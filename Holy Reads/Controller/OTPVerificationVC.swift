//
//  OTPVerificationVC.swift
//  Holy Reads
//
//  Created by mac-14 on 30/08/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit

class OTPVerificationVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var txtOtp: UITextField!
    @IBOutlet weak var btnResend: UIButton!
    
    // MARK: - Variable
    
    var isFrom = ""
    var strEmail = ""
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - IBAction
    
    @IBAction func btnSubmit_DidSelect(_ sender: UIButton) {
        self.view.endEditing(true)
        if ValidationClass().ValidateOtp(self){
            self.showHud()
            
            let parameterDictionary = NSMutableDictionary()
            let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as! String
            
            parameterDictionary.setValue(DataManager.getVal(user_id) as! String, forKey: "user_id")
            parameterDictionary.setValue(DataManager.getVal(txtOtp.text) as! String, forKey: "otp")
            print(parameterDictionary)
            let methodName = "otp"
            
            DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
                let status  = DataManager.getVal(responseData?["status"]) as! String
                let message  = DataManager.getVal(responseData?["message"]) as! String
                if status == "1" {
                    if self.isFrom == "ForgotPassword"{
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                        self.navigationController?.pushViewController(obj, animated: true)
                    } else if self.isFrom == "Login"{
                        let objVC: UIViewController? = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
                        self.navigationController?.pushViewController(objVC!, animated: true)
                        Config().AppUserDefaults.set(true, forKey: "isCurrentUser")
                    } else {
 //                       let obj = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
                         let obj = self.storyboard?.instantiateViewController(withIdentifier: "MembershipPlanVC") as! MembershipPlanVC
                         self.navigationController?.pushViewController(obj, animated: true)
                    }
                    self.view.makeToast(message: message)
                } else {
                    self.view.makeToast(message: message)
                }
                self.clearHud()
            }
        }
    }
    
    
    
    @IBAction func btnClose_DidSelect(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResend_DidSelect(_ sender: UIButton) {
        self.view.endEditing(true)
        self.txtOtp.text = ""
        self.showHud()
        let parameterDictionary = NSMutableDictionary()
        let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as! String
        parameterDictionary.setValue(user_id, forKey: "user_id")

        let methodName = "resend_otp"
        
        DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
            let status  = DataManager.getVal(responseData?["status"]) as! String
            let message  = DataManager.getVal(responseData?["message"]) as! String
            if status == "1" {
                 self.view.makeToast(message: message)
            } else {
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

