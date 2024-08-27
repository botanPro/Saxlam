//
//  XUploadImages.swift
//  wfbhl
//
//  Created by Botan Amedi on 23/09/2022.
//



import Foundation
import Firebase


class XUpload {
    
    static func UploadImage(Image : UIImage , completion : @escaping (_ url : String)->()) {
        guard let dataImg = Image.pngData() else { return }
        let storage = Storage.storage().reference()
        let imagesRef = storage.child("Pictures").child(UUID().uuidString)
        imagesRef.putData(dataImg, metadata: nil) { (meta, error) in print("botann")
            imagesRef.downloadURL { (url, error) in
                print("errooooor \(error.debugDescription)")
                guard let str = url?.absoluteString else { return }
                completion(str)
            }
        }
    }
}

extension UIImage {
    
    func upload(completion : @escaping (_ url : String)->()) {
        XUpload.UploadImage(Image: self) { (Url) in completion(Url) }
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    
    
}



