
import Foundation

struct Sizes: Codable {
    let canBlog: Int
    let canPrint: Int
    let canDownload: Int
    let size: [Size]
}

struct Size: Codable {
    let label: String
    let source: String
    let url: String
    let media: String
}
