SELECT USER
FROM DUAL;
--==>>SCOTT

--■■■ FUNCTION(함수) ■■■--

-- 1. 함수란 하나 이상의 PL/SQL 문으로 구성된 서브 루틴으로
--    코드를 다시 사용할 수 있도록 캡슐화 하는데 사용된다.
---   오라클에서는 오라클에 정의된 기본 제공 함수를 사용하거나
--    직접 스토어드 함수를 만들 수 있다.(→ 사용자 정의 함수)
--    이 사용자 정의 함수는 시스템 함수처럼 쿼리에서 호출하거나
--    저장 프로시저처럼 EXECUTE 문을 통해 실행할 수 있다.



-- 2. 형식 및 구조
/*
CREATE [OR REPLACE] FUNCTION 함수명
[(매개변수명 1 자료형
,  매개변수명2 자료형
)]

RETURN 데이터타입
IS
    -- 주요 변수 선언

BEGIN
    -- 실행문;
    ...
    RETURN (값);
    
    [EXCEPTION]
        -- 예외 처리 구문;

-- END;

*/

--※ 사용자 정의 함수 (스토어드 함수)는
--   IN 파라미터(입력 매개변수)만 사용할 수 있으며
--   반드시 반환될 값의 데이터타입을 RETURN 문에 선언해야 하고,
--   FUNCTION 은 반드시 단일 값만 반환한다.


--○ TBL_INSA테이블 을 대상으로
--  주민번호를 가지고 성별을 조회한다.

SELECT NAME, SSN, DECODE(SUBSTR(SSN,8,1),1,'남자',2,'여자','확인불가')"성별"
FROM TBL_INSA;

--○ FUNCTION 정의 (생성)
--  함수명 : FN_GENGER()
--                    ↑ SSN(주민번호) → 'YYMMDD-NNNNNNN'

CREATE OR REPLACE FUNCTION FN_GENDER(
    VSSN VARCHAR2
)
RETURN VARCHAR2
IS
    --주요 변수 선언
    VRESULT VARCHAR2(20);
BEGIN
    --연산 및 처리
    IF (SUBSTR(VSSN,8,1) IN (1,3))
        THEN VRESULT :='남자';
    ELSIF (SUBSTR(VSSN,8,1) IN (2,4))
        THEN VRESULT := '여자';
    ELSE
        VRESULT := '성별확인불가';
    END IF;
    
    --최종 결과값 반환
    RETURN VRESULT;
END;
--==>>Function FN_GENGER이(가) 컴파일되었습니다.

--○ 임의의 정수 두 개를 매개변수 (입력 파라미터)로 넘겨받아
--  A 의 B승의 값을 반환하는 사용자 정의 함수를 만든다.
--함수명 : FN_POW()
/*
사용예
SELECT FN_POW(10,3)
FROM DUAL;
*/


CREATE OR REPLACE FUNCTION FN_POW(
    N1 NUMBER,
    N2 NUMBER

)
RETURN NUMBER
IS
    RESULT NUMBER :=1;      --누적곱
    I NUMBER;
BEGIN

    IF N2>0
       THEN 
            FOR I IN 1..N2 LOOP
                RESULT := RESULT*N1;
            END LOOP;
            
    ELSIF N2=0
        THEN 
            RESULT := 1;
            
    ELSE
            FOR I IN N2 .. -1 LOOP
                RESULT := RESULT/N1;
            END LOOP;
            
    END IF;
    
    RETURN RESULT;
END;
--==>>Function FN_POW이(가) 컴파일되었습니다

--○ TBL_INSA 테이블의 급여 계산 정용 함수 정의 한다.
--  급여는 (기본급*12) + 수당 기반으로 연산을 수행한다.
--  함수명 : FN_PAY(기본급, 수당)

--○ TBL_INSA 테이블의 입사일을 기준으로 
--  현재까지의 근무년수를 반환하는 함수를 정의한다.
--  단, 근부년수는 소숫점 이하 한자리까지 계산한다.
--  함수명 : FN_WORKYEAR(입사일)


CREATE OR REPLACE FUNCTION FN_PAY(
    VBASICPAY NUMBER,
    VSUDANG NUMBER
)
RETURN NUMBER
IS
    VRESULT NUMBER;
BEGIN
    VRESULT := VBASICPAY*12 + VSUDANG;
    
    RETURN VRESULT;
    
