import Foundation
import Image_feed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: (any Image_feed.ImagesListPresenterProtocol)?
    
    var isShowedProgressHUD = false
    var isCalledUpdateTable = false
    
    func showProgressHUD() {
        isShowedProgressHUD = true
    }
    
    func dismissProgressHUD() {
        
    }
    
    func updateTableViewAnimated() {
        isCalledUpdateTable = true
    }
}
