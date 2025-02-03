//
//  ViewController.swift
//  MyHealthScreen
//
//  Created by admin100 on 12/12/24.
//

import UIKit
import PDFKit

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var BloodgroupLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var whiteViewController: UIView!
    var userProfile: UserProfile = UserData.userProfile

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupTableView()

        self.navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        whiteViewController.layer.cornerRadius = 20
        whiteViewController.layer.masksToBounds = true
        whiteViewController.layer.shadowColor = UIColor.black.cgColor
        whiteViewController.layer.shadowOpacity = 0.1
        whiteViewController.layer.shadowOffset = CGSize(width: 0, height: 4)
        whiteViewController.layer.shadowRadius = 10
        whiteViewController.layer.masksToBounds = false
    }
  

    func setupHeader() {
                profileImageView.layer.cornerRadius = 50
                profileImageView.clipsToBounds = true
                profileImageView.contentMode = .scaleAspectFit
                nameLabel.text = userProfile.name
                nameLabel.font = UIFont(name: "SFPro-Regular", size: 32) ?? UIFont.boldSystemFont(ofSize: 32)
                nameLabel.textColor = .white
                
                detailsLabel.text = "\(userProfile.age) Years, \(userProfile.gender)"
                detailsLabel.font = UIFont(name: "SFPro-Regular", size: 14) ?? UIFont.systemFont(ofSize: 16)
                detailsLabel.textColor = .systemGray6
                
                BloodgroupLabel.text = "Blood Group: \(userProfile.bloodGroup)"
                BloodgroupLabel.font = UIFont(name: "SFPro-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
                BloodgroupLabel.textColor = .white
                       
                  
            }
            
        func setupTableView() {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ConditionCell")
            tableView.separatorStyle = .none
           
        }
            
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return userProfile.conditions.count
            }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ConditionCell", for: indexPath)
                let condition = userProfile.conditions[indexPath.row]

                // Configure the cell's text
                cell.textLabel?.text = "\(indexPath.row + 1). \(condition)"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                cell.textLabel?.textColor = .darkText

                // Set the background color of the cell
                cell.contentView.backgroundColor = UIColor(hexCode: "F5F7FF") // Set cell background color

                // Apply rounded corners for the first and last cells
                if indexPath.row == 0 {
                    cell.contentView.layer.cornerRadius = 20
                    cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                } else if indexPath.row == userProfile.conditions.count - 1 {
                    cell.contentView.layer.cornerRadius = 20
                    cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                } else {
                    cell.contentView.layer.cornerRadius = 0
                }

                // Remove cell selection style
                cell.selectionStyle = .none

                return cell
            }

            func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                return 60
            }
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1  // One section for the title and one for the conditions
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            if section == 0 {
                return "You should know that I have"
            } else {
                return nil  // No header for the condition rows section
            }
        }
        
        // MARK: - Customizing Header Appearance
        func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            if section == 0 {
                guard let header = view as? UITableViewHeaderFooterView else { return }
                header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                header.textLabel?.textColor = .darkText
                header.textLabel?.textAlignment = .center
                header.contentView.backgroundColor = .clear
            }
        }
    @IBAction func exportButtonTapped(_ sender: UIButton) {
        exportTableViewToPDF(from: self)
    }
    func exportTableViewToPDF(from viewController: UIViewController) {
        // 1. Define PDF page size (A4)
        let pdfPageFrame = CGRect(x: 0, y: 0, width: 595, height: 842) // A4 size in points
        let pdfData = NSMutableData()

        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)

        // 2. Define margins and offsets
        var yOffset: CGFloat = 40 // Start lower from top
        let contentWidth = pdfPageFrame.width - 40 // Add side margins (20 each side)

        // 3. Add Title - "HII-CARE"
        let title = "HII-CARE"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 28),
            .foregroundColor: UIColor.systemBlue
        ]
        let titleSize = title.size(withAttributes: titleAttributes)
        title.draw(at: CGPoint(x: (pdfPageFrame.width - titleSize.width) / 2, y: yOffset), withAttributes: titleAttributes)
        yOffset += 60 // Space after title

        // 4. Add Patient Name
        let patientName = "Patient Name: \(UserData.userProfile.name)"
        let nameAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.darkGray
        ]
        patientName.draw(in: CGRect(x: 20, y: yOffset, width: contentWidth, height: 30), withAttributes: nameAttributes)
        yOffset += 40 // Space after name

        // 5. Add Table View Content (Health Conditions)
        let conditionsTitle = "Health Conditions:"
        let conditionsTitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.black
        ]
        conditionsTitle.draw(in: CGRect(x: 20, y: yOffset, width: contentWidth, height: 30), withAttributes: conditionsTitleAttributes)
        yOffset += 40 // Space after section title

        for (index, condition) in UserData.userProfile.conditions.enumerated() {
            let conditionText = "\(index + 1). \(condition)"
            let conditionAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.black
            ]
            conditionText.draw(in: CGRect(x: 20, y: yOffset, width: contentWidth, height: 30), withAttributes: conditionAttributes)
            yOffset += 30

            // Add new page if content exceeds the page height
            if yOffset > pdfPageFrame.height - 40 {
                UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
                yOffset = 40 // Reset yOffset for new page
            }
        }

        // 6. End PDF context
        UIGraphicsEndPDFContext()

        // 7. Save PDF to temporary location
        let filePath = NSTemporaryDirectory().appending("HealthReport.pdf")
        pdfData.write(toFile: filePath, atomically: true)
        let fileURL = URL(fileURLWithPath: filePath)

        // 8. Share using UIActivityViewController
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = viewController.view
        viewController.present(activityViewController, animated: true, completion: nil)
    }


}

//extension UIColor {
//    convenience init(hexCode: String) {
//        var hexSanitized = hexCode.trimmingCharacters(in: .whitespacesAndNewlines)
//        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized
//        
//        var rgb: UInt64 = 0
//        Scanner(string: hexSanitized).scanHexInt64(&rgb)
//        
//        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
//        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
//        let blue = CGFloat(rgb & 0x0000FF) / 255.0
//        
//        self.init(red: red, green: green, blue: blue, alpha: 1.0)
//    }
//}
