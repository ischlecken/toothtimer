//
//  ToothTimerViewController.swift
//  ToothTimer
//
//  Created by Feldmaus on 18.07.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import UIKit

class ToothTimerViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource
{
  var pageViewController  : UIPageViewController?
  var timerViewController : TimerViewController?
  var logViewController   : LogViewController?
  
  @IBOutlet weak var settingsButton: UIBarButtonItem!
  @IBOutlet weak var startButton   : UIBarButtonItem!
  
  @IBAction func timerAction(sender: UIBarButtonItem)
  { self.timerViewController?.toggleTimer()
  }
  
  @IBAction func settingsAction(sender: UIBarButtonItem?)
  { NSLog("settingsAction")
  }
  
  
  override func viewDidLoad()
  { super.viewDidLoad()
  
    self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    self.pageViewController!.delegate = self
    
    self.timerViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TimerViewController") as? TimerViewController
    self.logViewController   = self.storyboard!.instantiateViewControllerWithIdentifier("LogViewController") as? LogViewController
    
    let viewControllers = [timerViewController!]
    self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
    
    self.pageViewController!.dataSource = self
    
    self.addChildViewController(self.pageViewController!)
    self.view.addSubview(self.pageViewController!.view)
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    var pageViewRect = self.view.bounds
    if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
      pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0)
    }
    self.pageViewController!.view.frame = pageViewRect
    
    self.pageViewController!.didMoveToParentViewController(self)
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
  }
  
  // MARK: - UIPageViewController delegate methods
  
  func pageViewController(pageViewController                              : UIPageViewController,
                          spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation
                         ) -> UIPageViewControllerSpineLocation
  {
    if (orientation == .Portrait) || (orientation == .PortraitUpsideDown) || (UIDevice.currentDevice().userInterfaceIdiom == .Phone)
    { let currentViewController = self.pageViewController!.viewControllers![0]
      let viewControllers = [currentViewController]
     
      self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion:nil)
      self.pageViewController!.doubleSided = false
      
      return .Min
    } /* of if */
    
    let viewControllers = [timerViewController!,logViewController!]
    
    self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
    
    return .Mid
  }
  
  // MARK: - Page View Controller Data Source
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
  { NSLog("pageViewController.before")
    
    var result:UIViewController? = nil
    
    if viewController==self.logViewController
    { result = self.timerViewController }
    
    return result
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
  { NSLog("pageViewController.after")
    
    var result:UIViewController? = nil
    
    if viewController==self.timerViewController
    { result = self.logViewController }
    
    return result
  }

  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
  { return 2 }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
  {
    let currentViewController = self.pageViewController!.viewControllers![0]
    
    return currentViewController==timerViewController ? 0 : 1
  }

}

