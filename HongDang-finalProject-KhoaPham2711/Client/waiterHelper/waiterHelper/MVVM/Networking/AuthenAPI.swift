//
//  AuthenAPI.swift
//  waiterHelper
//
//  Created by HongDang on 2/20/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
import Alamofire

typealias UserSuccessHandel = ((_ model: EmployeeResponse?)->Void)

class AuthenAPI {
    
    static var shared = AuthenAPI()
    
    let APILogin = "employ/login"
    let APIToken = "employ/check"
    
    func Login(parameters:[String:String]?, headers:HTTPHeaders?, completion:@escaping UserSuccessHandel){
        let url = Server + APILogin
        RequestService.shared.AFRequestWith(url: url, method: .post, parameters: parameters, headers: headers, objectType: EmployeeResponse.self) { (result, data, error) in
            if result {
                guard let model = data as? EmployeeResponse else{
                    completion(nil)
                    return
                }
                completion(model)
            } else {
                print(error?.localizedDescription ?? "error at response data")
                completion(nil)
            }
            
        }
    }
    func CheckToken(parameters:[String:String]?, headers:HTTPHeaders?, completion:@escaping UserSuccessHandel){
        let url = Server + APIToken
        RequestService.shared.AFRequestWith(url: url, method: .post, parameters: parameters, headers: headers, objectType: EmployeeResponse.self) { (result, data, error) in
            if result {
                guard let model = data as? EmployeeResponse else{
                    completion(nil)
                    return
                }
                completion(model)
            } else {
                print(error?.localizedDescription ?? "error at response data")
                completion(nil)
            }
            
        }
    }
}
