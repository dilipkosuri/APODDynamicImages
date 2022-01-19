import Foundation
import Combine
import UIKit.UIImage

protocol APODDetailsUseCaseType: AutoMockable {
    /// Fetches details for apod with specified date
    func apodDetails(selectedDate: String) -> AnyPublisher<Result<ResponseModel, Error>, Never>
    // Loads the image for a specific response model
    func loadImage(for responseModel: ResponseModel) -> AnyPublisher<UIImage?, Never>
}

final class APODDetailsUseCase: APODDetailsUseCaseType {
    private let networkService: NetworkServiceType
    private let imageLoaderService: ImageLoaderServiceType
    private var sut: Cache<ResponseModel, String>!
    
    init(networkService: NetworkServiceType, imageLoaderService: ImageLoaderServiceType) {
        self.networkService = networkService
        self.imageLoaderService = imageLoaderService
    }
    
    func apodDetails(selectedDate: String = "") -> AnyPublisher<Result<ResponseModel, Error>, Never> {
        return networkService
            .load(Resource<ResponseModel>.setRequest(date: selectedDate))
            .map ({ result in
                return .success(result)
            })
            .catch { error -> AnyPublisher<Result<ResponseModel, Error>, Never> in
            .just(.failure(error))
            }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func loadImage(for responseModel: ResponseModel) -> AnyPublisher<UIImage?, Never> {
        return Deferred { return Just(responseModel.url) }
        .flatMap({[unowned self] imageURL -> AnyPublisher<UIImage?, Never> in
            guard let imageURL = responseModel.url else { return .just(nil) }
            guard let url = URL(string: imageURL) else { return .just(nil)}
            return self.imageLoaderService.loadImage(from: url)
        })
        .subscribe(on: Scheduler.backgroundWorkScheduler)
        .receive(on: Scheduler.mainScheduler)
        .share()
        .eraseToAnyPublisher()
    }
}
