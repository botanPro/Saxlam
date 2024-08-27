//
//  LaborDetails.swift
//  sharktest
//
//  Created by Botan Amedi on 26/07/2023.
//

import UIKit
import PDFReader
import Alamofire
import SwiftyJSON
import MBRadioCheckboxButton
import Drops

class LaborDetails: UIViewController {

    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var LargView: GradientView!
    
    @IBOutlet weak var CollectionHeightLayout: NSLayoutConstraint!

    
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 16, bottom: 0.0, right:16)
    let spacingBetweenCells: CGFloat = 10
    var numberOfItemsPerRow: CGFloat = 2
    
    var LaborDetails : LabsObject?
    @IBOutlet weak var ScrollView: UIScrollView!
    
    var ServiceArray : [LaborServise] = []
    var SocialArray : [SocislObject] = []
    var lab_id = ""
    @IBOutlet weak var LabNum: UILabel!
    @IBOutlet weak var LabName: UILabel!
    @IBOutlet weak var LabImage: UIImageView!
    @IBOutlet weak var SocialCollectionview: UICollectionView!
    @IBOutlet weak var ServicesCollectionViewCell: UICollectionView!
    @IBOutlet weak var Titlee: UILabel!
    @IBOutlet weak var Website: UILabel!
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var OpenWeek: UILabel!
    @IBOutlet weak var OpenTime: UILabel!
    
    var phone = ""
    var lat = ""
    var long = ""
    var Desc = ""
    var color_top = ""
    var color_bottom = ""
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    override func viewDidLoad() {
        super.viewDidLoad()
        ServicesCollectionViewCell.register(UINib(nibName: "LabsServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        SocialCollectionview.register(UINib(nibName: "SocialCollectionviewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
   
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        self.ScrollView.isHidden = true
        
        
        
        if CheckInternet.Connection() == true{
            let stringUrl = URL(string: API.URL);
            let username = openCartApi.UserName
            let password = openCartApi.key
            let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
            var lang : Int = 0
            if XLanguage.get() == .English{
                lang = 1
            }else if XLanguage.get() == .Arabic{
                lang = 2
            }else{
                lang = 3
            }
            let param: [String: Any] = [
                "fun":"get_labs_info",
                "lab_id" : self.lab_id,
                "lang" : lang
            ]

            AF.request(stringUrl!, method: .post, parameters: param, headers:  headers).responseData { respons in
                switch respons.result{
                case .success:
                    let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                    if jsonData.count != 0{
                        self.activityIndicator.stopAnimating()
                        self.ScrollView.isHidden = false
                        if let data = jsonData["social"].array {
                            for dataItem in data {
                                let social = SocislObject(image: dataItem["image"].string ?? "", url: dataItem["url"].string ?? "",color_top:dataItem["color_top"].string ?? "", color_bottom:dataItem["color_bottom"].string ?? "")
                                self.SocialArray.append(social)
                            }
                        }
                        
                        if let data = jsonData["data"].array {
                            for totalDict in data {
                                self.lat = totalDict["lat"].string ?? ""
                                self.long = totalDict["long"].string ?? ""
                                self.color_top = totalDict["color_top"].string ?? ""
                                self.color_bottom = totalDict["color_bottom"].string ?? ""
                                let urlString = "\(API.Labs)\(totalDict["logo"].string ?? "")"
                                let url = URL(string: urlString)
                                self.LabImage.sd_setImage(with: url, completed: nil)
                                self.LabName.text = totalDict["phone"].string ?? ""
                                self.Titlee.text = totalDict["title"].string ?? ""
                                self.phone = totalDict["phone"].string ?? ""
                                self.Website.text = totalDict["website"].string ?? ""
                                self.Desc = totalDict["disc"].string ?? ""
                                self.lab_id = totalDict["id"].string ?? ""
                                self.LabNum.text = totalDict["title"].string ?? ""
                                self.lat = totalDict["lat"].string ?? ""
                                self.OpenWeek.text = totalDict["open_week"].string ?? ""
                                self.OpenTime.text = totalDict["open_hour"].string ?? ""
                                self.Address.text = totalDict["address"].string ?? ""
                            }
                        }
                        
                        
                        self.SocialCollectionview.reloadData()
                        self.activityIndicator.stopAnimating()
                        self.ScrollView.isHidden = false
                        
                    }else{
                        self.ScrollView.isHidden = false
                    }
                case .failure(let error):
                    print("error 450 : error while Getting tests")
                    print(error);
                }
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if XLanguage.get() == .English{
            ServiceArray = [
                LaborServise.init(Title: "Tests Result", Desc: "See all your results", Logo: UIImage(named: "blank-page") ?? UIImage(), BackColor: #colorLiteral(red: 0.6745098039, green: 0.8941176471, blue: 0.8039215686, alpha: 1),IconColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BackIconColor : #colorLiteral(red: 0.1960784314, green: 0.737254902, blue: 0.5176470588, alpha: 1) ),
                LaborServise.init(Title: "Call Us", Desc: "Avaiable at \(self.OpenTime.text!)", Logo: UIImage(named: "phone-call") ?? UIImage(),  BackColor: #colorLiteral(red: 0.8431372549, green: 0.8941176471, blue: 0.9803921569, alpha: 1),IconColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BackIconColor : #colorLiteral(red: 0.7764705882, green: 0.6980392157, blue: 1, alpha: 1)),
                LaborServise.init(Title: "Order Car", Desc: "Order car Now", Logo: UIImage(named: "sports-car") ?? UIImage(), BackColor: #colorLiteral(red: 0.9960784314, green: 0.9294117647, blue: 0.8196078431, alpha: 1),IconColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BackIconColor : #colorLiteral(red: 1, green: 0.6666666667, blue: 0.09411764706, alpha: 1)),
                LaborServise.init(Title: "Location", Desc: "Find us", Logo: UIImage(named: "location-pin") ?? UIImage(),  BackColor: #colorLiteral(red: 1, green: 0.8078431373, blue: 0.8117647059, alpha: 1),IconColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BackIconColor : #colorLiteral(red: 0.8862745098, green: 0.2745098039, blue: 0.003921568627, alpha: 1)),
                LaborServise.init(Title: "Posts", Desc: "View All Posts", Logo: UIImage(named: "postcard-svgrepo-com") ?? UIImage(),   BackColor: #colorLiteral(red: 0.9411764706, green: 0.7843137255, blue: 0.8039215686, alpha: 1),IconColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BackIconColor : #colorLiteral(red: 0.8666666667, green: 0.4588235294, blue: 0.5254901961, alpha: 1)),
                LaborServise.init(Title: "About Us", Desc: "Learn more about us", Logo: UIImage(named: "information-svgrepo-com") ?? UIImage(),   BackColor: #colorLiteral(red: 0.8431372549, green: 0.8941176471, blue: 0.9803921569, alpha: 1),IconColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BackIconColor : #colorLiteral(red: 0.7764705882, green: 0.6980392157, blue: 1, alpha: 1)),
            ]
        }else if XLanguage.get() == .Arabic{
            ServiceArray = [
                LaborServise.init(Title: "نتائج المختبر", Desc: "رؤية جميع نتائجك", Logo: UIImage(named: "blank-page") ?? UIImage(), BackColor: #colorLiteral(red: 0.6745098039, green: 0.8941176471, blue: 0.8039215686, alpha: 1),IconColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BackIconColor : #colorLiteral(red: 0.1960784314, green: 0.737254902, blue: 0.5176470588, alpha: 1) ),
                LaborServise.init(Title: "اتصل بنا", Desc: "\(self.OpenTime.text!)", Logo: UIImage(named: "phone-call") ?? UIImage(),  BackColor: #colorLiteral(red: 0.8431372549, green: 0.8941176471, blue: 0.9803921569, alpha: 1),IconColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BackIconColor : #colorLiteral(red: 0.7764705882, green: 0.6980392157, blue: 1, alpha: 1)),
                LaborServise.init(Title: "اطلب السیارة", Desc: "اطلب السيارة الآن", Logo: UIImage(named: "sports-car") ?? UIImage(), BackColor: #colorLiteral(red: 0.9960784314, green: 0.9294117647, blue: 0.8196078431, alpha: 1),IconColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BackIconColor : #colorLiteral(red: 1, green: 0.6666666667, blue: 0.09411764706, alpha: 1)),
                LaborServise.init(Title: "العنوان", Desc: "ابحث عنا", Logo: UIImage(named: "location-pin") ?? UIImage(),  BackColor: #colorLiteral(red: 1, green: 0.8078431373, blue: 0.8117647059, alpha: 1),IconColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BackIconColor : #colorLiteral(red: 0.8862745098, green: 0.2745098039, blue: 0.003921568627, alpha: 1)),
                LaborServise.init(Title: "المنشورات", Desc: "استعرض كل المنشورات", Logo: UIImage(named: "postcard-svgrepo-com") ?? UIImage(),   BackColor: #colorLiteral(red: 0.9411764706, green: 0.7843137255, blue: 0.8039215686, alpha: 1),IconColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BackIconColor : #colorLiteral(red: 0.8666666667, green: 0.4588235294, blue: 0.5254901961, alpha: 1)),
                LaborServise.init(Title: "معلومات عنا", Desc: "تعرف أكثر عنا", Logo: UIImage(named: "information-svgrepo-com") ?? UIImage(),   BackColor: #colorLiteral(red: 0.8431372549, green: 0.8941176471, blue: 0.9803921569, alpha: 1),IconColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BackIconColor : #colorLiteral(red: 0.7764705882, green: 0.6980392157, blue: 1, alpha: 1)),
            ]
        }else{
            ServiceArray = [
                LaborServise.init(Title: "ئەنجامێن پشکنینا", Desc: "ئەنجامێن خو ل ڤێرێ ببینە", Logo: UIImage(named: "blank-page") ?? UIImage(), BackColor: #colorLiteral(red: 0.6745098039, green: 0.8941176471, blue: 0.8039215686, alpha: 1),IconColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BackIconColor : #colorLiteral(red: 0.1960784314, green: 0.737254902, blue: 0.5176470588, alpha: 1) ),
                LaborServise.init(Title: "پەیوەندیێ بکە", Desc: "\(self.OpenTime.text!)", Logo: UIImage(named: "phone-call") ?? UIImage(),  BackColor: #colorLiteral(red: 0.8431372549, green: 0.8941176471, blue: 0.9803921569, alpha: 1),IconColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BackIconColor : #colorLiteral(red: 0.7764705882, green: 0.6980392157, blue: 1, alpha: 1)),
                LaborServise.init(Title: "داخازکرنا ئوتومبێل", Desc: "ئوتومبێلێ دخازبکە", Logo: UIImage(named: "sports-car") ?? UIImage(), BackColor: #colorLiteral(red: 0.9960784314, green: 0.9294117647, blue: 0.8196078431, alpha: 1),IconColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BackIconColor : #colorLiteral(red: 1, green: 0.6666666667, blue: 0.09411764706, alpha: 1)),
                LaborServise.init(Title: "جهێ مە", Desc: "جهێ مە ببینە", Logo: UIImage(named: "location-pin") ?? UIImage(),  BackColor: #colorLiteral(red: 1, green: 0.8078431373, blue: 0.8117647059, alpha: 1),IconColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BackIconColor : #colorLiteral(red: 0.8862745098, green: 0.2745098039, blue: 0.003921568627, alpha: 1)),
                LaborServise.init(Title: "پوست", Desc: "هەمی پوستان ببینە", Logo: UIImage(named: "postcard-svgrepo-com") ?? UIImage(),   BackColor: #colorLiteral(red: 0.9411764706, green: 0.7843137255, blue: 0.8039215686, alpha: 1),IconColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BackIconColor : #colorLiteral(red: 0.8666666667, green: 0.4588235294, blue: 0.5254901961, alpha: 1)),
                LaborServise.init(Title: "دەربارەی مە", Desc: "زانیاریێن زێدەتر دەربارەی مە", Logo: UIImage(named: "information-svgrepo-com") ?? UIImage(),   BackColor: #colorLiteral(red: 0.8431372549, green: 0.8941176471, blue: 0.9803921569, alpha: 1),IconColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), BackIconColor : #colorLiteral(red: 0.7764705882, green: 0.6980392157, blue: 1, alpha: 1)),
            ]
        }
        
        self.ServicesCollectionViewCell.reloadData()

        
        
    }

    
    func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            let height = self.ServicesCollectionViewCell.collectionViewLayout.collectionViewContentSize.height
            self.CollectionHeightLayout.constant = height
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    
    


}

extension LaborDetails : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.ServicesCollectionViewCell{
            if ServiceArray.count == 0 {
                return 0
            }else{
                return ServiceArray.count
            }
        }else{
            if SocialArray.count == 0 {
                return 0
            }else{
                return SocialArray.count
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.ServicesCollectionViewCell{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LabsServiceCollectionViewCell
            cell.Titlee.text = ServiceArray[indexPath.row].Title
            cell.Desc.text = ServiceArray[indexPath.row].Desc
            cell.BackIconView.backgroundColor = ServiceArray[indexPath.row].BackIconColor
            cell.BackView.backgroundColor = ServiceArray[indexPath.row].BackColor
            cell.Icon.image = ServiceArray[indexPath.row].Logo
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SocialCollectionviewCell
            let urlString = "\(API.SocialImages)\(self.SocialArray[indexPath.row].image)"
            let url = URL(string: urlString)
            cell.Image.sd_setImage(with: url, completed: nil)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.ServicesCollectionViewCell{
            let totalSpacing = (2 * sectionInsets.left) + ((numberOfItemsPerRow - 1) * 10)
            let width = (collectionView.bounds.width - totalSpacing)/2
            return CGSize(width: width, height: 175)
        }else{
            return CGSize(width: 50, height: 50)
        }
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         if collectionView == self.ServicesCollectionViewCell{
             return sectionInsets
         }else{
             return UIEdgeInsets(top: 0.0, left: 20, bottom: 0.0, right:20)
         }
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         if collectionView == self.ServicesCollectionViewCell{
             return spacingBetweenCells
         }else{
             return 10
         }
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.ServicesCollectionViewCell{
            if indexPath.row == 0{
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let Results = storyboard.instantiateViewController(withIdentifier: "Results") as! Results
                Results.modalPresentationStyle = .fullScreen
                Results.lab_id = self.lab_id
                UserDefaults.standard.setValue(self.lab_id, forKey: "lab_id")
                self.present(Results, animated: true, completion: nil)
            }
            
            if indexPath.row == 1{
                if let url = URL(string: "tel://+964\(self.phone)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
            if indexPath.row == 2{
                if let url = URL(string: "tel://+964\(self.phone)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
            if indexPath.row == 3{
                if let UrlNavigation = URL.init(string: "comgooglemaps://") {
                    if UIApplication.shared.canOpenURL(UrlNavigation){
                        if let urlDestination = URL.init(string: "comgooglemaps://?saddr=&daddr=\(self.lat.trimmingCharacters(in: .whitespaces)),\(self.long.trimmingCharacters(in: .whitespaces))&directionsmode=driving") {
                            UIApplication.shared.open(urlDestination)
                        }
                    }else {
                        NSLog("Can't use comgooglemaps://");
                        self.openTrackerInBrowser()
                    }
                }else{
                    NSLog("Can't use comgooglemaps://");
                    self.openTrackerInBrowser()
                }
            }
            
            if indexPath.row == 4{
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let Results = storyboard.instantiateViewController(withIdentifier: "AvailableTests") as! AvailableTests
                Results.modalPresentationStyle = .fullScreen
                Results.lab_id = self.lab_id
                UserDefaults.standard.setValue(self.lab_id, forKey: "lab_id")
                self.present(Results, animated: true, completion: nil)
            }
            
            if indexPath.row == 5{
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let Results = storyboard.instantiateViewController(withIdentifier: "AboutUs") as! AboutUs
                Results.modalPresentationStyle = .fullScreen
                Results.txt = self.Desc
                self.present(Results, animated: true, completion: nil)
            }
        }else{
            if let url = URL(string: self.SocialArray[indexPath.row].url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

func openTrackerInBrowser(){
   if let urlDestination = URL.init(string: "http://maps.google.com/maps?q=loc:\(self.lat.trimmingCharacters(in: .whitespaces)),\(self.long.trimmingCharacters(in: .whitespaces))&directionsmode=driving") {
          UIApplication.shared.open(urlDestination)
       print("p[p[p[p")
      }
  }
    

}


class LaborServise{
    var Title = ""
    var Desc = ""
    var Logo : UIImage
    var BackColor : UIColor
    var IconColor : UIColor
    var BackIconColor : UIColor
    
    init(Title: String, Desc: String, Logo: UIImage, BackColor: UIColor, IconColor: UIColor, BackIconColor: UIColor) {
        self.Title = Title
        self.Desc = Desc
        self.Logo = Logo
        self.BackColor = BackColor
        self.IconColor = IconColor
        self.BackIconColor = BackIconColor
    }

}

class SocislObject{
    var image = ""
    var url = ""
    var color_top = ""
    var color_bottom = ""
    init(image: String, url: String,color_top :String, color_bottom : String) {
        self.image = image
        self.url = url
        self.color_top = color_top
        self.color_bottom = color_bottom
    }

}


