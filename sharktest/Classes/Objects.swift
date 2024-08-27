//
//  Objects.swift
//  wfbhl
//
//  Created by Botan Amedi on 23/09/2022.
//

//
//  Objects.swift
//  RealEstates
//
//  Created by botan pro on 4/25/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import CryptoSwift
import FCAlertView
import CommonCrypto
import CryptoKit
import SCLAlertView

//class NotificationsObject{
//    var note = ""
//    var date = ""
//    var title = ""
//    
//    init(note : String , date: String, title: String) {
//        self.note = note
//        self.date = date
//        self.title = title
//    }
//}
//
//class NotificationAPI{
//    static func GetNotifications(completion : @escaping (_ note : [NotificationsObject])->()){
//        var not : [NotificationsObject] = []
//        let stringUrl = URL(string: API.URL);
//        let param: [String: Any] = [
//            "key":API.key,
//            "username":API.UserName,
//            "fun":"get_notifications"
//        ]
//        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
//            switch respons.result{
//            case .success:
//                let jsonData = JSON(respons.data ?? "")
//                if(jsonData[0] != "error"){
//                    for (_,val) in jsonData{
//                        let notif = NotificationsObject(note: val["disc"].string ?? "", date: val["date"].string ?? "", title: val["title"].string ?? "")
//                        not.append(notif)
//                    }
//                    completion(not)
//                }
//            case .failure(let error):
//                print("error 630 : error while getting notifications")
//                print(error);
//            }
//        }
//    }
//}
//
//
//
//
class SlideObject{
    var id = ""
    var link = ""
    var image = ""
    
    init(id : String , link : String , image : String) {
        
        self.id  = id
        self.link = link
        self.image = image
    }
}


class SlideAPI {
    static func GetSlides(completion : @escaping (_ Slide : [SlideObject])->()){
        var slide = [SlideObject]()
        let stringUrl = URL(string: API.URL);
        let username = openCartApi.UserName
        let password = openCartApi.key
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
        let param: [String: Any] = [
            "fun":"get_slides"
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param,headers: headers).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                print(jsonData)
                    for (_,val) in jsonData{
                        let Slide = SlideObject(id: val["id"].string ?? "", link: val["link"].string ?? "", image: val["image"].string ?? "")
                        slide.append(Slide);
                    }
                    completion(slide);
            case .failure(let error):
                print("error 440 : error while getting Slide")
                print(error);
            }
        }
    }
}






//MARK:---------About-----------
class AboutObject{
    
    var about = ""
    var phone = ""
    var pravicy = ""

    
    init(about : String , phone : String , pravicy : String) {
        self.about = about
        self.phone = phone
        self.pravicy = pravicy
    }
    
    
}

class AboutAPI{
    static func GetAbout(completion : @escaping (_ about : AboutObject)->()){
        var about : AboutObject!
        var lang : Int = 0
        if XLanguage.get() == .English{
            lang = 1
        }else if XLanguage.get() == .Arabic{
            lang = 2
        }else{
            lang = 3
        }
        let stringUrl = URL(string: API.URL);
        let username = openCartApi.UserName
        let password = openCartApi.key
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
        let param: [String: Any] = [
            "fun":"get_about",
            "lang":lang
        ]
        AF.request(stringUrl!, method: .post, parameters: param,headers: headers).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                print(jsonData)
                    for (_,val) in jsonData{
                        let Subcat = AboutObject(about: val["about_us"].string ?? "" , phone: val["phone"].string ?? "", pravicy: val["pravicy"].string ?? "")
                        about = Subcat
                    }
                    completion(about)
            case .failure(let error):
                print("error 490 : error while getting about")
                print(error);
            }
        }
    }
}







class UpdateNotificationIdAPI{
    static func Update(UUID : String , userId : String){
        let stringUrl = URL(string: API.URL);
        let username = openCartApi.UserName
        let password = openCartApi.key
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
        let param: [String: Any] = [
            "fun":"update_notify",
            "id":userId,
            "notify_id":UUID
        ]
        print("one id jsonData -----111")
        print(userId)
        print(UUID)
        AF.request(stringUrl!, method: .post, parameters: param, headers: headers).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                print("one id jsonData -----222")
                print(jsonData)
            case .failure(let error):
                print("error 420 : error while getting onesignal UUID")
                print(error);
            }
        }
    }
}





