SELECT USER
FROM DUAL;
--==>>SCOTT

--���� FUNCTION(�Լ�) ����--

-- 1. �Լ��� �ϳ� �̻��� PL/SQL ������ ������ ���� ��ƾ����
--    �ڵ带 �ٽ� ����� �� �ֵ��� ĸ��ȭ �ϴµ� ���ȴ�.
---   ����Ŭ������ ����Ŭ�� ���ǵ� �⺻ ���� �Լ��� ����ϰų�
--    ���� ������ �Լ��� ���� �� �ִ�.(�� ����� ���� �Լ�)
--    �� ����� ���� �Լ��� �ý��� �Լ�ó�� �������� ȣ���ϰų�
--    ���� ���ν���ó�� EXECUTE ���� ���� ������ �� �ִ�.



-- 2. ���� �� ����
/*
CREATE [OR REPLACE] FUNCTION �Լ���
[(�Ű������� 1 �ڷ���
,  �Ű�������2 �ڷ���
)]

RETURN ������Ÿ��
IS
    -- �ֿ� ���� ����

BEGIN
    -- ���๮;
    ...
    RETURN (��);
    
    [EXCEPTION]
        -- ���� ó�� ����;

-- END;

*/

--�� ����� ���� �Լ� (������ �Լ�)��
--   IN �Ķ����(�Է� �Ű�����)�� ����� �� ������
--   �ݵ�� ��ȯ�� ���� ������Ÿ���� RETURN ���� �����ؾ� �ϰ�,
--   FUNCTION �� �ݵ�� ���� ���� ��ȯ�Ѵ�.


--�� TBL_INSA���̺� �� �������
--  �ֹι�ȣ�� ������ ������ ��ȸ�Ѵ�.

SELECT NAME, SSN, DECODE(SUBSTR(SSN,8,1),1,'����',2,'����','Ȯ�κҰ�')"����"
FROM TBL_INSA;

--�� FUNCTION ���� (����)
--  �Լ��� : FN_GENGER()
--                    �� SSN(�ֹι�ȣ) �� 'YYMMDD-NNNNNNN'

CREATE OR REPLACE FUNCTION FN_GENDER(
    VSSN VARCHAR2
)
RETURN VARCHAR2
IS
    --�ֿ� ���� ����
    VRESULT VARCHAR2(20);
BEGIN
    --���� �� ó��
    IF (SUBSTR(VSSN,8,1) IN (1,3))
        THEN VRESULT :='����';
    ELSIF (SUBSTR(VSSN,8,1) IN (2,4))
        THEN VRESULT := '����';
    ELSE
        VRESULT := '����Ȯ�κҰ�';
    END IF;
    
    --���� ����� ��ȯ
    RETURN VRESULT;
END;
--==>>Function FN_GENGER��(��) �����ϵǾ����ϴ�.

--�� ������ ���� �� ���� �Ű����� (�Է� �Ķ����)�� �Ѱܹ޾�
--  A �� B���� ���� ��ȯ�ϴ� ����� ���� �Լ��� �����.
--�Լ��� : FN_POW()
/*
��뿹
SELECT FN_POW(10,3)
FROM DUAL;
*/


CREATE OR REPLACE FUNCTION FN_POW(
    N1 NUMBER,
    N2 NUMBER

)
RETURN NUMBER
IS
    RESULT NUMBER :=1;      --������
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
--==>>Function FN_POW��(��) �����ϵǾ����ϴ�

--�� TBL_INSA ���̺��� �޿� ��� ���� �Լ� ���� �Ѵ�.
--  �޿��� (�⺻��*12) + ���� ������� ������ �����Ѵ�.
--  �Լ��� : FN_PAY(�⺻��, ����)

--�� TBL_INSA ���̺��� �Ի����� �������� 
--  ��������� �ٹ������ ��ȯ�ϴ� �Լ��� �����Ѵ�.
--  ��, �ٺγ���� �Ҽ��� ���� ���ڸ����� ����Ѵ�.
--  �Լ��� : FN_WORKYEAR(�Ի���)


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


--�� TBL_INSA ���̺��� �Ի����� �������� 
--  ��������� �ٹ������ ��ȯ�ϴ� �Լ��� �����Ѵ�.
--  ��, �ٺγ���� �Ҽ��� ���� ���ڸ����� ����Ѵ�.
--  �Լ��� : FN_WORKYEAR(�Ի���)

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
--(* TRUNCATE ���ڵ带 �߶󳻼� ������ ������ ����)



--�� ����


-- 1. INSERT, UPDATE, DELETE, (MERGE)
--==>> DML(Data Manipulation Language)
-- COMMIT / ROLLBACK �� �ʿ��ϴ�.



-- 2. CREATE, DROP, ALTER, (TRUNCATE)
--==>> DDL(Data Definition Language)
-- �����ϸ� �ڵ����� COMMIT �ȴ�.




