//
//  ViewModel.swift
//  NYTimesBestSellerBooks
//
//  Created by Izza Nadeem on 11/16/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation
protocol CategoriesViewModalProtocol: class {
    func categoriesDataLoaded()
    func dataFetchFailed()
}

public class CategoriesViewModel {
    
    weak var delegate: CategoriesViewModalProtocol?
    let settingsContentManager = SettingsContentManager()
    
    //Collection of fetch categories
    var categoriesArray = [AllCategories]() {
        didSet {
           delegate?.categoriesDataLoaded()
        }
    }
    
    convenience init() {
        self.init(categories: [AllCategories]())
    }
    
    init(categories: [AllCategories]) {
        categoriesArray = categories
    }
    
    func fetchCategories() {
        guard let url = URL(string:"https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=44b75ac0d27a44b5a98c2919a81ffa76") else {return}
        let completion = {(onlineCategories: [AllCategories]) in
            self.categoriesArray = onlineCategories
            //            self.settingsPickerView.selectRow(UserDefaultsHelper.manager.gettingPickerIndex(), inComponent: 0, animated: true)
        }
        _ = {(error: Error) in
            print(error)
        }
        settingsContentManager.getCategories(from: url, completionHandler: completion) {[unowned self] (error) in
            self.delegate?.dataFetchFailed()
        }
    }
    
    func categoriesCount() -> Int {
        return categoriesArray.count
    }
    
    func categoriesAtRow(_ row: Int) -> String {
        return categoriesArray[row].categoryName
    }
    
    func categoriesAtRowForKey(_ row: Int) -> String {
        return categoriesArray[row].key
    }
    
}