//MARK:---------About-----------




class CheckPhoneAPI{
    
    
    
    static func Login(phone : String, token : String ,completion : @escaping(_ Data : ProfileDataObjects)->()){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier:"Asia/Baghdad")
        let currentDate = Date()
        let formattedCurrentDate = dateFormatter.string(from: currentDate)
        
        print(formattedCurrentDate)
        do {
            let passwordData = formattedCurrentDate.data(using: .utf8)!
            let saltData = "6+XxxYYEMo&s_Y;".data(using: .utf8)!
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
                
                
        let stringUrl = URL(string: API.URL);
        let username = "ashraf_shark"
        let password = hexString
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
               let param: [String: Any] = [
                   "fun":"profile_login",
                   "phone" : phone,
                   "token" : token,
                   "date" : formattedCurrentDate
               ]
        
               AF.request(stringUrl!, method: .post, parameters: param,headers: headers).responseData { (response) in
                   switch response.result
                   {
                   case .success(_):
                       let jsonData = JSON(response.data ?? "")
                       for (_,val) in jsonData{
                           print("ooo---------ooo")
                           print(jsonData)
                           
                           if jsonData["error"].string != nil{
                               SCLAlertView().showWarning(API.APP_TITLE, subTitle: jsonData["error"].string ?? "");
                           }else{
                               if jsonData["insert"].string == "false"{
                                   //show alert that user has no account
                                   var mss = ""
                                   if XLanguage.get() == .English{
                                       mss = "Incorrect Phone Number"
                                   }
                                   SCLAlertView().showWarning(API.APP_TITLE, subTitle: mss);
                               }else{
                                   
                                   let Data = ProfileDataObjects(id: val["id"].string ?? "", full_name: val["full_name"].string ?? "", gender: val["gender"].string ?? "", birthday: val["birthday"].string ?? "", address: val["address"].string ?? "", phone: val["phone"].string ?? "", token:  val["token"].string ?? "", lab_id: val["lab_id"].string ?? "", type: val["type"].string ?? "", qrcode: val["qr_code"].string ?? "")
                                   
                                   UserDefaults.standard.setValue(Data.id, forKey: "openCartApi_userName")
                                   UserDefaults.standard.setValue(Data.token, forKey: "openCartApi_token")
                                   UserDefaults.standard.setValue(Data.lab_id, forKey: "my_lab_id")
                                   UserDefaults.standard.setValue(Data.type, forKey: "my_type")
                                   openCartApi.UserName = UserDefaults.standard.string(forKey: "openCartApi_userName") ?? ""
                                   openCartApi.key = UserDefaults.standard.string(forKey: "openCartApi_token") ?? ""
                                   
                                   completion(Data)
                               }
                           }
                       }
                   case .failure(let error):
                       print(error);
                   }
               }
            }
        }
        
    }
    
    
    static func CheckPhone(phone: String,completion : @escaping (_ note : [String],_ error : String)->()){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier:"Asia/Baghdad")
        let currentDate = Date()
        let formattedCurrentDate = dateFormatter.string(from: currentDate)
        
        print(formattedCurrentDate)
        do {
            let passwordData = formattedCurrentDate.data(using: .utf8)!
            let saltData = "6+XxxYYEMo&s_Y;".data(using: .utf8)!
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
                
                print("hashed pass : \(hexString)")
                print(phone)
                let stringUrl = URL(string: API.URL);
                let username = "ashraf_shark"
                let password = hexString
                let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
                let base64Credentials = credentialData.base64EncodedString(options: [])
                let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
                let param: [String: Any] = [
                    "fun":"check_phone",
                    "phone": phone,
                    "date" : formattedCurrentDate
                ]
                
                AF.request(stringUrl!, method: .post, parameters: param,headers: headers).responseData { respons in
                    switch respons.result{
                    case .success:
                        let jsonData = JSON(respons.data ?? "")
                        print(jsonData)
                        if jsonData["error"].string != nil{
                            SCLAlertView().showWarning(API.APP_TITLE, subTitle: jsonData["error"].string ?? "");
                            completion(["","",""],"error")
                        }else{
                            for (_,val) in jsonData{
                                completion([val["id"].string ?? "",val["phone"].string ?? "", val["full_name"].string ?? ""],"")
                                print(val["phone"].string ?? "")
                            }
                        }
                    case .failure(let error):
                        print("error 630 : error while checking phone")
                        print(error);
                    }
                }
            }
        }
    }
}


