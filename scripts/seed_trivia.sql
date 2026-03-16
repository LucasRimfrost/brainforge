-- seed_trivia.sql
-- Daily trivia challenges for all of 2026

INSERT INTO trivia_challenges (title, description, difficulty, expected_answer, hint, max_attempts, scheduled_date)
VALUES

-- January 2026
('Binary Basics',
 'What is the decimal value of the binary number 10110?',
 'easy', '22', 'Starting from the right: 0*1 + 1*2 + 1*4 + 0*8 + 1*16.', 5, '2026-01-01'),

('Big-O Simplification',
 'Simplify the following time complexity: O(3n^2 + 5n + 100). What is the simplified Big-O notation? Answer like O(n^2).',
 'easy', 'O(n^2)', 'Drop constants and lower-order terms.', 5, '2026-01-02'),

('Hex to Decimal',
 'What is the decimal value of the hexadecimal number 0xFF?',
 'easy', '255', 'F in hex is 15. So FF = 15*16 + 15.', 5, '2026-01-03'),

('Stack Basics',
 'You push the values 10, 20, 30 onto a stack in that order. You then pop twice. What value is on top of the stack now?',
 'easy', '10', 'A stack is last-in, first-out. Popping removes 30 then 20.', 5, '2026-01-04'),

('Fibonacci Sequence',
 'What is the 10th Fibonacci number? Use the convention F(1)=1, F(2)=1, F(3)=2, ...',
 'easy', '55', 'The sequence is 1, 1, 2, 3, 5, 8, 13, 21, 34, 55.', 5, '2026-01-05'),

('Sorting Complexity',
 'What is the average-case time complexity of quicksort? Answer in Big-O notation like O(n^2).',
 'easy', 'O(n log n)', 'It divides the array and conquers, similar to merge sort on average.', 5, '2026-01-06'),

('Two''s Complement',
 'In an 8-bit two''s complement system, what decimal value does 11111111 represent?',
 'medium', '-1', 'In two''s complement, all 1s represents -1.', 5, '2026-01-07'),

('Graph Basics',
 'A tree with 10 nodes has how many edges?',
 'easy', '9', 'A tree with n nodes always has n-1 edges.', 5, '2026-01-08'),

('Modular Arithmetic',
 'What is 17 mod 5?',
 'easy', '2', '17 divided by 5 is 3 with remainder 2.', 5, '2026-01-09'),

('DNS Port',
 'What is the standard port number used by the DNS protocol?',
 'easy', '53', 'It is a well-known port below 1024 used for name resolution.', 5, '2026-01-10'),

('Recursive Calls',
 'Consider a naive recursive Fibonacci function. How many total function calls are made to compute F(5)? Count the initial call as well. F(0)=0, F(1)=1.',
 'medium', '15', 'Draw the recursion tree. F(5) calls F(4) and F(3), F(4) calls F(3) and F(2), etc.', 5, '2026-01-11'),

('Bit Counting',
 'How many 1-bits are in the binary representation of the number 42?',
 'easy', '3', '42 in binary is 101010.', 5, '2026-01-12'),

('HTTP Status',
 'What HTTP status code means "Not Found"?',
 'easy', '404', 'This is one of the most well-known error codes on the web.', 5, '2026-01-13'),

('Array Index',
 'In a zero-indexed array of 100 elements, what is the index of the last element?',
 'easy', '99', 'If the first element is at index 0, the last is at n-1.', 5, '2026-01-14'),

('Boolean Algebra',
 'Using De Morgan''s law, what is the equivalent of NOT(A AND B)? Answer using OR and NOT, like: NOT A OR NOT B.',
 'medium', 'NOT A OR NOT B', 'De Morgan''s law flips the operator and negates each operand.', 5, '2026-01-15'),

('Subnet Hosts',
 'A /28 subnet mask provides how many usable host addresses?',
 'medium', '14', '2^(32-28) = 16 total addresses, minus network and broadcast = 14.', 5, '2026-01-16'),

('Linked List Reversal',
 'You have a singly linked list: 1 -> 2 -> 3 -> 4 -> 5. After reversing it, what is the new head value?',
 'easy', '5', 'Reversing a linked list makes the last node the new head.', 5, '2026-01-17'),

('Process States',
 'In a typical operating system process lifecycle, how many main states does a process have? (Ready, Running, Blocked/Waiting, New, Terminated)',
 'easy', '5', 'Think about the process state diagram: New, Ready, Running, Waiting, Terminated.', 5, '2026-01-18'),

('Matrix Multiply',
 'If matrix A is 3x4 and matrix B is 4x2, what are the dimensions of the resulting matrix A*B? Answer as RxC.',
 'easy', '3x2', 'The result has the rows of A and the columns of B.', 5, '2026-01-19'),

('Euler''s Formula',
 'For a connected planar graph, Euler''s formula states V - E + F = 2. If a graph has 6 vertices and 9 edges, how many faces does it have (including the outer face)?',
 'medium', '5', 'Plug into V - E + F = 2: 6 - 9 + F = 2, so F = 5.', 5, '2026-01-20'),

('Octal Conversion',
 'What is the decimal value of the octal number 77?',
 'easy', '63', '7*8 + 7 = 56 + 7 = 63.', 5, '2026-01-21'),

('Page Fault',
 'In a system with 4 page frames using FIFO replacement, the page reference string is 1, 2, 3, 4, 1, 2, 5, 1, 2, 3. How many page faults occur?',
 'hard', '8', 'Trace through the FIFO queue. After loading 1,2,3,4 (4 faults), pages 1,2 are hits, then 5 replaces 1 (fault), 1 replaces 2 (fault), 2 replaces 3 (fault), 3 replaces 4 (fault).', 5, '2026-01-22'),

('GCD Calculation',
 'What is the greatest common divisor (GCD) of 48 and 18?',
 'easy', '6', 'Use the Euclidean algorithm: 48 = 2*18 + 12, 18 = 1*12 + 6, 12 = 2*6 + 0.', 5, '2026-01-23'),

('TCP vs UDP',
 'Which transport layer protocol is connection-oriented: TCP or UDP?',
 'easy', 'TCP', 'One of them requires a three-way handshake before data transfer.', 5, '2026-01-24'),

('AVL Rotations',
 'You insert the keys 3, 2, 1 into an initially empty AVL tree. After the necessary rotation, what is the value at the root?',
 'medium', '2', 'Inserting 3, 2, 1 causes a right-right imbalance at 3, requiring a right rotation.', 5, '2026-01-25'),

('Base Conversion',
 'What is the binary representation of the decimal number 13? Answer without leading zeros.',
 'easy', '1101', '13 = 8 + 4 + 1 = 2^3 + 2^2 + 2^0.', 5, '2026-01-26'),

('Semaphore Init',
 'A binary semaphore can take how many distinct values?',
 'easy', '2', 'Binary means two possible values: 0 and 1.', 5, '2026-01-27'),

('Knapsack Problem',
 'You have a knapsack with capacity 7. Items: (weight=1, value=1), (weight=3, value=4), (weight=4, value=5), (weight=5, value=7). What is the maximum value you can carry using the 0/1 knapsack approach?',
 'hard', '9', 'Try combining items with weight 3 and weight 4 (total weight 7, total value 9).', 5, '2026-01-28'),

('OSI Layers',
 'How many layers are in the OSI networking model?',
 'easy', '7', 'Physical, Data Link, Network, Transport, Session, Presentation, Application.', 5, '2026-01-29'),

('Minimum Spanning Tree',
 'A graph has 5 vertices. What is the maximum number of edges a minimum spanning tree of this graph can have?',
 'easy', '4', 'A spanning tree of a graph with V vertices always has V-1 edges.', 5, '2026-01-30'),

('Counting Sort Range',
 'Counting sort is efficient when the range of input values (k) is not significantly greater than the number of elements (n). What is its time complexity? Answer like O(n+k).',
 'medium', 'O(n+k)', 'It counts occurrences, then reconstructs. Both steps depend on n and k.', 5, '2026-01-31'),

-- February 2026
('Power Set',
 'A set has 5 elements. How many subsets does it have (including the empty set and the set itself)?',
 'easy', '32', 'The power set of a set with n elements has 2^n subsets.', 5, '2026-02-01'),

('IP Address Classes',
 'In IPv4 classful addressing, what is the range of the first octet for Class A addresses? Answer like 1-126.',
 'medium', '1-126', '0 is reserved, 127 is loopback. Class A starts at 1.', 5, '2026-02-02'),

('Insertion Sort Swaps',
 'Using insertion sort on the array [4, 3, 2, 1], how many element swaps (or shifts) are needed to fully sort it?',
 'medium', '6', 'Pass 1: 1 shift, Pass 2: 2 shifts, Pass 3: 3 shifts. Total = 1+2+3 = 6.', 5, '2026-02-03'),

('Compiler Phases',
 'In the traditional compilation pipeline, which phase comes immediately after lexical analysis? Answer with one or two words.',
 'medium', 'syntax analysis', 'It is also known as parsing.', 5, '2026-02-04'),

('Binary Search Steps',
 'In a sorted array of 1000 elements, what is the maximum number of comparisons needed in binary search? (Use ceiling of log2(1000))',
 'easy', '10', 'log2(1000) is about 9.97, so ceiling is 10.', 5, '2026-02-05'),

('Pigeonhole Principle',
 'If you have 13 pigeons and 12 pigeonholes, at least how many pigeons must share a pigeonhole?',
 'easy', '2', 'With more pigeons than holes, at least one hole has more than one pigeon.', 5, '2026-02-06'),

('Cache Hit Rate',
 'A program makes 1000 memory accesses. 850 of them are cache hits. What is the cache hit rate as a percentage?',
 'easy', '85', '850/1000 * 100 = 85%.', 5, '2026-02-07'),

('Radix Sort',
 'Radix sort processes digits from which direction for the LSD (Least Significant Digit) variant? Answer "right" or "left".',
 'easy', 'right', 'LSD means it starts with the least significant (rightmost) digit.', 5, '2026-02-08'),

('Traveling Bits',
 'How many bits are in a single byte?',
 'easy', '8', 'This is one of the most fundamental units in computing.', 5, '2026-02-09'),

('Topological Sort',
 'Given a DAG with edges: A->B, A->C, B->D, C->D. How many valid topological orderings exist?',
 'medium', '2', 'A must come first, D must come last. The only choice is the order of B and C.', 5, '2026-02-10'),

('SQL Join',
 'Table A has 3 rows and Table B has 4 rows. If you perform a CROSS JOIN between A and B, how many rows will the result have?',
 'easy', '12', 'A CROSS JOIN returns every combination: 3 * 4 = 12.', 5, '2026-02-11'),

('Hamming Distance',
 'What is the Hamming distance between the binary strings 1011101 and 1001001?',
 'medium', '2', 'Compare bit by bit and count the positions that differ.', 5, '2026-02-12'),

('Virtual Memory',
 'If a system uses 32-bit virtual addresses and 4KB pages, how many entries does the page table have? Answer as a power of 2 like 2^20.',
 'medium', '2^20', '32 bits for address, 12 bits for page offset (4KB = 2^12), so 2^(32-12) = 2^20 entries.', 5, '2026-02-13'),

