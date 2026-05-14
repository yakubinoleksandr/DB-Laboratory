CREATE TABLE Service (
                         service_id SERIAL PRIMARY KEY,
                         service_name VARCHAR(100) UNIQUE NOT NULL,
                         price NUMERIC(10, 2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE AppointmentService (
                                    appointment_id INT NOT NULL REFERENCES Appointment(appointment_id) ON DELETE CASCADE,
                                    service_id INT NOT NULL REFERENCES Service(service_id) ON DELETE CASCADE,
                                    PRIMARY KEY (appointment_id, service_id)
);