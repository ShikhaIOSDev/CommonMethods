//
//  ApiManager.swift
//
//  Created by TechnoMac6 on 16/03/20.
//  Copyright © 2020 TechnoMac6. All rights reserved.
//

import Foundation
import UIKit

//MARK:- APIWithName.....

let AppName = "Practice"
let APIKEY = "ch05TLuPLutrLewrLuCr"
let APIMessageParam  = "message"
var pageInteger = Int()
var idStr = String()
var attachParam = String()
var idInt = Int()

enum APIWithName {
    case login
    case logout
    case register
}

public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case OPTIONS
}

extension APIWithName: Endpoint {
    var base: String {
        
        return "base url"
    }
    
    var path: String {
        switch self {
        case .login : return "login"
        case .register: return "register"
        case .logout: return "logout"
        }
    }
}

class APIManager  {
  
  static let shared = APIManager()
  let session: URLSession
  
  init(configuration: URLSessionConfiguration) {
    self.session = URLSession(configuration: configuration)
  }
  
  convenience init() {
    self.init(configuration: .default)
  }
}

extension APIManager {
    
    func switchKey<T, U>(_ myDict: inout [T:U], fromKey: T, toKey: T) {
        if let entry = myDict.removeValue(forKey: fromKey) {
            myDict[toKey] = entry
        }
    }
    
    /// Api call with custom method (POST)
    ///
    /// - Parameters:
    ///   - dicData: param to pass
    ///   - header: to be pass for header data (Authtoken)
    ///   - image: optional image for image upload
    ///   - imgKey: optional image key for image upload
    ///   - ApiName: apiname with enum
    ///   - method: for passing method i.e. POST, DELETE etc.
    ///   - completionHandler: dictionary with bool to identify success or failure
    //
    
