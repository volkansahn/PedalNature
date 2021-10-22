//
//  StorageManager.swift
//  PedalNature
//
//  Created by Volkan on 26.09.2021.
//

import FirebaseStorage
import Foundation

public class StorageManager{
    
    static let shared = StorageManager()
    
    private let bucket = Storage.storage().reference()
    
    enum PNStorageManagerError : Error{
        case failedToDownload
    }
    
    public enum UserPostType{
        case routePhoto, profilePicture
    }
    
    // MARK: - Public
    
    public func uploadUserPost(model: UserPostType, completion: @escaping (Result<URL, Error>) -> Void){
        
    }
    
    public func downloadImage(with reference: String, completion: @escaping (Result<URL, Error>) -> Void){
        bucket.child(reference).downloadURL { url, error in
            guard let url = url, error == nil else{
                completion(.failure(PNStorageManagerError.failedToDownload))
                return
            }
            
            completion(.success(url))
        }
    }
}


