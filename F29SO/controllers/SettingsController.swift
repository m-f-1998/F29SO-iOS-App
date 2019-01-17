//
//  SettingsController.swift
//  F29SO
//
//  Created by Matthew on 29/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit.UITableViewController
import OneSignal
import KeychainAccess

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let touchIDSwitch: UISwitch = UISwitch()
    private let settingsCells: Array = ["E-Mail Address: " + UserDefaults.standard.string(forKey: "userDetails")!, "Biometrics", "Go To Website", "Send App Feedback", "Privacy Policy", "Logout", "Version Number 0.4 {3} - © Matthew Frankland 2018"]
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
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
        case 2:
            selectableURL = "http://www.google.co.uk"
            break
        case 3:
            selectableURL = "http://www.bbc.co.uk"
            break
        case 4:
            selectableURL = "http://www.facebook.co.uk"
            break
        case 5:
            logout()
            return
        default:
            NSLog("Non-Selectable Settings Cell Called")
        }
        
        if selectableURL != "" {
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
        if indexPath.row == 6 { return 50.0 } else { return 65.0 }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // Define Cell Contents
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(String(describing: settingsCells[indexPath.row]))"
        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        if indexPath.row == 0 {
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 16.0)
            cell.selectionStyle = .none

            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(tapGestureRecognizer:)))
            cell.imageView?.addGestureRecognizer(tapGestureRecognizer)
            cell.bringSubviewToFront(cell.imageView!)
            cell.imageView?.isUserInteractionEnabled = true
            
            getImage()
        } else if indexPath.row == 1 {
            cell.textLabel?.textAlignment = .left
            cell.accessoryView = touchIDSwitch
            touchIDSwitch.addTarget(self, action: #selector(touchID), for: .valueChanged)
            cell.selectionStyle = .none
        } else if indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .blue
        } else if indexPath.row == 5 {
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
    
    //MARK: - Image Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            let newImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            self.uploadPhoto(image: newImage)
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
            cell?.imageView?.image = self.resizeImage(image: newImage, newWidth: 100.0)
            self.circleMask(img: cell!.imageView!)
        })
    }
    
    //MARK: - Setup Functions
    
    private func setupTableView() { // Setup TableView and register cells in delegate
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        touchIDSwitch.isOn = UserDefaults.standard.bool(forKey: "biometricsEnabled")
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    private func uploadPhoto(image: UIImage) { // Upload a Newly Selected Profile Picture To Server
        let uploadURL: String = "http://www.matthewfrankland.co.uk/pedalPay/profilePictures/uploadPhoto.php"
        do {
            let password = try Keychain(service:Bundle.main.object(forInfoDictionaryKey: "KaychainGroup") as! String).synchronizable(true).get(UserDefaults.standard.string(forKey: "userDetails")!)
            let picture = "data:image/png;base64," + resizeWithPercentage(percentage: 0.1, image: image)!.pngData()!.base64EncodedString()
            
            sendRequest(uploadURL, method: .post, parameters: ["email": UserDefaults.standard.string(forKey: "userDetails")!, "password": password!, "picture": picture], completionHandler: { (data, response, error) in
                guard let data = data else { return }
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                    self.alert(title: "Profile Image Uploaded", message: "", style: UIAlertController.Style.alert)
                } catch let error as NSError {
                    print("Error In Profile Pic Upload: " + error.debugDescription)
                    self.alert(title: "Fatal Error In Profile Picture", message: response.debugDescription, style: UIAlertController.Style.alert)
                }
            })?.resume()
        } catch {
            fatalError("Error fetching password items - \(error)")
        }
    }
    
    func resizeWithPercentage (percentage: CGFloat, image: UIImage) -> UIImage? { // Resize Image For Base64 Scaling at 10%
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: image.size.width * percentage, height: image.size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, image.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeImage (image: UIImage, newWidth: CGFloat) -> UIImage { // Resize Image At Fixed Width
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    @objc private func touchID() { // Set user defaults to remeber biometrics off or on based upon Settings Switch
        touchIDSwitch.isOn ? UserDefaults.standard.set(true, forKey: "biometricsEnabled") : UserDefaults.standard.set(false, forKey: "biometricsEnabled")
    }
        
    private func logout() { // Function to Logout
        let loginController : LoginSplashController = LoginSplashController() as LoginSplashController
        loginController.videoURL = URL(fileURLWithPath: Bundle.main.path(forResource: "edinburgh_ariel", ofType: "mp4")!)
        UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.7, options: .transitionCrossDissolve, animations: {
            UIApplication.shared.keyWindow!.rootViewController = loginController
            UIApplication.shared.keyWindow!.makeKeyAndVisible()
        }, completion: nil)
    }
    
    private func circleMask(img: UIImageView) { // Change UIImageView To Circle For Profile Pic
        DispatchQueue.main.async {
            img.layer.borderWidth = 1.0
            img.layer.masksToBounds = false
            img.layer.borderColor = UIColor.black.cgColor
            img.layer.cornerRadius = 10.0
            img.clipsToBounds = true
        }
    }
    
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) { // Present Image Controller When Profile Picture Tap Detected
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    private func getImage() { // Get Profile Picture From Server If Exists Else Present Default Profile Picture
        do {
            let password = try Keychain(service:Bundle.main.object(forInfoDictionaryKey: "KaychainGroup") as! String).synchronizable(true).get(UserDefaults.standard.string(forKey: "userDetails")!)
            let userIDURL =  "http://www.matthewfrankland.co.uk/pedalPay/userFunctions/userID.php"
            
            sendRequest(userIDURL, method: .post, parameters: ["email": UserDefaults.standard.string(forKey: "userDetails")!, "password": password!], completionHandler: { (data, response, error) in
                guard let data = data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                    let urlString: String = "http://www.matthewfrankland.co.uk/pedalPay/profilePictures/" + (json["message"] as! NSNumber).stringValue + ".jpg"
                    
                    if let url = URL(string: urlString) {
                        let request = URLRequest(url: url)
                        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                            guard let data = data, error == nil else {
                                print("\(String(describing: error))")
                                return
                            }
                            if response as? HTTPURLResponse != nil {
                                DispatchQueue.main.async {
                                    let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
                                    if (response as! HTTPURLResponse).statusCode == 200 {
                                        cell?.imageView?.image = self.resizeImage(image: UIImage(data: data)!, newWidth: 100.0)
                                        self.circleMask(img: cell!.imageView!)
                                    } else {
                                        cell?.imageView?.image = UIImage(named: "profile_picture.jpg")
                                        self.circleMask(img: (cell?.imageView)!)
                                    }
                                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                                }
                            }
                        }
                        task.resume()
                    }
                } catch let error as NSError {
                    self.alert(title: "Fatal Error In Profile Picture", message: error.description, style: UIAlertController.Style.alert)
                }
            })?.resume()
        } catch {
            fatalError("Error fetching password items - \(error)")
        }
    }

}
