//
//  ImageViewController.swift
//  shopping_app
//
//  Created by Muvindu on 9/25/19.
//  Copyright © 2019 Muvindu. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
class ImageViewController: UIViewController {
    var SelectedAssets = [PHAsset]()
    var ImageAssets = [UIImage]()
    var ImageNames = [String]()
    
    @IBOutlet weak var productNmae: UITextField!
    @IBOutlet weak var productDesc: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productVIew: UIImageView!
    let db = DbStore()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  
    @IBAction func saveProduct(_ sender: Any) {
        
        if ((productNmae.text?.isEmpty ?? true) || (productDesc.text?.isEmpty ?? true) || (productPrice.text?.isEmpty ?? true) || ImageAssets.count==0){
            do{
              //try db.deleteAll()
             //   var  pr = try db.readAll()
                
                //print(pr)
            }catch{
                print(error)
            }
            print("empty fields")
        }else{
            self.saveImagesToDocuments(images: self.ImageAssets, folder: "productTest")

            let product = productModel(name: productNmae.text!,user: "vendor1", description: productDesc.text!, price: productPrice.text!,photos: ImageNamesToArray(names: ImageNames),location: "test");
//             let product = productModel(name: "productNmae",user: "vendor1", description:" productDesc", price: "productPrice",photos: "ImageNamesToArra",location: "test");

            
            db.create(record: product)
//             do{
//             var  pr = try db.readAll()
//
//             }catch{
//                print(error)
//            }
            
            
        }
        
    }
    
    @IBAction func selectImages(_ sender: Any) {
        
        let vc = BSImagePickerViewController()
        vc.takePhotos=true
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            // User selected an asset.
                                            // Do something with it, start upload perhaps?
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            // Do something, cancel upload?
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            self.ImageAssets.removeAll();
            self.ImageNames.removeAll()
            print(assets.count)
            
            self.SelectedAssets.removeAll()
            self.ImageAssets.removeAll()
            
            for i in 0..<assets.count {
                self.SelectedAssets.append(assets[i])
                self.ImageAssets.append(self.convertImageFromAsset(asset: assets[i]))
                print(self.SelectedAssets)
            }
            
            self.productVIew.image=UIImage.animatedImage(with: self.ImageAssets, duration: 1.0);
           
          //  self.saveImagesToDocuments(images: self.ImageAssets, folder: "product")
            
          //  self.loadImagesFromAlbum(folderName: "product")
            
        }, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func convertImageFromAsset(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            image = result!
        })
        return image
    }
    
    func saveImagesToDocuments(images: [UIImage], folder: String ) {
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        
        for i in 0..<images.count{
            
            let fileName = String(images[i].hashValue)+".jpg"
            // create the destination file url to save your image
            ImageNames.append(fileName)
            
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            // get your UIImage jpeg data representation and check if the destination file url already exists
//            let folderURL = documentsDirectory.appendingPathComponent(folder)
//
//            if !FileManager.default.fileExists(atPath: folderURL.path) {
//                try? FileManager.default.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true, attributes: nil) //Create folder if not
//            }
            
            if let data = images[i].jpegData(compressionQuality:  1.0),
                !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    print("file saved")
                    
                    //return true;
                } catch {
                    print("error saving file:", error)
                    //  return false
                }
            }
            
        }
        
    }
    
    
     func loadImagesFromAlbum(folderName:String) -> [String]{
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        var theItems = [String]()
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(folderName)
            
            do {
                theItems = try FileManager.default.contentsOfDirectory(atPath: imageURL.path)
                return theItems
            } catch let error as NSError {
                print(error.localizedDescription)
                return theItems
            }
        }
        return theItems
    }
    
    func ImageNamesToArray(names: [String])-> String{
        print(names.count)
        
       var nameString = ""
        for i in 0..<names.count{
           
            if (i==names.count-1){
                nameString += names[i]
            }else{
                nameString += names[i]+","
            }
            
        }
        
        print(nameString)
        return nameString;
    }
    
}
