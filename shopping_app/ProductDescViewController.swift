//
//  ProductDescViewController.swift
//  shopping_app
//
//  Created by Muvindu on 9/26/19.
//  Copyright © 2019 Muvindu. All rights reserved.
//

import UIKit

class ProductDescViewController: UIViewController {

    @IBOutlet var productImages: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var productDesc: UILabel!
    
    var product: productModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        self.productImages.image=UIImage.animatedImage(with: self.getImages(product: product), duration: 2.0);
        self.productName.text = product.name
        self.productPrice.text = product.price
        self.productDesc.text = product.description
    }
    
    @IBAction func openLocation(_ sender: Any) {
    }
    
    func getImages(product: productModel)-> [UIImage]{
        var images:[UIImage] = []
        var names = product.photos.components(separatedBy: ",")
        for i in 0..<names.count{
        
        //let name = product.photos.components(separatedBy: ",")[0]
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageURL =  documentsDirectory.appendingPathComponent(names[i])
        let image    = UIImage(contentsOfFile: imageURL.path)
            images.append(image!)
        }
        // Do whatever you want with the image
        return images
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
