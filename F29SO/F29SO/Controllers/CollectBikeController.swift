//
//  CollectBikeController.swift
//  F29SO
//
//  Created by Matthew on 29/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit.UIViewController
import CoreNFC
import KeychainAccess

class CollectBikeController: UIViewController, NFCNDEFReaderSessionDelegate {
    
    private let mainLabel: UILabel = UILabel.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 300.0, height: 500.0))
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() { // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(mainLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) { //Start new threads that will take a long time to execute
        super.viewDidAppear(true)
        setupLabel()
        setupSession(queueName: "unlock", invalidateAfterFirst: true, attribute: .concurrent, alertMessage: "Hold Near Scanner to Unlock Bike")
    }
    
    //MARK: - Setup Functions
    
    private func setupSession(queueName: String, invalidateAfterFirst: Bool, attribute: DispatchQueue.Attributes, alertMessage: String) {
        let session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue(label: queueName, attributes: attribute), invalidateAfterFirstRead: invalidateAfterFirst)
        session.alertMessage = alertMessage
        session.begin()
    }
    
    private func setupLabel() { // Setup User Notification Label
        mainLabel.text = "Scanning For Bike...."
        mainLabel.textAlignment = .center
        mainLabel.numberOfLines = 10
        mainLabel.textColor = .black
        mainLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        mainLabel.center = self.view.center
    }
    
    //MARK: - CoreNFC Delegate
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) { // Print Error To User If NFC Fails
        DispatchQueue.main.async {
            self.mainLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            self.mainLabel.text = "Bike Unlock Failed:\n " + error.localizedDescription + "\n\nPlease Use Code Sent In Confirmation E-Mail"
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var result = ""
        for payload in messages[0].records {
            result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8)! // 1
        }
        let unlockURL: String = "http://www.matthewfrankland.co.uk/pedalPay/userFunctions/unlock.php" // Compare Booking With NFC Tag At Station and Give Unlock Code If True
        do {
            let password = try Keychain(service:Bundle.main.object(forInfoDictionaryKey: "KaychainGroup") as! String).synchronizable(true).get(UserDefaults.standard.string(forKey: "userDetails")!)
            sendRequest(unlockURL, method: .post, parameters: ["email": UserDefaults.standard.string(forKey: "userDetails")!, "password": password!, "bikeStand": result], completionHandler: { (data, response, error) in
                guard let data = data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                    if json["error"] as! Bool {
                        DispatchQueue.main.async {
                            self.mainLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                            self.mainLabel.text = "No Booking Found\nBookings Can Only Be Collected Up To 10 Minutes Prior To Booking Time - Please Check Confirmation Email"
                        }
                    } else {
                        let unlockCode = json["message"] as! String
                        DispatchQueue.main.async {
                            self.mainLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                            self.mainLabel.text = "Bike Unlock Code:\n " + unlockCode
                        }
                    }
                } catch let error as NSError {
                    DispatchQueue.main.async {
                        self.mainLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                        self.mainLabel.text = "Fatal Error In Retrieving Booking Code:\n " + error.description
                    }
                }
            })?.resume()
        } catch {
            fatalError("Error fetching password items - \(error)")
        }
    }
    
}
