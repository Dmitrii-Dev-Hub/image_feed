import Foundation

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func showProgressHUD()
    func dismissProgressHUD()
    func updateTableViewAnimated()
}

