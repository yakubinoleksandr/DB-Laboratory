INSERT INTO Cabinet(cabinet_number, floor_number, description)
VALUES
    (45, 4, 'Кабінет ультразвукової діагностики'),
    (52, 5, 'Операційний кабінет')
ON CONFLICT (cabinet_number) DO NOTHING;

INSERT INTO DoctorSchedule(doctor_id, week_day, start_time, end_time)
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
    )
ON CONFLICT DO NOTHING;

INSERT INTO Service(service_name, price)
VALUES
    ('Первинна консультація', 500.00),
    ('Повторна консультація', 300.00),
    ('Огляд', 250.00),
    ('УЗД', 1200.00),
    ('Операція', 15000.00)
ON CONFLICT (service_name) DO NOTHING;

INSERT INTO AppointmentService(appointment_id, service_id)
SELECT a.appointment_id, s.service_id
FROM Appointment a
         JOIN Service s ON s.service_name = 'Первинна консультація'
WHERE a.appointment_id = 1
ON CONFLICT DO NOTHING;

INSERT INTO AppointmentService(appointment_id, service_id)
SELECT a.appointment_id, s.service_id
FROM Appointment a
         JOIN Service s ON s.service_name = 'Огляд'
WHERE a.appointment_id = 2
ON CONFLICT DO NOTHING;

INSERT INTO AppointmentService(appointment_id, service_id)
SELECT a.appointment_id, s.service_id
FROM Appointment a
         JOIN Service s ON s.service_name = 'Повторна консультація'
WHERE a.appointment_id = 3
ON CONFLICT DO NOTHING;