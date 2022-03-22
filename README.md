# 💲tocky
매입원가 평균법으로 나스닥(NASDAQ) 투자종목의 수익성을 계산 할 수 있는 앱

# 사용 예
## 홈 화면
![alt text](https://github.com/junbangg/Stocky/blob/main/img/1.png?raw=true)

## 검색 기능
![search](https://user-images.githubusercontent.com/33091784/144051586-9b69e49f-5289-41a9-9c4f-ac275d08b847.gif)

## 검색 결과
![searchResult](https://user-images.githubusercontent.com/33091784/144051574-af8e73e7-36b0-44bd-af66-c71ea7266d20.gif)

## 계산 기능
![calculator](https://user-images.githubusercontent.com/33091784/144052656-d1f13703-d06e-485e-84c5-1c576dc49499.gif)


## 🧑‍💻 활용 / 배운 기술
- **UIKit / Storyboard**
- **Combine**
- **MVC 디자인 패턴**
- **Unit Testing**

## 🛠 라이브러리
- **MBProgressHUD** - https://github.com/jdg/MBProgressHUD
- **Charts**  -  https://github.com/danielgindi/Charts

## API
#### Alpha Vantage - https://www.alphavantage.com

## UML

## 브랜치 전략


## 🔥 Troubleshooting 및 고민한 점

1️⃣ Date Selector Slider 움직이면 현재가치가 반응적으로 업데이트 되는 기능 ✅
  - `Publishers.CombineLatest3` 를 이용해서 3개의 `Publisher` 의 값을 활용하여 현재가치를 즉각적으로 계산해서 표시
 
2️⃣ 모든 데이터가 입력되기 전에 그래프가 로딩되는 문제 ✅
  - **조금 더 반응성이 좋은 UX를 위해서 그래프가 로딩되는 시점을 사용자 입력이 완료된 후로 지연하고 싶었다.**
  - 기존의 `DataChartViewController` 로 구현했던 그래프를 `UIView` 로 변경
  - Delegate Pattern 을 활용해서 모든 데이터가 입력된 후에 로딩되도록 리팩토링
  - 마지막 입력 데이터로 사용되는 날짜 정보가 입력됐을때, `viewWillDisappear` 에서 Delegate 메서드가 호출되면서 차트 view가 로딩되도록 구현
  - 아예 그래프를 주식종목의 기본 정보로 제공하고, 계산 기능은 따로 분리하는것도 좋겠다는 아이디어도 생겼다. 🤔

3️⃣ 각종 identifier를 Namespace 로 관리했다가 `IdentifiableView` 프로토콜을 구현해서 관리 ✅
  ```swift
  protocol IdentifiableView {
    static var identifier: String { get }
  }

  extension IdentifiableView {
    static var identifier: String {
      return String(describing: self)
    }
  }
  ```
  - identifier가 필요한 타입에 `IdentifiableView` 프로토콜을 채택시켜서 Namespace 없이 문자열 생성해서 사용 가능
 
4️⃣ 한화로 표시하는 기능

5️⃣ Generic APIService 모델 리팩토링

6️⃣ KOSPI 검색 기능 추가

7️⃣ ViewController 의존성 주입 방식으로 적용

8️⃣ Pagination 적용

## 배운 점


