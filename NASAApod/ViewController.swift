import UIKit

/// Main Application View
class ViewController: UIViewController {

    /// Outlets connected to the interface
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var nasaImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
        descriptionLabel.text = ""
        copyrightLabel.text = ""
    
        updateInterface()
    }
    
    func updateInterface() {
        let pcinfo = PhotoInfoController()
        pcinfo.fetchPhotoInfo { (info) in
            /* Run code block on the main thread so the application continues to
               run (asynchronously) while waiting for the block to complete.
             */
            DispatchQueue.main.async {
                // Verify that photo information is available
                guard let photoInfo = info else { return }
                // Populate interface with the text data
                self.titleLabel.text = photoInfo.title
                self.descriptionLabel.text = photoInfo.description
                if let copyright = photoInfo.copyright {
                    self.copyrightLabel.text =
                    "by: \(copyright)"
                } else {
                    self.copyrightLabel.isHidden = true
                }
                
                // Load image data using url returned by the server
                pcinfo.fetchImage(url: photoInfo.url) {
                    (image)-> Void in
                    /* Run the code on the main thread so the application continues to
                       run while waiting for the code block to complete.
                     */
                    DispatchQueue.main.async {
                        /* Verify the image data is available and it's format can be used
                           to create an image.
                         */
                        guard let theImage = image else { return }
                        // Update image on the interface if available
                        self.nasaImage.image = theImage
                    }
                }
            }
        }
    }
}
