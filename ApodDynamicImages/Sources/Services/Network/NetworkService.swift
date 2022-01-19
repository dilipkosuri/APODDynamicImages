import Foundation
import Combine

final class NetworkService: NetworkServiceType {
    private let session: URLSession
    typealias ShortOutput = URLSession.DataTaskPublisher.Output

    init(session: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)) {
        self.session = session
    }

    @discardableResult
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {
        guard let request = resource.request else {
             return .fail(NetworkError.invalidRequest)
        }
                
        return session.dataTaskPublisher(for: request)
            .mapError { _ in NetworkError.invalidRequest }
            .print()
            .flatMap { data, response -> AnyPublisher<Data, Error> in
                guard let response = response as? HTTPURLResponse else {
                    return .fail(NetworkError.invalidResponse)
                }
                guard 200..<500 ~= response.statusCode else {
                     return .fail(NetworkError.dataLoadingError(statusCode: response.statusCode, data: data))
                }
                UserDefaults.standard.setUserData(value: data)
                return .just(data)
            }
            .decode(type: T.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
    
    func dataTaskPublisher(for urlRequest: URLRequest,
                           cachedResponseOnError: Bool) -> AnyPublisher<ShortOutput, Error> {
        return session.dataTaskPublisher(for: urlRequest)
            .tryCatch { [weak self] (error) -> AnyPublisher<ShortOutput, Never> in
                guard cachedResponseOnError,
                      let urlCache = self?.session.configuration.urlCache,
                    let cachedResponse = urlCache.cachedResponse(for: urlRequest) else {

                    throw error
                }

                return Just(ShortOutput(
                    data: cachedResponse.data,
                    response: cachedResponse.response
                )).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }

}