('Fibonacci Closed Form',
 'The golden ratio phi is approximately 1.618. What is the name of the closed-form formula for computing Fibonacci numbers? (Two-word answer)',
 'medium', 'Binet''s formula', 'It is named after the French mathematician Jacques Philippe Marie Binet.', 5, '2026-02-14'),

('Network Topology',
 'In a star network topology, if the central hub fails, how many connections between other nodes remain operational?',
 'easy', '0', 'All communication goes through the central hub.', 5, '2026-02-15'),

('Quick Select',
 'What is the average-case time complexity of the QuickSelect algorithm for finding the k-th smallest element? Answer in Big-O notation.',
 'medium', 'O(n)', 'Unlike QuickSort which processes both partitions, QuickSelect only recurses into one.', 5, '2026-02-16'),

('Decimal to Hex',
 'What is the hexadecimal representation of the decimal number 200?',
 'easy', 'C8', '200 / 16 = 12 remainder 8. 12 in hex is C.', 5, '2026-02-17'),

('Graph Coloring',
 'What is the minimum number of colors needed to color the vertices of a complete graph K4 such that no two adjacent vertices share the same color?',
 'medium', '4', 'In a complete graph, every vertex is adjacent to every other. You need n colors for Kn.', 5, '2026-02-18'),

('Disk Scheduling',
 'In the SSTF (Shortest Seek Time First) disk scheduling algorithm, the head at position 50 must service requests at positions: 82, 170, 43, 140, 24, 16, 190. Which request is serviced first?',
 'medium', '43', 'SSTF picks the request closest to the current head position. |50-43| = 7 is the smallest distance.', 5, '2026-02-19'),

('Bitwise AND',
 'What is the result of 12 AND 10 (bitwise AND in decimal)?',
 'easy', '8', '12 = 1100, 10 = 1010. AND gives 1000 = 8.', 5, '2026-02-20'),

('Heap Property',
 'In a max-heap represented as an array [50, 30, 40, 10, 20, 35, 38], what is the parent of the element at index 5 (0-based)?',
 'medium', '40', 'Parent index = floor((5-1)/2) = 2. The element at index 2 is 40.', 5, '2026-02-21'),

('TCP Handshake',
 'How many packets are exchanged during a TCP three-way handshake?',
 'easy', '3', 'SYN, SYN-ACK, ACK. The name gives it away!', 5, '2026-02-22'),

('P vs NP',
 'The famous unsolved problem "Does P equal NP?" is one of the Millennium Prize Problems. How many dollars is the prize for solving it?',
 'medium', '1000000', 'Each Millennium Prize Problem is worth one million dollars.', 5, '2026-02-23'),

('Merge Sort Space',
 'What is the space complexity of merge sort? Answer in Big-O notation.',
 'easy', 'O(n)', 'Merge sort needs auxiliary space proportional to the input size for merging.', 5, '2026-02-24'),

('Register Size',
 'A 64-bit processor register can store a maximum unsigned integer of 2^64 - 1. How many decimal digits does this number approximately have?',
 'hard', '20', '2^64 is approximately 1.8 * 10^19, which has 20 digits.', 5, '2026-02-25'),

('Bellman-Ford',
 'The Bellman-Ford algorithm can handle graphs with negative edge weights, but it cannot handle what type of cycle?',
 'easy', 'negative cycle', 'If the total weight of a cycle is negative, shortest paths are undefined.', 5, '2026-02-26'),

('SQL Aggregation',
 'Given a table with values [10, 20, 30, NULL, 50], what does SELECT AVG(value) return? Answer as a decimal.',
 'medium', '27.5', 'AVG ignores NULL values. (10+20+30+50)/4 = 110/4 = 27.5.', 5, '2026-02-27'),

('XOR Swap',
 'If a=5 and b=3, after performing: a=a XOR b; b=a XOR b; a=a XOR b; what is the value of a?',
 'medium', '3', 'This is the XOR swap trick. After all three operations, a and b are exchanged.', 5, '2026-02-28'),

-- March 2026
('Hash Table Load',
 'A hash table has 16 buckets and contains 12 elements. What is the load factor? Answer as a decimal.',
 'easy', '0.75', 'Load factor = number of elements / number of buckets = 12/16.', 5, '2026-03-01'),

('DFS vs BFS',
 'Which graph traversal algorithm uses a stack (or recursion) as its primary data structure: DFS or BFS?',
 'easy', 'DFS', 'Depth-First Search goes deep before going wide, which matches stack behavior.', 5, '2026-03-02'),

('Floating Point',
 'In IEEE 754 single-precision (32-bit) floating point, how many bits are used for the exponent field?',
 'medium', '8', 'The format is: 1 sign bit + 8 exponent bits + 23 mantissa bits = 32.', 5, '2026-03-03'),

('Quicksort Worst Case',
 'What is the worst-case time complexity of quicksort? Answer in Big-O notation.',
 'easy', 'O(n^2)', 'This happens when the pivot is always the smallest or largest element.', 5, '2026-03-04'),

('Round Robin',
 'In round-robin CPU scheduling with time quantum 4, processes P1(burst=5), P2(burst=3), P3(burst=8) arrive at time 0. At what time does P2 finish execution?',
 'medium', '7', 'P1 runs 0-4, P2 runs 4-7 (burst 3 < quantum 4, so it finishes at 7).', 5, '2026-03-05'),

('Probability Basics',
 'You flip a fair coin 3 times. What is the probability of getting exactly 2 heads? Answer as a fraction like 3/8.',
 'easy', '3/8', 'There are 8 possible outcomes. HHT, HTH, THH = 3 favorable outcomes.', 5, '2026-03-06'),

('IPv6 Length',
 'How many bits long is an IPv6 address?',
 'easy', '128', 'IPv4 uses 32 bits, and IPv6 quadruples that twice: 32 * 4 = 128.', 5, '2026-03-07'),

('Matrix Determinant',
 'What is the determinant of the 2x2 matrix [[3, 7], [1, 5]]?',
 'easy', '8', 'For a 2x2 matrix [[a,b],[c,d]], determinant = ad - bc = 3*5 - 7*1 = 8.', 5, '2026-03-08'),

('Dining Philosophers',
 'In the Dining Philosophers problem with 5 philosophers, how many forks (chopsticks) are on the table?',
 'easy', '5', 'There is one fork between each pair of adjacent philosophers.', 5, '2026-03-09'),

('Red-Black Tree',
 'In a red-black tree, what color is the root node always?',
 'easy', 'black', 'This is one of the fundamental properties of red-black trees.', 5, '2026-03-10'),

('Complement Hex',
 'What is the one''s complement of 0x0F in an 8-bit system? Answer in hexadecimal with 0x prefix.',
 'medium', '0xF0', 'One''s complement flips all bits. 0x0F = 00001111, complement = 11110000 = 0xF0.', 5, '2026-03-11'),

('B-Tree Order',
 'In a B-tree of order 5, what is the maximum number of keys a single node can hold?',
 'medium', '4', 'A B-tree of order m has at most m-1 keys per node. 5-1 = 4.', 5, '2026-03-12'),

('Prim vs Kruskal',
 'Which minimum spanning tree algorithm processes edges in order of increasing weight: Prim''s or Kruskal''s?',
 'easy', 'Kruskal''s', 'This algorithm sorts all edges first, then adds them if they don''t form a cycle.', 5, '2026-03-13'),

('FizzBuzz Count',
 'Consider all integers from 1 to 100. If a number is divisible by 3, it becomes "Fizz". If divisible by 5, it becomes "Buzz". If divisible by both 3 and 5, it becomes "FizzBuzz". How many times does "FizzBuzz" appear?',
 'easy', '6', 'Think about multiples of 15.', 5, '2026-03-14'),

('Reverse Sum',
 'Take the number 47. Reverse its digits to get 74. Add them together: 47 + 74 = 121. Now do the same for the number 293. What is 293 plus its reverse?',
 'easy', '685', 'The reverse of 293 is 392.', 5, '2026-03-15'),

('Staircase Climb',
 'You have a staircase with 7 steps. You can climb 1 or 2 steps at a time. How many distinct ways can you reach the top?',
 'medium', '21', 'This follows the Fibonacci sequence. Start from step 1 and work your way up.', 5, '2026-03-16'),

('Binary Ones',
 'How many 1s are there in the binary representation of the number 255?',
 'easy', '8', '255 in binary is all ones. How many bits does it take?', 5, '2026-03-17'),

('Missing Number',
 'You have an array containing all integers from 1 to 100, but one number is missing. The sum of the array is 4950. What number is missing?',
 'easy', '50', 'The sum of 1 to 100 is 5050.', 5, '2026-03-18'),

('Matrix Identity',
 'Given a 4x4 identity matrix, what is the sum of ALL its elements?',
 'easy', '4', 'An identity matrix has 1s on the diagonal and 0s everywhere else.', 5, '2026-03-19'),

('Palindrome Chain',
 'Start with the number 87. Add it to its reverse (78) to get 165. Then add 165 to its reverse (561) to get 726. Then add 726 to its reverse (627). What number do you get?',
 'medium', '1353', 'Just follow each step carefully. 726 + 627 = ?', 5, '2026-03-20'),

('Bit Shift',
 'In most programming languages, what is the result of the expression: 1 << 10?',
 'easy', '1024', 'Left shifting by N is the same as multiplying by 2^N.', 5, '2026-03-21'),

('Collatz Steps',
 'The Collatz sequence starts with a number. If even, divide by 2. If odd, multiply by 3 and add 1. Repeat until you reach 1. Starting from 6, how many steps does it take to reach 1? (Do not count the starting number)',
 'medium', '8', 'The sequence is: 6, 3, 10, 5, 16, 8, 4, 2, 1.', 5, '2026-03-22'),

('Array Rotation',
 'You have the array [1, 2, 3, 4, 5]. After rotating it to the right by 2 positions, what is the resulting array? Write your answer as comma-separated values with no spaces.',
 'easy', '4,5,1,2,3', 'The last 2 elements wrap around to the front.', 5, '2026-03-23'),

('Tower of Hanoi',
 'What is the minimum number of moves required to solve the Tower of Hanoi puzzle with 5 disks?',
 'medium', '31', 'The formula is 2^n - 1 where n is the number of disks.', 5, '2026-03-24'),

('XOR Puzzle',
 'What is the result of: 5 XOR 3 XOR 5 XOR 7 XOR 3?',
 'medium', '7', 'XOR of a number with itself is 0. XOR of a number with 0 is itself.', 5, '2026-03-25'),

('Egg Drop',
 'You have 2 eggs and a 100-floor building. You want to find the highest floor from which an egg can be dropped without breaking. What is the minimum number of drops you need in the worst case to guarantee finding the answer?',
 'hard', '14', 'Think about the triangular number approach. With k drops, you can cover k*(k+1)/2 floors.', 5, '2026-03-26'),

('Stack Sequence',
 'You push the numbers 1, 2, 3, 4, 5 onto a stack in order. What is the maximum number of different valid pop sequences possible?',
 'hard', '42', 'This is the 5th Catalan number. The formula is C(2n,n)/(n+1).', 5, '2026-03-27'),

