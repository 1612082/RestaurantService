//
//  PaymentViewModel.swift
//  waiterHelper
//
//  Created by HongDang on 3/18/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
class PaymentViewModel {
    var idBill:String = ""{
        didSet{}
    }
    func GetBill(completion:@escaping GetBillHandel){
        PaymentAPI.shared.GetBill(parameters: [:], headers: nil) { (model) in
            guard let model = model else {
                completion(nil)
                return
            }
            completion(model)
        }
    }

    func GetBillDetail(completion:@escaping GetBillDetailHandel){
        let param = [
            "idb": self.idBill,
        ]
        PaymentAPI.shared.GetBillDetail(parameters: param, headers: nil) { (model) in
            guard let model = model else {
                completion(nil)
                return
            }
            completion(model)
        }
    }
    func CountTotalPrice(_ arr:[BILLDETAIL]) -> Int{
        var s:Int = 0
        for i in arr {
            s += Int(i.PRICE)!*Int(i.QUANTITY)!
        }
        return s
    }
}
