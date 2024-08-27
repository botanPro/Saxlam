//
//  Home.swift
//  sharktest
//
//  Created by Botan Amedi on 22/01/2023.
//

import UIKit
import FSPagerView
import SDWebImage
import CRRefresh
import Drops
import SKPhotoBrowser
import FirebaseMessaging
class Home: UIViewController {

    var PostsArray : [PostObject] = []
    @IBOutlet weak var PostCollectionView: UICollectionView!
    var IsFooter = false
    var start = 0
    
    let sectionInsets1 = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 100.0, right: 0.0)
    var numberOfItemsPerRow1: CGFloat = 1
    let spacingBetweenCells1: CGFloat = 10
    
    
    @IBOutlet weak var LaborCollectionView: UICollectionView!
    @IBOutlet weak var SlideView: UIView!
    @IBOutlet weak var SearchView: UIView!
    @IBOutlet weak var Name: UILabel!
    var sliderImages : [SlideObject] = []
    var LaborArray : [LabsObject] = []
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var SliderView: FSPagerView!{
        didSet{
            self.SliderView.layer.masksToBounds = true
            self.SliderView.layer.cornerRadius = 10
            self.SliderView.automaticSlidingInterval = 4.0
            self.SliderView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.SliderView.transformer = FSPagerViewTransformer(type: .crossFading)
            self.SliderView.itemSize = FSPagerView.automaticSize
            self.GetSliderImages()
        }
    }
    
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 22.0, bottom: 0.0, right: 22.0)
    let spacingBetweenCells: CGFloat = 11

    

    @IBAction func soon(_ sender: Any) {
        Drops.hideAll()
        var mss = "Coming Soon"
        if XLanguage.get() == .English{
            mss = "Coming Soon"
        }
        
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
    @IBOutlet weak var LaborLable: UILabel!
    @IBOutlet weak var CategoryView: UIView!
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if CheckInternet.Connection() != true{
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
            self.activityIndicator.stopAnimating()
            Drops.hideAll()
            
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
        
        
        
        
        PostCollectionView.register(UINib(nibName: "PostsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        LaborCollectionView.register(UINib(nibName: "LabsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.SearchView.layer.masksToBounds = false
        self.SearchView.layer.shadowColor = UIColor.lightGray.cgColor
        self.SearchView.layer.shadowOpacity = 0.2
        self.SearchView.layer.shadowOffset = .zero
        self.SearchView.layer.shadowRadius = 6
        self.SearchView.layer.shouldRasterize = true
        self.SearchView.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        self.SearchView.layer.cornerRadius = 16
        self.SlideView.layer.cornerRadius = 10
        GetLAbs()
        self.ScrollView.cr.addHeadRefresh(animator: FastAnimator()) {
            self.GetSliderImages()
            self.GetLAbs()
        }
        
        self.IsFooter = false
        self.start = 0
        self.GetPosts(start : self.start,limit : 10)
        
        self.ScrollView.cr.addHeadRefresh(animator: FastAnimator()) {
            self.start = 0
            self.IsFooter = false
            self.GetPosts(start : self.start,limit : 10)
        }
        
        self.ScrollView.cr.addFootRefresh(animator: FastAnimator()) {
            self.IsFooter = true
            self.start += 10
            self.GetPosts(start : self.start,limit : 10)
        }
        
        if XLanguage.get() == .English{
            self.Name.text = "Hello!, \(UserDefaults.standard.string(forKey: "name") ?? "")"
        }else if XLanguage.get() == .Arabic{
            self.Name.text = "!مرحبًا, \(UserDefaults.standard.string(forKey: "name") ?? "")"
        }else{
            self.Name.text = "!سلاڤ, \(UserDefaults.standard.string(forKey: "name") ?? "")"
        }
        
        
        PostDescView.layer.masksToBounds = false
        PostDescView.layer.shadowOffset = .zero
        PostDescView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        PostDescView.layer.shadowRadius = 25
        PostDescView.layer.shadowOpacity = 0.6
        
        
        activityIndicator.hidesWhenStopped = true
        ScrollView.addSubview(activityIndicator)
        activityIndicator.center = ScrollView.center
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        
        
        self.SearchView.isHidden = true
        self.SliderView.isHidden = true
        self.LaborCollectionView.isHidden = true
        self.LaborLable.isHidden = true
        self.CategoryView.isHidden = true
        
        
        
        
        if UserDefaults.standard.bool(forKey: "Login") == true{
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("Error fetching FCM registration token: \(error)")
                } else if let token = token {
                    print("FCM registration token: \(token)")
                    UpdateNotificationIdAPI.Update(UUID: token, userId: UserDefaults.standard.string(forKey: "id") ?? "")
                }
            }
        }
        
        

    }
    
    
    
    @IBOutlet weak var PostCollectionViewHeight: NSLayoutConstraint!
    
    
    func GetPosts(start : Int,limit : Int){
        if CheckInternet.Connection() == true{
            if self.IsFooter == false{
                self.PostsArray.removeAll()
                PostObjectApi.GetPosts(UserId: UserDefaults.standard.string(forKey: "id") ?? "", Start: start, Limit: limit) { posts in
                    for post in posts {
                        self.PostsArray.append(post)
                        self.ScrollView.cr.endHeaderRefresh()
                        let height = self.PostCollectionView.collectionViewLayout.collectionViewContentSize.height
                        self.PostCollectionViewHeight.constant = height
                        self.PostCollectionView.reloadData()
                    }
                }
            }else{
                PostObjectApi.GetPosts(UserId: UserDefaults.standard.string(forKey: "id") ?? "", Start: start, Limit: limit) { posts in
                    self.ScrollView.cr.endLoadingMore()
                    for post in posts {
                        self.PostsArray.append(post)
                        let height = self.PostCollectionView.collectionViewLayout.collectionViewContentSize.height
                        self.PostCollectionViewHeight.constant = height
                        self.PostCollectionView.reloadData()
                    }
                }
            }
        }else{
            self.activityIndicator.stopAnimating()
        }
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
    
    
    @IBAction func GoToNotification(_ sender: Any) {
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let height = self.PostCollectionView.collectionViewLayout.collectionViewContentSize.height
                self.PostCollectionViewHeight.constant = height
                self.view.layoutIfNeeded()
            }
    }
    
    
    
        func GetSliderImages(){
            if CheckInternet.Connection() == true{
                self.sliderImages.removeAll()
                SlideAPI.GetSlides { Slide in
                    self.activityIndicator.stopAnimating()
                    self.sliderImages = Slide
                    self.SliderView.reloadData()
                    self.ScrollView.cr.endHeaderRefresh()
                    
                    
                    self.SearchView.isHidden = false
                    self.SliderView.isHidden = false
                    self.LaborCollectionView.isHidden = false
                    self.LaborLable.isHidden = false
                    self.CategoryView.isHidden = false
                }
            }else{
                self.activityIndicator.stopAnimating()
            }
            
        }
    
    
    func GetLAbs(){
        if CheckInternet.Connection() == true{
            self.LaborArray.removeAll()
            LabsObjectAPI.GetLAbs { Labs,error  in
                if error == ""{
                    self.activityIndicator.stopAnimating()
                    self.LaborArray = Labs
                    self.LaborCollectionView.reloadData()
                    self.ScrollView.cr.endHeaderRefresh()
                    
                    
                    self.SearchView.isHidden = false
                    self.SliderView.isHidden = false
                    self.LaborCollectionView.isHidden = false
                    self.LaborLable.isHidden = false
                    self.CategoryView.isHidden = false
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
                    vc.modalPresentationStyle = .fullScreen
                    //vc.DimissImage.isHidden = true
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true)
                }
            }
        }else{
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    
}





extension Home : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == LaborCollectionView{
            if LaborArray.count == 0 {
                return 0
            }else{
                return LaborArray.count
            }
        }else{
            if PostsArray.count == 0 {
                return 0
            }else{
                return PostsArray.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == LaborCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LabsCollectionViewCell
            cell.Name.text = LaborArray[indexPath.row].title
            cell.Location.text = LaborArray[indexPath.row].address
            cell.hour.text = LaborArray[indexPath.row].open_hour
            cell.Week.text = LaborArray[indexPath.row].open_week
            
            let urlString = "\(API.Labs)\(LaborArray[indexPath.row].logo)"
            let url = URL(string: urlString)
            cell.Imagee?.sd_setImage(with: url, completed: nil)
            
            return cell
        }else{
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
                            }
                        }
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
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == LaborCollectionView{
            return CGSize(width: collectionView.bounds.width / 1.13, height: 150)
        }else{
            if self.PostsArray[indexPath.row].desc == "" && self.PostsArray[indexPath.row].video_url != ""{
                return CGSize(width: collectionView.frame.size.width, height: 465)
            }else if self.PostsArray[indexPath.row].desc != "" && self.PostsArray[indexPath.row].video_url == ""{
                return CGSize(width: collectionView.frame.size.width, height: 488)
            }else if self.PostsArray[indexPath.row].desc != "" && self.PostsArray[indexPath.row].video_url != ""{
                return CGSize(width: collectionView.frame.size.width, height: 502)
            }
            return CGSize(width: collectionView.frame.size.width, height: 460)
        }

     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         if collectionView == LaborCollectionView{
             return sectionInsets
         }else{
             return sectionInsets1
         }
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         if collectionView == LaborCollectionView{
             return spacingBetweenCells
         }else{
             return spacingBetweenCells1
         }
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == LaborCollectionView{
            if self.LaborArray.count != 0  && indexPath.row <= self.LaborArray.count{
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let LaborDetails = storyboard.instantiateViewController(withIdentifier: "LaborDetails") as! LaborDetails
                LaborDetails.modalPresentationStyle = .fullScreen
                LaborDetails.lab_id = self.LaborArray[indexPath.row].id
                self.present(LaborDetails, animated: true, completion: nil)
            }
        }else{
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
    

}



extension Home: FSPagerViewDataSource,FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if sliderImages.count == 0{
            return 0
        }
        return sliderImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        if sliderImages.count != 0{
            let urlString = "\(API.SliderImages)\(sliderImages[index].image)"
            print(urlString)
            let url = URL(string: urlString )
        cell.imageView?.sd_setImage(with: url, completed: nil)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.imageView?.layer.cornerRadius = 10
        }
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if sliderImages.count != 0{
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
            
            if let url = NSURL(string: sliderImages[index].link ){
                UIApplication.shared.open(url as URL)
            }
        }
    }

}








