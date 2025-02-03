//
//  EditAppointmentsViewController.swift
//  ReminderTrial20wh
//
//  Created by user@25 on 16/12/24.
//

import UIKit

class AppointmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    private var appointments = [Appointment]()
    var completion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Appointments"
        view.addSubview(tableView)
        getAllAppointments()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddAppointment))
    }

    @objc private func didTapAddAppointment() {
        let addEditVC = AddAppointmentViewController()
        addEditVC.viewTitle = "Add Appointment"

        addEditVC.completionHandler = { [weak self] details, date, time, doctorName, hospitalName in
            // Combine the date and time
            let calendar = Calendar.current
            let combinedDate = calendar.date(bySettingHour: calendar.component(.hour, from: time),
                                             minute: calendar.component(.minute, from: time),
                                             second: 0, of: date) ?? date

            self?.createAppointment(details: details, time: combinedDate, doctorName: doctorName, hospitalName: hospitalName)
        }

        let navigationController = UINavigationController(rootViewController: addEditVC)
        present(navigationController, animated: true, completion: nil)
    }

    func createAppointment(details: String, time: Date, doctorName: String, hospitalName: String) {
        let newAppointment = Appointment(context: context)
        newAppointment.details = details
        newAppointment.time = time
        newAppointment.doctorName = doctorName
        newAppointment.hospitalName = hospitalName

        do {
            try context.save()
            getAllAppointments()
        } catch {
            print("Failed to save appointment: \(error)")
        }
    }

    func getAllAppointments() {
        do {
            appointments = try context.fetch(Appointment.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Failed to fetch appointments")
        }
    }

    // MARK: - TableView Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let appointment = appointments[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Format date and time
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let dateTimeString = dateFormatter.string(from: appointment.time ?? Date())

        // Update the cell text
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.text = """
        \(appointment.details ?? "No details") at \(appointment.hospitalName ?? "Unknown Hospital")
        Doctor: \(appointment.doctorName ?? "Unknown Doctor") 
        Date & Time: \(dateTimeString)
        """

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let appointment = appointments[indexPath.row]

        let sheet = UIAlertController(title: "Edit Appointment", message: nil, preferredStyle: .actionSheet)

        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Edit Appointment", message: "Edit your appointment details", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = appointment.details
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newDetails = field.text, !newDetails.isEmpty else {
                    return
                }

                self?.updateAppointment(appointment: appointment, newDetails: newDetails)
            }))
            self.present(alert, animated: true)
        }))

        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteAppointment(appointment: appointment)
        }))

        present(sheet, animated: true)
    }

    // MARK: - Core Data Operations

    func deleteAppointment(appointment: Appointment) {
        context.delete(appointment)
        do {
            try context.save()
            getAllAppointments()
        } catch {
            print("Failed to delete appointment")
        }
    }

    func updateAppointment(appointment: Appointment, newDetails: String) {
        appointment.details = newDetails
        appointment.time = Date()

        do {
            try context.save()
            getAllAppointments()
        } catch {
            print("Failed to update appointment")
        }
    }
}






   
