using System;
using UnityEngine;

namespace _Example.NativeProxy
{
    internal sealed class NativeProxyForEditor : INativeProxy
    {
        public event Action<float> OnChangeIntensity = null;

        public void Ready()
        {
            Debug.Log("NativeProxyForEditor Ready");
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
