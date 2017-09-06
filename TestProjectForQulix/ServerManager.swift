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
import p2_OAuth2

class ServerManager {

    static let shared = ServerManager()
    let baseUrl = "https://api.github.com/"
    typealias Completion = (Bool, JSON?, String?) -> ()
    
    
    //MARK: - Get requests
    
    func getRepos( completion: @escaping Completion) {
    
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Accept" : "application/vnd.github.mercy-preview+json",
                                    "Authorization": "token " + token]
        
        Alamofire.request(baseUrl + "user/repos", method:.get, parameters: nil, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("REPOSES: \(json)")
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
            }else {
                completion(false, nil, "Превышено время ожидания отклика сервера. Возможно утрачено интернет-соединение.")
            }
        }
    }
    
    func getCommits(repo: String, repoOwner: String, completion: @escaping Completion) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {return}
        
        let headers: HTTPHeaders = ["Accept" : "application/vnd.github.mercy-preview+json",
                                    "Authorization": "token " + token]
        
        let date = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        
        let stringFromDate = date.iso8601
        
        Alamofire.request(baseUrl + "repos/\(repoOwner)/\(repo)/commits?since=" + stringFromDate, method:.get, parameters: nil,encoding:URLEncoding.default, headers: headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if let status = status {
                if status == 200 {
                    if let data = data {
                        let json = JSON(data: data)
                        print("COMMITS: \(json)")
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
            } else {
                completion(false, nil, "Превышено время ожидания отклика сервера. Возможно утрачено интернет-соединение.")
            }
        }
    }
}















