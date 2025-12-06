import Foundation

/// Unity との呼び出し規約
public protocol NativeProxy {
    /// [Unity -> Native] UnityEngine のセットアップ完了イベント
    func onInitialize()
    /// [Unity -> Native] Unity から Intensity が変更された際のイベント
    func onChangeIntensity(_ intensity: Float32)
    /// [Native -> Unity] ネイティブ側から Intensity を変更した際のイベントを登録
    func registerEvent(for onChangeIntensity: @escaping (Float32) -> Void)
}

public final class FrameworkLibAPI {
    public static var isInitialized = false
    static var api: NativeProxy? = nil
    
    // NOTE: Native から登録されるプロトコル
    public static func registerAPIforNativeCalls(_ proxy: NativeProxy) {
        FrameworkLibAPI.api = api
    }
}

// MARK:- P/Invoke

/// ネイティブからintensityの設定を適用する際に呼び出す関数ポインタ
typealias OnChangeIntensityDelegate = @convention(c) (Float32) -> Void

@_cdecl("UaaLExample_NativeProxy_NativeInitialize")
func UaaLExample_NativeProxy_Initialize() {
    FrameworkLibAPI.api?.onInitialize()
    FrameworkLibAPI.isInitialized = true
}

@_cdecl("UaaLExample_NativeProxy_NativeSetIntensity")
func UaaLExample_NativeProxy_NativeSetIntensity(_ intensity: Float32) {
    FrameworkLibAPI.api?.onChangeIntensity(intensity)
}

@_cdecl("UaaLExample_NativeProxy_NativeRegisterDelegate")
func UaaLExample_NativeProxy_NativeRegisterDelegate(_ delegate: @escaping OnChangeIntensityDelegate) {
    FrameworkLibAPI.api?.registerEvent(for: delegate)
}
