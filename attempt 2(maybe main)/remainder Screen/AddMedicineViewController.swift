//
//  AddMedicineViewController.swift
//  ReminderTrial20wh
//
//  Created by user@25 on 18/12/24.
//

// AddMedicineViewController.swift

import UIKit

class AddMedicineViewController: UIViewController {
    
    var viewTitle: String?
    var placeholder: String?
    var completionHandler: ((String, [String], [String], String) -> Void)?
    
    private var selectedRepeats = [String]()
    private var selectedFrequencies = [String]()
    private var selectedFoodChoice = "Before Food"
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter medicine name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let repeatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Repeat", for: .normal)
        return button
    }()
    
    private let frequencyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Frequency", for: .normal)
        return button
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Before Food", "After Food"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewTitle
        view.backgroundColor = .white
        
        view.addSubview(nameTextField)
        view.addSubview(repeatButton)
        view.addSubview(frequencyButton)
        view.addSubview(segmentedControl)
        view.addSubview(saveButton)
        
        nameTextField.frame = CGRect(x: 20, y: 100, width: view.frame.size.width - 40, height: 40)
        repeatButton.frame = CGRect(x: 20, y: 160, width: view.frame.size.width - 40, height: 50)
        frequencyButton.frame = CGRect(x: 20, y: 220, width: view.frame.size.width - 40, height: 50)
        segmentedControl.frame = CGRect(x: 20, y: 290, width: view.frame.size.width - 40, height: 40)
        saveButton.frame = CGRect(x: 20, y: 350, width: view.frame.size.width - 40, height: 50)
        
        repeatButton.addTarget(self, action: #selector(didTapRepeatButton), for: .touchUpInside)
        frequencyButton.addTarget(self, action: #selector(didTapFrequencyButton), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
    }
    
    @objc private func didTapRepeatButton() {
        let options = ["Every Monday", "Every Tuesday", "Every Wednesday", "Every Thursday", "Every Friday"]
        showMultiSelectAlert(title: "Select Repeat Options", options: options, selectedItems: selectedRepeats) { [weak self] selected in
            self?.selectedRepeats = selected
            self?.repeatButton.setTitle(selected.joined(separator: ", "), for: .normal)
        }
    }
    
    @objc private func didTapFrequencyButton() {
        let options = ["Morning", "Afternoon", "Evening"]
        showMultiSelectAlert(title: "Select Frequency Options", options: options, selectedItems: selectedFrequencies) { [weak self] selected in
            self?.selectedFrequencies = selected
            self?.frequencyButton.setTitle(selected.joined(separator: ", "), for: .normal)
        }
    }
    
    @objc private func didTapSaveButton() {
        guard let name = nameTextField.text, !name.isEmpty else {
            print("Name cannot be empty")
            return
        }
        completionHandler?(name, selectedRepeats, selectedFrequencies, selectedFoodChoice)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func segmentedControlChanged() {
        selectedFoodChoice = segmentedControl.selectedSegmentIndex == 0 ? "Before Food" : "After Food"
    }
    
    private func showMultiSelectAlert(title: String, options: [String], selectedItems: [String], completion: @escaping ([String]) -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        for option in options {
            let isSelected = selectedItems.contains(option)
            alert.addAction(UIAlertAction(title: option, style: .default, handler: { _ in
                if isSelected {
                    completion(selectedItems.filter { $0 != option })
                } else {
                    completion(selectedItems + [option])
                }
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
