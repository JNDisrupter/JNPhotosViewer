//
//  JNPhotosViewerViewController.swift
//  JNPhotosViewer
//
//  Created by JN Disrupter on 8/29/18.
//  Copyright © 2018 JN Disrupter. All rights reserved.
//

import UIKit

/// JN Photos Viewer View Controller
open class JNPhotosViewerViewController: UIViewController {
    
    /// Pan Gesture
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    /// Collection view
    private var collectionView: UICollectionView!
    
    /// Close button
    private var closeButton: UIButton!
    
    /// Download button
    private var downloadButton: UIButton!
    
    /// Download Button Indicator
    private var downloadButtonIndicator : UIActivityIndicatorView!
    
    /// Transition Handler
    private var transitionHandler: PhotosViewerTransitioningDelegate?
    
    /// Selected image index
    public var selectedImageIndex: Int = 0
    
    /// Images list
    public var imagesList: [JNPhoto] = []
    
    /// Show download button
    public var showDownloadButton = false
    
    /// Delegate
    public weak var delegate: JNPhotosViewerViewControllerDelegate?
    
    /**
     Init with coder
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Set modal transition style
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        // Set modal presentation style
        self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        
        // This controls whether this view controller takes over control of the status bar's appearance when presented non-full screen on another view controller
        self.modalPresentationCapturesStatusBarAppearance = true
    }
    
    /**
     Init with nib name and bundle
     */
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Set modal transition style
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        // Set modal presentation style
        self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        
        // This controls whether this view controller takes over control of the status bar's appearance when presented non-full screen on another view controller
        self.modalPresentationCapturesStatusBarAppearance = true
    }
    
    /**
     Init
     */
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        // Set modal transition style
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        // Set modal presentation style
        self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        
        // This controls whether this view controller takes over control of the status bar's appearance when presented non-full screen on another view controller
        self.modalPresentationCapturesStatusBarAppearance = true
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background color
        self.view.backgroundColor = UIColor.clear
        
        // Init media collection view
        self.initImageCollectionView()
        
        // Init pan gesture
        self.initGestures()
        
        // Init close button
        self.initCloseButton()
        
        if self.showDownloadButton {
            self.initDownloadButton()
            self.initDownloadButtonIndicatorView()
        }
        
        // Init transition handler
        let startingImageView = self.delegate?.photosViewerViewController(viewController: self, refrenceViewFor: self.imagesList[self.selectedImageIndex])
        self.transitionHandler = PhotosViewerTransitioningDelegate()
        self.transitionHandler?.setupPresentation(startingImageView: startingImageView)
        self.transitioningDelegate = self.transitionHandler
        
        self.view.bringSubviewToFront(self.closeButton)
    }
    
    /**
     View will appear
     */
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.layoutIfNeeded()
        self.collectionView.scrollToItem(at: IndexPath(row: self.selectedImageIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
    }
    
    /**
     View did appear
     */
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Update transition handler
        if let cell = self.collectionView.cellForItem(at: IndexPath(row: self.selectedImageIndex, section: 0)) as? JNPhotosViewerCollectionViewCell {
            let endingImageView = self.delegate?.photosViewerViewController(viewController: self, refrenceViewFor: self.imagesList[self.selectedImageIndex])
            self.transitionHandler?.setupDismissal(startingImageView: cell.imageView, endingImageView: endingImageView)
        }
    }
    
    /// Prefers Status Bar Hidden
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /**
     Init image collection view
     */
    private func initImageCollectionView() {
        
        // Create flow layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UIScreen.main.bounds.size
        layout.headerReferenceSize = CGSize.zero
        
        // Set minumem spacing between items
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        // Create image collection view
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        // Register cell
        JNPhotosViewerCollectionViewCell.registerCell(collectionView: self.collectionView)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // Enable pagination
        self.collectionView.isPagingEnabled = true
        
        // Set collection view background
        self.collectionView.backgroundView = nil
        self.collectionView.backgroundColor = UIColor.black
        
        // Add as subview
        self.view.insertSubview(self.collectionView, at: 0)
        
        // Add constraints
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    // MARK: - Close button
    
    /**
     Init close button
     */
    private func initCloseButton() {
        
        // Initialize bundle
        let bundle = Bundle(for: JNPhotosViewerViewController.self)
        
        self.closeButton = UIButton()
        self.closeButton.setImage(UIImage(named: "ImageCloseButton", in: bundle, compatibleWith: nil), for: UIControl.State.normal)
        self.closeButton.addTarget(self, action: #selector(self.didClickCloseButton), for: UIControl.Event.touchUpInside)
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.closeButton)
        
        // Add constraints
        self.closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.closeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        
        // Add shadow to close button
        self.closeButton.layer.shadowColor = UIColor.black.cgColor
        self.closeButton.layer.shadowOffset = CGSize.zero
        self.closeButton.layer.shadowOpacity = 0.4
        self.closeButton.layer.shadowRadius = 6
        self.closeButton.layer.masksToBounds = false
        
        if #available(iOS 11, *) {
            let guide = self.view.safeAreaLayoutGuide
            self.closeButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16).isActive = true
        } else {
            self.closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16).isActive = true
        }
    }
    
    /**
     Did click close button
     */
    @objc private func didClickCloseButton() {
        self.dismiss(animated: true)
    }
    
    // MARK: - download button
    
    /**
     Init download button
     */
    private func initDownloadButton() {
        // Initialize bundle
        let bundle = Bundle(for: JNPhotosViewerViewController.self)
        
        self.downloadButton = UIButton()
        self.downloadButton.setImage(UIImage(named: "DownloadImage", in: bundle, compatibleWith: nil), for: UIControl.State.normal)
        self.downloadButton.addTarget(self, action: #selector(self.didClickDownloadButton), for: UIControl.Event.touchUpInside)
        self.downloadButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.downloadButton)
        
        // Add constraints
        self.downloadButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.downloadButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.downloadButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        
        if #available(iOS 11, *) {
            let guide = self.view.safeAreaLayoutGuide
            self.downloadButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16).isActive = true
        } else {
            self.downloadButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16).isActive = true
        }
    }
    
    /**
     Init download button indicator view
     */
    private func initDownloadButtonIndicatorView() {
        self.downloadButtonIndicator  = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        self.downloadButtonIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.downloadButtonIndicator.isHidden = true
        self.view.addSubview(self.downloadButtonIndicator)
        
        // Add constraints
        self.downloadButtonIndicator.trailingAnchor.constraint(equalTo: self.downloadButton.trailingAnchor).isActive = true
        self.downloadButtonIndicator.topAnchor.constraint(equalTo: self.downloadButton.topAnchor).isActive = true
        self.downloadButtonIndicator.bottomAnchor.constraint(equalTo: self.downloadButton.bottomAnchor).isActive = true
        self.downloadButtonIndicator.leadingAnchor.constraint(equalTo: self.downloadButton.leadingAnchor).isActive = true
    }
    
    /**
     Did click download button
     */
    @objc private func didClickDownloadButton() {
        if self.delegate != nil {
            self.downloadButton.isHidden = true
            self.downloadButtonIndicator.isHidden = false
            self.downloadButtonIndicator.startAnimating()
            self.downloadButtonIndicator.isUserInteractionEnabled = true
            
            self.delegate?.photosViewerViewController(viewController: self, didClickDownload: self.imagesList[self.selectedImageIndex], completion: {
                self.downloadButtonIndicator.isHidden = true
                self.downloadButtonIndicator.isUserInteractionEnabled = false
                self.downloadButton.isHidden = false
            })
        }
    }
}

