
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


extension UIColor {
    func toHexString() -> String {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "#%02X%02X%02X", Int(red*255), Int(green*255), Int(blue*255))
    }
}

extension Color {
    var toHexString: String {
        UIColor(self).toHexString()
    }

    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        if scanner.scanHexInt64(&rgb) {
            let r = Double((rgb >> 16) & 0xFF) / 255.0
            let g = Double((rgb >> 8) & 0xFF) / 255.0
            let b = Double(rgb & 0xFF) / 255.0
            self.init(red: r, green: g, blue: b)
        } else {
            self = .blue // fallback color
        }
    }
}
