//
//  ResetPasswordVC.swift
//  Holy Reads
//
//  Created by mac-14 on 30/08/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction
    
    @IBAction func btnDone_DidSelect(_ sender: UIButton) {
        self.view.endEditing(true)
        if ValidationClass().ValidateResetPasswordForm(self){
            showHud()
            let parameterDictionary = NSMutableDictionary()
            
            let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as! String
            parameterDictionary.setValue(DataManager.getVal(user_id) as! String, forKey: "user_id")
            parameterDictionary.setValue(DataManager.getVal(txtNewPassword.text!) as! String, forKey: "password")
            print(parameterDictionary)
            
            let methodName = "reset_password"
            DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
                let status  = DataManager.getVal(responseData?["status"]) as! String
                let message  = DataManager.getVal(responseData?["message"]) as! String
                if status == "1" {
                    self.appDelegate.showFirstPage()
                     self.topViewController()?.view.makeToast(message: message)
                    
                } else{
                    self.view.makeToast(message: message)
                }
                self.clearHud()
                
            }
        }
    }
    
    @IBAction func btnClose_DidSelect(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
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

