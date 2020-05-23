//
//  MyOrdersVC.swift
//  Zabayeh
//
//  Created by endpoint on 5/23/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit
import SVProgressHUD
import FTToastIndicator
import SwiftyJSON
class MyOrdersVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    let is_login = UserDefaults.standard.bool(forKey: "is_login")
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var orders = [JSON]()
    override func viewDidLoad() {
        super.viewDidLoad()
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        let nib = UINib(nibName: "OrderCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "OrderCell")
        tableView.delegate = self
        tableView.dataSource = self
        getOrders(0)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let pos = indexPath.row
        let item = orders[pos]
        let dateString = item["created_at"].stringValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateObj = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        cell.dateLB.text = dateFormatter.string(from: dateObj!)
        cell.logo.setImage(from: imageURL + item["product"]["image"].stringValue)
        cell.titleLB.text = item["product"]["name"].stringValue
        cell.priceLB.text = "\(item["product"]["price"].intValue)" + " " + Locale.current.currencyCode!
        return cell
    }
    func getOrders(_ status:Int){
        orders.removeAll()
        SVProgressHUD.show()
        Helper_API().getOrders(status: status) { (code, result) in
            SVProgressHUD.dismiss()
            if code == 200 {
                if let data = result {
                    if data.count > 0 {
                        self.tableView.isHidden = false
                        self.orders = data
                        self.tableView.reloadData()
                    }else{
                        self.tableView.isHidden = true
                    }
                }else{
                    self.tableView.isHidden = true
                }
            }else{
                print("code \(code)")
                                   FTToastIndicator.setToastIndicatorStyle(.dark)
                                   FTToastIndicator.showToastMessage("tryAgainLater".localized())
            }
        }
    }
    @IBAction func switchSegment(_ sender: UISegmentedControl) {
        let pos = sender.selectedSegmentIndex
        if pos == 0 {
            getOrders(0)
        }else if pos == 1 {
            getOrders(1)
        }else if pos == 2 {
            getOrders(2)
        }
    }
    
    @IBAction func cartBTN(_ sender: Any) {
        if is_login{
          performSegue(withIdentifier: "cartSegue", sender: self)
              }else{
                  self.loginAlert()
              }
    }
    

}
