//
//  CardScanner.swift
//  testapp
//
//  Created by Vlad Suhomlinov on 24.04.2021.
//  Copyright © 2021 touchin. All rights reserved.
//

import TIUIElements
import QRCodeReader
import UIKit
import SnapKit

final class CardScanner: BaseInitializableView {
    
    private let titleLabel = UILabel()
    private let qrEdgeIconView = UIImageView(image: .corners)
    private let focusView: FocusView = .init(cornerColor: .init(red: 234 / 255,
                                                                green: 65 / 255,
                                                                blue: 127 / 255,
                                                                alpha: 1),
                                             cornerLength: 40,
                                             cornerThickness: 6)
    
    let scannerView = CardReaderView()
    let flashlightButton = UIButton()
    
    // MARK: - Configurable View
    
    override func configureAppearance() {
        super.configureAppearance()
        
        backgroundColor = .black
        
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        updateFlashlightButtonAppearance(isTorchEnabled: false)
        
        qrEdgeIconView.isHidden = true
    }
    
    override func addViews() {
        super.addViews()
        
        addSubviews(scannerView, titleLabel, flashlightButton)
        
        qrEdgeIconView.addSubview(focusView)
        scannerView.overlay.addSubview(qrEdgeIconView)

        scannerView.overlay.focusView = focusView
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        scannerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        qrEdgeIconView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(qrEdgeIconView.snp.width).multipliedBy(0.64)
        }
        
        focusView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(qrEdgeIconView.snp.bottom).offset(28)
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(32)
        }
        
        flashlightButton.snp.makeConstraints {
            $0.top.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            $0.size.equalTo(CGFloat.topButtonSize)
        }
    }
    
    
    func updateFlashlightButtonAppearance(isTorchEnabled: Bool) {
        flashlightButton.setImage(isTorchEnabled ? .lightOff : .lightOn, for: .normal)
    }
    
    override func localize() {
        super.localize()
        
        titleLabel.text = "Обязательно проверяйте номер карты после распознавания"
    }
}

// MARK: - Constants

private extension CGFloat {
    static let topButtonSize: CGFloat = 28
}

extension FocusView {
    
    static let empty = FocusView(cornerColor: .clear,
                                 cornerLength: 0,
                                 cornerThickness: 0)
}
