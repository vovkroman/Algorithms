import Foundation

/// A node in the trie
 final class TrieNode<T: Hashable> {
    @usableFromInline
    var value: T?
    
    @usableFromInline
    weak var parentNode: TrieNode?
    
    @usableFromInline
    var children: [T: TrieNode] = [:]
    
    @usableFromInline
    var isTerminating = false
    
    @usableFromInline
    var isLeaf: Bool { return children.count == 0 }
    
    /// Description: initialize a node.
    /// - Parameters:
    ///   - value: The value that goes into the node
    ///   - parentNode: A reference to this node's parent
    @usableFromInline
    init(value: T? = nil, parentNode: TrieNode? = nil) {
        self.value = value
        self.parentNode = parentNode
    }
    
    /// Description: adds a child node to self.  If the child is already present,
    /// do nothing.
    /// - Parameter value: The item to be added to this node.
    @usableFromInline
    func add(value: T) {
        guard children[value] == nil else {
            return
        }
        children[value] = TrieNode(value: value, parentNode: self)
    }
}

/**
 **Trie** in computer science, a trie, also called digital tree or prefix tree, is a kind of search tree—an ordered tree data structure used to store a dynamic set or associative array where the keys are usually strings.
 
 Unlike a binary search tree, no node in the tree stores the key associated with that node; instead, its position in the tree defines the key with which it is associated; i.e., the value of the key is distributed across the structure. All the descendants of a node have a common prefix of the string associated with that node, and the root is associated with the empty string. Keys tend to be associated with leaves, though some inner nodes may correspond to keys of interest. Hence, keys are not necessarily associated with every node. For the space-optimized presentation of prefix tree, see compact prefix tree.
 
 **Application**:
A trie can also be used to replace a hash table, over which it has the following advantages:
- Looking up data in a trie is faster in the worst case, O(m) time (where m is the length of a search string), compared to an imperfect hash table. An imperfect hash table can have key collisions. A key collision is the hash function mapping of different keys to the same position in a hash table. The worst-case lookup speed in an imperfect hash table is O(N) time, but far more typically is O(1), with O(m) time spent evaluating the hash.
 
- There are no collisions of different keys in a trie.
- Buckets in a trie, which are analogous to hash table buckets that store key collisions, are necessary only if a single key is associated with more than one value.
- There is no need to provide a hash function or to change hash functions as more keys are added to a trie.
- A trie can provide an alphabetical ordering of the entries by key.

 **Performance**:
 - building  is O(m), m - word length
 - inserting is O(m), m - word length
 - remove is O(m), m - word length
 
 **Drawback**:
 - Trie lookup can be slower than hash table lookup, especially if the data is directly accessed on a hard disk drive or some other secondary storage device where the random-access time is high compared to main memory.
 - Some keys, such as floating point numbers, can lead to long chains and prefixes that are not particularly meaningful. Nevertheless, a bitwise trie can handle standard IEEE single and double format floating point numbers.[citation needed]
 - Some tries can require more space than a hash table, as memory may be allocated for each character in the search string, rather than a single chunk of memory for the whole entry, as in most hash tables.*/
final class Trie: NSObject, NSCoding {
    typealias Node = TrieNode<Character>
    ///Description: The number of words in the trie
    @usableFromInline
    var count: Int {
        return wordCount
    }
    /// Description: is the trie empty?
    @usableFromInline
    var isEmpty: Bool {
        return wordCount == 0
    }
    /// Description: all words currently in the trie
    @usableFromInline
    var words: [String] {
        return wordsInSubtrie(rootNode: root, partialWord: "")
    }
    
    @usableFromInline
    let root: Node
    
    @usableFromInline
    var wordCount: Int
    
    /// Description: creates an empty trie.
    
    override init() {
        root = Node()
        wordCount = 0
        super.init()
    }
    
    // MARK: NSCoding
    
    /// Description: initializes the trie with words from an archive
    /// - Parameter decoder: Decodes the archive
    required convenience init?(coder decoder: NSCoder) {
        self.init()
        let words = decoder.decodeObject(forKey: "words") as? [String]
        for word in words! {
            self.insert(word: word)
        }
    }
    
    /// Description: encodes the words in the trie by putting them in an array then encoding
    /// the array.
    /// - Parameter coder: The object that will encode the array
    @usableFromInline
    func encode(with coder: NSCoder) {
        coder.encode(self.words, forKey: "words")
    }
}

// MARK: - Adds methods: insert, remove, contains

