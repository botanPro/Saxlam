//
//  CreatePostVc.swift
//  sharktest
//
//  Created by Botan Amedi on 23/01/2024.
//

import UIKit
import BSImagePicker
import Photos
import Alamofire
import SwiftyJSON
import Drops

class CreatePost: UIViewController , UITextViewDelegate,UITextFieldDelegate{
    @IBOutlet weak var PlaceHOlder: UITextView!
    @IBOutlet weak var TextMess: UITextView!
    @IBOutlet weak var TextViewheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ProfileName: UILabel!
    @IBOutlet weak var PostImage: UIImageView!
    let minTextViewHeight: CGFloat = 33
    let maxTextViewHeight: CGFloat = 4000
    @IBOutlet weak var Video_Link: TextField!
    
    var ComingPostId = ""
    var ComingPostDesc = ""
    var ComingPostImage = ""
    var CommingVideoURL = ""
    var IsUpdating = false
    @IBAction func Dimiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.PlaceHOlder.isHidden = true
        
        if textView.text == ""{
            self.PlaceHOlder.isHidden = false
        }
        
        var height = textView.contentSize.height // ceil to avoid decimal
        
        if (height < minTextViewHeight + 5) { // min cap, + 5 to avoid tiny height difference at min height
            height = minTextViewHeight
        }
        if (height > maxTextViewHeight) { // max cap
            height = maxTextViewHeight
        }
        
