//
//  SettingsController.swift
//  F29SO
//
//  Created by Matthew on 29/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    
    let touchIDSwitch = UISwitch()
    let notificationSwitch = UISwitch()
    
    override func viewDidLoad() { // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableViewSetup()
    }
    
    //MARK: TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Constants.settingTitles[indexPath.row] {
            case "Go To Website":
                // Call Go To Website
                break
            case "Send App Feedback":
                // Call Send App Feedback Address
                break
            case "Privacy Policy":
                // Call Privacy Policy Address
                break
            case "Logout":
                logout()
                break
            default:
                print("Non-Selectable TableView Cell Called")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // Count settings to add
        return Constants.settingTitles.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { // Smaller height for copyright label
        if indexPath.row == 7 { return 50.0 } else { return 65.0 }
    }
    
    //MARK: Private Functions
    func tableViewSetup() { // Register cells with controller delegate
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        touchIDSwitch.isOn = UserDefaults.standard.bool(forKey: "biometricsEnabled")
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    @objc private func touchID() { //Set user defaults to remeber biometrics off or on
        touchIDSwitch.isOn ? UserDefaults.standard.set(true, forKey: "biometricsEnabled") : UserDefaults.standard.set(false, forKey: "biometricsEnabled")
    }
    
    private func logout() {
        let loginController : LoginSplashController = LoginSplashController() as LoginSplashController
        loginController.videoURL = URL(fileURLWithPath: Bundle.main.path(forResource: "edinburgh_ariel", ofType: "mp4")!)
        UIApplication.shared.keyWindow!.rootViewController = loginController
        UIApplication.shared.keyWindow!.makeKeyAndVisible()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(String(describing: Constants.settingTitles[indexPath.row]))"
        
        if indexPath.row == 0 {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 16.0)
            cell.isUserInteractionEnabled = false
        }else if indexPath.row == 1 {
            cell.accessoryView = touchIDSwitch
            touchIDSwitch.addTarget(self, action: #selector(touchID), for: .valueChanged)
            cell.selectionStyle = .none
        }else if indexPath.row == 2 {
            cell.accessoryView = notificationSwitch
            cell.selectionStyle = .none
        }else if indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .blue
        }else if indexPath.row == 6 {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .red
        } else {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 12.0)
            cell.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
}
