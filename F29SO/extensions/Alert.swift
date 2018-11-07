//
//  Alert.swift
//  F29SO
//
//  Created by Matthew on 02/11/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit

extension UIViewController {

    func alert(title: String, message: String, actions: [UIAlertAction], style: UIAlertController.Style) {
        DispatchQueue.main.async {
            
            let alert: UIAlertController = UIAlertController.init(
                title: title,
                message: message,
                preferredStyle: style)
            
            for i in 0...actions.count { alert.addAction(actions[i]) }
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}
