//
//  RegisterVC.swift
//  Zabayeh
//
//  Created by endpoint on 5/21/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit
import FlagPhoneNumber
import FTToastIndicator
import SVProgressHUD
class RegisterVC: UIViewController,FPNTextFieldDelegate {
    @IBOutlet weak var phView: UIView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var phoneTF: FPNTextField!
    var validPhoneNumber = false
       var phoneCode:String?
       var phone:String?
       var codePhone = ""
       var status_code = 0
       var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
     
    override func viewDidLoad() {
        super.viewDidLoad()
setting()
    }
    func setting(){
        register.RoundCorners(cornerRadius: 20.0)
        phView.RoundCorners(cornerRadius: 5.0)
        phView.dropShadow()
        nameView.RoundCorners(cornerRadius: 5.0)
        nameView.dropShadow()
        passwordView.RoundCorners(cornerRadius: 5.0)
        passwordView.dropShadow()
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
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//           return self.ArabicNumReplacement(TF: textField, SS: string)
//       }
    @IBAction func registerBTN(_ sender: Any) {
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
            //api code
            SVProgressHUD.show()
            Auth_API().register(name: name, password: pass, mobile: phone!) { (code) in
                SVProgressHUD.dismiss()
                if code == 200 {
                    let vc = UIStoryboard(name: "Main", bundle: nil)
                    let rootVc = vc.instantiateViewController(withIdentifier: "homeID")
                    self.present(rootVc, animated: true, completion: nil)
                }else{
                    FTToastIndicator.setToastIndicatorStyle(.dark)
                    FTToastIndicator.showToastMessage("tryAgainLater".localized())
                    print("register status code \(code)")
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
