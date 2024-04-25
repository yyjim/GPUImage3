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
        didSet { sparklesEffect.equalMinHue = equalMinHue }
    }
    public var equalMaxHue: Float = 0.083 {
        didSet { sparklesEffect.equalMaxHue = equalMaxHue }
    }
    public var equalSaturation: Float = 0.15 {
        didSet { sparklesEffect.equalSaturation = equalSaturation }
    }
    public var equalBrightness: Float = 2.0 {
        didSet { sparklesEffect.equalBrightness = equalBrightness }
    }
    public var speed: Float = 7.5 {
        didSet { sparklesEffect.speed = speed }
    }
    public var rayCount: Int = 2 {
        didSet { sparklesEffect.rayCount = rayCount }
    }
     public var rayLength: Float = 0.08 {
         didSet { sparklesEffect.rayLength = rayLength }
     }
    public var startAngle: Int = 45 {
        didSet { sparklesEffect.startAngle = startAngle }
    }
    public var sparkleExposure: Float = 0.0 {
        didSet { sparklesEffect.sparkleExposure = sparkleExposure }
    }
    public var blur: Float = 0 {
        didSet { boxBlurEffect.kernelSize = blur * 2 }
    }
    public var colorMode: ColorMode = .random {
        didSet { saturationEffect.saturation = saturation * Float(colorMode.rawValue) }
    }
    public var saturation: Float = 0.3 {
        didSet { saturationEffect.saturation = saturation * Float(colorMode.rawValue) }
    }
    public var minHue: Float = 0.0 {
        didSet { sparklesEffect.minHue = minHue }
    }
    public var maxHue: Float = 1.0 {
        didSet { sparklesEffect.maxHue = maxHue }
    }
    public var noiseInfluence: Float = 1.0 {
        didSet { sparklesEffect.noiseInfluence = noiseInfluence }
    }
    public var increasingRate: Float = 0.3 {
        didSet { sparklesEffect.increasingRate = increasingRate }
    }
    public var sparkleScale: Float = 0.7 {
        didSet { sparklesEffect.sparkleScale = sparkleScale }
    }
    public var sparkleAmount: Float = 0.4 {
        didSet { sparklesEffect.sparkleAmount = sparkleAmount}
    }
    public var frameRate: Float = 60 {
        didSet { sparklesEffect.frameRate = frameRate }
    }

    private let sparklesEffect = Sparkles()
    private let boxBlurEffect = CBBoxBlur()
    private let saturationEffect = SaturationAdjustment()
    private let addBlend = AddBlend()

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

        boxBlurEffect.texelSizeX = 2
        boxBlurEffect.texelSizeY = 2
        boxBlurEffect.kernelSize = blur * 2

        self.configureGroup{
            input, output in

            input
            --> sparklesEffect
            --> boxBlurEffect
            --> saturationEffect
//
//            input
//            --> addBlend
            --> output

//            saturationEffect.addTarget(addBlend, atTargetIndex: 1)
        }
    }
}
