//
//  UploadViewController.swift
//  gezGorPaylas
//
//  Created by doğan güneş on 28.02.2023.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var aciklamaTextField: UITextField!
    
    
    @IBOutlet weak var butonUpload: UIButton!
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       
        // GÖRSEL SEÇMEK İÇİN
        imageview.isUserInteractionEnabled = true
        let imagegestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        imageview.addGestureRecognizer(imagegestureRecognizer)
        
        let klavyeGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeyiKapat))
        view.addGestureRecognizer(klavyeGestureRecognizer)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        butonUpload.isEnabled = false
        
    }
    
    
    
    @objc func klavyeyiKapat() {
        view.endEditing(true)
    }
    
    @objc func gorselSec() {
            
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true,completion: nil)
     
    }
    // GÖRSEL SEÇİLDİKTEN SONRA
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        butonUpload.isEnabled = true
        imageview.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true,completion: nil)
        
    }
    
    
    
  
    @IBAction func btnUpload(_ sender: Any) {
        
         // firebase de media klasörü oluşturmak

        // storage nesnemezi oluşturduk 
        let storage = Storage.storage()
        // reference oluşturarak storage içersinde dizinimizi belirleyebiliyoruz
        let storageReference = storage.reference()
        // media klasörümüzü oluşturuyoruz
        let mediaFolder = storageReference.child("media")
        
        // resmimizi yüklemek için veriye dönüştürüyoruz UIImage olarak yükleyemediğimiz için
        
        if let gorseldata = imageview.image?.jpegData(compressionQuality: 0.5) {
           // child ile media klasörümüzün içine ulaşıoruz ve resmimizi oraya kaydediyoruz
            
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg") // her url uuisstring sayesinde farklı ismi ile kaydedilicek
            // kaydetme işlemi KOYMA İŞLEMİ (PUT)
            imageReference.putData(gorseldata,metadata: nil) { storagemetadata, error in
                if error != nil {
                    self.hatamesaji(title: "Hata!", message: error?.localizedDescription ?? "Hata aldınız, Tekrar Deneyin ")
                }else {
                    imageReference.downloadURL { (url,error) in
                        // hata mesajı yoksa url yi yazdırmaya çalışıyoruz
                        if error == nil {
                            // absolutestring ile url nin string halini aldık
                            let imageUrl = url?.absoluteString
                            //   print(imageurl)
                            
                            
                            // image i opsiyonellikten çıkarmak için
                            if let imageUrl = imageUrl {
                                // !!!! VERİ TABANINA KAYDETME İŞLEMİ !!!!!
                                // post koleksiyonuna veri eklemek için FireStore nesnemizi oluşturuyoruz
                                let fireStoreDatabes = Firestore.firestore()
                                let firestorePost = ["gorselurl" : imageUrl, "yorum" : self.aciklamaTextField.text! , "email" : Auth.auth().currentUser!.email, "tarih" : FieldValue.serverTimestamp()] as [String : Any]
                                
                                fireStoreDatabes.collection("Post").addDocument(data: firestorePost) {
                                    (error) in
                                    if error != nil {
                                        self.hatamesaji(title: "Hata!", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz")
                                    }else {
                                       // gorsel yükledikten sonra feed e gidilicek ve upload ekranına tekrar geldiğimizde resim gprselsec yorum kısmı boş olucak 
                                        self.imageview.image = UIImage(named: "gorselsec")
                                        self.aciklamaTextField.text = ""
                                        
                                        // index ile seçim yapıcaz soldan sağa 0-1-2 feed upload settings
                                        self.tabBarController?.selectedIndex = 0 // feed e geçiş yapılıcak
                                        
                                    }
                                }
                                
                                
                                
                                
                            }
                            
                         
                            
                            
                            
                        }
                        
                    }
                }
                
                
                
            }
            
        }
     
    }
    
    func hatamesaji(title:String,message:String) {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true,completion: nil)
        
    }
    
    @IBAction func btnKonumEkle(_ sender: Any) {
        performSegue(withIdentifier: "toNot", sender: nil)
    }
    
    
    
    
}
