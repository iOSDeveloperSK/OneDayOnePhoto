import UIKit

class PhotoCell: UICollectionViewCell {
    let imageView: UIImageView
    
    override init(frame: CGRect) {
        self.imageView = UIImageView()
        super.init(frame: frame)
        self.imageView.frame = self.bounds
        self.contentView.addSubview(self.imageView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renderPhoto(photo: Photo) {
        self.imageView.image = photo.image
    }
}
