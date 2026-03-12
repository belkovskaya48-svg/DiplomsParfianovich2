import UIKit
import SnapKit

final class ImageCell : UICollectionViewCell {
    static var identifier: String  {"\(Self.self)"}
    
     let userImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
         imageView.layer.borderWidth = 2
         imageView.layer.borderColor = UIColor(red: 1.0, green: 0.89, blue: 0.82, alpha: 1.0).cgColor
         imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let textField : UITextField = {
       let textField = UITextField()
        textField.backgroundColor = .clear
        textField.textColor = .black
        return textField
    }()
    

    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

        
        private func configureUI() {
            contentView.addSubview(userImageView)
          
            
            userImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }


        }
        
        func configure(with model: UserImage) {
            
            userImageView.image = nil
            
            if model.imageName == "plus" {
                
                userImageView.image = UIImage(systemName: "plus")
                userImageView.tintColor = .gray
                userImageView.contentMode = .center
                userImageView.backgroundColor = .systemGray6
            } else {
                
                let imageFromFile = SaveLoadManager().loadImage(name: model.imageName)
                
                userImageView.image = imageFromFile
                userImageView.contentMode = .scaleAspectFill
                userImageView.backgroundColor = .clear
            }
            
            textField.text = model.description
        }

    }
    

