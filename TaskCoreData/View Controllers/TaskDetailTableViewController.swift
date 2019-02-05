//
//  TaskDetailTableViewController.swift
//  TaskCoreData
//
//  Created by Cameron Milliken on 1/30/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit
import CoreData

class TaskDetailTableViewController: UITableViewController {
    
    var task: Task?
    var dueDateValue: Date?


    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dueTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextView!
    @IBOutlet var dueDatePicker: UIDatePicker!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dueTextField.inputView = dueDatePicker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userTappedView))
        view.addGestureRecognizer(tapGesture)
        updateViews()

    }
    
    func updateViews() {
        guard let task = task, isViewLoaded else { return }
        title = task.name
        nameTextField.text = task.name
        noteTextField.text = task.notes
        dueTextField.text = task.due?.stringValue()
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text,
            let notes = noteTextField.text,
            let date = dueDateValue
            else { return }
        let isComplete: Bool = false
        
        if let task = task {
            TaskController.sharedInstance.update(task: task, name: name, notes: notes, due: date)
        } else {
            TaskController.sharedInstance.add(taskWithname: name, notes: notes, due: date, isComplete: isComplete)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        dueDateValue = dueDatePicker.date
        dueTextField.text = dueDatePicker.date.stringValue()
    }
    
    @IBAction func userTappedView(_ sender: Any) {
        nameTextField.resignFirstResponder()
        dueTextField.resignFirstResponder()
        noteTextField.resignFirstResponder()
    }

}
