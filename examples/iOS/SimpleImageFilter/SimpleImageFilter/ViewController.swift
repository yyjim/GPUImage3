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
        let grainFilter = Grain()
        grainFilter.strength = 9.0 / 100.0
        grainFilter.time = 1.1

        picture = PictureInput(image: UIImage(named:"WID-small.jpg")!)
        picture --> grainFilter --> renderView
        picture.processImage()
    }
}

