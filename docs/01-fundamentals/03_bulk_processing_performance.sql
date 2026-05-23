-- Compare Standard Loop vs FORALL (Bulk Processing)
DECLARE
    TYPE t_emp_ids IS TABLE OF employees.employee_id%TYPE;
    v_ids t_emp_ids;
    v_start TIMESTAMP;
    v_end TIMESTAMP;
BEGIN
    SELECT employee_id BULK COLLECT INTO v_ids FROM employees;

    -- Standard Loop (Slow - Context Switching)
    v_start := SYSTIMESTAMP;
    FOR i IN 1..v_ids.COUNT LOOP
        UPDATE employees SET salary = salary * 1.05 WHERE employee_id = v_ids(i);
    END LOOP;
    v_end := SYSTIMESTAMP;
    DBMS_OUTPUT.PUT_LINE('Standard Loop: ' || (v_end - v_start));

    -- FORALL (Fast - Bulk operation)
    v_start := SYSTIMESTAMP;
    FORALL i IN 1..v_ids.COUNT
        UPDATE employees SET salary = salary * 1.05 WHERE employee_id = v_ids(i);
    v_end := SYSTIMESTAMP;
    DBMS_OUTPUT.PUT_LINE('FORALL Bulk: ' || (v_end - v_start));
END;
/