END;


--○ TBL_INSA 테이블의 입사일을 기준으로 
--  현재까지의 근무년수를 반환하는 함수를 정의한다.
--  단, 근부년수는 소숫점 이하 한자리까지 계산한다.
--  함수명 : FN_WORKYEAR(입사일)

ALTER SESSION SET NLS_DATE_FORMAT ='YYYY-MM-DD';

CREATE OR REPLACE FUNCTION FN_WORKYEAR(
    VHIREDATE DATE
)
RETURN NUMBER
IS
    VYEAR NUMBER := 0;
BEGIN
    VYEAR := TRUNC((SYSDATE-VHIREDATE)/365,1);
    
    RETURN VYEAR;
END;

--------------------------------------------------------------------------------
--(* TRUNCATE 레코드를 잘라내서 삭제해 버리는 구문)



--※ 참고


-- 1. INSERT, UPDATE, DELETE, (MERGE)
--==>> DML(Data Manipulation Language)
-- COMMIT / ROLLBACK 이 필요하다.



-- 2. CREATE, DROP, ALTER, (TRUNCATE)
--==>> DDL(Data Definition Language)
-- 실행하면 자동으로 COMMIT 된다.




-- 3. GRANT, REVOKE
--==>> DCL(Data Control Language)
-- 실행하면 자동으로 COMMIT 된다.


-- 4. COMMIT, ROLLBACK
--==>> TCL(Transaction Control Language)


-- 정적 pl/sql 문 → DML문, TCL문만 사용 가능하다.
-- 동적 pl/sql 문 → DML문, DDL문, DCL문, TCL문 사용 가능하다.

--※ 정적 SQL(정적 PL/SQL)
-- 기본적으로 사용하는 SQL 구문과
-- PL/SQL 구문안에 SQL 구문을 직접 삽입하는 방법
--  작성이 쉽고 성능이 좋다



--------------------------------------------------------------------------------

-- 프로시저 : 리턴 자료형이 VOID인 메소드와 비슷하다.
-- 매개변수를 받지 않더라도 호출한 자리에 연산 결과값을 두고 간다.
-- 내부적인 처리 일어난 후... 

-- 오라클에서 정의하는 함수는 RETURN 자료형이 없는 함수가 없다.
-- 입력 파라미터, 출력용 파라미터, 입출력 파라미터를 다 쓸 수 있도록 구성.

-- 함수 내부에서 절차적으로 진행하는 것이 중요하므로 프로시저 저으이.
-- 절차적으로 진행하지 않으면 문제가 발생할 수 있으므로 안에다 묶어 놓는 개념...


--■■■ PROCEDURE(프로시저) ■■■--



-- 1. PL/SQL 에서 가장 대표적인 구조인 스토어드 프로시저는
--    개발자가 자주 작성해야 하는 업무의 흐름을
--    미리 작성하여 데이터베이스 내에 저장해 두었다가
--    필요할 떄마다 호출하여 실행할 수 있도록 처리해 주는 구문이다.



-- 2. 형식 및 구조
/*
CREATE [OR REPLACE] PROCEDURE 프로시저명
[( 매개변수 IN    데이터타입
,  매개변수 OUT   데이터타입
,  매개변수 INOUT 데이터타입
)]
IS
    [-- 주요 변수 선언]
BEGIN
    -- 실행 구문;
    ...
    
    [EXCEPTION
        -- 예외 처리 구문;]
END;

*/

--※ FUNCTION 과 비교했을 때 『RETURN 반환자료형』 부분이 존재하지 않으며,
--   『RETURN』문 자체도 존재하지 않고,
--   프로시저 실행 시 넘겨주게 되는 매개변수의 종류는
--   IN(입력), OUT(출력), INOUT(입출력)으로 구분된다.




-- 3. 실행(호출)
/*
EXE[CUTE] 프로시저명[(인수1, 인수2, ...)];
*/


--○ INSERT 프로시저

--실습 테이블 생성
--  테이블 명 : TBL_STUDUNTS → 20241204_02_scott.sql
--  테이블 명 : TBL_IDTW → 20241204_02_scott.sql

