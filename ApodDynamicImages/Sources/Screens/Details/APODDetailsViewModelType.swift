import UIKit
import Combine

// INPUT
struct APODDetailsViewModelInput {
    /// called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>
    
    /// called when the user chooses a date
    let update: AnyPublisher<String, Never>
}

// OUTPUT
enum APODDetailsState {
    case loading
    case success(DetailsViewModel)
    case failure(Error)
}

extension APODDetailsState: Equatable {
    static func == (lhs: APODDetailsState, rhs: APODDetailsState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.success(let lhsDetails), .success(let rhsDetails)): return lhsDetails == rhsDetails
        case (.failure, .failure): return true
        default: return false
        }
    }
}

typealias APODDetailsViewModelOutput = AnyPublisher<APODDetailsState, Never>

protocol APODDetailsViewModelType: AnyObject {
    func transform(input: APODDetailsViewModelInput) -> APODDetailsViewModelOutput
}
