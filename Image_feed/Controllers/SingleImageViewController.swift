
import UIKit

class SingleImageViewController: UIViewController, UIScrollViewDelegate {
    
    private let imageView = UIImageView()
    private let backButton = UIButton()
    private let scrollView = UIScrollView()
    private let shareButton = UIButton()
    var selectedPhoto: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        setupScrollView()
        setupBackButton()
        setupShareButton()
        setupConstraints()
        view.backgroundColor = .ypBlack
        
    }
    
    private func setupImageView() {
        
        imageView
            .translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        guard let photo = selectedPhoto else {
            imageView.image = nil
            return
        }
        imageView.image = UIImage(named: photo.image)
        scrollView.addSubview(imageView)
    }
    
    private func setupScrollView() {
        scrollView
            .translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        
    }
    
    private func setupBackButton() {
        backButton
            .translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(
            UIImage(named: "chevron.backward"), for: .normal)
        backButton.addTarget(
            self, action: #selector(didTapBackButton), for: .touchUpInside)
        view.addSubview(backButton)
    }
    
    private func setupShareButton() {
        shareButton
            .translatesAutoresizingMaskIntoConstraints = false
        shareButton.setImage(
            UIImage(named: "shareButton"), for: .normal)
        shareButton.clipsToBounds = true
        shareButton.layer.cornerRadius = 25.5
        shareButton.backgroundColor = .ypBlack
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        view.addSubview(shareButton)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //
            scrollView.topAnchor.constraint(
                equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            
            //
            imageView.topAnchor.constraint(
                equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor),
            imageView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor),
            imageView.widthAnchor.constraint(
                equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(
                equalTo: scrollView.heightAnchor),
            
            //
            backButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide
                    .topAnchor, constant: 15),
            backButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16),
            backButton.heightAnchor.constraint(
                equalToConstant: 15.49),
            backButton.widthAnchor.constraint(
                equalToConstant: 8.97),
            
            //
            shareButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide
                    .bottomAnchor, constant: -16),
            shareButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            shareButton.heightAnchor.constraint(
                equalToConstant: 51),
            shareButton.widthAnchor.constraint(
                equalToConstant: 51)
            
        ])
    }
    @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    @objc private func didTapShareButton() {
        guard let image = imageView.image else { return }
        
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = shareButton
            popover.sourceRect = shareButton.bounds
            popover.permittedArrowDirections = .down
            present(activityVC, animated: true, completion: nil)
        }
        present(activityVC, animated: true, completion: nil)
    }
}
//#Preview(traits: .portrait) {
//    let vc = SingleImageViewController()
//    vc.selectedPhoto = Photo.mockData().first
//    return vc
//}

