//
//  OnrampApiService.swift
//  OnrampKit
//
//  API service for URL generation
//

import Foundation

class OnrampApiService {
    static var baseUrl = "https://api.onramp.money/sdk-apis"

    private static func setBaseUrl(_ url: String) {
        baseUrl = url.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }

    // Custom character set for proper URL query parameter encoding
    // Similar to encodeURIComponent in JavaScript
    private static var urlQueryParameterAllowed: CharacterSet = {
        var allowed = CharacterSet.urlQueryAllowed
        // Remove characters that should be percent-encoded in query values
        allowed.remove(charactersIn: "+=&")
        return allowed
    }()

    static func generateUrl(params: [String: Any], sdkFlow: String = "TRANSACTION", completion: @escaping (Result<String, Error>) -> Void) {
        // Build query string from params dictionary with proper percent encoding
        let queryString = params.map { key, value in
            // Convert value to string representation
            let stringValue: String
            if let strVal = value as? String {
                stringValue = strVal
            } else if let numVal = value as? NSNumber {
                stringValue = numVal.stringValue
            } else {
                stringValue = "\(value)"
            }

            // Percent encode both key and value using custom character set
            // This ensures '+' and other special characters are properly encoded
            let encodedKey = key.addingPercentEncoding(withAllowedCharacters: urlQueryParameterAllowed) ?? key
            let encodedValue = stringValue.addingPercentEncoding(withAllowedCharacters: urlQueryParameterAllowed) ?? stringValue

            return "\(encodedKey)=\(encodedValue)"
        }.joined(separator: "&")

        let urlString = "\(baseUrl)/generate-url?\(queryString)"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "OnrampSDK", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("IOS", forHTTPHeaderField: "X-SDK-TYPE")
        request.setValue(sdkFlow, forHTTPHeaderField: "X-SDK-FLOW")
        request.timeoutInterval = 30

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "OnrampSDK", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let dataDict = json["data"] as? [String: Any],
                   let generatedUrl = dataDict["url"] as? String {
                    completion(.success(generatedUrl))
                } else {
                    completion(.failure(NSError(domain: "OnrampSDK", code: -3, userInfo: [NSLocalizedDescriptionKey: "URL not found in response"])))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