    func jsonCallwithFormData(header:NSDictionary? = nil, dicData: NSDictionary ,withImage images : [String:UIImage]? = nil, imgKey : String? = nil, ApiName : APIWithName ,method:HTTPMethod, completionHandler:@escaping (NSMutableDictionary?, Bool, Int?) -> Swift.Void)
    {
        var urlRequest = NSMutableURLRequest()
        
        if images != nil && imgKey != nil{
            urlRequest = ApiName.requestWithImage
            urlRequest.httpBody = Parameters.imagedata(dicData, images!, imgKey!)
        } else {
            urlRequest = ApiName.request
            urlRequest.httpBody = Parameters.setBodyData(dicData)
        }
        if let dict = header {
            let key = dict.allKeys.first //we have only one key for now
            urlRequest.setValue(dict.value(forKey:key as! String) as? String, forHTTPHeaderField: key as! String)
        }
        urlRequest.httpMethod = method.rawValue
        //   urlRequest.addValue(APIKEY, forHTTPHeaderField: "ApiKey")
        if UserDefaults.standard.value(forKey: "auth_token") != nil{
            let BaseLoginString = UserDefaults.standard.value(forKey: "auth_token") as! String
            urlRequest.addValue(BaseLoginString, forHTTPHeaderField: "AUTH-TOKEN")
        }
        print(urlRequest.allHTTPHeaderFields as Any)
        
        
        let task = session.dataTask(with: urlRequest as URLRequest) { data, response, error in
            
            if error != nil || data == nil
            {
                return
                    // FIXME: Fix Alert
                    //          Alert.shared.showAlertMessage(titleStr: AppName, messageStr: (error?.localizedDescription)!, handler: { })
                    completionHandler(nil,false, 300)
            } else {
                do
                {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableDictionary
                    print(jsonResult ?? "nil")
                    if jsonResult != nil
                    {
                        if let dt = jsonResult {
                            let status = dt.value(forKey: "responseCode") as? Int
                            if  status != 200 {
                                completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,false, status)
                                
                            } else {
                                completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,true, status)
                            }
                        } else {
                            completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,false, nil)
                        }
                    } else {
                        print(error?.localizedDescription ?? "error")
                        // FIXME: Fix Alert
                        //  Alert.shared.showAlertMessage(titleStr: AppName, messageStr: (error?.localizedDescription)!, handler: { })
                        completionHandler(nil, false, nil)
                    }
                }
                catch
                {
                    print(error.localizedDescription)
                    // FIXME: Fix Alert
                    //    Alert.shared.showAlertMessage(titleStr: AppName, messageStr: error.localizedDescription, handler: { })
                    completionHandler(nil,false, nil)
                }
            }
        }
        task.resume()
    }
    
    //    func jsonCallwithFormDataImages(header:NSDictionary? = nil, dicData: NSDictionary ,withImage images : [UIImage]? = nil, imgKey : String? = nil, ApiName : APIWithName ,method:HTTPMethod, completionHandler:@escaping (NSMutableDictionary?, Bool, Int?) -> Swift.Void)
    func jsonCallwithFormDataImages(header:NSDictionary? = nil, dicData: NSDictionary ,withImage images : [String:UIImage]? = nil, imgKey : String? = nil, ApiName : APIWithName ,method:HTTPMethod, completionHandler:@escaping (NSMutableDictionary?, Bool, Int?) -> Swift.Void)
    {
        var urlRequest = NSMutableURLRequest()
        
        if images != nil && imgKey != nil{
            urlRequest = ApiName.requestWithMultipleImage
            //            urlRequest.httpBody = Parameters.imagedata(dicData, images!, imgKey!)
            urlRequest.httpBody = Parameters.multiplcimagedata(dicData, images!, imgKey!)
        } else {
            urlRequest = ApiName.request
            urlRequest.httpBody = Parameters.setBodyData(dicData)
        }
        if let dict = header {
            let key = dict.allKeys.first //we have only one key for now
            urlRequest.setValue(dict.value(forKey:key as! String) as? String, forHTTPHeaderField: key as! String)
        }
        urlRequest.httpMethod = method.rawValue
        //   urlRequest.addValue(APIKEY, forHTTPHeaderField: "ApiKey")
        if UserDefaults.standard.value(forKey: "auth_token") != nil{
            let BaseLoginString = UserDefaults.standard.value(forKey: "auth_token") as! String
            urlRequest.addValue(BaseLoginString, forHTTPHeaderField: "AUTH-TOKEN")
        }
        print(urlRequest.allHTTPHeaderFields as Any)
        
        
        let task = session.dataTask(with: urlRequest as URLRequest) { data, response, error in
            
            if error != nil || data == nil
            {
                return
                    // FIXME: Fix Alert
                    //          Alert.shared.showAlertMessage(titleStr: AppName, messageStr: (error?.localizedDescription)!, handler: { })
                    completionHandler(nil,false, 300)
            } else {
                do
                {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableDictionary
                    print(jsonResult ?? "nil")
                    if jsonResult != nil
                    {
                        if let dt = jsonResult {
                            let status = dt.value(forKey: "responseCode") as? Int
                            if  status != 200 {
                                completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,false, status)
                                
                            } else {
                                completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,true, status)
                            }
                        } else {
                            completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,false, nil)
                        }
                    } else {
                        print(error?.localizedDescription ?? "error")
                        // FIXME: Fix Alert
                        //  Alert.shared.showAlertMessage(titleStr: AppName, messageStr: (error?.localizedDescription)!, handler: { })
                        completionHandler(nil, false, nil)
                    }
                }
                catch
                {
                    print(error.localizedDescription)
                    // FIXME: Fix Alert
                    //    Alert.shared.showAlertMessage(titleStr: AppName, messageStr: error.localizedDescription, handler: { })
                    completionHandler(nil,false, nil)
                }
            }
        }
        task.resume()
    }
    
    func jsonCallwithFormDataWithId(header:NSDictionary? = nil, dicData: NSDictionary ,withImage images : [String:UIImage]? = nil, imgKey : String? = nil, ApiName : APIWithName ,idInteger: Int, method:HTTPMethod, completionHandler:@escaping (NSMutableDictionary?, Bool, Int?) -> Swift.Void)
    {
        idInt = idInteger
        var urlRequest = NSMutableURLRequest()
        
        if images != nil && imgKey != nil{
            urlRequest = ApiName.requestWithImageWithId
            urlRequest.httpBody = Parameters.imagedata(dicData, images!, imgKey!)
        } else {
            urlRequest = ApiName.requestWithId
            urlRequest.httpBody = Parameters.setBodyData(dicData)
        }
        if let dict = header {
            let key = dict.allKeys.first //we have only one key for now
            urlRequest.setValue(dict.value(forKey:key as! String) as? String, forHTTPHeaderField: key as! String)
        }
        urlRequest.httpMethod = method.rawValue
        //   urlRequest.addValue(APIKEY, forHTTPHeaderField: "ApiKey")
        if UserDefaults.standard.value(forKey: "auth_token") != nil{
            let BaseLoginString = UserDefaults.standard.value(forKey: "auth_token") as! String
            urlRequest.addValue(BaseLoginString, forHTTPHeaderField: "AUTH-TOKEN")
        }
        print(urlRequest.allHTTPHeaderFields as Any)
        
        let task = session.dataTask(with: urlRequest as URLRequest) { data, response, error in
            
            if error != nil || data == nil
            {
                return
                    // FIXME: Fix Alert
                    //          Alert.shared.showAlertMessage(titleStr: AppName, messageStr: (error?.localizedDescription)!, handler: { })
                    completionHandler(nil,false, 300)
            } else {
                do
                {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableDictionary
                    print(jsonResult ?? "nil")
                    if jsonResult != nil
                    {
                        if let dt = jsonResult {
                            let status = dt.value(forKey: "responseCode") as? Int
                            if  status != 200 {
                                completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,false, status)
                                
                            } else {
                                completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,true, status)
                            }
                        } else {
                            completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,false, nil)
                        }
                    } else {
                        print(error?.localizedDescription ?? "error")
                        // FIXME: Fix Alert
                        //  Alert.shared.showAlertMessage(titleStr: AppName, messageStr: (error?.localizedDescription)!, handler: { })
                        completionHandler(nil, false, nil)
                    }
                }
                catch
                {
                    print(error.localizedDescription)
                    // FIXME: Fix Alert
                    //    Alert.shared.showAlertMessage(titleStr: AppName, messageStr: error.localizedDescription, handler: { })
                    completionHandler(nil,false, nil)
                }
            }
        }
        task.resume()
    }
    
    func jsonCallwithGet(dicData: NSDictionary?, ApiName : APIWithName , completionHandler:@escaping (NSMutableDictionary?, Bool, Int?) -> Swift.Void)
    {
        var urlRequest = NSMutableURLRequest()
        urlRequest = ApiName.requestWithGet
        var urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)
        urlRequest.url = urlComponents?.url
        print("updated url \(String(describing: urlRequest.url))")
        
        if UserDefaults.standard.value(forKey: "auth_token") != nil{
            let BaseLoginString = UserDefaults.standard.value(forKey: "auth_token") as! String
            urlRequest.addValue(BaseLoginString, forHTTPHeaderField: "AUTH-TOKEN")
        }
        
        print(urlRequest.allHTTPHeaderFields)
        let task = session.dataTask(with: urlRequest as URLRequest) { data, response, error in
            
            if error != nil || data == nil
            {
                print(error!.localizedDescription)
                completionHandler(nil,false, 300)
            } else {
                do
                {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableDictionary
                    print(jsonResult ?? "nil")
                    if jsonResult != nil{
                        if let dt = jsonResult {
                            let status = dt.value(forKey: "responseCode") as? Int
                            if  status != 200 {
                                completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,false, status)
                                
                            } else {
                                completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,true, status)
                            }
                        } else {
                            completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,false, nil)
                        }
                    }
                    else {
                        print(error?.localizedDescription ?? "error")
                        completionHandler(nil, false, nil)
                    }
                }
                catch
                {
                    print(error.localizedDescription)
                    completionHandler(nil,false, nil)
                }
            }
        }
        task.resume()
    }
    
    //new Changes__
    func jsonCallwithPostWithoutParam(dicData: NSDictionary?, ApiName : APIWithName , method:HTTPMethod, completionHandler:@escaping (NSMutableDictionary?, Bool, Int?) -> Swift.Void)
    {
        var urlRequest = NSMutableURLRequest()
        urlRequest = ApiName.request
        
        var urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)
        urlRequest.url = urlComponents?.url
        print("updated url \(String(describing: urlRequest.url))")
        
        if UserDefaults.standard.value(forKey: "auth_token") != nil{
            let BaseLoginString = UserDefaults.standard.value(forKey: "auth_token") as! String
            urlRequest.addValue(BaseLoginString, forHTTPHeaderField: "AUTH-TOKEN")
        }
        
        print(urlRequest.allHTTPHeaderFields)
        let task = session.dataTask(with: urlRequest as URLRequest) { data, response, error in
            
            if error != nil || data == nil
            {
                print(error!.localizedDescription)
                completionHandler(nil,false, 300)
            } else {
                do
                {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableDictionary
                    print(jsonResult ?? "nil")
                    if jsonResult != nil{
                        if let dt = jsonResult {
                            let status = dt.value(forKey: "responseCode") as? Int
                            if  status != 200 {
                                completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,false, status)
                                
                            } else {
                                completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,true, status)
                            }
                        } else {
                            completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,false, nil)
                        }
                    }
                    else {
                        print(error?.localizedDescription ?? "error")
                        completionHandler(nil, false, nil)
                    }
                }
                catch
                {
                    print(error.localizedDescription)
                    completionHandler(nil,false, nil)
                }
            }
        }
        task.resume()
    }
    
    func jsonCallwithGetWithId(dicData: NSDictionary? , ApiName : APIWithName , idString: String,  completionHandler:@escaping (NSMutableDictionary?, Bool, Int?) -> Swift.Void)
    {
        // pageInteger = pageIndex
        idStr = idString
        var urlRequest = NSMutableURLRequest()
        urlRequest = ApiName.requestWithGetWithId
        let urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)
        
        // let dic = (dicData as? Dictionary<String, Any>).queryParameters
        //urlComponents?.query = dic
        urlRequest.url = urlComponents?.url
        print("updated url \(String(describing: urlRequest.url))")
        
        
        //    if dicData != nil {
        //      urlRequest.httpBody = Parameters.setBodyData(dicData!)
        //    }
        // urlRequest.addValue(APIKEY, forHTTPHeaderField: "ApiKey")
        if UserDefaults.standard.value(forKey: "auth_token") != nil{
              let BaseLoginString = UserDefaults.standard.value(forKey: "auth_token") as! String
           // let BaseLoginString = "kpS45cCZ8KypQstBV9PSP3b44MYqxc0JEkr9YbJqKDT3L2D9k6e4jeChJ6xHe2Ws_1568800720"
            
            urlRequest.setValue(BaseLoginString, forHTTPHeaderField: "AUTH-TOKEN")
        }
        print(urlRequest.allHTTPHeaderFields)
        let task = session.dataTask(with: urlRequest as URLRequest) { data, response, error in
            
            if error != nil || data == nil
            {
                print(error!.localizedDescription)
                // FIXME: Fix Alert
                //   Alert.shared.showAlertMessage(titleStr: AppName, messageStr: (error?.localizedDescription)!, handler: { })
                completionHandler(nil,false, nil)
            } else {
                do
                {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableDictionary
                    print(jsonResult ?? "nil")
                    if jsonResult != nil{
                        if let dt = jsonResult {
                            let status = dt.value(forKey: "responseCode") as? Int
                            if  status != 200 {
                                completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,false, status)
                            } else {
                                completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,true, status)
                            }
                        } else {
                            completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,false, nil)
                        }
                    } else {
                        print(error?.localizedDescription ?? "error")
                        // FIXME: Fix Alert
                        completionHandler(nil, false, nil)
                    }
                }catch{
                    print(error.localizedDescription)
                    // FIXME: Fix Alert
                    //   Alert.shared.showAlertMessage(titleStr: AppName, messageStr: error.localizedDescription, handler: { })
                    completionHandler(nil,false, nil)
                }
            }
        }
        task.resume()
    }
    
}


