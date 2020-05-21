//
//  CartCell.swift
//  Zabayeh
//
//  Created by endpoint on 5/20/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var countLB: UILabel!
    @IBOutlet weak var priceLB: UILabel!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        logo.layer.borderWidth = 1.0
        logo.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        logo.circleView()
        bgView.RoundCorners(cornerRadius: 5.0)
        bgView.dropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
