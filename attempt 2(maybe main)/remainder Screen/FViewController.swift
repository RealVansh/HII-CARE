import UIKit

class FViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    private var models = [Medicine]()
    private var expandedRows = Set<Int>() // Track expanded rows

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reminder"
        view.addSubview(tableView)
        getAllItems()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds

        // Add long press gesture recognizer
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tableView.addGestureRecognizer(longPressGesture)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddMedicine))
    }

    @objc private func didTapAddMedicine() {
        let addEditVC = AddMedicineViewController()
        addEditVC.viewTitle = "Add Medicine"

        addEditVC.completionHandler = { [weak self] name, repeatChoices, frequencyChoices, foodChoice in
            let repeatChoiceString = repeatChoices.joined(separator: ", ")
            let frequencyChoiceString = frequencyChoices.joined(separator: ", ")

            self?.createItem(name: name, repeatChoice: repeatChoiceString, frequencyChoice: frequencyChoiceString, foodChoice: foodChoice)
        }

        let navigationController = UINavigationController(rootViewController: addEditVC)
        present(navigationController, animated: true, completion: nil)
    }

    func createItem(name: String, repeatChoice: String, frequencyChoice: String, foodChoice: String) {
        let newItem = Medicine(context: context)
        newItem.name = name
        newItem.repeatChoice = repeatChoice
        newItem.frequencyChoice = frequencyChoice
        newItem.foodChoice = foodChoice
        newItem.createdAt = Date()

        do {
            try context.save()
            getAllItems()
        } catch {
            print("Failed to save item: \(error)")
        }
    }

    func getAllItems() {
        do {
            models = try context.fetch(Medicine.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Failed to fetch items")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let frequencyText = model.frequencyChoice ?? "No Frequency"
        cell.textLabel?.numberOfLines = 1
        cell.textLabel?.text = "\(model.name ?? "Unnamed") - \(frequencyText)"

        if expandedRows.contains(indexPath.row) {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = """
            Name: \(model.name ?? "Unnamed")
            Repeat: \(model.repeatChoice ?? "No Repeat")
            Frequency: \(model.frequencyChoice ?? "No Frequency")
            Food Choice: \(model.foodChoice ?? "No Food Choice")
            """
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if expandedRows.contains(indexPath.row) {
            expandedRows.remove(indexPath.row)
        } else {
            expandedRows.insert(indexPath.row)
        }

        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    @objc private func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }

        if gesture.state == .began {
            let selectedItem = models[indexPath.row]

            // Create action sheet
            let actionSheet = UIAlertController(title: "Manage Item", message: nil, preferredStyle: .actionSheet)

            // Edit action
            actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] _ in
                self?.editItem(item: selectedItem)
            }))

            // Delete action
            actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                self?.deleteItem(item: selectedItem)
            }))

            // Cancel action
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            // Present the action sheet
            present(actionSheet, animated: true, completion: nil)
        }
    }

    func editItem(item: Medicine) {
        let addEditVC = AddMedicineViewController()
        addEditVC.viewTitle = "Edit Medicine"

        addEditVC.placeholder = item.name ?? "Enter medicine name"
        addEditVC.completionHandler = { [weak self] name, repeatChoices, frequencyChoices, foodChoice in
            item.name = name
            item.repeatChoice = repeatChoices.joined(separator: ", ")
            item.frequencyChoice = frequencyChoices.joined(separator: ", ")
            item.foodChoice = foodChoice

            do {
                try self?.context.save()
                self?.getAllItems()
            } catch {
                print("Failed to edit item: \(error)")
            }
        }

        let navigationController = UINavigationController(rootViewController: addEditVC)
        present(navigationController, animated: true, completion: nil)
    }

    func deleteItem(item: Medicine) {
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        } catch {
            print("Failed to delete item: \(error)")
        }
    }
}
