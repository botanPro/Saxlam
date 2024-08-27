//
//  Home.swift
//  sharktest
//
//  Created by Botan Amedi on 11/12/2022.
//
import Foundation
import UIKit

class TabBarView: UIViewController {
    @IBOutlet weak var ShadowView: UIView!
    
    @IBOutlet weak var ProfileIcone: UIImageView!
    @IBOutlet weak var SearchIcone: UIImageView!
    @IBOutlet weak var HomeIcone: UIImageView!
    @IBOutlet weak var TabBar: UIView!
    @IBOutlet weak var ContentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ShadowView.layer.masksToBounds = false
        self.ShadowView.layer.shadowColor = UIColor.lightGray.cgColor
        self.ShadowView.layer.shadowOpacity = 0.4
        self.ShadowView.layer.shadowOffset = .zero
        self.ShadowView.layer.shadowRadius = 6
        self.ShadowView.layer.shouldRasterize = true
        self.ShadowView.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        self.ShadowView.layer.cornerRadius = 29
        self.TabBar.layer.cornerRadius = 29
        
        
//        guard let Home = self.storyboard?.instantiateViewController(withIdentifier: "Home") as? Home else {return}
//        Home.willMove(toParent: self)
//        self.ContentView.addSubview(Home.view)
//        self.addChild(Home)
//        Home.didMove(toParent: self)
        
        
        self.ProfileIcone.tintColor = UIColor.lightGray
        self.SearchIcone.tintColor = UIColor.lightGray
        

    }
    
    var IsUpdatedInfo = true
    var IsFirstTime = true
    override func viewDidAppear(_ animated: Bool) {
        if self.IsFirstTime == true{
            super.viewDidAppear(animated)
            guard let Home = self.storyboard?.instantiateViewController(withIdentifier: "Home") as? Home else {return}
            Home.willMove(toParent: self)
            self.ContentView.addSubview(Home.view)
            self.addChild(Home)
            Home.didMove(toParent: self)
            
            
            
            ProfileDataAPI.GetProfileData(id: UserDefaults.standard.string(forKey: "id") ?? "") { data,error  in
                if error == ""{
                    if data.full_name == ""{
                        self.IsUpdatedInfo = false
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateInfo") as! UpdateInfo
                        vc.modalPresentationStyle = .fullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        self.present(vc, animated: true)
                    }else{
                        self.IsUpdatedInfo = true
                    }
                }
            }
            
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    

    
    @IBAction func FirstTab(_ sender: Any) {
        if self.IsUpdatedInfo == false{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateInfo") as! UpdateInfo
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }else{
            guard let Home = self.storyboard?.instantiateViewController(withIdentifier: "Home") as? Home else {return}
            guard let Labors = self.storyboard?.instantiateViewController(withIdentifier: "Labors") as? Labors else {return}
            guard let Profile = self.storyboard?.instantiateViewController(withIdentifier: "Profile") as? Profile else {return}
            hideContentController(content: Labors)
            hideContentController(content: Profile)
            Home.willMove(toParent: self)
            self.ContentView.addSubview(Home.view)
            self.addChild(Home)
            Home.didMove(toParent: self)
            self.IsFirstTime = false
            self.HomeIcone.tintColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
            self.ProfileIcone.tintColor = UIColor.lightGray
            self.SearchIcone.tintColor = UIColor.lightGray
        }
    }

    @IBAction func SecondTab(_ sender: Any) {
        if self.IsUpdatedInfo == false{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateInfo") as! UpdateInfo
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }else{
            guard let Home = self.storyboard?.instantiateViewController(withIdentifier: "Home") as? Home else {return}
            guard let Labors = self.storyboard?.instantiateViewController(withIdentifier: "Labors") as? Labors else {return}
            guard let Profile = self.storyboard?.instantiateViewController(withIdentifier: "Profile") as? Profile else {return}
            
            hideContentController(content: Home)
            hideContentController(content: Profile)
            
            Labors.willMove(toParent: self)
            self.ContentView.addSubview(Labors.view)
            self.addChild(Labors)
            Labors.didMove(toParent: self)
            self.IsFirstTime = false
            self.HomeIcone.tintColor = UIColor.lightGray
            self.ProfileIcone.tintColor = UIColor.lightGray
            self.SearchIcone.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
      
        
    }
    
    @IBAction func ThirdTab(_ sender: Any) {
        if self.IsUpdatedInfo == false{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateInfo") as! UpdateInfo
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }else{
            guard let Home = self.storyboard?.instantiateViewController(withIdentifier: "Home") as? Home else {return}
            guard let Labors = self.storyboard?.instantiateViewController(withIdentifier: "Labors") as? Labors else {return}
            guard let Profile = self.storyboard?.instantiateViewController(withIdentifier: "Profile") as? Profile else {return}
            
            hideContentController(content: Home)
            hideContentController(content: Labors)
            
            Profile.willMove(toParent: self)
            self.ContentView.addSubview(Profile.view)
            self.addChild(Profile)
            Profile.didMove(toParent: self)
            self.IsFirstTime = false
            self.HomeIcone.tintColor = UIColor.lightGray
            self.ProfileIcone.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.SearchIcone.tintColor = UIColor.lightGray
        }
      
    }
    
    
    func hideContentController(content: UIViewController) {
        if self.children.count > 0{
                let viewControllers:[UIViewController] = self.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
    }
    
}




