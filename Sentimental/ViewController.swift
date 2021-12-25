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
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    private lazy var inputTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        return textView
    }()
    
    private lazy var predictButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Predict", for: .normal)
        button.layer.cornerRadius = 20.0
        button.titleLabel?.font = .systemFont(ofSize: 18.0)
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
            setAnimationWithResult(result)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sentimetal"
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
            make.height.equalTo(50.0)
            make.bottom.equalTo(predictButton.snp.bottom).offset(30.0)
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
