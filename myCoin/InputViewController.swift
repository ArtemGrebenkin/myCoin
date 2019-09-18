//
//  InputViewController.swift
//  myCoin
//
//  Created by Artem Grebenkin on 6/3/18.
//  Copyright © 2018 Artem Grebenkin. All rights reserved.
//

import UIKit
import RealmSwift


class InputViewController: UIViewController  {
    
    @IBOutlet weak var fieldCoin: UITextField!
    @IBOutlet weak var fieldDate: UITextField!
    @IBOutlet weak var textCoordinateLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    
    let picker = UIPickerView()
    let datePicker = UIDatePicker()
    var uid: String? //уид записи переданной сюда на редактирование(добавление)
    var realmCoinRecord: CoinRecord? //текущая запись найденная по уид с главного вью она будет сохранена(обновлена) в БД
    //var editRecordCoin: RecordCoinCell? //переданные на редактирование данные ячейки из таблицы
    //var editRecordCoin: CoinsData? //переданные на редактирование данные ячейки из таблицы
    //var coinRecord = CoinRecord()//модель данных
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        if let uid = uid {
            self.realmCoinRecord = realm.objects(CoinRecord.self).filter("uid == %@", uid).first
        }
        
        
        fieldCoin.placeholder = "Монета"
        fieldDate.placeholder = "Дата"
        textCoordinateLabel.text = "Место на карте"
        //кнопка Done на всплывающей клав.
        //let toolBar = UIToolbar()
        //toolBar.sizeToFit()
        //toolBar.setItems([done], animated: false)
        
        picker.dataSource = self
        picker.delegate = self
        fieldCoin.delegate = self
        fieldDate.delegate = self
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(InputViewController.dateChanged(datePicker:)), for: .valueChanged)

        fieldCoin.inputView = picker
        fieldDate.inputView = datePicker
        
        //кнопка Done на всплывающей клав.
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(InputViewController.viewTapped(gestureRecognizer:)))
        //view.addGestureRecognizer(tapGesture)
        //fieldCoin.inputAccessoryView = toolBar
        //fieldDate.inputAccessoryView = toolBar
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        mapButton.isEnabled = false
        /* такого быть здесь не должно, нужно вывести эту проверку на экран настроек
        if arrayCoins.isEmpty {
            fieldCoin.isEnabled = false
            fieldDate.isEnabled = false
            let lbl = InfoLabel()
            lbl.showMessage(view: self.view, message: "Сначала выберите валюту на экране настройки")
        }
        */
        
        //актуализируем запись местоположения она могла быть изменина вручную
        guard uid != nil else {return} //выйдем т.к. пустой уид собирает ВСЕ выбранной валюты
        
        //var txtCoinName: String?
        //var txtDateName: String?
        //var txtDescription: String?
        //var pickerIndex = 0
        //var pickerDate = Date()

        mapButton.isEnabled = true

        
        if let rec = realmCoinRecord { //если мы что-то нашли значит и уид имеется и это существующая запись
            fieldCoin.text = rec.coin?.fullName                  // имя монеты
            textCoordinateLabel.text = rec.locationDescription // описание координат
            if let date = rec.datePickUp as Date? {
                fieldDate.text = extDateToString(date: date)
                datePicker.setDate(date, animated: true)
            }
            picker.selectRow(rec.coin?.orderInArray ?? 0, inComponent: 0, animated: true) //find the need coin in the picker by index of stored property in the db
        }
        
   
           /*
            //перебераем массив монет пока не найдем монету-экземпляр по ее имени из CoreData (умнее я ни чего не придумал)
            for (index,element) in arrayCoins.enumerated() {
                if element.name == cd.name {
                    picker.selectRow(index, inComponent: 0, animated: true)
                    coinRecord.coin = arrayCoins[index]
                    break
                }
            }
        */
    }
    
    
    
    func saveRecord(_ dict: Dictionary<String, Any>) {
        if self.realmCoinRecord != nil {
            try! realm.write {
                realm.create(CoinRecord.self, value: dict, update: .modified)
            }
        }
    }


    
    @objc func dateChanged(datePicker: UIDatePicker)  {
        fieldDate.text = extDateToString(date: datePicker.date)
        self.saveRecord(["uid" : self.uid!, "datePickUp" : datePicker.date as NSDate])
    }
    
   //тап мимо клавиатуры должен завершить ввод
   // @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
   //     view.endEditing(true)
   // }
    
    @objc func donePressed() {
        view.endEditing(true)

        guard fieldDate.text != nil else { return }
        guard fieldCoin.text != nil else { return }

        self.navigationController?.popViewController(animated: true)
    }
    
    
  /*
    func tapDoneButton() {
        addNewCoinToCoreData()
        //return to root screen
        //_ = navigationController?.popToRootViewController(animated: true)
        //return to previous screen
        self.navigationController?.popViewController(animated: true)
    }
 */
    
   /*
    func addNewCoinToCoreData() {
        if let editedRec = editRecordCoin { //the edit record
            coreData.updateRecords(editedRec: editedRec)
            uuid = editedRec.uid
        } else {
            //the new record
            self.createNewRecord()
        }
    }
    
    
    
    func createNewRecord() {
        if let coin = selectedCoin  {
            uuid = UUID().uuidString
            //let datePickUp = (selectedDate  ?? Date())
            let datePickUp = picker.value(forKey: fieldDate.text!) as! Date
            coreData.saveData(coin: coin, datePickUp: datePickUp, uid: uuid!)
            //если мы создали однажды монету то она уже становится Редактируемой (чтоб не создать новую дважды)
            editRecordCoin = RecordCoinCell(uid: uuid!, datePickUp: datePickUp, coin: coin)
        }
    }
   */
    
    @IBAction func toMapButton(_ sender: Any) {
        //let newViewController = DetailViewController()
        //self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "addManualPin" {
            let destinationController = segue.destination as! MapViewController
            //destinationController.realmCoinRecord = coinRecord
            destinationController.manualPinAllowed = true
            //destinationController.editLattitude = coinRecord.latitude
            //destinationController.editLongitude = coinRecord.longitude
        }
    }
}


