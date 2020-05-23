//
//  TabBarController.swift
//  Zabayeh
//
//  Created by endpoint on 5/23/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController ,UITabBarControllerDelegate{
    let is_login = UserDefaults.standard.bool(forKey: "is_login")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
         }

    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
           if viewController == tabBarController.viewControllers![3] {
               if is_login{
                  return true
               }else{
               let vc = UIStoryboard(name: "Main", bundle: nil)
               let rootVc = vc.instantiateViewController(withIdentifier: "loginID")
               self.present(rootVc, animated: true, completion: nil)
               return false
               }
           }
           return true
       }


}
