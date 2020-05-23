//
//  ProductDetailsVC.swift
//  Zabayeh
//
//  Created by endpoint on 5/17/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit
import SwiftyJSON
import DropDown
import FTToastIndicator
class ProductDetailsVC: UIViewController {
    
    
    @IBOutlet weak var complete: UIButton!
    @IBOutlet weak var amountLB: UILabel!
    @IBOutlet weak var totalLB: UILabel!
    @IBOutlet weak var detailsLB: UITextField!
    @IBOutlet weak var freeIMG: UIImageView!
    @IBOutlet weak var noIMG: UIImageView!
    @IBOutlet weak var yesIMG: UIImageView!
    @IBOutlet weak var cookedLB: UILabel!
    @IBOutlet weak var cookedIMG: UIImageView!
    @IBOutlet weak var plasticLB: UILabel!
    @IBOutlet weak var plasticIMG: UIImageView!
    @IBOutlet weak var plateIMG: UIImageView!
    @IBOutlet weak var platesLB: UILabel!
    @IBOutlet weak var chipping: UIButton!
    @IBOutlet weak var sizeLB: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var logo: UIImageView!
    var plateVal = ""
    var plasticVal = ""
    var kersh = ""
    var cookedVal = ""
    var tot = 0
    var product:JSON?
    var packVal = 0
    var chippingList = [
        "FridgeShredder".localized(),
        "Hadramicutting".localized(),
        "Cutuplists".localized(),
        "Flatcutting".localized(),
    ]
    var chipVal = 0
    var Fridge = 0
    var Hadrami = 0
    var Cutup = 0
    var Flat = 0
    
