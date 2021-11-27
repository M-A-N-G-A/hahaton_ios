# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def rx_swift
  pod 'RxSwift', '~> 5.1.0'
  pod 'Alamofire'
  pod 'RxAlamofire'
end

def rx_cocoa
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxGesture'
  pod 'RxKeyboard'
end

def cocoaLumberjack
  pod 'CocoaLumberjack/Swift'
end

target 'OpenMVP' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  rx_cocoa
  rx_swift
  cocoaLumberjack
  pod 'SnapKit', '~> 5.0.0'
  pod 'PKHUD', '~> 5.0'
  pod 'Tabman', '~> 2.11'

end
