//
//  NetworkUtils.swift
//  OpenRoaming
//
//  Created by rajesh36 on 24/02/20.
//  Copyright © 2020 rajesh36. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import NetworkExtension

class NetworkUtils{
    
    class func isConnectedToNetwork() -> Bool {
        let defaultRouteReachability = SCNetworkReachabilityCreateWithName(nil,domain)
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
    
    
}
