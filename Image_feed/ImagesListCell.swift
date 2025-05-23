import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    private let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16 
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "LikeButton"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var delegate: ImagesListCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(in tableView: UITableView, with indexPath: IndexPath, photo: Photo) {
        cellImageView.kf.setImage(with: photo.thumbImageURL, placeholder: UIImage(resource: ._0)) { _ in
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        contentView.backgroundColor = .ypBlack

        let likeImage = photo.isLiked ? UIImage(named: "like_active") : UIImage(named: "like_inactive")
        likeButton.setImage(likeImage, for: .normal)

        dateLabel.text = photo.createdAt
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "like_active") : UIImage(named: "like_inactive")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    private func setupViews() {
        contentView.addSubview(cellImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            //            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            //            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            //            cellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            //            cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
     
                cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                cellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
   
            
            
                likeButton.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: -10.5),
                likeButton.topAnchor.constraint(equalTo: cellImageView.topAnchor, constant: 12),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            
            dateLabel.leadingAnchor.constraint(equalTo: cellImageView.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: -8)
        ])
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
    }
    
    @objc private func didTapLike() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.kf.cancelDownloadTask()
        cellImageView.image = nil
    }
}


//final class ImagesListCell: UITableViewCell {
//    static let reuseIdentifier = "ImagesListCell"
//
//    private var photoId: String?
//    private let postCellImage = UIImageView()
//    private let postCellHeartButton = UIButton()
//    private let postCellDataLabel = UILabel()
//
//    var onLikeButtonTapped: (() -> Void)?
//
//    weak var delegate: ImagesListCellDelegate?
//
//    private lazy var dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .long
//        formatter.timeStyle = .none
//        formatter.locale = Locale(identifier: "ru_RU")
//        formatter.dateFormat = "d MMMM yyyy"
//        return formatter
//    }()
//
//    private var isLiked: Bool = false {
//        didSet {
//            let imageName = isLiked ? "Active" : "No Active"
//            postCellHeartButton.setImage(UIImage(named: imageName), for: .normal)
//        }
//    }
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        contentView.addSubview(postCellImage)
//        contentView.addSubview(postCellHeartButton)
//        contentView.addSubview(postCellDataLabel)
//
//        setupPostCellHeartButton()
//        setupConstraints()
//        contentView.backgroundColor = .ypBlack
//        selectionStyle = .none
//    }
//    func configCell(in tableView: UITableView, with indexPath: IndexPath, photo: Photo)  {
//        isLiked = photo.isLiked
//        photoId = photo.id
//
//        guard
//            let likeImage = photo.isLiked
//                ? UIImage(named: "LikeActive") : UIImage(named: "LikeNoActive")
//        else {
//            return
//        }
//
//        postCellImage.kf.indicatorType = .activity
//        postCellImage.kf.setImage(with: photo.thumbImageURL, placeholder: UIImage(resource: ._0)) { _ in
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//        }
//        postCellDataLabel.text = photo.createdAt
//        postCellHeartButton.setImage(likeImage, for: .normal)
//    }
//    private func setupPostCellHeartButton() {
//        postCellHeartButton.translatesAutoresizingMaskIntoConstraints = false
//        postCellHeartButton.backgroundColor = .clear
//        postCellHeartButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
//    }
//
//    func setIsLiked(_ isLiked: Bool) {
//        let newImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
//        self.postCellHeartButton.setImage(newImage, for: .normal)
//    }
//
//    @objc private func didTapLike() {
//        delegate?.imageListCellDidTapLike(self)
//    }
//
//    func setupCell(post: Photo) {
//        postCellImage.layer.cornerRadius = 16
//        postCellImage.clipsToBounds = true
//        postCellImage.translatesAutoresizingMaskIntoConstraints = false
//        postCellImage.contentMode = .scaleAspectFill
//        postCellImage.kf.setImage(with: post.thumbImageURL)
//
//        isLiked = post.isLiked
//        postCellDataLabel.text = post.createdAt
//        setupPostCellDataLabel()
//    }
//
//    private func setupPostCellDataLabel() {
//        postCellDataLabel.translatesAutoresizingMaskIntoConstraints = false
//        postCellDataLabel.textColor = .ypWhite
//        postCellDataLabel.font = UIFont.systemFont(ofSize: 13)
//        postCellDataLabel.textAlignment = .left
//    }
//
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            postCellHeartButton.topAnchor.constraint(
//                equalTo: postCellImage.topAnchor),
//            postCellHeartButton.trailingAnchor.constraint(
//                equalTo: postCellImage.trailingAnchor),
//            postCellHeartButton.widthAnchor.constraint(
//                equalToConstant: 44),
//            postCellHeartButton.heightAnchor.constraint(
//                equalToConstant: 44),
//
//            postCellImage.topAnchor.constraint(
//                equalTo: contentView.topAnchor, constant: 8),
//            postCellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            postCellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            postCellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
//
//            postCellDataLabel.leadingAnchor.constraint(equalTo: postCellImage.leadingAnchor, constant: 8),
//            postCellDataLabel.bottomAnchor.constraint(equalTo: postCellImage.bottomAnchor, constant: -8),
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
