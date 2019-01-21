//
//  Alert.swift
//  F29SO
//
//  Created by Matthew on 02/11/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit.UIViewController

extension UIViewController {

    func alert(title: String, message: String, style: UIAlertController.Style) { // Generic Alert For The User
        DispatchQueue.main.async { // Present On Main Thread In-Case Of Async Call
            let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: style)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            UIView.animate(withDuration: 1.0, animations: {
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
        
    private func setupIndicator(indicator: UIActivityIndicatorView) -> UIActivityIndicatorView {
        indicator.hidesWhenStopped = true
        indicator.style = .gray
        indicator.startAnimating()
        return indicator
    }
    
}
