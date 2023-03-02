//
//  FeedViewController.swift
//  gezGorPaylas
//
//  Created by doğan güneş on 28.02.2023.
//

import UIKit
import Firebase
import SDWebImage // firestoredan resmimizi asenkron alabilmek için kütüphanemiz
class FeedViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
   
    var emailDizisi = [String]()
    var yorumDizisi = [String]()
    var gorselDizisi = [String]()
    

    
    @IBOutlet weak var tableview: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
       firebaseVerileriAl()
    }
    
    // firebase e kaydettiğimiz verileri çekme işlemi (snapshot)
    func firebaseVerileriAl() {
        // nesnemizi oluşturup değişkene atayalım
        
        let firestoreDatabase = Firestore.firestore()
      
        // WHERE FİELD İLE FİLTRELEME YAPABİLİRİZ BU ŞEKİLDE YAPARSAK SADECE EMAİL İ DOGAN@GMAİL.COM OLANLARI GETİRİR
        
        //  firestoreDatabase.collection("Post").whereField("email", isEqualTo: //"dogan@gmial.coom").addSnapshotListener { <#QuerySnapshot?#>, <#Error?#> in
         //   <#code#>
       // }
       
        
        
        
        // TARİHE GÖRE SIRALIYARAK ALIYORUZ
        firestoreDatabase.collection("Post").order(by: "tarih", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            } else { // hata mesajı yoksa
                if snapshot?.isEmpty != true && snapshot != nil {
                // SNAPSHOT BOŞ DEĞİLSE SNAPSHOT I İNCELEMEYE BAŞLICAZ
                   
                    
                    // eklediklerimiz bir daha getirmesin diye diziyi döngüden önce boşaltıyoruz
                    
                    self.emailDizisi.removeAll(keepingCapacity: false)
                    self.gorselDizisi.removeAll(keepingCapacity: false)
                    self.yorumDizisi.removeAll(keepingCapacity: false)
                    
                    
                    
                    
                    // snapshot taki dokümanları alabileceğimiz bir dizi (DOCUMENTS)
                    for document in snapshot!.documents {
                        // eğer sadece tek bir id ile kaydedilmiş dokuman olsaydı
                        // let documentId = document.documentID
                        // print(documentId)
                        
                        
                        
                        // ALMAYA BAŞLIYORUZ
                        if let gorselUrl =   document.get("gorselurl") as? String {
                            // alabilirsek dizimize ekliyoruz
                            self.gorselDizisi.append(gorselUrl)
                        }
                        if let yorum = document.get("yorum") as? String {
                            self.yorumDizisi.append(yorum)
                        }
                        if let email = document.get("email") as? String {
                            self.emailDizisi.append(email)
                        }
                        
                        
                    }
                    
                    self.tableview.reloadData()
                    
                    
                }
                
            }
            
        }
        
        
        
    }
    
     
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TABLEVİEW içinde oluşturduğumuz Prototype cell e identifier vericez (Cell)
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        // artık cell içine ulaşabiliyoruz
        cell.lblemail.text = emailDizisi[indexPath.row]
        cell.lblyorum.text = yorumDizisi[indexPath.row]
       // yüklediğimiz kütüphane ile resmimizi asenkron almak
        cell.postImageView.sd_setImage(with: URL(string: self.gorselDizisi[indexPath.row]))
        return cell
        
    }

    
}
