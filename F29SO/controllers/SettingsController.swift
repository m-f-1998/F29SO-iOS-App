//
//  SettingsController.swift
//  F29SO
//
//  Created by Matthew on 29/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    
    private let titles: Array = [
        ("Logged In: " + UserDefaults.standard.string(forKey: "userDetails")!),
        "Touch-ID",
        "Collection Notifications",
        "Go To Website",
        "Send App Feedback",
        "Privacy Policy",
        "Logout",
        "Version Number 0.4 {3} - © Matthew Frankland 2018"
    ]
    private var access = [nil, UISwitch(), UISwitch(), nil, nil, nil, nil, nil, nil]
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        access[0]?.isOn = UserDefaults.standard.bool(forKey: "touchIDEnabled")
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(String(describing: titles[indexPath.row]))")
        if titles[indexPath.row] == "Logout" {
            logout()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    @objc func touchID() {
        
        if (access[0]?.isOn)! {
            UserDefaults.standard.set(true, forKey: "touchIDEnabled")
        } else {
            UserDefaults.standard.set(false, forKey: "touchIDEnabled")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 7 {
            return 50.0
        }
        return 65.0
    }
    
    private func logout() {
        let loginController : LoginSplashController = LoginSplashController() as LoginSplashController
        loginController.videoURL = URL(fileURLWithPath: Bundle.main.path(forResource: "edinburgh_ariel", ofType: "mp4")!)
        UIApplication.shared.keyWindow!.rootViewController = loginController
        UIApplication.shared.keyWindow!.makeKeyAndVisible()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(String(describing: titles[indexPath.row]))"
        cell.accessoryView = access[indexPath.row]
        access[0]?.addTarget(self, action: #selector(touchID), for: .valueChanged)
        
        if indexPath.row == 0 {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 16.0)
            cell.isUserInteractionEnabled = false
        }
        
        if indexPath.row == 1 || indexPath.row == 2 {
            cell.selectionStyle = .none
        }
        
        if indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .blue
        }
        
        if indexPath.row == 6 {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .red
        }
        
        if indexPath.row == 7 {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 12.0)
            cell.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
}
