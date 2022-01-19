import Foundation
import UIKit.UIImage
import Combine

struct DetailsViewModel {
    let id: Int
    let title: String
    let date: String
    let overview: String
    let poster: AnyPublisher<UIImage?, Never>
    let imageInWebViewURL: URL?

    init(id: Int, title: String, date: String, overview: String, poster: AnyPublisher<UIImage?, Never>, imageInWebViewURL: URL?) {
        self.id = id
        self.title = title
        self.date = date
        self.overview = overview
        self.poster = poster
        self.imageInWebViewURL = imageInWebViewURL
    }
}

extension DetailsViewModel: Hashable {
    static func == (lhs: DetailsViewModel, rhs: DetailsViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }
}
