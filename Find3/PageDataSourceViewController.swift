//
//  PageDataSourceViewController.swift
//  Find3
//
//  Created by Susan Stevens on 5/16/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import UIKit
import SpriteKit

// Source: http://shrikar.com/ios-swift-tutorial-uipageviewcontroller-as-user-onboarding-tool/

class PageDataSourceViewController: UIViewController, UIPageViewControllerDataSource {
    
    private var pageController: UIPageViewController!
    
    private let pages = [
        "InstructionsPage0",
        "InstructionsPage1",
        "InstructionsPage2",
        "InstructionsPage3",
        "InstructionsPage4",
        "InstructionsPage5",
        "InstructionsPage6"]
    
    private let verticalOffset: CGFloat = 50.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPageViewController()
        setupPageControl()
        
    }

//MARK: - Page View Controller methods
    
    private func createPageViewController() {
        
        pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageViewController")
            as! UIPageViewController
        pageController.dataSource = self
        
        if pages.count > 0 {
            let firstController = getPageController(0)!
            
            pageController.setViewControllers([firstController],
                direction: UIPageViewControllerNavigationDirection.Forward,
                animated: false,
                completion: nil)
        }
        
        pageController.view.frame = CGRectMake(0, verticalOffset,
            self.view.frame.size.width,
            self.view.frame.size.height - verticalOffset)
        
        addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        pageController.didMoveToParentViewController(self)
    }
    
    private func setupPageControl() {
        
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.purpleColor()
        appearance.backgroundColor = UIColor.whiteColor()
        
    }

    private func getPageController(index: Int) -> UIViewController? {
        
        if index < pages.count {
            
            let viewController = self.storyboard!.instantiateViewControllerWithIdentifier(pages[index]) as! UIViewController
            
            if index >= 2 && index <= 5 {
                let exampleVC = viewController as! ExampleViewController
                exampleVC.page = index
            }
            
            return viewController
        }
        return nil
    }
    

//MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if let id = viewController.restorationIdentifier {
            if let index = find(pages, id) {
                if index > 0 {
                    return getPageController(index-1)
                }
            }
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let id = viewController.restorationIdentifier {
            if let index = find(pages, id) {
                if index + 1 < pages.count {
                    return getPageController(index+1)
                }
            }
        }
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
