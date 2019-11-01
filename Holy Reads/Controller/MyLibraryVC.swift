//
//  MyLibraryVC.swift
//  Holy Reads
//
//  Created by mac-14 on 31/08/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit

class MyLibraryVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate { 
    
    // MARK: - IBOutlet
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var LibariryTypeCollectionView: UICollectionView!
    @IBOutlet weak var LibariryCollectionView: UICollectionView!
    @IBOutlet weak var tblMyNotesHighlights: UITableView!
    

    var arrTypes = ["COMPLETED","READING NOW","MY FAVORITES","MY NOTES AND HIGHLIGHTS"]
    fileprivate var selectedCell: Int = 0
    var Liked = Bool()
    
     // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tblMyNotesHighlights.rowHeight = UITableView.automaticDimension
        tblMyNotesHighlights.estimatedRowHeight = 35
        
        let LibariryTypeLayOut = UICollectionViewFlowLayout()
        LibariryTypeLayOut.itemSize = CGSize(width: 170, height: 40)
        LibariryTypeLayOut.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        LibariryTypeLayOut.minimumInteritemSpacing = 0
        LibariryTypeLayOut.minimumLineSpacing = 5
        LibariryTypeLayOut.scrollDirection = .horizontal
        
        LibariryTypeCollectionView.collectionViewLayout = LibariryTypeLayOut
        
        let LibariryLayOut = UICollectionViewFlowLayout()
        LibariryLayOut.itemSize = CGSize(width: screenWidth/2 - 40, height: 300)
        LibariryLayOut.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
        LibariryLayOut.minimumInteritemSpacing = 10
        LibariryLayOut.minimumLineSpacing = 10
        LibariryLayOut.scrollDirection = .vertical
        
        LibariryCollectionView.collectionViewLayout = LibariryLayOut
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == LibariryTypeCollectionView {
        return arrTypes.count
        } else{
            return 20
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == LibariryTypeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyLibraryCell", for: indexPath) as! MyLibraryCell

            cell.lblType.text = arrTypes[indexPath.row]
            cell.tag = indexPath.row
            if selectedCell == indexPath.row {
                cell.lblType.textColor = #colorLiteral(red: 0.9960784314, green: 0.6, blue: 0.1450980392, alpha: 1)
                cell.viewLibraryType.layer.borderColor = #colorLiteral(red: 0.9960784314, green: 0.6, blue: 0.1450980392, alpha: 1)
            } else {
                cell.lblType.textColor = #colorLiteral(red: 0.1644093692, green: 0.2676883936, blue: 0.3667172194, alpha: 1)
                cell.viewLibraryType.layer.borderColor = #colorLiteral(red: 0.1644093692, green: 0.2676883936, blue: 0.3667172194, alpha: 1)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
            
            cell.tag = indexPath.row
            if Liked == true{
                cell.btnLike.isHidden = false
            }else{
                cell.btnLike.isHidden = true
            }
            
            cell.layer.cornerRadius = 8
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        

        if collectionView == LibariryTypeCollectionView{
            selectedCell = indexPath.row
            self.LibariryTypeCollectionView.reloadData()
            
            if indexPath.row == 0{
                self.Liked = false
                tblMyNotesHighlights.isHidden = true
                viewSearch.isHidden = true
                LibariryCollectionView.isHidden = false
                LibariryCollectionView.reloadData()
                
            } else if indexPath.row == 1{
                self.Liked = false
                tblMyNotesHighlights.isHidden = true
                viewSearch.isHidden = true
                LibariryCollectionView.isHidden = false
                LibariryCollectionView.reloadData()
                
            } else if indexPath.row == 2{
                self.Liked = true
                tblMyNotesHighlights.isHidden = true
                viewSearch.isHidden = true
                LibariryCollectionView.isHidden = false
                LibariryCollectionView.reloadData()
                
            } else if indexPath.row == 3{
                self.Liked = false
                tblMyNotesHighlights.isHidden = false
                viewSearch.isHidden = false
                LibariryCollectionView.isHidden = true
                LibariryCollectionView.reloadData()
                tblMyNotesHighlights.reloadData()
            }
            
        }else{
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath) as! PlanCell
        return cell
    }

    
}

