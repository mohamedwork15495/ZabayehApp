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
import SVProgressHUD
import FirebaseAuth
class LoginVC: UIViewController ,FPNTextFieldDelegate{
    var validPhoneNumber = false
    var phoneCode:String?
    var phone:String?
    var codePhone = ""
    var status_code = 0
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var phoneTF: FPNTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings()
    }
    func settings(){
        view1.RoundCorners(cornerRadius: 5.0)
        view1.dropShadow()
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
        let ph = phoneTF.text!
        if ph.isEmpty {
            FTToastIndicator.setToastIndicatorStyle(.dark)
            FTToastIndicator.showToastMessage("enterPhoneNumber".localized())
        }else if !validPhoneNumber{
            FTToastIndicator.setToastIndicatorStyle(.dark)
            FTToastIndicator.showToastMessage("enterValidPhoneNumber".localized())
        }else{
            SVProgressHUD.show()
            Auth_API().login(mobile: phone!) { (code) in
                SVProgressHUD.dismiss()
                if code == 200 {
                    self.status_code = code
                    self.setPhone()
                }else if code == 404{
                    self.status_code = code
                    self.setPhone()
                }else{
                    FTToastIndicator.setToastIndicatorStyle(.dark)
                    FTToastIndicator.showToastMessage("tryAgainLater".localized())
                }
            }
        }
    }
    
    func setPhone(){
           let phoneNumber = codePhone + phone!
           print("phone \(phoneNumber)")
           PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
               if let error = error {
                   self.showAlert(message: error.localizedDescription)
                   return
               }
               UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
               self.performSegue(withIdentifier: "verifySegue", sender: self)
           }
       }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verifySegue"{
            let des = segue.destination as! VerificationCodeVC
            des.status_code = status_code
            des.phone = phone!
            des.codePhone = codePhone
        }
    }
    
    @IBAction func skipBTN(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil)
        let rootVc = vc.instantiateViewController(withIdentifier: "homeID")
        self.present(rootVc, animated: true, completion: nil)
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
