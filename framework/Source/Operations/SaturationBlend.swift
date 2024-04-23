public class SaturationBlend: BasicOperation {

    // 0.0 ... 2.0
    public var saturation: Float = 1 { didSet { uniformSettings["saturation"] = saturation } }

    public init() {
        super.init(fragmentFunctionName:"saturationBlendFragment", numberOfInputs:2)
    }
}
