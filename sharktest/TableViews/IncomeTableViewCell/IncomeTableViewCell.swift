//
//  IncomeTableViewCell.swift
//  sharktest
//
//  Created by Botan Amedi on 30/01/2024.
//

import UIKit

class IncomeTableViewCell: UITableViewCell {
    @IBOutlet weak var InvDate: UILabel!
    @IBOutlet weak var invoicNum: UILabel!
    
    @IBOutlet weak var Remain: UILabel!
    @IBOutlet weak var Cash: UILabel!
    @IBOutlet weak var Total: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
