//
//  RequestService.swift
//  waiterHelper
//
//  Created by HongDang on 2/20/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
import Alamofire


// khai bao compleion co ten la CompletionHandleJSON tra ve 3 gia tri ket qua tra ve, data tra ve dang json, loi neu co
typealias CompletionHandleJSON = (_ result:Bool, _ json:Any?, _ error:Error?)->Void
struct RequestService {
    
    static var shared = RequestService()
    
    func AFRequestWith<T: Codable>(url: String, method: HTTPMethod, parameters: [String:String]?, headers: HTTPHeaders?, objectType: T.Type, completion:@escaping CompletionHandleJSON){
        AF.request(url,
                   method: method,
                   parameters: parameters,
                   encoder: URLEncodedFormParameterEncoder.default,
                   headers: headers,
                   interceptor: nil).response { (reponse) in
                    switch (reponse.result){
                    case .success(let data):
                        do {
                            let json = try JSONDecoder.init().decode(objectType.self, from: data!)
                            // tra gia ra ben ngoai ham bang completion handeler
                            completion(true, json, nil)
                        } catch {
                            //parse json khong dc
                            print("parse json khong dc")
                            completion (false,data,nil)
                        }
                    case .failure(let error):
                        print("res khong tra ve dc")
                        completion(false,nil,error)
                    }
                    
        }
    }
}
