//
//  APIManager.swift
//  NetworkStack_Example
//
//  Created by Abhishek Singh on 11/01/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import NetworkStack

class APIManager: AKSNetworkCacheWrapper {
    
    public func testNetwork(success: @escaping ((TestModel, JCRequest) -> Void),
                                        failure: @escaping((TestModel, JCRequest) -> Void)) -> JCRequest{
        let headers:[String:String] = Dictionary()
        var body:[String:String]    = Dictionary()
        body["migrate"] = "1"
        body["mobileNumber"] = "8618799108"
        
        let request:JCRequest = JCRequest.init(relativeURL: "https://api-sit.jio.com/cr/v2/wallet/validate",
                                                       requestType: HTTPRequestType.GET,
                                                       body:body,
                                                       headers:headers)
        request.parsingClass = TestModel.self
        request.letDelegateHandleFailureBlock = true
        request.cacheType = .none
        request.addNonAuthorizedStateHeader("l7xx3e887403b5ed40e78ca8edef65c87587", clientSecret: "c645568a927745a696e0e52e5871be83")
        
        self.downloadWithRequest(request: request, success: { (response, request) in
            success(response as! TestModel, request as! JCRequest)
        }, failure: { (response, request) in
            failure(response as! TestModel, request as! JCRequest)
        }, validationBlock: nil)
        return request
    }
}
