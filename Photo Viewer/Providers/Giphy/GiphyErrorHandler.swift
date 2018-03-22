import Foundation

class GiphyErrorHandler: ErrorHandler {
    func handleError(code: Int) -> (message: String?, callback:(()->())?) {
        switch code {
        default:
            return (message: "Something went wrong".localized, callback: nil)
        }
    }
}

