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

    
    static func generateMoney(cur: Currency) {
        //arrayCoins.removeAll()
        let array = [1,5,10,100] //массив возможных номиналов и их шагов
        var number = 0
        
        //sub money
        for (var index,element) in array.enumerated() {
            if element == array.last {break}
            index += 1
            while number < array[index] {
                number += element
                let imgName = String(number) + cur.subUnitName
                if UIImage(named: imgName) != nil { //если нашли картинку значит монета существует добавим ее
                    //need to clear arrayCoins here
                    //let newCoin = Coin(generalySign: false, currency: cur, rating: Int16(number), imgName: imgName1, orderInArray: arrayCoins.count) //создаем объект монета
                    let newCoin = Coin()
                    newCoin.currISO = cur.currencyISO
                    newCoin.subUnit = true
                    newCoin.imgName = imgName
                    newCoin.uid = imgName
                    //newCoin.orderInArray = arrayCoins.count
                    newCoin.rating = number
                    //arrayCoins.append(newCoin) //сначала заполняем массив младшими монетами
                    StorageManager.saveObjectCoin(newCoin)
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
                let imgName = String(number) + cur.currencyName
                if UIImage(named: imgName) != nil { //если нашли картинку значит монета существует добавим ее
                    //need to clear arrayCoins here
                    //let newCoin = Coin(generalySign: true, currency: cur, rating: Int16(number), imgName: imgName0, orderInArray: arrayCoins.count) //создаем объект монета
                    let newCoin = Coin()
                    newCoin.currISO = cur.currencyISO
                    newCoin.subUnit = false
                    newCoin.imgName = imgName
                    newCoin.uid = imgName
                    //newCoin.orderInArray = arrayCoins.count
                    newCoin.rating = number
                    //arrayCoins.append(newCoin) //потом заполняем массив старшими монетами
                    StorageManager.saveObjectCoin(newCoin)
                }
            }
        }
    }
}
