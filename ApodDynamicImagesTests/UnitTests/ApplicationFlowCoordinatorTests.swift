import Foundation
import XCTest
@testable import ApodDynamicImages

class ApplicationFlowCoordinatorTests: XCTestCase {

    private lazy var flowCoordinator = ApplicationFlowCoordinator(window: window, dependencyProvider: dependencyProvider)
    private let window =  UIWindow()
    private let dependencyProvider = ApplicationFlowCoordinatorDependencyProviderMock()

    /// Test that application flow is started correctly
    func test_startsApplicationsFlow() {
        // GIVEN
        let rootViewController = UINavigationController()
        dependencyProvider.apodDetailsControllerReturnValue = rootViewController

        // WHEN
        flowCoordinator.start()

        // THEN
        XCTAssertEqual(window.rootViewController, rootViewController)
    }
}
