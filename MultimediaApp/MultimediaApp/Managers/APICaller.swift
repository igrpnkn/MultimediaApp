//
//  APICaller.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    enum APIError: Error {
        case failedToGetDate
    }
    
    private init() {}
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        self.createRequest(with: URL(string: Constants.baseAPIURL + "/me"),
                           type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetDate ))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    Logger.log(object: Self.self, method: #function, message: "Got user profile model:", body: result, clarification: nil)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getNewReleases(completion: @escaping (Result<String, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=10&country=RU"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetDate))
                    return
                }
                do {
                    let meta = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    Logger.log(object: Self.self, method: #function, message: "Serialized JSON:", body: meta, clarification: nil)
//                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
//                    Logger.log(object: Self.self, method: #function, message: "Got user profile model:", body: result, clarification: nil)
                    completion(.success(""))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Creation common request
    
    private func createRequest(with url: URL?,
                               type: HTTPMethod,
                               completion: @escaping (URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            
            var request = URLRequest(url: apiURL)
            request.httpMethod = type.rawValue
            request.timeoutInterval = 20
            request.setValue("Bearer \(token)",
                             forHTTPHeaderField: "Authorization")
            completion(request)
        }
        
        
    }
    
}
