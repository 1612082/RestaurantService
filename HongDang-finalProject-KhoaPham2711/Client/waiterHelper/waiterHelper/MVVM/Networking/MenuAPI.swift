//
//  FoodAPI.swift
//  waiterHelper
//
//  Created by HongDang on 3/3/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
import Alamofire
typealias GetFoodHandel = ((_ model: MenuResponse?)->Void)
typealias GetCateHandel = ((_ model: CateResponse?)->Void)

class MenuAPI {
    static var shared = MenuAPI()
    
    let APIFood = "get/menu"
    let APICate = "get/category"
    
    func getFood(parameters:[String:String]?, headers:HTTPHeaders?, completion:@escaping GetFoodHandel){
        let url = Server + APIFood
        RequestService.shared.AFRequestWith(url: url, method: .get, parameters: parameters, headers: headers, objectType: MenuResponse.self) { (result, data, error) in
            if result {
                guard let model = data as? MenuResponse else{
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
    func getCate(parameters:[String:String]?, headers:HTTPHeaders?, completion:@escaping GetCateHandel){
        let url = Server + APICate
        RequestService.shared.AFRequestWith(url: url, method: .get, parameters: parameters, headers: headers, objectType: CateResponse.self) { (result, data, error) in
            if result {
                guard let model = data as? CateResponse else{
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
