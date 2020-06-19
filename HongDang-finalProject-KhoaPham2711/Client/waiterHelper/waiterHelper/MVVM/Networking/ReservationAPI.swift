//
//  ReservationAPI.swift
//  waiterHelper
//
//  Created by HongDang on 3/20/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
import Alamofire

typealias GetReservationHandler = ((_ model: ReservationResponse?)->Void)

class ReservationAPI {
    static var shared = ReservationAPI()
    
    let APIReservation = "get/reservation"
    
    func GetReservation(parameters:[String:String]?, headers:HTTPHeaders?, completion:@escaping GetReservationHandler){
        let url = Server + APIReservation
        RequestService.shared.AFRequestWith(url: url, method: .get, parameters: parameters, headers: headers, objectType: ReservationResponse.self) { (result, data, error) in
            if result {
                guard let model = data as? ReservationResponse else{
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
