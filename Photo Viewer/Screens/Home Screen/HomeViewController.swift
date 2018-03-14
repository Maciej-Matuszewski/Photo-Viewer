import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class HomeViewController: BaseViewController {

    fileprivate let viewModel = HomeViewModel()
    fileprivate let disposeBag = DisposeBag()

    fileprivate let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = .clear
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func configureProperties() {}

    override func configureLayout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.contentInset.bottom = view.safeAreaInsets.bottom
    }

    override func configureReactiveBinding() {
        viewModel.photos.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "cellIdentifier")) { index, model, cell in
                guard let cell = cell as? HomeTableViewCell else { return }
                cell.titleLabel.text = model.title
                if let imageURL = URL(string: model.imageURL) {
                    cell.backgroundImageView.kf.setImage(with: imageURL, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { [weak cell]  (image, _, _, _) in
                        cell?.titleLabel.textColor = image?.isDark ?? false ? .white : .darkText
                        cell?.loadingIndicator.stopAnimating()
                    })
                }
            }
            .disposed(by: disposeBag)
    }

    override func configureNavigationItem() {}

}
