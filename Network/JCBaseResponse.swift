//
//  JCBaseResponse.swift
//  JioCoupons
//
//  Created by Abhishek Singh on 04/07/17.
//  Copyright © 2017 JioMoney. All rights reserved.
//

import UIKit

public class JCBaseResponse:NSObject, Unmarshaling {
    //MARK: Member Variables
    //public var responseBody:Any?
    public private(set) var httpStatusCode:Int?
    public private(set) var headers:[AnyHashable:Any]?
    public private(set) var responseError:Error?
    public private(set) var message:String?
    
    public var tag:Int = 0
    
    class open func serializedResponseWith(data:Data?) -> Dictionary<String, Any>?{
        return nil
    }
    
    required override public init() {
        super.init()
    }
    
    required public init(object: MarshaledObject) throws{
        message = try object.value(for: "message")
    }
    
    required convenience public init?(request:JCRequest, response:URLResponse?, responseDict:Dictionary<String, Any>?, error: Error?) {
        if let _responseDict = responseDict {
            do {
                try self.init(object: _responseDict)
                addResponseDetails(response:response, error:error)
            } catch let someError as NSError {
                print("Parsing Error " + String.init(describing: someError))
                return nil
            }catch{
                return nil
            }
        }else{
            return nil
        }
    }
    
    public func addResponseDetails(response:URLResponse?, error: Error?){
        if let _response:HTTPURLResponse = response as? HTTPURLResponse{
            self.httpStatusCode = _response.statusCode
            self.headers = _response.allHeaderFields
        }
        
        if let _error = error {
            self.responseError = _error
        }
    }
}
