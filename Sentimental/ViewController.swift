//
//  ViewController.swift
//  Sentimental
//
//  Created by Ebubechukwu Dimobi on 25.12.2021.
//

import UIKit
import SnapKit
import Lottie

class ViewController: UIViewController {
    
   
    private var result: TextClassifierResult?
    
    private let manager = Manager()
    
    private let animationView: AnimationView = AnimationView(frame: .zero)
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private lazy var inputTextView: UITextField = {
        let textView = TextFieldWithPadding(frame: .zero)
        textView.backgroundColor = .black
        textView.layer.cornerRadius = 10.0
        textView.placeholder = "How do you feel...."
        return textView
    }()
    
    private lazy var predictButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Predict", for: .normal)
        button.layer.cornerRadius = 20.0
        button.titleLabel?.font = .systemFont(ofSize: 18.0)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(didTapPredictButton(_:)), for: .touchUpInside)

        return button
    }()
    
    @objc
    private func didTapPredictButton(_ sender: UIButton) {
        guard
            let text = inputTextView.text,
            !text.isEmpty else {
                return
            }
        
        if let result = manager.getPrediction(on: text) {
            resultLabel.text = result.outputText
            resultLabel.sizeToFit()
//            setupTextColor(with: result)
            setAnimationWithResult(result)
        }
    }
    
    private func setupTextColor(with result: TextClassifierResult) {
        let color: UIColor
        
        switch result {
        case .pos:
            color = .green
        case .neutral:
            color = .blue
        case .negative:
            color = .red
        }
        
        UIView.animate(withDuration: 1.0) {
            self.predictButton.backgroundColor = color
            self.resultLabel.textColor = color
            self.inputTextView.backgroundColor = color
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sentimetal"
        view.backgroundColor = UIColor(red: 115, green: 252, blue: 214, alpha: 1.0)
        makeConstraints()
        // Do any additional setup after loading the view.
    }
    
    private func makeConstraints() {
        [animationView, resultLabel, inputTextView, predictButton].forEach { view.addSubview($0) }
        
        animationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).inset(16.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.bottom.lessThanOrEqualTo(view.snp.centerY)
            make.centerX.equalToSuperview()
        }
        
        resultLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.centerX.equalToSuperview()
            make.top.equalTo(animationView.snp.bottom).offset(16.0)
        }
        
        inputTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.height.equalTo(48.0)
            make.bottom.equalTo(predictButton.snp.top).offset(-30.0)
        }
        
        predictButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.height.equalTo(48.0)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16.0)
        }
    }


}


extension ViewController {
    
    func setAnimationWithResult(_ result: TextClassifierResult) {
        if animationView.isAnimationPlaying {
            animationView.stop()
        }
        animationView.isHidden = false
        animationView.animation = lottieAnimationWithResult(result)
        animationView.loopMode = .loop
        animationView.play()
        animationView.backgroundBehavior = .pauseAndRestore
        self.result = result
    }
    
    private func lottieAnimationWithResult(_ result: TextClassifierResult) -> Lottie.Animation? {
        return Lottie.Animation.named(result.AnimationName)
    }
   
}

class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 10,
        left: 20,
        bottom: 10,
        right: 20
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
