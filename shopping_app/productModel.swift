//
//  productModel.swift
//  shopping_app
//
//  Created by Muvindu on 9/23/19.
//  Copyright © 2019 Muvindu. All rights reserved.
//

import Foundation

class productModel {
    var name: String
    var description: String
    var price: String
    
    init(name: String, description: String, price: String) {
        self.name = name
        self.description = description
        self.price = price
    }
}
