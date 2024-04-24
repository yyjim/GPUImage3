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
        didSet { directionalShines.sparkleExposure = sparkleExposure }
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

    private let firstExposureEffect = ExposureAdjustment()
    private let secondExposureEffect = ExposureAdjustment()

    private let erosionEffect = CBErosion()
    private let firstAddBlend = AddBlend()
    private let noiseEffect = CBPerlineNoise()
    private let lightExtractorEffect = CBKirakiraLightExtractor()
    private let directionalShines = DirectionalShines()
    private let saturationEffect = SaturationAdjustment()
    private let perlinNoiseEffect = CBPerlineNoise()
    private let secondAddBlend = AddBlend()

    private let directionalShines: [DirectionalShines] = []

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
        ({blur = 0})()
        ({colorMode = .random})()
        ({saturation = 0.3})()
        ({minHue = 0.0})()
        ({maxHue = 1.0})()
        ({noiseInfluence = 1.0})()
        ({increasingRate = 0.3})()
        ({startAngle = 45})()
        ({sparkleScale = 0.7})()
        ({sparkleAmount = 0.4})()
        ({frameRate = 60})()

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
        // lightExtractorEffect.updateValue(.textures([noiseTexture]), for: .noiseTexture)
        // let lightMapTexture = lightExtractorEffect.applyEffect(on: mtlTexture, in: commandBuffer, at: time)

        firstBoxBlurEffect
        firstBoxBlurEffect.texelSizeX = 3
        firstBoxBlurEffect.texelSizeY = 3
        firstBoxBlurEffect.kernelSize = 5 * 2
//        var boxBlurredTexture = boxBlurEffect.applyEffect(on: lightMapTexture, in: commandBuffer, at: time)

        hsvValueEffect.value = 0.7
        // boxBlurredTexture = hsvValueEffect.applyEffect(on: boxBlurredTexture, in: commandBuffer, at: time)

        dilationEffect.steps = 8
        dilationEffect.texelStep = 3
        dilationEffect.mode = 1
//        var centerTexture = dilationEffect.applyEffect(on: boxBlurredTexture, in: commandBuffer, at: time)
        firstExposureEffect.exposure = sparkleExposure
        // centerTexture = exposureEffect.applyEffect(on: centerTexture, in: commandBuffer, at: time)

        secondBoxBlurEffect.texelSizeX = 2
        secondBoxBlurEffect.texelSizeY = 2
        secondBoxBlurEffect.kernelSize = 5 * 2
//        centerTexture = boxBlurEffect.applyEffect(on: centerTexture, in: commandBuffer, at: time)

//        var sparkleTexture = centerTexture
//        // Calculate the degree interval
//        let intervalDegree = 180.0 / Float(rayCount)
        erosionEffect.steps = 6
        erosionEffect.texelSize = 3
//        let erodedLightTexture = erosionEffect.applyEffect(on: lightMapTexture, in: commandBuffer, at: time)

        /*
         for i in 0..<rayCount {
         let directionalBlurEffect()
             updateDirectionalBlurParameters(degree: Float(startAngle) + Float(i) * intervalDegree, length: rayLength)
             var rayTexture = directionalBlurEffect.applyEffect(on: erodedLightTexture, in: commandBuffer, at: time)
             exposureEffect.updateValue(.float(2.0 + sparkleExposure), for: .exposure)
             rayTexture = exposureEffect.applyEffect(on: rayTexture, in: commandBuffer, at: time)
             updateDirectionalBlurParameters(degree: Float(startAngle) + Float(i) * intervalDegree, length: rayLength * 0.4)
             rayTexture = directionalBlurEffect.applyEffect(on: rayTexture, in: commandBuffer, at: time)
             addBlendEffect.updateValue(.textures([rayTexture]), for: .assetTexture)
             sparkleTexture = addBlendEffect.applyEffect(on: sparkleTexture, in: commandBuffer, at: time)
         }
         */
        secondExposureEffect.exposure = 2.0 + sparkleExposure

        thirdBoxBlurEffect.texelSizeX = 2
        thirdBoxBlurEffect.texelSizeY = 2
        thirdBoxBlurEffect.kernelSize = blur * 2

        self.configureGroup{input, output in
            lightExtractorEffect.addTarget(perlinNoiseEffect, atTargetIndex: 1)
            firstAddBlend.addTarget(directionalShines, atTargetIndex: 1)
            secondAddBlend.addTarget(saturationEffect, atTargetIndex: 1)

            input
            --> perlinNoiseEffect

            input
            --> lightExtractorEffect
            --> firstBoxBlurEffect
            --> hsvValueEffect
            --> dilationEffect
            --> firstExposureEffect
            --> secondBoxBlurEffect
            --> firstAddBlend
            --> thirdBoxBlurEffect
            --> saturationEffect

            input
            --> secondAddBlend
            --> output
        }
    }
}
