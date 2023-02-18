//
//  Utils.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-18.
//

import Foundation
import YPImagePicker

class Utils {
    static func openPhotoGallery(controller: UIViewController, completion: @escaping(_ picker: YPImagePicker) -> Void) {
        var imagePickerConfig = YPImagePickerConfiguration()
        imagePickerConfig.library.mediaType = .photo
        imagePickerConfig.library.maxNumberOfItems = 1
        imagePickerConfig.startOnScreen = .library
        imagePickerConfig.shouldSaveNewPicturesToAlbum = false
        imagePickerConfig.hidesBottomBar = false
        imagePickerConfig.screens = [.library]
        imagePickerConfig.hidesBottomBar = false
        
        let imagePicker = YPImagePicker(configuration: imagePickerConfig)
        imagePicker.modalPresentationStyle = .fullScreen
        controller.present(imagePicker, animated: true)
        
        completion(imagePicker)
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        controller.present(picker, animated: true)
    }
}
