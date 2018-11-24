//
//  CollectBikeController.swift
//  F29SO
//
//  Created by Matthew on 29/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit
import CoreNFC

class CollectBikeController: UIViewController, NFCNDEFReaderSessionDelegate {
    
    private let mainLabel: UILabel = UILabel.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 300.0, height: 500.0))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupLabel()
        self.view.addSubview(mainLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //Start new threads that will take a long time to execute
        self.view.backgroundColor = .white
        setupLabel()
        let session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue(label: "queueName", attributes: .concurrent), invalidateAfterFirstRead: false)
        session.alertMessage = "Hold Near Scanner To Unlock Bike"
        session.begin()
    }
    
    private func setupLabel() {
        mainLabel.text = "Scanning For Bike...."
        mainLabel.textAlignment = .center
        mainLabel.numberOfLines = 10
        mainLabel.textColor = .black
        mainLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        mainLabel.center = self.view.center
    }
    
    //MARK: CoreNFC Delegate
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        DispatchQueue.main.async {
            self.mainLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            self.mainLabel.text = "Bike Unlock Failed\n\n " + error.localizedDescription
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                print(record.payload)
            }
        }
    }
    
}
