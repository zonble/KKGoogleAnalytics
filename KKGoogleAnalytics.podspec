Pod::Spec.new do |s|

  s.name         = "KKGoogleAnalytics"
  s.version      = "0.0.1"
  s.summary      = "A Google Analytics for Mac OS X."

  s.description  = <<-DESC
                   A longer description of KKGoogleAnalytics in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/zonble/KKGoogleAnalytics"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = "MIT (example)"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "Weizhong Yang" => "zonble@gmail.com" }
  s.social_media_url   = "http://twitter.com/zonble"

  s.platform     = :osx
  s.osx.deployment_target = "10.7"

  s.source       = { :git => "http://EXAMPLE/KKGoogleAnalytics.git", :tag => "0.0.1" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"

  s.resource  = "Resources/GoogleAnalytics.xcdatamodeld"

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true
end
