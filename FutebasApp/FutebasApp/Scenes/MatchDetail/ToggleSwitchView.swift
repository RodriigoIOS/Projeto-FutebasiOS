//
//  ToggleSwitchView.swift
//  FutebasApp
//
//  Created by Rodrigo Rocha on 19/07/26.
//

import UIKit

/// Pill + knob custom (o toggle "Goleiro fixo" do protótipo é mais fino
/// que o UISwitch nativo, então reproduzimos o desenho aqui).
final class ToggleSwitchView: UIControl {

    private(set) var isOn: Bool = false

    private let track = UIView()
    private let knob = UIView()
    private var knobLeadingConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        track.backgroundColor = FutebasColors.border
        track.layer.cornerRadius = 11
        track.isUserInteractionEnabled = false

        knob.backgroundColor = .white
        knob.layer.cornerRadius = 9
        knob.layer.shadowColor = UIColor.black.cgColor
        knob.layer.shadowOpacity = 0.25
        knob.layer.shadowRadius = 1
        knob.layer.shadowOffset = CGSize(width: 0, height: 1)
        knob.isUserInteractionEnabled = false

        addSubview(track)
        track.addSubview(knob)
        track.translatesAutoresizingMaskIntoConstraints = false
        knob.translatesAutoresizingMaskIntoConstraints = false

        knobLeadingConstraint = knob.leadingAnchor.constraint(equalTo: track.leadingAnchor, constant: 2)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 38),
            heightAnchor.constraint(equalToConstant: 22),

            track.topAnchor.constraint(equalTo: topAnchor),
            track.bottomAnchor.constraint(equalTo: bottomAnchor),
            track.leadingAnchor.constraint(equalTo: leadingAnchor),
            track.trailingAnchor.constraint(equalTo: trailingAnchor),

            knob.widthAnchor.constraint(equalToConstant: 18),
            knob.heightAnchor.constraint(equalToConstant: 18),
            knob.centerYAnchor.constraint(equalTo: track.centerYAnchor),
            knobLeadingConstraint,
        ])

        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    func setOn(_ on: Bool, animated: Bool) {
        isOn = on
        knobLeadingConstraint.constant = on ? 18 : 2
        track.backgroundColor = on ? FutebasColors.primary : FutebasColors.border
        let animation = { self.layoutIfNeeded() }
        if animated {
            UIView.animate(withDuration: 0.15, animations: animation)
        } else {
            animation()
        }
    }

    @objc private func didTap() {
        sendActions(for: .valueChanged)
    }
}
