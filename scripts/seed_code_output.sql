-- Seed: What's the Output? challenges for all of 2026
-- One unique challenge per day from January 1 through December 31 (365 days)
-- Languages: ~equal mix of Python, JavaScript, and Rust
-- Difficulties: ~40% easy, ~40% medium, ~20% hard

INSERT INTO code_output_challenges (title, description, language, code_snippet, expected_output, difficulty, hint, max_attempts, scheduled_date)
VALUES

-- ── January 2026 ────────────────────────────────────────────────────────────

('New Year Print', 'What does this code print?', 'python',
'print("Hello, 2026!")', 'Hello, 2026!', 'easy', 'print() outputs a string to stdout', 3, '2026-01-01'),

('Simple Addition', 'What does this code print?', 'javascript',
'console.log(2 + 3)', '5', 'easy', 'The + operator adds two numbers', 3, '2026-01-02'),

('Hello Rust', 'What does this code print?', 'rust',
'fn main() {
    println!("Hello, world!");
}', 'Hello, world!', 'easy', 'println! is a macro that prints to stdout', 3, '2026-01-03'),

('String Length', 'What does this code print?', 'python',
'print(len("python"))', '6', 'easy', 'len() returns the number of characters in a string', 3, '2026-01-04'),

('Math Floor', 'What does this code print?', 'javascript',
'console.log(Math.floor(4.7))', '4', 'easy', 'Math.floor rounds down to the nearest integer', 3, '2026-01-05'),

('Integer Arithmetic', 'What does this code print?', 'rust',
'fn main() {
    let x = 10 / 3;
    println!("{x}");
}', '3', 'easy', 'Integer division truncates in Rust', 3, '2026-01-06'),

('Boolean Logic', 'What does this code print?', 'python',
'print(True and False)', 'False', 'easy', 'and returns False if either operand is False', 3, '2026-01-07'),

('Array Length', 'What does this code print?', 'javascript',
'console.log([1, 2, 3, 4].length)', '4', 'easy', '.length gives the number of elements in an array', 3, '2026-01-08'),

('String Slice', 'What does this code print?', 'rust',
'fn main() {
    let s = String::from("hello");
    println!("{}", &s[1..4]);
}', 'ell', 'medium', 'String slicing uses byte indices and is exclusive on the end', 3, '2026-01-09'),

('Modulo Operator', 'What does this code print?', 'python',
'print(17 % 5)', '2', 'easy', '% returns the remainder of division', 3, '2026-01-10'),

('Type Coercion', 'What does this code print?', 'javascript',
'console.log("5" - 2)', '3', 'medium', 'The - operator coerces strings to numbers', 3, '2026-01-11'),

('Tuple Access', 'What does this code print?', 'rust',
'fn main() {
    let t = (10, 20, 30);
    println!("{}", t.2);
}', '30', 'easy', 'Tuple elements are accessed with .0, .1, .2, etc.', 3, '2026-01-12'),

('String Repeat PY', 'What does this code print?', 'python',
'print("ab" * 4)', 'abababab', 'easy', 'Multiplying a string repeats it', 3, '2026-01-13'),