//MARK: Parameter & Endpoint

class Parameters: NSObject {

  /**
   Request method enum to String
   
   - returns: returns string as request type
   */
  
  static func setBodyData(_ params : NSDictionary) -> Data? {
    do {
      let body = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
      return body
    } catch {
      return nil
    }
  }
    
    static func imagedata(_ parameters : NSDictionary ,_ images :[String:UIImage],_ filePathKey : String) -> Data
    {
        var body = Data()
        for (key, value) in parameters {
            if let anEncoding = "\r\n--\(Parameters.generateBoundaryString())\r\n".data(using: .utf8) {
                body.append(anEncoding)
            }
            if let anEncoding = ("Content-Disposition: form-data; name=\"\(String(describing:key))".data(using: .utf8)) {
                body.append(anEncoding)
            }
            body.append("\r\n\r\n\(String(describing:value))".data(using: .utf8)!)
        }
        
        for (key, value) in images {
            
            let image: UIImage = value
            
            let imageData = image.jpegData(compressionQuality: 0.5)
            if let anEncoding = "\r\n--\(Parameters.generateBoundaryString())\r\n".data(using: .utf8) {
                body.append(anEncoding)
            }
            
           // let number = Int(arc4random_uniform(6) + 1)
            let number = CGFloat.random(in: 1...1000000)
            let filename = "\(number)"+"image.png"
            
            if let anEncoding = ("Content-Disposition: form-data; name=\"\(String(describing: key))\"; filename=\"\(filename)\"\r\n ").data(using: .utf8) {
                body.append(anEncoding)
            }
            if let anEncoding = ("Content-Type: image/png\r\n\r\n").data(using: .utf8) {
                body.append(anEncoding)
            }
            if imageData != nil {
                body.append(imageData!)
            }
            if let anEncoding = "\r\n".data(using: .utf8) {
                body.append(anEncoding)
            }
            
            if let anEncoding = "--\(Parameters.generateBoundaryString())--\r\n".data(using: .utf8) {
                body.append(anEncoding)
            }
        }
        return body
    }
  
