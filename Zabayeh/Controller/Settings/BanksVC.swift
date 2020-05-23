//
//  BanksVC.swift
//  Zabayeh
//
//  Created by endpoint on 5/23/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit

class BanksVC: UIViewController {

    
    @IBOutlet weak var banksLB: UILabel!
    var txt = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        banksLB.text = txt
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
