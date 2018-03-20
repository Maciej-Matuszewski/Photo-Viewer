import UIKit

class FlowController {
    private let window: UIWindow
    public static let shared = FlowController()
    public let navigationController = UINavigationController()

    public let providers: [PhotosProvider] = {
        return [PinterestProvider()]
    }()

    private init() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    public func loadHomeController() {
        let authenticatedProviders = providers.filter { $0.isAuthorized }
        if !authenticatedProviders.isEmpty {
            navigationController.setNavigationBarHidden(false, animated: true)
            navigationController.setViewControllers([HomeViewController(providers: providers)], animated: true)
        } else {
            guard let firstProvider = providers.first else {
                fatalError("App can not works without photo provider!")
            }
            navigationController.setNavigationBarHidden(true, animated: true)
            navigationController.setViewControllers([OnboardingViewController(provider: firstProvider)], animated: true)
        }
    }
}
