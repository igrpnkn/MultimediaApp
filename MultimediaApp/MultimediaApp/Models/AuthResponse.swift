//
//  AuthResponse.swift
//  MultimediaApp
//
//  Created by Игорь Пенкин on 25.07.2021.
//

import Foundation

struct AuthResponse: Decodable {
    var access_token: String
    var expires_in: Int
    var refresh_token: String?
    var scope: String
    var token_type: String   
}
