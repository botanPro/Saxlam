//
//  Profile.swift
//  sharktest
//
//  Created by Botan Amedi on 22/01/2023.
//

import UIKit
import Firebase
import FirebaseAuth
import Drops

class Profile: UIViewController ,UIPickerViewDelegate , UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.numberOfLines = 0
            pickerLabel?.font = UIFont(name: "Helvetica-Bold", size: 10)
            pickerLabel?.textAlignment = .center
        }
        
        pickerLabel?.text = self.languages[row].language

        return pickerLabel!
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 30
    }
    
    
    
    
    @IBAction func CallShark(_ sender : Any){
            if let url = URL(string: "tel://+9647514505411") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
    }
    
    @IBAction func WebShark(_ sender : Any){
            if let url = URL(string: "http://shark-team.com") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
    }
    
    
    var selectedLanguage :languagesObject?
    var languages : [languagesObject] = []
    
    @IBOutlet weak var RadiuViews: UIView!
    @IBOutlet weak var RadiuViews0: UIView!
    @IBOutlet weak var RadiuViews1: UIView!
    @IBOutlet weak var RadiuViews2: UIView!
    @IBOutlet weak var RadiuViews3: UIView!
    @IBOutlet weak var RadiuViews4: UIView!
    
    @IBOutlet weak var LangLable: UILabel!
    @IBOutlet weak var RadiuArrow: UIView!
    @IBOutlet weak var RadiuArrow0: UIView!
    @IBOutlet weak var RadiuArrow1: UIView!
    @IBOutlet weak var RadiuArrow2: UIView!
    @IBOutlet weak var RadiuArrow3: UIView!
    @IBOutlet weak var RadiuArrow4: UIView!
    @IBOutlet weak var LogInLable: UILabel!
    
    @IBOutlet weak var MyPostsStack: UIStackView!
    @IBOutlet weak var EditProfileStack: UIStackView!
    @IBOutlet weak var DashboardStack: UIStackView!
    @IBOutlet weak var InfoStack: UIStackView!
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Address: UILabel!
    
    @IBOutlet weak var AddPostView: UIView!
    
    
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
    
    
    var count = 0
    override func viewDidAppear(_ animated: Bool) {
        if self.count == 0{
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
            self.count = 1
        }
    }
    
    
    var pickerView = UIPickerView(frame: CGRect(x: 10, y: 50, width: 250, height: 150))

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
        
        
        
        self.QRCodeImage.image = UIImage()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.EditProfileStack.isHidden = true
        self.DashboardStack.isHidden = true
        self.InfoStack.isHidden = true
        
        self.AddPostView.isHidden = true
        self.MyPostsStack.isHidden = true
        self.DashboardStack.isHidden = true
        
        if XLanguage.get() == .English{
            self.languages.append(languagesObject(id: "1", language: "English"))
            self.languages.append(languagesObject(id: "2", language: "Arabic"))
            self.languages.append(languagesObject(id: "3", language: "Kurdish"))
        }else if XLanguage.get() == .Arabic{
            self.languages.append(languagesObject(id: "1", language: "إنجليزي"))
            self.languages.append(languagesObject(id: "2", language: "العربیة"))
            self.languages.append(languagesObject(id: "3", language: "الکوردیة"))
        }else{
            self.languages.append(languagesObject(id: "1", language: "ئینگلیزی"))
            self.languages.append(languagesObject(id: "2", language: "عەرەبی"))
            self.languages.append(languagesObject(id: "3", language: "کوردی"))
        }
        
        
        
        
        self.RadiuViews0.layer.cornerRadius = self.RadiuViews0.bounds.width / 2
        self.RadiuViews.layer.cornerRadius = self.RadiuViews .bounds.width / 2
        self.RadiuViews1.layer.cornerRadius = self.RadiuViews1.bounds.width / 2
        self.RadiuViews2.layer.cornerRadius = self.RadiuViews2.bounds.width / 2
        self.RadiuViews3.layer.cornerRadius = self.RadiuViews3.bounds.width / 2
        self.RadiuViews4.layer.cornerRadius = self.RadiuViews4.bounds.width / 2
        
        self.RadiuArrow0.layer.cornerRadius = self.RadiuArrow0.bounds.width / 2
        self.RadiuArrow.layer.cornerRadius = self.RadiuArrow.bounds.width / 2
        self.RadiuArrow1.layer.cornerRadius = self.RadiuArrow1.bounds.width / 2
        self.RadiuArrow2.layer.cornerRadius = self.RadiuArrow2.bounds.width / 2
        self.RadiuArrow3.layer.cornerRadius = self.RadiuArrow3.bounds.width / 2
        self.RadiuArrow4.layer.cornerRadius = self.RadiuArrow4.bounds.width / 2
        
        
        
   
        
        
    }
    
    
    
    
    
    func GetMyPosts(){
        PostObjectApi.GetPostsById(lab_id:UserDefaults.standard.string(forKey: "my_lab_id") ?? "") { posts in
            if posts.count != 0 {
                self.MyPostsStack.isHidden = false
            }
            
        }
    }
    
    @IBAction func ChoosLang(_ sender: Any) {
        self.languages.removeAll()
        self.pickerView.reloadAllComponents()
        self.pickerView.reloadInputViews()
        self.pickerView.selectRow(0, inComponent: 0, animated: true)
        
        var action = ""
        var cancel = ""
        
        if XLanguage.get() == .English{

            action = "Select"
            cancel = "Cancel"
        }else if XLanguage.get() == .Arabic{

            action = "تحديد"
            cancel = "إلغاء"
        }else{

            action = "هەلبژارتن"
            cancel = "دەرکەتن"
        }
        
        
        if XLanguage.get() == .English{
            self.languages.append(languagesObject(id: "1", language: "English"))
            self.languages.append(languagesObject(id: "2", language: "Arabic"))
            self.languages.append(languagesObject(id: "3", language: "Kurdish"))
        }else if XLanguage.get() == .Arabic{
            self.languages.append(languagesObject(id: "1", language: "إنجليزي"))
            self.languages.append(languagesObject(id: "2", language: "العربیة"))
            self.languages.append(languagesObject(id: "3", language: "الکوردیة"))
        }else{
            self.languages.append(languagesObject(id: "1", language: "ئینگلیزی"))
            self.languages.append(languagesObject(id: "2", language: "عەرەبی"))
            self.languages.append(languagesObject(id: "3", language: "کوردی"))
        }
        
        self.pickerView.reloadAllComponents()
        self.pickerView.reloadInputViews()
        
        let ac = UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        ac.view.addSubview(pickerView)
        ac.addAction(UIAlertAction(title: action , style: .default, handler: { _ in
            if self.languages.count != 0{
                let pickerValue = self.languages[self.pickerView.selectedRow(inComponent: 0)]
                //UserDefaults.standard.set(pickerValue.language, forKey: "SelectedLanguage")
                if pickerValue.id == "1"{
                    self.LangLable.text = "English"
                    UserDefaults.standard.set("English", forKey: "SelectedLanguage")
                    XLanguage.set(Language: .English)
                    UserDefaults.standard.set(1, forKey: "Language")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarView") as? TabBarView
                    let appDelegate = UIApplication.shared.delegate?.window as? UIWindow
                    appDelegate?.rootViewController = vc
                }else if pickerValue.id == "2"{
                    XLanguage.set(Language: .Arabic)
                    self.LangLable.text = "العربیة"
                    UserDefaults.standard.set("العربیة", forKey: "SelectedLanguage")
                    UserDefaults.standard.set(2, forKey: "Language")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarView") as? TabBarView
                    let appDelegate = UIApplication.shared.delegate?.window as? UIWindow
                    appDelegate?.rootViewController = vc
                }else{
                    XLanguage.set(Language: .Kurdish)
                    self.LangLable.text = "کوردی"
                    UserDefaults.standard.set("کوردی", forKey: "SelectedLanguage")
                    UserDefaults.standard.set(3, forKey: "Language")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarView") as? TabBarView
                    let appDelegate = UIApplication.shared.delegate?.window as? UIWindow
                    appDelegate?.rootViewController = vc
                }
                
                if UserDefaults.standard.bool(forKey: "Login") == false{
                    if XLanguage.get() == .English{
                        self.LogInLable.text = "Login"
                    }else if XLanguage.get() == .Arabic{
                        self.LogInLable.text = "تسجيل الدخول"
                    }else{
                        self.LogInLable.text = "چوونه‌ ژوور‌"
                    }
                }else{
                    if XLanguage.get() == .Kurdish{
                        self.LogInLable.text = "چوونە دەر"
                    }else if XLanguage.get() == .English{
                        self.LogInLable.text = "Logout"
                    }else{
                        self.LogInLable.text = "تسجيل خروج"
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
            }
        }))
        
        ac.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        present(ac, animated: true)
        
    }
    
    @IBOutlet weak var QRCodeImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
       
        
        self.MyPostsStack.isHidden = true
        self.LangLable.text = UserDefaults.standard.string(forKey: "SelectedLanguage") ?? ""
        if UserDefaults.standard.bool(forKey: "Login") == true{
            
            self.IsLogin = true
            if XLanguage.get() == .Kurdish{
                self.LogInLable.text = "چوونە دەر"
            }else if XLanguage.get() == .English{
                self.LogInLable.text = "Logout"
            }else{
                self.LogInLable.text = "تسجيل خروج"
            }
           
            ProfileDataAPI.GetProfileData(id: UserDefaults.standard.string(forKey: "id") ?? "") { data,error  in
                
                self.alert.dismiss(animated: true, completion: nil)
                if error == ""{
                    if data.full_name == ""{
                        self.InfoStack.isHidden = true
                        self.EditProfileStack.isHidden = false
                    }else{
                        self.InfoStack.isHidden = false
                        self.EditProfileStack.isHidden = false
                        self.Name.text = data.full_name
                        self.Address.text = data.phone
                    }
                    
                    let code = data.qrcode
                    do {  // Adjust gradient colors as needed
                        let qrCodeImage = try? QRDispenser.generate(from: code)
                        self.QRCodeImage.image = qrCodeImage
                    }
                    
                    if data.type == "lab"{
                        self.AddPostView.isHidden = false
                        self.DashboardStack.isHidden = false
                        //self.QRCodeImage.isHidden = true
                        self.GetMyPosts()
                    }
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true)
                }
            }
            
            self.view.layoutIfNeeded()
        }else{
            self.alert.dismiss(animated: true, completion: nil)
            self.IsLogin = false
            self.EditProfileStack.isHidden = true
            self.AddPostView.isHidden = true
            self.MyPostsStack.isHidden = true
            self.DashboardStack.isHidden = true
            self.InfoStack.isHidden = true
            if XLanguage.get() == .English{
                self.LogInLable.text = "Login"
            }else if XLanguage.get() == .Arabic{
                self.LogInLable.text = "تسجيل الدخول"
            }else{
                self.LogInLable.text = "چوونه‌ ژوور‌"
            }
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.alert.dismiss(animated: true)
        })
        
        self.cornerViewCode = CornerView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
           self.QRCodeImage.addSubview(self.cornerViewCode!)
       }
    var cornerViewCode : CornerView?
       override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }
    
    
    
    
    
    
    var IsLogin = false

    
    var messagee = ""
    var Action = ""
    var cancel = ""
    var logoutT = ""
    var logoutM = ""
    @IBAction func LoginAndOut(_ sender: Any) {
        
        if CheckInternet.Connection() == true{
            
            if  self.IsLogin == true{
                if XLanguage.get() == .Kurdish{
                    self.logoutT = "چوونە دەر"
                    self.logoutM = "پشتراستی؟"
                    self.Action = "بەڵێ"
                    self.cancel = "نەخێر"
                }else if XLanguage.get() == .English{
                    self.logoutT = "logout"
                    self.logoutM = "Are you sure?"
                    self.Action = "Yes"
                    self.cancel = "No"
                }else{
                    self.logoutT = "تسجيل خروج"
                    self.logoutM = "هل أنت متأكد؟"
                    self.Action = "نعم"
                    self.cancel = "لا"
                }
                
                
                
                let myAlert = UIAlertController(title: logoutT, message: logoutM, preferredStyle: UIAlertController.Style.alert)
                myAlert.addAction(UIAlertAction(title: Action, style: .default, handler: { (UIAlertAction) in
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        UserDefaults.standard.set(false, forKey: "Login")
                        UserDefaults.standard.set("", forKey: "id")
                        UserDefaults.standard.set("", forKey: "my_lab_id")
                        self.EditProfileStack.isHidden = true
                        self.InfoStack.isHidden = true
                        self.AddPostView.isHidden = true
                        self.MyPostsStack.isHidden = true
                        self.DashboardStack.isHidden = true
                        if XLanguage.get() == .English{
                            self.LogInLable.text = "Login"
                        }else if XLanguage.get() == .Arabic{
                            self.LogInLable.text = "تسجيل الدخول"
                        }else{
                            self.LogInLable.text = "چوونه‌ ژوور‌"
                        }
                        
                        self.IsLogin = false
                        
                        
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
                        vc.modalPresentationStyle = .fullScreen
                        //vc.DimissImage.isHidden = true
                        vc.modalTransitionStyle = .crossDissolve
                        self.present(vc, animated: true)
                        
                        
                        
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                }))
                myAlert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
                self.present(myAlert, animated: true, completion: nil)
            }else{
                let vc = storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
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
    
    

}
class languagesObject {
    var language = ""
    var id = ""
    
    init(id:String,language:String) {
        self.id = id
        self.language = language
    }
}
