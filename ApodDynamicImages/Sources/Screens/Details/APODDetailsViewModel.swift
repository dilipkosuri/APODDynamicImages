import UIKit
import Combine

class APODDetailsViewModel: APODDetailsViewModelType {

    private let useCase: APODDetailsUseCaseType
    private var selectedDate: String
    private weak var navigator: APODDetailsNavigator?
    private var cancellables: [AnyCancellable] = []

    init(useCase: APODDetailsUseCaseType, selectedDate: String = "", navigator: APODDetailsNavigator) {
        self.useCase = useCase
        self.selectedDate = selectedDate
        self.navigator = navigator
    }

    func transform(input: APODDetailsViewModelInput) -> APODDetailsViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
       let apodDetails = input.appear
            .flatMap({[unowned self] _ in self.useCase.apodDetails(selectedDate: selectedDate) })
            .map({ result -> APODDetailsState in
                switch result {
                    case .success(let responseModel): return .success(self.viewModel(from: responseModel))
                    case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        
        input.update
            .sink(receiveValue: { [unowned self] selectedDate in self.navigator?.showUpdatedDetails(for: selectedDate) })
            .store(in: &cancellables)
        
        let loading: APODDetailsViewModelOutput = input.appear.map({_ in .loading }).eraseToAnyPublisher()
        return Publishers.Merge(loading, apodDetails).removeDuplicates().eraseToAnyPublisher()
    }

    private func viewModel(from responseModel: ResponseModel) -> DetailsViewModel {
        return DetailsViewModelBuilder.viewModel(from: responseModel, imageLoader: {[unowned self] responseModel in
            
            self.useCase.loadImage(for: responseModel) })
    }
}