// MARK: - UICollectionViewDataSource
extension JNPhotosViewerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    /**
     Number of sections in collection view
     */
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /**
     Number of items in section
     */
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesList.count
    }
    
    /**
     Cell for item at index path
     */
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get image cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JNPhotosViewerCollectionViewCell.getReuseIdentifier(), for: indexPath) as? JNPhotosViewerCollectionViewCell
        
        // Set up cell
        cell!.setup(photo: self.imagesList[indexPath.row])
        
        return cell!
    }
}

// MARK: - UIScrollViewDelegate
extension JNPhotosViewerViewController: UIScrollViewDelegate {
    
    /**
     Scroll view did end declarating
     */
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // Get current page
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        if w > 0 {
            let currentPage = Int(ceil(x/w))
            
            // Set selected page
            self.selectedImageIndex = currentPage
            
            // Did change page
            self.delegate?.photosViewerViewController(viewController: self, didChangePage: self.selectedImageIndex)
            
            // Update transition handler
            if let cell = self.collectionView.cellForItem(at: IndexPath(row: self.selectedImageIndex, section: 0)) as? JNPhotosViewerCollectionViewCell {
                let endingImageView = self.delegate?.photosViewerViewController(viewController: self, refrenceViewFor: self.imagesList[self.selectedImageIndex])
                self.transitionHandler?.setupDismissal(startingImageView: cell.imageView, endingImageView: endingImageView)
            }
        }
    }
}

