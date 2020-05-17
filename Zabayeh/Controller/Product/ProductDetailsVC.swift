//
//  ProductDetailsVC.swift
//  Zabayeh
//
//  Created by endpoint on 5/17/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit
import SwiftyJSON
class ProductDetailsVC: UIViewController {
    
    
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
            totalLB.text = "\(data["price"].intValue)"
            tot = data["price"].intValue
        }
    }
    func settings(){
        logo.layer.borderWidth = 1.0
        logo.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        logo.circleView()
        view1.RoundCorners(cornerRadius: 5.0)
        view1.dropShadow()
    }
    @IBAction func chippingBTN(_ sender: Any) {
    }
    
    
    
    // التغليف
    var isPlate = true
    @IBAction func plateBTN(_ sender: Any) {
        if isPlate{
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
            isYes = false
            yesIMG.image = UIImage(named: "inner")
            noIMG.image = UIImage(named: "outer")
            tot += (kersh as NSString).integerValue
            totalLB.text = "\(tot)"
        }else{
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
}
