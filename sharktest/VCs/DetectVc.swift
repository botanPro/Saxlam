//
//  DetectVc.swift
//  sharktest
//
//  Created by Botan Amedi on 24/01/2024.
//

import UIKit
import UIKit
import CoreLocation

class DetectVC: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        if UserDefaults.standard.bool(forKey: "Login") == false{
            self.performSegue(withIdentifier: "FirstVC", sender: nil)
        }else{
            self.performSegue(withIdentifier: "GoToApp", sender: nil)
        }
    }
    
}
