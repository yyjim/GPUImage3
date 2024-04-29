//
//  CBBoxBlur.swift
//  GPUImage
//
//  Created by Jim Wang on 2024/3/29.
//  Copyright © 2024 Red Queen Coder, LLC. All rights reserved.
//

import Foundation

public class CBBoxBlur: BasicOperation {
    // 1 ~ 10
    public var texelSizeX: Float = 3.0 { didSet { uniformSettings["texelSizeX"] = texelSizeX } }
    // 1 ~ 10
    public var texelSizeY: Float = 3.0 { didSet { uniformSettings["texelSizeY"] = texelSizeY } }
    // 0 ~ 30
    public var kernelSize: Float = 2.0 { didSet { uniformSettings["kernelSize"] = kernelSize } }

    public init() {
        super.init(fragmentFunctionName:"boxBlurFragment", numberOfInputs:1)
        ({
            texelSizeX = 3.0
            texelSizeY = 3.0
            kernelSize = 2.0
        })()
    }
}
