import UIKit
import CoreLocation

class PhotoStorage {
    var photos = [Photo]()
    
    init () {
// TODO: remove loading of demo data
        self.loadDemoData()
    }
    
    func loadDemoData () {
        for i in 1...30 {
            let location = CLLocation(latitude: 55.755611, longitude: 37.617298)
            let photo = Photo(image: UIImage(named: "cell.jpg")!, position: location)
            photo.caption = "Moscow castle in night"
            photo.tags = [PhotoTag(text: "moscow"), PhotoTag(text: "russia"), PhotoTag(text: "night")]
            self.photos.append(photo)
        }
    }
}