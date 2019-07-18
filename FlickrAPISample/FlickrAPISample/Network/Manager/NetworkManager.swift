
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

    enum Result<String> {
        case success
        case failure(String)
    }

    private func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
