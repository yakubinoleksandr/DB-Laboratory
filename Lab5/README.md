# Лабораторна робота №5

## Нормалізація бази даних

У цій лабораторній роботі було проведено аналіз схеми бази даних реєстратури лікарні. Метою було виявлення порушень нормальних форм (зокрема транзитивних залежностей) та приведення бази даних до 3-ї нормальної форми (3NF).

---

## 1. Аналіз початкової схеми та функціональних залежностей

**Поточна схема вже майже в 3NF, але є слабкі місця:**
- потенційні транзитивні залежності (Doctor → Specialization),
- надлишкові унікальні обмеження (Patient),
- можливі аномалії видалення/оновлення.

---

### `1. Specialization(spec_id, spec_name):`

*ФЗ:*
- `spec_id → spec_name`
- `spec_name → spec_id` (через UNIQUE)

*Ключі:*
- PK: `spec_id`
- альтернативний ключ: `spec_name`

*НФ:*
- 1NF 
- 2NF 
- 3NF 

Таблиця вже в 3NF

---

### `2. Doctor(doctor_id, first_name, last_name, spec_id, cabinet_number, experience_years):`

*ФЗ:*
- `doctor_id → first_name, last_name, spec_id, cabinet_number, experience_years`
- `spec_id → spec_name` (через іншу таблицю)

*Ключі:*
- `PK: doctor_id`

**Можливі проблеми:**
- логічна залежність: `doctor_id → spec_id → spec_name` (транзитивно)

Але `spec_name` винесено в іншу таблицю → це вже нормалізація.

*НФ:*
- 1NF 
- 2NF 
- 3NF (бо spec_name не в таблиці)

Таблиця вже в 3NF

---

### `3. Patient(patient_id, medical_card_number, first_name, last_name, birth_date, gender, phone, address):` 

*ФЗ:*
- `patient_id → medical_card_number, first_name, last_name, birth_date, gender, phone, address`
- `medical_card_number → patient_id, first_name, last_name, birth_date, gender, phone, address`
- `(first_name, last_name, birth_date) → patient_id, medical_card_number, gender, phone, address`

*Ключі:*
- PK: `patient_id`
- *альтернативні:*
  - `medical_card_number`
  - `(first_name, last_name, birth_date)`
 
**Проблема:** 
- Надлишкові ключі → ризик: дублювання та аномалії оновлення

*НФ:*
- 1NF (якщо у пацієнта не один номер то це порушення)
- 2NF 
- 3NF (формально так, але є надлишковість залежностей)

Підлягає нормалізації

---

### `4. Appointment(appointment_id, patient_id, doctor_id, app_date, app_time, app_status, note):`

*ФЗ:*
- `appointment_id → patient_id, doctor_id, app_date, app_time, app_status, note`
- `(doctor_id, app_date, app_time) → appointment_id, patient_id, app_status, note`

*Ключі:*
- PK: `appointment_id`
- альтернативний: `(doctor_id, app_date, app_time)`

*НФ:*
- 1NF 
- 2NF 
- 3NF

Таблиця вже в 3NF

## 2. Найвища нормальна форма початкової схеми
Вся схема: майже 3NF (з застереженнями)

**Чому:**
- всі таблиці атомарні → 1NF
- немає часткових залежностей → 2NF
- транзитивні залежності винесені → 3NF

Але є проблеми:
- `Patient` має надлишкові ключі
- немає окремої таблиці для телефонів (може бути список → порушення 1NF у майбутньому)

## 3. Покрокова нормалізація

**КРОК 1: Перевірка 1NF**

Є проблема, що у пацієнта може бути не один номер, тому вирішенням цієї проблеми є винесення номерів телефонів в окрему таблицю

`PatientPhone(phone_id, patient_id, phone)`

```sql
ALTER TABLE Patient
DROP COLUMN phone;

CREATE TABLE PatientPhone(
    phone_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES Patient(patient_id) ON DELETE CASCADE,
    phone CHAR(13) NOT NULL
);
```

---

**КРОК 2: Усунення надлишкових залежностей (2NF/3NF)**

В таблиці Patient - (first_name, last_name, birth_date) це псевдоключ, який нестабільний та створює дублювання.

Тому рішенням буде видалити його та залишити patient_id та medical_card_number.

```sql
ALTER TABLE Patient
DROP CONSTRAINT patient_first_name_last_name_birth_date_key;
```

## 4. Фінальна схема (3NF)
```sql
CREATE TABLE IF NOT EXISTS Specialization(
	spec_id SERIAL PRIMARY KEY,
	spec_name TEXT UNIQUE NOT NULL
);

CREATE TYPE state_gender as enum ('Чол', 'Жін', 'Нічого');

CREATE TABLE Patient(
    patient_id SERIAL PRIMARY KEY,
    medical_card_number VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(25) NOT NULL,
    last_name VARCHAR(25) NOT NULL,
    birth_date DATE NOT NULL,
    gender state_gender DEFAULT 'Нічого',
    address TEXT
);

CREATE TABLE PatientPhone(
    phone_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES Patient(patient_id),
    phone CHAR(13) NOT NULL
);

CREATE TABLE IF NOT EXISTS Doctor(
	doctor_id SERIAL PRIMARY KEY,
	first_name VARCHAR(25) NOT NULL,
	last_name VARCHAR(25) NOT NULL,
	spec_id INT REFERENCES Specialization(spec_id) NOT NULL,
	cabinet_number INT CHECK(cabinet_number>0 AND cabinet_number<100) NOT NULL,
	experience_years INT CHECK(experience_years>=0) DEFAULT 0
);

CREATE TYPE status_appointment as enum ('Заплановано', 'Завершено', 'Скасовано', 'Пропущено');

CREATE TABLE Appointment(
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES Patient(patient_id),
    doctor_id INT REFERENCES Doctor(doctor_id),
    app_date DATE NOT NULL,
    app_time TIME NOT NULL,
    app_status status_appointment DEFAULT 'Заплановано',
    note TEXT,
    UNIQUE (doctor_id, app_date, app_time)
);
```
