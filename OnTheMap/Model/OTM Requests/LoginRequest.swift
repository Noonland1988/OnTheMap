//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by 嶋田省吾 on 2021/10/02.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: loginDict
}

struct loginDict: Codable{
    let username : String
    let password : String
}

