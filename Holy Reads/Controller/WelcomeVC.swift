//
//  WelcomeVC.swift
//  Holy Reads
//
//  Created by mac-14 on 02/09/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var viewsignUp: UIView!
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewsignUp.clipsToBounds = true
        viewsignUp.layer.cornerRadius = 25
        if #available(iOS 11.0, *) {
            viewsignUp.layer.maskedCorners = [  .layerMinXMaxYCorner, .layerMinXMinYCorner ]
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: - IBAction

    @IBAction func btnSignUp_DidSelect(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(obj, animated: true)
        UserDefaults.standard.set(true, forKey: "isIntroSkipped")
        UserDefaults.standard.synchronize()
        
    }
    @IBAction func btnFacebook_DidSelect(_ sender: UIButton) {
       
    }
    @IBAction func btnGoogle_DidSelect(_ sender: UIButton) {
        
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
