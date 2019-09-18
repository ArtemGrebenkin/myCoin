//
//  DataViewController.swift
//  myCoin
//
//  Created by Artem Grebenkin on 4/17/18.
//  Copyright © 2018 Artem Grebenkin. All rights reserved.
//

import UIKit
import RealmSwift

class DataViewController: UIViewController {
    
    var arrayRecords: Results<CoinRecord>!

    @IBOutlet weak var dataTable: UITableView!
    let visibleTime: Double = -16 //max time of visible mark "New" on a cell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayRecords = realm.objects(CoinRecord.self).sorted(byKeyPath: "datePickUp", ascending: false)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    //override func viewWillAppear(_ animated: Bool) {
    //    arrayRecords = realm.objects(CoinRecord.self).sorted(byKeyPath: "datePickUp", ascending: false)
    //}
    
    @objc func addPressed() {
        //go to ahead screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let towardVC = storyboard.instantiateViewController(withIdentifier: "inputVC") as! InputViewController
        self.navigationController?.pushViewController(towardVC, animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = dataTable.indexPathForSelectedRow {
            let destinationController = segue.destination as! InputViewController
            
            if segue.identifier == "editRecord" {
                destinationController.uid = arrayRecords[indexPath.row].uid
            } else { //во всех остальных случаях будем считать что создаем новую запись
                destinationController.uid = UUID().uuidString //генерируем уникальный идентификатор новой монеты
            }
        }
    }
}


extension DataViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayRecords.isEmpty ? 0 : arrayRecords.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! DataTableViewCell
        //remove gray selected color
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 254, green: 239, blue: 0, alpha: 0)
        cell.selectedBackgroundView = backgroundView
        if let recordDate = arrayRecords[indexPath.row].datePickUp {
            cell.datePickUpLabel?.text = extDateToString(date: recordDate as Date)
            cell.newCoinImage.isHidden = recordDate.timeIntervalSinceNow > visibleTime ? false:true   //mark the cell as new (some seconds)
        }
        cell.coinNameLabel?.text = arrayRecords[indexPath.row].coin?.fullName
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StorageManager.deleteObject(arrayRecords[indexPath.row])
            dataTable.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
