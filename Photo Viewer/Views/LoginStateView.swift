import UIKit

class LoginStateView: UIView {
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

    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("LOGIN".localized, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .main
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = .button
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.addTarget(self, action: #selector(onLoginButtonAction), for: .touchUpInside)
        return button
    }()

    private var onButtonClick: (() -> ())?

    init(with infoText: String, size: CGSize, onButtonClick: (() -> ())? ) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: size))
        self.onButtonClick = onButtonClick
        infoLabel.text = infoText
        addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            infoLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30)
        ])
        addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 16),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func onLoginButtonAction() {
        onButtonClick?()
    }
}
