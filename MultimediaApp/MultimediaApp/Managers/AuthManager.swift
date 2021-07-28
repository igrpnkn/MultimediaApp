//
//  AuthManager.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    
    private var isTokenRefreshing = false
    
    struct Constants {
        static let clientID = "9468cf3e204741bc9832511d92e4c09b"
        static let clientSecret = "19a82a070afa41febe80788421a1d89d"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://github.com/Igor-A-Penkin/MultimediaApp"
        static let scopes = "ugc-image-upload%20user-read-recently-played%20user-top-read%20user-read-playback-position%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-read%20user-library-modify%20user-read-email%20user-read-private"
    }
    
    private init() {
    }
    
    public var signInURL: URL? {
        let baseURL = "https://accounts.spotify.com/authorize"
        let authURL = "\(baseURL)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: authURL)
    }
    
    var isSignedIn: Bool { 
         return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeCodeForToken(
        code: String,
        completionHandler: @escaping ((Bool) -> Void)
    ) {
        // getting token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
            
        var component = URLComponents()
        component.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("INFO: \(#function) Failure to get Base64 for basicToken")
            completionHandler(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        request.httpBody = component.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                completionHandler(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completionHandler(true)
            } catch {
                completionHandler(false)
            }
        }
        task.resume()
    }
    
    private var onRefreshBloks = [((String) -> Void)]()
    
    /// Supplies valid token to be used with API Calls
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !isTokenRefreshing else {
            // Append the completion
            onRefreshBloks.append(completion)
            return
        }
        
        if shouldRefreshToken {
            refreshIfNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                     completion(token)
                }
            }
        } else if let token = accessToken {
             completion(token)
        }
    }
    
    public func refreshIfNeeded(completion: ((Bool) -> Void)? ) {
        print("\nINFO: \(#function) : -")
        guard !isTokenRefreshing else {
            print("\nINFO: \(#function) : isTokenRefreshing = \(isTokenRefreshing) : refreshing guarded.")
            return
        }
        guard shouldRefreshToken else {
            print("\nINFO: \(#function) : shouldRefreshToken = \(shouldRefreshToken) : refreshing guarded.")
            completion?(true)
            return
        }
        guard self.refreshToken != nil else {
            print("\nINFO: \(#function) : refreshToken = nil : refreshing guarded.")
            return
        }
        //Refresh the token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            print("\nINFO: \(#function) : broken Constants.tokenAPIURL : refreshing guarded.")
            return
        }
            
        self.isTokenRefreshing = true
        
        var component = URLComponents()
        component.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: self.refreshToken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("INFO: \(#function) Failure to get Base64 for basicToken")
            completion?(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        request.httpBody = component.query?.data(using: .utf8)
        
        print("\nINFO: \(#function) : request for refreshing = \(request) : refreshing guarded.")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            self?.isTokenRefreshing = false
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBloks.forEach { $0(result.access_token) }
                self?.onRefreshBloks.removeAll()
                print("\nINFO: We have got a token: \(result.access_token)")
                self?.cacheToken(result: result)
                completion?(true)
            } catch {
                completion?(false)
            }
        }
        task.resume()
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
    
}
