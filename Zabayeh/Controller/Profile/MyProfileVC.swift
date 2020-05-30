//
//  MyProfileVC.swift
//  Zabayeh
//
//  Created by endpoint on 5/23/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit
import FlagPhoneNumber
class MyProfileVC: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var update: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phoneTF: FPNTextField!
    let dev = UserDefaults.standard
    let is_login = UserDefaults.standard.bool(forKey: "is_login")
    override func viewWillAppear(_ animated: Bool) {
        nameTF.text = dev.string(forKey: "name")!
        phoneTF.text = dev.string(forKey: "mobile")!
        passwordTF.text = "123456789"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        update.RoundCorners(cornerRadius: 20.0)
        
    }
    @IBAction func updateBTN(_ sender: Any) {
        performSegue(withIdentifier: "editSegue", sender: self)
    }
    
    @IBAction func cartBTn(_ sender: Any) {
    if is_login{
    performSegue(withIdentifier: "cartSegue", sender: self)
        }else{
            self.loginAlert()
        }
    }
    
    
}
