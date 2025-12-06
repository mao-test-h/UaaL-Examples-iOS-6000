using System;
using UnityEngine;

namespace _Example.NativeProxy
{
    internal sealed class NativeProxyForEditor : INativeProxy
    {
        public event Action<float> OnChangeIntensity = null;

        public void Initialize()
        {
            Debug.Log("NativeProxyForEditor Initialize");
        }

        public void SetIntensity(float intensity)
        {
            Debug.Log("NativeProxyForEditor SetIntensity");
        }

        public void Dispose()
        {
        }
    }
}
