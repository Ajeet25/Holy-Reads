//
//  BlessFriendVC.swift
//  Holy Reads
//
//  Created by mac-14 on 02/09/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit

class BlessFriendVC: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak var btnChooseSubscriptionPlan: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnChooseSubscriptionPlan.layer.borderColor = #colorLiteral(red: 0.9960784314, green: 0.6, blue: 0.1450980392, alpha: 1)
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
