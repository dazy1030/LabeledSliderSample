//
//  ViewController.swift
//  LabeledSliderSample
//
//  Created by Naoki Odajima on 2020/10/24.
//

import ReactiveCocoa
import ReactiveSwift
import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var labeledSliderView: LabeledSliderView!
    
    @IBOutlet private weak var firstButton: UIButton!
    @IBOutlet private weak var secondButton: UIButton!
    @IBOutlet private weak var thirdButton: UIButton!
    @IBOutlet private weak var fourthButton: UIButton!
    
    /// 押したボタンのインデックス
    private var selectedIndex: MutableProperty<Int> = MutableProperty<Int>(0)
    /// ボタンに対応するスライダーの値を保存するプロパティ
    private var sliderValues: [Float] = [10, 20, 30, 40]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ボタンが選択されたとき（と初回宣言時）にスライダーの値をセットする
        self.selectedIndex.producer
            .start(on: UIScheduler())
            .startWithValues { [weak self] (index: Int) in
                guard let self = self else { return }
                self.labeledSliderView.sliderValue = self.sliderValues[index]
            }
        // スライダーの値がつまみによって変更された時に保存している値を更新する
        self.labeledSliderView.sliderValues
            .observeValues { [weak self] (value: Float) in
                guard let self = self else { return }
                self.sliderValues[self.selectedIndex.value] = value
            }
        // ボタンを押した時に選択したボタンのインデックスを更新する
        self.selectedIndex <~ Signal.merge(
            self.firstButton.reactive.mapControlEvents(.primaryActionTriggered) { _ in 0 },
            self.secondButton.reactive.mapControlEvents(.primaryActionTriggered) { _ in 1 },
            self.thirdButton.reactive.mapControlEvents(.primaryActionTriggered) { _ in 2 },
            self.fourthButton.reactive.mapControlEvents(.primaryActionTriggered) { _ in 3 }
        )
        .skipRepeats()
    }
}

