import Foundation
import RxSwift
import RxCocoa

class OnboardingViewModel {
    private let disposeBag = DisposeBag()

    let state: BehaviorRelay<OnboardingState> = BehaviorRelay(value: .wait)
    let lastMessage: BehaviorRelay<MessageStruct?> = BehaviorRelay(value: nil)
    let provider: PhotosProvider

    enum OnboardingState {
        case wait
        case login
        case `continue`
        case waitForResponse
    }

    struct MessageStruct {
        var delay = 0.0
        var text: String
        var state: OnboardingState
        var outgoing: Bool = false
    }

    init(provider: PhotosProvider) {
        self.provider = provider
        let publishSubject = PublishSubject<MessageStruct>()
        var delay = 0.0

        publishSubject
            .flatMap { value -> Observable<MessageStruct> in
                delay = delay + value.delay
                return Observable.just(value).delaySubscription(RxTimeInterval(delay), scheduler: MainScheduler.instance)
            }
            .subscribe(onNext: { [weak self] messageModel in
                self?.state.accept(messageModel.state)
                self?.lastMessage.accept(messageModel)
            })
            .disposed(by: disposeBag)

        [
            MessageStruct(delay: 2.0, text: "Hello 👋".localized, state: .wait, outgoing: false),
            MessageStruct(delay: 2.2, text: "Welcome in Photo Viewer".localized, state: .wait, outgoing: false),
            MessageStruct(delay: 3.0, text: "Here you can keep photos\nfrom different services".localized, state: .wait, outgoing: false),
            MessageStruct(delay: 3.3, text: "Before we can continue you\nneed to authorize yourself.".localized, state: .wait, outgoing: false),
            MessageStruct(delay: 1.4, text: "Let's start with \(provider.serviceName)".localized, state: .login, outgoing: false),
        ].forEach { message in
            publishSubject.onNext(message)
        }

        NotificationCenter.default.rx.notification(Notification.AuthorizationStateHasBeenChanged).asObservable()
            .map { [weak self] _ -> Bool in
                self?.provider.isAuthorized ?? false
            }
            .filter { $0 }
            .map { [weak self] _ -> [MessageStruct] in
                return [
                    MessageStruct(delay: 0.0, text: "I'm logged in".localized, state: .wait, outgoing: true),
                    MessageStruct(delay: 1.6, text: "Great 👍".localized, state: .wait, outgoing: false),
                    MessageStruct(delay: 2.2, text: "Now you can see photos,\nthat you saved in \(self?.provider.serviceName ?? "")".localized, state: .continue, outgoing: false),
                ]
            }
            .subscribe(onNext: { messageModels in
                messageModels.forEach { message in
                    publishSubject.onNext(message)
                }
            })
            .disposed(by: disposeBag)
    }
}




