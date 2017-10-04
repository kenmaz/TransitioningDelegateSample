//
//  ViewController.swift
//  TransitioningDelegateSample
//
//  Created by Kentaro Matsumae on 2017/10/04.
//  Copyright © 2017年 DeNA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let myTransitionDelegate = MyTransitionDelegate()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dstVC = segue.destination
        dstVC.modalPresentationStyle = .custom
        dstVC.transitioningDelegate = myTransitionDelegate
    }

}

class MyTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    let interactor = MJMagazineInteractor()
    var panStartPos = CGPoint.zero
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interactor.hasStarted {
            return interactor
        } else {
            return nil
        }
    }
    
    func sourceViewDidPan(recognizer: UIPanGestureRecognizer, sourceVC: UIViewController) {
        let pos = recognizer.translation(in: sourceVC.view)
        let velocity = recognizer.velocity(in: sourceVC.view)
        
        switch recognizer.state {
        case .began:
            panStartPos = pos
            interactor.hasStarted = true
            sourceVC.dismiss(animated: true, completion: nil)
            
        case .changed:
            let w = sourceVC.view.frame.size.width
            let progress = (panStartPos.x - pos.x) / w
            let highVelocity = velocity.x < -500
            interactor.shouldFinish = (progress >= 0.5 || highVelocity)
            interactor.update(progress)
            
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
            
        case .ended:
            interactor.hasStarted = false
            if interactor.shouldFinish {
                interactor.finish()
            } else {
                interactor.cancel()
            }
        case .failed, .possible:
            print(#function)
            break
        }
    }
}

class MJMagazineInteractor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}

class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let drawerVC = transitionContext.viewController(forKey: .from) else {
                assertionFailure()
                return
        }
        
        let container = transitionContext.containerView
        container.backgroundColor = UIColor.black
        
        UIView.animate (
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveLinear,
            animations: {
                var frame = container.frame
                frame.origin.x = -1 * frame.size.width
                drawerVC.view.frame = frame
                container.backgroundColor = UIColor.clear
                
        }) { (res) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
