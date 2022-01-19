import UIKit

/// The ApplicationComponentsFactory takes responsibity of creating application components and establishing dependencies between them.
final class ApplicationComponentsFactory {
    fileprivate lazy var useCase: APODDetailsUseCaseType = APODDetailsUseCase(networkService: servicesProvider.network, imageLoaderService: servicesProvider.imageLoader)

    private let servicesProvider: ServicesProvider

    init(servicesProvider: ServicesProvider = ServicesProvider.defaultProvider()) {
        self.servicesProvider = servicesProvider
    }
}

extension ApplicationComponentsFactory: ApplicationFlowCoordinatorDependencyProvider {
    func apodDetailsController(selectedDate: String, navigator: APODDetailsNavigator) -> UINavigationController {
        let viewModel = APODDetailsViewModel(useCase: useCase, selectedDate: selectedDate, navigator: navigator)
        let apodDetailsVC = APODDetailsVC(viewModel: viewModel)
        let apodDetailsNavigationController = UINavigationController(rootViewController: apodDetailsVC)
        return apodDetailsNavigationController
    }
    
    func apodDetailsVC(selectedDate: String, navigator: APODDetailsNavigator) -> UIViewController {
        let viewModel = APODDetailsViewModel(useCase: useCase, selectedDate: selectedDate, navigator: navigator)
        let apodDetailsVC = APODDetailsVC(viewModel: viewModel)
        return apodDetailsVC
    }
}