('Subnet Math',
 'A /24 subnet mask provides how many usable host addresses?',
 'easy', '254', '2^8 = 256 total, minus the network address and broadcast address.', 5, '2026-03-28'),

('Linked List Cycle',
 'A linked list has nodes: 1 -> 2 -> 3 -> 4 -> 5 -> 3 (back to node 3). If you use the slow/fast pointer technique starting at node 1, at which node value do the pointers first meet?',
 'hard', '4', 'Slow moves 1 step, fast moves 2 steps. Trace through each step carefully.', 5, '2026-03-29'),

('Regex Match Count',
 'Given the string "aababcabcabc", how many non-overlapping matches does the pattern "abc" have?',
 'easy', '3', 'Scan left to right, each match consumes those characters.', 5, '2026-03-30'),

('Graph Edges',
 'A complete undirected graph has 6 nodes. How many edges does it have?',
 'medium', '15', 'The formula is n*(n-1)/2.', 5, '2026-03-31'),

-- April 2026
('Power of Two',
 'What is the largest power of 2 that is less than 1000?',
 'easy', '512', 'Start doubling: 1, 2, 4, 8, 16, 32, 64, 128, 256, ...', 5, '2026-04-01'),

('Hash Collision',
 'You have a hash table with 365 slots. Using the birthday paradox approximation, roughly how many items do you need to insert before there is a 50% chance of a collision? Round to the nearest whole number.',
 'hard', '23', 'The birthday paradox! With 365 days, you need about 23 people.', 5, '2026-04-02'),

('Sorting Swaps',
 'Using bubble sort on the array [5, 3, 1, 4, 2], how many swaps are needed to fully sort it in ascending order?',
 'medium', '7', 'Walk through each pass of bubble sort and count every swap.', 5, '2026-04-03'),

('Boolean Logic',
 'What is the result of: (true AND false) OR (NOT false AND true)? Answer with "true" or "false".',
 'easy', 'true', 'Evaluate each part in parentheses first.', 5, '2026-04-04'),

('Heap Height',
 'A complete binary heap contains 100 elements. What is the height of the heap? (Root is height 0)',
 'medium', '6', 'The height is floor(log2(n)). What is floor(log2(100))?', 5, '2026-04-05'),

('Two Sum',
 'Given the array [2, 7, 11, 15] and a target of 9, which two indices (0-based) add up to the target? Answer as two comma-separated numbers, smaller index first.',
 'easy', '0,1', 'Which two numbers in the array sum to 9?', 5, '2026-04-06'),

('Deadlock Conditions',
 'How many conditions must ALL be true simultaneously for a deadlock to occur in a system? (Coffman conditions)',
 'medium', '4', 'Mutual exclusion, hold and wait, no preemption, and...', 5, '2026-04-07'),

('Tree Traversal',
 'Given a binary tree where the inorder traversal is [1,2,3,4,5] and the preorder traversal is [3,2,1,5,4], what is the postorder traversal? Answer as comma-separated values.',
 'hard', '1,2,4,5,3', 'The first element of preorder is the root. Use that to split the inorder array.', 5, '2026-04-08'),

('Cache Lines',
 'If a CPU cache line is 64 bytes and an int is 4 bytes, how many ints fit in a single cache line?',
 'easy', '16', 'Simple division: 64 / 4.', 5, '2026-04-09'),

('Dijkstra Steps',
 'In a graph with vertices A, B, C, D and edges A-B(1), A-C(4), B-C(2), B-D(5), C-D(1), what is the shortest path distance from A to D?',
 'medium', '4', 'A -> B -> C -> D might be shorter than going directly.', 5, '2026-04-10'),

('Mutex Count',
 'The Dining Philosophers problem has 5 philosophers around a table. What is the minimum number of forks that must be available to guarantee that at least one philosopher can eat?',
 'hard', '5', 'Each philosopher needs 2 forks. Think about the worst case where everyone holds one fork.', 5, '2026-04-11'),

('Fibonacci Modulo',
 'What is the 20th Fibonacci number modulo 100? (F(1)=1, F(2)=1, F(3)=2, ...)',
 'medium', '65', 'Compute the sequence up to F(20) = 6765. Then take mod 100.', 5, '2026-04-12'),

('Traveling Salesman',
 'With 4 cities, how many unique round-trip routes exist for the Traveling Salesman Problem? (Starting city is fixed)',
 'medium', '6', 'With a fixed start, you permute the remaining (n-1) cities: (n-1)! = 3! = 6.', 5, '2026-04-13'),

('Counting Inversions',
 'In the array [2, 4, 1, 3, 5], how many inversions are there? (An inversion is a pair where the earlier element is larger than the later one.)',
 'medium', '3', 'The inversions are: (2,1), (4,1), (4,3).', 5, '2026-04-14'),

('Context Switch',
 'During a context switch, the operating system saves the state of the current process into a data structure. What is this structure commonly called? (Three-letter abbreviation)',
 'easy', 'PCB', 'Process Control Block stores register values, program counter, etc.', 5, '2026-04-15'),

('Binary Addition',
 'What is 1011 + 1101 in binary? Answer in binary.',
 'easy', '11000', '1011 (11) + 1101 (13) = 11000 (24).', 5, '2026-04-16'),

('Cycle Detection',
 'Floyd''s cycle detection algorithm uses two pointers. What are they commonly called?',
 'easy', 'tortoise and hare', 'One is slow and one is fast, like a famous fable.', 5, '2026-04-17'),

('Amortized Array',
 'A dynamic array doubles in size when full. Starting from size 1, after inserting 9 elements, what is the current capacity of the array?',
 'medium', '16', 'Capacity doubles: 1, 2, 4, 8, 16. The 9th element triggers doubling from 8 to 16.', 5, '2026-04-18'),

('Truth Table Rows',
 'A truth table for a Boolean expression with 4 variables has how many rows?',
 'easy', '16', 'Each variable can be true or false: 2^4 = 16.', 5, '2026-04-19'),

('Huffman Encoding',
 'Given characters with frequencies A:5, B:9, C:12, D:13, E:16, F:45, what is the total number of nodes in the Huffman tree (including leaves)?',
 'hard', '11', 'A Huffman tree with n leaf nodes has 2n-1 total nodes. 6 leaves gives 11 total nodes.', 5, '2026-04-20'),

('IPv4 Bits',
 'How many bits are in an IPv4 address?',
 'easy', '32', 'An IPv4 address has 4 octets, each 8 bits.', 5, '2026-04-21'),

('Segment Tree',
 'A segment tree is built on an array of n elements. How many nodes does it have in the worst case? Answer in terms of n, like 4n.',
 'medium', '4n', 'The tree needs at most 4n space to account for the next power of 2 rounding.', 5, '2026-04-22'),

('Caesar Cipher',
 'Using a Caesar cipher with a shift of 3, what does "HAL" become?',
 'easy', 'KDO', 'Shift each letter forward by 3: H->K, A->D, L->O.', 5, '2026-04-23'),

('Stable Sort',
 'Which of these sorting algorithms is NOT stable: merge sort, quicksort, or insertion sort?',
 'easy', 'quicksort', 'A stable sort preserves the relative order of equal elements.', 5, '2026-04-24'),

('RAM Latency',
 'In the memory hierarchy, which is faster to access: L1 cache or main RAM?',
 'easy', 'L1 cache', 'L1 cache is the closest to the CPU and the fastest.', 5, '2026-04-25'),

('Karnaugh Map',
 'A Karnaugh map for 3 Boolean variables has how many cells?',
 'easy', '8', '2^3 = 8 possible combinations of 3 variables.', 5, '2026-04-26'),

('Shortest Path',
 'In an unweighted graph, which algorithm finds the shortest path from a source to all other vertices?',
 'easy', 'BFS', 'Breadth-First Search explores all neighbors at distance d before distance d+1.', 5, '2026-04-27'),

('Semaphore vs Mutex',
 'A counting semaphore is initialized to 3. After 3 acquire operations and 1 release operation, what is the semaphore''s value?',
 'medium', '1', '3 - 3 + 1 = 1.', 5, '2026-04-28'),

('NP-Complete Example',
 'The Boolean satisfiability problem (SAT) was the first problem proven to be NP-complete. Who proved this? (Last name only)',
 'hard', 'Cook', 'This was proven in 1971 and the theorem bears his name.', 5, '2026-04-29'),

('ASCII Value',
 'What is the ASCII value (decimal) of the uppercase letter ''A''?',
 'easy', '65', 'ASCII codes for uppercase letters start at 65.', 5, '2026-04-30'),

-- May 2026
('Catalan Numbers',
 'The 4th Catalan number C(4) represents many things, including the number of valid arrangements of 4 pairs of parentheses. What is C(4)?',
 'medium', '14', 'C(n) = C(2n,n)/(n+1). C(4) = C(8,4)/5 = 70/5 = 14.', 5, '2026-05-01'),

('Memory Alignment',
 'On a 64-bit system with 8-byte alignment, a struct with a char (1 byte) followed by a double (8 bytes) takes how many bytes total (with padding)?',
 'medium', '16', 'The char is padded to 8 bytes for alignment, then the double takes 8 bytes.', 5, '2026-05-02'),

('Selection Sort',
 'Selection sort on an array of n elements always performs exactly how many comparisons? Answer in terms of n, like n(n-1)/2.',
 'medium', 'n(n-1)/2', 'Regardless of the input, selection sort compares each pair once across all passes.', 5, '2026-05-03'),

('CIDR Notation',
 'The CIDR notation 192.168.1.0/26 provides how many usable host addresses?',
 'medium', '62', '2^(32-26) = 64 total addresses, minus network and broadcast = 62.', 5, '2026-05-04'),

('Recursion Base Case',
 'In the recursive formula for factorial: n! = n * (n-1)!, what is the base case? Answer as a simple equation like 0!=1.',
 'easy', '0!=1', 'The recursion stops when n reaches 0, and 0! is defined as 1.', 5, '2026-05-05'),

('Endianness',
 'The integer 0x12345678 is stored at memory address 0x100 on a little-endian system. What byte is stored at address 0x100?',
 'medium', '0x78', 'Little-endian stores the least significant byte at the lowest address.', 5, '2026-05-06'),

('Graph Isomorphism',
 'Two graphs both have 4 vertices and 4 edges. Graph 1 forms a cycle (1-2-3-4-1). Graph 2 has edges 1-2, 2-3, 3-4, 4-2. Are they isomorphic? Answer yes or no.',
 'hard', 'no', 'Graph 1 has all vertices with degree 2. Graph 2 has vertex 2 with degree 3.', 5, '2026-05-07'),

('Pointer Arithmetic',
 'In C, if an int pointer p points to address 1000 and you do p+3, what address does it point to? (Assume int is 4 bytes)',
 'easy', '1012', 'Pointer arithmetic scales by the size of the type: 1000 + 3*4 = 1012.', 5, '2026-05-08'),

('HTTP Methods',
 'Which HTTP method is idempotent AND safe: GET, POST, PUT, or DELETE?',
 'easy', 'GET', 'A safe method does not modify the server state. GET only retrieves data.', 5, '2026-05-09'),

