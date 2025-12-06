import Foundation

final class Unity: NSObject {
    static let shared = Unity()
    private let unityFramework: UnityFramework
    private var onReadyHandler: (() -> Void)? = nil
    
    // NOTE: アプリ固有機能
    var intensityDelegate: IntensityDelegate? = nil
    private var onChangeIntensityDelegate: ((Double) -> Void)? = nil
    
    var view: UIView {
        unityFramework.appController().rootView!
    }
    
    override init() {
        unityFramework = Unity.loadUnityFramework()
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
            
            FrameworkLibAPI.registerAPIforNativeCalls(self)
            self.onReadyHandler = onReadyHandler
            
            // Set UnityFramework target for Unity-iPhone/Data folder to make Data part of a UnityFramework.framework and uncomment call to setDataBundleId
            // ODR is not supported in this case, ( if you need embedded and ODR you need to copy data )
            unityFramework.setDataBundleId("com.unity3d.framework")
            unityFramework.register(self)
            unityFramework.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: launchOptions)
            
            //onReadyHandler()
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

extension Unity: UnityFrameworkListener {
    func unityDidUnload(_ notification: Notification) {
    }
    
    func unityDidQuit(_ notification: Notification) {
    }
}

extension Unity: NativeProxy {
    func onChangeIntensity(_ intensity: Float32) {
        intensityDelegate?.onChangeIntensityFromUnity(intensity)
    }
    
    func registerEvent(for onChangeIntensity: @escaping (Float32) -> Void) {
        onChangeIntensityDelegate = { value in
            onChangeIntensity(Float32(value))
        }
    }
    
    func onReady() {
        onReadyHandler?()
    }
}

// MARK:- アプリ固有機能

protocol IntensityDelegate {
    /// intensityの変更通知 [Unity -> Native]
    func onChangeIntensityFromUnity(_ intensity: Float32)
}


extension Unity {
    /// intensityの設定 (Native -> Unity)
    func setIntensity(with intensity: Double) {
        onChangeIntensityDelegate?(intensity)
    }
}
