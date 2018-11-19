//
//  UserDefault.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 1/3/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation
class UserDefaultsHelper: NSObject {
    
    private override init() {}
    static let manager = UserDefaultsHelper()
    let selectedCategoryKey = "selectedCategory"
    @objc dynamic var currentCategoryIndex = 7
    
    func getPickerIndex() -> Int? {
       return UserDefaults.standard.integer(forKey: selectedCategoryKey)
    }
    
    func setPickerIndex(index: Int) {
        UserDefaults.standard.set(index, forKey: selectedCategoryKey)
        currentCategoryIndex = index
    }
    
}
