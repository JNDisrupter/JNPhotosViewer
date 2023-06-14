//
//  JNPhotosViewerUtils.swift
//  JNPhotosViewer
//
//  Created by Jayel Zaghmoutt on 6/1/23.
//

import Foundation


/// JN Photos Viewer Utils
public class JNPhotosViewerUtils {
    
    /**
     Get window
     - Returns: App key window
     */
    public class func getWindow() -> UIWindow? {
        
        // Return the main window from property App Delegate if its exists
        if let window = UIApplication.shared.delegate?.window {
            return window
        }
        
        // Return key window
        if #available(iOS 15.0, *) {
            return UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        }
    }
    
    /**
     Get main screen
     - Returns: Main screen
     */
    public class func getMainScreen() -> UIScreen {
        
        // Return main screen
        if #available(iOS 16.0, *) {
            return self.getWindow()!.windowScene!.screen
        } else {
            return UIScreen.main
        }
    }
    
}
