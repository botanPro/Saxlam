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




class QuestionsObject{
    var id = ""
    var question = ""
    var selected_answer = ""
    
    
    init(id : String ,question : String , selected_answer : String) {
        self.id = id
        self.question = question
        self.selected_answer = selected_answer
    }
}


class AnswersObject{
    var id = ""
    var answer = ""
    var question_id = ""
    
    init(id : String ,answer : String , question_id : String) {
        self.id = id
        self.answer = answer
        self.question_id = question_id
    }
}



class NotificationsObject{
    var note = ""
    var date = ""
    var title = ""
    
    init(note : String , date: String, title: String) {
        self.note = note
        self.date = date
        self.title = title
    }
}

class NotificationAPI{
    static func GetNotifications(completion : @escaping (_ note : [NotificationsObject])->()){
        var not : [NotificationsObject] = []
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"get_notifications"
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                if(jsonData[0] != "error"){
                    for (_,val) in jsonData{
                        let notif = NotificationsObject(note: val["disc"].string ?? "", date: val["date"].string ?? "", title: val["title"].string ?? "")
                        not.append(notif)
                    }
                    completion(not)
                }
            case .failure(let error):
                print("error 630 : error while getting notifications")
                print(error);
            }
        }
    }
}




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
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"get_slides"
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
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
//MARK:---------slide-----------






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
        let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"get_about",
            "lang":lang
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
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

//MARK:---------About-----------




class ActivityObjects{
    
    var id = ""
    var title = ""
    var desc = ""
    var youtube_link = ""
    var activity_date = ""
    var date = ""
    var image = ""
    var user_id = ""
    var views = ""
    var rate = ""
    init(id : String ,image : String, title : String , desc : String, youtube_link : String , activity_date : String , date:String
         , user_id : String, views : String , rate : String) {
        self.id  = id
        self.title = title
        self.desc = desc
        self.youtube_link = youtube_link
        self.activity_date = activity_date
        self.date = date
        self.image = image
        self.user_id = user_id
        self.views = views
        self.rate = rate
    }
    
    
}

class ActivityObjectsAPI{
    static func GetActivityByType(type : String, completion : @escaping (_ Profiles : [ActivityObjects])->()){
        var profils = [ActivityObjects]()
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"get_activity_by_type",
            "type": type
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                    for (_,val) in jsonData{
                        let profil = ActivityObjects(id: val["id"].string ?? "",image: val["image"].string ?? "", title: val["title"].string ?? "", desc: val["desc"].string ?? "", youtube_link: val["youtube_link"].string ?? "", activity_date: val["activity_date"].string ?? "", date: val["date"].string ?? "", user_id: val["user_id"].string ?? "", views: val["views"].string ?? "", rate: val["rate"].string ?? "")
                        profils.append(profil)
                    }
                    completion(profils);
            case .failure(let error):
                print("error 450 : error while getting activities")
                print(error);
            }
        }
    }
    
    
    static func GetRelated(Activitiy_id : String, completion : @escaping (_ Profiles : [ActivityObjects])->()){
        var profils = [ActivityObjects]()
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"get_related_activity_by_id",
            "id": Activitiy_id
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                    for (_,val) in jsonData{
                        let profil = ActivityObjects(id: val["id"].string ?? "",image: val["image"].string ?? "", title: val["title"].string ?? "", desc: val["desc"].string ?? "", youtube_link: val["youtube_link"].string ?? "", activity_date: val["activity_date"].string ?? "", date: val["date"].string ?? "", user_id: val["user_id"].string ?? "", views: val["views"].string ?? "", rate: val["rate"].string ?? "")
                        profils.append(profil)
                    }
                    completion(profils);
            case .failure(let error):
                print("error 450 : error while getting activities")
                print(error);
            }
        }
    }
}




class rateObject {

    static func SetRate(profileId: String, rate: Double, activitiesId: String,completion : @escaping (_ state : String)->()){
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun": "add_rate",
            "id":activitiesId,
            "profile_id":profileId,
            "rate":rate
        ]

        AF.request(stringUrl!, method: .post, parameters: param).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                completion(jsonData["insert"].string ?? "")
            case .failure(let error):
                print(error);
            }
        }
    }
    
}



class  ViewsObject {

    static func SetView(profileId: String, activitiesId: String,completion : @escaping (_ state : String)->()){
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun": "add_views",
            "id":activitiesId,
            "profile_id":profileId
        ]

        AF.request(stringUrl!, method: .post, parameters: param).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                completion(jsonData["insert"].string ?? "")
            case .failure(let error):
                print(error);
            }
        }
    }
    
}



