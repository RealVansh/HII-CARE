import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Initialize the window
        window = UIWindow(windowScene: windowScene)
        
        // Check if the user is already signed in
        if Auth.auth().currentUser != nil {
            print("User is already signed in: \(Auth.auth().currentUser?.uid ?? "")")
            
            // Load MainTC
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTC = storyboard.instantiateViewController(withIdentifier: "MainTC") as! UITabBarController
            window?.rootViewController = mainTC
        } else {
            print("No user signed in, showing onboarding.")
            
            // Load OnboardingViewController
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let onboardingVC = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController")
            window?.rootViewController = onboardingVC
        }
        
        // Make the window key and visible
        window?.makeKeyAndVisible()
    }
}
