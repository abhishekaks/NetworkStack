//
//  AKSCacheManager.swift
//  Pods
//
//  Created by Abhishek Singh on 10/01/18.
//

import UIKit
import PINCache

class AKSCacheManager: NSObject {
    static let defaultManager:AKSCacheManager = AKSCacheManager()
    
    // Private Vars
    internal var pinCache:PINCache
    internal var cacheQueue:DispatchQueue

    override init() {
        pinCache = PINCache.init(name: AKSCacheManagerConstants.aksCache.rawValue)
        cacheQueue = DispatchQueue.init(label: "com.aks.cache.queue", attributes: .concurrent)
        super.init()
    }
}
