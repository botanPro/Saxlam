//
//  SocialCollectionviewCell.swift
//  sharktest
//
//  Created by Botan Amedi on 11/02/2024.
//

import UIKit

class SocialCollectionviewCell: UICollectionViewCell {

    @IBOutlet weak var Image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        Image.layer.cornerRadius = Image.bounds.width / 2
        Image.layer.shadowColor = UIColor.black.cgColor
        Image.layer.shadowOpacity = 0.2
        Image.layer.shadowOffset = CGSize(width: 0, height: 1)
        Image.layer.shadowRadius = 1
        Image.layer.masksToBounds = false
    }

}
