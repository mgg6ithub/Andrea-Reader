
import UIKit
import SwiftUI

private struct RGBA: Equatable {
    let r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat
}

private extension UIColor {
    var rgba: RGBA? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return RGBA(r: r, g: g, b: b, a: a)
    }
}

func colorsEqual(_ a: Color, _ b: Color, epsilon: CGFloat = 0.001) -> Bool {
    guard let aa = UIColor(a).rgba, let bb = UIColor(b).rgba else { return false }
    return abs(aa.r - bb.r) < epsilon &&
           abs(aa.g - bb.g) < epsilon &&
           abs(aa.b - bb.b) < epsilon &&
           abs(aa.a - bb.a) < epsilon
}
