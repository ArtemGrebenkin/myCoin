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



class DetailViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var totalScoreLabel: CauntingLabel!
    @IBOutlet weak var titleLabel: CauntingLabel!
    @IBOutlet weak var sumOfCoinsLabel: UILabel!
    @IBOutlet weak var lab: UILabel!
    
    let coreData = CoreDataOperations()
    //var coreDataResult:[CoinsData]? = nil //результат выборки из CoreData
    var coreDataResult:[CoinsData]? //результат выборки из CoreData
    var coinRecord: RecordCoinCell?
    //выбранная монета
    //var uuid: String?
    //var selectedCoin : Coin?
    //var selectedDate : Date?
    var sumOfSubMoney: Int16 = 0
    var sumOfMoney: Int16 = 0
    var sumOfCoins: Int16 = 0
    var curFromSet: Currency?
    var curSymbol = ""
    var regionIsOut = true
    //var coinData: RecordCoinCell?
    //var coinData: CoinsData?
    var currentLocation: CLLocation?
    //переменные для редактироания сущ. записи
    var editLattitude: Double?
    var editLongitude: Double?

    var manualPinAllowed = false
    var oldManualPin: PinAnnatation? = nil
    ////////временно////
    var n: Int = 0
    var text = ""
    //////////////////


    let myLocationManager = CLLocationManager() //создаем наш экземпляр менеджера локаций он может создаваться на основном потоке но тогда и работать с ним надо на основном потоке


