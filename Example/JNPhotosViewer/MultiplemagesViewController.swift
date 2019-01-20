//
//  MultiplemagesViewController.swift
//  JNPhotosViewer_Example
//
//  Created by Mohammad Nabulsi on 1/20/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import JNPhotosViewer
import JNMultipleImages

/// Multiple Images View Controller
class MultiplemagesViewController: UIViewController {
    
    /// Multiple images
    @IBOutlet private weak var multipleImages: JNMultipleImagesView!
    
    /// Media list
    private var mediaList: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mediaList.append(UIImage(named: "NatureImage1")!)
        self.mediaList.append(UIImage(named: "NatureImage2")!)
        self.mediaList.append(UIImage(named: "NatureImage3")!)
        
        // Setup multiple images view
        self.multipleImages.setup(images: self.mediaList)
        self.multipleImages.delegate = self
    }
}

// MARK: - JNPhotosViewerViewControllerDelegate
extension MultiplemagesViewController: JNPhotosViewerViewControllerDelegate {
    
    /**
     Ask the delegate for refrence image view for photo which will be used as refrence to present and dismiss view to it.
     - Parameter viewController: JNPhotos Viewer View Controller
     - Parameter photo: JNPhoto object
     - Returns: Refrence view for photo
     */
    func photosViewerViewController(viewController: JNPhotosViewerViewController, refrenceViewFor photo: JNPhoto) -> UIImageView? {
        let photoIndex = self.mediaList.index(where: { item in return item == photo.image! }) ?? 0
        return self.multipleImages.getMediaView(at: photoIndex)
    }
    
    /**
     Tell the delegate that the download button clicked for photo
     - Parameter viewController: JNPhotos Viewer View Controller
     - Parameter photo: JNPhoto object
     - Parameter completion: The completion to call after finish proccesing the downlaod request, this completion will remove the loading from download button
     */
    func photosViewerViewController(viewController: JNPhotosViewerViewController, didClickDownload photo: JNPhoto, completion: () -> Void) {
        
    }
}

// MARK: - JNMultipleImagesViewDelegate
extension MultiplemagesViewController: JNMultipleImagesViewDelegate {
    
    /**
     Did click item at index
     - parameter atIndex: The clicked item index
     */
    func jsMultipleImagesView(didClickItem atIndex : Int) {
        
        let photosList = self.mediaList.map({ (item) -> JNPhoto in
            var jnPhoto = JNPhoto()
            jnPhoto.image = item
            return jnPhoto
        })
        
        let viewController = JNPhotosViewerViewController()
        viewController.imagesList = photosList
        viewController.selectedImageIndex = atIndex
        viewController.delegate = self
        viewController.showDownloadButton = false
        self.present(viewController, animated: true, completion: nil)
    }
}
