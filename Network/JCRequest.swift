//
//  JCRequest.swift
//  JioCoupons
//
//  Created by Abhishek Singh on 21/06/17.
//  Copyright © 2017 JioMoney. All rights reserved.
//

import UIKit

public enum HTTPRequestType:String {
    case GET    = "GET"
    case POST   = "POST"
    case PUT    = "PUT"
    case DELETE = "DELETE"
    case None   = ""
}

public class JCRequest: NSObject {
    
    //MARK: Member Variables
    public private(set) var url:String = ""
    public private(set) var requestType:HTTPRequestType = HTTPRequestType.None
    public private(set) var uniqueIdentifier:String = ""
    public private(set) var headers:[String:String] = Dictionary()
    public private(set) var body:[String:Any] = Dictionary()
    public fileprivate(set) var request:URLRequest?
    
    public var parsingClass:AnyClass = JCResponse.self
    public var shouldParse:Bool = true
    public var tag:Int = 0
    public var shouldShowErrorMessage:Bool = true
    public var cacheType:JCCacheType = .none
    public var forceCacheRefresh:Bool = false
    public var mockResponseFilepath:(filename:String, ext:String)?
    
    /*
     @param: letDelegateHandleFailureBlock
     @Description: The boolean parameter notifies the Network Manager to fire the
     failure block only if delegate is not provided else Delegate decides on the
     notification of failur block to the respective controller.
     */
    public var letDelegateHandleFailureBlock:Bool = false
    
    //MARK: Subclass Overridable Methods
    open func formBodyDataFrom(dictionary:[String:Any], requestType:HTTPRequestType, url:String) -> Data?{
        return nil
    }
    
    //MARK: Initializers
    public init(relativeURL:String, requestType:HTTPRequestType, body:[String:Any], headers:[String:String]) {
        super.init()
        self.cacheType = .none
        self.requestType = requestType
        self.body = body
        self.headers = headers
        self.url = getAbsolutePath(relativePath: relativeURL, requestType: requestType, body: body)
        self.uniqueIdentifier = formUniqueIdentifierFrom(relativeUrl: url, body: body)
        self.request = formRequestWith(headers: headers, bodyData:formBodyDataFrom(dictionary: body, requestType: requestType, url: self.url) , url: self.url, requestType: requestType)
    }
    
    public func setBody(_ body:Data?, request:inout URLRequest){
        if let _body = body {
            request.httpBody = _body
        }
    }
}

extension JCRequest{
    
    fileprivate func formUniqueIdentifierFrom(relativeUrl:String, body:[String:Any]) -> String{
        var uniqueIdentifier:String = relativeUrl + urlQuery(body)
        uniqueIdentifier = stringByRemovingCharacterPattern(JCGlobalConstants.NetworkUtility.ignorePattern, replacementString: "", inputString: uniqueIdentifier)
        return uniqueIdentifier
    }
    
    public func urlQuery(_ body:[String:Any]) -> String{
        var count:Int = 0
        var queryStr:String = ""
        
        for (key, value) in body {
            if count == 0 {
                queryStr = "?" + queryStr + key + "=" + String(describing: value)
            }else{
                queryStr = queryStr + "&" + key + "=" + String(describing: value)
            }
            count += 1
        }
        return queryStr
    }
    
    fileprivate func stringByRemovingCharacterPattern(_ pattern:String, replacementString:String, inputString:String) -> String{
        let regEx:NSRegularExpression   = try! NSRegularExpression.init(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let resultString:String         = regEx.stringByReplacingMatches(in: inputString, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, inputString.characters.count), withTemplate: replacementString)
        return resultString
    }
}

extension JCRequest{
    fileprivate func getAbsolutePath(relativePath:String, requestType:HTTPRequestType, body:[String:Any]) -> String{
        if requestType == HTTPRequestType.GET {
            return /*JCURL.baseURL() + */relativePath + urlQuery(body)
        }else{
            return /*JCURL.baseURL() + */relativePath
        }
    }
    
    fileprivate func formRequestWith(headers:[String:String], bodyData:Data?, url:String, requestType:HTTPRequestType) -> URLRequest{
        var request:URLRequest = URLRequest.init(url: URL.init(string: url)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: JCGlobalConstants.NetworkUtility.timeout)
        request.httpMethod = requestType.rawValue
        
        if let _bodyData:Data = bodyData, requestType == HTTPRequestType.POST  {
            setBody(_bodyData, request: &request)
        }
        
        request.allHTTPHeaderFields = addDefaultHeadersTo(headers)
        request.timeoutInterval = JCGlobalConstants.NetworkUtility.timeout
        return request
    }
    
    fileprivate func addDefaultHeadersTo(_ headers:[String:String]) -> [String:String]{
        let withDefaultHeaders:[String:String] = defaultHeaders().addValuesFromDictionary(headers)
        return withDefaultHeaders
    }
    
    fileprivate func defaultHeaders() -> [String:String]{
        var _defaultHeaders:[String:String] = Dictionary()
        _defaultHeaders[JCGlobalConstants.NetworkHeaders.API_key] = JCConfiguration.sharedInstance.apiKey
        
        if JCConfiguration.sharedInstance.accessToken.characters.count > 0 {
            _defaultHeaders[JCGlobalConstants.NetworkHeaders.Authorization] = JCConfiguration.sharedInstance.accessToken
        }
        
        _defaultHeaders[JCGlobalConstants.NetworkHeaders.ContentType] = self.contentType()
        _defaultHeaders[JCGlobalConstants.NetworkHeaders.ClientType] = JCGlobalConstants.NetworkHeaders.ClientTypeMyJio
        return _defaultHeaders
    }
    
    open func contentType() -> String{
        return JCGlobalConstants.NetworkHeaders.ContentType_JSON
    }
    
    public func addHeader(_ value:String, forKey:String) {
        if let _ = self.request {
            self.request!.setValue(value, forHTTPHeaderField: forKey)
        }
    }
    
    private func nonAuthorizedHeaderWith(_ username:String, password:String) -> String {
        let authString:String = String(format: "%@:%@", username, password)
        let authData:Data = authString.data(using: .utf8)!
        let base64Auth:String = authData.base64EncodedString()
        return base64Auth
    }
    
    public func addNonAuthorizedStateHeader(_ username:String = JCConfiguration.sharedInstance.apiKey, password:String = JCConfiguration.sharedInstance.clientSecret){
        if username.characters.count > 0 && password.characters.count > 0 {
            let nonAuthIdentityHeader:String = String(format: "Basic %@", self.nonAuthorizedHeaderWith(username, password: password))
            self.addHeader(nonAuthIdentityHeader, forKey: JCGlobalConstants.NetworkHeaders.Authorization)
        }
    }
}

extension Dictionary{
    func addValuesFromDictionary(_ inputDict:Dictionary) -> Dictionary{
        var parentDict:Dictionary = self
        for (key, value) in inputDict {
            parentDict[key] = value
        }
        return parentDict
    }
}

