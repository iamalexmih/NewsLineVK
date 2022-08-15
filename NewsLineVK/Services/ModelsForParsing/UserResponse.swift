//
//  UserResponse.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 14.08.2022.
//

import UIKit

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    let photo100: String?
}
