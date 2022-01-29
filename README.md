# 💲tocky
매입원가 평균법으로 나스닥(NASDAQ) 투자종목의 수익성을 계산 할 수 있는 앱


## 🧑‍💻 활용 / 배운 기술
- **UIKit / Storyboard**
- **Combine**
- **MVC 디자인 패턴**
- **Rest API 통신**
- **Unit Testing**

## 🛠 라이브러리
- **MBProgressHUD** - https://github.com/jdg/MBProgressHUD
- **Charts**  -  https://github.com/danielgindi/Charts

## API
#### Alpha Vantage - https://www.alphavantage.com

## 🔥 Troubleshooting

1️⃣ 모든 데이터가 입력되기 전에 그래프가 로딩되는 문제 ✅
  - ViewController가 보여지자마자 그래프가 로딩되기 시작했는데, 로딩되는 시점을 사용자 입력이 완료된 후로 지연하고 싶었다.
  - 기존의 `DataChartViewController` 로 구현했던 그래프를 `UIView` 로 변경
  - Delegate Pattern 을 활용해서 모든 데이터가 입력된 후에 로딩되도록 리팩토링
  - 마지막 입력 데이터로 사용되는 날짜 정보가 입력됐을때, `viewWillDisappear` 에서 Delegate 메서드가 호출되면서 차트 view가 로딩되도록 구현




# 사용 예
## 홈 화면
![alt text](https://github.com/junbangg/Stocky/blob/main/img/1.png?raw=true)

## 검색 기능
![search](https://user-images.githubusercontent.com/33091784/144051586-9b69e49f-5289-41a9-9c4f-ac275d08b847.gif)

## 검색 결과
![searchResult](https://user-images.githubusercontent.com/33091784/144051574-af8e73e7-36b0-44bd-af66-c71ea7266d20.gif)

## 계산 기능
![calculator](https://user-images.githubusercontent.com/33091784/144052656-d1f13703-d06e-485e-84c5-1c576dc49499.gif)


