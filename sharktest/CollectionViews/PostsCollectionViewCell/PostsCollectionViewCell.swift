//
//  PostsCollectionViewCell.swift
//  Etisal RX
//
//  Created by Botan Amedi on 02/10/2023.
//

import UIKit


protocol ProfileTappedDelegate: AnyObject {
    func ProfileTapped(_ Profile_id : String)
    func Like(_ post_id : String,_ like_icon : UIImageView)
    func didTapReadMore(_ post_text : String,_ post_like : String,_ action : Bool)
  }

class PostsCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    weak var delegate : ProfileTappedDelegate?
    @IBOutlet weak var DImage: UIImageView!
    @IBOutlet weak var DTime: UILabel!
    @IBOutlet weak var Dname: UILabel!
    @IBOutlet weak var PostImage: UIImageView!
    @IBOutlet weak var PostText: UILabel!
    @IBOutlet weak var EditPost: UIButton!
    @IBOutlet weak var Likes: UILabel!
    @IBOutlet weak var Like: UIImageView!
    @IBOutlet weak var Save: UIButton!

    @IBOutlet weak var link: UIButton!
    @IBOutlet weak var ProfileView: UIStackView!
    @IBOutlet weak var LikeButton: UIStackView!
    
    @IBOutlet weak var LinkHeight: NSLayoutConstraint!
    var Profile_id = ""
    var post_id = ""
    var like_button_action : UIImageView!
    var post_like = ""
    var post_text = ""
    var action = false
    
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        PostText.numberOfLines = 2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        tapGesture.delegate = self
        ProfileView.isUserInteractionEnabled = true
        ProfileView.addGestureRecognizer(tapGesture)
        
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(LikeButton(recognizer:)))
        tapGesture1.delegate = self
        LikeButton.isUserInteractionEnabled = true
        LikeButton.addGestureRecognizer(tapGesture1)
            
            
            let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(readMoreLabelTapped(recognizer:)))
            tapGesture2.delegate = self
            PostText.isUserInteractionEnabled = true
            PostText.addGestureRecognizer(tapGesture2)
    }
    

    @objc func handleTap(recognizer:UITapGestureRecognizer) {
        self.delegate?.ProfileTapped(Profile_id)
    }
    
    @objc func LikeButton(recognizer:UITapGestureRecognizer) {
        self.delegate?.Like(post_id, like_button_action)
    }

    @objc private func readMoreLabelTapped(recognizer:UITapGestureRecognizer) {
            delegate?.didTapReadMore(post_text, post_like, action)
    }
    
}
