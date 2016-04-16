import UIKit

class Photo {
    let title: String
    let remoteURL: NSURL
    let photoId: String
    let dateTaken: NSDate
    var image: UIImage?
    
    init(title: String, photoId: String, remoteURL: NSURL, dateTaken: NSDate) {
        self.title = title
        self.photoId = photoId
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}

extension Photo: Equatable {}

func == (lhs: Photo, rhs: Photo) -> Bool {
    return lhs.photoId == rhs.photoId
}