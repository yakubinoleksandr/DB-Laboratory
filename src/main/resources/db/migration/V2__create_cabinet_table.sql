CREATE TABLE Cabinet (
                         cabinet_id SERIAL PRIMARY KEY,
                         cabinet_number INT UNIQUE NOT NULL CHECK (cabinet_number > 0 AND cabinet_number < 100),
                         floor_number INT,
                         description TEXT
);

ALTER TABLE Doctor
    ADD COLUMN cabinet_id INT REFERENCES Cabinet(cabinet_id);

INSERT INTO Cabinet(cabinet_number)
SELECT DISTINCT cabinet_number
FROM Doctor;

UPDATE Doctor d
SET cabinet_id = c.cabinet_id
FROM Cabinet c
WHERE d.cabinet_number = c.cabinet_number;

ALTER TABLE Doctor
    DROP COLUMN cabinet_number;