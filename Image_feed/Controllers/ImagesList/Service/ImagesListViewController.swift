
import ProgressHUD
import UIKit

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {

    
    
    var presenter: ImagesListPresenterProtocol?

    init(presenter: ImagesListPresenterProtocol? = nil) {
           self.presenter = presenter
           
           super.init(nibName: nil, bundle: nil)
       }
       
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //    private let servers = ImagesListService.shared
    //    var photos = [Photo]()
    private let tableView = UITableView(
        frame: .zero,
        style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
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
    //    func dismissProgressHUD() {
    //        Image_feed.UIBlockingProgressHUD.dismiss()
    //    }
    //    func showProgressHUD() {
    //        Image_feed.UIBlockingProgressHUD.show()
    //    }
    
    func showProgressHUD() {
        UIBlockingProgressHUD.show()
    }
    
    func dismissProgressHUD() {
        UIBlockingProgressHUD.dismiss()
    }
    
    @objc internal func updateTableViewAnimated() {
        
        guard let (oldCount, newCount) = presenter?.updatePhotosAndGetCounts() else { return }
        
        guard oldCount != newCount else { return }
        
        let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    
    
    //        presenter.getPhoto
    //        let oldCount = photos.count
    //        let newPhotos = ImagesListService.shared.photos
    //        let newCount = newPhotos.count
    //
    //        guard oldCount != newCount else { return }
    //
    //        let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
    //        photos = newPhotos
    //        tableView.performBatchUpdates {
    //            tableView.insertRows(at: indexPaths, with: .automatic)
}








extension ImagesListViewController: UITableViewDelegate {
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        //        let photo = photos[indexPath.row]
    //        guard let photo = presenter?.getPhoto(at: indexPath.row) else {
    //            return UIImage(named: "PlaceholderCellImage")?.size.height ?? 0
    //        }
    //        
    //        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    //        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
    //        
    //        let imageWidth = photo.size.width
    //        let imageHeight = photo.size.height
    //        let scale = imageViewWidth / imageWidth
    //        let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
    //        
    //        return cellHeight
    //    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.getPhoto(at: indexPath.row) else {
            return UIImage(named: "PlaceholderCellImage")?.size.height ?? 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    
    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedPhoto = presenter?.getPhoto(at: indexPath.row)
            let singleImageVC = SingleImageViewController()
            let url = presenter?.getPhoto(at: indexPath.row)?.largeImageURL
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
            return presenter?.getPhotosCount() ?? 0
        }
    
    //    func tableView(_ tableView: UITableView,
    //                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        guard let cell = tableView.dequeueReusableCell(
    //            withIdentifier: ImagesListCell.reuseIdentifier,
    //            for: indexPath) as? ImagesListCell else {
    //            return UITableViewCell()
    //        }
    //        let image = presenter.getPhotosCount()
    //        cell.delegate = self
    //        cell.setupCell(post: ImagesListPresenter.photos)
    //        return cell
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let imageListCell = tableView.dequeueReusableCell(
                withIdentifier: ImagesListCell.reuseIdentifier,
                for: indexPath
            ) as? ImagesListCell
        else {
            return UITableViewCell()
        }
        
        guard
            let photo = presenter?.getPhoto(at: indexPath.row)
        else {
            return imageListCell
        }
        
        imageListCell.delegate = self
        imageListCell.configCell(in: tableView, with: indexPath, photo: photo)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let thresholdIndex = (presenter?.getPhotosCount() ?? 0) - 3
        if indexPath.row == thresholdIndex {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
    
}

extension ImagesListViewController: ImagesListCellDelegate {
    //    func imageListCellDidTapLike(_ cell: ImagesListCell) {
    //        guard let indexPath = tableView.indexPath(for: cell) else { return }
    //
    //        UIBlockingProgressHUD.show()
    //        servers.changeLike(photoId: photo.id, isLiked: photo.isLiked) { [weak self] result in
    //            guard let self = self else { return }
    //            switch result {
    //            case .success(let newPhoto):
    //                self.photos[indexPath.row] = newPhoto
    //                cell.setIsLiked(newPhoto.isLiked)
    //            case .failure(let error):
    //                print(error)
    //            }
    //            UIBlockingProgressHUD.dismiss()
    //        }
    //    }
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        presenter?.changeLike(at: indexPath.row) { [weak self] result in
            switch result {
            case .success(let isLiked):
                cell.setIsLiked(isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ImagesListViewController {
    
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