class CreateUserAPI{
    static func create(fire_id : String , phone: String,completion : @escaping (_ id : String)->()){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier:"Asia/Baghdad")
        let currentDate = Date()
        let formattedCurrentDate = dateFormatter.string(from: currentDate)
        
        print(formattedCurrentDate)
        do {
            let passwordData = formattedCurrentDate.data(using: .utf8)!
            let saltData = "6+XxxYYEMo&s_Y;".data(using: .utf8)!
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
                
                let stringUrl = URL(string: API.URL);
                let username = "ashraf_shark"
                let password = hexString
                let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
                let base64Credentials = credentialData.base64EncodedString(options: [])
                let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
                
                let param: [String: Any] = [
                    "fun": "profile_create",
                    "phone": phone,
                    "fire_id" : fire_id,
                    "date" : formattedCurrentDate
                ]
                
                AF.request(stringUrl!, method: .post, parameters: param,headers: headers).responseData { respons in
                    switch respons.result{
                    case .success:
                        let jsonData = JSON(respons.data ?? "")
                        print(jsonData)
                        for (_,val) in jsonData{
                            completion(val["profile_id"].string ?? "")
                        }
                        
                    case .failure(let error):
                        print("error 490 : error while creating user")
                        print(error);
                    }
                }
            }
        }
    }
}



import Firebase
import FirebaseAuth

class ProfileDataObjects{
    
    
    var id = ""
    var full_name = ""
    var gender = ""
    var birthday = ""
    var address = ""
    var phone = ""
    var token = ""
    var lab_id  = ""
    var type = ""
    var qrcode = ""
    
    
    init(id: String = "", full_name: String = "", gender: String = "", birthday: String = "", address: String = "",phone : String,token : String,lab_id : String,type  : String,qrcode : String) {
        self.id = id
        self.full_name = full_name
        self.gender = gender
        self.birthday = birthday
        self.address = address
        self.phone = phone
        self.token = token
        self.lab_id = lab_id
        self.type = type
        self.qrcode = qrcode
    }
    
    
}

class ProfileDataAPI{
    static func update(profile_id : String , full_name : String ,birthday: String, gender : String, address : String ,completion : @escaping (_ Done : String)->()){
        let stringUrl = URL(string: API.URL);
        let username = openCartApi.UserName
        let password = openCartApi.key
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
        let param: [String: Any] = [
            "fun":"update_profile",
            "id":profile_id,
            "full_name":full_name,
            "gender":gender,
            "birthday":birthday,
            "address": address
        ]
        
        print(profile_id)
        print(full_name)
        print(gender)
        print(birthday)
        print(address)
        AF.request(stringUrl!, method: .post, parameters: param,headers: headers).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                completion("")
            case .failure(let error):
                print("error 450 : error while updating profile")
                print(error);
            }
        }
    }
    
    
    
    static func GetProfileData(id: String,completion : @escaping (_ note : ProfileDataObjects, _ error: String)->()){
        let stringUrl = URL(string: API.URL);
        let username = openCartApi.UserName
        let password = openCartApi.key
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
        let param: [String: Any] = [
            "fun": "get_profile",
            "id": id
        ]
        
   
        AF.request(stringUrl!, method: .post, parameters: param,headers: headers).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                if jsonData["error"].string != nil{
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        UserDefaults.standard.set(false, forKey: "Login")
                        UserDefaults.standard.set("", forKey: "id")
                        UserDefaults.standard.set("", forKey: "my_lab_id")
                        completion(ProfileDataObjects(id: "", full_name: "", gender: "", birthday: "", address: "", phone: "", token: "", lab_id: "", type: "",qrcode: ""),jsonData["error"].string ?? "")
                        
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                }else{
                    for (_,val) in jsonData{
                        let data = ProfileDataObjects(id: val["id"].string ?? "", full_name:  val["full_name"].string ?? "", gender:  val["gender"].string ?? "", birthday:  val["birthday"].string ?? "", address:  val["address"].string ?? "", phone: val["phone"].string ?? "", token: val["token"].string ?? "", lab_id: val["lab_id"].string ?? "", type: val["type"].string ?? "", qrcode: val["qr_code"].string ?? "")
                        completion(data,"")
                    }
                }
                
            case .failure(let error):
                print("error 450 : error while getting profile")
                print(error);
            }
        }
        
        
    }
}







