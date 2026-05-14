CREATE TYPE week_day_type AS ENUM (
    'Понеділок',
    'Вівторок',
    'Середа',
    'Четвер',
    'Пʼятниця',
    'Субота',
    'Неділя'
    );

CREATE TABLE DoctorSchedule (
                                schedule_id SERIAL PRIMARY KEY,
                                doctor_id INT NOT NULL REFERENCES Doctor(doctor_id) ON DELETE CASCADE,
                                week_day week_day_type NOT NULL,
                                start_time TIME NOT NULL,
                                end_time TIME NOT NULL,
                                CHECK (start_time < end_time)
);