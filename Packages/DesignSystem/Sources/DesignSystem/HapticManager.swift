import CoreHaptics
import UIKit

public class HapticManager {
    public static let shared: HapticManager = .init()

    public enum HapticType {
        case tabSelection
        case dataRefresh
        case buttonPress
    }

    private let selectionGenerator = UISelectionFeedbackGenerator()
    private let impactGenerator = UIImpactFeedbackGenerator(style: .heavy)

    private init() {
      selectionGenerator.prepare()
      impactGenerator.prepare()
    }

    @MainActor
    public func fireHaptic(of type: HapticType) {
        guard supportsHaptics else { return }
        switch type {
        case .tabSelection:
            selectionGenerator.selectionChanged()
        case .dataRefresh:
            impactGenerator.impactOccurred()
        case .buttonPress:
            impactGenerator.impactOccurred()
        }
    }

    private var supportsHaptics: Bool {
      CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }
}
