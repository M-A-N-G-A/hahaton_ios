//
//  ImagePickerController.swift
//  OpenMVP
//
//  Created by Ayur Arkhipov on 27.11.2021.
//

import UIKit

class ImagePickerController: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    enum Errors: Error {
        case cancel
        case imageNotFound(String)
    }
    
    var picker = UIImagePickerController()
//    var viewController: UIViewController?
    var complete: ((Result<UIImage, Error>) -> Void)?

    static let shared = ImagePickerController()
    
    func pickImage(_ viewController: UIViewController, _ complete: @escaping ((Result<UIImage, Error>) -> Void)) {
//        self.viewController = viewController;
        self.complete = complete
        picker = UIImagePickerController()
        picker.delegate = self
        
        picker.sourceType = .photoLibrary
        viewController.present(picker, animated: true, completion: nil)
    }

    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        complete?(.failure(Errors.cancel))
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            complete?(.failure(Errors.imageNotFound(info.description)))
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        Log.debug(image)
        complete?(.success(image))
    }

}

