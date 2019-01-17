//
//  NoConnection.swift
//  F29SO
//
//  Created by Matthew on 17/01/2019.
//  Copyright © 2019 Matthew Frankland. All rights reserved.
//

import UIKit.UIViewController

class NoConnection: UIViewController {
    
    private let mainLabel: UILabel = UILabel.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 300.0, height: 500.0))
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() { // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(mainLabel)
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
    }
    
    override func viewDidAppear(_ animated: Bool) { //Start new threads that will take a long time to execute
        super.viewDidAppear(true)
        setupLabel()
    }
    
    //MARK: - Setup Functions
    
    private func setupLabel() { // Setup Notification Label
        mainLabel.text = "Internet Connection Required"
        mainLabel.textAlignment = .center
        mainLabel.numberOfLines = 10
        mainLabel.textColor = .black
        mainLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        mainLabel.center = self.view.center
    }
    
    //MARK: - Helper Functions
    
    func updateUserInterface() { // Update User Controller If Network Status Changes
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            break
        case .wifi:
            DispatchQueue.main.async {
                let controller = LoginSplashController()
                controller.videoURL = URL(fileURLWithPath: Bundle.main.path(forResource: "edinburgh_ariel", ofType: "mp4")!)
                UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.7, options: .transitionCrossDissolve, animations: {
                    controller.setNeedsStatusBarAppearanceUpdate()
                    UIApplication.shared.keyWindow?.rootViewController = controller
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()
                }, completion: nil)
            }
        case .wwan:
            DispatchQueue.main.async {
                let controller = LoginSplashController()
                controller.videoURL = URL(fileURLWithPath: Bundle.main.path(forResource: "edinburgh_ariel", ofType: "mp4")!)
                UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.7, options: .transitionCrossDissolve, animations: {
                    controller.setNeedsStatusBarAppearanceUpdate()
                    UIApplication.shared.keyWindow?.rootViewController = controller
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()
                }, completion: nil)
            }
        }
    }
    
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }

}
