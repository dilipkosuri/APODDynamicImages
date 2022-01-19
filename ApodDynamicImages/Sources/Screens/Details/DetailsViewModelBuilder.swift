import Foundation
import UIKit.UIImage
import Combine

struct DetailsViewModelBuilder {
    static func viewModel(from responseModel: ResponseModel, imageLoader: (ResponseModel) -> AnyPublisher<UIImage?, Never>) -> DetailsViewModel {
        return DetailsViewModel(id: responseModel.id,
                                title: responseModel.title ?? "",
                                date: responseModel.contentDate,
                                overview: responseModel.explanation ?? "",
                                poster: imageLoader(responseModel), imageInWebViewURL: responseModel.imageInWebViewURL)
    }
}

extension ResponseModel {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var contentDate: String {
        let formattedDate = OtherUtils().formatDate(dateString: date ?? "", formatted: true)
        return "\(formattedDate)"
    }
}
