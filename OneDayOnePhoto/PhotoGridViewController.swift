import UIKit

class PhotoGridViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NewPhotoViewControllerDelegate {
    let photoStorage = PhotoStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.registerClass(PhotoCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.setupNewPhotoButton()
    }
    
    func setupNewPhotoButton () {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "newPhotoButtonPressed")
    }
    
    func newPhotoButtonPressed () {
        let newPhotoVC = NewPhotoViewController()
        newPhotoVC.photoDelegate = self
        self.navigationController?.pushViewController(newPhotoVC, animated: true)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoStorage.photos.count
    }
    
// MARK: -
// MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let photo = self.photoStorage.photos[indexPath.row]
        let photoDetailVC = PhotoDetailViewController(photo: photo)
        self.navigationController?.pushViewController(photoDetailVC, animated: true)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as PhotoCell
        let photo = self.photoStorage.photos[indexPath.row]
        cell.renderPhoto(photo)
        
        return cell
    }

// MARK: -
// MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
// MARK: -
// MARK: NewPhotoViewControllerDelegate
    
    func newPhotoViewControllerDidPreparePhoto(viewController: NewPhotoViewController, photo: Photo) {
        self.photoStorage.photos.insert(photo, atIndex: 0)
        self.navigationController?.popViewControllerAnimated(true)
        self.collectionView.reloadData()
    }
    
}
