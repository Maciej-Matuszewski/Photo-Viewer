import UIKit

class PhotoPreviewViewControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {

  let duration = 0.6
  var presenting = true
  var originFrame = CGRect.zero

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    let toView = transitionContext.view(forKey: .to)!
    let fromView = transitionContext.view(forKey: .from)!
    containerView.addSubview(toView)

    let frontView = presenting ? toView : fromView
    guard let imageView = frontView.subviews.first as? UIImageView else {
        transitionContext.completeTransition(true)
        return
    }

    if presenting {
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.frame = originFrame
        frontView.backgroundColor = .clear
    }

    containerView.bringSubview(toFront: frontView)

    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: { [unowned self] in
        if self.presenting {
            imageView.frame = UIScreen.main.bounds
            frontView.layer.cornerRadius = 0
            frontView.backgroundColor = .black
            imageView.contentMode = .center
        } else {
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 16
            imageView.frame = self.originFrame
            frontView.backgroundColor = .clear
        }
    }, completion: { _ in
      transitionContext.completeTransition(true)
    })

  }
}
