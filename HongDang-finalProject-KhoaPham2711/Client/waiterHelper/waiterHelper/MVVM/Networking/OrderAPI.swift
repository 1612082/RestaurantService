
//
//  OrderAPI.swift
//  waiterHelper
//
//  Created by HongDang on 3/8/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
import Alamofire

typealias GetOrderHandler = ((_ model: OrderResponse?)->Void)

class OrderAPI {
    static var shared = OrderAPI()
    
    let APIOrder = "get/order"
    
    func GetOrder(parameters:[String:String]?, headers:HTTPHeaders?, completion:@escaping GetOrderHandler){
        let url = Server + APIOrder
        RequestService.shared.AFRequestWith(url: url, method: .get, parameters: parameters, headers: headers, objectType: OrderResponse.self) { (result, data, error) in
            if result {
                guard let model = data as? OrderResponse else{
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
