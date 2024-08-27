//
//  LabsCollectionViewCell.swift
//  sharktest
//
//  Created by Botan Amedi on 11/12/2022.
//

import UIKit

class LabsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var BackImagee: UIImageView!
    @IBOutlet weak var Imagee: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var Week: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backView.layer.cornerRadius = 10
    }

    
}
