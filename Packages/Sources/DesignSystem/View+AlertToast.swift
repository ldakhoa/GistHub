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

    public func toastSuccess(
        isPresenting: Binding<Bool>,
        title: String,
        subTitle: String? = nil,
        duration: Double = 0.8,
        displayMode: AlertToast.DisplayMode = .banner(.pop),
        type: AlertToast.AlertType = .complete(Colors.success.color),
        completion: (() -> Void)? = nil
    ) -> some View {
        self.toast(isPresenting: isPresenting, duration: duration) {
            AlertToast(
                displayMode: displayMode,
                type: type,
                title: title,
                subTitle: subTitle,
                style: .style(backgroundColor: Colors.toastBackground.color)
            )
        } completion: {
            completion?()
        }
    }

    public func toastLoading(
        isPresenting: Binding<Bool>,
        title: String? = nil,
        subTitle: String? = nil
    ) -> some View {
        self.toast(isPresenting: isPresenting) {
            AlertToast(type: .loading, title: title, subTitle: subTitle)
        }
    }
}
