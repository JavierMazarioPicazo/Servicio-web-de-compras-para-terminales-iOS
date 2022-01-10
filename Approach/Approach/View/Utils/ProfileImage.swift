//
//  ProfileImage.swift
//  Approach
//
//  Created by Javier Mazario on 2/11/21.
//

import Foundation
import SwiftUI

struct ProfileImage: View {
    
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
        .resizable()
        .frame(width: 110, height: 110)
        .clipShape(Circle())
    }
}
