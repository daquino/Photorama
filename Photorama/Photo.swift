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
    
    func addTagObject(tag: NSManagedObject) {
        let currentTags = mutableSetValueForKey("tags")
        currentTags.addObject(tag)
    }
    
    func removeTagObject(tag: NSManagedObject) {
        let currentTags = mutableSetValueForKey("tags")
        currentTags.removeObject(tag)
    }

}
