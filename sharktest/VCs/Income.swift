//
//  Income.swift
//  sharktest
//
//  Created by Botan Amedi on 30/01/2024.
//

import UIKit
import Alamofire
import SwiftyJSON
import Drops
class Income: UIViewController {

    var Results : [ResultData] = []
   
    
    @IBOutlet weak var DateOne: UIDatePicker!
    @IBOutlet weak var DateTow: UIDatePicker!
    
    var FirstDate = ""
    var SecondDate = ""
    var DateoneCompare = Date()
    var DatetowCompare = Date()
    
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBOutlet weak var Remain: UILabel!
    @IBOutlet weak var Cash: UILabel!
    @IBOutlet weak var Total: UILabel!
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    @IBOutlet weak var ResultsTableView: UITableView!
    @IBOutlet weak var SearchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DateOne.maximumDate = Date()
        DateTow.maximumDate = Date()
        
        ResultsTableView.register(UINib(nibName: "IncomeTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
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
        GetResults()
    }
    
    
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
            self.activityIndicator.startAnimating()
            self.Results.removeAll()
            self.ResultsTableView.reloadData()
            let stringUrl = URL(string: API.URL);
            let username = openCartApi.UserName
            let password = openCartApi.key
            let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
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
                
                
                let param: [String: Any] = [
                    "fun":"lab_financial",
                    "id" : UserDefaults.standard.string(forKey: "id") ?? "",
                    "lab_id" : UserDefaults.standard.string(forKey: "my_lab_id") ?? "",
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
                            if XLanguage.get() == .English{
                                self.ResultsTableView.setEmptyView(title: "No Data Found", message: "There is no data between dates")
                            }else if XLanguage.get() == . Arabic{
                                self.ResultsTableView.setEmptyView(title: "لاتوجد بيانات", message: "")
                            }else{
                                self.ResultsTableView.setEmptyView(title: "هیچ داتایەک نە هاتە دیتن", message: "")
                            }
                        }else{
                            
                            if let data = jsonData["data"].array {
                                for dataItem in data {
                                    let product = ResultData(full_name: dataItem["full_name"].string  ?? "", remain: dataItem["remain"].string  ?? "", total: dataItem["total"].string  ?? "", id: dataItem["id"].string  ?? "", cash: dataItem["cash"].string  ?? "", date: dataItem["date"].string  ?? "")
                                    self.Results.append(product)
                                }
                            }
                            
                            let totalDict = jsonData["total"].dictionary
                            self.Cash.text = totalDict?["cashSum"]?.string ?? "".currencyFormattingIQD()
                            self.Total.text = totalDict?["totalSum"]?.string ?? "".currencyFormattingIQD()
                            self.Remain.text = totalDict?["remainSum"]?.string ?? "".currencyFormattingIQD()
                            self.activityIndicator.stopAnimating()
                        }
                        self.ResultsTableView.reloadData()
                        
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
                
                
                let param: [String: Any] = [
                    "fun":"lab_financial",
                    "id" : UserDefaults.standard.string(forKey: "id") ?? "",
                    "lab_id" : UserDefaults.standard.string(forKey: "my_lab_id") ?? "",
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
                            if XLanguage.get() == .English{
                                self.ResultsTableView.setEmptyView(title: "No Data Found", message: "There is no data between dates")
                            }else if XLanguage.get() == . Arabic{
                                self.ResultsTableView.setEmptyView(title: "لاتوجد بيانات", message: "")
                            }else{
                                self.ResultsTableView.setEmptyView(title: "هیچ داتایەک نە هاتە دیتن", message: "")
                            }
                        }else{
                            
                            if let data = jsonData["data"].array {
                                for dataItem in data {
                                    let product = ResultData(full_name: dataItem["full_name"].string  ?? "", remain: dataItem["remain"].string  ?? "", total: dataItem["total"].string  ?? "", id: dataItem["id"].string  ?? "", cash: dataItem["cash"].string  ?? "", date: dataItem["date"].string  ?? "")
                                    self.Results.append(product)
                                }
                            }
                            
                            let totalDict = jsonData["total"].dictionary
                            self.Cash.text = totalDict?["cashSum"]?.string?.currencyFormattingIQD()
                            self.Total.text = totalDict?["totalSum"]?.string?.currencyFormattingIQD()
                            self.Remain.text = totalDict?["remainSum"]?.string?.currencyFormattingIQD()
                            self.activityIndicator.stopAnimating()
                        }
                        self.ResultsTableView.reloadData()
                        
                        
                    case .failure(let error):
                        print("error 450 : error while Getting my tests")
                        print(error);
                    }
                }
            }
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
    
    
    
    func GetResults(){
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
                "fun":"lab_financial",
                "id" : UserDefaults.standard.string(forKey: "id") ?? "",
                "lab_id" : UserDefaults.standard.string(forKey: "my_lab_id") ?? "",
                "date_one" : formattedDateOne,
                "date_two" : formattedDateTow
            ]
            AF.request(stringUrl!, method: .post, parameters: param, headers:  headers).responseData { respons in
                switch respons.result{
                case .success:
                    let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                    if jsonData.count == 0{
                        self.activityIndicator.stopAnimating()
                        
                        if XLanguage.get() == .English{
                            self.ResultsTableView.setEmptyView(title: "No Data Found", message: "There is no data for today")
                        }else if XLanguage.get() == . Arabic{
                            self.ResultsTableView.setEmptyView(title: "لاتوجد بيانات", message: "")
                        }else{
                            self.ResultsTableView.setEmptyView(title: "هیچ داتایەک نە هاتە دیتن", message: "")
                        }
                    }else{
                        if let data = jsonData["data"].array {
                            for dataItem in data {
                                let product = ResultData(full_name: dataItem["full_name"].string  ?? "", remain: dataItem["remain"].string  ?? "", total: dataItem["total"].string  ?? "", id: dataItem["id"].string  ?? "", cash: dataItem["cash"].string  ?? "", date: dataItem["date"].string  ?? "")
                                self.Results.append(product)
                            }
                        }
                        
                        let totalDict = jsonData["total"].dictionary
                        self.Cash.text = totalDict?["cashSum"]?.string?.currencyFormattingIQD()
                        self.Total.text = totalDict?["totalSum"]?.string?.currencyFormattingIQD()
                        self.Remain.text = totalDict?["remainSum"]?.string?.currencyFormattingIQD()

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
                        self.ResultsTableView.setEmptyView(title: "No Data Found", message: "There is no data for today")
                    }else if XLanguage.get() == . Arabic{
                        self.ResultsTableView.setEmptyView(title: "لاتوجد بيانات", message: "")
                    }else{
                        self.ResultsTableView.setEmptyView(title: "هیچ داتایەک نە هاتە دیتن", message: "")
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



extension Income : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Results.count == 0{
            return 0
        }
        self.ResultsTableView.setEmptyView(title: "", message: "")
        return Results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! IncomeTableViewCell
        cell.InvDate.text = Results[indexPath.row].date
        if XLanguage.get() == .English{
            cell.invoicNum.text = "Invoice No: \(Results[indexPath.row].id)"
        }else if XLanguage.get() == .Arabic{
            cell.invoicNum.text = "رقم الفاتورة: \(Results[indexPath.row].id)"
        }else{
            cell.invoicNum.text = "ژمارا فاکتورێ: \(Results[indexPath.row].id)"
        }
        
        cell.Total.text = Results[indexPath.row].total.currencyFormattingIQD()
        cell.Remain.text = Results[indexPath.row].remain.currencyFormattingIQD()
        cell.Cash.text = Results[indexPath.row].cash.currencyFormattingIQD()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    


    
}



class ResultData{
    var full_name = ""
    var remain = ""
    var total = ""
    var id = ""
    var cash = ""
    var date = ""
    
    init(full_name: String, remain: String, total: String, id: String, cash: String, date: String) {
        self.full_name = full_name
        self.remain = remain
        self.total = total
        self.id = id
        self.cash = cash
        self.date = date
    }
}
