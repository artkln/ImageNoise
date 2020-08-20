import UIKit

class ViewController: UIViewController {

//    Объявление объектов для хранения изображений
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var fullScreenImage: UIImageView!
    
//    Функция, работающая сразу после загрузки приложения
    override func viewDidLoad() {
        super.viewDidLoad()
        fullScreenImage.isHidden = true
        fullScreenImage.alpha = 0
        
//        Создание распознавателей нажатия на картинки
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(firstImageTapped(tapGestureRecognizer1:)))
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(secondImageTapped(tapGestureRecognizer2:)))
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(fullScreenImageTapped(tapGestureRecognizer3:)))
        
//        Включение возможности картинок реагировать на действия пользователя
//        Добавление распознавателей к соответствующим картинкам
        firstImage.isUserInteractionEnabled = true
        firstImage.addGestureRecognizer(tapGestureRecognizer1)
        secondImage.isUserInteractionEnabled = true
        secondImage.addGestureRecognizer(tapGestureRecognizer2)
        fullScreenImage.isUserInteractionEnabled = true
        fullScreenImage.addGestureRecognizer(tapGestureRecognizer3)
    }
    
//    Организация и анимация появления картинки в полноэкранном режиме
    private func fullScreenImageAction(image: UIImage) {
        fullScreenImage.isHidden = false
        fullScreenImage.contentMode = .scaleAspectFill
        fullScreenImage.clipsToBounds = true
        fullScreenImage.image = image
        
        fullScreenImage.alpha = 0
        UIImageView.animate(withDuration: 1, animations: {
           self.fullScreenImage.alpha = 1
        }) { _ in
            self.fullScreenImage.alpha = 1
        }
    }

//    Метод для обработки нажатия на левую картинку
    @objc func firstImageTapped(tapGestureRecognizer1: UITapGestureRecognizer)
    {
        let tappedImageView = tapGestureRecognizer1.view as! UIImageView
        fullScreenImageAction(image: tappedImageView.image!)
    }
    
//    Метод для обработки нажатия на правую картинку
    @objc func secondImageTapped(tapGestureRecognizer2: UITapGestureRecognizer)
    {
        let tappedImageView = tapGestureRecognizer2.view as! UIImageView
        fullScreenImageAction(image: tappedImageView.image!)
        fullScreenImage.addSubview(UIImageView(image: fullScreenImage.image!.tinted()))
    }
    
//    Метод для обработки нажатия на полноразмерную картинку
    @objc func fullScreenImageTapped(tapGestureRecognizer3: UITapGestureRecognizer)
    {
//        Анимация исчезновения картинки
        fullScreenImage.alpha = 1
        UIImageView.animate(withDuration: 1, animations: {
           self.fullScreenImage.alpha = 0
        }) { _ in
            self.fullScreenImage.alpha = 0
        }
        
        for subview in fullScreenImage.subviews as [UIView] {
            subview.removeFromSuperview()
        }
        
        fullScreenImage.isHidden = true
    }
    
//     Метод для обработки нажатия на кнопку загрузки изображения
    @IBAction func loadButtonPressed(_ sender: UIButton) {
        chooseImage(source: .photoLibrary)
    }
}

//     Расширение для класса ViewController
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    Функция для выбора изображения из галереи пользователя с помощью объекта imagePicker
    private func chooseImage(source: UIImagePickerController.SourceType) {
         if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            self.present(imagePicker, animated: true, completion: nil)
         }
     }
    
//     Установление выбранного изображения и готового изображения с шумом на экран
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        firstImage.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        firstImage.contentMode = .scaleAspectFill
        firstImage.clipsToBounds = true
        
        secondImage.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        secondImage.contentMode = .scaleAspectFill
        secondImage.clipsToBounds = true
        secondImage.addSubview(UIImageView(image: secondImage.image!.tinted()))
        
        dismiss(animated: true, completion: nil)
    }
}

//    Расширение для класса UIImage
extension UIImage {
    
//    Функция, располагающая точки с шумом на изображении
    func tinted() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        for _ in 0...80000 {
            let randX = Int.random(in: 0...Int(size.width))
            let randY = Int.random(in: 0...Int(size.height))
            drawCircular(center: CGPoint(x: randX, y: randY))
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
//    Функция, создающая точку с цветом шума
    private func drawCircular(center:CGPoint) {
        let radius = 0.5
        let path = UIBezierPath(arcCenter: center, radius: CGFloat(radius), startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        path.lineWidth = 0.25
        let color = UIColor.white
        color.setFill()
        path.fill()
    }
}
