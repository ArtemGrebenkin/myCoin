//
//  InputViewController.swift
//  myCoin
//
//  Created by Artem Grebenkin on 6/3/18.
//  Copyright © 2018 Artem Grebenkin. All rights reserved.
//

import UIKit
import CoreData


class InputViewController: UIViewController  {
    
    @IBOutlet weak var fieldCoin: UITextField!
    @IBOutlet weak var fieldDate: UITextField!
    @IBOutlet weak var textCoordinateLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    
    let picker = UIPickerView()
    let datePicker = UIDatePicker()
    var uid: String? //уид записи переданной сюда на редактирование
    //var editRecordCoin: RecordCoinCell? //переданные на редактирование данные ячейки из таблицы
    //var editRecordCoin: CoinsData? //переданные на редактирование данные ячейки из таблицы
    var coinRecord = RecordCoinCell()//модель данных
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //if uid != nil {
        let coreData = CoreDataOperations()
        //let coinsData = coreData.fetchData(uid: uid)
        let coinsData = coreData.fetchFromCoreData(uid: uid)
        ////mapButton.isEnabled = true
            
        //fieldCoin.text = cutNameBrackets(name: editRec.name)
        if let cd = coinsData?.first { //если мы что-то нашли значит и уид имеется и это существующая запись
            fieldCoin.text = cd.name                   // имя монеты
            textCoordinateLabel.text = cd.locationDescription // описание координат
            if let date = cd.datePickUp as Date? {
                fieldDate.text = extDateToString(date: date)
            }
            
            //перебераем массив монет пока не найдем монету-экземпляр по ее имени из CoreData (умнее я ни чего не придумал)
            for (index,element) in arrayCoins.enumerated() {
                if element.name == cd.name {
                    picker.selectRow(index, inComponent: 0, animated: true)
                    coinRecord.coin = arrayCoins[index]
                    break
                }
            }
            
            
            //заполняем остальные атрибуты модели данных
            coinRecord.latitude = cd.latitude
            coinRecord.longitude = cd.longitude
            coinRecord.datePickUp = cd.datePickUp
            coinRecord.locationDescription = cd.locationDescription
            coinRecord.uid = uid
        }
        //}
        //fieldCoin.text = txtCoinName
        //fieldDate.text = txtDateName
        //textCoordinateLabel.text = txtDescription
        //picker.selectRow(pickerIndex, inComponent: 0, animated: true)
        //datePicker.setDate(pickerDate, animated: true)
        
    }
    /*
    //при добавлении новой монеты если поля пустые запоним их текущей датой и самой младшей монетой
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.navigationItem.rightBarButtonItem = doneButton //установим кнопку Done
        
        if editRecordCoin == nil { //если нет редактируемой монеты значит мы добавляем новую
            if fieldCoin.isEditing && fieldCoin.text!.isEmpty {
                //fieldCoin.text = cutNameBrackets(name: arrayCoins[0].name)
                fieldCoin.text = arrayCoins[0].name
                selectedCoin = arrayCoins[0]
                mapButton.isEnabled = true
            }
            if fieldDate.isEditing && fieldDate.text!.isEmpty  {
                fieldDate.text = extDateToString(date: (Date()))
                selectedDate = datePicker.date
            }
        }
    }
    */
    
    
    
    @objc func dateChanged(datePicker: UIDatePicker)  {
        fieldDate.text = extDateToString(date: datePicker.date)
        ////editRecordCoin?.datePickUp = datePicker.date as NSDate
        coinRecord.datePickUp = datePicker.date as NSDate
       /*
        if let editRec = editRecordCoin { //редактируем запись
            editRec.datePickUp = datePicker.date //запоминаем новое выбранное значение
        } else { //новая запись
             //selectedDate = datePicker.date //для создания новой записи
        }
    */
    }
    
   //тап мимо клавиатуры должен завершить ввод
   // @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
   //     view.endEditing(true)
   // }
    
    @objc func donePressed() {
        view.endEditing(true)
        //addCoinToCoreData()
        guard fieldDate.text != nil else { return }
        guard fieldCoin.text != nil else { return }
        
        saveCoinToCoreData()
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

    func saveCoinToCoreData() {
        guard coinRecord.coin != nil else {return}
        let coreData = CoreDataOperations()
        coreData.saveToCoreData(&coinRecord)
    }
    
    @IBAction func toMapButton(_ sender: Any) {
        //let newViewController = DetailViewController()
        //self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "addManualPin" {
            let destinationController = segue.destination as! DetailViewController
            //if editRecordCoin == nil { //если правим существующую запись
            //    self.createNewRecord()
            //}
            //destinationController.selectedCoin = coinRecord.coin
            //destinationController.uuid = uid
            //destinationController.selectedDate = selectedDate
            //destinationController.selectedDate = datePicker.date
            destinationController.coinRecord = coinRecord
            destinationController.manualPinAllowed = true
            destinationController.editLattitude = coinRecord.latitude
            destinationController.editLongitude = coinRecord.longitude
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

extension InputViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayCoins.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return cutNameBrackets(name: arrayCoins[row].name)
        return arrayCoins[row].name
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //fieldCoin.text = cutNameBrackets(name: arrayCoins[row].name)
        fieldCoin.text = arrayCoins[row].name
        
        ////if let editRec = editRecordCoin { //редактируем запись
            ////editRec.name        = arrayCoins[row].name //запоминаем новое выбранное значение
            ////editRec.currency    = arrayCoins[row].currency.rawValue
            ////editRec.rating      = arrayCoins[row].rating
            ////editRec.generalySign = arrayCoins[row].generalySign
            ////editRec.metal       = arrayCoins[row].metal
            
            coinRecord.coin = arrayCoins[row]
            
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
                    fieldCoin.text = coin.name
                ////selectedCoin = arrayCoins[0]
                    coinRecord.coin = coin
                    mapButton.isEnabled = true
                }
            }
            if fieldDate.isEditing && fieldDate.text!.isEmpty  {
                coinRecord.datePickUp = datePicker.date as NSDate
                fieldDate.text = extDateToString(date: (Date()))
                //selectedDate = datePicker.date
            }
        }
    }
}
    
    

