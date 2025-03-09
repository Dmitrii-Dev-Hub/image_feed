import UIKit


class PostCell: UITableViewCell {
    
    static let reuseId = "PostCell"
    
    
    var postCellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var postCellLikeButton: UIButton = {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            let heartImage = UIImage(systemName: "heart.fill")
            button.setImage(heartImage, for: .normal)
            button.tintColor = .red
            
            return button
        }()
    
    func setupPostCellLikeButton() {
            contentView.addSubview(postCellLikeButton)
            
            NSLayoutConstraint.activate([
                postCellLikeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 244),
                postCellLikeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
                postCellLikeButton.widthAnchor.constraint(equalToConstant: 44),
                postCellLikeButton.heightAnchor.constraint(equalToConstant: 44)
            ])
        }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(postCellImage)
        contentView.addSubview(postCellLikeButton)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
