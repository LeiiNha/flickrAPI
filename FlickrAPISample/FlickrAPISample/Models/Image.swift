import Foundation

struct Root: Decodable {
    private enum RootKeys: String, CodingKey {
        case stat
        case photos
    }
    let photos: ImageResults
    let stat: String
}

struct ImageResults: Decodable {
    private enum ImageResultsKeys: String, CodingKey {
        case page
        case pages
        case perpage
        case total
        case photo
    }
    var page: Int
    var pages: Int
    var perpage: Int
    var total: String
    var photo: [Image]
}

struct Image {
    let identifier: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let isPublic: Int
    let isFriend: Int
    let isFamily: Int
    var sizes: Sizes?
}

extension Image: Decodable {
    enum ImageKeys: String, CodingKey {
        case identifier = "id"
        case owner
        case secret
        case server
        case farm
        case title
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ImageKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        owner = try container.decode(String.self, forKey: .owner)
        secret = try container.decode(String.self, forKey: .secret)
        server = try container.decode(String.self, forKey: .server)
        farm = try container.decode(Int.self, forKey: .farm)
        title = try container.decode(String.self, forKey: .title)
        isPublic = try container.decode(Int.self, forKey: .isPublic)
        isFriend = try container.decode(Int.self, forKey: .isFriend)
        isFamily = try container.decode(Int.self, forKey: .isFamily)
        sizes = nil
    }
}

struct SizesResults: Decodable {
    private enum SizesResultsKeys: String, CodingKey {
        case stat
        case sizes
    }
    let sizes: Sizes
    let stat: String
}
