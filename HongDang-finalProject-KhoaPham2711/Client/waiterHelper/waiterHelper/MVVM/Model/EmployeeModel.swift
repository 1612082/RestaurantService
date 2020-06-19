//
//  EmployeeModel.swift
//  waiterHelper
//
//  Created by HongDang on 2/20/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
public struct EmployeeResponse:Codable {

        public var data : [Employee]
        public var message : String
        public var result : Bool
        public var token : String
        
}
public struct Employee:Codable {

        public var EMAIL : String
        public var ID : String
        public var IDNV : String
        public var NAME : String
        public var PASSWORD : String
        public var ROLE : String
}
