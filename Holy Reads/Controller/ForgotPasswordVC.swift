//
//  ForgotPasswordVC.swift
//  Holy Reads
//
//  Created by mac-14 on 30/08/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var txtEmail: UITextField!
    
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    // MARK: - IBAction
    
    @IBAction func btnUpdate_DidSelect(_ sender: Any) {
         self.view.endEditing(true)
        if ValidationClass().ValidateForgotPasswordForm(self){
            self.showHud()
            let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setValue(DataManager.getVal(txtEmail.text!) as! String, forKey: "email")
            print(parameterDictionary)
            
            let methodName = "forgot_password"
            DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
                let status  = DataManager.getVal(responseData?["status"]) as! String
                let message  = DataManager.getVal(responseData?["message"]) as! String
                if status == "1" {
                    let response = DataManager.getVal(responseData?["data"]) as! [String: Any]
                    DataManager.saveinDefaults(response)
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
                    obj.isFrom = "ForgotPassword"
                    self.navigationController?.pushViewController(obj, animated: true)
                } else{
                    self.view.makeToast(message: message)
                    //self.clearAllNotice()
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

