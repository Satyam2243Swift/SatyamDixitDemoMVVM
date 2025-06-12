//
//  HoldingsViewModel.swift
//  SatyamDixitDemo
//
//  Created by Satyam Dixit on 10/06/25.
//


import Foundation

class HoldingsViewModel {
    private let service: HoldingsServiceProtocol
    private(set) var holdings: [Holding] = [] {
        didSet {
            calculatePortfolioValues()
        }
    }

    var isExpanded: Bool = false
    var currentValue: Double = 0
    var totalInvestment: Double = 0
    var totalPNL: Double = 0
    var todaysPNL: Double = 0

    var onUpdate: (() -> Void)?

    init(service: HoldingsServiceProtocol = HoldingsAPIService()) {
        self.service = service
    }

    func fetchHoldings() {
        service.fetchHoldings { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.holdings = data ?? []
                    self.onUpdate?()
                case .failure(let error):
                    print("API Error: \(error.localizedDescription)")
                }
            }
        }
    }

    private func calculatePortfolioValues() {
        currentValue = holdings.reduce(0) { $0 + (($1.ltp ?? 0) * ($1.quantity ?? 0)) }
        totalInvestment = holdings.reduce(0) { $0 + (($1.avgPrice ?? 0) * ($1.quantity ?? 0)) }
        totalPNL = currentValue - totalInvestment
        todaysPNL = holdings.reduce(0) { $0 + ((($1.close ?? 0) - ($1.ltp ?? 0)) * ($1.quantity ?? 0)) }
    }

    func toggleExpanded() {
        isExpanded.toggle()
        onUpdate?()
    }

    func pnl(for holding: Holding) -> Double {
        let ltp = holding.ltp ?? 0
        let avg = holding.avgPrice ?? 0
        let qty = holding.quantity ?? 0
        return (ltp - avg) * qty
    }
}
