//
//  File.swift
//  
//
//  Created by Chiaote Ni on 2024/4/24.
//

import Foundation

final class DirectionalShines: OperationGroup {

    var rayCount: Int = 2 {
        didSet { resetDirectionalShines() }
    }
    var rayLength: Float = 0.08 {
        didSet { updateDirectionalShines() }
    }
    var degree: Float = 45.0 {
        didSet { updateDirectionalShines() }
    }
    var sparkleExposure: Float = 0.0 {
        didSet { updateDirectionalShines() }
    }
    private var directionalShines: [DirectionalShine]

    override init() {
        super.init()
        setupPipeline()
    }
}

// MARK: - Private functions
extension DirectionalShines {

    private func updateDirectionalShines() {
        let intervalDegree = 180.0 / Float(rayCount)
        directionalShines
            .enumerated()
            .forEach { index, directionalShine in
                directionalShine.degree = Float(startAngle) + Float(index) * intervalDegree
                directionalShine.rayLength = rayLength
                directionalShine.sparkleExposure = sparkleExposure
            }
    }

    private func resetDirectionalShines() {
        directionalShines.forEach {
            $0.removeAllTargets()
            $0.resetPipeline()
        }
        directionalShines = Array(repeating: DirectionalShine(), count: rayCount)
        updateDirectionalShines()
        setupPipeline()
    }

    private func setupPipeline() {
        configureGroup { input, output in
            input
            --> firstDirectionalBlurEffect
            --> exposureEffect
            --> secondDirectionalBlurEffect
            --> addBlendEffect
            --> output
        }
    }
}
