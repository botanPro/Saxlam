//
//  Verifying.swift
//  sharktest
//
//  Created by Botan Amedi on 27/07/2023.
//

import UIKit
import AEOTPTextField
import MHLoadingButton
import Firebase
import FirebaseAuth
import CryptoSwift
import FCAlertView
import CommonCrypto
import CryptoKit
import SCLAlertView
import Drops
class Verifying: UIViewController {
    
    @IBOutlet weak var OTPCode: AEOTPTextField!
    @IBOutlet weak var Verify: UIButton!
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    var ver : String = ""
    var IsCheckPhoneZero = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.OTPCode.becomeFirstResponder()
        OTPCode.otpDefaultCharacter = ""
        OTPCode.otpDelegate = self
        OTPCode.otpBackgroundColor = #colorLiteral(red: 0.9398464561, green: 0.9398464561, blue: 0.9398464561, alpha: 1)
        OTPCode.otpTextColor = .black
        OTPCode.configure(with: 6)
        OTPCode.otpFontSize = 16
        OTPCode.otpFilledBackgroundColor = #colorLiteral(red: 0.9398464561, green: 0.9398464561, blue: 0.9398464561, alpha: 1)
        OTPCode.otpCornerRaduis = 5
        OTPCode.otpFilledBorderColor = #colorLiteral(red: 0.7721900344, green: 0.8500768542, blue: 0.9397693872, alpha: 0)
        
        
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            let myMessage = "no virification code"
            let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(myAlert, animated: true, completion: nil)
            return
        }
        self.ver = verificationID
    }
    
    
    
    
    func popBack(_ nb: Int) {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count < nb else {
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
                return
            }
        }
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
    
    
    var credential : PhoneAuthCredential!
    @IBAction func Verify(_ sender: Any) {
        if CheckInternet.Connection() == true{
            if self.OTPCode.text!.trimmingCharacters(in: .whitespaces) != ""{
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
                self.Verify.isUserInteractionEnabled = false
                credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: self.ver ,
                    verificationCode: self.OTPCode.text!.convertedDigitsToLocale(Locale(identifier: "EN")))
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if let error = error {
                        self.alert.dismiss(animated: true) {
                            UserDefaults.standard.set(false, forKey: "Login")
                            UserDefaults.standard.set("", forKey: "FireId")
                            UserDefaults.standard.set("", forKey: "PhoneNumber")
                            self.Verify.isUserInteractionEnabled = false
                            let myMessage = error.localizedDescription
                            let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
                            myAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(myAlert, animated: true, completion: nil)
                        }
                        return
                    }
                    
                    
                    if ((authResult?.user) != nil){
                        guard let UserId = authResult?.user.uid else { return }
                        print("fire id is \(UserId)")
                        
                        do {
                            let passwordData = UserId.data(using: .utf8)!
                            let saltData = "Xtp5j?!>X<<35jn".data(using: .utf8)!
                            var derivedKey = [UInt8](repeating: 0, count: 32)
                            
                            let status = passwordData.withUnsafeBytes { passwordBytes in
                                saltData.withUnsafeBytes { saltBytes in
                                    CCKeyDerivationPBKDF(
                                        CCPBKDFAlgorithm(kCCPBKDF2),
                                        passwordBytes.baseAddress!.assumingMemoryBound(to: Int8.self),
                                        passwordData.count,
                                        saltBytes.baseAddress!.assumingMemoryBound(to: UInt8.self),
                                        saltData.count,
                                        CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
                                        UInt32(4096),
                                        &derivedKey,
                                        derivedKey.count
                                    )
                                }
                            }
                            
                            if status == kCCSuccess {
                                // Convert the derived key to a hexadecimal string
                                let hexString = derivedKey.map { String(format: "%02hhx", $0) }.joined()
                                
                                if self.IsCheckPhoneZero == false{
                                    ///CheckPhone = 1
                                    print("p[p[p[p[p[999")
                                    CheckPhoneAPI.Login(phone: UserDefaults.standard.string(forKey: "PhoneNumber")?.removeWhitespace() ?? "", token: hexString) { Data in
                                        UserDefaults.standard.set(true, forKey: "Login")
                                        UserDefaults.standard.set(UserId, forKey: "FireId")
                                        UserDefaults.standard.set(Data.full_name, forKey: "name")
                                        UserDefaults.standard.set(Data.id, forKey: "id")
                                        
                                        self.alert.dismiss(animated: true) {
                                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarView") as! TabBarView
                                            vc.modalPresentationStyle = .fullScreen
                                            vc.modalTransitionStyle = .crossDissolve
                                            self.present(vc, animated: true)
                                        }
                                    }
                                }else{
                                    ///CheckPhone = 0
                                    print("p[p[p[p[p[")
                                    CreateUserAPI.create(fire_id: UserId, phone: UserDefaults.standard.string(forKey: "PhoneNumber")?.removeWhitespace() ?? "") { id in
                                        CheckPhoneAPI.Login(phone: UserDefaults.standard.string(forKey: "PhoneNumber")?.removeWhitespace() ?? "", token: hexString) { Data in
                                            UserDefaults.standard.set(true, forKey: "Login")
                                            UserDefaults.standard.set(UserId, forKey: "FireId")
                                            UserDefaults.standard.set(Data.full_name, forKey: "name")
                                            UserDefaults.standard.set(Data.id, forKey: "id")
                                            
                                            self.alert.dismiss(animated: true) {
                                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarView") as! TabBarView
                                                vc.modalPresentationStyle = .fullScreen
                                                vc.modalTransitionStyle = .crossDissolve
                                                self.present(vc, animated: true)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
                // self.Verify.isUserInteractionEnabled = true
            }
        }else{
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


extension Verifying: AEOTPTextFieldDelegate {
    func didUserFinishEnter(the code: String) {
        print(code)
    }
}
