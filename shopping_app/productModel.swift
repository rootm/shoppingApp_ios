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
    var user: String
    var description: String
    var price: String
    var photos: String
    var location: String
    

convenience init() {
        self.init()
    }
    
    init(name: String, user: String, description: String, price: String, photos: String, location: String) {
        self.name = name
        self.description = description
        self.price = price
        self.photos = photos
        self.location = location
        self.user=user

    }
}
