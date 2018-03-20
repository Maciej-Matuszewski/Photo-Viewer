import UIKit

class MessageView: UIView {

    let backgroundImageView: UIImageView = {
        let image = UIImage(named: "messageBubble")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .main
        return imageView
    }()

    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .body
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    init(text: String, outgoing: Bool = false) {
        super.init(frame: CGRect.zero)
        addSubview(backgroundImageView)
        if outgoing {
            backgroundImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
            backgroundImageView.tintColor = .white
            label.transform = CGAffineTransform(scaleX: -1, y: 1)
            label.textColor = .main
            NSLayoutConstraint.activate([
                backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
                backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor),
                backgroundImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -13)
            ])
        } else {
            NSLayoutConstraint.activate([
                backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
                backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor),
                backgroundImageView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor),
                backgroundImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -13)
            ])
        }

        backgroundImageView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 12),
            label.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 26),
            label.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -13)
        ])

        label.text = text
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
