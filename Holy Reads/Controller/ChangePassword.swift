//
//  ChangePassword.swift
//  Holy Reads
//
//  Created by mac-14 on 02/09/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit

class ChangePassword: UIViewController {

     // MARK: - Outlets
    
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - NavigationBar Buttons
    @IBAction func btnBack_DidSelect(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUpdate_DidSelect(_ sender: UIButton) {
        self.view.endEditing(true)
        if ValidationClass().ValidateChangePasswordForm(self) {
            self.showHud()

            let parameterDictionary = NSMutableDictionary()
            let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as! String
            
            parameterDictionary.setValue(DataManager.getVal(user_id) as! String, forKey: "user_id")
            parameterDictionary.setValue(DataManager.getVal(txtCurrentPassword.text!) as! String, forKey: "old_password")
            parameterDictionary.setValue(DataManager.getVal(txtNewPassword.text!) as! String, forKey: "new_password")
            print(parameterDictionary)
            
            let methodName = "change_password"
            
            DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
                let status  = DataManager.getVal(responseData?["status"]) as! String
                let message  = DataManager.getVal(responseData?["message"]) as! String
                if status == "1" {
                    self.navigationController?.popViewController(animated: true)
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

}
