import UIKit

/// The `ApplicationFlowCoordinatorDependencyProvider` protocol defines methods to satisfy external dependencies of the ApplicationFlowCoordinator
protocol ApplicationFlowCoordinatorDependencyProvider: APODDetailsFlowCoordinatorDependencyProvider {}

protocol APODDetailsFlowCoordinatorDependencyProvider: class {
    // Creates UIViewController to show the details of the apod with specific date
    func apodDetailsController(selectedDate: String, navigator: APODDetailsNavigator) -> UINavigationController
    
    func apodDetailsVC(selectedDate: String, navigator: APODDetailsNavigator) -> UIViewController
}
