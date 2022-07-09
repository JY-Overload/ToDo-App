//
//  taskCell.swift
//  ToDoApp
//
//  Created by James Yu on 1/2/21.
//

import UIKit

class taskCell: UITableViewCell {
    

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDueTime: UILabel!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var markImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}

