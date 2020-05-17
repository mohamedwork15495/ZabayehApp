//
//  OffersVC.swift
//  Zabayeh
//
//  Created by endpoint on 5/17/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import FTToastIndicator
class OffersVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    var offers = [JSON]()
    var offer_id = 0
    var txt = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "OffersCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "OffersCell")
        tableView.delegate = self
        tableView.dataSource = self
        getoffers()
    }
    func getoffers(){
        SVProgressHUD.show()
        Helper_API().getOffers { (code, result) in
            SVProgressHUD.dismiss()
            if code == 200 {
                if let data = result {
                    if data.count > 0 {
                        self.tableView.isHidden = false
                        self.offers = data
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OffersCell", for: indexPath) as! OffersCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let pos = indexPath.row
        let item = offers[pos]
        cell.logo.setImage(from: imageURL + item["image"].stringValue)
        cell.titleLB.text = item["name"].stringValue
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let pos = indexPath.row
               let item = offers[pos]
        offer_id = item["id"].intValue
        txt = item["name"].stringValue
        performSegue(withIdentifier: "offerSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "offerSegue" {
            let des = segue.destination as! SubOffersVC
            des.offer_id = offer_id
            des.txt = txt
        }
    }
    
    
}
