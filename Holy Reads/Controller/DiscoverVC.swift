//
//  DiscoverVC.swift
//  Holy Reads
//
//  Created by mac-14 on 31/08/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit
import SDWebImage
import IQKeyboardManagerSwift
class DiscoverVC: UIViewController, UITableViewDataSource, UITableViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblCategoryTitle: UILabel!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var tblDiscover: UITableView!
    @IBOutlet weak var CategoriesCollectionView: UICollectionView!
    @IBOutlet weak var lblSelectedCategoryTitle: UILabel!
    @IBOutlet weak var lblNoBookFound: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    // MARK: - Variable
    
    var arrBooksCategories = [[String:Any]]()
    var arrCategorizedBooksList = [[String:Any]]()
    var categoryId = String()
    var arrSearch = [[String:Any]]()
    var newString = ""
    var searched = false
    var selectedIndex = 0
 
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tblDiscover.rowHeight = UITableView.automaticDimension
        tblDiscover.estimatedRowHeight = 162
        
        let CategoriesLiberaryLayOut = UICollectionViewFlowLayout()
        CategoriesLiberaryLayOut.itemSize = CGSize(width: screenWidth/3, height: 160)
        CategoriesLiberaryLayOut.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
        CategoriesLiberaryLayOut.minimumInteritemSpacing = 0
        CategoriesLiberaryLayOut.minimumLineSpacing = 15
        CategoriesLiberaryLayOut.scrollDirection = .horizontal
        CategoriesCollectionView.collectionViewLayout = CategoriesLiberaryLayOut
        
        self.getCategoriesData()
        self.getCategorisedBookData(categoryID: "1")
    }
    override func viewWillAppear(_ animated: Bool) {
        
       // IQKeyboardManager.shared.enableAutoToolbar = false
     
    }
   // MARK: - IBAction
    
    @IBAction func btnSearch_DidSelect(_ sender: UIButton) {
        self.getSeachBook()
    }
 
     // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrBooksCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.layer.cornerRadius = 8
        if indexPath.row ==  selectedIndex {
            cell.layer.borderWidth = 2
            cell.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        } else{
            cell.layer.borderWidth = 1
            cell.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        if arrBooksCategories.count != 0{
            if let dict = arrBooksCategories[indexPath.row] as? [String:AnyObject] {
                if let title =  dict["title"] as? String{
                    cell.lblTitle.text = title
                }
                if let bookThumbnail =  dict["thumbnail_image"] as? String {
                    cell.imgBookThumbnail.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.imgBookThumbnail.startAnimating()
                    let url = URL.init(string: bookThumbnail)
                    cell.imgBookThumbnail.sd_setImage(with: url, placeholderImage: UIImage.init(named: ""), options: .refreshCached, completed: { (img, error, cacheType, url) in
                    })
                    cell.imgBookThumbnail.stopAnimating()
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        if let dict = DataManager.getVal(self.arrBooksCategories[indexPath.row]) as? [String:Any]{
            if let title = dict["title"] as? String{
                lblSelectedCategoryTitle.text = title
             }
            if let categoryId = dict["category_id"] as? Int{
                self.categoryId = String(categoryId)
                self.getCategorisedBookData(categoryID: self.categoryId)
            }
        }
       collectionView.reloadData()
        //        let obj = self.storyboard?.instantiateViewController(withIdentifier: "DiscoverDetailsVC") as! DiscoverDetailsVC
        //        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searched == true{
            return arrSearch.count
        } else{
            return arrCategorizedBooksList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PsychologyCell", for: indexPath) as! PsychologyCell
            if arrCategorizedBooksList.count != 0 {
                if let dict = arrCategorizedBooksList[indexPath.row] as? [String:AnyObject] {
                    tblDiscover.isHidden = false
                    lblNoBookFound.isHidden = true
                    if let title =  dict["book_title"] as? String{
                        cell.lblBookTitle.text = title
                    }
                    if let bookThumbnail =  dict["cover_image"] as? String {
                        cell.imgBook.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.imgBook.startAnimating()
                        let url = URL.init(string: bookThumbnail)
                        cell.imgBook.sd_setImage(with: url, placeholderImage: UIImage.init(named: ""), options: .refreshCached, completed: { (img, error, cacheType, url) in
                        })
                        cell.imgBook.stopAnimating()
                    }
                    if let authorName =  dict["author"] as? String{
                        cell.lblAuthorNAme.text = authorName
                    }
                    if let description =  dict["description"] as? String{
                        cell.lblDescription.text = description
                    }
                }
            } else{
                tblDiscover.reloadData()
                tblDiscover.isHidden = true
                lblNoBookFound.isHidden = false
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dict = DataManager.getVal(self.arrCategorizedBooksList[indexPath.row]) as? [String:Any]{
            if let bookId = dict["book_id"] as? Int{
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "DiscoverDetailsVC") as! DiscoverDetailsVC
                obj.bookId = bookId
                self.navigationController?.pushViewController(obj, animated: true)
            }
        }
    }
    
    // MARK: - Textfield Delegate
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if textField == txtSearch{
//            self.newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//            arrSearch = arrCategorizedBooksList.filter{(object) -> Bool in
//                if let allBook = object as? [String:Any] {
//                    if let filtered = allBook["book_title"] as? String {
//                        return filtered.lowercased().contains(newString)
//                    }
//                }
//                return false
//            }
//            if newString == ""{
//                searched = false
//            } else{
//                searched = true
//            }
//            tblDiscover.reloadData()
//            print("SearchedArray\(arrSearch)")
//            print("SearchedArrayCount\(arrSearch.count)")
//            // getSeachBook()
//        }
//        return true
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.endEditing(true)
        if textField == txtSearch {
            self.getSeachBook()
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField == txtSearch {
          self.getSeachBook()
        }
        return true
    }
    
    
    // MARK: - API CALLING (Book Category Type )
    func getCategoriesData(){
        self.showHud()
        let parameterDictionary = NSMutableDictionary()
        let methodName = "getBookCategories"
        
        DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
            let status  = DataManager.getVal(responseData?["status"]) as! String
            let message  = DataManager.getVal(responseData?["message"]) as! String
            
            if status == "1" {
                let response = DataManager.getVal(responseData?["data"]) as! [[String: Any]]
                self.arrBooksCategories = response
                if let dict = self.arrBooksCategories[0] as? [String:Any] {
                    if let title =  dict["title"] as? String{
                        self.lblCategoryTitle.text = title
                    }
                }
                self.CategoriesCollectionView.reloadData()
            } else{
                self.view.makeToast(message: message)
            }
            self.clearHud()
        }
    }
    
    // MARK: - API CALLING (Book Categorised Book Data)
    func getCategorisedBookData(categoryID: String){
        self.showHud()
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setValue(categoryID, forKey: "category_id")
        let methodName = "getBooksAccCategories"
        
        DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
            let status  = DataManager.getVal(responseData?["status"]) as! String
            let message = DataManager.getVal(responseData?["message"]) as! String
            self.arrCategorizedBooksList.removeAll()
            if status == "1" {
                let response = DataManager.getVal(responseData?["data"]) as! [[String: Any]]
                self.arrCategorizedBooksList = response
                self.tblDiscover.reloadData()
            } else{
                self.tblDiscover.reloadData()
                self.tblDiscover.isHidden = true
                self.lblNoBookFound.isHidden = false
                self.view.makeToast(message: message)
            }
            self.clearHud()
        }
    }
    
    // MARK: - API CALLING (Search Book)
    func getSeachBook(){
        self.showHud()
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setValue(txtSearch.text, forKey: "search")
        if categoryId == ""{
            parameterDictionary.setValue("1", forKey: "category_id")
        }else{
            parameterDictionary.setValue(categoryId, forKey: "category_id")
        }
       
        let methodName = "searchResults"
        
        DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
            let status  = DataManager.getVal(responseData?["status"]) as! String
            let message = DataManager.getVal(responseData?["message"]) as! String
            self.arrCategorizedBooksList.removeAll()
            if status == "1" {
                let response = DataManager.getVal(responseData?["data"]) as! [[String: Any]]
                self.arrCategorizedBooksList = response
                self.tblDiscover.reloadData()
            } else{
                self.tblDiscover.reloadData()
                self.tblDiscover.isHidden = true
                self.lblNoBookFound.isHidden = false
                self.view.makeToast(message: message)
            }
            self.clearHud()
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




