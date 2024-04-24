//
//  Kirakira.swift
//  GPUImage
//
//  Created by Jim Wang on 2024/3/29.
//  Copyright © 2024 Red Queen Coder, LLC. All rights reserved.
//

import Foundation

public class Kirakira: OperationGroup {

    public enum ColorMode: Int {
        case white = 0
        case random = 1
    }

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
    public var speed: Float = 7.5 {
        didSet { noiseEffect.speed = speed }
    }
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
    public var blur: Float = 0 {
        didSet { thirdBoxBlurEffect.kernelSize = blur * 2 }
    }
    public var colorMode: ColorMode = .random {
        didSet { saturationEffect.saturation = saturation * Float(colorMode.rawValue) }
    }
    public var saturation: Float = 0.3 {
        didSet { saturationEffect.saturation = saturation * Float(colorMode.rawValue) }
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
    public var sparkleScale: Float = 0.7 {
        didSet { noiseEffect.scale = sparkleScale }
    }
    public var sparkleAmount: Float = 0.4 {
        didSet { lightExtractorEffect.luminanceThreshold = 1.0 - sparkleAmount * 0.5}
    }
    public var frameRate: Float = 60 {
        didSet { noiseEffect.frameRate = Float(frameRate) }
    }

    private let firstBoxBlurEffect = CBBoxBlur()
    private let secondBoxBlurEffect = CBBoxBlur()
    private let thirdBoxBlurEffect = CBBoxBlur()

    private let hsvValueEffect = CBHSV()
    private let dilationEffect = CBDilation()

    private let exposureEffect = ExposureAdjustment()

    private let erosionEffect = CBErosion()
    private let firstAddBlend = AddBlend()
    private let noiseEffect = CBPerlineNoise()
    private let lightExtractorEffect = CBKirakiraLightExtractor()
    private let directionalShines = DirectionalShines()
    private let saturationEffect = SaturationAdjustment()
    private let perlinNoiseEffect = CBPerlineNoise()
    private let secondAddBlend = AddBlend()

    public override init() {
        super.init()
//        ({equalMinHue = 0.75})()
//        ({equalMaxHue = 0.083})()
//        ({equalSaturation = 0.15})()
//        ({equalBrightness = 2.0})()
//        ({speed = 7.5})()
//        ({rayCount = 2})()
//        ({rayLength = 0.08})()
//        ({sparkleExposure = 0.0})()
//        ({blur = 0})()
//        ({colorMode = .random})()
//        ({saturation = 0.3})()
//        ({minHue = 0.0})()
//        ({maxHue = 1.0})()
//        ({noiseInfluence = 1.0})()
//        ({increasingRate = 0.3})()
//        ({startAngle = 45})()
//        ({sparkleScale = 0.7})()
//        ({sparkleAmount = 0.4})()
//        ({frameRate = 60})()

        noiseEffect.speed = speed
        noiseEffect.scale = sparkleScale
        noiseEffect.frameRate = frameRate

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

        erosionEffect.steps = 6
        erosionEffect.texelSize = 3

        directionalShines.rayCount = rayCount
        directionalShines.rayLength = rayLength
        directionalShines.startAngle = startAngle
        directionalShines.sparkleExposure = 2.0 + sparkleExposure

        thirdBoxBlurEffect.texelSizeX = 2
        thirdBoxBlurEffect.texelSizeY = 2
        thirdBoxBlurEffect.kernelSize = blur * 2

        self.configureGroup{
            input, output in
//            input --> output
            
//            input
//            --> perlinNoiseEffect
//            --> output

            input
            --> lightExtractorEffect
            --> firstBoxBlurEffect
            --> hsvValueEffect
            --> dilationEffect
            --> exposureEffect
            --> secondBoxBlurEffect
            --> firstAddBlend
            --> thirdBoxBlurEffect
            --> saturationEffect
            
            lightExtractorEffect
            --> directionalShines
            
            print(
                "🌲",
                lightExtractorEffect.maximumInputs,
                firstAddBlend.maximumInputs,
                secondAddBlend.maximumInputs,
                "\n",
                lightExtractorEffect.sources.sources.count,
                firstAddBlend.sources.sources.count,
                secondAddBlend.sources.sources.count
            )

            perlinNoiseEffect.addTarget(lightExtractorEffect, atTargetIndex: 1)
            directionalShines.addTarget(firstAddBlend, atTargetIndex: 1)
            saturationEffect.addTarget(secondAddBlend, atTargetIndex: 1)

            input
            --> secondAddBlend
            --> output
        }
    }
}
