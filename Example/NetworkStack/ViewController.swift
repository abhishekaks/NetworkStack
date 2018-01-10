//
//  ViewController.swift
//  NetworkStack
//
//  Created by abhishekaks on 01/10/2018.
//  Copyright (c) 2018 abhishekaks. All rights reserved.
//

import UIKit
import NetworkStack

class ViewController: UIViewController, AKSNetworkManagerDelegate {
    
    var apiManager:APIManager = APIManager.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = apiManager.testNetwork(success: { (model, request) in
            
        }) { (model, request) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didFailWith(response: AKSResponse,
                     request: AKSRequest,
                     error: Error?,
                     success:@escaping CompletionBlock,
                     failure:@escaping CompletionBlock,
                     validationBlock: ValidationBlock?){
        
    }
    
    func didDownloadWith(response: AKSResponse, request: AKSRequest, error: Error?) {
        
    }
}
