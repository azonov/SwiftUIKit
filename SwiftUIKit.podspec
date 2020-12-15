
Pod::Spec.new do |s|
  s.name             = 'SwiftUIKit'
  s.version          = '1.0.0'
  s.summary          = "#{s.name}"

  s.platform = :ios
  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.author           = { 'Andrey Zonov' => 'andryzonov@gmail.com' }
  s.source = { :git => "https://github.com/azonov/SwiftUIKit.git", :tag => s.version.to_s }
  s.homepage = "https://github.com/azonov/SwiftUIKit"
  s.source_files = "#{s.name}/Classes/**/*.swift"
  s.resources = ["#{s.name}/Resources/**/*.{storyboard,xib,xcassets,strings,stringsdict}"]
end
