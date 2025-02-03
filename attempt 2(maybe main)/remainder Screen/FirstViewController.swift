import UIKit
import CoreData

class FirstViewController: UIViewController {

    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let medicineSwitchView = UIView()
    private let medicineSwitchLabel = UILabel()
    private let medicineSwitch = UISwitch()
    private let medicationsView = UIView()
    private let appointmentsView = UIView()
    private let editMedicationsButton = UIButton(type: .system)
    private let editAppointmentsButton = UIButton(type: .system)
    private let scrollView = UIScrollView()
    private let appointmentsStackView = UIStackView()

    private var medicines = [Medicine]() // Medicines data
    private var appointments = [Appointment]() // Appointments data

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        fetchMedicines()
        fetchAppointments()

        // Observe notifications for data updates
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name("DataUpdated"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMedicines()
        fetchAppointments()
    }

    // MARK: - UI Setup
    private func setupUI() {
        setupTitleAndDate()
        setupMedicationsView()
        setupAppointmentsView()
    }

    private func setupTitleAndDate() {
        // Title Label
        titleLabel.text = "Reminder"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Date Label
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        dateLabel.text = formatter.string(from: Date())
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.textAlignment = .center
        dateLabel.textColor = .darkGray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)

        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupMedicationsView() {
        medicationsView.backgroundColor = .secondarySystemBackground
        medicationsView.layer.cornerRadius = 10
        medicationsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(medicationsView)

        let medicationsLabel = UILabel()
        medicationsLabel.text = "Your Medication"
        medicationsLabel.font = UIFont.boldSystemFont(ofSize: 20)
        medicationsLabel.translatesAutoresizingMaskIntoConstraints = false
        medicationsView.addSubview(medicationsLabel)

        editMedicationsButton.setTitle("Edit", for: .normal)
        editMedicationsButton.tintColor = .systemBlue
        editMedicationsButton.addTarget(self, action: #selector(editMedicationsTapped), for: .touchUpInside)
        editMedicationsButton.translatesAutoresizingMaskIntoConstraints = false
        medicationsView.addSubview(editMedicationsButton)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        medicationsView.addSubview(scrollView)

        NSLayoutConstraint.activate([
            medicationsView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            medicationsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            medicationsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            medicationsView.heightAnchor.constraint(equalToConstant: 200),

            medicationsLabel.topAnchor.constraint(equalTo: medicationsView.topAnchor, constant: 10),
            medicationsLabel.leadingAnchor.constraint(equalTo: medicationsView.leadingAnchor, constant: 10),

            editMedicationsButton.centerYAnchor.constraint(equalTo: medicationsLabel.centerYAnchor),
            editMedicationsButton.trailingAnchor.constraint(equalTo: medicationsView.trailingAnchor, constant: -10),

            scrollView.topAnchor.constraint(equalTo: medicationsLabel.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: medicationsView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: medicationsView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: medicationsView.bottomAnchor, constant: -10)
        ])
    }

    private func setupAppointmentsView() {
        appointmentsView.backgroundColor = .secondarySystemBackground
        appointmentsView.layer.cornerRadius = 10
        appointmentsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appointmentsView)

        let appointmentsLabel = UILabel()
        appointmentsLabel.text = "Upcoming Appointments"
        appointmentsLabel.font = UIFont.boldSystemFont(ofSize: 20)
        appointmentsLabel.translatesAutoresizingMaskIntoConstraints = false
        appointmentsView.addSubview(appointmentsLabel)

        editAppointmentsButton.setTitle("Edit", for: .normal)
        editAppointmentsButton.tintColor = .systemBlue
        editAppointmentsButton.addTarget(self, action: #selector(editAppointmentsTapped), for: .touchUpInside)
        editAppointmentsButton.translatesAutoresizingMaskIntoConstraints = false
        appointmentsView.addSubview(editAppointmentsButton)

        let appointmentsScrollView = UIScrollView()
        appointmentsScrollView.translatesAutoresizingMaskIntoConstraints = false
        appointmentsView.addSubview(appointmentsScrollView)

        appointmentsStackView.axis = .vertical
        appointmentsStackView.spacing = 10
        appointmentsStackView.translatesAutoresizingMaskIntoConstraints = false
        appointmentsScrollView.addSubview(appointmentsStackView)

        NSLayoutConstraint.activate([
            appointmentsView.topAnchor.constraint(equalTo: medicationsView.bottomAnchor, constant: 20),
            appointmentsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            appointmentsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            appointmentsView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
            appointmentsView.heightAnchor.constraint(equalToConstant: 200),

            appointmentsLabel.topAnchor.constraint(equalTo: appointmentsView.topAnchor, constant: 10),
            appointmentsLabel.leadingAnchor.constraint(equalTo: appointmentsView.leadingAnchor, constant: 10),

            editAppointmentsButton.centerYAnchor.constraint(equalTo: appointmentsLabel.centerYAnchor),
            editAppointmentsButton.trailingAnchor.constraint(equalTo: appointmentsView.trailingAnchor, constant: -10),

            appointmentsScrollView.topAnchor.constraint(equalTo: appointmentsLabel.bottomAnchor, constant: 10),
            appointmentsScrollView.leadingAnchor.constraint(equalTo: appointmentsView.leadingAnchor),
            appointmentsScrollView.trailingAnchor.constraint(equalTo: appointmentsView.trailingAnchor),
            appointmentsScrollView.bottomAnchor.constraint(equalTo: appointmentsView.bottomAnchor),

            appointmentsStackView.topAnchor.constraint(equalTo: appointmentsScrollView.topAnchor),
            appointmentsStackView.leadingAnchor.constraint(equalTo: appointmentsScrollView.leadingAnchor, constant: 10),
            appointmentsStackView.trailingAnchor.constraint(equalTo: appointmentsScrollView.trailingAnchor, constant: -10),
            appointmentsStackView.bottomAnchor.constraint(equalTo: appointmentsScrollView.bottomAnchor),
            appointmentsStackView.widthAnchor.constraint(equalTo: appointmentsScrollView.widthAnchor)
        ])
    }

    // MARK: - Data Fetching
    private func fetchMedicines() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            medicines = try context.fetch(Medicine.fetchRequest())
            displayMedicines()
        } catch {
            print("Failed to fetch medicines: \(error)")
        }
    }

    private func fetchAppointments() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            appointments = try context.fetch(Appointment.fetchRequest())
            print("Fetched Appointments: \(appointments)") // Debugging
            for appointment in appointments {
                print("Appointment Name: \(appointment.name ?? "No Name")") // Debug
            }
            displayAppointments()
        } catch {
            print("Failed to fetch appointments: \(error)")
        }
    }

    private func displayMedicines() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        var yOffset: CGFloat = 0
        for medicine in medicines {
            let label = UILabel()
            label.text = medicine.name
            label.frame = CGRect(x: 10, y: yOffset, width: scrollView.frame.size.width - 20, height: 30)
            label.font = UIFont.systemFont(ofSize: 16)
            scrollView.addSubview(label)
            yOffset += 40
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: yOffset)
    }

    private func displayAppointments() {
        appointmentsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for appointment in appointments {
            let label = UILabel()

            label.text = "\(appointment.details ?? "No details") with  \(appointment.doctorName ?? "Unknown Doctor")"
            
            label.font = UIFont.systemFont(ofSize: 16)
            label.numberOfLines = 0
            appointmentsStackView.addArrangedSubview(label)
        }
    }

    // MARK: - Notification Handling
    @objc private func refreshData() {
        fetchMedicines()
        fetchAppointments()
    }

    // MARK: - Actions
    @objc private func editMedicationsTapped() {
        let editMedicationsVC = FViewController()
        navigationController?.pushViewController(editMedicationsVC, animated: true)
    }

    @objc private func editAppointmentsTapped() {
        let editAppointmentsVC = AppointmentViewController()
        navigationController?.pushViewController(editAppointmentsVC, animated: true)
    }
}
