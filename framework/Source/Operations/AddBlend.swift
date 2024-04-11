public class AddBlend: BasicOperation {

    public var opacity: Float = 1 { didSet { uniformSettings["opacity"] = opacity } }

    public init() {
        super.init(fragmentFunctionName:"addBlendFragment", numberOfInputs:2)
        ({
            opacity = 1
        })()
    }
}
