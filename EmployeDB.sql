SET TERMOUT ON
PROMPT Building demonstration tables.  Please wait.
SET TERMOUT OFF

ALTER SESSION SET NLS_LANGUAGE = 'ENGLISH';

CREATE TABLE Emp (
    EMPNO NUMBER(4) PRIMARY KEY,
    ENAME VARCHAR2(10),
    JOB VARCHAR2(9),
    MGR NUMBER(4),
    HIREDATE DATE,
    SAL NUMBER(7, 2) CHECK (SAL > 0),
    COMM NUMBER(7, 2) CHECK (COMM >= 0),
    DEPTNO NUMBER(2),
    CONSTRAINT fk_dept FOREIGN KEY (DEPTNO)
        REFERENCES DEPT(DEPTNO)
        ON DELETE SET NULL
);

CREATE TABLE DEPT (
    DEPTNO NUMBER(2),
    DNAME VARCHAR2(14),
    LOC VARCHAR2(13),
    CONSTRAINT pk_dept PRIMARY KEY (DEPTNO)
);

CREATE TABLE BONUS
        (ENAME VARCHAR2(10),
         JOB   VARCHAR2(9),
         SAL   NUMBER,
         COMM  NUMBER);

CREATE TABLE Emps_in_Depts (
    Deptno NUMBER(2),
    Employees VARCHAR2(4000)
);

CREATE TABLE SALGRADE
        (GRADE NUMBER,
         LOSAL NUMBER,
         HISAL NUMBER);

INSERT INTO SALGRADE VALUES (1,  700, 1200);
INSERT INTO SALGRADE VALUES (2, 1201, 1400);
INSERT INTO SALGRADE VALUES (3, 1401, 2000);
INSERT INTO SALGRADE VALUES (4, 2001, 3000);
INSERT INTO SALGRADE VALUES (5, 3001, 9999);

CREATE TABLE DUMMY
        (DUMMY NUMBER);

INSERT INTO DUMMY VALUES (0);

INSERT INTO EMP VALUES
        (7369, 'SMITH',  'CLERK',     7902,
        TO_DATE('17-MAR-1980', 'DD-MON-YYYY'),  800, NULL, 20);
INSERT INTO EMP VALUES
        (7499, 'ALLEN',  'SALESMAN',  7698,
        TO_DATE('20-MAR-1981', 'DD-MON-YYYY'), 1600,  300, 30);
INSERT INTO EMP VALUES
        (7521, 'WARD',   'SALESMAN',  7698,
        TO_DATE('22-MAR-1981', 'DD-MON-YYYY'), 1250,  500, 30);
INSERT INTO EMP VALUES
        (7566, 'JONES',  'MANAGER',   7839,
        TO_DATE('2-MAR-1981', 'DD-MON-YYYY'),  2975, NULL, 20);
INSERT INTO EMP VALUES
        (7654, 'MARTIN', 'SALESMAN',  7698,
        TO_DATE('28-MAR-1981', 'DD-MON-YYYY'), 1250, 1400, 30);
INSERT INTO EMP VALUES
        (7698, 'BLAKE',  'MANAGER',   7839,
        TO_DATE('1-MAR-1981', 'DD-MON-YYYY'),  2850, NULL, 30);
INSERT INTO EMP VALUES
        (7782, 'CLARK',  'MANAGER',   7839,
        TO_DATE('9-MAR-1981', 'DD-MON-YYYY'),  2450, NULL, 10);
INSERT INTO EMP VALUES
        (7788, 'SCOTT',  'ANALYST',   7566,
        TO_DATE('09-MAR-1982', 'DD-MON-YYYY'), 3000, NULL, 20);
INSERT INTO EMP VALUES
        (7839, 'KING',   'PRESIDENT', NULL,
        TO_DATE('17-MAR-1981', 'DD-MON-YYYY'), 5000, NULL, 10);
INSERT INTO EMP VALUES
        (7844, 'TURNER', 'SALESMAN',  7698,
        TO_DATE('8-MAR-1981', 'DD-MON-YYYY'),  1500,    0, 30);
INSERT INTO EMP VALUES
        (7876, 'ADAMS',  'CLERK',     7788,
        TO_DATE('12-MAR-1983', 'DD-MON-YYYY'), 1100, NULL, 20);
