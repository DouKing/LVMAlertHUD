Pod::Spec.new do |s|

  s.name         = "LVMAlertHUD"
  s.version      = "3"
  s.summary      = "仿系统API弹框"
  s.homepage     = "https://github.com/DouKing/LVMAlertHUD"
  s.license      = "MIT"
  s.author       = { "wuyikai" => "wyk8916@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/DouKing/LVMAlertHUD.git", :tag => "#{s.version}" }
  s.source_files = 'LVMAlertHUD/Source/**/*.{h,m}'
  s.resources    = 'LVMAlertHUD/Source/**/*.png'
  s.requires_arc = true

  s.subspec 'AlertController' do |ss|
    ss.source_files = 'LVMAlertHUD/Source/AlertController/**/*.{h,m}', 'LVMAlertHUD/Source/Helper/**/*.{h,m}', 'LVMAlertHUD/Source/LVMAlertHeader.h'
    ss.dependency 'pop'
  end

  s.subspec 'StatusBarHUD' do |ss|
    ss.source_files = 'LVMAlertHUD/Source/StatusBarHUD/**/*.{h,m}', 'LVMAlertHUD/Source/Resource/*'
  end

  s.subspec 'Toast' do |ss|
    ss.source_files = 'LVMAlertHUD/Source/Toast/**/*.{h,m}'
    ss.dependency 'pop'
  end

end
