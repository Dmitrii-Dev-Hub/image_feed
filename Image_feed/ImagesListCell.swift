import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    private let postCellImage = UIImageView()
    private let postCellHeartButton = UIButton()
    private let postCellDataLabel = UILabel()
    
    var onLikeButtonTapped: (() -> Void)?
    
    weak var delegate: ImagesListCellDelegate?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()
    
    private var isLiked: Bool = false {
        didSet {
            let imageName = isLiked ? "Active" : "No Active"
            postCellHeartButton.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(postCellImage)
        contentView.addSubview(postCellHeartButton)
        contentView.addSubview(postCellDataLabel)
        
        setupPostCellHeartButton()
        setupConstraints()
        contentView.backgroundColor = .ypBlack
        selectionStyle = .none
    }
    
    private func setupPostCellHeartButton() {
        postCellHeartButton.translatesAutoresizingMaskIntoConstraints = false
        postCellHeartButton.backgroundColor = .clear
        postCellHeartButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let newImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
        self.postCellHeartButton.setImage(newImage, for: .normal)
    }
    
    @objc private func didTapLike() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setupCell(post: Photo) {
        postCellImage.layer.cornerRadius = 16
        postCellImage.clipsToBounds = true
        postCellImage.translatesAutoresizingMaskIntoConstraints = false
        postCellImage.contentMode = .scaleAspectFill
        postCellImage.kf.setImage(with: post.thumbImageURL)
        
        isLiked = post.isLiked
        postCellDataLabel.text = post.createdAt
        setupPostCellDataLabel()
    }
    
    private func setupPostCellDataLabel() {
        postCellDataLabel.translatesAutoresizingMaskIntoConstraints = false
        postCellDataLabel.textColor = .ypWhite
        postCellDataLabel.font = UIFont.systemFont(ofSize: 13)
        postCellDataLabel.textAlignment = .left
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            postCellHeartButton.topAnchor.constraint(
                equalTo: postCellImage.topAnchor),
            postCellHeartButton.trailingAnchor.constraint(
                equalTo: postCellImage.trailingAnchor),
            postCellHeartButton.widthAnchor.constraint(
                equalToConstant: 44),
            postCellHeartButton.heightAnchor.constraint(
                equalToConstant: 44),
            
            postCellImage.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: 8),
            postCellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postCellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            postCellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            postCellDataLabel.leadingAnchor.constraint(equalTo: postCellImage.leadingAnchor, constant: 8),
            postCellDataLabel.bottomAnchor.constraint(equalTo: postCellImage.bottomAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
