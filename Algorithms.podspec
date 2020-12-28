Pod::Spec.new do |spec|

  spec.name         = "Algorithms"
  spec.version      = "0.0.1"
  spec.summary      = "Algorithms is a framework including all algorithms and data structures."

  spec.description  = "Algorithms is a framework including all algorithms and data structures + some extensions for embedded Swift Collection (see. below) that commonly used for iOS/Mac/tvOS development."

  spec.screenshots  = "https://github.com/vovkroman/Algorithms/blob/master/Images/searching_plot.png"
  spec.license      = "MIT"
  
  spec.author             = { "Roman Vovk" => "roman.vovk.s@gmail.com" }
  spec.homepage           = "https://github.com/vovkroman/Algorithms"
  spec.social_media_url   = "https://www.linkedin.com/in/roman-vovk-bb6394b2"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  spec.platform     = :ios, "10.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  spec.source       = { :git => "https://github.com/vovkroman/Algorithms.git", :tag => "#{spec.version}" }

  spec.source_files  = "Algorithms/Source", "Algorithms/Source/**/*.{h,m,swift}"
  spec.exclude_files = "Algorithms.h", "Algorithms/Source/Stack/Cpp/CppStack.h", "Algorithms/Source/PriorityQueue/ObjC/CFPriorityQueue.h"

  # spec.public_header_files = "Algorithms/Source/Exclude"
  spec.swift_version = "4.2"

  s.frameworks = "Foundation", "CoreFoundation"

end
