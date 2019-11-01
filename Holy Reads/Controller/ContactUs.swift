//
//  ContactUs.swift
//  Holy Reads
//
//  Created by mac-14 on 31/08/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit
import MapKit

class ContactUs: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var txtMeassage: UITextField!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - NavigationBar Buttons
    @IBAction func btnBack_DidSelect(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSend_DidiSelect(_ sender: UIButton) {
        self.view.endEditing(true)
        if ValidationClass().ValidateContactUsForm(self) {
            self.showHud()
            let parameterDictionary = NSMutableDictionary()
            let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as! String
            parameterDictionary.setValue(DataManager.getVal(user_id) as! String, forKey: "user_id")
            parameterDictionary.setValue(DataManager.getVal(txtSubject.text!) as! String, forKey: "subject")
            parameterDictionary.setValue(DataManager.getVal(txtMeassage.text!) as! String, forKey: "message")
            print(parameterDictionary)
            
            let methodName = "contact_us"
            
            DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
                let status  = DataManager.getVal(responseData?["status"]) as! String
                let message  = DataManager.getVal(responseData?["message"]) as! String
                if status == "1" {
                    self.navigationController?.popViewController(animated: true)
                } else {
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
