//
//  TabBarController.swift
//  F29SO
//
//  Created by Matthew on 29/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit.UITabBarController

class TabBarController: UITabBarController, UITabBarControllerDelegate  {
    
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
    
}
