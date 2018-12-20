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
    let settingsCells: Array = [
        UserDefaults.standard.string(forKey: "userDetails")!,
        "Touch-ID",
        "Collection Notifications",
        "Go To Website",
        "Send App Feedback",
        "Privacy Policy",
        "Logout",
        "Version Number 0.4 {3} - © Matthew Frankland 2018"
    ]
    
    override func viewDidLoad() { // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableViewSetup()
        tableView.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    //MARK: TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectableURL = ""
        switch settingsCells[indexPath.row] {
            case "Go To Website":
                selectableURL = OutputURL.websiteURL
                break
            case "Send App Feedback":
                selectableURL = OutputURL.feedbackURL
                break
            case "Privacy Policy":
                selectableURL = OutputURL.privacyURL
                break
            case "Logout":
                logout()
                return
            default:
                print("Non-Selectable TableView Cell Called")
        }
        if #available(iOS 10.0, *) {  UIApplication.shared.open(URL.init(string: selectableURL)!, options: [:], completionHandler: nil) } else { UIApplication.shared.openURL(URL.init(string: selectableURL)!) }
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // Count settings to add
        return settingsCells.count
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
    
    func setCircle(image: UIImageView) -> UIImageView {
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = image.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        image.clipsToBounds = true
        return image
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(String(describing: settingsCells[indexPath.row]))"
        
        if indexPath.row == 0 {
            
            let image = UIImage.init(named: "profile_picture.jpg")
            cell.imageView?.image = image
            circleMask(img: cell.imageView)

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
    
    private func circleMask(img: UIImageView) {
        img.layer.borderWidth = 1.0
        img.layer.masksToBounds = false
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.cornerRadius = 30.0
        img.clipsToBounds = true
    }
    
}
