

import UIKit

final class ImagesListViewController: UIViewController {
    
    private let servers = ImagesListService.shared
    private var images = [Photo]()
    private let tableView = UITableView(
        frame: .zero,
        style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypBlack
        view.addSubview(tableView)
        tableView
            .translatesAutoresizingMaskIntoConstraints = false
        setupTableView()
        setupConstraintsTableView()
        
        NotificationCenter.default.addObserver(
               self,
               selector: #selector(updateTableViewAnimated),
               name: ImagesListService.didChangeNotification,
               object: nil
           )

           ImagesListService.shared.fetchPhotosNextPage()
        
    }
    @objc private func updateTableViewAnimated() {
        let oldCount = images.count
        let newPhotos = ImagesListService.shared.photos
        let newCount = newPhotos.count

        guard oldCount != newCount else { return }

        let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
        images = newPhotos
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }

    
    private func setupTableView(){
        tableView.backgroundColor = .ypBlack
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            ImagesListCell.self,
            forCellReuseIdentifier: ImagesListCell.reuseIdentifier
        )
        tableView.allowsSelection = true
    }
    
    private func setupConstraintsTableView(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor)
        ])
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
//    func tableView(
//        _ tableView: UITableView,
//        heightForRowAt indexPath: IndexPath) -> CGFloat {
//            guard let photo = UIImage(
//                named: images[indexPath.row].image) else {
//                return 0
//            }
//            let imageInsets = UIEdgeInsets(
//                top: 4, left: 16, bottom: 4, right: 16)
//            let imageViewWidth = tableView
//                .bounds.width - imageInsets.left - imageInsets.right
//            let imageWidth = photo.size.width
//            let scale = imageViewWidth / imageWidth
//            let cellHeight =
//            photo.size.height * scale + imageInsets
//                .top + imageInsets.bottom
//            return cellHeight
//        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = images[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        
        let imageWidth = photo.size.width
        let imageHeight = photo.size.height
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }

    
    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedPhoto = images[indexPath.row]
            let singleImageVC = SingleImageViewController()
            let url = images[indexPath.row].largeImageURL
            singleImageVC.selectedPhoto = selectedPhoto
            singleImageVC.imageURL = url
            singleImageVC.modalPresentationStyle = .fullScreen
            present(singleImageVC, animated: true, completion: nil)
        }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return images.count
        }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        let image = images[indexPath.row]
//        let isActive = indexPath.row % 2 == 0
        cell.delegate = self
        cell.setupCell(post: image)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let thresholdIndex = images.count - 3
        if indexPath.row == thresholdIndex {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }

}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = images[indexPath.row]
        
        UIBlockingProgressHUD.show()
        servers.changeLike(photoId: photo.id, isLiked: photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let newPhoto):
                self.images[indexPath.row] = newPhoto
                cell.setIsLiked(newPhoto.isLiked)
            case .failure(let error):
                print(error)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}



//#Preview(traits: .portrait) {
//    ImagesListViewController()
//}
