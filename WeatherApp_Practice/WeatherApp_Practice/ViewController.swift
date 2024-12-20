//
//  ViewController.swift
//  WeatherApp_Practice
//
//  Created by t2023-m0033 on 12/6/24.
//

import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController {
    
    private var datasource = [ForecastWeather]()
    
    //URL 쿼리 아이템들
    // 서울역 위경도
    private let urlQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "lat", value: "37.5"),
        URLQueryItem(name: "lon", value: "126.9"),
        URLQueryItem(name: "appid", value: "d856e8326311d6b4b7f6823025451b67"),
        URLQueryItem(name: "units", value: "metric")
    ]
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "서울특별시"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 50)
        return label
    }()
    private let tempMinLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    private let tempMaxLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    private let tempStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 20
        sv.distribution = .fillEqually
        return sv
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var tabelView: UITableView = {
        let tabelView = UITableView()
        tabelView.backgroundColor = .black
        // delegate: "대리자, 대신 수행을 해주는 사람 - 테이블뷰의 여러가지 속성 세팅을 이 뷰컨에서 대신 세팅해주는 코드를 작성하겠다.
        tabelView.delegate = self
        // datasource : 테이블 뷰 안에 집어넣을 데이터들, 이 뷰컨에서 세팅해주겠다.
        tabelView.dataSource = self
        // 테이블 뷰에다가 테이블 뷰 셀 등록
        tabelView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tabelView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchCurrentWeatherData()
        fetchForecastData()
    }
    
    // 제네릭, codable을 채택한 타입으로 ,  escaping 클로저, 탈출
    // 보통적인 코드들은 함수 안에서 작성되었을 때 함수가 끝나면 같이 소멸됨, escaping 은 이 메서드가 끝나도 탈출해서 언제든지 실행 될 수 있다
    // T로 사용하는 이유 -> url을 두가지를 받아올거기 때문에, 재활용 가능
    // 서버 데이터를 불러오는 메서드
    private func fetchData<T: Decodable>(url: URL, completion: @escaping (T?) -> Void) {
        let session = URLSession(configuration: .default)
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else {
                print("데이터 로드 실패")
                completion(nil)
                return
            }
            // http status code 성공 범위는 200번대
            let succesRange = 200..<300
            if let response = response as? HTTPURLResponse, succesRange.contains(response.statusCode) {
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    print("JSON 디코딩 실패")
                    completion(nil)
                    return
                }
                completion(decodedData)
            } else {
                print("응답 오류")
                completion(nil)
            }
        }.resume()
    }
    
    // Alamofire 를 사용해서 서버 데이터를 불러오는 메서드
    private func fetchDateByAlamofire<T: Decodable>(url: URL, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    // 서버에서 현재 날씨 데이터를 받아오는 메서드
    private func fetchCurrentWeatherData() {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
        urlComponents?.queryItems = self.urlQueryItems
        
        guard let url = urlComponents?.url else {
            print("잘못된 URL")
            return
        }
        
        fetchDateByAlamofire(url: url) { [weak self] (result: Result<CurrentWeatherResult, AFError>) in
            guard let self else { return }
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.tempLabel.text = "\(Int(result.main.temp))°C"
                    self.tempMinLabel.text = "최소: \(Int(result.main.tempMin))°C"
                    self.tempMaxLabel.text = "최고: \(Int(result.main.tempMax))°C"
                }
                
                guard let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(result.weather[0].icon)@2x.png") else { return }
                
                // Alamofire 를 사용한 이미지 로드
                AF.request(imageUrl).responseData { response in
                    if let data = response.data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.imageView.image = image
                        }
                    }
                }
            case .failure(let error):
                print("데이터 로드 실패: \(error)")
            }
        }
        
//        fetchData(url: url) { [weak self] (result: CurrentWeatherResult?) in
//            guard let self, let result else { return }
//            
//            DispatchQueue.main.async {
//                self.tempLabel.text = "\(Int(result.main.temp))°C"
//                self.tempMinLabel.text = "최소: \(Int(result.main.tempMin))°C"
//                self.tempMaxLabel.text = "최고: \(Int(result.main.tempMax))°C"
//            }
//            
//            guard let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(result.weather[0].icon)@2x.png") else { return }
//            
//            // image를 로드하는 작업은 백그라운드 쓰레드에서 작업
//            if let data = try? Data(contentsOf: imageUrl) {
//                if let image = UIImage(data: data) {
//                    
//                    DispatchQueue.main.async {
//                        self.imageView.image = image
//                    }
//                }
//            }
//        }
    }
    
    // 서버에서 5일간 날씨 예보 데이터를 불러오는 메서드
    private func fetchForecastData() {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast")
        urlComponents?.queryItems = self.urlQueryItems
        
        guard let url = urlComponents?.url else {
            print("잘못된 URL")
            return
        }
        
        fetchDateByAlamofire(url: url) { [weak self] (result: Result<ForecastWeatherResult, AFError>) in
            guard let self else { return }
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.datasource = result.list
                    self.tabelView.reloadData()
                }
            case .failure(let error):
                print("데이터 로드 실패: \(error)")
            }
        }
        
        
//        fetchData(url: url) { [weak self] (result: ForecastWeatherResult?) in
//            guard let self, let result else { return }
//            
//            //콘솔에다가 데이터를 잘 불러왔는지 찍어보기
//            for forecastWeather in result.list {
//                print("\(forecastWeather.main)\n\(forecastWeather.dtTxt)\n\n")
//            }
//            
//            DispatchQueue.main.async {
//                self.datasource = result.list
//                self.tabelView.reloadData()
//            }
//        }
    }
    private func configureUI() {
        view.backgroundColor = .black
        [
            titleLabel,
            tempLabel,
            tempStackView,
            imageView,
            tabelView
        ].forEach { view.addSubview($0)}
        
        [
            tempMinLabel,
            tempMaxLabel
        ].forEach{ tempStackView.addArrangedSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(120)
        }
        tempLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        tempStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tempLabel.snp.bottom).offset(10)
        }
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(160)
            $0.top.equalTo(tempStackView.snp.bottom).offset(20)
        }
        tabelView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
        }
        
    }
}

extension ViewController: UITableViewDelegate {
    // 테이블 뷰 셀 높이 크기 지정.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
}

extension ViewController: UITableViewDataSource {
    // 테이블 뷰의 IndexPath  마다 테이블 뷰 셀을 지정
    // indexPath = 테이블 뷰의 행과 섹션을 의미 row, section
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id) as? TableViewCell else { return UITableViewCell() }
        cell.configureCell(forecastWeather: datasource[indexPath.row])
        return cell
    }
    
    // 테이블 뷰 섹션의 행이 몇개 들어가는가, 여기서 섹션은 없으니 총 행 갯수 입력
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource.count
    }
}



