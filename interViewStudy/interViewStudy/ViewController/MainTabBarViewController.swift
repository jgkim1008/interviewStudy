//
//  MainTabBarViewController.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/28.
//

import UIKit

final class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initTabBar()
        
    }
    
    private func initTabBar() {
        tabBar.backgroundColor = .black
        tabBar.barTintColor = UIColor.black
        tabBar.tintColor = UIColor.systemBlue
        tabBar.unselectedItemTintColor = UIColor.systemGray

        let mainViewController = MainViewController()
        let searchController = SearchViewController()
        
        let firstViewController = UINavigationController(rootViewController: mainViewController)
        firstViewController.view.backgroundColor = .black
        firstViewController.navigationBar.backgroundColor = .black
        firstViewController.tabBarItem.image = UIImage(systemName: "house")
        firstViewController.tabBarItem.title = "홈" // TabBar Item 의 이름

        let secondViewController = UINavigationController(rootViewController: searchController)
        secondViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        secondViewController.tabBarItem.title = "검색"

        tabBar.isHidden = false
        tabBar.backgroundColor = .black
        setViewControllers([firstViewController, secondViewController], animated: true)
    }

}
