//
//  EditProfileVC.swift
//  Zabayeh
//
//  Created by endpoint on 5/23/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit
import FlagPhoneNumber
import FTToastIndicator
import SVProgressHUD
class EditProfileVC: UIViewController ,FPNTextFieldDelegate{
    var validPhoneNumber = false
    var phoneCode:String?
    var phone:String?
    var codePhone = ""
    var status_code = 0
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    
    let dev = UserDefaults.standard
    @IBOutlet weak var update: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: FPNTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update.RoundCorners(cornerRadius: 20.0)
        nameTF.text = dev.string(forKey: "name")!
        phoneTF.text = dev.string(forKey: "mobile")!
        settings()
    }
    func settings(){
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
    
    
    @IBAction func updateBTN(_ sender: Any) {
        let ph = phoneTF.text!
        let name = nameTF.text!
        let pass = passwordTF.text!
        if ph.isEmpty && name.isEmpty && pass.isEmpty {
            FTToastIndicator.setToastIndicatorStyle(.dark)
            FTToastIndicator.showToastMessage("enterAllData".localized())
        }else if ph.isEmpty{
            FTToastIndicator.setToastIndicatorStyle(.dark)
            FTToastIndicator.showToastMessage("enterPhoneNumber".localized())
        }else if !validPhoneNumber{
            FTToastIndicator.setToastIndicatorStyle(.dark)
            FTToastIndicator.showToastMessage("enterValidPhoneNumber".localized())
        }else if name.isEmpty {
            FTToastIndicator.setToastIndicatorStyle(.dark)
            FTToastIndicator.showToastMessage("enterName".localized())
        }else if pass.isEmpty {
            FTToastIndicator.setToastIndicatorStyle(.dark)
            FTToastIndicator.showToastMessage("enterPassword".localized())
        }else if pass.count < 6{
            FTToastIndicator.setToastIndicatorStyle(.dark)
            FTToastIndicator.showToastMessage("enterStrongPassword".localized())
        }else{
            SVProgressHUD.show()
            Auth_API().updateProfile(name: name, password: pass, mobile: phone!) { (code) in
                SVProgressHUD.dismiss()
                if code == 200 {
                    FTToastIndicator.setToastIndicatorStyle(.dark)
                    FTToastIndicator.showToastMessage("success".localized())
                    self.navigationController?.popViewController(animated: true)
                }else{
                    print("code \(code)")
                    FTToastIndicator.setToastIndicatorStyle(.dark)
                    FTToastIndicator.showToastMessage("tryAgainLater".localized())
                }
            }
        }
        
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
