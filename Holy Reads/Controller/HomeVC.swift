//
//  HomeVC.swift
//  Holy Reads
//
//  Created by mac-14 on 30/08/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SDWebImage
import Alamofire


class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var VideoCollectionView: UICollectionView!
    @IBOutlet weak var CategoriesCollectionView: UICollectionView!
    @IBOutlet weak var RecommendedCollectionView: UICollectionView!
    @IBOutlet weak var CuratedCollectionView: UICollectionView!
    @IBOutlet weak var MostPopularCollectionView: UICollectionView!
    @IBOutlet weak var LatestCollectionView: UICollectionView!
    
    // MARK: - Variable
    
    var arrBooksCategories = [[String:Any]] ()
    var arrCuratedBookList = [[String:Any]] ()
    var arrLatestBook = [[String:Any]] ()
    var arrMostPopularBook = [[String:Any]] ()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createThumbnailOfVideoFromRemoteUrl(url: "http://i.devtechnosys.tech:8083/holyreads/webroot/summary/video/1568703681_summary_.mp4")
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let LiberaryLayOut = UICollectionViewFlowLayout()
        LiberaryLayOut.itemSize = CGSize(width: screenWidth/1.2, height: 150)
        LiberaryLayOut.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 30)
        LiberaryLayOut.minimumInteritemSpacing = 0
        LiberaryLayOut.minimumLineSpacing = 15
        LiberaryLayOut.scrollDirection = .horizontal
        
        VideoCollectionView.collectionViewLayout = LiberaryLayOut
        
        let CategoriesLiberaryLayOut = UICollectionViewFlowLayout()
        CategoriesLiberaryLayOut.itemSize = CGSize(width: screenWidth/2.8, height: 160)
        CategoriesLiberaryLayOut.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
        CategoriesLiberaryLayOut.minimumInteritemSpacing = 0
        CategoriesLiberaryLayOut.minimumLineSpacing = 15
        CategoriesLiberaryLayOut.scrollDirection = .horizontal
        
        CategoriesCollectionView.collectionViewLayout = CategoriesLiberaryLayOut
        
        let RecommendedLiberaryLayOut = UICollectionViewFlowLayout()
        RecommendedLiberaryLayOut.itemSize = CGSize(width: screenWidth/2.6, height: 275)
        RecommendedLiberaryLayOut.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
        RecommendedLiberaryLayOut.minimumInteritemSpacing = 0
        RecommendedLiberaryLayOut.minimumLineSpacing = 15
        RecommendedLiberaryLayOut.scrollDirection = .horizontal
        
        RecommendedCollectionView.collectionViewLayout = RecommendedLiberaryLayOut
        
        let CuratedLiberaryLayOut = UICollectionViewFlowLayout()
        CuratedLiberaryLayOut.itemSize = CGSize(width: screenWidth-30, height: 285)
        CuratedLiberaryLayOut.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
        CuratedLiberaryLayOut.minimumInteritemSpacing = 0
        CuratedLiberaryLayOut.minimumLineSpacing = 15
        CuratedLiberaryLayOut.scrollDirection = .horizontal
        
        CuratedCollectionView.collectionViewLayout = CuratedLiberaryLayOut
        
        let MostPopularLiberaryLayOut = UICollectionViewFlowLayout()
        MostPopularLiberaryLayOut.itemSize = CGSize(width: screenWidth/2.6, height: 275)
        MostPopularLiberaryLayOut.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
        MostPopularLiberaryLayOut.minimumInteritemSpacing = 0
        MostPopularLiberaryLayOut.minimumLineSpacing = 15
        MostPopularLiberaryLayOut.scrollDirection = .horizontal
        
        MostPopularCollectionView.collectionViewLayout = MostPopularLiberaryLayOut
        
        let LatestLiberaryLayOut = UICollectionViewFlowLayout()
        LatestLiberaryLayOut.itemSize = CGSize(width: screenWidth/2.6, height: 275)
        LatestLiberaryLayOut.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
        LatestLiberaryLayOut.minimumInteritemSpacing = 0
        LatestLiberaryLayOut.minimumLineSpacing = 15
        LatestLiberaryLayOut.scrollDirection = .horizontal
        
        LatestCollectionView.collectionViewLayout = LatestLiberaryLayOut
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getHomeData()
    }
    // MARK: - NavigationBar Buttons
    
    @IBAction func btnNotification_DidSelect(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
 
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == CategoriesCollectionView{
            return arrBooksCategories.count
        }else if collectionView == CuratedCollectionView  {
            return arrCuratedBookList.count
        } else if collectionView == LatestCollectionView  {
            return arrLatestBook.count
        } else if collectionView == MostPopularCollectionView  {
            return arrMostPopularBook.count
        } else{
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == VideoCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
            //            if let url = "http://i.devtechnosys.tech:8083/holyreads/webroot/summary/video/1568628875_summary_.mp4" as? String {
            //                let videoURL = URL(string: url)!
            //                cell.player = AVPlayer(url: videoURL)
            //                cell.avpController = AVPlayerViewController()
            //                cell.avpController.player = cell.player
            //                cell.avpController.view.frame.size.width = cell.viewVideo.frame.size.width
            //                cell.avpController.view.frame.size.height = cell.viewVideo.frame.size.height
            //                self.addChild(cell.avpController)
            //                cell.viewVideo.addSubview(cell.avpController.view)
            //                //cell.player.play()
            //            }
            //            let url = URL(string: "http://www.youtube.com/watch?v=zPP6lXaL7KA&feature=youtube_gdata_player")
            //            cell.player = AVPlayer(url: url!)
            //            cell.avpController.player = cell.player
            //            cell.avpController.view.frame.size.height = cell.VideoImgView.frame.size.height
            //            cell.avpController.view.frame.size.width = cell.VideoImgView.frame.size.width
            //            cell.VideoImgView.addSubview(cell.avpController.view)
            //            //cell.avpController.player?.play()
            cell.layer.cornerRadius = 8
            return cell
        } else if collectionView == RecommendedCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCell", for: indexPath) as! RecommendedCell
            cell.layer.borderWidth = 1
            cell.layer.borderColor = #colorLiteral(red: 0.8901960784, green: 0.9098039216, blue: 0.9176470588, alpha: 1)
            cell.layer.cornerRadius = 8
            return cell
        } else if collectionView == CategoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            cell.layer.borderWidth = 1
            cell.layer.borderColor = #colorLiteral(red: 0.8901960784, green: 0.9098039216, blue: 0.9176470588, alpha: 1)
            cell.layer.cornerRadius = 8
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
            return cell
        } else if collectionView == CuratedCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuratedCell", for: indexPath) as! CuratedCell
            cell.layer.cornerRadius = 8
            cell.btnNext.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
            cell.btnPrevious.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
            if let dict = arrCuratedBookList[indexPath.row] as? [String:AnyObject] {
                // To hide Arrows of left & right
                if indexPath.row + 1 == dict.count {
                    cell.btnNext.isHidden = true
                } else {
                    cell.btnNext.isHidden = false
                }
                if indexPath.row == 0 {
                    cell.btnPrevious.isHidden = true
                } else{
                    cell.btnPrevious.isHidden = false
                }
                if let title =  dict["book_title"] as? String{
                    cell.lblBookTitle.text = title
                }
                // Setting Data
                
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
                    // cell.lblDescription.text = description
                }
            }
            return cell
        } else if collectionView == MostPopularCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCell", for: indexPath) as! RecommendedCell
            cell.layer.borderWidth = 1
            cell.layer.borderColor = #colorLiteral(red: 0.8901960784, green: 0.9098039216, blue: 0.9176470588, alpha: 1)
            cell.layer.cornerRadius = 8
            
            if let dict = arrMostPopularBook[indexPath.row] as? [String:AnyObject] {
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
                    // cell.lblDescription.text = description
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCell", for: indexPath) as! RecommendedCell
            cell.layer.cornerRadius = 8
            cell.layer.borderWidth = 1
            cell.layer.borderColor = #colorLiteral(red: 0.8901960784, green: 0.9098039216, blue: 0.9176470588, alpha: 1)
            
            if let dict = arrLatestBook[indexPath.row] as? [String:AnyObject] {
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
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == VideoCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
            cell.player.play()
        }
    }
    
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var book_id = Int()
        if collectionView == CategoriesCollectionView{
            //            let dict = DataManager.getVal(self.arrBooksCategories[indexPath.row]) as! NSDictionary
            //            //            let cat_id = DataManager.getVal(dict["category_id"]) as! String
            //            //            let title = DataManager.getVal(dict["title"]) as! String
            //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DiscoverVC") as! DiscoverVC
            //            //            vc.categoryId = cat_id
            //            //            vc.cat_title = title
            //            self.navigationController?.pushViewController(vc, animated: true)
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
            obj.selectedIndex = 1
            self.navigationController?.pushViewController(obj, animated: true)
        }
        if collectionView == CuratedCollectionView{
            if let dict = DataManager.getVal(self.arrCuratedBookList[indexPath.row]) as? [String:Any]{
                if let bookId = dict["book_id"] as? Int{
                    book_id  = bookId
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "DiscoverDetailsVC") as! DiscoverDetailsVC
                    obj.bookId = book_id
                    self.navigationController?.pushViewController(obj, animated: true)
                }
            }
        }
        if collectionView == MostPopularCollectionView{
            if let dict = DataManager.getVal(self.arrMostPopularBook[indexPath.row]) as? [String:Any]{
                if let bookId = dict["book_id"] as? Int{
                    book_id  = bookId
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "DiscoverDetailsVC") as! DiscoverDetailsVC
                    obj.bookId = book_id
                    self.navigationController?.pushViewController(obj, animated: true)
                }
            }
        }
        if collectionView == LatestCollectionView{
            if let dict = DataManager.getVal(self.arrLatestBook[indexPath.row]) as? [String:Any]{
                if let bookId = dict["book_id"] as? Int{
                    book_id  = bookId
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "DiscoverDetailsVC") as! DiscoverDetailsVC
                    obj.bookId = book_id
                    self.navigationController?.pushViewController(obj, animated: false)
                }
            }
        }
        
    }
    
    //        if collectionView == CategoriesCollectionView{
    //            if let dict = DataManager.getVal(self.arrBooksCategories[indexPath.row]) as? [String:Any]{
    //                if let bookId = dict["category_id"] as? Int{
    //                    book_id  = bookId
    //                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "DiscoverDetailsVC") as! DiscoverDetailsVC
    //                    obj.bookId = book_id
    //                    self.navigationController?.pushViewController(obj, animated: true)
    //                }
    //            }
    //        }
    
    //    }
    
    @objc func nextButtonTapped(_ sender : UIButton) {
        let visibleItems: NSArray = self.CuratedCollectionView.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        if nextItem.row < arrCuratedBookList.count {
            self.CuratedCollectionView.scrollToItem(at: nextItem, at: .left, animated: true)
        }
    }
    @objc func previousButtonTapped(_ sender : UIButton) {
        let visibleItems: NSArray = self.CuratedCollectionView.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
        if nextItem.row < arrCuratedBookList.count && nextItem.row >= 0{
            self.CuratedCollectionView.scrollToItem(at: nextItem, at: .right, animated: true)
        }
    }
    
    func createThumbnailOfVideoFromRemoteUrl(url: String) -> UIImage? {
        let asset = AVAsset(url: URL(string:url )!)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        //Can set this to improve performance if target size is known before hand
        //assetImgGenerate.maximumSize = CGSize(width,height)
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Home API CALLING
    
    func getHomeData(){
        self.showHud()
        let parameterDictionary = NSMutableDictionary()
        let methodName = "getHomeData"
        
        DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
            let status  = DataManager.getVal(responseData?["status"]) as! String
            let message  = DataManager.getVal(responseData?["message"]) as! String
            
            if status == "1" {
                let response = DataManager.getVal(responseData?["data"]) as! [String: Any]
                if let categories = response["categories"] as? [[String:Any]] {
                    self.arrBooksCategories = categories
                    self.CategoriesCollectionView.reloadData()
                }
                if let curatedList = response["curated_list"] as? [[String:Any]] {
                    self.arrCuratedBookList = curatedList
                    self.CuratedCollectionView.reloadData()
                }
                if let latest = response["latest"] as? [[String:Any]] {
                    self.arrLatestBook = latest
                    self.LatestCollectionView.reloadData()
                }
                if let mostPopular = response["most_popular"] as? [[String:Any]] {
                    self.arrMostPopularBook = mostPopular
                    self.MostPopularCollectionView.reloadData()
                }
            } else{
                self.view.makeToast(message: message)
            }
            self.clearHud()
        }
    }
}




