
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
    static let getSizesMethod = "flickr.photos.getSizes"
    static let searchMethod = "flickr.photos.search"
}

extension FlickrAPI: EndpointType {
    
    var baseURL: URL {
        switch self {
        case .getImageBySource(let source):
            return URL(string: source)!
        default:
            return URL(string: Constants.baseURL)!.appendingPathComponent(self.path)
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
        if let params = parameters {
            return HTTPTask.requestParameters(bodyParameters: params, urlParameters: params)
        }
        return HTTPTask.request
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        params["api_key"] = Constants.APIKey
        params["format"] = Constants.responseFormat
        params["nojsoncallback"] = "1"
        switch self {
        case .getImageSizes(let photoId):
            params["method"] = Constants.getSizesMethod
            params["photo_id"] = photoId
            return params
        case .getImagesWithTags(let tags, let page):
            params["method"] = Constants.searchMethod
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
