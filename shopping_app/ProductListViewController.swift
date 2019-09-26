//
//  ProductListViewController.swift
//  shopping_app
//
//  Created by Muvindu on 9/26/19.
//  Copyright © 2019 Muvindu. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let db = DbStore()
    var productlist: [productModel] = []
    var vendor:Bool = false
    
    @IBOutlet weak var ProductsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       if vendor{
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProduct(sender:)))
            
            self.navigationItem.rightBarButtonItem = addButton

        }
        
        productlist = getproducts()
        // Do any additional setup after loading the view.
    }

    
    @objc func addProduct(sender: UIBarButtonItem){
        let productAddView: ImageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        
     
        
        self.navigationController?.pushViewController(productAddView, animated: true)
        
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:ProductsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductsCollectionViewCell
        
        cell.productImage.image = getImage(product: productlist[indexPath.row])
        cell.productName.text = productlist[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsView: ProductDescViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProductDescViewController") as! ProductDescViewController
        
       print("sfsdfsdfsdfdsfsdfdsf")
        
        productDetailsView.product = productlist[indexPath.row]
        self.navigationController?.pushViewController(productDetailsView, animated: true)
    }
    
    
    
    
    func getproducts()->[productModel]{
        var products:[productModel]=[]
        do{
            products = try db.readAll()
            
        }catch{
            print(error)
        }
        
        return products
    }

    
    func getImage(product: productModel)-> UIImage{
        let name = product.photos.components(separatedBy: ",")[0]

       let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let imageURL =  documentsDirectory.appendingPathComponent(name)
            let image    = UIImage(contentsOfFile: imageURL.path)
            // Do whatever you want with the image
        return image!

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
