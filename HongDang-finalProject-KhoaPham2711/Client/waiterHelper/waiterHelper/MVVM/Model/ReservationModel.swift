//
//  ReservationModel.swift
//  waiterHelper
//
//  Created by HongDang on 3/20/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
public struct ReservationResponse:Codable {

        public var data : [RESERVATION]
        public var message : String
        public var result : Bool
        
}
public struct RESERVATION:Codable {

        public var DAY : String
        public var HOUR : String
        public var ID : String
        public var IDTABLE : String
        public var INTIME : Bool
        public var MINUTE : String
        public var MONTH : String
        public var NAME : String
        public var STATE : Bool
        public var YEAR : String
        
}
