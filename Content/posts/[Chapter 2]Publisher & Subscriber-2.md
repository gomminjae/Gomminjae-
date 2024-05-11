---
date: 2024-05-06 15:04
description: Let's combine study
tags: swift,combine
---

# [Chapter 2]Publisher & Subscriber - 2

## Subscribing with assign(to: on:)

`sink외에도` 내장된 `assign` 연산자를 통해 수신된 값을 개체의 KVO 속성에 할당할 수 있습니다. 

## 예시

```swift
example(of: "assign(to:on:)") {
  // 1
  class SomeObject {
    var value: String = "" {
      didSet {
        print(value)
      }
    }
  }
  
  // 2
  let object = SomeObject()
  
  // 3
  let publisher = ["Hello", "world!"].publisher
  
  // 4
  _ = publisher
    .assign(to: \.value, on: object)
}
```

1. SomeObject 클래스를 정의합니다 
2. 해당 클래스의 인스턴스를 생성합니다
3. 문자열 배열의 publisher를 생성합니다 
4. publisher를 subscription하여 값을 object에 할당합니다

결과는 다음과 같습니다. 

```swift
——— Example of: assign(to:on:) ———
Hello
world!
```

그러면 `sink`와 `ssign`의 차이점이 무엇인가? 라고 생각이 들겁니다. sink와 assign의 차이점은 다음과 같습니다. 

1. **`sink`는 값을 수신하면 클로저를 호출하고 클로저 내에서 값을 처리합니다. 즉, 클로저 내에서 명시적으로 원하는 동작을 구현할 수 있습니다.**
2. **`assign`은 값을 수신하면 해당 값을 속성에 직접 할당하는 방식입니다. 이는 보통 UI 업데이트와 같은 경우에 많이 사용됩니다.** 
3. **또한 `sink`는 수동으로 subscription을 취소할 수 있습니다(cancellable return) 그러나 `assign`은 객체의 수명주기에 따라 자동으로 subscription이 취소됩니다.**

## Republishing with assign(to:)

`@Published`라는 속성 래퍼로 표시된 다른 속성을 통해 `publisher`가 방출하는 값을 다시 사용할 수 있습니다. 예제는 다음과 같습니다

```swift
example(of: "assign(to:)") {
  // 1
  class SomeObject {
    @Published var value = 0
  }
  
  let object = SomeObject()
  
  // 2
  object.$value
    .sink {
      print($0)
    }
  
  // 3
  (0..<10).publisher
    .assign(to: &object.$value)
}
```

1. `@Published` 로 어노테이팅된 프로퍼티인 value를 생성합니다 
2. `$` 접두사를 사용하여 `@Publushed`프로퍼티에 접근할 권한을 얻고 이를 구독하면서 수신된 값을 print합니다. 
3. 0~9까지의 숫자 `publisher`를 만들고 이것을 `assign(to:)`를 이용하여 각 value를 &object.$value를 이용하여 속성에 대한 참조를 진행합니다. 

`assign(to:)`는 `AnyCancellable`을 리턴하지 않습니다. **object의 @Published가 deinit되는 시점에 취소를 진행합니다.  이 함수는 객체의 생명주기를 따릅니다.** 

```swift
class MyObject {
  @Published var word: String = ""
  var subscriptions = Set<AnyCancellable>()

  init() {
    ["A", "B", "C"].publisher
      .assign(to: \.word, on: self)
      .store(in: &subscriptions)
  }
}
```

이 예시는 `assign(to:on:)`을 이용하여 저장하고 `AnyCancellable`에 `강한 참조 순환`을 일으킵니다. 이 방식은 assign(to: &$word) 문제를 예방할 수 있습니다.  `@Published` 속성으로 선언되어 있으면 더이상 &기호를 사용하지 않고 속성에 값을 할당할 수 있다는 장점이 있습니다.
