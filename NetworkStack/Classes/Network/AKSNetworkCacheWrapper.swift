//
//  AKSNetworkCacheWrapper.swift
//  Pods
//
//  Created by Abhishek Singh on 10/01/18.
//

import UIKit

open class AKSNetworkCacheWrapper: AKSNetworkManager {
    override public func didDownloadData(_ data:Data?, request:AKSRequest, response:AKSResponse) -> Data? {
        if let _data = data {
            AKSCacheManager.defaultManager.saveDataForRequest(request, data: _data, response: response)
        }
        return super.didDownloadData(data, request: request, response: response)
    }
    
    override public func downloadWithRequest(request: AKSRequest, success: @escaping CompletionBlock, failure: @escaping CompletionBlock, validationBlock: ValidationBlock?) {
        if request.cacheType != .none {
            AKSCacheManager.defaultManager.dataForRequest(request, completion: { (responseObject) in
                if let _responseObject:Data = responseObject as? Data {
                    // Parse the response
                    let parsedResponse:AKSResponse = AKSNetworkDownloader.parseTheResponse(_responseObject, urlResponse: nil, request: request, error: nil)
                    DispatchQueue.main.async {
                        success(parsedResponse, request)
                    }
                }else {
                    super.downloadWithRequest(request: request, success: success, failure: failure, validationBlock: validationBlock)
                }
            })
        }else {
            super.downloadWithRequest(request: request, success: success, failure: failure, validationBlock: validationBlock)
        }
    }
}
