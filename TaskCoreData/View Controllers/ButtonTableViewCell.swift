//
//  ButtonTableViewCell.swift
//  TaskCoreData
//
//  Created by Cameron Milliken on 1/30/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate: class {
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell)
}

class ButtonTableViewCell: UITableViewCell {
    
    weak var delegate: ButtonTableViewCellDelegate?
    
    @IBOutlet weak var primaryLabel: UILabel!
    
    @IBOutlet weak var completeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func completeButtonTapped(_ sender: Any) {
        if let delegate = delegate{
            delegate.buttonCellButtonTapped(self)
        }
    }
    
    func updateButton(_ isComplete: Bool) {
        
        let completeImage = UIImage(named: "checked")
        let incompleteImage = UIImage(named: "empty")
        if isComplete == true {
            completeButton.setImage(completeImage, for: .normal)
            
        } else {
            completeButton.setImage(incompleteImage, for: .normal)
            
        }
    }
    
}

extension ButtonTableViewCell {
    func update(withTask task: Task) {
        primaryLabel.text = task.name
        updateButton(task.isComplete)
    }
}

