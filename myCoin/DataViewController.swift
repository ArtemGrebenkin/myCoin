//
//  DataViewController.swift
//  myCoin
//
//  Created by Artem Grebenkin on 4/17/18.
//  Copyright © 2018 Artem Grebenkin. All rights reserved.
//

import UIKit


class DataViewController: UIViewController {

    @IBOutlet weak var dataTable: UITableView!
    let visibleTime: Double = -16 //max time of visible mark "New" on a cell
    //var coreDataResult:[CoinsData]? = nil //результат выборки из CoreData
    //var arrayCoinRecords:[RecordCoinCell] = [] //массив монет из CoreData
    var arrayCoinRecords:[CoinsData] = [] //массив монет из CoreData

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        self.navigationItem.rightBarButtonItem = addButton
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataFromCoreData()
        dataTable.reloadData()
    }

    
    
    @objc func addPressed() {
        //go to ahead screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let towardVC = storyboard.instantiateViewController(withIdentifier: "inputVC") as! InputViewController
        self.navigationController?.pushViewController(towardVC, animated: true)
    }
    
    
    /*
    func loadDataFromCoreData() {
        
        let coreData = CoreDataOperations()
        coreDataResult = coreData.fetchData()
        
        if let res = coreDataResult {
            arrayCoinRecords.removeAll()
            for item in res {
                let name = (item.name ?? "no name")
                let cur = (item.currency ?? "no currency")//это будет KZT rawvalue из энум переделать!
                let date = (item.datePickUp ?? Date())
                if let uuid = item.uid { //если нет ключа то эти записи не имеют смысла
                    let recCoin = RecordCoinCell(uid: uuid, name: name, currency: cur, rating: item.rating, datePickUp: date, generalSign: item.generalySign, metal: item.metal)
                    if let locDescr = item.locationDescription {
                        recCoin.locationDescription = locDescr
                    }
                    if item.latitude != 0 { //  добавим условие т.к. item.latitude не опциональный тип и поэтому он отдает 0 recCoin.latitude если в CoreData null
                        recCoin.latitude = item.latitude
                    }
                    if item.longitude != 0 {
                        recCoin.longitude = item.longitude
                    }
                    arrayCoinRecords.append(recCoin)
                }
            }
        }

    }
    */
    func loadDataFromCoreData() {
        
        let coreData = CoreDataOperations()
        //if let coreDataResult = coreData.fetchData(uid: nil) {
        if let coreDataResult = coreData.fetchFromCoreData(uid: nil) {
              arrayCoinRecords = coreDataResult
        }
    }
    
    
    
    
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCoinRecords.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! DataTableViewCell
        //remove gray selected color
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 254, green: 239, blue: 0, alpha: 0)
        cell.selectedBackgroundView = backgroundView
        cell.datePickUpLabel?.text = extDateToString(date: arrayCoinRecords[indexPath.row].datePickUp)
        //cell.coinNameLabel?.text = cutNameBrackets(name: arrayCoinRecords[indexPath.row].name)
        cell.coinNameLabel?.text = arrayCoinRecords[indexPath.row].name
        
        //mark the cell as new (some seconds)
        cell.newCoinImage.isHidden = true
        let recordTime = arrayCoinRecords[indexPath.row].datePickUp
        if recordTime.timeIntervalSinceNow > visibleTime {
            cell.newCoinImage.isHidden = false
        }
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFromCoreData(key: arrayCoinRecords[indexPath.row].uid)
            arrayCoinRecords.remove(at: indexPath.row)
            dataTable.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    */

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = dataTable.indexPathForSelectedRow {
            let destinationController = segue.destination as! InputViewController
            
            if segue.identifier == "editRecord" {
                //destinationController.editRecordCoin = arrayCoinRecords[indexPath.row]
                destinationController.uid = arrayCoinRecords[indexPath.row].uid
            } else { //во всех отсальных случаях будем считать что создаем новую запись
                destinationController.uid = UUID().uuidString //генерируем уникальный идентификатор новой монеты
            }
        }
    }
    
    
    
    func deleteFromCoreData(key: String) {
        let coreData = CoreDataOperations()
        coreData.deleteRecords(uid: key)
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


extension DataViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCoinRecords.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! DataTableViewCell
        //remove gray selected color
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 254, green: 239, blue: 0, alpha: 0)
        cell.selectedBackgroundView = backgroundView
        //cell.datePickUpLabel?.text = extDateToString(date: arrayCoinRecords[indexPath.row].datePickUp)
        if let recordDate = arrayCoinRecords[indexPath.row].datePickUp {
            cell.datePickUpLabel?.text = extDateToString(date: recordDate as Date)
            cell.newCoinImage.isHidden = recordDate.timeIntervalSinceNow > visibleTime ? false:true   //mark the cell as new (some seconds)
        }
        cell.coinNameLabel?.text = arrayCoinRecords[indexPath.row].name
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let recordDel = arrayCoinRecords[indexPath.row].uid {
                deleteFromCoreData(key: recordDel)
                arrayCoinRecords.remove(at: indexPath.row)
                dataTable.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
