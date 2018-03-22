import Foundation

protocol ErrorHandler {
    func handleError(code: Int) -> (message: String?, callback:(()->())?)
}
