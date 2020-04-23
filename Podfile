source 'https://github.com/CocoaPods/Specs.git'

target "Achelous" do

platform :ios, '8.0'

eval(File.open('PodDevExtension.rb').read) if File.exist? 'PodDevExtension.rb'


pod 'Bugly','2.5.2'
pod 'BaiduMapKit', '5.1.0'
pod 'BMKLocationKit', '1.8.5'
pod 'WMZDialog',  '1.0.7'
pod 'JXTAlertManager'
pod 'SDWebImage', '~> 4.0.0'
pod 'SVProgressHUD', '2.2.5'
pod 'YYModel' ,'1.0.4'
pod 'AFNetworking','3.2.1'
pod 'Mantle', '2.1.0'
pod 'MJRefresh', '3.1.15'
pod 'LookinServer', '0.9.4', :configurations => ['Debug']
pod 'HYBUnicodeReadable', '1.1'
#pod 'MLeaksFinder','1.0.0', :configurations => ['Debug']

end

#post_install do |installer|
#    copy_pods_resources_path = "Pods/Target Support Files/Pods-Billion/Pods-Billion-resources.sh"
#    string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
#    assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
#    text = File.read(copy_pods_resources_path)
#    new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
#    File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
#end
