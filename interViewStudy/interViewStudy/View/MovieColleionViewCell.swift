//
//  MainTableViewCell.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/20.
//

import UIKit

final class MovieColleionViewCell: UICollectionViewCell {
    static let identifier = String(describing: MovieColleionViewCell.self)
    private var posterImageView: UIImageView = {
        let posterImageView = UIImageView()
        posterImageView.contentMode = .scaleToFill
        posterImageView.clipsToBounds = true
        return posterImageView
    }()
    var id: Int?
    
    private var titleLabel = UILabel.makeLabel(font: .callout, color: .white)
    private var scopeImage = UIImageView(image: UIImage(systemName: "star.fill"))
    
    private var scopeScore = UILabel.makeLabel(font: .caption1, color: .yellow)
    
    private lazy var scopeStackView: UIStackView = {
        let scopeStackView = UIStackView(arrangedSubviews: [scopeImage, scopeScore])
        scopeStackView.translatesAutoresizingMaskIntoConstraints = false
        scopeStackView.alignment = .leading
        scopeStackView.distribution = .fill
        scopeStackView.axis = .horizontal
        return scopeStackView
    }()

    private lazy var informationStackView: UIStackView = {
       let informationStackView = UIStackView(arrangedSubviews: [titleLabel, scopeStackView])
        informationStackView.translatesAutoresizingMaskIntoConstraints = false
        informationStackView.alignment = .leading
        informationStackView.axis = .vertical
        informationStackView.spacing = 1.0
        informationStackView.distribution = .fillEqually
        return informationStackView
    }()
    
    private lazy var cellStackView: UIStackView = {
       let cellStackView = UIStackView(arrangedSubviews: [posterImageView, informationStackView])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.alignment = .leading
        cellStackView.axis = .vertical
        cellStackView.spacing = 10
        cellStackView.distribution = .fill
        return cellStackView
    }()
    
    override func prepareForReuse() {
        titleLabel.text = nil
        posterImageView.image = nil
        scopeScore.text = nil
    }
    
    func configure(of movie: MovieInfoModel?) {
        scopeImage.tintColor = .yellow
        setLayoutForStackView()
            guard let movie = movie else {
            return
        }
        posterImageView.image = movie.image
        titleLabel.text = movie.title
        scopeScore.text = movie.voteAverage.description
    }
    
    func setLayoutForStackView() {
        contentView.addSubview(cellStackView)
        NSLayoutConstraint.activate([cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                     cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor ),
                                     cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                     scopeImage.heightAnchor.constraint(equalToConstant: 16),
                                     scopeImage.widthAnchor.constraint(equalToConstant: 16)])
    }
    
}
