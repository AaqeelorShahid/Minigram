//
//  MainTabController.swift
//  Nanameue Mini App
//
//  Created by Shahid on 2023-02-11.
//

import Foundation
import UIKit
import FirebaseAuth
import YPImagePicker


class MainTabController: UITabBarController {
    // MARK: - Life cycle
    private var model: UserModel? {
        didSet {
            guard let model: UserModel else {return}
            configureViewController(model: model)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCurrentUser()
        fetchUserData()
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
    
    func fetchUserData() {
        ProfileService.fetchUserData { userData in
            self.model = userData
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
    
    
    func configureViewController(model: UserModel) {
        self.delegate = self
        view.backgroundColor = .white
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        let feed = initNavigationController(unselectedImage: UIImage(imageLiteralResourceName: "feed_unselected"), selectedImage: UIImage(imageLiteralResourceName: "feed_selected"), viewController: MainFeedController(collectionViewLayout: collectionViewLayout))
        
        let search = initNavigationController(unselectedImage: UIImage(imageLiteralResourceName: "search_unselected"), selectedImage: UIImage(imageLiteralResourceName: "search_selected"), viewController: SearchController())
        
        let postMaker = initNavigationController(unselectedImage: UIImage(imageLiteralResourceName: "post_maker_unselected"), selectedImage: UIImage(imageLiteralResourceName: "post_maker_selected"), viewController: PostMakerController())
        
        let notification = initNavigationController(unselectedImage: UIImage(imageLiteralResourceName: "notification_unselected"), selectedImage: UIImage(imageLiteralResourceName: "notification_selected"), viewController: NotificationController())
        
        let profileController = ProfileController(model: model)
        let profile = initNavigationController(unselectedImage: UIImage(imageLiteralResourceName: "profile_unselected"), selectedImage: UIImage(imageLiteralResourceName: "profile_selected"), viewController: profileController)
        
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

// MARK: - Authentication Delegate

extension MainTabController: AuthenticationDelegate {
    func authenticationCompleted() {
        fetchUserData()
        showLoading(false)
        self.dismiss(animated: true)
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let selectedTabIndex = viewControllers?.firstIndex(of: viewController)
        
        //TODO: - if removed the search and notification tab, please change the index of post maker below
        if selectedTabIndex == 2 {
            let controller = PostUploadController()
            controller.delegate = self
            controller.userModel = model
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true)
        }
        
        return true
    }
}

// MARK: - PostUploadDelegate

extension MainTabController: PostUploadProtocol {
    func controllerDidFinishTask(_ controller: PostUploadController) {
        selectedIndex = 0
        controller.dismiss(animated: true)
        showLoading(false)
    }
}