    ///send data
    var covering:Int?
    var cutting:Int?
    var kersh_and_mosran = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        settings()
        setData()
        
    }
    func setData(){
        if let data = product{
            logo.setImage(from: imageURL + data["image"].stringValue)
            sizeLB.text = data["description"].stringValue
            platesLB.text = "\("Packagingdish".localized()) (\(data["plates_price"].stringValue) \(Locale.current.currencyCode!))"
            plasticLB.text = "\("Packagingbags".localized()) (\(data["plastic_price"].stringValue) \(Locale.current.currencyCode!))"
            plateVal = data["plates_price"].stringValue
            plasticVal = data["plastic_price"].stringValue
            kersh = data["kersh_and_mosran_price"].stringValue
            cookedLB.text = "\("Requestsacrificecookedsoggy".localized()) (250 \(Locale.current.currencyCode!))"
            cookedVal = "250"
            Fridge = (data["fridge_cutting_price"].stringValue as NSString).integerValue
             Hadrami = (data["hadramy"].stringValue as NSString).integerValue
            Cutup = (data["kwayem"].stringValue as NSString).integerValue
            Flat = (data["quarter_cutting_price"].stringValue as NSString).integerValue
            chipping.setTitle(chippingList[0], for: .normal)
            cutting = 0
            totalLB.text = "\(data["price"].intValue)"
            covering = 2
            tot = data["price"].intValue
        }
    }
    func settings(){
        chipping.layer.borderWidth = 1.0
        chipping.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        chipping.RoundCorners(cornerRadius: 3.0)
        complete.RoundCorners(cornerRadius: 20.0)
        logo.layer.borderWidth = 1.0
        logo.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        logo.circleView()
        view1.RoundCorners(cornerRadius: 5.0)
        view1.dropShadow()
    }
    @IBAction func chippingBTN(_ sender: UIButton) {
        if chippingList.count > 0 {
            let dropDown = DropDown()
            DropDown.appearance().cornerRadius = 10
            dropDown.dropShadow()
            dropDown.anchorView = sender
            dropDown.dataSource = chippingList
            dropDown.selectionAction = { [unowned self](index,item) in
                sender.setTitle(item, for: .normal)
                if index == 0 {
                    self.covering = 0
                    self.tot -= self.chipVal
                    self.tot += self.Fridge
                    self.chipVal = self.Fridge
                }else if index == 1{
                    self.tot -= self.chipVal
                    self.tot += self.Hadrami
                    self.chipVal = self.Hadrami
                    self.covering = 1
                }else if index == 2{
                    self.tot -= self.chipVal
                    self.tot += self.Cutup
                    self.chipVal = self.Cutup
                    self.covering = 2
                }else if index == 3{
                    self.tot -= self.chipVal
                    self.tot += self.Flat
                    self.chipVal = self.Flat
                    self.covering = 3
                }
            }
            dropDown.show()
        }
    }
    
    // التغليف
    var isPlate = true
    @IBAction func plateBTN(_ sender: Any) {
        if isPlate{
            covering = 0
            isPlate = false
            isPlastic = true
            plateIMG.image = UIImage(named: "inner")
            plasticIMG.image = UIImage(named: "outer")
            freeIMG.image = UIImage(named: "outer")
            tot -= packVal
            tot += (plateVal as NSString).integerValue
            totalLB.text = "\(tot)"
            packVal = (plateVal as NSString).integerValue
        }else{
            covering = -1
            isPlate = true
            isPlastic = true
            plateIMG.image = UIImage(named: "outer")
            plasticIMG.image = UIImage(named: "outer")
            freeIMG.image = UIImage(named: "outer")
            tot -= (plateVal as NSString).integerValue
            totalLB.text = "\(tot)"
            packVal = 0
        }
    }
    var isPlastic = true
    @IBAction func plasticBTN(_ sender: Any) {
        if isPlastic {
            covering = 1
            isPlastic = false
            isPlate = true
            plateIMG.image = UIImage(named: "outer")
            plasticIMG.image = UIImage(named: "inner")
            freeIMG.image = UIImage(named: "outer")
            tot -= packVal
            tot += (plasticVal as NSString).integerValue
            
            totalLB.text = "\(tot)"
            packVal = (plasticVal as NSString).integerValue
        }else{
            covering = -1
            isPlastic = true
            isPlate = true
            plateIMG.image = UIImage(named: "outer")
            plasticIMG.image = UIImage(named: "outer")
            freeIMG.image = UIImage(named: "outer")
            tot -= (plasticVal as NSString).integerValue
            totalLB.text = "\(tot)"
            packVal = 0
        }
    }
    @IBAction func freeBTN(_ sender: Any) {
        isPlate = true
        isPlastic = true
        plateIMG.image = UIImage(named: "outer")
        plasticIMG.image = UIImage(named: "outer")
        freeIMG.image = UIImage(named: "inner")
        tot -= packVal
        totalLB.text = "\(tot)"
        packVal = 0
        covering = 2
        
    }
    var isCooked = true
    @IBAction func cookedBTN(_ sender: Any) {
        if isCooked{
            isCooked = false
            cookedIMG.image = UIImage(named: "true")
            tot += (cookedVal as NSString).integerValue
            totalLB.text = "\(tot)"
        }else{
            isCooked = true
            cookedIMG.image = UIImage(named: "untrue")
            tot -= (cookedVal as NSString).integerValue
            totalLB.text = "\(tot)"
        }
    }
    var isYes = true
    @IBAction func yesBTN(_ sender: Any) {
        if isYes {
            kersh_and_mosran = 1
            isYes = false
            yesIMG.image = UIImage(named: "inner")
            noIMG.image = UIImage(named: "outer")
            tot += (kersh as NSString).integerValue
            totalLB.text = "\(tot)"
        }else{
            kersh_and_mosran = 0
            isYes = true
            yesIMG.image = UIImage(named: "outer")
            noIMG.image = UIImage(named: "inner")
            tot -= (kersh as NSString).integerValue
            totalLB.text = "\(tot)"
        }
    }
    
    
    
    @IBAction func plusBTN(_ sender: Any) {
        amountLB.text = "\((amountLB.text! as NSString).integerValue + 1)"
        if let pro = product{
            tot += pro["price"].intValue
            totalLB.text = "\(tot)"
        }
    }
    
    @IBAction func minusBTN(_ sender: Any) {
        if (amountLB.text! as NSString).integerValue > 1 {
            amountLB.text = "\((amountLB.text! as NSString).integerValue - 1)"
            if let pro = product{
                tot -= pro["price"].intValue
                totalLB.text = "\(tot)"
            }
        }else{
            amountLB.text = "1"
            totalLB.text = "\(tot)"
        }
    }
    
    var pro = [String:String]()
    @IBAction func completeBTN(_ sender: Any) {
        let desc = detailsLB.text!
        if covering == -1 {
          FTToastIndicator.setToastIndicatorStyle(.dark)
          FTToastIndicator.showToastMessage("chooseCoveringType".localized())
        }else if desc.isEmpty {
            FTToastIndicator.setToastIndicatorStyle(.dark)
            FTToastIndicator.showToastMessage("enterOrderDetails".localized())
        }else{
            pro["product_id"] = "\(product!["id"].intValue)"
            pro["user_id"] = "\(UserDefaults.standard.integer(forKey: "id"))"
            pro["order_total"] = "\(tot)"
            pro["kersh_and_mosran"] = "\(kersh_and_mosran)"
            pro["cutting"] = "\(cutting)"
            pro["covering"] = "\(covering)"
            pro["description"] = desc
            pro["quantity"] = amountLB.text!
            pro["name"] = product!["name"].stringValue
            pro["image"] = product!["image"].stringValue
            performSegue(withIdentifier: "completeSegue", sender: self)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "completeSegue" {
            let des = segue.destination as! CompletePurchaseVC
            des.product = pro
        }
    }
    
}
