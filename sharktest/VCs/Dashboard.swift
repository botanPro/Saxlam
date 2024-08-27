//
//  Dashboard.swift
//  sharktest
//
//  Created by Botan Amedi on 27/01/2024.
//

import UIKit

import Alamofire
import SwiftyJSON
import SwiftChart
import Drops
class Dashboard: UIViewController {
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBAction func Dismiss(_ sender : Any){
        self.dismiss(animated: true)
    }
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)

    
    @IBOutlet weak var ChartView: Chart!
    
    @IBOutlet weak var PatientTotal: UILabel!
    @IBOutlet weak var PatientToday: UILabel!
    
    @IBOutlet weak var InvoiceTotal: UILabel!
    @IBOutlet weak var InvoiceToday: UILabel!
    
    @IBOutlet weak var ResultTotal: UILabel!
    @IBOutlet weak var ResultToday: UILabel!
    
    
    @IBOutlet weak var UsersTotal: UILabel!
    
    @IBOutlet weak var IncomePrice: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ScrollView.isHidden = true

        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        
        
        if CheckInternet.Connection() == true{
            getChartData { chartData in
                if chartData.count != 0{
                    var serieData: [Double] = []
                    var labels: [Double] = []
                    var labelsAsString: Array<String> = []
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM"
                    
                    for (i, value) in chartData.enumerated() {
                        if let dateString = value["date"] as? String,
                           let date = dateFormatter.date(from: dateString) {
                            serieData.append(value["close"] as! Double)
                            
                            let monthAsString = dateFormatter.string(from: date)
                            if labels.count == 0 || labelsAsString.last != monthAsString {
                                labels.append(Double(i))
                                labelsAsString.append(monthAsString)
                            }
                        }
                    }
                    
                    let series = ChartSeries(serieData)
                    series.area = true
                    
                    self.ChartView.lineWidth = 0.5
                    self.ChartView.labelFont = UIFont.systemFont(ofSize: 8)
                    self.ChartView.xLabels = labels
                    self.ChartView.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
                        return labelsAsString[labelIndex]
                    }
                    self.ChartView.xLabelsTextAlignment = .center
                    self.ChartView.yLabelsOnRightSide = true
                    // Add some padding above the x-axis
                    if let minData = serieData.min() {
                        self.ChartView.minY = minData - 5
                    } else {
                        // Handle the case where serieData is nil or min() returns nil
                        print("Error: serieData is nil or min() returns nil")
                    }
                    
                    self.ChartView.add(series)
                }
            }
            
            
            
            GetStatistics()
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
    
    
    
    var labelsAsString: Array<String> = []
    func getChartData(completion: @escaping (Array<Dictionary<String, Any>>) -> Void) {
        let stringUrl = URL(string: API.URL)
        let username = openCartApi.UserName
        let password = openCartApi.key
        let credentialData = "\(username):\(password)".data(using: .utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers: HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
        let param: [String: Any] = [
            "fun": "get_lab_chart_static",
            "id": UserDefaults.standard.string(forKey: "id") ?? "",
            "lab_id": UserDefaults.standard.string(forKey: "my_lab_id") ?? ""
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param, headers: headers).responseData { response in
            switch response.result {
            case .success:
                if let jsonData = try? JSON(data: response.data ?? Data()) {
                    print(jsonData)
                    var dataArray: [Dictionary<String, Any>] = []
                    self.activityIndicator.stopAnimating()
                    self.ScrollView.isHidden = false
                    for (_, val) in jsonData {
                        let date = val["mon"].string ?? ""
                        let close = val["count"].string ?? ""
                        let count = (close as NSString).doubleValue
                        let dataEntry: [String: Any] = ["date": date, "close": count]
                        dataArray.append(dataEntry)
                    }

                    completion(dataArray)
                }
            case .failure(let error):
                print("error 450: error while getting chart data")
                print(error)
                completion([])
            }
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // Redraw chart on rotation
        self.ChartView.setNeedsDisplay()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetStatistics()
    }
    
    func GetStatistics(){
        let stringUrl = URL(string: API.URL);
        let username = openCartApi.UserName
        let password = openCartApi.key
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
        let param: [String: Any] = [
            "fun":"get_lab_statistic",
            "id" : UserDefaults.standard.string(forKey: "id") ?? "",
            "lab_id": UserDefaults.standard.string(forKey: "my_lab_id") ?? ""
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param, headers:  headers).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                     print(jsonData)
                self.activityIndicator.stopAnimating()
                self.ScrollView.isHidden = false
                for (_,val) in jsonData{
                    self.PatientTotal.text = val["totalPeople"].string?.NumberFormatting()
                    self.PatientToday.text = val["peopleToday"].string?.NumberFormatting()
                    
                    
                    self.InvoiceTotal.text = val["totalInvoice"].string?.NumberFormatting()
                    self.InvoiceToday.text = val["invoiceToday"].string?.NumberFormatting()
                    
                    
                    self.ResultTotal.text = val["resultTotal"].string?.NumberFormatting()
                    self.ResultToday.text = val["resultToday"].string?.NumberFormatting()
                    
                    if val["incomeToday"].string == "0" || val["incomeToday"].string == "" || val["incomeToday"].string == " "{
                        self.IncomePrice.text = "IQD 0,0"
                    }else{
                        self.IncomePrice.text = val["incomeToday"].string?.currencyFormattingIQD()
                    }
                    self.GetLabsViews()
                }
            case .failure(let error):
                print("error 450 : error while Getting Statistics")
                print(error);
            }
        }
    }
    
    
    func GetLabsViews(){
        let stringUrl = URL(string: API.URL);
        let username = openCartApi.UserName
        let password = openCartApi.key
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
        let param: [String: Any] = [
            "fun":"get_lab_views",
            "lab_id": UserDefaults.standard.string(forKey: "my_lab_id") ?? ""
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param, headers:  headers).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                     print(jsonData)
                self.activityIndicator.stopAnimating()
                self.ScrollView.isHidden = false
                for (_,val) in jsonData{
                    print(val["views"].string ?? "")
                    
                    self.UsersTotal.text = val["views"].string ?? ""
                }
            case .failure(let error):
                print("error 450 : error while Getting Statistics")
                print(error);
            }
        }
    }
    
    
    
    @IBAction func Incom(_ sender: Any) {
        
        
    }
    
    
    @IBAction func Results(_ sender: Any) {
        
        
    }
    
}



class ChartData{
    var count = ""
    var mon = ""
    
    init(count: String , mon: String) {
        self.count = count
        self.mon = mon
    }
}
