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
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    let containerView = transitionContext.containerView
    containerView.backgroundColor = UIColor.clear
    
    let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
    let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
    
    let herbView = presenting ? toView : fromView
    
    let initialFrame = presenting ? originFrame : herbView.frame
    let finalFrame = presenting ? herbView.frame : originFrame
    
    let xScaleFactor = presenting ?
      initialFrame.width / finalFrame.width :
      finalFrame.width / initialFrame.width
    
    let yScaleFactor = presenting ?
      initialFrame.height / finalFrame.height :
      finalFrame.height / initialFrame.height
    
    let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
    
    if presenting {
      herbView.transform = scaleTransform
      herbView.center = CGPoint(
        x: initialFrame.midX,
        y: initialFrame.midY)
      herbView.clipsToBounds = true
    }
    
    containerView.addSubview(toView)
    containerView.bringSubview(toFront: herbView)
    
    UIView.animate(withDuration: duration, delay:0.0,
      usingSpringWithDamping: 0.4,
      initialSpringVelocity: 0.0,
      options: [],
      animations: {
        
        herbView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
        herbView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        
      }, completion:{_ in
        
        if !self.presenting {
          self.dismissCompletion?()
        }
        transitionContext.completeTransition(true)
        
        if self.presenting {
          containerView.addSubview(fromView)
          containerView.bringSubview(toFront: toView)
        }
    })
    
    
  }

}
