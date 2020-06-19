//
//  LobbyModel.swift
//  waiterHelper
//
//  Created by HongDang on 2/21/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
public struct TblInlobbyResponse:Codable {
    public var data : [Table]
    public var message : String
    public var result : Bool
}
//public struct Lobby{
//    let idLobby: String;
//    var listTableReserve:[Table]
//    var listTableServing:[Table]
//    var listTableDisplay:[Table]
//
//}
public struct LobbysResponse:Codable {

        public var data : [Lobbys]
        public var message : String
        public var result : Bool
        
}

public struct Lobbys: Codable{
    public var ID : String
    public var NAME : String
}
