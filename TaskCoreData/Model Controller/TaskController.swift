//
//  TaskController.swift
//  TaskCoreData
//
//  Created by Cameron Milliken on 1/30/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    static let sharedInstance = TaskController()
    
    
    // MARK: - CRUD Functions
    let fetchedResultsController: NSFetchedResultsController<Task> = {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "isComplete", ascending: true)]
        request.sortDescriptors = [NSSortDescriptor(key: "due", ascending: true)]
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
    }()
    
    init() {
//        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error in \(#function) :  \(error) \(error.localizedDescription)")
        }
    }
    
    //Create
    func add(taskWithname name: String, notes: String?, due: Date?, isComplete: Bool) {
        Task(name: name, notes: notes, due: due, isComplete: isComplete)
        saveToPersistenceStore()
    }
    
    //Update
    func update(task: Task, name: String, notes: String?, due: Date?) {
        task.name = name
        task.notes = notes
        task.due = due
        saveToPersistenceStore()
    }
    
    
    //Delete
    func remove(task: Task) {
        CoreDataStack.context.delete(task)
        saveToPersistenceStore()
    }
    
    func toggleIsCompleteFor(task: Task) {
        if task.isComplete == false {
            task.isComplete = true
        } else {
            task.isComplete = false
        }
        saveToPersistenceStore()
    }
    
    //Save to persistence
    func saveToPersistenceStore() {
        //        do {
        //            try CoreDataStack.context.save()
        //        } catch {
        //            print("There was an error in \(#function) : \(error.localizedDescription)")
        //        }
        if CoreDataStack.context.hasChanges {
            try? CoreDataStack.context.save()
        }
    }
    
    
    func fetchTasks() -> [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            return try CoreDataStack.context.fetch(request)
        } catch let error {
            print("🤬 Error with fetch request in PlaylistController: \(error.localizedDescription)")
            return []
        }
    }
}//End of class
