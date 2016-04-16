import UIKit

class PhotoInfoViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchImageForPhoto(photo) { (imageResult) in
            switch imageResult {
            case let .Success(image):
                NSOperationQueue.mainQueue().addOperationWithBlock({ 
                    self.imageView.image = image
                })
            case let .Failure(error):
                print("Error fetching image for photo: \(error)")
            }
        }
    }
}