('Convex Hull',
 'What is the time complexity of the gift wrapping (Jarvis march) algorithm for finding the convex hull of n points with h points on the hull? Answer like O(nh).',
 'hard', 'O(nh)', 'For each of the h hull points, it scans all n points to find the next one.', 5, '2026-05-10'),

('Signed Integer',
 'In a signed 8-bit integer using two''s complement, what is the minimum (most negative) value?',
 'medium', '-128', 'The range is -2^7 to 2^7 - 1, which is -128 to 127.', 5, '2026-05-11'),

('Database Normal Form',
 'In which normal form is a relation if it has no partial dependencies on a candidate key? (Answer like 2NF)',
 'medium', '2NF', 'Second Normal Form eliminates partial dependencies on the primary key.', 5, '2026-05-12'),

('Fibonacci Identity',
 'What is the sum of the first 10 Fibonacci numbers? (F(1)=1, F(2)=1, F(3)=2, ..., F(10)=55)',
 'medium', '143', 'Sum them: 1+1+2+3+5+8+13+21+34+55 = 143.', 5, '2026-05-13'),

('Depth of BST',
 'What is the minimum possible height of a binary search tree containing 15 nodes? (Root is height 0)',
 'easy', '3', 'A perfect binary tree of height 3 has 2^4 - 1 = 15 nodes.', 5, '2026-05-14'),

('Mutex Deadlock',
 'Process A holds lock 1 and wants lock 2. Process B holds lock 2 and wants lock 1. What is this situation called?',
 'easy', 'deadlock', 'Both processes are waiting for a resource held by the other.', 5, '2026-05-15'),

('Parity Bit',
 'You have a 7-bit data word: 1010101. Using even parity, what should the parity bit be?',
 'easy', '0', 'The data has four 1s, which is already even. The parity bit is 0.', 5, '2026-05-16'),

('Breadth First Traversal',
 'In a binary tree with root 1, left child 2, right child 3, where 2 has children 4 and 5, what is the BFS traversal? Answer as comma-separated values.',
 'easy', '1,2,3,4,5', 'BFS visits level by level: root first, then its children, then their children.', 5, '2026-05-17'),

('Number of Subnets',
 'You borrow 3 bits from the host portion of a Class C network for subnetting. How many subnets can you create?',
 'medium', '8', '2^3 = 8 subnets.', 5, '2026-05-18'),

('Postfix Evaluation',
 'Evaluate the postfix expression: 3 4 + 2 * 7 -. What is the result?',
 'medium', '7', '3+4=7, 7*2=14, 14-7=7.', 5, '2026-05-19'),

('Assembly MOV',
 'In x86 assembly, what does the MOV instruction do? Answer in 2-3 words.',
 'easy', 'copies data', 'Despite its name, it copies rather than moves data from source to destination.', 5, '2026-05-20'),

('Hash Function',
 'A hash function maps keys to indices 0 through 9. Using the division method, where does key 47 map to? (47 mod 10)',
 'easy', '7', '47 mod 10 = 7.', 5, '2026-05-21'),

('Minimum Cut',
 'By the max-flow min-cut theorem, the maximum flow in a network equals what? Answer in 2-3 words.',
 'medium', 'minimum cut', 'This fundamental theorem equates two seemingly different quantities in a flow network.', 5, '2026-05-22'),

('Binary Tree Nodes',
 'A full binary tree has 7 internal nodes. How many leaf nodes does it have?',
 'easy', '8', 'In a full binary tree, the number of leaves = internal nodes + 1.', 5, '2026-05-23'),

('UTF-8 Bytes',
 'In UTF-8 encoding, how many bytes are used to encode a standard ASCII character?',
 'easy', '1', 'UTF-8 is backwards compatible with ASCII, using 1 byte for codes 0-127.', 5, '2026-05-24'),

('Kruskal Complexity',
 'What is the time complexity of Kruskal''s MST algorithm for a graph with V vertices and E edges? Answer like O(E log E).',
 'medium', 'O(E log E)', 'The bottleneck is sorting the edges. Union-Find operations are nearly O(1).', 5, '2026-05-25'),

('RAID Level',
 'Which RAID level uses disk mirroring (data is duplicated on two disks)?',
 'easy', 'RAID 1', 'This is the simplest form of redundancy: an exact copy.', 5, '2026-05-26'),

('Logic Gate',
 'What logic gate outputs 1 only when both inputs are different?',
 'easy', 'XOR', 'It outputs 1 for inputs (0,1) and (1,0), but 0 for (0,0) and (1,1).', 5, '2026-05-27'),

('LRU Cache',
 'An LRU cache has capacity 3. Access sequence: A, B, C, A, D. After all accesses, which item was evicted?',
 'medium', 'B', 'After A,B,C the cache is [A,B,C]. Accessing A moves it to recent. D evicts the least recent: B.', 5, '2026-05-28'),

('Complement Binary',
 'What is the two''s complement representation of -5 in 8-bit binary?',
 'medium', '11111011', 'Start with 5 = 00000101, flip bits to get 11111010, add 1 to get 11111011.', 5, '2026-05-29'),

('SQL Constraint',
 'In SQL, which constraint ensures that all values in a column are different?',
 'easy', 'UNIQUE', 'This constraint prevents duplicate values in a column.', 5, '2026-05-30'),

('Towers of Power',
 'What is 2^2^2 (evaluated right-to-left as 2^(2^2))?',
 'easy', '16', '2^2 = 4, then 2^4 = 16.', 5, '2026-05-31'),

-- June 2026
('Turing Complete',
 'A system is Turing complete if it can simulate any Turing machine. Which simple 2D programming language uses only the characters ><^v+-.[]? (No spaces in answer)',
 'hard', 'brainfuck', 'This esoteric language uses only 8 commands and operates on a tape of memory.', 5, '2026-06-01'),

('Network MTU',
 'What is the default Maximum Transmission Unit (MTU) size in bytes for Ethernet?',
 'medium', '1500', 'This is the standard MTU for Ethernet frames.', 5, '2026-06-02'),

('Complexity Class',
 'What complexity class contains problems that can be verified in polynomial time?',
 'easy', 'NP', 'NP stands for Nondeterministic Polynomial time.', 5, '2026-06-03'),

('Infix to Postfix',
 'Convert the infix expression "A + B * C" to postfix notation. (No parentheses in answer)',
 'medium', 'A B C * +', 'Multiplication has higher precedence than addition, so it goes first.', 5, '2026-06-04'),

('Clock Speed',
 'If a CPU runs at 3 GHz, how many clock cycles does it execute per second? Answer in scientific notation like 3e9.',
 'easy', '3e9', 'Giga means billion, so 3 GHz = 3 billion cycles per second.', 5, '2026-06-05'),

('Graph Bipartite',
 'A cycle graph with 5 vertices (C5) — is it bipartite? Answer yes or no.',
 'medium', 'no', 'Odd cycles are not bipartite. A graph is bipartite only if all cycles are even-length.', 5, '2026-06-06'),

('SQL ACID',
 'In database ACID properties, what does the "I" stand for?',
 'easy', 'Isolation', 'The four properties are Atomicity, Consistency, Isolation, Durability.', 5, '2026-06-07'),

('Pipeline Stages',
 'A classic RISC processor pipeline has how many stages? (Fetch, Decode, Execute, Memory, Writeback)',
 'easy', '5', 'The classic 5-stage pipeline: IF, ID, EX, MEM, WB.', 5, '2026-06-08'),

('Combinatorics',
 'How many ways can you choose 3 items from a set of 10? (10 choose 3)',
 'easy', '120', 'C(10,3) = 10! / (3! * 7!) = 120.', 5, '2026-06-09'),

('TCP Window',
 'In TCP, the maximum window size with the standard 16-bit window field (without scaling) is how many bytes?',
 'medium', '65535', '2^16 - 1 = 65535 bytes.', 5, '2026-06-10'),

('Euclid GCD',
 'Using the Euclidean algorithm, what is the GCD of 252 and 105?',
 'medium', '21', '252 = 2*105 + 42, 105 = 2*42 + 21, 42 = 2*21 + 0. GCD is 21.', 5, '2026-06-11'),

('Memory Pages',
 'A system has 4KB page size and 1GB of physical memory. How many physical frames are there? Answer as a power of 2 like 2^18.',
 'medium', '2^18', '1GB = 2^30 bytes, page size = 2^12 bytes. 2^30 / 2^12 = 2^18 frames.', 5, '2026-06-12'),

('Recursion Depth',
 'In Python, what is the default recursion limit? (Approximate, to the nearest hundred)',
 'easy', '1000', 'Python sets a default recursion limit to prevent stack overflows.', 5, '2026-06-13'),

('Chromatic Number',
 'What is the chromatic number of a tree with more than one vertex?',
 'easy', '2', 'Trees are bipartite. You can always 2-color a tree.', 5, '2026-06-14'),

('Process Fork',
 'In Unix, if a process calls fork() once, how many total processes exist after the call?',
 'easy', '2', 'fork() creates one child process, so there''s the parent and the child.', 5, '2026-06-15'),

('Logarithm Base',
 'In computer science, when we write log n without a base (in complexity analysis), what base is typically assumed?',
 'easy', '2', 'Computer scientists usually use base 2 because of binary.', 5, '2026-06-16'),

('Matrix Trace',
 'What is the trace of the matrix [[1, 2, 3], [4, 5, 6], [7, 8, 9]]?',
 'easy', '15', 'The trace is the sum of diagonal elements: 1 + 5 + 9 = 15.', 5, '2026-06-17'),

('Trie Lookup',
 'What is the time complexity of looking up a string of length m in a trie? Answer in Big-O notation.',
 'easy', 'O(m)', 'You follow one edge per character, so it takes O(m) time.', 5, '2026-06-18'),

('Disk Seek',
 'In disk scheduling, the SCAN algorithm is also known by what elevator-related nickname? (One word)',
 'easy', 'elevator', 'It moves in one direction servicing requests, then reverses, like an elevator.', 5, '2026-06-19'),

('Prime Check',
 'Is 91 a prime number? Answer yes or no.',
 'medium', 'no', '91 = 7 * 13. It looks prime but is not.', 5, '2026-06-20'),

('Critical Section',
 'Peterson''s algorithm solves the critical section problem for how many processes?',
 'medium', '2', 'The classic Peterson''s algorithm is designed for two processes.', 5, '2026-06-21'),

('Binary Subtraction',
 'What is 10000 - 00111 in binary?',
 'medium', '1001', '16 - 7 = 9, and 9 in binary is 1001.', 5, '2026-06-22'),

('Spanning Trees',
 'How many spanning trees does a complete graph K4 have?',
 'hard', '16', 'By Cayley''s formula, K_n has n^(n-2) spanning trees. 4^2 = 16.', 5, '2026-06-23'),

('System Call',
 'In Unix/Linux, which system call creates a new process?',
 'easy', 'fork', 'This call duplicates the calling process.', 5, '2026-06-24'),

('Queue Operations',
 'You enqueue 5, 10, 15, 20 into a queue, then dequeue twice. What is now at the front of the queue?',
 'easy', '15', 'A queue is FIFO. Dequeueing removes 5, then 10. Front is now 15.', 5, '2026-06-25'),

