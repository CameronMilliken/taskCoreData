//
//  Task+Convenience.swift
//  TaskCoreData
//
//  Created by Cameron Milliken on 1/30/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import Foundation
import CoreData

extension Task {
    @discardableResult
    convenience init(name: String, notes: String?, due: Date?, isComplete: Bool, moc: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: moc)
        self.name = name
        self.notes = notes
        self.due = due
        self.isComplete = isComplete
        
        //notes and due were not included becasue they are optional.
    }
}

