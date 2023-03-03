//
//  mapViewController.swift
//  gezGorPaylas
//
//  Created by doğan güneş on 2.03.2023.
//

import UIKit
import MapKit
import CoreLocation // kullanıcının konumunu almak için ihtiyacımız var
import CoreData
class mapViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var baslikTextField: UITextField!
    
    @IBOutlet weak var notTextField: UITextField!
    
    
    
    @IBOutlet weak var mapview: MKMapView!
    var locationManager = CLLocationManager() // konum yöneticisini oluşturduk
    var secilenLatitude = Double()
    var secilenLongitude = Double()
    
    var secilenIsim = ""
    var secilenID : UUID?
    
    var annotationTitle = ""
    var annotationSubtitle = ""
    var annotationLatitude = Double()
    var annotationLongitude = Double()
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapview.delegate = self
       
        // KULLANICININ KONUMUNU ALMAK
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // kullanıcının konumunu ne derece alıcaz 10m , 1km, en iyisi ?
        locationManager.requestWhenInUseAuthorization() // kullanıcıdan konumunu almak için izin istiyroruz
        locationManager.startUpdatingLocation() // konumu güncellemeye başla
        // ********* konum alındı ***********
        
        
        // kullanıcı haritaya uzun bastığında (PARAMETRELİ ŞEKİLDE YAPINCA FONKSİYON İÇİNDE DE JEST ALGILICIYIMIZA ULAŞABİLİCEZ)
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(konumSec(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 3 // minimum 3 saniye basınca algılanıcak
        
        mapview.addGestureRecognizer(gestureRecognizer)
        
        // DİĞER EKRANDAKİ EKLEME BUTONUNDA SECİLENİSMİ BOŞ YAPTIK ORAYA TIKLANIRSA ELSE YE GİİRCEK 
        if secilenIsim != "" {
            // Core Datadan verileri Çek

            
            // id çekme NSPredicate ile çekerken lazım
            if let uuidString = secilenID?.uuidString {
                //print(uuidString)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Yer")
               
                // neyi  nasıl filtreleyeceğimiz (İD Sİ EŞİT OLAN ARGÜMANLARI GETİR)
                fetchrequest.predicate = NSPredicate(format: "id = %@",uuidString )
                
                fetchrequest.returnsObjectsAsFaults = false
                
                do {
                    let sonuclar = try context.fetch(fetchrequest)
                    for sonuc in sonuclar as! [NSManagedObject] {
                       
                        // bunlardan birini bile alamazsak annotation oluşturamıcaz
                        
                        if let isim = sonuc.value(forKey: "isim") as? String {
                            annotationTitle = isim
                            if let not = sonuc.value(forKey: "not") as? String {
                                annotationSubtitle = not
                                if let latitude = sonuc.value(forKey: "latitude") as? Double {
                                    annotationLatitude = latitude
                                    if let longitude = sonuc.value(forKey: "longitude") as? Double {
                                        annotationLongitude = longitude
                                        
                                        
                                        // ANNOTATİON OLUŞTURMAK
                                        let annotation = MKPointAnnotation()
                                        annotation.title = annotationTitle
                                        annotation.subtitle = annotationSubtitle
                                        let coordinate = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationLongitude)
                                        annotation.coordinate = coordinate
                                        
                                        // annotationumuzu mapview a eklemek
                                        mapview.addAnnotation(annotation)
                                        baslikTextField.text = annotationTitle
                                        notTextField.text = annotationSubtitle
                                        locationManager.stopUpdatingLocation()
                                        
                                        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                        
                                        let region = MKCoordinateRegion(center: coordinate, span: span)
                                        mapview.setRegion(region, animated: true)
                                        
                                    }
                                    
                                }
                            }
                        }
                        
                       
                        
                        
                       
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                }catch{print("Hata!")}
                
                
                
            }
            
            

        }else {
            // yeni veri eklemeye geldi
        }
        
        
        
        
        
        
    }
    
    // kullanıcının seçtiği konuma baloncuk oluşturabailmesi ve konumu alma
    @objc func konumSec(gestureRecognizer : UILongPressGestureRecognizer) {

            // jest algılayıcı başlarsa (dokunulan noktayı alıcaz)
        if gestureRecognizer.state == .began {
            let dokunulanNokta = gestureRecognizer.location(in: mapview)
            
            // dokunulan yeri koordinata döndürme (convert etme dönüştürme) KOORDİNATI ALMA
            let dokunulanKoordinat = mapview.convert(dokunulanNokta, toCoordinateFrom: mapview)
            secilenLatitude = dokunulanKoordinat.latitude
            secilenLongitude = dokunulanKoordinat.longitude
            
            
        // BALONCUK OLUŞTURMA
            let annotation = MKPointAnnotation()
            annotation.coordinate = dokunulanKoordinat
            annotation.title = baslikTextField.text
            annotation.subtitle = notTextField.text
            mapview.addAnnotation(annotation)
            
        }


    }
    
    
    
    
    
    
    
    // güncelledikçe konumları veriyor
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //  print(locations[0].coordinate.latitude) enlem ve boylam yazdırma
        // print(locations[0].coordinate.longitude)
        
        
        
    // KONUM OLUŞTURMA    (zom seviyesi , seçtiğimiz bölgenin merkezi vs )
      
        if secilenIsim == "" {
            
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            
            // bölgeyi set etmek için span ı alıyoruz
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            // bölgeyi set ediyoruz
            let region = MKCoordinateRegion(center: location, span: span)
            mapview.setRegion(region, animated: true)
        }
        
    }
    
    
    @IBAction func btnKaydet(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // Entity mizi tanımlıyoruz
        let yeniYer = NSEntityDescription.insertNewObject(forEntityName: "Yer", into: context)
        // değerleri kaydetme
        yeniYer.setValue(baslikTextField.text, forKey: "isim")
        yeniYer.setValue(notTextField.text, forKey: "not")
        yeniYer.setValue(secilenLatitude, forKey: "latitude")
        yeniYer.setValue(secilenLongitude, forKey: "longitude")
        yeniYer.setValue(UUID(), forKey: "id")
        
        
        do {
            try context.save()
            print("Kayıt Edildi")
        }catch {print("Hata!")}
        
        // GÖZLEMCİ OLUŞTURULDU
        NotificationCenter.default.post(name: NSNotification.Name("gozlemciOlusturuldu"), object: nil)
        navigationController?.popViewController(animated: true) // BİR ÖNCEKİ SAYFAYA GERİ DÖNME
        
        
        
        
        
    }
    
    
    // annotation a buton ekleme
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       
        
        // kullanıcının konumunu gösteriyorsa pin kullanıcı konumu ile ilgi işlem yaplmıcaksa
        if annotation is MKUserLocation {
            return nil
        }
        
        
        
        
        
        let reuseId = "Annotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        // eğer annotation yeni oluşturuluyorsa ona özelliklerimizi ekliyoruz
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true // anotasyon extra bir şey gösterebilir mi buton gibi
            pinView?.tintColor = .red
            
            // pin vieww da ki butonum
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button // ne göstereceğiz (button)
            
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
        
    }
    
    // oluşturduğum i harfine tıklanınca ne olucak ??
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
      
        // kullanıcı kaydettiği bir yere gidiyorsa
        if secilenIsim != "" {
            
            let requestLocation = CLLocation(latitude: annotationLatitude, longitude: annotationLongitude)
            
            
            // koordinatlar arasında bağlantı yapıyor (CLGeocoder)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarkDizisi, hata) in
                
                if let placemarks = placemarkDizisi {
                    if placemarks.count > 0 {
                        
                        let yeniPlacemark = MKPlacemark(placemark: placemarks[0])
                        let item = MKMapItem(placemark: yeniPlacemark)
                        item.name = self.annotationTitle
                        // MODEDRİVİNG İLK GELECEK SEÇENEĞİN ARABA OLMASI 
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        // HARİTADA NASIL AÇILICAK
                        item.openInMaps(launchOptions: launchOptions)
                        
                        
                        
                    }
                }
                
            }
            
        }
    }
    
    

}
