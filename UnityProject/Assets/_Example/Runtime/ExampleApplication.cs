using _Example.NativeProxy;
using UnityEngine;
using UnityEngine.UIElements;

namespace _Example
{
    internal sealed class ExampleApplication : MonoBehaviour
    {
        [SerializeField] private UIDocument uiDocument;
        [SerializeField] private Rotation rotationObj;

        private readonly INativeProxy _nativeProxy = NativeProxyFactory.Create();
        private Slider _intensitySlider;

        private void Awake()
        {
            _nativeProxy.Initialize();
        }

        private void Start()
        {
            var root = uiDocument.rootVisualElement;
            _intensitySlider = root.Q<Slider>("intensity-slider");

            _intensitySlider.SetValueWithoutNotify(rotationObj.intensity);
            _intensitySlider.RegisterValueChangedCallback(OnSliderValueChange);

            _nativeProxy.OnChangeIntensity += intensity =>
            {
                _intensitySlider.SetValueWithoutNotify(intensity);
                rotationObj.intensity = intensity;
            };
        }

        private void OnSliderValueChange(ChangeEvent<float> evt)
        {
            _nativeProxy.SetIntensity(evt.newValue);
            rotationObj.intensity = evt.newValue;
        }
    }
}
