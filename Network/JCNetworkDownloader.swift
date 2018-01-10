//
//  JCNetworkDownloader.swift
//  JioCoupons
//
//  Created by Abhishek Singh on 21/06/17.
//  Copyright © 2017 JioMoney. All rights reserved.
//

import UIKit

class JCNetworkDownloader: NSObject {
    
    var dataTask:URLSessionDataTask? = nil
    var data:Data? = nil
    var completionBlock:CompletionHandler
    var request:JCRequest
    
    init(request    :JCRequest,
         completion : @escaping CompletionHandler) {
        self.request = request
        self.completionBlock = completion
        super.init()
        logRequest(request)
        initializeDownloadWith(request, completion: completion)
    }
    
    private func logRequest(_ request:JCRequest){
//                print("\n***Sending API Request***\nURL:\n" + request.url + "\n\nBody:\n" + "\(request.body)" + "\n\nHeaders:\n" + String(describing: request.request?.allHTTPHeaderFields) + "\n\n*************************\n")
    }
    
    fileprivate func logResponseDataWith(request:JCRequest, responseData:Data?, response:HTTPURLResponse?){
        if let _data = responseData {
//            print("\n***Received API Response For***\nURL:\n" + request.url + "\n\nBody:\n" + "\(request.body)" + "\n\nResponse Code:\n" + String(describing: response?.statusCode) + "\n" + "\n\nHeaders:\n" + String(describing: request.request?.allHTTPHeaderFields) + "\n\nResponse:\n" + String(data: _data, encoding: .utf8)!  + "\n\n*************************\n")
        }
    }
    
    private func initializeDownloadWith(_ request:JCRequest,
                                        completion:@escaping CompletionHandler){
        let urlSessionConf:URLSessionConfiguration = URLSessionConfiguration.default
        
        if let _request = request.request {
            self.dataTask = URLSession(configuration: urlSessionConf, delegate: self, delegateQueue: OperationQueue.main).dataTask(with: _request)
        }
    }
    
    public func startDownloading(){
        if let task = self.dataTask {
            task.resume()
        }
    }
    
    public func stopDownloading(){
        if let task = self.dataTask {
            task.cancel()
        }
    }
    
    public class func parseTheResponse(_ data:Data?, urlResponse: URLResponse?, request:JCRequest, error: Error?) -> JCResponse{
        let parsingClass: JCResponse.Type = request.parsingClass as! JCResponse.Type
        if request.shouldParse {
            if let parsedObject:JCResponse = parsingClass.init(request: request, response: urlResponse, responseDict: parsingClass.serializedResponseWith(data: data), error: error){
                return parsedObject
            }else{
                let parsedObject:JCResponse = parsingClass.init()
                parsedObject.addResponseDetails(response: urlResponse, error: error)
                return parsedObject
            }
        }else{
            let parsedObject:JCResponse = parsingClass.init()
            //parsedObject.responseBody = parsingClass.serializedResponseWith(data: data)
            return parsedObject
        }
    }
}

extension JCNetworkDownloader: URLSessionDataDelegate{
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void){
        self.data = Data()
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        self.data!.append(data)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        logResponseDataWith(request: self.request, responseData: self.data, response: task.response as? HTTPURLResponse)
        //        print("\n\n\nPrinting Raw Data\n\n\n")
        //        print(task.currentRequest?.url ?? "")
        //        print("\n\n\n")
        
        let parsedResponse:JCResponse = JCNetworkDownloader.parseTheResponse(self.data, urlResponse: task.response, request: self.request, error: error)
        if let _error:Error = error {
            self.completionBlock(parsedResponse, self.request, self.data, _error)
        }else{
            self.completionBlock(parsedResponse, self.request, self.data, nil)
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        
        if let _ =  challenge.protectionSpace.serverTrust{
            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }else{
            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
        }
    }
}

