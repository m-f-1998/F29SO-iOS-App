//
//  LoginSplashController.swift
//  F29SO
//
//  Created by Matthew on 27/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit.UIViewController

class LoginSplashController: LFLoginController, LFLoginControllerDelegate {
    
    override func viewDidLoad() { // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        delegate = self
        videoURL = URL(fileURLWithPath: Bundle.main.path(forResource: "edinburgh_ariel", ofType: "mp4")!)
    }
    
    override func viewDidAppear(_ animated: Bool) { // Start new threads that will take a long time to execute
        super.viewDidAppear(true)
        if UserDefaults.standard.bool(forKey: "biometricsEnabled") && UserDefaults.standard.string(forKey: "userDetails") != nil {
            self.authenticationWithBiometrics()
        }
    }
    
    //MARK: - LogIn Delegate
    
    func loginDidFinish(email: String, password: String, type: LFLoginController.SendType) { // Login : Register Option Called
        if !email.isEmpty && !password.isEmpty {
            let url = type == .Login ? OutputURL.loginURL : OutputURL.registerURL; UserDefaults.standard.set(false, forKey: "biometricsEnabled")
            sendRequest(url, method: .post, parameters: ["email": email, "password": password], completionHandler: { (data, response, error) in
                guard let data = data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                    if json["error"] as! Bool {
                        self.alert(title: json["message"] as! String, message: "Please Try Again", style: UIAlertController.Style.alert)
                    } else {
                        UserDefaults.standard.setValue(json["message"], forKey: "userDetails")
                        self.rootContTransition(rVC: TabBarController(), navBarTitle: "Hire A Bike")
                    }
                } catch let error as NSError {
                    self.alert(title: "Fatal Error In Login", message: error.description, style: UIAlertController.Style.alert)
                }
            })?.resume()
        }
    }
    
    func forgotPasswordTapped(email: String) {
        print(email)
    }

}

