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
    func createNewOrder(params:[String:[[String:Any]]],completion : @escaping(_ success: Bool,_ code:Int) -> () ){
              let headers:[String:String] = [
                 "Content-Type":"application/json"
              ]
              
              Alamofire.request(creatnewOrderURL, method: .post, parameters: params, encoding:JSONEncoding.default , headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
                     switch response.response?.statusCode {

                     case 200?:
                         switch response.result{
                         case .failure( let error):
                             print(error)
                             completion(true,response.response?.statusCode ?? 0)
                         case .success(let value):
                             let json = JSON(value)
                             print(json)
                             completion(true,response.response?.statusCode ?? 0)
                         }
                     default:
                         print("get createOrder code  == \(response.response?.statusCode ?? 0)")
                         if let requestBody = response.request?.httpBody {
                         do {
                         let jsonArray = try JSONSerialization.jsonObject(with: requestBody, options: [])
                         print("Array: \(jsonArray)")
                         }
                         catch {
                         print("Error: \(error)")
                         }
                         }
                         completion(false,response.response?.statusCode ?? 0)
                         
                     }
                 }
                 
             }
    
    func getSettings(completion : @escaping(_ code: Int, _ result:JSON?) -> () ){
              Alamofire.request(settingsURL, method: .get, parameters: nil, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
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
                          completion(response.response?.statusCode ?? 0,datobj)
                      }
                  default:
                      print("get Settings code  == \(response.response?.statusCode ?? 0)")
                      if let dat = response.data {
                          //print(dat)
                          let responseJSON = try? JSON(data: dat)
                          print(responseJSON)
                      }
                      completion(response.response?.statusCode ?? 0,nil)
                      
                  }
              }
              
          }
    func contactUS(name:String,email:String,message:String,completion : @escaping(_ code: Int, _ result:JSON?) -> () ){
        let params = [
            "name":name,
            "email":email,
            "message":message
        ]
        Alamofire.request(contactUsURL, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
                      switch response.response?.statusCode {
                      case 200?:
                          //print("get all cities == \(response.response?.statusCode ?? 0)")
                          switch response.result{
                          case .failure( let error):
                              print(error)
                              completion(response.response?.statusCode ?? 0,nil)
                          case .success(let value):
                              let json = JSON(value)
                              let datobj = json
                              completion(response.response?.statusCode ?? 0,datobj)
                          }
                      default:
                          print("get Settings code  == \(response.response?.statusCode ?? 0)")
                          if let dat = response.data {
                              //print(dat)
                              let responseJSON = try? JSON(data: dat)
                              print(responseJSON)
                          }
                          completion(response.response?.statusCode ?? 0,nil)
                          
                      }
                  }
                  
              }
    
    func getOrders(status:Int,completion : @escaping(_ code: Int, _ result:[JSON]?) -> () ){
        let headers = [
            "Content-Type":"application/json"
        ]
        let params = ["user_id":UserDefaults.standard.integer(forKey: "id"),
                      "status":status
        ]
       Alamofire.request(MyOrdersURL, method: .get, parameters: params, encoding:URLEncoding.default , headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
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
                         print(datobj)
                         completion(response.response?.statusCode ?? 0,datobj.arrayValue)
                     }
                 default:
                     print("get My Orders code  == \(response.response?.statusCode ?? 0)")
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

