//
//  Tabbar.swift
//  SocialApp
//
//  Created by Mark bergeson on 1/10/21.
//

import UIKit

class Tabbar: UITabBarController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
         setupView()
        
    }
}

private extension Tabbar {
    func setupView() {
        view.backgroundColor = .white
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        if FeatureFlag.tabs.enabled() {
            let nav1 = UINavigationController(rootViewController: HomeController())
            let nav2 = UINavigationController(rootViewController: UIViewController())
            let nav3 = UINavigationController(rootViewController: UIViewController())
            let nav4 = UINavigationController(rootViewController: ProfileController())
            let nav5 = UINavigationController(rootViewController: UIViewController())
            self.viewControllers = [nav1, nav2, nav3, nav4, nav5]
        } else {
            let nav1 = UINavigationController(rootViewController: HomeController())
            let nav5 = UINavigationController(rootViewController: UIViewController())
            self.viewControllers = [nav1, nav5]
        }
        
        
        guard let items = tabBar.items else { return }
        
        if FeatureFlag.tabs.enabled() {
            if let item = items.first {
                item.title = "Home"
                item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
                item.image = UIImage(named: "􀎞")?.withRenderingMode(.alwaysOriginal)
                item.selectedImage = UIImage(named: "􀎟")?.withRenderingMode(.alwaysOriginal)
            }
            
            if items.count > 2 {
                items[1].title = "Saved"
                items[1].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
                items[1].image = UIImage(named: "bookmark un")?.withRenderingMode(.alwaysOriginal)
                items[1].selectedImage = UIImage(named: "bookmark sel")?.withRenderingMode(.alwaysOriginal)
            }
            
            if items.count > 3 {
                items[2].title = "Messages"
                items[2].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
                items[2].image = UIImage(named: "􀌤")?.withRenderingMode(.alwaysOriginal)
                items[2].selectedImage = UIImage(named: "􀌥")?.withRenderingMode(.alwaysOriginal)
            }
            
            if items.count > 4 {
                items[3].title = "Profile"
                items[3].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
                items[3].image = UIImage(named: "􀉭")?.withRenderingMode(.alwaysOriginal)
                items[3].selectedImage = UIImage(named: "􀉮")?.withRenderingMode(.alwaysOriginal)
            }
            
            if let item = items.last {
                item.title = "Alerts"
                item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
                item.image = UIImage(named: "􀋙")?.withRenderingMode(.alwaysOriginal)
                item.selectedImage = UIImage(named: "􀋚")?.withRenderingMode(.alwaysOriginal)
            }
        } else {
        
            if let item = items.first {
                item.title = "Home"
                item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
                item.image = UIImage(named: "􀎞")?.withRenderingMode(.alwaysOriginal)
                item.selectedImage = UIImage(named: "􀎟")?.withRenderingMode(.alwaysOriginal)
            }
    
            
            if let item = items.last {
                item.title = "Alerts"
                item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
                item.image = UIImage(named: "􀋙")?.withRenderingMode(.alwaysOriginal)
                item.selectedImage = UIImage(named: "􀋚")?.withRenderingMode(.alwaysOriginal)
            }
        
    }
    
}
}
