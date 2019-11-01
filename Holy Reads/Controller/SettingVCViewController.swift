//
//  SettingVCViewController.swift
//  Holy Reads
//
//  Created by mac-14 on 03/09/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit
import SDWebImage

class SettingVCViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tblSetting: UITableView!
    @IBOutlet weak var txtUsername: UILabel!
    @IBOutlet weak var txtEmail: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!

    
    //MARK:- Variables
    var arrTitles = [["title": "Personal Information", "expendable": false, "leftIcon":"Personal Information", "rightButton":""],
                     ["title": "Change Password", "expendable": false,"leftIcon":"Change password", "rightButton":""],
                     ["title": "My Subscription", "expendable": false,"leftIcon":"My Subscription", "rightButton":""],
                     ["title": "Bless a Friend", "expendable": false,"leftIcon":"Bless a Friend", "rightButton":""],
                     ["title": "My Downloads", "expendable": false,"leftIcon":"My Downloads", "rightButton":""],
                     ["title": "Notification Settings", "expendable": false,"leftIcon":"Notification", "rightButton":""],
                     ["title": "Support", "expendable": true, "isExpended": false,"leftIcon":"Support", "rightButton":"down","expendData": ["FAQ", "Contact Us", "Privacy Policy", "Submit Feedback"]],
                     ["title": "Notification", "expendable": false,"leftIcon":"Notification", "rightButton":""],
                     ["title": "Logout", "expendable": false,"leftIcon":"logout", "rightButton":""],
                     ["title": "Kindle Integration", "expendable": false,"leftIcon":"", "rightButton":""],
                     ["title": "EverNote Integration", "expendable": false,"leftIcon":"", "rightButton":""]
    ]
    var arrExpandImg = [ "FAQ","Contact us","Privacy Policy","Submit Feedback"]
    var notificationStatus = ""
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.showUserData()
        //self.performSelector(inBackground: #selector(notificationApi), with: nil)
    }
    
    func showUserData (){
        let email = DataManager.getVal(Config().AppUserDefaults.value(forKey: "email")) as! String
        txtEmail.text = email
        let username = DataManager.getVal(Config().AppUserDefaults.value(forKey: "username")) as! String
        txtUsername.text = username
        if let profileImg = DataManager.getVal(Config().AppUserDefaults.value(forKey: "profile_picture")) as? String
        {
            self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imgProfile.startAnimating()
            let url = URL.init(string: profileImg)
            self.imgProfile.sd_setImage(with: url, placeholderImage: UIImage.init(named: ""), options: .refreshCached, completed: { (img, error, cacheType, url) in
            })
            self.imgProfile.stopAnimating()
        }
        
    }
    
    @objc func actionNotificationButtonClick(_ sender: UISwitch) {
        print("Switchtapped")
        if sender.isOn{
            notificationStatus = "1"
        } else {
            notificationStatus = "0"
        }
        self.notificationApi()
        //changenotificationsetting
        
    }
    
    @objc func actionRightButtonClick(_ sender: UIButton) {
        print("RightButtontapped")

    }
    
    
    @objc func actionButtonHeaderClick(_ sender: UIButton) {
        if sender.tag == 0{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if sender.tag == 1{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ChangePassword") as! ChangePassword
            self.navigationController?.pushViewController(obj, animated: true)
        } else if sender.tag == 2{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "MySubscriptionVC") as! MySubscriptionVC
            self.navigationController?.pushViewController(obj, animated: true)
        } else if sender.tag == 3{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "BlessFriendVC") as! BlessFriendVC
            self.navigationController?.pushViewController(obj, animated: true)
        } else if sender.tag == 4{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "MyDownloadsVC") as! MyDownloadsVC
            self.navigationController?.pushViewController(obj, animated: true)
        } else if sender.tag == 5{
            //            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ChangePassword") as! ChangePassword
            //            self.navigationController?.pushViewController(obj, animated: true)
        } else if sender.tag == 6 {
            if let isExpended = (arrTitles[sender.tag])["isExpended"] as? Bool {
                var dicData = arrTitles[sender.tag]
                dicData["isExpended"] = !isExpended
                if isExpended {
                    dicData["rightButton"] = "down"
                } else{
                    dicData["rightButton"] = "up"
                }
                arrTitles.remove(at: sender.tag)
                arrTitles.insert(dicData, at: sender.tag)
                tblSetting.reloadData()
            }
        } else if sender.tag == 7{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
            self.navigationController?.pushViewController(obj, animated: true)
        } else if sender.tag == 8 {
            let alertView = UIAlertController(title: "Are you sure you want to Logout?", message: "", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                switch action.style{
                case .default:
                    DataManager.ClearUserDetails()
                    self.appDelegate.showFirstPage()
                    break
                case .cancel:
                    break
                case .destructive:
                    
                    break
                }
            }))
            alertView.addAction(UIAlertAction(title: "No", style: .cancel) { action in
                
            })
            present(alertView, animated: true)
        }
    }
}