extension Trie {
    /// Description: inserts a word into the trie.  If the word is already present,
    /// there is no change.
    /// - Parameter word: the word to be inserted.
    @inlinable
    public func insert(word: String) {
        guard !word.isEmpty else {
            return
        }
        var currentNode = root
        for character in word.lowercased() {
            if let childNode = currentNode.children[character] {
                currentNode = childNode
            } else {
                currentNode.add(value: character)
                currentNode = currentNode.children[character]!
            }
        }
        // Word already present?
        guard !currentNode.isTerminating else {
            return
        }
        wordCount += 1
        currentNode.isTerminating = true
    }
    
    /// Description: determines whether a word is in the trie.
    /// - Parameters:
    ///   - word: the word to check for
    ///   - matchPrefix: whether the search word should match
    ///   if it is only a prefix of other nodes in the trie
    @inlinable
    public func contains(word: String, matchPrefix: Bool = false) -> Bool {
        guard !word.isEmpty else {
            return false
        }
        var currentNode = root
        for character in word.lowercased() {
            guard let childNode = currentNode.children[character] else {
                return false
            }
            currentNode = childNode
        }
        return matchPrefix || currentNode.isTerminating
    }
    
    /// Description: attempts to walk to the last node of a word.  The
    /// search will fail if the word is not present. Doesn't
    /// check if the node is terminating
    /// - Parameter word: the word in question
    /// - Returns: the node where the search ended, nil if the
    /// search failed.
    @usableFromInline
    func findLastNodeOf(word: String) -> Node? {
        var currentNode = root
        for character in word.lowercased() {
            guard let childNode = currentNode.children[character] else {
                return nil
            }
            currentNode = childNode
        }
        return currentNode
    }
    
    /// Description: attempts to walk to the terminating node of a word.  The
    /// search will fail if the word is not present.
    /// - Parameter word: the word in question
    @usableFromInline
    func findTerminalNodeOf(word: String) -> Node? {
        if let lastNode = findLastNodeOf(word: word) {
            return lastNode.isTerminating ? lastNode : nil
        }
        return nil
    }
    
    /// Description: deletes a word from the trie by starting with the last letter
    /// and moving back, deleting nodes until either a non-leaf or a
    /// terminating node is found.
    /// - Parameter terminalNode: the node representing the last node
    /// of a word
    @usableFromInline
    func deleteNodesForWordEndingWith(terminalNode: Node) {
        var lastNode = terminalNode
        var character = lastNode.value
        while lastNode.isLeaf, let parentNode = lastNode.parentNode {
            lastNode = parentNode
            lastNode.children[character!] = nil
            character = lastNode.value
            if lastNode.isTerminating {
                break
            }
        }
    }
    
    /// Description: removes a word from the trie.  If the word is not present or
    /// it is empty, just ignore it.  If the last node is a leaf,
    /// delete that node and higher nodes that are leaves until a
    /// terminating node or non-leaf is found.  If the last node of
    /// the word has more children, the word is part of other words.
    /// Mark the last node as non-terminating.
    /// - Parameter word: the word to be removed
    @inlinable
    public func remove(word: String) {
        guard !word.isEmpty else {
            return
        }
        guard let terminalNode = findTerminalNodeOf(word: word) else {
            return
        }
        if terminalNode.isLeaf {
            deleteNodesForWordEndingWith(terminalNode: terminalNode)
        } else {
            terminalNode.isTerminating = false
        }
        wordCount -= 1
    }
    
    /// Description: returns an array of words in a subtrie of the trie
    /// - Parameters:
    ///   - rootNode: the root node of the subtrie
    ///   - partialWord: the letters collected by traversing to this node
    @usableFromInline
    func wordsInSubtrie(rootNode: Node, partialWord: String) -> [String] {
        var subtrieWords = [String]()
        var previousLetters = partialWord
        if let value = rootNode.value {
            previousLetters.append(value)
        }
        if rootNode.isTerminating {
            subtrieWords.append(previousLetters)
        }
        for childNode in rootNode.children.values {
            let childWords = wordsInSubtrie(rootNode: childNode, partialWord: previousLetters)
            subtrieWords += childWords
        }
        return subtrieWords
    }
    
    /// Description: returns an array of words in a subtrie of the trie that start
    /// with given prefix
    /// - Parameters:
    ///   - prefix: the letters for word prefix
    @inlinable
    public func findWordsWithPrefix(prefix: String) -> [String] {
        var words = [String]()
        let prefixLowerCased = prefix.lowercased()
        if let lastNode = findLastNodeOf(word: prefixLowerCased) {
            if lastNode.isTerminating {
                words.append(prefixLowerCased)
            }
            for childNode in lastNode.children.values {
                let childWords = wordsInSubtrie(rootNode: childNode, partialWord: prefixLowerCased)
                words += childWords
            }
        }
        return words
    }
}
