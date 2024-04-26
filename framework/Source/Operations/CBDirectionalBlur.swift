//
//  DirectionalBlur.swift
//  GPUImage
//
//  Created by Jim Wang on 2024/3/29.
//  Copyright © 2024 Red Queen Coder, LLC. All rights reserved.
//

import Foundation

public class CBDirectionalBlur: BasicOperation {
    // 0.0 ~ 360.0
    public var degree: Float = 45.0 {
        didSet {
            let radian =  degree / 180.0 * Float.pi
            uniformSettings["radian"] = radian
        }
    }
    // 0.0 ~ 1.0
    public var length: Float = 0.15 { didSet { uniformSettings["length"] = length } }

    public init() {
        super.init(fragmentFunctionName:"directionalBlurFragment", numberOfInputs:1)
        ({
            degree = 45.0
            length = 0.15
        })()
    }
}
