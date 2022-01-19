import Foundation
import Combine
@testable import ApodDynamicImages

class NetworkServiceTypeMock: NetworkServiceType {

    var responses = [String:Any]()

    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> where T : Decodable {
        if let response = responses[resource.url.path] as? T {
            return .just(response)
        } else if let error = responses[resource.url.path] as? NetworkError {
            return .fail(error)
        } else {
            return .fail(NetworkError.invalidRequest)
        }
    }
}
