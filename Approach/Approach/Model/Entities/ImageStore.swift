//
//  ImageStore.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//

import Foundation
import UIKit
import SwiftUI


class ImageStore: ObservableObject {
    @Published var imagesCache = [URL:UIImage]()
    
    let defaultImage = UIImage(named: "none-png-2")!
    
    static var shared = ImageStore()
    
    func image(url: URL?) -> UIImage {
        
        guard let url = url else {
            return defaultImage
        }
        
        if let img = imagesCache[url]{
            return img
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let img = UIImage(data: data){
                DispatchQueue.main.async {
                    self.imagesCache[url] = img
                }
            }
            else{
                print("No entro en imagestore")
            }
        }
        return defaultImage
    }
    
    
}
