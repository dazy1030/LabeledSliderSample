//
//  LabeledSliderView.swift
//  LabeledSliderSample
//
//  Created by Naoki Odajima on 2020/10/24.
//

import ReactiveCocoa
import ReactiveSwift
import UIKit

/// スライダーのつまみの上につまみの値が表示されるラベルを持つUIView
final class LabeledSliderView: UIView {
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var slider: UISlider!
    
    @IBOutlet private weak var valueLabelXConstraint: NSLayoutConstraint!
    
    /// つまみによって変更されたスライダーの値のストリーム
    var sliderValues: Signal<Float, Never> {
        self.slider.reactive.values
    }
    
    /// スライダーの値
    var sliderValue: Float {
        get {
            self.slider.value
        }
        set {
            // スライダーの値を直接編集した時
            self.slider.value = newValue
            self.updateLabelText()
            self.updateLabelConstraint()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // スライダーのつまみによって更新された時
        self.slider.reactive.values
            .observe(on: UIScheduler())
            .observeValues { [weak self] (value: Float) in
                self?.updateLabelText()
                self?.updateLabelConstraint()
            }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 回転時に更新する
        self.updateLabelConstraint()
    }
    
    /// ラベルのテキストをスライダーの値にする
    private func updateLabelText() {
        self.valueLabel.text = String(Int(self.slider.value))
    }
    
    /// ラベルの位置をスライダーのつまみの上に更新する
    private func updateLabelConstraint() {
        let trackBounds: CGRect = self.slider.trackRect(forBounds: self.slider.bounds)
        let trackFrame: CGRect = self.slider.convert(trackBounds, to: self.slider.superview)
        let thumbFrame: CGRect = self.slider.thumbRect(forBounds: self.slider.bounds,
                                                       trackRect: trackFrame,
                                                       value: self.slider.value)
        self.valueLabelXConstraint.constant = thumbFrame.midX
    }
}
