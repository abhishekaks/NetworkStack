//
//  JCJSONRequest.swift
//  JioCoupons
//
//  Created by Abhishek Singh on 21/06/17.
//  Copyright © 2017 JioMoney. All rights reserved.
//

import UIKit

class JCJSONRequest: JCRequest {
    open override func formBodyDataFrom(dictionary:[String:Any], requestType:HTTPRequestType, url:String) -> Data?{
        if requestType == HTTPRequestType.POST {
            return try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
        }else{
            return super.formBodyDataFrom(dictionary: dictionary, requestType: requestType, url: url)
        }
    }
    
    open override func contentType() -> String{
        return JCGlobalConstants.NetworkHeaders.ContentType_JSON
    }
}