class UpwardsBlurEdge: UIVisualEffectView {
    
    lazy var grad: CAGradientLayer = {
        let g = CAGradientLayer()
        g.colors = [
            UIColor.white.cgColor,
            UIColor.clear.cgColor
        ]
        g.startPoint = CGPoint(x: 0.5, y: 1)
        g.endPoint = CGPoint(x: 0.5, y: 0)
        layer.mask = g
        return g
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grad.frame = bounds
    }
}


class UpwardsBlurEdge2: UIVisualEffectView {
    
    lazy var grad: CAGradientLayer = {
        let g = CAGradientLayer()
        g.colors = [
            UIColor.white.cgColor,
            UIColor.clear.cgColor
        ]
        g.startPoint = CGPoint(x: 0.5, y: 0)
        g.endPoint = CGPoint(x: 0.5, y: 1)
        layer.mask = g
        return g
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grad.frame = bounds
    }
}


extension Home : ProfileTappedDelegate {
    func didTapReadMore(_ post_text : String,_ post_like: String, _ action : Bool) {
        if action == true{
            self.PostCollectionView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.2) {
                self.PostDescViewBottom.constant = -500
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.3) {
                self.PostDescViewBottom.constant = 0
                self.PostDesc.text = post_text
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    
    
    func ProfileTapped(_ product_id : String) {
        if UserDefaults.standard.bool(forKey: "Login") == true{
            if UserDefaults.standard.string(forKey: "Status") != "0"{
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let LaborDetails = storyboard.instantiateViewController(withIdentifier: "LaborDetails") as! LaborDetails
                LaborDetails.modalPresentationStyle = .fullScreen
                LaborDetails.lab_id = product_id
                self.present(LaborDetails, animated: true, completion: nil)
            }
        }
    }
    
    
}
