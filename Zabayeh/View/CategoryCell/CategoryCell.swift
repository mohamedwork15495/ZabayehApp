//
//  CategoryCell.swift
//  Zabayeh
//
//  Created by endpoint on 5/16/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLB: UILabel!
    
    @IBOutlet weak var logo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        logo.layer.borderWidth = 2.0
        logo.layer.borderColor = #colorLiteral(red: 0.833019793, green: 0.2301174104, blue: 0.2245136201, alpha: 1)
        logo.circleView()
        bgView.RoundCorners(cornerRadius: 5.0)
        bgView.dropShadow()
    }

}
