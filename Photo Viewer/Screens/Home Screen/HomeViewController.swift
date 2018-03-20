import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class HomeViewController: BaseViewController {

    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()

    private let refreshControl = UIRefreshControl()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = .clear
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    fileprivate var emptyStateView: UIView {
        let viewSize = CGSize(
            width: view.frame.width,
            height: tableView.frame.height - (navigationController?.navigationBar.frame.height ?? 0) - (navigationController?.tabBarController?.tabBar.frame.height ?? 0) - 100
        )
        return viewModel.currentPhotosProvider.value.isAuthorized
            ? EmptyStateView(
                with: viewModel.currentPhotosProvider.value.emptyStateInfoText,
                size: viewSize
            )
            : LoginStateView(
                with: "Please login to display photos!".localized,
                size: viewSize,
                onButtonClick: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.viewModel.currentPhotosProvider.value.authorize(parentController: strongSelf)
                }
            )
    }

    init(provider: PhotosProvider) {
        viewModel = HomeViewModel(provider: provider)
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configureProperties() {
        tableView.refreshControl = refreshControl
    }

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

        let refreshObserver = refreshControl.rx.controlEvent(.valueChanged).asObservable().map { return () }
        let providerObserver = viewModel.currentPhotosProvider.asObservable().map { _ in return () }
        //TO-DO: Change Notification.name
        let authorizationObserver = NotificationCenter.default.rx.notification(Notification.Name(rawValue: "AuthorizationStateHasBeenChangedNotification")).asObservable().map { _ in return () }

        Observable.of(refreshObserver, providerObserver, authorizationObserver)
            .merge()
            .flatMap { [unowned self] _ in return self.viewModel.currentPhotosProvider.asObservable() }
            .filter { $0.isAuthorized }
            .flatMap {$0.getPhotos(page: nil, searchPhrase: nil)}
            .bind(to: viewModel.photos)
            .disposed(by: disposeBag)

        viewModel.photos.asObservable()
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] photos in
                self?.refreshControl.endRefreshing()
                self?.tableView.tableHeaderView = photos.isEmpty ? self?.emptyStateView : nil
            })
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

        viewModel.currentPhotosProvider.asObservable()
            .map { $0.serviceName }
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(PhotoModel.self)
            .asObservable()
            .map { PhotoPreviewViewController(photoModel: $0) }
            .subscribe(onNext: { [weak self] controller in
                self?.present(controller, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
