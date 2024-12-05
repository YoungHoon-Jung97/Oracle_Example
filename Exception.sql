--�� ���̺� ����
CREATE TABLE TBL_MEMBER
(NUM    NUMBER
,NAME   VARCHAR2(30)
,TEL    VARCHAR2(60)
,CITY   VARCHAR2(60)
,CONSTRAINT TBL_MEMBER_PK PRIMARY KEY (NUM)
);

SELECT *
FROM TBL_MEMBER;

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
    
    --Ŀ��
    COMMIT;
    
    --����ó��
    EXCEPTION 
        WHEN OTHERS THEN ROLLBACK; 
        
    
END;
--==>>Procedure PRC_�԰�_INSERT��(��) �����ϵǾ����ϴ�

--�� ������ ���ν���(PRC_MEMBER_INSERT)�� ������ �۵��ϴ����� ���� Ȯ��
--  �� ���ν��� ȣ��
--EXEC PRC_MEMBER_INSERT(�̸�, ��ȭ��ȣ,����)
EXEC PRC_MEMBER_INSERT('������','010-1111-1111','����');
--==>>PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�

EXEC PRC_MEMBER_INSERT('���¹�','010-2222-2222','��õ');
--==>>PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�

EXEC PRC_MEMBER_INSERT('�ȿ���','010-3333-3333','���');
--==>>PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�

SELECT *
FROM TBL_MEMBER;
--==>>
/*
1	������	010-1111-1111	����
2	���¹�	010-2222-2222	��õ
3	�ȿ���	010-3333-3333	���
*/

--------------------------------------------------------------------------------
CREATE TABLE TBL_���
(����ȣ       NUMBER
,��ǰ�ڵ�       VARCHAR2(20)
,�������       DATE       DEFAULT SYSDATE
,������       NUMBER
,���ܰ�       NUMBER
);
--==>>Table TBL_�����(��) �����Ǿ����ϴ�

--�� TBL_��� ���̺��� ����ȣ�� PK�������� ����
ALTER TABLE TBL_���
ADD CONSTRAINT ���_����ȣ_PK PRIMARY KEY (����ȣ);
--==>>Table TBL_�����(��) ����Ǿ����ϴ�


--�� TBL_��� ���̺��� ��ǰ�ڵ�� TBL_��ǰ ���̺��� ��ǰ�ڵ带
--  ������ �� �ֵ��� �ܷ�Ű(FK) �������� ����
ALTER TABLE TBL_���
ADD CONSTRAINT ���_��ǰ�ڵ�_FK FOREIGN KEY(��ǰ�ڵ�)
                    REFERENCES TBL_��ǰ(��ǰ�ڵ�);
--==>>Table TBL_�����(��) ����Ǿ����ϴ�

--�� TBL_��� �׺� ������ �Է� ��(��, Ǯ�� �̺�Ʈ �߻� ��)
--  TBL_��ǰ ���̺��� �ش� ��ǰ�� �������� ������ �� �ִ� ���ν����� �ۼ��Ѵ�.
--  ��,����ȣ�� �԰��ȣ�� ���������� �ڵ� ����
--  ����, ��� ������ ���������� ���� ���...
--  ��� �׼��� ó������ �ʵ��� �����Ѵ�.(��� �̷������ �ʵ���...)
--  ���ν��� �� : PRC_���_INSERT(��ǰ�ڵ�,������,���ܰ�)

SELECT *
FROM TBL_���;

SELECT *
FROM TBL_��ǰ;

CREATE OR REPLACE PROCEDURE PRC_���_INSERT(
V_��ǰ�ڵ�       IN TBL_��ǰ.��ǰ�ڵ�%TYPE
,V_������      IN TBL_���.������%TYPE
,V_���ܰ�      IN TBL_���.���ܰ�%TYPE
)
IS
    V_����ȣ TBL_���.����ȣ%TYPE;
    USER_DEFINE_ERROR EXCEPTION;
    V_������ TBL_��ǰ.������%TYPE;
    
BEGIN
    
    SELECT ������ INTO V_������
    FROM TBL_��ǰ
    WHERE V_��ǰ�ڵ� = ��ǰ�ڵ�;
    
    IF V_������ < V_������
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    SELECT NVL(MAX(����ȣ),0)+1 INTO V_����ȣ
    FROM TBL_���;
    
    INSERT INTO TBL_��� (����ȣ,��ǰ�ڵ�,������,���ܰ�)
    VALUES(V_����ȣ,V_��ǰ�ڵ�,V_������,V_���ܰ�);
    
    UPDATE TBL_��ǰ
    SET ������ = ������ - V_������
    WHERE ��ǰ�ڵ� = V_��ǰ�ڵ�;
    
    COMMIT;
    --����ó��
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001,'�������� �������� �Ѿ����ϴ�.');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    

