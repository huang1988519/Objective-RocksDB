
Pod::Spec.new do |s|

  s.name         = "Objective-RocksDB"
  s.version      = "0.5.0"
  s.summary      = "Objective-RocksDB is a  Static library for iOS. RockesDB is developed and maintained by Facebook Database Engineering Team."

  s.description  = <<-DESC
    RockesDB is developed by facebook, it`s build on earlier work on LevelDB.
    Objective-RocksDB fork from iabudiab/ObjectiveRocks.
    But Objective-RocksDB is convenient to import using CocoaPods.
                   DESC

  s.homepage     = "https://github.com/huang1988519/Objective-RocksDB
  s.license      = "MIT"
  s.author       = { "huang1988519" => "huang1988519@126.com" }
  s.platform     = :ios, "5.0"

  #  When using multiple platforms
  s.ios.deployment_target = "5.0"
  s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "git@github.com:huang1988519/Objective-RocksDB.git", :tag => "0.5.0" }


  s.source_files  = "Classes", "Classes/**/*.{h,m}"

  # s.public_header_files = "Classes/**/*.h"


  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "RockesDB", :git => 'git@github.com:facebook/rocksdb.git'
end
