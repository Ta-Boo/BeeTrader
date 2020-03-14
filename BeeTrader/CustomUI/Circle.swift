import UIKit
@IBDesignable
class Circle: UIView {
    @IBInspectable var mainColor: UIColor = UIColor.blue
    @IBInspectable var ringColor: UIColor = UIColor.orange
    @IBInspectable var ringThickness: CGFloat = 4
    @IBInspectable var isSelected: Bool = true

    override func draw(_ rect: CGRect) {
        let dotPath = UIBezierPath(ovalIn: rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = dotPath.cgPath
        shapeLayer.fillColor = mainColor.cgColor
        layer.addSublayer(shapeLayer)

        if isSelected { drawRingFittingInsideView(rect: rect) }
    }

    internal func drawRingFittingInsideView(rect: CGRect) {
        let hw: CGFloat = ringThickness / 2
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: hw, dy: hw))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = ringColor.cgColor
        shapeLayer.lineWidth = ringThickness
        layer.addSublayer(shapeLayer)
    }
}
