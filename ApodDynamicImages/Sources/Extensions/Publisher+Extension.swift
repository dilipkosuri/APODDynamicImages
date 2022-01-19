import Foundation
import Combine

enum UserDefaultsKeys : String {
    case ResponseData
}

extension Publisher {
   func flatMapLatest<T: Publisher>(_ transform: @escaping (Self.Output) -> T) -> Publishers.SwitchToLatest<T, Publishers.Map<Self, T>> where T.Failure == Self.Failure {
        map(transform).switchToLatest()
    }
}

extension Publisher {

    static func empty() -> AnyPublisher<Output, Failure> {
        return Empty().eraseToAnyPublisher()
    }

    static func just(_ output: Output) -> AnyPublisher<Output, Failure> {
        return Just(output)
            .catch { _ in AnyPublisher<Output, Failure>.empty() }
            .eraseToAnyPublisher()
    }

    static func fail(_ error: Failure) -> AnyPublisher<Output, Failure> {
        return Fail(error: error).eraseToAnyPublisher()
    }
}

extension UserDefaults{
    
    //MARK: Save User Data
    func setUserData(value: Data){
        set(value, forKey: UserDefaultsKeys.ResponseData.rawValue)
    }

    //MARK: Retrieve User Data
    func getUserData() -> Data {
        return data(forKey: UserDefaultsKeys.ResponseData.rawValue) ?? Data()
    }
}