    static func multiplcimagedata(_ parameters : NSDictionary ,_ images :[String:UIImage],_ filePathKey : String) -> Data
    {
        var body = Data()
        for (key, value) in parameters {
            if let anEncoding = "\r\n--\(Parameters.generateBoundaryString())\r\n".data(using: .utf8) {
                body.append(anEncoding)
            }
            if let anEncoding = ("Content-Disposition: form-data; name=\"\(String(describing:key))".data(using: .utf8)) {
                body.append(anEncoding)
            }
            body.append("\r\n\r\n\(String(describing:value))".data(using: .utf8)!)
        }
        
        for (key, value) in images {
            
            let image: UIImage = value
            
            let imageData = image.jpegData(compressionQuality: 0.5)
            if let anEncoding = "\r\n--\(Parameters.generateBoundaryString())\r\n".data(using: .utf8) {
                body.append(anEncoding)
            }
            
            // let number = Int(arc4random_uniform(6) + 1)
            let number = CGFloat.random(in: 1...1000000)
            let filename = "\(number)"+"image.png"
            if let anEncoding = ("Content-Disposition: form-data; name=\"\(String(describing: key))\"; filename=\"\(filename)\"\r\n ").data(using: .utf8) {
                body.append(anEncoding)
            }
            if let anEncoding = ("Content-Type: image/png\r\n\r\n").data(using: .utf8) {
                body.append(anEncoding)
            }
            if imageData != nil {
                body.append(imageData!)
            }
            if let anEncoding = "\r\n".data(using: .utf8) {
                body.append(anEncoding)
            }
            
            if let anEncoding = "--\(Parameters.generateBoundaryString())--\r\n".data(using: .utf8) {
                body.append(anEncoding)
            }
        }
        
        //        for (index, value) in images.enumerated() {
        //
        //            let image: UIImage = value
        //
        //            let imageData = image.jpegData(compressionQuality: 0.7)
        //            if let anEncoding = "\r\n--\(Parameters.generateBoundaryString())\r\n".data(using: .utf8) {
        //                body.append(anEncoding)
        //            }
        //
        //            // let number = Int(arc4random_uniform(6) + 1)
        //            let number = CGFloat.random(in: 1...1000000)
        //            let filename = "\(number)"+"image.png"
        //            let key = filePathKey+"\([index])"
        //            //  let key = filePathKey
        //            if let anEncoding = ("Content-Disposition: form-data; name=\"\(String(describing: key))\"; filename=\"\(filename)\"\r\n ").data(using: .utf8) {
        //                body.append(anEncoding)
        //            }
        //
        //            //            if let anEncoding = ("Content-Disposition: form-data;  filename=\"\(filename)\"\r\n ").data(using: .utf8) {
        //            //                body.append(anEncoding)
        //            //            }
        //
        //            if let anEncoding = ("Content-Type: image/png\r\n\r\n").data(using: .utf8) {
        //                body.append(anEncoding)
        //            }
        //            if imageData != nil {
        //                body.append(imageData!)
        //            }
        //            if let anEncoding = "\r\n".data(using: .utf8) {
        //                body.append(anEncoding)
        //            }
        //
        //            if let anEncoding = "--\(Parameters.generateBoundaryString())--\r\n".data(using: .utf8) {
        //                body.append(anEncoding)
        //            }
        //        }
        return body
    }
  
