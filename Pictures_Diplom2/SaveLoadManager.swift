import KeychainSwift
import UIKit
import Foundation

final class SaveLoadManager {
    
    enum Keys: String {
        
        case passwordCreate
        case imageName
        case savedImages
        case userImage
        case userImageArray
    }
    
    private let defaults = UserDefaults.standard
    
    func savePassword (_ passwordCreate: Bool) {
        defaults.set(passwordCreate, forKey: Keys.passwordCreate.rawValue)
        
    }
    func loadPassword(for key: Keys) -> Bool? {
        return defaults.object(forKey: key.rawValue) as? Bool
        
    }
    
    func saveUserImage(_ userImage: UserImage) {
        
        UserDefaults.standard.set(encodable: userImage, forKey: Keys.userImage.rawValue)
    }
    func loadUserImage() -> UserImage {
        
        UserDefaults.standard.get(decodableType: UserImage.self, forKey: Keys.userImage.rawValue) ?? UserImage(imageName: "plus", description: "", isFavorite: false)
    }
    
    func saveUserImagesArray (_ userImages: [UserImage])  {
        
        UserDefaults.standard.set(encodable: userImages, forKey: Keys.userImageArray.rawValue)
    }
    func loadUserImagesArray() -> [UserImage] {
        
        UserDefaults.standard.get(decodableType: [UserImage].self, forKey: Keys.userImageArray.rawValue) ?? []
    }
    
    func saveImage (image: UIImage) -> String? {
         
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{return nil}
        
        let filename = UUID().uuidString
        let fileURL = directory.appendingPathComponent(filename)
        
        guard let data = image.pngData() else {return nil}
        
        do {
            try data.write(to : fileURL)
            return filename
        } catch let error {
            
            print (error.localizedDescription)
            return nil
        }
    }
    
    func loadImage (name: String) -> UIImage? {
        
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        
        let fileURL = directory.appendingPathComponent(name)
        return UIImage (contentsOfFile: fileURL.path)
        
    }
    
    func removeImage(name: String) {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentsDirectory.appendingPathComponent(name)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            try? fileManager.removeItem(at: fileURL)
        }
    }
    
    func saveImageName(_ text: String) {
        
        defaults.set(text, forKey: Keys.imageName.rawValue)
    }
    
    func loadImageName() -> String? {
        
        return defaults.object(forKey: Keys.imageName.rawValue) as? String
    }
}

extension UserDefaults {
    func set<T: Encodable>(encodable: T?, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func get<T: Decodable>(decodableType: T.Type, forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(decodableType, from: data)
    }
    
}
