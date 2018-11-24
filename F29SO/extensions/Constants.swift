//
//  Constants.swift
//  F29SO
//
//  Created by Matthew on 20/11/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import Foundation

struct Constants {
    // For tidier global calls
    static let loginURL: String = "http://www.matthewfrankland.co.uk/login/login.php"
    static let registerURL: String = "http://www.matthewfrankland.co.uk/login/register.php"
    static let locationsURL: String = "http://www.matthewfrankland.co.uk/login/locations.php"
    static let settingTitles: Array = ["Logged In: " + UserDefaults.standard.string(forKey: "userDetails")!, "Touch-ID", "Collection Notifications", "Go To Website", "Send App Feedback", "Privacy Policy", "Logout",  "Version Number 0.4 {3} - © Matthew Frankland 2018"]
}
