import Foundation

protocol APODDetailsNavigator: AutoMockable, AnyObject {
    /// Presents new content based on the date selected in APOD Details screen
    func showUpdatedDetails(for selected: String)
}
