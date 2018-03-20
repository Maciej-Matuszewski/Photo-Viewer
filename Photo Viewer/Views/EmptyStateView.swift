import UIKit

class EmptyStateView: UIView {
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font = .title
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    init(with infoText: String, size: CGSize) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: size))
        infoLabel.text = infoText
        addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            infoLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            infoLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
