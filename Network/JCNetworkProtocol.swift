//
//  JCNetworkProtocol.swift
//  JioCoupons
//
//  Created by Abhishek Singh on 26/06/17.
//  Copyright © 2017 JioMoney. All rights reserved.
//

import UIKit

typealias CompletionHandler = (JCResponse, JCRequest, Data?, Error?) -> Void
typealias CompletionBlock = (JCResponse, JCRequest) -> Void
typealias ValidationBlock = (JCResponse, JCRequest) -> Bool

protocol JCNetworkManagerDelegate:class {
    func didDownloadWith(response: JCResponse,
                         request: JCRequest,
                         error: Error?)
    
    func didFailWith(response: JCResponse,
                     request: JCRequest,
                     error: Error?,
                     success:@escaping CompletionBlock,
                     failure:@escaping CompletionBlock,
                     validationBlock: ValidationBlock?)
}

extension JCNetworkManagerDelegate{
    func didDownloadWith(response: JCResponse, request: JCRequest, error: Error?){
        
    }
}

