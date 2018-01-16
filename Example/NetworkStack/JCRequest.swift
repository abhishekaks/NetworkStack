//
//  JCRequest.swift
//  NetworkStack_Example
//
//  Created by Abhishek Singh on 10/01/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import NetworkStack

struct JCRequestConstants {
    static let API_key:String = "X-API-KEY"
    static let ClientType: String = "X-CLIENT-TYPE"
    static let Authorization:String = "Authorization"
    static let ClientTypeMyJio: String = "myjio"
    static let ContentType:String = "Content-Type"
    
    struct SIT {
        static let apiKeyValue:String = "l7xx3e887403b5ed40e78ca8edef65c87587"
    }
}

public class  JCRequest:AKSJSONRequest {
    override open func defaultHeaders() -> [String:String]{
        var _defaultHeaders:[String:String] = Dictionary()
                _defaultHeaders[JCRequestConstants.API_key] = JCRequestConstants.SIT.apiKeyValue
        
//                if JCConfiguration.sharedInstance.accessToken.characters.count > 0 {
//                    _defaultHeaders[JCGlobalConstants.NetworkHeaders.Authorization] = JCConfiguration.sharedInstance.accessToken
//                }
        
                _defaultHeaders[JCRequestConstants.ContentType] = self.contentType()
        return _defaultHeaders
    }
    
    private func nonAuthorizedHeaderWith(_ username:String, password:String) -> String {
        let authString:String = String(format: "%@:%@", username, password)
        let authData:Data = authString.data(using: .utf8)!
        let base64Auth:String = authData.base64EncodedString()
        return base64Auth
    }
    
    public func addNonAuthorizedStateHeader(_ apiKey:String = ""/*JCConfiguration.sharedInstance.apiKey*/, clientSecret:String = /*JCConfiguration.sharedInstance.clientSecret*/""){
        if apiKey.count > 0 && clientSecret.count > 0 {
            let nonAuthIdentityHeader:String = String(format: "Basic %@", self.nonAuthorizedHeaderWith(apiKey, password: clientSecret))
            self.addHeader(nonAuthIdentityHeader, forKey: JCRequestConstants.Authorization)
        }
    }
}
