import Foundation

struct Stock: Hashable {
    let symbol: String
    let exchange: Exchange
    let sector: Sector
    var logoUrl: URL { .init(string: "https://financialmodelingprep.com/image-stock/\(symbol).png")! }
}

extension Stock {
    static let majors: [Self] = [
        .init(symbol: "AAPL", exchange: .nasdaq, sector: .technology),
        .init(symbol: "AMZN", exchange: .nasdaq, sector: .consumerDiscretionary),
        .init(symbol: "GOOG", exchange: .nasdaq, sector: .communicationServices),
        .init(symbol: "MSFT", exchange: .nasdaq, sector: .technology),
        .init(symbol: "META", exchange: .nasdaq, sector: .communicationServices),
        .init(symbol: "TSLA", exchange: .nasdaq, sector: .consumerDiscretionary),
        .init(symbol: "ZM", exchange: .nasdaq, sector: .technology),
        .init(symbol: "SBUX", exchange: .nasdaq, sector: .consumerDiscretionary),
        .init(symbol: "PYPL", exchange: .nasdaq, sector: .technology),
        .init(symbol: "NKE", exchange: .nyse, sector: .consumerDiscretionary),
        .init(symbol: "NVDA", exchange: .nasdaq, sector: .technology),
        .init(symbol: "ADBE", exchange: .nasdaq, sector: .technology),
        .init(symbol: "INTC", exchange: .nasdaq, sector: .technology),
        .init(symbol: "DIS", exchange: .nyse, sector: .communicationServices),
        .init(symbol: "MCD", exchange: .nyse, sector: .consumerDiscretionary),
        .init(symbol: "NFLX", exchange: .nasdaq, sector: .communicationServices)
    ]
}
