import UIKit
import SafariServices
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        StyleController.initialize()
        FlowController.shared.loadHomeController()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let result = PinterestProvider.handle(url)
        if result {
            if let safariViewController = (app.keyWindow?.rootViewController as? UINavigationController)?.visibleViewController as? SFSafariViewController {
                safariViewController.dismiss(animated: true, completion: nil)
            }
        }
        return result
    }

    //TO-DO: This method should be removed,
    //however it can be helpful during project review.
    func logout(){
        let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "")
        keychain["PinterestProviderToken"] = nil
        UserDefaults.standard.removeObject(forKey: "GiphyAuthStatus")
        UserDefaults.standard.synchronize()
    }
}

