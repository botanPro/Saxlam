//
//  Search.swift
//  sharktest
//
//  Created by Botan Amedi on 22/01/2023.
//

import UIKit
import Alamofire
import SwiftyJSON
import Drops
class Search: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var CollectionHeightLayout: NSLayoutConstraint!
    
    @IBOutlet weak var AllLaborsCollectionView: UICollectionView!
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 22.0, bottom: 0.0, right: 22.0)
    let spacingBetweenCells: CGFloat = 11
    var LaborArray : [LabsObject] = []
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    @IBOutlet weak var SearchView: UIView!
    
    @IBOutlet weak var BottomLayout: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SearchTextField.delegate = self
        self.SearchTextField.becomeFirstResponder()
        AllLaborsCollectionView.register(UINib(nibName: "LabsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        self.SearchView.layer.masksToBounds = false
        self.SearchView.layer.shadowColor = UIColor.lightGray.cgColor
        self.SearchView.layer.shadowOpacity = 0.2
        self.SearchView.layer.shadowOffset = .zero
        self.SearchView.layer.shadowRadius = 6
        self.SearchView.layer.shouldRasterize = true
        self.SearchView.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        self.SearchView.layer.cornerRadius = 16
        
        
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        GetLAbs()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHiden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    var isSearched = false
    func GetLAbs(){
        if CheckInternet.Connection() == true{
            self.isSearched = false
                self.LaborArray.removeAll()
                LabsObjectAPI.GetLAbs { Labs,error  in
            if error == ""{
                self.activityIndicator.stopAnimating()
                self.LaborArray = Labs
                self.AllLaborsCollectionView.reloadData()
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
        
            Drops.hideAll()
        self.activityIndicator.stopAnimating()
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    lazy var workItem = WorkItem()
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if CheckInternet.Connection() == true{
            if textField.text?.count == 1{
                self.GetLAbs()
            }else{
                self.activityIndicator.startAnimating()
                self.workItem.perform(after: 0.3) {
                    let stringUrl = URL(string: API.URL);
                    let username = openCartApi.UserName
                    let password = openCartApi.key
                    let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
                    let base64Credentials = credentialData.base64EncodedString(options: [])
                    let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
                    let lang : Int = UserDefaults.standard.integer(forKey: "Language")
                    let param: [String: Any] = [
                        "fun":"search_labs",
                        "text" : textField.text ?? "",
                        "lang" : lang
                    ]
                    
                    AF.request(stringUrl!, method: .post, parameters: param, headers:  headers).responseData { respons in
                        switch respons.result{
                        case .success:
                            let jsonData = JSON(respons.data ?? "")
                            print(jsonData)
                            if jsonData.count == 0{print("eeeeee\(jsonData.count)")
                                self.activityIndicator.stopAnimating()
                                self.LaborArray.removeAll()
                                self.AllLaborsCollectionView.reloadData()
                                if XLanguage.get() == .English{
                                    self.AllLaborsCollectionView.setEmptyView(title: "No laboratories Found", message: "There are no laboratories")
                                }else if XLanguage.get() == .Arabic{
                                    self.AllLaborsCollectionView.setEmptyView(title: "لم يتم العثور على مختبرات", message: "لا يوجد مختبرات")
                                }else{
                                    self.AllLaborsCollectionView.setEmptyView(title: "هیچ تاقیگەهەک نە هاتە دیتن", message: "")
                                }
                            }else{
                                self.activityIndicator.stopAnimating()
                                for (_,val) in jsonData{
                                    let product = LabsObject(id: val["id"].string ?? "", title: val["title"].string ?? "", disc: val["disc"].string ?? "", logo: val["logo"].string ?? "", website: val["website"].string ?? "", address: val["address"].string ?? "", open_week: val["open_week"].string ?? "", open_hour: val["open_hour"].string ?? "", phone: val["phone"].string ?? "")
                                    self.LaborArray.append(product)
                                }
                                self.AllLaborsCollectionView.setEmptyView(title: "", message: "")
                                self.AllLaborsCollectionView.reloadData()
                            }
                        case .failure(let error):
                            self.activityIndicator.stopAnimating()
                            print("error 450 : error while Getting search labs")
                            print(error);
                        }
                    }
                }
            }
        
        }
        return true
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
    
    @IBAction func DismissKeyBoard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if self.LaborArray.count != 0{
                let height = self.AllLaborsCollectionView.collectionViewLayout.collectionViewContentSize.height
                self.CollectionHeightLayout.constant = height
            }else{
                self.CollectionHeightLayout.constant = 500
            }
            
        }
    }

}

extension Search : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if LaborArray.count == 0 {
                return 0
            }
            self.AllLaborsCollectionView.setEmptyView(title: "", message: "")
            return LaborArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LabsCollectionViewCell
        cell.Name.text = LaborArray[indexPath.row].title
        cell.Location.text = LaborArray[indexPath.row].address
        cell.hour.text = LaborArray[indexPath.row].open_hour
        cell.Week.text = LaborArray[indexPath.row].open_week
        
        let urlString = "\(API.Labs)\(LaborArray[indexPath.row].logo)"
        let url = URL(string: urlString)
        cell.Imagee?.sd_setImage(with: url, completed: nil)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 150)

     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return sectionInsets
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return spacingBetweenCells
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.LaborArray.count != 0 && indexPath.row <= self.LaborArray.count{
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let LaborDetails = storyboard.instantiateViewController(withIdentifier: "LaborDetails") as! LaborDetails
            LaborDetails.modalPresentationStyle = .fullScreen
            LaborDetails.lab_id = self.LaborArray[indexPath.row].id
            self.present(LaborDetails, animated: true, completion: nil)
        }
    }
    

}


