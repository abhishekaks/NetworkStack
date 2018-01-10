//
//  AKSRequest.swift
//  Pods
//
//  Created by Abhishek Singh on 10/01/18.
//

import UIKit

public enum HTTPRequestType:String {
    case GET    = "GET"
    case POST   = "POST"
    case PUT    = "PUT"
    case DELETE = "DELETE"
    case None   = ""
}

open class AKSRequest: NSObject {
    
    //MARK: Member Variables
    public private(set) var url:String = ""
    public private(set) var requestType:HTTPRequestType = HTTPRequestType.None
    public private(set) var uniqueIdentifier:String = ""
    public private(set) var headers:[String:String] = Dictionary()
    public private(set) var body:[String:Any] = Dictionary()
    public fileprivate(set) var request:URLRequest?
    
    public var parsingClass:AnyClass = AKSResponse.self
    public var shouldParse:Bool = true
    public var tag:Int = 0
    public var shouldShowErrorMessage:Bool = true
    public var cacheType:AKSCacheType = .none
    public var forceCacheRefresh:Bool = false
    public var mockResponseFilepath:(filename:String, ext:String)?
    public var timeout:TimeInterval = 60
    
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
    
    open func contentType() -> String{
        return AKSGlobalConstants.NetworkHeaders.ContentType_JSON
    }
    
    open func defaultHeaders() -> [String:String]{
        let _defaultHeaders:[String:String] = Dictionary()
        return _defaultHeaders
    }
}

extension AKSRequest{
    
    fileprivate func formUniqueIdentifierFrom(relativeUrl:String, body:[String:Any]) -> String{
        var uniqueIdentifier:String = relativeUrl + urlQuery(body)
        uniqueIdentifier = stringByRemovingCharacterPattern(AKSGlobalConstants.NetworkUtility.ignorePattern, replacementString: "", inputString: uniqueIdentifier)
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
        let resultString:String         = regEx.stringByReplacingMatches(in: inputString, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, inputString.count), withTemplate: replacementString)
        return resultString
    }
}

extension AKSRequest{
    fileprivate func getAbsolutePath(relativePath:String, requestType:HTTPRequestType, body:[String:Any]) -> String{
        if requestType == HTTPRequestType.GET {
            return relativePath + urlQuery(body)
        }else{
            return relativePath
        }
    }
    
    fileprivate func formRequestWith(headers:[String:String], bodyData:Data?, url:String, requestType:HTTPRequestType) -> URLRequest{
        var request:URLRequest = URLRequest.init(url: URL.init(string: url)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: timeout)
        request.httpMethod = requestType.rawValue
        
        if let _bodyData:Data = bodyData, requestType == HTTPRequestType.POST  {
            setBody(_bodyData, request: &request)
        }
        
        request.allHTTPHeaderFields = addDefaultHeadersTo(headers)
        request.timeoutInterval = AKSGlobalConstants.NetworkUtility.timeout
        return request
    }
    
    private func addDefaultHeadersTo(_ headers:[String:String]) -> [String:String]{
        let withDefaultHeaders:[String:String] = defaultHeaders().addValuesFromDictionary(headers)
        return withDefaultHeaders
    }
    
    public func addHeader(_ value:String, forKey:String) {
        if let _ = self.request {
            self.request!.setValue(value, forHTTPHeaderField: forKey)
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
