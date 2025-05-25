import Foundation

public protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateProgressValue(_ value: Double)
    func shouldHideProgress(for value: Float) -> Bool
    func code(from url: URL) -> String?
}

