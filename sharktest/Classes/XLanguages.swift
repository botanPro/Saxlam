//
//  XLanguages.swift
//  wfbhl
//
//  Created by Botan Amedi on 13/10/2022.
//


import Foundation
import UIKit
class XLanguage {
    
    enum LanguageEnum : String {
        case Arabic
        case Kurdish
        case English
    }
    
    
    static func set(Language : LanguageEnum){
    UserDefaults.standard.set(Language.rawValue, forKey: "lang")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
    }
    static func get()->LanguageEnum{
        if let lang = UserDefaults.standard.value(forKey: "lang") as? String{
            if lang == "Arabic"{
                return .Arabic
            }else if lang == "Kurdish"{
                return .Kurdish
            }else if lang == "English"{
                return .English
            }
        }
        return .English
    }
    
    
}


class Languagebutton: UIButton{
    
    @IBInspectable var ArabicText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var KurdishText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var EnglishText : String = ""{
        didSet{
            update()
        }
    }
    
    @objc func update(){
        
        if XLanguage.get() == .Arabic{
            self.setTitle(self.ArabicText , for: .normal)
        }else if XLanguage.get() == .Kurdish{
            self.setTitle(self.KurdishText , for: .normal)
        }else if XLanguage.get() == .English{
            self.setTitle(self.EnglishText , for: .normal)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(Languagebutton.update), name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
    }
}


class LanguageLable: UILabel{
    
    @IBInspectable var ArabicText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var KurdishText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var EnglishText : String = ""{
        didSet{
            update()
        }
    }
    
    @objc func update(){
       
        if XLanguage.get() == .Arabic{
            self.text = ArabicText
        }else if XLanguage.get() == .Kurdish{
            self.text = KurdishText
        }else if XLanguage.get() == .English{
            self.text = EnglishText
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(LanguageLable.update), name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
    }
}



class LanguagePlaceHolder: UITextField{
    
    @IBInspectable var ArabicText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var KurdishText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var EnglishText : String = ""{
        didSet{
            update()
        }
    }
    
    @objc func update(){
        
        if XLanguage.get() == .Arabic{
            self.placeholder = ArabicText
        }else if XLanguage.get() == .Kurdish{
            self.placeholder = KurdishText
        }else if XLanguage.get() == .English{
            self.placeholder = EnglishText
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(LanguagePlaceHolder.update), name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
         if action == #selector(UIResponderStandardEditActions.paste(_:)) {
             return false
         }
         return super.canPerformAction(action, withSender: sender)
    }
}



class DisablePastingTextView : UITextView{
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
         if action == #selector(UIResponderStandardEditActions.paste(_:)) {
             return false
         }
         return super.canPerformAction(action, withSender: sender)
    }
}



class LanguageSegmentedControl: UISegmentedControl{
    
    @IBInspectable var EnglishText : String = ""{
        didSet{
            update()
        }
    }
    
    @IBInspectable var ArabicText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var KurdishText : String = ""{
        didSet{
            update()
        }
    }
   
    
    @objc func update(){
        
        if XLanguage.get() == .Arabic{
            self.setTitle(ArabicText, forSegmentAt: 0)
        }else if XLanguage.get() == .Kurdish{
            self.setTitle(KurdishText, forSegmentAt: 0)
        }
        if XLanguage.get() == .English{
            self.setTitle(ArabicText, forSegmentAt: 1)
        }else if XLanguage.get() == .Kurdish{
            self.setTitle(KurdishText, forSegmentAt: 1)
        }
        if XLanguage.get() == .Kurdish{
            self.setTitle(ArabicText, forSegmentAt: 2)
        }else if XLanguage.get() == .Kurdish{
            self.setTitle(KurdishText, forSegmentAt: 2)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(Languagebutton.update), name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
}
}


class LanguageNvigationItem: UINavigationItem{
    
    @IBInspectable var ArabicText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var KurdishText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var EnglishText : String = ""{
        didSet{
            update()
        }
    }
    
    @objc func update(){
        
        if XLanguage.get() == .Arabic{
            self.title = ArabicText
        }else if XLanguage.get() == .Kurdish{
            self.title = KurdishText
        }else if XLanguage.get() == .English{
            self.title = EnglishText
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(LanguageNvigationItem.update), name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
}
}


class LanguageBarItem: UIBarButtonItem{
    
    @IBInspectable var ArabicText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var KurdishText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var EnglishText : String = ""{
        didSet{
            update()
        }
    }
    
    @objc func update(){
        
        if XLanguage.get() == .Arabic{
            self.title = ArabicText
        }else if XLanguage.get() == .Kurdish{
            self.title = KurdishText
        }else if XLanguage.get() == .English{
            self.title = EnglishText
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(LanguageBarItem.update), name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
}
}





