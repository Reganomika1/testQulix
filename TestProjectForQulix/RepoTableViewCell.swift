//
//  RepoTableViewCell.swift
//  TestProjectForQulix
//
//  Created by Macbook on 06.09.17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import Foundation
import UIKit

class RepoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var lastDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
