//
//  JCNetworkManager.swift
//  JioCoupons
//
//  Created by Abhishek Singh on 21/06/17.
//  Copyright © 2017 JioMoney. All rights reserved.
//

import UIKit

open class JCNetworkManager: NSObject {
    
    private weak var delegate:JCNetworkManagerDelegate?
    private var requestDict:[String:JCNetworkDownloader] = Dictionary()
    private var networkQueue:DispatchQueue = DispatchQueue(label: "com.jio.jiomoney.coupons.networkQueue")
    
    init(delegate:JCNetworkManagerDelegate) {
        self.delegate = delegate
        self.requestDict = Dictionary()
        self.networkQueue = DispatchQueue(label: "com.jio.jiomoney.coupons.networkQueue")
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    func downloadWithRequest(
        request:JCRequest,
        success:@escaping CompletionBlock,
        failure:@escaping CompletionBlock,
        validationBlock: ValidationBlock?){
        
        if let mockResponsePath:(filename:String, ext:String) = request.mockResponseFilepath, mockResponsePath.filename.characters.count > 0, mockResponsePath.ext.characters.count > 0, let filePath:String = Bundle(for: self.classForCoder).path(forResource: mockResponsePath.filename, ofType: mockResponsePath.ext) {
            let jsonData:Data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
            let response:JCResponse = JCNetworkDownloader.parseTheResponse(jsonData, urlResponse: nil, request: request, error: nil)
            DispatchQueue.main.async {
                success(response, request)
            }
            
        }else {
            sendRequest(request: request) { [weak self] (response, request, data, error) in
                if error != nil{
                    if let __weakSelf = self {
                        if let _ = __weakSelf.delegate, request.letDelegateHandleFailureBlock == false{
                            DispatchQueue.main.async {
                                failure(response, request)
                            }
                        }
                        if let _delegate = __weakSelf.delegate{
                            DispatchQueue.main.async {
                                _delegate.didFailWith(response: response, request: request, error: error, success: success, failure: failure, validationBlock: validationBlock)
                            }
                        }
                    }
                }else{
                    if validationBlock != nil{
                        let isSuccess = validationBlock!(response, request)
                        if let __weakSelf = self {
                            __weakSelf.informer(isSuccess, response: response, request: request, data:data, error: error, successBlock: success, failureBlock: failure, validationBlock:validationBlock)
                        }
                    }else{
                        if let __weakSelf = self {
                            __weakSelf.validateIfSuccessfulResponse(response: response, request: request, success: success, failure: failure, validationBlock: validationBlock, completionBlock: { (isSuccess) in
                                __weakSelf.informer(isSuccess, response: response, request: request, data:data, error: error, successBlock: success, failureBlock: failure, validationBlock:validationBlock)
                            })
                        }
                    }
                }
            }
        }
    }
    
    private func informer(_ success:Bool, response:JCResponse, request:JCRequest, data:Data? , error:Error?, successBlock:@escaping CompletionBlock, failureBlock:@escaping CompletionBlock, validationBlock: ValidationBlock?){
        if success == true{
            _ = self.didDownloadData(data, request: request, response: response)
            DispatchQueue.main.async {
                successBlock(response, request)
            }
        }else{
            if let _ = self.delegate, request.letDelegateHandleFailureBlock == false{
                DispatchQueue.main.async {
                    failureBlock(response, request)
                }
            }
            if let _delegate = self.delegate{
                DispatchQueue.main.async {
                    _delegate.didFailWith(response: response, request: request, error: error, success: successBlock, failure: failureBlock, validationBlock: validationBlock)
                }
            }
        }
    }
    
    private func sendRequest(request:JCRequest, completionBlock:@escaping CompletionHandler){
        networkQueue.async {
            let downloader:JCNetworkDownloader = JCNetworkDownloader.init(request: request) { [weak self] (response, request, data, error) in
                if let __weakSelf = self {
                    __weakSelf.requestDict.removeValue(forKey: request.uniqueIdentifier)
                    completionBlock(response, request, data, error)
                }else{
                    completionBlock(response, request, data, error)
                }
            }
            self.requestDict[request.uniqueIdentifier] = downloader
            downloader.startDownloading()
        }
    }
    
    public func didDownloadData(_ data:Data?, request:JCRequest, response:JCResponse) -> Data?{
        return data
    }
    
    public func successfulResponse(_ response:JCResponse) -> Bool{
        if let _httpCode = response.httpStatusCode, _httpCode == 200 {
            return true
        }
        return false
    }
    
    public func cancelRequest(request:JCRequest){
        networkQueue.async {
            if let downloader:JCNetworkDownloader = self.requestDict[request.uniqueIdentifier]{
                downloader.stopDownloading()
                self.requestDict.removeValue(forKey: request.uniqueIdentifier)
            }
        }
    }
    
    public func cancelAllRequests(){
        networkQueue.async {
            for (key, value) in self.requestDict{
                let downloader:JCNetworkDownloader = value
                downloader.stopDownloading()
                self.requestDict.removeValue(forKey: key)
            }
            self.requestDict = Dictionary()
        }
    }
    
    func validateIfSuccessfulResponse(response:JCResponse,
                                      request:JCRequest,
                                      success:@escaping CompletionBlock,
                                      failure:@escaping CompletionBlock,
                                      validationBlock: ValidationBlock?,
                                      completionBlock:@escaping (Bool)->()){
        let isSuccess:Bool = successfulResponse(response)
        completionBlock(isSuccess)
    }
}

