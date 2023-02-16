//
//  UploadImage.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-13.
//

import Foundation
import FirebaseStorage

struct ImageUploader {
    static func uploadImageToStorage(image: UIImage, path: String, completion: @escaping (String) -> Void){
         guard let image = image.jpegData(compressionQuality: 0.50) else {return}
         
         let fileName = NSUUID().uuidString
            // Example for the path - "/profile"
         let ref = Storage.storage().reference(withPath: "\(path)/\(fileName)")
         
         ref.putData(image, metadata: nil) { meta, error in
             if let error = error {
                 print("Failed to upload image \(error.localizedDescription)")
                 return
             }
             
             ref.downloadURL { url, err in
                 guard let imgUrl = url?.absoluteString else {return}
                 completion(imgUrl)
             }
         }
    }
}
