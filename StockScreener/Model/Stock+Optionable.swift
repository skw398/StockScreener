import Foundation

protocol Optionable: Hashable, CaseIterable, CustomStringConvertible {}

extension Stock {
    enum Exchange: Optionable {
        case nyse
        case nasdaq
        
        var description: String {
            switch self {
            case .nyse:
                return "NY証券取引所"
            case .nasdaq:
                return "ナスダック"
            }
        }
    }
    
    enum Sector: Int, Optionable {
        case technology
        case communicationServices
        case consumerDiscretionary
        
        var description: String {
            switch self {
            case .technology:
                return "テクノロジー"
            case .communicationServices:
                return "通信サービス"
            case .consumerDiscretionary:
                return "一般消費財"
            }
        }
    }
}