/*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        //let location = locations.last
        currentLocation = locations.first //одна метка на карте
        
        //self.map.showsUserLocation = true //покажем наше текущее положение на карте
        
        if let loc = currentLocation {
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(loc.coordinate.latitude, loc.coordinate.longitude)
            
            if regionIsOut { //устанавливаем регион один раз при открытии карты, в дальнейшем пользователь сможет двигать карту без помех
                self.regionIsOut = false
                let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)//величина приближения на карте
                let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
                self.map.setRegion(region, animated: false)//устанавливаем наш регион чтобы не искать пин вручную на карте
                self.map.setCenter(myLocation, animated: false) //переместимся на текущую координату
            }
            
            
            if selectedCoin != nil && !manualPinAllowed {
                if isGoodAccurasy() {  //если спозиционировались точно, ставим пин
                    createPointOnTheMap(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude, datePickUp: Date())
                }
            }
        }
    }
*/
    

    
    
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
    
    
    
    //func createPointOnTheMap(lat: Double, lon: Double, datePickUp: Date)  {
    func createPointOnTheMap()  {
        //обновляем запись в CoreData
        //if let coin = selectedCoin {
        if let coin = coinRecord?.coin{
            if let lat = coinRecord?.latitude, let lon = coinRecord?.longitude {
                let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
                //создаем пин
                let newPin = PinAnnatation(title: coin.name, subtitle: "", coordinate: myLocation)
                let pointOnTheView = map.convert(myLocation, toPointTo: self.view)
                animateCoin(coordinateX: pointOnTheView.x, coordinateY: pointOnTheView.y)
                map.addAnnotation(newPin)
                //временно выключим coinData = RecordCoinCell(uid: uuid, datePickUp: datePickUp, coin: coin, lat: lat, lon: lon) //создаем объект запись
                addLocationDescription(lat: lat, lon: lon) //расшифруем локацию и добавим объект запись в CoreData
                myLocationManager.stopUpdatingLocation() //остановим менеджер
                myLocationManager.delegate = nil //уничтожим для верности делегата
            }
        }
    }
    
    
    func addLocationDescription(lat: Double, lon: Double) {
        var loc: CLLocation?
        loc = CLLocation(latitude: lat, longitude: lon)
        //print(lat, lon)
        var addressString = "не найдено названий локации"
        CLGeocoder().reverseGeocodeLocation(loc!) { (placemark, error) in
            if error != nil {
                addressString = "ошибка получения данных имени локации"
            } else {
                
       /*
                    print(place.addressDictionary)
                    switch place {
                        case let plc0 where place.thoroughfare != nil:           namesOfLocations[plc0.thoroughfare!] = 0
                        case let plc1 where place.subThoroughfare != nil:        namesOfLocations[plc1.subThoroughfare!] = 1
                        case let plc2 where place.locality != nil:               namesOfLocations[plc2.locality!] = 2
                        case let plc3 where place.name != nil:                   namesOfLocations[plc3.name!] = 3
                        case let plc4 where place.subLocality != nil:            namesOfLocations[plc4.subLocality!] = 4
                        case let plc5 where place.administrativeArea != nil:     namesOfLocations[plc5.administrativeArea!] = 5
                        case let plc6 where place.subAdministrativeArea != nil:  namesOfLocations[plc6.subAdministrativeArea!] = 6
                        
                        default:
                        namesOfLocations["не найдено названий локации"] = 0
                    }
                    //упорядочим через массив
                    for (name, order) in namesOfLocations {
                        arrayLocations[order] = name
                    }
                    //соберем в строку
                    var fullNameLocation = ""
                    for item in arrayLocations {
                        fullNameLocation += item
                        fullNameLocation += " "
                    }
                    self.coinData!.locationDescription = fullNameLocation
            */
                let pm = placemark! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemark![0]
                    if pm.name != nil {
                        addressString = pm.name!
                    }
                    //print(addressString)
                    //self.coinData?.locationDescription = addressString
                    self.coinRecord?.locationDescription = addressString
                    ////self.coreData.updateRecords(editedRec: self.coinData!) //обновим запись
                    
                    if var rec = self.coinRecord {
                        let coreData = CoreDataOperations()
                        coreData.saveToCoreData(&rec)
                    }
                }
            }

        }

        
    }
    
    
   /*
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let annatationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pinCoin")
        annatationView.image = UIImage(named: "pinCoinLay")
        annatationView.canShowCallout = true
        return annatationView
    }
   */
    
   /*
    //обработаем ошибку получения координат
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        lab.isHidden = false
        lab.text = "Служба геолокации не включена."
    }
   */
    
    
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
            curSymbol = (curFromSet?.curSymbol)!
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
        titleLabel.text = (sumOfSubMoney < 10 ? "0" + String(sumOfSubMoney) : String(sumOfSubMoney))

    }

    
    
    func animateCauntingLables() {
        //if let coin = selectedCoin {  //запускаем счетчик денег
        if let coin = coinRecord?.coin {  //запускаем счетчик денег
            if coin.generalySign { //если основные ден.единицы
                let startMoney: Int16 = (sumOfMoney >= coin.rating ? sumOfMoney - coin.rating : 0) //чтобы не уйти в меньше 0
                totalScoreLabel.count(fromValue: startMoney, to: sumOfMoney, withDuration: 1, addStr: curSymbol)
            } else { //если копейки
                if sumOfSubMoney - coin.rating < 0 && sumOfMoney > 0 {
                    titleLabel.count(fromValue: 100 - sumOfSubMoney - coin.rating, to: 0, withDuration: 1, addStr: "") // увел. копейки до 100
                    totalScoreLabel.count(fromValue: sumOfMoney - 1, to: sumOfMoney, withDuration: 0, addStr: curSymbol)// +1 к основной ден.ед.
                    titleLabel.count(fromValue: 0, to: sumOfSubMoney, withDuration: 1, addStr: "") // увел. остаток копеек (после 100)
                } else {
                    let startMoney: Int16 = (sumOfSubMoney >= coin.rating ? sumOfSubMoney - coin.rating : 0) //чтобы не уйти в меньше 0
                    titleLabel.count(fromValue: startMoney, to: sumOfSubMoney, withDuration: 1, addStr: "")
                    totalScoreLabel.text = curSymbol + "0"
                }
            }
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        coreDataResult = coreData.fetchFromCoreData(uid: nil)
        var coordinate:CLLocationCoordinate2D
        map.removeAnnotations(map.annotations) //удаляем показанные
        var arrayAnnatations: [MKAnnotation] = []
        if let res = coreDataResult {
            sumOfMoney = 0
            sumOfSubMoney = 0
            sumOfCoins = 0
            for item in res {
                if item.generalySign {
                    sumOfMoney += item.rating
                } else {
                    sumOfSubMoney += item.rating
                    if sumOfSubMoney >= 100 {
                        sumOfMoney += 1
                        sumOfSubMoney = sumOfSubMoney - 100
                    }
                }
                sumOfCoins += 1
                coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                let existingPin = PinAnnatation(title: item.name!, subtitle: "", coordinate: coordinate)
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
                coinRecord?.latitude = manualLocation.latitude
                coinRecord?.longitude = manualLocation.longitude
                //let datePickUp = coinRecord?.datePickUp //(selectedDate ?? Date())
                //createPointOnTheMap(lat: manualLocation.latitude, lon: manualLocation.longitude, datePickUp: datePickUp)
                createPointOnTheMap()
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: CLLocationManagerDelegate {
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //let location = locations.last
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
            if coinRecord?.coin != nil && !manualPinAllowed {
                if isGoodAccurasy() {  //если спозиционировались точно, ставим пин
                    //createPointOnTheMap(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude, datePickUp: Date())
                    coinRecord?.latitude = loc.coordinate.latitude
                    coinRecord?.longitude = loc.coordinate.longitude
                    createPointOnTheMap()
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

extension DetailViewController: MKMapViewDelegate {
    
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
