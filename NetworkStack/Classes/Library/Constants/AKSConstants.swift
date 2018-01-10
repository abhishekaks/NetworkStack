//
//  AKSConstants.swift
//  Pods
//
//  Created by Abhishek Singh on 10/01/18.
//

import UIKit

struct AKSGlobalConstants {
    struct NetworkHeaders{
        // Keys
        static let API_key:String = "X-API-KEY"
        static let ClientType: String = "X-CLIENT-TYPE"
        static let ContentType:String = "Content-Type"
        static let Authorization:String = "Authorization"
        static let ContentLen:String = "Content-Length"
        static let requestId:String = "requestId"
        
        // Value
        static let ContentType_JSON:String = "application/json"
        static let ContentType_FormEncoded:String = "application/x-www-form-urlencoded"
    }
    
    struct NetworkUtility {
        static let ignorePattern:String = "[&'*,.=~?/:;]"
        static let timeout:TimeInterval = 60
        static let defaultResponseHolder:String = "result"
    }
}
