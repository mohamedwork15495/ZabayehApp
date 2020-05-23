//
//  AppDelegate.swift
//  Zabayeh
//
//  Created by endpoint on 5/10/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import MOLH
import FirebaseAuth
import Firebase
import FirebaseMessaging
import UserNotifications
import GooglePlaces
import GoogleMaps
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,MOLHResetable,UNUserNotificationCenterDelegate ,MessagingDelegate{
    var window: UIWindow?
    let is_login = UserDefaults.standard.bool(forKey: "is_login")
    // For iOS 9+
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        return false
        // URL not auth related, developer should handle it.
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey("AIzaSyDhauu7VGauXPs9aX41Qw6mcB17iuIW2gI")
        GMSServices.provideAPIKey("AIzaSyDhauu7VGauXPs9aX41Qw6mcB17iuIW2gI")
        
        MOLHLanguage.setDefaultLanguage("en")
        MOLH.shared.activate(true)
        MOLH.shared.specialKeyWords = ["Cancel","Done"]
        
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.alert,.announcement]) { (granted, error) in
            DispatchQueue.main.async {UIApplication.shared.registerForRemoteNotifications()}}
        application.beginBackgroundTask(withName: "showNotification", expirationHandler: nil)
        self.splashScreen()
        return true
    }
    private func splashScreen(){
        let lanuchScreenVC = UIStoryboard(name: "LaunchScreen", bundle: nil)
        if #available(iOS 13.0, *) {
            let rootVC = lanuchScreenVC.instantiateViewController(identifier: "splashscreenController")
            self.window?.rootViewController = rootVC
            self.window?.makeKeyAndVisible()
            Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.dismissSplashController), userInfo: nil, repeats: false)
        }
    }
    @objc func dismissSplashController(){
        if is_login{
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "homeID")
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = initialViewControlleripad
            self.window?.makeKeyAndVisible()

        }else{
            let mainVC = UIStoryboard.init(name: "Main", bundle: nil)
            if #available(iOS 13.0, *) {
                let rootVC = mainVC.instantiateViewController(identifier: "loginID")
                self.window?.rootViewController = rootVC
                self.window?.makeKeyAndVisible()
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        
    }
    
    //print userInfo when app is  in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound])
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    func reset() {
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let stry = UIStoryboard(name: "Main", bundle: nil)
        rootviewcontroller.rootViewController = stry.instantiateViewController(withIdentifier: "homeID")
    }
    
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Zabayeh")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

