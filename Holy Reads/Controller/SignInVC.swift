//
//  SignInVC.swift
//  Holy Reads
//
//  Created by mac-14 on 30/08/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SignInVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    var dictSocialInfo = [String:Any]()
    
     // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction
    
    @IBAction func btnSignIn_DidSelect(_ sender: UIButton) {
        self.view.endEditing(true)
        if ValidationClass().ValidateSignInForm(self) {
            self.showHud()
        
            let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setValue(DataManager.getVal(txtEmail.text!) as! String, forKey: "email")
            parameterDictionary.setValue(DataManager.getVal(txtPassword.text!) as! String, forKey: "password")
            print(parameterDictionary)
            
            let methodName = "login"
            
            DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
                let status  = DataManager.getVal(responseData?["status"]) as! String
                let message  = DataManager.getVal(responseData?["message"]) as! String
                if status == "1" {
                    let response = DataManager.getVal(responseData?["data"]) as! [String: Any]
                    DataManager.saveinDefaults(response)
                    if response["verified_status"] as! Int == 2{
                        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
                        objVC.isFrom = "Login"
                        objVC.strEmail = self.txtEmail.text!
                        self.navigationController?.pushViewController(objVC, animated: true)
                    } else if response["verified_status"] as! Int == 1 {
                        let objVC: UIViewController? = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
                        self.navigationController?.pushViewController(objVC!, animated: true)
                        Config().AppUserDefaults.set(true, forKey: "isCurrentUser")
                    }
                }
                else{
                    self.view.makeToast(message: message)
                }
                self.clearHud()
            }
        }
    }
    
    @IBAction func btnClose_DidSelect(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnFacebook_DidSelect(_ sender: UIButton) {
        let fbLoginManager = LoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn(permissions: ["email","public_profile"], from: self, handler: { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        })
    }
    
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: {(connection, result, error) -> Void in
                if error != nil{
                    print("FB error")
                    return
                }
                let fbLoginManager = LoginManager()
                fbLoginManager.logOut()
                print(result as Any)
                
                let fields = result as? [String:Any];
                let fullName = DataManager.getVal(fields?["name"]) as! String;
                let firstName = DataManager.getVal(fields?["first_name"]) as! String;
                let lastName = DataManager.getVal(fields?["last_name"]) as! String;
                let social_id = DataManager.getVal(fields?["id"]) as! String;
                let email = DataManager.getVal(fields?["email"]) as! String;
                let facebookProfileUrl = "http://graph.facebook.com/\(social_id)/picture?type=large"
                
                self.dictSocialInfo["name"] = fullName
                self.dictSocialInfo["email"] = email
                self.dictSocialInfo["social_id"] = social_id
                self.dictSocialInfo["first_name"] = firstName
                self.dictSocialInfo["last_name"] = lastName
                self.dictSocialInfo["image"] = facebookProfileUrl
                self.facebookApiCall()
            })
        }
    }
    
    @IBAction func btnForgotPassword_DidSelect(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnNewCustomer_DidSelect(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    
    func facebookApiCall(){
        
        self.showHud()
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setValue(dictSocialInfo["name"], forKey: "username")
        parameterDictionary.setValue(dictSocialInfo["email"], forKey: "email")
        parameterDictionary.setValue(dictSocialInfo["social_id"], forKey: "fb_id")
        parameterDictionary.setValue(dictSocialInfo["first_name"], forKey: "first_name")
        parameterDictionary.setValue(dictSocialInfo["image"], forKey: "profile_picture")
        print(parameterDictionary)
        
        let methodName = "facebooklogin"
        
        DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
            let status  = DataManager.getVal(responseData?["status"]) as! String
            let message  = DataManager.getVal(responseData?["message"]) as! String
            
            if status == "1" {
                let response = DataManager.getVal(responseData?["data"]) as! [String: Any]
                let objVC: UIViewController? = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
                DataManager.saveinDefaults(response)
                Config().AppUserDefaults.set(true, forKey: "isCurrentUser")
                self.navigationController?.pushViewController(objVC!, animated: true)
            } else{
                self.view.makeToast(message: message)
            }
            self.clearHud()
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

}
