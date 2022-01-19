import Foundation

extension Resource {

    static func setRequest(date: String = "") -> Resource<ResponseModel> {
        let url = ApiConstants.baseUrl
        var parameters: [String : CustomStringConvertible] = [
            "api_key": ApiConstants.apiKey,
            "concept_tags": "True"
            ]
        
        if !date.isEmpty {
            parameters["date"] = date
        }
        
        return Resource<ResponseModel>(url: url, parameters: parameters)
    }
}

