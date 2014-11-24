import Foundation
import UIKit
import CoreLocation
import MapKit

class Photo: NSObject, MKAnnotation {
    let image: UIImage
    let createdAt: NSDate
    let position: CLLocation?
    var caption: String?
    var tags = [PhotoTag]()
    
    init (image: UIImage, position: CLLocation?) {
        self.position = position
        self.image = image
        self.createdAt = NSDate()
    }
    
    var coordinate: CLLocationCoordinate2D {
        get {
            if let position = self.position {
                return position.coordinate
            } else {
                return kCLLocationCoordinate2DInvalid
            }
        }
    }
    
    var title: String! {
        get {
            if let caption = self.caption {
                return caption
            } else {
                return ""
            }
        }
    }
}
