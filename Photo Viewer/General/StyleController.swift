import UIKit
import KVNProgress

class StyleController {

    private init(){}

    public static func initialize() {
        let styleController = StyleController()
        styleController.configureNavigationBar()
        styleController.configureKVNProgress()
    }

    private func configureNavigationBar() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.tintColor = .main
        navigationBar.barTintColor = .white
        navigationBar.prefersLargeTitles = true
    }

    private func configureKVNProgress() {
        let config = KVNProgressConfiguration.init()
        config.backgroundTintColor = .background
        config.circleStrokeForegroundColor = .text
        config.successColor = .text
        config.statusColor = .text
        config.errorColor = .text
        config.isFullScreen = true
        KVNProgress.setConfiguration(config)
    }
}
