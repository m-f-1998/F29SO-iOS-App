//
//  TabBars.swift
//  F29SO
//
//  Created by Matthew on 02/11/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit.UIViewController
import Eureka

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if topViewController is FormViewController {
            return .lightContent
        }
        return topViewController?.preferredStatusBarStyle ?? .lightContent
    }
}

extension UIImagePickerController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}

extension UIViewController {

    func generateTabBar(title: [String], image: [UIImage]) -> [UITabBarItem] { // Generate Items for Global Tab Bar
        var tabBarItems: [UITabBarItem] = []
        
        if title.count == image.count {
            for i in 0...title.count-1 {
                tabBarItems.append(UITabBarItem(title: title[i], image: image[i], tag: i))
            }
            tabBarItems.append(UITabBarItem(tabBarSystemItem: .more, tag: title.count)) // Add More Tab For Settings Table
        }
        
        return tabBarItems
    }
    
    func rootContTransition(rVC: UITabBarController, navBarTitle: String) { // Move To Main Menu from Login
        DispatchQueue.main.async {
            let nvC: UINavigationController = UINavigationController(rootViewController: rVC)
            self.setupTabs(rVC: rVC)
            self.setupNavCont(nvCont: nvC, title: navBarTitle)
            
            UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.4, options: .transitionCrossDissolve, animations: { // Dissolve Transition Is More Fluid
                rVC.setNeedsStatusBarAppearanceUpdate()
                UIApplication.shared.keyWindow?.rootViewController = nvC
                UIApplication.shared.keyWindow?.makeKeyAndVisible()
            }, completion: nil)
        }
    }
    
    private func setupNavCont(nvCont: UINavigationController, title: String) { // Main Nav Cont Before Transition - Global For Tabs
        nvCont.navigationBar.topItem?.title = title
        nvCont.navigationBar.barTintColor = .black
        nvCont.navigationBar.tintColor = .white
        nvCont.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setupTabs(rVC: UITabBarController) { // Setup Tabs Visually And With Transitions
        let tabControllers: Array = [MainMapController(), CollectBikeController(), SettingsController()]
        let tabBarItems: [UITabBarItem] = self.generateTabBar(
            title: ["Hire", "Collect"],
            image: [UIImage.init(named: "bike_logo")!, UIImage(named: "hire_logo")!]
        )
        for i in 0...tabBarItems.count-1 {
            tabControllers[i].tabBarItem = tabBarItems[i]
        }
        rVC.viewControllers = tabControllers
        rVC.selectedViewController = rVC.viewControllers![0]
    }
    
}
