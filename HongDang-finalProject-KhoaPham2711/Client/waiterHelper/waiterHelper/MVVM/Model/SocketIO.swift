//
//  SocketIO.swift
//  waiterHelper
//
//  Created by HongDang on 3/8/20.
//  Copyright © 2020 HongDang. All rights reserved.
//

import Foundation
import SocketIO
class SocketHandler {
    private init(){}
    static let shared = SocketHandler()

    let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
    private(set) lazy var socket = manager.defaultSocket
}