('Float Precision',
 'In IEEE 754 double-precision (64-bit), approximately how many significant decimal digits of precision are available?',
 'medium', '15', 'Double precision has a 52-bit mantissa, giving about 15-17 significant digits.', 5, '2026-06-26'),

('ARP Protocol',
 'The ARP protocol maps what type of address to what other type? Answer like: X to Y.',
 'medium', 'IP to MAC', 'Address Resolution Protocol resolves network layer addresses to link layer addresses.', 5, '2026-06-27'),

('Recursion Stack',
 'A recursive function to compute the sum from 1 to n: sum(n) = n + sum(n-1), base case sum(0) = 0. How many stack frames are created for sum(5), including the base case call?',
 'easy', '6', 'sum(5), sum(4), sum(3), sum(2), sum(1), sum(0) = 6 frames.', 5, '2026-06-28'),

('Red-Black Insertion',
 'After inserting the key 10 into an empty red-black tree, what color is the node?',
 'easy', 'black', 'The root of a red-black tree is always black.', 5, '2026-06-29'),

('Parallel Speedup',
 'According to Amdahl''s law, if 75% of a program can be parallelized and you use 4 processors, what is the maximum speedup? Answer as a decimal rounded to two places.',
 'hard', '2.29', 'Speedup = 1 / (0.25 + 0.75/4) = 1 / (0.25 + 0.1875) = 1 / 0.4375 = 2.29.', 5, '2026-06-30'),

-- July 2026
('C Sizeof',
 'In standard C on a 64-bit system, what is the typical size of a pointer in bytes?',
 'easy', '8', 'On a 64-bit system, pointers are 64 bits = 8 bytes.', 5, '2026-07-01'),

('BST Inorder',
 'When you perform an inorder traversal of a binary search tree, in what order do the values come out?',
 'easy', 'sorted', 'The left subtree is visited first, then the root, then the right subtree.', 5, '2026-07-02'),

('Network Mask',
 'What is the subnet mask for a /16 network in dotted decimal notation?',
 'easy', '255.255.0.0', 'The first 16 bits are all 1s: 11111111.11111111.00000000.00000000.', 5, '2026-07-03'),

('Dynamic Programming',
 'The longest common subsequence of "ABCDE" and "ACE" has what length?',
 'easy', '3', 'The LCS is "ACE", which has 3 characters.', 5, '2026-07-04'),

('Bits in Kilobyte',
 'How many bits are in one kibibyte (KiB)?',
 'easy', '8192', '1 KiB = 1024 bytes = 1024 * 8 = 8192 bits.', 5, '2026-07-05'),

('Master Theorem',
 'For the recurrence T(n) = 2T(n/2) + n, which is case of the Master Theorem does it fall under? Answer as a number (1, 2, or 3).',
 'medium', '2', 'a=2, b=2, f(n)=n. n^(log_b(a)) = n^1 = n = f(n). This is Case 2, so T(n) = O(n log n).', 5, '2026-07-06'),

('HTTP Default Port',
 'What is the default port number for HTTPS?',
 'easy', '443', 'HTTP uses port 80, HTTPS uses port 443.', 5, '2026-07-07'),

('Sieve of Eratosthenes',
 'How many prime numbers are there between 1 and 30 (inclusive)?',
 'easy', '10', '2,3,5,7,11,13,17,19,23,29 — that''s 10 primes.', 5, '2026-07-08'),

('Thread vs Process',
 'Threads within the same process share what memory area? Name the largest shared region.',
 'easy', 'heap', 'Threads share the heap, global data, and code. Each thread has its own stack.', 5, '2026-07-09'),

('Recurrence Relation',
 'What does the recurrence T(n) = T(n/2) + 1 with T(1) = 0 solve to in Big-O?',
 'medium', 'O(log n)', 'Each step halves the problem and does constant work — this is binary search.', 5, '2026-07-10'),

('Decimal Precision',
 'What is 0.1 + 0.2 in most floating-point implementations? Answer to 17 decimal places.',
 'medium', '0.30000000000000004', 'Floating-point cannot represent 0.1 or 0.2 exactly in base 2.', 5, '2026-07-11'),

('B+ Tree',
 'In a B+ tree, all actual data records are stored at which level of the tree?',
 'easy', 'leaf', 'B+ trees store all data in leaf nodes; internal nodes only store keys for navigation.', 5, '2026-07-12'),

('CPU Registers',
 'In the x86-64 architecture, how many general-purpose registers are there?',
 'medium', '16', 'x86-64 extended the 8 registers of x86 to 16: RAX through R15.', 5, '2026-07-13'),

('Modular Inverse',
 'What is the modular multiplicative inverse of 3 modulo 7? (Find x where 3x mod 7 = 1)',
 'medium', '5', '3 * 5 = 15, and 15 mod 7 = 1.', 5, '2026-07-14'),

('ACID Durability',
 'In ACID properties, durability ensures that once a transaction is committed, it persists even after what event?',
 'easy', 'system crash', 'Committed data must survive power failures, crashes, and errors.', 5, '2026-07-15'),

('Priority Queue',
 'A min-priority queue contains elements with priorities [5, 3, 8, 1, 4]. What element is dequeued first?',
 'easy', '1', 'A min-priority queue always removes the element with the smallest priority.', 5, '2026-07-16'),

('Hex Addition',
 'What is 0xA + 0xB in hexadecimal?',
 'easy', '0x15', 'A=10, B=11. 10+11=21. 21 in hex is 15 (1*16 + 5).', 5, '2026-07-17'),

('Strassen''s Algorithm',
 'Strassen''s algorithm for matrix multiplication reduces the number of multiplications for 2x2 matrices from 8 to how many?',
 'medium', '7', 'Strassen discovered that 7 multiplications suffice, giving O(n^2.807).', 5, '2026-07-18'),

('Process Scheduling',
 'In Shortest Job First (SJF) scheduling, processes with burst times 6, 8, 2, 4 arrive at time 0. What is the average waiting time?',
 'medium', '5', 'Order: 2(wait=0), 4(wait=2), 6(wait=6), 8(wait=12). Average = (0+2+6+12)/4 = 5.', 5, '2026-07-19'),

('Bitwise OR',
 'What is 0b1010 OR 0b0110 in binary?',
 'easy', '1110', '1010 OR 0110: bit by bit, 1|0=1, 0|1=1, 1|1=1, 0|0=0 gives 1110.', 5, '2026-07-20'),

('Complete Graph Chromatic',
 'What is the chromatic number of a complete graph K5?',
 'easy', '5', 'In a complete graph, every vertex is adjacent to every other, so you need n colors.', 5, '2026-07-21'),

('File Descriptor',
 'In Unix, which file descriptor number is standard output (stdout)?',
 'easy', '1', 'stdin=0, stdout=1, stderr=2.', 5, '2026-07-22'),

('Matrix Rank',
 'What is the rank of the 3x3 identity matrix?',
 'easy', '3', 'The identity matrix has 3 linearly independent rows and columns.', 5, '2026-07-23'),

('Tail Recursion',
 'Tail call optimization prevents which problem that can occur with deep recursion?',
 'easy', 'stack overflow', 'Without TCO, each recursive call adds a frame to the stack.', 5, '2026-07-24'),

('SMTP Port',
 'What is the standard port number for SMTP (email sending)?',
 'easy', '25', 'SMTP traditionally uses port 25 for mail relay.', 5, '2026-07-25'),

('Bit Manipulation',
 'What single bitwise operation clears (sets to 0) the lowest set bit of an integer n? Answer like: n & (n-1).',
 'medium', 'n & (n-1)', 'Subtracting 1 flips the lowest set bit and all bits below it.', 5, '2026-07-26'),

('Graph Diameter',
 'A path graph with 5 vertices (P5: 1-2-3-4-5) has what diameter? (Longest shortest path between any two vertices)',
 'easy', '4', 'The longest shortest path is from vertex 1 to vertex 5, which is 4 edges.', 5, '2026-07-27'),

('Concurrency Primitive',
 'What synchronization primitive allows multiple readers but only one writer at a time? (Hyphenated answer)',
 'medium', 'read-write lock', 'This lock allows shared read access but exclusive write access.', 5, '2026-07-28'),

('IEEE 754 Special',
 'In IEEE 754, what is the result of dividing a positive number by zero?',
 'easy', 'infinity', 'IEEE 754 defines positive/negative infinity as special floating-point values.', 5, '2026-07-29'),

('Interpolation Search',
 'Interpolation search has what average-case time complexity on uniformly distributed data? Answer in Big-O.',
 'hard', 'O(log log n)', 'It estimates the position based on the value, achieving double-logarithmic time on uniform data.', 5, '2026-07-30'),

('Network Layer',
 'At which OSI layer does the IP protocol operate? Answer with the layer number.',
 'easy', '3', 'The Network layer (layer 3) handles logical addressing and routing.', 5, '2026-07-31'),

-- August 2026
('Shell Sort Gap',
 'Shell sort is a generalization of which simpler sorting algorithm?',
 'easy', 'insertion sort', 'Shell sort performs insertion sort on elements at progressively smaller gap intervals.', 5, '2026-08-01'),

('Heap Build',
 'What is the time complexity of building a max-heap from an unsorted array of n elements? Answer in Big-O.',
 'medium', 'O(n)', 'Despite each heapify being O(log n), the bottom-up approach sums to O(n).', 5, '2026-08-02'),

('SQL Keys',
 'A foreign key in a relational database references what in another table?',
 'easy', 'primary key', 'A foreign key establishes a relationship by pointing to the primary key of another table.', 5, '2026-08-03'),

('Pipeline Hazard',
 'What is the name for the pipeline hazard that occurs when an instruction depends on the result of a previous instruction that hasn''t completed yet?',
 'medium', 'data hazard', 'This type of hazard involves dependencies between instructions.', 5, '2026-08-04'),

('Modular Exponentiation',
 'What is 2^10 mod 100?',
 'easy', '24', '2^10 = 1024. 1024 mod 100 = 24.', 5, '2026-08-05'),

('Adjacency Matrix',
 'An undirected graph with 5 vertices and no self-loops uses an adjacency matrix. How many entries does the matrix have?',
 'easy', '25', 'A 5x5 matrix has 5*5 = 25 entries.', 5, '2026-08-06'),

('Scheduling Algorithm',
 'Which CPU scheduling algorithm can cause starvation of low-priority processes?',
 'medium', 'priority scheduling', 'If higher-priority processes keep arriving, low-priority ones may never run.', 5, '2026-08-07'),

('Lambda Calculus',
 'In the lambda calculus, what is the simplest combinator that returns its argument? (Single letter)',
 'medium', 'I', 'The identity combinator I = lambda x. x returns whatever you give it.', 5, '2026-08-08'),

('TLB Purpose',
 'What does TLB stand for in computer architecture? (Full name)',
 'medium', 'Translation Lookaside Buffer', 'It caches recent virtual-to-physical address translations.', 5, '2026-08-09'),

('Binary to Octal',
 'Convert the binary number 110101 to octal.',
 'easy', '65', 'Group from right: 110 101 = 6 5 in octal.', 5, '2026-08-10'),

