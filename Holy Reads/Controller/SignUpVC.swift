//
//  SignUpVC.swift
//  Holy Reads
//
//  Created by mac-14 on 30/08/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    // MARK: - IBOutlet
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnSelectProfilePic: UIButton!
    
    //MARK: - Variables
    let imagePicker = UIImagePickerController()
    var imageData = Data()
    
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imgProfile.layer.cornerRadius = self.imgProfile.frame.height/2
        btnSelectProfilePic.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    // MARK: - IBAction
    @IBAction func btnTermsCondition(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        obj.strTittle = "Terms & Conditions"
        obj.strURL = "pages/mobile_terms"
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
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
    
    @IBAction func btnSubmit_DidSelect(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if ValidationClass().ValidateSignUpForm(self){
            self.showHud()
            
            let parameterDictionary = NSMutableDictionary()
            parameterDictionary.setValue(DataManager.getVal(txtEmail.text!) as! String, forKey: "email")
            parameterDictionary.setValue(DataManager.getVal(txtPassword.text!) as! String, forKey: "password")
            print(parameterDictionary)
 
            let methodName = "signup"
            
            if imgProfile.image == nil {
                DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
                    let status  = DataManager.getVal(responseData?["status"]) as! String
                    let message  = DataManager.getVal(responseData?["message"]) as! String
                    if status == "1" {
                        if status == "1" {
                            let response = DataManager.getVal(responseData?["data"]) as! [String: Any]
                            DataManager.saveinDefaults(response)
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
                            self.navigationController?.pushViewController(obj, animated: true)
                            // Config().AppUserDefaults.set(true, forKey: "isCurrentUser")
                        }
                        else{
                            self.view.makeToast(message: message)
                        }
                    self.clearHud()
                    } else if status == "0" {
                        self.clearHud()
                       self.view.makeToast(message: message)
                        // self.view.makeToast(message: message)
                    }
                }
            } else {
                //For upload image
                let dataArr = NSMutableArray()
                let dataDict = NSMutableDictionary()
                dataDict.setObject("profile_picture", forKey: "image" as NSCopying)
                dataDict.setObject(resize(self.imgProfile.image!).pngData()!, forKey: "imageData" as NSCopying)
                dataDict.setObject("png", forKey: "ext" as NSCopying)
                dataArr.add(dataDict)
                
                DataManager.getAPIResponseFileSingleImage(parameterDictionary, methodName: methodName as NSString ,dataArray: dataArr){(responseData,error)-> Void in
                    let status  = DataManager.getVal(responseData?["status"]) as! String
                    let message  = DataManager.getVal(responseData?["message"]) as! String
                    
                    if status == "1" {
                        let response = DataManager.getVal(responseData?["data"]) as! [String: Any]
                        DataManager.saveinDefaults(response)
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
                        self.navigationController?.pushViewController(obj, animated: true)
                    } else{
                        self.view.makeToast(message: message)
                    }
                    self.clearHud()
                }
            }
        }
    }
    
    @IBAction func btnSignIn_DidSelect(_ sender: UIButton){
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnAgree_didSelect(_ sender: UIButton) {
        self.view.endEditing(true)
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btnAcceptTermsConditions_DidSelect(_ sender: UIButton) {
        
    }
    
    @IBAction func btnClose_DidSelect(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[.originalImage] as? UIImage
        imgProfile.image = pickedImage
        if imgProfile != nil{
            btnSelectProfilePic.setImage(UIImage.init(named: ""), for: .normal)
        }
        imageData = pickedImage?.jpegData(compressionQuality: 0.8)! ?? Data()
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func cancel(){
        print("Cancel Clicked")
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

