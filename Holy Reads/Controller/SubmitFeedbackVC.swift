//
//  SubmitFeedbackVC.swift
//  Holy Reads
//
//  Created by mac-14 on 18/10/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit

class SubmitFeedbackVC: UIViewController {
// MARK: - Outlets
    @IBOutlet weak var txtSubmitFeedback: UITextView!
    @IBOutlet weak var txtTitle: UITextField!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtSubmitFeedback.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.4572720462)
        txtSubmitFeedback.layer.borderWidth = 1

    }
    
    // MARK: - NavigationBar Buttons
    @IBAction func btnBack_DidSelect(_ sender: Any) {
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
