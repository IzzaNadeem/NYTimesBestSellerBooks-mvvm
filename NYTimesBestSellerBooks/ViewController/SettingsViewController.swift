//
//  ViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q  on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

//Final is class modifier which prevents it from being inherited or being overridden
 final class SettingsViewController: UIViewController {
    
    private var observation: NSKeyValueObservation?
    private let categoriesViewModel = CategoriesViewModel()

    private func setupObservers() {
        observation = UserDefaultsHelper.manager.observe(\.currentCategoryIndex, options: [.old, .new], changeHandler: { [weak self] _, _ in
            self?.settingsPickerView.selectRow(UserDefaultsHelper.manager.getPickerIndex() ?? 7, inComponent: 0, animated: true)
        })
    }
    
    @IBOutlet weak var settingsPickerView: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        self.settingsPickerView.delegate = self
        self.settingsPickerView.dataSource = self
        categoriesViewModel.delegate = self
        self.settingsPickerView.selectRow(UserDefaultsHelper.manager.getPickerIndex() ?? 7, inComponent: 0, animated: true)
    }

    func fetchData() {
     categoriesViewModel.fetchCategories()
    }
}

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesViewModel.categoriesCount()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesViewModel.categoriesAtRow(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaultsHelper.manager.setPickerIndex(index: row)
    }
}

extension SettingsViewController: CategoriesViewModalProtocol {
    
    func categoriesDataLoaded() {
        DispatchQueue.main.async {
         self.settingsPickerView.reloadAllComponents()
        }
    }
    
    func dataFetchFailed() {
        let errorAlert = Alert.createErrorAlert(withMessage: "Error Loading Data")
        self.present(errorAlert, animated: true, completion: nil)
    }

}
