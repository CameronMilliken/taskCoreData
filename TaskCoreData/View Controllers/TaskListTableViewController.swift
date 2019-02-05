//
//  TaskListTableViewController.swift
//  TaskCoreData
//
//  Created by Cameron Milliken on 1/30/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController, ButtonTableViewCellDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        TaskController.sharedInstance.fetchedResultsController.delegate = self
//        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        do {
//            try TaskController.sharedInstance.fetchedResultsController.performFetch()
//        }catch{
//            print("Error loading FetchedResultsController: \(error): \(error.localizedDescription)")
//            }
//        TaskController.sharedInstance.fetchedResultsController.delegate = self
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TaskController.sharedInstance.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return TaskController.sharedInstance.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? ButtonTableViewCell
        let task = TaskController.sharedInstance.fetchedResultsController.object(at: indexPath)
//        cell?.textLabel?.text = task.name
//        cell?.
        cell?.delegate = self
        cell?.update(withTask: task)
        return cell ?? UITableViewCell()
    }
        
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            guard let sectionInfo = TaskController.sharedInstance.fetchedResultsController.sections?[section] else { return nil }
            switch sectionInfo.name {
            case "0":
                return "Incomplete"
            case "1":
                return "Complete"
            default:
                return ""
            }
        }
        
        
        // Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Delete the row from the data source
                let task = TaskController.sharedInstance.fetchedResultsController.object(at: indexPath)
                TaskController.sharedInstance.remove(task: task)
            }
        }

        func buttonCellButtonTapped(_ sender: ButtonTableViewCell) {
            guard let indexPath = tableView.indexPath(for: sender) else { return }
            let task = TaskController.sharedInstance.fetchedResultsController.object(at: indexPath)
            TaskController.sharedInstance.toggleIsCompleteFor(task: task)
            sender.update(withTask: task)
        }
        
        
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toDetailVC" {
                guard let indexPath = tableView.indexPathForSelectedRow else {return}
                guard let destinationVC = segue.destination as? TaskDetailTableViewController else { return }
                let task = TaskController.sharedInstance.fetchedResultsController.object(at: indexPath)
                destinationVC.dueDateValue = task.due
                destinationVC.task = task
            }
        }
    }

extension TaskListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let newIndexPath = newIndexPath, let indexPath = indexPath else {return}
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default:
            return
        }
    }
}



