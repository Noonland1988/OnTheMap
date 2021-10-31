//
//  PublicUserData.swift
//  OnTheMap
//
//  Created by 嶋田省吾 on 2021/10/09.
//

import Foundation

struct PublicUserData: Codable {
    let firstName: String
    let lastName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey{
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
    }
}