-- 3. GRANT, REVOKE
--==>> DCL(Data Control Language)
-- �����ϸ� �ڵ����� COMMIT �ȴ�.


-- 4. COMMIT, ROLLBACK
--==>> TCL(Transaction Control Language)


-- ���� pl/sql �� �� DML��, TCL���� ��� �����ϴ�.
-- ���� pl/sql �� �� DML��, DDL��, DCL��, TCL�� ��� �����ϴ�.

--�� ���� SQL(���� PL/SQL)
-- �⺻������ ����ϴ� SQL ������
-- PL/SQL �����ȿ� SQL ������ ���� �����ϴ� ���
--  �ۼ��� ���� ������ ����



--------------------------------------------------------------------------------

-- ���ν��� : ���� �ڷ����� VOID�� �޼ҵ�� ����ϴ�.
-- �Ű������� ���� �ʴ��� ȣ���� �ڸ��� ���� ������� �ΰ� ����.
-- �������� ó�� �Ͼ ��... 

-- ����Ŭ���� �����ϴ� �Լ��� RETURN �ڷ����� ���� �Լ��� ����.
-- �Է� �Ķ����, ��¿� �Ķ����, ����� �Ķ���͸� �� �� �� �ֵ��� ����.

-- �Լ� ���ο��� ���������� �����ϴ� ���� �߿��ϹǷ� ���ν��� ������.
-- ���������� �������� ������ ������ �߻��� �� �����Ƿ� �ȿ��� ���� ���� ����...


--���� PROCEDURE(���ν���) ����--



-- 1. PL/SQL ���� ���� ��ǥ���� ������ ������ ���ν�����
--    �����ڰ� ���� �ۼ��ؾ� �ϴ� ������ �帧��
--    �̸� �ۼ��Ͽ� �����ͺ��̽� ���� ������ �ξ��ٰ�
--    �ʿ��� ������ ȣ���Ͽ� ������ �� �ֵ��� ó���� �ִ� �����̴�.



-- 2. ���� �� ����
/*
CREATE [OR REPLACE] PROCEDURE ���ν�����
[( �Ű����� IN    ������Ÿ��
,  �Ű����� OUT   ������Ÿ��
,  �Ű����� INOUT ������Ÿ��
)]
IS
    [-- �ֿ� ���� ����]
BEGIN
    -- ���� ����;
    ...
    
    [EXCEPTION
        -- ���� ó�� ����;]
END;

*/

--�� FUNCTION �� ������ �� ��RETURN ��ȯ�ڷ����� �κ��� �������� ������,
--   ��RETURN���� ��ü�� �������� �ʰ�,
--   ���ν��� ���� �� �Ѱ��ְ� �Ǵ� �Ű������� ������
--   IN(�Է�), OUT(���), INOUT(�����)���� ���еȴ�.




-- 3. ����(ȣ��)
/*
EXE[CUTE] ���ν�����[(�μ�1, �μ�2, ...)];
*/


--�� INSERT ���ν���

--�ǽ� ���̺� ����
--  ���̺� �� : TBL_STUDUNTS �� 20241204_02_scott.sql
--  ���̺� �� : TBL_IDTW �� 20241204_02_scott.sql

--���ν��� ����
--���ν��� �� : PRC_STUDENTS_INSERT(���̵�,�н�����,�̸�,��ȭ��ȣ,�ּ�)
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
    --TBL_IDPW���̺� ������ �Է�
    INSERT INTO TBL_IDPW(ID,PW)
    VALUES(V_ID,V_PW);
    
    --TBL_STUDENTS���̺� �������Է�
    INSERT INTO TBL_STUDENTS(ID,NAME,TEL,ADDR)
    VALUES (V_ID,V_NAME,V_TEL,V_ADDR);
    
    --Ŀ��
    COMMIT;
END;

--==>>Procedure PRC_STUDENTS_INSERT��(��) �����ϵǾ����ϴ�


--�� ������ �Է� �� Ư�� �׸��� �����͸� �Է��ϸ�
--  ���������� �ٸ� �׸��� �Բ� �Է� ó���� �� �ִ� ���ν����� �����Ѵ�.
--���ν��� �� : PRC_SUNGJUK_INSERT

--�ǽ����̺� ����
--  ���̺� �� : TBL_SUNGJUK �� 20241204_02_scott.sql

