--○ 테이블 생성
CREATE TABLE TBL_MEMBER
(NUM    NUMBER
,NAME   VARCHAR2(30)
,TEL    VARCHAR2(60)
,CITY   VARCHAR2(60)
,CONSTRAINT TBL_MEMBER_PK PRIMARY KEY (NUM)
);

SELECT *
FROM TBL_MEMBER;

--○ TBL_상품, TBL_입고 테이블을 대상으로
--  TBL_입고 테이블에 데이터 입력 시(즉 , 입고 이벤트 발생 시)

--  TBL_상품 테입르 해당 상품의 재고수량이 함께 변동될 수 있는 기능을 가진
--  프로시저를 작성한다.
--  단, 이 과정에서 입고번호는 자동 증가 처리한다.(시퀀스 사용 X)
--  TBL_입고 테이블 구성 컬럼
--  → 입고번호, 상품코드, 입고일자, 입고수량, 입고단가
--  프로시저명 : PRC_입고_INSERT(상품코드,입고수량,입고단가)

--※ TBL_입고 테이블에  입고 이벤트 발생 시...
--  관련 테이블에서 수행되어야 하는 내용
--  ① INSERT → TBL_입고
--     INSERT INTO TBL_입고 (입고번호, 상품코드,입고일자,입고수량,입고단가)
--     VALUES(1,'H001',SYSDATE,20,1000);
--  ② UPDATE → TBL_상품
--     UPDATE TBL_상품
--     SET 재고수량 = 기존재고수량 + 20(← 입고수량)
--     WHERE 상품코드='H001';


SELECT *
FROM TBL_입고;

DESC TBL_입고;

SELECT *
FROM TBL_상품;

CREATE OR REPLACE PROCEDURE PRC_입고_INSERT
(V_상품코드       TBL_상품.상품코드%TYPE
,V_입고수량       TBL_입고.입고수량%TYPE
,V_입고단가       TBL_입고.입고단가%TYPE
)
IS
    --아래의 쿼리문을 수행하기 위해 필요한 데이터 변수로 추가 선언
    V_입고번호 TBL_입고.입고번호%TYPE ;
BEGIN
    --선언한 변수 (V_입고번호)에 값 담아내기
    SELECT NVL(MAX(입고번호),0)+1 INTO V_입고번호
    FROM TBL_입고;
    
    --결과값이 NULL이 나옴
    --SELECT MAX(NVL(입고번호,0))+1 INTO V_입고번호
    --FROM TBL_입고;
    
    --쿼리문 작성
    --①INSERT문
    INSERT INTO TBL_입고 (입고번호,상품코드,입고수량,입고단가)
    VALUES(V_입고번호,V_상품코드,V_입고수량,V_입고단가);
    
    --②UPDATE문
    UPDATE TBL_상품
    SET 소비자가격 = V_입고단가, 재고수량 = V_입고수량 + 재고수량
    WHERE V_상품코드 = 상품코드;
    
    --커밋
    COMMIT;
    
    --예외처리
    EXCEPTION 
        WHEN OTHERS THEN ROLLBACK; 
        
    
END;
--==>>Procedure PRC_입고_INSERT이(가) 컴파일되었습니다

--○ 생성한 프로시저(PRC_MEMBER_INSERT)가 제댜로 작동하는지의 여부 확인
--  → 프로시저 호출
--EXEC PRC_MEMBER_INSERT(이름, 전화번호,지역)
EXEC PRC_MEMBER_INSERT('박제훈','010-1111-1111','서울');
--==>>PL/SQL 프로시저가 성공적으로 완료되었습니다

EXEC PRC_MEMBER_INSERT('정승민','010-2222-2222','인천');
--==>>PL/SQL 프로시저가 성공적으로 완료되었습니다

EXEC PRC_MEMBER_INSERT('안예지','010-3333-3333','경기');
--==>>PL/SQL 프로시저가 성공적으로 완료되었습니다

SELECT *
FROM TBL_MEMBER;
--==>>
/*
1	박제훈	010-1111-1111	서울
2	정승민	010-2222-2222	인천
3	안예지	010-3333-3333	경기
*/

--------------------------------------------------------------------------------
CREATE TABLE TBL_출고
(출고번호       NUMBER
,상품코드       VARCHAR2(20)
,출고일자       DATE       DEFAULT SYSDATE
,출고수량       NUMBER
,출고단가       NUMBER
);
--==>>Table TBL_출고이(가) 생성되었습니다

--○ TBL_출고 테이블의 출고번호에 PK제약조건 지정
ALTER TABLE TBL_출고
ADD CONSTRAINT 출고_출고번호_PK PRIMARY KEY (출고번호);
--==>>Table TBL_출고이(가) 변경되었습니다


