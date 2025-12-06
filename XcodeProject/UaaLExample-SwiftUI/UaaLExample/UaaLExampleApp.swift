import SwiftUI

// AppDelegate クラスの定義
class AppDelegate: NSObject, UIApplicationDelegate {
    let unityBridge: UnityBridge = UnityBridge.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // UaaLの初期化
        unityBridge.application(application, didFinishLaunchingWithOptions: launchOptions) { [weak self] in
            // TODO
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        unityBridge.applicationWillResignActive(application)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        unityBridge.applicationDidEnterBackground(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        unityBridge.applicationWillEnterForeground(application)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        unityBridge.applicationDidBecomeActive(application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        unityBridge.applicationWillTerminate(application)
    }
}

@main
struct UaaLExampleApp: App {
    // AppDelegate を SwiftUI App に接続
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
