//
//  AKSNetworkManager.swift
//  Pods
//
//  Created by Abhishek Singh on 10/01/18.
//

import UIKit

open class AKSNetworkManager: NSObject {
    
    private weak var delegate:AKSNetworkManagerDelegate?
    private var requestDict:[String:AKSNetworkDownloader] = Dictionary()
    private var networkQueue:DispatchQueue = DispatchQueue(label: "com.aks.networkQueue")
    
    public init(delegate:AKSNetworkManagerDelegate) {
        self.delegate = delegate
        super.init()
        start()
    }
    
    override public init() {
        super.init()
        start()
    }
    
    private func start() {
        self.requestDict = Dictionary()
        self.networkQueue = DispatchQueue(label: "com.aks.networkQueue")
    }
    
    public func downloadWithRequest(
        request:AKSRequest,
        success:@escaping CompletionBlock,
        failure:@escaping CompletionBlock,
        validationBlock: ValidationBlock?){
        
        if let mockResponsePath:(filename:String, ext:String) = request.mockResponseFilepath, mockResponsePath.filename.count > 0, mockResponsePath.ext.count > 0, let filePath:String = Bundle(for: self.classForCoder).path(forResource: mockResponsePath.filename, ofType: mockResponsePath.ext) {
            let jsonData:Data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
            let response:AKSResponse = AKSNetworkDownloader.parseTheResponse(jsonData, urlResponse: nil, request: request, error: nil)
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
    
    private func informer(_ success:Bool, response:AKSResponse, request:AKSRequest, data:Data? , error:Error?, successBlock:@escaping CompletionBlock, failureBlock:@escaping CompletionBlock, validationBlock: ValidationBlock?){
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
    
    private func sendRequest(request:AKSRequest, completionBlock:@escaping CompletionHandler){
        networkQueue.async {
            let downloader:AKSNetworkDownloader = AKSNetworkDownloader.init(request: request) { [weak self] (response, request, data, error) in
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
    
    public func didDownloadData(_ data:Data?, request:AKSRequest, response:AKSResponse) -> Data?{
        return data
    }
    
    public func successfulResponse(_ response:AKSResponse) -> Bool{
        if let _httpCode = response.httpStatusCode, _httpCode == 200 {
            return true
        }
        return false
    }
    
    public func cancelRequest(request:AKSRequest){
        networkQueue.async {
            if let downloader:AKSNetworkDownloader = self.requestDict[request.uniqueIdentifier]{
                downloader.stopDownloading()
                self.requestDict.removeValue(forKey: request.uniqueIdentifier)
            }
        }
    }
    
    public func cancelAllRequests(){
        networkQueue.async {
            for (key, value) in self.requestDict{
                let downloader:AKSNetworkDownloader = value
                downloader.stopDownloading()
                self.requestDict.removeValue(forKey: key)
            }
            self.requestDict = Dictionary()
        }
    }
    
    public func validateIfSuccessfulResponse(response:AKSResponse,
                                      request:AKSRequest,
                                      success:@escaping CompletionBlock,
                                      failure:@escaping CompletionBlock,
                                      validationBlock: ValidationBlock?,
                                      completionBlock:@escaping (Bool)->()){
        let isSuccess:Bool = successfulResponse(response)
        completionBlock(isSuccess)
    }
}

