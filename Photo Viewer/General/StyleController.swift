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
    }
}
