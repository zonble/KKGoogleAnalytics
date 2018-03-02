Pod::Spec.new do |s|
  s.name = "KKGoogleAnalytics"
  s.version = "0.0.2"
  s.summary = "Another Google Analytics library for Mac OS X."

  s.description = <<-DESC
                   Just another Google Analytics library for Mac OS
                   X. The interface of the library is much like
                   Google's official SDK for iOS, it helps you to do
                   analytics for not only page views but also app
                   views and so on.
                   DESC

  s.homepage = "https://github.com/zonble/KKGoogleAnalytics"
  s.license = "MIT"

  s.author = {"Weizhong Yang" => "zonble@gmail.com"}
  s.social_media_url = "http://twitter.com/zonble"

  s.platform = :osx
  s.osx.deployment_target = "10.7"

  s.source = {:git => "https://github.com/zonble/KKGoogleAnalytics.git", :tag => "0.0.2"}

  s.source_files = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.resource = "Resources/GoogleAnalytics.xcdatamodeld"
  s.requires_arc = true
end
