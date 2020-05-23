//
//  ContactUsVC.swift
//  Zabayeh
//
//  Created by endpoint on 5/23/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit
import SVProgressHUD
import FTToastIndicator
class ContactUsVC: UIViewController {

    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var messageTF: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
settings()
    }
    func settings(){
        messageTF.layer.borderWidth = 1.0
        messageTF.layer.borderColor = #colorLiteral(red: 0.6018347144, green: 0.6644291282, blue: 0.7028875947, alpha: 1)
        messageTF.RoundCorners(cornerRadius: 5.0)
        send.RoundCorners(cornerRadius: 20.0)
        
    }
    
    @IBAction func sendBTN(_ sender: Any) {
        let name = nameTF.text!
        let email = emailTF.text!
        let msg = messageTF.text!
        if name.isEmpty && email.isEmpty && msg.isEmpty {
            FTToastIndicator.setToastIndicatorStyle(.dark)
            FTToastIndicator.showToastMessage("enterAllData".localized())
        }else if name.isEmpty {
            FTToastIndicator.setToastIndicatorStyle(.dark)
          FTToastIndicator.showToastMessage("enterName".localized())
        }else if email.isEmpty{
            FTToastIndicator.setToastIndicatorStyle(.dark)
                     FTToastIndicator.showToastMessage("enterEmail".localized())
        }else if !Validaton.isValidEmailAddress(emailAddressString: email){
            FTToastIndicator.setToastIndicatorStyle(.dark)
            FTToastIndicator.showToastMessage("enterValidEmail".localized())
        }else  if msg.isEmpty {
            FTToastIndicator.setToastIndicatorStyle(.dark)
            FTToastIndicator.showToastMessage("entermsg".localized())
        }else{
            SVProgressHUD.show()
            Helper_API().contactUS(name: name, email: email, message: msg) { (code, result) in
                SVProgressHUD.dismiss()
                if code == 200 {
                    FTToastIndicator.setToastIndicatorStyle(.dark)
                    FTToastIndicator.showToastMessage("success".localized())
                    self.navigationController?.popViewController(animated: true)
                }else{
                    print("code")
                    FTToastIndicator.setToastIndicatorStyle(.dark)
                    FTToastIndicator.showToastMessage("tryAgainLater".localized())
                }
            }
        }
    }
    
}
