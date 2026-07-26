//
//  DashedBorder.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import UIKit

/// View com borda tracejada, usada para os placeholders "sem time" e
/// para os botões "+ Adicionar time/jogador" do detalhe da partida.
class DashedBorderView: UIView {

    var dashColor: UIColor = FutebasColors.border { didSet { dashLayer.strokeColor = dashColor.cgColor } }
    var dashCornerRadius: CGFloat = FutebasRadius.medium { didSet { setNeedsLayout() } }

    private let dashLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = nil
        layer.lineDashPattern = [4, 3]
        layer.lineWidth = 1
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        dashLayer.strokeColor = dashColor.cgColor
        layer.addSublayer(dashLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dashLayer.frame = bounds
        dashLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: dashCornerRadius).cgPath
    }
}

final class DashedBorderButton: UIButton {

    var dashColor: UIColor = FutebasColors.border { didSet { dashLayer.strokeColor = dashColor.cgColor } }
    var dashCornerRadius: CGFloat = FutebasRadius.medium { didSet { setNeedsLayout() } }

    private let dashLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = nil
        layer.lineDashPattern = [4, 3]
        layer.lineWidth = 1
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        dashLayer.strokeColor = dashColor.cgColor
        layer.addSublayer(dashLayer)
        tintColor = FutebasColors.primary
        setTitleColor(FutebasColors.primary, for: .normal)
        titleLabel?.font = FutebasTypography.captionBold
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dashLayer.frame = bounds
        dashLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: dashCornerRadius).cgPath
    }

    override var isEnabled: Bool {
        didSet { alpha = isEnabled ? 1 : 0.4 }
    }
}
