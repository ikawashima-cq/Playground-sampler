//: A UIKit based Playground for presenting user interface
  
import RxSwift

let disposeBag: DisposeBag = .init()

let observable = Observable.of(1,2,3)

observable
    .subscribe(onNext: { element in
        print(element)
    }, onCompleted: {
        print("complete")
    }).disposed(by: disposeBag)
