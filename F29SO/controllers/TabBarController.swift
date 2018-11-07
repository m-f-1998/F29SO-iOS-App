//
//  TabBarController.swift
//  F29SO
//
//  Created by Matthew on 29/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit
import CoreNFC

class TabBarController: UITabBarController, UITabBarControllerDelegate  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //placehodler
        if item.tag == 0 {
            self.navigationController?.navigationBar.topItem?.title = "Hire A Bike"
        } else if item.tag == 1 {
            self.navigationController?.navigationBar.topItem?.title = "Collect A Reservation"
        } else if item.tag == 2 {
            self.navigationController?.navigationBar.topItem?.title = "Settings"
        }
    }
    
}
