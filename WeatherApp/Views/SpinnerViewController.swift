
import UIKit
import Foundation

class SpinnerViewController: UIViewController {
    //Создаем UI элементы
    let rectangleView = UIView()
    let spinner = UIActivityIndicatorView(style: .large)
    let label = UILabel()
    
    override func loadView() {
        //Настройки View
        view = UIView()
        view.backgroundColor = UIColor(white: 0.6, alpha: 0.7)
        
        //Настройки RectangleView
        rectangleView.layer.cornerRadius = 13
        rectangleView.backgroundColor = UIColor(white: 0.3, alpha: 0.4)
        view.addSubview(rectangleView)
        rectangleView.translatesAutoresizingMaskIntoConstraints = false
        rectangleView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        rectangleView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        rectangleView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        rectangleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //Настройки Spinner
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        rectangleView.addSubview(spinner)
        spinner.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //Настройки Label
        label.text = "Loading chat..."
        label.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = UIFont(name: "Arial", size: 22)
        rectangleView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: rectangleView.centerXAnchor, constant: 0).isActive = true
        label.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 10).isActive = true
    }
}
