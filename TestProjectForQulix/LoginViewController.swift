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
        "client_id": "d69afae5f476502ed0d5",                         
        "client_secret": "0fdb68aab1f992b951ae55fc1c16fa2afb2e2730",
        "authorize_uri": "https://github.com/login/oauth/authorize",
        "token_uri": "https://github.com/login/oauth/access_token",
        "scope": "user repo:status",
        "redirect_uris": ["testqulix://oauth-callback/github"],
        "secret_in_body": true,
        "verbose": true,
        ] as OAuth2JSON)
    
    //MARK: - LifeCycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oauth2.forgetTokens()
        
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
                if let token = self.oauth2.accessToken{
                    UserDefaults.standard.set(token, forKey: "token") 
                }
                self.didGetUserdata(dict: json, loader: loader)
            }
            catch let error {
                self.didCancelOrFail(error)
            }
        }
    }
 
    //MARK: - AUTH
   
    var userDataRequest: URLRequest {
        var request = URLRequest(url: URL(string: "https://api.github.com/user")!)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        return request
    }

    func didGetUserdata(dict: [String: Any], loader: OAuth2DataLoader?) {
        
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Reposes", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ReposesViewController") as! ReposesViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - Handlers

    func didCancelOrFail(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("Authorization went wrong: \(error)")
            }
        }
    }
  

}
