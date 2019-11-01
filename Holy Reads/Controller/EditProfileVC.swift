//
//  EditProfileVC.swift
//  Holy Reads
//
//  Created by mac-14 on 02/09/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit
import SDWebImage

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

     // MARK: - IBOutlet
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    
    //MARK: - Variables
    let imagePicker = UIImagePickerController()
    var imageData = Data()
    var dicUserDetails = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        getProfileData()
    }
    
    // MARK: - NavigationBar Buttons
    @IBAction func btnBack_DidSelect(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - IBAction
    
    @IBAction func btnEditProfilePhoto(_ sender: UIButton) {
        let alert:UIAlertController = UIAlertController(title: "Choose", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertAction.Style.default) {
            
            UIAlertAction in self.appDelegate.checkGalleryPermission{(GalleryPermission) in
                if GalleryPermission {
                    self.openGallary()
                }
            }
        }
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) {
            UIAlertAction in self.appDelegate.checkCameraPermission{(cameraPermission) in
                if cameraPermission {
                    self.openCamera()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        
        alert.addAction(gallaryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openGallary() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera Not Present")
        }
    }
    
    @IBAction func btnUpdate_DidSelect(_ sender: UIButton) {
            self.view.endEditing(true)
            if ValidationClass().ValidateEditProfileForm(self){
                self.showHud()
                let parameterDictionary = NSMutableDictionary()
                
                let user_id = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as! String
                
                parameterDictionary.setValue(DataManager.getVal(txtUserName.text!) as! String, forKey: "username")
                parameterDictionary.setValue(DataManager.getVal(user_id) as! String, forKey: "user_id")
                parameterDictionary.setValue(DataManager.getVal(txtEmail.text) as! String, forKey: "email")

                print(parameterDictionary)
                
                //For upload image
                let dataArr = NSMutableArray()
                let dataDict = NSMutableDictionary()
                dataDict.setObject("profile_picture", forKey: "image" as NSCopying)
                dataDict.setObject(resize(self.imgProfile.image!).pngData()!, forKey: "imageData" as NSCopying)
                dataDict.setObject("png", forKey: "ext" as NSCopying)
                dataArr.add(dataDict)
                
                let methodName = "edit_profile"
                
                DataManager.getAPIResponseFileSingleImage(parameterDictionary, methodName: methodName as NSString ,dataArray: dataArr){(responseData,error)-> Void in
                    let status  = DataManager.getVal(responseData?["status"]) as! String
                    let message  = DataManager.getVal(responseData?["message"]) as! String
                    
                    if status == "1" {
                        let response = DataManager.getVal(responseData?["data"]) as! [String: Any]
                        DataManager.saveinDefaults(response)
                       self.navigationController?.popViewController(animated: true)
                        // Config().AppUserDefaults.set(true, forKey: "isCurrentUser")
                    } else{
                        self.view.makeToast(message: message)
                    }
                    self.clearHud()
                }
            }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[.originalImage] as? UIImage
        imgProfile.image = pickedImage
        imageData = pickedImage?.jpegData(compressionQuality: 0.8)! ?? Data()
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func cancel(){
        print("Cancel Clicked")
    }
    
    
    //MARK:- API Calling
    func getProfileData() {
        self.showHud()
        let parameterDictionary = NSMutableDictionary()
        let userId = DataManager.getVal(Config().AppUserDefaults.value(forKey: "user_id")) as! String
        parameterDictionary.setValue(userId, forKey: "user_id")
        
        let methodName = "profile_details"
        
        DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
            let status  = DataManager.getVal(responseData?["status"]) as! String
            let message  = DataManager.getVal(responseData?["message"]) as! String
            
            if status == "1" {
                let response = DataManager.getVal(responseData?["data"]) as! [String: Any]
                self.dicUserDetails = response
                self.setProfileData()
                
            }else{
                self.view.makeToast(message: message)
            }
            self.clearHud()
        }
    }
    
    func setProfileData()  {
        self.txtUserName.text = dicUserDetails["username"] as? String
        self.txtEmail.text =  dicUserDetails["email"] as? String
        if let profileImg = dicUserDetails["profile_picture"] as? String
        {
            self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let url = URL.init(string: profileImg)
            self.imgProfile.sd_setImage(with: url, placeholderImage: UIImage.init(named: ""), options: .refreshCached, completed: { (img, error, cacheType, url) in
            })
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
