# interviewStudy

**프로젝트 기간: 2022년 2월 14일 ~ 2022.03.01**

&nbsp; 


## 프로젝트 설명
현재 상영중인 영화정보를 보여주는 어플리케이션 입니다.<br>
&nbsp;  
&nbsp; 

## 목차
+ [실행 화면](#실행-화면)
+ [핵심 경험](#핵심-경험)
    1. [MVVM 패턴 적용](#1-mvvm-패턴-적용)
    2. [Debounce 적용](#2-debounce-적용)
    3. [Infinite scroll 적용](#3-infinite-scroll-적용)


&nbsp;

## 실행 화면
|상황|메인 화면|검색 화면|
|--|--|--|
||<img width=300 src="https://user-images.githubusercontent.com/52707151/163806204-5e586c2a-d120-4081-b362-d717b4a62690.gif">|<img width=300 src="https://user-images.githubusercontent.com/52707151/163806069-0f6805e8-f9ce-48e1-be95-f265fa8513b4.gif">|




&nbsp;
# 핵심 경험

## 1. MVVM 패턴 적용 

+ 뷰와 데이터 관련 로직들의 결합도가 높아지는 문제를 해결하고자 MVVM 패턴을 도입했습니다.
&nbsp;


## 2. Debounce 적용
+ 연속적으로 수정되는 텍스트의 마지막 입력값으로 검색을 진행하여, 불필요한 네트워크 통신을 줄일수 있었습니다.
  ```swift
  func debounce(action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        guard let validWorkItem = workItem else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: validWorkItem) // UI관련이면 mainThread
    }
  ```
&nbsp;


## 3. Infinite scroll 적용
+ Pagination을 하는 방법은 총 3가지가 있다.
  + scrollYoffset
  ```swift
  extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let heightRemainBottom = contentHeight - yOffset
        
        let frameHeight = scrollView.frame.size.height
        if heightRemainBottom < frameHeight {
            //데이타 로드
            }
        }
    }
  ```
  &nbsp;
  + willDisplayCell
  ```swift
  extension ViewController {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row > itemList.count -4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { 
                if collectionView.visibleCells.contains(cell) {
                    //데이타 로드
                  }
              }
          }
      }
  }
  ```
  &nbsp;
  + prefetchRow 
  ```swift
  extension ViewController: UICollectionViewDataSourcePrefetching {
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
      for indexPath in indexPaths {
          if indexPath.item  == itemlList.count {
              //데이타 로드
            }
        }
     }
  }
