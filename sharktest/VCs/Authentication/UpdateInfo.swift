//
//  UpdateInfo.swift
//  sharktest
//
//  Created by Botan Amedi on 31/08/2023.
//

import UIKit
import SwiftUI
import Drops
class UpdateInfo: UIViewController {
    
    @IBOutlet weak var Address: UITextField!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Female: Languagebutton!
    @IBOutlet weak var male: Languagebutton!
    
    
    
    @IBOutlet weak var DatePickerr: UIDatePicker!
    
    @IBAction func DatePickerr(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let currentDate = Date()
        let formattedCurrentDate = dateFormatter.string(from: sender.date)
        self.Birthday = formattedCurrentDate
        self.Birthdaylable.text = formattedCurrentDate
    }
    @IBOutlet weak var Birthdaylable: UILabel!
    
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    var Birthday = ""
    var IsGender = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.male.layer.cornerRadius = 8
        self.Female.layer.cornerRadius = 8
        
        ProfileDataAPI.GetProfileData(id: UserDefaults.standard.string(forKey: "id") ?? "") { data,error  in
            if error == ""{
                self.Name.text = data.full_name
                self.Address.text = data.address
                
                self.Birthdaylable.text = data.birthday
                self.Birthday = data.birthday
                self.IsGender = "Male"
                self.male.backgroundColor = #colorLiteral(red: 0.1620929837, green: 0.4347665906, blue: 0.8148480654, alpha: 1)
                self.male.tintColor = UIColor.white
                self.male.layer.borderWidth = 0
                self.male.layer.borderColor = UIColor.clear.cgColor
                
                self.Female.backgroundColor = UIColor.white
                self.Female.tintColor = #colorLiteral(red: 0.1620929837, green: 0.4347665906, blue: 0.8148480654, alpha: 1)
                self.Female.layer.borderWidth = 0.8
                self.Female.layer.borderColor = #colorLiteral(red: 0.1620929837, green: 0.4347665906, blue: 0.8148480654, alpha: 1)
                
                if data.gender == "Male"{
                    self.IsGender = "Male"
                    self.male.backgroundColor = #colorLiteral(red: 0.1620929837, green: 0.4347665906, blue: 0.8148480654, alpha: 1)
                    self.male.tintColor = UIColor.white
                    self.male.layer.borderWidth = 0
                    self.male.layer.borderColor = UIColor.clear.cgColor
                    
                    self.Female.backgroundColor = UIColor.white
                    self.Female.tintColor = #colorLiteral(red: 0.1620929837, green: 0.4347665906, blue: 0.8148480654, alpha: 1)
                    self.Female.layer.borderWidth = 0.8
                    self.Female.layer.borderColor = #colorLiteral(red: 0.1620929837, green: 0.4347665906, blue: 0.8148480654, alpha: 1)
                }else{
                    self.IsGender = "Female"
                    self.Female.backgroundColor = #colorLiteral(red: 0.1620929837, green: 0.4347665906, blue: 0.8148480654, alpha: 1)
                    self.Female.tintColor = UIColor.white
                    self.Female.layer.borderWidth = 0
                    self.Female.layer.borderColor = UIColor.clear.cgColor
                    
                    self.male.backgroundColor = UIColor.white
                    self.male.tintColor = #colorLiteral(red: 0.1620929837, green: 0.4347665906, blue: 0.8148480654, alpha: 1)
                    self.male.layer.borderWidth = 0.8
                    self.male.layer.borderColor = #colorLiteral(red: 0.1620929837, green: 0.4347665906, blue: 0.8148480654, alpha: 1)
                }
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
            }
        }
    }
    
    
    
    
    
    
    
    @IBAction func Male(_ sender: Any) {
        self.IsGender = "Male"
        self.male.backgroundColor = #colorLiteral(red: 0.1620929837, green: 0.4347665906, blue: 0.8148480654, alpha: 1)
        self.male.tintColor = UIColor.white
        self.male.layer.borderWidth = 0
        self.male.layer.borderColor = UIColor.clear.cgColor
        
        self.Female.backgroundColor = UIColor.white
        self.Female.tintColor = #colorLiteral(red: 0.1620929837, green: 0.4347665906, blue: 0.8148480654, alpha: 1)
        self.Female.layer.borderWidth = 0.8
        self.Female.layer.borderColor = #colorLiteral(red: 0.1620929837, green: 0.4347665906, blue: 0.8148480654, alpha: 1)
    }
    
    
    @IBAction func Female(_ sender: Any) {
        self.IsGender = "Female"
        self.Female.backgroundColor = #colorLiteral(red: 0.1620929837, green: 0.4347665906, blue: 0.8148480654, alpha: 1)
        self.Female.tintColor = UIColor.white
        self.Female.layer.borderWidth = 0
        self.Female.layer.borderColor = UIColor.clear.cgColor
        
        self.male.backgroundColor = UIColor.white
        self.male.tintColor = #colorLiteral(red: 0.1620929837, green: 0.4347665906, blue: 0.8148480654, alpha: 1)
        self.male.layer.borderWidth = 0.8
        self.male.layer.borderColor = #colorLiteral(red: 0.1620929837, green: 0.4347665906, blue: 0.8148480654, alpha: 1)
    }
    
    
    
    
    @IBAction func Update(_ sender: Any) {print("1")
        if CheckInternet.Connection() == true{print("2")
            if self.Name.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""{print("3")
                
                ProfileDataAPI.update(profile_id:  UserDefaults.standard.string(forKey: "id") ?? "", full_name: self.Name.text!, birthday: self.Birthday, gender: self.IsGender, address: self.Address.text!) { done in
                    self.dismiss(animated: true)
                }
            }else{print("4")
                if XLanguage.get() == .English{
                    let myAlert = UIAlertController(title: "", message: "Please write your name to continue", preferredStyle: UIAlertController.Style.alert)
                    myAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(myAlert, animated: true, completion: nil)
                }else if XLanguage.get() == .Arabic{
                    let myAlert = UIAlertController(title: "", message: "من فضلك اكتب اسمك للمتابعة", preferredStyle: UIAlertController.Style.alert)
                    myAlert.addAction(UIAlertAction(title: "حسنا", style: UIAlertAction.Style.default, handler: nil))
                    self.present(myAlert, animated: true, completion: nil)
                }else{
                    let myAlert = UIAlertController(title: "", message: "هیڤیە بو بەردەوامبوونێ ناڤێ خو بنڤیسە", preferredStyle: UIAlertController.Style.alert)
                    myAlert.addAction(UIAlertAction(title: "باشە", style: UIAlertAction.Style.default, handler: nil))
                    self.present(myAlert, animated: true, completion: nil)
                }
            }
            
        }else{print("5")
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

