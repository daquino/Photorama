import UIKit
import CoreData


class Photo: NSManagedObject {

    var image: UIImage?
    
    override func awakeFromInsert() {
        title = ""
        photoID = ""
        remoteURL = NSURL()
        photoKey = NSUUID().UUIDString
        dateTaken = NSDate()
    }
    
    func incrementViewCount() {
        viewCount = NSNumber(integer: viewCount.integerValue+1)
    }

}
