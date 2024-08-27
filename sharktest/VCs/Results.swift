//
//  Results.swift
//  sharktest
//
//  Created by Botan Amedi on 26/07/2023.
//

import UIKit
import PDFReader
import Alamofire
import SwiftyJSON
import Drops
class Results: UIViewController ,UITextFieldDelegate{
    
    var Results : [TestObject] = []
    var lab_id = ""
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
  
    
    var isSearched = false
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    lazy var workItem = WorkItem()
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if CheckInternet.Connection() == true{
            if textField.text?.count == 1 {
                self.GetMyTests()
            }else{
                self.isSearched = true
                self.workItem.perform(after: 0.3) {
                    self.Results.removeAll()
                    let stringUrl = URL(string: API.URL);
                    let username = openCartApi.UserName
                    let password = openCartApi.key
                    let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
                    let base64Credentials = credentialData.base64EncodedString(options: [])
                    let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
                    let param: [String: Any] = [
                        "fun":"filter_user_test",
                        "id" : UserDefaults.standard.string(forKey: "id") ?? "",
                        "lab_id" : self.lab_id,
                        "type": "invoice",
                        "inv_id" : textField.text ?? "",
                        "date_one" :"",
                        "date_two" : ""
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
                                    self.ResultsTableView.setEmptyView(title: "No Results", message: "There are no Results to be shown")
                                }else if XLanguage.get() == .Arabic{
                                    self.ResultsTableView.setEmptyView(title: "لا یوجد نتائیج", message: "")
                                }else{
                                    self.ResultsTableView.setEmptyView(title: "هیچ ئەنجامەک بەردەست نینە", message: "")
                                }
                            }else{
                                self.activityIndicator.stopAnimating()
                                for (_,val) in jsonData{
                                    let product = TestObject(inv_num: val["inv_num"].string ?? "", inv_date: val["inv_date"].string ?? "", done_result: val["done_result"].string ?? "", url: val["url"].string ?? "",full_name : val["full_name"].string ?? "")
                                    self.Results.append(product)
                                }
                                self.ResultsTableView.reloadData()
                            }
                        case .failure(let error):
                            print("error 450 : error while Getting my tests")
                            print(error);
                        }
                    }
                    
                }
            }
        }
        return true
    }
    
    
    
    @IBOutlet weak var DateOne: UIDatePicker!
    @IBOutlet weak var DateTow: UIDatePicker!
    
    
    var FirstDate = ""
    var SecondDate = ""
    var DateoneCompare = Date()
    var DatetowCompare = Date()
    @IBAction func firstDatePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        DateoneCompare = sender.date
        let formattedDateOne = dateFormatter.string(from: DateoneCompare)
        print("User selected date with the first date picker: \(formattedDateOne)")
        FirstDate = formattedDateOne
        
        compareDates()
    }

    @IBAction func secondDatePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        DatetowCompare = sender.date
        let formattedDateTow = dateFormatter.string(from: DatetowCompare)
        print("User selected date with the second date picker: \(formattedDateTow)")
        SecondDate = formattedDateTow
        
        compareDates()
    }
    
    
    func compareDates() {
        if CheckInternet.Connection() == true{
            if DatetowCompare < DateoneCompare {
                let date = SecondDate
                SecondDate = FirstDate
                FirstDate = date
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let formattedDateTow = dateFormatter.string(from: Date())
                
                
                
                if self.FirstDate == ""{
                    self.FirstDate = formattedDateTow
                }
                if self.SecondDate == ""{
                    self.SecondDate = formattedDateTow
                }
                
                
                self.Results.removeAll()
                let stringUrl = URL(string: API.URL);
                let username = openCartApi.UserName
                let password = openCartApi.key
                let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
                let base64Credentials = credentialData.base64EncodedString(options: [])
                let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
                let param: [String: Any] = [
                    "fun":"filter_user_test",
                    "id" : UserDefaults.standard.string(forKey: "id") ?? "",
                    "lab_id" : self.lab_id,
                    "type": "date_inv",
                    "inv_id" :"",
                    "date_one" : FirstDate,
                    "date_two" : SecondDate
                ]
                
                AF.request(stringUrl!, method: .post, parameters: param, headers:  headers).responseData { respons in
                    switch respons.result{
                    case .success:
                        let jsonData = JSON(respons.data ?? "")
                        print(jsonData)
                        if jsonData.count == 0{
                            self.activityIndicator.stopAnimating()
                            self.ResultsTableView.reloadData()
                            self.ResultsTableView.isHidden = false
                            if XLanguage.get() == .English{
                                self.ResultsTableView.setEmptyView(title: "No Results", message: "There are no Results to be shown")
                            }else if XLanguage.get() == .Arabic{
                                self.ResultsTableView.setEmptyView(title: "لا یوجد نتائیج", message: "")
                            }else{
                                self.ResultsTableView.setEmptyView(title: "هیچ ئەنجامەک بەردەست نینە", message: "")
                            }
                        }else{
                            self.activityIndicator.stopAnimating()
                            self.ResultsTableView.isHidden = false
                            for (_,val) in jsonData{
                                let product = TestObject(inv_num: val["inv_num"].string ?? "", inv_date: val["inv_date"].string ?? "", done_result: val["done_result"].string ?? "", url: val["url"].string ?? "",full_name : val["full_name"].string ?? "")
                                self.Results.append(product)
                            }
                            self.ResultsTableView.reloadData()
                        }
                    case .failure(let error):
                        print("error 450 : error while Getting my tests")
                        print(error);
                    }
                }
                
                
            }else{
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let formattedDateTow = dateFormatter.string(from: Date())
                
                
                
                if self.FirstDate == ""{
                    self.FirstDate = formattedDateTow
                }
                if self.SecondDate == ""{
                    self.SecondDate = formattedDateTow
                }
                
                self.Results.removeAll()
                let stringUrl = URL(string: API.URL);
                let username = openCartApi.UserName
                let password = openCartApi.key
                let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
                let base64Credentials = credentialData.base64EncodedString(options: [])
                let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
                let param: [String: Any] = [
                    "fun":"filter_user_test",
                    "id" : UserDefaults.standard.string(forKey: "id") ?? "",
                    "lab_id" : self.lab_id,
                    "type": "date_inv",
                    "inv_id" :"",
                    "date_one" : FirstDate,
                    "date_two" : SecondDate
                ]
                
                AF.request(stringUrl!, method: .post, parameters: param, headers:  headers).responseData { respons in
                    switch respons.result{
                    case .success:
                        let jsonData = JSON(respons.data ?? "")
                        print(jsonData)
                        if jsonData.count == 0{
                            self.activityIndicator.stopAnimating()
                            self.ResultsTableView.isHidden = false
                            self.ResultsTableView.reloadData()
                            if XLanguage.get() == .English{
                                self.ResultsTableView.setEmptyView(title: "No Results", message: "There are no Results to be shown")
                            }else if XLanguage.get() == .Arabic{
                                self.ResultsTableView.setEmptyView(title: "لا یوجد نتائیج", message: "")
                            }else{
                                self.ResultsTableView.setEmptyView(title: "هیچ ئەنجامەک بەردەست نینە", message: "")
                            }
                        }else{
                            self.activityIndicator.stopAnimating()
                            self.ResultsTableView.isHidden = false
                            for (_,val) in jsonData{
                                let product = TestObject(inv_num: val["inv_num"].string ?? "", inv_date: val["inv_date"].string ?? "", done_result: val["done_result"].string ?? "", url: val["url"].string ?? "",full_name : val["full_name"].string ?? "")
                                self.Results.append(product)
                            }
                            self.ResultsTableView.reloadData()
                        }
                    case .failure(let error):
                        print("error 450 : error while Getting my tests")
                        print(error);
                    }
                }
            }
        }else{
            self.Results.removeAll()
            self.ResultsTableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.ResultsTableView.isHidden = false
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
    
    
    @IBOutlet weak var BottomLayout: NSLayoutConstraint!
    
    
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    @IBOutlet weak var ResultsTableView: UITableView!
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var SearchView: UIView!
    //TestResultsTableViewCell
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DateOne.maximumDate = Date()
        DateTow.maximumDate = Date()
        ResultsTableView.register(UINib(nibName: "TestResultsTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        GetMyTests()
        self.SearchTextField.delegate = self
        
        self.SearchView.layer.masksToBounds = false
        self.SearchView.layer.shadowColor = UIColor.lightGray.cgColor
        self.SearchView.layer.shadowOpacity = 0.2
        self.SearchView.layer.shadowOffset = .zero
        self.SearchView.layer.shadowRadius = 6
        self.SearchView.layer.shouldRasterize = true
        self.SearchView.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        self.SearchView.layer.cornerRadius = 16
        
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        activityIndicator.color = .gray
        ResultsTableView.isHidden = true
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
        self.BottomLayout.constant += keyboardFrame.height - 100
        }
    }
    @objc func keyboardWasHiden(notification: NSNotification) {
        self.count = 1
        self.BottomLayout.constant = 0
    }
    func GetMyTests(){
        if CheckInternet.Connection() == true{
            self.isSearched = false
            self.Results.removeAll()
            TestObjectAPI.GetMyTest(Id: UserDefaults.standard.string(forKey: "id") ?? "", LabId: self.lab_id) { Tests in
                self.activityIndicator.stopAnimating()
                self.ResultsTableView.isHidden = false
                if Tests.count == 0{
                    self.ResultsTableView.reloadData()
                    if XLanguage.get() == .English{
                        self.ResultsTableView.setEmptyView(title: "No Results", message: "There are no Results to be shown")
                    }else if XLanguage.get() == .Arabic{
                        self.ResultsTableView.setEmptyView(title: "لا یوجد نتائیج", message: "")
                    }else{
                        self.ResultsTableView.setEmptyView(title: "هیچ ئەنجامەک بەردەست نینە", message: "")
                    }
                }else{
                    self.Results = Tests
                    self.ResultsTableView.reloadData()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { [self] in
                if self.Results.count == 0{
                    self.ResultsTableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    ResultsTableView.isHidden = false
                    if XLanguage.get() == .English{
                        self.ResultsTableView.setEmptyView(title: "No Results", message: "There are no Results to be shown")
                    }else if XLanguage.get() == .Arabic{
                        self.ResultsTableView.setEmptyView(title: "لا یوجد نتائیج", message: "")
                    }else{
                        self.ResultsTableView.setEmptyView(title: "هیچ ئەنجامەک بەردەست نینە", message: "")
                    }
                }
            })
        }else{
            self.activityIndicator.stopAnimating()
            self.ResultsTableView.isHidden = false
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
    
    
    
    @objc func Share(_ sender : UIButton){
        let url = URL(string: sender.accessibilityLabel ?? "")!
                
        // Create an instance of UIActivityViewController
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        // Exclude some activities
        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact]
        
        // Present the view controller
        present(activityViewController, animated: true)
    }


}


extension Results : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Results.count == 0{
            return 0
        }
        self.ResultsTableView.setEmptyView(title: "", message: "")
        return Results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TestResultsTableViewCell
        if XLanguage.get() == .English{
            cell.invoicNum.text = "Invoice No: \(Results[indexPath.row].inv_num)"
            cell.InvDate.text = "Date : \(Results[indexPath.row].inv_date)"
        }else if XLanguage.get() == .Arabic{
            cell.invoicNum.text = "رقم الفاتورة: \(Results[indexPath.row].inv_num)"
            cell.InvDate.text = "التاريخ : \(Results[indexPath.row].inv_date)"
        }else{
            cell.invoicNum.text = "ژمارا فاکتورێ: \(Results[indexPath.row].inv_num)"
            cell.InvDate.text = "بەروار : \(Results[indexPath.row].inv_date)"
        }
        
        cell.FullName.isHidden = true
        
        if Results[indexPath.row].done_result == "1"{
            cell.Timer.image = UIImage(named: "eye-recognition")
        }else{
            cell.Timer.image = UIImage(named: "timer")
        }
        
        
        cell.Share.accessibilityLabel = self.Results[indexPath.row].url
        cell.Share.addTarget(self, action: #selector(self.Share), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Results.count != 0 && indexPath.row < Results.count {
            if Results[indexPath.row].done_result == "1" {
                guard let cell = tableView.cellForRow(at: indexPath) as? TestResultsTableViewCell else {return}
                var activityIndicator: UIActivityIndicatorView!
                activityIndicator = UIActivityIndicatorView(style: .medium)
                activityIndicator.hidesWhenStopped = true
                activityIndicator.color = .darkGray
                cell.Timer.image = UIImage()
                cell.Timer.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    let remotePDFDocumentURLPath = self.Results[indexPath.row].url
                    let remotePDFDocumentURL = URL(string: remotePDFDocumentURLPath)!
                    
                    if let document = PDFDocument(url: remotePDFDocumentURL){
                        let readerController = PDFViewController.createNew(with: document)
                        let nav = UINavigationController(rootViewController: readerController)
                        activityIndicator.stopAnimating()
                        cell.Timer.image = UIImage(named: "eye-recognition")
                        self.present(nav, animated: true)
                    }else{
                        
                        var mss = ""
                        if XLanguage.get() == .English{
                            mss = "The PDF is not available"
                        }else if XLanguage.get() == .Arabic{
                            mss = "المستند غير متوفر"
                        }else{
                            mss = "پشکنین نە یا بەردەستە"
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
                        activityIndicator.stopAnimating()
                        cell.Timer.image = UIImage(named: "timer")
                    }
                })
                
            }
        }
    }

    
}
