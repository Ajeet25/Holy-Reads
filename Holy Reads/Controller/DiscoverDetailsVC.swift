//
//  DiscoverDetailsVC.swift
//  Holy Reads
//
//  Created by mac-14 on 31/08/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit
import SDWebImage
import FolioReaderKit

enum Epub: Int {
    case bookOne = 0
    case bookTwo
    
    var name: String {
        switch self {
        case .bookOne:      return "The" // standard eBook
        case .bookTwo:      return "The Silver Chair" // audio-eBook
        }
    }
    
    var shouldHideNavigationOnTap: Bool {
        switch self {
        case .bookOne:      return false
        case .bookTwo:      return true
        }
    }
    
    var scrollDirection: FolioReaderScrollDirection {
        switch self {
        case .bookOne:      return .vertical
        case .bookTwo:      return .horizontal
        }
    }
    
    var bookPath: String? {
        let a = Bundle.main.path(forResource:  self.name, ofType: "epub")
        print(a)
        return a
    }
    
    var readerIdentifier: String {
        switch self {
        case .bookOne:      return "READER_ONE"
        case .bookTwo:      return "READER_TWO"
        }
    }
}

class DiscoverDetailsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - IBOutlet
    @IBOutlet weak var tblDiscoverDetails: UITableView!
    @IBOutlet weak var imgBook: UIImageView!
    @IBOutlet weak var imgBookCover: UIImageView!
    @IBOutlet weak var lblBookTitle: UILabel!
    @IBOutlet weak var lblAuthorNAme: UILabel!
    
    var bookId = Int()
    var dictBookDetails = [String: Any]()
    let folioReader = FolioReader()
     // MARK: - ViewLifeCycle
    var cat_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblDiscoverDetails.rowHeight = UITableView.automaticDimension
        tblDiscoverDetails.estimatedRowHeight = 70
        UIAccessibility.requestGuidedAccessSession(enabled: true){
            success in
            print("Request guided access success \(success)")
        }
   
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getBookDetail()
    }
    
    func open(epub: Epub) {
        guard let bookPath = epub.bookPath else {
            return
        }
        
        let readerConfiguration = self.readerConfiguration(forEpub: epub)
        folioReader.presentReader(parentViewController: self, withEpubPath: bookPath, andConfig: readerConfiguration, shouldRemoveEpub: false)
    }
    private func readerConfiguration(forEpub epub: Epub) -> FolioReaderConfig {
        let config = FolioReaderConfig(withIdentifier: epub.readerIdentifier)
        config.shouldHideNavigationOnTap = epub.shouldHideNavigationOnTap
        config.scrollDirection = epub.scrollDirection
        
        // See more at FolioReaderConfig.swift
        //        config.canChangeScrollDirection = false
        //        config.enableTTS = false
        //        config.displayTitle = true
        //        config.allowSharing = false
        //        config.tintColor = UIColor.blueColor()
        //        config.toolBarTintColor = UIColor.redColor()
        //        config.toolBarBackgroundColor = UIColor.purpleColor()
        //        config.menuTextColor = UIColor.brownColor()
        //        config.menuBackgroundColor = UIColor.lightGrayColor()
        //        config.hidePageIndicator = true
        //        config.realmConfiguration = Realm.Configuration(fileURL: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("highlights.realm"))
        
        // Custom sharing quote background
        config.quoteCustomBackgrounds = []
        if let image = UIImage(named: "demo-bg") {
            let customImageQuote = QuoteImage(withImage: image, alpha: 0.6, backgroundColor: UIColor.black)
            config.quoteCustomBackgrounds.append(customImageQuote)
        }
        
        let textColor = UIColor(red:0.86, green:0.73, blue:0.70, alpha:1.0)
        let customColor = UIColor(red:0.30, green:0.26, blue:0.20, alpha:1.0)
        let customQuote = QuoteImage(withColor: customColor, alpha: 1.0, textColor: textColor)
        config.quoteCustomBackgrounds.append(customQuote)
        
        return config
    }

    
     // MARK: - NavigationBar Buttons
    @IBAction func btnBack_DidSelect(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - IBAction
    
    @IBAction func btnRead_DidSelect(_ sender: UIButton) {
        guard let epub = Epub(rawValue: 1) else {
            return
        }
        self.open(epub: epub)
       // let obj = self.storyboard?.instantiateViewController(withIdentifier: "ReadListVC") as! ReadListVC
//        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ReadVC") as! ReadVC
//        obj.dictBookDetails = self.dictBookDetails
//        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnListin_DidSelect(_ sender: UIButton) {
        
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ListinMusicVC") as! ListinMusicVC
            obj.dictBookDetails = self.dictBookDetails
            self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnWatch_DidSelect(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "WatchVideoVC") as! WatchVideoVC
        obj.dictBookDetails = self.dictBookDetails
        self.navigationController?.pushViewController(obj, animated: true)
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IntroductionCell", for: indexPath) as! IntroductionCell
        if let description =  dictBookDetails["description"] as? String {
            cell.lblDescription.text = description
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    //MARK:- Get Book Detail Api Calling
    func getBookDetail(){
        self.showHud()
        let parameterDictionary = NSMutableDictionary()
        parameterDictionary.setValue(bookId, forKey: "book_id")
        let methodName = "getBookDetail"
        
        DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
            let status  = DataManager.getVal(responseData?["status"]) as! String
            let message  = DataManager.getVal(responseData?["message"]) as! String
            
            if status == "1" {
                if let response = DataManager.getVal(responseData?["data"]) as? [String: Any]{
                    self.dictBookDetails = response
                    self.setBookDetails()
                    self.tblDiscoverDetails.reloadData()
                }
            } else{
                self.view.makeToast(message: message)
            }
            self.clearHud()
        }
    }
    
    func setBookDetails() {
        if let title =  dictBookDetails["book_title"] as? String{
            lblBookTitle.text = title
        }
        if let author =  dictBookDetails["author"] as? String{
            lblAuthorNAme.text = author
        }
        if let bookThumbnail =  dictBookDetails["cover_image"] as? String {
            self.imgBook.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imgBook.startAnimating()
            let url = URL.init(string: bookThumbnail)
            self.imgBook.sd_setImage(with: url, placeholderImage: UIImage.init(named: ""), options: .refreshCached, completed: { (img, error, cacheType, url) in
            })
            self.imgBookCover.sd_setImage(with: url, placeholderImage: UIImage.init(named: ""), options: .refreshCached, completed: { (img, error, cacheType, url) in
            })
            self.imgBook.stopAnimating()
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
extension FolioReader {
    
    /// Present a Folio Reader Container modally on a Parent View Controller.
    ///
    /// - Parameters:
    ///   - parentViewController: View Controller that will present the reader container.
    ///   - epubPath: String representing the path on the disk of the ePub file. Must not be nil nor empty string.
    ///   - unzipPath: Path to unzip the compressed epub.
    ///   - config: FolioReader configuration.
    ///   - shouldRemoveEpub: Boolean to remove the epub or not. Default true.
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    open func presentReader(parentViewController: UIViewController, withEpubPath epubPath: String, unzipPath: String? = nil, andConfig config: FolioReaderConfig, shouldRemoveEpub: Bool = true, animated:
        Bool = true) {
        let readerContainer = FolioReaderContainer(withConfig: config, folioReader: self, epubPath: epubPath, unzipPath: unzipPath, removeEpub: shouldRemoveEpub)
        self.readerContainer = readerContainer
        parentViewController.present(readerContainer, animated: animated, completion: nil)
        
    }
}
