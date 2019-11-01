//
//  WebViewVC.swift
//  Holy Reads
//
//  Created by mac-14 on 02/09/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit
import LocalAuthentication

class WebViewVC: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var lblTittle: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var strTittle = ""
    var strURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let Url = Config().Web_URl + strURL
        lblTittle.text = strTittle
        let url = URL (string: Url)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    
    // MARK: - NavigationBar Buttons
    @IBAction func btnBack_DidSelect(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Web View Methods
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.isHidden = true
        activityIndicator.startAnimating()
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
