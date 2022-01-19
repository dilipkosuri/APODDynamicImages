import Foundation

class OtherUtils {
    func formatDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func formatDate(dateString: String, formatted display: Bool = false, from picker: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        if picker {
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }
        
        guard let date = dateFormatter.date(from: dateString) else {
            return ""
        }
        // set the date format according to display
        !display ? (dateFormatter.dateFormat = "yyyy-MM-dd") : (dateFormatter.dateFormat = "EEEE, MMM d, yyyy")
         return "\(dateFormatter.string(from: date))"
    }
}
