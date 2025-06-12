//
//  HoldingsServiceProtocol.swift
//  SatyamDixitDemo
//
//  Created by Satyam Dixit on 10/06/25.
//


// MARK: - HoldingsAPIService.swift
import Foundation

protocol HoldingsServiceProtocol {
    func fetchHoldings(completion: @escaping (Result<[Holding]?, Error>) -> Void)
}

class HoldingsAPIService: HoldingsServiceProtocol {
    private let endpoint = URL(string: "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/")!

    func fetchHoldings(completion: @escaping (Result<[Holding]?, Error>) -> Void) {
        URLSession.shared.dataTask(with: endpoint) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "DataNil", code: -1, userInfo: nil)))
                return
            }
            do {
                let holdings = try JSONDecoder().decode(HoldingsResponse.self, from: data)
                completion(.success(holdings.data?.userHolding))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
