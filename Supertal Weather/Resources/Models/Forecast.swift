import Foundation

struct Forecast : Codable {
	let coord : Coordinates?
	let weather : [Weather]?
	let base : String?
	let main : Main?
	let visibility : Int?
	let wind : Wind?
	let clouds : Clouds?
	let dt : Int?
	let sys : System?
	let timezone : Int?
	let id : Int?
	let name : String?
	let cod : Int?
    
    var computedWeather: Weather? {
        return weather?.first
    }

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		coord = try values.decodeIfPresent(Coordinates.self, forKey: .coord)
		weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
		base = try values.decodeIfPresent(String.self, forKey: .base)
		main = try values.decodeIfPresent(Main.self, forKey: .main)
		visibility = try values.decodeIfPresent(Int.self, forKey: .visibility)
		wind = try values.decodeIfPresent(Wind.self, forKey: .wind)
		clouds = try values.decodeIfPresent(Clouds.self, forKey: .clouds)
		dt = try values.decodeIfPresent(Int.self, forKey: .dt)
		sys = try values.decodeIfPresent(System.self, forKey: .sys)
		timezone = try values.decodeIfPresent(Int.self, forKey: .timezone)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		cod = try values.decodeIfPresent(Int.self, forKey: .cod)
	}

}

struct Clouds: Codable {
    let all: Int?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        all = try values.decodeIfPresent(Int.self, forKey: .all)
    }

}

struct Coordinates: Codable {
    let lon: Double?
    let lat: Double?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lon = try values.decodeIfPresent(Double.self, forKey: .lon)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
    }
}

struct Main: Codable {
    let temp: Double?
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
    let pressure: Int?
    let humidity: Int?
    
    var celciusTemp: String {
        "\(Int(floor((temp ?? 0) - 273.0)))"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        temp = try values.decodeIfPresent(Double.self, forKey: .temp)
        feels_like = try values.decodeIfPresent(Double.self, forKey: .feels_like)
        temp_min = try values.decodeIfPresent(Double.self, forKey: .temp_min)
        temp_max = try values.decodeIfPresent(Double.self, forKey: .temp_max)
        pressure = try values.decodeIfPresent(Int.self, forKey: .pressure)
        humidity = try values.decodeIfPresent(Int.self, forKey: .humidity)
    }

}

struct System: Codable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Double?
    let sunset: Double?
    
    var computedSunrise: String? {
        let date = Date(timeIntervalSince1970: sunrise ?? 0.0)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM a"
        return formatter.string(from: date)
    }
    
    var computedSunset: String? {
        let date = Date(timeIntervalSince1970: sunset ?? 0.0)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM a"
        return formatter.string(from: date)
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        sunrise = try values.decodeIfPresent(Double.self, forKey: .sunrise)
        sunset = try values.decodeIfPresent(Double.self, forKey: .sunset)
    }

}

struct Weather : Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        main = try values.decodeIfPresent(String.self, forKey: .main)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
    }

}

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    
    var computedSpeed: String? {
        let newSpeed = Int(ceil((speed ?? 1)*3600.0)/1000.0)
        return "\(newSpeed)"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        speed = try values.decodeIfPresent(Double.self, forKey: .speed)
        deg = try values.decodeIfPresent(Int.self, forKey: .deg)
    }
}
