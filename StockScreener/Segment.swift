import Foundation

enum Segment<Option: Optionable>: Hashable, CustomStringConvertible {
    case all, option(Option)
    
    var description: String {
        switch self {
        case .all:
            return "全て"
        case .option(let element):
            return element.description
        }
    }
}
