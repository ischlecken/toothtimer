//
//  ToothTimerViewController.swift
//  ToothTimer
//
//  Created by Feldmaus on 18.07.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import UIKit

private var kvoToothTimerViewControllerContext = 0

extension UIViewController {
  func createBlur(effectStyle: UIBlurEffectStyle = .Light) {
    NSLog("UIViewController.createBlur")
    
    if !UIAccessibilityIsReduceTransparencyEnabled() {
      view.backgroundColor = UIColor.clearColor()
      
      let blurView = UIVisualEffectView(effect: UIBlurEffect(style: effectStyle))
      blurView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight , UIViewAutoresizing.FlexibleWidth]
      blurView.frame = view.bounds
      
      view.insertSubview(blurView, atIndex: 0)
    }
  }
}

extension UITableViewController {
  override func createBlur(effectStyle: UIBlurEffectStyle = UIBlurEffectStyle.Light) {
    NSLog("UITableViewController.createBlur")
    
    if !UIAccessibilityIsReduceTransparencyEnabled() {
      tableView.backgroundColor = UIColor.clearColor()
      
      let blurEffect = UIBlurEffect(style: effectStyle)
      tableView.backgroundView = UIVisualEffectView(effect: blurEffect)
      tableView.separatorEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
    }
  }
}

class ToothTimerViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIPopoverPresentationControllerDelegate
{
                 var pageViewController       : UIPageViewController?
                 var timerViewController      : TimerViewController?
                 var badgeTableViewController : BadgeTableViewController?
  @IBOutlet weak var gradientView             : GradientView!
  @IBOutlet weak var settingsButton           : UIBarButtonItem!
  @IBOutlet weak var startButton              : UIBarButtonItem!
  
  override func prefersStatusBarHidden() -> Bool
  { var result = false
    
    if let tvc = self.timerViewController
    { if tvc.isTimerRunning { result = true } }
    
    return result
  }
  
  @IBAction func timerAction(sender: UIBarButtonItem)
  {
    if let isRunning = self.timerViewController?.isTimerRunning
    { if !isRunning
      { self.timerViewController?.startTimer() }
      else
      { self.timerViewController?.stopTimer() }
    } /* of if */
  }
  
  @IBAction func settingsAction(sender: UIBarButtonItem?)
  { NSLog("settingsAction")
    
    let vc:UIViewController? = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsViewController")
    
    vc?.modalPresentationStyle                                  = UIModalPresentationStyle.Popover
    vc?.popoverPresentationController?.barButtonItem            = self.settingsButton
    vc?.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Any
    vc?.popoverPresentationController?.delegate                 = self
    vc?.popoverPresentationController?.backgroundColor          = UIColor.clearColor()
    
    self.presentViewController(vc!, animated: true, completion: nil)
  }
  
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    NSLog("adaptivePresentationStyleForPresentationController()")
    
    return UIModalPresentationStyle.None
  }
  
  func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
    NSLog("presentationController()")
    
    return nil
  }
  
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
  {
    if context == &kvoToothTimerViewControllerContext && keyPath == "isTimerRunning"
    {
      if let newValue = change?[NSKeyValueChangeNewKey] as? Bool
      { NSLog("isTimerRunning changed: \(newValue)")
        
        if newValue
        { AudioUtil.playSound("start")
          AudioUtil.vibrate()
          
          self.gradientView.dimGradient()
          self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        else
        { AudioUtil.playSound("stop")
          AudioUtil.vibrate()
          
          self.gradientView.resetGradient()
          self.navigationController?.setNavigationBarHidden(false, animated: true)
          
          BadgeAllocator.allocateBadge()
        }
      } /* of if */
    } /* of if */
    else
    { super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    } /* of else */
  }
  
  deinit {
    self.timerViewController!.removeObserver(self, forKeyPath: "isTimerRunning", context: &kvoToothTimerViewControllerContext)
  }
  
  override func viewDidLoad()
  { super.viewDidLoad()
  
    self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    self.pageViewController!.delegate = self
    
    self.timerViewController      = self.storyboard!.instantiateViewControllerWithIdentifier("TimerViewController") as? TimerViewController
    self.badgeTableViewController = self.storyboard!.instantiateViewControllerWithIdentifier("BadgeTableViewController") as? BadgeTableViewController
    
    self.timerViewController!.addObserver(self, forKeyPath: "isTimerRunning", options: .New, context: &kvoToothTimerViewControllerContext)
    
    let ei =  UIEdgeInsetsMake(64, 0, 0, 0)
    self.badgeTableViewController?.tableView.contentInset          = ei
    self.badgeTableViewController?.tableView.scrollIndicatorInsets = ei
    
    
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
                         ) -> UIPageViewControllerSpineLocation {
    if (orientation == .Portrait) || (orientation == .PortraitUpsideDown) || (UIDevice.currentDevice().userInterfaceIdiom == .Phone)
    { let currentViewController = self.pageViewController!.viewControllers![0]
      let viewControllers = [currentViewController]
     
      self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion:nil)
      self.pageViewController!.doubleSided = false
      
      return .Min
    } /* of if */
    
    let viewControllers = [timerViewController!,badgeTableViewController!]
    
    self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
    
    return .Mid
  }
  
  // MARK: - Page View Controller Data Source
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
  { NSLog("pageViewController.before")
    
    var result:UIViewController? = nil
    
    if viewController==self.badgeTableViewController
    { result = self.timerViewController }
    
    return result
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
  { NSLog("pageViewController.after")
    
    var result:UIViewController? = nil
    
    if viewController==self.timerViewController
    { result = self.badgeTableViewController }
    
    return result
  }

  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
  { return 2 }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
  {
    let currentViewController = self.pageViewController!.viewControllers![0]
    var result = 0
    
    switch currentViewController
    {
    case self.badgeTableViewController!:
      result = 1
    default:
      result = 0
    }
    
    return result
  }

}

