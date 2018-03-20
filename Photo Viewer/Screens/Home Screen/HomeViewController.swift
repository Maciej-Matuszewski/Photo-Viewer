import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class HomeViewController: BaseViewController {

    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()

    private let refreshControl = UIRefreshControl()

    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search".localized
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        return searchController
    }()

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

    fileprivate lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        indicatorView.color = .main
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        return indicatorView
    }()

    fileprivate var emptyStateView: UIView {
        let viewSize = CGSize(
            width: view.frame.width,
            height: 300
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
        navigationItem.searchController = searchController
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
        let emptySearchObserver = searchController.searchBar.rx.text.filter { $0?.isEmpty ?? false }.map { _ in return () }
        //TO-DO: Change Notification.name
        let authorizationObserver = NotificationCenter.default.rx.notification(Notification.Name(rawValue: "AuthorizationStateHasBeenChangedNotification")).asObservable().map { _ in return () }

        Observable.of(refreshObserver, providerObserver, authorizationObserver, emptySearchObserver)
            .merge()
            .throttle(2, latest: true, scheduler: MainScheduler.instance)
            .flatMap { [unowned self] _ in return self.viewModel.currentPhotosProvider.asObservable() }
            .filter { $0.isAuthorized }
            .flatMap {$0.getPhotos(searchPhrase: nil)}
            .bind(to: viewModel.photos)
            .disposed(by: disposeBag)

        viewModel.photos.asObservable()
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] photos in
                self?.refreshControl.endRefreshing()
                self?.tableView.tableHeaderView = photos.isEmpty ? self?.emptyStateView : nil
                self?.tableView.tableFooterView = self?.viewModel.currentPhotosProvider.value.hasMore ?? false ? self?.loadingIndicatorView : UIView()
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

        tableView.rx.willDisplayCell
            .map { $0.indexPath }
            .filter { [unowned self] indexPath -> Bool in
                return indexPath.row == self.viewModel.photos.value.count - 1 && self.viewModel.currentPhotosProvider.value.hasMore
            }
            .flatMap { [unowned self] _ -> Observable<[PhotoModel]> in self.viewModel.currentPhotosProvider.value.getNextPage() }
            .map { [unowned self] models -> [PhotoModel] in
                var currentPhotos = self.viewModel.photos.value
                currentPhotos.append(contentsOf: models)
                return currentPhotos
            }
            .bind(to: viewModel.photos)
            .disposed(by: disposeBag)

        viewModel.currentPhotosProvider.asObservable()
            .map { $0.serviceName }
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(PhotoModel.self)
            .asObservable()
            .map { PhotoPreviewViewController(photoModel: $0) }
            .subscribe(onNext: { [weak self] controller in
                if self?.searchController.isActive ?? false {
                    self?.searchController.present(controller, animated: true, completion: nil)
                } else {
                    self?.present(controller, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)

        searchController.searchBar.rx.text.asObservable()
            .map { ($0 ?? "").lowercased() }
            .throttle(1.5, latest: true, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .flatMap { [unowned self] searchPhrase in
                return self.viewModel.currentPhotosProvider.value.getPhotos(searchPhrase: searchPhrase)
            }
            .bind(to: viewModel.photos)
            .disposed(by: disposeBag)

        Observable
            .from([
                NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillShow)
                    .map { notification -> CGFloat in
                        (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                    },
                NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillHide)
                    .map { _ -> CGFloat in
                        0
                    }
                ])
            .merge()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] keyboardHeight in
                self?.tableView.contentInset.bottom = keyboardHeight != 0 ? keyboardHeight : self?.view.safeAreaInsets.bottom ?? 0
            })
            .disposed(by: disposeBag)
    }
}
