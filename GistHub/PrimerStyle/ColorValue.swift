//
//  ColorValue.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import SwiftUI

/// A platform-agnostic representation of a 32-bit RGBA color value.
public struct ColorValue: Equatable {

    public static let clear: ColorValue = .init(r: 0.0, g: 0.0, b: 0.0, a: 0.0)

    /// Creates a color value instance with the specified three-channel, 8-bit-per-channel color value, usually in hex.
    ///
    /// For example: `0xFF0000` represents red, `0x00FF00` green, and `0x0000FF` blue.
    /// There is no way to specify an alpha channel via this initializer. For that, use `init(r:g:b:a)` instead.
    ///
    /// - Parameter hexValue: The color value to store, in 24-bit (three-channel, 8-bit) RGB.
    ///
    /// - Returns: A color object that stores the provided color information.
    public init(_ hexValue: UInt32) {
        self.hexValue = hexValue << 8 | 0xFF
    }

    /// Creates a color value instance with the specified channel values.
    ///
    /// Parameters work just like `UIColor`, `NSColor`, or `SwiftUI.Color`, and should all be in the range of `0.0 ≤ value ≤ 1.0`.
    /// Any channel that is above 1.0 will be clipped down to 1.0; results are undefined for negative inputs.
    ///
    /// - Parameter r: The red channel.
    /// - Parameter g: The green channel.
    /// - Parameter b: The blue channel.
    /// - Parameter a: The alpha channel.
    ///
    /// - Returns: A color object that stores the provided color information.
    public init(
        r: CGFloat,
        g: CGFloat,
        b: CGFloat,
        a: CGFloat
    ) {
        hexValue = (min(UInt32(r * 255.0), 0xFF) << 24) |
                   (min(UInt32(g * 255.0), 0xFF) << 16) |
                   (min(UInt32(b * 255.0), 0xFF) << 8) |
                   (min(UInt32(a * 255.0), 0xFF))
    }

    var r: CGFloat { CGFloat((hexValue & 0xFF000000) >> 24) / 255.0 }
    var g: CGFloat { CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0 }
    var b: CGFloat { CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0 }
    var a: CGFloat { CGFloat(hexValue & 0x000000FF) / 255.0 }

    // Value is stored in RGBA format.
    private let hexValue: UInt32
}

extension Color {
    /// Creates a Color from a `ColorValue` instance.
    ///
    /// - Parameter colorValue: Color value to use to initialize this color.
    init(colorValue: ColorValue) {
        self.init(UIColor(colorValue: colorValue))
    }
}
