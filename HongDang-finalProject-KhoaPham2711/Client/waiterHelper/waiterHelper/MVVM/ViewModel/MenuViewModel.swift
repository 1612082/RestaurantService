//
//  FoodViewModel.swift
//  waiterHelper
//
//  Created by HongDang on 3/3/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
class MenuViewModel {
    
    func GetMenu(completion:@escaping GetFoodHandel){
        MenuAPI.shared.getFood(parameters: [:], headers: nil) { (model) in
            guard let model = model else {
                completion(nil)
                return
            }
            completion(model)
        }
    }
    func GetCate(completion:@escaping GetCateHandel){
        MenuAPI.shared.getCate(parameters: [:], headers: nil) { (model) in
            guard let model = model else {
                completion(nil)
                return
            }
            completion(model)
        }
    }
}
