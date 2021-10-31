//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by 嶋田省吾 on 2021/10/10.
//

import Foundation

struct StudentLocation: Codable{
    let results: [results]
}

struct results: Codable{
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Float
    let longitude: Float
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
