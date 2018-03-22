import UIKit

class FlowController {
    private let window: UIWindow
    public static let shared = FlowController()

    public let providers: [PhotosProvider] = {
        return [PinterestProvider(), GiphyProvider()]
    }()

    private init() {
        window = UIWindow(frame: UIScreen.main.bounds)
    }

    public func loadHomeController() {
        let authenticatedProviders = providers.filter { $0.isAuthorized }
        if !authenticatedProviders.isEmpty {
            let tabBarController = UITabBarController()
            tabBarController.setViewControllers(
                providers.map { provider in
                    let navigationController = UINavigationController(rootViewController: HomeViewController(provider: provider))
                    navigationController.tabBarItem.title = provider.serviceName
                    navigationController.tabBarItem.image = provider.logoImage
                    return navigationController
                },
                animated: true
            )
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        } else {
            guard let firstProvider = providers.first else {
                fatalError("App can not works without photo provider!")
            }

            let navigationController = UINavigationController(rootViewController: OnboardingViewController(provider: firstProvider))
            navigationController.isNavigationBarHidden = true
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
}
