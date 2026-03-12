import UIKit
import Foundation


final class UserImage : Codable {
    
    var imageName : String
    var description : String
    var isFavorite : Bool
    
    init(imageName: String, description: String, isFavorite: Bool) {
        
        self.imageName = imageName
        self.description = description
        self.isFavorite = isFavorite
    }
    
    var userImage: UIImage? {
        
            return UIImage(named: imageName)
        }
        
       
}
