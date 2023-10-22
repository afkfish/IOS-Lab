//
//  NotebookViewController.swift
//  UberNotebook
//
//  Created by Beni Kis on 22/10/2023.
//

import UIKit
import CoreData

class NotebookViewController: UITableViewController {
    
    private var notebooks = [Notebook]()
    private var fetchedResultsController: NSFetchedResultsController<Notebook>!
    
    @IBAction func addNotebookButtonTap(_ sender: UIBarButtonItem) {
        let createNotebookAlert = UIAlertController(title: "Create Notebook", message: "Enter the title", preferredStyle: .alert)
        
        createNotebookAlert.addTextField() { textField in
            textField.placeholder = "Notebook title"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        createNotebookAlert.addAction(cancelAction)
        
        let createAction = UIAlertAction(title: "Create", style: .default) { action in
            
            let textField = createNotebookAlert.textFields!.first!
            self.createNotebook(with: textField.text!)
        }
        createNotebookAlert.addAction(createAction)
        
        present(createNotebookAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNotebooks()
        
        fetchedResultsController.delegate = self
    }
    
    private func fetchNotebooks() {
        let managedObjectContext = AppDelegate.managedContext
        
        let fetchRequest: NSFetchRequest<Notebook> = Notebook.fetchRequest()
        
        fetchRequest.sortDescriptors = []
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            notebooks = fetchedResultsController.fetchedObjects!
        } catch let error as NSError {
            print("\(error.userInfo)")
        }
    }
    
    private func createNotebook(with title: String) {
        let managedObjectContext = AppDelegate.managedContext
        
        let notebook = Notebook(context: managedObjectContext)
        notebook.title = title
    }
    
    func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        let notebook = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = notebook.title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotebookCell", for: indexPath)
        
        configure(cell: cell, at: indexPath)
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNotesSegue" {
            let noteViewController = segue.destination as! NoteViewController
            noteViewController.notebook = notebooks[tableView.indexPathForSelectedRow!.row]
        }
    }
}

extension NotebookViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            notebooks = controller.fetchedObjects as! [Notebook]
        case .delete:
          tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!)!
            configure(cell: cell, at: indexPath!)
          case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
