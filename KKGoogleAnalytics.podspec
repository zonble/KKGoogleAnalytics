Pod::Spec.new do |s|
  s.name = "KKGoogleAnalytics"
  s.version = "0.0.3"
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

  s.author = {"zonble" => "zonble@gmail.com"}
  s.social_media_url = "http://twitter.com/zonble"

  s.osx.deployment_target = "10.10"
  s.ios.deployment_target = "8.0"

  s.source = {:git => 'https://github.com/zonble/KKGoogleAnalytics.git', :tag => s.version.to_s}

  s.source_files = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.resource = "Resources/GoogleAnalytics.xcdatamodeld"
  s.requires_arc = true
  s.frameworks = ['CoreData']
end
