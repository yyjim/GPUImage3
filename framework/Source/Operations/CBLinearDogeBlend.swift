//
//  LinearDogeBlend.swift
//  GPUImage
//
//  Created by Jim Wang on 2024/3/29.
//  Copyright © 2024 Red Queen Coder, LLC. All rights reserved.
//

import Foundation

public class CBLinearDogeBlend: BasicOperation {
    // 0.0 ~ 1.0
    public var assetOpacity: Float = 0.6 { didSet { uniformSettings["assetOpacity"] = assetOpacity } }
    // 0.0 ~ 1.0
    public var intensity: Float = 1.0 { didSet { uniformSettings["intensity"] = intensity } }

    public init() {
        super.init(fragmentFunctionName:"linearDodgeBlendFragment", numberOfInputs: 2)
        ({
            assetOpacity = 0.6
            intensity = 1.0
        })()
    }
}
