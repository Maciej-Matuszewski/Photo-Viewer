import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        baseConfiguration()
        configureProperties()
        configureLayout()
        configureReactiveBinding()
        configureNavigationController()
    }

    private func baseConfiguration(){
        view.backgroundColor = .background
    }

    internal func configureProperties() {
        fatalError("`configureProperties()` has not been implemented in \(self)")
    }

    internal func configureLayout() {
        fatalError("`configureLayout()` has not been implemented in \(self)")
    }

    internal func configureReactiveBinding() {
        fatalError("`configureReactiveBinding()` has not been implemented in \(self)")
    }

    internal func configureNavigationController() {
        fatalError("`configureNavigationController()` has not been implemented in \(self)")
    }
}
