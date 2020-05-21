//
//  CartVC.swift
//  Zabayeh
//
//  Created by endpoint on 5/20/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit
import CoreData
class CartVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
  
    

    @IBOutlet weak var tableView: UITableView!
    var allItems = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "CartCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CartCell")
        tableView.delegate = self
        tableView.dataSource = self
        retrieveData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let pos = indexPath.row
        let item = allItems[pos]
        cell.logo.setImage(from: imageURL + (item["image"] as! String))
        cell.titleLB.text = item["name"] as! String
        cell.countLB.text = "\(item["quantity"] as! Int)"
        cell.priceLB.text = item["order_total"] as! String
        
        return cell
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
                   var dic = [String:Any]()
                   dic["longitude"] = (data.value(forKey: "longitude") as! String)
                   dic["product_id"] = (data.value(forKey: "product_id") as! Int)
                   dic["user_id"] = (data.value(forKey: "user_id") as! Int)
                   dic["latitude"] = (data.value(forKey: "latitude") as! String)
                   dic["address"] = (data.value(forKey: "address") as! String)
                   dic["order_total"] = (data.value(forKey: "order_total") as! String)
                   dic["kersh_and_mosran"] = (data.value(forKey: "kersh_and_mosran") as! Int)
                   dic["cutting"] = (data.value(forKey: "cutting") as! Int)
                   dic["covering"] = (data.value(forKey: "covering") as! Int)
                   dic["description"] = (data.value(forKey: "desc") as! String)
                   dic["quantity"] = (data.value(forKey: "quantity") as! Int)
                  dic["image"] = (data.value(forKey: "image") as! String)
                dic["name"] = (data.value(forKey: "name") as! String)

                //price += ((data.value(forKey: "price") as! String) as NSString).integerValue
                   allItems.append(dic)
               }
               print("all_data\(allItems.description)")
               if allItems.count > 0 {
                   tableView.reloadData()
               }else{
                   tableView.isHidden = false
                   //tableView.isHidden = true
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
           fetchRequest.predicate = NSPredicate(format: "item_id = %@ ",item_id)
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
       
}