--○ TBL_출고 테이블의 상품코드는 TBL_상품 테이블의 상품코드를
--  참조할 수 있도록 외래키(FK) 제약조건 지정
ALTER TABLE TBL_출고
ADD CONSTRAINT 출고_상품코드_FK FOREIGN KEY(상품코드)
                    REFERENCES TBL_상품(상품코드);
--==>>Table TBL_출고이(가) 변경되었습니다

--○ TBL_출고 테블에 데이터 입력 시(즉, 풀고 이벤트 발생 시)
--  TBL_상품 데이블의 해당 상품의 재고수량이 변동될 수 있는 프로시저를 작성한다.
--  단,출고번호는 입고번호와 마찬가지로 자동 증가
--  또한, 출고 수향이 재고수량보다 많은 경우...
--  출고 액션이 처리되지 않도록 구성한다.(출고가 이루어지지 않도록...)
--  프로시저 명 : PRC_출고_INSERT(상품코드,출고수량,출고단가)

SELECT *
FROM TBL_출고;

SELECT *
FROM TBL_상품;

CREATE OR REPLACE PROCEDURE PRC_출고_INSERT(
V_상품코드       IN TBL_상품.상품코드%TYPE
,V_출고수량      IN TBL_출고.출고수량%TYPE
,V_출고단가      IN TBL_출고.출고단가%TYPE
)
IS
    V_출고번호 TBL_출고.출고번호%TYPE;
    USER_DEFINE_ERROR EXCEPTION;
    V_재고수량 TBL_상품.재고수량%TYPE;
    
BEGIN
    
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE V_상품코드 = 상품코드;
    
    IF V_재고수량 < V_출고수량
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    SELECT NVL(MAX(출고번호),0)+1 INTO V_출고번호
    FROM TBL_출고;
    
    INSERT INTO TBL_출고 (출고번호,상품코드,출고수량,출고단가)
    VALUES(V_출고번호,V_상품코드,V_출고수량,V_출고단가);
    
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 - V_출고수량
    WHERE 상품코드 = V_상품코드;
    
    COMMIT;
    --예외처기
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001,'출고수량이 재고수량을 넘었습니다.');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    

END;



--○ TBL_출고 테이블에서 출고 수량을 변경(수정)하는 프로시저를 작성한다.
--   프로시저명 : PRC_출고_UPDATE(출고번호,변경할수량)

SELECT *
FROM TBL_출고;

SELECT *
FROM TBL_상품;

CREATE OR REPLACE PROCEDURE PRC_출고_UPDATE(

    --① 매개변수 구성
    V_출고번호      IN TBL_출고.출고번호%TYPE
,   V_변경할수량    IN TBL_출고.출고수량%TYPE
)
IS
    V_재고수량 TBL_상품.재고수량%TYPE;
    V_상품코드 TBL_출고.상품코드%TYPE;
    V_출고수량 TBL_출고.출고수량%TYPE;
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN
    
    SELECT 상품코드 INTO V_상품코드
    FROM TBL_출고
    WHERE V_출고번호 = 출고번호;
    
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE V_상품코드 = 상품코드;  
    
    SELECT 출고수량 INTO V_출고수량
    FROM TBL_출고
    WHERE 출고번호 =V_출고번호;
    
    

    IF (V_재고수량+ V_출고수량)<V_변경할수량
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    --② 수행 쿼리문 구성
    --UPDATE → TBL_출고
    UPDATE TBL_출고
    SET 출고수량 = V_변경할수량
    WHERE 출고번호 = V_출고번호;
    
    --UPDATE → TBL_상품
    UPDATE TBL_상품
    SET 재고수량 =(V_재고수량+ V_출고수량)-V_변경할수량
    WHERE 상품코드 = V_상품코드;
    
    COMMIT;
    
    --예외처리
    EXCEPTION 
        WHEN   USER_DEFINE_ERROR
            THEN   RAISE_APPLICATION_ERROR(-20003,'재고부족');
                    ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;



EXEC PRC_출고_DELETE(1);
--◎ TBL_입고 테이블에서 입고수량을 수정(변경)하는 프로시자를 작성한다.
--  프로시저명 :PRC_입고_UPDATE(입고번호,변경할수량)