END;



--�� TBL_��� ���̺��� ��� ������ ����(����)�ϴ� ���ν����� �ۼ��Ѵ�.
--   ���ν����� : PRC_���_UPDATE(����ȣ,�����Ҽ���)

SELECT *
FROM TBL_���;

SELECT *
FROM TBL_��ǰ;

CREATE OR REPLACE PROCEDURE PRC_���_UPDATE(

    --�� �Ű����� ����
    V_����ȣ      IN TBL_���.����ȣ%TYPE
,   V_�����Ҽ���    IN TBL_���.������%TYPE
)
IS
    V_������ TBL_��ǰ.������%TYPE;
    V_��ǰ�ڵ� TBL_���.��ǰ�ڵ�%TYPE;
    V_������ TBL_���.������%TYPE;
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN
    
    SELECT ��ǰ�ڵ� INTO V_��ǰ�ڵ�
    FROM TBL_���
    WHERE V_����ȣ = ����ȣ;
    
    SELECT ������ INTO V_������
    FROM TBL_��ǰ
    WHERE V_��ǰ�ڵ� = ��ǰ�ڵ�;  
    
    SELECT ������ INTO V_������
    FROM TBL_���
    WHERE ����ȣ =V_����ȣ;
    
    

    IF (V_������+ V_������)<V_�����Ҽ���
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    --�� ���� ������ ����
    --UPDATE �� TBL_���
    UPDATE TBL_���
    SET ������ = V_�����Ҽ���
    WHERE ����ȣ = V_����ȣ;
    
    --UPDATE �� TBL_��ǰ
    UPDATE TBL_��ǰ
    SET ������ =(V_������+ V_������)-V_�����Ҽ���
    WHERE ��ǰ�ڵ� = V_��ǰ�ڵ�;
    
    COMMIT;
    
    --����ó��
    EXCEPTION 
        WHEN   USER_DEFINE_ERROR
            THEN   RAISE_APPLICATION_ERROR(-20003,'������');
                    ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;



EXEC PRC_���_DELETE(1);
--�� TBL_�԰� ���̺��� �԰������ ����(����)�ϴ� ���ν��ڸ� �ۼ��Ѵ�.
--  ���ν����� :PRC_�԰�_UPDATE(�԰��ȣ,�����Ҽ���)

CREATE OR REPLACE PROCEDURE PRC_�԰�_UPDATE
(V_�԰��ȣ      IN TBL_�԰�.�԰��ȣ%TYPE
,V_�����Ҽ���    IN TBL_�԰�.�԰����%TYPE
)
IS
    --�麯������ �� V_��ǰ�ڵ�
    V_��ǰ�ڵ� TBL_��ǰ.��ǰ�ڵ�%TYPE;
    --�뺯������ �� V_������
    V_������ TBL_��ǰ.������%TYPE;
    --�캯������ �� V_�԰����
    V_�԰���� TBL_�԰�.�԰����%TYPE;
     --�ﺯ������ 
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    
    --�꺯���� ���� �� V_��ǰ�ڵ�
    SELECT ��ǰ�ڵ� INTO V_��ǰ�ڵ�
    FROM TBL_�԰�
    WHERE �԰��ȣ = V_�԰��ȣ;
    
    --������ ���� �� V_������
    SELECT ������ INTO V_������
    FROM TBL_��ǰ
    WHERE V_��ǰ�ڵ� = ��ǰ�ڵ�;
    
    --����� ���� �� V_�԰����
    SELECT �԰���� INTO V_�԰����
    FROM TBL_�԰�
    WHERE V_�԰��ȣ = �԰��ȣ;
    
    --�𿹿�ó�� �߻�
    IF (V_������ - V_�԰����) <0
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    
    --�������� �ۼ� �� UPDATE TBL_�԰�
    UPDATE TBL_�԰�
    SET �԰���� = V_�����Ҽ���
    WHERE V_�԰��ȣ =�԰��ȣ;
    
    --�������� �ۼ� �� UPDATE TBL_��ǰ
    UPDATE TBL_��ǰ
    SET ������ = V_������ -  V_�԰���� + V_�����Ҽ���
    WHERE V_��ǰ�ڵ� = ��ǰ�ڵ�;
    
    --Ŀ��
    COMMIT;
    
     --�񿹿�ó��
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001,'����');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
    
