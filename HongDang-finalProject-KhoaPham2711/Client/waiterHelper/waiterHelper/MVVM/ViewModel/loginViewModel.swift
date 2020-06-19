//
//  loginViewModel.swift
//  waiterHelper
//
//  Created by HongDang on 2/20/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
class LoginViewModel {
    var email:String = ""{
        didSet{}
    }
    var pass:String = ""{
        didSet{}
    }
    var token:String = ""{
        didSet{
            
        }
    }
    
    func Login(completion:@escaping UserSuccessHandel){
        let param = [
            "email": self.email,
            "password": self.pass
        ]
        AuthenAPI.shared.Login(parameters: param, headers: nil) { (model) in
            guard let model = model else {
                completion(nil)
                return
            }
            completion(model)
        }
    }
    func CheckToken(completion:@escaping UserSuccessHandel){
        let param = [
            "token": self.token
        ]
        AuthenAPI.shared.CheckToken(parameters: param, headers: nil) { (model) in
            guard let model = model else {
                completion(nil)
                return
            }
            completion(model)
        }
    }
    
}
