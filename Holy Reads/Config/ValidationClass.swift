//
//  ValidationClass.swift
//  Samksa
//
//  Created by Mac Mini on 17/12/14.
//  Copyright (c) 2014 Fullestop. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}

class ValidationClass: NSObject {
    
    func validateUrl (_ stringURL : NSString) -> Bool {
        let urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        //let urlTest = NSPredicate.predicateWithSubstitutionVariables(predicate)
        
        return predicate.evaluate(with: stringURL)
    }
    
    func isBlank(_ textfield:UITextField) -> Bool {
        let thetext = textfield.text
        let trimmedString = thetext!.trimmingCharacters(in: CharacterSet.whitespaces)
        if trimmedString.isEmpty {
            return true
        }
        return false
    }
    
    func isTextViewBlank(_ textview:UITextView) -> Bool {
        
        if textview.text.isEmpty {
            return true
        }
        return false
    }
    func isValidEmail(_ EmailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = EmailStr.range(of: emailRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return !result
    }
    
    
    func isValidPWD(_ PwdStr:String) -> Bool {
        let PwdRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{10,}"
        let range = PwdStr.range(of: PwdRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return !result
    }
    
    func ValidateSignInForm(_ loginVCValidateObj:SignInVC) -> Bool {
        if isBlank(loginVCValidateObj.txtEmail) {
            loginVCValidateObj.view.makeToast(message: "Please enter your email")
            loginVCValidateObj.view.endEditing(true)
            return false
        } else if isValidEmail(loginVCValidateObj.txtEmail.text!){
            loginVCValidateObj.view.makeToast(message: "Please enter a valid email")
            loginVCValidateObj.view.endEditing(true)
            return false
        } else if isBlank(loginVCValidateObj.txtPassword) {
            loginVCValidateObj.view.makeToast(message: "Please enter your password.")
            loginVCValidateObj.view.endEditing(true)
            return false
        } else {
            return true
        }
    }
    
    func ValidateSignUpForm(_ signupVCValidateObj:SignUpVC) -> Bool {
        
        if isBlank(signupVCValidateObj.txtEmail) {
            signupVCValidateObj.view.makeToast(message: "Please enter email")
            signupVCValidateObj.view.endEditing(true)
            return false
        } else if isValidEmail(signupVCValidateObj.txtEmail.text ?? ""){
            signupVCValidateObj.view.makeToast(message: "Please enter a valid email")
            signupVCValidateObj.view.endEditing(true)
            return false
        }
        else if isBlank(signupVCValidateObj.txtPassword) {
            signupVCValidateObj.view.makeToast(message: "Please enter password")
            signupVCValidateObj.view.endEditing(true)
            return false
        } else if signupVCValidateObj.txtPassword.text!.count < 6 {
            signupVCValidateObj.view.makeToast(message: "Password must contain minimum 6 characters")
            signupVCValidateObj.view.endEditing(true)
            return false
        } else if isBlank(signupVCValidateObj.txtConfirmPassword) {
            signupVCValidateObj.view.makeToast(message: "Please enter confirm password")
            signupVCValidateObj.view.endEditing(true)
            return false
        } else if signupVCValidateObj.txtConfirmPassword.text!.count < 6 {
            signupVCValidateObj.view.makeToast(message: "Confirm password must contain minimum 6 characters")
            signupVCValidateObj.view.endEditing(true)
            return false
        } else if signupVCValidateObj.txtPassword.text! != signupVCValidateObj.txtConfirmPassword.text!{
            signupVCValidateObj.view.makeToast(message: "Password and confirm password does not match")
            return false
        } else if signupVCValidateObj.btnAgree.isSelected == false {
            signupVCValidateObj.view.makeToast(message: "Please accept terms & conditions")
            return false
        }
        else{
            return true
        }
    }
    func ValidateOtp(_ OTPVCValidateObj:OTPVerificationVC) -> Bool {
        if isBlank(OTPVCValidateObj.txtOtp) {
            OTPVCValidateObj.view.makeToast(message: "Please enter confirmation code password")
            return false
        }  else{
            return true
        }
    }
    
    func ValidateForgotPasswordForm(_ forgotPasswordVCValidateObj:ForgotPasswordVC) -> Bool {
        if isBlank(forgotPasswordVCValidateObj.txtEmail){
            forgotPasswordVCValidateObj.view.makeToast(message: "Please enter email")
            forgotPasswordVCValidateObj.view.endEditing(true)
            return false
        } else if isValidEmail(forgotPasswordVCValidateObj.txtEmail.text!){
            forgotPasswordVCValidateObj.view.makeToast(message: "Please enter a valid email")
            forgotPasswordVCValidateObj.view.endEditing(true)
            return false
        } else {
            return true
        }
    }
    
    func ValidateResetPasswordForm(_ resetPasswordVCValidateObj:ResetPasswordVC) -> Bool {
        if isBlank(resetPasswordVCValidateObj.txtNewPassword){
            resetPasswordVCValidateObj.view.makeToast(message: "Please enter new password")
            resetPasswordVCValidateObj.view.endEditing(true)
            return false
        } else if resetPasswordVCValidateObj.txtNewPassword.text!.count < 6 {
            resetPasswordVCValidateObj.view.makeToast(message: "New password must contain minimum 6 characters")
            resetPasswordVCValidateObj.view.endEditing(true)
            return false
        } else  if isBlank(resetPasswordVCValidateObj.txtConfirmPassword){
            resetPasswordVCValidateObj.view.makeToast(message: "Please enter confirm password")
            resetPasswordVCValidateObj.view.endEditing(true)
            return false
        } else if resetPasswordVCValidateObj.txtConfirmPassword.text!.count < 6 {
            resetPasswordVCValidateObj.view.makeToast(message: "Confirm password must contain minimum 6 characters")
            resetPasswordVCValidateObj.view.endEditing(true)
            return false
        }  else if resetPasswordVCValidateObj.txtNewPassword.text! != resetPasswordVCValidateObj.txtConfirmPassword.text!{
            resetPasswordVCValidateObj.view.makeToast(message: "Password and confirm password does not match")
            return false
        } else {
            return true
        }
    }
    
    func ValidateEditProfileForm(_ editProfileVCValidateObj:EditProfileVC) -> Bool {
        if isBlank(editProfileVCValidateObj.txtUserName) {
            editProfileVCValidateObj.view.makeToast(message: "Please enter username")
            editProfileVCValidateObj.view.endEditing(true)
            return false
        } else if editProfileVCValidateObj.txtUserName.text!.count > 50 {
            editProfileVCValidateObj.view.makeToast(message: "Username length should be Max - 50..")
            editProfileVCValidateObj.view.endEditing(true)
            return false
        } else {
            return true
        }
    }
    
    func ValidateChangePasswordForm(_ changePasswordVCValidateObj:ChangePassword) -> Bool {
        if isBlank(changePasswordVCValidateObj.txtCurrentPassword) {
            changePasswordVCValidateObj.view.makeToast(message: "Please enter your password")
            changePasswordVCValidateObj.view.endEditing(true)
            return false
        } else if changePasswordVCValidateObj.txtCurrentPassword.text!.count < 7 {
            changePasswordVCValidateObj.view.makeToast(message: "Password must contain minimum 7 characters")
            changePasswordVCValidateObj.view.endEditing(true)
            return false
        } else if isBlank(changePasswordVCValidateObj.txtNewPassword) {
            changePasswordVCValidateObj.view.makeToast(message: "Please enter new password")
            changePasswordVCValidateObj.view.endEditing(true)
            return false
        } else if changePasswordVCValidateObj.txtNewPassword.text!.count < 7 {
            changePasswordVCValidateObj.view.makeToast(message: "New password must contain minimum 7 characters")
            changePasswordVCValidateObj.view.endEditing(true)
            return false
        } else if isBlank(changePasswordVCValidateObj.txtConfirmPassword) {
            changePasswordVCValidateObj.view.makeToast(message: "Please enter confirm password")
            changePasswordVCValidateObj.view.endEditing(true)
            return false
        } else if changePasswordVCValidateObj.txtConfirmPassword.text!.count < 7 {
            changePasswordVCValidateObj.view.makeToast(message: "Confirm password must contain minimum 7 characters")
            changePasswordVCValidateObj.view.endEditing(true)
            return false
        } else if changePasswordVCValidateObj.txtNewPassword.text != changePasswordVCValidateObj.txtConfirmPassword.text{
            changePasswordVCValidateObj.view.makeToast(message: "Password and confirm password does not match")
            return false
        } else {
            return true
        }
    }
    func ValidateContactUsForm(_ contactUsVCValidateObj:ContactUs) -> Bool {
        
        if isBlank(contactUsVCValidateObj.txtSubject) {
            contactUsVCValidateObj.view.makeToast(message: "Please enter subject")
            contactUsVCValidateObj.view.endEditing(true)
            return false
        } else if contactUsVCValidateObj.txtSubject.text!.count > 50 {
            contactUsVCValidateObj.view.makeToast(message: "Subject must contain maximum 50 characters")
            contactUsVCValidateObj.view.endEditing(true)
            return false
        } else if isBlank(contactUsVCValidateObj.txtMeassage) {
            contactUsVCValidateObj.view.makeToast(message: "Please enter message")
            contactUsVCValidateObj.view.endEditing(true)
            return false
        } else if contactUsVCValidateObj.txtMeassage.text!.count > 250 {
            contactUsVCValidateObj.view.makeToast(message: "Message must contain maximum 250 characters")
            contactUsVCValidateObj.view.endEditing(true)
            return false
        } else{
            return true
        }
    }
    
    
    func ValidateAddMemberForm(_ addMemberVCValidateObj:AddMemberVC) -> Bool {
        if isBlank(addMemberVCValidateObj.txtName){
            addMemberVCValidateObj.view.makeToast(message: "Please enter name")
            addMemberVCValidateObj.view.endEditing(true)
            return false
        } else if isBlank(addMemberVCValidateObj.txtEmail){
            addMemberVCValidateObj.view.makeToast(message: "Please enter email")
            addMemberVCValidateObj.view.endEditing(true)
            return false
        } else if isValidEmail(addMemberVCValidateObj.txtEmail.text!){
            addMemberVCValidateObj.view.makeToast(message: "Please enter a valid email")
            addMemberVCValidateObj.view.endEditing(true)
            return false
        } else {
            return true
        }
    }

    //    func ValidateProfileForm(_ profileVCValidateObj:ProfileVC) -> Bool {
    //        if isBlank(profileVCValidateObj.txtPhoneNo) {
    //            profileVCValidateObj.view.makeToast(message: "Please enter mobile no")
    //            profileVCValidateObj.view.endEditing(true)
    //            return false
    //        } else if profileVCValidateObj.txtPhoneNo.text!.count < 7 || profileVCValidateObj.txtPhoneNo.text!.count > 15 {
    //            profileVCValidateObj.view.makeToast(message: "Phone Number should be in 7-15 digits")
    //            return false
    //        }
    //        else {
    //            return true
    //        }
    //    }
    
    
    
}




