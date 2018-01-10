//
//  AKSJSONRequest.swift
//  Pods
//
//  Created by Abhishek Singh on 10/01/18.
//

import UIKit

open class AKSJSONRequest: AKSRequest {
    open override func formBodyDataFrom(dictionary:[String:Any], requestType:HTTPRequestType, url:String) -> Data?{
        if requestType == HTTPRequestType.POST {
            return try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
        }else{
            return super.formBodyDataFrom(dictionary: dictionary, requestType: requestType, url: url)
        }
    }
    
    open override func contentType() -> String{
        return AKSGlobalConstants.NetworkHeaders.ContentType_JSON
    }
}
