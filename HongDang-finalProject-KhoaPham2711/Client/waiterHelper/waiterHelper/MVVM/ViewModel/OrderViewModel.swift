//
//  OrderViewModel.swift
//  waiterHelper
//
//  Created by HongDang on 3/8/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
class OrderViewModel {
    
    func GetOrder(completion:@escaping GetOrderHandler){
        OrderAPI.shared.GetOrder(parameters: [:], headers: nil) { (model) in
            guard let model = model else {
                completion(nil)
                return
            }
            completion(model)
        }
    }

}
