//
//  Colors.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import UIKit
import SwiftUI

final class Colors {
    public enum Palette {
        enum Blue {
            case blue0
            case blue1
            case blue2
            case blue3
            case blue4
            case blue5
            case blue6
            case blue7
            case blue8
            case blue9

            var light: UIColor {
                switch self {
                case .blue0: return UIColor(colorValue: ColorValue(0xddf4ff))
                case .blue1: return UIColor(colorValue: ColorValue(0xb6e3ff))
                case .blue2: return UIColor(colorValue: ColorValue(0x80ccff))
                case .blue3: return UIColor(colorValue: ColorValue(0x54aeff))
                case .blue4: return UIColor(colorValue: ColorValue(0x218bff))
                case .blue5: return UIColor(colorValue: ColorValue(0x0969da))
                case .blue6: return UIColor(colorValue: ColorValue(0x0550ae))
                case .blue7: return UIColor(colorValue: ColorValue(0x033d8b))
                case .blue8: return UIColor(colorValue: ColorValue(0x0a3069))
                case .blue9: return UIColor(colorValue: ColorValue(0x002155))
                }
            }

            var dark: UIColor {
                switch self {
                case .blue0: return UIColor(colorValue: ColorValue(0xc6e6ff))
                case .blue1: return UIColor(colorValue: ColorValue(0x96d0ff))
                case .blue2: return UIColor(colorValue: ColorValue(0x6cb6ff))
                case .blue3: return UIColor(colorValue: ColorValue(0x539bf5))
                case .blue4: return UIColor(colorValue: ColorValue(0x4184e4))
                case .blue5: return UIColor(colorValue: ColorValue(0x316dca))
                case .blue6: return UIColor(colorValue: ColorValue(0x255ab2))
                case .blue7: return UIColor(colorValue: ColorValue(0x1b4b91))
                case .blue8: return UIColor(colorValue: ColorValue(0x143d79))
                case .blue9: return UIColor(colorValue: ColorValue(0x0f2d5c))
                }
            }

            var dynamicColor: UIColor {
                UIColor(light: self.light, dark: self.dark)
            }
        }

        enum Gray {
            case gray0
            case gray1
            case gray2
            case gray3
            case gray4
            case gray5
            case gray6
            case gray7
            case gray8
            case gray9

            var light: UIColor {
                switch self {
                case .gray0: return UIColor(colorValue: ColorValue(0xf6f8fa))
                case .gray1: return UIColor(colorValue: ColorValue(0xeaeef2))
                case .gray2: return UIColor(colorValue: ColorValue(0xd0d7de))
                case .gray3: return UIColor(colorValue: ColorValue(0xafb8c1))
                case .gray4: return UIColor(colorValue: ColorValue(0x8c959f))
                case .gray5: return UIColor(colorValue: ColorValue(0x6e7781))
                case .gray6: return UIColor(colorValue: ColorValue(0x57606a))
                case .gray7: return UIColor(colorValue: ColorValue(0x424a53))
                case .gray8: return UIColor(colorValue: ColorValue(0x32383f))
                case .gray9: return UIColor(colorValue: ColorValue(0x24292f))
                }
            }

            var dark: UIColor {
                switch self {
                case .gray0: return UIColor(colorValue: ColorValue(0xcdd9e5))
                case .gray1: return UIColor(colorValue: ColorValue(0xadbac7))
                case .gray2: return UIColor(colorValue: ColorValue(0x909dab))
                case .gray3: return UIColor(colorValue: ColorValue(0x768390))
                case .gray4: return UIColor(colorValue: ColorValue(0x636e7b))
                case .gray5: return UIColor(colorValue: ColorValue(0x545d68))
                case .gray6: return UIColor(colorValue: ColorValue(0x444c56))
                case .gray7: return UIColor(colorValue: ColorValue(0x373e47))
                case .gray8: return UIColor(colorValue: ColorValue(0x2d333b))
                case .gray9: return UIColor(colorValue: ColorValue(0x22272e))
                }
            }

            var dynamicColor: UIColor {
                UIColor(light: self.light, dark: self.dark)
            }
        }

        enum Green {
            case green0
            case green1
            case green2
            case green3
            case green4
            case green5
            case green6
            case green7
            case green8
            case green9