INSERT INTO EMP VALUES
        (7900, 'JAMES',  'CLERK',     7698,
        TO_DATE('3-MAR-1981', 'DD-MON-YYYY'),   950, NULL, 30);
INSERT INTO EMP VALUES
        (7902, 'FORD',   'ANALYST',   7566,
        TO_DATE('3-MAR-1981', 'DD-MON-YYYY'),  3000, NULL, 20);
INSERT INTO EMP VALUES
        (7934, 'MILLER', 'CLERK',     7782,
        TO_DATE('23-MAR-1982', 'DD-MON-YYYY'), 1300, NULL, 10);

INSERT INTO DEPT VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT VALUES (20, 'RESEARCH',   'DALLAS');
INSERT INTO DEPT VALUES (30, 'SALES',      'CHICAGO');
INSERT INTO DEPT VALUES (40, 'OPERATIONS', 'BOSTON');

-- Exercise 1: PL/SQL block for entering a new employee
DECLARE
    v_empno   NUMBER;
    v_ename   VARCHAR2(10);
    v_job     VARCHAR2(9);
    v_mgr     NUMBER;
    v_hiredate DATE;
    v_sal     NUMBER(7, 2);
    v_comm    NUMBER(7, 2);
    v_deptno  NUMBER;
    v_confirm CHAR(1);
BEGIN
    ACCEPT v_empno   NUMBER PROMPT 'Enter Employee Number: ';
    ACCEPT v_ename   CHAR   PROMPT 'Enter Employee Name: ';
    ACCEPT v_job     CHAR   PROMPT 'Enter Job: ';
    ACCEPT v_mgr     NUMBER PROMPT 'Enter Manager Number: ';
    ACCEPT v_hiredate CHAR   PROMPT 'Enter Hire Date (DD-MON-YYYY): ';
    ACCEPT v_sal     NUMBER PROMPT 'Enter Salary: ';
    ACCEPT v_comm    NUMBER PROMPT 'Enter Commission: ';
    ACCEPT v_deptno  NUMBER PROMPT 'Enter Department Number: ';

    INSERT INTO Emp (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
    VALUES (v_empno, v_ename, v_job, v_mgr, TO_DATE(v_hiredate, 'DD-MON-YYYY'), v_sal, v_comm, v_deptno);

    ACCEPT v_confirm CHAR(1) PROMPT 'Do you confirm changes made? (Y/N): ';

    IF UPPER(v_confirm) = 'N' THEN
        DELETE FROM Emp WHERE EMPNO = v_empno;
        DBMS_OUTPUT.PUT_LINE('Insertion undone.');
    ELSIF UPPER(v_confirm) = 'Y' THEN
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Insertion confirmed.');
        SELECT * INTO v_empno, v_ename, v_job, v_mgr, v_hiredate, v_sal, v_comm, v_deptno
        FROM Emp WHERE EMPNO = v_empno;
        DBMS_OUTPUT.PUT_LINE('New Employee:');
        DBMS_OUTPUT.PUT_LINE('Employee Number: ' || v_empno);
        DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_ename);
        DBMS_OUTPUT.PUT_LINE('Job: ' || v_job);
        DBMS_OUTPUT.PUT_LINE('Manager Number: ' || v_mgr);
        DBMS_OUTPUT.PUT_LINE('Hire Date: ' || TO_CHAR(v_hiredate, 'DD-MON-YYYY'));
        DBMS_OUTPUT.PUT_LINE('Salary: ' || v_sal);
        DBMS_OUTPUT.PUT_LINE('Commission: ' || v_comm);
        DBMS_OUTPUT.PUT_LINE('Department Number: ' || v_deptno);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Invalid choice.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


DECLARE
    CURSOR c_emp_dept IS
        SELECT e.DEPTNO,
               LISTAGG(e.ENAME, '$') WITHIN GROUP (ORDER BY e.ENAME) AS emp_names
        FROM Emp e
        GROUP BY e.DEPTNO;
BEGIN
    FOR emp_rec IN c_emp_dept LOOP
        INSERT INTO Emps_in_Depts (Deptno, Employees)
        VALUES (emp_rec.DEPTNO, emp_rec.emp_names);
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Rows inserted into Emps_in_Depts.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
SELECT * FROM Emps_in_Depts;

COMMIT;



