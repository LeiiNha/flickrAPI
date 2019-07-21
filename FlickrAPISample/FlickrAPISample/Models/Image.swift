import Foundation

struct Root: Codable {
    let photos: ImageResults
    let stat: String
}

struct ImageResults: Codable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: String
    var photo: [Image]
}

struct Image: Codable {
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

struct SizesResults: Codable {
    let sizes: Sizes
    let stat: String
}
