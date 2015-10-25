//
//  PuffAnimator.swift
//  ToothTimer
//
//  Created by Feldmaus on 25.10.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation


class PuffAnimator : NSObject, UIViewControllerAnimatedTransitioning {
  
  let duration    = 3.0
  var presenting  = true
  var originFrame = CGRect.zero
  
  var dismissCompletion: (()->())?
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return duration
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    let containerView = transitionContext.containerView()!
    containerView.backgroundColor = UIColor.clearColor()
    
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
    
    let herbView = presenting ? toView : fromView
    
    let initialFrame = presenting ? originFrame : herbView.frame
    let finalFrame = presenting ? herbView.frame : originFrame
    
    let xScaleFactor = presenting ?
      initialFrame.width / finalFrame.width :
      finalFrame.width / initialFrame.width
    
    let yScaleFactor = presenting ?
      initialFrame.height / finalFrame.height :
      finalFrame.height / initialFrame.height
    
    let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
    
    if presenting {
      herbView.transform = scaleTransform
      herbView.center = CGPoint(
        x: CGRectGetMidX(initialFrame),
        y: CGRectGetMidY(initialFrame))
      herbView.clipsToBounds = true
    }
    
    containerView.addSubview(toView)
    containerView.bringSubviewToFront(herbView)
    
    UIView.animateWithDuration(duration, delay:0.0,
      usingSpringWithDamping: 0.4,
      initialSpringVelocity: 0.0,
      options: [],
      animations: {
        
        herbView.transform = self.presenting ? CGAffineTransformIdentity : scaleTransform
        herbView.center = CGPoint(x: CGRectGetMidX(finalFrame), y: CGRectGetMidY(finalFrame))
        
      }, completion:{_ in
        
        if !self.presenting {
          self.dismissCompletion?()
        }
        transitionContext.completeTransition(true)
        
        if self.presenting {
          containerView.addSubview(fromView)
          containerView.bringSubviewToFront(toView)
        }
    })
    
    
  }

}