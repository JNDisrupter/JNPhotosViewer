//
//  PhotosViewerDismissalAnimatedTransitioning.swift
//  JNPhotosViewer
//
//  Created by JN Disrupter on 8/29/18.
//  Copyright © 2018 JN Disrupter. All rights reserved.
//

import UIKit

/// Photos Viewer Dismissal Animated Transitioning
class PhotosViewerDismissalAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// Transition Context
    fileprivate weak var transitionContext: UIViewControllerContextTransitioning?
    
    /// Starting Image View
    fileprivate var startingImageView: UIImageView
    
    /// Ending image view
    fileprivate var endingImageView: UIImageView?
    
    /// Scalable Image view
    fileprivate var scalableImageview = JNScalableImageView()
    
    /// From View
    fileprivate var fromView: UIView?
    
    /// Overlay view
    fileprivate let overlayView = UIView()

    /**
     Initilizer
     - Parameter startingImageView: Starting image view
     - Parameter endingImageView: Ending image view
     */
    init(startingImageView: UIImageView, endingImageView: UIImageView?) {
        self.startingImageView = startingImageView
        self.endingImageView = endingImageView
        super.init()
    }
    
    /**
     Setup
     - Parameter startingImageView: Starting image view
     - Parameter endingImageView: Ending image view
     */
    func setupDismissal(startingImageView: UIImageView, endingImageView: UIImageView?) {
        self.startingImageView = startingImageView
        self.endingImageView = endingImageView
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.start(transitionContext)
        self.finish()
    }
    
    func start(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        self.fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let containerView = transitionContext.containerView
        let fromSuperView = self.startingImageView.superview
        
        self.scalableImageview.image = self.startingImageView.image
        self.scalableImageview.frame = (fromSuperView?.convert(self.startingImageView.frame, to: nil) ?? self.startingImageView.frame)
        self.scalableImageview.contentMode = .scaleAspectFit
        
        self.fromView?.isHidden = true
        self.overlayView.frame = containerView.bounds
        self.overlayView.backgroundColor = .black
        
        containerView.addSubview(self.overlayView)
        containerView.addSubview(self.scalableImageview)
    }
    
    func cancel() {
        self.transitionContext?.cancelInteractiveTransition()
        UIView.animate(withDuration: self.transitionDuration(using: self.transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            self.scalableImageview.contentMode = .scaleAspectFit
            self.scalableImageview.transform = .identity
            self.scalableImageview.frame = self.startingImageView.frame
            self.overlayView.alpha = 1.0
        }, completion: { _ in
            self.fromView?.isHidden = false
            self.scalableImageview.removeFromSuperview()
            self.transitionContext?.completeTransition(false)
            self.overlayView.removeFromSuperview()
        })
    }
    
    func finish() {
        let duration = self.transitionDuration(using: self.transitionContext)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.overlayView.alpha = 0.0
            if let endingImageView = self.endingImageView, let superView = endingImageView.superview {
                self.scalableImageview.contentMode = endingImageView.contentMode
                self.scalableImageview.transform = .identity
                self.scalableImageview.frame = superView.convert(endingImageView.frame, to: nil)
            } else {
                self.scalableImageview.alpha = 0.0
            }
        }, completion: { _ in
            self.endingImageView?.isHidden = false
            self.overlayView.removeFromSuperview()
            self.scalableImageview.removeFromSuperview()
            self.fromView?.removeFromSuperview()
            self.transitionContext?.completeTransition(true)
        })
    }
}

/// Photos Viewer Dismissal Interactor Transitioning
class PhotosViewerDismissalInteractorTransitioning: NSObject, UIViewControllerInteractiveTransitioning {
    
    /// Dismissal transition
    private let transition: PhotosViewerDismissalAnimatedTransitioning
    
    /**
     Init with transition
     */
    init(transition: PhotosViewerDismissalAnimatedTransitioning) {
        self.transition = transition
        super.init()
    }
    
    /**
     Start interactive transition
     */
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transition.start(transitionContext)
    }
    
    /**
     Cancel
     */
    func cancel() {
        self.transition.cancel()
    }
    
    /**
     Finish
     */
    func finish() {
        self.transition.finish()
    }
    
    /**
     Update transition interactor
     - Parameter transform: CGAffineTransform to apply to the image
     - Parameter percentage: Paning percentage
     */
    func update(transform: CGAffineTransform, percentage: CGFloat) {
        let maximumPercentage = self.transition.endingImageView != nil ? ((self.transition.endingImageView?.frame.size.width)! / self.transition.startingImageView.frame.size.width): 1.0
        let translationTransform = transform
        var invertedPercentage = 1.0 - percentage
        self.transition.overlayView.alpha = invertedPercentage
        if invertedPercentage <= maximumPercentage {
            invertedPercentage = maximumPercentage
        }
        let scaleTransform = CGAffineTransform(scaleX: invertedPercentage, y: invertedPercentage)
        self.transition.scalableImageview.transform = scaleTransform.concatenating(translationTransform)
    }
}
