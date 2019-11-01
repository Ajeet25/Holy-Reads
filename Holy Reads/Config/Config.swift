//
//  DashBoardVC.swift
//  Sabjiwala
//
//  Created by Ritesh Jain on 12/06/18.
//  Copyright © 2018 OWeBest.com. All rights reserved.
//

import Foundation
import UIKit

class Config: NSObject,UIAlertViewDelegate {
    
    let API_URL = "http://i.devtechnosys.tech:8083/holyreads/api/"
    let Web_URl = "http://i.devtechnosys.tech:8083/holyreads/"
    
    let AppAlertTitle = "Holy Reads"
    let AppUserDefaults = UserDefaults.standard
    
    let debug_mode = 1
    let NO_IMAGE = "NoImage"
    
    let USER_NO_IMAGE = "NoImage"
    
   
    //    var imageArr: [UIImage] = [UIImage(named: "image1")!, UIImage(named: "image2")!, UIImage(named: "image3")!, UIImage(named: "image4")!, UIImage(named: "image5")!, UIImage(named: "image6")!, UIImage(named: "image7")!, UIImage(named: "image8")!, UIImage(named: "image9")!, UIImage(named: "image10")!, UIImage(named: "image11")!, UIImage(named: "image12")!]
    
    
    /********************************* App Color Codes ***************************************/
    let AppBackgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    let AppNavBlueColor = UIColor(red: 0/255, green: 188/255, blue: 252/255, alpha: 1.0)
    let AppGreenColor = UIColor(red: 44/255, green: 175/255, blue: 125/255, alpha: 1.0)
    let AppYellowColor = UIColor(red: 255/255, green: 242/255, blue: 63/255, alpha: 1.0)
    let AppBrownColor = UIColor(red: 231/255, green: 149/255, blue: 41/255, alpha: 1.0)
    let AppButtonGreenColor = UIColor(red: 70/255, green: 147/255, blue: 155/255, alpha: 1.0)
    let AppLineColor = UIColor.lightText
    let AppGrayColor = UIColor(white: 0xDCDCDC, alpha: 1.0)
    let AppBlackColor = UIColor.black
    let AppRedColor = UIColor(red: 233/255, green: 62/255, blue: 39/255, alpha: 1.0)
    let AppAppleColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
    let AppOrangeColor = UIColor(red: 254.0/255.0, green:
        153.0/255.0, blue: 37.0/255.0, alpha: 1.0)
    
    let AppWhiteColor = UIColor.white
    let AppClearColor = UIColor.clear
    
    func printData(_ dataValue : Any ){
        if debug_mode == 1 {
            print(dataValue)
        }
    }
    
    func AppGlobalFont(_ fontSize:CGFloat,isBold:Bool) -> UIFont {
        
        let fontName : String!
        fontName = (isBold) ? "Lato-Bold" : "Lato-Regular"
        
        return UIFont(name: fontName, size: fontSize)!
    }
    
    
}




