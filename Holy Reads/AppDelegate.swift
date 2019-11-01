//
//  AppDelegate.swift
//  Holy Reads
//
//  Created by mac-14 on 30/08/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var deafults: UserDefaults!
    var navigationController = UINavigationController()
    var initialViewController: UIViewController?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 4.0))
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = UIColor.init(red: 0/255.0, green: 111/255.0, blue: 255/255.0, alpha: 1)
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        navigationController.navigationBar.isHidden = true
        deafults = UserDefaults.standard
        
        showMain()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func showFirstPage(){
        initialViewController = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        let navigationController = UINavigationController(rootViewController: initialViewController!)
        window?.rootViewController = navigationController
        navigationController.isNavigationBarHidden = true
    }
    
    func showMain(){
        
        if let isIntroSkipped = deafults.value(forKey: "isIntroSkipped") as? Bool, isIntroSkipped == true {
            
            if let userLoggedIn = Config().AppUserDefaults.value(forKey:"isCurrentUser") as? Bool, userLoggedIn == true {
                initialViewController = storyboard.instantiateViewController(withIdentifier: "tabbar") 
            } else{
                initialViewController = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
            }
        } else{
            initialViewController = storyboard.instantiateViewController(withIdentifier: "IntroductionVC") as! IntroductionVC
        }
        navigationController = UINavigationController.init(rootViewController: initialViewController!)
        navigationController.navigationBar.isHidden = true
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func checkCameraPermission(completionHandler:@escaping (Bool) -> ())
    {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            completionHandler(true)
            // Already Authorized
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    completionHandler(true)
                    // User granted
                } else {
                    //                    self.TabLogin.selectedIndex = self.selectTab
                    completionHandler(false)
                    let alert:UIAlertController=UIAlertController(title: "Permissions", message: "App doesn't have camera access permissions. Please go to settings and allow Holy Reads for camera access permissions.", preferredStyle: UIAlertController.Style.alert)
                    
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                    alert.addAction(settingsAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
                    {
                        UIAlertAction in
                        
                    }
                    // Add the actions
                    alert.addAction(cancelAction)
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    // User Rejected
                }
            })
        }
    }
    
    //MARK: - checkGalleryPermission
    
    func checkGalleryPermission(completionHandler:@escaping (Bool) -> ())
    {
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        // check the status for PHAuthorizationStatusAuthorized or ALAuthorizationStatusDenied e.g
        if status == PHAuthorizationStatus.notDetermined
        {
            PHPhotoLibrary.requestAuthorization({ (statusinner) in
                if statusinner != PHAuthorizationStatus.authorized {
                    //show alert for asking the user to give permission
                    completionHandler(false)
                    let alert:UIAlertController=UIAlertController(title: "Permissions", message: "App doesn't have gallery access permissions. Please go to settings and allow Holy Reads for gallery access permissions.", preferredStyle: UIAlertController.Style.alert)
                    
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                    alert.addAction(settingsAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
                    {
                        UIAlertAction in
                    }
                    // Add the actions
                    alert.addAction(cancelAction)
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
                else
                {
                    completionHandler(true)
                }
            })
        }
        else if status != PHAuthorizationStatus.authorized {
            //show alert for asking the user to give permission
            completionHandler(false)
            let alert:UIAlertController=UIAlertController(title: "Permissions", message: "App doesn't have gallery access permissions. Please go to settings and allow Holy Reads for gallery access permissions.", preferredStyle: UIAlertController.Style.alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            alert.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            {
                UIAlertAction in
            }
            // Add the actions
            alert.addAction(cancelAction)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        else
        {
            completionHandler(true)
        }
    }
    
    
}

