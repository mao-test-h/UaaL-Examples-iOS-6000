namespace _Example.NativeProxy
{
    public static class NativeProxyFactory
    {
        public static INativeProxy Create()
        {
#if UNITY_EDITOR
            return new NativeProxyForEditor();
#elif UNITY_IOS
            return new NativeProxyIOS();
#else
            throw new NotImplementedException();
#endif
        }
    }
}
