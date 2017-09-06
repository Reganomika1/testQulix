//
//  CommitsViewController.swift
//  TestProjectForQulix
//
//  Created by Macbook on 06.09.17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import p2_OAuth2
import CoreData

class CommitsViewController: UIViewController, NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var entityDescript :NSEntityDescription!
    
    var fetchedControl: NSFetchedResultsController<NSFetchRequestResult>!
    
    var userPhotoURL: URL!
    var userName: String!
    
    var fetchedRepo: Repo!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Коммиты (" + fetchedRepo.name! + ")"
        
        tableView.tableFooterView = UIView()
        
        tableView.estimatedRowHeight = 120
        
        entityDescript = NSEntityDescription.entity(forEntityName: "Commit", in: CoreDataManager.shared.managedObjectContext)
        
        fetchedControl = CoreDataManager.shared.getFetchedResultController(entityName: "Commit", sortDescriptor: "date", ascending: false)
        fetchedControl.delegate = self
        
        do {
            try fetchedControl.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        ServerManager.shared.getCommits(repo: fetchedRepo.name!, repoOwner: fetchedRepo.author!) { (success, response, error) in
            if success == true{
                if let response = response{
                    
                    let itemsArray = response.arrayValue
                    
                    flag: for element in itemsArray {
                        
                        let fetchedItems = self.fetchedRepo.commit?.allObjects as! [Commit]
                        for object in fetchedItems {
                            if object.commitHash == element["sha"].stringValue {
                                continue flag
                            }
                        }
                        
                        let item = Commit(entity: self.entityDescript, insertInto: CoreDataManager.shared.managedObjectContext)
                        item.date = element["commit"]["author"]["date"].stringValue
                        item.message = element["commit"]["message"].stringValue
                        item.author = element["commit"]["author"]["name"].stringValue
                        item.repo = self.fetchedRepo
                        item.commitHash = element["sha"].stringValue
                        CoreDataManager.shared.saveContext()
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    //MARK : - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

extension CommitsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.fetchedRepo.commit?.allObjects.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commitCell") as! CommitTableViewCell
        
        let fetchedItem = fetchedRepo.commit?.allObjects[indexPath.row] as! Commit
        
        cell.nameLabel.text = fetchedItem.message
        cell.authorLabel.text = fetchedItem.author
        cell.hashLabel.text = fetchedItem.commitHash
        cell.dateLabel.text = fetchedItem.date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

