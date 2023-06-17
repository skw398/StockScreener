import Combine

@MainActor class ViewModel: ObservableObject {
    
    @Published var selectedExchange: Segment<Stock.Exchange> = .all
    @Published var selectedSector: Segment<Stock.Sector> = .all
    
    var tappedStock: PassthroughSubject<Stock, Never> = .init()
    
    var filteredStocksPublisher: AnyPublisher<[Stock], Never> {
        Publishers.CombineLatest($selectedExchange, $selectedSector)
            .map { selectedExchange, selectedSector in
                var filtered = Stock.majors
                
                if case let .option(exchange) = selectedExchange {
                    filtered = filtered.filter { $0.exchange == exchange }
                }
                
                if case let .option(sector) = selectedSector {
                    filtered = filtered.filter { $0.sector == sector }
                }
                
                return filtered
            }
            .eraseToAnyPublisher()
    }
}
