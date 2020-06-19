//
//  OrderModel.swift
//  waiterHelper
//
//  Created by HongDang on 3/2/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
public struct ORDER:Codable {
    let idTable:String
    let idFood:String
    let name:String
    var quantity:Int
}
public struct OrderResponse:Codable {

        public var data : [OrderFromServer]
        public var message : String
        public var result : Bool
        
}
public struct OrderFromServer:Codable {
    public var DAY : String
    public var HOUR : String
    public var ID : String
    public var IDBILL : String
    public var IDFOOD : String
    public var IDTABLE : String
    public var MINUTE : String
    public var MONTH : String
    public var NAME : String
    public var QUANTITY : String
    public var SECONDS : String
    public var SERVING : Bool
    public var STATE : Bool
    public var YEAR : String
}
