platform :ios, '7.0'

# ignore all warnings from all pods
inhibit_all_warnings!

pod 'AFNetworking'
pod 'PonyDebugger'
pod 'SVPullToRefresh', '~> 0.4.1'
pod 'DAKeyboardControl', '~> 2.3'
pod 'UIAlertView-Blocks', '0.0.1'
pod 'SVProgressHUD', :head
pod 'SVPullToRefresh'

target :unit_tests, :exclusive => true do
  link_with 'UnitTests'
  pod 'Specta'
  pod 'Expecta'
  pod 'OCMock'
end
