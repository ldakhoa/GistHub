//
//  UIColor+Extensions.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

#if canImport(UIKit)
import UIKit
#endif

extension UIColor {

    /// Creates a UIColor from a `ColorValue` instance.
    ///
    /// - Parameter colorValue: Color value to use to initialize this color.
    public convenience init(colorValue: ColorValue) {
        self.init(
            red: colorValue.r,
            green: colorValue.g,
            blue: colorValue.b,
            alpha: colorValue.a)
    }

    public convenience init(light: UIColor, dark: UIColor) {
        self.init { traits -> UIColor in
            if traits.userInterfaceStyle == .light {
                return light
            } else {
                return dark
            }
        }
    }

    private var colorValue: ColorValue? {
        var redValue: CGFloat = 1.0
        var greenValue: CGFloat = 1.0
        var blueValue: CGFloat = 1.0
        var alphaValue: CGFloat = 1.0
        if self.getRed(&redValue, green: &greenValue, blue: &blueValue, alpha: &alphaValue) {
            let colorValue = ColorValue(r: redValue, g: greenValue, b: blueValue, a: alphaValue)
            return colorValue
        } else {
            return nil
        }
    }

    public var hexString: String {
        let cgColorInRGB = cgColor.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil)!
        let colorRef = cgColorInRGB.components
        let r = colorRef?[0] ?? 0
        let g = colorRef?[1] ?? 0
        let b = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : g) ?? 0
        let a = cgColor.alpha

        var color = String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )

        if a < 1 {
            color += String(format: "%02lX", lroundf(Float(a * 255)))
        }

        return color
    }
}