/*
���࿹)
EXEC PRC_SUNGJUK_INSERT(1,'������',90,80,70);

�� ���ν��� ȣ��� ó���� ���
�й�  �̸� ��������     ��������    ��������    ����  ���  ���
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


--�� TBL_SUNGJUK ���̺� ����
--  Ư�� �л��� ����(�й�, ��������, ���� ����, ��������)
--  ������ ���� �� ���� ,���, ��ޱ��� �����ϴ� ���ν����� �ۼ��Ѵ�.
--  ���ν����� : PRC_SUNGJUK_UPDATE




CREATE OR REPLACE PROCEDURE PRC_SUNGJUK_UPDATE
(
V_HAKBUN   IN TBL_SUNGJUK.HAKBUN%TYPE
,V_KOR     IN TBL_SUNGJUK.KOR%TYPE
,V_ENG     IN TBL_SUNGJUK.ENG%TYPE
,V_MAT     IN TBL_SUNGJUK.MAT%TYPE
)
IS 
    --UPDATE�������� �����ϴµ� �ʿ��� �ֿ� ���� ����
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


--�� TBL_SUTDENTS���̺���
--  ��ȭ��ȣ�� �ּ� �����͸� �����ϴ�(�����ϴ�) ���ν����� �ۼ��Ѵ�.
--  ��, ID��  PW �� ��ġ�ϴ� ��쿡�� ������ ������ �� �ֵ��� ó���Ѵ�.
--���ν����� : PRC_STUDENTS_UPDATE
/*
���࿹)
EXEC PRC_STUDENTS_UPDATE('superman','java007$','010-1212-3434','��õ ����');

�� ���ν��� ȣ��� ó���� ���
superman ������ 010-1111-1111 ���ֵ� ��������

EXEC PRC_STUDENTS_UPDATE('superman','java006$','010-1212-3434','��õ ����');

�� ���ν��� ȣ��� ó���� ���
superman ������ 010-1212-3434 ��õ ����
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

--�� TBL_INSA ���̺��� ������� �����͸� �Է��ϴ� ���ν����� �ۼ��Ѵ�.
--  NUM,NAME,SSN, IBSADATE,CITY,TEL,BESEO,JIKWI,BASICPAY,SUDANG
--  ������ ���� �ִ� ��� ���̺� ������ �Է� ��
--  NUM�׸�(�����ȣ)�� ����
--  ���� �ο��� �����ȣ ������ ��ȣ�� �� ���� ��ȣ��
--  �ڵ����� �Է� ó���� �� �ִ� ���ν����� �����Ѵ�
-- ���ν����� : PRC_INSA_INSERT(NAME,SSN,IBSADATE,CITY, TEL,BUSEO,JIKWI,BASICPAY,SUDANG);
/*
���࿹)
EXEC PRC_INSA_INSERT('�ȿ���','980716-2234567','SYSDATE','����','010-5555-5555','������','�븮',500000,500000);

�� ���ν��� ȣ��� ó���� ���
1061 �ȿ��� 980716-2234567 2024-12-03 ���� 010-5555-5555 ������ 500000 500000
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

--> ��ȿ���� �� �н����带 �Է����� ���
EXEC PRC_STUDENTS_UPDATE('superman','java006$','010-2762-1916','��õ��籸'); 

SELECT *
FROM TBL_STUDENTS;
--==>>
/*
superman	������	010-2762-1916	��õ��籸
happyday	������	010-2222-2222	���� ������
happytest	������	010-3333-3333	���� ���α�

*/


EXEC PRC_INSA_INSERT('�ȿ���','980716-2234567',SYSDATE,'����','010-5555-5555','������','�븮',500000,500000);

SELECT *
FROM TBL_INSA
WHERE NAME = '�ȿ���';
--------------------------------------------------------------------------------
--�� �ǽ� ���̺� ����
--���̺�� : (TBL_��ǰ)
CREATE TABLE TBL_��ǰ
(��ǰ�ڵ�  VARCHAR2(20)
,��ǰ��    VARCHAR2(100)
,�Һ��ڰ��� NUMBER
,������   NUMBER DEFAULT 0
,CONSTRAINT ��ǰ_��ǰ�ڵ�_PK PRIMARY KEY (��ǰ�ڵ�)
);
--==>>Table TBL_��ǰ��(��) �����Ǿ����ϴ�

--�� �ǽ� ���̺� ����
--  ���̺�� : TBL_�԰�
CREATE TABLE TBL_�԰�
(�԰��ȣ  NUMBER
,��ǰ�ڵ�   VARCHAR2(20)
,�԰�����   DATE  DEFAULT SYSDATE
,�԰����   NUMBER
,�԰�ܰ�   NUMBER
,CONSTRAINT �԰�_�԰��ȣ_PK PRIMARY KEY(�԰��ȣ)
,CONSTRAINT �԰�_��ǰ�ڵ�_FK FOREIGN KEY(��ǰ�ڵ�)
                REFERENCES TBL_��ǰ(��ǰ�ڵ�)
);
--==>>Table TBL_�԰���(��) �����Ǿ����ϴ�

-- TBL_�԰� ���̺��� �԰��ȣ�� �⺻Ű(PK) �������� ����
--  

