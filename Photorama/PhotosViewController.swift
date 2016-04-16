import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        store.fetchRecentPhotos() {
            (photosResult) -> Void in
            switch (photosResult) {
            case let .Success(photos):
                if let firstPhoto = photos.first {
                    self.store.fetchImageForPhoto(firstPhoto, completion: { (imageResult) in
                        switch(imageResult) {
                        case let .Success(image):
                            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                                self.imageView.image = image
                            })
                        case let .Failure(error):
                            print("Error downloading image: \(error)")
                        }
                    })
                }
            case let .Failure(error):
                print("Error fetching recent photos: \(error)")
            }
        }
    }
}