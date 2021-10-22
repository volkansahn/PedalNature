//
//  DatabaseManager.swift
//  PedalNature
//
//  Created by Volkan on 26.09.2021.
//

import FirebaseDatabase

public class DatabaseManager{
    
    static let shared = DatabaseManager()
    
    var ref = Database.database().reference()
    
    // MARK: -Public
    
    /// Check if Username is available
    ///  - Parameters
    ///         - email : String
    ///         - password: String
    public func canCreateNewUser(with email: String, completion: @escaping (Bool) -> Void){
        completion(true)
    }
    
    /// Insert user to Database
    ///  - Parameters
    ///         - email : String
    public func insertNewUser(with email: String, completion: @escaping (Bool) -> Void){
        self.ref.child("users").setValue(["email": email]){ error, _ in
            if error == nil {
                completion(true)
                return
            }
            
            else{
                completion(false)
                return
            }
        }
        
    }
}
