//
//  ReposesViewController.swift
//  TestProjectForQulix
//
//  Created by Macbook on 06.09.17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import Foundation
import UIKit
import p2_OAuth2
import CoreData

class ReposesViewController: UIViewController, NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var entityDescript :NSEntityDescription!
    
    var fetchedControl: NSFetchedResultsController<NSFetchRequestResult>!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Мои репозитории"
        
        tableView.tableFooterView = UIView()
        
        tableView.estimatedRowHeight = 120
        
        entityDescript = NSEntityDescription.entity(forEntityName: "Repo", in: CoreDataManager.shared.managedObjectContext)
        
        fetchedControl = CoreDataManager.shared.getFetchedResultController(entityName: "Repo", sortDescriptor: "lastUpdate", ascending: false)
        fetchedControl.delegate = self
        
        do {
            try fetchedControl.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updatePage()
    }
    
    //MARK: - UpdatePage
    
    func updatePage(){
        ServerManager.shared.getRepos { (success, response, error) in
            if success == true{
                if let response = response{
                    
                    let itemsArray = response.arrayValue
                    
                    flag: for element in itemsArray {
                        
                        let fetchedItems = self.fetchedControl.fetchedObjects as! [Repo]
                        for object in fetchedItems {
                            if object.repoId == element["id"].int64Value {
                                continue flag
                            }
                        }
                        
                        let item = Repo(entity: self.entityDescript, insertInto: CoreDataManager.shared.managedObjectContext)
                        item.repoId = element["id"].int64Value
                        item.name = element["name"].stringValue
                        
                        item.lastUpdate = element["updated_at"].stringValue
                        item.author = element["owner"]["login"].stringValue
                        item.commit = nil
                        item.repoDescription = element["description"].stringValue
                        item.authorId = element["owner"]["login"].int64Value
                        CoreDataManager.shared.saveContext()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: error, message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK : - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource

extension ReposesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fc = self.fetchedControl{
            if let objects = fc.fetchedObjects{
                return objects.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell") as! RepoTableViewCell
    
        let fetchedItem = fetchedControl.object(at: indexPath) as! Repo
        
        cell.nameLabel.text = fetchedItem.name
        cell.authorLabel.text = fetchedItem.author
        cell.descriptionLabel.text = fetchedItem.repoDescription
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: fetchedItem.lastUpdate!)!
        dateFormatter.dateFormat = "dd MM yyyy HH:mm:ss"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date)
        
        cell.lastDateLabel.text = dateString
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

//MARK: - UITableViewDelegate

extension ReposesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Commits", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CommitsViewController")  as! CommitsViewController
        vc.fetchedRepo = fetchedControl.object(at: indexPath) as! Repo
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Extensions

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
    }
}

