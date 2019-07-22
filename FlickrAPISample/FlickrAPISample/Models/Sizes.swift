
import Foundation

import Foundation
//It was really hard to call this 'Sizes' but I wanted to keep consistency with the api
struct Sizes {
    let canBlog: Int
    let canPrint: Int
    let canDownload: Int
    let size: [Size]
}

extension Sizes: Decodable {
    enum SizesKeys: String, CodingKey {
        case canBlog = "canblog"
        case canPrint = "canprint"
        case canDownload = "candownload"
        case size
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SizesKeys.self)
        canBlog = try container.decode(Int.self, forKey: .canBlog)
        canPrint = try container.decode(Int.self, forKey: .canPrint)
        canDownload = try container.decode(Int.self, forKey: .canDownload)
        size = try container.decode([Size].self, forKey: .size)
    }
}

struct Size {
    let label: String
    let source: String
    let url: String
    let media: String
}

extension Size: Decodable {
    enum SizeKeys: String, CodingKey {
        case label
        case source
        case url
        case media
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SizeKeys.self)
        label = try container.decode(String.self, forKey: .label)
        source = try container.decode(String.self, forKey: .source)
        url = try container.decode(String.self, forKey: .url)
        media = try container.decode(String.self, forKey: .media)
    }
}
