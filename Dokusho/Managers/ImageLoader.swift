//
//  ImageLoader.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/30/23.
//

import Foundation
import UIKit
import NukeUI

final public class ImageLoader {
    
    static let shared = ImageLoader()
    
    func loadImage(url: String) async {
        let imageUrl = URL(string: url)
        guard imageUrl != nil else {return}
    }

}
