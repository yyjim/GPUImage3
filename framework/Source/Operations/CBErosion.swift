//
//  CBErosion.swift
//  GPUImage
//
//  Created by Jim Wang on 2024/3/29.
//  Copyright © 2024 Red Queen Coder, LLC. All rights reserved.
//

import Foundation

public class CBErosion: BasicOperation {
    // 1 ~ 10
    public var steps: Float = 6 { didSet { uniformSettings["steps"] = steps } }
    // 1 ~ 10
    public var texelSize: Float = 3 { didSet { uniformSettings["texelSize"] = texelSize } }

    public init() {
        super.init(fragmentFunctionName:"erosionFragment", numberOfInputs:1)
        ({
            steps = 6
            texelSize = 3
        })()
    }
}
