import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        baseConfiguration()
        configureProperties()
        configureLayout()
        configureReactiveBinding()
    }

    internal func baseConfiguration(){
        view.backgroundColor = .background
    }

    internal func configureProperties() {
        #if DEBUG
        fatalError("`configureProperties()` has not been implemented in \(self)")
        #endif
    }

    internal func configureLayout() {
        #if DEBUG
        fatalError("`configureLayout()` has not been implemented in \(self)")
        #endif
    }

    internal func configureReactiveBinding() {
        #if DEBUG
        fatalError("`configureReactiveBinding()` has not been implemented in \(self)")
        #endif
    }
}
