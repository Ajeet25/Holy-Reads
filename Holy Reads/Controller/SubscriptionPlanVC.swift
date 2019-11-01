//
//  SubscriptionPlanVC.swift
//  Holy Reads
//
//  Created by mac-14 on 30/08/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit

class SubscriptionPlanVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var lblPlanName: UILabel!
    @IBOutlet weak var tblPlanDetails: UITableView!
    @IBOutlet weak var txtSelectPriceDetails: UITextView!
    
    @IBOutlet weak var btnWrittenSummaries: UIButton!
    @IBOutlet weak var btnAudioVideoSummaries: UIButton!
    @IBOutlet weak var btnAudioSummaries: UIButton!
    
    @IBOutlet weak var lblWrittenSummaries: UILabel!
    @IBOutlet weak var lblAudioVideoSummaries: UILabel!
    @IBOutlet weak var lblAudioSummaries: UILabel!
    
    @IBOutlet weak var imgWrittenSummaries: UIImageView!
    @IBOutlet weak var imgAudioVideoSummaries: UIImageView!
    @IBOutlet weak var imgAudioSummaries: UIImageView!
    
    @IBOutlet weak var imgMonthlyTriangle: UIImageView!
    @IBOutlet weak var imgQuaterlyTriangle: UIImageView!
    @IBOutlet weak var imgAnnuallyTriangle: UIImageView!
    
    @IBOutlet weak var choosePlanColletionView: UICollectionView!
    //monthly
    @IBOutlet weak var lblMonthlyCurrency: UILabel!
    @IBOutlet weak var lblMonthlyPrice: UILabel!
    @IBOutlet weak var lblPlanDetails: UILabel!
    @IBOutlet weak var btnMonthly: UIButton!
    
    //Anually
    @IBOutlet weak var lblYearlyCurrency: UILabel!
    @IBOutlet weak var lblYearlyPrice: UILabel!
    @IBOutlet weak var lblYearly: UILabel!
    @IBOutlet weak var btnYearly: UIButton!
    
    // Quaterly
    @IBOutlet weak var lblQuaterlyCurrency: UILabel!
    @IBOutlet weak var lblQuaterlyPrice: UILabel!
    @IBOutlet weak var lblQuaterly: UILabel!
    @IBOutlet weak var btnQuaterly: UIButton!
    
    var isFrom = ""
    var planId = Int()
    var dictPlanDetails = [String:Any]()
    var selectedIndex = Int()
    var arrPlans = ["Quaterly","Monthly", "Annually"]
    var planType = "1"
    var planDuration = ""
    
    var plan_description_Array = [Any]()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
