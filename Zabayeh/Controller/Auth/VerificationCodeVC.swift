//
//  VerificationCodeVC.swift
//  Jack
//
//  Created by endpoint on 3/17/20.
//  Copyright © 2020 endpoint. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase
import FirebaseAuth
class VerificationCodeVC: UIViewController ,OTPDelegate{

    var phone_code = ""
    var phone = ""
    var codePhone = ""
    var status_code = 0
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    
    @IBOutlet weak var otpContainerView: UIView!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    
    //let user_id = UserDefaults.standard.integer(forKey: "id")
    var timer:Timer?
    var startTime = 60.0
    let otpStackView = OTPStackView()
    override func viewWillAppear(_ animated: Bool) {
        // testButton.isHidden = true
        
        otpContainerView.addSubview(otpStackView)
        otpStackView.delegate = self
        otpStackView.semanticContentAttribute = .forceLeftToRight
        otpStackView.heightAnchor.constraint(equalTo: otpContainerView.heightAnchor).isActive = true
        otpStackView.centerXAnchor.constraint(equalTo: otpContainerView.centerXAnchor).isActive = true
        otpStackView.centerYAnchor.constraint(equalTo: otpContainerView.centerYAnchor).isActive = true
        timeButton.roundCorners(cornerRadius: 20.0)
        checkButton.roundCorners(cornerRadius: 20.0)
        timeButton.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    func didChangeValidity(isValid: Bool) {
        
    }
    @objc func onTimerFires()
    {
        timeButton.isUserInteractionEnabled = false
        
        startTime -= 1.0
        timeButton.setTitle("00:\(Int(startTime))", for: .normal)
       // print(startTime)
        if startTime <= 0.0  {
            
            timeButton.setTitle("Resend_code".localized(), for: .normal)
            timeButton.isUserInteractionEnabled = true
            timer!.invalidate()
            timer = nil
        }
    }
    
    
    @IBAction func checkBTN(_ sender: Any) {
        print("Final OTP : ",otpStackView.getOTP())
        otpStackView.setAllFieldColor(isWarningColor: true, color: #colorLiteral(red: 0.833019793, green: 0.2301174104, blue: 0.2245136201, alpha: 1))
        
        let verificationCode  = otpStackView.getOTP()
        if verificationCode.isEmpty {
            self.showAlert(message: "enterVerificationCode".localized())
        }else if verificationCode.count != 6 {
            self.showAlert(message: "invalidVerificationCode".localized())
        }else {
            SVProgressHUD.show()
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID ?? "",
                verificationCode: verificationCode)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    SVProgressHUD.dismiss()
                    self.showAlert(message: error.localizedDescription)
                    return
                }
                SVProgressHUD.dismiss()
                if self.status_code == 200{
                    UserDefaults.standard.set(true, forKey: "is_login")
                    let vc = UIStoryboard(name: "Main", bundle: nil)
                    let rootVc = vc.instantiateViewController(withIdentifier: "homeID")
                    self.present(rootVc, animated: true, completion: nil)
                }else{
                    self.performSegue(withIdentifier: "registerSegue", sender: self)
                    print("register")
                }
                
            }
        }
    }
    
    @IBAction func timeBTN(_ sender: Any) {
        setPhone()
    }
 
    func setPhone(){
        let phoneNumber = codePhone + phone
        
        print("phone \(phoneNumber)")
        Auth.auth().settings!.isAppVerificationDisabledForTesting = false
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }
            self.timeButton.setTitle(nil, for: .normal)
            self.startTime = 120.0
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.onTimerFires), userInfo: nil, repeats: true)
            self.timeButton.isUserInteractionEnabled = false
           // print("verfi \(verificationID!)")
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            SVProgressHUD.showSuccess(withStatus: "we_sent_to_you_an_sms_verification_code".localized())
            SVProgressHUD.dismiss(withDelay: 2.0)
        }
    }
    
}
