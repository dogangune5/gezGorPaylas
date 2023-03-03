//
//  KonumNotViewController.swift
//  gezGorPaylas
//
//  Created by doğan güneş on 2.03.2023.
//

import UIKit
import CoreData
class KonumNotViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   

    @IBOutlet weak var tableviewNot: UITableView!
    
    var isimDİzisi = [String]()
    var idDizisi = [UUID]()
 
    var secilenYerIsmi = ""
    var secilenYerId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewNot.dataSource = self
        tableviewNot.delegate = self
        veriAl()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // GÖZLEMCİ EKLİYORUZ gözlemci tetiklenince verial fonksiyonu çalışıcak 
        NotificationCenter.default.addObserver(self, selector: #selector(veriAl), name: NSNotification.Name("gozlemciOlusturuldu"), object: nil)
    }
    
    
    
    // verileri alıyoruz
  @objc  func veriAl() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Yer")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let sonuclar = try context.fetch(fetchRequest)
            // gelen bir sonuc varsa
            if sonuclar.count > 0 {
                
                // eski veriyi sürekli getirmesin diye döngüden önce diziyi boşaltıyoruz
                isimDİzisi.removeAll(keepingCapacity: false)
                idDizisi.removeAll(keepingCapacity: false)
                
                for sonuc in sonuclar as! [NSManagedObject] {
                    if let isim = sonuc.value(forKey: "isim") as? String{
                        isimDİzisi.append(isim)
                    }
                    
                    if let id = sonuc.value(forKey: "id") as? UUID {
                        idDizisi.append(id)
                        
                    }
                }
                tableviewNot.reloadData()
            }
            
            
            
        }catch {print("Hata!")}



    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isimDİzisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = isimDİzisi[indexPath.row]
        return cell
    }
    // TableView da bir row seçilirse olucaklar
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secilenYerIsmi = isimDİzisi[indexPath.row]
        secilenYerId = idDizisi[indexPath.row]
        performSegue(withIdentifier: "toMap", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap" {
            let destinationVC = segue.destination as! mapViewController
            destinationVC.secilenIsim = secilenYerIsmi
            destinationVC.secilenID = secilenYerId
        }
        
    }
    
 
    
    @IBAction func btnNotEkle(_ sender: Any) {
        secilenYerIsmi = "" // EĞER DİREKT BU BUTONA TIKLARSA YER EKLEMEYE GELDİĞİNİ ANLAYALIM
        performSegue(withIdentifier: "toMap", sender: nil)
    }
    
    
}
