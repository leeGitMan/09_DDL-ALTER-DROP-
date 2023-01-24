-- DDL(DATA DEFINITION LANGUAGE)
-- 객체를 만들고(CREATE), 바꾸고(ALTER), 삭제(DROP)하는 데이터 정의 언어

-- ALTER(바꾸다, 수정하다, 변조하다)

-- 테이블에서 수정할 수 있는 것
-- 1) 제약 조건 --> 기존 것을 수정하는 것이 아닌, 추가, 삭제만 가능
-- 2) 컬럼(추가, 수정, 삭제)
-- 3) 이름 변경(테이블명, 제약조건명, 컬럼명)


-----------------------------------------------------------------------------------


-- 1. 제약조건(추가, 삭제)

-- [작성법]
-- 1) 추가 : ALTER TABLE 테이블명
-- 			 ADD [CONSTRAINT 제약 조건명] 제약조건(지정할 컬럼명)
--			 [REFERENCES 테이블명[(컬럼명)]]; <-- FK인 경우 추가


-- 2) 삭제 : ALTER TABLE 테이블명 
-- 			 DROP CONSTRAINT 제약조건명;


--> 수정은 별도로 존재하지 않으며, 삭제 후 추가를 해야한다.


-- DEPARTMENT 테이블 복사(컬럼명, 데이터타입, NOT NULL만 복사)

CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

SELECT *
FROM DEPT_COPY;



-- DEPT_COPY의 DEPT_TITLE 컬럼에 UNIQUE 추가

ALTER TABLE DEPT_COPY
ADD CONSTRAINT DEPT_COPY_TITLE_U UNIQUE(DEPT_TITLE);

-- DEPT_COPY의 DEPT_TITLE 컬럼에 UNIQUE 삭제

ALTER TABLE DEPT_COPY
DROP CONSTRAINT DEPT_COPY_TITLE_U;


-- *** DEPT_COPY의 DEPT_TITLE 컬럼에 NOT NULL 제약조건 추가/삭제

ALTER TABLE DEPT_COPY
ADD CONSTRAINT DEPT_COPY_TITLE_NN NOT NULL(DEPT_TITLE);
-- ORA-00904: : 부적합한 식별자


--> NOT NULL 제약조건은 새로운 조건을 추가하는 것이 아닌
-- 컬럼 자체에 NULL 허용/비허용을 제어하는 성질 변경의 형태로 인식됨.

-- MODIFY(수정하다) 구문을 사용해서 NULL 제어

ALTER TABLE DEPT_COPY 
MODIFY DEPT_TITLE NOT NULL; -- DEPT_TITLE 컬럼을 NOT NULL 제약조건 설정으로 수정

-- NOT NULL을 해제하고 싶으면 밑에 구문 처럼

ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE NULL; -- DEPT_TITLE 컬럼을 NOT NULL 제약조건 해제


----------------------------------------------------------------------------------------


-- 2. 컬럼(추가/수정/삭제)

-- 컬럼 추가
-- ALTER TABLE 테이블명 ADD(컬럼명 데이터타입 [DEFAULT '값']);

-- 컬럼 수정
-- ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입; -> 데이터 타입 변경 하는 방법
-- ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT '값'; -> DEFAULT 값 변경
-- ALTER TABLE 테이블명 MODIFY 컬럼명 NULL, NOT NULL; -> NULL여부 변경

-- 컬럼 삭제
-- ALTER TABLE 테이블명 DROP (삭제할 컬럼명);
-- ALTER TABLE 테이블명 DROP COLUMN 삭제할 컬럼명;
--> 의미는 같으나 표기법만 다르다.


-- * 컬럼 삭제 시, 주의사항 *
-- 테이블이란, 행과 열로 이루어진 DB에서 가장 기본적인 객체로
--				테이블에 데이터가 저장됨

-- 테이블은 최소 컬럼이 1개 이상의 존재해야한다.
-- 그래서 모든 컬럼을 다 삭제할 순 없다.



SELECT *
FROM DEPT_COPY;

-- CNAME 컬럼 추가

ALTER TABLE DEPT_COPY
ADD (CNAME VARCHAR2(30));

-- LNAME 컬럼 추가(기본값 '한국')

ALTER TABLE DEPT_COPY 
ADD (LNAME VARCHAR2(30) DEFAULT '한국');

--> 컬럼이 생성되면서, DEFAULT 값이 자동 삽입됨.


-- D10 개발1팀 추가

INSERT INTO DEPT_COPY
VALUES('D10', '개발1팀', 'L1', DEFAULT, DEFAULT);
-- ORA-12899: "KH"."DEPT_COPY"."DEPT_ID" 열에 대한 값이 너무 큼(실제: 3, 최대값: 2)

-- DEPT_ID 컬럼 수정(데이터 타입 수정)

ALTER TABLE DEPT_COPY
MODIFY DEPT_ID VARCHAR2(3);


