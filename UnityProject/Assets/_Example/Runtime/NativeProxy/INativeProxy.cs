using System;

namespace _Example.NativeProxy
{
    /// <summary>
    /// ネイティブとの呼び出し規約
    /// </summary>
    public interface INativeProxy : IDisposable
    {
        /// <summary>
        /// [Native -> Unity] ネイティブ側で Intensity が変更された際のイベント
        /// </summary>
        event Action<float> OnChangeIntensity;

        /// <summary>
        /// [Unity -> Native] UnityEngine のセットアップ完了通知
        /// </summary>
        void Initialize();

        /// <summary>
        /// [Unity -> Native] Intensity の設定
        /// </summary>
        void SetIntensity(float intensity);
    }
}
