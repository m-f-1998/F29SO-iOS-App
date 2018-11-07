//
//  HireBikeController.swift
//  F29SO
//
//  Created by Matthew on 30/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit
import Eureka
import PassKit

class HireBikeController: FormViewController {
    
    func applePayCalled() {
        let request = PKPaymentRequest()
        
        let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
        let ApplePaySwagMerchantID = "merchant.com.matthewfrankland"
        
        request.merchantIdentifier = ApplePaySwagMerchantID
        request.supportedNetworks = SupportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "GB"
        request.currencyCode = "GBP"
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Swag", amount: 10000.21),
            PKPaymentSummaryItem(label: "VAT", amount: 2000.04),
            PKPaymentSummaryItem(label: "Matthew Frankland", amount: 10000.21)
        ]
        
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        self.present(applePayController!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++
            Section(header: "Personal Details", footer: "Please Enter Your Full Name As Appears On Your Payment Card. Your Reservation Code Will Be E-Mailed By Default To Your Account E-Mail.")
            
            <<< NameRow() {
                $0.title = "Forename(s):"
                $0.placeholder = "Required"
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
            }
            
             +++ Section(header: "Address", footer: "Please Enter Your Address As Per Customer Who Will Be Invoiced For Product.")
            
            <<< NameRow() {
                $0.title = "Line 1:"
                $0.placeholder = "Required"
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
            }
            
            <<< NameRow() {
                $0.title = "Line 2:"
                $0.placeholder = "Required"
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
            }
            
            <<< NameRow() {
                $0.title = "Town:"
                $0.placeholder = "Required"
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
            }
            
            <<< NameRow() {
                $0.title = "Postcode:"
                $0.placeholder = "Required"
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
            }
        
            +++ Section(header: "Payment", footer: "Apple Pay Only. Other Payment Forms Accepted Online.")
            
            <<< ButtonRow(){
                
                $0.title = "Pay Now"
                }
                .onCellSelection { cell, row in
                    self.applePayCalled()
                
        }
    }
}
