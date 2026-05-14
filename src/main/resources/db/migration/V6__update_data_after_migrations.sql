UPDATE Cabinet
SET floor_number = 1,
    description = 'Кабінет терапевта'
WHERE cabinet_number = 8;

UPDATE Cabinet
SET floor_number = 2,
    description = 'Кабінет офтальмолога'
WHERE cabinet_number = 14;

UPDATE Cabinet
SET floor_number = 3,
    description = 'Кабінет ЛОРа'
WHERE cabinet_number = 27;

UPDATE Cabinet
SET floor_number = 1,
    description = 'Кабінет терапевта'
WHERE cabinet_number = 11;

UPDATE Cabinet
SET floor_number = 2,
    description = 'Кабінет хірурга'
WHERE cabinet_number = 22;

UPDATE Cabinet
SET floor_number = 3,
    description = 'Кабінет ЛОРа'
WHERE cabinet_number = 31;

INSERT INTO Cabinet(cabinet_number, floor_number, description)
VALUES
    (45, 4, 'Кабінет ультразвукової діагностики'),
    (52, 5, 'Операційний кабінет')
ON CONFLICT (cabinet_number) DO NOTHING;

INSERT INTO DoctorSchedule(
    doctor_id,
    week_day,
    start_time,
    end_time
)
VALUES
    (
        (SELECT doctor_id FROM Doctor WHERE last_name = 'Стіренко'),
        'Понеділок',
        '08:00',
        '14:00'
    ),
    (
        (SELECT doctor_id FROM Doctor WHERE last_name = 'Дольник'),
        'Вівторок',
        '10:00',
        '16:00'
    ),
    (
        (SELECT doctor_id FROM Doctor WHERE last_name = 'Смічик'),
        'Середа',
        '09:00',
        '15:00'
    ),
    (
        (SELECT doctor_id FROM Doctor WHERE last_name = 'Мельник'),
        'Четвер',
        '08:30',
        '13:30'
    ),
    (
        (SELECT doctor_id FROM Doctor WHERE last_name = 'Коваль'),
        'Пʼятниця',
        '11:00',
        '17:00'
    ),
    (
        (SELECT doctor_id FROM Doctor WHERE last_name = 'Шевчук'),
        'Субота',
        '09:00',
        '13:00'
    );

INSERT INTO Service(service_name, price)
VALUES
    ('Первинна консультація', 500.00),
    ('Повторна консультація', 300.00),
    ('Огляд', 250.00),
    ('Перевірка зору', 400.00),
    ('Хірургічна консультація', 800.00),
    ('ЛОР-огляд', 350.00),
    ('УЗД', 1200.00),
    ('Операція', 15000.00)
ON CONFLICT (service_name) DO NOTHING;

INSERT INTO AppointmentService(appointment_id, service_id)
SELECT a.appointment_id, s.service_id
FROM Appointment a
         JOIN Patient p ON a.patient_id = p.patient_id
         JOIN Service s ON s.service_name = 'Перевірка зору'
WHERE p.medical_card_number = '6769'
ON CONFLICT DO NOTHING;

INSERT INTO AppointmentService(appointment_id, service_id)
SELECT a.appointment_id, s.service_id
FROM Appointment a
         JOIN Patient p ON a.patient_id = p.patient_id
         JOIN Service s ON s.service_name = 'Первинна консультація'
WHERE p.medical_card_number = '2137'
ON CONFLICT DO NOTHING;

INSERT INTO AppointmentService(appointment_id, service_id)
SELECT a.appointment_id, s.service_id
FROM Appointment a
         JOIN Patient p ON a.patient_id = p.patient_id
         JOIN Service s ON s.service_name = 'Повторна консультація'
WHERE p.medical_card_number = '6361'
ON CONFLICT DO NOTHING;