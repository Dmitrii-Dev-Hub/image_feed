import UIKit


final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    var postCellImage = UIImageView()
    var postCellHeartButton = UIButton()
    var postCellDataLabel = UILabel()
    
    private lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "d MMMM yyyy"

            return formatter
        }()
    
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
    
    func setupPostCellHeartButton() {
        postCellHeartButton.setImage(UIImage(named: "Active"), for: .normal)
        postCellHeartButton.translatesAutoresizingMaskIntoConstraints = false
        postCellHeartButton.backgroundColor = .clear
        
    }
    
    func setupCell(post: Image, isActive: Bool) {
        postCellImage.layer.cornerRadius = 16
        postCellImage.clipsToBounds = true
        postCellImage.translatesAutoresizingMaskIntoConstraints = false
        postCellImage.contentMode = .scaleAspectFill
        postCellImage.image = UIImage(named: post.image)
        
        let imageName = isActive ? "Active" : "No Active"
        postCellHeartButton.setImage(UIImage(named: imageName), for: .normal)

        setupPostCellDataLabel()
        
    }
    
    func setupPostCellDataLabel() {
        let currentDate = Date()
        postCellDataLabel.translatesAutoresizingMaskIntoConstraints = false
        postCellDataLabel.text = dateFormatter.string(from: currentDate)
        postCellDataLabel.textColor = .ypWhite
        postCellDataLabel.font = UIFont.systemFont(ofSize: 13)
        postCellDataLabel.textAlignment = .left
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            //Button
            postCellHeartButton.topAnchor.constraint(
                equalTo: postCellImage.topAnchor, constant: 0),
            postCellHeartButton.trailingAnchor.constraint(
                equalTo: postCellImage.trailingAnchor, constant: 0),
            postCellHeartButton.widthAnchor.constraint(
                equalToConstant: 44),
            postCellHeartButton.heightAnchor.constraint(
                equalToConstant: 44),
            
            //Image
            postCellImage.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: 8),
            postCellImage.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            postCellImage.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            postCellImage.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -8),
            
            //Data
            postCellDataLabel.leadingAnchor.constraint(
                equalTo: postCellImage.leadingAnchor, constant: 8),
            postCellDataLabel.bottomAnchor.constraint(
                equalTo: postCellImage.bottomAnchor, constant: -8),
            //postCellDataLabel.trailingAnchor.constraint(
               // equalTo: contentView.trailingAnchor, constant: -8),
           // postCellDataLabel.heightAnchor.constraint(equalToConstant: 20)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
