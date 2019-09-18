//
//  SettingsViewController.swift
//  myCoin
//
//  Created by Artem Grebenkin on 6/17/18.
//  Copyright © 2018 Artem Grebenkin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var metalLabel: UILabel!
    @IBOutlet weak var paperLabel: UILabel!
    @IBOutlet weak var settingsTable: UITableView!
    @IBOutlet weak var swMetal: UISwitch!
    @IBOutlet weak var swPaper: UISwitch!
    
    //let setting = Settings()
    //var arraySetting: [Coin] = []
    //var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    var selectedIndexPath: IndexPath?
    let arrayCurrency: [Currency] = Currency.allValues
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTable.rowHeight = UITableView.automaticDimension
        settingsTable.isScrollEnabled = false
        metalLabel.text = "Монеты"
        paperLabel.text = "Банкноты"
        
        metalLabel.isHidden = true
        swMetal.isHidden = true
        paperLabel.isHidden = true
        swPaper.isHidden = true
    }

    
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //var txtArray: [String] = []

        if let srtCurrency = UserDefaults.standard.string(forKey: "Currency") {
            //txtArray = ["Валюта:"]
            swMetal.isOn = UserDefaults.standard.bool(forKey: "Metal")
            swPaper.isOn = UserDefaults.standard.bool(forKey: "Paper")
            //arraySetting = setting.generateSettingRows(txtArray: txtArray)
    
            
            //set the checkmark from UserDefaults
            //for (i,item) in arraySetting.enumerated() {
            for (i,item) in arrayCurrency.enumerated() {
                //if item.currency.rawValue == srtCurrency {
                if item.currencyISO == srtCurrency {
                    
                    selectedIndexPath = IndexPath(row: i, section: 0)
                }
            }
        } 
     }
    
    
    
    @IBAction func swMetal(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "Metal")
        UserDefaults.standard.synchronize()
    }
    
    
    
    @IBAction func swPaper(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "Paper")
        UserDefaults.standard.synchronize()
    }
    
    
   /*
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return arraySetting.count
        return arrayCurrency.count
     }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) //as! SettingsTableViewCell
        //remove gray selected color
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 254, green: 239, blue: 0, alpha: 0)
        cell.selectedBackgroundView = backgroundView
     
        //cell.textLabel?.text = arraySetting[indexPath.row].name
        cell.textLabel?.text = arrayCurrency[indexPath.row].curName + " " + arrayCurrency[indexPath.row].generalyName
        
        cell.textLabel?.font = UIFont(name: "Courier New" , size: 25.0)
        cell.textLabel?.textAlignment = NSTextAlignment.center
        if selectedIndexPath == indexPath {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        return cell
     }
    
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        settingsTable.deselectRow(at: indexPath, animated: true)
        //if checkmakr set, don`t repeat
        if indexPath == selectedIndexPath {//|| arraySetting[indexPath.row].rating == 0 {
            
            return
        }
        //set new checkmakr and delete old checkmark
        let newCell = tableView.cellForRow(at: indexPath)
        if newCell?.accessoryType == UITableViewCellAccessoryType.none {
            newCell?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        if selectedIndexPath != nil {
            let oldCell = tableView.cellForRow(at: selectedIndexPath!)
            if oldCell?.accessoryType == UITableViewCellAccessoryType.checkmark {
                oldCell?.accessoryType = UITableViewCellAccessoryType.none
            }
        }
        //the selected cell is saving
        selectedIndexPath = indexPath
        
        //UserDefaults.standard.set(arraySetting[indexPath.row].currency.rawValue, forKey: "Currency")
        //UserDefaults.standard.set(arraySetting[indexPath.row].currency.curSymbol, forKey: "CurSymbol")
        UserDefaults.standard.set(arrayCurrency[indexPath.row].curName, forKey: "Currency")
        UserDefaults.standard.set(arrayCurrency[indexPath.row].curSymbol, forKey: "CurSymbol")
        
        UserDefaults.standard.set(swMetal.isOn, forKey: "Metal")
        UserDefaults.standard.set(swPaper.isOn, forKey: "Paper")
        UserDefaults.standard.synchronize()

        //let queue = DispatchQueue.global(qos: .utility)
        //queue.async{
        
        //self.setting.generateMoney(cur: self.arraySetting[indexPath.row].currency)//start async after that reload data
        self.setting.generateMoney(cur: self.arrayCurrency[indexPath.row])//start async after that reload data
        
            //DispatchQueue.main.async {
             //   if arrayCoins.isEmpty {
                   // let animate = Animates(table: settingsTable)
                   // let txtArray = ["Упс! Ааааууч!","Эти монеты ПРОПАЛИ!", "Полиция!..."]
                    //let txtArray = ["Какую валюту","Вы хотите использовать?"]
                   // self.arraySetting = self.setting.generateSettingRows(txtArray: txtArray)
                  //  animate.animateTable()

             //   } else {
        let delayInSeconds = 0.5
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            self.navigationController?.popViewController(animated: true)
        }
             //   }
                ////self.coinTable.reloadData()
                ////self.animateTable()
            //}
        //}
     }
 
  */

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

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return arrayCurrency.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        //remove gray selected color
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 254, green: 239, blue: 0, alpha: 0)
        cell.selectedBackgroundView = backgroundView
        
        cell.textLabel?.text = arrayCurrency[indexPath.row].currencyISO + " " + arrayCurrency[indexPath.row].currencyName
        
        cell.textLabel?.font = UIFont(name: "Courier New" , size: 25.0)
        cell.textLabel?.textAlignment = NSTextAlignment.center
        if selectedIndexPath == indexPath {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Выбирете валюту"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        settingsTable.deselectRow(at: indexPath, animated: true)
        //if checkmakr set, don`t repeat
        if indexPath == selectedIndexPath {
            
            return
        }
        //set new checkmakr and delete old checkmark
        let newCell = tableView.cellForRow(at: indexPath)
        if newCell?.accessoryType == UITableViewCell.AccessoryType.none {
            newCell?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        if selectedIndexPath != nil {
            let oldCell = tableView.cellForRow(at: selectedIndexPath!)
            if oldCell?.accessoryType == UITableViewCell.AccessoryType.checkmark {
                oldCell?.accessoryType = UITableViewCell.AccessoryType.none
            }
        }
        //the selected cell is saving
        selectedIndexPath = indexPath
        
        UserDefaults.standard.set(arrayCurrency[indexPath.row].currencyISO, forKey: "Currency")
        UserDefaults.standard.set(arrayCurrency[indexPath.row].currencySymbol, forKey: "CurSymbol")
        
        UserDefaults.standard.set(swMetal.isOn, forKey: "Metal")
        UserDefaults.standard.set(swPaper.isOn, forKey: "Paper")
        UserDefaults.standard.synchronize()


        Settings.generateMoney(cur: self.arrayCurrency[indexPath.row])//start async after that reload data
        

        let delayInSeconds = 0.5
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            self.navigationController?.popViewController(animated: true)
        }

    }
    
    
}
