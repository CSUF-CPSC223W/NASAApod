import Foundation

/// Stores and decodes JSON information from the NASA Astronomy photo of the day web API
struct PhotoInfo : Codable {
    // Each property will contain the corresponding value from the JSON file
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    
    // We use an enumeration whose cases correspond to each property
    enum CodingKeys: String, CodingKey {
        case title
        /* In some cases, we want to use a different name for our
           property. For example, the JSON-formatted String has an
           attribute called explanation, but we want to use a different
           name to refer to it. So we use description and map it to
           explanation. */
        case description = "explanation"
        case url
        case copyright
    }
    
    
    /// Initialize a PhotoInfo object using data the is decoded by a decoder. In this case, a JSON decoder.
    /// - Parameter decoder: decoder object used to decode date
    init(from decoder: Decoder) throws {
        /* We assign our enumeration as the decoder's container.
           We use decode to extract one element from the
           JSON-formatted string and store it in the appropriate
           property. */
        let valueContainer = try decoder.container(keyedBy:
           CodingKeys.self)
        self.title = try valueContainer.decode(String.self,
           forKey: CodingKeys.title)
        self.description = try
           valueContainer.decode(String.self, forKey:
           CodingKeys.description)
        self.url = try valueContainer.decode(URL.self, forKey:
           CodingKeys.url)
        self.copyright = try? valueContainer.decode(String.self,
           forKey: CodingKeys.copyright)
    }
}
