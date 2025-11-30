import Foundation

final class UnityBridge: NSObject {
    static let shared = UnityBridge()
    private let unityFramework: UnityFramework
    private var onReadyHandler: (() -> Void)? = nil
    
    // NOTE: アプリ固有機能
    var unityDelegate: UnityDelegate? = nil
    private var onChangeIntensity: ((Double) -> Void)? = nil
    
    var view: UIView {
        unityFramework.appController().rootView!
    }
    
    override init() {
        unityFramework = UnityBridge.loadUnityFramework()
        super.init()
    }
    
    func sendMessage(objectName: String, functionName: String, argument: String) {
        unityFramework.sendMessageToGO(withName: objectName, functionName: functionName, message: argument)
    }
    
    func pause(_ pause: Bool) {
        unityFramework.pause(pause)
    }
    
    func unload() {
        unityFramework.unloadApplication()
    }
    
    // ref: Unity-iPhone -> MainApp/main.mm
    private static func loadUnityFramework() -> UnityFramework {
        let bundlePath = Bundle.main.bundlePath
        let frameworkPath = bundlePath + "/Frameworks/UnityFramework.framework"
        
        guard let bundle = Bundle(path: frameworkPath) else {
            fatalError("failed loadUnityFramework.")
        }
        
        if !bundle.isLoaded {
            bundle.load()
        }
        
        guard let frameworkClass = bundle.principalClass as? UnityFramework.Type,
              let framework = frameworkClass.getInstance()
        else {
            fatalError("failed loadUnityFramework.")
        }
        
        if framework.appController() == nil {
            // unity is not initialized
            var header = _mh_execute_header
            framework.setExecuteHeader(&header)
        }
        
        return framework
    }
    
    // MARK:- AppDelegate
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?,
        onReadyHandler: @escaping () -> Void) {
            
            self.onReadyHandler = onReadyHandler
            
            // Set UnityFramework target for Unity-iPhone/Data folder to make Data part of a UnityFramework.framework and uncomment call to setDataBundleId
            // ODR is not supported in this case, ( if you need embedded and ODR you need to copy data )
            unityFramework.setDataBundleId("com.unity3d.framework")
            unityFramework.register(self)
            FrameworkLibAPI.registerAPIforNativeCalls(self)
            unityFramework.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: launchOptions)
        }
    
    func applicationWillResignActive(_ application: UIApplication) {
        unityFramework.appController().applicationWillResignActive(application)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        unityFramework.appController().applicationDidEnterBackground(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        unityFramework.appController().applicationWillEnterForeground(application)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        unityFramework.appController().applicationDidBecomeActive(application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        unityFramework.appController().applicationWillTerminate(application)
    }
}

extension UnityBridge: UnityFrameworkListener {
    func unityDidUnload(_ notification: Notification) {
    }
    
    func unityDidQuit(_ notification: Notification) {
    }
}
// MARK:- アプリ固有機能

/// Unity からのイベントを受け取るためのデリゲート
protocol UnityDelegate {
    /// intensityの変更通知 [Unity -> Native]
    func onChangeIntensity(_ intensity: Float32)
}


/// Swift から Unity に向けて呼び出すメソッド
extension UnityBridge {
    /// intensityの設定 (Native -> Unity)
    func setIntensity(with intensity: Double) {
        onChangeIntensity?(intensity)
    }
}

extension UnityBridge: NativeProxy {
    func onReady() {
        onReadyHandler?()
    }
    
    func onChangeIntensity(_ intensity: Float32) {
        unityDelegate?.onChangeIntensity(intensity)
    }
    
    func registerEvent(for onChangeIntensity: @escaping (Float32) -> Void) {
        self.onChangeIntensity = { value in
            onChangeIntensity(Float32(value))
        }
    }
}

