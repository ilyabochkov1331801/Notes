import UIKit.UIColor

extension UIColor {
    func colorComponents() -> Array<CGFloat> {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let colorComponents = [ red, green, blue, alpha ]
        return colorComponents
    }
}
