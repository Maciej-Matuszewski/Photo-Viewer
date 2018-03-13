import UIKit

extension UIFont {
    
    /// Normal font used in application
    static let body = UIFont.preferredFont(forTextStyle: .body)

    /// Font with size of normal font, but bolded
    static let title = UIFont.preferredFont(forTextStyle: .title1)

    /// Font bigger than normal
    static let button = UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)

    /// Font with size of big font, but bolded
    static let header = UIFont.preferredFont(forTextStyle: .headline)
}
