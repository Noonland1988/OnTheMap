//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by 嶋田省吾 on 2021/10/02.
//

import Foundation

struct loginResponse: Codable{
    let account: account
    let session: session
}

struct account: Codable{
    let registered: Bool
    let key: String
}

struct session: Codable{
    let id: String
    let expiration: String
}
