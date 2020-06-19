//
//  PaymentAPI.swift
//  waiterHelper
//
//  Created by HongDang on 3/18/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
import Alamofire
typealias GetBillHandel = ((_ model: PaymentResponse?)->Void)
typealias GetBillDetailHandel = ((_ model: PaymentDetailResponse?)->Void)
class PaymentAPI {
    let APIPayment = "get/bill"
    let APIBillDetail = "post/billdetail"
    
    static var shared = PaymentAPI()
    
    func GetBill(parameters:[String:String]?, headers:HTTPHeaders?, completion:@escaping GetBillHandel){
        let url = Server + APIPayment
        RequestService.shared.AFRequestWith(url: url, method: .get, parameters: parameters, headers: headers, objectType: PaymentResponse.self) { (result, data, error) in
            if result {
                guard let model = data as? PaymentResponse else{
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
    func GetBillDetail(parameters:[String:String]?, headers:HTTPHeaders?, completion:@escaping GetBillDetailHandel){
        let url = Server + APIBillDetail
        RequestService.shared.AFRequestWith(url: url, method: .post, parameters: parameters, headers: headers, objectType: PaymentDetailResponse.self) { (result, data, error) in
            if result {
                guard let model = data as? PaymentDetailResponse else{
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
