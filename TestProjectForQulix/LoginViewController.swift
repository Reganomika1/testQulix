//
//  LoginViewController.swift
//  TestProjectForQulix
//
//  Created by Macbook on 06.09.17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit
import Alamofire
import p2_OAuth2
import SwiftyJSON


class LoginViewController: UIViewController {
    
    fileprivate var alamofireManager: SessionManager?
    
    var loader: OAuth2DataLoader?
    
    var oauth2 = OAuth2CodeGrant(settings: [
        "client_id": "d69afae5f476502ed0d5",                         // yes, this client-id and secret will work!
        "client_secret": "0fdb68aab1f992b951ae55fc1c16fa2afb2e2730",
        "authorize_uri": "https://github.com/login/oauth/authorize",
        "token_uri": "https://github.com/login/oauth/access_token",
        "scope": "user repo:status",
        "redirect_uris": ["testqulix://oauth-callback/github"],            // app has registered this scheme
        "secret_in_body": true,                                      // GitHub does not accept client secret in the Authorization header
        "verbose": true,
        ] as OAuth2JSON)
    
    //MARK: - LifeCycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let signBarButtonItem = UIBarButtonItem(title: "Вход", style: UIBarButtonItemStyle.done, target: self, action: #selector(authorization))
        navigationItem.rightBarButtonItem = signBarButtonItem
    }
    
    
    //MARK: - Selectors
    
    func authorization(){
        if oauth2.isAuthorizing {
            oauth2.abortAuthorization()
            return
        }
        
        oauth2.authConfig.authorizeEmbedded = false		// the default
        let loader = OAuth2DataLoader(oauth2: oauth2)
        self.loader = loader
        
        loader.perform(request: userDataRequest) { response in
            do {
                let json = try response.responseJSON()
                self.didGetUserdata(dict: json, loader: loader)
            }
            catch let error {
                self.didCancelOrFail(error)
            }
        }
    }


 
    //MARK: - Profile
   
    var userDataRequest: URLRequest {
        var request = URLRequest(url: URL(string: "https://api.github.com/user")!)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        return request
    }

    func didGetUserdata(dict: [String: Any], loader: OAuth2DataLoader?) {
        

        DispatchQueue.main.async {
        
        let storyboard = UIStoryboard(name: "Reposes", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReposesViewController") as! ReposesViewController
        
            if let username = dict["name"] as? String {
                vc.userName = username
            }
            else {
                vc.userName = "Имя не указано"
            }
            if let imgURL = dict["avatar_url"] as? String, let url = URL(string: imgURL) {
                vc.userPhotoURL = url
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func didCancelOrFail(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("Authorization went wrong: \(error)")
            }
        }
    }
  

}
