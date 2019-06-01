//
//  SplashViewModel.swift
//  Playground-sampler
//
//  Created by Iichiro Kawashima on 2019/06/02.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SplashViewModel {

    private let disposeBag = DisposeBag()

    // ====================================
    // viewController -> viewModel (inputs)
    // ====================================

    struct Input {
        let didButtonTaped = PublishRelay<Void>()
        let userNameText = PublishRelay<String>()
        let viewDidAppear = PublishRelay<[Any]>()
    }

    let inputs = Input()

    // =================================================
    // ViewModel -> viewControllerへイベントの通知(outputs)
    // =================================================

    let didDatafetched: Observable<String>

    var textValid: Observable<Bool>

    var showAlert: Driver<Void> {
        return inputs.viewDidAppear
            .map { _ in () }
            .asDriver(onErrorDriveWith: Driver.empty())
    }
    // model層のクラスなどインスタンス化
    init() {
        let _didDatafetched = BehaviorRelay<String>(value: "")
        self.didDatafetched = _didDatafetched.asObservable()

        textValid = inputs.userNameText
            .map { text in
                text.count > 3
            }.asObservable()

        inputs.didButtonTaped
            .map { [unowned self] _ -> String in
                self.fetch()
            }
            .bind(to: _didDatafetched)
            .disposed(by: disposeBag)

    //==============
    //other examples
    //==============

//        inputs.userNameText
//            .subscribe(onNext: { [unowned self] text in
//                self.validate(text: text)
//                }, onError: { (error) in
//                    print(error.localizedDescription)
//            }).disposed(by: disposeBag)
//
//        inputs.viewDidAppear
//            .subscribe(onNext: { _ in
//                fetch() やviewの更新処理
//            }, onError: { (error) in
//                print(error.localizedDescription)
//            }).disposed(by: disposeBag)
    }

    // サンプル関数
    private func fetch() -> String {
        // ダミーデータ
        // remoteからfetchしてくること想定
        return "Bind成功"
    }

    // サンプル関数
    private func validate(text: String) -> Bool {
        return text.count > 3
    }
}
