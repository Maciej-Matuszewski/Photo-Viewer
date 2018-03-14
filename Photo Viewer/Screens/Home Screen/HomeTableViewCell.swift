import UIKit

class HomeTableViewCell: UITableViewCell {

    private let frontView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.4
        view.layer.shouldRasterize = true
        return view
    }()

    public let loadingIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicatorView.color = .text
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.startAnimating()
        return indicatorView
    }()

    public let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    public let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font =  .title
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear

        addSubview(frontView)
        NSLayoutConstraint.activate([
            frontView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            frontView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            frontView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            frontView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -28)
        ])

        frontView.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: frontView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: frontView.centerYAnchor),
        ])

        addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: frontView.topAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: frontView.leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: frontView.rightAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: frontView.bottomAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 240)

        ])

        backgroundImageView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: backgroundImageView.topAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 8),
            titleLabel.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 0.7),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: backgroundImageView.bottomAnchor, constant: -8)
        ])
    }

    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        loadingIndicator.startAnimating()
        backgroundImageView.image = nil
        titleLabel.text = nil
    }
}
