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
class HomeVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var slideView: ImageSlideshow!
    var cats = [JSON]()
    var layout = UICollectionViewFlowLayout()
    var category_id = 0
    var txt = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        getSlider()
        let nib = UINib(nibName: "CategoryCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CategoryCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 20)/2, height: 172.0)
        // layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout  = layout
        getcats()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let pos = indexPath.row
        let item = cats[pos]
        cell.logo.setImage(from: imageURL + item["image"].stringValue)
        cell.titleLB.text = item["name"].stringValue
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let pos = indexPath.row
               let item = cats[pos]
        category_id = item["id"].intValue
        txt = item["name"].stringValue
        performSegue(withIdentifier: "prodSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "prodSegue" {
            let des = segue.destination as! SubCatVC
            des.category_id = category_id
            des.txt = txt
        }
    }
    func getcats(){
        SVProgressHUD.show()
        Helper_API().getCategories { (code, result) in
            SVProgressHUD.dismiss()
            if code == 200 {
                if let data = result {
                    if data.count > 0 {
                        self.collectionView.isHidden = false
                        self.cats = data
                        self.collectionView.reloadData()
                        self.collectionView.layoutIfNeeded()
                        self.collectionView.heightAnchor.constraint(equalToConstant: self.collectionView.contentSize.height).isActive = true
                    }else{
                        self.collectionView.isHidden = true
                    }
                }else{
                    self.collectionView.isHidden = true
                }
            }else{
                self.collectionView.isHidden = true
                FTToastIndicator.setToastIndicatorStyle(.dark)
                FTToastIndicator.showToastMessage("fail".localized())
            }
        }
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
            imgSource.append(KingfisherSource(urlString: imageURL + item.stringValue)!)
        }
        slideView.setImageInputs(imgSource)
    }
    
    
    
}
