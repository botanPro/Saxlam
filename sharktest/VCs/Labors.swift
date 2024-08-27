//
//  Labors.swift
//  sharktest
//
//  Created by Botan Amedi on 29/01/2023.
//

import UIKit
import CRRefresh
import Drops
class Labors: UIViewController {
    
    @IBOutlet var GoToSearch: UITapGestureRecognizer!
    
    @IBOutlet weak var SearchView: UIView!
    
    @IBOutlet weak var CollectionHeightLayout: NSLayoutConstraint!
    
    @IBOutlet weak var AllLaborsCollectionView: UICollectionView!
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    @IBOutlet weak var ScrollView: UIScrollView!
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 22.0, bottom: 0.0, right: 22.0)
    let spacingBetweenCells: CGFloat = 11
    var LaborArray : [LabsObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        if CheckInternet.Connection() != true{
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
            self.activityIndicator.stopAnimating()
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
        }else{
            self.GetLAbs()
        }
        
        
        
        
        
        
        
        self.SearchView.layer.masksToBounds = false
        self.SearchView.layer.shadowColor = UIColor.lightGray.cgColor
        self.SearchView.layer.shadowOpacity = 0.2
        self.SearchView.layer.shadowOffset = .zero
        self.SearchView.layer.shadowRadius = 6
        self.SearchView.layer.shouldRasterize = true
        self.SearchView.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        self.SearchView.layer.cornerRadius = 16
        
        AllLaborsCollectionView.register(UINib(nibName: "LabsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.ScrollView.cr.addHeadRefresh(animator: FastAnimator()) {
            self.GetLAbs()
        }
        
        
       
        activityIndicator.hidesWhenStopped = true
        ScrollView.addSubview(activityIndicator)
        activityIndicator.center = ScrollView.center
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        
        
    }
    
    
    
    
    @IBAction func soon(_ sender: Any) {
        Drops.hideAll()
        var mss = ""
        if XLanguage.get() == .English{
            mss = "Coming Soon"
        }
        
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
    
    func GetLAbs(){
        if CheckInternet.Connection() == true{
            self.LaborArray.removeAll()
            LabsObjectAPI.GetLAbs { Labs,error in
                if error == ""{
                    if Labs.count == 0{
                        self.activityIndicator.stopAnimating()
                        if XLanguage.get() == .English{
                            self.AllLaborsCollectionView.setEmptyView(title: "No laboratories Found", message: "There are no laboratories")
                        }else if XLanguage.get() == .Arabic{
                            self.AllLaborsCollectionView.setEmptyView(title: "لم يتم العثور على مختبرات", message: "لا يوجد مختبرات")
                        }else{
                            self.AllLaborsCollectionView.setEmptyView(title: "هیچ تاقیگەهەک نە هاتە دیتن", message: "")
                        }
                    }else{
                        self.activityIndicator.stopAnimating()
                        self.LaborArray = Labs
                        self.AllLaborsCollectionView.reloadData()
                        self.ScrollView.cr.endHeaderRefresh()
                        let height = self.AllLaborsCollectionView.collectionViewLayout.collectionViewContentSize.height
                        self.CollectionHeightLayout.constant = height
                        self.view.layoutIfNeeded()
                    }
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true)
                }
            }
        }else{
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}

extension Labors : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if LaborArray.count == 0 {
            return 0
        }else{
            self.self.AllLaborsCollectionView.setEmptyView(title: "", message: "")
            return LaborArray.count
        }
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
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let LaborDetails = storyboard.instantiateViewController(withIdentifier: "LaborDetails") as! LaborDetails
        LaborDetails.modalPresentationStyle = .fullScreen
        LaborDetails.lab_id = self.LaborArray[indexPath.row].id
        self.present(LaborDetails, animated: true, completion: nil)
        
    }
    

}


