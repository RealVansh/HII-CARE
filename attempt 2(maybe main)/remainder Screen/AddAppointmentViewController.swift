//
//  AddAppointmentViewController.swift
//  ReminderTrial20wh
//
//  Created by user@25 on 06/01/25.
//

import UIKit

class AddAppointmentViewController: UIViewController {

    var completionHandler: ((_ details: String, _ date: Date, _ time: Date, _ doctorName: String, _ hospitalName: String) -> Void)?
    
    var viewTitle: String = "Add Appointment"
    
    private let doctorPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let doctorTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Select or enter doctor's name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let doctorOptions = ["Dr. Joseph", "Dr. Sanjana", "Dr. Nikhil", "Dr. Sumithra"] // Example doctor names
    
    private let hospitalTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter hospital name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let detailsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter appointment details"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.minimumDate = Date()
        return picker
    }()
    
    private let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .inline
        return picker
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Appointment", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewTitle
        view.backgroundColor = .systemBackground
        
        // Set up the doctor picker
        doctorPicker.delegate = self
        doctorPicker.dataSource = self
        doctorTextField.inputView = doctorPicker // Set the picker as the input view for the text field
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(doctorTextField)
        view.addSubview(hospitalTextField)
        view.addSubview(detailsTextField)
        view.addSubview(datePicker)
        view.addSubview(timePicker)
        view.addSubview(saveButton)
        
        doctorTextField.translatesAutoresizingMaskIntoConstraints = false
        hospitalTextField.translatesAutoresizingMaskIntoConstraints = false
        detailsTextField.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Doctor's name text field
            doctorTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            doctorTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doctorTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Hospital name text field
            hospitalTextField.topAnchor.constraint(equalTo: doctorTextField.bottomAnchor, constant: 20),
            hospitalTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hospitalTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Appointment details text field
            detailsTextField.topAnchor.constraint(equalTo: hospitalTextField.bottomAnchor, constant: 20),
            detailsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Date picker
            datePicker.topAnchor.constraint(equalTo: detailsTextField.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Time picker
            timePicker.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Save button
            saveButton.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 30),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func didTapSave() {
        guard let details = detailsTextField.text, !details.isEmpty,
              let doctorName = doctorTextField.text, !doctorName.isEmpty,
              let hospitalName = hospitalTextField.text, !hospitalName.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please fill in all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let selectedDate = datePicker.date
        let selectedTime = timePicker.date
        
        // Notify listeners about the data change
        NotificationCenter.default.post(name: NSNotification.Name("AppointmentDataChanged"), object: nil)
        
        completionHandler?(details, selectedDate, selectedTime, doctorName, hospitalName)
        dismiss(animated: true, completion: nil)
    }
    
}

// Extensions for UIPickerViewDataSource and UIPickerViewDelegate
extension AddAppointmentViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Single column
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return doctorOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return doctorOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        doctorTextField.text = doctorOptions[row] // Update the text field with the selected option
    }
}
