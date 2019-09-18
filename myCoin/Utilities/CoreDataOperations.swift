//
//  CoreDataOperations.swift
//  myCoin
//
//  Created by Artem Grebenkin on 4/27/18.
//  Copyright © 2018 Artem Grebenkin. All rights reserved.
//

import CoreData
import UIKit

class CoreDataOperations: NSObject {
 /*
    // MARK: Save data
    //func saveData(name:String, currency:String, datePickUp:Date, latitude:Double, longitude:Double, rating:Int16) -> Void {
    //func saveData(coin:Coin, datePickUp:Date, latitude:Double?, longitude:Double?) -> Void {
    func saveToCoreData(_ someData: inout RecordCoinCell) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        var entityData = CoinsData(context: context)
        
        if let uid = someData.uid {
            if let resultData = fetchFromCoreData(uid: uid) {
                entityData = resultData.first!
            }
        } else {
            entityData.uid = UUID().uuidString
            someData.uid = entityData.uid
        }
        
        entityData.name = someData.coin?.name
        entityData.currency = someData.coin?.currency.curName
        entityData.datePickUp = someData.datePickUp
        entityData.latitude = someData.latitude!
        entityData.longitude = someData.longitude!
        entityData.rating = someData.coin!.rating
        entityData.generalySign = someData.coin!.generalySign
        entityData.metal = someData.coin!.metal
        entityData.locationDescription = someData.locationDescription
        
        appDelegate.saveContext()
    }
    
    
    func fetchFromCoreData(uid: String?) -> [CoinsData]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<CoinsData> = CoinsData.fetchRequest()
        if let uid = uid {
            request.predicate = NSPredicate(format: "uid == %@", uid)
        } else {
            if let cur = UserDefaults.standard.string(forKey: "Currency") {
                request.predicate = NSPredicate(format: "currency == %@", cur)
            }
        }
        //добавим сортировку по дате по убыв
        let sort = NSSortDescriptor(key: #keyPath(CoinsData.datePickUp), ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            let result = try context.fetch(request)
            //result.forEach { article in
            //}
            return result
        }  catch {
            fatalError("Failed to fetch records: \(error)")
        }
    }
    
    
    
    
/*
    func saveData(someData: RecordCoinCell) -> Void {
        let managedObjectContext = getContext()
        let coinData = NSEntityDescription.insertNewObject(forEntityName: "CoinsData", into: managedObjectContext) as! CoinsData
        
        coinData.name = someData.coin?.name
        coinData.currency = someData.coin?.currency.curName
        coinData.datePickUp = someData.datePickUp
       // if latitude != nil && longitude != nil {
        coinData.latitude = someData.latitude
        coinData.longitude = someData.longitude
        //}
        if someData.uid == nil {
            coinData.uid = UUID().uuidString
        } else {
            coinData.uid = someData.uid
        }
        
        coinData.rating = someData.coin!.rating
        coinData.generalySign = someData.coin!.generalySign
        coinData.metal = someData.coin!.metal
        do {
            try managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
    }
    
    func saveDataNew(object: NSManagedObject) {

        let context = getContext()
        //let entity = NSEntityDescription.entity(forEntityName: "CoinsData", in: context)
        
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
    }
    */
    // MARK: Fetching Data
    /*
    func fetchData() -> [CoinsData]? {
        
        let moc = getContext()
  
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoinsData")
        if let cur = UserDefaults.standard.string(forKey: "Currency") {
            fetchRequest.predicate = NSPredicate(format: "currency == %@", cur)
        }
        
        //добавим сортировку по дате по убыв
        let sort = NSSortDescriptor(key: #keyPath(CoinsData.datePickUp), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let fetchedCoin = try moc.fetch(fetchRequest) as! [CoinsData]
            return fetchedCoin
            
        } catch {
            fatalError("Failed to fetch records: \(error)")
        }
    }
   */
    
  /*
    func fetchData(uid:String?) -> [CoinsData]? {
        
        let moc = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoinsData")
        if uid != nil {
            fetchRequest.predicate = NSPredicate(format: "uid == %@", uid!)
        } else {
            if let cur = UserDefaults.standard.string(forKey: "Currency") {
                fetchRequest.predicate = NSPredicate(format: "currency == %@", cur)
            }
        }
        
        //добавим сортировку по дате по убыв
        let sort = NSSortDescriptor(key: #keyPath(CoinsData.datePickUp), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let fetchedCoin = try moc.fetch(fetchRequest) as! [CoinsData]
            return fetchedCoin
            
        } catch {
            fatalError("Failed to fetch records: \(error)")
        }
        
    }
    */
    // MARK: Delete Data Records
    
    func deleteRecords(uid: String) -> Void {
        let moc = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoinsData")
        //if let key = keyCurrentDate {
        //fetchRequest.predicate = NSPredicate(format: "uid == %@", uid as CVarArg)
        //fetchRequest.predicate = NSPredicate(format: "uid == nil")
        //}
        let result = try? moc.fetch(fetchRequest)
        let resultData = result as! [CoinsData]
        
        for object in resultData {
            moc.delete(object)
        }
        
        do {
            try moc.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        } catch {
            
        }
        
        
        
        
        
    }
    
    // MARK: Update Data
    /*
    func updateRecords(editedRec: RecordCoinCell) -> Void {
        let moc = getContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoinsData")
        fetchRequest.predicate = NSPredicate(format: "uid == %@", editedRec.uid as CVarArg)
        
        let result = try? moc.fetch(fetchRequest)
        
        let resultData = result as! [CoinsData]
        for object in resultData {
            object.name = editedRec.name
            object.rating = editedRec.rating
            object.currency = editedRec.currency
            object.datePickUp = editedRec.datePickUp
            object.generalySign = editedRec.generalSign
            object.metal = editedRec.metal
            object.locationDescription = editedRec.locationDescription
            if let lat = editedRec.latitude, let lon = editedRec.longitude {
                object.latitude = lat
                object.longitude = lon
            }
 
        }
        do{
            try moc.save()
        }catch let error as NSError {
            print("Could not update \(error), \(error.userInfo)")
        }
    }
    */
    /*
    func updateRecords(editedRec: RecordCoinCell) -> Void {
        let moc = getContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoinsData")
        guard let uid = editedRec.uid  else { return }
        fetchRequest.predicate = NSPredicate(format: "uid == %@", uid as CVarArg)
        
        let result = try? moc.fetch(fetchRequest)
        
        let resultData = result as! [CoinsData]
        for object in resultData {
            object.name = editedRec.coin.name
            object.rating = editedRec.rating
            object.currency = editedRec.currency
            object.datePickUp = editedRec.datePickUp
            object.generalySign = editedRec.generalySign
            object.metal = editedRec.metal
            object.locationDescription = editedRec.locationDescription
            object.latitude = editedRec.latitude
            object.longitude = editedRec.longitude
        }
        do{
            try moc.save()
        }catch let error as NSError {
            print("Could not update \(error), \(error.userInfo)")
        }
    }
    */
    // MARK: Get Context
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
 */
}







