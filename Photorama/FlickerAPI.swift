import Foundation

enum Method: String {
    case RecentPhotos = "flickr.photos.getRecent"
}

enum PhotosResult {
    case Success([Photo])
    case Failure(ErrorType)
}

enum FlickerError: ErrorType {
    case InvalidJSONData
}

struct FlickerAPI {
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "bffa65a71b3146a960039675a491f7f7"
    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    
    static func  recentPhotosUrl() -> NSURL {
        return flickerURL(.RecentPhotos, parameters: ["extras":"url_h,date_taken"])
    }
    
    private static func flickerURL(method: Method, parameters: [String:String]?) -> NSURL {
        let components = NSURLComponents(string: baseURLString)!
        var queryItems = [NSURLQueryItem]()
        let baseParams = ["method": method.rawValue,
                          "format": "json",
                          "nojsoncallback": "1",
                          "api_key": APIKey]
        for (key, value) in baseParams {
            let queryItem = NSURLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        }
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let queryItem = NSURLQueryItem(name: key, value: value)
                queryItems.append(queryItem)
            }
        }
        components.queryItems = queryItems
        return components.URL!
    }
    
    static func photosFromJSONData(data: NSData) -> PhotosResult {
        do {
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            guard let
                jsonDictionary = jsonObject as? [NSObject:AnyObject],
                photos = jsonDictionary["photos"] as? [String:AnyObject],
                photosArray = photos["photo"] as? [[String:AnyObject]] else {
                    return .Failure(FlickerError.InvalidJSONData)
            }
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photoFromJSONObject(photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            if(finalPhotos.count == 0 && photosArray.count > 0) {
                return .Failure(FlickerError.InvalidJSONData)
            }
            return .Success(finalPhotos)
        }
        catch {
            return .Failure(error)
        }
    }
    
    static func photoFromJSONObject(json: [String : AnyObject]) -> Photo? {
        guard let
            photoId = json["id"] as? String,
            title = json["title"] as? String,
            dateString = json["datetaken"] as? String,
            photoURLString = json["url_h"] as? String,
            url = NSURL(string: photoURLString),
            dateTaken = dateFormatter.dateFromString(dateString) else {
                return nil
        }
        
        return Photo(title: title, photoId: photoId, remoteURL: url, dateTaken: dateTaken)
        
    }
}