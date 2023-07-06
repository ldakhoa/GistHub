import SwiftUI
import AlertToast

extension View {
    public func toastError(
        isPresenting: Binding<Bool>,
        error: String,
        displayMode: AlertToast.DisplayMode = .banner(.pop),
        duration: Double = 2.5
    ) -> some View {
        self.toast(isPresenting: isPresenting) {
            AlertToast(
                displayMode: displayMode,
                type: .error(Colors.danger.color),
                title: error,
                style: .style(backgroundColor: Colors.errorToastBackground.color)
            )
        }
    }
}
