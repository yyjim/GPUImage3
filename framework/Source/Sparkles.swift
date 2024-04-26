//
//  Sparkles.swift
//  GPUImage_iOS
//
//  Created by Chiaote Ni on 2024/4/25.
//  Copyright © 2024 Red Queen Coder, LLC. All rights reserved.
//

import Foundation

public class Sparkles: OperationGroup {

    public enum ColorMode: Int {
        case white = 0
        case random = 1
    }

    // MARK: - Properties

    // Noise
    public var speed: Float = 7.5 {
        didSet { perlinNoiseEffect.speed = speed }
    }
    public var sparkleScale: Float = 0.7 {
        didSet { perlinNoiseEffect.scale = sparkleScale }
    }
    public var frameRate: Float = 60 {
        didSet { perlinNoiseEffect.frameRate = frameRate }
    }
    // LightExtractor
    public var equalMinHue: Float = 0.75 {
        didSet { lightExtractorEffect.equalMinHue = equalMinHue }
    }
    public var equalMaxHue: Float = 0.083 {
        didSet { lightExtractorEffect.equalMaxHue = equalMaxHue }
    }
    public var equalSaturation: Float = 0.15 {
        didSet { lightExtractorEffect.equalSaturation = equalSaturation }
    }
    public var equalBrightness: Float = 2.0 {
        didSet { lightExtractorEffect.equalBrightness = equalBrightness }
    }
    public var minHue: Float = 0.0 {
        didSet { lightExtractorEffect.minHue = minHue }
    }
    public var maxHue: Float = 1.0 {
        didSet { lightExtractorEffect.maxHue = maxHue }
    }
    public var noiseInfluence: Float = 1.0 {
        didSet { lightExtractorEffect.noiseInfluence = noiseInfluence }
    }
    public var increasingRate: Float = 0.3 {
        didSet { lightExtractorEffect.increasingRate = increasingRate }
    }
    public var sparkleAmount: Float = 0.4 {
        didSet { lightExtractorEffect.luminanceThreshold = 1.0 - sparkleAmount * 0.5}
    }
    // DirectionalBlurs
    public let rayCount: Int
    public var rayLength: Float = 0.08 {
        didSet { updateDirectionalShines() }
    }
    public var startAngle: Int = 45 {
        didSet { updateDirectionalShines() }
    }
    public var sparkleExposure: Float = 0.0 {
        didSet { updateDirectionalShines() }
    }

    // MARK: - Effects

    // light map
    private let perlinNoiseEffect = CBPerlineNoise()
    private let lightExtractorEffect = CBKirakiraLightExtractor()

    // center / sparkles
    private let firstBoxBlurEffect = CBBoxBlur()
    private let hsvValueEffect = CBHSV()

    private let dilationEffect = CBDilation()
    private let exposureEffect = ExposureAdjustment()
    private let secondBoxBlurEffect = CBBoxBlur()

    // ray
    private var erosionEffect = CBErosion()

    private lazy var directionalShines: [DirectionalShine] = {
        Array(0...rayCount).map { _ in
            DirectionalShine()
        }
    }()
    private lazy var addBlendEffects: [AddBlend] = {
        Array(0...rayCount).map { _ in
            AddBlend()
        }
    }()

    public init(rayCount: Int = 2) {
        self.rayCount = rayCount
        super.init()

        erosionEffect.steps = 6
        erosionEffect.texelSize = 3

        firstBoxBlurEffect.texelSizeX = 3
        firstBoxBlurEffect.texelSizeY = 3
        firstBoxBlurEffect.kernelSize = 5 * 2

        hsvValueEffect.value = 0.7

        dilationEffect.steps = 8
        dilationEffect.texelStep = 3
        dilationEffect.mode = 1

        secondBoxBlurEffect.texelSizeX = 2
        secondBoxBlurEffect.texelSizeY = 2
        secondBoxBlurEffect.kernelSize = 5 * 2

        setupPipeline()
        updateDirectionalShines()
    }
}

// MARK: - Private functions
extension Sparkles {

    private func updateDirectionalShines() {
        let intervalDegree: Float = 180.0 / Float(rayCount)
        for i in 0 ..< rayCount {
            directionalShines[i].degree = Float(startAngle) + (Float(i) * intervalDegree)
            directionalShines[i].rayLength = rayLength
            directionalShines[i].sparkleExposure = 2 + sparkleExposure
        }
    }
    private func setupPipeline() {
        configureGroup{ input, output in

            input
            --> perlinNoiseEffect
            perlinNoiseEffect.addTarget(lightExtractorEffect, atTargetIndex: 1)

            input
            --> lightExtractorEffect    // lightMapTexture
            --> firstBoxBlurEffect
            --> hsvValueEffect
            --> dilationEffect          // boxBlurredTexture
            --> exposureEffect
            --> secondBoxBlurEffect     // centerTexture

            lightExtractorEffect
            --> erosionEffect           // erodedLightTexture

            var node: ImageProcessingOperation = secondBoxBlurEffect

            for i in 0 ..< rayCount {
                let addBend = addBlendEffects[i]
                let directionalShine = directionalShines[i]

                erosionEffect --> directionalShine // rayTexture
                directionalShine.addTarget(addBend, atTargetIndex: 1)

                node --> addBend // sparkleTexture
                node = addBend
            }

            node
            --> output
        }
    }
}
