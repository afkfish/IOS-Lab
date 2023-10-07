//
//  NamesViewController.swift
//  iNames
//
//  Created by Beni Kis on 07/10/2023.
//

import UIKit

class NamesViewController: UITableViewController {
  
  var names = [AnyObject]()

  // MARK: View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
    names = NameHandler.shared.names!
    title = "Mai névnapok"
  }

  // MARK: TableView Data Source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return names.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath)
    let name = names[indexPath.row] as! [NSString: NSString]
    
    cell.textLabel?.text = name["name"] as String?
    cell.imageView?.contentMode = .scaleAspectFill
    cell.imageView?.image = UIImage(named: "Flower")
    cell.imageView?.tintColor = .black
    
    return cell
  }

  // MARK: Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowDetailSegue" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let object = names[indexPath.row] as! [NSString: NSString]
        
        let nameViewController = (segue.destination as! UINavigationController).topViewController as! NameViewController
        nameViewController.nameToDisplay = object
        nameViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        nameViewController.navigationItem.leftItemsSupplementBackButton = true
      }
    }
  }
  
}
