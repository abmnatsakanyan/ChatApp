//
//  SceneDelegate.swift
//  ChatApp
//
//  Created by Albert Mnatsakanyan on 10/14/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        let chatVC = ChatConfigurator.configure()
        let nc = UINavigationController(rootViewController: chatVC)

        window.rootViewController = nc
        window.makeKeyAndVisible()
        
        self.window = window
    }
}
