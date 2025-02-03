import UIKit
import FirebaseAuth

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides: [OnboardingSlide] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.setTitle("Get Started", for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if the user is already logged in
        if Auth.auth().currentUser != nil {
            print("User is already signed in: \(Auth.auth().currentUser?.uid ?? "No UID")")
            transitionToHome()
            return // Exit here to avoid onboarding initialization
        }
        
        // Initialize onboarding slides
        slides = [
            OnboardingSlide(title: "Hassle-Free Storage", description: "Easy store and access to all your Medical Records.", image: UIImage.first),
            OnboardingSlide(title: "Never Miss a Dose", description: "Get timely reminders for your medications.", image: UIImage.second),
            OnboardingSlide(title: "Your Health at a Glance", description: "Quickly access your vital health details.", image: UIImage.last)
        ]
        
        // Set up collectionView and pageControl
        pageControl.numberOfPages = slides.count
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        if currentPage == slides.count - 1 {
            let controller = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .crossDissolve
            present(controller, animated: true, completion: nil)
        } else {
            currentPage += 1
            
            // Validate currentPage to avoid out-of-bounds error
            guard currentPage < slides.count else { return }
            
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    // Transition to the Home screen
    func transitionToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainTC = storyboard.instantiateViewController(withIdentifier: "MainTC") as? UITabBarController {
            self.view.window?.rootViewController = mainTC
            self.view.window?.makeKeyAndVisible()
        } else {
            print("Error: Could not find MainTC in storyboard")
        }
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
