//
//  UIView.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/29/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation
import UIKit
import MOLH
extension UIView{
   var transformUponLocalization:Void {
          if MOLHLanguage.currentAppleLanguage() == "ar" {
              self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0) }
      }
    func RoundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
    }
   
    func dropShadow(scale: Bool = true) {
         layer.masksToBounds = false
             layer.shadowColor = UIColor.black.cgColor
             layer.shadowOpacity = 0.2
             layer.shadowOffset = .zero
             layer.shadowRadius = 3
             layer.shouldRasterize = true
             layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    func circleView(){
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
   
    func whiteBorder(){
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor(hexString: "#ffffff").cgColor
    }
    func blackBorder(){
           self.layer.borderWidth = 3.0
           self.layer.borderColor = UIColor(hexString: "#EEEEEE").cgColor
       }
    
    
    func pulsate() {
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = 0.4
    pulse.fromValue = 0.98
    pulse.toValue = 1.0
    pulse.autoreverses = true
    pulse.repeatCount = .infinity
    pulse.initialVelocity = 0.5
    pulse.damping = 1.0
    layer.add(pulse, forKey: nil)
    }
    func flash() {
    let flash = CABasicAnimation(keyPath: "opacity")
    flash.duration = 0.3
    flash.fromValue = 1
    flash.toValue = 0.1
    flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    flash.autoreverses = true
    flash.repeatCount = 2
    layer.add(flash, forKey: nil)
    }
    
}
