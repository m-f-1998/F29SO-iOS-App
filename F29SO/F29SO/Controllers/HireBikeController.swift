//
//  HireBikeController.swift
//  F29SO
//
//  Created by Matthew on 30/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import Eureka
import PassKit
import Stripe
import KeychainAccess

enum STPBackendChargeResult{
    case Success, Failure
}

typealias STPTokenSubmissionHandler = (STPBackendChargeResult?, NSError?) -> Void

class HireBikeController: FormViewController, PKPaymentAuthorizationViewControllerDelegate {
    
    var selectedLocation = ""
    let backendBaseURL: String = "http://www.matthewfrankland.co.uk/pedalPay/applePay/index.php"
    let SupportedPaymentNetworks: [PKPaymentNetwork] = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    let applePaySwagMerchantID: String = "merchant.com.matthewfrankland.stripe"
    let stripePublishableKey = "pk_test_ZOXIw0ioiX2rDM0yyhAw4DJA"
    var totalPrice = 0.00
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {  // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        form +++
            
        //MARK: PRODUCT REQUIREMENTS FORM
            
        Section(header: "Product Requirements", footer: "")
        <<< TimeRow() {
            $0.title = "Time for Hiring:"
            $0.tag = "bookStart"
            $0.minimumDate = Date()
            $0.add(rule: RuleRequired())
        } <<< TimeRow() {
            $0.title = "Time for Return:"
            $0.tag = "bookEnd"
            $0.minimumDate = Calendar.autoupdatingCurrent.date(byAdding: .hour, value: +1, to: Date())
            $0.maximumDate = Calendar.autoupdatingCurrent.startOfDay(for: getTomorrowAt(hour: 0, minutes: 0))
            $0.add(rule: RuleRequired())
        } <<< ActionSheetRow<String>() {
            $0.title = "Bike Type"
            $0.selectorTitle = "Pick a Bike Type"
            $0.tag = "type"
            $0.options = ["Normal","Kids","Tandem"]
            $0.value = "None Selected"
            $0.add(rule: RuleRequired())
        } <<< MultipleSelectorRow<String>() {
            $0.title = "Accessories"
            $0.selectorTitle = "Pick any Additional Accessories"
            $0.tag = "accessories"
            $0.options = ["Bag","Bike Chain","Pump","Helmet"]
        } <<< ActionSheetRow<String>() {
            $0.title = "Bike Location"
            $0.tag = "location"
            $0.disabled = true
            $0.value = selectedLocation
        }
            
        //MARK: PAYMENT
        +++ Section(header: "Payment", footer: "Apple Pay Only. Other Payment Forms Accepted Online.")
        <<< ButtonRow(){
            $0.title = "Pay Now"
        }.onCellSelection { cell, row in
            let formvalues = self.form.values()
            let minutes = Calendar.current.dateComponents([.minute], from: (formvalues["bookStart"] as! Date), to: (formvalues["bookEnd"] as! Date)).minute
            var cost = NSDecimalNumber(value: Double(minutes!) * 0.04)
            var accessories = NSDecimalNumber(value: 0.00)

            if (formvalues["type"] as! String) != "Road" {
                cost = NSDecimalNumber(value: Double(truncating: cost) * Double(2))
            }
            if formvalues["accessories"] == nil {
                accessories = NSDecimalNumber(value: Double((formvalues["accessories"] as! Set<String>).count) * 0.02 * Double(minutes!))
            }
            
            let vat = NSDecimalNumber(value: (Double(truncating: cost) + Double(truncating: accessories)) * 0.2)
            let total = NSDecimalNumber(value: Double(truncating: cost) + Double(truncating: accessories) + Double(truncating: vat))
            let paymentItems: [PKPaymentSummaryItem] = [
                PKPaymentSummaryItem(label: (formvalues["type"] as! String) + " Bike Hire Cost", amount: cost),
                PKPaymentSummaryItem(label: "Accessories Hire Cost", amount: accessories),
                PKPaymentSummaryItem(label: "VAT", amount: vat),
                PKPaymentSummaryItem(label: "Pedal Pay Ltd.", amount: total)
            ]
            
            self.totalPrice = round(100*Double(truncating: total))/100
            self.validateInput(paymentItems: paymentItems)
        }
    }
        
