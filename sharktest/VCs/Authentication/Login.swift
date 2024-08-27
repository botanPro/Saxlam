//
//  Login.swift
//  sharktest
//
//  Created by Botan Amedi on 27/07/2023.
//

import UIKit
import PhoneNumberKit
import MHLoadingButton
import Firebase
import FirebaseAuth
import Drops
class Login: UIViewController {
    
    @IBOutlet weak var PhoneNumber: PhoneNumberTextField!
    
    @IBOutlet weak var Login: UIButton!
    
    var TextLength = 0
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        TextLength = textField.text?.count ?? 0
        return false
    }
    
    @IBOutlet weak var DimissImage: UIImageView!
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.PhoneNumber.becomeFirstResponder()
        
        self.PhoneNumber.keyboardType = .asciiCapable
        self.PhoneNumber.withPrefix = true
        self.PhoneNumber.withFlag = true
        self.PhoneNumber.withExamplePlaceholder = true
        
        
    }
    
    
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

    var phone = ""
    @IBAction func Login(_ sender: Any) {
        if CheckInternet.Connection() == true{
            if self.PhoneNumber.text != ""{
                let str = self.PhoneNumber.text!
                if str.count > 5{
                    let index = str.index(str.startIndex, offsetBy: 5)
                    if str[index] == "0" && self.PhoneNumber.currentRegion == "IQ"{
                        self.phone = self.PhoneNumber.text!
                        self.phone.remove(at: index)
                    }else{
                        self.phone = self.PhoneNumber.text!
                    }
                }
                print(self.phone)
                self.Login.isUserInteractionEnabled = false
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
                CheckPhoneAPI.CheckPhone(phone: self.phone.convertedDigitsToLocale(Locale(identifier: "EN")).removeWhitespace()) { data,error in
                    if error == ""{
                    if data[1] == "0"{
                        PhoneAuthProvider.provider().verifyPhoneNumber(self.phone.convertedDigitsToLocale(Locale(identifier: "EN")), uiDelegate: nil) { (verificationID, error) in
                            if let error = error {
                                print(error)
                                self.Login.isUserInteractionEnabled = true
                                let myMessage = error.localizedDescription
                                self.alert.dismiss(animated: true) {
                                    let myAlert = UIAlertController(title: nil, message: myMessage, preferredStyle: UIAlertController.Style.alert)
                                    myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(myAlert, animated: true, completion: nil)
                                }
                                return
                            }
                            self.alert.dismiss(animated: true) {
                                UserDefaults.standard.set(self.PhoneNumber.text!, forKey: "PhoneNumber")
                                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let myVC = storyboard.instantiateViewController(withIdentifier: "VeryingVC") as! Verifying
                                myVC.modalPresentationStyle = .fullScreen
                                myVC.IsCheckPhoneZero = true
                                self.Login.isUserInteractionEnabled = true
                                self.present(myVC, animated: true)
                            }
                            
                        }
                    }else{
                        
                        PhoneAuthProvider.provider().verifyPhoneNumber(self.phone.convertedDigitsToLocale(Locale(identifier: "EN")), uiDelegate: nil) { (verificationID, error) in
                            self.alert.dismiss(animated: true) {
                                if let error = error {
                                    print(error)
                                    self.Login.isUserInteractionEnabled = true
                                    let myMessage = error.localizedDescription
                                    let myAlert = UIAlertController(title: nil, message: myMessage, preferredStyle: UIAlertController.Style.alert)
                                    myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(myAlert, animated: true, completion: nil)
                                    return
                                }
                                UserDefaults.standard.set(self.PhoneNumber.text!, forKey: "PhoneNumber")
                                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let myVC = storyboard.instantiateViewController(withIdentifier: "VeryingVC") as! Verifying
                                myVC.modalPresentationStyle = .fullScreen
                                self.Login.isUserInteractionEnabled = true
                                myVC.IsCheckPhoneZero = false
                                self.present(myVC, animated: true)
                            }
                        }
                    }
                    }else{
                        self.alert.dismiss(animated: true) {
                            self.Login.isUserInteractionEnabled = true
                        }
                    }
                    
                }
            }else{
                self.alert.dismiss(animated: true) {
                    self.Login.isUserInteractionEnabled = true
                    if self.PhoneNumber.text == ""{
                        var mss = ""
                        var action = ""
                        if XLanguage.get() == .English{
                            mss = "Please enter phone number"
                            action = "Ok"
                        }else if XLanguage.get() == .Kurdish{
                            mss = "هیڤیە ژمارا مۆبایلێ بنڤیسە"
                            action = "باشە"
                        }else{
                            mss = "الرجاء إدخال رقم الهاتف"
                            action = "حسنا"
                        }
                        let myAlert = UIAlertController(title: nil, message: mss, preferredStyle: UIAlertController.Style.alert)
                        myAlert.addAction(UIAlertAction(title: action, style: UIAlertAction.Style.default, handler: nil))
                        self.present(myAlert, animated: true, completion: nil)
                    }
                }
            }
                
        }else{
                self.Login.isUserInteractionEnabled = true
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

class MyGBTextField: PhoneNumberTextField {
    override var defaultRegion: String {
        get {
            return "IRQ"
        }
        set {} // exists for backward compatibility
    }
}
extension String {
   func replace(string:String, replacement:String) -> String {
       return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
   }

   func removeWhitespace() -> String {
       return self.replace(string: " ", replacement: "")
   }
 }
