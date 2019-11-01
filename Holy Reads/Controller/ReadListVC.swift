//
//  ReadListVC.swift
//  Holy Reads
//
//  Created by mac-14 on 31/08/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit

class ReadListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - IBOutlet
    @IBOutlet weak var tblReadList: UITableView!
    @IBOutlet weak var viewMenu: UIView!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tblReadList.rowHeight = UITableView.automaticDimension
        tblReadList.estimatedRowHeight = 35
        viewMenu.addShadowView()
    }
    
    // MARK: - NavigationBar Buttons
    @IBAction func btnBack_DidSelect(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadListCell", for: indexPath) as! ReadListCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ReadVC") as! ReadVC
        self.navigationController?.pushViewController(obj, animated: true)
        
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
