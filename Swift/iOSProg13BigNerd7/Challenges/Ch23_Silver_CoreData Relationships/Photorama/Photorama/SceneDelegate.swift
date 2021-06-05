//
//  SceneDelegate.swift
//  Photorama
//
//  Created by Chao Mei on 24/4/21.
//
// Siver Challenge
// “Have the collection view always display four items per row, taking up as much of the screen width as possible. This should work in both portrait and landscape orientations. Consider making adjustments to the flow layout in the viewDidLayoutSubviews() method.”
//Excerpt From: Aaron Hillegass. “iOS Programming: The Big Nerd Ranch Guide, 7th Edition.” Apple Books.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let tabBarController = window!.rootViewController as! UITabBarController
        let firstViewController = tabBarController.viewControllers?[0] as? UINavigationController
        let photosViewController = firstViewController?.topViewController as? PhotosViewController
        photosViewController?.store = PhotoStore()
        let secondViewController = tabBarController.viewControllers?[1] as? UINavigationController
        let favoritePhotosViewController = secondViewController?.topViewController as? FavoritePhotosViewController
        favoritePhotosViewController?.store = photosViewController?.store // favoritePhotoViewController uses the same photo store to avoid multiple entitiy description registration with the same persistent container
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}
