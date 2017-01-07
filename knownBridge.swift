//
//  knownBridge.swift
//  HueLighting
//
//  Created by Richard Whent on 04/01/2017.
//  Copyright © 2017 Chunkster.net. All rights reserved.
//

import UIKit

class KnownBridge: Bridge {
    private var _bridgeConnectionUserName: String!
    
    init(bridgeID: String, bridgeIPAddress: String, userName: String) {
        super.init(bridgeID: bridgeID, bridgeIPAddress: bridgeIPAddress)
        self._bridgeConnectionUserName = userName
    }
    
    var bridgeConnectionUserName: String {
        get {
            return self._bridgeConnectionUserName
        }
    }
    
    func isValidIPAddress(input: String) -> Bool {
        var isValid: Bool = true
        
        let array = input.components(separatedBy: ".")
        
        if (array.count != 4) {
            isValid = false
        }  else if (((Int(array[0]) == nil)) || ((Int(array[1]) == nil)) || ((Int(array[2]) == nil)) || ((Int(array[3]) == nil))) {
            isValid = false
        }
        
        
        return isValid
    }

}
