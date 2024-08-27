//
//  MyPosts.swift
//  sharktest
//
//  Created by Botan Amedi on 24/01/2024.
//

import UIKit
import SKPhotoBrowser
import Drops
class MyPosts: UIViewController {

    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
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
        
        override func viewDidLoad() {
            super.viewDidLoad()
            PostCollectionView.register(UINib(nibName: "PostsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
            GetMyPosts()
            
            
            activityIndicator.hidesWhenStopped = true
            PostCollectionView.addSubview(activityIndicator)
            activityIndicator.center = PostCollectionView.center
            activityIndicator.color = .gray
            activityIndicator.startAnimating()
        }
        
        
    func GetMyPosts(){
        if CheckInternet.Connection() == true{
            self.PostsArray.removeAll()
            PostObjectApi.GetPostsById(lab_id:UserDefaults.standard.string(forKey: "my_lab_id") ?? "") { posts in
                for post in posts {
                    self.PostsArray.append(post)
                }
                self.PostCollectionView.reloadData()
                
                if posts.count == 0 {
                    self.dismiss(animated: true)
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
    
    
    
    @objc func EditPost(_ sender : UIButton){
        var Deleteaction = ""
        var Editaction = ""
        var Cancelaction = ""
        if XLanguage.get() == .English{
            Deleteaction = "Delete Post"
            Editaction = "Edit Post"
            Cancelaction = "Cancel"
        }else if XLanguage.get() == .Arabic{
            Deleteaction = "حذف المنشور"
            Editaction = "تعديل المنشور"
            Cancelaction = "إلغاء"
        }else if XLanguage.get() == .Kurdish{
            Deleteaction = "ژێبرنا پوستی"
            Editaction = "دەستکاریکرنا پوستی"
            Cancelaction = "دەرکەتن"
        }
        let myAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        myAlert.addAction(UIAlertAction(title: Deleteaction, style: UIAlertAction.Style.default, handler: { _ in
            self.DeletePost(PostId: sender.accessibilityIdentifier ?? "")
        }))
        myAlert.addAction(UIAlertAction(title: Editaction, style: UIAlertAction.Style.default, handler: {_ in
            self.EditPostt(PostId: sender.accessibilityIdentifier ?? "")
        }))
        myAlert.addAction(UIAlertAction(title: Cancelaction, style: UIAlertAction.Style.cancel, handler: nil))
        self.present(myAlert, animated: true, completion: nil)
    }
    
    
    var alert = UIAlertController()
    var loadingLableMessage = ""
    func LoadingView(){
        alert = UIAlertController(title: nil, message: self.loadingLableMessage, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func DeletePost(PostId : String){
        if CheckInternet.Connection() == true{
            var mss = ""
            var action = ""
            var Cancelaction = ""
            
            if XLanguage.get() == .English{
                mss = "Delete Post?"
                action = "Delete"
                Cancelaction = "No"
            }else if XLanguage.get() == . Arabic{
                mss = "الحذف؟"
                action = "حذف"
                Cancelaction = "لا"
            }else{
                mss = "ژێبرن؟"
                action = "ژێبرن"
                Cancelaction = "نەخێر"
            }
            let myAlert = UIAlertController(title: mss, message: nil, preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(UIAlertAction(title: action, style: UIAlertAction.Style.default, handler: { _ in
                if XLanguage.get() == .English{
                    self.loadingLableMessage = "Please wait..."
                    self.LoadingView()
                }
                PostObjectApi.DeletePost(PostId: PostId) { Done in
                    self.alert.dismiss(animated: true, completion: nil)
                    self.GetMyPosts()
                }
            }))
            
            myAlert.addAction(UIAlertAction(title: Cancelaction, style: UIAlertAction.Style.cancel, handler: nil))
            self.present(myAlert, animated: true, completion: nil)
        }else{
            var mss = ""
            var action = ""
            if XLanguage.get() == .English{
                mss = "No internet conection"
                action = "Ok"
            }else if XLanguage.get() == .Kurdish{
                mss = "هێلا ئینترنێتێ نینە"
                action = "باشە"
            }else{
                mss = "لا يوجد اتصال بالإنترنت"
                action = "حسنا"
            }
    
    Drops.hideAll()
            self.activityIndicator.stopAnimating()
    let drop = Drop(
        title: "",
        subtitle: mss,
        icon: nil,
        action: .init {
            print("Drop tapped")
            Drops.hideCurrent()
        },
        position: .top,
        duration: 3.0,
        accessibility: "Alert: Title, Subtitle"
    )
    Drops.show(drop)
    
        }
    }
    
    
    var SelectedPostForEdit : PostObject!
    func EditPostt(PostId : String){
        for post in self.PostsArray{
            if PostId == post.id {
                self.SelectedPostForEdit = post
            }
        }
        if self.SelectedPostForEdit != nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "CreatePost") as! CreatePost
            myVC.IsUpdating = true
            myVC.ComingPostId = SelectedPostForEdit.id
            myVC.ComingPostDesc = SelectedPostForEdit.desc
            myVC.ComingPostImage = SelectedPostForEdit.post_image
            myVC.CommingVideoURL = SelectedPostForEdit.video_url
            myVC.modalPresentationStyle = .fullScreen
            self.present(myVC, animated: true)
        }
    }

    
        


    }



    extension MyPosts : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
        
        
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
                //cell.EditPost.isHidden = true
                cell.EditPost.accessibilityIdentifier = self.PostsArray[indexPath.row].id
                cell.EditPost.addTarget(self, action: #selector(self.EditPost), for: .touchUpInside)

                print("========")
                print(cell.PostText.countLines())
                
                if cell.PostText.countLines() >= 3 {
                    let readmoreFont  = UIFont.systemFont(ofSize: 13.0, weight: .medium)
                        let readmoreFontColor = UIColor.gray
                        DispatchQueue.main.async {
                            cell.action = false
                            cell.post_text = self.PostsArray[indexPath.row].desc
                        }
                } else {
                    cell.action = false
                }
                cell.link.setTitle(self.PostsArray[indexPath.row].video_url, for: .normal)
              
                
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




    extension MyPosts : ProfileTappedDelegate {
        func didTapReadMore(_ post_text : String,_ post_like: String, _ action : Bool) {

        }
        
        
        func ProfileTapped(_ product_id : String) {

        }
        
        
    }

