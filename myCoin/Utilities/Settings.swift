//
//  Settings.swift
//  myCoin
//
//  Created by Artem Grebenkin on 6/23/18.
//  Copyright © 2018 Artem Grebenkin. All rights reserved.
//

import Foundation
import UIKit

class Settings {
 /*
    func generateSettingRows(txtArray: [String]) -> [Coin] {
        var arraySettings: [Coin] = []
        var i = 0
        
        for item in txtArray {
            let settingCoin = Coin(rating: 0, currency: Currency.USD ,textMsg: item ) //создаем объект монета
            arraySettings.append(settingCoin) //заполняем массив монетами
        }
        //gererate setting
        for item in Currency.allCases {
            i += 1
            //let settingCoin = Coin(rating: Int16(i), currency: item, textMsg: item.curName() + " " + item.generalyName())//создаем объект монета
            let settingCoin = Coin(rating: Int16(i), currency: item, textMsg: item.curName + " " + item.generalyName)//создаем объект монета
            arraySettings.append(settingCoin) //заполняем массив монетами
        }
       return arraySettings
    }
 */

    
    func generateMoney(cur: Currency) {
        arrayCoins.removeAll()
        let array = [1,5,10,100] //массив возможных номиналов и их шагов
        var number = 0
        
        //sub money
        // металлическая мелочь
        for (var index,element) in array.enumerated() {
            if element == array.last {break}
            index += 1
            while number < array[index] {
                number += element
                let imgName1 = String(number) + cur.subSignName
                if UIImage(named: imgName1) != nil { //если нашли картинку значит монета существует добавим ее
                    //need to clear arrayCoins here
                    let newCoin = Coin(generalySign: false, metal: true, currency: cur, rating: Int16(number), imgName: imgName1, orderInArray: arrayCoins.count) //создаем объект монета
                    arrayCoins.append(newCoin) //сначала заполняем массив младшими монетами
                }
            }
        }
        
        number = 0
        //base money
        for (var index,element) in array.enumerated() {
            if element == array.last {break}
            index += 1
            while number < array[index] {
                number += element
                let imgName0 = String(number) + cur.generalyName
                if UIImage(named: imgName0) != nil { //если нашли картинку значит монета существует добавим ее
                    //need to clear arrayCoins here
                    let newCoin = Coin(generalySign: true, metal: true, currency: cur, rating: Int16(number), imgName: imgName0, orderInArray: arrayCoins.count) //создаем объект монета
                    arrayCoins.append(newCoin) //потом заполняем массив старшими монетами
                }
            }
        }
    }
}
