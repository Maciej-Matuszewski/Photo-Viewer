import Foundation
import RxSwift

class APIClient {
    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func send<T: Codable, E: Codable & ErrorModel>(apiRequest: APIRequest, ErrorModelType: E.Type) -> Observable<T> {
        return Observable<T>.create { [unowned self] observer in
            let request = apiRequest.request(with: self.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

                if let error = error {
                    observer.onError(error)
                    observer.onCompleted()
                    return
                }

                guard let data = data else {
                    observer.onError(APIError.MissingData)
                    observer.onCompleted()
                    return
                }

                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(model)
                } catch _ {
                    do {
                        let errorModel: E = try JSONDecoder().decode(E.self, from: data)
                        observer.onError(APIError.ResponseError(errorModel))
                    } catch _ {
                        observer.onError(APIError.ErrorModelDecodeError)
                    }
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

enum APIError: Error {
    case MissingData
    case ResponseError(ErrorModel)
    case ErrorModelDecodeError
}
