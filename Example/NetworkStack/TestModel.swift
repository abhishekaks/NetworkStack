//
//  TestModel.swift
//  NetworkStack_Example
//
//  Created by Abhishek Singh on 11/01/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import NetworkStack
import Marshal

class TestModel: AKSJSONResponse {
    public var mpinSet:Bool?
    
    required init(object: MarshaledObject) throws{
        mpinSet = try object.value(for: "mpinSet")
        try super.init(object: object)
    }
    
    required init() {
        super.init()
    }
}
