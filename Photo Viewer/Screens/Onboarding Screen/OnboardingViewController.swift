import UIKit
import RxSwift
import RxCocoa

class OnboardingViewController: BaseViewController {

    private let viewModel: OnboardingViewModel
    private let disposeBag = DisposeBag()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitleColor(.main, for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = .button
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return button
    }()

    let scrollView = UIScrollView()

    init(provider: PhotosProvider) {
        viewModel = OnboardingViewModel(provider: provider)
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.provider.isAuthorized {
            viewModel.state.accept(.wait)
        }
    }

    internal override func configureProperties() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }

    internal override func configureLayout() {

        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20),
        ])

        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor),
        ])

    }

    internal override func configureReactiveBinding() {
        viewModel.lastMessage.asObservable()
            .filter { $0 != nil }
            .map { MessageView(text: $0?.text ?? "", outgoing: $0?.outgoing ?? false) }
            .subscribe(onNext: { [weak self] messageView in
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.stackView.addArrangedSubview(messageView)
                }, completion: { [weak self] _ in
                    guard let scrollView = self?.scrollView,
                        scrollView.contentSize.height > scrollView.bounds.size.height
                    else { return }
                    let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
                    scrollView.setContentOffset(bottomOffset, animated: true)
                })
            })
            .disposed(by: disposeBag)

        viewModel.state.asObservable()
            .subscribe(onNext: { [weak self] state in
                switch state {
                case .wait:
                    self?.button.isHidden = true
                    return
                case .login:
                    guard let button = self?.button else { return }
                    button.setTitle("Log in".localized, for: .normal)
                    self?.button.isHidden = false
                    return
                case .continue:
                    guard let button = self?.button else { return }
                    button.setTitle("Continue".localized, for: .normal)
                    self?.button.isHidden = false
                    return
                }
            })
            .disposed(by: disposeBag)

        button.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                switch strongSelf.viewModel.state.value {
                case .login:
                    strongSelf.viewModel.provider.authorize(parentController: strongSelf)
                    return
                case .wait:
                    return
                case .continue:
                    FlowController.shared.loadHomeController()
                }
            })
            .disposed(by: disposeBag)
    }
}
