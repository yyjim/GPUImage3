//
//  CBHSV.swift
//  GPUImage
//
//  Created by Jim Wang on 2024/3/29.
//  Copyright © 2024 Red Queen Coder, LLC. All rights reserved.
//

import Foundation

public class CBHSV: BasicOperation {
    // Range: -1.0 ~ 1.0
    public var value: Float = 0 { didSet { uniformSettings["value"] = value } }

    public init() {
        super.init(fragmentFunctionName:"hsvFragment", numberOfInputs: 1)
        ({value = 0.0})()
    }
}