            var light: UIColor {
                switch self {
                case .green0: return UIColor(colorValue: ColorValue(0xdafbe1))
                case .green1: return UIColor(colorValue: ColorValue(0xaceebb))
                case .green2: return UIColor(colorValue: ColorValue(0x6fdd8b))
                case .green3: return UIColor(colorValue: ColorValue(0x4ac26b))
                case .green4: return UIColor(colorValue: ColorValue(0x2da44e))
                case .green5: return UIColor(colorValue: ColorValue(0x1a7f37))
                case .green6: return UIColor(colorValue: ColorValue(0x116329))
                case .green7: return UIColor(colorValue: ColorValue(0x044f1e))
                case .green8: return UIColor(colorValue: ColorValue(0x003d16))
                case .green9: return UIColor(colorValue: ColorValue(0x002d11))
                }
            }
            var dark: UIColor {
                switch self {
                case .green0: return UIColor(colorValue: ColorValue(0xb4f1b4))
                case .green1: return UIColor(colorValue: ColorValue(0x8ddb8c))
                case .green2: return UIColor(colorValue: ColorValue(0x6bc46d))
                case .green3: return UIColor(colorValue: ColorValue(0x57ab5a))
                case .green4: return UIColor(colorValue: ColorValue(0x46954a))
                case .green5: return UIColor(colorValue: ColorValue(0x347d39))
                case .green6: return UIColor(colorValue: ColorValue(0x2b6a30))
                case .green7: return UIColor(colorValue: ColorValue(0x245829))
                case .green8: return UIColor(colorValue: ColorValue(0x1b4721))
                case .green9: return UIColor(colorValue: ColorValue(0x113417))
                }
            }
            var dynamicColor: UIColor {
                UIColor(light: self.light, dark: self.dark)
            }
        }

        enum Pink {
            case pink0
            case pink1
            case pink2
            case pink3
            case pink4
            case pink5
            case pink6
            case pink7
            case pink8
            case pink9

            var light: UIColor {
                switch self {
                case .pink0: return UIColor(colorValue: ColorValue(0xffeff7))
                case .pink1: return UIColor(colorValue: ColorValue(0xffd3eb))
                case .pink2: return UIColor(colorValue: ColorValue(0xffadda))
                case .pink3: return UIColor(colorValue: ColorValue(0xff80c8))
                case .pink4: return UIColor(colorValue: ColorValue(0xe85aad))
                case .pink5: return UIColor(colorValue: ColorValue(0xbf3989))
                case .pink6: return UIColor(colorValue: ColorValue(0x99286e))
                case .pink7: return UIColor(colorValue: ColorValue(0x772057))
                case .pink8: return UIColor(colorValue: ColorValue(0x611347))
                case .pink9: return UIColor(colorValue: ColorValue(0x4d0336))
                }
            }

            var dark: UIColor {
                switch self {
                case .pink0: return UIColor(colorValue: ColorValue(0xffd7eb))
                case .pink1: return UIColor(colorValue: ColorValue(0xffb3d8))
                case .pink2: return UIColor(colorValue: ColorValue(0xfc8dc7))
                case .pink3: return UIColor(colorValue: ColorValue(0xe275ad))
                case .pink4: return UIColor(colorValue: ColorValue(0xc96198))
                case .pink5: return UIColor(colorValue: ColorValue(0xae4c82))
                case .pink6: return UIColor(colorValue: ColorValue(0x983b6e))
                case .pink7: return UIColor(colorValue: ColorValue(0x7e325a))
                case .pink8: return UIColor(colorValue: ColorValue(0x69264a))
                case .pink9: return UIColor(colorValue: ColorValue(0x551639))
                }
            }

            var dynamicColor: UIColor {
                UIColor(light: self.light, dark: self.dark)
            }
        }

        enum Purple {
            case purple0
            case purple1
            case purple2
            case purple3
            case purple4
            case purple5
            case purple6
            case purple7
            case purple8
            case purple9

            var light: UIColor {
                switch self {
                case .purple0: return UIColor(colorValue: ColorValue(0xfbefff))
                case .purple1: return UIColor(colorValue: ColorValue(0xecd8ff))
                case .purple2: return UIColor(colorValue: ColorValue(0xd8b9ff))
                case .purple3: return UIColor(colorValue: ColorValue(0xc297ff))
                case .purple4: return UIColor(colorValue: ColorValue(0xa475f9))
                case .purple5: return UIColor(colorValue: ColorValue(0x8250df))
                case .purple6: return UIColor(colorValue: ColorValue(0x6639ba))
                case .purple7: return UIColor(colorValue: ColorValue(0x512a97))
                case .purple8: return UIColor(colorValue: ColorValue(0x3e1f79))
                case .purple9: return UIColor(colorValue: ColorValue(0x2e1461))
                }
            }

