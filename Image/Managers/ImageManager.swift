//
//  ImageManager.swift
//  Image
//
//  Created by Влад on 05.07.2022.
//

import Foundation


class ImageManager: ObservableObject {
    ///Массив для хранения информации от api
    @Published private(set) var imageArray: ImageModel?
    ///Переменная указывающая совершается ли сейчас запрос
    @Published var search: Bool = false
    ///Переменные для настройки размера изображений
    @Published var isSelectedLarge = false
    @Published var isSelectedMedium = false
    @Published var isSelectedIcon = false
    ///Переменные для выбора языка и страны
    @Published var location = Location.NoSelection
    @Published var languages = Languages.NoSelection
    ///Перечисление для типов страны
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
    ///Перечисленения для типов языка
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
    ///Функция которая собирает ссылку для запроса и выполняет его
    func startSearchImage(searchString: String) async throws {
        ///Применяет значение true для переменной когда поиск начался
        DispatchQueue.main.async {
            self.search = true
        }
        ///Когда функция завершила свое выполнение переменной присваивается значение false
        defer {
            DispatchQueue.main.async {
                self.search = false
            }
        }
        ///Переменные для параметров поиска
        var toolsURL = ""
        var currentLocation: String
        var currentLanguages: String
        ///Условие определяет был ли выбран размер изображения
        if isSelectedLarge || isSelectedIcon || isSelectedMedium {
            var tools = "&tbs="
            ///Определяет какой размер был выбран
            switch Bool(){
                case isSelectedLarge:  tools = tools + "l"
                case isSelectedMedium: tools = tools + "m"
                case isSelectedIcon: tools = tools + "i"
                default : tools = ""
            }
            toolsURL = tools
        }
        ///Определяет какая страна была выбрана
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
        ///Определяет какой был выбран язык
        switch languages {
            case .Portuguese: currentLanguages = "&gl=pt"
            case .German: currentLanguages = "&gl=de"
            case .Indonesian: currentLanguages = "&gl=id"
            case .Japanese: currentLanguages = "&gl=ja"
            case .Spanish: currentLanguages = "&gl=es"
            case .Russian: currentLanguages = "&gl=ru"
            case .English: currentLanguages = "&gl=en"
            case .NoSelection : currentLanguages = ""
        }
        ///Проверяет ссылку на коректность и создает константу с этой ссылкой
        guard let url = URL(string: "https://serpapi.com/search.json?engine=google&q=\(searchString)\(currentLocation)\(currentLanguages)&tbm=isch&start=0&num=20&ijn=0\(toolsURL)&api_key=5fcce852d130b772b17e89c928e23ead4e3e82425ee0d4eae8bd01b7002706f2".encodeUrl) else { fatalError("Missing URL")}
        
        let urlRequest = URLRequest(url: url)
        ///Выполняет запрос в сеть с помощью реквеста
        let (data, responce) = try await URLSession.shared.data(for: urlRequest)
        ///Проверка на наличие доступа по ссылке
        guard (responce as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching image") }
        ///Данный блок при ожитающихся обстоятельствах выполняет декодирование JSON файла и присваивает его массиву
        ///Если при выполнении этих операции возникли какие-либо ошибки, он выводит их в консоль
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
