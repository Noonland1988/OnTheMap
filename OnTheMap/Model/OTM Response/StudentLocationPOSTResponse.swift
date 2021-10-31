//
//  StudentLocationPOSTResponse.swift
//  OnTheMap
//
//  Created by 嶋田省吾 on 2021/10/13.
//

import Foundation

//Response for AddStudentLocation
struct StudentLocationPOSTResponse: Codable {
    let createdAt: String
    let objectId: String
}
