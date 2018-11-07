//
//  LoginSplashController.swift
//  F29SO
//
//  Created by Matthew on 27/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit

class LoginSplashController: LFLoginController, LFLoginControllerDelegate {
    
    private let loginURL: URL = URL(string: "http://www.matthewfrankland.co.uk/login/login.php")!
    private let registerURL: URL = URL(string: "http://www.matthewfrankland.co.uk/login/register.php")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.delegate = self
        self.videoURL = URL(fileURLWithPath: Bundle.main.path(forResource: "edinburgh_ariel", ofType: "mp4")!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if UserDefaults.standard.bool(forKey: "touchIDEnabled") {
            self.authenticationWithTouchID()
        }
    }
    
    private func getPostString(params:[String:Any]) -> String {
        var data = [String]()
        for(key, value) in params {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    //MARK: LogIn Delegate
    
    func loginDidFinish(email: String, password: String, type: LFLoginController.SendType) {
        let params: [String: Any] = ["email": email, "password": password]
        let actions: [UIAlertAction] = [UIAlertAction.init(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil)]
        var request: URLRequest
        
        if (!email.isEmpty && !password.isEmpty) {
            
            if type == .Login {
                request = URLRequest(url: loginURL) } else { request = URLRequest(url: registerURL); UserDefaults.standard.set(false, forKey: "touchIDEnabled")
            }
            request.httpMethod = "POST"
            request.httpBody = getPostString(params: params).data(using: .utf8)
            URLSession.shared.getAllTasks { (openTasks: [URLSessionTask]) in NSLog("open tasks: \(openTasks)")}
            
            _ = URLSession.shared.dataTask(with: request) {(data, response, error) in
                guard let data = data else { return }
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    
                    if (json["error"] as! Bool == false) {
                        UserDefaults.standard.setValue(json["message"], forKey: "userDetails")
                        self.rootContTransition(rootCont: TabBarController(), navBarTitle: "Hire a Bike")
                    } else { self.alert(title: json["message"] as! String, message: "Please Try Again", actions: actions, style: UIAlertController.Style.alert)
                    }

                } catch let error as NSError {
                    
                    self.alert(title: "Fatal Error In Login", message: error.description, actions: actions, style: UIAlertController.Style.alert)
                    print(error.debugDescription)
                    
                }
            }.resume();
        }
    }
    
    func forgotPasswordTapped(email: String) {
        //Placeholder
        print(email)
    }

}

