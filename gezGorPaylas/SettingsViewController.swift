//
//  SettingsViewController.swift
//  gezGorPaylas
//
//  Created by doğan güneş on 28.02.2023.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    @IBAction func btnCikisYap(_ sender: Any) {
        
        do {
            try  Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        }catch {print("Hata!")}
        
    
    }
    
    

}