// MARK: - GestureRecognizers & UIGestureRecognizerDelegate
extension JNPhotosViewerViewController: UIGestureRecognizerDelegate {
    
    /**
     Gesture recognizer should begin
     */
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            if gestureRecognizer == self.panGestureRecognizer, let cell = self.collectionView.cellForItem(at: IndexPath(row: self.selectedImageIndex, section: 0)) as? JNPhotosViewerCollectionViewCell, cell.scrollView.zoomScale == cell.scrollView.minimumZoomScale {
                return true
            }
        }
        
        return false
    }
    
    /**
     Init pan gesture
     */
    private func initGestures() {
        self.panGestureRecognizer = UIPanGestureRecognizer()
        self.panGestureRecognizer.addTarget(self, action: #selector(imageViewPanned(_:)))
        self.panGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(self.panGestureRecognizer!)
    }
    
    /**
     Image view panned
     */
    @objc private func imageViewPanned(_ recognizer: UIPanGestureRecognizer) {
        guard self.transitionHandler != nil else { return }
        
        switch recognizer.state {
        case .began:
            transitionHandler?.forcesNonInteractiveDismissal = true
            dismiss(animated: true)
        default:
            if let cell = self.collectionView.cellForItem(at: IndexPath(row: self.selectedImageIndex, section: 0)) as? JNPhotosViewerCollectionViewCell {
                self.transitionHandler?.didPanWithPanGestureRecognizer(panGestureRecognizer: recognizer, viewToPan: cell.imageView)
            }
            
            break
        }
    }
}

/// JNPhotos Viewer View Controller Delegate
public protocol JNPhotosViewerViewControllerDelegate: NSObjectProtocol {
    
    /**
     Ask the delegate for refrence image view for photo which will be used as refrence to present and dismiss view to it.
     - Parameter viewController: JNPhotos Viewer View Controller
     - Parameter photo: JNPhoto object
     - Returns: Refrence view for photo
     */
    func photosViewerViewController(viewController: JNPhotosViewerViewController, refrenceViewFor photo: JNPhoto) -> UIImageView?
    
    /**
     Tell the delegate that the download button clicked for photo
     - Parameter viewController: JNPhotos Viewer View Controller
     - Parameter photo: JNPhoto object
     - Parameter completion: The completion to call after finish proccesing the downlaod request, this completion will remove the loading from download button
     */
    func photosViewerViewController(viewController: JNPhotosViewerViewController, didClickDownload photo: JNPhoto, completion: @escaping () -> Void)
    
    /**
     Tell the delegate that the page have been changed
     - Parameter viewController: JNPhotos Viewer View Controller
     - Parameter page: New page index
     - Parameter completion: The completion to call after finish proccesing the downlaod request, this completion will remove the loading from download button
     */
    func photosViewerViewController(viewController: JNPhotosViewerViewController, didChangePage page: Int)
}

public extension JNPhotosViewerViewControllerDelegate {
    
    /**
     Tell the delegate that the download button clicked for photo
     - Parameter viewController: JNPhotos Viewer View Controller
     - Parameter photo: JNPhoto object
     - Parameter completion: The completion to call after finish proccesing the downlaod request, this completion will remove the loading from download button
     */
    func photosViewerViewController(viewController: JNPhotosViewerViewController, didClickDownload photo: JNPhoto, completion: @escaping () -> Void) {}
    
    /**
     Tell the delegate that the page have been changed
     - Parameter viewController: JNPhotos Viewer View Controller
     - Parameter page: New page index
     - Parameter completion: The completion to call after finish proccesing the downlaod request, this completion will remove the loading from download button
     */
    func photosViewerViewController(viewController: JNPhotosViewerViewController, didChangePage page: Int) {}
}