END;



--�� TBL_��� ���̺��� �������� �����ϴ� ���ν��ڸ� �ۼ��Ѵ�.
--  ���ν����� :PRC_���_DELETE(����ȣ) 

CREATE OR REPLACE PROCEDURE PRC_���_DELETE
(V_����ȣ     IN TBL_���.����ȣ%TYPE
)
IS
    --�麯������ �� V_��ǰ�ڵ�
    V_��ǰ�ڵ� TBL_��ǰ.��ǰ�ڵ�%TYPE;
    --�뺯������ �� V_������
    V_������ TBL_��ǰ.������%TYPE;
    --�캯������ �� V_�԰����
    V_������ TBL_���.������%TYPE;
    
BEGIN

    --�꺯���� ���� �� V_��ǰ�ڵ�
    SELECT ��ǰ�ڵ� INTO V_��ǰ�ڵ�
    FROM TBL_���
    WHERE ����ȣ = V_����ȣ;
    
    --������ ���� �� V_������
    SELECT ������ INTO V_������
    FROM TBL_��ǰ
    WHERE V_��ǰ�ڵ� = ��ǰ�ڵ�;
    
    --����� ���� �� V_�԰����
    SELECT ������ INTO V_������
    FROM TBL_���
    WHERE V_����ȣ = ����ȣ;
    
    --�������� �ۼ� �� DELETR TBL_���
    DELETE
    FROM TBL_���
    WHERE ����ȣ = V_����ȣ;
    
    --�������� �ۼ� �� UPDATE TBL_��ǰ
    UPDATE TBL_��ǰ
    SET ������ = V_������ +  V_������ 
    WHERE V_��ǰ�ڵ� = ��ǰ�ڵ�;
    
     --Ŀ��
    COMMIT;
    
    --�￹��ó��
    EXCEPTION
        WHEN OTHERS
            THEN ROLLBACK;
    
END;


--�� TBL_�԰� ���̺��� �԰������ �����ϴ� ���ν��ڸ� �ۼ��Ѵ�.
--  ���ν����� :PRC_�԰�_DELETE(�԰��ȣ)

CREATE OR REPLACE PROCEDURE PRC_�԰�_DELETE
(V_�԰��ȣ     IN TBL_�԰�.�԰��ȣ%TYPE
)
IS
    --�麯������ �� V_��ǰ�ڵ�
    V_��ǰ�ڵ� TBL_��ǰ.��ǰ�ڵ�%TYPE;
    --�뺯������ �� V_������
    V_������ TBL_��ǰ.������%TYPE;
    --�캯������ �� V_�԰����
    V_�԰���� TBL_�԰�.�԰����%TYPE;
    --�ﺯ������ 
    USER_DEFINE_ERROR EXCEPTION;
    MAX             NUMBER;

    
BEGIN

    --�꺯���� ���� �� V_��ǰ�ڵ�
    SELECT ��ǰ�ڵ� INTO V_��ǰ�ڵ�
    FROM TBL_�԰�
    WHERE �԰��ȣ = V_�԰��ȣ;
    
    --������ ���� �� V_������
    SELECT ������ INTO V_������
    FROM TBL_��ǰ
    WHERE V_��ǰ�ڵ� = ��ǰ�ڵ�;
    
    --����� ���� �� V_�԰����
    SELECT �԰���� INTO V_�԰����
    FROM TBL_�԰�
    WHERE V_�԰��ȣ = �԰��ȣ;
    
    SELECT MAX(�԰��ȣ) INTO MAX
    FROM TBL_�԰�;
    
    --�𿹿�ó�� �߻�
    IF V_�԰��ȣ NOT BETWEEN 1 AND MAX 
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    IF (V_������ - V_�԰����) <0
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    
    
    --�������� �ۼ� �� DELETR TBL_�԰�
    DELETE
    FROM TBL_�԰�
    WHERE �԰��ȣ = V_�԰��ȣ;
    
    --�������� �ۼ� �� UPDATE TBL_��ǰ
    UPDATE TBL_��ǰ
    SET ������ = V_������ -  V_�԰���� 
    WHERE V_��ǰ�ڵ� = ��ǰ�ڵ�;
    
     --Ŀ��
    COMMIT;
    
    --�񿹿�ó��
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001,'����');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
    
END;
