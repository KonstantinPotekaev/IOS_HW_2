//
//  SceneDelegate.swift
//  kspotekaevPW2
//
//  Created by Константин Потекаев on 29.10.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Создаем rootViewController
        let rootViewController = WishMakerViewController()
        
        // Оборачиваем в UINavigationController
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        // Настраиваем окно
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}
