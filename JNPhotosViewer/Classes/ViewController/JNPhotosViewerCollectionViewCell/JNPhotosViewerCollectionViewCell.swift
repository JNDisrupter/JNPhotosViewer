//
//  JNPhotosViewerCollectionViewCell.swift
//  JNPhotosViewer
//
//  Created by JN Disrupter on 8/29/18.
//  Copyright © 2018 JN Disrupter. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation

/// JNPhotos Viewer Collection View Cell
open class JNPhotosViewerCollectionViewCell: UICollectionViewCell , UIScrollViewDelegate {
    
    /// Image view
    @IBOutlet open weak var imageView: UIImageView!
    
    /// Scroll view
    @IBOutlet open weak var scrollView: UIScrollView!
    
    /**
     Awake from nib
     */
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        // Make image scrollable
        self.makeImageViewZoomable()
        
        // Set content mode
        self.imageView.contentMode = UIView.ContentMode.scaleAspectFit
    }
    
    /**
     Set up cell
     - parameter image : Image data which might be UIImage or Url String
     - parameter isZoomEnabled : Bool value to enable zoom on image view.
     */
    open func setup(photo: JNPhoto) {
        if let image = photo.image {
            self.imageView.image = image
            self.imageView.sd_imageIndicator = nil
        } else {
            
            // Change activity indicator style
            self.imageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            
            let mediaUrl = photo.imageUrl
            self.imageView.sd_setImage(with: URL(string: mediaUrl)) { (image, error, cacheType, url) in
                self.imageView.sd_imageIndicator = nil
                if error != nil {
                    self.imageView?.image = photo.placeholderImage
                }
            }
        }
    }
    
    /**
     Make image view zoomable
     */
    private func makeImageViewZoomable() {
        self.scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
        self.scrollView.alwaysBounceVertical = false
        self.scrollView.alwaysBounceHorizontal = false
        self.scrollView.bounces = false
        self.scrollView.backgroundColor = UIColor.clear
        self.scrollView.delegate = self
        self.scrollView.isUserInteractionEnabled = true
        self.scrollView.minimumZoomScale = 1
        self.scrollView.maximumZoomScale = 10.0
    }
    
    /**
     Init pan gesture
     */
    func initGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.numberOfTapsRequired = 2
        tapGestureRecognizer.addTarget(self, action: #selector(self.imageViewDoubleTapped))
        self.imageView.addGestureRecognizer(tapGestureRecognizer)
        self.imageView.isUserInteractionEnabled = true
    }
    
    @objc func imageViewDoubleTapped() {
        if self.scrollView.zoomScale > self.scrollView.minimumZoomScale {
            self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: true)
        } else {
            self.scrollView.setZoomScale(self.scrollView.maximumZoomScale, animated: true)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    /**
     View for zooming
     */
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    // MARK: - Class methods
    
    /**
     Get reuse identifier
     */
    open class func getReuseIdentifier() -> String {
        return "JNPhotosViewerCollectionViewCell"
    }
    
    /**
     Register cell
     */
    open class func registerCell(collectionView:UICollectionView) {
        collectionView.register(UINib(nibName: "JNPhotosViewerCollectionViewCell", bundle: Bundle.init(for: JNPhotosViewerCollectionViewCell.self)), forCellWithReuseIdentifier: JNPhotosViewerCollectionViewCell.getReuseIdentifier())
    }
}
