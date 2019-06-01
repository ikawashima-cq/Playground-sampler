//
//  ViewController.swift
//  Playground-sampler
//
//  Created by Iichiro Kawashima on 2019/05/01.
//  Copyright © 2019 Iichiro Kawashima. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SplashViewController: UIViewController {

    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.placeholder = "入力してください"
            textField.font = UIFont.systemFont(ofSize: 14)
        }
    }

    @IBOutlet weak var button: UIButton! {
        didSet {
            button.layer.cornerRadius = 8
            button.layer.borderColor = UIColor.blue.cgColor
            button.setTitle("ボタン", for: .normal)
            button.isEnabled = false
        }
    }

    @IBOutlet weak var label: UILabel! {
        didSet {
            label.textAlignment = .center
        }
    }

    private let disposeBag = DisposeBag()

    let viewModel = SplashViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Rxsample"

        // ================================================
        // ViewController -> viewModelへイベントの通知(inputs)
        // ================================================

        button.rx.tap
            .do(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .bind(to: viewModel.inputs.didButtonTaped)
            .disposed(by: disposeBag)

        textField.rx.text.orEmpty
            .bind(to: viewModel.inputs.userNameText)
            .disposed(by: disposeBag)

        rx.methodInvoked(#selector(viewDidAppear))
            .bind(to: viewModel.inputs.viewDidAppear)
            .disposed(by: disposeBag)

        // ======================================
        // ViewModel -> viewController (outputs)
        // ======================================

        viewModel.textValid
            .subscribe(onNext: { [unowned self] bool in
                // textFiledのバリデーションが通ったらボタン有効にする
                if bool {
                    self.button.isEnabled = true
                }
            }).disposed(by: disposeBag)

        viewModel.showAlert
            .drive(onNext: { [unowned self] _ in
                // アラート表示処理
                self.showAlert()
            }).disposed(by: disposeBag)

        viewModel.didDatafetched
            .do(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            // タイトルにfetchしてきたデータ数表示
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }

    private func showAlert() {
        let alert = UIAlertController(title: "Welcome", message: "ボタンを押下したらラベルに文字が表示されます", preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okayButton)

        present(alert, animated: true)
    }
}
