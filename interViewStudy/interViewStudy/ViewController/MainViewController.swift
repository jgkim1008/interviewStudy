//
//  ViewController.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/15.
//

import UIKit


final class MainViewController: UIViewController, UICollectionViewDelegate {
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .basicLayout)
        collectionView.register(MovieColleionViewCell.self, forCellWithReuseIdentifier: MovieColleionViewCell.identifier)
        return collectionView
    }()

    private let viewModel = MainViewModel()
    private let topInset: CGFloat = 5
    private let bottomInset: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.topItem?.title = "현재 상영 중"
        navigationController?.navigationBar.tintColor = .white
        setLayoutForCollectionView()
        collectionView.delegate = self
        makeDataSource()


    }

    
    private func makeNavigationItem() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.topItem?.title = "현재 상영 중"
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setLayoutForCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                                     collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    
    private func makeDataSource() {
        viewModel.dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, movieData) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieColleionViewCell.identifier, for: indexPath) as? MovieColleionViewCell
            cell?.configure(of: movieData)
        
            return cell
        }
    }
}

extension MainViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let heightRemainBottom = contentHeight - yOffset
        
        let frameHeight = scrollView.frame.size.height
        if heightRemainBottom < frameHeight {
            viewModel.fetchData()
        }
    }
}
