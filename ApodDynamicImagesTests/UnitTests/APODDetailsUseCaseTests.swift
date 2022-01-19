import Foundation
import XCTest
import Combine
@testable import ApodDynamicImages

class APODDetailsUseCaseTests: XCTestCase {

    private let networkService = NetworkServiceTypeMock()
    private let imageLoaderService = ImageLoaderServiceTypeMock()
    private var useCase: APODDetailsUseCase!
    private var cancellables: [AnyCancellable] = []

    override func setUp() {
        useCase = APODDetailsUseCase(networkService: networkService,
                                imageLoaderService: imageLoaderService)
    }

    func test_loadsImageFromNetwork() {
        // Given
        let jsonResponse = ResponseModel.loadFromFile("APODDetails.json")
        let data = jsonResponse
        var result: UIImage?
        let expectation = self.expectation(description: "loadImage")
        imageLoaderService.loadImageFromReturnValue = .just(UIImage())

        // When
        useCase.loadImage(for: data).sink { value in
            result = value
            expectation.fulfill()
        }.store(in: &cancellables)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(result)
    }
}
