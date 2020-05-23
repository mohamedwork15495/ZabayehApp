//
//  CartVC.swift
//  Zabayeh
//
//  Created by endpoint on 5/20/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD
import FTToastIndicator
class CartVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var comp: UIButton!
    @IBOutlet weak var ret: UIButton!
    
    @IBOutlet weak var orderNow: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    var allItems = [[String:String]]()
    override func viewWillAppear(_ animated: Bool) {
        allItems.removeAll()
        let nib = UINib(nibName: "CartCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CartCell")
        tableView.delegate = self
        tableView.dataSource = self
        retrieveData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        orderNow.RoundCorners(cornerRadius: 20.0)
        comp.RoundCorners(cornerRadius: 20.0)
        ret.RoundCorners(cornerRadius: 20.0)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let pos = indexPath.row
        let item = allItems[pos]
        cell.logo.setImage(from: imageURL + item["image"]!)
        cell.titleLB.text = item["name"]!
        cell.countLB.text = item["quantity"]!
        cell.priceLB.text = item["order_total"]!
        cell.tag = pos
        cell.delete.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return cell
    }
    @objc func deleteTapped(_ sender: UIButton) {
        let pos = sender.tag
        let item = allItems[pos]
        deleteDataAtIndex(item_id: item["product_id"]!)
    }
    func retrieveData(){
        //price = 0
        allItems.removeAll()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                if let user_id = (data.value(forKey: "user_id") as? String){
                    if user_id == "\(UserDefaults.standard.integer(forKey: "id"))" {
                        var dic = [String:String]()
                        dic["longitude"] = (data.value(forKey: "longitude") as! String)
                        dic["product_id"] = (data.value(forKey: "product_id") as! String)
                        dic["user_id"] = (data.value(forKey: "user_id") as! String)
                        dic["latitude"] = (data.value(forKey: "latitude") as! String)
                        dic["address"] = (data.value(forKey: "address") as! String)
                        dic["order_total"] = (data.value(forKey: "order_total") as! String)
                        dic["kersh_and_mosran"] = (data.value(forKey: "kersh_and_mosran") as! String)
                        dic["cutting"] = (data.value(forKey: "cutting") as! String)
                        dic["covering"] = (data.value(forKey: "covering") as! String)
                        dic["description"] = (data.value(forKey: "desc") as! String)
                        dic["quantity"] = (data.value(forKey: "quantity") as! String)
                        dic["image"] = (data.value(forKey: "image") as! String)
                        dic["name"] = (data.value(forKey: "name") as! String)
                        dic["mobile"] = (data.value(forKey: "mobile") as! String)
                        //price += ((data.value(forKey: "price") as! String) as NSString).integerValue
                        allItems.append(dic)
                    }
                }
            }
            print("all_data\(allItems.description)")
            if allItems.count > 0 {
                tableView.reloadData()
            }else{
                tableView.isHidden = true
                comp.isHidden = true
                ret.isHidden = true
            }
        } catch  {
            print("fail")
        }
    }
    func deleteDataAtIndex(item_id:String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        // fetchRequest.predicate = NSPredicate(format: "item_id = %@ AND amount = %@ AND logo = %@ AND price = %@ AND title = %@ ",item_id,amount,logo,price,title)
        fetchRequest.predicate = NSPredicate(format: "product_id = %@ ",item_id)
        do{
            let dateRequest = try managedContext.fetch(fetchRequest)
            let objectToDelete = dateRequest[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            do{
                try managedContext.save()
                self.retrieveData()
            }catch{
                print("Error Delete",error)
            }
        }catch{
            print("Error Delete",error)
        }
    }
    
    @IBAction func orderNowBTN(_ sender: Any) {
       // self.navigationController?.popViewController(animated: true)
        self.tabBarController?.selectedIndex = 0
    }
    @IBAction func completeBTN(_ sender: Any) {
        var order = [[String:Any]]()
        for item in allItems {
            var dic = [String:Any]()
            dic["longitude"] = item["longitude"]!
            dic["product_id"] = (item["product_id"]! as NSString).integerValue
            dic["user_id"] = UserDefaults.standard.integer(forKey: "id")
            dic["latitude"] = item["latitude"]!
            dic["address"] = item["address"]!
            dic["order_total"] = item["order_total"]!
            dic["kersh_and_mosran"] = (item["kersh_and_mosran"]! as NSString).integerValue
            dic["cutting"] = (item["cutting"]! as NSString).integerValue
            dic["covering"] = (item["covering"]! as NSString).integerValue
            dic["description"] = item["description"]!
            dic["mobile"] = item["mobile"]!
            dic["quantity"] = (item["quantity"]! as NSString).integerValue
            order.append(dic)
        }
        print("order \(order.description)")
        
        SVProgressHUD.show()
        Helper_API().createNewOrder(params: ["orders":order]) { (success, code) in
            SVProgressHUD.dismiss()
            if code == 200 {
                FTToastIndicator.setToastIndicatorStyle(.dark)
                FTToastIndicator.showToastMessage("success".localized())
                self.deleteData()
            }else{
                print("code \(code)")
                FTToastIndicator.setToastIndicatorStyle(.dark)
                FTToastIndicator.showToastMessage("tryAgainLater".localized())
            }
        }
        
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
                    tableView.isHidden = true
                    comp.isHidden = true
                    ret.isHidden = true
                }catch{
                    print("Error Delete",error)
                }
            }
            
        } catch  {
            print("fail")
        }
    }

    @IBAction func returnBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
