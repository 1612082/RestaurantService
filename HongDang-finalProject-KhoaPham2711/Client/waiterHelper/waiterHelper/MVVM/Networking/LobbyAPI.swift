//
//  LobbyAPI.swift
//  waiterHelper
//
//  Created by HongDang on 2/29/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
import Alamofire
typealias GetLobbysHandel = ((_ model: LobbysResponse?)->Void)

typealias GetTblInLobbysHandel = ((_ model: TblInlobbyResponse?)->Void)
class LobbiAPI {
    static var shared = LobbiAPI()
    
    let APILobby = "get/lobby"
    let APITblInLobby = "get/table"
    let APIFreeTable = "get/freetable"
    
    func getLobbys(parameters:[String:String]?, headers:HTTPHeaders?, completion:@escaping GetLobbysHandel){
        let url = Server + APILobby
        RequestService.shared.AFRequestWith(url: url, method: .get, parameters: parameters, headers: headers, objectType: LobbysResponse.self) { (result, data, error) in
            if result {
                guard let model = data as? LobbysResponse else{
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
    func getTableInLobby(parameters:[String:String]?, headers:HTTPHeaders?, completion:@escaping GetTblInLobbysHandel){
        let url = Server + APITblInLobby
        RequestService.shared.AFRequestWith(url: url, method: .post, parameters: parameters, headers: headers, objectType: TblInlobbyResponse.self) { (result, data, error) in
            if result {
                guard let model = data as? TblInlobbyResponse else{
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
    func getFreeTable(parameters:[String:String]?, headers:HTTPHeaders?, completion:@escaping GetTblInLobbysHandel){
        let url = Server + APIFreeTable
        RequestService.shared.AFRequestWith(url: url, method: .get, parameters: parameters, headers: headers, objectType: TblInlobbyResponse.self) { (result, data, error) in
            if result {
                guard let model = data as? TblInlobbyResponse else{
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
