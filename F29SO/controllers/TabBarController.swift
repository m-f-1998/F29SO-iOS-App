//
//  TabBarController.swift
//  F29SO
//
//  Created by Matthew on 29/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate  {
        
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        switch item.tag {
            case 0:
                self.navigationController?.navigationBar.topItem?.title = "Hire A Bike"
            case 1:
                self.navigationController?.navigationBar.topItem?.title = "Collect A Reservation"
            case 2:
                self.navigationController?.navigationBar.topItem?.title = "Settings"
            default:
                print("Default Nav Controller Item Called")
        }
    }
    
}
