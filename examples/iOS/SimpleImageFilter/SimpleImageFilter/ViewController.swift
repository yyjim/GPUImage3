import UIKit
import GPUImage

class ViewController: UIViewController {
    
    @IBOutlet weak var renderView: RenderView!

    var picture: PictureInput!


    override func viewDidLoad() {
        super.viewDidLoad()
        renderView.contentMode = .scaleAspectFit
        renderView.colorPixelFormat = .bgra8Unorm
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        applyGrain()
    }

    private lazy var grainFilter = Grain()
    private func applyGrain() {
//        let grainFilter = Grain()
//        grainFilter.strength = 9.0 / 100.0
//        grainFilter.time = 1.1

        let filter = Kirakira()

//        let filter = CBKirakiraLightExtractor()
//        let input2 = PictureInput(image: UIImage(named:"overlay-1.jpg")!)
//        input2.addTarget(filter, atTargetIndex: 1)
//        input2.processImage()

//        picture = PictureInput(image: UIImage(named:"overlay-3.png")!)
        picture = PictureInput(image: UIImage(named:"WID-small.jpg")!)

//        picture --> filter --> blendImage

//        let linearDodge = AddBlend()
//        blendImage.addTarget(linearDodge, atTargetIndex: 1)
//        blendImage.processImage()

        picture --> filter --> renderView
        picture.processImage()
    }
}

