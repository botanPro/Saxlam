//
//  Home.swift
//  sharktest
//
//  Created by Botan Amedi on 11/12/2022.
//

import UIKit

class Home: UIViewController {
    @IBOutlet weak var SearchView: UIView!
    @IBOutlet weak var HiName: UILabel!
    var BackgroundColors : [String] = [ "1" , "6" , "8" , "4" , "5" , "2", "7", "3" ]
    @IBOutlet weak var DoctorsCollectionView: UICollectionView!
    @IBOutlet weak var LabsCollectionView: UICollectionView!
    @IBOutlet weak var GoToNotifications: UIButton!
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    var numberOfItemsPerRow: CGFloat = 1
    let spacingBetweenCells: CGFloat = 10
    var LabsArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SearchView.layer.borderWidth = 1
        self.SearchView.layer.borderColor = #colorLiteral(red: 0.6799461246, green: 0.748108983, blue: 0.8951761127, alpha: 1)
        
        LabsCollectionView.register(UINib(nibName: "LabsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")

    }
    @IBAction func GoToSearch(_ sender: Any) {
    }
    
}

extension Home : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if LabsArray.count == 0 {
            return 4
        }
        return LabsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LabsCollectionViewCell
        cell.backView.backgroundColor = UIColor(named: BackgroundColors[indexPath.row % BackgroundColors.count])
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.layer.bounds.width / 1.3, height: 170)
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return sectionInsets
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 10
     }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    

}
