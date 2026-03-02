//
//  JNScalableImageView.swift
//  JNPhotosViewer
//
//  Created by JN Disrupter on 8/29/18.
//  Copyright © 2018 JN Disrupter. All rights reserved.
//

import UIKit
import QuartzCore
import AVFoundation

/// Scalable Image View
class JNScalableImageView: UIView {
    
    /// Image view
    private let imageView = UIImageView()
    
    /// Content mode
    override var contentMode: UIView.ContentMode {
        didSet { self.updateImageViewAccordingToContentMode() }
    }
    
    /// Frame
    override var frame: CGRect {
        didSet { self.updateImageViewAccordingToContentMode() }
    }
    
    /// Image
    var image: UIImage? {
        didSet {
            self.imageView.image = image
            self.updateImageViewAccordingToContentMode()
        }
    }
    
    /**
     Initlizer
     */
    init() {
        super.init(frame: CGRect.zero)
        self.clipsToBounds = true
        self.addSubview(self.imageView)
        self.imageView.contentMode = UIView.ContentMode.scaleToFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Update image view content mode according to view content mode
     */
    private func updateImageViewAccordingToContentMode() {
        guard let image = self.image else { return }
        
        switch self.contentMode {
        case .scaleToFill:
            self.imageView.bounds = CGRect(origin: .zero, size: self.bounds.size)
            self.imageView.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        case .scaleAspectFit:
            if image.size.width > image.size.height {
                let imageViewFrame = AVMakeRect(aspectRatio: image.size, insideRect: self.bounds)
                self.imageView.bounds = CGRect(origin: .zero, size: imageViewFrame.size)
                self.imageView.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
            } else {
                let imageRatio = image.size.width / image.size.height
                self.imageView.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: floor(self.bounds.width / imageRatio))
                self.imageView.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
            }
        case .scaleAspectFill:
            let imageRatio = image.size.width / image.size.height
            let insideRectRatio = bounds.width / bounds.height
            if imageRatio > insideRectRatio {
                if image.size.width > image.size.height {
                    self.imageView.bounds = CGRect(x: 0, y: 0, width: floor(self.bounds.height * imageRatio), height: self.bounds.height)
                } else {
                    self.imageView.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width / imageRatio)
                }
            } else {
                self.imageView.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: floor(self.bounds.width / imageRatio))
            }
            
            self.imageView.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        case .redraw:
            let imageRatio = image.size.width / image.size.height
            let insideRectRatio = self.bounds.width / self.bounds.height
            if imageRatio > insideRectRatio {
                imageView.bounds = CGRect(x: 0, y: 0, width: floor(self.bounds.height * imageRatio), height: self.bounds.height)
            } else {
                imageView.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: floor(self.bounds.width / imageRatio))
            }
            
            self.imageView.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        case .center:
            self.imageView.bounds = CGRect(origin: .zero, size: image.size)
            self.imageView.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        case .top:
            self.imageView.bounds = CGRect(origin: .zero, size: image.size)
            self.imageView.center = CGPoint(x: self.bounds.size.width / 2, y: image.size.height / 2)
        case .bottom:
            self.imageView.bounds = CGRect(origin: .zero, size: image.size)
            self.imageView.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height - image.size.height / 2)
        case .left:
            self.imageView.bounds = CGRect(origin: .zero, size: image.size)
            self.imageView.center = CGPoint(x: image.size.width / 2, y: self.bounds.size.height / 2)
        case .right:
            self.imageView.bounds = CGRect(origin: .zero, size: image.size)
            self.imageView.center = CGPoint(x: self.bounds.size.width - image.size.width / 2, y: self.bounds.size.height / 2)
        case .topLeft:
            self.imageView.bounds = CGRect(origin: .zero, size: image.size)
            self.imageView.center = CGPoint(x: image.size.width / 2, y: image.size.height / 2)
        case .topRight:
            self.imageView.bounds = CGRect(origin: .zero, size: image.size)
            self.imageView.center = CGPoint(x: self.bounds.size.width - image.size.width / 2, y: image.size.height / 2)
        case .bottomLeft:
            self.imageView.bounds = CGRect(origin: .zero, size: image.size)
            self.imageView.center = CGPoint(x: image.size.width / 2, y: self.bounds.size.height - image.size.height / 2)
        case .bottomRight:
            self.imageView.bounds = CGRect(origin: .zero, size: image.size)
            self.imageView.center = CGPoint(x: self.bounds.size.width - image.size.width / 2, y: self.bounds.size.height - image.size.height / 2)
        @unknown default:
            break
        }
    }
}
