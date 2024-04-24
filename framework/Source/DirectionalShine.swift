//
//  DirectionalShine.swift
//
//
//  Created by Chiaote Ni on 2024/4/24.
//

import Foundation

final class DirectionalShine: OperationGroup {

    var rayLength: Float = 0.08 {
        didSet {
            firstDirectionalBlurEffect.length = rayLength
            secondDirectionalBlurEffect.length = rayLength * 0.4
        }
    }
    var degree: Float = 45.0 {
        didSet {
            firstDirectionalBlurEffect.degree = degree
            secondDirectionalBlurEffect.degree = degree
        }
    }
    var sparkleExposure: Float = 0.0 {
        didSet {
            exposureEffect.exposure = sparkleExposure
        }
    }

    private let exposureEffect = ExposureAdjustment()
    private let firstDirectionalBlurEffect = CBDirectionBlur()
    private let secondDirectionalBlurEffect = CBDirectionBlur()
    private let addBlendEffect = AddBlend()

    override init() {
        super.init()

        self.configureGroup { input, output in
            input
            --> firstDirectionalBlurEffect
            --> exposureEffect
            --> secondDirectionalBlurEffect
            --> addBlendEffect
            --> output
        }
    }
}
