//
//  ChooseNameForFilter.swift
//  sharktest
//
//  Created by Botan Amedi on 31/01/2024.
//

import UIKit
import Alamofire
import SwiftyJSON
import Drops
class ChooseNameForFilter: UIViewController ,UITextFieldDelegate{
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    var Users : [UsersObject] = []
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    lazy var workItem = WorkItem()
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if CheckInternet.Connection() == true{
            if textField.text == "" {
                self.GetSomeUsers()
            }else{
                self.workItem.perform(after: 0.3) {
                    self.Users.removeAll()
                    let stringUrl = URL(string: API.URL);
                    let username = openCartApi.UserName
                    let password = openCartApi.key
                    let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
                    let base64Credentials = credentialData.base64EncodedString(options: [])
                    let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
                    let param: [String: Any] = [
                        "fun":"search_lab_user",
                        "id" : UserDefaults.standard.string(forKey: "id") ?? "",
                        "lab_id" : UserDefaults.standard.string(forKey: "my_lab_id") ?? "",
                        "full_name": textField.text ?? "",
                    ]
                    
                    AF.request(stringUrl!, method: .post, parameters: param, headers:  headers).responseData { respons in
                        switch respons.result{
                        case .success:
                            let jsonData = JSON(respons.data ?? "")
                            print(jsonData)
                            if jsonData.count == 0{
                                self.activityIndicator.stopAnimating()
                                self.ResultsTableView.reloadData()
                                
                                if XLanguage.get() == .English{
                                    self.ResultsTableView.setEmptyView(title: "No Users Found", message: "There are no Users")
                                }else if XLanguage.get() == .Arabic{
                                    self.ResultsTableView.setEmptyView(title: "لم يتم العثور على مستخدمين", message: "")
                                }else{
                                    self.ResultsTableView.setEmptyView(title: "هیچ بکارهێنەرەک نە هاتە دیتن", message: "")
                                }
                            }else{
                                for (_,val) in jsonData{
                                    let User = UsersObject(id: val["id"].string ?? "", full_name: val["full_name"].string ?? "")
                                    self.Users.append(User)
                                }
                                self.ResultsTableView.reloadData()
                            }
                        case .failure(let error):
                            print("error 450 : error while Getting users")
                            print(error);
                        }
                    }
                    
                }
            }
        }
        return true
    }
    
    
    
    
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    @IBOutlet weak var ResultsTableView: UITableView!
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var SearchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ResultsTableView.register(UINib(nibName: "UsersNameTableViewcell", bundle: nil), forCellReuseIdentifier: "Cell")

        self.SearchTextField.delegate = self
        self.GetSomeUsers()
        
        self.SearchView.layer.masksToBounds = false
        self.SearchView.layer.shadowColor = UIColor.lightGray.cgColor
        self.SearchView.layer.shadowOpacity = 0.2
        self.SearchView.layer.shadowOffset = .zero
        self.SearchView.layer.shadowRadius = 6
        self.SearchView.layer.shouldRasterize = true
        self.SearchView.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        self.SearchView.layer.cornerRadius = 16
        
        
        
        activityIndicator.hidesWhenStopped = true
        ResultsTableView.addSubview(activityIndicator)
        activityIndicator.center = ResultsTableView.center
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHiden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBOutlet weak var BottomLayout: NSLayoutConstraint!
    
    
    var count = 1
    @objc func keyboardWasShown(notification: NSNotification) {
        if count == 1{
           count += 1
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.BottomLayout.constant += keyboardFrame.height
        }
    }
    @objc func keyboardWasHiden(notification: NSNotification) {
        self.count = 1
        self.BottomLayout.constant = 0
    }
    
    
    
    func GetSomeUsers(){
        if CheckInternet.Connection() == true{
            self.Users.removeAll()
            let stringUrl = URL(string: API.URL);
            let username = openCartApi.UserName
            let password = openCartApi.key
            let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
            let param: [String: Any] = [
                "fun":"search_lab_user",
                "id" : UserDefaults.standard.string(forKey: "id") ?? "",
                "lab_id" : UserDefaults.standard.string(forKey: "my_lab_id") ?? "",
                "full_name": "",
            ]
            
            AF.request(stringUrl!, method: .post, parameters: param, headers:  headers).responseData { respons in
                switch respons.result{
                case .success:
                    let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                    if jsonData.count == 0{
                        self.activityIndicator.stopAnimating()
                        self.ResultsTableView.reloadData()
                        if XLanguage.get() == .English{
                            self.ResultsTableView.setEmptyView(title: "No Users Found", message: "There are no Users")
                        }else if XLanguage.get() == .Arabic{
                            self.ResultsTableView.setEmptyView(title: "لم يتم العثور على مستخدمين", message: "")
                        }else{
                            self.ResultsTableView.setEmptyView(title: "هیچ بکارهێنەرەک نە هاتە دیتن", message: "")
                        }
                    }else{
                        for (_,val) in jsonData {
                            let User = UsersObject(id: val["id"].string ?? "", full_name: val["full_name"].string ?? "")
                            self.Users.append(User)
                        }
                        
                        self.activityIndicator.stopAnimating()
                    }
                    self.ResultsTableView.reloadData()
                    
                case .failure(let error):
                    print("error 450 : error while Getting users")
                    print(error);
                }
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                if self.Users.count == 0{
                    self.ResultsTableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    if XLanguage.get() == .English{
                        self.ResultsTableView.setEmptyView(title: "No Users Found", message: "There are no Users")
                    }else if XLanguage.get() == .Arabic{
                        self.ResultsTableView.setEmptyView(title: "لم يتم العثور على مستخدمين", message: "")
                    }else{
                        self.ResultsTableView.setEmptyView(title: "هیچ بکارهێنەرەک نە هاتە دیتن", message: "")
                    }
                }
            })
        }else{
            self.activityIndicator.stopAnimating()
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
            self.ResultsTableView.setEmptyView(title: "", message: "")
            
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


extension ChooseNameForFilter : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Users.count == 0{
            return 0
        }
        self.ResultsTableView.setEmptyView(title: "", message: "")
        return Users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UsersNameTableViewcell
        if Users.count != 0{
            cell.Titlee.text = Users[indexPath.row].full_name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Users.count != 0 && indexPath.row <= Users.count{
                let Data:[String: String] = ["id": Users[indexPath.row].id , "full_name" : Users[indexPath.row].full_name]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DataComing"), object: nil , userInfo: Data)
                self.dismiss(animated: true, completion: nil)
        }
    }
}



class UsersObject{
    
    var id = ""
    var full_name = ""
   
    
    init(id : String , full_name : String) {
        self.full_name = full_name
        self.id = id
    }
    
    
}
