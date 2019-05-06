//
//  SingleImageViewController.swift
//  JNPhotosViewer
//
//  Created by JN Disrupter on 9/5/18.
//  Copyright © 2018 JN Disrupter. All rights reserved.
//

import UIKit
import JNPhotosViewer

/// Signle Image View Controller
class SingleImageViewController: UIViewController {

    /// Image view
    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /**
     Did tap image view
     */
    @IBAction func didTapImageView(_ sender: Any) {
        
        var jnPhoto = JNPhoto()
        jnPhoto.image = imageView.image
        
        let viewController = JNPhotosViewerViewController()
        viewController.imagesList = [jnPhoto]
        viewController.delegate = self
        viewController.showDownloadButton = false
        self.present(viewController, animated: true, completion: nil)
    }
}

// MARK: - JNPhotosViewerViewControllerDelegate
extension SingleImageViewController: JNPhotosViewerViewControllerDelegate {
    
    /**
     Ask the delegate for refrence image view for photo which will be used as refrence to present and dismiss view to it.
     - Parameter viewController: JNPhotos Viewer View Controller
     - Parameter photo: JNPhoto object
     - Returns: Refrence view for photo
     */
    func photosViewerViewController(viewController: JNPhotosViewerViewController, refrenceViewFor photo: JNPhoto) -> UIImageView? {
        return self.imageView
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
