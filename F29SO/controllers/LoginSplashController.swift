//
//  LoginSplashController.swift
//  F29SO
//
//  Created by Matthew on 27/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit.UIViewController
import KeychainAccess

class LoginSplashController: LFLoginController, LFLoginControllerDelegate {
    
    var firstSet: Bool = false
    var checked: Bool!
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() { // Do any additional setup after loading the view, typically from a nib.
        delegate = self
        checked = false
    }
    
    override func viewDidAppear(_ animated: Bool) { // Start new threads that will take a long time to execute
        super.viewDidAppear(true)
        if firstSet == false {
            firstSet = true
            updateUserInterface()
            NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        }
    }
    
    //MARK: - LogIn Delegate
    
    func loginDidFinish(email: String, password: String, type: LFLoginController.SendType) { // Login : Register Option Called
        let loginURL: String = "http://www.matthewfrankland.co.uk/pedalPay/login/login.php"
        let registerURL: String = "http://www.matthewfrankland.co.uk/pedalPay/login/register.php"
        if !email.isEmpty && !password.isEmpty {
            let url = type == .Login ? loginURL : registerURL; UserDefaults.standard.set(false, forKey: "biometricsEnabled")
            sendRequest(url, method: .post, parameters: ["email": email, "password": password], completionHandler: { (data, response, error) in
                guard let data = data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                    DispatchQueue.main.async {
                        if json["error"] as! Bool {
                            self.alert(title: json["message"] as! String, message: "Please Try Again", style: .alert)
                        } else {
                            var user: String = json["message"] as! String
                            if String(user.suffix(10)) == "Admin User" {
                                user = String(user[..<user.index(user.endIndex, offsetBy: -13)])
                            }
                            UserDefaults.standard.setValue(user, forKey: "userDetails")
                            do {
                                try Keychain(service: Bundle.main.object(forInfoDictionaryKey: "KaychainGroup") as! String).synchronizable(true).set(password, key: user)
                            } catch {
                                fatalError("Error updating keychain - \(error)")
                            }
                            
                            self.rootContTransition(rVC: TabBarController(), navBarTitle: "Hire A Bike")
                        }
                    }
                } catch let error as NSError {
                    DispatchQueue.main.async {
                        self.alert(title: "Fatal Error In Login", message: error.description, style: .alert)
                    }
                }
            })?.resume()
        }
    }
    
    func forgotPasswordTapped(email: String) {
        let resetURL: String = "http://www.matthewfrankland.co.uk/pedalPay/login/resetPass.php"
        if !email.isEmpty {
            sendRequest(resetURL, method: .post, parameters: ["email": email], completionHandler: { (data, response, error) in
                guard let data = data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                    DispatchQueue.main.async {
                        if json["error"] as! Bool {
                            self.alert(title: json["message"] as! String, message: "Please Try Again", style: .alert)
                        } else {
                            self.alert(title: "Password Request Acknowledged", message: "E-Mail Sent If Account Exists", style: .alert)
                        }
                    }
                } catch let error as NSError {
                    DispatchQueue.main.async {
                        self.alert(title: "Fatal Error In Login", message: error.description, style: .alert)
                    }
                }
            })?.resume()
        } else {
            self.alert(title: "No E-Mail Given", message: "Fill E-Mail Field Prior To Password Reset Request", style: .alert)
        }
    }
    
    //MARK: - Helper Functions
    
    func updateUserInterface() { // Update User Controller If Network Status Changes
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            DispatchQueue.main.async {
                let controller = NoConnection()
                UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.7, options: .transitionCrossDissolve, animations: {
                    controller.setNeedsStatusBarAppearanceUpdate()
                    UIApplication.shared.keyWindow?.rootViewController = controller
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()
                }, completion: nil)
                }
        case .wifi:
            if UserDefaults.standard.bool(forKey: "biometricsEnabled") && UserDefaults.standard.string(forKey: "userDetails") != nil && !checked {
                self.authenticationWithBiometrics()
                checked = true
            }
        case .wwan:
            if UserDefaults.standard.bool(forKey: "biometricsEnabled") && UserDefaults.standard.string(forKey: "userDetails") != nil && !checked {
                self.authenticationWithBiometrics()
                checked = true
            }
        }
    }
    
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }

}

