//
//  SubCatVC.swift
//  Zabayeh
//
//  Created by endpoint on 5/16/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import FTToastIndicator
class SubCatVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
  
    

    @IBOutlet weak var tableView: UITableView!
    var products = [JSON]()
    var category_id = 0
    var txt = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = txt
        let nib = UINib(nibName: "SubCatCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SubCatCell")
        tableView.delegate = self
        tableView.dataSource = self
        getproducts()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCatCell", for: indexPath) as! SubCatCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let pos = indexPath.row
        let item = products[pos]
        cell.logo.setImage(from: imageURL + item["image"].stringValue)
        cell.priceLB.text = "\(item["price"].intValue) \(Locale.current.currencyCode!)"
        cell.titleLB.text = item["name"].stringValue
        return cell
      }
    func getproducts(){
           SVProgressHUD.show()
        Helper_API().getproducts(category_id: category_id) { (code, result) in
        SVProgressHUD.dismiss()
               if code == 200 {
                   if let data = result {
                       if data.count > 0 {
                           self.tableView.isHidden = false
                           self.products = data
                           self.tableView.reloadData()
                         }else{
                           self.tableView.isHidden = true
                       }
                   }else{
                       self.tableView.isHidden = true
                   }
               }else{
                   self.tableView.isHidden = true
                   FTToastIndicator.setToastIndicatorStyle(.dark)
                   FTToastIndicator.showToastMessage("fail".localized())
               }
           }
       }
    

}
