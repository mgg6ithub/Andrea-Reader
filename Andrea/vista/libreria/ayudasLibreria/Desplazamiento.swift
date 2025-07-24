
import SwiftUI

struct ScrollIndexPreferenceKey: PreferenceKey {
    static var defaultValue: [VisibleIndex] = []
    static func reduce(value: inout [VisibleIndex], nextValue: () -> [VisibleIndex]) {
        let new = nextValue()
        value.append(contentsOf: new)
    }

}

struct VisibleIndex: Equatable {
    let index: Int
    let minY: CGFloat
}
