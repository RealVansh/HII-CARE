//
//  AppDelegate.swift
//  test-yoga5
//
//  Created by user@22 on 04/11/24.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import CoreData
import FirebaseFirestore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        Thread.sleep(forTimeInterval: 3)
        // Override point for customization after application launch.
        FirebaseApp.configure()
        checkUserSignInStatus()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func checkUserSignInStatus(){
        if let user = Auth.auth().currentUser{
            print("User is already signde in: \(user.uid)")
            showHomeScreen()
        }else {
            print("No user is signed in.")
            showLoginScreen()
        }
    }
    func showHomeScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
    }
    func showLoginScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let googleViewController = storyboard.instantiateViewController(withIdentifier: "GoogleVC") as! GoogleViewController
    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ReminderTrial20wh")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
     
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}



