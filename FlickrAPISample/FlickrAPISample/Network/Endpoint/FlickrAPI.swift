
import Foundation

public enum FlickrAPI {
    case directUrl(url: URL)
    case getImagesWithTags([String], Int)
    case getImageSizes(String)
    case getImageBySource(String)
}

private enum Constants {
    static let baseURL = "https://api.flickr.com/"
    static let APIKey = "f9cc014fa76b098f9e82f1c288379ea1"
    static let responseFormat = "json"
}

extension FlickrAPI: EndpointType {
    
    var baseURL: URL {
        switch self {
        case .getImageBySource(let source):
            return URL(string: source)!
        default:
            return URL(string: Constants.baseURL)!
        }
    }
    
    var path: String {
        switch self {
        case .directUrl:
            return ""
        default:
            return "services/rest/"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        return .request
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        params["api_key"] = Constants.APIKey
        params["format"] = Constants.responseFormat
        //para["nojsoncallback"] = "1"
        switch self {
        case .getImageSizes(let photoId):
            params["method"] = "flickr.photos.getSizes"
            params["photo_id"] = photoId
            return params
        case .getImagesWithTags(let tags, let page):
            params["method"] = "flickr.photos.search"
            params["page"] = page
            params["tags"] = tags.joined(separator: ",")
            return params
        case .getImageBySource:
            return nil
        default:
            return nil
        }
    }
}
