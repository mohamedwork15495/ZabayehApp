//
//  OffersCell.swift
//  Zabayeh
//
//  Created by endpoint on 5/17/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit

class OffersCell: UITableViewCell {
        @IBOutlet weak var bgView: UIView!
        
        @IBOutlet weak var titleLB: UILabel!
        @IBOutlet weak var blackView: UIView!
        @IBOutlet weak var logo: UIImageView!
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            logo.RoundCorners(cornerRadius: 10.0)
            bgView.RoundCorners(cornerRadius: 10.0)
            bgView.dropShadow()
            blackView.layer.cornerRadius = 10.0
            blackView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
            // Configure the view for the selected state
        }
        
    }
