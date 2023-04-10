//
//  SliderTableViewCell.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 10.04.2023.
//

import UIKit

class SliderTableViewCell: UITableViewCell {
    
    let minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 70
        return slider
    }()
    
    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 70
        return slider
    }()
    
    let minLabel: UILabel = {
        let label = AgeRangeLabel()
        label.text = "Min: 18"
        return label
    }()
    
    let maxLabel: UILabel = {
        let label = AgeRangeLabel()
        label.text = "Max: 70"
        return label
    }()
    
    class AgeRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureStackView()
    }
    
    private func configureStackView() {
        let stackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLabel, minSlider]),
            UIStackView(arrangedSubviews: [maxLabel, maxSlider])
        ])
        contentView.becomeFirstResponder()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
