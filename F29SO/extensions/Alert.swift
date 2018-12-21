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
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        DispatchQueue.main.async { // Present On Main Thread In-Case Of Async Call
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func activityIndicatorAlert(title: String, message: String, style: UIAlertController.Style) { // Add Activity Indidicator To Show Processing
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10,y: 5,width: 50, height: 50))
        
        DispatchQueue.main.async { // Present On Main Thread In-Case Of Async Call
            alert.view.addSubview(self.setupIndicator(indicator: loadingIndicator))
            self.present(alert, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // Asynchronous Dismissal After 3 Seconds
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupIndicator(indicator: UIActivityIndicatorView) -> UIActivityIndicatorView {
        indicator.hidesWhenStopped = true
        indicator.style = .gray
        indicator.startAnimating()
        return indicator
    }
    
}
