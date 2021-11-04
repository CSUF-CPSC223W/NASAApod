import Foundation
import UIKit

/// Retrieve and format data from the NASA Astronomy photo of the day web API
class PhotoInfoController {
    
    /// Construct a PhotoInfo object from NASA's photo of the day web API.
    ///
    /// The  @escaping annotation  is a special annotation indicating that the closure
    /// may be called after the fetchPhotoInfo exits. Take note that
    /// the network request runs in the background and can take longer
    /// to complete as it waits for data from the server.
    /// - Parameter completion: closure that is passed a nullable PhotoInfo object when the data is received from the server
    func fetchPhotoInfo(on date: String, completion: @escaping (PhotoInfo?)->Void ){
        // URL of the NASA photo of the day endpoint.
        let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
        
        // Add the date of the photo to view and an API key used for authentication.
        let query: [String: String] = [
        "api_key": "DEMO_KEY",
        "date": date
        ]
        
        // Verify that the queries are valid and the URL is converted to the HTTPS scheme.
        guard let url = baseURL.withQueries(query), let secureURL = url.withHTTPS() else {
            return
        }
        
        // Create a request to retrieve data from the NASA server. The closure is called
        // once the server replies to the request.
        let task = URLSession.shared.dataTask(with: secureURL) {
            (data, response, error) in
            // Decode the data into a PhotoInfo object.
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let photoInfo = try? jsonDecoder.decode(PhotoInfo.self, from: data) {
                // Call the closure and pass the constructed PhotoInfo object.
                completion(photoInfo)
            } else {
                print("Either no data was returned, or data was not properly decoded.")
                // Call the closure and pass nil when data cannot be retrieved or decoded.
                completion(nil)
            }
        }
        // Send the request
        task.resume()
    }
    
    
    /// Create a UIImage object from a URL
    /// - Parameters:
    ///   - url: url of the image
    ///   - completion: closure is called and passed the nullable UIImage after getting the server repl
    func fetchImage(url: URL, completion: @escaping (UIImage?)->Void) {
        // Create a request to retrieve an image from the NASA server using the
        // photo URL.
        let task = URLSession.shared.dataTask(with: url) {
            (data,response, error) in
            /* Verify the image data is available and it can be used
               to create an image.
             */
            guard let imageData = data,
                    let image = UIImage(data: imageData) else {
                // Call the completion closure and pass nil if data can not be loaded
                completion(nil)
                return
            }
            // Call the completion closure and pass the UIImage object if it is available
            completion(image)
        }
        // Send the request
        task.resume()
    }
}
