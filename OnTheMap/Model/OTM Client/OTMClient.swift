//
//  OTMClient.swift
//  OnTheMap
//
//  Created by 嶋田省吾 on 2021/10/02.
//

import Foundation
import UIKit


class OTMClient{
    
    struct Auth{
        static var userId = ""
        static var sessionId = ""
        static var firstName = ""
        static var lastName = ""
        static var nickname = ""
        static var objectId = ""
    }
    
    
    //URLs
    
    enum Endpoints{
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case loginOut
        case getPublicUserData
        case getStudentLocation(options: String)
        case postStudentlocation
        
        var stringValue: String{
            switch self {
            case .loginOut: return Endpoints.base + "/session"
            case .getPublicUserData: return Endpoints.base + "/users/\(Auth.userId)"
            case .getStudentLocation(let options): return Endpoints.base + "/StudentLocation" + "?\(options)"
            case .postStudentlocation: return Endpoints.base + "/StudentLocation"
            }
        }
        var url: URL{
            return URL(string: stringValue)!
        }
    }//end of Endpoints
    
    class func login(username: String, password: String, completion: @escaping(Bool, Error?) -> Void){
        let loginRequest = LoginRequest(udacity: loginDict(username: username, password: password))
        taskForPOSTRequest(url: Endpoints.loginOut.url, headerAccept: true, udacityApi: true, responseType: loginResponse.self, body: loginRequest){(response, error) in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.userId = response.account.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout (completion: @escaping() -> Void) {
        var request = URLRequest(url: Endpoints.loginOut.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          let range = (5..<data!.count)
          let newData = data?.subdata(in: range) /* subset response data! but not necessary... */
            Auth.sessionId = ""
            Auth.userId = ""
            completion()
        }
        task.resume()
        
    }
    
    class func getPublicUserData(completion: @escaping (Bool, Error?) -> Void){
        taskForGETRequest(url: Endpoints.getPublicUserData.url, responseType: PublicUserData.self, udacityApi: true) { response, error in
            if let response = response {
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                Auth.nickname = response.nickname
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        
    }
    
    class func gettingStudentLocation(options: String, completion: @escaping (StudentLocation?, Error?) -> Void){
        //for extensibility, I set "options", although we only input 100 at the moment...
        taskForGETRequest(url: Endpoints.getStudentLocation(options: options).url, responseType: StudentLocation.self, udacityApi: false){ response, error in
            if let response = response {
                DispatchQueue.main.async {
                    print("found studentlocation")
                    completion(response, nil)
                }
            } else {
                DispatchQueue.main.async {
                    print("GETrequest failed \(String(describing: error))")
                    completion(nil, error)
                }
            }
        }
    }
    
    //POST student location
    class func createStudentLocation(yourLocation: String, yourLink: String, yourLatitude: Float, yourLongitude: Float, completion: @escaping (Bool, Error?) -> Void){
        let requestBody = AddStudentLocation(uniqueKey: Auth.userId, firstName: Auth.firstName, lastName: Auth.lastName, mapString: yourLocation, mediaURL: yourLink, latitude: yourLatitude, longitude: yourLongitude)
        taskForPOSTRequest(url: Endpoints.postStudentlocation.url, headerAccept: false, udacityApi: false, responseType: StudentLocationPOSTResponse.self, body: requestBody){ response, error in
            if let response = response {
                DispatchQueue.main.async {
                    print("POST suceeded")
                    Auth.objectId = response.objectId
                    completion(true, error)
                }
            } else {
                DispatchQueue.main.async {
                    print("POST failed")
                    completion(false, error)
                }
            }
        }
    }
    

    
    //MARK: HTTPRequestHandlers
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, udacityApi: Bool, completion: @escaping (ResponseType?, Error?) ->Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil,error)
                }
                return
          }
            var newData: Data //handling udacityJSON responses
            if udacityApi == true{
                let range = (5..<data.count)
                newData = data.subdata(in: range)
            } else {
                newData = data
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    print("found responseObject")
                    completion(responseObject, nil)
                }
            } catch { //handling error if needed... not implemented at the moment
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    
    
        
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, headerAccept: Bool, udacityApi: Bool, responseType: ResponseType.Type, body:RequestType, completion: @escaping (ResponseType?, Error?) ->Void){
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
    
        if headerAccept == true {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            var newData: Data //handling udacityJSON responses
            if udacityApi == true{
                let range = (5..<data.count)
                newData = data.subdata(in: range)
            } else {
                newData = data
            }
           
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    
                    completion(responseObject, nil)
                }
            } catch { //handling error if needed... not implemented at the moment
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
}
