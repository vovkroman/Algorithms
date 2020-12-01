# Algorithms

### Description

*Algorithms is an framework inlcuding all algorithms and data structure + some extensions to embeded Swift Collection (see. below) that commonly used for iOS/Mac/tvOS development*. 

Besides that in scope of some algorithm investigation, performance tests have been measured (See. Benchmarks).

### Requirements (Programming language)

Swift 5.2 & Objective-C 2.0

### Algorithm List

- [x] [**Queue**](https://github.com/RoMaN16102012/Algorithms/blob/master/Algorithms/Queue/Swift/Queue.swift) - Queue data structure.
- [x] [**Stack**](https://github.com/RoMaN16102012/Algorithms/tree/master/Algorithms/Stack/Swift) - Stack data structure.
- [x] **Priority Queue** - framework contains Swift implemenation of [Priority Queue](https://github.com/RoMaN16102012/Algorithms/blob/master/Algorithms/PriorityQueue/Swift/PriorityQueue.swift), based on own [Heap](https://github.com/raywenderlich/swift-algorithm-club/blob/master/Heap) implementation, and wrapper around Apple's [CFBinaryHeap](https://developer.apple.com/documentation/corefoundation/cfbinaryheap).
- [x] **Ordered Set** - framework contains own implementation of [Ordered Array](https://github.com/RoMaN16102012/Algorithms/blob/master/Algorithms/SortedArray/Swift/OrderedArray.swift), and [Ordered Set](https://github.com/RoMaN16102012/Algorithms/blob/master/Algorithms/OderedSet/OrderedSet.swift) wrapper arround [NSMutableOrderdSet](https://developer.apple.com/documentation/foundation/nsmutableorderedset).
- [x] [**Segment Tree**](https://github.com/RoMaN16102012/Algorithms/blob/master/Algorithms/SegmentTree/Swift/SegmentTree.swift) - implemenation of Segment Tree, based on own implementation of [Segment Tree](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Segment%20Treet). Besides contains [*Segment Tree*] using [lazy propagation](https://github.com/raywenderlich/swift-algorithm-club/blob/master/Segment%20Tree/LazyPropagation/README.markdown) technic.
- [x] [**LinkedList**](https://github.com/RoMaN16102012/Algorithms/blob/master/Algorithms/LinkedList/LinkedList.swift) - Single Linked List data structure, and optimizied [Single Linked List](https://github.com/RoMaN16102012/Algorithms/blob/master/Algorithms/LinkedList/LinkedList%2BCOW.swift) with [Copy-On-Write](https://medium.com/@lucianoalmeida1/understanding-swift-copy-on-write-mechanisms-52ac31d68f2f) semantic.
- [x] [**Trie**](https://github.com/RoMaN16102012/Algorithms/blob/master/Algorithms/Trie/Trie.swift) - Trie data structure, [also called digital tree or prefix tree](https://en.wikipedia.org/wiki/Trie#:~:text=In%20computer%20science%2C%20a%20trie,the%20keys%20are%20usually%20strings.)
- [x] [**A thread safe swift array.**](https://github.com/RoMaN16102012/Algorithms/blob/master/Algorithms/SynchrinizedArray/SynchronizedArray.swift) - Thread safe Swift array.
- [x] [**Graph**]() - Thread safe Swift array.
- [x] [**Extensions**]()

### Benchmarks

Figure below compares searching operation among [Ordered Array](https://github.com/RoMaN16102012/Algorithms/blob/master/Algorithms/SortedArray/Swift/OrderedArray.swift), [Ordered Set](https://github.com/RoMaN16102012/Algorithms/blob/master/Algorithms/OderedSet/OrderedSet.swift), and searching extension of Swift [Set](https://github.com/RoMaN16102012/Algorithms/blob/master/Algorithms/Extensions/Set%2BSearching.swift).
![](Images/searching_plot.png)

*There are 2 remarkable aspects*: 
1) **Ordered Set** has the same asymptotic plot **Ordered Array** (but with different constant value {x3 more}). It means, [NSMutableOrderdSet](https://developer.apple.com/documentation/foundation/nsmutableorderedset) works as Sorted Array under the hood.
2) Searching [Set](https://github.com/RoMaN16102012/Algorithms/blob/master/Algorithms/Extensions/Set%2BSearching.swift) extension behaves itself as **Ordered Array** does.
