//
//  LobbyViewModel.swift
//  waiterHelper
//
//  Created by HongDang on 2/29/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
class LobbyViewModel {
    var idLobby:String = ""{
        didSet{}
    }
    func GetLobby(completion:@escaping GetLobbysHandel){
        LobbiAPI.shared.getLobbys(parameters: [:], headers: nil) { (model) in
            guard let model = model else {
                completion(nil)
                return
            }
            completion(model)
        }
    }
    func GetTableInLobby(completion:@escaping GetTblInLobbysHandel){
        let param = [
            "idlooby": self.idLobby,
        ]
        LobbiAPI.shared.getTableInLobby(parameters: param, headers: nil) { (model) in
            guard let model = model else {
                completion(nil)
                return
            }
            completion(model)
        }
    }
    func GetFreeTable(completion:@escaping GetTblInLobbysHandel){
        
        LobbiAPI.shared.getFreeTable(parameters: [:], headers: nil) { (model) in
            guard let model = model else {
                completion(nil)
                return
            }
            completion(model)
        }
    }
}
