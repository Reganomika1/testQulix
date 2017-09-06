//
//  ReposesViewController.swift
//  TestProjectForQulix
//
//  Created by Macbook on 06.09.17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ReposesViewController: UIViewController{
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var userPhotoURL: URL!
    var userName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.avatarView.sd_setImage(with:self.userPhotoURL, completed: nil)
            self.nameLabel.text = self.userName
        }
    }
}
