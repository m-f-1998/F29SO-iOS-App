//
//  SettingsController.swift
//  F29SO
//
//  Created by Matthew on 29/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit.UITableViewController

class SettingsController: UITableViewController {
    
    private let touchIDSwitch: UISwitch = UISwitch()
    private let notificationSwitch: UISwitch = UISwitch()
    private let settingsCells: Array = [UserDefaults.standard.string(forKey: "userDetails")!, "Touch-ID", "Collection Notifications", "Go To Website", "Send App Feedback", "Privacy Policy", "Logout", "Version Number 0.4 {3} - © Matthew Frankland 2018"]
    
    override func viewDidLoad() { // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupTableView()
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // Set Cells That Open URL
        var selectableURL = ""
        
        switch indexPath.row {
        case 3:
            selectableURL = OutputURL.websiteURL
            break
        case 4:
            selectableURL = OutputURL.feedbackURL
            break
        case 5:
            selectableURL = OutputURL.privacyURL
            break
        case 6:
            logout()
            return
        default:
            NSLog("Non-Selectable Settings Cell Called")
        }
        
        if (selectableURL != "") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL.init(string: selectableURL)!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL.init(string: selectableURL)!)
            }
            tableView.cellForRow(at: indexPath)?.isSelected = false
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // Count settings to add
        return settingsCells.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { // Smaller height for copyright label
        if indexPath.row == 7 { return 50.0 } else { return 65.0 }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // Define Cell Contents
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(String(describing: settingsCells[indexPath.row]))"
        
        if indexPath.row == 0 {
            cell.imageView?.image = UIImage(named: "profile_picture.jpg")
            circleMask(img: cell.imageView!)
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
    
    //MARK: - Setup Functions
    
    private func setupTableView() { // Setup TableView and register cells in delegate
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        touchIDSwitch.isOn = UserDefaults.standard.bool(forKey: "biometricsEnabled")
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    @objc private func touchID() { // Set user defaults to remeber biometrics off or on based upon Settings Switch
        touchIDSwitch.isOn ? UserDefaults.standard.set(true, forKey: "biometricsEnabled") : UserDefaults.standard.set(false, forKey: "biometricsEnabled")
    }
    
    private func logout() { // Function to Logout
        let loginController : LoginSplashController = LoginSplashController() as LoginSplashController
        UIApplication.shared.keyWindow!.rootViewController = loginController
        UIApplication.shared.keyWindow!.makeKeyAndVisible()
    }
    
    private func circleMask(img: UIImageView) { // Change UIImageView To Circle For Profile Pic
        img.layer.borderWidth = 1.0
        img.layer.masksToBounds = false
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.cornerRadius = 30.0
        img.clipsToBounds = true
    }
    
}
