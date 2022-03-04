//
//  AppDelegate.swift
//  Reciptopia
//
//  Created by 김세영 on 2022/02/21.
//

import UIKit
import Reciptopia_iOS
import ReciptopiaKit
import Reciptopia_UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  let dependencyContainer = ReciptopiaDependencyContainer()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    IngredientEntityValueTransformer.registerTransformer()
    window = UIWindow(frame: UIScreen.main.bounds)
    
    let pictureIngredientViewController = dependencyContainer.makePictureIngredientViewController()
    window?.makeKeyAndVisible()
    window?.rootViewController = UINavigationController(rootViewController: pictureIngredientViewController)
    
    
    return true
  }
}

