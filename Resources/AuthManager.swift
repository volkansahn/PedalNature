//
//  AuthManager.swift
//  PedalNature
//
//  Created by Volkan on 26.09.2021.
//

import FirebaseAuth

public class AuthManager{
    
    static let shared = AuthManager()
    
    // MARK: -Public
    
    public func registerUser(email: String, password: String, completion : @escaping (Bool) -> Void){
        
        DatabaseManager.shared.canCreateNewUser(with: email) { canCreate in
            if canCreate{
                // Create Account
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    guard authResult != nil, error == nil else{
                        completion(false)
                        return
                    }
                    
                    // Insert to Database
                    DatabaseManager.shared.insertNewUser(with: email) { inserted in
                        if inserted{
                            completion(true)
                            return
                        }else{
                            completion(false)
                            return
                        }
                    }
                    
                }
            }else{
                completion(false)

            }
        }
        
        
    }
    
    public func loginUser(email: String, password: String, completion : @escaping (Bool) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard authResult != nil, error == nil else{
                completion(false)
                return
            }
            completion(true)
            
        }
    }
    
    public func logOut(completion : (Bool) -> Void){
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        } catch  {
            print(error)
            completion(false)
            return
        }
    }
}
