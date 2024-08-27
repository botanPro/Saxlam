//
//  DashboardResults.swift
//  sharktest
//
//  Created by Botan Amedi on 31/01/2024.
//

import UIKit
import PDFReader
import Alamofire
import SwiftyJSON
import MBRadioCheckboxButton
import Drops
class DashboardResults: UIViewController ,UITextFieldDelegate{
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func DismissFilter(_ sender: Any) {
        IsDateChecked = false
        IsNameChecked = false
        self.DateCheckBox.isOn = false
        self.NameCheckBox.isOn = false
        self.DateStack.isUserInteractionEnabled = false
        self.NameStack.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.4) {
            self.FilterBottom.constant = -400
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func ShowFilter(_ sender: Any) {
        UIView.animate(withDuration: 0.4) {
            self.FilterBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBOutlet weak var DateCheckBox: CheckboxButton!
    @IBOutlet weak var NameCheckBox: CheckboxButton!
    
    
    @IBOutlet weak var DateView: UIView!
    @IBOutlet weak var NameView: UIView!
    
    
    
    var IsDateChecked = false
    var IsNameChecked = false
    @IBAction func DateCheckBox(_ sender: CheckboxButton) {
        print(sender.isOn)
        if sender.isOn == true{
            self.DateStack.isUserInteractionEnabled = true
            IsDateChecked = true
        }else{
            self.DateStack.isUserInteractionEnabled = false
            IsDateChecked = false
        }
    }
    
    @IBAction func NameCheckBox(_ sender: CheckboxButton) {
        if sender.isOn == true{
            self.NameStack.isUserInteractionEnabled = true
            IsNameChecked = true
            self.NameCheckBox.isOn = true
        }else{
            self.NameStack.isUserInteractionEnabled = false
            IsNameChecked = false
            self.NameCheckBox.isOn = false
        }
    }
    
    @IBOutlet weak var FilterBottom: NSLayoutConstraint!
    
    
    
    
    var Results : [TestObject] = []
    var lab_id = ""
    
    var isSearched = false
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    lazy var workItem = WorkItem()
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        print(textField.text!)
        if CheckInternet.Connection() == true{
            if textField.text?.count == 1 {
                self.GetTodayResults()
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
                        "fun":"filter_lab_test",
                        "id" : UserDefaults.standard.string(forKey: "id") ?? "",
                        "lab_id" : UserDefaults.standard.string(forKey: "my_lab_id") ?? "",
                        "type": "invoice",
                        "inv_id" : textField.text ?? "",
                        "profile_id": "",
                        "date_one" :"",
                        "date_two" : ""
                    ]
                    
                    AF.request(stringUrl!, method: .post, parameters: param, headers:  headers).responseData { respons in
                        switch respons.result{
                        case .success:
                            let jsonData = JSON(respons.data ?? "")
                            print(jsonData)
                            if jsonData.count == 0{
                                UIView.animate(withDuration: 0.4) {
                                    self.FilterBottom.constant = 0
                                    self.view.layoutIfNeeded()
                                }
                                self.ResultsTableView.reloadData()
                                self.activityIndicator.stopAnimating()
                                if XLanguage.get() == .English{
                                    self.ResultsTableView.setEmptyView(title: "No Results", message: "There are no Results for today")
                                }else if XLanguage.get() == .Arabic{
                                    self.ResultsTableView.setEmptyView(title: "لا یوجد نتائیج", message: "")
                                }else{
                                    self.ResultsTableView.setEmptyView(title: "هیچ ئەنجامەک بەردەست نینە", message: "")
                                }
                            }else{
                                for (_,val) in jsonData{
                                    let product = TestObject(inv_num: val["inv_num"].string ?? "", inv_date: val["inv_date"].string ?? "", done_result: val["done_result"].string ?? "", url: val["url"].string ?? "", full_name: val["full_name"].string ?? "")
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
    
    
    
    
    
    
    
    
    
    
    
    @objc func GetWorkerType(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            self.count = 1
            if let id = dict["id"] as? String , let full_name = dict["full_name"] as? String{
                self.SelectedProfileName.text = full_name
                self.Selected_profile_id = id
            }
        }
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetWorkerType(_:)), name: NSNotification.Name(rawValue: "DataComing"), object: nil)
    }
    
    
    
    
    
    
    @IBOutlet weak var DateOne: UIDatePicker!
    @IBOutlet weak var DateTow: UIDatePicker!
    
    @IBOutlet weak var SelectedProfileName: UITextField!
    
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
        if self.DatetowCompare < self.DateoneCompare {
            let date = self.SecondDate
            self.SecondDate = self.FirstDate
            self.FirstDate = date
        }
    }
    
    
    @IBOutlet weak var DateStack: UIStackView!
    @IBOutlet weak var NameStack: UIStackView!
    
    
    @IBOutlet weak var BottomLayout: NSLayoutConstraint!
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    @IBOutlet weak var ResultsTableView: UITableView!
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var SearchView: UIView!
    
    var Selected_profile_id = ""
    @IBOutlet weak var FilterView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.DateStack.isUserInteractionEnabled = false
        self.NameStack.isUserInteractionEnabled = false
        self.FilterBottom.constant = -400
        GetTodayResults()
        
        DateOne.maximumDate = Date()
        DateTow.maximumDate = Date()
        ResultsTableView.register(UINib(nibName: "TestResultsTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")

        self.SearchTextField.delegate = self
        
        self.SearchView.layer.masksToBounds = false
        self.SearchView.layer.shadowColor = UIColor.lightGray.cgColor
        self.SearchView.layer.shadowOpacity = 0.2
        self.SearchView.layer.shadowOffset = .zero
        self.SearchView.layer.shadowRadius = 6
        self.SearchView.layer.shouldRasterize = true
        self.SearchView.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        self.SearchView.layer.cornerRadius = 16
        
        
        self.FilterView.layer.masksToBounds = false
        self.FilterView.layer.shadowColor = UIColor.lightGray.cgColor
        self.FilterView.layer.shadowOpacity = 0.2
        self.FilterView.layer.shadowOffset = .zero
        self.FilterView.layer.shadowRadius = 6
        self.FilterView.layer.shouldRasterize = true
        self.FilterView.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        self.FilterView.layer.cornerRadius = 16
        
        
        
        activityIndicator.hidesWhenStopped = true
        ResultsTableView.addSubview(activityIndicator)
        activityIndicator.center = ResultsTableView.center
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHiden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    func GetTodayResults(){
        if CheckInternet.Connection() == true{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let formattedDateTow = dateFormatter.string(from: Date())
            let formattedDateOne = dateFormatter.string(from: Date())
            
            self.Results.removeAll()
            let stringUrl = URL(string: API.URL);
            let username = openCartApi.UserName
            let password = openCartApi.key
            let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
            let param: [String: Any] = [
                "fun":"filter_lab_test",
                "id" : UserDefaults.standard.string(forKey: "id") ?? "",
                "lab_id" : UserDefaults.standard.string(forKey: "my_lab_id") ?? "",
                "type": "date_inv",
                "inv_id" :"",
                "profile_id" : "",
                "date_one" : formattedDateOne,
                "date_two" : formattedDateTow
            ]
            
            
            print(formattedDateOne)
            print(formattedDateTow)
            
            print(UserDefaults.standard.string(forKey: "id") ?? "")
            print(UserDefaults.standard.string(forKey: "my_lab_id") ?? "")
            AF.request(stringUrl!, method: .post, parameters: param, headers:  headers).responseData { respons in
                switch respons.result{
                case .success:
                    let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                    UIView.animate(withDuration: 0.4) {
                        self.FilterBottom.constant = -400
                        self.view.layoutIfNeeded()
                    }
                    if jsonData.count == 0{
                        self.activityIndicator.stopAnimating()
                        self.ResultsTableView.reloadData()
                        if XLanguage.get() == .English{
                            self.ResultsTableView.setEmptyView(title: "No Results", message: "There are no Results for today")
                        }else if XLanguage.get() == .Arabic{
                            self.ResultsTableView.setEmptyView(title: "لا یوجد نتائیج", message: "")
                        }else{
                            self.ResultsTableView.setEmptyView(title: "هیچ ئەنجامەک بەردەست نینە", message: "")
                        }
                    }else{
                        for (_,val) in jsonData {
                            let product = TestObject(inv_num: val["inv_num"].string ?? "", inv_date: val["inv_date"].string ?? "", done_result: val["done_result"].string ?? "", url: val["url"].string ?? "", full_name: val["full_name"].string ?? "")
                            self.Results.append(product)
                        }
                        
                        self.activityIndicator.stopAnimating()
                    }
                    self.ResultsTableView.reloadData()
                    
                case .failure(let error):
                    print("error 450 : error while Getting tests")
                    print(error);
                }
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                if self.Results.count == 0{
                    self.ResultsTableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    if XLanguage.get() == .English{
                        self.ResultsTableView.setEmptyView(title: "No Results", message: "There are no Results for today")
                    }else if XLanguage.get() == .Arabic{
                        self.ResultsTableView.setEmptyView(title: "لا یوجد نتائیج", message: "")
                    }else{
                        self.ResultsTableView.setEmptyView(title: "هیچ ئەنجامەک بەردەست نینە", message: "")
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
   
    @IBAction func ShowResults(_ sender: Any) {
        UIView.animate(withDuration: 0.4) {
            self.FilterBottom.constant = -400
            self.view.layoutIfNeeded()
        }
        self.activityIndicator.startAnimating()
        self.Results.removeAll()
        self.ResultsTableView.reloadData()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let formattedDateTow = dateFormatter.string(from: Date())
        
        
        if self.IsDateChecked == true && self.IsNameChecked == false{print("111")
            if self.FirstDate == ""{
                self.FirstDate = formattedDateTow
            }
            if self.SecondDate == ""{
                self.SecondDate = formattedDateTow
            }
            
            self.GetResults(profile_id: self.Selected_profile_id, date_one: self.FirstDate, date_tow: self.SecondDate, type: "date_inv")
        }
        
        if self.IsDateChecked == false && self.IsNameChecked == true{print("222")
            self.GetResults(profile_id: self.Selected_profile_id, date_one: self.FirstDate, date_tow: self.SecondDate, type: "user")
        }
        
        if self.IsDateChecked == true && self.IsNameChecked == true{print("3333")
            if self.FirstDate == ""{
                self.FirstDate = formattedDateTow
            }
            if self.SecondDate == ""{
                self.SecondDate = formattedDateTow
            }
            self.GetResults(profile_id: self.Selected_profile_id, date_one: self.FirstDate, date_tow: self.SecondDate, type: "date_user")
        }
    }
    
    
    func GetResults(profile_id : String, date_one : String, date_tow: String,type: String){
        self.Results.removeAll()
        let stringUrl = URL(string: API.URL);
        let username = openCartApi.UserName
        let password = openCartApi.key
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
        
        
        let param: [String: Any] = [
            "fun":"filter_lab_test",
            "id" : UserDefaults.standard.string(forKey: "id") ?? "",
            "lab_id" : UserDefaults.standard.string(forKey: "my_lab_id") ?? "",
            "type": type,
            "inv_id" :"",
            "profile_id" : profile_id,
            "date_one" : date_one,
            "date_two" : date_tow
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
                    for (_,val) in jsonData {
                            let product = TestObject(inv_num: val["inv_num"].string ?? "", inv_date: val["inv_date"].string ?? "", done_result: val["done_result"].string ?? "", url: val["url"].string ?? "", full_name: val["full_name"].string ?? "")
                            self.Results.append(product)
                    }
                    
                    self.activityIndicator.stopAnimating()
                }
                self.ResultsTableView.reloadData()
                
            case .failure(let error):
                print("error 450 : error while Getting tests")
                print(error);
            }
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



extension DashboardResults : UITableViewDelegate, UITableViewDataSource {
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
        
        cell.FullName.text = Results[indexPath.row].full_name
        
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
