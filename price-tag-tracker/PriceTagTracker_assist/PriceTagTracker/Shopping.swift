//
//  Shopping.swift
//  PriceTagTracker
//
//  Created by arachnothrone on 2023-02-04.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

class ShoppingCart {
    var lastScannedPrice: Float = 0.0
    var currentGoodsPrice: Float = 0.0
    var currentGoodsPriceStr: String = "0.0"
    var numOfItems: Int = 0
    var lastItemRemoved: Bool = false
    
    func addItem(itemPrice: Float) {
        self.currentGoodsPrice += itemPrice
        self.currentGoodsPriceStr = "Price: $\(String(format: "%.2f", self.currentGoodsPrice))"
        self.numOfItems += 1
        self.lastScannedPrice = itemPrice
        self.lastItemRemoved = false
    }
    
    func removeLastItem() {
        if (!self.lastItemRemoved && self.numOfItems > 0) {
            self.numOfItems -= 1
            self.currentGoodsPrice -= self.lastScannedPrice
            self.currentGoodsPriceStr = "Price: $\(String(format: "%.2f", self.currentGoodsPrice))"
            print("removeLastItem: items=\(self.numOfItems), lastPrice=\(self.lastScannedPrice), currPrice=\(self.currentGoodsPrice)")
            self.lastScannedPrice = 0
            self.lastItemRemoved = true
        }
    }
    
    func printStateToConsole() {
        print("ShoppingCart: items=\(self.numOfItems), lastPrice=\(self.lastScannedPrice), currPrice=\(self.currentGoodsPrice)")
    }

    func getCurrentGoodsPrice() -> Float {
        return self.currentGoodsPrice
    }
    
}
