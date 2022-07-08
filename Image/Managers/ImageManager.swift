//
//  ImageManager.swift
//  Image
//
//  Created by Влад on 05.07.2022.
//

import Foundation


class ImageManager: ObservableObject {
    
    @Published private(set) var imageArray: ImageModel?
    
    @Published var search: Bool = false
    
    @Published var isSelectedLarge = false
    @Published var isSelectedMedium = false
    @Published var isSelectedIcon = false
    
    @Published var location = Location.NoSelection
    @Published var languages = Languages.NoSelection
    
    enum Location: String, CaseIterable, Identifiable {
        case Russia
        case UnitedStates = "United States"
        case Brazil
        case Mexico
        case Japan
        case Indonesia
        case Germany
        case NoSelection = "No Selection"
        
        var id:String { self.rawValue }
    }
    
    enum Languages: String, CaseIterable, Identifiable {
        case Russian
        case English
        case Portuguese
        case Spanish
        case Japanese
        case Indonesian
        case German
        case NoSelection = "No Selection"
        
        var id:String { self.rawValue }
    }
    
    func startSearchImage(searchString: String) async throws {
        
        DispatchQueue.main.async {
            self.search = true
        }
        defer {
            DispatchQueue.main.async {
                self.search = false
            }
        }
        
        var toolsURL = ""
        var currentLocation: String?
        
        if isSelectedLarge || isSelectedIcon || isSelectedMedium {
            var tools = "&tbs="
            switch Bool(){
                case isSelectedLarge:  tools = tools + "l"
                case isSelectedMedium: tools = tools + "m"
                case isSelectedIcon: tools = tools + "i"
                default : tools = ""
            }
            toolsURL = tools
        }
        
        switch location {
            case .Brazil: currentLocation = "&gl=br"
            case .Germany: currentLocation = "&gl=de"
            case .Indonesia: currentLocation = "&gl=id"
            case .Japan: currentLocation = "&gl=jp"
            case .Mexico: currentLocation = "&gl=mx"
            case .Russia: currentLocation = "&gl=ru"
            case .UnitedStates: currentLocation = "&gl=us"
            case .NoSelection : currentLocation = ""
        }
        
        switch languages {
            case .Portuguese: currentLocation = "&gl=pt"
            case .German: currentLocation = "&gl=de"
            case .Indonesian: currentLocation = "&gl=id"
            case .Japanese: currentLocation = "&gl=ja"
            case .Spanish: currentLocation = "&gl=es"
            case .Russian: currentLocation = "&gl=ru"
            case .English: currentLocation = "&gl=en"
            case .NoSelection : currentLocation = ""
        }
        
        guard let url = URL(string: "https://serpapi.com/search.json?engine=google&q=\(searchString)\(currentLocation!)&tbm=isch&start=0&num=20&ijn=0\(toolsURL)&api_key=5fcce852d130b772b17e89c928e23ead4e3e82425ee0d4eae8bd01b7002706f2".encodeUrl) else { fatalError("Missing URL")}
        
        let urlRequest = URLRequest(url: url)
        
        let (data, responce) = try await URLSession.shared.data(for: urlRequest)
        
        guard (responce as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching image") }
        
        do {
            let decodeData = try JSONDecoder().decode(ImageModel.self, from: data)
            DispatchQueue.main.async {
                self.imageArray = decodeData
            }
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        
    }
}
