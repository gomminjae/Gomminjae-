---
date: 2024-05-07 15:04
description: Let's combine study
tags: swift,combine
---


# [Chapter 2]Publisher & Subscriber - 1

> `Combine`의 핵심에는 `Publish protocol`이 있습니다.  이 프로토콜은 시간이 지남에 따라 값들을 하나 이상의 `Subscriber`에게 전송할 수 있는 타입에 대한 요구사항을 정의합니다. `Publisher`는 해당 값들을 포함하는 이벤트를 `publish`하거나 `방출`합니다.
> 

## Publisher 예시 1 (기존 API인 Notification center와 결합)

```swift
import Foundation
import Combine

var subscription = Set<AnyCancellable>()

func example(of desription: String, action: () -> Void) {
    print("\n --- Example of: ", desription, "---")
    action()
}
```
```swift
example(of: "Publisher") {
    let myNotification = Notification.Name("MyNotification")
    
    let publisher = NotificationCenter.default
        .publisher(for: myNotification,object: nil)
    

```

이 코드에서는 

  1. Notification 이름을 생성합니다
  2. `NotificationCenter`의 기본 센터에 액세스하여 해당 `publisher(for:object:)`메서드를 호출하고 반환 값을 지역 상수에 할당합니다.

## publisher 메소드 확인

![publisher](/images/publishermethod.png)

이러한 `publisher` 메소드는 기존의 오래된 **비동기식 api**에서 새로운 대안으로 가는 다리라고 생각할 수 있습니다. 

`publisher`은 2종류의 이벤트를 방출합니다

1. 값(element,value)
2. 완료(Completion event) 

`**publisher**`은 0개 이상의 값을 내보낼 수 있지만 `completion event`는 오직 1개만 방출할 수 있습니다. `publisher`가 `완료 이벤트(completion)`를 방출하면 더 이상 다른 이벤트를 방출 할 수 없습니다. 

## 예시 2

```swift
example(of: "Publisher") {
    let myNotification = Notification.Name("MyNotification")
    
    let publisher = NotificationCenter.default
        .publisher(for: myNotification,object: nil)
    // 3
    let center = NotificationCenter.default

    // 4
    let observer = center.addObserver(
      forName: myNotification,
      object: nil,
      queue: nil) { notification in
          print("Notification received!")
      }
    // 5
    center.post(name: myNotification, object: nil)

    // 6
    center.removeObserver(observer)
    
}
```

이 코드는 다음과 같습니다

1. 기본 알림 센터에 대한 핸들을 가져옵니다
2. 이전에 만든 이름으로 알림을 수신할 observer를 만듭니다. 
3. 알림을 게시 
4. observer를 제거합니다 

결과는 다음과 같습니다 

```text
——— Example of: Publisher ———
Notification received!
```

이 예제는 실제로 `publisher`에서 나오는것이 아니기 때문에 이 `publiser`를 구독할 `subscribe`를 만들어보겠습니다.

# Subscriber

> `Subscriber`는 `publisher`로부터 입력을 받을 수 있는 유형에 대한 요구사항을 정의하는 **protocol 입니다**.
> 

## 예제

```swift
example(of: "Subscriber") {
    let myNotification = Notification.Name("MyNotification")
    let publisher = NotificationCenter.default
        .publisher(for: myNotification,object: nil)
    let center = NotificationCenter.default
```

여기서 알람을 게시한다면 `publisher`은 알림을 내보내지 않습니다. `publisher`은 `subscriber`가 1개 이상 있을 때만 이벤트를 방출합니다.

## Subscribing with sink

```swift
example(of: "Subscriber") {
    let myNotification = Notification.Name("MyNotification")
    let publisher = NotificationCenter.default
        .publisher(for: myNotification,object: nil)
    let center = NotificationCenter.default
    // 1
    let subscription = publisher
        .sink { _ in
            print("Notification received from a publisher!")
        }
		// 2
    center.post(name: myNotification, object: nil)
		// 3
    subscription.cancel()
}
```

    1. sink를 호출하여 subscription을 생성합니다 
    2. notification을 보냅니다 
    3. subscription을 취소합니다. 

```test
——— Example of: Publisher ———
Notification received from a publisher!
```

다음과 같이 출력되는것을 볼 수 있습니다.  sink는 publisher가 내보낸 만큼의 값을 계속해서 받습니다. 이것을 *unlimited demand(무제한 수요)*라고 부릅니다. 

![sink](/images/sink.png)

사진과 같이 sink연산자는 실제로 2개의 클로저를 제공합니다. 예제에서는 사용하지 않았지만 이 클로저들은 하나는 완료 이벤트 수신을 처리하고 다른 하나는 값 수신을 처리합니다.  이것들을 보기위해 예제를 추가하겠습니다 

# sink 클로저 예제

```swift
example(of: "Just") {
  // 1
  let just = Just("Hello world!")
  
  // 2
  _ = just
    .sink(
      receiveCompletion: {
        print("Received completion", $0)
      },
      receiveValue: {
        print("Received value", $0)
    })
}
```

1. Just를 이용하여 publisher를 생성합니다. 이것은 single value단위의 publisher입니다. 
2. subscription을 만들어 수신된 각 이벤트에 대한 메시지를 출력합니다. 

다음과 같이 출력됩니다. 수신값을 먼저 출력하고 그 다음 완료 이벤트를 출력하는것을 볼 수 있습니다.

```text
——— Example of: Just ———
Received value Hello world!
Received completion finished
```

구독자를 추가해보겠습니다.

```swift
example(of: "Just") {
  // 1
  let just = Just("Hello world!")
  
  // 2
  _ = just
    .sink(
      receiveCompletion: {
        print("Received completion", $0)
      },
      receiveValue: {
        print("Received value", $0)
    })
	// 구독자 추가
	_ = just
  .sink(
    receiveCompletion: {
      print("Received completion (another)", $0)
    },
    receiveValue: {
      print("Received value (another)", $0)
  })
}
```

```text
--- Example of:  Just ---
Received value Hello world!
Received completion finished
Received value (another) Hello world!
Received completion (another) finished
```

다음과 같이 출력문이 생성됩니다. 두 구독자 모두에게 값이 전달된것을 확인할 수 있습니다.
