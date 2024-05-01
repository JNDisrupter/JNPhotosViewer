Pod::Spec.new do |s|
    s.name                            = 'JNPhotosViewer'
    s.version                         = '1.0.6'
    s.summary                         = 'summery of JNPhotosViewer.'
    s.description                     = 'Library for viewing multiple images with animation for presenting and dismissing.'
    s.homepage                        = 'https://github.com/JNDisrupter'
    s.license                         = { :type => "MIT", :file => "LICENSE" }
    s.authors                         = { "Jayel Zaghmoutt" => "eng.jayel.z@gmail.com", "Mohammad Nabulsi" => "mohammad.s.nabulsi@gmail.com"   }
    s.ios.deployment_target           = '11.0'
    s.swift_version                   = '5.10'
    s.source                          = { :git => "https://github.com/JNDisrupter/JNPhotosViewer.git", :tag => "#{s.version}" }
    s.source_files                    = 'JNPhotosViewer/**/*.swift'
    s.resources                       = 'JNPhotosViewer/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,ttf}'
    s.dependency                      'SDWebImage'
end
