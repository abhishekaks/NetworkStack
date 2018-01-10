//
//  AKSJSONFormEncodedRequest.swift
//  Pods
//
//  Created by Abhishek Singh on 10/01/18.
//

import UIKit

open class AKSJSONFormEncodedRequest: AKSRequest {
    open override func contentType() -> String{
        return AKSGlobalConstants.NetworkHeaders.ContentType_FormEncoded
    }
    
    open override func formBodyDataFrom(dictionary:[String:Any], requestType:HTTPRequestType, url:String) -> Data?{
        let bodyString:String = urlQuery(dictionary).replacingOccurrences(of: "?", with: "")
        return bodyString.data(using: .utf8)
    }
    
    override public func setBody(_ body:Data?, request:inout URLRequest){
        super.setBody(body, request: &request)
        if var _body = body {
            let lengthVal:String = String(format: "%lu", _body.count)
            self.addHeader(lengthVal, forKey: AKSGlobalConstants.NetworkHeaders.ContentLen)
        }
    }
}