extension InputViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayCoins.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayCoins[row].fullName
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        fieldCoin.text = arrayCoins[row].fullName
        self.saveRecord(["uid" : self.uid!, "coin" : arrayCoins[row]])
        ////if let editRec = editRecordCoin { //редактируем запись
            ////editRec.name        = arrayCoins[row].name //запоминаем новое выбранное значение
            ////editRec.currency    = arrayCoins[row].currency.rawValue
            ////editRec.rating      = arrayCoins[row].rating
            ////editRec.generalySign = arrayCoins[row].generalySign
            ////editRec.metal       = arrayCoins[row].metal
            
            //coinRecord.coin = arrayCoins[row]
            
        ////} else { //новая запись
        ////    selectedCoin = arrayCoins[row] //используем глобальный массив с флагами добавленная монета и т д думаю ничего страшного в этом нет
        ////}
        //fieldCoin.resignFirstResponder() //скрывает пикервью после завершения выбора значения
    }
}

extension InputViewController: UITextFieldDelegate {
    
    //при добавлении новой монеты если поля пустые запоним их текущей датой и самой младшей монетой
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.navigationItem.rightBarButtonItem = doneButton //установим кнопку Done
        
        if uid == nil { //если нет редактируемой монеты значит мы добавляем новую
            if fieldCoin.isEditing && fieldCoin.text!.isEmpty {
                //fieldCoin.text = cutNameBrackets(name: arrayCoins[0].name)
                if let coin = arrayCoins.first {
                    fieldCoin.text = coin.fullName
                ////selectedCoin = arrayCoins[0]
                    //coinRecord.coin = coin
                    mapButton.isEnabled = true
                }
            }
            if fieldDate.isEditing && fieldDate.text!.isEmpty  {
                //coinRecord.datePickUp = datePicker.date as NSDate
                fieldDate.text = extDateToString(date: (Date()))
                //selectedDate = datePicker.date
            }
        }
    }
}
    
    

