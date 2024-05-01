# JNPhotosViewer

[![CI Status](https://img.shields.io/travis/mohammadnabulsi/JNPhotosViewer.svg?style=flat)](https://travis-ci.org/mohammadnabulsi/JNPhotosViewer)
[![Version](https://img.shields.io/cocoapods/v/JNPhotosViewer.svg?style=flat)](https://cocoapods.org/pods/JNPhotosViewer)
[![License](https://img.shields.io/cocoapods/l/JNPhotosViewer.svg?style=flat)](https://cocoapods.org/pods/JNPhotosViewer)
[![Platform](https://img.shields.io/cocoapods/p/JNPhotosViewer.svg?style=flat)](https://cocoapods.org/pods/JNPhotosViewer)

## Preview

<img src="https://github.com/JNDisrupter/JNPhotosViewer/raw/master/Images/preview.gif" width="280"/> 

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 11.0+ / macOS 14+
- Xcode 15.3+
- Swift 5.10+

## Installation

JNPhotosViewer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JNPhotosViewer'
```
## Setup

```swift
let viewController = JNPhotosViewerViewController()
viewController.imagesList = [JNPhoto]
viewController.delegate = self
viewController.showDownloadButton = false
self.present(viewController, animated: true, completion: nil)
```

### Public variables
```swift
var imagesList: Array of JNPhoto
var delegate: JNPhotosViewerViewControllerDelegate
var showDownloadButton: Bool
```
### Public classes

1. JNPhotosViewerViewController
2. JNPhotosViewerViewControllerDelegate
    1. photosViewerViewController(viewController: JNPhotosViewerViewController, refrenceViewFor photo: JNPhoto) -> UIImageView?
    <br>This method will return the image view for photo to use for dismiss animation if not provided the default animation will be appiled.
    2. photosViewerViewController(viewController: JNPhotosViewerViewController, didClickDownload photo: JNPhoto, completion: () -> Void)
        <br>This method will be called when the download button clicked, call the completion to hide loading indicator from download button.

## Author

Yara AbuHijleh & Mohammad Nabulsi & Jayel Zaghmoutt

## License

JNPhotosViewer is available under the MIT license. See the LICENSE file for more info. See the [LICENSE](https://github.com/JNDisrupter/JNPhotosViewer/blob/master/LICENSE) file for more info.