class LabsObject{
    
    var id = ""
    var title = ""
    var disc = ""
    var logo = ""
    var website = ""
    var address = ""
    var open_week = ""
    var open_hour = ""
    var phone = ""
    var lat = ""
    var long = ""

    init(id: String = "", title: String = "", disc: String = "", logo: String = "", website: String = "", address: String = "", open_week: String = "", open_hour: String = "", phone: String = "", lat: String = "", long: String = "") {
        self.id = id
        self.title = title
        self.disc = disc
        self.logo = logo
        self.website = website
        self.address = address
        self.open_week = open_week
        self.open_hour = open_hour
        self.phone = phone
        self.lat = lat
        self.long = long
    }
    
}

class LabsObjectAPI{
    static func GetLAbs(completion : @escaping (_ Labs : [LabsObject], _ error: String)->()){
        var labs = [LabsObject]()
        var lang : Int = 0
        if XLanguage.get() == .English{
            lang = 1
        }else if XLanguage.get() == .Arabic{
            lang = 2
        }else{
            lang = 3
        }
        
        let stringUrl = URL(string: API.URL);
        let username = openCartApi.UserName
        let password = openCartApi.key
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
        let param: [String: Any] = [
            "fun":"get_labs",
            "lang":lang,
        ]
        
        print(openCartApi.UserName)
        print(openCartApi.key)
        print(lang)
        AF.request(stringUrl!, method: .post, parameters: param,headers: headers).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                print(jsonData)
                if jsonData["error"].string != nil{
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        UserDefaults.standard.set(false, forKey: "Login")
                        UserDefaults.standard.set("", forKey: "id")
                        UserDefaults.standard.set("", forKey: "my_lab_id")
                        completion([],jsonData["error"].string ?? "")
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                }else{
                    for (_,val) in jsonData{
                        let Labs = LabsObject(id: val["id"].string ?? "", title: val["title"].string ?? "", disc: val["disc"].string ?? "", logo: val["logo"].string ?? "", website: val["website"].string ?? "", address: val["address"].string ?? "", open_week: val["open_week"].string ?? "", open_hour: val["open_hour"].string ?? "", phone: val["phone"].string ?? "", lat: val["lat"].string ?? "", long: val["long"].string ?? "")
                        labs.append(Labs);
                    }
                    completion(labs,"");
                }
            case .failure(let error):
                print("error 440 : error while getting Labs")
                print(error);
            }
        }
        
    }
}



class TestObject{
    

    var inv_num = ""
    var inv_date = ""
    var done_result = ""
    var url = ""
    var full_name = ""

    init(inv_num: String , inv_date: String , done_result: String , url: String,full_name : String ) {
        self.inv_num = inv_num
        self.inv_date = inv_date
        self.done_result = done_result
        self.url = url
        self.full_name = full_name
    }
    
}

class TestObjectAPI{
    static func GetMyTest(Id : String, LabId : String,completion : @escaping (_ Tests : [TestObject])->()){
        var Tests = [TestObject]()
        let stringUrl = URL(string: API.URL);
        let username = openCartApi.UserName
        let password = openCartApi.key
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
        let param: [String: Any] = [
            "fun":"get_user_test",
            "id":Id,
            "lab_id":LabId
        ]
        
        print(Id)
        print(LabId)
        
        AF.request(stringUrl!, method: .post, parameters: param,headers: headers).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                print(jsonData)
                    for (_,val) in jsonData{
                        let test = TestObject(inv_num: val["inv_num"].string ?? "", inv_date: val["inv_date"].string ?? "", done_result: val["done_result"].string ?? "", url: val["url"].string ?? "",full_name : val["full_name"].string ?? "")
                        Tests.append(test);
                    }
                    completion(Tests);
            case .failure(let error):
                print("error 440 : error while getting Tests")
                print(error);
            }
        }
        
    }
}





class PostObject{
   var id = ""
   var desc = ""
   var post_image = ""
   var profile_id = ""
   var full_name = ""
   var profile_image = ""
   var hour = ""
   var video_url = ""
    