('Stable Marriage',
 'The Gale-Shapley algorithm solves the stable matching problem. Who proposed it alongside Gale? (Last name only)',
 'hard', 'Shapley', 'Lloyd Shapley co-authored the paper in 1962 and later won the Nobel Prize in Economics.', 5, '2026-08-11'),

('Array vs Linked',
 'What is the time complexity of accessing the k-th element in a singly linked list? Answer in Big-O.',
 'easy', 'O(n)', 'You must traverse from the head to the k-th element, one node at a time.', 5, '2026-08-12'),

('Docker Layer',
 'In Docker, each instruction in a Dockerfile creates a new what?',
 'easy', 'layer', 'Docker images are made up of read-only layers, one per instruction.', 5, '2026-08-13'),

('Floyd-Warshall',
 'What is the time complexity of the Floyd-Warshall all-pairs shortest path algorithm for a graph with V vertices? Answer in Big-O.',
 'medium', 'O(V^3)', 'It uses three nested loops over all vertices.', 5, '2026-08-14'),

('Binary Palindrome',
 'Is the number 9 a binary palindrome? (9 in binary is 1001) Answer yes or no.',
 'easy', 'yes', '1001 reversed is 1001, which is the same.', 5, '2026-08-15'),

('Page Replacement',
 'Which page replacement algorithm is optimal but impossible to implement in practice because it requires future knowledge?',
 'medium', 'OPT', 'The optimal algorithm replaces the page that won''t be used for the longest time.', 5, '2026-08-16'),

('String Matching',
 'The KMP (Knuth-Morris-Pratt) string matching algorithm has what time complexity for searching a pattern of length m in a text of length n? Answer like O(n+m).',
 'medium', 'O(n+m)', 'KMP preprocesses the pattern in O(m) and scans the text in O(n).', 5, '2026-08-17'),

('Ethernet Frame',
 'What is the minimum size of an Ethernet frame in bytes (including header but excluding preamble)?',
 'medium', '64', 'The minimum Ethernet frame size is 64 bytes to ensure collision detection.', 5, '2026-08-18'),

('Ternary Search',
 'Ternary search divides the search space into how many parts at each step?',
 'easy', '3', 'As the name suggests, it divides into three equal parts.', 5, '2026-08-19'),

('Database Indexing',
 'A B-tree index on a database table with 1 million rows, using a B-tree of order 100, has approximately how many levels?',
 'hard', '3', 'Each level can hold 100^level entries. 100^3 = 1,000,000 so about 3 levels.', 5, '2026-08-20'),

('Counting Bits',
 'How many 1-bits appear in total across all numbers from 0 to 7 (inclusive) in binary?',
 'medium', '12', '0(0), 1(1), 1(1), 2(2), 1(1), 2(2), 2(2), 3(3). Sum = 0+1+1+2+1+2+2+3 = 12.', 5, '2026-08-21'),

('Banker''s Algorithm',
 'The Banker''s Algorithm is used for what purpose in operating systems? Answer in 2-3 words.',
 'medium', 'deadlock avoidance', 'It checks whether granting a resource request would lead to an unsafe state.', 5, '2026-08-22'),

('Hex Subtraction',
 'What is 0xFF - 0x0A in hexadecimal?',
 'easy', '0xF5', '255 - 10 = 245. 245 = 15*16 + 5 = 0xF5.', 5, '2026-08-23'),

('Trie Space',
 'A trie stores English words. If only lowercase letters are used, how many children can each node have at most?',
 'easy', '26', 'There are 26 lowercase English letters, so each node can have up to 26 children.', 5, '2026-08-24'),

('Mutex Types',
 'A recursive mutex (re-entrant mutex) allows the same thread to lock it multiple times without deadlocking. How many times must it be unlocked to fully release it if locked 3 times?',
 'medium', '3', 'Each lock call must be matched by an unlock call.', 5, '2026-08-25'),

('CRC Polynomial',
 'CRC-32 uses a polynomial of degree what?',
 'medium', '32', 'CRC-n uses a polynomial of degree n.', 5, '2026-08-26'),

('Bucket Sort',
 'Bucket sort has what average-case time complexity when input is uniformly distributed? Answer in Big-O.',
 'medium', 'O(n)', 'With uniform distribution, each bucket has roughly the same number of elements.', 5, '2026-08-27'),

('Memory Segments',
 'In a typical process memory layout, which segment grows downward toward the heap?',
 'easy', 'stack', 'The stack grows downward in address space while the heap grows upward.', 5, '2026-08-28'),

('Graph Cut',
 'In a graph with 6 vertices divided into two sets of 3, what is the maximum number of edges in the cut between the two sets?',
 'medium', '9', 'Each vertex in one set can connect to all 3 vertices in the other: 3*3 = 9.', 5, '2026-08-29'),

('Race Condition',
 'Two threads increment a shared counter 1000 times each without synchronization. The counter starts at 0. What is the minimum possible final value?',
 'hard', '2', 'In the worst case, almost all increments can be lost due to read-modify-write races. The minimum is 2.', 5, '2026-08-30'),

('SQL Index',
 'What data structure do most relational databases use for their default index type?',
 'easy', 'B-tree', 'B-trees (or B+ trees) are the standard index structure in most RDBMS.', 5, '2026-08-31'),

-- September 2026
('IEEE Exponent Bias',
 'In IEEE 754 single-precision floating point, what is the exponent bias?',
 'medium', '127', 'The bias is 2^(k-1) - 1 where k=8 exponent bits. 2^7 - 1 = 127.', 5, '2026-09-01'),

('Counting Paths',
 'In a 4x4 grid, starting from the top-left corner, how many unique paths are there to the bottom-right corner if you can only move right or down?',
 'medium', '20', 'This is C(6,3) = 20. You need 3 rights and 3 downs in some order.', 5, '2026-09-02'),

('Python List',
 'In Python, what is the time complexity of appending an element to the end of a list? Answer in amortized Big-O.',
 'easy', 'O(1)', 'Python lists use dynamic arrays, so appending is amortized constant time.', 5, '2026-09-03'),

('Hamiltonian Path',
 'A Hamiltonian path visits every vertex exactly once. Does a complete graph K5 have a Hamiltonian path? Answer yes or no.',
 'easy', 'yes', 'A complete graph has edges between all pairs, so you can always find such a path.', 5, '2026-09-04'),

('DHCP Port',
 'DHCP servers listen on which UDP port number?',
 'medium', '67', 'DHCP server uses port 67, client uses port 68.', 5, '2026-09-05'),

('Overflow Detection',
 'In an 8-bit unsigned integer, what happens when you add 200 + 100? What is the stored result?',
 'medium', '44', '200 + 100 = 300, but 300 mod 256 = 44 due to overflow.', 5, '2026-09-06'),

('Binary Heap Array',
 'In a 1-indexed array representation of a binary heap, the left child of node at index i is at what index?',
 'easy', '2i', 'Left child = 2*i, Right child = 2*i + 1.', 5, '2026-09-07'),

('RSA Basics',
 'In RSA encryption, if p=3 and q=11, what is n (the modulus)?',
 'easy', '33', 'n = p * q = 3 * 11 = 33.', 5, '2026-09-08'),

('Merge Sort Passes',
 'How many passes does merge sort need to sort an array of 16 elements?',
 'medium', '4', 'Merge sort needs log2(n) passes. log2(16) = 4.', 5, '2026-09-09'),

('Inheritance Diamond',
 'The "diamond problem" in object-oriented programming occurs with what type of inheritance?',
 'easy', 'multiple', 'When a class inherits from two classes that share a common ancestor.', 5, '2026-09-10'),

('Hex Multiplication',
 'What is 0x10 * 0x10 in hexadecimal?',
 'easy', '0x100', '0x10 = 16. 16 * 16 = 256 = 0x100.', 5, '2026-09-11'),

('Josephus Problem',
 'In the Josephus problem with n=5 people in a circle, eliminating every 2nd person, who survives? (People numbered 1-5, starting count from person 1)',
 'hard', '3', 'Elimination order: 2, 4, 1, 5. Person 3 survives.', 5, '2026-09-12'),

('Cache Associativity',
 'In a 4-way set-associative cache, each set contains how many cache lines?',
 'easy', '4', 'N-way set-associative means N lines per set.', 5, '2026-09-13'),

('Type Coercion',
 'In JavaScript, what does "5" + 3 evaluate to?',
 'easy', '53', 'JavaScript coerces 3 to a string and concatenates: "5" + "3" = "53".', 5, '2026-09-14'),

('Scheduling Quantum',
 'In round-robin scheduling, what is the name for the maximum time a process can run before being preempted?',
 'easy', 'time quantum', 'Also called a time slice, it determines how long each process runs.', 5, '2026-09-15'),

('Power Modulo',
 'What is 7^3 mod 10?',
 'easy', '3', '7^3 = 343. 343 mod 10 = 3.', 5, '2026-09-16'),

('Skip List',
 'A skip list has what expected time complexity for search? Answer in Big-O.',
 'medium', 'O(log n)', 'The multiple levels of links allow skipping over many elements.', 5, '2026-09-17'),

('TCP Congestion',
 'In TCP congestion control, what phase doubles the congestion window every round-trip time?',
 'medium', 'slow start', 'Despite its name, slow start increases the window exponentially.', 5, '2026-09-18'),

('Math Expression',
 'What is the value of the expression: 2^0 + 2^1 + 2^2 + 2^3 + 2^4?',
 'easy', '31', '1 + 2 + 4 + 8 + 16 = 31.', 5, '2026-09-19'),

('Disjoint Set',
 'What is the amortized time complexity of Union-Find with both union by rank and path compression? Answer in Big-O using alpha notation.',
 'hard', 'O(alpha(n))', 'alpha(n) is the inverse Ackermann function, which grows incredibly slowly.', 5, '2026-09-20'),

('SQL Having',
 'In SQL, the HAVING clause is used to filter results after which operation?',
 'easy', 'GROUP BY', 'WHERE filters before grouping, HAVING filters after grouping.', 5, '2026-09-21'),

('Memory Leak',
 'In C, calling malloc() without a corresponding call to what function causes a memory leak?',
 'easy', 'free', 'Every malloc must be paired with free to release the allocated memory.', 5, '2026-09-22'),

('Cycle Length',
 'A directed graph has vertices A, B, C, D with edges A->B, B->C, C->D, D->B. What is the length of the cycle?',
 'easy', '3', 'The cycle is B->C->D->B, which has 3 edges.', 5, '2026-09-23'),

('Radix Complexity',
 'What is the time complexity of radix sort for n numbers with d digits and base b? Answer like O(d(n+b)).',
 'medium', 'O(d(n+b))', 'Radix sort performs d passes of counting sort, each taking O(n+b).', 5, '2026-09-24'),

('Interrupt Types',
 'What type of interrupt is triggered by a divide-by-zero error: hardware interrupt or software interrupt?',
 'medium', 'software interrupt', 'This is a processor exception (trap), which is a type of software interrupt.', 5, '2026-09-25'),

('Fibonacci Property',
 'What is the ratio of consecutive Fibonacci numbers as they approach infinity? Answer to 3 decimal places.',
 'medium', '1.618', 'This is the golden ratio, phi = (1 + sqrt(5)) / 2.', 5, '2026-09-26'),

