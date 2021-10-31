//
//  AddStudentLocationRequest.swift
//  OnTheMap
//
//  Created by 嶋田省吾 on 2021/10/27.
//

import Foundation

struct AddStudentLocation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
}
