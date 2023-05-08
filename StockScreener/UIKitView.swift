import UIKit
import SwiftUI
import Combine

final class UIKitViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    @IBOutlet private weak var exchangeSegmentedControl: UISegmentedControl! {
        didSet {
            exchangeSegmentedControl.removeAllSegments()
            exchangeSegmentedControl.insertSegment(
                withTitle: Segment<Stock.Exchange>.all.description, at: 0, animated: false
            )
            Stock.Exchange.allCases.enumerated().forEach { i, exchange in
                exchangeSegmentedControl.insertSegment(
                    withTitle: Segment<Stock.Exchange>.option(exchange).description, at: i + 1, animated: false
                )
            }
            exchangeSegmentedControl.selectedSegmentIndex = 0
        }
    }
    
    @IBOutlet private weak var sectorSegmentedControl: UISegmentedControl! {
        didSet {
            sectorSegmentedControl.removeAllSegments()
            sectorSegmentedControl.insertSegment(
                withTitle: Segment<Stock.Sector>.all.description, at: 0, animated: false
            )
            Stock.Sector.allCases.enumerated().forEach { i, sector in
                sectorSegmentedControl.insertSegment(
                    withTitle: Segment<Stock.Sector>.option(sector).description, at: i + 1, animated: false
                )
            }
            sectorSegmentedControl.selectedSegmentIndex = 0
        }
    }
    
    private let viewModel: ViewModel = .init()
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
        setActions()
        bind()
    }
    
    private func bind() {
        viewModel.filteredStocksPublisher
            .sink { [weak self] stocks in
                Stock.majors.enumerated().forEach { (index, stock) in
                    let alpha: CGFloat = stocks.contains(stock) ? 1.0 : 0.5
                    self?.collectionView.cellForItem(at: .init(row: index, section: .zero))?.alpha = alpha
                }
            }
            .store(in: &cancellables)
        
        viewModel.tappedStock
            .sink { stock in
                // do something
                print("\(stock.symbol) tapped")
            }
            .store(in: &cancellables)
    }
    
    private func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        let size = view.bounds.width / 4 - 16
        layout.itemSize = .init(width: size, height: size)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        collectionView.collectionViewLayout = layout
    }
    
    private func setActions() {
        exchangeSegmentedControl.addAction(.init(handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.selectedExchange = {
                let index = self.exchangeSegmentedControl.selectedSegmentIndex
                if index == 0 { return .all }
                else { return .option(
                    Stock.Exchange.allCases[index - 1]
                )}
            }()
        }), for: .valueChanged)
        
        sectorSegmentedControl.addAction(.init(handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.selectedSector = {
                let selectedIndex = self.sectorSegmentedControl.selectedSegmentIndex
                if let sector = Stock.Sector(rawValue: selectedIndex - 1) {
                    return .option(sector)
                }
                return .all
            }()
        }), for: .valueChanged)
    }
}

extension UIKitViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Stock.majors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        cell.clipsToBounds = true
        cell.layer.cornerRadius = cell.bounds.width / 4
        cell.backgroundColor = .init(white: 0.25, alpha: 1)
        
        let indicator = UIActivityIndicatorView()
        indicator.color = .white
        indicator.startAnimating()
        indicator.frame.size = cell.bounds.size
        
        let imageView = UIImageView()
        imageView.frame.size = .init(width: cell.bounds.width / 2, height: cell.bounds.width / 2)
        imageView.frame.origin = .init(x: cell.bounds.width / 4, y: cell.bounds.width / 4)
        
        Task {
            cell.addSubview(indicator)
            imageView.image = await {
                if let image = await Stock.majors[indexPath.row].logoImage {
                    return image
                }
                return .init(systemName: "questionmark")
            }()
            cell.addSubview(imageView)
            indicator.removeFromSuperview()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.tappedStock.send(Stock.majors[indexPath.row])
    }
}

private extension Stock {
    
    var logoImage: UIImage? {
        get async {
            let data = try? await URLSession.shared.data(from: logoUrl).0
            return data == nil ? nil : .init(data: data!)
        }
    }
}

struct UIKitView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIStoryboard(name: String(describing: UIKitView.self), bundle: Bundle.main)
            .instantiateInitialViewController()!
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.topItem?.title = "UIKit Stock Screener"
        return nav
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct UIKitView_Previews: PreviewProvider {
    static var previews: some View {
        UIKitView()
    }
}
