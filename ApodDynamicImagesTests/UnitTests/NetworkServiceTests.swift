import Foundation
import XCTest
import Combine
@testable import ApodDynamicImages

class NetworkServiceTests: XCTestCase {

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: config)
    }()
    private lazy var networkService = NetworkService(session: session)
    private let resource = Resource<ResponseModel>.setRequest(date: "2022-01-19")
    private lazy var apodDetailsJsonData: Data = {
        let url = Bundle(for: NetworkServiceTests.self).url(forResource: "APODDetails", withExtension: "json")
        guard let resourceUrl = url, let data = try? Data(contentsOf: resourceUrl) else {
            XCTFail("Failed to create data object from string!")
            return Data()
        }
        return data
    }()
    private var cancellables: [AnyCancellable] = []

    override class func setUp() {
        URLProtocol.registerClass(URLProtocolMock.self)
    }

    func test_loadFinishedSuccessfully() {
        // Given
        var result: Result<ResponseModel, Error>?
        let expectation = self.expectation(description: "networkServiceExpectation")
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: self.resource.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, self.apodDetailsJsonData)
        }

        // When
        networkService.load(resource)
            .map({ dataResult -> Result<ResponseModel, Error> in Result.success(dataResult)})
            .catch({ error -> AnyPublisher<Result<ResponseModel, Error>, Never> in .just(.failure(error)) })
            .sink(receiveValue: { value in
                result = value
                expectation.fulfill()
        }).store(in: &cancellables)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        guard case .success(let dataSet) = result else {
            XCTFail()
            return
        }
        XCTAssertEqual(dataSet.media_type, "image")
    }

    func test_loadFailedWithInternalError() {
        // Given
        var result: Result<ResponseModel, Error>?
        let expectation = self.expectation(description: "networkServiceExpectation")
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: self.resource.url, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }

        // When
        networkService.load(resource)
            .map({ dataSet -> Result<ResponseModel, Error> in Result.success(dataSet)})
            .catch({ error -> AnyPublisher<Result<ResponseModel, Error>, Never> in .just(.failure(error)) })
            .sink(receiveValue: { value in
                result = value
                expectation.fulfill()
            }).store(in: &cancellables)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        guard case .failure(let error) = result,
            let networkError = error as? NetworkError,
            case NetworkError.dataLoadingError(500, _) = networkError else {
            XCTFail()
            return
        }
    }

    func test_loadFailedWithJsonParsingError() {
        // Given
        var result: Result<ResponseModel, Error>?
        let expectation = self.expectation(description: "networkServiceExpectation")
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: self.resource.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }

        // When
        networkService.load(resource)
            .map({ dataSet -> Result<ResponseModel, Error> in Result.success(dataSet)})
            .catch({ error -> AnyPublisher<Result<ResponseModel, Error>, Never> in .just(.failure(error)) })
            .sink(receiveValue: { value in
                result = value
                expectation.fulfill()
            }).store(in: &cancellables)

        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        guard case .failure(let error) = result, error is DecodingError else {
            XCTFail()
            return
        }
    }
}
