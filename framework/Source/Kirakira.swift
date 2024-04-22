//
//  Kirakira.swift
//  GPUImage
//
//  Created by Jim Wang on 2024/3/29.
//  Copyright © 2024 Red Queen Coder, LLC. All rights reserved.
//

import Foundation

//public class SmoothToonFilter: OperationGroup {
//    public var blurRadiusInPixels: Float = 2.0 { didSet { gaussianBlur.blurRadiusInPixels = blurRadiusInPixels } }
//    public var threshold: Float = 0.2 { didSet { toonFilter.threshold = threshold } }
//    public var quantizationLevels: Float = 10.0 { didSet { toonFilter.quantizationLevels = quantizationLevels } }
//
//    let gaussianBlur = GaussianBlur()
//    let toonFilter = ToonFilter()
//
//    public override init() {
//        super.init()
//
//        ({blurRadiusInPixels = 2.0})()
//        ({threshold = 0.2})()
//        ({quantizationLevels = 10.0})()
//
//        self.configureGroup{input, output in
//            input --> self.gaussianBlur --> self.toonFilter --> output
//        }
//    }
//}

public class Kirakira: OperationGroup {

    public enum ColorMode: Int {
        case white = 0
        case random = 1
    }

//    public var equalMinHue: Float = 0.75 {
//        didSet { uniformSettings["equalMinHue"] = equalMinHue }
//    }
//    public var equalMaxHue: Float = 0.083 {
//        didSet { uniformSettings["equalMaxHue"] = equalMaxHue }
//    }
//    public var equalSaturation: Float = 0.15 {
//        didSet { uniformSettings["equalSaturation"] = equalSaturation }
//    }
//    public var equalBrightness: Float = 2.0 {
//        didSet { uniformSettings["equalBrightness"] = equalBrightness }
//    }
//    public var speed: Float = 7.5 {
//        didSet { uniformSettings["speed"] = speed }
//    }
//    public var rayCount: Int = 2 {
//        didSet { uniformSettings["rayCount"] = Float(rayCount) }
//    }
//    public var rayLength: Float = 0.08 {
//        didSet { uniformSettings["rayLength"] = rayLength }
//    }
//    public var sparkleExposure: Float = 0.0 {
//        didSet { uniformSettings["sparkleExposure"] = sparkleExposure }
//    }
//    public var blur: Float = 0 {
//        didSet { uniformSettings["blur"] = blur }
//    }
//    public var colorMode: ColorMode = .random {
//        didSet { uniformSettings["colorMode"] = Float(colorMode.rawValue) }
//    }
//    public var saturation: Float = 0.3 {
//        didSet { uniformSettings["saturation"] = saturation }
//    }
//    public var minHue: Float = 0.0 {
//        didSet { uniformSettings["minHue"] = minHue }
//    }
//    public var maxHue: Float = 1.0 {
//        didSet { uniformSettings["maxHue"] = maxHue }
//    }
//    public var noiseInfluence: Float = 1.0 {
//        didSet { uniformSettings["noiseInfluence"] = noiseInfluence }
//    }
//    public var increasingRate: Float = 0.3 {
//        didSet { uniformSettings["increasingRate"] = increasingRate }
//    }
//    public var startAngle: Int = 45 {
//        didSet { uniformSettings["startAngle"] = Float(startAngle) }
//    }
//    public var sparkleScale: Float = 0.7 {
//        didSet { uniformSettings["sparkleScale"] = sparkleScale }
//    }
//    public var sparkleAmount: Float = 0.4 {
//        didSet { uniformSettings["sparkleAmount"] = sparkleAmount }
//    }
//    public var frameRate: Int = 60 {
//        didSet { uniformSettings["frameRate"] = Float(frameRate) }
//    }

//    public init() {
        // TODO
//        super.init(fragmentFunctionName:"grainEffectFragment", numberOfInputs:1)
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
//    }
}
