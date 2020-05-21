//
//  Auth_API.swift
//  Zabayeh
//
//  Created by endpoint on 5/20/20.
//  Copyright © 2020 endPoint. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class Auth_API:NSObject{
    let defaults = UserDefaults.standard
    func login(mobile:String,completion : @escaping(_ code: Int) -> () ){
          
          let parameters : [String : Any] = [
              "mobile":mobile
          ]
          
          Alamofire.request(loginURL, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
              
              switch response.response?.statusCode {
              case 200?:
                  switch response.result
                  {
                  case .failure( let error):
                      print(error)
                      completion(response.response!.statusCode)
                  case .success(let data):
                      let jsonx = JSON(data)
                      let json = jsonx["innerData"]
                      print(json)
                      self.defaults.set(json["id"].intValue, forKey: "id")
                      self.defaults.set(json["mobile"].stringValue, forKey: "mobile")
                      self.defaults.set(json["name"].stringValue, forKey: "name")
                      self.defaults.set(json["role"].stringValue, forKey: "role")
//                      self.defaults.set(true, forKey: "is_login")
                      completion(response.response!.statusCode)
                  }
              default:
                  print("get login code  == \(response.response?.statusCode ?? 0)")
                  if let requestBody = response.request?.httpBody {
                      do {
                          let jsonArray = try JSONSerialization.jsonObject(with: requestBody, options: [])
                          print("Array: \(jsonArray)")
                      }
                      catch {
                          print("Error: \(error)")
                      }
                  }
                  completion(response.response?.statusCode ?? 0)
              }
              
              
          }
      }
    
    func register(name:String,password:String,mobile:String,completion : @escaping(_ code: Int) -> () ){
        
        let parameters : [String : Any] = [
            "mobile":mobile,
            "password":password,
            "name":name
        ]
        
        Alamofire.request(registerURL, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            
            switch response.response?.statusCode {
            case 200?:
                switch response.result
                {
                case .failure( let error):
                    print(error)
                    completion(response.response!.statusCode)
                case .success(let data):
                    let jsonx = JSON(data)
                    let json = jsonx["innerData"]
                    print(json)
                    self.defaults.set(json["id"].intValue, forKey: "id")
                    self.defaults.set(json["mobile"].stringValue, forKey: "mobile")
                    self.defaults.set(json["name"].stringValue, forKey: "name")
                    self.defaults.set(json["role"].stringValue, forKey: "role")
                    self.defaults.set(true, forKey: "is_login")
                    completion(response.response!.statusCode)
                }
            default:
                print("get login code  == \(response.response?.statusCode ?? 0)")
                if let requestBody = response.request?.httpBody {
                    do {
                        let jsonArray = try JSONSerialization.jsonObject(with: requestBody, options: [])
                        print("Array: \(jsonArray)")
                    }
                    catch {
                        print("Error: \(error)")
                    }
                }
                completion(response.response?.statusCode ?? 0)
            }
            
            
        }
    }
      
}
