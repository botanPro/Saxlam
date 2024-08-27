//
//  TestResultsTableViewCell.swift
//  sharktest
//
//  Created by Botan Amedi on 26/07/2023.
//

import UIKit

class TestResultsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Share: UIButton!
    @IBOutlet weak var FullName: UILabel!
    @IBOutlet weak var Timer: UIImageView!
    @IBOutlet weak var BackView: UIView!
    @IBOutlet weak var InvDate: UILabel!
    @IBOutlet weak var invoicNum: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
