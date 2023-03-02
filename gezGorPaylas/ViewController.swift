//
//  ViewController.swift
//  gezGorPaylas
//
//  Created by doğan güneş on 27.02.2023.
//

import UIKit
import Firebase
class ViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sifreTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnGirisYap(_ sender: Any) {
        
        if emailTextField.text != "" && sifreTextField.text != "" {
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: sifreTextField.text!) { authdataresult, error in
                
                if error != nil {
                    self.hataMesaji(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata! Tekrar Deneyin")
                }else {self.performSegue(withIdentifier: "toFeedVC", sender: nil)}
                
            }
            
            
        }else {
            self.hataMesaji(titleInput: "Hata !", messageInput: "Email Ve Şifrenizi giriniz")
        }
        
        
        
        
        
        
        
        
    }
    
    @IBAction func btnKayitOl(_ sender: Any) {
        
        if emailTextField.text != "" && sifreTextField.text != "" {
            
            // koşul sağlanıyorsa kayıt olma işlemi gerçekleştirilicek
            
            // Firebase için kullanıcı işlmelerini gerçekleştiren sınıfı çağırıyoruz (AUTH)
            
             // nesneyi oluşturup öğelere erişim sağlıyoruz
            Auth.auth().createUser(withEmail: emailTextField.text!, password: sifreTextField.text!) { authdataresult, error in
                // eğer hata varsa
                if error != nil {
                    // burada firebasein bize verdiği hata mesajını kullanıcıya gösterticez
    
                    // eğer locallizerDescription kısmı gösterilebiliyorsa orası gösterilicek gösterilemiyorsa bizim yazımız gösterilicek (?? )
                    self.hataMesaji(titleInput: "Hata !", messageInput: error?.localizedDescription ?? "Hata aldınız Tekrar deneyiniz")
                    
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    
                }
                
                
            }
            
            
            
            
            
        } else { // hata mesajı vericez
            hataMesaji(titleInput: "Hata !", messageInput: "Kullanıcı Adı Ve Şifre Giriniz")
        }
        
        
        
        
    }
    
    
    // hata mesajlarını göstermek için fonksiyopnumuz
    func hataMesaji(titleInput : String , messageInput : String) {
       
        // sitilimiz lert hata mesajı şeklinde yani
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        
        // alertimize kullanıcının çıkması için buton ekliyoruz
        let alertButonum = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil)
       // alertimize butonumuzu ekliyoruz
        alert.addAction(alertButonum)
        // alertimizi sunuyoruz (gösteriyoruz)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    

}