CREATE OR REPLACE PROCEDURE PRC_입고_UPDATE
(V_입고번호      IN TBL_입고.입고번호%TYPE
,V_변경할수량    IN TBL_입고.입고수량%TYPE
)
IS
    --③변수선언 → V_상품코드
    V_상품코드 TBL_상품.상품코드%TYPE;
    --⑤변수선언 → V_재고수량
    V_재고수량 TBL_상품.재고수량%TYPE;
    --⑥변수선언 → V_입고수량
    V_입고수량 TBL_입고.입고수량%TYPE;
     --⑨변수선언 
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    
    --④변수값 대입 → V_상품코드
    SELECT 상품코드 INTO V_상품코드
    FROM TBL_입고
    WHERE 입고번호 = V_입고번호;
    
    --⑦변수값 대입 → V_재고수량
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE V_상품코드 = 상품코드;
    
    --⑧변수값 대입 → V_입고수량
    SELECT 입고수량 INTO V_입고수량
    FROM TBL_입고
    WHERE V_입고번호 = 입고번호;
    
    --⑩예외처리 발생
    IF (V_재고수량 - V_입고수량) <0
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    
    --①쿼리문 작성 → UPDATE TBL_입고
    UPDATE TBL_입고
    SET 입고수량 = V_변경할수량
    WHERE V_입고번호 =입고번호;
    
    --②쿼리문 작성 → UPDATE TBL_상품
    UPDATE TBL_상품
    SET 재고수량 = V_재고수량 -  V_입고수량 + V_변경할수량
    WHERE V_상품코드 = 상품코드;
    
    --커밋
    COMMIT;
    
     --⑪예외처리
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001,'오류');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
    
END;



--◎ TBL_출고 테이블에서 출고수량을 삭제하는 프로시자를 작성한다.
--  프로시저명 :PRC_출고_DELETE(출고번호) 

CREATE OR REPLACE PROCEDURE PRC_출고_DELETE
(V_출고번호     IN TBL_출고.출고번호%TYPE
)
IS
    --③변수선언 → V_상품코드
    V_상품코드 TBL_상품.상품코드%TYPE;
    --⑤변수선언 → V_재고수량
    V_재고수량 TBL_상품.재고수량%TYPE;
    --⑥변수선언 → V_입고수량
    V_출고수량 TBL_출고.출고수량%TYPE;
    
BEGIN

    --④변수값 대입 → V_상품코드
    SELECT 상품코드 INTO V_상품코드
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    
    --⑦변수값 대입 → V_재고수량
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE V_상품코드 = 상품코드;
    
    --⑧변수값 대입 → V_입고수량
    SELECT 출고수량 INTO V_출고수량
    FROM TBL_출고
    WHERE V_출고번호 = 출고번호;
    
    --①쿼리문 작성 → DELETR TBL_출고
    DELETE
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    
    --②쿼리문 작성 → UPDATE TBL_상품
    UPDATE TBL_상품
    SET 재고수량 = V_재고수량 +  V_출고수량 
    WHERE V_상품코드 = 상품코드;
    
     --커밋
    COMMIT;
    
    --⑨예외처리
    EXCEPTION
        WHEN OTHERS
            THEN ROLLBACK;
    
END;


--◎ TBL_입고 테이블에서 입고수량을 삭제하는 프로시자를 작성한다.
--  프로시저명 :PRC_입고_DELETE(입고번호)

CREATE OR REPLACE PROCEDURE PRC_입고_DELETE
(V_입고번호     IN TBL_입고.입고번호%TYPE
)
IS
    --③변수선언 → V_상품코드
    V_상품코드 TBL_상품.상품코드%TYPE;
    --⑤변수선언 → V_재고수량
    V_재고수량 TBL_상품.재고수량%TYPE;
    --⑥변수선언 → V_입고수량
    V_입고수량 TBL_입고.입고수량%TYPE;
    --⑨변수선언 
    USER_DEFINE_ERROR EXCEPTION;
    MAX             NUMBER;

    
BEGIN

    --④변수값 대입 → V_상품코드
    SELECT 상품코드 INTO V_상품코드
    FROM TBL_입고
    WHERE 입고번호 = V_입고번호;
    
    --⑦변수값 대입 → V_재고수량
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE V_상품코드 = 상품코드;
    
    --⑧변수값 대입 → V_입고수량
    SELECT 입고수량 INTO V_입고수량
    FROM TBL_입고
    WHERE V_입고번호 = 입고번호;
    
    SELECT MAX(입고번호) INTO MAX
    FROM TBL_입고;
    
    --⑩예외처리 발생
    IF V_입고번호 NOT BETWEEN 1 AND MAX 
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    IF (V_재고수량 - V_입고수량) <0
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    
    
    --①쿼리문 작성 → DELETR TBL_입고
    DELETE
    FROM TBL_입고
    WHERE 입고번호 = V_입고번호;
    
    --②쿼리문 작성 → UPDATE TBL_상품
    UPDATE TBL_상품
    SET 재고수량 = V_재고수량 -  V_입고수량 
    WHERE V_상품코드 = 상품코드;
    
     --커밋
    COMMIT;
    
    --⑪예외처리
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001,'오류');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
    
END;
