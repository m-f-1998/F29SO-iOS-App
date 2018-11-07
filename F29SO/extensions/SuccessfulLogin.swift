//
//  SuccessfulLogin.swift
//  F29SO
//
//  Created by Matthew on 02/11/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit

extension UIViewController {

    func tabBarItems(title: [String], image: [UIImage]) -> [UITabBarItem] {
        var tabBarItems: [UITabBarItem] = []
        
        if title.count == image.count {
            for i in 0...title.count-1 {
                tabBarItems.append(
                    UITabBarItem.init(title: title[i], image: image[i], tag: i))
            }
            
            tabBarItems.append(
                UITabBarItem.init(tabBarSystemItem: UITabBarItem.SystemItem.more, tag: title.count))
        }
        
        return tabBarItems
    }
    
    
    func rootContTransition(rootCont: UITabBarController, navBarTitle: String) {
        DispatchQueue.main.async {
            
            let tabControllers: Array = [MainMapController(), CollectBikeController(), SettingsController()]
            let tabBarItems: [UITabBarItem] = self.tabBarItems(
                title: ["Hire", "Collect"],
                image: [UIImage.init(named: "bike_logo")!, UIImage.init(named: "hire_logo")!])
            
            for i in 0...tabBarItems.count-1 { tabControllers[i].tabBarItem = tabBarItems[i] }
            rootCont.viewControllers = tabControllers
            rootCont.selectedViewController = rootCont.viewControllers![0]
            
            let nvC: UINavigationController = UINavigationController.init(rootViewController: rootCont)
            nvC.navigationBar.topItem?.title = navBarTitle
            
            UIApplication.shared.keyWindow?.rootViewController = nvC
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
            
        }
    }
    
}