--프로시저 생성
--프로시저 명 : PRC_STUDENTS_INSERT(아이디,패스워드,이름,전화번호,주소)
CREATE OR REPLACE PROCEDURE PRC_STUDENTS_INSERT
(
V_ID        IN TBL_IDPW.ID%TYPE
,V_PW       IN TBL_IDPW.PW%TYPE       
,V_NAME     IN TBL_STUDENTS.NAME%TYPE
,V_TEL      IN TBL_STUDENTS.TEL%TYPE
,V_ADDR     IN TBL_STUDENTS.ADDR%TYPE
)
IS
BEGIN
    --TBL_IDPW테이블에 데이터 입력
    INSERT INTO TBL_IDPW(ID,PW)
    VALUES(V_ID,V_PW);
    
    --TBL_STUDENTS테이블에 데이터입력
    INSERT INTO TBL_STUDENTS(ID,NAME,TEL,ADDR)
    VALUES (V_ID,V_NAME,V_TEL,V_ADDR);
    
    --커밋
    COMMIT;
END;

--==>>Procedure PRC_STUDENTS_INSERT이(가) 컴파일되었습니다


--○ 테이터 입력 시 특정 항목의 데이터만 입력하면
--  내부적으로 다른 항목이 함께 입력 처리될 수 있는 프로시저를 생성한다.
--프로시저 명 : PRC_SUNGJUK_INSERT

--실습테이블 생성
--  테이블 명 : TBL_SUNGJUK → 20241204_02_scott.sql

/*
실행예)
EXEC PRC_SUNGJUK_INSERT(1,'이은솔',90,80,70);

→ 프로시저 호출로 처리된 결과
학번  이름 국어점수     영어점수    수학점수    총점  평균  등급
*/

CREATE OR REPLACE PROCEDURE PRC_SUNGJUK_INSERT
(V_HAKBUN  IN TBL_SUNGJUK.HAKBUN%TYPE
,V_NAME    IN TBL_SUNGJUK.NAME%TYPE
,V_KOR     IN TBL_SUNGJUK.KOR%TYPE
,V_ENG     IN TBL_SUNGJUK.ENG%TYPE
,V_MAT     IN TBL_SUNGJUK.MAT%TYPE
)
IS
    --INSERT 
     V_TOT      TBL_SUNGJUK.TOT%TYPE;
     V_AVG      TBL_SUNGJUK.AVG%TYPE;
     V_GRADE    TBL_SUNGJUK.GRADE%TYPE;
BEGIN
    V_TOT := V_KOR + V_ENG + V_MAT;
    V_AVG := V_TOT/3;
    IF V_AVG>=90
        THEN V_GRADE :='A';
    ELSIF V_AVG>=80
        THEN V_GRADE :='B';
    ELSIF V_AVG>=70
        THEN V_GRADE := 'C';
    ELSIF V_AVG>=60
        THEN V_GRADE :='E';
    ELSE
        V_GRADE :='F';
    END IF;
    
    INSERT INTO TBL_SUNGJUK(HAKBUN,NAME,KOR,ENG,MAT,TOT,AVG,GRADE)
    VALUES(V_HAKBUN,V_NAME,V_KOR,V_ENG,V_MAT,V_TOT,V_AVG,V_GRADE);
    
    
    
    
    
    COMMIT;
END;  


--○ TBL_SUNGJUK 테이블 에서
--  특정 학생의 점수(학번, 국어점수, 영어 점수, 수학점수)
--  데이터 수정 시 총점 ,평균, 등급까지 수정하는 프로시저를 작성한다.
--  프로시저명 : PRC_SUNGJUK_UPDATE




CREATE OR REPLACE PROCEDURE PRC_SUNGJUK_UPDATE
(
V_HAKBUN   IN TBL_SUNGJUK.HAKBUN%TYPE
,V_KOR     IN TBL_SUNGJUK.KOR%TYPE
,V_ENG     IN TBL_SUNGJUK.ENG%TYPE
,V_MAT     IN TBL_SUNGJUK.MAT%TYPE
)
IS 
    --UPDATE쿼리문을 수행하는데 필요한 주요 변수 선언
   -- V_TOT TBL_SUNGJUK.TOT%TYPE;
    --V_AVG TBL_SUNGJUK.AVG%TYPE;
   -- V_GRADE TBL_SUNGJUK.GRADE%TYPE;
