//
//  BestSellersViewModel.swift
//  NYTimesBestSellerBooks
//
//  Created by Izza Nadeem on 11/20/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation

final class BestSellersViewModel {
    
    let bestSellersContentManager = BestSellerContentManager()
    let settingsContentManager = SettingsContentManager()
    let bookDetailContentManager = BookDetailContentManager()
    
    var book = [BooksInfo]() {
        didSet {
            //do something here to reload the collectionView
        }
    }
    
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
    
    func loadBooks(fromBestSellers bestSeller: BestSellers,
                   completionHandler: @escaping (BooksInfo?) -> Void,
                   errorHandler: @escaping (AppError) -> Void) {
        guard let isbn = bestSeller.isbns.first?.isbn10 else {return}
        guard let url = URL(string:"https://www.googleapis.com/books/v1/volumes?q=+isbn:\(isbn)") else {return}
        let completion = {(onlineBooks: [BooksInfo]) in
            completionHandler(onlineBooks.first)
        }
        let printErrors = {(error: Error) in
            print(error)
        }
        bookDetailContentManager.getBookDetail(from: url, completionHandler: completion, errorHandler: {print($0)})
    }
    
    func bestSellersCount() -> Int {
        return bestSellersArray.count
    }
    
    func bestSellersAtRow(_ index: Int) -> BestSellers? {
        return bestSellersArray[index]
        //maybe call loadboooksatrow here? and then when data is fetched, reload collectionVC
      
    }
    
    func booksInfoAt(bestSeller: BestSellers) -> BooksInfo? {
        var thingToReturn: BooksInfo?
        loadBooks(fromBestSellers: bestSeller, completionHandler: { (book: BooksInfo?) in
            thingToReturn = book
        }, errorHandler: {print($0)}) //probably call alert
        return thingToReturn
    }
    
}
