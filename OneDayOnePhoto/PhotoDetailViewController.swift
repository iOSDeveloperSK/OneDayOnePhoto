import UIKit
import CoreLocation
import MapKit

class PhotoDetailViewController: UIViewController {
    let photo: Photo
    let titleLabel = UILabel()
    let imageView = UIImageView()
    let dateLabel = UILabel()
    let tagsLabel = UILabel()
    let mapView = MKMapView()
    
    init (photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        if self.photo.position != nil {
            self.setupSegmentedControl()
        }
        self.setupImageView()
        self.setupMapView()
        self.setupTitleLabel()
        self.setupDateLabel()
        self.setupTagsLabel()
    }
    
    func setupImageView () {
        self.imageView.image = self.photo.image
        self.imageView.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.width)
        self.view.addSubview(self.imageView)
    }
    
    func setupMapView () {
        self.mapView.frame = self.imageView.frame
        self.mapView.hidden = true
        self.mapView.alpha = 0
        self.view.addSubview(self.mapView)
        
        if let coordinate = self.photo.position?.coordinate {
            self.mapView.setCenterCoordinate(coordinate, animated: false)
            let region = MKCoordinateRegionMake(self.photo.coordinate, MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            self.mapView.setRegion(region, animated: false)
            self.mapView.addAnnotation(self.photo)
        }
    }
    
    func setupTitleLabel () {
        self.titleLabel.frame = CGRect(x: 0, y: (self.imageView.frame.origin.y + self.imageView.frame.size.height), width: self.view.frame.size.width, height: 25)
        self.view.addSubview(self.titleLabel)
        self.titleLabel.text = self.photo.caption
    }

    func setupDateLabel () {
        self.dateLabel.frame = CGRect(x: 0, y: (self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height), width: self.view.frame.size.width, height: 30)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "sk_SK")
        let createdAt = dateFormatter.stringFromDate(self.photo.createdAt)
        self.dateLabel.text = "Uploaded at: \(createdAt)"
        self.dateLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.dateLabel)
    }
    
    func setupTagsLabel () {
        self.tagsLabel.frame = CGRect(x: 0, y: (dateLabel.frame.origin.y + dateLabel.frame.size.height), width: self.view.frame.size.width, height: 40)
        var tags = ""
        for tag in self.photo.tags {
            tags += "\(tag.text), "
        }
        self.tagsLabel.text = tags
        self.view.addSubview(self.tagsLabel)
    }
    
    func setupSegmentedControl () {
        let segmentedControl = UISegmentedControl(items: ["Image", "Map"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: "segmentedControlChanged", forControlEvents: .ValueChanged)
        self.navigationItem.titleView = segmentedControl
    }
    
    func segmentedControlChanged () {
        if self.imageView.hidden {
            
            self.imageView.hidden = false
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.imageView.alpha = 1
                self.mapView.alpha = 0
            }, completion: { (completed) -> Void in
                self.mapView.hidden = true
            })
            
        } else {
            
            self.mapView.hidden = false
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.imageView.alpha = 0
                self.mapView.alpha = 1
            }, completion: { (completed) -> Void in
                self.imageView.hidden = true
            })

        }
    }
}