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
  func createBlur(_ effectStyle: UIBlurEffectStyle = .light) {
    print("UIViewController.createBlur")
    
    if !UIAccessibilityIsReduceTransparencyEnabled() {
      view.backgroundColor = UIColor.clear
      
      let blurView = UIVisualEffectView(effect: UIBlurEffect(style: effectStyle))
      blurView.autoresizingMask = [UIViewAutoresizing.flexibleHeight , UIViewAutoresizing.flexibleWidth]
      blurView.frame = view.bounds
      
      view.insertSubview(blurView, at: 0)
    }
  }
}

extension UITableViewController {
  override func createBlur(_ effectStyle: UIBlurEffectStyle = UIBlurEffectStyle.light) {
    print("UITableViewController.createBlur")
    
    if !UIAccessibilityIsReduceTransparencyEnabled() {
      tableView.backgroundColor = UIColor.clear
      
      let blurEffect = UIBlurEffect(style: effectStyle)
      tableView.backgroundView = UIVisualEffectView(effect: blurEffect)
      tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
    }
  }
}

class ToothTimerViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIPopoverPresentationControllerDelegate
{
                 var pageViewController       : UIPageViewController?
                 var timerViewController      : TimerViewController?
                 var badgeViewController      : BadgeCollectionViewController?
                 let transition               = PuffAnimator()
  @IBOutlet weak var gradientView             : GradientView!
  @IBOutlet weak var settingsButton           : UIBarButtonItem!
  @IBOutlet weak var startButton              : UIBarButtonItem!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    self.pageViewController!.delegate = self
    
    self.timerViewController      = self.storyboard!.instantiateViewController(withIdentifier: "TimerViewController") as? TimerViewController
    //self.badgeViewController = self.storyboard!.instantiateViewControllerWithIdentifier("BadgeTableViewController") as? BadgeTableViewController
    self.badgeViewController = self.storyboard!.instantiateViewController(withIdentifier: "BadgeCollectionViewController") as? BadgeCollectionViewController
    
    self.timerViewController!.addObserver(self, forKeyPath: "isTimerRunning", options: .new, context: &kvoToothTimerViewControllerContext)
    
    let ei =  UIEdgeInsetsMake(64, 0, 0, 0)
//    self.badgeViewController?.tableView.contentInset          = ei
//    self.badgeViewController?.tableView.scrollIndicatorInsets = ei
    self.badgeViewController?.collectionView!.contentInset          = ei
    self.badgeViewController?.collectionView!.scrollIndicatorInsets = ei
    
    
    let viewControllers = [timerViewController!]
    self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
    
    self.pageViewController!.dataSource = self
    
    self.addChildViewController(self.pageViewController!)
    self.view.addSubview(self.pageViewController!.view)
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    var pageViewRect = self.view.bounds
    if UIDevice.current.userInterfaceIdiom == .pad {
      pageViewRect = pageViewRect.insetBy(dx: 40.0, dy: 40.0)
    }
    self.pageViewController!.view.frame = pageViewRect
    
    self.pageViewController!.didMove(toParentViewController: self)
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
  }
  
  deinit {
    self.timerViewController!.removeObserver(self, forKeyPath: "isTimerRunning", context: &kvoToothTimerViewControllerContext)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if context == &kvoToothTimerViewControllerContext && keyPath == "isTimerRunning"
    {
      if let newValue = change?[NSKeyValueChangeKey.newKey] as? Bool
      { print("isTimerRunning changed: \(newValue)")
        
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
    { super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    } /* of else */
  }
  
  override var prefersStatusBarHidden : Bool {
    var result = false
    
    if let tvc = self.timerViewController
    { if tvc.isTimerRunning { result = true } }
    
    return result
  }
  

  // MARK: UIPageViewController delegate methods
  
  func pageViewController(_ pageViewController                              : UIPageViewController,
                          spineLocationFor orientation: UIInterfaceOrientation
                         ) -> UIPageViewControllerSpineLocation {
    if (orientation == .portrait) || (orientation == .portraitUpsideDown) || (UIDevice.current.userInterfaceIdiom == .phone)
    { let currentViewController = self.pageViewController!.viewControllers![0]
      let viewControllers = [currentViewController]
     
      self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion:nil)
      self.pageViewController!.isDoubleSided = false
      
      return .min
    } /* of if */
    
    let viewControllers = [timerViewController!,badgeViewController!] as [Any]
    
    self.pageViewController!.setViewControllers(viewControllers as! [UIViewController], direction: .forward, animated: true, completion: nil)
    
    return .mid
  }
  
  // MARK: Page View Controller Data Source
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    print("pageViewController.before")
    
    var result:UIViewController? = nil
    
    if viewController==self.badgeViewController
    { result = self.timerViewController }
    
    return result
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    print("pageViewController.after")
    
    var result:UIViewController? = nil
    
    if viewController==self.timerViewController
    { result = self.badgeViewController }
    
    return result
  }

  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return 2
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    let currentViewController = self.pageViewController!.viewControllers![0]
    var result = 0
    
    switch currentViewController
    {
    case self.badgeViewController!:
      result = 1
    default:
      result = 0
    }
    
    return result
  }

  // MARK: Actions
  
  @IBAction func timerAction(_ sender: UIBarButtonItem) {
    if let isRunning = self.timerViewController?.isTimerRunning
    { if !isRunning
    { self.timerViewController?.startTimer() }
    else
    { self.timerViewController?.stopTimer() }
    } /* of if */
  }
  
  @IBAction func settingsAction(_ sender: UIBarButtonItem?) {
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController")
    
    vc?.modalPresentationStyle                                  = UIModalPresentationStyle.popover
    vc?.popoverPresentationController?.barButtonItem            = self.settingsButton
    vc?.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
    vc?.popoverPresentationController?.delegate                 = self
    vc?.popoverPresentationController?.backgroundColor          = UIColor.clear
    
    self.present(vc!, animated: true, completion: nil)
  }
  
  @IBAction func showLogsAction(_ sender: UIBarButtonItem?) {
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogsViewController")
    
    vc?.transitioningDelegate = self
    self.present(vc!, animated: true, completion: nil)
    
    /*
    vc?.modalPresentationStyle                                  = UIModalPresentationStyle.Popover
    vc?.popoverPresentationController?.barButtonItem            = self.startButton
    vc?.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Any
    vc?.popoverPresentationController?.delegate                 = self
    vc?.popoverPresentationController?.backgroundColor          = UIColor.clearColor()
    
    self.presentViewController(vc!, animated: true, completion: nil)
    */
  }
  
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return UIModalPresentationStyle.none
  }
  
  func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
    print("presentationController()")
    
    return nil
  }

}

extension ToothTimerViewController: UIViewControllerTransitioningDelegate {
  
  func animationController(forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      
    transition.originFrame = CGRect(x: 20, y: 60, width: 40, height: 40)
    transition.presenting  = true
    
    return transition
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.presenting = false
    
    return transition
  }
}
