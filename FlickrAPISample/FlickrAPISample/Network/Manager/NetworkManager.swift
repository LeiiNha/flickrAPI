
import Foundation
struct NetworkManager {

    private let router = Router<FlickrAPI>()

    enum NetworkResponse: String {
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
}
