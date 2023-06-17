import SwiftUI

struct SwiftUIView: View {
    
    @StateObject var viewModel: ViewModel = .init()
    @State var filteredStocks: [Stock] = Stock.majors
    
    var body: some View {
        NavigationView {
            
            GeometryReader { geometry in
                let cellSize = geometry.size.width / 4 - 16
                
                VStack(spacing: 8) {
                    
                    OptionPicker<Stock.Exchange>(
                        title: "取引所",
                        selection: $viewModel.selectedExchange
                    )
                    
                    OptionPicker<Stock.Sector>(
                        title: "セクター",
                        selection: $viewModel.selectedSector
                    )
                    
                    Spacer().frame(height: 16)
                    
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: cellSize))],
                        spacing: 16
                    ) {
                        ForEach(Stock.majors, id: \.symbol) { stock in
                            StockCell(
                                stock: stock,
                                isHighlighted: filteredStocks.contains(stock)
                            )
                            .frame(width: cellSize, height: cellSize)
                            .onTapGesture {
                                viewModel.tappedStock.send(stock)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .onReceive(viewModel.filteredStocksPublisher) { stocks in
                    filteredStocks = stocks
                }
                .onReceive(viewModel.tappedStock) { stock in
                    // do something
                    print("\(stock.symbol) tapped")
                }
                .navigationTitle("SwiftUI Stock Screener")
            }
        }
    }
    
    private struct OptionPicker<Option: Optionable>: View {
        let title: String
        let selection: Binding<Segment<Option>>
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title).fontWeight(.bold)
                
                Picker(title, selection: selection) {
                    let segment = Segment<Option>.all
                    Text(segment.description)
                        .tag(segment)
                    
                    ForEach(Array(Option.allCases), id: \.self) { option in
                        let segment = Segment<Option>.option(option)
                        Text(segment.description)
                            .tag(segment)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
    }
    
    private struct StockCell: View {
        
        let stock: Stock
        let isHighlighted: Bool
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    RoundedRectangle(cornerRadius: geometry.size.width / 4)
                        .fill(Color(white: 0.25))
                    
                    AsyncImage(url: stock.logoUrl) { phase in
                        if let image = phase.image {
                            image.resizable().scaledToFit()
                        } else if phase.error != nil {
                            Image(systemName: "questionmark")
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                    }
                    .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                }
            }
            .opacity(isHighlighted ? 1.0 : 0.5)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