            var dark: UIColor {
                switch self {
                case .purple0: return UIColor(colorValue: ColorValue(0xeedcff))
                case .purple1: return UIColor(colorValue: ColorValue(0xdcbdfb))
                case .purple2: return UIColor(colorValue: ColorValue(0xdcbdfb))
                case .purple3: return UIColor(colorValue: ColorValue(0xb083f0))
                case .purple4: return UIColor(colorValue: ColorValue(0x986ee2))
                case .purple5: return UIColor(colorValue: ColorValue(0x8256d0))
                case .purple6: return UIColor(colorValue: ColorValue(0x6b44bc))
                case .purple7: return UIColor(colorValue: ColorValue(0x5936a2))
                case .purple8: return UIColor(colorValue: ColorValue(0x472c82))
                case .purple9: return UIColor(colorValue: ColorValue(0x352160))
                }
            }

            var dynamicColor: UIColor {
                UIColor(light: self.light, dark: self.dark)
            }
        }

        enum Red {
            case red0
            case red1
            case red2
            case red3
            case red4
            case red5
            case red6
            case red7
            case red8
            case red9

            var light: UIColor {
                switch self {
                case .red0: return UIColor(colorValue: ColorValue(0xffebe9))
                case .red1: return UIColor(colorValue: ColorValue(0xffcecb))
                case .red2: return UIColor(colorValue: ColorValue(0xffaba8))
                case .red3: return UIColor(colorValue: ColorValue(0xff8182))
                case .red4: return UIColor(colorValue: ColorValue(0xfa4549))
                case .red5: return UIColor(colorValue: ColorValue(0xcf222e))
                case .red6: return UIColor(colorValue: ColorValue(0xa40e26))
                case .red7: return UIColor(colorValue: ColorValue(0x82071e))
                case .red8: return UIColor(colorValue: ColorValue(0x660018))
                case .red9: return UIColor(colorValue: ColorValue(0x4c0014))
                }
            }

            var dark: UIColor {
                switch self {
                case .red0: return UIColor(colorValue: ColorValue(0xffd8d3))
                case .red1: return UIColor(colorValue: ColorValue(0xffb8b0))
                case .red2: return UIColor(colorValue: ColorValue(0xff938a))
                case .red3: return UIColor(colorValue: ColorValue(0xf47067))
                case .red4: return UIColor(colorValue: ColorValue(0xe5534b))
                case .red5: return UIColor(colorValue: ColorValue(0xc93c37))
                case .red6: return UIColor(colorValue: ColorValue(0xad2e2c))
                case .red7: return UIColor(colorValue: ColorValue(0x922323))
                case .red8: return UIColor(colorValue: ColorValue(0x78191b))
                case .red9: return UIColor(colorValue: ColorValue(0x5d0f12))
                }
            }

            var dynamicColor: UIColor {
                UIColor(light: self.light, dark: self.dark)
            }
        }

        enum Yellow {
            case yellow0
            case yellow1
            case yellow2
            case yellow3
            case yellow4
            case yellow5
            case yellow6
            case yellow7
            case yellow8
            case yellow9

            var light: UIColor {
                switch self {
                case .yellow0: return UIColor(colorValue: ColorValue(0xfff8c5))
                case .yellow1: return UIColor(colorValue: ColorValue(0xfae17d))
                case .yellow2: return UIColor(colorValue: ColorValue(0xeac54f))
                case .yellow3: return UIColor(colorValue: ColorValue(0xd4a72c))
                case .yellow4: return UIColor(colorValue: ColorValue(0xbf8700))
                case .yellow5: return UIColor(colorValue: ColorValue(0x9a6700))
                case .yellow6: return UIColor(colorValue: ColorValue(0x7d4e00))
                case .yellow7: return UIColor(colorValue: ColorValue(0x633c01))
                case .yellow8: return UIColor(colorValue: ColorValue(0x4d2d00))
                case .yellow9: return UIColor(colorValue: ColorValue(0x3b2300))
                }
            }

