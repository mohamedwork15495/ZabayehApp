//
//  LoginVC.swift
//  Zabayeh
//
//  Created by endpoint on 5/11/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit
import FlagPhoneNumber
import FTToastIndicator
class LoginVC: UIViewController ,FPNTextFieldDelegate{
var validPhoneNumber = false
var phoneCode:String?
var phone:String?
var codePhone = ""
var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var phoneTF: FPNTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()



    }
     func settings(){
    print("region code :\(Locale.current.regionCode!)")
    
            login.RoundCorners(cornerRadius: 20.0)
            phoneTF.delegate = self
            phoneTF.hasPhoneNumberExample = false
        phoneTF.hasPhoneNumberExample = false // true by default
        phoneTF.placeholder = "Phone Number"
            phoneTF.setFlag(countryCode: FPNCountryCode(rawValue: Locale.current.regionCode!)!)
            phoneTF.displayMode = .list // .picker by default
            listController.setup(repository: phoneTF.countryRepository)
            listController.didSelect = { [weak self] country in
                self?.phoneTF.setFlag(countryCode: country.code)
            }
        }
    @IBAction func loginBTN(_ sender: Any) {
    }
    
    @IBAction func skipBTN(_ sender: Any) {
    }
    
    @IBAction func newAccountBTN(_ sender: Any) {
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        let x = dialCode.replacingOccurrences(of: "+", with: "00")
        codePhone = dialCode
        phoneCode = x
    }
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            validPhoneNumber = true
            phone = "\(textField.getRawPhoneNumber()!)"
        } else {
            validPhoneNumber = false
        }
    }
    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)
        present(navigationViewController, animated: true, completion: nil)
    }
}
