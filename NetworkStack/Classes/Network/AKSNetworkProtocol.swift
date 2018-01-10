//
//  AKSNetworkProtocol.swift
//  Pods
//
//  Created by Abhishek Singh on 10/01/18.
//

import UIKit

public typealias CompletionHandler = (AKSResponse, AKSRequest, Data?, Error?) -> Void
public typealias CompletionBlock = (AKSResponse, AKSRequest) -> Void
public typealias ValidationBlock = (AKSResponse, AKSRequest) -> Bool

public protocol AKSNetworkManagerDelegate:class {
    func didDownloadWith(response: AKSResponse,
                         request: AKSRequest,
                         error: Error?)
    
    func didFailWith(response: AKSResponse,
                     request: AKSRequest,
                     error: Error?,
                     success:@escaping CompletionBlock,
                     failure:@escaping CompletionBlock,
                     validationBlock: ValidationBlock?)
}

extension AKSNetworkManagerDelegate{
    func didDownloadWith(response: AKSResponse, request: AKSRequest, error: Error?){
        
    }
}
