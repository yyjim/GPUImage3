//
//  File.swift
//  
//
//  Created by Chiaote Ni on 2024/4/24.
//

import Foundation

final class DirectionalShines: OperationGroup {

    var rayCount: Int = 2 {
        didSet { resetSubEffects() }
    }
    var rayLength: Float = 0.08 {
        didSet { updateDirectionalShines() }
    }
    var startAngle: Int = 45 {
        didSet { updateDirectionalShines() }
    }
    var sparkleExposure: Float = 0.0 {
        didSet { updateDirectionalShines() }
    }
    private var directionalShines: [DirectionalShine] = []
    private var addBlendEffects: [AddBlend] = []

    override init() {
        super.init()

        resetSubEffects()
    }
}

// MARK: - Private functions
extension DirectionalShines {

    private func updateDirectionalShines() {
        let intervalDegree = 180.0 / Float(rayCount)
        directionalShines
            .enumerated()
            .forEach { index, directionalShine in
                directionalShine.degree = Float(startAngle) + (Float(index) * intervalDegree)
                directionalShine.rayLength = rayLength
                directionalShine.sparkleExposure = sparkleExposure
            }
    }

    private func resetSubEffects() {
        directionalShines.forEach {
            $0.removeAllTargets()
            $0.resetPipeline()
        }
        directionalShines = Array(repeating: DirectionalShine(), count: rayCount)
        
        addBlendEffects.forEach {
            $0.removeAllTargets()
            $0.resetPipeline()
        }
        addBlendEffects = Array(repeating: AddBlend(), count: rayCount)

        resetPipeline()
        removeAllTargets()

        setupPipeline()
        updateDirectionalShines()
    }

    private func setupPipeline() {
        configureGroup { input, output in

            var input: ImageProcessingOperation = input

            for (addBlend, directionalShine) in zip(addBlendEffects, directionalShines) {
                input --> directionalShine
                directionalShine.addTarget(addBlend, atTargetIndex: 1)

                input --> addBlend
                input = addBlend
            }
            input --> output
        }
    }
}
