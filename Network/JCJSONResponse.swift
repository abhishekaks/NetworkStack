//
//  JCJSONResponse.swift
//  JioCoupons
//
//  Created by Abhishek Singh on 23/06/17.
//  Copyright © 2017 JioMoney. All rights reserved.
//

import UIKit

class JCJSONResponse: JCResponse {
    class open override func serializedResponseWith(data:Data?) -> Dictionary<String, Any>?{
        if let _data:Data = data {
            do{
                let serializedResponse:Any = try JSONSerialization.jsonObject(with: _data, options: [])
                if serializedResponse is Dictionary<String, Any> {
                    return serializedResponse as? Dictionary<String, Any>
                }else{
                    return [JCGlobalConstants.NetworkUtility.defaultResponseHolder:serializedResponse]
                }
            }catch let error{
                print("error parsing " + String(describing: error))
                return super.serializedResponseWith(data: data)
            }
        }else{
            return super.serializedResponseWith(data: data)
        }
    }
}
