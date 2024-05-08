---
date: 2024-05-07 15:04
description: Let's combine
tags: swift,combine
---
# [Chapter 2]Publisher & Subscriber - 3

## Cancellable

 `subscriber`가 완료되고 더 이상 `publisher`로 부터 값을 받고싶지 않은 경우 `subscription을 취소`하여 리소스를 확보하고 네트워크 호출과 같은 해당 활동의 발생을 중지하는 것이 좋습니다.

 `subscription`은 `AnyCancellable 토큰`을 반환하므로 구독이 끝나면 구독을 취소할 수 있습니다. 이 방법은 `AnyCancellable protocol`을 준수합니다. 

## Understanding what’s going on

![publisher 예제](/images/publisher.png)

1. Subscriber은 publisher를 구독합니다. 
2. publisher은 구독을 생성하여 subscriber에게 제공합니다 
3. subscriber가 값을 요청합니다.
4. publisher은 값을 보냅니다
5. publisher가 completion을 보냅니다 

publisher 프로토콜을 먼저 살펴보겠습니다 

```swift
public protocol Publisher {
  // 1
  associatedtype Output

  // 2
  associatedtype Failure : Error

  // 4
  func receive<S>(subscriber: S)
    where S: Subscriber,
    Self.Failure == S.Failure,
    Self.Output == S.Input
}

extension Publisher {
  // 3
  public func subscribe<S>(_ subscriber: S)
    where S : Subscriber,
    Self.Failure == S.Failure,
    Self.Output == S.Input
}
```

1. `publisher`가 생성할 수 있는 값의 타입니다 
2. `publisher`가 생성할 수 있는 오류의 타입입니다 `Never`을 사용하여 오류를 생성하지 않는다고 보장할 수 있습니다. 
3. `subscriber은 subscribe(_:)`를 사용하여 연결합니다. 

subscriber 프로토콜도 살펴보겠습니다. 

```swift
public protocol Subscriber: CustomCombineIdentifierConvertible {
  // 1
  associatedtype Input

  // 2
  associatedtype Failure: Error

  // 3
  func receive(subscription: Subscription)

  // 4
  func receive(_ input: Self.Input) -> Subscribers.Demand

  // 5
  func receive(completion: Subscribers.Completion<Self.Failure>)
}
```

1. subscriber가 받을 수 있는 값의 타입입니다. 
2. subscriber가 받을 수 있는 오류 타입입니다. 이 또하 Never사용 가능합니다 
3. publisher은 receive(subscription:)로 subscriber을 호출하여 구독을 제공합니다. 
4. publisher은 receive(_:)로 방금 게시한 새 값을 보내도록 subscriber을 호출합니다 
5. publisher은 receive(completion:)을 subscriber에게 전달하고 정상 또는 오류여부를 알려줍니다. 

이렇듯 `publisher`와 `subscriber`간의 연결의 핵심은 `subscription`입니다. 이것은 다음과 같습니다 

```swift
public protocol Subscription: Cancellable, CustomCombineIdentifierConvertible {
  func request(_ demand: Subscribers.Demand)
}
```

subscriber은 request(_:)를 통해 더 많은 데이터를 최대 또는 무제한으로 요청할 수 있음을 나타냅니다. 

## Creating a custom subscriber

```swift
example(of: "Custom Subscriber") {
  // 1
  let publisher = (1...6).publisher
  
  // 2
  final class IntSubscriber: Subscriber {
    // 3
    typealias Input = Int
    typealias Failure = Never

    // 4
    func receive(subscription: Subscription) {
      subscription.request(.max(3))
    }
    
    // 5
    func receive(_ input: Int) -> Subscribers.Demand {
      print("Received value", input)
      return .none
    }
    
    // 6
    func receive(completion: Subscribers.Completion<Never>) {
      print("Received completion", completion)
    }
  }
}
```

