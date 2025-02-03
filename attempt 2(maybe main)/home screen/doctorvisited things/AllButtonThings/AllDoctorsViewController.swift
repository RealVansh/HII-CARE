import UIKit

class AllDoctorsViewController: UIViewController {
    var doctor: [Doctor] = []
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Doctors List"
        registerCells()
        setupNavigationBar()
        
    }
    private func registerCells() {
        tableView.register(UINib(nibName: AllDocListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AllDocListTableViewCell.identifier)
    }
    private func setupNavigationBar() {
            let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDoctorTapped))
            navigationItem.rightBarButtonItem = plusButton
        }

    @objc private func addDoctorTapped() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let addDoctorVC = storyboard.instantiateViewController(withIdentifier: "add_doctor") as? AddDoctorDetailsViewController {
                addDoctorVC.modalPresentationStyle = .pageSheet
                self.present(addDoctorVC, animated: true, completion: nil)
            }
        }
}
extension AllDoctorsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllDocListTableViewCell.identifier, for: indexPath) as! AllDocListTableViewCell
        cell.setup(doctor: doctor[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctor.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name if different
        if let controller = storyboard.instantiateViewController(withIdentifier: "DoctorDetailViewController") as? DoctorDetailViewController {
            controller.doctor = doctor[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }

}