--�� ������ �Է�
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('H001','Ȩ����',1500);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('H002','�����',1200);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('H003','����Ĩ',1000);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('H004','ġ�佺',1100);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('H005','��η�',1000);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('H006','������',2000);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('H007','���ĸ�',1700);
--==>>1 �� ��(��) ���ԵǾ����ϴ�. *7

INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('C001','����Ĩ',1800);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('C002','���͸�',1900);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('C003','���̽�',1700);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('C004','������',2200);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('C005','������',2500);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('C006','���̺�',1200);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('C007','������',3500);

INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('E001','������',1000);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('E002','������',1100);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('E003','���̼�',1100);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('E004','��Ʋ��',1200);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('E005','������',1000);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('E006','���ݴ�',1500);
INSERT INTO TBL_��ǰ(��ǰ�ڵ�,��ǰ��,�Һ��ڰ���)
VALUES('E007','����ī',1600);

SELECT *
FROM TBL_��ǰ;
--==>>
/*
H001	Ȩ����	1500	0
H002	�����	1200	0
H003	����Ĩ	1000	0
H004	ġ�佺	1100	0
H005	��η�	1000	0
H006	������	2000	0
H007	���ĸ�	1700	0
C001	����Ĩ	1800	0
C002	���͸�	1900	0
C003	���̽�	1700	0
C004	������	2200	0
C005	������	2500	0
C006	���̺�	1200	0
C007	������	3500	0
E001	������	1000	0
E002	������	1100	0
E003	���̼�	1100	0
E004	��Ʋ��	1200	0
E005	������	1000	0
E006	���ݴ�	1500	0
E007	����ī	1600	0
*/

COMMIT;
--�� TBL_��ǰ, TBL_�԰� ���̺��� �������
--  TBL_�԰� ���̺� ������ �Է� ��(�� , �԰� �̺�Ʈ �߻� ��)

--  TBL_��ǰ ���Ը� �ش� ��ǰ�� �������� �Բ� ������ �� �ִ� ����� ����
--  ���ν����� �ۼ��Ѵ�.
--  ��, �� �������� �԰��ȣ�� �ڵ� ���� ó���Ѵ�.(������ ��� X)
--  TBL_�԰� ���̺� ���� �÷�
--  �� �԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�
--  ���ν����� : PRC_�԰�_INSERT(��ǰ�ڵ�,�԰����,�԰�ܰ�)

--�� TBL_�԰� ���̺�  �԰� �̺�Ʈ �߻� ��...
--  ���� ���̺��� ����Ǿ�� �ϴ� ����
--  �� INSERT �� TBL_�԰�
--     INSERT INTO TBL_�԰� (�԰��ȣ, ��ǰ�ڵ�,�԰�����,�԰����,�԰�ܰ�)
--     VALUES(1,'H001',SYSDATE,20,1000);
--  �� UPDATE �� TBL_��ǰ
--     UPDATE TBL_��ǰ
--     SET ������ = ���������� + 20(�� �԰����)
--     WHERE ��ǰ�ڵ�='H001';


SELECT *
FROM TBL_�԰�;

DESC TBL_�԰�;

SELECT *
FROM TBL_��ǰ;

CREATE OR REPLACE PROCEDURE PRC_�԰�_INSERT
(V_��ǰ�ڵ�       TBL_��ǰ.��ǰ�ڵ�%TYPE
,V_�԰����       TBL_�԰�.�԰����%TYPE
,V_�԰�ܰ�       TBL_�԰�.�԰�ܰ�%TYPE
)
IS
    --�Ʒ��� �������� �����ϱ� ���� �ʿ��� ������ ������ �߰� ����
    V_�԰��ȣ TBL_�԰�.�԰��ȣ%TYPE ;
BEGIN
    --������ ���� (V_�԰��ȣ)�� �� ��Ƴ���
    SELECT NVL(MAX(�԰��ȣ),0)+1 INTO V_�԰��ȣ
    FROM TBL_�԰�;
    
    --������� NULL�� ����
    --SELECT MAX(NVL(�԰��ȣ,0))+1 INTO V_�԰��ȣ
    --FROM TBL_�԰�;
    
    --������ �ۼ�
    --��INSERT��
    INSERT INTO TBL_�԰� (�԰��ȣ,��ǰ�ڵ�,�԰����,�԰�ܰ�)
    VALUES(V_�԰��ȣ,V_��ǰ�ڵ�,V_�԰����,V_�԰�ܰ�);
    
    --��UPDATE��
    UPDATE TBL_��ǰ
    SET �Һ��ڰ��� = V_�԰�ܰ�, ������ = V_�԰���� + ������
    WHERE V_��ǰ�ڵ� = ��ǰ�ڵ�;
    
    COMMIT;
END;


