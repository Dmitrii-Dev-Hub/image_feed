import Foundation
import Image_feed
import XCTest

final class ImagesListViewControllerFake: ImagesListViewControllerProtocol {
    var presenter: (any Image_feed.ImagesListPresenterProtocol)?
    
    func showProgressHUD() {
        
    }
    
    func dismissProgressHUD() {
        
    }
    
    func updateTableViewAnimated() {
        let (_, _) = presenter!.updatePhotosAndGetCounts()
    }
}
