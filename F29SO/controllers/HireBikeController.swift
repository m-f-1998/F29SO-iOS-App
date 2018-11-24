//
//  HireBikeController.swift
//  F29SO
//
//  Created by Matthew on 30/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import Eureka
import PassKit

class HireBikeController: FormViewController, PKPaymentAuthorizationViewControllerDelegate {
    
    private let request = PKPaymentRequest.init()
    var selectedLocation = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        form +++
        
        //MARK: PERSONAL DETAILS
        Section(header: "Personal Details", footer: "Please Enter Your Full Name As Appears On Your Payment Card.")
        <<< NameRow() {
            $0.title = "Forename(s):"
            $0.placeholder = "Required"
            $0.add(rule: RuleRequired())
        }.cellSetup { cell, row in
            cell.imageView?.image = UIImage(named: "plus_image")
        } <<< NameRow() {
            $0.title = "Surname:"
            $0.placeholder = "Required"
            $0.add(rule: RuleRequired())
        }.cellSetup { cell, row in
            cell.imageView?.image = UIImage(named: "plus_image")
        } <<< DateRow() {
            $0.title = "Date of Birth:"
            $0.value = Date(timeIntervalSinceReferenceDate: 0)
            $0.add(rule: RuleRequired())
        }
            
        //MARK: ADDRESS DETAILS
        +++ Section(header: "Address", footer: "Please Enter Your Address As Per Invoiced Customer")
        <<< NameRow() {
            $0.title = "Line 1:"
            $0.placeholder = "Required"
            $0.add(rule: RuleRequired())
        }.cellSetup { cell, row in
            cell.imageView?.image = UIImage(named: "plus_image")
        } <<< NameRow() {
            $0.title = "Line 2:"
            $0.placeholder = "Required"
            $0.add(rule: RuleRequired())
        }.cellSetup { cell, row in
            cell.imageView?.image = UIImage(named: "plus_image")
        } <<< NameRow() {
            $0.title = "Town:"
            $0.placeholder = "Required"
            $0.add(rule: RuleRequired())
        }.cellSetup { cell, row in
            cell.imageView?.image = UIImage(named: "plus_image")
        } <<< NameRow() {
            $0.title = "Postcode:"
            $0.placeholder = "Required"
            $0.add(rule: RuleRequired())
        }.cellSetup { cell, row in
            cell.imageView?.image = UIImage(named: "plus_image")
        }
            
        //MARK: PRODUCT REQUIREMENTS
        +++ Section(header: "Product Requirements", footer: "")
        <<< TimeRow() {
            $0.title = "Time for Hiring:"
            $0.value = Date(timeIntervalSinceReferenceDate: 0)
            $0.add(rule: RuleRequired())
        } <<< ActionSheetRow<String>() {
            $0.title = "Bike Type"
            $0.selectorTitle = "Pick a Bike Type"
            $0.options = ["Road","Mountain","Some Other Type"]
            $0.value = "None Selected"
            $0.add(rule: RuleRequired())
        } <<< MultipleSelectorRow<String>() {
            $0.title = "Accessories"
            $0.selectorTitle = "Pick any Additional Accessories"
            $0.options = ["Helmet","Camera","None"]
            $0.add(rule: RuleRequired())
        } <<< ActionSheetRow<String>() {
            $0.title = "Bike Location"
            $0.disabled = true
            $0.value = selectedLocation
        }
            
        //MARK: PAYMENT
        +++ Section(header: "Payment", footer: "Apple Pay Only. Other Payment Forms Accepted Online.")
        <<< ButtonRow(){
            $0.title = "Pay Now"
        }.onCellSelection { cell, row in
            let paymentItems: [PKPaymentSummaryItem] = [
                PKPaymentSummaryItem(label: "1 Hour Hire", amount: 10000.21),
                PKPaymentSummaryItem(label: "VAT", amount: 2000.04),
                PKPaymentSummaryItem(label: "Generic Software Company Ltd.", amount: 10000.21)
            ]
            self.validateInput(paymentItems: paymentItems)
        }
    }
        
    //MARK: ApplePay
    func applePayRequest(paymentItems: [PKPaymentSummaryItem]) {
        let SupportedPaymentNetworks: [PKPaymentNetwork] = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
        let ApplePaySwagMerchantID: String = "merchant.com.matthewfrankland"
            
        request.merchantIdentifier = ApplePaySwagMerchantID
        request.supportedNetworks = SupportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "GB"
        request.currencyCode = "GBP"
        request.paymentSummaryItems = paymentItems
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Validation
    func validateInput(paymentItems: [PKPaymentSummaryItem]) {
        print(self.form.validate())
        if self.form.validate() == [] {
            self.applePayRequest(paymentItems: paymentItems)
            let paymentController = PKPaymentAuthorizationViewController.init(paymentRequest: self.request)!
            paymentController.delegate = self
            self.present(paymentController, animated: true, completion: nil)
        } else {
            self.alert(title: "Error In Payment", message: "All Fields Are Required To Proceed", actions:  [UIAlertAction.init(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil)], style: .alert)
        }
    }
}
