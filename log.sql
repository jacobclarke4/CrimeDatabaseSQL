-- Keep a log of any SQL queries you execute as you solve the mystery.

SELECT * FROM  crime_scene_reports;

SELECT * FROM bakery_security_logs;

-- FInd name of all people leaving bakery
SELECT people.name, people.license_plate
    FROM people
    JOIN bakery_security_logs
    ON bakery_security_logs.license_plate = people.license_plate
WHERE bakery_security_logs.year = 2021
    AND bakery_security_logs.month = 7
    AND bakery_security_logs.day = 28;


-- ALl witnesses who mentioned bakery
SELECT name, transcript
    FROM interviews
WHERE year = 2021
    AND month = 7
    AND day = 28
    AND transcript LIKE '%bakery%';


-- Check for people who had transactions at Leggett street Info given by witness
SELECT name, atm_transactions.amount
    FROM people
    JOIN bank_accounts
    ON people.id = bank_accounts.person_id
    JOIN atm_transactions
    ON bank_accounts.account_number - atm_transactions.account_number
WHERE year = 2021
    AND month = 7
    AND day = 28
    AND atm_location = 'Leggett Street'
    AND transaction_type = 'withdraw';

-- Info about Fiftyville airport
SELECT abbreviation, full_name, city
    FROM airports
WHERE city = 'Fiftyville';

-- Find time of earlies flight the next morning
SELECT flights.id, full_name, city, flights.hour, flights.minute
    FROM airports
    JOIN flights
    ON airports.id = flights.destination_airport_id
WHERE flights.origin_airport_id =
    (SELECT id
        FROM airports
        WHERE city = 'Fiftyville')
    AND flights.year = 2021
    AND flights.month = 7
    AND flights.day = 29
ORDER BY flights.hour, flights.minute LIMIT 1;

-- Find all passengers leaving on the earlies flight
SELECT passengers.flight_id, name, passengers.passport_number, passengers.seat
    FROM people
    JOIN passengers
    ON people.passport_number = passengers.passport_number
    JOIN flights
    ON passengers.flight_id = flights.id
WHERE flights.year = 2021
    AND flights.month = 7
    AND flights.day = 29
    AND flights.hour = 8
    AND flights.minute = 20
ORDER BY passengers.passport_number;

--RAYMOND said the phone call from the thief lasted less than 1 minute
SELECT name, phone_calls.duration
    FROM people
    JOIN phone_calls
    ON people.phone_number = phone_calls.receiver
WHERE phone_calls.year = 2021
    AND phone_calls.month = 7
    AND phone_calls.day = 28
    AND phone_calls.duration <= 60
ORDER BY phone_calls.duration;

-- Bruce is the only person who left the bakery, made a phone call under 1 minute, went to the nearest atm on Leggett Street, and was a passenger on the earliest flight out of Fiftyville
-- Robin was the only other person who's time on the phone call matched Bruce's so was the accomplice