BEGIN
    UPDATE TBL_SUNGJUK
    SET KOR = V_KOR, ENG = V_ENG, MAT =V_MAT,
            TOT = V_KOR + V_ENG + V_MAT,
            AVG = (V_KOR+ V_ENG + V_MAT)/3,
            GRADE = CASE WHEN AVG>=90
                            THEN 'A'
                            WHEN AVG>=80
                            THEN 'B'
                            WHEN AVG>=70
                            THEN  'C'
                            WHEN AVG>=60
                            THEN 'E'
                            ELSE
                                'F'
                        END
            WHERE HAKBUN = V_HAKBUN;
            
            COMMIT;
END;    


--○ TBL_SUTDENTS테이블에서
--  전화번호와 주소 데이터를 수정하는(변경하는) 프로시저를 작성한다.
--  단, ID와  PW 가 일치하는 경우에만 수정을 진행할 수 있도록 처리한다.
--프로시저명 : PRC_STUDENTS_UPDATE
/*
실행예)
EXEC PRC_STUDENTS_UPDATE('superman','java007$','010-1212-3434','인천 서구');

→ 프로시저 호출로 처리된 결과
superman 정영훈 010-1111-1111 제주도 서귀포시

EXEC PRC_STUDENTS_UPDATE('superman','java006$','010-1212-3434','인천 서구');

→ 프로시저 호출로 처리된 결과
superman 정영훈 010-1212-3434 인천 서구
*/

SELECT *
FROM TBL_IDPW;

SELECT *
FROM TBL_STUDENTS;

CREATE OR REPLACE PROCEDURE PRC_STUDENTS_UPDATE
(V_ID       TBL_IDPW.ID%TYPE
,V_PW       TBL_IDPW.PW%TYPE
,V_TEL      TBL_STUDENTS.TEL%TYPE
,V_ADDR     TBL_STUDENTS.ADDR%TYPE
)
IS
BEGIN
    
    UPDATE (SELECT I.ID,I.PW,S.TEL,S.ADDR
            FROM TBL_STUDENTS S JOIN TBL_IDPW I
            ON S.ID = I.ID)T
    SET T.TEL =V_TEL, ADDR = V_ADDR
    WHERE T.ID = V_ID  AND T.PW = V_PW; 
    

    COMMIT;
    
END;  



CREATE OR REPLACE PROCEDURE PRC_STUDENTS_UPDATE
(V_ID       TBL_IDPW.ID%TYPE
,V_PW       TBL_IDPW.PW%TYPE
,V_TEL      TBL_STUDENTS.TEL%TYPE
,V_ADDR     TBL_STUDENTS.ADDR%TYPE
)
IS

BEGIN
    

        UPDATE TBL_STUDENTS
        SET TEL = V_TEL, ADDR = V_ADDR
        WHERE V_ID = ID AND (SELECT PW
                            FROM TBL_IDPW
                            WHERE PW = V_PW) = V_PW;
    

    COMMIT;
    
END;    

--------------------------------------------------------------------------------

--○ TBL_INSA 테이블을 대상으로 데이터를 입력하는 프로시저를 작성한다.
--  NUM,NAME,SSN, IBSADATE,CITY,TEL,BESEO,JIKWI,BASICPAY,SUDANG
--  구조를 갖고 있는 대상 테이블에 데이터 입력 시
--  NUM항목(사원번호)의 값은
--  기존 부여된 사원번호 마지막 번호의 그 다음 번호를
--  자동으로 입력 처리할 수 있는 프로시저로 구성한다
-- 프로시저명 : PRC_INSA_INSERT(NAME,SSN,IBSADATE,CITY, TEL,BUSEO,JIKWI,BASICPAY,SUDANG);
/*
실행예)
EXEC PRC_INSA_INSERT('안예지','980716-2234567','SYSDATE','서울','010-5555-5555','영업부','대리',500000,500000);

→ 프로시저 호출로 처리된 결과
1061 안예지 980716-2234567 2024-12-03 서울 010-5555-5555 영업부 500000 500000
*/


CREATE OR REPLACE PROCEDURE PRC_INSA_INSERT(
V_NAME      TBL_INSA.NAME%TYPE,
V_SSN       TBL_INSA.SSN%TYPE,
V_IBSADATE  TBL_INSA.IBSADATE%TYPE,
V_CITY      TBL_INSA.CITY%TYPE,
V_TEL       TBL_INSA.TEL%TYPE,
V_BUSEO     TBL_INSA.BUSEO%TYPE,
V_JIKWI     TBL_INSA.JIKWI%TYPE,
V_BASICPAY  TBL_INSA.BASICPAY%TYPE,
V_SUDANG    TBL_INSA.SUDANG%TYPE
) 
IS
    V_NUM TBL_INSA.NUM%TYPE;
    
