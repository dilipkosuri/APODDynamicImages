import XCTest

class APODDetailsPage: Page {
    
    override func verify() {
        assertVisible(AccessibilityIdentifiers.APODDetails.rootViewId)
    }
}

// MARK: Assertions
extension APODDetailsPage {
    
    @discardableResult
    func assertTitle(_ text: String) -> Self {
        return assertLabelText(AccessibilityIdentifiers.APODDetails.titleLabelId, text)
    }
    
    @discardableResult
    func assertSubtitle(_ text: String) -> Self {
        return assertLabelText(AccessibilityIdentifiers.APODDetails.subtitleLabelId, text)
    }
    
    @discardableResult
    func assertDescription(_ text: String) -> Self {
        return assertLabelText(AccessibilityIdentifiers.APODDetails.descriptionLabelId, text)
    }
    
    @discardableResult
    func assertContentIsHidden() -> Self {
        return assertHidden(AccessibilityIdentifiers.APODDetails.contentViewId)
    }
    
    @discardableResult
    func assertLoadingIndicatorIsVisible() -> Self {
        return assertVisible(AccessibilityIdentifiers.APODDetails.loadingIndicatorId)
    }
    
    @discardableResult
    func assertLoadingIndicatorIsHidden() -> Self {
        return assertHidden(AccessibilityIdentifiers.APODDetails.loadingIndicatorId)
    }

}

