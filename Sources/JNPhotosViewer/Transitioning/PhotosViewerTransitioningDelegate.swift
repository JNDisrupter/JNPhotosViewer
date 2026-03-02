//
//  PhotosViewerTransitioningDelegate.swift
//  JNPhotosViewer
//
//  Created by JN Disrupter on 8/29/18.
//  Copyright © 2018 JN Disrupter. All rights reserved.
//

import UIKit

/// Photos Viewer Transitioning Delegate
public class PhotosViewerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    /// Presentation Transition
    private var presentationTransition: PhotosViewerPresentationAnimatedTransitioning?

    /// Dismissal Transition
    private var dismissalTransition: PhotosViewerDismissalAnimatedTransitioning?
    
    /// Dismissal Interactor
    private var dismissalInteractor: PhotosViewerDismissalInteractorTransitioning?
    
    /// Dismiss Interactively
    public var forcesNonInteractiveDismissal = false
    
    /**
     Setup
     - Parameter startingImageView: Starting image view to start animation from it
     - Parameter endingImageView: Ending image view to end animating to it.
     */
    public func setupPresentation(startingImageView: UIImageView? = nil) {
        if let startingImageView = startingImageView {
            self.presentationTransition = PhotosViewerPresentationAnimatedTransitioning(startingImageView: startingImageView)
        }
    }
    
    /**
     Setup
     - Parameter startingImageView: Starting image view to start animation from it
     - Parameter endingImageView: Ending image view to end animating to it.
     */
    public func setupDismissal(startingImageView: UIImageView? = nil, endingImageView: UIImageView? = nil) {
        
        // Cancel presentation transition
        self.presentationTransition?.cancel()
        
        // Hide new ending view
        if let endingImageView = endingImageView, endingImageView.superview != nil {
            endingImageView.isHidden = true
            self.presentationTransition?.setStartingImageView(startingImageView: endingImageView)
        }
        
        if let startingImageView = startingImageView , startingImageView.superview != nil , endingImageView != nil {
            if self.dismissalTransition == nil {
                self.dismissalTransition = PhotosViewerDismissalAnimatedTransitioning(startingImageView: startingImageView, endingImageView: endingImageView)
                self.dismissalInteractor = PhotosViewerDismissalInteractorTransitioning(transition: self.dismissalTransition!)
            } else {
                self.dismissalTransition?.setupDismissal(startingImageView: startingImageView, endingImageView: endingImageView)
            }
        }
    }
    
    /**
     Did pan with gesture recognizer
     - Parameter panGestureRecognizer: Pan gesture recognizer
     - Parameter viewToPan: View to pan
     */
    public func didPanWithPanGestureRecognizer(panGestureRecognizer: UIPanGestureRecognizer, viewToPan: UIView) {
        let translation = panGestureRecognizer.translation(in: viewToPan)
        let velocity = panGestureRecognizer.velocity(in: viewToPan)
        
        switch panGestureRecognizer.state {
        case .changed:
            let percentage = abs(translation.y) / viewToPan.bounds.height
            var rationPercentage = abs(1 - percentage)
            
            if rationPercentage < 0.4 {
                rationPercentage = 0.4
            }
            
            self.dismissalInteractor?.update(transform: CGAffineTransform(translationX: translation.x * rationPercentage, y: translation.y * rationPercentage), percentage: percentage)
        case .ended, .cancelled:
            self.forcesNonInteractiveDismissal = false
            let percentage = abs(translation.y + velocity.y) / viewToPan.bounds.height
            if percentage > 0.35 {
                self.dismissalInteractor?.finish()
            } else {
                self.dismissalInteractor?.cancel()
            }
        default: break
        }
    }

    /// MARK: - UIViewControllerTransitioningDelegate
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.presentationTransition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.dismissalTransition
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.forcesNonInteractiveDismissal ? self.dismissalInteractor : nil
    }
}
