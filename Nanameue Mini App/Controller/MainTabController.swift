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
            configureTabViewController(model: model)
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
        ProfileService.fetchUserData { userData, status in
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
    
    
    func configureTabViewController(model: UserModel) {
        self.delegate = self
        view.backgroundColor = .white
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        let feed = initNavigationController(unselectedImage: UIImage(imageLiteralResourceName: "feed_unselected"), selectedImage: UIImage(imageLiteralResourceName: "feed_selected"), viewController: MainFeedController(collectionViewLayout: collectionViewLayout))
        
        let postMaker = initNavigationController(unselectedImage: UIImage(imageLiteralResourceName: "post_maker_unselected"), selectedImage: UIImage(imageLiteralResourceName: "post_maker_selected"), viewController: PostMakerController())
        
        let profileController = ProfileController(model: model)
        let profile = initNavigationController(unselectedImage: UIImage(imageLiteralResourceName: "profile_unselected"), selectedImage: UIImage(imageLiteralResourceName: "profile_selected"), viewController: profileController)
        
        viewControllers = [feed, postMaker, profile]
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
        showLoading(false, showText: false)
        self.dismiss(animated: true)
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let selectedTabIndex = viewControllers?.firstIndex(of: viewController)
        
        if selectedTabIndex == 1 {
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
        showLoading(false, showText: false)
        
        //Refreshing the feed/timeline after posting new post
        guard let navigationController = viewControllers?.first as? UINavigationController else {return}
        guard let feedNavigationController = navigationController.viewControllers.first as? MainFeedController else {return}
        feedNavigationController.refreshFeed()
    }
}
