#if UNITY_IOS
using System;
using System.Runtime.InteropServices;

namespace _Example.NativeProxy
{
    internal sealed class NativeProxyIOS : INativeProxy
    {
        private static event Action<float> OnChangeIntensityInternal;

        public event Action<float> OnChangeIntensity
        {
            add => OnChangeIntensityInternal += value;
            remove => OnChangeIntensityInternal -= value;
        }

        public NativeProxyIOS()
        {
            RegisterChangeIntensityDelegate();
        }

        public void Dispose()
        {
        }

        public void Ready() => NativeReady();

        public void SetIntensity(float intensity) => NativeSetIntensity(intensity);

        private static void RegisterChangeIntensityDelegate()
        {
            NativeRegisterDelegate(CallChangeIntensity);
        }

        [DllImport("__Internal", EntryPoint = "UaaLExample_NativeProxy_NativeReady")]
        private static extern void NativeReady();

        [DllImport("__Internal", EntryPoint = "UaaLExample_NativeProxy_NativeSetIntensity")]
        private static extern void NativeSetIntensity(float intensity);

        [DllImport("__Internal", EntryPoint = "UaaLExample_NativeProxy_NativeRegisterDelegate")]
        private static extern void NativeRegisterDelegate(OnChangeIntensityDelegate onChangeIntensity);

        [AOT.MonoPInvokeCallbackAttribute(typeof(OnChangeIntensityDelegate))]
        private static void CallChangeIntensity(float intensity)
        {
            OnChangeIntensityInternal?.Invoke(intensity);
        }

        [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
        private delegate void OnChangeIntensityDelegate([MarshalAs(UnmanagedType.R4)] Single intensity);
    }
}
#endif
