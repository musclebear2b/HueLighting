//
//  bridge.swift
//  HueLighting
//
//  Created by Richard Whent on 06/01/2017.
//  Copyright © 2017 Chunkster.net. All rights reserved.
//

import UIKit

class Bridge: NSObject {
    
    private var _bridgeID: String!
    private var _bridgeIPAddress: String!
    
    init(bridgeID: String, bridgeIPAddress: String) {
        self._bridgeID = bridgeID
        self._bridgeIPAddress = bridgeIPAddress
    }
    
    var bridgeID: String {
        get {
            return self._bridgeID
        }
    }
    
    var bridgeIPAddress: String {
        get {
            return self._bridgeIPAddress
        }
        set {
            self._bridgeIPAddress = newValue
        }
    }
}

