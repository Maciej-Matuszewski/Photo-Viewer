import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class PhotoPreviewViewController: BaseViewController {

    private let disposeBag = DisposeBag()
    private let photo: BehaviorRelay<PhotoModel>
    fileprivate var startTransform: CGAffineTransform = CGAffineTransform.identity

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let pinchGestureRecognizer: UIPinchGestureRecognizer = {
        let gestureRecognizer = UIPinchGestureRecognizer()
        return gestureRecognizer
    }()

    private let panGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer()
        return gestureRecognizer
    }()

    init(photoModel: PhotoModel) {
        photo = BehaviorRelay(value: photoModel)
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func baseConfiguration() {
        view.backgroundColor = .black
    }

    override func configureProperties() {
        imageView.addGestureRecognizer(pinchGestureRecognizer)
        imageView.addGestureRecognizer(panGestureRecognizer)
    }

    override func configureLayout() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func configureReactiveBinding() {
        photo.asObservable()
            .map { $0.imageURL }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] imageURL in
                guard let url = URL(string: imageURL) else { return }
                self?.imageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)

        pinchGestureRecognizer.rx.event
            .subscribe(onNext: { [weak self] gestureRecognizer in
                self?.handle(gestureRecognizer)
            })
            .disposed(by: disposeBag)

        panGestureRecognizer.rx.event
            .subscribe(onNext: { [weak self] gestureRecognizer in
                self?.handle(gestureRecognizer)
            })
            .disposed(by: disposeBag)
    }
}

extension PhotoPreviewViewController {
    fileprivate func handle(_ pinchGestureRecognizer: UIPinchGestureRecognizer) {
        guard let imageView = pinchGestureRecognizer.view as? UIImageView else { return }

        let scale = startTransform.a * pinchGestureRecognizer.scale

        switch pinchGestureRecognizer.state {
        case .began:
            startTransform = imageView.transform
            return

        case .changed:
            let transform = CGAffineTransform(
                a: scale,
                b: imageView.transform.b,
                c: imageView.transform.c,
                d: scale,
                tx: imageView.transform.tx,
                ty: imageView.transform.ty
            )
            imageView.transform = transform
            return

        case .ended:
            transformationEnd(imageView: imageView)
            return

        default:
            return
        }
    }


    fileprivate func handle(_ panGestureRecognizer: UIPanGestureRecognizer) {
        guard let imageView = panGestureRecognizer.view as? UIImageView else { return }

        let translation = CGPoint(
            x: startTransform.tx + panGestureRecognizer.translation(in: imageView).x,
            y: startTransform.ty + panGestureRecognizer.translation(in: imageView).y
        )

        switch panGestureRecognizer.state {
        case .began:
            startTransform = imageView.transform
            return

        case .changed:
            let transform = CGAffineTransform(
                a: imageView.transform.a,
                b: imageView.transform.b,
                c: imageView.transform.c,
                d: imageView.transform.d,
                tx: translation.x,
                ty: translation.y
            )
            imageView.transform = transform
            return

        case .ended:
            transformationEnd(imageView: imageView)
            return

        default:
            return
        }
    }

    private func transformationEnd(imageView: UIImageView) {
        let scale = imageView.frame.size.width / imageView.bounds.size.width
        let endScale = scale > 2.0 ? 2.0 : scale < 1.0 ? 1.0 : scale
        let translation = CGPoint(x: imageView.transform.tx, y: imageView.transform.ty)

        let imageFrame: CGRect = {
            guard let image = imageView.image else { return imageView.frame }

            let imageSize = image.size;
            let frameSize = imageView.frame.size;
            let size: CGSize;

            if imageSize.width < frameSize.width && imageSize.height < frameSize.height {
                size = imageSize
            } else {
                let widthRatio  = imageSize.width / frameSize.width
                let heightRatio = imageSize.height / frameSize.height
                let maxRatio = CGFloat.maximum(widthRatio, heightRatio)
                size = CGSize(width: imageSize.width / maxRatio, height: imageSize.height / maxRatio)
            }
            let origin = CGPoint(x: imageView.center.x - size.width / 2, y: imageView.center.y - size.height / 2)

            return CGRect(origin: origin, size: size)
        }()

        let tx: CGFloat = {
            if imageFrame.size.width <= imageView.bounds.size.width {
                return 0
            } else if (imageFrame.size.width - imageView.bounds.size.width) / 2 < fabs(translation.x) {
                let margin = (imageFrame.size.width - imageView.bounds.size.width) / 2
                return translation.x > 0 ? margin : -margin
            }
            return translation.x
        }()

        let ty: CGFloat = {
            if imageFrame.size.height <= imageView.bounds.size.height {
                if fabs(translation.y) > 240{
                    dismiss(animated: true, completion: nil)
                }
                return 0
            } else if (imageFrame.size.height - imageView.bounds.size.height) / 2 < fabs(translation.y) {
                let margin = (imageFrame.size.height - imageView.bounds.size.height) / 2
                if fabs(translation.y) / 2 > margin {
                    dismiss(animated: true, completion: nil)
                }
                return translation.y > 0 ? margin : -margin
            }
            return translation.y
        }()

        let transform = CGAffineTransform(
            a: endScale,
            b: imageView.transform.b,
            c: imageView.transform.c,
            d: endScale,
            tx: tx,
            ty: ty
        )
        UIView.animate(withDuration: 0.3, animations: {
            imageView.transform = transform
        })
        
    }
}
