//
//  APIManager.swift
//  ExchangeRate
//
//  Created by Teerawat Vanasapdamrong on 8/2/2565 BE.
//

import Foundation

protocol APIManagerProtocol {
    func getSupportedCodes(_ completion: @escaping (Result<SupportedCodeResponse, APIError>) -> Void)
    func getStandard(code: String, _ completion: @escaping (Result<StandardResponse, APIError>) -> Void)
    func getPairConversion(baseCode: String, targetCode: String, _ completion: @escaping (Result<PairConversionResponse, APIError>) -> Void)
}

let baseURL: String = "https://v6.exchangerate-api.com/v6"
let apiKey: String = "959747ab50b9c8b3242fa045"

class APIManager {
    private func request<T: Codable>(urlString: String, httpMethod: String = "GET", parameters: Data? = nil, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        request.httpMethod = httpMethod
        if let parameters = parameters {
            request.httpBody = parameters
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error, let _ = response as? HTTPURLResponse {
                DispatchQueue.main.async {
                    completion(.failure(.networkError))
                }
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    do {
                        let values = try JSONDecoder().decode(T.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(values))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(.invalidJSON))
                        }
                    }
                } else {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(APIError(rawValue: errorResponse.errorType) ?? .unknownError))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(.unknownError))
                        }
                    }
                }
            }
        }
        task.resume()
    }
}

extension APIManager: APIManagerProtocol {
    func getSupportedCodes(_ completion: @escaping (Result<SupportedCodeResponse, APIError>) -> Void) {
        request(urlString: "\(baseURL)/\(apiKey)/codes", completion: completion)
    }
    
    func getStandard(code: String, _ completion: @escaping (Result<StandardResponse, APIError>) -> Void) {
        request(urlString: "\(baseURL)/\(apiKey)/latest/\(code)", completion: completion)
    }
    
    func getPairConversion(baseCode: String, targetCode: String, _ completion: @escaping (Result<PairConversionResponse, APIError>) -> Void) {
        request(urlString: "\(baseURL)/\(apiKey)/pair/\(baseCode)/\(targetCode)", completion: completion)
    }
}
