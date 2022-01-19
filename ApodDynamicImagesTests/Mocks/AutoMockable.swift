import Foundation
import XCTest
import Combine
@testable import ApodDynamicImages

class ImageLoaderServiceTypeMock: ImageLoaderServiceType {

    //MARK: - loadImage

    var loadImageFromCallsCount = 0
    var loadImageFromCalled: Bool {
        return loadImageFromCallsCount > 0
    }
    var loadImageFromReceivedUrl: URL?
    var loadImageFromReceivedInvocations: [URL] = []
    var loadImageFromReturnValue: AnyPublisher<UIImage?, Never>!
    var loadImageFromClosure: ((URL) -> AnyPublisher<UIImage?, Never>)?

    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        loadImageFromCallsCount += 1
        loadImageFromReceivedUrl = url
        loadImageFromReceivedInvocations.append(url)
        return loadImageFromClosure.map({ $0(url) }) ?? loadImageFromReturnValue
    }
}

class APODDetailsUseCaseTypeMock: APODDetailsUseCaseType {
    //MARK: - ApodDetails
    var apodDetailsWithReceivedInvocations: [Int] = []
    var apodDetailsWithReturnValue: AnyPublisher<Result<ResponseModel, Error>, Never>!
    var apodDetailsWithClosure: ((Int) -> AnyPublisher<Result<ResponseModel, Error>, Never>)?
    
    func apodDetails(selectedDate: String) -> AnyPublisher<Result<ResponseModel, Error>, Never> {
        return apodDetailsWithClosure.map({ $0(121) }) ?? apodDetailsWithReturnValue
    }

    //MARK: - loadImage

    var loadImageForSizeCallsCount = 0
    var loadImageForSizeCalled: Bool {
        return loadImageForSizeCallsCount > 0
    }
    
    var loadImageForSizeReceivedArguments: (ResponseModel)?
    var loadImageForSizeReceivedInvocations: [(ResponseModel)] = []
    var loadImageForSizeReturnValue: AnyPublisher<UIImage?, Never>!
    var loadImageForSizeClosure: ((ResponseModel) -> AnyPublisher<UIImage?, Never>)?

    func loadImage(for responseModel: ResponseModel) -> AnyPublisher<UIImage?, Never> {
        loadImageForSizeCallsCount += 1
        return loadImageForSizeClosure.map({ $0(responseModel) }) ?? loadImageForSizeReturnValue
    }
}

class NetworkServiceTypeMock: NetworkServiceType {

    var loadCallsCount = 0
    var loadCalled: Bool {
        return loadCallsCount > 0
    }
    var responses = [String:Any]()

    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {
        if let response = responses[resource.url.path] as? T {
            return .just(response)
        } else if let error = responses[resource.url.path] as? NetworkError {
            return .fail(error)
        } else {
            return .fail(NetworkError.invalidRequest)
        }
    }
}

class ApplicationFlowCoordinatorDependencyProviderMock: ApplicationFlowCoordinatorDependencyProvider {
    
    var apodDetailsNavigationControllerReturnValue: UINavigationController?
    func apodDetailsController(selectedDate: String, navigator: APODDetailsNavigator) -> UINavigationController {
        return apodDetailsNavigationControllerReturnValue!
    }
    
    var apodDetailsControllerReturnValue: UIViewController?
    func apodDetailsVC(selectedDate: String, navigator: APODDetailsNavigator) -> UIViewController {
        return apodDetailsControllerReturnValue!
    }
}
