//
//  TabBarController.swift
//  F29SO
//
//  Created by Matthew on 29/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit.UITabBarController

class TabBarController: UITabBarController, UITabBarControllerDelegate  {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() { // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
    }
    
    //MARK: - TableView Delegate
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) { // Add Tab Bar To Global Controller
        switch item.tag {
            case 0:
                self.navigationController?.navigationBar.topItem?.title = "Hire A Bike"
            case 1:
                self.navigationController?.navigationBar.topItem?.title = "Collect A Reservation"
            case 2:
                self.navigationController?.navigationBar.topItem?.title = "Settings"
            default:
                NSLog("Tab Bar Controller Not Recognised - Can't Sent Title")
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
            break
        case .wwan:
            break
        }
    }
    
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
}
