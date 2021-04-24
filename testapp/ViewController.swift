//
//  ViewController.swift
//  testapp
//
//  Created by Vlad Suhomlinov on 29.03.2020.
//  Copyright © 2020 touchin. All rights reserved.
//

import UIKit
import QRCodeReader
import Reg
import SnapKit

class ViewController: UIViewController {

    let cardScanner = CardReader(factory: CardFactoryImpl(), onUpdateRectOfInterest: nil)
    let cardScannerView = CardScanner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(cardScannerView)
        
        cardScanner.stopScanningWhenCodeIsFound = true
        
        cardScannerView.scannerView.setReader(cardScanner)
        
        cardScannerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cardScanner.didFind = { [weak self] in
            self?.handleResult(card: $0)
        }
        
        cardScannerView.flashlightButton.addTarget(self, action: #selector(toggleFlashlightAction), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cardScanner.startScanning()
        
        cardScannerView.layoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cardScanner.stopScanning()
    }
    
    @objc private func toggleFlashlightAction() {

        cardScanner.isTorchEnabled.toggle()
        cardScannerView.updateFlashlightButtonAppearance(isTorchEnabled: cardScanner.isTorchEnabled)
    }
    
    private func handleResult(card: Card) {
        
        let alert = UIAlertController(title: "Номер карты", message: card.number, preferredStyle: .alert)
        let actionTrue = UIAlertAction(title: "Верно", style: .default, handler: { [weak self] _ in
            self?.cardScanner.startScanning()
        })
        let actionErrors = UIAlertAction(title: "С ошибками", style: .default, handler: { [weak self] _ in
            self?.cardScanner.startScanning()
        })
        let actionRetake = UIAlertAction(title: "Переделать", style: .default, handler: { [weak self] _ in
            self?.cardScanner.startScanning()
        })
        
        alert.addAction(actionTrue)
        alert.addAction(actionErrors)
        alert.addAction(actionRetake)
        
        present(alert, animated: true, completion: nil)
    }
}

final class CardFactoryImpl: CardFactory {
    let creditCardNumber: Regex = #"(?:\d[ -]*?){13,16}"#
    
    func create(_ values: [String]) -> Card? {
        values.map {
            $0.replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "-", with: "")
            
        }
        .first {
            $0.count >= 15 && $0.count <= 19 && $0.isOnlyNumbers
        }
        .map { $0.inserting(separator: " ", every: 4) }
        .map { Card(number: $0) }
    }
}

private extension String {
    var isOnlyNumbers: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
}

extension Collection {
    func unfoldSubSequences(limitedTo maxLength: Int) -> UnfoldSequence<SubSequence,Index> {
        sequence(state: startIndex) { start in
            guard start < self.endIndex else { return nil }
            let end = self.index(start, offsetBy: maxLength, limitedBy: self.endIndex) ?? self.endIndex
            defer { start = end }
            return self[start..<end]
        }
    }

    func every(n: Int) -> UnfoldSequence<Element,Index> {
        sequence(state: startIndex) { index in
            guard index < endIndex else { return nil }
            defer { index = self.index(index, offsetBy: n, limitedBy: endIndex) ?? endIndex }
            return self[index]
        }
    }

    var pairs: [SubSequence] { .init(unfoldSubSequences(limitedTo: 2)) }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    mutating func insert<S: StringProtocol>(separator: S, every n: Int) {
        for index in indices.every(n: n).dropFirst().reversed() {
            insert(contentsOf: separator, at: index)
        }
    }
    func inserting<S: StringProtocol>(separator: S, every n: Int) -> Self {
        .init(unfoldSubSequences(limitedTo: n).joined(separator: separator))
    }
}