extension SettingVCViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let status = (arrTitles[section])["expendable"] as? Bool, status == true, let isExpended = (arrTitles[section])["isExpended"] as? Bool, isExpended == true {
            if let arrData = (arrTitles[section])["expendData"] as? [String] {
                return arrData.count
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
        header.backgroundColor = UIColor.white
        
        let leftImg = UIImageView(image: UIImage.init(named: (arrTitles[section])["leftIcon"] as! String ) , highlightedImage: nil)
        leftImg.frame = CGRect(x: 20, y: 20, width: 20, height: 20)
        header.addSubview(leftImg)
        
        let label = UILabel(frame: CGRect(x: 55, y: 12, width: header.frame.size.width - 36, height: header.frame.size.height - 25.0))
        label.font = UIFont.init(name: "Verdana", size: 17)
        label.textColor = #colorLiteral(red: 0.1644093692, green: 0.2676883936, blue: 0.3667172194, alpha: 1)
        label.text = (arrTitles[section])["title"] as? String
        if section == 9 || section == 10 {
            label.font = UIFont.init(name: "Verdana-Bold", size: 16)
            label.frame = CGRect(x: 20, y: 12, width: header.frame.size.width - 36, height: header.frame.size.height - 25.0)
        }
        header.addSubview(label)
        
        let labelLine = UILabel(frame: CGRect(x: 0, y: header.frame.size.height - 2, width: header.frame.size.width, height:1))
        labelLine.backgroundColor = #colorLiteral(red: 0.9845257401, green: 0.9815086722, blue: 0.9844581485, alpha: 1)
        header.addSubview(labelLine)
 
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: header.frame.size.width, height: header.frame.size.height))
        button.tag = section
        button.addTarget(self, action: #selector(actionButtonHeaderClick(_:)), for: .touchUpInside)
        header.addSubview(button)
        
        let notificationSwitch = UISwitch(frame: CGRect(x: header.frame.size.width - 70, y: 15, width: 50, height: 30))
        notificationSwitch.contentMode = .scaleToFill
        if UserDefaults.standard.value(forKey: "notification_status")as? String == "0"{
            notificationSwitch.isOn = false
        } else{
            notificationSwitch.isOn =  true
        }
        notificationSwitch.tag = section
        notificationSwitch.isUserInteractionEnabled = false
        notificationSwitch.isHidden = true
        if section == 5 {
            notificationSwitch.isHidden = false
            notificationSwitch.isUserInteractionEnabled = true
        }
        notificationSwitch.onTintColor = UIColor.init(red: 5.0/255.0, green: 133.0/255.0, blue: 187.0/255.0, alpha: 1)// the "on" color
        
        notificationSwitch.addTarget(self, action: #selector(actionNotificationButtonClick(_:)), for: .touchUpInside)
        header.addSubview(notificationSwitch)
        
        
        
        let rightButton = UIButton(frame: CGRect(x: header.frame.size.width - 70, y: 15, width:50 , height: 30))
        rightButton.tag = section
        rightButton.isUserInteractionEnabled = false
        rightButton.addTarget(self, action: #selector(actionRightButtonClick(_:)), for: .touchUpInside)
        rightButton.setImage(UIImage.init(named: (arrTitles[section])["rightButton"] as! String ), for: .normal)
        //        rightButton.setImage(UIImage.init(named:UIImage(named: (arrTitles[section])["rightButton"] as! String )), for: UIControl.State.normal)
        header.addSubview(rightButton)
        
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "ExpandCell") as? ExpandCell
        cell?.imgIcon.image = UIImage.init(named: arrExpandImg[indexPath.row])
        if let data = arrTitles[6] as? [String: Any]{
            if let cellData = data["expendData"] as? [String]{
             cell?.lblTitle.text = cellData[indexPath.row]
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
//            obj.strTittle = "FAQ"
//            obj.strURL = ""
//            self.navigationController?.pushViewController(obj, animated: true)
        } else if indexPath.row == 1 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ContactUs") as! ContactUs
            self.navigationController?.pushViewController(obj, animated: true)
        } else if indexPath.row == 2 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
            obj.strTittle = "Privacy Policy"
            obj.strURL = "pages/mobile_privacy"
            self.navigationController?.pushViewController(obj, animated: true)
        } else if indexPath.row == 3 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubmitFeedbackVC") as! SubmitFeedbackVC
            self.navigationController?.pushViewController(obj, animated: true)
        }
     }
    
    //MARK:- Api Call
    func notificationApi() {
        self.view.endEditing(true)
        self.showHud()
        let parameterDictionary = NSMutableDictionary()
        let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as! String
        parameterDictionary.setValue(DataManager.getVal(user_id) as! String, forKey: "user_id")
        parameterDictionary.setValue(DataManager.getVal(notificationStatus) as! String, forKey: "notification_status")
        print(parameterDictionary)
        
        let methodName = "changenotificationsetting"
        DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
            let status  = DataManager.getVal(responseData?["status"]) as! String
            let message  = DataManager.getVal(responseData?["message"]) as! String
            if status == "1" {
                self.notificationStatus =  DataManager.getVal(responseData?["notification_status"]) as! String
                UserDefaults.standard.set(self.notificationStatus, forKey: "notification_status")
            } else{
                self.view.makeToast(message: message)
            }
            self.clearHud()
        }
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


