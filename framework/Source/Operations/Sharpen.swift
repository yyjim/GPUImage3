import Metal

public class Sharpen: BasicOperation {
    public var sharpness:Float = 0.0 { didSet { uniformSettings["sharpness"] = sharpness } }
    public var overriddenTexelSize:Size? {
        didSet {
            uniformSettings["texelWidth"] = overriddenTexelSize?.width ?? 1.0
            uniformSettings["texelHeight"] = overriddenTexelSize?.height ?? 1.0
        }
    }

    public init() {
        super.init(vertexFunctionName: "sharpenVertex", fragmentFunctionName: "sharpenFragment", numberOfInputs: 1)
        
        ({sharpness = 0.0})()
    }
    
    // Pretty sure this is OpenGL only
//    override func configureFramebufferSpecificUniforms(_ inputFramebuffer:Framebuffer) {
//        let outputRotation = overriddenOutputRotation ?? inputFramebuffer.orientation.rotationNeededForOrientation(.portrait)
//        let texelSize = overriddenTexelSize ?? inputFramebuffer.texelSize(for:outputRotation)
//        uniformSettings["texelWidth"] = texelSize.width
//        uniformSettings["texelHeight"] = texelSize.height
//    }

    override func internalRenderFunction(commandBuffer: MTLCommandBuffer, outputTexture: Texture) {
        overriddenTexelSize = Size(
            width: Float(1) / Float(outputTexture.texture.width),
            height: Float(1) / Float(outputTexture.texture.height)
        )
        super.internalRenderFunction(commandBuffer: commandBuffer, outputTexture: outputTexture)
    }
}
