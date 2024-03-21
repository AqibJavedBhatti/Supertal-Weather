//
//  NetworkManager.swift
//  Supertal Weather
//
//  Created by Aqib Javed on 19/03/2024.
//

import Foundation

class NetworkManager {
    
    let apiKey = "f4aa4ed185f2e9ede3e2f0e5c54641d7"
    func getWeather(lat: String,
                    long: String,
                    completion: @escaping ((Data?, Error?) -> Void) ) {
        guard let url = createURLFromParameters(parameters: ["lat": lat,
                                                             "lon": long,
                                                             "appid": apiKey],
                                                pathparam: "weather") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            completion(data, error)
        }
        task.resume()
    }
    
    private func createURLFromParameters(parameters: [String:Any], pathparam: String?) -> URL? {

        var components = URLComponents()
        components.scheme = Constants.APIDetails.APIScheme
        components.host   = Constants.APIDetails.APIHost
        components.path   = Constants.APIDetails.APIPath
        if let paramPath = pathparam {
            components.path = Constants.APIDetails.APIPath + "\(paramPath)"
        }
        if !parameters.isEmpty {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url
    }
    
}

struct Constants {
    struct APIDetails {
        static let APIScheme = "https"
        static let APIHost = "api.openweathermap.org"
        static let APIPath = "/data/2.5/"
    }
}
