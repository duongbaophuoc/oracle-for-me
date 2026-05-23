CREATE OR REPLACE PACKAGE bank_ops_pkg AS
    PROCEDURE transfer_funds(p_from_acc NUMBER, p_to_acc NUMBER, p_amount NUMBER);
END bank_ops_pkg;
/

CREATE OR REPLACE PACKAGE BODY bank_ops_pkg AS
    PROCEDURE transfer_funds(p_from_acc NUMBER, p_to_acc NUMBER, p_amount NUMBER) IS
        deadlock_detected EXCEPTION;
        PRAGMA EXCEPTION_INIT(deadlock_detected, -60);
        v_retries NUMBER := 0;
    BEGIN
        <<retry_loop>>
        BEGIN
            SAVEPOINT start_transfer;
            
            UPDATE accounts SET balance = balance - p_amount WHERE account_id = p_from_acc;
            UPDATE accounts SET balance = balance + p_amount WHERE account_id = p_to_acc;
            
            COMMIT;
        EXCEPTION
            WHEN deadlock_detected THEN
                ROLLBACK TO start_transfer;
                v_retries := v_retries + 1;
                IF v_retries <= 3 THEN
                    DBMS_LOCK.SLEEP(DBMS_RANDOM.VALUE(1,3));
                    GOTO retry_loop;
                ELSE
                    RAISE;
                END IF;
            WHEN OTHERS THEN
                ROLLBACK;
                INSERT INTO error_log (log_time, error_msg) VALUES (SYSTIMESTAMP, SQLERRM);
                COMMIT;
                RAISE;
        END;
    END transfer_funds;
END bank_ops_pkg;
/