//
//  JCJSONFormEncodedRequest.swift
//  JioCoupons
//
//  Created by Abhishek Singh on 16/10/17.
//  Copyright © 2017 JioMoney. All rights reserved.
//

import UIKit

class JCJSONFormEncodedRequest: JCRequest {

    open override func contentType() -> String{
        return JCGlobalConstants.NetworkHeaders.ContentType_FormEncoded
    }
    
    open override func formBodyDataFrom(dictionary:[String:Any], requestType:HTTPRequestType, url:String) -> Data?{
        let bodyString:String = urlQuery(dictionary).replacingOccurrences(of: "?", with: "")
        return bodyString.data(using: .utf8)
    }
    
    override func setBody(_ body:Data?, request:inout URLRequest){
        super.setBody(body, request: &request)
        if var _body = body {
            let lengthVal:String = String(format: "%lu", _body.count)
            self.addHeader(lengthVal, forKey: JCGlobalConstants.NetworkHeaders.ContentLen)
        }
    }
}
