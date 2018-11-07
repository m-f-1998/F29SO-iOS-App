//
//  ViewControllerExtensions.swift
//  F29SO
//
//  Created by Matthew on 29/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit
import LocalAuthentication

extension UIViewController {
    
    func authenticationWithTouchID() {
        let localAuthenticationContext: LAContext = LAContext()
        let actions: [UIAlertAction] = [UIAlertAction.init(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil)]
        var authError: NSError?
        let reasonString = "To access the secure data"
        
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    
                    if UserDefaults.standard.string(forKey: "userDetails") != nil {
                        
                        self.rootContTransition(rootCont: TabBarController(), navBarTitle: "Hire a Bike")
                        
                    } else {
                        
                        self.alert(title: "User Not Known", message: "Log In Manually", actions: actions, style: UIAlertController.Style.alert)
                        
                    }
                    
                } else {
                    guard let error = evaluateError else {
                        return
                    }
                    
                    self.alert(title: "Authentication Failure", message: self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code), actions: actions, style: UIAlertController.Style.alert)
                    UserDefaults.standard.set(nil, forKey: "userDetails")

                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }

            self.alert(title: "Authentication Failure", message: self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code), actions: actions, style: UIAlertController.Style.alert)

        }
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
                case Int(kLAErrorBiometryNotAvailable): message = "Authentication could not start because the device does not support biometric authentication."
                
                case Int(kLAErrorBiometryLockout): message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
                case Int(kLAErrorBiometryNotEnrolled): message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
                default: message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
                case Int(kLAErrorTouchIDLockout): message = "Too many failed attempts."
                
                case Int(kLAErrorTouchIDNotAvailable): message = "TouchID is not available on the device"
                
                case Int(kLAErrorTouchIDNotEnrolled): message = "TouchID is not enrolled on the device"
                
                default: message = "Did not find error code on LAError object"
            }
        }
        
        return message
        
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            case Int(kLAErrorAuthenticationFailed): message = "User failed to provide valid credentials"
            
            case Int(kLAErrorAppCancel): message = "Authentication was cancelled by application"
            
            case Int(kLAErrorInvalidContext): message = "The context is invalid"
            
            case Int(kLAErrorNotInteractive): message = "Not interactive"
            
            case Int(kLAErrorPasscodeNotSet): message = "Passcode is not set on the device"
            
            case Int(kLAErrorSystemCancel): message = "Authentication was cancelled by the system"
            
            case Int(kLAErrorUserCancel): message = "User did cancel"
            
            case Int(kLAErrorUserFallback): message = "User chose to use the fallback"
            
            default: message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
        
    }
}
