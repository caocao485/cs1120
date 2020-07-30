# cs1120

- [cs1120](#cs1120)
  * [part1总结](#part1--)
  * [part2 总结](#part2---)
  * [Part 3总结](#part-3--)
    + [Python](#python)
  * [part 4 解释器和可计算](#part-4--------)
    + [建立一个语言](#------)
  * [其余语言的BNF形式](#-----bnf--)
    + [HTTP：](#http-)
    + [SQL：](#sql-)
    + [Java](#java)



![课程内容总览](/images/course_roadmap.png)

[Classes](http://www.cs.virginia.edu/~evans/cs1120-f11/allclasses)

[20Q.net Inc.](http://www.20q.net/)

[cs1120: Introduction to Computing: Explorations in Language, Logic, and Machines](https://web.eecs.umich.edu/~weimerw/2012-1120F/)

[David Evans](https://www.slideshare.net/DavidEvansUVa/presentations/6)

[Anaconda 查看、创建、管理和使用python环境_分花拂柳的博客-CSDN博客_anaconda 创建环境](https://blog.csdn.net/u014628771/article/details/80066624)

## part1总结

------

1. 这书比sicp多的地方：语言（可能是语法形式，比如BNF 语法）、复杂度分析、更明确的面向对象系统和可计算性分析

2. 信息（编码）：二进制编码树表现数字、文字、图片

3. 对角线法证明实数不可数：需要用计算机模拟

4. 摩根定律：计算机执行能力的增长（底层硬件增长的规律）

5. 计算机：研究模拟现实世界的抽象事物、计算机不受自然条件的约束（一个主要的限制因素是人的思维能力，抽象是解决办法）、自由艺术（纯智力活动）

6. 本书主题：

   1. 定义过程，
   2. 分析过程
   3. 改善过程
   4. 计算的局限性

7. 本书重点：

   1. 递归定义
   2. 通用性（将程序当成数据）
   3. 抽象

8. 定义语言的方法：

   1. 递归转换网络：递归转换网络是一种图形理论示意图，用于表示上下文无关文法的规则。RTN可应用于编程语言，自然语言和词法分析。任何根据RTN规则构造的句子都被称为“格式正确的”。格式良好的句子的结构要素本身也可以是格式良好的句子，或者它们可以是更简单的结构（可以用堆栈表示）

      ![rtn](/images/rtn.png)

   2. BNF文法（巴科斯文法）：是一种用于表示上下文无关文法的语言，上下文无关文法描述了一类形式语言。（从理论推导到实际，从一般推导到特殊），巴科斯文法还可以递归。

      ![bnf](/images/bnf.png)

9. 自然语言的缺陷：复杂性（单词很多）、歧义、不规则性（有很多方言）、不经济性（描述东西很复杂）、缺乏抽象手段

10. BNF Scheme 语法：

    ```jsx
    1.基本表达式
    Expression ::= PrimitiveExpression
    
    PrimitiveExpression ::= Number | true | false | Primitive Procedure
    
    **Evaluation Rule 1: Primitives. A primitive, evaluates to __________________________________________.**
    
    **Defintion** ::= （define Name Expression）
    ;;Abbreviated Procedure Definitions
    Definition :: ⇒ (define (Name Parameters) Expression)
    
    Expression ::= NameExpression
    
    NameExpression ::= Name
    
    **Evaluation Rule 2: Names. A name expression evaluates to a NameExpression is the value associated with the Name.**
    
    2.过程表达式
    Expression :: ⇒ ProcedureExpression
    
    ProcedureExpression :: ⇒ (lambda (Parameters) Expression)
    
    Parameters :: ⇒ e | Name Parameters
    
    produces a procedure that takes as inputs the Parameters following the lambda. The lambda special form means “make a procedure”. 
    The body of the resulting procedure is the Expression, which is not
    evaluated until the procedure is applied.
    
    3.应用表达式
    Expression ::= ApplicationExpression
    
    ApplicationExpression ::= (Expression MoreExpressions)
    
    MoreExpressions ::= e | Expression MoreExpressions （**终止符**）
    
    **Evaluation Rule 3: Application. To evaluate an application:
        (a) Evaluate all the subexpressions (in any order)
        (b) Apply the value of the first subexpression to the values of all the other subexpressions. （operands arguments）
    
    Application Rule 1: Primitives. If the procedure to apply is a primitive, produce primitive value
    
    Application Rule 2: Constructed Procedures. If the procedure is a constructed procedure, evaluate___________________ 
    the body of the procedure with each formal parameter replaced by the corresponding actual argument expression value.
    
    ;;代换模型
    ;; the first Expression evaluates to a procedure that was
    created using a ProcedureExpression, so the ApplicationExpression becomes:
    ApplicationExpression :: ⇒((lambda (Parameters)Expression) MoreExpressions)
    
    ;;决策（Decisions）决策表达式
    Expression :: ⇒ IfExpression
    IfExpression :: ⇒ (if Expression Predicate
    											 Expression Consequent
    											 Expression Alternate )
    ;;special form**
    ```

    计算规则就是：

    ```jsx
    Program :: ⇒ e | ProgramElement Program
    ProgramElement :: ⇒ Expression | Definition
    	A program is a sequence of expressions and definitions.
    
    Definition :: ⇒ (define Name Expression)
    	A definition evaluates the expression, and associates the value of the
    	expression with the name.
    Definition :: ⇒ (define (Name Parameters) Expression)
    	Abbreviation for
    	(define Name (lambda Parameters) Expression)
    
    Expression :: ⇒ PrimitiveExpression | NameExpression| ApplicationExpression| ProcedureExpression | IfExpression
    	The value of the expression is the value of the replacement expression.
    
    PrimitiveExpression :: ⇒ Number | true | false | primitive procedure
    	Evaluation Rule 1: Primitives. A primitive expression evaluates to
    	its pre-defined value.
    
    NameExpression :: ⇒ Name
    	Evaluation Rule 2: Names. A name evaluates to the value associatedwith that name.
    
    ApplicationExpression :: ⇒ (Expression MoreExpressions)
    	Evaluation Rule 3: Application. To evaluate an application expression:
    		a. Evaluate all the subexpressions;
    		b. Then, apply the value of the first subexpression to the values of the remaining subexpressions.
    
    MoreExpressions :: ⇒ e | Expression MoreExpressions
    ProcedureExpression :: ⇒ (lambda (Parameters) Expression)
    Parameters :: ⇒ e | Name Parameters
    	Evaluation Rule 4: Lambda. 
    		Lambda expressions evaluate to aprocedure that takes the given parameters and has the expression as its body.
    
    IfExpression :: ⇒ (if Expression Predicate
    											 Expression Consequent
    			                 Expression Alternate )
    	Evaluation Rule 5: If. 
    		To evaluate an if expression, 
    			(a) evaluate thepredicate expression; 
    			then, (b) if the value of the predicateexpression is a false value then the value of
    						 the if expression is thevalue of the alternate expression; 
    			otherwise, the value of the ifexpression is the value of the consequent expression.
    
    Expression ::= BeginExpression
    BeginExpression ::= (begin MoreExpressions Expression)
    	Evaluation Rule 6: Begin. 
    		To evaluate (begin Expression1 Expression2 … Expressionk), 
    			evaluate each sub-expression in order from left to right. 
    			The value of the begin expression is the value of Expressionk.
    
    Expression ::= LetExpression
    LetExpression ::= (let (Bindings) Body)
    Body ::= MoreExpressions Expression
    Bindings ::= Binding Bindings
    Bindings ::=
    Binding ::= (Name Expression)
    	Evaluation Rule 7: Let. 
    		To evaluate a let expression, evaluate each binding in order. 
    			To evaluate each binding, evaluate the binding expression and bind the name to the value of that expression. 
    			Then, evaluate the body expressions in order with the names in the expression that match binding names substituted with their bound values. 
    		The value of the let expression is the value of the last body expression.
    
    Expression ::= CondExpression
    CondExpression ::= (cond ClauseList)
    ClauseList ::=
    ClauseList ::= Clause ClauseList
    Clause ::= (ExpressionTest ExpressionAction)
    Clause ::= (else ExpressionAction)
    	Evaluation Rule 8: Conditionals. 
    		To evaluate a CondExpression, evaluate each clause’s test expression in order until one is found that evaluates to a true value. 
    		Then, evaluate the action expression of that clause. 
    			The value of the CondExpression is the value of the action expression. 
    			If none of the test expressions evaluate to a true value, 
    				if the CondExpression includes an else clause, the value of the CondExpression is the value of the action expression associated with the else clause. 
    				If none of the test expressions evaluate to a true value, and the CondExpression has no else clause, the CondExpression has no value.
    
    The evaluation rule for an application (Rule 3b) uses apply to perform the application. 
    Apply is deifined by the two application rules:
    		Application Rule 1: Primitives.
    			To apply a primitive procedure, just do it.
    		Application Rule 2: Constructed Procedures.
    			To apply a constructed procedure, evaluate the body of the procedure with 
    			each parameter name bound to the corresponding input expression value.
    
    Expression :: ⇒ LetExpression
    LetExpression :: ⇒ (let (Bindings) Expression)
    Bindings :: ⇒ Binding Bindings
    Bindings :: ⇒ e
    Binding :: ⇒ (Name Expression)
    
    Evaluation Rule 6: Let expression. 
    To evaluate a let expression, valuate each binding in order. 
    	To evaluate each binding, evaluate the binding expression 
    												and bind the name to the value of that expression. 
    	Then, the value of the let expression is the value of the body expression 
    		evaluated with the names in the expression that 
    		match binding names substituted with their bound values.
    
    Expression :: ⇒ Assignment
    Assignment :: ⇒ (set! Name Expression)
    
    Evaluation Rule 7: Assignment. 
    To evaluate an assignment, 
    	evaluate the expression, 
    	and replace the value associated with the name 
    		with the value of the expression. 
    An assignment has no value.
    
    Expression :: ⇒ BeginExpression
    BeginExpression :: ⇒ (begin MoreExpressions Expression)
    
    Evaluation Rule 8: Begin. To evaluate a begin expression,
    (begin Expression 1 Expression 2 . . . Expression k )
    evaluate each subexpression in order from left to right. The value of the
    begin expression is the value of the last subexpression, Expression k .
    
    Expression → AndExpression
    AndExpression → (and ExpressionList)
    ExpressionList → ε
    ExpressionList → Expression ExpressionList
    
    Expression → ForExpression
    ForExpression → (for Name in Expression1 do Expression2)
    ```

11. 过程与数学函数的区别：

    1. 状态：过程可能改变状态
    2. 资源：时间和空间资源

12. rgb：颜色比较，不同权重的rgb元素想加

    [请教,比较两个RGB颜色的相似度-CSDN论坛](https://bbs.csdn.net/topics/391015532)

    ![rgb_result](/images/rgb_result.png)

13. Racket有面向对象系统

    - 实现subclass

      ```jsx
      (define (make-sub-object super subproc)
      (lambda (message)
      (let ((method (subproc message)))
      (if method method (super message)))))
      
      (define (ask object message . args)
      (apply (object message) object args))
      
      (define (make-sub-object super subproc)
      (lambda (message)
      (if (eq? message ’get-super)
      (lambda (self ) super)
      (let ((method (subproc message)))
      (if method method (super message))))))
      
      (ask (ask self ’get-super) ’set-count! val))
      ```

14. 求不动点

    ```jsx
    #lang racket
    (define (find-fixedpoint fun initvalue)
      (if (good-enough? (fun initvalue) initvalue)
          initvalue
          (find-fixedpoint fun (improve fun initvalue))))
    
    (define (good-enough? a b)
      (< (abs (- a b)) 0.0000000000000001))
    
    (define (improve fun value)
      (/ (+ (fun value) value) 2))
    ```

15. 解决问题的方法：分而治之：

    1. 组合式

       ```jsx
       (define fcompose
       		(lambda(f g)(lambda(x)(g (f x)))))
       
       (define f2compose
         (lambda(f g)
           (lambda(a b)
             (g(f a b)))))
       ```

    2. 递归式

       - **Base case:** This case ends the recursion. Any input to a recursive procedure will eventually reach the base case.
       - **Recursive case:** This case reduces the size of the problem. The recursive case will always try to make the problem smaller until it reaches the base case.
       - Trust recursion

       ```jsx
       (define (factorial n)
              (if ( = n 0 )1
                  ( * n (factorial ( - n 1 )))))
       
       (define (choose n k)
         (if (= k 1)
             (/ (factorial n) (factorial (- n k)))
             (* (/ n k) (choose (- n 1)(- k 1)))))
       
       (define possible
         (/ (* 4 9) (choose 52 5)))
       
       (exact->inexact possible)
       ```

16. debugging：

    1. printf：

       ```jsx
       (define (factorialn n)
       	(printf "Enter factorial: ~a~n" n)
       	(if ( = n 0 ) 
       			1 
       			( * n (factorialn ( - n 1 )))))
       ```

    2. Tracing：

       ```jsx
       > (require racket/trace)
       > (trace factorial)
       > (factorial 2)
       
       (factorial 2)
       |(factorial 1)
       | (factorial 0)
       | 1
       |1
       2
       2
       ```

17. 求pi：

    [如何使用BBP公式直接计算π的第n位_HuntZou的博客-CSDN博客_bbp公式](https://blog.csdn.net/zouh613/article/details/83348102)

    [【并行计算】六种方法计算圆周率](http://littledva.cn/article-16/)

18. middle

    ```jsx
    (define middle
    	(lambda(a b c)
    		(min (max a b) (max a c) (max b c))))
    ```

19. 构建pair：

    ```jsx
    (define (scons a b)(lambda(w)(if w a b))
    (define (scar pair)(pair true))
    (define (scdr pair)(pair false))
    ```

20. list的文法形式：

    ```jsx
    List :: ⇒ null
    List :: ⇒ (cons Value List)
    ```

21. 汉明距离：在信息论中，两个等长字符串之间的汉明距离（英语：Hamming distance）是两个字符串对应位置的不同字符的个数。

22. 编辑距离：也叫莱文斯坦距离(Levenshtein),是针对二个字符串（例如英文字）的差异程度的量化量测，量测方式是看至少需要多少次的处理才能将一个字符串变成另一个字符串。

23. L-系统：

    ```jsx
    ;;; 
    ;;; L-System commands for the tree fractal
    ;;; F1 ::= (F1 O(R30 F1) F1 O(R-60 F1) F1) 
    
    (draw-lsystem-fractal (make-tree-fractal 3))
    ```

------

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/ec135186-9508-42ae-b91f-c89162202c25/Untitled.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/ec135186-9508-42ae-b91f-c89162202c25/Untitled.png)

## part2 总结

------

1. 计算机作为机器的两个关键点：延展我们的思维而非延展我们的动手能力，执行多种任务而非单一任务。

2. 数字抽象：屏蔽细节、做简化。

3. 图灵机：提供了一个通用的可计算模型。

   1. 一条无限长的纸带TAPE：分成方块作为输入、工作存储和输出。

   2. 读写头：可以在纸带上左右移动，它能读出当前所指的格子上的符号，并能改变当前格子上的符号。可以左右移动一个格子。(符号是个有限集） 还会跟踪其内部状态，并按照匹配当前状态和当前磁带方块的规则来决定下一步要做什么。（特殊状态：**停机状态**）

      ![turing_machine](/images/turing_machine.png)

      ![turing_start](/images/turing_start.png)

      ![halts](/images/halts.png)

      ![significance](/images/significance.png)

      [PS4 - Comments](http://www.cs.virginia.edu/~evans/cs1120-f11/problem-sets/problem-set-4-constructing-colossi/ps4-comments)

4. ada

5. Finite State Machine：

   A Finite State Machine is a very simple model of a machine that has a finite amount of memory (unlike the Turing Machine model which has an infinite amount of memory since the tape is infinitely long). A Finite State Machine consists of:

   - A finite alphabet of symbols. There is a finite set of symbols that can be written into squares on the tape.
   - A finite set of states. Some of the states may be distinguished (for the FSM for a Turing Machine, we typically have a distinguished state called “Halt” where the machine stops if that state is reached).
   - A set of decision rules. Each rule is of the form <state0, symbol> → state1. If the machine is currently in state0 and the next input symbol is symbol, after reading the symbol the state is now in state1.

   Unlike a Turing Machine, a Finite State Machine can see each input symbol only once. You can think of it as a machine that starts with the input on a finite tape, and process that input from left to right, reading one square at a time.

6. xor：

   [德摩根定律](https://zh.wikipedia.org/wiki/德摩根定律)

   ```jsx
   （or a b) = (not (and (not a)(not b)))
   
   (xor a b) = (and (or a b)
   								 (or (not a)
   										 (not b)))
   
   (xor a b) = (and (not (and (not a) (not b)))
   								 (not (and a b)))
   
   (xor a b) = (or (and (not a) b)
   								(and a (not b))
   ```

   [金马的Blog](http://lijinma.com/blog/2014/05/29/amazing-xor/)

   xor的用处：快速比较、快速归零、校验和恢复

   保密特性：

   - 可逆性 - (xor (xor a b) b)无论b是什么，都会计算为a。这意味着，如果我们用密钥xor加密一个信息，我们可以用相同的密钥再次使用xor来解密这个信息
   - 完美保密性--如果a是一个消息位，r是一个完全随机的位（百分之五十的几率是真，百分之五十的几率是假），那么无论消息位a是什么，（xor a r）同样有可能是真或假。

7. Racket实现循环：

   ```jsx
   (define (for index end proc)
     (if(>= index end)
        (void) ;;this evaluates to no value
        (begin
          (proc index)
          (for(+ index 1) end proc))))
   
   (define (while index test update proc)
     (if(test index)
        (begin
          (proc index)
          (while (update index) test update proc))
        index))
   
   (define (loop index result test update proc)
     (if (test index)
         (loop (update index)
               (proc index result)
               test update proc)
         result))
   
   (define (gauss-sum n)
    (loop 1 0
          (lambda (i) (<= i n))
          (lambda (i) (+ i 1))
          (lambda (index result)
            (+ index result))))
   
   (define (factorial n)
    (loop 1 1
          (lambda (i) (<= i n))
          (lambda (i) (+ i 1))
          (lambda (index result)
            (* index result))))
   
   (define (not-null? p) (not (null? p))) 
   
   (define (list-length p)
    (loop p  0
            (lambda(i)(not-null? i))
            (lambda(i)(cdr i))
            (lambda(index result)
              (+ result 1))))
   
   (define (list-accumulate f base p)
    (loop p base
          (lambda(i)(not-null? i))
          (lambda(i)(cdr i))
          (lambda(index result)
            (f (car index) result))))
   
   (define (fib n)
     (cond((= n 0)0)
          ((= n 1) 1)
          (else
           (loop 2 1
                 (lambda (i) (<= i n))
                 (lambda (i) (+ i 1))
                 (lambda (index result)
                   (+ (fib (- index 2)) result))))))
   
   (define (fibo-loop n)
     (cdr
      (loop 1 (cons 0 1)
            (lambda(i)(< i n))
            add1
            (lambda(i v)
              (cons (cdr v)(+ (car v)(cdr v)))))))
   ```

8. web-crawler：典型的网络爬虫从一组种子 URL 开始，然后通过跟踪这些页面上的链接来索引更多的文档。这样循环往复：每个新发现的页面上的链接都会被添加到爬虫要索引的URL集合中。为了开发一个网络爬虫，我们需要一种方法来提取给定网页上的链接，并管理要索引的网页集。

   1. 定义一个过程extract-links，该过程将一个代表网页文本的字符串作为输入，并输出一个与该网页链接的所有网页的列表。通过搜索网页上的锚标签可以找到被链接的网页。锚标签的形式是<a href=target>（文本到文字位置的过程可能是一个有用的起点，用来定义extract-links。）
   2. 定义一个存储过程crawl-page，它接收一个索引和一个代表URL的字符串作为输入。作为输出，它产生了一个由索引（即把输入URL处的页面中的所有单词加到输入索引中的结果）和一个代表被抓取页面链接到的所有页面的URL列表组成的一对。
   3. 定义一个过程crawl-web，它接收一个种子URL的列表和一个表示最大爬行深度的Number作为输入。它应该输出种子URLs给出的位置的网页上的所有单词的索引，以及通过跟随不超过最大深度的链接数可以从这些种子URLs到达的任何页面。

   $$\R{u} =\sum_{{v}\in{L{u}}} \frac{R{v}} {L{v}}$$

   - L u是包含指向目标网页u的链接的网页集
   - L ( v )是页面v上的链接数量（因此，来自包含许多链接的页面的链接的值小于来自一个只包含少量链接的页面的链接的值）。
   - R ( u )的值给出了对确定的页面的排名的衡量。其中数值越高表示越有价值的页面。

## Part 3总结

------

1. 环境模型：名、帧栈、环境

2. 状态求值规则：

   ```jsx
   Stateful Evaluation Rule 2：Names。
   To evaluate a name expression,search the evaluation environment's frame with a
   name that matches the name in the expression.  
   If such a place exists,the value of the name expression is the value in that place
   Otherwise,the value of the name expression is the result of evaluating the name 
   expression in the parent environment.   
   	if the evaluation environment has no parent,the name if not defined and the name 
   expression evaluates to an error. 
   
   Stateful Definition Rule. 
   A definition creates a new place with the definition's name in the frame associated
   	with the evaluation environment. The value in the place is value of 
   	the definition's expression.  
   If there is already a place with the name in the current frame, the definition 
   replaces the old place with a new place and value.        
   
   Stateful Application Rule 2: Constructed Procedures. 
   To apply a constructed procedure:
   	1. Constructed a new environment, whose parent 
   		is the environment of the applied procedure
   	2. For each procedure parameter,create a place in the frame of the new 
   		environment with the name of the parameter. Evaluate each operand expression
   		in the evvironment or the application and initialize the value in each place to
   		the value of the corresponding oprand expression
   	3.Evaluate the body of the procedure in the newly created environment.
   		The resulting value is the value of the application. 
   ```

3. 变动的列表操作：（操作更加高效，没有构建的过程）

   ```jsx
   #lang racket
   (require racket/mpair)
   (require racket/trace)
   
   (define (update-counter!)
     (set! counter (+ counter 1))
     counter)
   
   (define counter 0)
   
   (define pair (mcons 1 2))
   (set-mcar! pair 3)
   (set-mcdr! pair 4)
   pair
   
   (define m1 (mlist 1 2 3))
   (set-mcar! (mcdr m1) 5)
   (set-mcar! (mcdr (mcdr m1))0)
   m1
   
   (define (mlist-length m)
     (if(null? m)0 (+ 1(mlist-length (mcdr m)))))
   
   ;;Exercise 9.5
   (define (mpair-circular? pair)
     (let((slower-pair pair)
          (faster-pair pair))
       (define (iter slower faster)
         (cond
           ((or(null? slower)
               (null? faster)
               (null? (mcdr faster)))
               false)
           ((or(equal? slower faster)
               (equal? slower (mcdr faster)))
            true)
           (iter (mcdr slower) (mcdr (mcdr faster)))))
       (iter slower-pair faster-pair)))
   
   (set-mcdr! pair pair)
   (mpair-circular?  pair)
   pair
   
   (define (mlist-map! f p)
     (if(null? p)(void)
        (begin(set-mcar! p (f (mcar p)))
              (mlist-map! f (mcdr p)))))
   
   (define (mlist-filter! test p)
     (if(null? p)null
        (begin (set-mcdr! p (mlist-filter! test (mcdr p)))
               (if(test(mcar p)) p(mcdr p)))))
   (define a (mlist 1 2 3 1 4))
   (mlist-filter! (lambda(x)(> x 1)) a)
   a
   (set! a (mlist-filter!
            (lambda(x)(> x 1))
            a))
   
   (define (mlist-append! p q)
     (if(null? p)(error "Cannot append to an empty list")
        (if(null? (mcdr p)) (set-mcdr! p q)
           (mlist-append!(mcdr p)q))))
   
   ;;alaising
   (define m3 (mlist 1 2 3))
   (define m2 (mlist 4 5 6))
   (mlist-append! m1 m2)
   (set! m3 (mlist-filter! (lambda(el)
                            (= (modulo el 2)0))
                          m3))
   m3
   
   ;;Exercise 9.6 
   (define (mlist-inc! p)
     (mlist-map! add1 p))
   
   ;;Exercise 9.7
   (define (mlist-truncate! p1 )
     (if(null?(mcdr(mcdr p1)))
        (set-mcdr! p1 '())
        (mlist-truncate! (mcdr p1))))
   
   ;;Exercise 9.8
   (define (mlist-make-circular! p)
     (let((initial-value p))
       (define (iter p1)
         (if(null? (mcdr p1))
            (set-mcdr! p1 initial-value)
            (iter (mcdr p1))))
       (iter p)))
   
   ;;m2
   ;;(mlist-make-circular! m2)
   ;;m2
   
   ;;Exercise 9.9
   (define (mlist-reverse-interval! p)
     (if(null? (mcdr p))
        p
        (let((rest(mlist-reverse-interval! (mcdr p))))
          (set-mcdr! p null)
          (mlist-append! rest p)
             rest)))
   (define (mlist-reverse! p)
     (let((car-value(mcar p))
          (p1 (mlist-reverse-interval! (mcdr p))))
       (mlist-append! p1 (mlist car-value))
       (set-mcar!  p (mcar p1))
     (set-mcdr! p (mcdr p1))))
   
   m1
   ;;(trace mlist-reverse!)
   (mlist-reverse! m1)
   m1
   ;;(1 2 3)
   ;;(2 3)
   
   ;; 
   (define (mlist-reverse! p)
     (if(null? (mcdr p))
        (void)
        (let((rest(mcdr p))
             (carp(mcar p)))
          (mlist-reverse! rest)
          (set-mcar! p (mcar rest))
          (set-mcdr! p (mcdr rest))
          (mlist-append! p (mcons carp null)))))
   
   ;;Exercise 9.10
   (define (mlist-aliases? p1 p2)
     (if(or(null? p1)(null? p2))
        false
        (if(eq? (mcar p1)(mcar p2))
           true
           (mlist-aliases? (mcdr p1)(mcdr p2)))))
   
   ;;(set-mcar! m2 2)
   ;;(set-mcar! m3 2)
   
   ;;(mlist-aliases? m2 m3)
   
   (define (while test body)
          (if(test)
             (begin(body)(while test body))
             (void))) ;;no result value
   
   (define (fibo-while n)
     (let ((a 1)(b 1))
       (while (lambda()(> n 2))
              (lambda()
                (let ((oldb b))
                (set! b (+ a b))
                (set! a oldb)
                (set! n (- n 1)))))
       b))
   
   ;;Exercise 9.11
   (define (mlist-map-while! f lst)
     (while (lambda()(not(null? lst)))
            (lambda()
              (set-mcar! lst (f (mcar lst)))
              (set! lst (mcdr lst)))))
   m2
   (mlist-map-while! (lambda(x)(+ x 2)) m2)
   m2
   
   ;;Exercise 9.12
   (define (factorial n)
     (let ((fact 1))
       (repeat-until
        (lambda()(set! fact (* fact n))(set! n (- n 1)))
        (lambda()(< n 1)))
       fact))
   (define (repeat-until body test)
     (body)
     (if(not (test))
        (repeat-until  body test)
        (void)))
   
   ;;
   ```

4. 第9章总结：

   变动的列表操作：（赋值的列表操作更加高效，没有构建的过程，也不需要复制数据结构来对其进行修改）。

   赋值的缺点：对程序的推理变得困难，下一章讲的是智能数据结构（即面向对象系统）。

5. location：

   ```jsx
   Places live in frames. 
   An environment is a frame and a pointer to a parent environment.    
   All environments except the global environment have exactly one 
   parent environment,global environment has no parent.   
   Application creates a new environment. 
   ```

6. 状态编程（一页总结）：

   - 在求值Scheme的代换模型中，并不容易来让人推理变动。在环境模型中：
     - 一个名字是指向存储一个值的位置。define、mcons、cons和function应用创造地方，set!改变位置的值。
     - 位置集存在于帧栈中，一个环境是一个帧栈和一个指向父帧栈的指针。全局环境没有父系。
     - 求值一个名字，一步步遍历帧栈直到找到定义。
     - 函数式和命令式过程可能有不同的渐进式消耗。

7. Scheme实现subclass:

   ```jsx
   (define (make-sub-object super subproc)
   		(lambda (message)
   			(let ((method (subproc message)))
   				(if method method (super message)))))
   
   (define (ask object message . args)
   		(apply (object message) object args)) ;;self作为参数传入
   
   ;;例子
   (deine (make-counter)
   	(let ((count 0 ))
   		(lambda (message)
   				(cond((eq? message ’ get-count ) (lambda (self ) count))
   						 ((eq? message ’ set-count! ) (lambda (self val) (set! count val)))
   					   ((eq? message ’ reset! ) (lambda (self ) (ask self ’ set-count! 0 )))
   					   ((eq? message ’ next! )(lambda (self ) (ask self ’ set-count! ( + 1 (ask self ’ current )))))
                (else (error "Unrecognized message" ))))))
   
   (define (make-adjustable-counter)
   	(make-sub-object
   		(make-counter)
   		(lambda (message)
   			(cond
   				((eq? message ’ adjust! )
   					(lambda (self val)
   					(ask self ’ set-count! ( + (ask self ’ get-count ) val))))
   				(else false)))))
   ```

8. Scheme实现复写方法：

   ```jsx
   (define (make-sub-object super subproc)
   	(lambda (message)
   		(if (eq? message ’ get-super )
   				(lambda (self ) super)
   				(let ((method (subproc message)))
   						 (if method method (super message))))))
   
   ;;With the get-super method we can define the set-count! method for positive-
   ;;counter, replacing the . . . with:
   (ask (ask self ’ get-super ) ’ set-count! val))
   ```

### Python

1. Python的bnf语法：

   ```jsx
   PythonCode ::= Statements
   Statements ::= Statement <newline> Statements
   Statements ::= 
   
   ;;statement
   Statement ::= AssignmentStatement
   Statement ::= ApplicationStatement
   Statement ::= FunctionDefinition
   
   AssignmentStatement ::= Variable = Expression
   
   ApplicationStatement ::= Name ( Arguments )
   Arguments ::=
   Arguments ::= MoreArguments
   MoreArguments ::= Argument ,MoreArguments
   MoreArguments ::= Argument
   Argument ::= Expression
   
   FunctionDefinition ::= def Name (Parameters ): <newline> Statements
   Parameters ::=
   Parameters ::= MoreParameters
   MoreParameters ::= Parameter ,MoreParameters
   MoreParameters ::= Parameter
   Parameter ::= Variable
   
   ReturnStatement ::= return Expression
   
   Expression ::= lambda Parameters : Expression
   
   ;;Control Statements
   Statement ::= if Expression: Block
   
   Statement ::= if Expression: BlockConsequent
                        else: BlockAlternate
   
   Statement ::= while Expression: Block
   
   Statement ::= for VaribleList in ExpressionList : Block
   
   Statement ::=while Expression:Block
   
   Expression ::= lambda Parameters:Expresson
   ```

2. Python的Types

   - Booleans
   - Strings
   - List(Tuple)

   List操作：

   - Mapping
   - Filtering
   - Appending
   - Deleting

   Dictonaries：

   ```jsx
   DictionaryInitializationStatment ::= Variable = { InitializationExpressions }
   InitializationExpressions ::=
   InitializationExpressions ::= InitializationExpression, InitializationExpressions
   InitializationExpression ::= Expression : Expression
   
   SetStatement ::= Expression [ Expression ] = Expression
   
   FetchExpression ::= Expression [ Expression ]
   ```

   Classes

   ```jsx
   ClassDefinition ::= class Name:
                                           FunctionDefinitions
   
   ClassDefinition ::= class SubClassName ( SuperClassName ) :
                                           FunctionDefinitions
   ```

   Modules：

   ```jsx
   import module
   from module import *
   ```

3. Python注意点：

   1. from adventure import *

   2. tuple不可变

   3. 列表反转：

      ```jsx
      def sreverse(p):
          if len(p) == 1:
              return
          else:
              rest=p[1:]
              first=p[0]
              sreverse(rest)
              p[0] = rest[0]
              p[1:] = rest[1:]
              p.append(first)
      def reversee(p):
          **for i in range(0,len(p) >> 1):
              p[i],p[len(p) - 1 - i] = p[len(p) - 1 - i],p[i]
      ```

## part 4 解释器和可计算

------

### 建立一个语言

1. 设计语法：

   语言中的字符串是怎样的

   使用BNF文法来描述这个语言的所有字符串

2. 标记这个求值规则： 描述每个字符串在语言中的含义

3. 建造一个求值器：

   实现一个过程将语言合法字符串和一个环境作为输入，值作为输出：

   $meval: String × Environment → Value$

   1. 指出如何表示程序中的数据： 什么是过程，帧栈，环境等等

   2. 实现求值规则：

      对于每个求值规则，定义一个符合规则行为的过程。

> 求值器的核心：

求值程序：

```jsx
def meval(expr, env):
    if isPrimitive(expr):
       return evalPrimitive(expr)
    elif isIf(expr):             
        return evalIf(expr, env) 
    elif isDefinition(expr):                
       evalDefinition(expr, env)
    elif isName(expr):
       return evalName(expr, env)
    elif isLambda(expr):
       return evalLambda(expr, env)
    elif isApplication(expr):
       return evalApplication(expr, env)
    else:
       error ('Unknown expression type: ' + str(expr))

class Environment:
    def __init__(self, parent):
        self._parent = parent
        self._frame = {}
    def addVariable(self, name, value):
        self._frame[name] = value
    def lookupVariable(self, name):
        if self._frame.has_key(name):
            return self._frame[name]
        elif (self._parent):
            return self._parent.lookupVariable(name)
        else:
            evalError('Undefined name: %s' % (name))

def evalApplication(expr, env):
    subexprs = expr
    subexprvals = map (lambda sexpr: meval(sexpr, env), subexprs)
    return mapply(subexprvals[0], subexprvals[1:])

def mapply(proc, operands):
    if (isPrimitiveProcedure(proc)):
        return proc(operands)
    elif isinstance(proc, Procedure):
        params = proc.getParams()
        newenv = Environment(proc.getEnvironment())
        if len(params) != len(operands):
            evalError ('Parameter length mismatch: %s given operands %s' 
                       % (str(proc), str(operands)))
        for i in range(0, len(params)):
               newenv.addVariable(params[i], operands[i])        
        return meval(proc.getBody(), newenv)        
    else:
        evalError('Application of non-procedure: %s' % (proc))
```

1. Scheme只需要分析括号开闭即可，语法分析很简单，递归下降。
2. 没有eval sequence
3. 缺乏Python的Debug技术
4. global关键字(造成这个原因的关键在于**Python变量赋值和初始化不分**）：
   1. 局部作用域改变全局变量（L中修改G中的变量）用`global`， `global`同时还可以定义新的全局变量
   2. 内层函数改变外层函数变量（在L中修改E中的变量）用`nonlocal`，`nonlocal`不能定义新的外层函数变量，只能改变已有的外层函数变量，同时`nonlocal`不能改变全局变量。
5. **from xx import \*不会导入由global定义的新变量（而后再导入）**

[Python常见十六个错误集合，你知道那些？](https://segmentfault.com/a/1190000015221119)

1. **init** 和__new__方法：

[详解Python中的__init__和__new__](https://www.jianshu.com/p/4f312ca60338)

1. 理发师悖论：

理发师悖论由哲学家罗素在1903年提出，也称为罗素悖论。有一个理发师打广告，说：“**我只给本城所有不给自己刮脸的人刮脸。**”问题是：理发师能不能给他自己刮脸呢？如果他不给自己刮脸，他就属于“不给自己刮脸的人”；如果他给自己刮脸，他就属于“给自己刮脸的人”，他就不该给自己刮脸。

[理发师悖论真正的矛盾是什么](https://zhuanlan.zhihu.com/p/34440794)

> Lazy evaluate

- Lazy Application Rule 2:

   Constructed Procedures. To apply a con-structed procedure:

  1. Construct a new environment, whose parent is the environmentof the applied procedure.
  2. For each procedure parameter, create a place in the frame of thenew environment with the name of the parameter. **Put a thunk inthat place, which is an object that can be used later to evaluatethe value of the corresponding operand expression if and whenits value is needed.**
  3. Evaluate the body of the procedure in the newly created environ-ment. The resulting value is the value of the application.

> 静态类型系统

**BNF：**

```jsx
Definition → (define Name : Type Expression)

Expression → ProcedureExpression
ProcedureExpression → (lambda (Parameters)Expression)
Parameters → ε
Parameters → Name : Type Parameters

Type → PrimitiveType | ProcedureType
PrimitiveType → Number | Boolean
ProcedureType → ( ProductType -> Type)
ProductType → (TypeList)
TypeList → Type TypeList | ε
```

**例子：**

```jsx
(define compose : ((((Number) -> Number) ((Number) -> Number))
                   -> ((Number) -> Number)) 
  (lambda ((f : ((Number) -> Number))
           (g : ((Number) -> Number)))
    (lambda ((x : Number)) (g (f x)))))

(define x:Number 3)
(define square : ((Number) -> Number) 
  (lambda ((x : Number)) (* x x)))
(define zz:(() -> Void)(lambda()(set! x (+ x 2))))
```

compose例子揭示了静态、显式类型的两个重要缺点。

- 第一个是manifest类型会增加很多程序的大小。在Java程序中也会注意到这一点。
- 第二是与Charme相比，静态类型会降低Aazda的表现力。

**解释器的改动部分：**

1. 在求值之前，进行类型检查；
2. 

## 其余语言的BNF形式

### HTTP：

```jsx
Document ::= <html> Header Body </html>
Header ::= <head> HeadElements </head>
HeadElements ::= HeadElement HeadElements
HeadElements ::=
HeadElement ::= <title> Element </title>
Body ::= <body> Elements </body>
Elements ::= Element Elements
Elements ::=
Element ::= <p>Element</p>
                            Make the inner element a paragraph.
Element ::= <center>Element</center>
                            Center the element horizontally on the page.
Element ::= <b>Element</b>
                            Display the element in bold.
Element ::= Text

Element ::= <em>Element</em>
Element ::= <tt>Element</tt>
Element ::= <font size="value">Element</font>
Element ::= <font face="Name">Element</font>
Element ::= <font color="Color">Element</font>
Element ::= <br>
Element ::= <a href="URL">Element</a>

Element ::= <img src="URL" width="Number" height="Number" " border="Number" alt="Text" >

;;**Tables

Element ::= Table
Table ::= <table TableOptions> TableRows </table
TableOptions ::= TableOption TableOptions
TableOptions ::=
TableOption ::= border="Number"
                            Width of the lines around the table (0 for no lines)
TableOption ::= cellspacing="Number"
                            Amount of space between each cell (pixels)
TableOption ::= cellpadding="Number"
                            Amount of space around the element in a cell (pixels)
TableOption ::= bgcolor="Color"
                            Background color of the table
TableRow ::= <tr RowOptions> TableColumns </tr>
RowOptions ::= RowOption RowOptions
RowOptions ::=
RowOption ::= valign=" VerticalAlignment"
                            Line up rows along top, middle or bottom.
TableColumns ::= TableColumn TableColumns
TableColumns ::=
TableColumn ::= <td ColumnOptions> Elements </td>
ColumnOptions ::= ColumnOption ColumnOptions
ColumnOptions ::=
ColumnOption ::= align="HorizontalAlignment"
                            Align the elements in the column left, right or center.
ColumnOption ::= bgcolor="Color"
                            Set the background color of the column.
ColumnOption ::= width="Number"
                            Specify the width of the column.

;;Forms
Element ::= <form method="post" action="URL"> FormElements </form>
FormElements ::= FormElement FormElements
FormElements ::=

FormElement ::= <textarea TextOptions>Element</textarea>
FormElement ::= <input InputOptions>
FormElement ::= <select>Selections</select>
Selections ::= Selection Selections
Selections ::=
Selection ::= <option value="Name">Element</option>**
```

### SQL：

[CS1120: Schemer's Guide to SQL](https://web.eecs.umich.edu/~weimerw/2012-1120F/guides/sql.html)

```jsx
Commands ::= Command ; Commands
Commands ::= Command
Command ::= CreateTableCommand | InsertCommand | SelectCommand | UpdateCommand | DeleteCommand | DropTableCommand
CreateTable ::= CREATE TABLE Name (FieldDefinitions)
InsertCommand ::= INSERT INTO Table ( FieldNames ) VALUES (Values)
DeleteCommand ::= DELETE FROM Table WhereClause
SelectCommand ::= SELECT Fields FROM Table JoinClause WhereClause OrderClause
UpdateCommand ::= UPDATE Table SET SetList WhereClause
DropTable ::= DROP TABLE Table

CreateTable ::= CREATE TABLE Name (FieldDefinitions)
FieldDefininitions::= FieldDefintion, FieldDefinitions
FieldDefinitions ::= FieldDefinition
FieldDefinition ::= FieldName FieldType PrimaryModifier UniqueModifier NullModifier IncrementModifier
PrimaryModifier ::= PRIMARY KEY
PrimaryModifier ::=
UniqueModifier ::= UNIQUE
UniqueModifier ::=
NullModifier ::= NOT NULL | NULL
NullModifier ::=
OptIncrement ::= AUTO_INCREMENT
OptIncrement ::=
FieldType ::= DATE | TIME | DATETIME | INT | FLOAT | VARCHAR (Number) | TEXT
FieldName ::= Name
FieldName ::= Table.Name
Table ::= name of a table

InsertCommand ::= INSERT INTO Table ( FieldNames ) VALUES (Values)
Values ::= Value Values
Values ::= Value ::= Number | String | Date | Boolean
FieldNames ::= FieldName , FieldNames
FieldNames ::= FieldName

DeleteCommand ::= DELETE FROM Table WhereClause
WhereClause ::= WHERE Conditions
WhereClause ::=
Conditions ::= Condition Conjunction Conditions
Conditions ::= Condition
Conjunction ::= AND | OR
Condition ::= Field Comparator Value
Comparator ::= < | > | = | <= | >=

SelectCommand ::= SELECT FieldSpecifier FROM Table JoinClause WhereClause OrderClause
FieldSpecifier ::= Fields Fields ::= Field, Fields
Fields ::= FieldModifier Field
Fields ::= *
Field ::= name of a field in the table AS Name
Field ::= name of a field in the table
FieldSpecifier ::= Operator ( Fields ) AS Name
Operator ::= AVG | COUNT | MIN | MAX | SUM
FieldModifier ::= DISTINCT
FieldModifier ::=
JoinClause ::= INNER JOIN Table ON expandedField = expandedField
JoinClause ::=
OrderClause ::= ORDER BY Field Descending
Descending ::= DESC
Descending ::=

UpdateCommand ::= UPDATE Table SET SetList WhereClause
SetList ::= Set, SetList
SetList ::=
Set ::= Field = Value

DropTable ::= DROP TABLE Table
```

### Java

[CS1120: Schemer's Guide to Java](https://web.eecs.umich.edu/~weimerw/2012-1120F/guides/java.html)