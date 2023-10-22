//
//  NoteViewController.swift
//  UberNotebook
//
//  Created by Beni Kis on 22/10/2023.
//

import UIKit
import CoreData

class NoteViewController: UITableViewController {
    
    var notebook: Notebook!
    private var fetchedResultsController: NSFetchedResultsController<Note>!
    
    @IBAction func addNoteButtonTap(_ sender: UIBarButtonItem) {
        let createNoteAlert = UIAlertController(title: "Create Note", message: "Enter the content", preferredStyle: .alert)
        
        createNoteAlert.addTextField() { textField in
            textField.placeholder = "Note content"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        createNoteAlert.addAction(cancelAction)
        
        let createAction = UIAlertAction(title: "Create", style: .default) { action in
            
            let textField = createNoteAlert.textFields!.first!
            self.createNote(with: textField.text!)
        }
        createNoteAlert.addAction(createAction)
        
        present(createNoteAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = notebook.title
        
        let managedObjectContext = AppDelegate.managedContext
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        // szűrés azon Note-okra, melyek a kiválasztott Notebookhoz tartoznak
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Note.notebook), notebook)
        fetchRequest.predicate = predicate
        
        // rendezés creationDate szerint csökkenő sorrendben
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Note.creationDate), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // egyszerre max 30 Note lekérdezése
        fetchRequest.fetchBatchSize = 30
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("\(error.userInfo)")
        }
        
        fetchedResultsController.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        
        return sectionInfo.numberOfObjects
    }
    
    func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        let note = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = note.content
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        cell.detailTextLabel?.text = dateFormatter.string(from: note.creationDate!)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        configure(cell: cell, at: indexPath)
        
        return cell
    }
    
    private func createNote(with content: String) {
      let managedObjectContext = AppDelegate.managedContext

      let note = Note(context: managedObjectContext)
      note.content = content
      note.creationDate = Date()
      note.notebook = notebook
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedObjectContext = AppDelegate.managedContext
            let noteToDelete = fetchedResultsController.object(at: indexPath)
            managedObjectContext.delete(noteToDelete)
        }
    }
}

extension NoteViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
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