  static func generateBoundaryString() -> String {
    return "----------V2ymHFg03ehbqgZCaKO6jy"
  }
}

protocol Endpoint {
  var base : String { get }
  var path : String { get }
  
}

extension Endpoint {
    
    var requestWithGetWithId : NSMutableURLRequest {
        //  let url = URL.init(string: "\(base)\(path)\(idStr)")!
        
        let str = "\(base)\(path)\(idStr)"
        let trimurl = str.replacingOccurrences(of: " ", with: "%20")
        let url = URL.init(string: trimurl)!
        
        let requestt = NSMutableURLRequest()
        requestt.url = url
        requestt.httpMethod = HTTPMethod.GET.rawValue //"GET"
        requestt.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestt.timeoutInterval = 60.0
        print(url)
        return requestt
    }
    
    var request: NSMutableURLRequest {
        let url = URL.init(string: "\(base)\(path)")!
        let requestt = NSMutableURLRequest()
        requestt.url = url
        print("Request url \(url)")
        requestt.httpMethod = HTTPMethod.POST.rawValue//"POST"
        requestt.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestt.timeoutInterval = 60.0
        
        return requestt
    }
    
    var requestWithId: NSMutableURLRequest {
        let url = URL.init(string: "\(base)\(path)\(idInt)")!
        let requestt = NSMutableURLRequest()
        requestt.url = url
        print("Request url \(url)")
        requestt.httpMethod = HTTPMethod.POST.rawValue//"POST"
        requestt.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestt.timeoutInterval = 60.0
        return requestt
    }
    
