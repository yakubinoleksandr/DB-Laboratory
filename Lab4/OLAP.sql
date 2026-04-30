-- Кількість лікарів по спеціалізаціях
SELECT s.spec_name, COUNT(d.doctor_id) AS doctor_count
FROM specialization s
LEFT JOIN doctor d ON s.spec_id = d.spec_id
GROUP BY s.spec_name;

-- Середній стаж лікарів по спеціалізаціях
SELECT s.spec_name, AVG(d.experience_years) AS avg_experience
FROM specialization s
JOIN doctor d ON s.spec_id = d.spec_id
GROUP BY s.spec_name;

-- Кількість прийомів у кожного лікаря
SELECT d.doctor_id, d.last_name, COUNT(a.appointment_id) AS total_appointments
FROM doctor d
LEFT JOIN appointment a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.last_name;

-- Мінімальний і максимальний стаж лікарів
SELECT MIN(experience_years) AS min_exp,
       MAX(experience_years) AS max_exp
FROM doctor;

-- Кількість прийомів за статусом
SELECT app_status, COUNT(*) AS count_status
FROM appointment
GROUP BY app_status;

-- Список прийомів з лікарем і пацієнтом
SELECT p.first_name, p.last_name,
       d.first_name AS doc_name, d.last_name AS doc_surname,
       a.app_date, a.app_time
FROM appointment a
INNER JOIN patient p ON a.patient_id = p.patient_id
INNER JOIN doctor d ON a.doctor_id = d.doctor_id;

-- Всі лікарі (навіть без прийомів)
SELECT d.first_name, d.last_name, a.appointment_id
FROM doctor d
LEFT JOIN appointment a ON d.doctor_id = a.doctor_id;

-- Всі лікарі і всі прийоми
SELECT d.last_name, a.appointment_id
FROM doctor d
FULL JOIN appointment a ON d.doctor_id = a.doctor_id;

-- Лікарі з максимальним стажем
SELECT *
FROM doctor
WHERE experience_years = (
    SELECT MAX(experience_years) FROM doctor
);

-- Пацієнти, які мають хоча б один запис
SELECT *
FROM patient
WHERE patient_id IN (
    SELECT DISTINCT patient_id FROM appointment
);

-- Кількість прийомів для кожного лікаря
SELECT d.first_name, d.last_name,
       (SELECT COUNT(*)
        FROM appointment a
        WHERE a.doctor_id = d.doctor_id) AS appointment_count
FROM doctor d;
