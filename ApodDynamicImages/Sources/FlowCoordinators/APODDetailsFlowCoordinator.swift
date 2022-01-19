import UIKit

/// The `APODDetailsFlowCoordinator` takes control over the flows on the details screen showing image, date, explanation and video if not image
class APODDetailsFlowCoordinator: FlowCoordinator {
    fileprivate let window: UIWindow
    fileprivate var appNavigationController: UINavigationController?
    fileprivate let dependencyProvider: APODDetailsFlowCoordinatorDependencyProvider
    
    init(window: UIWindow, dependencyProvider: APODDetailsFlowCoordinatorDependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }
    
    func start() {
        let appNavigationController = dependencyProvider.apodDetailsController(selectedDate: "", navigator: self)
        window.rootViewController = appNavigationController
        self.appNavigationController = appNavigationController
    }
}

extension APODDetailsFlowCoordinator: APODDetailsNavigator {
    func showUpdatedDetails(for selected: String) {
        let controller = self.dependencyProvider.apodDetailsVC(selectedDate: selected, navigator: self)
        appNavigationController?.pushViewController(controller, animated: true)
    }
}
