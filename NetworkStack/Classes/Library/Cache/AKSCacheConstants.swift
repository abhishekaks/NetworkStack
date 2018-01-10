//
//  AKSCacheConstants.swift
//  Pods
//
//  Created by Abhishek Singh on 10/01/18.
//

import UIKit

public enum AKSCacheManagerConstants:String {
    case aksCache
    case aksCachedData
    case aksCacheLife
    case aksCacheTimestamp
}

public enum AKSCacheType:Int {
    case none = 0
    case defaultCache = 30
    case oneMinute = 60
    case twoMinutes = 120
    case fiveMinutes = 300
    case tenMinutes = 600
    case oneHour = 3600
    case ondeDay = 86400
}
