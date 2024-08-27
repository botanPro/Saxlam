//
//  DashboardTests.swift
//  sharktest
//
//  Created by Botan Amedi on 17/02/2024.
//

import UIKit
import Alamofire
import SwiftyJSON
import Drops
class DashboardTests: UIViewController ,UITextFieldDelegate{
    
    
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    
    var Tests : [TestsObject] = []
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    lazy var workItem = WorkItem()
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if CheckInternet.Connection() == true{
            if textField.text?.count == 1 {
                self.GetSomeTests()
            }else{
                self.workItem.perform(after: 0.3) {
                    self.Tests.removeAll()
                    let stringUrl = URL(string: API.URL);
                    let username = openCartApi.UserName
                    let password = openCartApi.key
                    let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
                    let base64Credentials = credentialData.base64EncodedString(options: [])
                    let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
                    let param: [String: Any] = [
                        "fun":"search_lab_test",
                        "lab_id" : UserDefaults.standard.string(forKey: "my_lab_id") ?? "",
                        "test": textField.text ?? "",
                    ]
                    
                    AF.request(stringUrl!, method: .post, parameters: param, headers:  headers).responseData { respons in
                        switch respons.result{
                        case .success:
                            let jsonData = JSON(respons.data ?? "")
                            print(jsonData)
                            if jsonData.count == 0{
                                self.activityIndicator.stopAnimating()
                                self.TestsTableView.reloadData()
                                
                                if XLanguage.get() == .English{
                                    self.TestsTableView.setEmptyView(title: "No Tests Found", message: "There are no Tests")
                                }else if XLanguage.get() == .Arabic{
                                    self.TestsTableView.setEmptyView(title: "لم يتم العثور على الفحصات", message: "")
                                }else{
                                    self.TestsTableView.setEmptyView(title: "هیچ پشکنینەک نە هاتە دیتن", message: "")
                                }
                            }else{
                                for (_,val) in jsonData{
                                    let User = TestsObject(id: val["id"].string ?? "", Title: val["name"].string ?? "", category: val["type"].string ?? "", discount: val["discount"].string ?? "", price: val["price"].string ?? "", price2: val["price2"].string ?? "")
                                    self.Tests.append(User)
                                }
                                self.TestsTableView.reloadData()
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
    @IBOutlet weak var TestsTableView: UITableView!
    @IBOutlet weak var SearchTextFieldd: UITextField!
    @IBOutlet weak var SearchVieww: UIView!
    @IBOutlet weak var BottomLayoutt: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TestsTableView.register(UINib(nibName: "DashboardTestsTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        self.SearchTextFieldd.delegate = self
        self.GetSomeTests()
        
        self.SearchVieww.layer.masksToBounds = false
        self.SearchVieww.layer.shadowColor = UIColor.lightGray.cgColor
        self.SearchVieww.layer.shadowOpacity = 0.2
        self.SearchVieww.layer.shadowOffset = .zero
        self.SearchVieww.layer.shadowRadius = 6
        self.SearchVieww.layer.shouldRasterize = true
        self.SearchVieww.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        self.SearchVieww.layer.cornerRadius = 16
        
        
        
        activityIndicator.hidesWhenStopped = true
        TestsTableView.addSubview(activityIndicator)
        activityIndicator.center = TestsTableView.center
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHiden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    var count = 1
    @objc func keyboardWasShown(notification: NSNotification) {
        if count == 1{
            count += 1
            let info = notification.userInfo!
            let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            self.BottomLayoutt.constant += keyboardFrame.height
        }
    }
    @objc func keyboardWasHiden(notification: NSNotification) {
        self.count = 1
        self.BottomLayoutt.constant = 0
    }
    
    
    
    func GetSomeTests(){
        if CheckInternet.Connection() == true{
            self.Tests.removeAll()
            let stringUrl = URL(string: API.URL);
            let username = openCartApi.UserName
            let password = openCartApi.key
            let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
            let param: [String: Any] = [
                "fun":"search_lab_test",
                "lab_id" : UserDefaults.standard.string(forKey: "my_lab_id") ?? "",
                "test": "",
            ]
            
            AF.request(stringUrl!, method: .post, parameters: param, headers:  headers).responseData { respons in
                switch respons.result{
                case .success:
                    let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                    if jsonData.count == 0{
                        self.activityIndicator.stopAnimating()
                        self.TestsTableView.reloadData()
                        if XLanguage.get() == .English{
                            self.TestsTableView.setEmptyView(title: "No Tests Found", message: "There are no Tests")
                        }else if XLanguage.get() == .Arabic{
                            self.TestsTableView.setEmptyView(title: "لا یوجد الفحصات", message: "")
                        }else{
                            self.TestsTableView.setEmptyView(title: "هیچ پشکنینەک نینە ", message: "")
                        }
                    }else{
                        for (_,val) in jsonData {
                            let User = TestsObject(id: val["id"].string ?? "", Title: val["name"].string ?? "", category: val["type"].string ?? "", discount: val["discount"].string ?? "", price: val["price"].string ?? "", price2: val["price2"].string ?? "")
                            self.Tests.append(User)
                        }
                        
                        self.activityIndicator.stopAnimating()
                    }
                    self.TestsTableView.reloadData()
                    
                case .failure(let error):
                    print("error 450 : error while Getting users")
                    print(error);
                }
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                if self.Tests.count == 0{
                    self.TestsTableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    if XLanguage.get() == .English{
                        self.TestsTableView.setEmptyView(title: "No Tests Found", message: "There are no Tests")
                    }else if XLanguage.get() == .Arabic{
                        self.TestsTableView.setEmptyView(title: "لا یوجد الفحصات", message: "")
                    }else{
                        self.TestsTableView.setEmptyView(title: "هیچ پشکنینەک نینە ", message: "")
                    }
                }
            })
        }else{
            self.TestsTableView.reloadData()
            self.activityIndicator.stopAnimating()
            var mss = ""
            if XLanguage.get() == .English{
                mss = "No internet conection"
            }else if XLanguage.get() == .Kurdish{
                mss = "هێلا ئینترنێتێ نینە"
            }else{
                mss = "لا يوجد اتصال بالإنترنت"
            }
            self.TestsTableView.setEmptyView(title: "", message: "")
            
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
    
    extension DashboardTests : UITableViewDelegate , UITableViewDataSource{
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if Tests.count == 0{
                return 0
            }
            self.TestsTableView.setEmptyView(title: "", message: "")
            return Tests.count
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            80
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DashboardTestsTableViewCell
            if Tests.count != 0{
                cell.Title.text = Tests[indexPath.row].Title
                cell.Category.text = Tests[indexPath.row].category
                
                if Tests[indexPath.row].discount != ""{
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "IQD \(Tests[indexPath.row].discount)")
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
                    cell.Discount.attributedText = attributeString
                }else{
                    cell.Discount.isHidden = true
                }
                
                cell.Price.text = "IQD \(Tests[indexPath.row].price)"
                cell.Price2.text = "IQD \(Tests[indexPath.row].price2)"
            }
            return cell
        }
    }




class TestsObject{
    
    var id = ""
    var Title = ""
    var category = ""
    var discount = ""
    var price = ""
    var price2 = ""
    
    init(id: String, Title: String, category: String, discount: String, price: String,price2:String) {
        self.id = id
        self.Title = Title
        self.category = category
        self.discount = discount
        self.price = price
        self.price2 = price2
    }
    
}