1. (1..6)을 방출하는 `publisher`를 생성합니다 
2. 새로운 `subscriber`인 `IntSubscriber`를 정의합니다. 
3. Input타입을 설정해주고 에러는 Never로 에러가 일어나지 않다는것을 보장해줍니다. 
4. `receive(subscription:)`를 구현합니다. 해당 함수는 `.request(.max(3))`을 이용하여 subscriber가 구독시 최대 3개의 값을 receive할 수 있다는 설정을 해줍니다. 
5. 수신된 값을 출력하고 .none은 .max(0)과 같습니다. (더 이상 수신할 의사가 없음을 의미합니다) 
6. 완료 이벤트를 출력합니다. 

결과를 확인해보겠습니다. 

```swift
let subscriber = IntSubscriber()

publisher.subscribe(subscriber)

//echo
——— Example of: Custom Subscriber ———
Received value 1
Received value 2
Received value 3
```

결과를 보면 완료 메세지를 출력하지 않았습니다. 그 이유는 5번 코드를 보면 `.none`으로 한번 수신되면 더이상 받지 않는다고 설정했기 때문에 `publisher`에서 발행된 모든 데이터가 수신되지 않습니다. 수신 최대개수 `.max(3)`까지인 3개만 수신되고 완료메세지가 출력되지 않습니다.

모든 값을 받고 완료 메세지를 출력하도록 수정해보겠습니다. 

```swift
func receive(_ input: Int) -> Subscribers.Demand {
  print("Received value", input)
  return .unlimited
}
//echo
——— Example of: Custom Subscriber ———
Received value 1
Received value 2
Received value 3
Received value 4
Received value 5
Received value 6
Received completion finished
```

이렇듯 `.unlimited`로 제한을 두지않았더니 모든 데이터가 출력되고 완료메세지가 출력되는것을 확인할 수 있습니다. 

## Hello Future

 `Future`은 `Just`와 마찬가지로 단일값을 publish하는 `publisher`입니다. `Future`은 실패하거나 단일 값을 방출한 후 완료됩니다. 그러면 J`ust와 차이점은 무엇인가?` 바로 동기적이냐 비동기적이냐의 차이입니다.Just는 단순히 동기적으로 단일값을 방출하고 완료합니다 이것은 단일값을 즉시 처리하고자 할때 사용됩니다. 그러나 Future은 비동기적으로 작동합니다. 클로저를 통해 작업이 완료되면 값을 발행하고 완료됩니다. 작업이 완료되면 `.success(value)`를 통해 값을 내보내거나 실패시 `.failure`를 통해 에러를 내보낼 수 있습니다.. 

예시로 보겠습니다.

```swift
example(of: "Future") {
    func futureIncrement(
        integer: Int,
        afterDelay delay: TimeInterval) -> Future<Int, Never> {
            Future<Int, Never> { promise in
                DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                    promise(.success(integer + 1))
                }
            }
        }
    // 1
    let future = futureIncrement(integer: 1, afterDelay: 3)
    
    // 2
    future
        .sink(receiveCompletion: { print($0) },
              receiveValue: { print($0) })
        .store(in: &subscription)
}
```

1. future을 생성합니다. 해당 future은 생성 후 3초 딜레이 후 전달한 정수를 1 증가시키는 함수입니다. 
2. 수신된 값과 완료이벤트를 구독 및 출력합니다. 

출력은 다음과 같습니다

```swift
——— Example of: Future ———
2
finished
```

다른 예시를 살펴보겠습니다.

```swift
example(of: "Future") {
    func futureIncrement(
        integer: Int,
        afterDelay delay: TimeInterval) -> Future<Int, Never> {
            Future<Int, Never> { promise in
                print("Original")
                DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                    promise(.success(integer + 1))
                }
            }
        }
    // 1
    let future = futureIncrement(integer: 1, afterDelay: 3)
    
    // 2
    future
        .sink(receiveCompletion: { print($0) },
              receiveValue: { print($0) })
        .store(in: &subscription)
    future
      .sink(receiveCompletion: { print("Second", $0) },
            receiveValue: { print("Second", $0) })
      .store(in: &subscription)
}
```

future 구독 수를 한개 더 늘렸습니다. 또한 Disapqtch queue실행전에 Original을 출력하도록 변경하였습니다. 결과를 확인하면 

```swift
——— Example of: Future ———
Original
2
finished
Second 2
Second finished
```

이렇듯 Future은 값을 무한정 비동기적으로 게시할 수 있습니다. 

##