('Permutations',
 'How many ways can you arrange the letters in the word "BOOK"? (Note the repeated O)',
 'medium', '12', '4! / 2! = 24 / 2 = 12, because O appears twice.', 5, '2026-09-27'),

('HTTP Idempotent',
 'Is the HTTP DELETE method idempotent? Answer yes or no.',
 'medium', 'yes', 'Deleting the same resource multiple times has the same effect as deleting it once.', 5, '2026-09-28'),

('Queue with Stacks',
 'What is the minimum number of stacks needed to implement a queue?',
 'easy', '2', 'One stack for enqueue, one for dequeue. Elements are transferred as needed.', 5, '2026-09-29'),

('Halting Problem',
 'Alan Turing proved that the halting problem is what? (One word)',
 'easy', 'undecidable', 'No algorithm can determine for all programs whether they halt or loop forever.', 5, '2026-09-30'),

-- October 2026
('CPU Pipeline Stall',
 'A pipeline stall caused by a branch instruction waiting for its condition to be evaluated is called a what? (Two words)',
 'medium', 'control hazard', 'Also known as a branch hazard, it occurs because the CPU doesn''t know which instruction to fetch next.', 5, '2026-10-01'),

('Graph Complement',
 'The complement of a complete graph K5 has how many edges?',
 'easy', '0', 'K5 already has all possible edges. Its complement has none.', 5, '2026-10-02'),

('Abstract Data Type',
 'A FIFO (First-In, First-Out) abstract data type is commonly known as what?',
 'easy', 'queue', 'Elements are removed in the same order they were added.', 5, '2026-10-03'),

('Ackermann Function',
 'What is the value of the Ackermann function A(1, 1)?',
 'medium', '3', 'A(1,1) = A(0, A(1,0)) = A(0, A(0,1)) = A(0, 2) = 3.', 5, '2026-10-04'),

('Unix Permission',
 'In Unix, the file permission 755 in octal means what in symbolic notation for the owner?',
 'easy', 'rwx', '7 = 4+2+1 = read+write+execute.', 5, '2026-10-05'),

('TCP Flags',
 'How many control flag bits are in a standard TCP header?',
 'medium', '6', 'URG, ACK, PSH, RST, SYN, FIN are the 6 original TCP flags.', 5, '2026-10-06'),

('Convex Hull Points',
 'Given points (0,0), (1,0), (0,1), (1,1), (0.5,0.5), how many points are on the convex hull?',
 'easy', '4', 'The four corner points form the hull. (0.5, 0.5) is inside.', 5, '2026-10-07'),

('NFA to DFA',
 'An NFA with n states can require a DFA with at most how many states? Answer in terms of n like 2^n.',
 'medium', '2^n', 'In the worst case, the subset construction can produce 2^n states.', 5, '2026-10-08'),

('Memory Allocation',
 'Which memory allocation strategy searches for the smallest free block that fits: first fit, best fit, or worst fit?',
 'easy', 'best fit', 'Best fit minimizes wasted space by finding the tightest fit.', 5, '2026-10-09'),

('Karatsuba',
 'Karatsuba''s algorithm multiplies two n-digit numbers in what time complexity? Answer like O(n^1.585).',
 'hard', 'O(n^1.585)', 'It reduces 4 sub-multiplications to 3, giving O(n^(log2(3))) = O(n^1.585).', 5, '2026-10-10'),

('Endian Check',
 'The number 0x01020304 stored in big-endian format has which byte at the lowest memory address?',
 'medium', '0x01', 'Big-endian stores the most significant byte first.', 5, '2026-10-11'),

('Automata Language',
 'What type of automaton recognizes regular languages?',
 'easy', 'finite automaton', 'The Chomsky hierarchy maps regular languages to finite automata.', 5, '2026-10-12'),

('Binary Fraction',
 'What is the decimal value of the binary fraction 0.11? (That is, 0 + 1/2 + 1/4)',
 'easy', '0.75', '1 * (1/2) + 1 * (1/4) = 0.5 + 0.25 = 0.75.', 5, '2026-10-13'),

('Garbage Collection',
 'The mark-and-sweep garbage collection algorithm has how many main phases?',
 'easy', '2', 'Phase 1: Mark all reachable objects. Phase 2: Sweep unreachable objects.', 5, '2026-10-14'),

('Network Broadcast',
 'In the 192.168.1.0/24 network, what is the broadcast address?',
 'easy', '192.168.1.255', 'The broadcast address has all host bits set to 1.', 5, '2026-10-15'),

('Recurrence Solution',
 'The recurrence T(n) = 2T(n/2) + O(1) solves to what? Answer in Big-O.',
 'medium', 'O(n)', 'By the Master Theorem case 1: n^(log2(2)) = n^1 dominates the O(1) term.', 5, '2026-10-16'),

('Instruction Set',
 'RISC stands for what? (Full phrase)',
 'easy', 'Reduced Instruction Set Computer', 'RISC uses a small set of simple, fast instructions.', 5, '2026-10-17'),

('Map Coloring',
 'The four color theorem states that any planar map can be colored with at most how many colors?',
 'easy', '4', 'This was proven in 1976 with computer assistance.', 5, '2026-10-18'),

('Database Join',
 'A natural join between two tables combines rows based on what?',
 'easy', 'common columns', 'It matches rows where all columns with the same name have equal values.', 5, '2026-10-19'),

('SHA-256 Output',
 'How many bits are in the output of the SHA-256 hash function?',
 'easy', '256', 'The 256 in SHA-256 refers to the output size in bits.', 5, '2026-10-20'),

('Thrashing',
 'In virtual memory, when the system spends more time paging than executing, this is called what?',
 'easy', 'thrashing', 'The system is constantly swapping pages in and out of memory.', 5, '2026-10-21'),

('Stable Matching',
 'In the Gale-Shapley algorithm for stable matching between n men and n women, who always proposes in the traditional formulation?',
 'medium', 'men', 'In the man-proposing variant, men propose and women accept or reject.', 5, '2026-10-22'),

('Complement Graph',
 'If a graph G has 5 vertices and 3 edges, how many edges does its complement have?',
 'medium', '7', 'Total possible edges = C(5,2) = 10. Complement has 10 - 3 = 7 edges.', 5, '2026-10-23'),

('Web Protocol',
 'HTTP/2 uses what type of connection multiplexing: sequential or stream-based?',
 'medium', 'stream-based', 'HTTP/2 multiplexes multiple streams over a single TCP connection.', 5, '2026-10-24'),

('Register File',
 'The MIPS architecture has how many general-purpose registers?',
 'medium', '32', 'MIPS has 32 registers, numbered $0 through $31.', 5, '2026-10-25'),

('Set Operations',
 'If set A = {1,2,3,4} and set B = {3,4,5,6}, what is |A union B|?',
 'easy', '6', 'A union B = {1,2,3,4,5,6} which has 6 elements.', 5, '2026-10-26'),

('Deadlock Prevention',
 'Requiring processes to request all resources at once prevents which Coffman condition?',
 'medium', 'hold and wait', 'If a process must request everything upfront, it never holds some while waiting for others.', 5, '2026-10-27'),

('Bit Reversal',
 'Reverse the bits of the 8-bit number 10110001. What is the result in binary?',
 'easy', '10001101', 'Read the bits from right to left: 10001101.', 5, '2026-10-28'),

('DNS Record',
 'Which DNS record type maps a domain name to an IPv4 address?',
 'easy', 'A', 'The "A" record (Address record) points a domain to an IPv4 address.', 5, '2026-10-29'),

('Coin Change',
 'Using dynamic programming, how many ways can you make change for 5 cents using coins of 1, 2, and 5 cents?',
 'medium', '4', 'The ways are: 5, 2+2+1, 2+1+1+1, 1+1+1+1+1. That is 4 ways.', 5, '2026-10-30'),

('Time Complexity Class',
 'A problem solvable in O(n^k) for some constant k belongs to which complexity class?',
 'easy', 'P', 'P is the class of problems solvable in polynomial time.', 5, '2026-10-31'),

-- November 2026
('Bit Field',
 'How many distinct values can be represented with 5 bits?',
 'easy', '32', '2^5 = 32.', 5, '2026-11-01'),

('Matrix Multiplication',
 'Multiplying two n x n matrices using the standard algorithm requires how many scalar multiplications? Answer in terms of n like n^3.',
 'easy', 'n^3', 'Three nested loops, each running n times, with a multiplication in the innermost.', 5, '2026-11-02'),

('Shortest Job First',
 'SJF (Shortest Job First) scheduling is provably optimal for minimizing what metric?',
 'medium', 'average waiting time', 'By running shorter jobs first, the total waiting time across all jobs is minimized.', 5, '2026-11-03'),

('Chinese Remainder',
 'What is the smallest positive integer x such that x mod 3 = 2 and x mod 5 = 3?',
 'medium', '8', '8 mod 3 = 2, 8 mod 5 = 3. Check: 8 is the smallest such number.', 5, '2026-11-04'),

('Git Internals',
 'In Git, a commit object contains a reference to what type of object that represents the state of the project? (One word)',
 'easy', 'tree', 'A commit points to a tree object, which represents a directory snapshot.', 5, '2026-11-05'),

('Concurrency Model',
 'The actor model of concurrency was popularized by which programming language? (Hint: it runs on the JVM and starts with "E")',
 'medium', 'Erlang', 'Erlang (originally on BEAM, not JVM) popularized actors. Akka brought actors to the JVM.', 5, '2026-11-06'),

('Sorting Lower Bound',
 'What is the lower bound for comparison-based sorting algorithms? Answer in Big-Omega notation like Omega(n log n).',
 'medium', 'Omega(n log n)', 'Any comparison-based sort must make at least log2(n!) = Omega(n log n) comparisons.', 5, '2026-11-07'),

('L2 Cache',
 'In the typical memory hierarchy, which is faster: L2 cache or L3 cache?',
 'easy', 'L2 cache', 'L1 is fastest, then L2, then L3, then main memory.', 5, '2026-11-08'),

('Hamming Code',
 'In a Hamming(7,4) code, how many data bits are there?',
 'easy', '4', 'Hamming(7,4) means 7 total bits with 4 data bits and 3 parity bits.', 5, '2026-11-09'),

('Vertex Cover',
 'In a path graph with 4 vertices (1-2-3-4), what is the minimum vertex cover size?',
 'medium', '2', 'Picking vertices 2 and 3 covers all three edges.', 5, '2026-11-10'),

('SQL Transaction',
 'What SQL command undoes all changes made during the current transaction?',
 'easy', 'ROLLBACK', 'COMMIT saves changes, ROLLBACK undoes them.', 5, '2026-11-11'),

('Floating Point NaN',
 'In IEEE 754, what happens when you compare NaN == NaN? Answer true or false.',
 'medium', 'false', 'NaN is not equal to anything, including itself.', 5, '2026-11-12'),

('Graph Theory',
 'A graph where every vertex has the same degree is called what? (One word ending in "-regular")',
 'medium', 'regular', 'A k-regular graph has every vertex with degree k.', 5, '2026-11-13'),

('Compiler Optimization',
 'Loop unrolling is an optimization technique that reduces the overhead of what?',
 'medium', 'loop control', 'By duplicating the loop body, it reduces the number of branch instructions and counter updates.', 5, '2026-11-14'),

