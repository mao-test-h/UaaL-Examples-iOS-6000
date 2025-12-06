import SwiftUI

/// UaaLのViewをSwiftUIのViewとして扱うやつ
struct UnityView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
#if targetEnvironment(simulator)
        // SimulatorでUaaLを表示したい場合には前者を、CanvasPreviewで表示したい場合には後者を返すようにコードを書き換えて
        let view = UnityBridge.shared.view
        if isCanvasPreview {
            // UaaLの表示領域を分かりやすくするためにダミーで色を塗ってるだけ
            view.backgroundColor = .green
        }
        return view
#else
        return UnityBridge.shared.view
#endif
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // do noting
    }

    // SwiftUIのCanvasPreviewでの実行中かどうかの判定
    private var isCanvasPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

struct UnityView_Previews: PreviewProvider {
    static var previews: some View {
        UnityView()
    }
}
