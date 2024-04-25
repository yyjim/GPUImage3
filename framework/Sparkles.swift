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

    public var speed: Float = 7.5 {
        didSet { perlinNoiseEffect.speed = speed }
    }
    public var sparkleScale: Float = 0.7 {
        didSet { perlinNoiseEffect.scale = sparkleScale }
    }
    public var frameRate: Float = 60 {
        didSet { perlinNoiseEffect.frameRate = frameRate }
    }
    //
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
    //
    public var rayCount: Int = 2 {
        didSet { directionalShines.rayCount = rayCount }
    }
     public var rayLength: Float = 0.08 {
         didSet { directionalShines.rayLength = rayLength }
     }
    public var startAngle: Int = 45 {
        didSet { directionalShines.startAngle = startAngle }
    }
    public var sparkleExposure: Float = 0.0 {
        didSet {
            exposureEffect.exposure = sparkleExposure
            directionalShines.sparkleExposure = 2.0 + sparkleExposure
        }
    }

    // MARK: - Effects

    private let perlinNoiseEffect = CBPerlineNoise()
    private let lightExtractorEffect = CBKirakiraLightExtractor()

    private let directionalShines = DirectionalShines()

    private let firstBoxBlurEffect = CBBoxBlur()
    private let hsvValueEffect = CBHSV()

    private let dilationEffect = CBDilation()
    private let exposureEffect = ExposureAdjustment()
    private let secondBoxBlurEffect = CBBoxBlur()

    private let firstAddBlend = AddBlend()

    public override init() {
        super.init()
        ({equalMinHue = 0.75})()
        ({equalMaxHue = 0.083})()
        ({equalSaturation = 0.15})()
        ({equalBrightness = 2.0})()
        ({speed = 7.5})()
        ({rayCount = 2})()
        ({rayLength = 0.08})()
        ({sparkleExposure = 0.0})()
        ({minHue = 0.0})()
        ({maxHue = 1.0})()
        ({noiseInfluence = 1.0})()
        ({increasingRate = 0.3})()
        ({startAngle = 45})()
        ({sparkleScale = 0.7})()
        ({sparkleAmount = 0.4})()
        ({frameRate = 60})()

        perlinNoiseEffect.speed = speed
        perlinNoiseEffect.scale = sparkleScale
        perlinNoiseEffect.frameRate = frameRate

        lightExtractorEffect.luminanceThreshold = 1.0 - sparkleAmount * 0.5
        lightExtractorEffect.noiseInfluence = noiseInfluence
        lightExtractorEffect.increasingRate = increasingRate
        lightExtractorEffect.minHue = minHue
        lightExtractorEffect.maxHue = maxHue
        lightExtractorEffect.equalMinHue = equalMinHue
        lightExtractorEffect.equalMaxHue = equalMaxHue
        lightExtractorEffect.equalSaturation = equalSaturation
        lightExtractorEffect.equalBrightness = equalBrightness

        firstBoxBlurEffect.texelSizeX = 3
        firstBoxBlurEffect.texelSizeY = 3
        firstBoxBlurEffect.kernelSize = 5 * 2

        hsvValueEffect.value = 0.7

        dilationEffect.steps = 8
        dilationEffect.texelStep = 3
        dilationEffect.mode = 1
        exposureEffect.exposure = sparkleExposure

        secondBoxBlurEffect.texelSizeX = 2
        secondBoxBlurEffect.texelSizeY = 2
        secondBoxBlurEffect.kernelSize = 5 * 2

        directionalShines.rayCount = rayCount
        directionalShines.rayLength = rayLength
        directionalShines.startAngle = startAngle
        directionalShines.sparkleExposure = 2.0 + sparkleExposure


        self.configureGroup{
            input, output in

//            input --> output

            input
            --> perlinNoiseEffect

            input
            --> lightExtractorEffect
            --> firstBoxBlurEffect
            --> hsvValueEffect
            --> dilationEffect
            --> exposureEffect
            --> secondBoxBlurEffect
            --> directionalShines
            --> output

//            --> firstAddBlend
//            --> thirdBoxBlurEffect
//            --> saturationEffect
//            --> output

//            lightExtractorEffect.addTarget(directionalShines, atTargetIndex: 1)
//            lightExtractorEffect
//            --> directionalShines
//            directionalShines
//            --> output

            perlinNoiseEffect.addTarget(lightExtractorEffect, atTargetIndex: 1)
            directionalShines.addTarget(firstAddBlend, atTargetIndex: 1)

//            input
//            --> secondAddBlend
//            --> output
        }
    }
}
