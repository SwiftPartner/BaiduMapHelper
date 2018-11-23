#
Pod::Spec.new do |s|

  s.name         = "BaiduMapHelper"
  s.version      = "0.0.2"
  s.summary      = "百度地图部分功能封装"

  s.description  = <<-DESC
                    暂时只用到定位和正反地理位置编码，后续如果有用到其他的会继续集成
                   DESC

  s.homepage     = "https://github.com/SwiftPartner"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Runryan" => "mob_developer@163.com" }
s.social_media_url   = "https://www.jianshu.com/u/ddf4eb832e80"

s.platform     = :ios
s.platform     = :ios, "9.0"
s.swift_version = '4.2'



  s.source       = { :git => "https://github.com/SwiftPartner/BaiduMapHelper.git", :tag => "#{s.version}" }

  s.source_files  = "Classes", "Classes/**/*.{h,m}"
# s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { s.xcconfig = 'SWIFT_OBJC_BRIDGING_HEADER' => '${PODS_ROOT}/Classes/Bridging-Header.h' }
  s.dependency "BMKLocationKit"
  s.dependency "BaiduMapKit"
  s.dependency "SPLog"

end