//MARK:---------About-----------
class AvtivitiesImageObject{
    
    var id = ""
    var act_id = ""
    var image = ""

    init(id : String , act_id : String , image : String) {
        self.id = id
        self.act_id = act_id
        self.image = image
    }
    
    
}

class AvtivitiesImageAPI{
    static func GetAbout(completion : @escaping (_ about : AvtivitiesImageObject)->()){
        var about : AvtivitiesImageObject!
        let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"get_about",
            "lang":lang
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                print(jsonData)
                    for (_,val) in jsonData{
                        let Subcat = AvtivitiesImageObject(id: val["id"].string ?? "" , act_id: val["activity_id"].string ?? "", image: val["image"].string ?? "")
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

//MARK:---------About-----------





class CheckPhoneAPI{
    static func CheckPhone(fire_id: String,completion : @escaping (_ note : [String])->()){

        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"check_phone",
            "fire_id": fire_id
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                for (_,val) in jsonData{
                    completion([val["phone"].string ?? "", val["id"].string ?? ""])
                }
                    
            case .failure(let error):
                print("error 630 : error while checking phone")
                print(error);
            }
        }
    }
}


class CreateUserAPI{
    static func create(fire_id : String , phone: String,completion : @escaping (_ id : String)->()){
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key": API.key,
            "username": API.UserName,
            "fun": "profile_create",
            "phone": phone,
            "fire_id" : fire_id
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
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





class ProfileDataObjects{
    
    var id = ""
    var full_name = ""
    var gender = ""
    var age = ""
    var email = ""
    var phone = ""
    var status = ""
    var married = ""
    var special_conditions = ""
    var survivor_from_situation = ""
    var belong_famly = ""
    var education = ""
    var location = ""
    var fire_id = ""
    var one_id = ""
    var date = ""
    
    init(id : String , full_name : String ,phone: String, gender : String, age : String , email : String , status:String, married : String , special_conditions : String
         , survivor_from_situation : String , belong_famly : String , education:String, location : String, fire_id : String , one_id : String,date:String) {
        self.id                          =     id
        self.full_name                   =    full_name
        self.gender                      =    gender
        self.age                           =   age
        self.phone                         =   phone
        self.email                          =  email
        self.status                         =  status
        self.married                        =  married
        self.special_conditions            =  special_conditions
        self.survivor_from_situation       =  survivor_from_situation
        self.belong_famly                   =  belong_famly
        self.education                      =  education
        self.location                       =  location
        self.fire_id                        =  fire_id
        self.one_id                         =  one_id
        self.date                            = date
    }
    
    
}

class ProfileDataAPI{
    static func update(profile_id : String , full_name : String ,phone: String, gender : String, age : String , email : String , status:String, married : String , special_conditions : String, survivor_from_situation : String , belong_famly : String , education:String, location : String){
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"update_profile",
            "id":profile_id,
            "full_name":full_name,
            "gender":gender,
            "age":age,
            "phone": phone,
            "email": email,
            "status": status,
            "married": married,
            "special_conditions": special_conditions,
            "survivor_from_situation":  survivor_from_situation,
            "belong_famly":belong_famly,
            "education":education,
            "location":location
        ]
        print(profile_id)
        print(full_name)
        print(phone)
        print(gender)
        print(age)
        print(email)
        print(status)
        print(married)
        print(special_conditions)
        print(survivor_from_situation)
        print(belong_famly)
        print(education)
        print(location)
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
            case .failure(let error):
                print("error 450 : error while updating profile")
                print(error);
            }
        }
    }
    
    
    
    static func GetProfileData(id: String,completion : @escaping (_ note : ProfileDataObjects)->()){
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key": API.key,
            "username": API.UserName,
            "fun": "get_profile",
            "id": id
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                for (_,val) in jsonData{
                    let data = ProfileDataObjects(id: val["id"].string ?? "", full_name:  val["full_name"].string ?? "", phone:  val["phone"].string ?? "", gender:  val["gender"].string ?? "", age:  val["age"].string ?? "", email:  val["email"].string ?? "", status:  val["status"].string ?? "", married:  val["married"].string ?? "", special_conditions:  val["special_conditions"].string ?? "", survivor_from_situation:  val["survivor_from_situation"].string ?? "", belong_famly:  val["belong_famly"].string ?? "", education:  val["education"].string ?? "", location:  val["location"].string ?? "", fire_id:  val["fire_id"].string ?? "", one_id:  val["one_id"].string ?? "", date:  val["date"].string ?? "")
                    completion(data)
                }
                
            case .failure(let error):
                print("error 450 : error while getting profile")
                print(error);
            }
        }
        
        
    }
}

