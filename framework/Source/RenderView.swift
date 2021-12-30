import Foundation
import MetalKit

public class RenderView: MTKView, ImageConsumer {
    
    public let sources = SourceContainer()
    public let maximumInputs: UInt = 1
    var currentTexture: Texture?
    var renderPipelineState:MTLRenderPipelineState!
    
    public override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: sharedMetalRenderingDevice.device)
        
        commonInit()
    }
    
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        framebufferOnly = false
        autoResizeDrawable = true
        
        self.device = sharedMetalRenderingDevice.device
        
        let (pipelineState, _) = generateRenderPipelineState(device:sharedMetalRenderingDevice, vertexFunctionName:"oneInputVertex", fragmentFunctionName:"passthroughFragment", operationName:"RenderView")
        self.renderPipelineState = pipelineState
        
        enableSetNeedsDisplay = false
        isPaused = true
    }
    
    public func newTextureAvailable(_ texture:Texture, fromSourceIndex:UInt) {
        self.drawableSize = CGSize(width: texture.texture.width, height: texture.texture.height)
        currentTexture = texture
        self.draw()
    }


    // See: https://github.com/BradLarson/GPUImage3/issues/5
    // The MaxFramesInFlight set to 3. Check MaxFramesInFlight in this link
    // https://developer.apple.com/documentation/metal/synchronization/synchronizing_cpu_and_gpu_work
    private let inFlightSemaphore = DispatchSemaphore(value: 3)

    public override func draw(_ rect:CGRect) {
        guard let currentDrawable = self.currentDrawable, let imageTexture = currentTexture else {
            return
        }

        guard let commandBuffer = sharedMetalRenderingDevice.commandQueue.makeCommandBuffer() else {
            return
        }

        _ = inFlightSemaphore.wait(timeout: DispatchTime.distantFuture)
        let semaphore = inFlightSemaphore
        commandBuffer.addCompletedHandler { (_ commandBuffer)-> Swift.Void in
            semaphore.signal()
        }
        let outputTexture = Texture(orientation: .portrait, texture: currentDrawable.texture)
        commandBuffer.renderQuad(pipelineState: renderPipelineState,
                                 inputTextures: [0:imageTexture],
                                 outputTexture: outputTexture)
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
}
