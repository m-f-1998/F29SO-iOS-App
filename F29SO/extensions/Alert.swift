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
        // Generic alert for the user - customisable from the controller view only
        DispatchQueue.main.async {
            let alert: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: style)
            for i in 0...actions.count-1 { alert.addAction(actions[i]) }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func activityIndicatorAlert() {
        let alert = UIAlertController(title: "Updating App Data", message: "Please Wait...", preferredStyle: .alert)
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10,y: 5,width: 50, height: 50)) as UIActivityIndicatorView

        DispatchQueue.main.async {
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.gray
            loadingIndicator.startAnimating();
            
            alert.view.tintColor = UIColor.black
            alert.view.addSubview(loadingIndicator)
            self.present(alert, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
}
