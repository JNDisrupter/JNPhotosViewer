//
//  JNPhoto.swift
//  JNPhotosViewer
//
//  Created by JN Disrupter on 9/5/18.
//  Copyright © 2018 JN Disrupter. All rights reserved.
//

import UIKit

/// JNPhoto
public struct JNPhoto {
    
    /// Identifier
    public var identifier: String
    
    /// Image
    public var image: UIImage?
    
    /// Image url
    public var imageUrl: String
    
    /// Place holder image
    public var placeholderImage: UIImage?
    
    /**
     initializer
     */
    public init() {
        self.identifier = ""
        self.image = nil
        self.imageUrl = ""
        self.placeholderImage = nil
    }
}
