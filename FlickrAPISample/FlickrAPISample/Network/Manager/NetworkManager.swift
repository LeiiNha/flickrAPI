
import Foundation

protocol NetworkManagerProtocol {
    func getImagesWithTags(page: Int, tags: [String], completion: @escaping (ImageResults?, _ error: NetworkError?) -> Void)
    func getImageSize(photoId: String, completion: @escaping (Sizes?, _ error: NetworkError?) -> Void)
    func cancelRequest()
}
struct NetworkManager: NetworkManagerProtocol {

    private let router = Router<FlickrAPI>()
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Bool, NetworkError> {
        switch response.statusCode {
        case 200...299: return .success(true)
        case 501...599: return .failure(.failedBuildRequest)
        default: return .failure(.failedBuildRequest)
        }
    }
    
    func getImagesWithTags(page: Int, tags: [String], completion: @escaping (ImageResults?, _ error: NetworkError?) -> Void) {
        router.request(.getImagesWithTags(tags, page), completion: { data, response, error in
            guard error == nil else {
                completion(nil, NetworkError.failedBuildRequest)
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else { completion(nil, NetworkError.encodingFailed)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(Root.self, from: responseData)
                        completion(apiResponse.photos, nil)
                    } catch {
                        completion(nil, NetworkError.encodingFailed)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
        })
    }
    
    func getImageSize(photoId: String, completion: @escaping (Sizes?, _ error: NetworkError?) -> Void) {
        router.request(.getImageSizes(photoId), completion: { data, response, error in
            guard error == nil else {
                completion(nil, NetworkError.failedBuildRequest)
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else { completion(nil, NetworkError.encodingFailed)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(SizesResults.self, from: responseData)
                        completion(apiResponse.sizes, nil)
                    } catch {
                        completion(nil, NetworkError.encodingFailed)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
        })
    }
    
    func cancelRequest() {
        router.cancel()
    }
}
