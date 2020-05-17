//
//  Helper_API.swift
//  Zabayeh
//
//  Created by endpoint on 5/16/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import MOLH
class Helper_API:NSObject{
    let defaults = UserDefaults.standard
    let is_arabic = MOLHLanguage.currentAppleLanguage() == "en" ? "en" : "ar"
    func getSlider(completion : @escaping(_ code: Int, _ result:[JSON]?) -> () ){
        Alamofire.request(sliderURL, method: .get, parameters: nil, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.response?.statusCode {
            case 200?:
                //print("get all cities == \(response.response?.statusCode ?? 0)")
                switch response.result{
                case .failure( let error):
                    print(error)
                    completion(response.response?.statusCode ?? 0,nil)
                case .success(let value):
                    let json = JSON(value)
                    let datobj = json["innerData"]
                 
                    completion(response.response?.statusCode ?? 0,datobj.arrayValue)
                }
            default:
                print("get slider code  == \(response.response?.statusCode ?? 0)")
                if let dat = response.data {
                    //print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON)
                }
                completion(response.response?.statusCode ?? 0,nil)
                
            }
        }
        
    }
    func getCategories(completion : @escaping(_ code: Int, _ result:[JSON]?) -> () ){
           Alamofire.request(categoriesURL, method: .get, parameters: nil, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
               switch response.response?.statusCode {
               case 200?:
                   //print("get all cities == \(response.response?.statusCode ?? 0)")
                   switch response.result{
                   case .failure( let error):
                       print(error)
                       completion(response.response?.statusCode ?? 0,nil)
                   case .success(let value):
                       let json = JSON(value)
                       let datobj = json["innerData"]
                    
                       completion(response.response?.statusCode ?? 0,datobj.arrayValue)
                   }
               default:
                   print("get categories code  == \(response.response?.statusCode ?? 0)")
                   if let dat = response.data {
                       //print(dat)
                       let responseJSON = try? JSON(data: dat)
                       print(responseJSON)
                   }
                   completion(response.response?.statusCode ?? 0,nil)
                   
               }
           }
           
       }
    func getproducts(category_id:Int,completion : @escaping(_ code: Int, _ result:[JSON]?) -> () ){
        let params = ["category_id":category_id]
        Alamofire.request(productsURL, method: .get, parameters: params, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
                  switch response.response?.statusCode {
                  case 200?:
                      //print("get all cities == \(response.response?.statusCode ?? 0)")
                      switch response.result{
                      case .failure( let error):
                          print(error)
                          completion(response.response?.statusCode ?? 0,nil)
                      case .success(let value):
                          let json = JSON(value)
                          let datobj = json["innerData"]
                       
                          completion(response.response?.statusCode ?? 0,datobj.arrayValue)
                      }
                  default:
                      print("get products code  == \(response.response?.statusCode ?? 0)")
                      if let dat = response.data {
                          //print(dat)
                          let responseJSON = try? JSON(data: dat)
                          print(responseJSON)
                      }
                      completion(response.response?.statusCode ?? 0,nil)
                      
                  }
              }
              
          }
    
    func getOffers(completion : @escaping(_ code: Int, _ result:[JSON]?) -> () ){
          Alamofire.request(offersURL, method: .get, parameters: nil, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
                    switch response.response?.statusCode {
                    case 200?:
                        //print("get all cities == \(response.response?.statusCode ?? 0)")
                        switch response.result{
                        case .failure( let error):
                            print(error)
                            completion(response.response?.statusCode ?? 0,nil)
                        case .success(let value):
                            let json = JSON(value)
                            let datobj = json["innerData"]
                         
                            completion(response.response?.statusCode ?? 0,datobj.arrayValue)
                        }
                    default:
                        print("get products code  == \(response.response?.statusCode ?? 0)")
                        if let dat = response.data {
                            //print(dat)
                            let responseJSON = try? JSON(data: dat)
                            print(responseJSON)
                        }
                        completion(response.response?.statusCode ?? 0,nil)
                        
                    }
                }
                
            }
    
    func getSubOffers(offer_id:Int,completion : @escaping(_ code: Int, _ result:[JSON]?) -> () ){
    let params = ["offer_id":offer_id]
    Alamofire.request(subOffersURL, method: .get, parameters: params, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
              switch response.response?.statusCode {
              case 200?:
                  //print("get all cities == \(response.response?.statusCode ?? 0)")
                  switch response.result{
                  case .failure( let error):
                      print(error)
                      completion(response.response?.statusCode ?? 0,nil)
                  case .success(let value):
                      let json = JSON(value)
                      let datobj = json["innerData"]["prods"]
                      completion(response.response?.statusCode ?? 0,datobj.arrayValue)
                  }
              default:
                  print("get products code  == \(response.response?.statusCode ?? 0)")
                  if let dat = response.data {
                      //print(dat)
                      let responseJSON = try? JSON(data: dat)
                      print(responseJSON)
                  }
                  completion(response.response?.statusCode ?? 0,nil)
                  
              }
          }
          
      }
}