    //MARK: - Stripe Payment Delegate
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping ((PKPaymentAuthorizationStatus) -> Void)) { // Process Booking On Stripe Delegate
        let apiClient = STPAPIClient(publishableKey: stripePublishableKey)
        apiClient.createToken(with: payment, completion: { (token, error) -> Void in
            if error == nil {
                if let token = token {
                    self.createBackendChargeWithToken(token, completion: { (result, error) -> Void in
                        if result == STPBackendChargeResult.Success {
                            completion(PKPaymentAuthorizationStatus.success)
                        }
                        else {
                            completion(PKPaymentAuthorizationStatus.failure)
                        }
                    })
                }
            }
            else {
                completion(PKPaymentAuthorizationStatus.failure)
            }
        })
    }
    
    func processBookings() { // Process Booking In Database
        let formvalues = self.form.values()
        let bookingsURL: String = "http://www.matthewfrankland.co.uk/pedalPay/userFunctions/makeBooking.php"
        do {
            let keychainPassword = try Keychain(service: Bundle.main.object(forInfoDictionaryKey: "KaychainGroup") as! String).synchronizable(true).get(UserDefaults.standard.string(forKey: "userDetails")!)
            sendRequest(bookingsURL, method: .post, parameters: ["email": UserDefaults.standard.string(forKey: "userDetails")!, "password": keychainPassword!, "bookStart": formvalues["bookStart"]!!, "bookEnd": formvalues["bookEnd"]!!, "hub": formvalues["location"] as! String, "city": "Edinburgh", "bikeType": formvalues["type"]!!], completionHandler: { (data, response, error) in
                guard let data = data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                    let returnMessage = json["message"] as! NSString
                    print(returnMessage)
                } catch let error as NSError {
                    self.alert(title: "Fatal Error In Booking", message: error.description, style: UIAlertController.Style.alert)
                }
            })?.resume()
        } catch {
            fatalError("Error fetching password items - \(error)")
        }
    }
    
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) { // Called After Every Dismiss Of Payment Controller
        processBookings()
        self.dismiss(animated: true, completion: nil)
    }
    
    func createBackendChargeWithToken(_ token: STPToken, completion: @escaping STPTokenSubmissionHandler) { // Create Backend Token For Stripe Transaction Processing
        if totalPrice != 0.00 {
            let price = NSDecimalNumber (string: String(totalPrice))
            if backendBaseURL != "" {
                if let url = URL(string: backendBaseURL) {
                    let session = URLSession(configuration: URLSessionConfiguration.default)
                    let request = NSMutableURLRequest(url: url)
                    request.httpMethod = "POST"
                    let postBody = "stripeToken=\(token.tokenId)&amount=\(price)"
                    let postData = postBody.data(using: String.Encoding.utf8, allowLossyConversion: false)
                    
                    session.uploadTask(with: request as URLRequest, from: postData, completionHandler: { data, response, error in
                        let successfulResponse = (response as? HTTPURLResponse)?.statusCode == 200
                        if successfulResponse && error == nil {
                            completion(.Success, nil)
                        } else {
                            if error != nil {
                                completion(.Failure, error! as NSError)
                            } else {
                                completion(.Failure, NSError(domain: StripeDomain, code: 50, userInfo: [NSLocalizedDescriptionKey: "There was an error communicating with your payment backend."]))
                            }
                        }
                    }).resume()
                    return
                }
            }
            completion(STPBackendChargeResult.Failure, NSError(domain: StripeDomain, code: 50, userInfo: [NSLocalizedDescriptionKey: "You created a token! Its value is \(token.tokenId). Now configure your backend to accept this token and complete a charge."]))
        }
    }
    
    //MARK: - Setup Functions

    private func validateInput(paymentItems: [PKPaymentSummaryItem]) { // Validate All Required Apple Pay Fields Are Given
        if self.form.validate() == [] {
            self.applePayRequest(paymentItems: paymentItems)
        } else {
            self.alert(title: "Error In Payment", message: "All Fields Are Required To Proceed", style: .alert)
        }
    }
    
    private func getTomorrowAt(hour: Int, minutes: Int) -> Date { // Get Set Time On The Following Dat
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
        return Calendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: tomorrow!)!
    }
    
    private func applePayRequest(paymentItems: [PKPaymentSummaryItem]) { // Construct PKPaymentController For Apple Pay Controller Presentation On Navigation Controller
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: SupportedPaymentNetworks){
            let request = Stripe.paymentRequest(withMerchantIdentifier: applePaySwagMerchantID, country: "GB", currency: "GBP")
            request.paymentSummaryItems = paymentItems
            request.requiredBillingContactFields = Set([PKContactField.postalAddress, PKContactField.name, PKContactField.emailAddress])
            request.merchantCapabilities = PKMerchantCapability.capability3DS
            request.supportedNetworks = SupportedPaymentNetworks
            
            if Stripe.canSubmitPaymentRequest(request) {
                let paymentController = PKPaymentAuthorizationViewController(paymentRequest: request)
                paymentController!.delegate = self
                self.present(paymentController!, animated: true, completion: nil)
            }
        }
    }
    
}
