//
//  HomeVC.swift
//  Zabayeh
//
//  Created by endpoint on 5/16/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit
import ImageSlideshow
import SwiftyJSON
import SVProgressHUD
import FTToastIndicator
class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var slideView: ImageSlideshow!
    override func viewDidLoad() {
        super.viewDidLoad()
        getSlider()
        
    }
    func getSlider(){
        SVProgressHUD.show()
        Helper_API().getSlider { (code, result) in
            SVProgressHUD.dismiss()
            if code == 200 {
                if let data = result{
                    self.configSliderShow(self.slideView, data)
                }
            }else{
                FTToastIndicator.setToastIndicatorStyle(.dark)
                FTToastIndicator.showToastMessage("fail".localized())
            }
        }
    }
    func configSliderShow(_ slideView:ImageSlideshow,_ SlideImages:[JSON]) {
        slideView.slideshowInterval = 5.0
        slideView.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        slideView.contentScaleMode = UIView.ContentMode.scaleAspectFill
        let pageControl = UIPageControl()
        //043A70
        pageControl.currentPageIndicatorTintColor = UIColor(hexString: "#043A70")
        pageControl.pageIndicatorTintColor = UIColor.white
        slideView.pageIndicator = pageControl
        slideView.activityIndicator = DefaultActivityIndicator()
        slideView.activityIndicator = DefaultActivityIndicator(style: .gray , color: nil )
        slideView.addSubview(pageControl)
        slideShow(slideView,SlideImages)
    }
    func slideShow(_ slideView:ImageSlideshow,_ slideImages:[JSON]) {
        var imgSource = [InputSource]()
        for item in slideImages{
            imgSource.append(KingfisherSource(urlString: item.stringValue)!)
        }
        slideView.setImageInputs(imgSource)
    }
    
    
    
}
