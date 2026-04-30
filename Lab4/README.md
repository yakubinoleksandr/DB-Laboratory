# Лабораторна робота №4

## Маніпулювання даними SQL (OLAP)

### SQL-скрипт(и)

```sql
-- Кількість лікарів по спеціалізаціях
SELECT s.spec_name, COUNT(d.doctor_id) AS doctor_count
FROM specialization s
LEFT JOIN doctor d ON s.spec_id = d.spec_id
GROUP BY s.spec_name;
```
![alt text] ()
