//
//  AuthManager.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    
    struct AuthConstants {
        static let clientID = "9468cf3e204741bc9832511d92e4c09b"
        static let clientSecret = "19a82a070afa41febe80788421a1d89d"
    }
    
    private init() {
    }
    
    public var signInURL: URL? {
        let baseURL = "https://accounts.spotify.com/authorize"
        let scopes = "user-read-private"
        let redirectUri = "https://github.com/Igor-A-Penkin/MultimediaApp"
        let authURL = "\(baseURL)?response_type=code&client_id=\(AuthConstants.clientID)&scope=\(scopes)&redirect_uri=\(redirectUri)&show_dialog=TRUE"
        return URL(string: authURL)
    }
    
    var isSignedIn: Bool { 
         return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
    
    public func exchangeCodeForToken(code: String, completionHandler: @escaping (Bool) -> Void) {
        // get token
    }
    
    private func refreshAccessToken() {
        // TO DO
    }
    
    private func cacheToken() {
        // TO DO
    }
    
}