    var requestWithImageWithId : NSMutableURLRequest {
        
        let url = URL.init(string: "\(base)\(path)\(idInt)")!
        let request = NSMutableURLRequest()
        request.url = url
        print(url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies = false
        request.httpMethod = HTTPMethod.POST.rawValue //"POST"
        request.timeoutInterval = 180.0
        // set Content-Type in HTTP header
        let BoundaryConstant = "----------V2ymHFg03ehbqgZCaKO6jy"
        let contentType = "multipart/form-data;boundary=\(BoundaryConstant)"
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    var requestWithImage : NSMutableURLRequest {
        
        let url = URL.init(string: "\(base)\(path)")!
        let request = NSMutableURLRequest()
        request.url = url
        print(url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies = false
        request.httpMethod = HTTPMethod.POST.rawValue //"POST"
        request.timeoutInterval = 180.0
        // set Content-Type in HTTP header
        let BoundaryConstant = "----------V2ymHFg03ehbqgZCaKO6jy"
        let contentType = "multipart/form-data;boundary=\(BoundaryConstant)"
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    var requestWithMultipleImage : NSMutableURLRequest {
        
        let url = URL.init(string: "\(base)\(path)")!
        let request = NSMutableURLRequest()
        request.url = url
        print(url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies = false
        request.httpMethod = HTTPMethod.POST.rawValue //"POST"
        request.timeoutInterval = 180.0
        // set Content-Type in HTTP header
        let BoundaryConstant = "----------V2ymHFg03ehbqgZCaKO6jy"
        let contentType = "multipart/form-data;boundary=\(BoundaryConstant)"
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    var requestWithGet: NSMutableURLRequest {
        let url = URL.init(string: "\(base)\(path)")!
        let requestt = NSMutableURLRequest()
        requestt.url = url
        requestt.httpMethod = HTTPMethod.GET.rawValue //"GET"
        requestt.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestt.timeoutInterval = 60.0
        print("url is____-",url)
        return requestt
    }
}

extension Dictionary {
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
}