//         let str = "<p>Lorem Ipsum is simply dummy text.</p>\n<p>Lorem Ipsum is simply dummy text.</p>\n<p>Lorem Ipsum is simply dummy text.</p>\n<p>Lorem Ipsum is simply dummy text.</p>"
//
//
//        let fullNameArr = str.components(separatedBy: ".")
//
//        print(fullNameArr)
//
        
        
        
   
        
       // lblQuaterlyPrice.attributedText = add(stringList: fullNameArr, font: UIFont.systemFont(ofSize: 10), bullet: "●")
 
        
       // self.lblQuaterlyPrice.text = "\u{2022} This is a list item!"

        let ChoosePlanLiberaryLayOut = UICollectionViewFlowLayout()
        ChoosePlanLiberaryLayOut.itemSize = CGSize(width: screenWidth/3-20, height: 120)
        ChoosePlanLiberaryLayOut.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        ChoosePlanLiberaryLayOut.minimumInteritemSpacing = 0
        ChoosePlanLiberaryLayOut.minimumLineSpacing = 15
        ChoosePlanLiberaryLayOut.scrollDirection = .horizontal
        
        choosePlanColletionView.collectionViewLayout = ChoosePlanLiberaryLayOut
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    func addBulletToString(stringList: [String],
             font: UIFont,
             bullet: String = "\u{2022}",
             indentation: CGFloat = 20,
             lineSpacing: CGFloat = 2,
             paragraphSpacing: CGFloat = 12,
             textColor: UIColor = .gray,
             bulletColor: UIColor = UIColor.orange) -> NSAttributedString {
        
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
        let bulletAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: bulletColor]
        
        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        //paragraphStyle.firstLineHeadIndent = 0
        //paragraphStyle.headIndent = 20
        //paragraphStyle.tailIndent = 1
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation
        
        let bulletList = NSMutableAttributedString()
        for string in stringList {
            let formattedString = "\(bullet)\t\(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)
            
            attributedString.addAttributes(
                [NSAttributedString.Key.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))
            
            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))
            
            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: bullet)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }
        
        return bulletList
    }

    override func viewWillAppear(_ animated: Bool) {
        getMembershipPlanDetails(planId: planId)
    }
    
    // MARK: - NavigationBar Buttons
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - IBAction
    @IBAction func btnFreeTrial(_ sender: UIButton) {
        self.freeTrial()
    }
    
    @IBAction func btnWrittenSummaries(_ sender: UIButton) {
        if sender.tag == 101{
            btnWrittenSummaries.isSelected = true
            lblWrittenSummaries.textColor = Config().AppOrangeColor
            imgWrittenSummaries.image = #imageLiteral(resourceName: "radio1")
            
            btnAudioVideoSummaries.isSelected = false
            lblAudioVideoSummaries.textColor = UIColor.lightGray
            imgAudioVideoSummaries.image = #imageLiteral(resourceName: "radio")
            
            btnAudioSummaries.isSelected = false
            lblAudioSummaries.textColor = UIColor.lightGray
            imgAudioSummaries.image = #imageLiteral(resourceName: "radio")
            self.planType = "1"
        } else if sender.tag == 102{
            
            btnAudioVideoSummaries.isSelected = true
            lblAudioVideoSummaries.textColor = Config().AppOrangeColor
            imgAudioVideoSummaries.image = #imageLiteral(resourceName: "radio1")
            
            btnWrittenSummaries.isSelected = false
            lblWrittenSummaries.textColor = UIColor.lightGray
            imgWrittenSummaries.image = #imageLiteral(resourceName: "radio")
            
            btnAudioSummaries.isSelected = false
            lblAudioSummaries.textColor = UIColor.lightGray
            imgAudioSummaries.image = #imageLiteral(resourceName: "radio")
            self.planType = "2"
            
        } else if sender.tag == 103{
            
            btnAudioSummaries.isSelected = true
            lblAudioSummaries.textColor = Config().AppOrangeColor
            imgAudioSummaries.image = #imageLiteral(resourceName: "radio1")
            
            btnWrittenSummaries.isSelected = false
            lblWrittenSummaries.textColor = UIColor.lightGray
            imgWrittenSummaries.image = #imageLiteral(resourceName: "radio")
            
            btnAudioVideoSummaries.isSelected = false
            lblAudioVideoSummaries.textColor = UIColor.lightGray
            imgAudioVideoSummaries.image = #imageLiteral(resourceName: "radio")
            self.planType = "3"
            
        }
    }
   
    @IBAction func btnMakePayment_DidSelect(_ sender: UIButton) {
        self.SelectMembershipPlan()

    }
    
    // MARK: - UITableViewDelegate
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return self.plan_description_Array.count
    //    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath) as! PlanCell
    //        let dict = DataManager.getVal(self.plan_description_Array[indexPath.row]) as! NSDictionary
    //
    //        let monthly_description = DataManager.getVal(dict["description"]) as! String
    //        cell.lblDescription.text = monthly_description.htmlToString
    //        print(monthly_description)
    //
    //        return cell
    //    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //
    //    }
    // MARK: - UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.plan_description_Array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChoosePlanCell", for: indexPath) as! ChoosePlanCell
        let dict = DataManager.getVal(self.plan_description_Array[indexPath.row]) as! NSDictionary
        let monthly_price = DataManager.getVal(dict["price"]) as! String
        cell.lblPrice.text = monthly_price
        
        cell.lblPlanType.text = arrPlans[indexPath.row]
        if self.selectedIndex == indexPath.row{
            cell.btnPlanType.backgroundColor = #colorLiteral(red: 0.9959338307, green: 0.6004624963, blue: 0.1465278566, alpha: 1)
            cell.lblCurrency.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.lblPrice.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.lblPlanType.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.imgTriangle.isHidden = false
            //cell.img.setImage(UIImage(named:"check-box"), for: .normal)
        } else {
            
            // cell.CheckButton.setImage(UIImage(named:"uncheck"), for: .normal)
            cell.btnPlanType.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
            cell.lblCurrency.textColor = #colorLiteral(red: 0.9959338307, green: 0.6004624963, blue: 0.1465278566, alpha: 1)
            cell.lblPrice.textColor = #colorLiteral(red: 0.9959338307, green: 0.6004624963, blue: 0.1465278566, alpha: 1)
            cell.lblPlanType.textColor = #colorLiteral(red: 0.9959338307, green: 0.6004624963, blue: 0.1465278566, alpha: 1)
            cell.btnPlanType.setImage(UIImage.init(named: "Rectangle-1"), for: .selected)
            cell.imgTriangle.isHidden = true
        }
        cell.layer.cornerRadius = 4
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.choosePlanColletionView.reloadData()
        self.updateDetails()
        
        //self.tblPlanDetails.reloadData()
    }
    func updateDetails (){
        if let strDes = dictPlanDetails["subscription_title"] as? String{
            self.lblPlanName.text = strDes
        }
        
        if selectedIndex == 0 {
           if let strDes = dictPlanDetails["quarterly_description"] as? String{
               // let url = URL(string: "http://i.devtechnosys.tech:8083/holyreads/pages/mobile_subscription_description")!
                //let requestObj = URLRequest(url: url)
                //webView.loadRequest(requestObj)
                // let desctiption =  strDes.htmlToString
       
            let trimmed = strDes.replacingOccurrences(of: "\r\n", with: "")
            let fullNameArr = trimmed.components(separatedBy: ".")
            var s = [String]()
              for i in 0..<fullNameArr.count-1 {
                s.append(fullNameArr[i])
            }
            self.lblPlanDetails.attributedText = addBulletToString(stringList: s, font: UIFont.systemFont(ofSize: 15), bullet: "●")
            self.planDuration = "90"

            }
        } else if selectedIndex == 1{
            if let strDes = dictPlanDetails["monthly_description"] as? String{
                let trimmed = strDes.replacingOccurrences(of: "\r\n", with: "")
                let fullNameArr = trimmed.components(separatedBy: ".")
                var s = [String]()
                 
                for i in 0..<fullNameArr.count-1 {
                    s.append(fullNameArr[i])
                }
                self.lblPlanDetails.attributedText = addBulletToString(stringList: s, font: UIFont.systemFont(ofSize: 15), bullet: "●")
                self.planDuration = "30"
            }
            
        } else if selectedIndex == 2{
            if let strDes = dictPlanDetails["anually_description"] as? String{
                let trimmed = strDes.replacingOccurrences(of: "\r\n", with: "")
                let fullNameArr = trimmed.components(separatedBy: ".")
                var s = [String]()
                
                
                for i in 0..<fullNameArr.count-1 {
                    s.append(fullNameArr[i])
                }
                self.lblPlanDetails.attributedText = addBulletToString(stringList: s, font: UIFont.systemFont(ofSize: 15), bullet: "●")
                self.planDuration = "365"
            }
        }
    }
 
    //MARK:- API Calling (getPerticularSubscriptionData)
    func getMembershipPlanDetails (planId: Int) {
        self.view.endEditing(true)
         self.showHud()
        let idPlan = DataManager.getVal(planId)
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setValue(idPlan, forKey: "subscription_id")
        print(parameterDictionary)
        
        let methodName = "getPerticularSubscriptionData"
        
        DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
            let status  = DataManager.getVal(responseData?["status"]) as! String
            let message  = DataManager.getVal(responseData?["message"]) as! String
            
            if status == "1" {
                if  let response = DataManager.getVal(responseData?["data"]) as? [String:Any]{
                    self.dictPlanDetails = response
                    self.plan_description_Array = DataManager.getVal(response["price"]) as! [Any]
                    self.choosePlanColletionView.reloadData()
                    self.updateDetails()
                }
            }else{
                self.view.makeToast(message: message)
            }
            self.clearHud()
        }
    }
    
    //MARK:- API Calling (SelectMembershipPlan)

    func SelectMembershipPlan() {
        
 //        "subscription_id" : "5",
//        "user_id" : "315",
//        "subscription_details" : "3",
//        "duration" : 365
        self.view.endEditing(true)
        self.showHud()
    
        let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as! String

        let parameterDictionary = NSMutableDictionary()

        parameterDictionary.setValue(planId, forKey: "subscription_id")
        parameterDictionary.setValue(user_id, forKey: "user_id")
        parameterDictionary.setValue(planType, forKey: "subscription_details")
        parameterDictionary.setValue(planDuration, forKey: "duration")

        print(parameterDictionary)
        
        let methodName = "chooseSubscription"
        
        DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
            let status  = DataManager.getVal(responseData?["status"]) as! String
            let message  = DataManager.getVal(responseData?["message"]) as! String
            
            if status == "1" {
                if  let response = DataManager.getVal(responseData?["data"]) as? [String:Any] {
                    
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                    self.navigationController?.pushViewController(obj, animated: true)
                 }
            } else{
                self.view.makeToast(message: message)
            }
            self.clearHud()
        }
    }
    
    func freeTrial () {
        self.view.endEditing(true)
        self.showHud()
        
        let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as! String
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setValue(user_id, forKey: "user_id")
        print(parameterDictionary)
        
        let methodName = "freetrial"
        
        DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
            let status  = DataManager.getVal(responseData?["status"]) as! String
            let message  = DataManager.getVal(responseData?["message"]) as! String
            
            if status == "1" {
                   self.appDelegate.showFirstPage()
             } else{
                self.view.makeToast(message: message)
            }
            self.clearHud()
        }
    }
        
    
    
    
    
}

