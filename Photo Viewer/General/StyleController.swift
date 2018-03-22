import UIKit

class StyleController {
    private init(){}

    public static func initialize() {
        let styleController = StyleController()
        styleController.configureNavigationBar()
    }

    private func configureNavigationBar() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.tintColor = .main
        navigationBar.barTintColor = .white
        navigationBar.prefersLargeTitles = true
        navigationBar.isTranslucent = false
    }
    private func configureTabBar() {
        let tabBar = UITabBar.appearance()
        tabBar.tintColor = .main
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
    }
}