    var number_line = 0
    
    init(id: String = "", desc: String = "", post_image: String = "", profile_id: String = "", full_name: String = "", profile_image: String = "", hour: String = "",video_url : String = "") {
        self.id = id
        self.desc = desc
        self.post_image = post_image
        self.profile_id = profile_id
        self.full_name = full_name
        self.profile_image = profile_image
        self.hour = hour
        self.video_url = video_url
    }
}


class PostObjectApi{

    
    
    static func GetPosts(UserId: String,Start: Int,Limit: Int,completion : @escaping (_ posts : [PostObject])->()){
        var posts : [PostObject] = []
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
            "fun":"get_posts",
            "profile_id":UserId,
            "start":Start,
            "limit":Limit,
            "lang" : lang
        ]
        
        print(UserId)
        print(Start)
        print(Limit)
        AF.request(stringUrl!, method: .post, parameters: param, headers:  headers).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                for (_,val) in jsonData{
                    let post = PostObject(id: val["id"].string ?? "", desc: val["desc"].string ?? "", post_image: val["post_image"].string ?? "", profile_id: val["profile_id"].string ?? "", full_name: val["full_name"].string ?? "", profile_image: val["profile_image"].string ?? "",hour: val["hour"].string ?? "",video_url: val["video_url"].string ?? "")
                    posts.append(post)
                }
                completion(posts)
            case .failure(let error):
                print("error 450 : error while Getting Posts")
                print(error);
            }
        }
    }
    
    
    static func GetPostsById(lab_id : String,completion : @escaping (_ posts : [PostObject])->()){
        var posts : [PostObject] = []
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
            "fun":"get_posts_by_profile_id",
            "id" :lab_id,
            "lang" : lang

        ]
        AF.request(stringUrl!, method: .post, parameters: param, headers:  headers).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                for (_,val) in jsonData{
                    let post = PostObject(id: val["id"].string ?? "", desc: val["desc"].string ?? "", post_image: val["post_image"].string ?? "", profile_id: val["profile_id"].string ?? "", full_name: val["full_name"].string ?? "", profile_image: val["profile_image"].string ?? "",hour: val["hour"].string ?? "",video_url: val["video_url"].string ?? "")
                    posts.append(post)
                }
                completion(posts)
            case .failure(let error):
                print("error 450 : error while Getting profile Posts")
                print(error);
            }
        }
    }
   
    
    
    static func AddPost(UserId : String, Desc : String,Image: String, video_url : String,completion : @escaping (_ insert : String)->()){
        let stringUrl = URL(string: API.URL);
        let username = openCartApi.UserName
        let password = openCartApi.key
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
        let param: [String: Any] = [
            "fun":"add_post",
            "profile_id" : UserId,
            "desc" : Desc,
            "image" : Image,
            "video_url" : video_url
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param, headers:  headers).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                completion("")
            case .failure(let error):
                completion("")
                print("error 450 : error while Adding post")
                print(error);
            }
        }
    }
    
    
    
    
    static func UpdatePost(PostId : String, Desc : String, video_url : String,completion : @escaping (_ Done : String)->()){
        let stringUrl = URL(string: API.URL);
        let username = openCartApi.UserName
        let password = openCartApi.key
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
        let param: [String: Any] = [
            "fun":"update_post",
            "post_id" : PostId,
            "desc" : Desc,
            "video_url" : video_url,
            "profile_id": UserDefaults.standard.string(forKey: "id") ?? ""
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param, headers:  headers).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                completion("")
            case .failure(let error):
                completion("")
                print("error 450 : error while updating post")
                print(error);
            }
        }
    }
    
   
    
    
    static func DeletePost(PostId : String,completion : @escaping (_ Done : String)->()){
        let stringUrl = URL(string: API.URL);
        let username = openCartApi.UserName
        let password = openCartApi.key
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
        let param: [String: Any] = [
            "fun":"delete_post",
            "id" : PostId,
            "profile_id": UserDefaults.standard.string(forKey: "id") ?? ""

        ]
        
        AF.request(stringUrl!, method: .post, parameters: param, headers:  headers).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                completion("")
            case .failure(let error):
                completion("")
                print("error 450 : error while delete post")
                print(error);
            }
        }
    }
}

