//
//  Extensions.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/17/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation
import UIKit
//import SideMenu
extension UIViewController {
    func ArabicNumReplacement(TF:UITextField,SS:String)->Bool {
           if TF.keyboardType == .numberPad && SS != "" {
               let numberStr: String = SS
               let formatter: NumberFormatter = NumberFormatter()
               formatter.locale = Locale(identifier: "EN")
               if let final = formatter.number(from: numberStr) {
                   TF.text =  "\(TF.text ?? "")\(final)"
               }
               return false
           }
           return true
       }
    
    func showAlert(message: String, title: String = "fastOne".localized()) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ok".localized(), style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func alertdone(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ok".localized(), style: .default, handler: { action in
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
       
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func loginAlert() {
        let alertController = UIAlertController(title: "fastOne".localized(), message: "loginPlease".localized(), preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ok".localized(), style: .default, handler: { action in
             let vc = UIStoryboard(name: "Main", bundle: nil)
               let rootVc = vc.instantiateViewController(withIdentifier: "loginID")
               self.present(rootVc, animated: true, completion: nil)
        })
        alertController.addAction(OKAction)
        alertController.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))

        self.present(alertController, animated: true, completion: nil)
    }
}
extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
    
}
class helperHelper:NSObject{
//class func sideMenu(_ storyboard:String ,_ identifier:String)->SideMenuNavigationController{
//        let menu = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier:identifier) as! SideMenuNavigationController
//        menu.menuWidth = UIScreen.main.bounds.width/2 + UIScreen.main.bounds.width/4
//        menu.presentationStyle = .menuSlideIn
//        if Locale.preferredLanguages[0] == "ar" {menu.leftSide = false}else{menu.leftSide = true}
//        return menu
//    }
}
