//
//  PhotosViewerPresentationAnimatedTransitioning.swift
//  JNPhotosViewer
//
//  Created by JN Disrupter on 8/29/18.
//  Copyright © 2018 JN Disrupter. All rights reserved.
//

import UIKit

/// Photos Viewer Presentation Animated Transitioning
class PhotosViewerPresentationAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// Starting image view
    private var startingImageView: UIImageView
    
    /**
     Initilizer with starting image view
     */
    init(startingImageView: UIImageView) {
        self.startingImageView = startingImageView
        
        super.init()
    }
    
    /**
     Set starting image view
     */
    func setStartingImageView(startingImageView: UIImageView) {
        self.startingImageView = startingImageView
    }
    
    /**
     Cancel transition
     */
    func cancel() {
        self.startingImageView.isHidden = false
    }
    
    /// MARK: - UIViewControllerAnimatedTransitioning
    
    /**
     Transition duration
     */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    /**
     Animate transition using transition context
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let fromParentView = self.startingImageView.superview!
        
        let imageView = JNScalableImageView()
        imageView.image = self.startingImageView.image
        imageView.frame = fromParentView.convert(self.startingImageView.frame, to: nil)
        imageView.contentMode = self.startingImageView.contentMode
        
        let overlayView = UIView(frame: containerView.bounds)
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.0
        
        toView.frame = containerView.bounds
        toView.isHidden = true
        self.startingImageView.isHidden = true
        
        containerView.addSubview(toView)
        containerView.addSubview(overlayView)
        containerView.addSubview(imageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,  animations: {
                        imageView.contentMode = .scaleAspectFit
                        imageView.frame = containerView.bounds
                        overlayView.alpha = 1.0
        }, completion: { _ in
            toView.isHidden = false
            overlayView.removeFromSuperview()
            imageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
