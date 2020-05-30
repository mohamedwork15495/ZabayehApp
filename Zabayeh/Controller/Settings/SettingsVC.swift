//
//  SettingsVC.swift
//  Zabayeh
//
//  Created by endpoint on 5/23/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit
import SVProgressHUD
import FTToastIndicator
import MOLH
import CoreData
class SettingsVC: UIViewController {
    
    @IBOutlet weak var point: UILabel!
    var banks:String?
    let is_arabic = MOLHLanguage.currentAppleLanguage() == "en" ? "en" : "ar"
    let is_login = UserDefaults.standard.bool(forKey: "is_login")
    var terms:String?
    override func viewWillAppear(_ animated: Bool) {
        getBalance()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
getSettings()

    }
    func getSettings(){
        SVProgressHUD.show()
        Helper_API().getSettings { (code, result) in
            SVProgressHUD.dismiss()
            if code == 200 {
                if let data = result{
                    self.banks = data["bank_details"].stringValue
                    if self.is_arabic == "en"{
                        self.terms = data["terms_and_conditions_en"].stringValue
                    }else{
                        self.terms = data["terms_and_conditions"].stringValue
                    }
                }
            }else{
                print("code \(code)")
                FTToastIndicator.setToastIndicatorStyle(.dark)
                FTToastIndicator.showToastMessage("tryAgainLater".localized())
            }
        }
    }
    func getBalance(){
        Helper_API().getBalance { (code, result) in
            if code == 200 {
                if let data = result{
                    self.point.text = "\(data["balance"].intValue)"
                }else{
                    self.point.text = "0"
                }
            }else{
                print("code \(code)")
                self.point.text = "0"

            }
        }
    }
    @IBAction func banksBTN(_ sender: Any) {
        if banks != nil {
    performSegue(withIdentifier: "bankAccountsSegue", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bankAccountsSegue" {
            let des = segue.destination as! BanksVC
            des.txt = banks!
        }else if segue.identifier == "termsSegue" {
            let des = segue.destination as! TermsVC
            des.txt = terms!
        }
    }
    
    @IBAction func termsBTN(_ sender: Any) {
        if terms != nil{
            performSegue(withIdentifier: "termsSegue", sender: self)
        }
    }
    
    @IBAction func contactBTN(_ sender: Any) {
   performSegue(withIdentifier: "contactSegue", sender: self)
    }
    
    @IBAction func logOut(_ sender: UIButton) {
    let alertController = UIAlertController(title: "doYouwantlogout".localized(), message: nil, preferredStyle: .actionSheet)
    let OKAction = UIAlertAction(title: "Yes".localized(), style: .default, handler: { action in
        UserDefaults.standard.set(false, forKey: "is_login")
        self.deleteData()
        let vc = UIStoryboard(name: "Main", bundle: nil)
        let rootVc = vc.instantiateViewController(withIdentifier: "loginID")
        self.present(rootVc, animated: true, completion: nil)
    })
    alertController.addAction(OKAction)
    alertController.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
    if UIDevice.current.userInterfaceIdiom == .pad {
        alertController.popoverPresentationController?.sourceView = sender
        alertController.popoverPresentationController?.sourceRect = sender.bounds
        alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
    }
    
    self.present(alertController, animated: true)
    
    }
    
    @IBAction func cartBTN(_ sender: Any) {
    if is_login{
       performSegue(withIdentifier: "cartSegue", sender: self)
           }else{
               self.loginAlert()
           }
    }
    @IBAction func languageBTN(_ sender: Any) {
    performSegue(withIdentifier: "languageSegue", sender: self)
    }
    func deleteData(){
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
           let managedContext = appDelegate.persistentContainer.viewContext
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
           do {
               let result = try managedContext.fetch(fetchRequest)
               
               for data in result as! [NSManagedObject] {
                   managedContext.delete(data)
                   do{
                       try managedContext.save()
                       print("deleted")
                   }catch{
                       print("Error Delete",error)
                   }
               }
               
           } catch  {
               print("fail")
           }
       }
    
}
