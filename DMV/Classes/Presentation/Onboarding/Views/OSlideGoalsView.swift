//
//  OSlide4View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class OSlideGoalsView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var cell1 = makeCell(title: "Onboarding.Goals.Cell1", tag: 0)
    lazy var cell2 = makeCell(title: "Onboarding.Goals.Cell2", tag: 1)
    lazy var cell3 = makeCell(title: "Onboarding.Goals.Cell3", tag: 2)
    lazy var button = makeButton()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step, scope: OnboardingScope) {
        super.init(step: step, scope: scope)
        
        makeConstraints()
        initialize()
        changeEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSlideGoalsView {
    func initialize() {
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                
                let selectedGoals = [
                    self.cell1, self.cell2, self.cell3
                ]
                .filter { $0.isSelected }
                .map { $0.tag }
                
                self.scope.assetsPreferences = selectedGoals
                
                self.onNext()
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func selected(tapGesture: UITapGestureRecognizer) {
        guard let cell = tapGesture.view as? OGoalCell else {
            return
        }
        
        cell.isSelected = !cell.isSelected
        
        changeEnabled()
        
        AmplitudeManager.shared
            .logEvent(name: "Goals Tap", parameters: [:])
    }
    
    func changeEnabled() {
        let isEmpty = [
            cell1, cell2, cell3
        ]
        .filter { $0.isSelected }
        .isEmpty
        
        button.isEnabled = !isEmpty
        button.alpha = isEmpty ? 0.4 : 1
    }
}

// MARK: Make constraints
private extension OSlideGoalsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: cell1.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell1.bottomAnchor.constraint(equalTo: cell2.topAnchor, constant: -12.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell2.bottomAnchor.constraint(equalTo: cell3.topAnchor, constant: -12.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell3.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -48.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            button.heightAnchor.constraint(equalToConstant: 60.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlideGoalsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryText)
            .font(Fonts.SFProRounded.bold(size: 32.scale))
            .lineHeight(38.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Goals.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(title: String, tag: Int) -> OGoalCell {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selected(tapGesture:)))
        
        let view = OGoalCell()
        view.tag = tag
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.isSelected = false
        view.text = title.localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryButtonTint)
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = Onboarding.primaryButton
        view.layer.cornerRadius = 30.scale
        view.setAttributedTitle("Onboarding.Next".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
