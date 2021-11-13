//
//  CreateRouteImagesTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 12.10.2021.
//
import UIKit

final class CreateRouteImagesTableViewCell: UITableViewCell {
    //identifier
    static let identifier = "CreateRouteImagesTableViewCell"
    
    private let headerLabel : UILabel = {
        let label = UILabel()
        
        return label
    }()
    private var collectionView: UICollectionView?
    private let pageControl = UIPageControl()
    public var imagelist = [RouteImage]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // CollectionView Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        
        // CollectionView Cell
        collectionView?.register(HorizontalImageSliderCollectionViewCell.self, forCellWithReuseIdentifier: HorizontalImageSliderCollectionViewCell.identifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let collectionView = collectionView else {
            return
        }
        
        pageControl.currentPageIndicatorTintColor = UIColor(rgb: 0x5da973)
        
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageControl.currentPage = Int(roundedIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let pageControlHeight : CGFloat = 50.0

        collectionView?.frame = CGRect(x: 0,
                                       y: 0,
                                       width: contentView.width,
                                       height: contentView.height-pageControlHeight)
        
        pageControl.frame = CGRect(x: 0,
                                   y: collectionView!.bottom,
                                   width: contentView.width,
                                   height: pageControlHeight)
    }
    
    public func configure(with images: [RouteImage]){
        imagelist = images
    }

}

extension CreateRouteImagesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagelist.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let modal = userRoutes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalImageSliderCollectionViewCell.identifier, for: indexPath) as! HorizontalImageSliderCollectionViewCell
        //cell.configure(with: modal)
        cell.configure(with: imagelist[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return CGSize(width: contentView.width, height: contentView.height)
    }
}
