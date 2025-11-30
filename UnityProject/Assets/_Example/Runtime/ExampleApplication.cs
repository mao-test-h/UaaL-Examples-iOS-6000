using _Example.NativeProxy;
using UnityEngine;
using UnityEngine.UI;

namespace _Example
{
    internal sealed class ExampleApplication : MonoBehaviour
    {
        [SerializeField] private Rotation rotationObj;
        [SerializeField] private Slider intensitySlider;

        private readonly INativeProxy _nativeProxy = NativeProxyFactory.Create();

        private void Awake()
        {
            _nativeProxy.Ready();
        }

        private void Start()
        {
            //intensitySlider.SetValueWithoutNotify(rotationObj.intensity);
            //intensitySlider.onValueChanged.AddListener(OnSliderValueChange);
            _nativeProxy.OnChangeIntensity += intensity =>
            {
                intensitySlider.SetValueWithoutNotify(intensity);
                rotationObj.intensity = intensity;
            };
        }

        private void OnSliderValueChange(float intensity)
        {
            _nativeProxy.SetIntensity(intensity);
            rotationObj.intensity = intensity;
        }
    }
}
