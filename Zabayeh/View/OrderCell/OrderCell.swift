//
//  OrderCell.swift
//  Zabayeh
//
//  Created by endpoint on 5/23/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    @IBOutlet weak var priceLB: UILabel!
    @IBOutlet weak var dateLB: UILabel!
    
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var logo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        logo.layer.borderWidth = 1.0
        logo.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        logo.circleView()
        bgView.RoundCorners(cornerRadius: 5.0)
        bgView.dropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
