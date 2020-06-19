//
//  MenuModel.swift
//  waiterHelper
//
//  Created by HongDang on 3/2/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
public struct FOOD:Codable {
    public var Category : String
    public var ID : String
    public var IDCATE : String
    public var NAME : String
    public var PRICE : String
    public var STATE : Bool
}
public struct MenuResponse:Codable {

        public var data : [FOOD]
        public var message : String
        public var result : Bool
        
}
public struct CATEGORY:Codable{
    public var ID : String
    public var Name : String
}
public struct CateResponse:Codable {

        public var data : [CATEGORY]
        public var message : String
        public var result : Bool
        
}
