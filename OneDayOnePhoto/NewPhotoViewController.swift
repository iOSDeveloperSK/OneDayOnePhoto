import UIKit
import Foundation
import Photos
import CoreLocation

protocol NewPhotoViewControllerDelegate {
    func newPhotoViewControllerDidPreparePhoto(viewController: NewPhotoViewController, photo: Photo)
}

class NewPhotoViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    let imageView = UIImageView()
    let captionTextField = UITextField()
    let submitButton = UIButton()
    var photoDelegate: NewPhotoViewControllerDelegate?
    var location: CLLocation?
    let locationManager = CLLocationManager()
    
    override func loadView() {
        self.view = UIScrollView(frame: UIScreen.mainScreen().bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Add New Photo"
        
        self.setupKeyboardNotifications()
        self.setupImageView()
        self.setupCaptionTextField()
        self.setupGalleryButton()
        self.setupCameraButton()
        self.setupSubmitButton()
        self.setupTagsButton()
        self.setupScrollViewContentSize()
    }
    
// MARK: Keyboard Handling
    
    func setupKeyboardNotifications () {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardDidShow (notification: NSNotification) {
        let keyboardFrameValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        let keyboardFrameRect = keyboardFrameValue?.CGRectValue()
        if let keyboardHeight = keyboardFrameRect?.size.height {
            let scrollView = self.view as UIScrollView
            scrollView.frame.size.height = UIScreen.mainScreen().bounds.size.height - keyboardHeight
            let yOffset = scrollView.contentSize.height - scrollView.bounds.size.height
            let contentOffset = CGPoint(x: 0, y: yOffset)
//            scrollView.setContentOffset(contentOffset, animated: true)
//            scrollView.scrollRectToVisible(CGRect(x: 0, y: yOffset, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height), animated: true)
        }
    }
    
    func keyboardWillHide (notification: NSNotification) {
        let scrollView = self.view as UIScrollView
        scrollView.frame = UIScreen.mainScreen().bounds
    }
    
// MARK: UI Setup
    
    func setupScrollViewContentSize () {
        let scrollView = self.view as UIScrollView
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: self.submitButton.bottom)
    }
    
    func setupTagsButton () {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tags", style: UIBarButtonItemStyle.Plain, target: self, action: "tagsButtonPressed:")
    }
    
    func setupImageView () {
        self.imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        self.imageView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        self.view.addSubview(self.imageView)
    }
    
    func setupCaptionTextField () {
        self.captionTextField.returnKeyType = UIReturnKeyType.Done
        self.captionTextField.frame = CGRect(x: 10, y: self.imageView.bottom + 5, width: (self.view.frame.size.width - 20), height: 44)
        self.captionTextField.placeholder = "Photo Caption"
        self.captionTextField.borderStyle = UITextBorderStyle.RoundedRect
        self.captionTextField.delegate = self
        self.view.addSubview(self.captionTextField)
    }
    
    func setupGalleryButton () {
        let galleryButton = UIButton(frame: CGRect(x: 10, y: self.captionTextField.bottom + 5, width: ((self.view.frame.size.width / 2) - 15), height: 44))
        galleryButton.backgroundColor = UIColor.blueColor()
        galleryButton.setTitle("Gallery", forState: .Normal)
        galleryButton.addTarget(self, action: "galleryButtonPressed", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(galleryButton)
    }
    
    func setupCameraButton () {
        let cameraButton = UIButton(frame: CGRect(x: ((self.view.frame.size.width / 2) + 5), y: self.captionTextField.bottom + 5, width: ((self.view.frame.size.width / 2) - 15), height: 44))
        cameraButton.backgroundColor = UIColor.blueColor()
        cameraButton.setTitle("Camera", forState: .Normal)
        cameraButton.addTarget(self, action: "cameraButtonPressed", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(cameraButton)
    }
    
    func setupSubmitButton () {
        self.submitButton.frame = CGRect(x: 10, y: self.imageView.bottom + 110, width: (self.view.frame.size.width - 20), height: 44)
        self.submitButton.backgroundColor = UIColor.grayColor()
        self.submitButton.setTitle("Save Photo", forState: .Normal)
        self.submitButton.addTarget(self, action: "submitButtonPressed", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.submitButton)
    }
    
// MARK: User Interaction
    
    func tagsButtonPressed (sender: AnyObject?) {
        let tagsVC = TagsViewController()
        tagsVC.tags = [PhotoTag(text: "nature"), PhotoTag(text: "night")]
        self.navigationController?.pushViewController(tagsVC, animated: true)
    }
    
    func showGallery () {
        let vc = UIImagePickerController()
        vc.delegate = self
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func galleryButtonPressed () {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            self.locationManager.delegate = self
            self.locationManager.requestAlwaysAuthorization()
        } else {
            self.showGallery()
        }
    }
    
    func cameraButtonPressed () {
        let vc = UIImagePickerController()
        vc.sourceType = UIImagePickerControllerSourceType.Camera
        vc.delegate = self
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func submitButtonPressed () {
        if let image = self.imageView.image {
            let caption = self.captionTextField.text
            let photo = Photo(image: image, position: self.location)
            photo.caption = caption
            
            self.photoDelegate?.newPhotoViewControllerDidPreparePhoto(self, photo: photo)
        } else {
            let alert = UIAlertController(title: "Notice", message: "Please, choose a photo from gallery.", preferredStyle: UIAlertControllerStyle.Alert)

            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(okAction)
            
            let chooseAction = UIAlertAction(title: "Choose...", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                self.galleryButtonPressed()
            })
            alert.addAction(chooseAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

// MARK: UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let captionTextLength = countElements(textField.text)
        let stringLength = countElements(string)
        
        if (captionTextLength + stringLength <= 50) {
            return true
        }
        
        return false
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
    
// MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if picker.sourceType == UIImagePickerControllerSourceType.Camera {
            self.location = self.locationManager.location
        } else {
            if let assetURL = info[UIImagePickerControllerReferenceURL] as? NSURL {
                if let fetchResult = PHAsset.fetchAssetsWithALAssetURLs([assetURL], options: nil) {
                    let assetsCount = fetchResult.count
                    if let firstAsset = fetchResult.firstObject as? PHAsset {
                        NSLog("\(firstAsset.location)")
                    }
                }
            }
        }
        
        self.imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }

// MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        self.showGallery()
    }
}