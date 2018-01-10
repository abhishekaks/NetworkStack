//
//  AKSCacheManager+APICache.swift
//  NetworkStack
//
//  Created by Abhishek Singh on 10/01/18.
//

import UIKit

extension AKSCacheManager {
    public func saveDataForRequest(_ request: AKSRequest, data:AnyHashable?, response:AKSResponse) {
        AKSCacheManager.defaultManager.cacheQueue.async(flags: .barrier) { [weak self] in
            let shouldContinue:Bool = request.uniqueIdentifier.count > 0
            if let _data = data, shouldContinue == true, request.cacheType.rawValue > 0 {
                if response.httpStatusCode == 200 {
                    // Save Data With Meta Details
                    let dictToSave:NSMutableDictionary = NSMutableDictionary()
                    dictToSave[AKSCacheManagerConstants.aksCachedData.rawValue] = _data
                    dictToSave[AKSCacheManagerConstants.aksCacheLife.rawValue] = NSNumber(integerLiteral: request.cacheType.rawValue)
                    dictToSave[AKSCacheManagerConstants.aksCacheTimestamp.rawValue] = Date()
                    
                    // Save The Response with Meta Data in Cache
                    AKSCacheManager.defaultManager.pinCache.setObject(dictToSave, forKey: request.uniqueIdentifier)
                }else{
                    if let _weakSelf = self {
                        _weakSelf.removeDataForRequest(request)
                    }
                }
            }
        }
    }
    
    public func removeDataForRequest(_ request:AKSRequest) {
        AKSCacheManager.defaultManager.cacheQueue.async(flags: .barrier) {
            if request.uniqueIdentifier.characters.count > 0 {
                AKSCacheManager.defaultManager.pinCache.removeObject(forKey: request.uniqueIdentifier)
            }
        }
    }
    
    public func dataForRequest(_ request:AKSRequest, completion:@escaping (AnyHashable?)->()){
        if request.uniqueIdentifier.characters.count <= 0 {
            completion(nil)
        }else{
            AKSCacheManager.defaultManager.pinCache.object(forKey: request.uniqueIdentifier, block: { [weak self] (pinCache, key, object) in
                if let _data:NSMutableDictionary = object as? NSMutableDictionary, let _weakself = self {
                    let validData:Bool = _weakself.validateCacheData(_data, request: request)
                    if validData == true {
                        completion(_data.object(forKey: AKSCacheManagerConstants.aksCachedData.rawValue) as? AnyHashable)
                    }else{
                        completion(nil)
                        _weakself.removeDataForRequest(request)
                    }
                }else{
                    completion(nil)
                }
            })
        }
    }
    
    private func validateCacheData(_ data:NSMutableDictionary?, request:AKSRequest) -> Bool {
        var valid:Bool = false
        if let _data = data {
            AKSCacheManager.defaultManager.cacheQueue.sync {
                if let savedDate:Date = _data.object(forKey: AKSCacheManagerConstants.aksCacheTimestamp.rawValue) as? Date {
                    let currentDate:Date = Date()
                    let cacheExpiry:Int = (_data.object(forKey: AKSCacheManagerConstants.aksCacheLife.rawValue) as! NSNumber).intValue
                    if currentDate.timeIntervalSince(savedDate) < Double(cacheExpiry) && !request.forceCacheRefresh {
                        valid = true
                    }else{
                        valid = false
                    }
                }
            }
        }
        return valid
    }
}

