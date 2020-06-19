//
//  PaymentModel.swift
//  waiterHelper
//
//  Created by HongDang on 3/18/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
public struct BILLDETAIL:Codable {

        public var ID : String
        public var IDTABLE : String
        public var NAME : String
        public var PRICE : String
        public var QUANTITY : String
        
}
public struct PaymentDetailResponse:Codable {

        public var data : [BILLDETAIL]
        public var message : String
        public var result : Bool
        
}
public struct BILL:Codable {

        public var ID : String
        public var IDTABLE : String
        public var STATE : Bool
        
}
public struct PaymentResponse:Codable {

        public var data : [BILL]
        public var message : String
        public var result : Bool
        
}
