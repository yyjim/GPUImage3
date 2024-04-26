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

        applyKiraKira()
    }

    private func applyGrain() {
        let grainFilter = Grain()
        grainFilter.strength = 9.0 / 100.0
        grainFilter.time = 1.1

        picture = PictureInput(image: UIImage(named:"WID-small.jpg")!)
        picture --> grainFilter --> renderView
        picture.processImage()
    }

    private func applyKiraKira() {
        let filter = {
            let filter = Kirakira(rayCount: 3)
            filter.equalMinHue = 0.54
            filter.equalMaxHue = 0
            filter.equalSaturation = 0.15
            filter.equalBrightness = 2.8
            filter.rayLength = 0.5
            filter.sparkleExposure = 0.1
            filter.blur = 0
            filter.colorMode = .random
            filter.saturation = 0.5
            filter.centerSaturation = 0.3
            filter.minHue = 0
            filter.maxHue = 1
            filter.noiseInfluence = 1
            filter.increasingRate = 0.03
            filter.sparkleAmount = 0.6
            return filter
        }()

        picture = PictureInput(image: UIImage(named:"WID-small.jpg")!)
        picture --> filter --> renderView
        picture.processImage()
    }
}

