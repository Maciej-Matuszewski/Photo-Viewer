import UIKit

extension UIAlertController {
    convenience init(okActionHandler handler: ((UIAlertAction) -> Void)?, title: String, message: String?) {
        self.init(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "Ok".localized, style: .default, handler: handler)
        self.addAction(alertAction)
    }
}
