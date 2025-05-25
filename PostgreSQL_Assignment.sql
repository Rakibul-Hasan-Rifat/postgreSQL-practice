-- create a table for rangers
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    region VARCHAR(30) NOT NULL
);

-- insert sample data into rangers table
INSERT INTO
    rangers (name, region)
VALUES (
        'Alice Green',
        'Northern Hills'
    ),
    ('Bob White', 'River Delta'),
    (
        'Carol King',
        'Mountain Range'
    );

-- select all data from rangers table
SELECT * FROM rangers;

-- create a table for species
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(20) NOT NULL,
    scientific_name VARCHAR(50) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(20) NOT NULL
);

-- insert sample data into species table
INSERT INTO
    species (
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        'Bengal Tiger',
        'Panthera tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    );

-- select all data from species table
SELECT * FROM species;

-- create a table for sightings
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES rangers (ranger_id),
    species_id INT REFERENCES species (species_id),
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(100) NOT NULL,
    notes TEXT
);

-- insert sample data for sightings
INSERT INTO
    sightings (
        sighting_id,
        ranger_id,
        species_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        1,
        1,
        1,
        'Peak Ridge',
        '2024-05-10 07:45:00',
        'Camera trap image captured'
    ),
    (
        2,
        2,
        2,
        'Bankwood Area',
        '2024-05-12 16:20:00',
        'Juvenile seen'
    ),
    (
        3,
        3,
        3,
        'Bamboo Grove East',
        '2024-05-15 09:10:00',
        'Feeding observed'
    ),
    (
        4,
        1,
        2,
        'Snowfall Pass',
        '2024-05-18 18:30:00',
        NULL
    );

-- select all data from sightings table
SELECT * FROM sightings;

-- ______________________________ problem 1 ______________________________

INSERT INTO
    rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');

-- ______________________________ problem 2 ______________________________
SELECT count(DISTINCT common_name) AS unique_species_count
FROM species;

SELECT count(*) as unique_species_count
FROM (
        SELECT count(*)
        FROM species
        GROUP BY
            common_name
    );

-- ______________________________ problem 3 ______________________________
SELECT * FROM sightings WHERE location ILIKE '%pass%';

-- ______________________________ problem 4 ______________________________
SELECT name, count(*) as total_sightings
FROM rangers
    INNER JOIN sightings USING (ranger_id)
GROUP BY
    name
ORDER BY name;

-- ______________________________ problem 5 ______________________________
SELECT common_name
FROM species
WHERE
    species_id NOT IN (
        SELECT DISTINCT
            species.species_id
        FROM species
            RIGHT JOIN sightings ON species.species_id = sightings.species_id
        ORDER BY species.species_id ASC
    );

-- ______________________________ problem 6 ______________________________
SELECT common_name, sighting_time, name
FROM
    sightings
    JOIN species USING (species_id)
    JOIN rangers ON sightings.ranger_id = rangers.ranger_id
ORDER BY sighting_time DESC
LIMIT 2;

-- ______________________________ problem 7 ______________________________
UPDATE species
SET
    conservation_status = 'Historic'
WHERE
    extract(
        YEAR
        FROM discovery_date
    ) < 1800;

-- ______________________________ problem 8 ______________________________
SELECT
    sighting_id,
    CASE
        WHEN extract(
            HOUR
            FROM sighting_time
        ) <= 12 THEN 'Morning'
        WHEN extract(
            HOUR
            FROM sighting_time
        ) BETWEEN 12 AND 17  THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;

-- ______________________________ problem 9 ______________________________
DELETE FROM rangers
WHERE
    ranger_id NOT IN (
        SELECT DISTINCT
            rangers.ranger_id
        FROM sightings
            INNER JOIN rangers ON sightings.ranger_id = rangers.ranger_id
        ORDER BY rangers.ranger_id
    );