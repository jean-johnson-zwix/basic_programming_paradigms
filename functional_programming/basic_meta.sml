(*--Q1. A. Sum of a list--*)
fun sumList [] = 0 |
    sumList (h::t) = h + sumList(t);
sumList [22,4,7,1];

(*--Q1. B. Fibonacci --*)
fun fibonacci 0 = 0 |
    fibonacci 1 = 1 |
    fibonacci n = fibonacci(n-1) + fibonacci(n-2);
fibonacci 9;

(*--Q2. Reverse (Tail Recursive) --*)
fun reverse [] = [] |
    reverse L = 
      let 
        fun reverseHelper (acc, [] )= acc |
            reverseHelper (acc,(h::t) )= reverseHelper ((h::acc), t)
      in
        reverseHelper ([], L)
      end;
reverse([2,1,3]);

(*--Q3. Rotate --*)
fun rotate_once [] = [] |
    rotate_once L = [List.last(L)]@List.take(L,List.length(L)-1);
fun rotate([], _) = [] |
    rotate(L, 1) = rotate_once(L)  |
    rotate(L, n) = rotate(rotate_once(L), n-1) ;
rotate([1,2,3], 4);

(*--Q4. Merge Sort --*)
fun divide L = 
  let val mid = length(L) div 2
  in (List.take(L,mid), List.drop(L,mid))
  end;
fun merge (_,[], Right) = Right |
    merge (_,Left, []) = Left    |
    merge (cmp,lh::lt, rh::rt) = 
      if cmp lh rh  
      then lh :: merge(cmp,lt,rh::rt) 
      else rh :: merge(cmp,lh::lt,rt);
fun msort _ [] = [] |
    msort _ [x] = [x] |
    msort cmp L = 
      let val (Left, Right) = divide L
      in merge (cmp,msort cmp Left, msort cmp Right)
      end;
msort (fn x =>fn y=> x<y) [2, 5, 3, 4, 1];
msort (fn x =>fn y=> x>y) [2, 5, 3, 4, 1];

(*-- Extra Credit: Tower of Hanoi --*)
fun hanoi(1,peg1,peg2,peg3) = [(peg1,peg3)] |
    hanoi(n,peg1,peg2,peg3) = hanoi(n-1,peg1,peg3,peg2) @ [(peg1,peg3)] @ hanoi(n-1,peg2,peg1,peg3);
hanoi(3, 1, 2, 3);