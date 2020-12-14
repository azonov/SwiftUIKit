
Pod::Spec.new do |s|
  s.name             = 'SwiftUIKit'
  s.version          = '1.0.0'
  s.summary          = "#{s.name}"

  s.platform = :ios
  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.author           = { 'Andrey Zonov' => 'ext.azonov@tinkoff.ru' }
  s.source = { :git => "https://stash.tcsbank.ru/scm/mi/#{s.name}.git", :tag => s.version.to_s }
  s.homepage = "https://stash.tcsbank.ru/scm/mi/#{s.name}.git"
  s.source_files = "#{s.name}/Classes/**/*.swift"
  s.resources = ["#{s.name}/Resources/**/*.{storyboard,xib,xcassets,strings,stringsdict}"]
end
