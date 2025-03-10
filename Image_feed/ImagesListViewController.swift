

import UIKit

final class ImagesListViewController: UIViewController {
    
    
    private let images = Photo.mockData()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        setupTableView()
        setupConstraintsTableView()
        
        
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
        tableView.allowsSelection = false
        
    }
    
    private func setupConstraintsTableView(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
  }
#Preview(traits: .portrait) {
    ImagesListViewController()
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = UIImage(named: images[indexPath.row].image)
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        
        let imageWidth = (photo?.size.width)!
        let scale = imageViewWidth / imageWidth
        let cellHeight = (photo?.size.height)! * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as! ImagesListCell
            
            let image = images[indexPath.row]
        
            let isActive = indexPath.row % 2 == 0
        
            cell.setupCell(post: image, isActive: isActive)
            
            return cell
        }
}
