//
//  RegisterViewController.swift
//  shopping_app
//
//  Created by Muvindu on 9/26/19.
//  Copyright © 2019 Muvindu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class RegisterViewController: UIViewController {

    @IBOutlet var userEmail: UITextField!
    @IBOutlet var userPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  
    @IBAction func userRegister(_ sender: Any) {
        
        if (!(userEmail.text?.isEmpty ?? true) && !(userPass.text?.isEmpty ?? true)){
            registerAPI(user: userEmail.text!, password: userPass.text!)
        }
        
    }
    
    
    
    
    func registerAPI(user: String, password: String){
        Alamofire.request("https://reqres.in/api/register", method: .post,
                          parameters: ["email": user,"password": password]
                          )
                .responseJSON { response in
                guard response.result.isSuccess,
                    let value = response.result.value else {
                        print("Error while fetching tags: \(String(describing: response.result.error))")
                        return
                }
                
                // 3
                let response = JSON(value)
                   
                    if response["token"].exists() {
                        print("response someKey exists")
                        let ProductListView: ProductListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProductListViewController") as! ProductListViewController
                        
                       
                self.navigationController?.pushViewController(ProductListView,animated: true);
                        print(response)
                    }else{
                        print(response)
                    }
                }
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
