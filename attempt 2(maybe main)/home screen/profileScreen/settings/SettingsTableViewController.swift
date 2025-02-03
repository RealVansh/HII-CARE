//
//  SettingsTableViewController.swift
//  attempt 2(maybe main)
//
//  Created by admin100 on 10/01/25.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    let settingsOptions = ["Reset Password", "Notifications"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the table view
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        cell.textLabel?.text = settingsOptions[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedOption = settingsOptions[indexPath.row]
        
        if selectedOption == "Reset Password" {
            // Navigate to Reset Password Screen
            performSegue(withIdentifier: "ResetPasswordSegue", sender: self)
        } else if selectedOption == "Notifications" {
            // Navigate to Notifications Screen
            performSegue(withIdentifier: "NotificationsSegue", sender: self)
        }
    }

    private func navigateToResetPassword() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resetPasswordVC = storyboard.instantiateViewController(withIdentifier: "ResetPasswordViewController")
        navigationController?.pushViewController(resetPasswordVC, animated: true)
    }

    private func navigateToNotifications() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let notificationsVC = storyboard.instantiateViewController(withIdentifier: "NotificationsViewController")
        navigationController?.pushViewController(notificationsVC, animated: true)
    }
}
