//
//  DetailViewController.swift
//  myCoin
//
//  Created by Artem Grebenkin on 4/9/18.
//  Copyright © 2018 Artem Grebenkin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation
import RealmSwift


class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var totalScoreLabel: CauntingLabel!
    @IBOutlet weak var titleLabel: CauntingLabel!
    @IBOutlet weak var sumOfCoinsLabel: UILabel!
    @IBOutlet weak var lab: UILabel!
    
    var realmCoinRecord: CoinRecord? //текущая запись найденная по уид с главного вью она будет сохранена(обновлена) в БД
    var currentUid: String?
    var sumOfSubMoney = 0
    var sumOfMoney = 0
    var sumOfCoins = 0
    var curFromSet: Currency?
    var curSymbol = ""
    var regionIsOut = true
    var currentLocation: CLLocation?
    //переменные для редактироания сущ. записи
    var editLattitude: Double?
    var editLongitude: Double?
    var manualPinAllowed = false
 
    var arrayRecords: Results<CoinRecord>!

    let myLocationManager = CLLocationManager() //создаем наш экземпляр менеджера локаций он может создаваться на основном потоке но тогда и работать с ним надо на основном потоке

    
    func isGoodAccurasy() -> Bool {
        
        let freshTime: TimeInterval = 15.0
        let minHAccurasy : CLLocationAccuracy = 500.0
        let minVAccurasy : CLLocationAccuracy = 100.0
        if let location = currentLocation {
            let ts = location.timestamp
            let vAccurasy = location.verticalAccuracy
            let hAccurasy = location.horizontalAccuracy
        
            if  abs(ts.timeIntervalSinceNow) < freshTime { //отсечем старые точные координаты
                if (abs(vAccurasy) < minVAccurasy)&&(abs(hAccurasy) < minHAccurasy) { //сравниваем точности
                    return true //коор достаточно точны
                }
                return false //точность коор не удовлетворительная
            }
        }
        //text += " \n" + String(n) + " falseT H:" + String(hAccurasy) + ", V:" + String(vAccurasy)
        return false //актуальность коор не удовлетворительная
    }
    
    
    func createPointOnTheMap()  {
        //обновляем запись в БД
        if let coin = realmCoinRecord?.coin{
            if let lat = realmCoinRecord?.latitude, let lon = realmCoinRecord?.longitude {
                let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
                //создаем пин
                let newPin = PinAnnatation(title: coin.fullName, subtitle: "", coordinate: myLocation)
                let pointOnTheView = map.convert(myLocation, toPointTo: self.view)
                animateCoin(coordinateX: pointOnTheView.x, coordinateY: pointOnTheView.y)
                map.addAnnotation(newPin)
                addLocationDescription(lat, lon) //расшифруем локацию и добавим объект запись в CoreData
                myLocationManager.stopUpdatingLocation() //остановим менеджер
                myLocationManager.delegate = nil //уничтожим для верности делегата
            }
        }
    }
    
    
    func addLocationDescription(_ lat: Double, _ lon: Double) {
        var loc: CLLocation?
        loc = CLLocation(latitude: lat, longitude: lon)
        //print(lat, lon)
        var addressString = "не найдено названий локации"
        CLGeocoder().reverseGeocodeLocation(loc!) { (placemark, error) in
            if error != nil {
                addressString = "ошибка получения данных имени локации"
            } else {
                let pm = placemark! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemark![0]
                    if pm.name != nil {
                        addressString = pm.name!
                    }
                    self.saveRecord(["uid" : self.currentUid!, "locationDescription": addressString])
                }
            }
        }
    }
    
    
    func saveRecord(_ dict: Dictionary<String, Any>) {
        if realmCoinRecord != nil {
            //DispatchQueue.main.async { т.к. не ставится точка на карте
                try! realm.write {
                        realm.create(CoinRecord.self, value: dict, update: .modified)
                }
            //}
        }
    }
    

   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = ""
        sumOfCoinsLabel.text = ""
        totalScoreLabel.text = ""
        /////временно? ///////////
        lab.text = ""
        lab.isHidden = true
        //////////////////////////
        
        if let cur = UserDefaults.standard.string(forKey: "Currency") {
            curFromSet = Currency(rawValue: cur)
        }
        
        //запускаем навигацию
        if CLLocationManager.locationServicesEnabled() {
            //&& myLocationManager.pausesLocationUpdatesAutomatically { //не помню зачем это нужно
            myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
            myLocationManager.startUpdatingLocation()
        }
        
        //показываем карту находок
        loadPinsFromCoreData()

        if manualPinAllowed {
            self.navigationItem.rightBarButtonItem?.isEnabled = false //чтобы не "ходить" по кругу залочим кнопку бара справа если прыгнули сюда для добавления монеты вручную
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //переместим вид на карту в то место где была найдена монета
        if let lat = editLattitude, let lon = editLongitude {
           let myEditLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
           self.map.setCenter(myEditLocation, animated: false)
        }
        
        if curFromSet != nil {
            curSymbol = (curFromSet?.currencySymbol)!
        }
        
        sumOfCoinsLabel.text = String(sumOfCoins) //текущие значения ранее найденных денег
        //  программнное добавленние сообщения при ручном вводе пина
        if manualPinAllowed {
            let lbl = InfoLabel()
            lbl.showMessage(view: self.view, message: "Добавьте монету на карту долгим нажатием")
            //переместим вид на карту в то место где была найдена монета
            //if editLattitude != nil && editLongitude != nil {
             //   let myEditLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(editLattitude!, editLongitude!)
             //   self.map.setCenter(myEditLocation, animated: true)
            //}
        } else {
            animateCauntingLables() //запускаем анимацию счетчика денег и монет если зашли с "главного входа"
        }
        //выведем суммарные кол-ва денег и монет
        totalScoreLabel.text = curSymbol + String(sumOfMoney)
        let strSumOfSubMoney = String(sumOfSubMoney)
        titleLabel.text = (sumOfSubMoney > 10 ? strSumOfSubMoney : "0" + strSumOfSubMoney)

    }

    
    
    func animateCauntingLables() {
        //if let coin = selectedCoin {  //запускаем счетчик денег
        if let coin = realmCoinRecord?.coin {  //запускаем счетчик денег
            if !coin.subUnit { //если основные ден.единицы
                let startMoney: Int = (sumOfMoney >= coin.rating ? sumOfMoney - coin.rating : 0) //чтобы не уйти в меньше 0
                totalScoreLabel.count(fromValue: startMoney, to: sumOfMoney, withDuration: 1, addStr: curSymbol)
            } else { //если копейки
                if sumOfSubMoney - coin.rating < 0 && sumOfMoney > 0 {
                    titleLabel.count(fromValue: 100 - sumOfSubMoney - coin.rating, to: 0, withDuration: 1, addStr: "") // увел. копейки до 100
                    totalScoreLabel.count(fromValue: sumOfMoney - 1, to: sumOfMoney, withDuration: 0, addStr: curSymbol)// +1 к основной ден.ед.
                    titleLabel.count(fromValue: 0, to: sumOfSubMoney, withDuration: 1, addStr: "") // увел. остаток копеек (после 100)
                } else {
                    let startMoney: Int = (sumOfSubMoney >= coin.rating ? sumOfSubMoney - coin.rating : 0) //чтобы не уйти в меньше 0
                    titleLabel.count(fromValue: startMoney, to: sumOfSubMoney, withDuration: 1, addStr: "")
                    totalScoreLabel.text = curSymbol + "0"
                }
            }
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        arrayRecords = realm.objects(CoinRecord.self)
        if let uid = currentUid {
            //print(" текущий \(uid)")
            self.realmCoinRecord = realm.objects(CoinRecord.self).filter("uid == %@", uid).first
        }
        myLocationManager.delegate = self //указываем себя как делегата созданного экземпляра менеджера локаций
        myLocationManager.requestWhenInUseAuthorization() //разрешение на получение геолокации на устройстве
        myLocationManager.distanceFilter = 10 //мин расстояние на которое нужно переместиться чтобы было создано событие обновления (в метрах)
        /*
         requestWhenInUseAuthorization() либо requestAlwaysAuthorization() не покажет пользователю алерт о запросе прав для этого необходимо добавить поясняющий текст сообщения в info.plist в соотвествующий ключ NSLocationAlwaysUsageDescription / NSLocationWhenInUseUsageDescription
         Как только пользователь, свернув приложение, будет некоторое время оставаться неподвижно, геолокация остановится.
         Все дело в том, что CLLocationManager по умолчанию использует паузу для геолокации pausesLocationUpdatesAutomatically.
         myLocationManager.startUpdatingLocation() //запускает генерацию обновлений, сообщающих текущее местоположение
         myLocationManager.startMonitoringSignificantLocationChanges() //Начинает генерировать обновления на основе значительных изменений местоположения для requestAlwaysAuthorization()
         */
    }

    
    /*
    //делегатная функция
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: pin, reuseIdentifier: "coinPin")
        annotationView.image = UIImage(named: "coinPin")
        return annotationView
    }
    */
    
    
    //делаем выборку существующих пинов из CoreData и добавляем на карту
    func loadPinsFromCoreData() {
        //coreDataResult = coreData.fetchData(uid: nil)
        ///////////////////////////////////////////////////coreDataResult = coreData.fetchFromCoreData(uid: nil)
        
        
        var coordinate:CLLocationCoordinate2D
        map.removeAnnotations(map.annotations) //удаляем показанные
        var arrayAnnatations: [MKAnnotation] = []
        if let res = arrayRecords {
            sumOfMoney = 0
            sumOfSubMoney = 0
            sumOfCoins = 0
            for item in res {
                guard let coin = item.coin else {return}
                if coin.subUnit == false {
                    sumOfMoney += Int(coin.rating)
                } else {
                    sumOfSubMoney += Int(coin.rating)
                    if sumOfSubMoney >= 100 {
                        sumOfMoney += 1
                        sumOfSubMoney = sumOfSubMoney - 100
                    }
                }
                sumOfCoins += 1
                coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                let existingPin = PinAnnatation(title: coin.fullName, subtitle: "", coordinate: coordinate)
                arrayAnnatations.append(existingPin)
            }
            self.map.addAnnotations(arrayAnnatations)
        }
    }
    

    
    @IBAction func setPinManualy(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.ended {
            if manualPinAllowed {
                if editLattitude != nil && editLongitude != nil {
                    //удалим старый пин редактируемой точки
                    if let annotationFiltered = self.map.annotations.first(where: { $0.coordinate.latitude == editLattitude! && $0.coordinate.longitude == editLongitude!}) {
                        self.map.removeAnnotation(annotationFiltered)
                    }
                }
                let location = sender.location(in: self.map)
                let manualLocation = self.map.convert(location, toCoordinateFrom: self.map)
                if let uid = currentUid { //вынести в отдельную функцию т к повтор
                    saveRecord(["uid" : uid, "latitude" : manualLocation.latitude, "longitude" : manualLocation.longitude])
                    createPointOnTheMap()
                }
                //сохраним коорднаты последней точки
                editLattitude = manualLocation.latitude
                editLongitude = manualLocation.longitude
            }
        }
    }
    
   /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination == InputViewController() {
            
        
            let destinationController = segue.destination as! InputViewController
            destinationController.editRecordCoin = self.coinData
            manualPinAllowed = false
        }
        
    }
 */
    func animateCoin(coordinateX: CGFloat, coordinateY: CGFloat)  {
        let image = UIImage(named: "pinCoinStay")
        let imageView = UIImageView(frame: CGRect(x: coordinateX, y: coordinateY, width: 70.0, height: 70.0))
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        
        self.view.addSubview(imageView)
        UIView.animate(withDuration: 0.6, animations: {
            imageView.frame = CGRect(x: coordinateX, y: coordinateY, width: 0.0, height: 0.0)
        }, completion: {(Bool) in
            imageView.removeFromSuperview()
        })
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.first //одна метка на карте
        
        //self.map.showsUserLocation = true //покажем наше текущее положение на карте
        
        if let loc = currentLocation {
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(loc.coordinate.latitude, loc.coordinate.longitude)
            
            if regionIsOut { //устанавливаем регион один раз при открытии карты, в дальнейшем пользователь сможет двигать карту без помех
                self.regionIsOut = false
                let span:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 0.01,longitudeDelta: 0.01)//величина приближения на карте
                let region:MKCoordinateRegion = MKCoordinateRegion.init(center: myLocation, span: span)
                self.map.setRegion(region, animated: false)//устанавливаем наш регион чтобы не искать пин вручную на карте
                self.map.setCenter(myLocation, animated: false) //переместимся на текущую координату
            }
            
            
            //if selectedCoin != nil && !manualPinAllowed {
            if !manualPinAllowed {
                if isGoodAccurasy() {  //если спозиционировались точно, ставим пин
                    if let uid = currentUid {
                        saveRecord(["uid" : uid, "latitude" : loc.coordinate.latitude, "longitude" : loc.coordinate.longitude])
                        //print("uid \(uid) loc \(loc.coordinate.latitude) : \(loc.coordinate.longitude)")
                        createPointOnTheMap()
                    }
                }
            }
        }
    }
    
    //обработаем ошибку получения координат
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        lab.isHidden = false
        lab.text = "Служба геолокации не включена."
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let annatationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pinCoin")
        annatationView.image = UIImage(named: "pinCoinLay")
        annatationView.canShowCallout = true
        return annatationView
    }

    
}
