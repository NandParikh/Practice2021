//
//  DatabaseHelper.swift
//  Practise2021
//
//  Created by Nand Parikh on 19/03/21.
//

import Foundation
import UIKit
import CoreData

class DatabaseHelper {
    
    static var shareInstance = DatabaseHelper()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    //MARK:- Save Data
    func saveData(object : [String:Any]){
        
        let user = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context!) as! Users
        user.userId = object["userId"] as? String
        user.name = object["name"] as? String
        user.email = object["email"] as? String
        user.avatar = object["avatar"] as? Data
        user.phoneNumber = 8980400932
        user.gender = true

        //Get Document Directory Path for CoreData
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("Doc directory path is \(path)")
        
        //Users/nandparikh/Library/Developer/CoreSimulator/Devices/977FF2E6-487E-49EA-8939-D18639DE96FB/data/Containers/Data/Application/440FCB8C-9219-4070-821A-52D859D20D28/Documents
        //Library/ApplicatoinSupport/Practise2021
        
        //SaveUser
        do {
            try context!.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK:- Edit Data
    func editData(object : [String:Any], index : Int){
        let users = fetchData()
        users[index].userId = (object["userId"] as! String)
        users[index].name = (object["name"] as! String)
        users[index].email = (object["email"] as! String)
        users[index].avatar = (object["avatar"] as! Data)

        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("Doc directory path is \(path)")

        do {
            try context?.save()
        } catch  {
            print("")
        }
    }

    //MARK:- Fetch Data
    func fetchData() -> [Users]{

        var users = [Users]()
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Users")
        
        do {
            users = try context!.fetch(fetchRequest) as! [Users]
            
        } catch  {
            let fetchError = error as NSError
            print(fetchError)
        }
        return users
    }
    
    //MARK:- Delete Data
    func deleteData(index : Int) -> [Users]{
        var user = fetchData()
        context?.delete(user[index])
        user.remove(at: index)
        
        do {
            try context?.save()
        } catch  {
            print("cannot delete data")
        }
        return user
    }
    
    func saveImageToCoreData(object : [String:Data]){
        //Get Document Directory Path for CoreData
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("Doc directory path is \(path)")

        let randomNumber = Int.random(in: 1...100)
        let user = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context!) as! Users
        user.avatar = object["avatar"]
        user.userId = "\(randomNumber)"
        
        
        do {
            try context?.save()
        } catch  {
            print(error.localizedDescription)
        }
    }

    func completionHandlerExample(name : String, completion : (Int, Bool, String) -> Void) -> String{
        completion(5,true,"good")
        return name
    }
}


//    func updateData(){
//        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Users")
//        let predicate : NSPredicate = NSPredicate(format: "userId=%d", 1)
//        print(predicate)
//        fetchRequest.predicate = predicate
//
//        do {
//            if let fetchResults = try managedContext!.fetch(fetchRequest) as? [NSManagedObject]
//            {
//                if fetchResults.count != 0 {
//                    let managedObject = fetchResults[0]
//                    managedObject.setValue("Pinto", forKey: "name")
//                    try managedContext!.save()
//                }
//            }
//
//
//        } catch {
//            let fetchError = error as NSError
//            print(fetchError)
//        }
//    }

//    func deleteData(){
//        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Users")
//        let predicate : NSPredicate = NSPredicate(format: "userId=%d", 2)
//        fetchRequest.predicate = predicate
//
//
//        let batchDeleteRequest : NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context!.execute(batchDeleteRequest)
//        } catch  {
//            print(error.localizedDescription)
//        }
//    }


