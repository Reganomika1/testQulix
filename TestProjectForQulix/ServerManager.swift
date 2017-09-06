//
//  ServerMamager.swift
//  PressFeed
//
//  Created by Artem on 21.08.17.
//  Copyright © 2017 BalinaSoft. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ServerManager {

    static let shared = ServerManager()
    let baseUrl = "https://apidev.pressfeed.ru"
    typealias Completion = (Bool, JSON?, String?) -> ()
    
    var localPath: String?
    
    //MARK: - Auth
    
    func auth(email: String, password: String, completion: @escaping Completion) {
    
        let params: Parameters = ["email": email,
                                  "password": password,
                                  "rememberMe": 1,
                                  "device_type": "ios"]
        
        let headers: HTTPHeaders = ["Current-Version": "v1"]
        
        Alamofire.request(baseUrl + "/auth", method:.post, parameters: params, encoding:JSONEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("AUTH: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    func restorePassword(email: String, completion: @escaping Completion) {
    
        let params: Parameters = ["email": email]
        
        let headers: HTTPHeaders = ["Current-Version": "v1"]
        
        Alamofire.request(baseUrl + "/restore-password/send-letter", method:.post, parameters: params, encoding:JSONEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("RESTORE PASSWORD: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    //MARK: - SMI
    
    func getSMI(match: String, completion: @escaping Completion) {
        
        let headers: HTTPHeaders = ["Current-Version": "v1"]
        
        Alamofire.request(baseUrl + "/smi?match=" + match, method:.get, parameters: nil, encoding:JSONEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("SMI: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    //MARK: - Registration
    
    func registration(type: String, name: String, surname: String, city: String, email: String, password: String, phone: String, smiName: String, smiId: String, smiSite: String, smiCity: String, geoId: String, position: String, completion: @escaping Completion) {
        
        let headers: HTTPHeaders = ["Current-Version": "v1"]
        var params: Parameters
        
        if type == "journalist" {
        
            params = ["type": type,
                      "name": name,
                      "surname": surname,
                      "city": city,
                      "email": email,
                      "password": password,
                      "phone": phone,
                      "smi": [["id": smiId, "position": position, "name": smiName, "site": smiSite, "city": smiCity, "geo_id": geoId]]]
        } else {
            
            params = ["type": type,
                      "name": name,
                      "surname": surname,
                      "city": city,
                      "email": email,
                      "password": password,
                      "phone": phone,
                      "companies": [["id": smiId, "position": position, "name": smiName, "site": smiSite,"geo_id": "0"]]]
        }
        
        
        
        Alamofire.request(baseUrl + "/registration", method:.post, parameters: params, encoding:JSONEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            print(status!)
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("REGISTRATION: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    //MARK: - City
    
    func getCity(match: String, completion: @escaping Completion) {
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Content-Type": "application/json"]
        
        let params: Parameters = ["match": match]
        
        Alamofire.request(baseUrl + "/city", method:.get, parameters: params, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("CITY: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    
    //MARK: - Profile
    
    func postAvatar( photo: UIImage, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let fixOrientationImage=photo.fixOrientation()
        
        
        let documentDirectory: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        let imageName = "temp"
        let imagePath = documentDirectory.appendingPathComponent(imageName)
        do {
            if let data = UIImageJPEGRepresentation(fixOrientationImage, 0.4) {
                try data.write(to: URL(fileURLWithPath: imagePath), options: .atomic)
            }
        } catch {
            print(error)
        }
        
        localPath = imagePath
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Current-Version": "v1",
            "Content-Type": "application/json"
        ]
        
        Alamofire.upload( multipartFormData: { (multipartFormData) in
            let filePath = URL(fileURLWithPath: self.localPath!)
            let data = "Alamofire".data(using: String.Encoding.utf8, allowLossyConversion: false)!
            multipartFormData.append(data, withName: "test")
            multipartFormData.append(filePath, withName: "file", fileName: "file.jpg", mimeType: "image/jpeg")
        }, to:baseUrl + "/files/avatar", headers: headers)
        { (result) in
            
            switch result {
                
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    let data = response.data
                    if let data = data {
                        let json = JSON(data: data)
                        completion(true, json, nil)
                    }
                }
                
            case .failure(let encodingError):
                completion(false, nil, encodingError as? String)
            }
            
        }
    }

    
    func getOwner(completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1" , "Authorization": "Bearer " + token]
        
        Alamofire.request(baseUrl + "/users/owner", method:.get, parameters: nil, encoding:URLEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("OWNER: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    //MARK: - Queries
    
    func getProfile(userId: Int, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1" , "Authorization": "Bearer " + token]
        
        let params : Parameters = ["user_id" : userId]
        
        Alamofire.request(baseUrl + "/users/profile", method:.get, parameters: params, encoding:URLEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("PROFILE: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    func getQueries(status: String, completion: @escaping Completion) {
    
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        Alamofire.request(baseUrl + "/queries?current=1&status=" + status, method:.get, parameters: nil, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("QUERIES: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    func getQueryFromId(id: Int, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = ["query_ids": [id]]
        
        Alamofire.request(baseUrl + "/queries?current=1", method:.get, parameters: params, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("QUERY: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }

    
    func getMyQueries(offset: Int, isArchive: Bool, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        var urlWithParams = String()
        
        if isArchive{
            urlWithParams = "/queries?current=1&mine=1&is_archived=1&offset=\(offset)&limit=20"
        } else {
            urlWithParams = "/queries?current=1&mine=1&is_archived=0&offset=\(offset)&limit=20"
        }
        
        Alamofire.request(baseUrl + urlWithParams, method:.get, parameters: nil, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("MY QUERIES: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    func searchQueries(match: String, status: String, completion: @escaping Completion) {
    
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = ["match": match,
                                  "mark": "0",
                                  "current": "1",
                                  "status": status]
        
        Alamofire.request(baseUrl + "/queries/search", method:.get, parameters: params, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("SEARCH QUERIES: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    func createQuery(title: String, text: String, deadline: String, smiId: String, canRepost: Int, anonim: Int, completion: @escaping Completion) {
    
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = ["title": title,
                                  "text": text,
                                  "requirements": "",
                                  "deadline": deadline,
                                  "user_smi_id": smiId,
                                  "industries": "40",
                                  "can_repost": canRepost,
                                  "is_anonymous": anonim]
        
        Alamofire.request(baseUrl + "/queries", method:.post, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("CREATE QUERY: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    //MARK: - QueryStatus
    
    func addQueryToDeleted(id: String, completion: @escaping Completion) {
    
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = ["ids": [id]]
        
        Alamofire.request(baseUrl + "/querystatus/deleted", method:.post, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("ADD QUERY TO DELETED: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    func addQueryToArchive(id: String, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = [
            "query_id": id,
            "archive": 1
        ]
        
        Alamofire.request(baseUrl + "/queries", method:.put, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("ADD QUERY TO ARCHIVE: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    func closeQuery(id: String, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = [
            "query_id": id,
            "close": 1
        ]
        
        Alamofire.request(baseUrl + "/queries", method:.put, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("CLOSE QUERY: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    func returnQuery(id: String, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = [
            "query_id": id,
            "close": 0
        ]
        
        Alamofire.request(baseUrl + "/queries", method:.put, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("RETURN QUERY: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    func addQueryToRequestsFromArchive(id: String, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = [
            "query_id": id,
            "archive": 0
        ]
        
        Alamofire.request(baseUrl + "/queries", method:.put, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("REMOVE QUERY FROM ARCHIVE: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }

    
    func deleteQuery(id: String, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = [
            "query_id": id
        ]
        
        Alamofire.request(baseUrl + "/queries", method:.delete, parameters: params, encoding: URLEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("DELETE QUERY: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }

    
    func addQueryToFav(id: String, completion: @escaping Completion) {
    
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = ["ids": [id]]
        
        Alamofire.request(baseUrl + "/querystatus/favorite", method:.post, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("ADD QUERY TO FAV: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    func removeQueryFromFav(id: String, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = ["ids": [id]]
        
        Alamofire.request(baseUrl + "/querystatus/favorite", method: .delete, parameters: params, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("REMOVE QUERY FROM FAV: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    func removeQueryFromDeleted(id: String, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = ["ids": [id]]
        
        Alamofire.request(baseUrl + "/querystatus/deleted", method: .delete, parameters: params, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("REMOVE QUERY FROM DELETED: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    func addQueryToRead(id: String, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = ["ids": [id]]
        
        Alamofire.request(baseUrl + "/querystatus/read", method:.post, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("ADD QUERY TO READ: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    //MARK: - Pitches
    
    func postPitch(text: String, queryId: Int, company_id: Int, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = ["text": text,
                                  "query_id": queryId,
                                  "company_id" : company_id]
        
        Alamofire.request(baseUrl + "/pitches", method:.post, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("POST PITCH: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    func getMyPitches(offset: Int, isArchive: Bool, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        var urlWithParams = String()
        
        if isArchive{
            urlWithParams = "/pitches?&mine=1&is_archived=1&offset=\(offset)&limit=20"
        } else {
            urlWithParams = "/pitches?mine=1&is_archived=0&offset=\(offset)&limit=20"
        }
        
        Alamofire.request(baseUrl + urlWithParams, method:.get, parameters: nil, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("PITCHES: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    func getPitchesForMyQuery(queryId: String, completion: @escaping Completion) {
    
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = ["query_id": queryId,
                                  "mine": 0]
        
        Alamofire.request(baseUrl + "/pitches", method:.get, parameters: params, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("PITCHES FOR MY QUERY: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    func removePitchFromArchive(id: String, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = [
            "pitch_id": id,
            "archive": 0
        ]
        
        Alamofire.request(baseUrl + "/pitches", method:.put, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("REMOVE PITCH FROM ARCHIVE: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    func addPitchToArchive(id: String, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = [
            "pitch_id": id,
            "archive": 1
        ]
        
        Alamofire.request(baseUrl + "/pitches", method:.put, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("ADD PITCH FROM ARCHIVE: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    
    //MARK: - Comments
    
    func postComment(text: String, pitchId: Int, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = ["text": text,
                                  "pitch_id": pitchId]
        
        Alamofire.request(baseUrl + "/comments", method:.post, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("POST COMMENT: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    func getComments( pitchId: Int, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = ["pitch_id": pitchId]
        
        Alamofire.request(baseUrl + "/comments", method:.get, parameters: params, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("COMENTS: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }

    //MARK: - Companies
    
    func createCompany(name: String, geoId: String, link: String!, position: String, completion: @escaping Completion) {
    
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = ["name": name,
                                  "geo_id": geoId,
                                  "link": link,
                                  "position": position]
        
        Alamofire.request(baseUrl + "/companies", method:.post, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("CREATE COMPANY: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }

    //MARK: - Users
    
    func addSMI(id: String, userSmiId: String, position: String, name: String, site: String, city: String, geoId: String, completion: @escaping Completion) {
    
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Current-Version": "v1",
                                    "Authorization": "Bearer " + token,
                                    "Content-Type": "application/json"]
        
        let params: Parameters = ["smi" : [["id": id,
                                           "user_smi_id": userSmiId,
                                           "position": position,
                                           "name": name,
                                           "site": site,
                                           "city": city,
                                           "geo_id": geoId]]]
        
        Alamofire.request(baseUrl + "/users", method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("ADD SMI: \(json)")
                        completion(true, json, nil)
                    } else {
                        completion(true, nil, nil)
                    }
                } else if status >= 500 {
                    completion(false, nil, "Сервер не работает")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        print(json)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    
}















