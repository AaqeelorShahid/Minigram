//
//  UploadImage.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-13.
//

import Foundation
import FirebaseStorage

struct ImageUploader {
     static func uploadImageToStorage(image: UIImage, completion: @escaping (String) -> Void){
         guard let image = image.jpegData(compressionQuality: 0.50) else {return}
         
         let fileName = NSUUID().uuidString
         let ref = Storage.storage().reference(withPath: "/profile/\(fileName)")
         
         ref.putData(image, metadata: nil) { meta, err in
             if let error = err {
                 print("Failed to upload image \(err?.localizedDescription)")
                 return
             }
             
             ref.downloadURL { url, err in
                 guard let imgUrl = url?.absoluteString else {return}
                 completion(imgUrl)
             }
         }
    }
}
