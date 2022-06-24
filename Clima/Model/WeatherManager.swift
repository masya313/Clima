//
//  WeatherManager.swift
//  Clima
//
//  Created by Anastasia Krylova on 23.06.2022.
//

import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    //weatherManager обязательно указываем как аргумент имя того кто вызвал этот метод и присваеваем ему внешнее имя _
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    // без lang=ru
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=YOURAPIKEY&units=metric&lang=ru"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        let urlWhithoutSpace = urlString.replacingOccurrences(of: " ", with: "")
        let encodeUrl = urlWhithoutSpace.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        performRequest(with: encodeUrl!)
    }
    
    func fetchWeather(latitude: String, longitude: String) {
//        let lat = String(format: "%.2f", latitude)
//        let lon = String(format: "%.2f", longitude)
        print(latitude, longitude)
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1. create URL
        if let url = URL(string: urlString) {
            //2. create urlSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. start the task
            task.resume()
            
        }
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let cityName = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: cityName, temperature: temp)
//            print(weather.conditionName)
//            print(weather.temperatureValue)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
