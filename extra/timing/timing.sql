DROP TABLE performance_testing;

CREATE TABLE performance_testing AS
SELECT ROWNUM AS key, MOD(ROWNUM, 2) AS mod2, MOD(ROWNUM, 4) AS mod4,
  MOD(ROWNUM, 8) AS mod8, MOD(ROWNUM, 16) AS mod16,
  MOD(ROWNUM, 4) AS mod4i, MOD(ROWNUM, 8) AS mod8i, MOD(ROWNUM, 16) AS mod16i
FROM dual
CONNECT BY ROWNUM <= &1;

ALTER TABLE performance_testing ADD CONSTRAINT pk_performance_testing PRIMARY KEY(key);
CREATE INDEX idx_performance_testing_4 ON performance_testing(mod4i);
CREATE INDEX idx_performance_testing_8 ON performance_testing(mod8i);
CREATE INDEX idx_performance_testing_16 ON performance_testing(mod16i);

ANALYZE TABLE performance_testing COMPUTE STATISTICS;

quit
