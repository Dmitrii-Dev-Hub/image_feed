import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func getPhotosCount() -> Int
    func getPhoto(at index: Int) -> Photo?
    func updatePhotosAndGetCounts() -> (Int, Int)
    func nextPage()
    func shouldGetNextPage(for index: Int)
    func changeLike(at index: Int, _ completion: @escaping (Result<Bool, Error>) -> Void)
    func viewDidLoad()
}