('Number Theory',
 'What is Euler''s totient function phi(12)? (Count integers from 1 to 12 that are coprime with 12)',
 'medium', '4', 'Numbers coprime with 12: 1, 5, 7, 11. That''s 4.', 5, '2026-11-15'),

('CISC Architecture',
 'CISC stands for what? (Full phrase)',
 'easy', 'Complex Instruction Set Computer', 'CISC uses a large set of feature-rich instructions, like x86.', 5, '2026-11-16'),

('Networking Protocol',
 'Which protocol operates at the application layer and is used for secure shell access?',
 'easy', 'SSH', 'SSH (Secure Shell) provides encrypted remote access.', 5, '2026-11-17'),

('Greedy Algorithm',
 'The activity selection problem can be solved greedily by always choosing the activity that finishes what? (One word)',
 'easy', 'earliest', 'Always picking the activity with the earliest finish time is optimal.', 5, '2026-11-18'),

('Thread Safety',
 'An operation that completes entirely without being interrupted is called what? (One word)',
 'easy', 'atomic', 'Atomic operations cannot be divided or interrupted.', 5, '2026-11-19'),

('Matrix Inverse',
 'A 2x2 matrix [[a,b],[c,d]] has an inverse only if ad-bc is not equal to what value?',
 'easy', '0', 'The determinant ad-bc must be non-zero for the inverse to exist.', 5, '2026-11-20'),

('WAL Protocol',
 'In databases, WAL stands for what? (Full phrase)',
 'medium', 'Write-Ahead Logging', 'Changes are logged before being applied to ensure durability and recovery.', 5, '2026-11-21'),

('Traveling Bits Count',
 'The number 1023 in binary is 1111111111. How many bits is that?',
 'easy', '10', '1023 = 2^10 - 1, which is ten 1-bits.', 5, '2026-11-22'),

('Algorithm Design',
 'The divide-and-conquer approach breaks a problem into subproblems, solves them, and then does what with the results? (One word)',
 'easy', 'combines', 'The three steps are: divide, conquer (solve), and combine.', 5, '2026-11-23'),

('Network Topology Star',
 'In a star topology with n devices (not counting the hub), how many cables are needed?',
 'easy', 'n', 'Each device has exactly one cable to the central hub.', 5, '2026-11-24'),

('Lambda Expression',
 'In Python, what keyword is used to create an anonymous function?',
 'easy', 'lambda', 'Python uses the lambda keyword for small anonymous functions.', 5, '2026-11-25'),

('Cryptographic Hash',
 'The SHA family of hash functions was designed by which US government agency? (Abbreviation)',
 'medium', 'NSA', 'The National Security Agency designed SHA-1 and SHA-2.', 5, '2026-11-26'),

('Determinant Property',
 'If you swap two rows of a matrix, what happens to its determinant?',
 'medium', 'changes sign', 'Each row swap negates the determinant.', 5, '2026-11-27'),

('Process Communication',
 'What IPC mechanism allows two processes to communicate through a shared region of memory? (Two words)',
 'easy', 'shared memory', 'Both processes map the same physical memory into their address spaces.', 5, '2026-11-28'),

('Balanced BST',
 'The maximum height of an AVL tree with 7 nodes is what? (Root is height 0)',
 'medium', '3', 'An AVL tree with 7 nodes can have height at most 3 (e.g., a minimum AVL tree of height 3 has 7 nodes).', 5, '2026-11-29'),

('Complex Number',
 'What is i^4 where i is the imaginary unit?',
 'easy', '1', 'i^1=i, i^2=-1, i^3=-i, i^4=1.', 5, '2026-11-30'),

-- December 2026
('Binary Tree Height',
 'A binary tree has 31 nodes and is perfectly balanced (complete). What is its height? (Root is height 0)',
 'easy', '4', '2^5 - 1 = 31 nodes. A perfect tree of height h has 2^(h+1)-1 nodes. h=4.', 5, '2026-12-01'),

('Encryption Type',
 'AES (Advanced Encryption Standard) is what type of encryption: symmetric or asymmetric?',
 'easy', 'symmetric', 'AES uses the same key for encryption and decryption.', 5, '2026-12-02'),

('Morris Traversal',
 'Morris traversal of a binary tree uses what extra space complexity? Answer in Big-O.',
 'hard', 'O(1)', 'Morris traversal uses threaded pointers to traverse without a stack or recursion.', 5, '2026-12-03'),

('Network Latency',
 'If the speed of light in fiber optic cable is approximately 200,000 km/s and the distance is 1000 km, what is the one-way propagation delay in milliseconds?',
 'easy', '5', '1000 / 200000 = 0.005 seconds = 5 ms.', 5, '2026-12-04'),

('SQL Normalization',
 'A table is in 3NF if it is in 2NF and has no what type of dependency?',
 'medium', 'transitive dependency', 'Third Normal Form eliminates transitive dependencies on the primary key.', 5, '2026-12-05'),

('Palindrome Check',
 'A palindrome checking algorithm that uses two pointers (one from each end) has what time complexity? Answer in Big-O.',
 'easy', 'O(n)', 'Each pointer traverses at most half the string, so it is O(n).', 5, '2026-12-06'),

('Von Neumann',
 'In the Von Neumann architecture, instructions and data share what? (Two words)',
 'easy', 'same memory', 'Unlike Harvard architecture, Von Neumann uses a single memory for both.', 5, '2026-12-07'),

('Edit Distance',
 'What is the edit distance (Levenshtein distance) between "kitten" and "sitting"?',
 'medium', '3', 'kitten -> sitten (substitute s for k), sitten -> sittin (substitute i for e), sittin -> sitting (insert g).', 5, '2026-12-08'),

('Inversion Count',
 'The maximum number of inversions in an array of n elements is n*(n-1)/2. For n=6, what is this value?',
 'easy', '15', '6*5/2 = 15. This occurs when the array is sorted in reverse.', 5, '2026-12-09'),

('Paging Math',
 'A virtual address is 20 bits and the page size is 1 KB. How many bits are used for the page number?',
 'medium', '10', '1 KB = 2^10, so offset is 10 bits. Page number = 20 - 10 = 10 bits.', 5, '2026-12-10'),

('Huffman Prefix',
 'Huffman coding produces codes that are what type of code? (Two-word answer: ___ code)',
 'easy', 'prefix code', 'No codeword is a prefix of another, allowing unambiguous decoding.', 5, '2026-12-11'),

('Amortized Analysis',
 'In a dynamic array that doubles when full, the amortized cost of insertion is O(1). What technique is commonly used to prove this?',
 'hard', 'aggregate method', 'The aggregate method sums the total cost of n operations and divides by n.', 5, '2026-12-12'),

('Router Function',
 'A router operates at which OSI layer?',
 'easy', '3', 'Routers work at the Network layer (Layer 3) using IP addresses.', 5, '2026-12-13'),

('Prime Factorization',
 'What is the prime factorization of 84? Answer like 2^2*3*7.',
 'easy', '2^2*3*7', '84 = 4 * 21 = 2^2 * 3 * 7.', 5, '2026-12-14'),

('Compiler Backend',
 'The phase of compilation that generates machine code from an intermediate representation is called what? (Two words)',
 'medium', 'code generation', 'The backend of a compiler translates IR to target machine code.', 5, '2026-12-15'),

('Probability Union',
 'If P(A) = 0.3, P(B) = 0.4, and A and B are independent, what is P(A and B)?',
 'easy', '0.12', 'For independent events: P(A and B) = P(A) * P(B) = 0.3 * 0.4 = 0.12.', 5, '2026-12-16'),

('Concurrency Bug',
 'A situation where the program behavior depends on the relative timing of events is called a what? (Two words)',
 'easy', 'race condition', 'When two threads access shared data without proper synchronization.', 5, '2026-12-17'),

('KMP Failure Function',
 'For the pattern "ABAB", what is the failure function (partial match table) value at index 3 (0-based)?',
 'hard', '2', 'The proper prefix "AB" is also a suffix of "ABAB", so the value at index 3 is 2.', 5, '2026-12-18'),

('Stack Machines',
 'The Java Virtual Machine (JVM) is based on what type of machine architecture: register-based or stack-based?',
 'easy', 'stack-based', 'The JVM uses an operand stack for computation rather than registers.', 5, '2026-12-19'),

('Counting Problem',
 'How many leaf nodes does a full binary tree with 7 internal nodes have?',
 'easy', '8', 'For a full binary tree: leaves = internal nodes + 1 = 7 + 1 = 8.', 5, '2026-12-20'),

('Shortest Paths',
 'For which type of graph does Dijkstra''s algorithm fail to find correct shortest paths?',
 'easy', 'negative weight edges', 'Dijkstra assumes all edge weights are non-negative.', 5, '2026-12-21'),

('Cache Write Policy',
 'In a write-through cache policy, when is data written to main memory?',
 'easy', 'immediately', 'Write-through writes to cache and main memory at the same time.', 5, '2026-12-22'),

('Depth First Numbering',
 'In a DFS of a tree rooted at 1 with children 2 and 3, where 2 has child 4: if we always visit the left (lower-numbered) child first, what is the DFS order? Answer as comma-separated values.',
 'easy', '1,2,4,3', 'DFS: visit 1, go to 2, go to 4, backtrack, go to 3.', 5, '2026-12-23'),

('Logic Puzzle',
 'You have 3 switches downstairs and 3 light bulbs upstairs. You can only go upstairs once. What is the minimum number of switch operations needed to determine which switch controls which bulb?',
 'hard', '2', 'Turn on switch 1 for 5 minutes (warm), turn it off. Turn on switch 2. Go upstairs: on=switch 2, warm=switch 1, cold/off=switch 3.', 5, '2026-12-24'),

('Asymptotic Notation',
 'O(1) is sometimes called what-time? (One word)',
 'easy', 'constant', 'O(1) means the operation takes constant time regardless of input size.', 5, '2026-12-25'),

('Bloom Filter',
 'A Bloom filter can have false positives but can it have false negatives? Answer yes or no.',
 'medium', 'no', 'If a Bloom filter says an element is not present, it is definitely not present.', 5, '2026-12-26'),

('Process vs Thread',
 'What do threads within the same process share that separate processes do not? (One word)',
 'easy', 'memory', 'Threads share the same address space (memory), while processes have separate spaces.', 5, '2026-12-27'),

('Permutation Cycles',
 'The permutation [3, 1, 2] (meaning 1->3, 2->1, 3->2) consists of how many cycles?',
 'medium', '1', 'The cycle is (1 3 2): 1->3->2->1. There is one cycle.', 5, '2026-12-28'),

('Math Ceiling',
 'What is the ceiling of 7.2?',
 'easy', '8', 'The ceiling function rounds up to the nearest integer.', 5, '2026-12-29'),

('Year in Binary',
 'What is the year 2026 in binary?',
 'medium', '11111101010', '2026 = 1024+512+256+128+64+32+8+2 = 11111101010.', 5, '2026-12-30'),

('Last Challenge',
 'How many days are in the year 2026?',
 'easy', '365', '2026 is not divisible by 4, so it is not a leap year.', 5, '2026-12-31');
