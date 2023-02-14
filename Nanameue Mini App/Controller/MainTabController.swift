//
//  MainTabController.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-11.
//

import Foundation
import UIKit
import FirebaseAuth


class MainTabController: UITabBarController {
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        checkCurrentUser()
    }
    
    // MARK: - Helper functions
    
    func checkCurrentUser() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            checkCurrentUser()
        } catch {
            print ("Error - sign out ")
        }
        
    }
    
    
    func configureViewController() {
        view.backgroundColor = .white
        
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        let feed = initNavigationController(unselectedImage: UIImage(imageLiteralResourceName: "feed_unselected"), selectedImage: UIImage(imageLiteralResourceName: "feed_selected"), viewController: MainFeedController(collectionViewLayout: collectionViewLayout))
        
        let search = initNavigationController(unselectedImage: UIImage(imageLiteralResourceName: "search_unselected"), selectedImage: UIImage(imageLiteralResourceName: "search_selected"), viewController: SearchController())
        
        let postMaker = initNavigationController(unselectedImage: UIImage(imageLiteralResourceName: "post_maker_unselected"), selectedImage: UIImage(imageLiteralResourceName: "post_maker_selected"), viewController: PostMakerController())
        
        let notification = initNavigationController(unselectedImage: UIImage(imageLiteralResourceName: "notification_unselected"), selectedImage: UIImage(imageLiteralResourceName: "notification_selected"), viewController: NotificationController())
        
        let layout = UICollectionViewFlowLayout()
        let profile = initNavigationController(unselectedImage: UIImage(imageLiteralResourceName: "profile_unselected"), selectedImage: UIImage(imageLiteralResourceName: "profile_selected"), viewController: ProfileController(collectionViewLayout: layout))
        
        viewControllers = [feed, search, postMaker, notification, profile]
        tabBar.tintColor = .black
        tabBar.isTranslucent = false
    }
    
    func initNavigationController(unselectedImage: UIImage, selectedImage: UIImage, viewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
}

extension MainTabController: AuthenticationDelegate {
    func authenticationCompleted() {
        self.dismiss(animated: true)
    }
}
