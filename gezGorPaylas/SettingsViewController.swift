//
//  SettingsViewController.swift
//  gezGorPaylas
//
//  Created by doğan güneş on 28.02.2023.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController {

    @IBOutlet weak var lblguncel: UILabel!
    
    @IBOutlet weak var lblhissedilen: UILabel!
    
    @IBOutlet weak var lblRuzgar: UILabel!
    
    // HAVA DURUMU VERİSİNİ ALMAK İÇİN
    // 1. WEB ADRESİNE GİDECEĞİZ
    // 2. DATAYI AL
    // 3. DATAYI İŞLE
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    override func viewWillAppear(_ animated: Bool) {
        lblguncel.text = ""
        lblhissedilen.text = ""
        lblRuzgar.text = ""
    }

    @IBAction func btnCikisYap(_ sender: Any) {
        
        do {
            try  Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        }catch {print("Hata!")}
        
    
    }
    
    
    @IBAction func tbnhavadurumualTiklandi(_ sender: Any) {
        
        // 1
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=41,0798793&lon=29,0371709&appid=87991b6a6d7b895e995e84e008723358")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil {
                print("Hata!")
            }else {
                // 2. adım datayı aldık
                if data != nil {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!,options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                        // as String ile herhangi bir veri gelebileceğini söyledik çünkü double float veya int veri gelebilir
                        DispatchQueue.main.async {
                            // ÇEKME İŞLEMİ
                            // print(jsonResponse!["main"] as Any)
                          // json verisindeki main ve childlerine ulaşıyoruz
                            if let main = jsonResponse!["main"] as? [String:Any] {
                               // Temp verisini alıcaz (güncel hava durumu )
                                if let temp = main["temp"] as? Double {
                                    self.lblguncel.text = String(Int(temp-272.15))
                                }
                                // hissedilen hava durumunu alma
                                if let feels = main["feels_like"] as? Double {
                                    self.lblhissedilen.text = String(Int(feels-272.15))
                                }
                            }
                            // rüzgar alma
                            if let wind = jsonResponse!["wind"] as? [String:Any] {
                                if let speed = wind["speed"] as? Double {
                                    self.lblRuzgar.text = String(Int(speed))
                                }
                            }

                        }
                        
                    }catch{print("Hata!")}
                }
            }
        }
        
        task.resume()
    }
    
}
