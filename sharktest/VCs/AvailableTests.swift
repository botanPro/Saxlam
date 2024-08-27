//
//  AvailableTests.swift
//  sharktest
//
//  Created by Botan Amedi on 23/01/2024.
//

import UIKit
import SKPhotoBrowser
class AvailableTests: UIViewController {
    var PostsArray : [PostObject] = []
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
    var numberOfItemsPerRow: CGFloat = 1
    let spacingBetweenCells: CGFloat = 10
    @IBOutlet weak var PostCollectionView: UICollectionView!
    var IsFooter = false
    var start = 0
    var lab_id = ""
    
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    override func viewDidLoad() {
        super.viewDidLoad()
        PostCollectionView.register(UINib(nibName: "PostsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
        GetMyPosts()
        activityIndicator.hidesWhenStopped = true
        PostCollectionView.addSubview(activityIndicator)
        activityIndicator.center = PostCollectionView.center
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
    }
    
    
    @IBOutlet weak var PostDescView: UIView!
    @IBOutlet weak var PostDescViewBottom: NSLayoutConstraint!
    @IBOutlet weak var PostDesc: UITextView!
    
    @IBAction func DismissDesc(_ sender: Any) {
        self.PostCollectionView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3) {
            self.PostDesc.setContentOffset(.zero, animated: true)
            self.PostDescViewBottom.constant = -500
            self.view.layoutIfNeeded()
        }
    }
    
    
    @objc func OpenVideoLink(_ sender : UIButton){
        if let urlString = sender.accessibilityLabel , let url = URL(string: urlString) {
            // Check if the URL scheme is present
            if url.scheme == nil {
                // If not, assume it's an HTTP link and prepend "http://"
                if let httpURL = URL(string: "http://" + urlString) {
                    UIApplication.shared.open(httpURL, options: [:], completionHandler: nil)
                } else {
                    // Handle invalid URL case
                    print("Invalid URL")
                }
            } else {
                // If the scheme is present, open the URL directly
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            // Handle invalid URL case
            print("Invalid URL")
        }
    }
    
    func GetMyPosts(){
        if CheckInternet.Connection() == true{
            self.PostsArray.removeAll()
            PostObjectApi.GetPostsById(lab_id:self.lab_id) { posts in
                self.activityIndicator.stopAnimating()
                if posts.count == 0{
                    if XLanguage.get() == .English{
                        self.PostCollectionView.setEmptyView(title: "No Available Tests", message: "There are no Available Tests to be shown")
                    }else if XLanguage.get() == .Arabic{
                        self.PostCollectionView.setEmptyView(title: "لا یوجد اختبارات", message: "")
                    }else{
                        self.PostCollectionView.setEmptyView(title: "هیچ پشکنینەک بەردەست نینە", message: "")
                    }
                }else{
                    for post in posts {
                        self.PostsArray.append(post)
                    }
                    self.PostCollectionView.reloadData()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                if self.PostsArray.count == 0{
                    self.PostCollectionView.reloadData()
                    self.activityIndicator.stopAnimating()
                    if XLanguage.get() == .English{
                        self.PostCollectionView.setEmptyView(title: "No Available Tests", message: "There are no Available Tests to be shown")
                    }else if XLanguage.get() == .Arabic{
                        self.PostCollectionView.setEmptyView(title: "لا یوجد اختبارات", message: "")
                    }else{
                        self.PostCollectionView.setEmptyView(title: "هیچ پشکنینەک بەردەست نینە", message: "")
                    }
                }
            })
            
        }
    }
       


}



extension AvailableTests : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if PostsArray.count == 0 {
            return 0
        }else{
            self.PostCollectionView.setEmptyView(title: "", message: "")
            return PostsArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PostsCollectionViewCell
        if self.PostsArray.count != 0{
            cell.PostText.text = self.PostsArray[indexPath.row].desc
            let urlString = self.PostsArray[indexPath.row].post_image
            let url = URL(string: "\(API.PostImages)\(urlString)")
            cell.PostImage?.sd_setImage(with: url, completed: nil)
            
            let urlString1 = self.PostsArray[indexPath.row].profile_image
            let url1 = URL(string: "\(API.Labs)\(urlString1)")
            cell.DImage?.sd_setImage(with: url1, completed: nil)
            
            cell.DTime.isHidden = true
            cell.Dname.text = self.PostsArray[indexPath.row].full_name
            
            cell.delegate = self
            cell.Profile_id = self.PostsArray[indexPath.row].profile_id
            cell.post_id = self.PostsArray[indexPath.row].id
            cell.EditPost.isHidden = true

            print("========")
            print(cell.PostText.countLines())
            
            if cell.PostText.countLines() >= 3 {
                let readmoreFont  = UIFont.systemFont(ofSize: 13.0, weight: .medium)
                    let readmoreFontColor = UIColor.gray
                    DispatchQueue.main.async {
                        cell.action = true
                        cell.post_text = self.PostsArray[indexPath.row].desc
                        if XLanguage.get() == .English{
                            cell.PostText.addTrailing(with: "...", moreText: "more", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
                        }else if XLanguage.get() == .Arabic{
                            cell.PostText.addTrailing(with: "...", moreText: "المزید", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
                        }else{
                            cell.PostText.addTrailing(with: "...", moreText: "زیاتر", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
                        }                    }
            } else {
                cell.action = false
            }

            if self.PostsArray[indexPath.row].video_url != ""{
                cell.LinkHeight.constant = 20
                cell.link.setTitle(self.PostsArray[indexPath.row].video_url, for: .normal)
                cell.link.accessibilityLabel = self.PostsArray[indexPath.row].video_url
                cell.link.addTarget(self, action: #selector(self.OpenVideoLink), for: .touchUpInside)
            }else{
                cell.LinkHeight.constant = 0
                cell.link.setTitle(self.PostsArray[indexPath.row].video_url, for: .normal)
                cell.link.accessibilityLabel = self.PostsArray[indexPath.row].video_url
                cell.link.addTarget(self, action: #selector(self.OpenVideoLink), for: .touchUpInside)
            }
            
            
        }
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.PostsArray[indexPath.row].desc == "" && self.PostsArray[indexPath.row].video_url != ""{
            return CGSize(width: collectionView.frame.size.width, height: 465)
        }else if self.PostsArray[indexPath.row].desc != "" && self.PostsArray[indexPath.row].video_url == ""{
            return CGSize(width: collectionView.frame.size.width, height: 488)
        }else if self.PostsArray[indexPath.row].desc != "" && self.PostsArray[indexPath.row].video_url != ""{
            return CGSize(width: collectionView.frame.size.width, height: 502)
        }
        
        return CGSize(width: collectionView.frame.size.width, height: 460)
        
    }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return sectionInsets
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return spacingBetweenCells
     }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.PostsArray.count != 0  && indexPath.row <= self.PostsArray.count{
            var images = [SKPhoto]()
            let photo = SKPhoto.photoWithImageURL("\(API.PostImages)\(self.PostsArray[indexPath.row].post_image)")
            photo.shouldCachePhotoURLImage = false
            images.append(photo)
        
            let browser = SKPhotoBrowser(photos: images)
            browser.title = self.PostsArray[indexPath.row].desc
            browser.initializePageIndex(indexPath.row)
            present(browser, animated: true, completion: {})
        }
    }
    
    

}




class likesContent{
    var id = ""
    var likes = ""
    
    init(id: String = "", likes: String = "") {
        self.id = id
        self.likes = likes
    }
    
}




extension UILabel {
  func countLines() -> Int {
    guard let myText = self.text as NSString? else {
      return 0
    }
    // Call self.layoutIfNeeded() if your view uses auto layout
    let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
    let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)
    return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
  }
}

extension UITextView {
  func countLines1() -> Int {
    guard let myText = self.text as NSString? else {
      return 0
    }
    // Call self.layoutIfNeeded() if your view uses auto layout
    let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
    let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)
      return Int(ceil(CGFloat(labelSize.height) / (self.font?.lineHeight ?? 1)))
  }
}


extension AvailableTests : ProfileTappedDelegate {
    func didTapReadMore(_ post_text : String,_ post_like: String, _ action : Bool) {
        if action == true{
            self.PostCollectionView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.2) {
                self.PostDescViewBottom.constant = -500
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.3) {
                self.PostDescViewBottom.constant = -30
                self.PostDesc.text = post_text
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    func ProfileTapped(_ product_id : String) {
        if UserDefaults.standard.bool(forKey: "Login") == true{

        }
    }
    
    
}


extension UILabel{
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        
        let readMoreText: String = trailingText + moreText
        
        if self.visibleTextLength == 0 { return }
        
        let lengthForVisibleString: Int = self.visibleTextLength
        
        if let myText = self.text {
            
            let mutableString: String = myText
            
            let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: myText.count - lengthForVisibleString), with: "")
            
            let readMoreLength: Int = (readMoreText.count)
            
            guard let safeTrimmedString = trimmedString else { return }
            
            if safeTrimmedString.count <= readMoreLength { return }
            
            print("this number \(safeTrimmedString.count) should never be less\n")
            print("then this number \(readMoreLength)")
            
            // "safeTrimmedString.count - readMoreLength" should never be less then the readMoreLength because it'll be a negative value and will crash
            let trimmedForReadMore: String = (safeTrimmedString as NSString).replacingCharacters(in: NSRange(location: safeTrimmedString.count - readMoreLength, length: readMoreLength), with: "") + trailingText
            
            let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
            let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
            answerAttributed.append(readMoreAttributed)
            self.attributedText = answerAttributed
        }
    }
    
    var visibleTextLength: Int {
        
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        if let myText = self.text {
            
            let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
            let attributedText = NSAttributedString(string: myText, attributes: attributes as? [NSAttributedString.Key : Any])
            let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
            
            if boundingRect.size.height > labelHeight {
                var index: Int = 0
                var prev: Int = 0
                let characterSet = CharacterSet.whitespacesAndNewlines
                repeat {
                    prev = index
                    if mode == NSLineBreakMode.byCharWrapping {
                        index += 1
                    } else {
                        index = (myText as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: myText.count - index - 1)).location
                    }
                } while index != NSNotFound && index < myText.count && (myText as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
                return prev
            }
        }
        
        if self.text == nil {
            return 0
        } else {
            return self.text!.count
        }
    }
}
