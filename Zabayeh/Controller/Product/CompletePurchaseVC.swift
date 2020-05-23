//
//  CompletePurchaseVC.swift
//  Zabayeh
//
//  Created by endpoint on 5/18/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FlagPhoneNumber
import CoreData
import FTToastIndicator

class CompletePurchaseVC: UIViewController ,GMSMapViewDelegate,FPNTextFieldDelegate,CLLocationManagerDelegate{
    var validPhoneNumber = false
    var phoneCode:String?
    var phone:String?
    var codePhone = ""
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    var product = [String:String]()
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var phoneTF: FPNTextField!
    var locationManager = CLLocationManager()
    var lat:Double?
    var lon:Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        settings()
    }
    var markerSquirt = GMSMarker()
    var onLoc = true
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if onLoc {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            //  print("locations \(locValue.latitude) \(locValue.longitude)")
            let userLocation = locations.last!
            lat = userLocation.coordinate.latitude
            lon = userLocation.coordinate.longitude
            let camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, zoom: 9.0)
            viewMap.camera = camera
            reverseGeocodeCoordinate(locValue)
            
            markerSquirt.position = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            // markerSquirt.icon = UIImage(named: "marker")
            markerSquirt.map = viewMap
            onLoc = false
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let coordinate = position.target
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        lat = coordinate.latitude
        lon = coordinate.longitude
        viewMap.clear()
        reverseGeocodeCoordinate(coordinate)
        markerSquirt.position = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
        // markerSquirt.icon = UIImage(named: "marker")
        markerSquirt.map = viewMap
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        // 1
        let geocoder = GMSGeocoder()
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            // 3
            print("the lines is \(lines.joined(separator: "\n"))")
            self.addressTF.text = lines.joined(separator: "\n")
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    func settings(){
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
        viewMap.delegate = self
        viewMap.mapType = .normal
        add.RoundCorners(cornerRadius: 20.0)
        viewMap.RoundCorners(cornerRadius: 5.0)
        phoneTF.delegate = self
        phoneTF.hasPhoneNumberExample = false
        phoneTF.hasPhoneNumberExample = false // true by default
        phoneTF.placeholder = "Phone Number"
        phoneTF.setFlag(countryCode: FPNCountryCode(rawValue: Locale.current.regionCode!)!)
        phoneTF.displayMode = .list // .picker by default
        listController.setup(repository: phoneTF.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.phoneTF.setFlag(countryCode: country.code)
        }
    }
    
    
    
    @IBAction func addToCart(_ sender: Any) {
        let ph = phoneTF.text!
        let address = addressTF.text!
        if ph.isEmpty && address.isEmpty {
            FTToastIndicator.setToastIndicatorStyle(.dark)
            FTToastIndicator.showToastMessage("enterphonenumberAndSelectAddressOnMap".localized())
        }else if ph.isEmpty {
            FTToastIndicator.setToastIndicatorStyle(.dark)
            FTToastIndicator.showToastMessage("enterPhoneNumber".localized())
        }else if !validPhoneNumber {
            FTToastIndicator.setToastIndicatorStyle(.dark)
            FTToastIndicator.showToastMessage("enterValidPhoneNumber".localized())
        }else if address.isEmpty{
            FTToastIndicator.setToastIndicatorStyle(.dark)
            FTToastIndicator.showToastMessage("selectAddressOnMap".localized())
        }else{
            // add to cart
            let item = product
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Cart", in: context)
            let newEntry = NSManagedObject(entity: entity!, insertInto: context)
            
            newEntry.setValue(item["product_id"]!, forKey: "product_id")
            newEntry.setValue("\(UserDefaults.standard.integer(forKey: "id"))", forKey: "user_id")
            newEntry.setValue(codePhone + phone!, forKey: "mobile")
            newEntry.setValue("\(lon!)", forKey: "longitude")
            newEntry.setValue("\(lat!)", forKey: "latitude")
            newEntry.setValue(address, forKey: "address")
            newEntry.setValue(item["order_total"]!, forKey: "order_total")
            newEntry.setValue(item["kersh_and_mosran"]!, forKey: "kersh_and_mosran")
            newEntry.setValue(item["cutting"]!, forKey: "cutting")
            newEntry.setValue(item["covering"]!, forKey: "covering")
            newEntry.setValue(item["description"]!, forKey: "desc")
            newEntry.setValue(item["quantity"]!, forKey: "quantity")
            newEntry.setValue(item["name"]!, forKey: "name")
            newEntry.setValue(item["image"]!, forKey: "image")
            do{
                try context.save()
                FTToastIndicator.setToastIndicatorStyle(.dark)
                FTToastIndicator.showToastMessage("productAddedToCart".localized())
                //print("save")
            }catch{
                print("fail")
            }
        }
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        let x = dialCode.replacingOccurrences(of: "+", with: "00")
        codePhone = dialCode
        phoneCode = x
    }
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            validPhoneNumber = true
            phone = "\(textField.getRawPhoneNumber()!)"
        } else {
            validPhoneNumber = false
        }
    }
    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)
        present(navigationViewController, animated: true, completion: nil)
    }
    
}
