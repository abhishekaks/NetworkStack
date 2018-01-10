Pod::Spec.new do |s|
  s.name             = 'NetworkStackSwift'
  s.version          = '0.3.0'
  s.summary          = 'Network Layer along with Parsing for Swift Projects.'

  s.description      = <<-DESC
NetworkStack allows easy and fast integration of a network layer for a swift and objective c project along with caching the response if specified.
                       DESC

  s.homepage         = 'https://github.com/abhishekaks/NetworkStack'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'abhishekaks' => 'abhishekattitude@gmail.com' }
  s.source           = { :git => 'https://github.com/abhishekaks/NetworkStack.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'NetworkStack/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NetworkStack' => ['NetworkStack/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'PINCache'
end