-- LNAME의 기본값을 '한국' -> 'KOREA'로 수정
ALTER TABLE DEPT_COPY 
MODIFY LNAME DEFAULT 'KOREA';
--> 기존 데이터의 디폴트 값은 변하지 않고 앞으로의 데이터의 디폴트 값이 코리아로 변경된다.


-- LNAME '한국' -> 'KOREA'로 변경
UPDATE DEPT_COPY 
SET LNAME = DEFAULT 
WHERE LNAME = '한국';

COMMIT;


-- 모든 컬럼 삭제 (다 삭제 안될거임)

ALTER TABLE DEPT_COPY DROP (LNAME);
ALTER TABLE DEPT_COPY DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY DROP (LOCATION_ID);
ALTER TABLE DEPT_COPY DROP (DEPT_TITLE);
ALTER TABLE DEPT_COPY DROP (DEPT_ID);
-- ORA-12983: 테이블에 모든 열들을 삭제할 수 없습니다

-- 테이블 삭제
DROP TABLE DEPT_COPY;

------------------------------------------------------------------------------------

SELECT *
FROM DEPT_COPY;

CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;
--> 컬럼명, 데이터타입, NOT NULL 여부만 복사된다.


-- DEPT_COPY 테이블에 PK 추가(컬럼 : DEPT_ID, 제약조건명 : D_COPY_PK)
ALTER TABLE DEPT_COPY
ADD CONSTRAINT D_COPY_PK PRIMARY KEY(DEPT_ID);



-- 3. 이름 변경(테이블명, 컬럼명, 제약조건명)

-- 1) 컬럼명 변경 (DEPT_TITLE -> DEPT_NAME으로 바꾸기)

ALTER TABLE DEPT_COPY
RENAME COLUMN DEPT_TITLE TO DEPT_NAME;


-- 2) 제약조건명 변경하기(D_COPY_PK -> DEPT_COPY_PK로 바꾸기)

ALTER TABLE DEPT_COPY 
RENAME CONSTRAINT D_COPY_PK TO DEPT_COPY_PK;

-- 3) 테이블명 변경하기(DEPT_COPY -> DCOPY로 바꾸기)

ALTER TABLE DEPT_COPY
RENAME TO DCOPY; 

SELECT *
FROM DCOPY;

------------------------------------------------------------------------------------

-- 4. 테이블 삭제

-- DROP TALBE 테이블명 [CASCADE CONSTRAINT];

-- 1) 관계가 형성되지 않은 테이블(DCOPY) 삭제하기
--> 외래키가 연결되지 않은 테이블

DROP TABLE DCOPY;

-- 2) 관계가 형성된 테이블 삭제하기
--> 외래키가 연결된 테이블

CREATE TABLE TB1(
	TB1_PK NUMBER PRIMARY KEY,
	TB1_COL NUMBER
);

CREATE TABLE TB2(
	TB2_PK NUMBER PRIMARY KEY,
	TB2_COL NUMBER REFERENCES TB1 -- FK 제약조건 추가
);


-- TB1에 샘플 데이터 넣어보기

INSERT INTO TB1 VALUES (1,100);
INSERT INTO TB1 VALUES (2,200);
INSERT INTO TB1 VALUES (3,300);

SELECT * FROM TB1;


COMMIT;


INSERT INTO TB2 VALUES (11,1);
INSERT INTO TB2 VALUES (12,2);
INSERT INTO TB2 VALUES (13,3);

SELECT * FROM TB2;



-- TB1 삭제

DROP TABLE TB1;

-- ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다

--> 해결방법
-- 1) 자식, 부모 테이블 순서로 삭제
-- 2) ALTER를 이용해서 FK 제약조건 삭제 후 TB1 삭제
-- 3) DROP TABLE 삭제옵션 CASCADE CONSTRAINT 사용
--> CASCADE CONSTRAINT : 삭제하려는 테이블과 연결된 FK 제약조건을 모두 삭제 가능

DROP TABLE TB1 CASCADE CONSTRAINTS;
--> TB1 삭제 성공


----------------------------------------------------------------------------------------

/* DDL 주의 사항 */
-- 1) DDL은 COMMIT / ROLLBACK이 되지 않는다
--> ALTER, DROP을 신중하게 진행해야함.

-- 2) DDL과 DML 구문을 섞어서 수행하면 안 된다
--> DDL은 수행 시, 존재하고 있는 트랜잭션을 모두 DB에 강제 COMMIT 시킴
--> DDL이 종료된 후, DML 구문을 수정할 수 있도록 권장

SELECT * FROM TB2;
COMMIT;

INSERT INTO TB2 VALUES(14,4);
INSERT INTO TB2 VALUES(15,5);

-- 컬럼명 변경 DDL
ALTER TABLE TB2 RENAME COLUMN TB2_COL TO TB2_COLCOL;
-- (COMMIT)이 되어버려서 롤백해도 컬럼명이 변경이 안됨
ROLLBACK;


