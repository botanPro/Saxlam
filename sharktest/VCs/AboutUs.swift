//
//  AboutUs.swift
//  sharktest
//
//  Created by Botan Amedi on 01/02/2024.
//

import UIKit

class AboutUs: UIViewController {
    @IBOutlet weak var AboutUsTextView: UITextView!
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    var txt = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AboutUsTextView.textColor = .black
        self.AboutUsTextView.text =  txt
    }
}
