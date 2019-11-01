//
//  MySubscriptionVC.swift
//  Holy Reads
//
//  Created by mac-14 on 02/09/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit

class MySubscriptionVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var tblMySubscription: UITableView!
    @IBOutlet weak var lblPlanName: UILabel!
    @IBOutlet weak var lblPlanDetails: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPlanDuration: UILabel!
    
    // MARK: - Variable
    var dictSubscriptionDetails = [String:Any]()
    
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblMySubscription.rowHeight = UITableView.automaticDimension
        tblMySubscription.estimatedRowHeight = 35
    }
    override func viewWillAppear(_ animated: Bool) {
        webView.isHidden = true
       // self.mySubscriptionApi()
    }
    
    // MARK: - NavigationBar Buttons
    @IBAction func btnBack_DidSelect(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
      // MARK: - IBAction
    @IBAction func btnUpdateTapped_DidSelect(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionPlanVC") as! SubscriptionPlanVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnAddMember_DidSelect(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "AddMemberVC") as! AddMemberVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath) as! PlanCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    //MARK:- Api Call(My Subscription Plan)
    func mySubscriptionApi() {
        self.view.endEditing(true)
        self.showHud()
        let parameterDictionary = NSMutableDictionary()
        let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as! String
        parameterDictionary.setValue(DataManager.getVal(user_id) as! String, forKey: "user_id")
        print(parameterDictionary)
        
        let methodName = "getmysubscription"
//       (
//        {
//            description = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";
//            duration = 90;
//            price = 54;
//            "subscription_details" = 2;
//            "subscription_name" = Family;
//        }
//        );
        
        DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
            let status  = DataManager.getVal(responseData?["status"]) as! String
            let message  = DataManager.getVal(responseData?["message"]) as! String
            if status == "1" {
                let response = DataManager.getVal(responseData?["data"]) as! [String: Any]
                self.dictSubscriptionDetails = response
                self.setSubsciptionData()
            } else{
                self.view.makeToast(message: message)
            }
            self.clearHud()
        }
    }
    
    func setSubsciptionData()  {
        if let planName =  dictSubscriptionDetails ["subscription_name"] as? String{
            self.lblPlanName.text = planName
        }
        if let planDetails =  dictSubscriptionDetails ["subscription_details"] as? String{
            self.lblPlanDetails.text = planDetails
        }
        if let price =  dictSubscriptionDetails ["price"] as? Int{
            self.lblPrice.text = String(price)
        }
        if let planDuration =  dictSubscriptionDetails ["duration"] as? String{
            self.lblPlanDuration.text = planDuration
        }
        if let description =  dictSubscriptionDetails ["description"] as? String{
             webView.loadHTMLString(description, baseURL: nil)
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
