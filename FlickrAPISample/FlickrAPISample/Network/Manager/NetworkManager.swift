
import Foundation
struct NetworkManager {

    private let router = Router<FlickrAPI>()

    enum NetworkResponse: Error {
        case success
        case badRequest = "bad request"
        case failed = "request failed"
        case noData = "response with no data"
        case unableToDecode = "Could not decode"
        case networkFail = "Check your connection"
    }
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Bool, NetworkError> {
        switch response.statusCode {
        case 200...299: return .success(true)
        case 501...599: return .failure(.failedBuildRequest)
        default: return .failure(.failedBuildRequest)
        }
    }
    /*
     case directUrl(url: URL)
     case getImagesWithTags([String], Int)
     case getImageSizes(String)
     case getImageBySource(String)
     */
    
    func getImagesWithTags(page: Int, tags: [String], completion: @escaping (ImageResults) -> Void) {
        router.request(.getImagesWithTags(tags, page), completion: { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(Root.self, from: response.data)
                    completion(results.photos)
                } catch let err {
                    print(err)
                }
            case let .failure(error):
                print(error)
            }
        })
    }
    func getImageSize(photoId: String, completion: @escaping (Sizes?, _ error: NetworkError) -> Void) {
        router.request(.getImageSizes(photoId), completion: { data, response, error in
            guard error == nil else { completion(nil, NetworkResponse.failed) }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else { completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(SizesResults.self, from: responseData)
                        completion(apiResponse.location, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let error):
                    completion(nil, NetworkError.failedBuildRequest)
                }
            }
        })
    }
    
    func getDetails(url: String, completion: @escaping(_ location: Location?, _ error: String?) -> Void) {
        guard let url = URL(string: url) else { completion(nil, "Error in url"); return }
        router.request(.directUrl(url: url), completion: { data, response, error in
            guard error == nil else { completion(nil, NetworkResponse.networkFail.rawValue); return }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else { completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(LocationResponse.self, from: responseData)
                        completion(apiResponse.location, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
        })
    }
}
