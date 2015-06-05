//
//  PageDataSourceViewController.swift
//  Find3
//
//  Created by Susan Stevens on 5/16/15.
//  Copyright (c) 2015 Susan Stevens. All rights reserved.
//

import UIKit
import SpriteKit

// Reference: http://shrikar.com/ios-swift-tutorial-uipageviewcontroller-as-user-onboarding-tool/

class PageDataSourceViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var groupsFoundLabel: UILabel!
    var groupsFound: Int = 0
    var scene: TutorialScene!
    var level: String!
    
    private var pageController: UIPageViewController!
    private let pages = ["InstructionsPage1", "InstructionsPage2", "InstructionsPage3"]
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPageViewController()
        setupPageControl()
        
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        scene = TutorialScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.tapThreeHandler = handleTapThree
        scene.grid = Grid(level: level, layer: scene.picturesLayer)
        
        skView.presentScene(scene)
        
        beginGame()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindToHomeSegue" || segue.identifier == "unwindToHomeFromButton" {
            println("remove scene from parent")
            
            scene.removeActionForKey("runTimer")
            scene.removeActionForKey("runRemovePicTimer")
            
            let gameLayer = scene.childNodeWithName("Game Layer")
            let pictureLayer = gameLayer?.childNodeWithName("Pictures Layer")
            
            for picture in scene.grid.allPictures {
                picture.removeFromParent()
            }
            
            pictureLayer?.removeFromParent()
            gameLayer?.removeFromParent()
            scene.removeFromParent()
            
        }
    }
    
//MARK: - Tutorial Scene methods
    
    // Set-up for beginning of tutorial
    func beginGame() {
        let pictures = scene.grid.pictures
        scene.addSpritesForPictures(pictures)
        
        groupsFoundLabel.text = "Groups Found: 0"
        groupsFound = 0
    }
    
    // Called when user taps three PicSprites
    func handleTapThree(group: PictureGroup) {
        self.view.userInteractionEnabled = false
        
        println(group.description)
        
        if group.isValidGroup() {
            println("valid group")
            updateGroupsFoundLabel()
            scene.animateValidGroupTutorial(group)
            self.view.userInteractionEnabled = true
        } else {
            println("invalid group")
            group.pictureA.wiggleAndDeselect()
            group.pictureB.wiggleAndDeselect()
            group.pictureC.wiggleAndDeselect()
            scene.selectedPics.removeAll()
            self.view.userInteractionEnabled = true
        }
    }
    
    // Increment groupsFoundLabel when valid group selected
    func updateGroupsFoundLabel() {
        groupsFound++
        groupsFoundLabel.text = "Groups Found: \(groupsFound)"
        if groupsFound == 2 {
            presentEndOfTutorialAlert()
        }
    }
    
    // Present alert after user has found 2 valid groups
    func presentEndOfTutorialAlert() {
        let alertController = UIAlertController(title: "Nice!", message: "You're ready to play. But watch out - the properties you see will change on every level!", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            println("OK pressed")
            self.performSegueWithIdentifier("unwindToHomeSegue", sender: self)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            println("presenting alert controller")
        }
    }
    
//MARK: - Page View Controller methods
    
    private func createPageViewController() {
        pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        pageController.dataSource = self
        
        if pages.count > 0 {
            let firstController = getPageController(0)!
            
            pageController.setViewControllers([firstController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 4)
        addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        pageController.didMoveToParentViewController(self)
        
        
        
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.darkGrayColor()
        appearance.currentPageIndicatorTintColor = UIColor.blackColor()
        appearance.backgroundColor = UIColor.whiteColor()
    }

    private func getPageController(index: Int) -> UIViewController? {
        if index < pages.count {
            let viewController = self.storyboard!.instantiateViewControllerWithIdentifier(pages[index]) as! UIViewController
            return viewController
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
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
