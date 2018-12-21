//
//  Biometrics.swift
//  F29SO
//
//  Created by Matthew on 29/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit.UIViewController
import LocalAuthentication

extension UIViewController {
    
    func authenticationWithBiometrics() { // Main Biometric Authentication Method
        let localAuthenticationContext: LAContext = LAContext()
        let reasonString: String = "Using Biomaterics To Unlock Application To Protect User Details"
        var authError: NSError?
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonString) {
                success, evaluateError in
                    if success { // User authenticated successfully, take appropriate action
                        self.rootContTransition(rVC: TabBarController(), navBarTitle: "Hire a Bike")
                    } else { // User did not authenticate successfully, look at error and take appropriate action
                        guard let error: Error = evaluateError else { return }
                        self.logError(error_code: error._code, alert: false)
                    }
            }
        } else { // Show appropriate alert if biometry is lockout or not enrolled
            guard let error: Error = authError else { return }
            logError(error_code: error._code, alert: true)
        }
    }
    
    func logError(error_code: Int, alert: Bool) { // System For Logging When Error Occurs
        let evaluateError: String = "Authentication Could Not Continue Because " + self.evaluateAuthenticationPolicyMessageForLA(errorCode: error_code)
        NSLog(evaluateError)
        if alert { self.alert(title: "Authentication Failure", message: evaluateError, style: UIAlertController.Style.alert) }
    }
    
    // MARK: - Error Codes
    // Error Codes Dcoumentation: https://developer.apple.com/documentation/localauthentication/laerror/code
    
    private func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message: String = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
                case Int(kLAErrorBiometryNotAvailable): message = "This Device Does Not Support Biometric Authentication."
                case Int(kLAErrorBiometryLockout): message = "This User Has Been Locked Out Due To Failing Authentication Too Many Times."
                case Int(kLAErrorBiometryNotEnrolled): message = "This User Has Not Enrolled In Biometric Authentication."
            default: message = "Of Unkown Error /*sys_id=>#11.0*/."
            }
        } else {
            switch errorCode {
                case Int(kLAErrorTouchIDLockout): message = "Too Many Failed Attempts."
                case Int(kLAErrorTouchIDNotAvailable): message = "TouchID Is Not Available On The Device."
                case Int(kLAErrorTouchIDNotEnrolled): message = "TouchID Is Not Enrolled On The Device."
                default: message = "Of Unkown Error /*sys_id<#11.0*/."
            }
        }
        return message
    }
    
    private func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        var message: String = ""
        switch errorCode {
            case Int(kLAErrorAuthenticationFailed): message = "User Failed To Provide Valid Credentials."
            case Int(kLAErrorAppCancel): message = "Authentication Was Cancelled By Application."
            case Int(kLAErrorInvalidContext): message = "The Context Is Invalid."
            case Int(kLAErrorNotInteractive): message = "Not Interactive."
            case Int(kLAErrorPasscodeNotSet): message = "Passcode Is Not Set On The Device."
            case Int(kLAErrorSystemCancel): message = "Authentication Was Cancelled By The System."
            case Int(kLAErrorUserCancel): message = "User Did Cancel."
            case Int(kLAErrorUserFallback): message = "User Chose To Use The Fallback."
            default: message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        return message
    }
    
}
