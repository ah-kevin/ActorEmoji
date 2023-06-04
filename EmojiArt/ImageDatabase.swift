import UIKit

@globalActor actor ImageDatabase {
  static let shared = ImageDatabase()
  let imageLoader = ImageLoader()
  
  private let storage = DiskStorage()
  private var storedImagesIndex = Set<String>()
}
