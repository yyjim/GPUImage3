//
//  CBDilation.swift
//  GPUImage
//
//  Created by Jim Wang on 2024/3/29.
//  Copyright © 2024 Red Queen Coder, LLC. All rights reserved.
//

import Foundation

public class CBDilation: BasicOperation {
    // 1 ~ 10
    public var steps: Float = 6.0 { didSet { uniformSettings["steps"] = steps } }
    // 1 ~ 10
    public var texelStep: Float = 3.0 { didSet { uniformSettings["texelStep"] = texelStep } }
    // 0: max dilation 1: average dilation
    public var mode: Float = 0 { didSet { uniformSettings["mode"] = mode } }

    public init() {
        super.init(fragmentFunctionName:"dilationFragment", numberOfInputs:1)
        ({
            steps = 6.0
            texelStep = 3.0
            mode = 0
        })()
    }
}
