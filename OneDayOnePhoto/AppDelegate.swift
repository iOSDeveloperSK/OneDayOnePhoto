import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.makeKeyAndVisible()
        let photoGridVC = PhotoGridViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let navVC = UINavigationController(rootViewController: photoGridVC)
        self.window?.rootViewController = navVC
        
        return true
    }

}