        if height != TextViewheightConstraint.constant { print("[[[[")// set when height changed
            TextViewheightConstraint.constant = height // change the value of NSLayoutConstraint
            self.view.layoutIfNeeded()
            textView.setContentOffset(.zero, animated: false) // scroll to top to avoid "wrong contentOffset" artefact when line count changes
        }
      
    }
    
    
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.paste(_:)) ?
            false : super.canPerformAction(action, withSender: sender)
    }
    
    
    
    @IBOutlet weak var AlbumView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if XLanguage.get() == .English{
            self.PlaceHOlder.text = "Post available tests here"
        }else if XLanguage.get() == .Arabic{
            self.PlaceHOlder.text = "قم بنشر الاختبارات المتاحة هنا"
        }else{
            self.PlaceHOlder.text = "پشکنینێن بەردەست ل ڤێرێرێ بەلاڤ بکە"
        }
        
        self.Video_Link.delegate = self
        self.Video_Link.allowsEditingTextAttributes = true
        
        self.TextMess.delegate = self
        self.TextMess.backgroundColor = .clear
        self.ProfileName.text = ""
        ProfileDataAPI.GetProfileData(id: UserDefaults.standard.string(forKey: "id") ?? "") { data,error  in
            self.ProfileName.text = data.full_name
        }
        
        if self.IsUpdating == true{
            self.AlbumView.isUserInteractionEnabled = false
            self.AlbumView.alpha = 0.4
            self.Video_Link.text = self.CommingVideoURL
            if self.ComingPostDesc == ""{
                
                if XLanguage.get() == .English{
                    self.PlaceHOlder.text = "Post available tests here"
                }else if XLanguage.get() == .Arabic{
                    self.PlaceHOlder.text = "قم بنشر الاختبارات المتاحة هنا"
                }else{
                    self.PlaceHOlder.text = "پشکنینێن بەردەست ل ڤێرێرێ بەلاڤ بکە"
                }
            }else{
                self.PlaceHOlder.text = ""
                self.TextMess.text = self.ComingPostDesc
            }
            let url = URL(string: "\(API.PostImages)\(ComingPostImage)")
            self.PostImage?.sd_setImage(with: url, completed: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                if self.ComingPostDesc != ""{
                    self.TextMess.insertText(" ")
                }
            })
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHiden), name: UIResponder.keyboardWillHideNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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

    
    @IBOutlet weak var ScrollViewLayout: NSLayoutConstraint!
    var count = 1
    @objc func keyboardWasShown(notification: NSNotification) {
        if count == 1{
            count += 1
            let info = notification.userInfo!
            let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            self.ScrollViewLayout.constant = keyboardFrame.height - 100
        }
    }
    
    @objc func keyboardWasHiden(notification: NSNotification) {
        self.count = 1
        self.ScrollViewLayout.constant = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
       // MARK: - URL Validation
       
    func isValidURL(_ urlString: String) -> Bool {
        // Use a permissive regular expression to validate the URL
        let urlRegex = #"^(http(s)?://)?([\w-]+\.+[\w-]+)+.*"#
        let urlTest = NSPredicate(format: "SELF MATCHES %@", urlRegex)
        return urlTest.evaluate(with: urlString)
    }
    
    func showAlert(message: String) {
           let alertController = UIAlertController(
               title: "Invalid URL",
               message: message,
               preferredStyle: .alert
           )
           let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           alertController.addAction(okAction)

           present(alertController, animated: true, completion: nil)
       }

    @IBAction func Post(_ sender: Any) {
        if CheckInternet.Connection() == true{
            if self.IsUpdating == false{
                if UserDefaults.standard.bool(forKey: "Login") == true{
                    if self.Images.count != 0{
                       
                        if self.Video_Link.text != ""{
                            if self.isValidURL(self.Video_Link.text!) == false{
                                    self.showAlert(message: "Invalid URL format. Please enter a valid URL.")
                                return
                            }
                        }
                        
                        if XLanguage.get() == .English{
                            self.loadingLableMessage = "Please wait..."
                            self.LoadingView()
                        }else if XLanguage.get() == . Arabic{
                            self.loadingLableMessage = "يرجى الانتظار..."
                            self.LoadingView()
                        }else{
                            self.loadingLableMessage = "هیڤیە چاڤەرێبە..."
                            self.LoadingView()
                        }
                        uploadPostImage(image: self.Images[0]) { imageString in
                            
                            PostObjectApi.AddPost(UserId: UserDefaults.standard.string(forKey: "my_lab_id") ?? "", Desc: self.TextMess.text!,Image: imageString,video_url: self.Video_Link.text!) { Done in
                                self.alert.dismiss(animated: true, completion: {
                                    var mss = ""
                                    if XLanguage.get() == .English{
                                        mss = "Post added"
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
                                    self.dismiss(animated: true)
                                })
                                   
                            }
                        }
                    }else{
                        self.alert.dismiss(animated: true, completion: {
                            if self.Images.count == 0{
                                var mss = ""
                                var action = ""
                                if XLanguage.get() == .English{
                                    mss = "Please Select Image"
                                    action = "Ok"
                                }else if XLanguage.get() == .Arabic{
                                    mss = "تکایە وێنە هەڵبژێرە"
                                    action = "حسنا"
                                }else{
                                    mss = "هیڤیە وێنەکی هەلبژێرە"
                                    action = "باشە"
                                }
                                let myAlert = UIAlertController(title: nil, message: mss, preferredStyle: UIAlertController.Style.alert)
                                myAlert.addAction(UIAlertAction(title: action, style: UIAlertAction.Style.default, handler: nil))
                                self.present(myAlert, animated: true, completion: nil)
                            }
                        })
                        
                    }
                }else{
                    self.alert.dismiss(animated: true, completion: nil)
                }
            }else{
                if UserDefaults.standard.bool(forKey: "Login") == true{
                        if self.Video_Link.text != ""{
                            if self.isValidURL(self.Video_Link.text!) == false{
                                    self.showAlert(message: "Invalid URL format. Please enter a valid URL.")
                                return
                            }
                        }
                    if XLanguage.get() == .English{
                        self.loadingLableMessage = "Please wait..."
                        self.LoadingView()
                    }else if XLanguage.get() == . Arabic{
                        self.loadingLableMessage = "يرجى الانتظار..."
                        self.LoadingView()
                    }else{
                        self.loadingLableMessage = "هیڤیە چاڤەرێبە..."
                        self.LoadingView()
                    }
                        
                        PostObjectApi.UpdatePost(PostId: self.ComingPostId, Desc: self.TextMess.text!,video_url: self.Video_Link.text!) { Done in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                self.alert.dismiss(animated: true, completion: {
                                    var mss = ""
                                    if XLanguage.get() == .English{
                                        mss = "Post updated"
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
                                    self.dismiss(animated: true)
                                })
                                
                            })
                        }
                    
                }else{
                    self.alert.dismiss(animated: true, completion: {
                    })
                    
                }
          }
        
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
    
    
    var SelectedAssets = [PHAsset]()
    @IBAction func ShowAlbum(_ sender: Any) {
        self.SelectedAssets.removeAll()
        let vc = BSImagePickerViewController()
        bs_presentImagePickerController(vc, animated: true,
           select: { (asset: PHAsset) -> Void in
        }, deselect: { (asset: PHAsset) -> Void in
        }, cancel: { (assets: [PHAsset]) -> Void in
        }, finish: { (assets: [PHAsset]) -> Void in
            print(assets)
            for i in 0..<assets.count{
                self.SelectedAssets.append(assets[i])
            }
            
            self.getAllImages()
        }, completion: nil)
    }
    
    var Images : [UIImage] = []
    func getAllImages() -> Void {
        for i in 0..<SelectedAssets.count{
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var thumbnail = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 512, height: 512), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                thumbnail = result!
            })
            self.Images.removeAll()
            self.Images.append(thumbnail)
            self.PostImage.image = thumbnail
        }
        
    }
    

    
    
    func uploadPostImage(image: UIImage,completion : @escaping (_ Done : String)->()){
        let stringUrl = URL(string: API.URL)
        let username = openCartApi.UserName
        let password = openCartApi.key
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers: HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]

        // Image data
        let image = image // Replace with your image
        let imageData = image.jpegData(compressionQuality: 0.5) // Adjust compression quality as needed

        // Define your parameters
        let param: [String: Any] = [
            "fun": "upload_post_img"
        ]

        AF.upload(multipartFormData: { multipartFormData in
            // Add image data
            if let imageData = imageData {
                multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            }
            
            // Add other parameters
            for (key, value) in param {
                if let data = "\(value)".data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
        }, to: stringUrl!, method: .post, headers: headers)
        .responseData { response in
            switch response.result {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                completion(jsonData["image"].string ?? "")
                //completion(jsonData["insert"].string ?? "")
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
