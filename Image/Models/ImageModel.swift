//
//  ImageModel.swift
//  Image
//
//  Created by Влад on 05.07.2022.
//

import Foundation

struct ImageModel: Decodable {
    let imagesResults: [ImagesResult]

    enum CodingKeys: String, CodingKey {
        case imagesResults = "images_results"
    }
}

struct ImagesResult: Decodable {
    let position: Int
    let thumbnail: String
    let source, title: String
    let link: String
    let original: String?
    let isProduct: Bool

    enum CodingKeys: String, CodingKey {
        case position, thumbnail, source, title, link, original
        case isProduct = "is_product"
    }
}