            var dark: UIColor {
                switch self {
                case .yellow0: return UIColor(colorValue: ColorValue(0xfbe090))
                case .yellow1: return UIColor(colorValue: ColorValue(0xeac55f))
                case .yellow2: return UIColor(colorValue: ColorValue(0xdaaa3f))
                case .yellow3: return UIColor(colorValue: ColorValue(0xc69026))
                case .yellow4: return UIColor(colorValue: ColorValue(0xae7c14))
                case .yellow5: return UIColor(colorValue: ColorValue(0x966600))
                case .yellow6: return UIColor(colorValue: ColorValue(0x805400))
                case .yellow7: return UIColor(colorValue: ColorValue(0x6c4400))
                case .yellow8: return UIColor(colorValue: ColorValue(0x593600))
                case .yellow9: return UIColor(colorValue: ColorValue(0x452700))
                }
            }

            var dynamicColor: UIColor {
                UIColor(light: self.light, dark: self.dark)
            }
        }

        enum Orange {
            case orange0
            case orange1
            case orange2
            case orange3
            case orange4
            case orange5
            case orange6
            case orange7
            case orange8
            case orange9

            var light: UIColor {
                switch self {
                case .orange0: return UIColor(colorValue: ColorValue(0xfff1e5))
                case .orange1: return UIColor(colorValue: ColorValue(0xffd8b5))
                case .orange2: return UIColor(colorValue: ColorValue(0xffb77c))
                case .orange3: return UIColor(colorValue: ColorValue(0xfb8f44))
                case .orange4: return UIColor(colorValue: ColorValue(0xe16f24))
                case .orange5: return UIColor(colorValue: ColorValue(0xbc4c00))
                case .orange6: return UIColor(colorValue: ColorValue(0x953800))
                case .orange7: return UIColor(colorValue: ColorValue(0x762c00))
                case .orange8: return UIColor(colorValue: ColorValue(0x5c2200))
                case .orange9: return UIColor(colorValue: ColorValue(0x471700))
                }
            }

            var dark: UIColor {
                switch self {
                case .orange0: return UIColor(colorValue: ColorValue(0xffddb0))
                case .orange1: return UIColor(colorValue: ColorValue(0xffbc6f))
                case .orange2: return UIColor(colorValue: ColorValue(0xf69d50))
                case .orange3: return UIColor(colorValue: ColorValue(0xe0823d))
                case .orange4: return UIColor(colorValue: ColorValue(0xcc6b2c))
                case .orange5: return UIColor(colorValue: ColorValue(0xae5622))
                case .orange6: return UIColor(colorValue: ColorValue(0x94471b))
                case .orange7: return UIColor(colorValue: ColorValue(0x7f3913))
                case .orange8: return UIColor(colorValue: ColorValue(0x682d0f))
                case .orange9: return UIColor(colorValue: ColorValue(0x4d210c))
                }
            }

            var dynamicColor: UIColor {
                UIColor(light: self.light, dark: self.dark)
            }
        }

        enum Black {
            case black0
            var light: UIColor {
                switch self {
                case .black0: return UIColor(colorValue: ColorValue(0x1b1f24))
                }
            }
            var dark: UIColor {
                switch self {
                case .black0: return UIColor(colorValue: ColorValue(0x1c2128))
                }
            }
            var dynamicColor: UIColor {
                UIColor(light: self.light, dark: self.dark)
            }
        }

        enum White {
            case white0
            var light: UIColor {
                switch self {
                case .white0: return UIColor.white
                }
            }
            var dark: UIColor {
                switch self {
                case .white0: return UIColor(colorValue: ColorValue(0xcdd9e5))
                }
            }
            var dynamicColor: UIColor {
                UIColor(light: self.light, dark: self.dark)
            }
        }
    }

    static var accent = Palette.Blue.blue5.dynamicColor
    static var success = Palette.Green.green5.dynamicColor
    static var danger = Palette.Red.red5.dynamicColor
    static var neutralEmphasisPlus = UIColor(light: Palette.Gray.gray9.light, dark: Palette.Gray.gray1.dark)
    static var neutralEmphasis = Palette.Gray.gray5.dynamicColor
    static var listBackground = UIColor.secondarySystemGroupedBackground

    static var buttonBackground = UIColor(light: Palette.Gray.gray0.light, dark: Palette.Gray.gray7.dark)
    static var buttonForeground = UIColor(light: Palette.Gray.gray9.light, dark: Palette.Gray.gray1.dark)
    static var buttonBorder = UIColor(light: Palette.Gray.gray2.light, dark: Palette.Gray.gray6.dark)
}

extension UIColor {
    var color: Color {
        Color(self)
    }
}
