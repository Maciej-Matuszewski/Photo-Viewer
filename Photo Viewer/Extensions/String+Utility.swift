import Foundation
import UIKit

extension String {
    
    /// Variable that returns localized version of delivered string
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    ///Check that string is valid with delivered pattern
    ///
    /// - Parameter pattern: (String) Regular expression pattern
    /// - Returns: (Bool) Information that string is valid
    func isValid(withPattern pattern: String) -> Bool {
        do{
            let regEx = try NSRegularExpression.init(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let regExMaches = regEx.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange.init(location: 0, length: count))
            if(regExMaches > 0){return true}
        }catch _{
            return false
        }
        return false
    }
}