BEGIN
     SELECT MAX(NUM)+1 INTO V_NUM FROM TBL_INSA;
     --V_NUM := (SELECT MAX(NUM) FROM TBL_INSA)+1;
    
    INSERT INTO TBL_INSA(NUM,NAME,SSN, IBSADATE,CITY,TEL,BUSEO,JIKWI,BASICPAY,SUDANG)
    VALUES(V_NUM,V_NAME,V_SSN,V_IBSADATE,V_CITY,V_TEL,V_BUSEO,V_JIKWI,V_BASICPAY,V_SUDANG);
    
    COMMIT;
    
END;

--> 유효하지 한 패스워드를 입력했을 경우
EXEC PRC_STUDENTS_UPDATE('superman','java006$','010-2762-1916','인천계양구'); 

SELECT *
FROM TBL_STUDENTS;
--==>>
/*
superman	정영훈	010-2762-1916	인천계양구
happyday	곽유진	010-2222-2222	서울 마포구
happytest	엄서연	010-3333-3333	서울 종로구

*/


EXEC PRC_INSA_INSERT('안예지','980716-2234567',SYSDATE,'서울','010-5555-5555','영업부','대리',500000,500000);

SELECT *
FROM TBL_INSA
WHERE NAME = '안예지';
--------------------------------------------------------------------------------
--○ 실습 테이블 생성
--테이블명 : (TBL_상품)
CREATE TABLE TBL_상품
(상품코드  VARCHAR2(20)
,상품명    VARCHAR2(100)
,소비자가격 NUMBER
,재고수량   NUMBER DEFAULT 0
,CONSTRAINT 삼품_상품코드_PK PRIMARY KEY (상품코드)
);
--==>>Table TBL_상품이(가) 생성되었습니다

--○ 실습 테이블 생성
--  테이블명 : TBL_입고
CREATE TABLE TBL_입고
(입고번호  NUMBER
,상품코드   VARCHAR2(20)
,입고일자   DATE  DEFAULT SYSDATE
,입고수량   NUMBER
,입고단가   NUMBER
,CONSTRAINT 입고_입고번호_PK PRIMARY KEY(입고번호)
,CONSTRAINT 입고_상품코드_FK FOREIGN KEY(상품코드)
                REFERENCES TBL_상품(상품코드)
);
--==>>Table TBL_입고이(가) 생성되었습니다

-- TBL_입고 테이블의 입고번호를 기본키(PK) 제약조건 설정
--  

--○ 데이터 입력
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('H001','홈런볼',1500);
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('H002','새우깡',1200);
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('H003','스윙칩',1000);
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('H004','치토스',1100);
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('H005','밭두렁',1000);
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('H006','오감자',2000);
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('H007','양파링',1700);
--==>>1 행 이(가) 삽입되었습니다. *7

INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('C001','초코칩',1800);
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('C002','버터링',1900);
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('C003','에이스',1700);
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('C004','오레오',2200);
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('C005','다이젠',2500);
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('C006','아이비',1200);
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('C007','오예스',3500);

INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('E001','마이쮸',1000);
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('E002','엠엔엠',1100);
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('E003','아이셔',1100);
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('E004','비틀즈',1200);
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('E005','아폴로',1000);
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('E006','새콜달',1500);
INSERT INTO TBL_상품(상품코드,상품명,소비자가격)
VALUES('E007','말랑카',1600);

SELECT *
FROM TBL_상품;
--==>>
/*
H001	홈런볼	1500	0
H002	새우깡	1200	0
H003	스윙칩	1000	0
H004	치토스	1100	0
H005	밭두렁	1000	0
H006	오감자	2000	0
H007	양파링	1700	0
C001	초코칩	1800	0
C002	버터링	1900	0
C003	에이스	1700	0
C004	오레오	2200	0
C005	다이젠	2500	0
C006	아이비	1200	0
C007	오예스	3500	0
E001	마이쮸	1000	0
E002	엠엔엠	1100	0
E003	아이셔	1100	0
E004	비틀즈	1200	0
E005	아폴로	1000	0
E006	새콜달	1500	0
E007	말랑카	1600	0
*/

COMMIT;
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
    
    COMMIT;
END;


