import Foundation
import KeychainAccess

class PinterestErrorHandler: ErrorHandler {
    func handleError(code: Int) -> (message: String?, callback:(()->())?) {
        switch code {
        case 3:
            return (message: "Access token is not valid!".localized, callback: { [weak self] in
                self?.logout()
                FlowController.shared.loadHomeController()
            })
        default:
            return (message: "Something went wrong".localized, callback: nil)
        }
    }

    private func logout() {
        let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "")
        keychain["PinterestProviderToken"] = nil
    }
}
