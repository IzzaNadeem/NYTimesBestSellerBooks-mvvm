//
//  BestSellersViewModel.swift
//  NYTimesBestSellerBooks
//
//  Created by Izza Nadeem on 11/20/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation

public class bestSellersViewModel {
    
    let bestSellersContentManager = BestSellerContentManager()
    let settingsContentManager = SettingsContentManager()
    
    var bestSellersArray = [BestSellers]() {
        didSet {
            
        }
    }
    
    var categoriesArray = [AllCategories]() {
        didSet {
            
        }
    }
    
    convenience init() {
        self.init(bestSellers: [BestSellers]())
    }
    
    init(bestSellers: [BestSellers]) {
       bestSellersArray = bestSellers
    }
    
    func loadCategories() {
        guard let url = URL(string:"https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=44b75ac0d27a44b5a98c2919a81ffa76") else {return}
        let completion = {(onlineCategories: [AllCategories]) in
            self.categoriesArray = onlineCategories
            guard let firstCategories = onlineCategories.first else {return}
            self.fetchBestSellers(fromCategoryName: firstCategories.key)
        }
        let printErrors = {(error: Error) in
            print(error)
        }
        settingsContentManager.getCategories(from: url, completionHandler: completion, errorHandler: {print($0)})
    }
    
    func fetchBestSellers(fromCategoryName: String) {
        guard let url = URL(string:"https://api.nytimes.com/svc/books/v3/lists.json?api-key=44b75ac0d27a44b5a98c2919a81ffa76&list=\(fromCategoryName)") else {return}
        let completion = {(onlineBestSellers: [BestSellers]?) in
            self.bestSellersArray = onlineBestSellers!
        }
        let printErrors = {(error: Error) in
            print(error)
        }
        bestSellersContentManager.getBestSellers(from: url, completionHandler: completion, errorHandler: {print($0)})
    }
    
}
