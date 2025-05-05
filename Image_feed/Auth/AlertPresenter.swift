import UIKit

final class AlertPresenter {
    
    weak var delegate: UIViewController?
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let button = UIAlertAction(title: model.buttonText, style: .default, handler: model.completion)
        alert.addAction(button)
        delegate?.present(alert, animated: true)
    }
}
