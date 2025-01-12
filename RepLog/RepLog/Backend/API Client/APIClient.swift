//
//  APIClient.swift
//  RepLog
//
//  Created by Brad Curci on 1/10/25.
//

import Foundation

class APIClient {
    
    static let shared = APIClient()

    private init() {}
    
    
    // Error classifications
    public enum APIError: Error {
        case invalidURL
        case nilData
        case decodingError
        
        // Status code responses
        case informationalResponse
        case redirectionResponse
        case clientError
        case serverError
    }
    
    
    // MARK: Main request
    func request<T: Decodable>(
        baseURL         : String,
        method          : String = "GET",
        parameters      : [String : Any]? = nil,
        headers         : [String : String]? = nil,
        body            : Data? = nil,
        tokenRequired   : Bool = true,
        printResponse   : Bool = false,
        printStatusCode : Bool = false,
        completion      : @escaping (Result<T, Error>) -> Void
    ){
        
        
        // Build URL Component
        guard var urlComponents = URLComponents(string: baseURL) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        
        // Append query parameters for method of type GET
        if method.uppercased() == "GET", let parameters = parameters {
            urlComponents.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: String(describing: value))
            }
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        
        // Construct Request
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        // Add headers
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        
        // MARK: APP SECRET
        // This code is to be later revised for production but is acceptable for development
        // ---------------------------------------------------------------------------------
        guard let infoDictionary: [String : Any] = Bundle.main.infoDictionary else {
            return
        }
        
        guard let secretKey: String = infoDictionary["AppSecret"] as? String else {
            return
        }
        
        request.setValue("\(secretKey)", forHTTPHeaderField: "X-Tadabase-App-Secret")
        // ---------------------------------------------------------------------------------
        
        
        // Add user token
        if tokenRequired {
            guard let token = TokenViewModel.shared.retrieveTokenFromKeychain() else { return }
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        
        // Parameters for non-GET requests
        if method.uppercased() != "GET" {
            if let body = body {
                request.httpBody = body
            } else if let parameters = parameters {
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            }
        }
        
        
        // Request
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            
            guard let data = data else {
                completion(.failure(APIError.nilData))
                return
            }
            
            
            // check status code
            var statusCode = 0
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
                switch httpResponse.statusCode {
                    case 100...199:
                        self.printResponse(data)
                        completion(.failure(APIError.informationalResponse))
                        return
                    case 200...299:
                        break
                    case 300...399:
                        self.printResponse(data)
                        completion(.failure(APIError.redirectionResponse))
                        return
                    case 400...499:
                        self.printResponse(data)
                        completion(.failure(APIError.clientError))
                        return
                    default:
                        self.printResponse(data)
                        completion(.failure(APIError.serverError))
                        return
                }
            }
            
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
            
            if printResponse {
                self.printResponse(data)
            }
            
            if printStatusCode {
                print("Status Code: \(statusCode)")
            }
        }
        task.resume()
    }
    
    
    // MARK: Asynchronus Request
    func asyncRequest<T: Decodable>(
        baseURL         : String,
        method          : String = "GET",
        parameters      : [String : Any]? = nil,
        headers         : [String : String]? = nil,
        body            : Data? = nil,
        tokenRequired   : Bool = true,
        printResponse   : Bool = false,
        printStatusCode : Bool = false
    ) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            request(
                baseURL: baseURL,
                method: method,
                parameters: parameters,
                headers: headers,
                body: body,
                tokenRequired: tokenRequired,
                printResponse: printResponse,
                printStatusCode: printStatusCode
            ) { (result: Result<T, Error>) in
                switch result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                }
            }
        }
    }
    
    
    // pretty print json data
    private func printResponse(_ JSONData: Data) {
        if let JSONObject = try? JSONSerialization.jsonObject(with: JSONData, options: []),
        let prettyData = try? JSONSerialization.data(withJSONObject: JSONObject, options: .prettyPrinted),
        let prettyString = String(data: prettyData, encoding: .utf8) {
            print(prettyString)
        }
    }
}
