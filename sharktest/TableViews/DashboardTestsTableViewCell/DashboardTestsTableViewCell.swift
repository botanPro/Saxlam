//
//  DashboardTestsTableViewCell.swift
//  sharktest
//
//  Created by Botan Amedi on 17/02/2024.
//

import UIKit

class DashboardTestsTableViewCell: UITableViewCell {
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Category: UILabel!
    
    @IBOutlet weak var Price2: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var Discount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
