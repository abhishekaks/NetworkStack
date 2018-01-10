//
//  JMNetworkCacheWrapper.swift
//  JIOAppCouponIntegration
//
//  Created by Abhishek Singh on 16/11/17.
//  Copyright © 2017 Abhishek Singh. All rights reserved.
//

import UIKit

class JMNetworkCacheWrapper: JCNetworkManager {
    override func didDownloadData(_ data:Data?, request:JCRequest, response:JCResponse) -> Data? {
        if let _data = data {
            JCCacheManager.defaultManager.saveDataForRequest(request, data: _data, response: response)
        }
        return super.didDownloadData(data, request: request, response: response)
    }
    
    override func downloadWithRequest(request: JCRequest, success: @escaping CompletionBlock, failure: @escaping CompletionBlock, validationBlock: ValidationBlock?) {
        if request.cacheType != .none {
            JCCacheManager.defaultManager.dataForRequest(request, completion: { (responseObject) in
                if let _responseObject:Data = responseObject as? Data {
                    // Parse the response
                    let parsedResponse:JCResponse = JCNetworkDownloader.parseTheResponse(_responseObject, urlResponse: nil, request: request, error: nil)
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
