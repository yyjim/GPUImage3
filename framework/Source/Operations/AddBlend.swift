public class AddBlend: BasicOperation {

    public var intensity: Float = 1 { didSet { uniformSettings["intensity"] = intensity } }

    public init() {
        super.init(fragmentFunctionName:"addBlendFragment", numberOfInputs:2)
        ({
            intensity = 1
        })()
    }
}