('Ternary Operator', 'What does this code print?', 'javascript',
'const x = 10;
console.log(x > 5 ? "yes" : "no")', 'yes', 'easy', 'The ternary operator evaluates the condition and picks a branch', 3, '2026-01-14'),

('The Classic Swap', 'What does this code print?', 'python',
'a, b = 1, 2
a, b = b, a
print(a, b)', '2 1', 'easy', 'Python allows tuple unpacking in assignments', 3, '2026-01-15'),

('String Multiplication', 'What does this code print?', 'python',
'print("ha" * 3)', 'hahaha', 'easy', 'Strings can be multiplied by integers in Python', 3, '2026-01-16'),

('Falsy Surprise', 'What does this code print?', 'javascript',
'console.log([] == false)', 'true', 'medium', 'JavaScript coerces both sides when using ==', 3, '2026-01-17'),

('Type Confusion', 'What does this code print?', 'javascript',
'console.log(typeof null)', 'object', 'medium', 'This is a famous JavaScript bug that was never fixed', 3, '2026-01-18'),

('List Identity', 'What does this code print?', 'python',
'a = [1, 2, 3]
b = a
b.append(4)
print(len(a))', '4', 'easy', 'Assignment copies the reference, not the list', 3, '2026-01-19'),

('NaN Madness', 'What does this code print?', 'javascript',
'console.log(NaN === NaN)', 'false', 'medium', 'NaN is not equal to anything, including itself', 3, '2026-01-20'),

('Slice and Dice', 'What does this code print?', 'python',
'x = "hello"
print(x[::-1])', 'olleh', 'easy', 'Negative step reverses the sequence', 3, '2026-01-21'),

('Plus Plus What', 'What does this code print?', 'javascript',
'console.log(1 + "2" + 3)', '123', 'medium', 'Once a string enters the +, everything becomes concatenation', 3, '2026-01-22'),

('Mutable Default', 'What does this code print?', 'python',
'def add(x, lst=[]):
    lst.append(x)
    return lst

add(1)
print(add(2))', '[1, 2]', 'hard', 'Default mutable arguments are shared across calls', 3, '2026-01-23'),

('Shadowed Variable', 'What does this code print?', 'rust',
'fn main() {
    let x = 5;
    let x = x + 1;
    let x = x * 2;
    println!("{x}");
}', '12', 'easy', 'Rust allows variable shadowing with let', 3, '2026-01-24'),

('Boolean Arithmetic', 'What does this code print?', 'python',
'print(True + True + False)', '2', 'easy', 'In Python, True is 1 and False is 0', 3, '2026-01-25'),

('Array Sort Surprise', 'What does this code print?', 'javascript',
'console.log([10, 9, 8].sort().join(","))', '10,8,9', 'hard', 'Array.sort() converts elements to strings by default', 3, '2026-01-26'),

('Chained Comparison', 'What does this code print?', 'python',
'print(1 < 2 < 3)', 'True', 'easy', 'Python supports chained comparisons', 3, '2026-01-27'),

('Emergency Exit', 'What does this code print?', 'python',
'for i in range(5):
    if i == 3:
        break
    print(i, end=" ")
print()', '0 1 2 ', 'easy', 'break exits the loop before printing 3', 3, '2026-01-28'),

('Tricky Ternary', 'What does this code print?', 'javascript',
'let x = 0;
console.log(x ? "truthy" : "falsy")', 'falsy', 'easy', '0 is falsy in JavaScript', 3, '2026-01-29'),

('Ownership Move', 'What does this code print?', 'rust',
'fn main() {
    let s1 = String::from("hello");
    let s2 = s1.clone();
    println!("{} {}", s1, s2);
}', 'hello hello', 'easy', 'clone() creates a deep copy so both variables are valid', 3, '2026-01-30'),

('Dict Merge', 'What does this code print?', 'python',
'a = {"x": 1, "y": 2}
b = {"y": 3, "z": 4}
print({**a, **b})', '{''x'': 1, ''y'': 3, ''z'': 4}', 'medium', 'Later keys overwrite earlier ones when merging dicts', 3, '2026-01-31'),

-- ── February 2026 ───────────────────────────────────────────────────────────

('Empty String Check', 'What does this code print?', 'javascript',
'console.log("" == false)', 'true', 'medium', 'Empty string is coerced to 0, and false is coerced to 0', 3, '2026-02-01'),

('Set Surprise', 'What does this code print?', 'python',
'print(len({1, 1, 2, 2, 3}))', '3', 'easy', 'Sets automatically deduplicate', 3, '2026-02-02'),

('Closure Trap', 'What does this code print?', 'javascript',
'const funcs = [];
for (var i = 0; i < 3; i++) {
    funcs.push(() => i);
}
console.log(funcs[0]())', '3', 'hard', 'var is function-scoped, so all closures share the same i', 3, '2026-02-03'),

('Integer Division', 'What does this code print?', 'python',
'print(7 // 2)', '3', 'easy', '// is floor division in Python', 3, '2026-02-04'),

('Template Literal', 'What does this code print?', 'javascript',
'const x = 10;
console.log(`${x > 5 ? "big" : "small"}`)', 'big', 'easy', 'Template literals can contain expressions', 3, '2026-02-05'),

('Tuple Indexing', 'What does this code print?', 'rust',
'fn main() {
    let t = (1, "hello", 3.14);
    println!("{}", t.1);
}', 'hello', 'easy', 'Tuple fields are accessed with .0, .1, .2, etc.', 3, '2026-02-06'),

('List Comprehension', 'What does this code print?', 'python',
'print([x**2 for x in range(5) if x % 2 == 0])', '[0, 4, 16]', 'medium', 'Filter runs before the transformation', 3, '2026-02-07'),

('Typeof Undefined', 'What does this code print?', 'javascript',
'let x;
console.log(typeof x)', 'undefined', 'easy', 'Declared but unassigned variables are undefined', 3, '2026-02-08'),

('Zip Magic', 'What does this code print?', 'python',
'a = [1, 2, 3]
b = ["a", "b", "c"]
print(list(zip(a, b)))', '[(1, ''a''), (2, ''b''), (3, ''c'')]', 'medium', 'zip pairs elements from both iterables', 3, '2026-02-09'),

('Spread Merge', 'What does this code print?', 'javascript',
'const a = [1, 2];
const b = [3, 4];
console.log([...a, ...b].length)', '4', 'easy', 'Spread operator flattens arrays', 3, '2026-02-10'),

('Match Expression', 'What does this code print?', 'rust',
'fn main() {
    let x = 42;
    let msg = match x {
        0..=9 => "small",
        10..=99 => "medium",
        _ => "big",
    };
    println!("{msg}");
}', 'medium', 'easy', 'match with ranges checks which range contains the value', 3, '2026-02-11'),

('String Join', 'What does this code print?', 'python',
'print("-".join(["a", "b", "c"]))', 'a-b-c', 'easy', 'join() places the separator between elements', 3, '2026-02-12'),

('Nullish Coalescing', 'What does this code print?', 'javascript',
'const x = null;
const y = 0;
console.log(x ?? "default", y ?? "default")', 'default 0', 'medium', '?? only checks for null/undefined, not falsy values', 3, '2026-02-13'),

('Enumerate', 'What does this code print?', 'python',
'for i, c in enumerate("abc"):
    print(i, end="")
print()', '012', 'easy', 'enumerate gives (index, value) pairs starting from 0', 3, '2026-02-14'),

('Destructuring', 'What does this code print?', 'javascript',
'const [a, , b] = [1, 2, 3, 4];
console.log(a + b)', '4', 'medium', 'The empty slot skips the second element', 3, '2026-02-15'),

('Vector Push', 'What does this code print?', 'rust',
'fn main() {
    let mut v = vec![1, 2, 3];
    v.push(4);
    v.push(5);
    println!("{}", v.len());
}', '5', 'easy', 'push adds elements to the end of the vector', 3, '2026-02-16'),

('Global vs Local', 'What does this code print?', 'python',
'x = 10
def foo():
    x = 20
    return x
foo()
print(x)', '10', 'medium', 'Assignment inside a function creates a local variable', 3, '2026-02-17'),

('Void Operator', 'What does this code print?', 'javascript',
'console.log(void 0 === undefined)', 'true', 'medium', 'void always evaluates to undefined', 3, '2026-02-18'),

('Iterator Sum', 'What does this code print?', 'rust',
'fn main() {
    let total: i32 = (1..=4).sum();
    println!("{total}");
}', '10', 'easy', '1..=4 is an inclusive range: 1+2+3+4', 3, '2026-02-19'),

('In Operator', 'What does this code print?', 'python',
'print("hell" in "hello world")', 'True', 'easy', 'in checks for substring membership in strings', 3, '2026-02-20'),

('Optional Chaining', 'What does this code print?', 'javascript',
'const obj = { a: { b: 42 } };
console.log(obj?.a?.b)', '42', 'easy', 'Optional chaining returns the value if the chain is valid', 3, '2026-02-21'),

('F-String Format', 'What does this code print?', 'python',
'pi = 3.14159
print(f"{pi:.2f}")', '3.14', 'medium', '.2f formats to 2 decimal places', 3, '2026-02-22'),

('Infinity Check', 'What does this code print?', 'javascript',
'console.log(1 / 0)', 'Infinity', 'medium', 'JavaScript returns Infinity instead of throwing an error', 3, '2026-02-23'),

('String Iter', 'What does this code print?', 'rust',
'fn main() {
    let s = "hi";
    println!("{}", s.chars().count());
}', '2', 'easy', 'chars().count() gives the number of characters', 3, '2026-02-24'),

('Walrus Operator', 'What does this code print?', 'python',
'if (n := 10) > 5:
    print(n)', '10', 'medium', ':= assigns and returns the value in one expression', 3, '2026-02-25'),

('Array From', 'What does this code print?', 'javascript',
'console.log(Array.from("hello").length)', '5', 'easy', 'Array.from converts an iterable to an array', 3, '2026-02-26'),

('Nested List', 'What does this code print?', 'python',
'matrix = [[1,2],[3,4],[5,6]]
flat = [x for row in matrix for x in row]
print(flat)', '[1, 2, 3, 4, 5, 6]', 'medium', 'Nested comprehension reads left to right like nested loops', 3, '2026-02-27'),

('Map Filter', 'What does this code print?', 'javascript',
'console.log([1,2,3,4,5].filter(x => x % 2).map(x => x * 10).join(","))', '10,30,50', 'medium', 'filter keeps odd numbers (truthy), then map multiplies by 10', 3, '2026-02-28'),

-- ── March 2026 ──────────────────────────────────────────────────────────────

('If Let', 'What does this code print?', 'rust',
'fn main() {
    let val: Option<i32> = Some(42);
    if let Some(x) = val {
        println!("{x}");
    }
}', '42', 'easy', 'if let destructures the Option and binds the inner value', 3, '2026-03-01'),

('Any All', 'What does this code print?', 'python',
'nums = [2, 4, 6, 8]
print(all(x % 2 == 0 for x in nums))', 'True', 'easy', 'all() returns True if every element satisfies the condition', 3, '2026-03-02'),

('Double Equals', 'What does this code print?', 'javascript',
'console.log(0 == "")', 'true', 'hard', 'Both are coerced to 0 with ==', 3, '2026-03-03'),

('Enumerate Start', 'What does this code print?', 'python',
'for i, x in enumerate(["a","b","c"], start=1):
    pass
print(i, x)', '3 c', 'medium', 'enumerate with start=1 begins counting from 1', 3, '2026-03-04'),

('Map Object', 'What does this code print?', 'javascript',
'const m = new Map();
m.set("a", 1);
m.set("b", 2);
m.set("a", 3);
console.log(m.size)', '2', 'medium', 'Map keys are unique — setting the same key again overwrites it', 3, '2026-03-05'),

('Collect Vector', 'What does this code print?', 'rust',
'fn main() {
    let v: Vec<i32> = (0..5).filter(|x| x % 2 == 0).collect();
    println!("{:?}", v);
}', '[0, 2, 4]', 'medium', 'filter keeps elements where the predicate is true', 3, '2026-03-06'),

('Dict Get', 'What does this code print?', 'python',
'd = {"a": 1, "b": 2}
print(d.get("c", 99))', '99', 'easy', 'get() returns the default value when the key is missing', 3, '2026-03-07'),

('Reduce Sum', 'What does this code print?', 'javascript',
'console.log([1,2,3,4].reduce((a,b) => a + b, 0))', '10', 'easy', 'reduce accumulates values starting from the initial value 0', 3, '2026-03-08'),

('Power Tower', 'What does this code print?', 'python',
'print(2 ** 3 ** 2)', '512', 'hard', 'Exponentiation is right-associative: 2 ** (3 ** 2) = 2 ** 9', 3, '2026-03-09'),

('String Repeat', 'What does this code print?', 'rust',
'fn main() {
    let s = "ab".repeat(3);
    println!("{s}");
}', 'ababab', 'easy', 'repeat() duplicates the string n times', 3, '2026-03-10'),

('Truthy Empty', 'What does this code print?', 'javascript',
'console.log(Boolean([]))', 'true', 'hard', 'Empty arrays are truthy in JavaScript — only [] == false uses coercion', 3, '2026-03-11'),

('Counter', 'What does this code print?', 'python',
'from collections import Counter
print(Counter("banana")["a"])', '3', 'easy', 'Counter counts occurrences of each element', 3, '2026-03-12'),

('Reverse Iterator', 'What does this code print?', 'rust',
'fn main() {
    let v = vec![1, 2, 3];
    let r: Vec<_> = v.iter().rev().collect();
    println!("{:?}", r);
}', '[3, 2, 1]', 'medium', 'rev() reverses the iterator order', 3, '2026-03-13'),

('String Contains', 'What does this code print?', 'javascript',
'console.log("foobar".includes("oob"))', 'true', 'easy', 'includes() checks for substring presence', 3, '2026-03-14'),

('Lambda Sort', 'What does this code print?', 'python',
'words = ["banana", "pie", "kiwi"]
words.sort(key=len)
print(words)', '[''pie'', ''kiwi'', ''banana'']', 'medium', 'key=len sorts by string length', 3, '2026-03-15'),

('Typeof Array', 'What does this code print?', 'javascript',
'console.log(typeof [])', 'object', 'medium', 'Arrays are objects in JavaScript — use Array.isArray() to check', 3, '2026-03-16'),

('Implicit Return', 'What does this code print?', 'rust',
'fn double(x: i32) -> i32 {
    x * 2
}
fn main() {
    println!("{}", double(21));
}', '42', 'easy', 'The last expression without a semicolon is the return value', 3, '2026-03-17'),

('Map vs List', 'What does this code print?', 'python',
'result = map(lambda x: x*2, [1,2,3])
print(type(result).__name__)', 'map', 'medium', 'map() returns a lazy iterator, not a list', 3, '2026-03-18'),

('Promise Value', 'What does this code print?', 'javascript',
'const x = "start";
setTimeout(() => console.log("timeout"), 0);
console.log(x)', 'start', 'hard', 'setTimeout callbacks run after the current call stack, even with 0ms delay', 3, '2026-03-19'),

('Struct Debug', 'What does this code print?', 'rust',
'#[derive(Debug)]
struct Point { x: i32, y: i32 }
fn main() {
    let p = Point { x: 3, y: 7 };
    println!("{:?}", p);
}', 'Point { x: 3, y: 7 }', 'easy', 'Debug trait prints the struct name and fields', 3, '2026-03-20'),

('Not Not', 'What does this code print?', 'python',
'print(not not [])', 'False', 'medium', 'not not converts to bool — empty list is falsy', 3, '2026-03-21'),

('Object Keys', 'What does this code print?', 'javascript',
'const obj = { a: 1, b: 2, c: 3 };
console.log(Object.keys(obj).length)', '3', 'easy', 'Object.keys() returns an array of the property names', 3, '2026-03-22'),

('Char Collect', 'What does this code print?', 'rust',
'fn main() {
    let s: String = "hello".chars().filter(|c| *c != ''l'').collect();
    println!("{s}");
}', 'heo', 'medium', 'filter removes matching characters, collect builds a new String', 3, '2026-03-23'),

('Floor Negative', 'What does this code print?', 'python',
'print(-7 // 2)', '-4', 'hard', 'Floor division rounds toward negative infinity, not zero', 3, '2026-03-24'),

('String Pad', 'What does this code print?', 'javascript',
'console.log("42".padStart(5, "0"))', '00042', 'easy', 'padStart adds characters to the beginning until the target length', 3, '2026-03-25'),

('Vec Dedup', 'What does this code print?', 'rust',
'fn main() {
    let mut v = vec![1, 1, 2, 3, 3, 3, 2];
    v.dedup();
    println!("{:?}", v);
}', '[1, 2, 3, 2]', 'hard', 'dedup only removes consecutive duplicates, not all duplicates', 3, '2026-03-26'),

('Unpacking Star', 'What does this code print?', 'python',
'first, *middle, last = [1, 2, 3, 4, 5]
print(middle)', '[2, 3, 4]', 'medium', 'The * collects everything between first and last', 3, '2026-03-27'),

('Comparison Chain', 'What does this code print?', 'javascript',
'console.log(3 > 2 > 1)', 'false', 'hard', '3 > 2 is true, then true > 1 is false (true coerces to 1, 1 > 1 is false)', 3, '2026-03-28'),

('HashMap Entry', 'What does this code print?', 'rust',
'use std::collections::HashMap;
fn main() {
    let mut m = HashMap::new();
    m.insert("a", 1);
    m.insert("a", 2);
    println!("{}", m["a"]);
}', '2', 'easy', 'insert overwrites the value for an existing key', 3, '2026-03-29'),

('Set Operations', 'What does this code print?', 'python',
'a = {1, 2, 3, 4}
b = {3, 4, 5, 6}
print(sorted(a & b))', '[3, 4]', 'medium', '& is set intersection — elements in both sets', 3, '2026-03-30'),

('Arrow Return', 'What does this code print?', 'javascript',
'const add = (a, b) => a + b;
console.log(add(3, 4))', '7', 'easy', 'Arrow functions with no braces implicitly return the expression', 3, '2026-03-31'),

-- ── April 2026 ──────────────────────────────────────────────────────────────

('Enum Match', 'What does this code print?', 'rust',
'enum Color { Red, Green, Blue }
fn main() {
    let c = Color::Green;
    match c {
        Color::Red => println!("R"),
        Color::Green => println!("G"),
        Color::Blue => println!("B"),
    }
}', 'G', 'easy', 'match checks which variant the enum is', 3, '2026-04-01'),

('Truthiness', 'What does this code print?', 'python',
'print(bool(""), bool(" "), bool("0"))', 'False True True', 'medium', 'Only empty string is falsy — " " and "0" have length > 0', 3, '2026-04-02'),

('Delete Property', 'What does this code print?', 'javascript',
'const obj = {a: 1, b: 2, c: 3};
delete obj.b;
console.log(Object.keys(obj).join(","))', 'a,c', 'easy', 'delete removes a property from an object', 3, '2026-04-03'),

('Closure Move', 'What does this code print?', 'rust',
'fn main() {
    let name = String::from("Rust");
    let greet = move || println!("Hello, {name}!");
    greet();
}', 'Hello, Rust!', 'medium', 'move captures variables by value into the closure', 3, '2026-04-04'),

('Generator Next', 'What does this code print?', 'python',
'def gen():
    yield 1
    yield 2
    yield 3
g = gen()
next(g)
print(next(g))', '2', 'medium', 'First next() yields 1, second next() yields 2', 3, '2026-04-05'),

('Short Circuit', 'What does this code print?', 'javascript',
'console.log(0 || "" || null || "hello" || "world")', 'hello', 'medium', '|| returns the first truthy value it finds', 3, '2026-04-06'),

('Reference Borrow', 'What does this code print?', 'rust',
'fn first(s: &str) -> &str {
    &s[..1]
}
fn main() {
    let word = String::from("hello");
    println!("{}", first(&word));
}', 'h', 'medium', '&s[..1] borrows the first byte/character of the string', 3, '2026-04-07'),

('Multiple Return', 'What does this code print?', 'python',
'def minmax(lst):
    return min(lst), max(lst)
lo, hi = minmax([5, 2, 8, 1])
print(lo, hi)', '1 8', 'easy', 'Python functions can return tuples which can be unpacked', 3, '2026-04-08'),

('Array Find', 'What does this code print?', 'javascript',
'const arr = [5, 12, 8, 130, 44];
console.log(arr.find(x => x > 10))', '12', 'easy', 'find() returns the first element that matches the predicate', 3, '2026-04-09'),

('Option Map', 'What does this code print?', 'rust',
'fn main() {
    let x: Option<i32> = Some(5);
    let y = x.map(|v| v * 2);
    println!("{:?}", y);
}', 'Some(10)', 'medium', 'map on Some applies the function to the inner value', 3, '2026-04-10'),

('Dict Comprehension', 'What does this code print?', 'python',
'd = {k: v for k, v in enumerate("abc")}
print(d)', '{0: ''a'', 1: ''b'', 2: ''c''}', 'medium', 'enumerate gives (index, value) pairs for the dict', 3, '2026-04-11'),

('Splice Return', 'What does this code print?', 'javascript',
'const arr = [1, 2, 3, 4, 5];
const removed = arr.splice(1, 2);
console.log(arr.join(","))', '1,4,5', 'medium', 'splice(1, 2) removes 2 elements starting at index 1', 3, '2026-04-12'),

('Result Unwrap', 'What does this code print?', 'rust',
'fn divide(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        Err("division by zero".into())
    } else {
        Ok(a / b)
    }
}
fn main() {
    println!("{}", divide(10.0, 4.0).unwrap());
}', '2.5', 'easy', 'unwrap() extracts the Ok value from a Result', 3, '2026-04-13'),

('Frozen Set', 'What does this code print?', 'python',
'a = frozenset([3, 1, 2, 1, 3])
print(sorted(a))', '[1, 2, 3]', 'easy', 'frozenset deduplicates like set, sorted() returns a list', 3, '2026-04-14'),

('Number Methods', 'What does this code print?', 'javascript',
'console.log(Number.isInteger(5.0))', 'true', 'medium', '5.0 has no fractional part, so JavaScript considers it an integer', 3, '2026-04-15'),

('Vec Capacity', 'What does this code print?', 'rust',
'fn main() {
    let v = Vec::<i32>::with_capacity(10);
    println!("{} {}", v.len(), v.capacity());
}', '0 10', 'medium', 'with_capacity allocates space but starts with 0 length', 3, '2026-04-16'),

('Reversed List', 'What does this code print?', 'python',
'print(list(reversed([1, 2, 3])))', '[3, 2, 1]', 'easy', 'reversed() returns an iterator in reverse order', 3, '2026-04-17'),

('String Split', 'What does this code print?', 'javascript',
'console.log("a,b,,c".split(",").length)', '4', 'easy', 'split creates an element for each segment, including empty ones', 3, '2026-04-18'),

('Ownership Transfer', 'What does this code print?', 'rust',
'fn take_length(s: String) -> usize {
    s.len()
}
fn main() {
    let s = String::from("hello");
    println!("{}", take_length(s));
}', '5', 'easy', 'The function takes ownership but returns the length before dropping', 3, '2026-04-19'),

('String Methods', 'What does this code print?', 'python',
'print("Hello World".lower().count("l"))', '3', 'easy', 'lower() converts to lowercase, then count finds occurrences of l', 3, '2026-04-20'),

('Every Some', 'What does this code print?', 'javascript',
'console.log([2, 4, 6].every(x => x % 2 === 0))', 'true', 'easy', 'every() returns true if all elements satisfy the predicate', 3, '2026-04-21'),

('String Owns', 'What does this code print?', 'rust',
'fn main() {
    let s1 = String::from("foo");
    let s2 = String::from("bar");
    println!("{}", s1 + &s2);
}', 'foobar', 'medium', 'The + operator takes ownership of s1 and borrows s2', 3, '2026-04-22'),

('Divmod', 'What does this code print?', 'python',
'print(divmod(17, 5))', '(3, 2)', 'easy', 'divmod returns (quotient, remainder) as a tuple', 3, '2026-04-23'),

('Flat Map', 'What does this code print?', 'javascript',
'console.log([1, 2, 3].flatMap(x => [x, x * 2]).join(","))', '1,2,2,4,3,6', 'medium', 'flatMap maps then flattens one level', 3, '2026-04-24'),

('While Let', 'What does this code print?', 'rust',
'fn main() {
    let mut stack = vec![1, 2, 3];
    let mut sum = 0;
    while let Some(top) = stack.pop() {
        sum += top;
    }
    println!("{sum}");
}', '6', 'medium', 'while let keeps popping until the stack is empty', 3, '2026-04-25'),

('Zip Unequal', 'What does this code print?', 'python',
'a = [1, 2, 3]
b = ["x", "y"]
print(list(zip(a, b)))', '[(1, ''x''), (2, ''y'')]', 'medium', 'zip stops at the shortest iterable', 3, '2026-04-26'),

('Array Includes', 'What does this code print?', 'javascript',
'console.log([1, 2, NaN].includes(NaN))', 'true', 'hard', 'includes() uses SameValueZero which considers NaN equal to NaN', 3, '2026-04-27'),

('Loop Labels', 'What does this code print?', 'rust',
'fn main() {
    let mut count = 0;
    ''outer: for i in 0..3 {
        for j in 0..3 {
            if i + j == 3 {
                break ''outer;
            }
            count += 1;
        }
    }
    println!("{count}");
}', '6', 'hard', 'break with a label exits the outer loop when i=1, j=2', 3, '2026-04-28'),

('Abs Value', 'What does this code print?', 'python',
'print(abs(-42))', '42', 'easy', 'abs() returns the absolute value', 3, '2026-04-29'),

('Set Object', 'What does this code print?', 'javascript',
'const s = new Set([1, 2, 2, 3, 3, 3]);
console.log(s.size)', '3', 'easy', 'Set automatically deduplicates values', 3, '2026-04-30'),

-- ── May 2026 ────────────────────────────────────────────────────────────────

('Iter Chain', 'What does this code print?', 'rust',
'fn main() {
    let a = vec![1, 2];
    let b = vec![3, 4];
    let c: Vec<_> = a.iter().chain(b.iter()).collect();
    println!("{:?}", c);
}', '[1, 2, 3, 4]', 'medium', 'chain() concatenates two iterators', 3, '2026-05-01'),

('Round Gotcha', 'What does this code print?', 'python',
'print(round(2.5))', '2', 'hard', 'Python uses banker''s rounding — 2.5 rounds to 2 (nearest even)', 3, '2026-05-02'),

('Object Assign', 'What does this code print?', 'javascript',
'const target = { a: 1 };
Object.assign(target, { b: 2 }, { c: 3 });
console.log(Object.keys(target).join(","))', 'a,b,c', 'easy', 'Object.assign copies properties from sources to target', 3, '2026-05-03'),

('String Format', 'What does this code print?', 'rust',
'fn main() {
    let name = "world";
    let greeting = format!("Hello, {name}!");
    println!("{greeting}");
}', 'Hello, world!', 'easy', 'format! creates a String without printing it', 3, '2026-05-04'),

('Max with Key', 'What does this code print?', 'python',
'words = ["cat", "elephant", "dog"]
print(max(words, key=len))', 'elephant', 'easy', 'max with key=len finds the longest string', 3, '2026-05-05'),

('Logical AND', 'What does this code print?', 'javascript',
'console.log("hello" && 42)', '42', 'medium', '&& returns the last truthy value if all are truthy', 3, '2026-05-06'),

('Type Cast', 'What does this code print?', 'rust',
'fn main() {
    let x: f64 = 3.14;
    let y: i32 = x as i32;
    println!("{y}");
}', '3', 'easy', 'as i32 truncates the decimal part', 3, '2026-05-07'),

('String Replace', 'What does this code print?', 'python',
'print("hello world".replace("o", "0"))', 'hell0 w0rld', 'easy', 'replace() substitutes all occurrences', 3, '2026-05-08'),

('Spread Object', 'What does this code print?', 'javascript',
'const a = { x: 1, y: 2 };
const b = { ...a, y: 3, z: 4 };
console.log(JSON.stringify(b))', '{"x":1,"y":3,"z":4}', 'medium', 'Spread copies properties, later ones override earlier', 3, '2026-05-09'),

('Vec Windows', 'What does this code print?', 'rust',
'fn main() {
    let v = vec![1, 2, 3, 4];
    let count = v.windows(2).count();
    println!("{count}");
}', '3', 'medium', 'windows(2) creates overlapping pairs: 3 windows from 4 elements', 3, '2026-05-10'),

('Complex Numbers', 'What does this code print?', 'python',
'z = 3 + 4j
print(abs(z))', '5.0', 'medium', 'abs() of a complex number returns its magnitude', 3, '2026-05-11'),

('IndexOf', 'What does this code print?', 'javascript',
'const arr = [1, 2, 3];
console.log(arr.indexOf(2))', '1', 'easy', 'indexOf returns the first index where the element is found', 3, '2026-05-12'),

('Iter Enumerate', 'What does this code print?', 'rust',
'fn main() {
    let v = vec!["a", "b", "c"];
    for (i, val) in v.iter().enumerate() {
        if i == 1 {
            println!("{val}");
        }
    }
}', 'b', 'easy', 'enumerate() pairs each element with its index', 3, '2026-05-13'),

('Str Isdigit', 'What does this code print?', 'python',
'print("123".isdigit(), "12.3".isdigit())', 'True False', 'easy', 'isdigit() returns True only if all characters are digits', 3, '2026-05-14'),

('Array Flat Infinity', 'What does this code print?', 'javascript',
'console.log([1, [2, [3]]].flat(Infinity).join(","))', '1,2,3', 'medium', 'flat(Infinity) flattens all nested arrays completely', 3, '2026-05-15'),

('Mutable Ref', 'What does this code print?', 'rust',
'fn add_one(v: &mut Vec<i32>) {
    v.push(99);
}
fn main() {
    let mut nums = vec![1, 2];
    add_one(&mut nums);
    println!("{:?}", nums);
}', '[1, 2, 99]', 'medium', 'A mutable reference allows modifying the original vector', 3, '2026-05-16'),

('Try Except', 'What does this code print?', 'python',
'try:
    result = 10 / 0
except ZeroDivisionError:
    result = -1
print(result)', '-1', 'easy', 'The except block catches the division by zero', 3, '2026-05-17'),

('Object Values', 'What does this code print?', 'javascript',
'const obj = { a: 10, b: 20, c: 30 };
console.log(Object.values(obj).reduce((a, b) => a + b))', '60', 'medium', 'Object.values gets the values, reduce sums them', 3, '2026-05-18'),

('Struct Method', 'What does this code print?', 'rust',
'struct Rect {
    w: f64,
    h: f64,
}
impl Rect {
    fn area(&self) -> f64 {
        self.w * self.h
    }
}
fn main() {
    let r = Rect { w: 3.0, h: 4.0 };
    println!("{}", r.area());
}', '12', 'easy', 'Methods access struct fields through &self', 3, '2026-05-19'),

('Sorted Reverse', 'What does this code print?', 'python',
'print(sorted([3, 1, 4, 1, 5], reverse=True))', '[5, 4, 3, 1, 1]', 'easy', 'reverse=True sorts in descending order', 3, '2026-05-20'),

('String Starts', 'What does this code print?', 'javascript',
'console.log("JavaScript".startsWith("Java"))', 'true', 'easy', 'startsWith checks if the string begins with the given substring', 3, '2026-05-21'),

('Vec Retain', 'What does this code print?', 'rust',
'fn main() {
    let mut v = vec![1, 2, 3, 4, 5];
    v.retain(|&x| x % 2 != 0);
    println!("{:?}", v);
}', '[1, 3, 5]', 'medium', 'retain keeps only elements where the predicate is true', 3, '2026-05-22'),

('String Strip', 'What does this code print?', 'python',
'print("  hello  ".strip())', 'hello', 'easy', 'strip() removes leading and trailing whitespace', 3, '2026-05-23'),

('Array Slice', 'What does this code print?', 'javascript',
'const arr = [10, 20, 30, 40, 50];
console.log(arr.slice(1, 3).join(","))', '20,30', 'easy', 'slice(1, 3) extracts elements at indices 1 and 2', 3, '2026-05-24'),

('Iter Fold', 'What does this code print?', 'rust',
'fn main() {
    let product: i32 = (1..=5).fold(1, |acc, x| acc * x);
    println!("{product}");
}', '120', 'medium', 'fold with multiplication computes factorial: 1*2*3*4*5', 3, '2026-05-25'),

('List Pop', 'What does this code print?', 'python',
'lst = [10, 20, 30, 40]
val = lst.pop(1)
print(val, lst)', '20 [10, 30, 40]', 'easy', 'pop(1) removes and returns the element at index 1', 3, '2026-05-26'),

('Char Code', 'What does this code print?', 'javascript',
'console.log("A".charCodeAt(0))', '65', 'easy', 'charCodeAt returns the UTF-16 code of the character', 3, '2026-05-27'),

('Vec Split', 'What does this code print?', 'rust',
'fn main() {
    let v = vec![1, 2, 3, 4, 5];
    let (left, right) = v.split_at(2);
    println!("{:?} {:?}", left, right);
}', '[1, 2] [3, 4, 5]', 'medium', 'split_at divides at the given index', 3, '2026-05-28'),

('Dict Items', 'What does this code print?', 'python',
'scores = {"a": 90, "b": 85}
for k, v in scores.items():
    print(f"{k}:{v}", end=" ")
print()', 'a:90 b:85 ', 'easy', 'items() iterates over key-value pairs', 3, '2026-05-29'),

('Regex Test', 'What does this code print?', 'javascript',
'console.log(/^\d+$/.test("42"))', 'true', 'medium', 'The regex checks if the entire string is digits', 3, '2026-05-30'),

('Iter Zip', 'What does this code print?', 'rust',
'fn main() {
    let a = [1, 2, 3];
    let b = [10, 20, 30];
    let sums: Vec<i32> = a.iter().zip(b.iter()).map(|(x, y)| x + y).collect();
    println!("{:?}", sums);
}', '[11, 22, 33]', 'medium', 'zip pairs elements, map adds them', 3, '2026-05-31'),

-- ── June 2026 ───────────────────────────────────────────────────────────────

('List Times', 'What does this code print?', 'python',
'print([[0]] * 3)', '[[0], [0], [0]]', 'easy', 'Multiplying a list repeats its elements', 3, '2026-06-01'),

('Array At', 'What does this code print?', 'javascript',
'const arr = [10, 20, 30, 40];
console.log(arr.at(-1))', '40', 'easy', 'at(-1) returns the last element', 3, '2026-06-02'),

('Trait Display', 'What does this code print?', 'rust',
'use std::fmt;
struct Name(String);
impl fmt::Display for Name {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Hi, {}!", self.0)
    }
}
fn main() {
    let n = Name("Alice".to_string());
    println!("{n}");
}', 'Hi, Alice!', 'medium', 'Display trait customizes how a type is printed', 3, '2026-06-03'),

('String Startswith', 'What does this code print?', 'python',
'print("python".startswith("py"))', 'True', 'easy', 'startswith checks the beginning of a string', 3, '2026-06-04'),

('Math Max', 'What does this code print?', 'javascript',
'console.log(Math.max(1, 3, 2))', '3', 'easy', 'Math.max returns the largest of the given numbers', 3, '2026-06-05'),

('Unwrap Or', 'What does this code print?', 'rust',
'fn main() {
    let x: Option<i32> = None;
    println!("{}", x.unwrap_or(42));
}', '42', 'easy', 'unwrap_or returns the default value when the Option is None', 3, '2026-06-06'),

('Map List', 'What does this code print?', 'python',
'print(list(map(str, [1, 2, 3])))', '[''1'', ''2'', ''3'']', 'easy', 'map applies str to each element', 3, '2026-06-07'),

('String Repeat JS', 'What does this code print?', 'javascript',
'console.log("ha".repeat(3))', 'hahaha', 'easy', 'repeat() creates a new string by repeating n times', 3, '2026-06-08'),

('Generic Function', 'What does this code print?', 'rust',
'fn largest<T: PartialOrd>(a: T, b: T) -> T {
    if a >= b { a } else { b }
}
fn main() {
    println!("{}", largest(5, 3));
}', '5', 'medium', 'Generic function compares with PartialOrd trait', 3, '2026-06-09'),

('String Partition', 'What does this code print?', 'python',
'print("hello-world".partition("-"))', '(''hello'', ''-'', ''world'')', 'medium', 'partition splits at the first occurrence and keeps the separator', 3, '2026-06-10'),

('Object Entries', 'What does this code print?', 'javascript',
'const obj = { x: 1, y: 2 };
console.log(Object.entries(obj).length)', '2', 'easy', 'Object.entries returns an array of [key, value] pairs', 3, '2026-06-11'),

('Box Value', 'What does this code print?', 'rust',
'fn main() {
    let b = Box::new(42);
    println!("{}", *b + 1);
}', '43', 'medium', 'Dereferencing a Box gives access to the inner value', 3, '2026-06-12'),

('Filter Function', 'What does this code print?', 'python',
'print(list(filter(lambda x: x > 3, [1, 4, 2, 5, 3])))', '[4, 5]', 'easy', 'filter keeps elements where the lambda returns True', 3, '2026-06-13'),

('JSON Stringify', 'What does this code print?', 'javascript',
'console.log(JSON.stringify({ a: 1, b: [2, 3] }))', '{"a":1,"b":[2,3]}', 'easy', 'JSON.stringify serializes an object to a JSON string', 3, '2026-06-14'),

('Vec Contains', 'What does this code print?', 'rust',
'fn main() {
    let v = vec!["apple", "banana", "cherry"];
    println!("{}", v.contains(&"banana"));
}', 'true', 'easy', 'contains checks if the vector has the element', 3, '2026-06-15'),

('Is Instance', 'What does this code print?', 'python',
'print(isinstance(True, int))', 'True', 'hard', 'bool is a subclass of int in Python', 3, '2026-06-16'),

('Array Every', 'What does this code print?', 'javascript',
'console.log([1, 2, 3].every(x => x > 0))', 'true', 'easy', 'every returns true if all elements satisfy the condition', 3, '2026-06-17'),

('String Contains RS', 'What does this code print?', 'rust',
'fn main() {
    let s = "hello world";
    println!("{}", s.contains("world"));
}', 'true', 'easy', 'contains checks for a substring in the string', 3, '2026-06-18'),

('Chained Methods', 'What does this code print?', 'python',
'print("Hello World".upper().split())', '[''HELLO'', ''WORLD'']', 'easy', 'upper() converts to uppercase, split() breaks on whitespace', 3, '2026-06-19'),

('Array ReduceRight', 'What does this code print?', 'javascript',
'console.log([1, 2, 3, 4].reduceRight((a, b) => a - b))', '-2', 'hard', 'reduceRight starts from the right: 4-3=1, 1-2=-1, -1-1=-2', 3, '2026-06-20'),

('Iter Take', 'What does this code print?', 'rust',
'fn main() {
    let v: Vec<i32> = (0..10).take(3).collect();
    println!("{:?}", v);
}', '[0, 1, 2]', 'easy', 'take(3) yields only the first 3 elements', 3, '2026-06-21'),

('Multiple Assignment', 'What does this code print?', 'python',
'a = b = c = 5
print(a, b, c)', '5 5 5', 'easy', 'Chained assignment sets all variables to the same value', 3, '2026-06-22'),

('Array Some', 'What does this code print?', 'javascript',
'console.log([1, 2, 3, 4].some(x => x > 3))', 'true', 'easy', 'some returns true if at least one element satisfies the condition', 3, '2026-06-23'),

('Str To Uppercase', 'What does this code print?', 'rust',
'fn main() {
    let s = "hello";
    println!("{}", s.to_uppercase());
}', 'HELLO', 'easy', 'to_uppercase converts all characters to uppercase', 3, '2026-06-24'),

('Power Operator', 'What does this code print?', 'python',
'print(pow(2, 10))', '1024', 'easy', 'pow(2, 10) computes 2 to the power of 10', 3, '2026-06-25'),

('Symbol Typeof', 'What does this code print?', 'javascript',
'console.log(typeof Symbol("test"))', 'symbol', 'medium', 'Symbols are a primitive type in JavaScript', 3, '2026-06-26'),

('Iter Skip', 'What does this code print?', 'rust',
'fn main() {
    let v: Vec<i32> = (0..5).skip(2).collect();
    println!("{:?}", v);
}', '[2, 3, 4]', 'easy', 'skip(2) discards the first 2 elements', 3, '2026-06-27'),

('List Index', 'What does this code print?', 'python',
'print([10, 20, 30, 40].index(30))', '2', 'easy', 'index() returns the position of the first occurrence', 3, '2026-06-28'),

('Array From Map', 'What does this code print?', 'javascript',
'console.log(Array.from({length: 3}, (_, i) => i * 2).join(","))', '0,2,4', 'medium', 'Array.from with a mapping function generates values', 3, '2026-06-29'),

('Iter Position', 'What does this code print?', 'rust',
'fn main() {
    let v = vec![10, 20, 30, 40];
    let pos = v.iter().position(|&x| x == 30);
    println!("{:?}", pos);
}', 'Some(2)', 'medium', 'position returns the index wrapped in Option', 3, '2026-06-30'),

-- ── July 2026 ───────────────────────────────────────────────────────────────

('Byte Literal', 'What does this code print?', 'python',
'print(b"hello"[0])', '104', 'medium', 'Indexing a bytes object returns the integer value of the byte', 3, '2026-07-01'),

('Bitwise OR', 'What does this code print?', 'javascript',
'console.log(5 | 3)', '7', 'medium', '5 is 101, 3 is 011, OR gives 111 which is 7', 3, '2026-07-02'),

('Str Replace RS', 'What does this code print?', 'rust',
'fn main() {
    let s = "hello world";
    println!("{}", s.replace("world", "rust"));
}', 'hello rust', 'easy', 'replace creates a new string with the substitution', 3, '2026-07-03'),

('Ord Chr', 'What does this code print?', 'python',
'print(chr(65), ord("A"))', 'A 65', 'easy', 'chr converts int to char, ord converts char to int', 3, '2026-07-04'),

('Math Trunc', 'What does this code print?', 'javascript',
'console.log(Math.trunc(-4.7))', '-4', 'easy', 'Math.trunc removes the decimal part without rounding', 3, '2026-07-05'),

('Vec Map', 'What does this code print?', 'rust',
'fn main() {
    let v: Vec<i32> = vec![1, 2, 3].iter().map(|x| x * x).collect();
    println!("{:?}", v);
}', '[1, 4, 9]', 'easy', 'map transforms each element by squaring it', 3, '2026-07-06'),

('Hex Conversion', 'What does this code print?', 'python',
'print(hex(255))', '0xff', 'easy', 'hex() converts an integer to a hexadecimal string', 3, '2026-07-07'),

('String Slice JS', 'What does this code print?', 'javascript',
'console.log("hello world".slice(-5))', 'world', 'easy', 'Negative index in slice counts from the end', 3, '2026-07-08'),

('Vec Last', 'What does this code print?', 'rust',
'fn main() {
    let v = vec![10, 20, 30];
    println!("{:?}", v.last());
}', 'Some(30)', 'easy', 'last() returns the last element wrapped in Option', 3, '2026-07-09'),

('Bin Function', 'What does this code print?', 'python',
'print(bin(10))', '0b1010', 'easy', 'bin() converts an integer to binary string', 3, '2026-07-10'),

('ParseInt Hex', 'What does this code print?', 'javascript',
'console.log(parseInt("0x1A", 16))', '26', 'medium', 'parseInt with base 16 parses hexadecimal', 3, '2026-07-11'),

('Str Trim', 'What does this code print?', 'rust',
'fn main() {
    let s = "  hello  ";
    println!("{}!", s.trim());
}', 'hello!', 'easy', 'trim() removes leading and trailing whitespace', 3, '2026-07-12'),

('Title Case', 'What does this code print?', 'python',
'print("hello world foo".title())', 'Hello World Foo', 'easy', 'title() capitalizes the first letter of each word', 3, '2026-07-13'),

('Number ToFixed', 'What does this code print?', 'javascript',
'console.log((3.14159).toFixed(2))', '3.14', 'easy', 'toFixed(2) rounds to 2 decimal places and returns a string', 3, '2026-07-14'),

('Vec First Empty', 'What does this code print?', 'rust',
'fn main() {
    let v: Vec<i32> = vec![];
    println!("{:?}", v.first());
}', 'None', 'easy', 'first() on an empty vector returns None', 3, '2026-07-15'),

('Any Function', 'What does this code print?', 'python',
'print(any([0, "", None, 42]))', 'True', 'easy', 'any() returns True if at least one element is truthy', 3, '2026-07-16'),

('Array Reverse', 'What does this code print?', 'javascript',
'const arr = [1, 2, 3];
arr.reverse();
console.log(arr.join(","))', '3,2,1', 'easy', 'reverse() mutates the array in place', 3, '2026-07-17'),

('Vec Extend', 'What does this code print?', 'rust',
'fn main() {
    let mut a = vec![1, 2];
    a.extend(vec![3, 4]);
    println!("{:?}", a);
}', '[1, 2, 3, 4]', 'easy', 'extend appends all elements from another collection', 3, '2026-07-18'),

('String Center', 'What does this code print?', 'python',
'print("hi".center(6, "-"))', '--hi--', 'medium', 'center pads both sides to reach the target width', 3, '2026-07-19'),

('String Match JS', 'What does this code print?', 'javascript',
'const m = "hello123".match(/\d+/);
console.log(m[0])', '123', 'medium', 'match returns an array; the first element is the full match', 3, '2026-07-20'),

('Iter Any All RS', 'What does this code print?', 'rust',
'fn main() {
    let v = vec![2, 4, 6];
    println!("{} {}", v.iter().all(|x| x % 2 == 0), v.iter().any(|x| *x > 5));
}', 'true true', 'medium', 'all checks every element, any checks at least one', 3, '2026-07-21'),

('String Zfill', 'What does this code print?', 'python',
'print("42".zfill(5))', '00042', 'easy', 'zfill pads with zeros on the left', 3, '2026-07-22'),

('Array Fill', 'What does this code print?', 'javascript',
'console.log(new Array(3).fill(7).join(","))', '7,7,7', 'easy', 'fill() sets all elements to the given value', 3, '2026-07-23'),

('Iter Max', 'What does this code print?', 'rust',
'fn main() {
    let v = vec![3, 7, 1, 9, 4];
    println!("{:?}", v.iter().max());
}', 'Some(9)', 'easy', 'max returns the largest element wrapped in Option', 3, '2026-07-24'),

('Complex Slice', 'What does this code print?', 'python',
'lst = [0, 1, 2, 3, 4, 5]
print(lst[1:5:2])', '[1, 3]', 'medium', 'Slicing with step 2 takes every other element', 3, '2026-07-25'),

('Bitwise XOR', 'What does this code print?', 'javascript',
'console.log(5 ^ 3)', '6', 'medium', '5 is 101, 3 is 011, XOR gives 110 which is 6', 3, '2026-07-26'),

('Iter Min', 'What does this code print?', 'rust',
'fn main() {
    let v = vec![3, 7, 1, 9, 4];
    println!("{:?}", v.iter().min());
}', 'Some(1)', 'easy', 'min returns the smallest element wrapped in Option', 3, '2026-07-27'),

('Str Count', 'What does this code print?', 'python',
'print("banana".count("an"))', '2', 'easy', 'count() returns non-overlapping occurrences of substring', 3, '2026-07-28'),

('Array IndexOf', 'What does this code print?', 'javascript',
'console.log(["a", "b", "c", "b"].indexOf("b"))', '1', 'easy', 'indexOf returns the first index of the element', 3, '2026-07-29'),

('Iter Peekable', 'What does this code print?', 'rust',
'fn main() {
    let v = vec![1, 2, 3];
    let mut iter = v.iter().peekable();
    println!("{:?}", iter.peek());
    println!("{:?}", iter.next());
}', 'Some(1)
Some(1)', 'medium', 'peek looks at the next element without consuming it', 3, '2026-07-30'),

('Ljust Rjust', 'What does this code print?', 'python',
'print("hi".ljust(5, ".") + "hi".rjust(5, "."))', 'hi......hi', 'medium', 'ljust pads right, rjust pads left', 3, '2026-07-31'),

-- ── August 2026 ─────────────────────────────────────────────────────────────

('String Raw', 'What does this code print?', 'javascript',
'console.log(String.raw`hello\nworld`)', 'hello\nworld', 'medium', 'String.raw treats backslashes as literal characters', 3, '2026-08-01'),

('Iter Product', 'What does this code print?', 'rust',
'fn main() {
    let product: i32 = vec![2, 3, 4].iter().product();
    println!("{product}");
}', '24', 'easy', 'product() multiplies all elements: 2*3*4=24', 3, '2026-08-02'),

('String Encode', 'What does this code print?', 'python',
'print(len("hello".encode("utf-8")))', '5', 'easy', 'ASCII characters are 1 byte each in UTF-8', 3, '2026-08-03'),

('Array Flat One', 'What does this code print?', 'javascript',
'console.log([1, [2, 3], [4]].flat().join(","))', '1,2,3,4', 'easy', 'flat() flattens one level of nesting by default', 3, '2026-08-04'),

('Str Starts With RS', 'What does this code print?', 'rust',
'fn main() {
    let s = "hello world";
    println!("{}", s.starts_with("hello"));
}', 'true', 'easy', 'starts_with checks the beginning of the string', 3, '2026-08-05'),

('Dict Pop', 'What does this code print?', 'python',
'd = {"a": 1, "b": 2, "c": 3}
val = d.pop("b")
print(val, len(d))', '2 2', 'easy', 'pop removes the key and returns its value', 3, '2026-08-06'),

('ParseInt Default', 'What does this code print?', 'javascript',
'console.log(parseInt("08"))', '8', 'easy', 'parseInt defaults to base 10 in modern JavaScript', 3, '2026-08-07'),

('Str Split Whitespace', 'What does this code print?', 'rust',
'fn main() {
    let s = "hello world rust";
    let words: Vec<&str> = s.split_whitespace().collect();
    println!("{}", words.len());
}', '3', 'easy', 'split_whitespace splits on any whitespace', 3, '2026-08-08'),

('List Insert', 'What does this code print?', 'python',
'lst = [1, 2, 3]
lst.insert(1, 99)
print(lst)', '[1, 99, 2, 3]', 'easy', 'insert(1, 99) puts 99 at index 1, shifting others right', 3, '2026-08-09'),

('String EndsWith', 'What does this code print?', 'javascript',
'console.log("filename.txt".endsWith(".txt"))', 'true', 'easy', 'endsWith checks if the string ends with the given suffix', 3, '2026-08-10'),

('Str Ends With RS', 'What does this code print?', 'rust',
'fn main() {
    let s = "picture.png";
    println!("{}", s.ends_with(".png"));
}', 'true', 'easy', 'ends_with checks the suffix of the string', 3, '2026-08-11'),

('Nested Unpacking', 'What does this code print?', 'python',
'(a, b), c = [1, 2], 3
print(a, b, c)', '1 2 3', 'medium', 'Python supports nested unpacking of sequences', 3, '2026-08-12'),

('Array Concat', 'What does this code print?', 'javascript',
'const a = [1, 2];
const b = a.concat([3, 4]);
console.log(a.length, b.length)', '2 4', 'easy', 'concat creates a new array; the original is unchanged', 3, '2026-08-13'),

('Iter Flatten', 'What does this code print?', 'rust',
'fn main() {
    let v = vec![vec![1, 2], vec![3], vec![4, 5]];
    let flat: Vec<i32> = v.into_iter().flatten().collect();
    println!("{:?}", flat);
}', '[1, 2, 3, 4, 5]', 'medium', 'flatten collapses nested iterators into one', 3, '2026-08-14'),

('String Format Spec', 'What does this code print?', 'python',
'print(f"{42:08b}")', '00101010', 'medium', '08b formats as binary padded to 8 digits with zeros', 3, '2026-08-15'),

('Truthy String', 'What does this code print?', 'javascript',
'console.log(Boolean("0"))', 'true', 'medium', 'Non-empty strings are truthy in JavaScript, even "0"', 3, '2026-08-16'),

('String Chars RS', 'What does this code print?', 'rust',
'fn main() {
    let s = "hello";
    let first = s.chars().next().unwrap();
    println!("{first}");
}', 'h', 'easy', 'chars().next() gets the first character', 3, '2026-08-17'),

('Str Translate', 'What does this code print?', 'python',
'table = str.maketrans("aeiou", "12345")
print("hello".translate(table))', 'h2ll4', 'medium', 'translate replaces characters using the translation table', 3, '2026-08-18'),

('Unary Plus', 'What does this code print?', 'javascript',
'console.log(+"42")', '42', 'easy', 'Unary + converts a string to a number', 3, '2026-08-19'),

('Iter Step By', 'What does this code print?', 'rust',
'fn main() {
    let v: Vec<i32> = (0..10).step_by(3).collect();
    println!("{:?}", v);
}', '[0, 3, 6, 9]', 'medium', 'step_by(3) yields every third element', 3, '2026-08-20'),

('Min Max PY', 'What does this code print?', 'python',
'print(min(3, 1, 4), max(3, 1, 4))', '1 4', 'easy', 'min and max find the smallest and largest values', 3, '2026-08-21'),

('Comma Operator', 'What does this code print?', 'javascript',
'const x = (1, 2, 3);
console.log(x)', '3', 'hard', 'The comma operator evaluates all expressions and returns the last', 3, '2026-08-22'),

('HashMap Len', 'What does this code print?', 'rust',
'use std::collections::HashMap;
fn main() {
    let mut m = HashMap::new();
    m.insert("a", 1);
    m.insert("b", 2);
    m.insert("c", 3);
    println!("{}", m.len());
}', '3', 'easy', 'len() returns the number of key-value pairs', 3, '2026-08-23'),

('Ternary Expression', 'What does this code print?', 'python',
'x = 7
print("even" if x % 2 == 0 else "odd")', 'odd', 'easy', 'Python ternary: value_if_true if condition else value_if_false', 3, '2026-08-24'),

('String TrimStart', 'What does this code print?', 'javascript',
'console.log("   hello   ".trimStart())', 'hello   ', 'easy', 'trimStart removes leading whitespace only', 3, '2026-08-25'),

('Vec Chunks', 'What does this code print?', 'rust',
'fn main() {
    let v = vec![1, 2, 3, 4, 5];
    let chunks: Vec<&[i32]> = v.chunks(2).collect();
    println!("{}", chunks.len());
}', '3', 'medium', 'chunks(2) splits into groups of 2, with a smaller last chunk', 3, '2026-08-26'),

('Math Ceil', 'What does this code print?', 'python',
'import math
print(math.ceil(4.1))', '5', 'easy', 'ceil rounds up to the nearest integer', 3, '2026-08-27'),

('Double Tilde', 'What does this code print?', 'javascript',
'console.log(~~4.9)', '4', 'medium', 'Double bitwise NOT truncates to integer like Math.trunc', 3, '2026-08-28'),

('Iter Collect String', 'What does this code print?', 'rust',
'fn main() {
    let s: String = vec![''h'', ''i''].into_iter().collect();
    println!("{s}");
}', 'hi', 'easy', 'Collecting chars into a String builds the string', 3, '2026-08-29'),

('Bool Conversion', 'What does this code print?', 'python',
'print(int(True), int(False))', '1 0', 'easy', 'True converts to 1 and False converts to 0', 3, '2026-08-30'),

('Logical OR Assign', 'What does this code print?', 'javascript',
'let x = 0;
x ||= 42;
console.log(x)', '42', 'medium', '||= assigns the right side only if the left is falsy', 3, '2026-08-31'),

-- ── September 2026 ──────────────────────────────────────────────────────────

('Range Sum RS', 'What does this code print?', 'rust',
'fn main() {
    let total: i32 = (1..=100).sum();
    println!("{total}");
}', '5050', 'easy', 'Sum of 1 to 100 using inclusive range', 3, '2026-09-01'),

('String Expandtabs', 'What does this code print?', 'python',
'print("a\tb".expandtabs(4))', 'a   b', 'medium', 'expandtabs replaces tab characters with spaces', 3, '2026-09-02'),

('Object Freeze', 'What does this code print?', 'javascript',
'const obj = Object.freeze({ a: 1, b: 2 });
obj.c = 3;
console.log(Object.keys(obj).length)', '2', 'medium', 'Object.freeze prevents adding or modifying properties', 3, '2026-09-03'),

('Iter Count RS', 'What does this code print?', 'rust',
'fn main() {
    let count = "hello world".chars().filter(|c| c.is_alphabetic()).count();
    println!("{count}");
}', '10', 'easy', 'Counts alphabetic characters (space is excluded)', 3, '2026-09-04'),

('String Ljust PY', 'What does this code print?', 'python',
'print("|" + "hi".ljust(10) + "|")', '|hi        |', 'easy', 'ljust pads the right side with spaces to the given width', 3, '2026-09-05'),

('Promise Type', 'What does this code print?', 'javascript',
'console.log(typeof Promise.resolve(42))', 'object', 'medium', 'Promise.resolve returns a Promise object', 3, '2026-09-06'),

('Iter Map Collect RS', 'What does this code print?', 'rust',
'fn main() {
    let v: Vec<String> = vec!["hi", "bye"]
        .iter()
        .map(|s| s.to_uppercase())
        .collect();
    println!("{:?}", v);
}', '["HI", "BYE"]', 'easy', 'map with to_uppercase transforms each string', 3, '2026-09-07'),

('Str Isalpha', 'What does this code print?', 'python',
'print("hello".isalpha(), "hello1".isalpha())', 'True False', 'easy', 'isalpha returns True only if all characters are alphabetic', 3, '2026-09-08'),

('Array Identity', 'What does this code print?', 'javascript',
'const a = [1, 2];
const b = [1, 2];
console.log(a === b)', 'false', 'medium', 'Two arrays with the same contents are different objects', 3, '2026-09-09'),

('Iter Scan', 'What does this code print?', 'rust',
'fn main() {
    let v: Vec<i32> = (1..=4)
        .scan(0, |state, x| {
            *state += x;
            Some(*state)
        })
        .collect();
    println!("{:?}", v);
}', '[1, 3, 6, 10]', 'hard', 'scan accumulates running totals: 1, 1+2, 1+2+3, 1+2+3+4', 3, '2026-09-10'),

('String Rfind', 'What does this code print?', 'python',
'print("banana".rfind("an"))', '3', 'medium', 'rfind returns the last occurrence index of the substring', 3, '2026-09-11'),

('String ReplaceAll', 'What does this code print?', 'javascript',
'console.log("aabaa".replaceAll("aa", "X"))', 'XbX', 'easy', 'replaceAll replaces all occurrences', 3, '2026-09-12'),

('Vec Truncate', 'What does this code print?', 'rust',
'fn main() {
    let mut v = vec![1, 2, 3, 4, 5];
    v.truncate(3);
    println!("{:?}", v);
}', '[1, 2, 3]', 'easy', 'truncate removes elements beyond the given length', 3, '2026-09-13'),

('Dict Update', 'What does this code print?', 'python',
'a = {"x": 1}
a.update({"x": 10, "y": 20})
print(a)', '{''x'': 10, ''y'': 20}', 'easy', 'update merges in the new dict, overwriting existing keys', 3, '2026-09-14'),

('Array LastIndexOf', 'What does this code print?', 'javascript',
'console.log([1, 2, 3, 2, 1].lastIndexOf(2))', '3', 'easy', 'lastIndexOf returns the last index of the element', 3, '2026-09-15'),

('Const in Block', 'What does this code print?', 'rust',
'fn main() {
    const MAX: i32 = 100;
    let val = MAX - 1;
    println!("{val}");
}', '99', 'easy', 'const defines a compile-time constant', 3, '2026-09-16'),

('Count Spaces', 'What does this code print?', 'python',
'print("hello world".count(" "))', '1', 'easy', 'count returns the number of non-overlapping occurrences', 3, '2026-09-17'),

('In Operator JS', 'What does this code print?', 'javascript',
'const obj = { a: 1, b: undefined };
console.log("b" in obj)', 'true', 'medium', 'in checks if the key exists, regardless of value', 3, '2026-09-18'),

('Str Len RS', 'What does this code print?', 'rust',
'fn main() {
    let s = "hello";
    println!("{}", s.len());
}', '5', 'easy', 'len() returns the byte length (same as char count for ASCII)', 3, '2026-09-19'),

('List Extend', 'What does this code print?', 'python',
'a = [1, 2]
a.extend([3, 4])
print(a)', '[1, 2, 3, 4]', 'easy', 'extend appends all elements from the iterable', 3, '2026-09-20'),

('Slice Copy JS', 'What does this code print?', 'javascript',
'const a = [1, 2, 3];
const b = a.slice();
b.push(4);
console.log(a.length)', '3', 'easy', 'slice() with no args creates a shallow copy', 3, '2026-09-21'),

('Range Inclusive', 'What does this code print?', 'rust',
'fn main() {
    let v: Vec<i32> = (1..=5).collect();
    println!("{:?}", v);
}', '[1, 2, 3, 4, 5]', 'easy', '..= creates an inclusive range', 3, '2026-09-22'),

('Walrus In While', 'What does this code print?', 'python',
'data = [1, 2, 3]
while (n := data.pop()) != 1:
    pass
print(n)', '1', 'medium', 'Walrus operator assigns inside the while condition', 3, '2026-09-23'),

('Array FindIndex', 'What does this code print?', 'javascript',
'console.log([10, 20, 30, 40].findIndex(x => x > 25))', '2', 'easy', 'findIndex returns the index of the first match', 3, '2026-09-24'),

('Iter Sum Float', 'What does this code print?', 'rust',
'fn main() {
    let total: f64 = vec![1.5, 2.5, 3.0].iter().sum();
    println!("{total}");
}', '7', 'easy', 'sum adds all floating point values', 3, '2026-09-25'),

('Str Splitlines', 'What does this code print?', 'python',
'text = "line1\nline2\nline3"
print(len(text.splitlines()))', '3', 'easy', 'splitlines splits at newline characters', 3, '2026-09-26'),

('Map Get', 'What does this code print?', 'javascript',
'const m = new Map([[1, "a"], [2, "b"], [3, "c"]]);
console.log(m.get(2))', 'b', 'easy', 'Map.get retrieves the value for a key', 3, '2026-09-27'),

('Iter Min By Key', 'What does this code print?', 'rust',
'fn main() {
    let words = vec!["hello", "hi", "hey"];
    let shortest = words.iter().min_by_key(|w| w.len()).unwrap();
    println!("{shortest}");
}', 'hi', 'medium', 'min_by_key finds the element with the smallest key value', 3, '2026-09-28'),

('Round To Even', 'What does this code print?', 'python',
'print(round(0.5), round(1.5), round(2.5))', '0 2 2', 'hard', 'Python rounds to the nearest even number at .5', 3, '2026-09-29'),

('Ternary Nested', 'What does this code print?', 'javascript',
'const x = 15;
console.log(x > 20 ? "big" : x > 10 ? "medium" : "small")', 'medium', 'medium', 'Nested ternaries evaluate from right to left', 3, '2026-09-30'),

-- ── October 2026 ────────────────────────────────────────────────────────────

('Iter Filter Map', 'What does this code print?', 'rust',
'fn main() {
    let v: Vec<i32> = vec![1, 2, 3, 4, 5]
        .into_iter()
        .filter_map(|x| if x > 2 { Some(x * 10) } else { None })
        .collect();
    println!("{:?}", v);
}', '[30, 40, 50]', 'medium', 'filter_map combines filter and map in one step', 3, '2026-10-01'),

('String Upper', 'What does this code print?', 'python',
'print("hello".upper())', 'HELLO', 'easy', 'upper() converts all characters to uppercase', 3, '2026-10-02'),

('Spread Function', 'What does this code print?', 'javascript',
'function sum(...args) {
    return args.reduce((a, b) => a + b, 0);
}
console.log(sum(1, 2, 3, 4))', '10', 'easy', 'Rest parameters collect all arguments into an array', 3, '2026-10-03'),

('String Push RS', 'What does this code print?', 'rust',
'fn main() {
    let mut s = String::from("hello");
    s.push_str(" world");
    println!("{s}");
}', 'hello world', 'easy', 'push_str appends a string slice to a String', 3, '2026-10-04'),

('Map Sum PY', 'What does this code print?', 'python',
'print(sum(map(int, "123")))', '6', 'easy', 'map(int, ...) converts each char to int, sum adds them', 3, '2026-10-05'),

('Exponent Operator', 'What does this code print?', 'javascript',
'console.log(2 ** 10)', '1024', 'easy', '** is the exponentiation operator', 3, '2026-10-06'),

('Match Guard', 'What does this code print?', 'rust',
'fn main() {
    let x = 4;
    let msg = match x {
        n if n < 0 => "negative",
        0 => "zero",
        n if n % 2 == 0 => "even",
        _ => "odd",
    };
    println!("{msg}");
}', 'even', 'medium', 'Match guards add extra conditions to patterns', 3, '2026-10-07'),

('List Mul Trap', 'What does this code print?', 'python',
'a = [[0]] * 3
a[0][0] = 1
print(a)', '[[1], [1], [1]]', 'hard', '* creates shallow copies — all inner lists are the same object', 3, '2026-10-08'),

('Delete Undefined', 'What does this code print?', 'javascript',
'const arr = [1, 2, 3];
delete arr[1];
console.log(arr.length)', '3', 'hard', 'delete removes the element but does not change the length', 3, '2026-10-09'),

('Iter Cycle', 'What does this code print?', 'rust',
'fn main() {
    let v: Vec<i32> = [1, 2].iter().cycle().take(5).copied().collect();
    println!("{:?}", v);
}', '[1, 2, 1, 2, 1]', 'medium', 'cycle repeats the iterator infinitely, take limits it', 3, '2026-10-10'),

('Str Find PY', 'What does this code print?', 'python',
'print("hello world".find("world"))', '6', 'easy', 'find returns the index of the first occurrence', 3, '2026-10-11'),

('Array Constructor', 'What does this code print?', 'javascript',
'console.log(Array(3).fill(0).join(","))', '0,0,0', 'easy', 'Array(3) creates an array of length 3, fill sets all values', 3, '2026-10-12'),

('Vec Iter Even Sum', 'What does this code print?', 'rust',
'fn main() {
    let v = vec![1, 2, 3, 4, 5];
    let even_sum: i32 = v.iter().filter(|&&x| x % 2 == 0).sum();
    println!("{even_sum}");
}', '6', 'medium', 'Filter even numbers and sum: 2 + 4 = 6', 3, '2026-10-13'),

('Str Format PY', 'What does this code print?', 'python',
'print("{} + {} = {}".format(1, 2, 3))', '1 + 2 = 3', 'easy', 'format fills in the placeholders in order', 3, '2026-10-14'),

('IsFinite', 'What does this code print?', 'javascript',
'console.log(Number.isFinite(Infinity))', 'false', 'easy', 'Infinity is not considered finite', 3, '2026-10-15'),

('Closure Return', 'What does this code print?', 'rust',
'fn make_adder(x: i32) -> impl Fn(i32) -> i32 {
    move |y| x + y
}
fn main() {
    let add5 = make_adder(5);
    println!("{}", add5(3));
}', '8', 'medium', 'The closure captures x and adds it to its argument', 3, '2026-10-16'),

('Str Isupper', 'What does this code print?', 'python',
'print("HELLO".isupper(), "Hello".isupper())', 'True False', 'easy', 'isupper returns True only if all cased characters are uppercase', 3, '2026-10-17'),

('Object Destructure', 'What does this code print?', 'javascript',
'const { a, b, ...rest } = { a: 1, b: 2, c: 3, d: 4 };
console.log(Object.keys(rest).length)', '2', 'medium', 'Rest syntax collects remaining properties', 3, '2026-10-18'),

('Iter Inspect', 'What does this code print?', 'rust',
'fn main() {
    let sum: i32 = (1..=3).inspect(|x| { let _ = x; }).sum();
    println!("{sum}");
}', '6', 'easy', 'inspect allows peeking at values; does not change the iterator', 3, '2026-10-19'),

('Dict Keys Sorted', 'What does this code print?', 'python',
'd = {"a": 1, "b": 2, "c": 3}
print(sorted(d.keys()))', '[''a'', ''b'', ''c'']', 'easy', 'keys() returns the dictionary keys, sorted alphabetically', 3, '2026-10-20'),

('Entries Loop', 'What does this code print?', 'javascript',
'const arr = ["a", "b", "c"];
for (const [i, v] of arr.entries()) {
    if (i === 1) console.log(v);
}', 'b', 'medium', 'entries() gives [index, value] pairs', 3, '2026-10-21'),

('Nested Match', 'What does this code print?', 'rust',
'fn main() {
    let pair = (true, 42);
    match pair {
        (true, n) if n > 0 => println!("positive truth"),
        _ => println!("other"),
    }
}', 'positive truth', 'medium', 'Nested pattern matching with a guard condition', 3, '2026-10-22'),

('Str Swapcase', 'What does this code print?', 'python',
'print("Hello World".swapcase())', 'hELLO wORLD', 'easy', 'swapcase inverts the case of each character', 3, '2026-10-23'),

('JSON Parse', 'What does this code print?', 'javascript',
'const obj = JSON.parse(''{"a":1,"b":2}'');
console.log(obj.a + obj.b)', '3', 'easy', 'JSON.parse converts a JSON string to an object', 3, '2026-10-24'),

('Iter Unzip', 'What does this code print?', 'rust',
'fn main() {
    let (a, b): (Vec<i32>, Vec<i32>) = vec![(1, 10), (2, 20), (3, 30)]
        .into_iter()
        .unzip();
    println!("{:?} {:?}", a, b);
}', '[1, 2, 3] [10, 20, 30]', 'medium', 'unzip separates pairs into two collections', 3, '2026-10-25'),

('Bytes Decode', 'What does this code print?', 'python',
'print(bytes([72, 101, 108]).decode())', 'Hel', 'medium', 'bytes from integers decoded as UTF-8', 3, '2026-10-26'),

('Tagged Template', 'What does this code print?', 'javascript',
'function tag(strings, ...vals) {
    return strings[0] + vals[0];
}
console.log(tag`hello ${42} world`)', 'hello 42', 'hard', 'Tagged templates receive string parts and interpolated values separately', 3, '2026-10-27'),

('Iter Enumerate RS', 'What does this code print?', 'rust',
'fn main() {
    let v = vec!["a", "b", "c"];
    let result: Vec<_> = v.iter().enumerate().collect();
    println!("{:?}", result);
}', '[(0, "a"), (1, "b"), (2, "c")]', 'easy', 'enumerate pairs each element with its index', 3, '2026-10-28'),

('Dict Fromkeys', 'What does this code print?', 'python',
'print(dict.fromkeys(["a", "b", "c"], 0))', '{''a'': 0, ''b'': 0, ''c'': 0}', 'medium', 'fromkeys creates a dict with the given keys and default value', 3, '2026-10-29'),

('Math Sign', 'What does this code print?', 'javascript',
'console.log(Math.sign(-42), Math.sign(0), Math.sign(100))', '-1 0 1', 'easy', 'Math.sign returns -1, 0, or 1 based on the sign', 3, '2026-10-30'),

('Halloween Enum', 'What does this code print?', 'rust',
'#[derive(Debug)]
enum Monster {
    Ghost,
    Zombie,
    Vampire,
}
fn main() {
    let m = Monster::Vampire;
    println!("{:?}", m);
}', 'Vampire', 'easy', 'Debug trait prints the enum variant name', 3, '2026-10-31'),

-- ── November 2026 ───────────────────────────────────────────────────────────

('Str Isnumeric', 'What does this code print?', 'python',
'print("123".isnumeric(), "12.3".isnumeric())', 'True False', 'easy', 'isnumeric returns True only if all characters are numeric', 3, '2026-11-01'),

('Array Keys', 'What does this code print?', 'javascript',
'console.log([...Array(3).keys()].join(","))', '0,1,2', 'easy', 'Array(3).keys() generates indices 0, 1, 2', 3, '2026-11-02'),

('Vec Pop', 'What does this code print?', 'rust',
'fn main() {
    let mut v = vec![1, 2, 3];
    let last = v.pop();
    println!("{:?} {:?}", last, v);
}', 'Some(3) [1, 2]', 'easy', 'pop removes and returns the last element', 3, '2026-11-03'),

('Tuple Concat', 'What does this code print?', 'python',
'a = (1, 2, 3)
print(a + (4, 5))', '(1, 2, 3, 4, 5)', 'easy', 'Tuples can be concatenated with +', 3, '2026-11-04'),

('Async Typeof', 'What does this code print?', 'javascript',
'console.log(typeof (async function() {}))', 'function', 'medium', 'Async functions are still of type function', 3, '2026-11-05'),

('Ownership Scope', 'What does this code print?', 'rust',
'fn main() {
    let x = 5;
    {
        let y = x + 1;
        println!("{y}");
    }
}', '6', 'easy', 'Variables are valid within their scope', 3, '2026-11-06'),

('String Casefold', 'What does this code print?', 'python',
'print("HELLO".casefold())', 'hello', 'easy', 'casefold performs aggressive lowercasing', 3, '2026-11-07'),

('Nullish Assign', 'What does this code print?', 'javascript',
'let x = null;
x ??= 42;
console.log(x)', '42', 'medium', '??= assigns only if the left side is null or undefined', 3, '2026-11-08'),

('Iter Last', 'What does this code print?', 'rust',
'fn main() {
    let last = (0..5).last();
    println!("{:?}", last);
}', 'Some(4)', 'easy', 'last() returns the final element of the iterator', 3, '2026-11-09'),

('Complex Comprehension', 'What does this code print?', 'python',
'print({x: x**2 for x in range(4)})', '{0: 0, 1: 1, 2: 4, 3: 9}', 'medium', 'Dict comprehension maps each key to its square', 3, '2026-11-10'),

('String At JS', 'What does this code print?', 'javascript',
'console.log("hello".at(-2))', 'l', 'easy', 'at(-2) returns the second to last character', 3, '2026-11-11'),

('Ref Count', 'What does this code print?', 'rust',
'fn main() {
    let v = vec![1, 2, 3, 4, 5];
    let count = v.iter().filter(|&&x| x > 3).count();
    println!("{count}");
}', '2', 'easy', 'filter and count: 4 and 5 are greater than 3', 3, '2026-11-12'),

('List Remove', 'What does this code print?', 'python',
'lst = [1, 2, 3, 2, 1]
lst.remove(2)
print(lst)', '[1, 3, 2, 1]', 'easy', 'remove deletes the first occurrence only', 3, '2026-11-13'),

('FromEntries', 'What does this code print?', 'javascript',
'const entries = [["a", 1], ["b", 2]];
console.log(JSON.stringify(Object.fromEntries(entries)))', '{"a":1,"b":2}', 'medium', 'Object.fromEntries converts [key, value] pairs to an object', 3, '2026-11-14'),

('Vec Sort', 'What does this code print?', 'rust',
'fn main() {
    let mut v = vec![3, 1, 4, 1, 5];
    v.sort();
    println!("{:?}", v);
}', '[1, 1, 3, 4, 5]', 'easy', 'sort() sorts the vector in ascending order', 3, '2026-11-15'),

('Lambda Map PY', 'What does this code print?', 'python',
'double = lambda x: x * 2
print(list(map(double, [1, 2, 3])))', '[2, 4, 6]', 'easy', 'lambda with map applies the function to each element', 3, '2026-11-16'),

('Typeof Function', 'What does this code print?', 'javascript',
'console.log(typeof function(){})', 'function', 'easy', 'Functions have their own type in JavaScript', 3, '2026-11-17'),

('Vec Binary Search', 'What does this code print?', 'rust',
'fn main() {
    let v = vec![1, 3, 5, 7, 9];
    println!("{:?}", v.binary_search(&5));
}', 'Ok(2)', 'medium', 'binary_search returns Ok with the index if found', 3, '2026-11-18'),

('Dict Setdefault', 'What does this code print?', 'python',
'd = {"a": 1}
d.setdefault("b", 2)
d.setdefault("a", 99)
print(d)', '{''a'': 1, ''b'': 2}', 'medium', 'setdefault only sets the value if the key is missing', 3, '2026-11-19'),

('Symbol Description', 'What does this code print?', 'javascript',
'const s = Symbol("test");
console.log(s.description)', 'test', 'medium', 'The description property returns the Symbol description string', 3, '2026-11-20'),

('Iter Zip RS', 'What does this code print?', 'rust',
'fn main() {
    let a = vec![1, 2, 3];
    let b = vec![4, 5];
    let zipped: Vec<_> = a.iter().zip(b.iter()).collect();
    println!("{:?}", zipped);
}', '[(1, 4), (2, 5)]', 'medium', 'zip stops at the shorter iterator', 3, '2026-11-21'),

('Multiple Inheritance', 'What does this code print?', 'python',
'class A:
    x = 1
class B(A):
    x = 2
class C(A):
    pass
print(B.x, C.x)', '2 1', 'medium', 'B overrides x, C inherits from A', 3, '2026-11-22'),

('Label Break JS', 'What does this code print?', 'javascript',
'let result = 0;
outer: for (let i = 0; i < 3; i++) {
    for (let j = 0; j < 3; j++) {
        if (j === 1) continue outer;
        result += 1;
    }
}
console.log(result)', '3', 'hard', 'continue outer skips the rest of the inner loop each time', 3, '2026-11-23'),

('String Bytes RS', 'What does this code print?', 'rust',
'fn main() {
    let s = "hi";
    println!("{}", s.as_bytes().len());
}', '2', 'easy', 'as_bytes returns the byte representation', 3, '2026-11-24'),

('Itertools Chain', 'What does this code print?', 'python',
'from itertools import chain
print(list(chain([1, 2], [3], [4, 5])))', '[1, 2, 3, 4, 5]', 'easy', 'chain concatenates multiple iterables', 3, '2026-11-25'),

('Reflect OwnKeys', 'What does this code print?', 'javascript',
'console.log(Reflect.ownKeys({ a: 1, b: 2 }).length)', '2', 'medium', 'Reflect.ownKeys returns all own property keys', 3, '2026-11-26'),

('Iter Copied', 'What does this code print?', 'rust',
'fn main() {
    let v = vec![1, 2, 3];
    let doubled: Vec<i32> = v.iter().copied().map(|x| x * 2).collect();
    println!("{:?}", doubled);
}', '[2, 4, 6]', 'easy', 'copied converts from &i32 to i32, then map doubles each', 3, '2026-11-27'),

('Str Rstrip', 'What does this code print?', 'python',
'print("hello...".rstrip("."))', 'hello', 'easy', 'rstrip removes trailing characters matching the argument', 3, '2026-11-28'),

('Filter Modulo', 'What does this code print?', 'javascript',
'console.log([1, 2, 3, 4, 5, 6].filter(x => x % 3 === 0).join(","))', '3,6', 'easy', 'filter keeps only elements divisible by 3', 3, '2026-11-29'),

('Vec Swap', 'What does this code print?', 'rust',
'fn main() {
    let mut v = vec![1, 2, 3, 4];
    v.swap(0, 3);
    println!("{:?}", v);
}', '[4, 2, 3, 1]', 'easy', 'swap exchanges elements at two indices', 3, '2026-11-30'),

-- ── December 2026 ───────────────────────────────────────────────────────────

('Hash Set Union', 'What does this code print?', 'python',
'a = {1, 2, 3}
b = {2, 3, 4}
print(sorted(a | b))', '[1, 2, 3, 4]', 'easy', '| is set union — elements in either set', 3, '2026-12-01'),

('String Search JS', 'What does this code print?', 'javascript',
'console.log("hello world".search(/world/))', '6', 'easy', 'search returns the index of the first match', 3, '2026-12-02'),

('Iter Flat Map RS', 'What does this code print?', 'rust',
'fn main() {
    let v: Vec<i32> = vec![1, 2, 3]
        .into_iter()
        .flat_map(|x| vec![x, x * 10])
        .collect();
    println!("{:?}", v);
}', '[1, 10, 2, 20, 3, 30]', 'medium', 'flat_map maps each element to a vector and flattens', 3, '2026-12-03'),

('Str Rjust PY', 'What does this code print?', 'python',
'print("42".rjust(5, "0"))', '00042', 'easy', 'rjust pads the left side to reach the target width', 3, '2026-12-04'),

('Reverse String JS', 'What does this code print?', 'javascript',
'console.log([..."hello"].reverse().join(""))', 'olleh', 'easy', 'Spread into array, reverse, and join to reverse a string', 3, '2026-12-05'),

('Struct Update', 'What does this code print?', 'rust',
'#[derive(Debug)]
struct Point { x: i32, y: i32 }
fn main() {
    let p1 = Point { x: 1, y: 2 };
    let p2 = Point { x: 10, ..p1 };
    println!("{:?}", p2);
}', 'Point { x: 10, y: 2 }', 'medium', 'Struct update syntax copies remaining fields from p1', 3, '2026-12-06'),

('Sum Range PY', 'What does this code print?', 'python',
'print(sum(range(1, 11)))', '55', 'easy', 'sum of 1 to 10', 3, '2026-12-07'),

('Math Pow JS', 'What does this code print?', 'javascript',
'console.log(Math.pow(2, 8))', '256', 'easy', 'Math.pow computes 2 to the 8th power', 3, '2026-12-08'),

('Iter Take While', 'What does this code print?', 'rust',
'fn main() {
    let v: Vec<i32> = vec![1, 2, 3, 4, 5]
        .into_iter()
        .take_while(|&x| x < 4)
        .collect();
    println!("{:?}", v);
}', '[1, 2, 3]', 'medium', 'take_while stops at the first element that fails the predicate', 3, '2026-12-09'),

('String Isspace', 'What does this code print?', 'python',
'print("   ".isspace(), "  a ".isspace())', 'True False', 'easy', 'isspace returns True only if all characters are whitespace', 3, '2026-12-10'),

('Set Iteration', 'What does this code print?', 'javascript',
'const s = new Set([3, 1, 2]);
const arr = [];
for (const v of s) arr.push(v);
console.log(arr.join(","))', '3,1,2', 'medium', 'Set preserves insertion order when iterated', 3, '2026-12-11'),

('Iter Skip While', 'What does this code print?', 'rust',
'fn main() {
    let v: Vec<i32> = vec![1, 2, 3, 4, 5]
        .into_iter()
        .skip_while(|&x| x < 3)
        .collect();
    println!("{:?}", v);
}', '[3, 4, 5]', 'easy', 'skip_while discards elements until the predicate fails', 3, '2026-12-12'),

('Tuple Repeat', 'What does this code print?', 'python',
'print((1, 2) * 3)', '(1, 2, 1, 2, 1, 2)', 'easy', 'Tuple multiplication repeats the elements', 3, '2026-12-13'),

('Number Precision', 'What does this code print?', 'javascript',
'console.log(0.1 + 0.2 === 0.3)', 'false', 'hard', 'Floating point arithmetic is not exact — 0.1 + 0.2 is 0.30000000000000004', 3, '2026-12-14'),

('Iter Collect HashMap', 'What does this code print?', 'rust',
'use std::collections::HashMap;
fn main() {
    let m: HashMap<&str, i32> = vec![("a", 1), ("b", 2)].into_iter().collect();
    println!("{}", m.len());
}', '2', 'easy', 'Collecting tuples into a HashMap creates key-value pairs', 3, '2026-12-15'),

('Str Capitalize', 'What does this code print?', 'python',
'print("hello world".capitalize())', 'Hello world', 'easy', 'capitalize uppercases only the first character', 3, '2026-12-16'),

('Generator Function', 'What does this code print?', 'javascript',
'function* gen() {
    yield 1;
    yield 2;
    yield 3;
}
console.log([...gen()].join(","))', '1,2,3', 'medium', 'Spreading a generator collects all yielded values', 3, '2026-12-17'),

('Match Tuple', 'What does this code print?', 'rust',
'fn main() {
    let point = (0, -2);
    match point {
        (0, 0) => println!("origin"),
        (x, 0) => println!("x-axis at {x}"),
        (0, y) => println!("y-axis at {y}"),
        (x, y) => println!("{x},{y}"),
    }
}', 'y-axis at -2', 'medium', 'Pattern matching on tuples with specific values', 3, '2026-12-18'),

('Zip Longest', 'What does this code print?', 'python',
'from itertools import zip_longest
print(list(zip_longest([1, 2], [3], fillvalue=0)))', '[(1, 3), (2, 0)]', 'medium', 'zip_longest pads shorter iterables with fillvalue', 3, '2026-12-19'),

('Even Sum JS', 'What does this code print?', 'javascript',
'const nums = [1, 2, 3, 4, 5, 6];
console.log(nums.filter(n => n % 2 === 0).reduce((a, b) => a + b))', '12', 'medium', 'Filter even numbers (2,4,6) then sum them', 3, '2026-12-20'),

('Lifetime Basic', 'What does this code print?', 'rust',
'fn longest<''a>(a: &''a str, b: &''a str) -> &''a str {
    if a.len() >= b.len() { a } else { b }
}
fn main() {
    let r = longest("hello", "hi");
    println!("{r}");
}', 'hello', 'medium', 'Lifetimes ensure the returned reference is valid', 3, '2026-12-21'),

('Complex F-String', 'What does this code print?', 'python',
'name = "World"
print(f"Hello, {name!r}")', 'Hello, ''World''', 'medium', '!r applies repr() which adds quotes around strings', 3, '2026-12-22'),

('Bitwise Shift', 'What does this code print?', 'javascript',
'console.log(1 << 3)', '8', 'medium', 'Left shift by 3 is equivalent to multiplying by 2^3', 3, '2026-12-23'),

('Trait Default', 'What does this code print?', 'rust',
'#[derive(Debug, Default)]
struct Config {
    width: u32,
    height: u32,
}
fn main() {
    let c = Config::default();
    println!("{} {}", c.width, c.height);
}', '0 0', 'easy', 'Default trait initializes numeric fields to 0', 3, '2026-12-24'),

('Christmas Print', 'What does this code print?', 'python',
'print("Merry Christmas!")', 'Merry Christmas!', 'easy', 'print() outputs the string directly', 3, '2026-12-25'),

('Optional Param', 'What does this code print?', 'javascript',
'function greet(name = "World") {
    return `Hello, ${name}!`;
}
console.log(greet())', 'Hello, World!', 'easy', 'Default parameters are used when no argument is provided', 3, '2026-12-26'),

('String Concat RS', 'What does this code print?', 'rust',
'fn main() {
    let a = "hello";
    let b = " world";
    let c = [a, b].concat();
    println!("{c}");
}', 'hello world', 'easy', 'concat joins string slices in an array', 3, '2026-12-27'),

('Dict Values Sum', 'What does this code print?', 'python',
'scores = {"math": 90, "sci": 85, "eng": 92}
print(sum(scores.values()))', '267', 'easy', 'values() gets the dict values, sum adds them', 3, '2026-12-28'),

('Intl Number', 'What does this code print?', 'javascript',
'console.log(new Intl.NumberFormat("en-US").format(1234567))', '1,234,567', 'medium', 'Intl.NumberFormat formats numbers with locale-specific separators', 3, '2026-12-29'),

('Vec Remove', 'What does this code print?', 'rust',
'fn main() {
    let mut v = vec![10, 20, 30, 40];
    let removed = v.remove(1);
    println!("{removed} {:?}", v);
}', '20 [10, 30, 40]', 'easy', 'remove returns and removes the element at the index', 3, '2026-12-30'),

('Year End', 'What does this code print?', 'python',
'print("Goodbye, " + str(2026) + "!")', 'Goodbye, 2026!', 'easy', 'String concatenation with str() conversion', 3, '2026-12-31');
