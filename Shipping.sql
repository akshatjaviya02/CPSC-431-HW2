CREATE DATABASE Shipping; 
USE Shipping;
CREATE TABLE `Boats`(
    `bid` INT(11) NOT NULL,
    `bname` VARCHAR(45) NOT NULL,
    `color` VARCHAR(45) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;
--

-- Dumping data for table `Boats`
--

INSERT INTO `Boats`(`bid`, `bname`, `color`)
VALUES(101, 'Interlake', 'blue'),(102, 'Interlake', 'red'),(103, 'Clipper', 'green'),(104, 'Marine', 'red');
-- --------------------------------------------------------
--

-- Table structure for table `Reserves`
--

CREATE TABLE `Reserves`(
    `sid` INT(11) NOT NULL,
    `bid` INT(11) NOT NULL,
    `day` DATE NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;
--

-- Dumping data for table `Reserves`
--

INSERT INTO `Reserves`(`sid`, `bid`, `day`)
VALUES(22, 101, '1998-10-10'),(22, 102, '1998-10-10'),(22, 103, '1998-10-08'),(22, 104, '1998-10-07'),(31, 102, '1998-11-10'),(31, 103, '1998-11-06'),(31, 104, '1998-11-12'),(64, 101, '1998-09-05'),(64, 102, '1998-09-08'),(74, 103, '1998-09-08');
-- --------------------------------------------------------
--

-- Table structure for table `Sailors`
--

CREATE TABLE `Sailors`(
    `sid` INT(11) NOT NULL,
    `sname` VARCHAR(45) NOT NULL,
    `rating` INT(11) NOT NULL,
    `age` DOUBLE NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;
--

-- Dumping data for table `Sailors`
--

INSERT INTO `Sailors`(`sid`, `sname`, `rating`, `age`)
VALUES(22, 'Dustin', 7, 45),(29, 'Brutus', 1, 33),(31, 'Lubber', 8, 55.5),(32, 'Andy', 8, 25.5),(58, 'Rusty', 10, 35),(64, 'Horatio', 7, 35),(71, 'Zorba', 10, 16),(74, 'Horatio', 9, 35),(85, 'Art', 3, 25.5),(95, 'Bob', 3, 63.5);
--

-- Indexes for dumped tables
--

--

-- Indexes for table `Boats`
--

ALTER TABLE
    `Boats` ADD PRIMARY KEY(`bid`);
    --

    -- Indexes for table `Reserves`
    --

ALTER TABLE
    `Reserves` ADD PRIMARY KEY(`sid`, `bid`),
    ADD KEY `fk_2`(`bid`);
    --

    -- Indexes for table `Sailors`
    --

ALTER TABLE
    `Sailors` ADD PRIMARY KEY(`sid`);
    --

    -- Constraints for dumped tables
    --

    --

    -- Constraints for table `Reserves`
    --

ALTER TABLE
    `Reserves` ADD CONSTRAINT `fk_1` FOREIGN KEY(`sid`) REFERENCES `Sailors`(`sid`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `fk_2` FOREIGN KEY(`bid`) REFERENCES `Boats`(`bid`) ON DELETE CASCADE ON UPDATE CASCADE;


SELECT DISTINCT
    (Sailors.sname)
FROM
    Sailors,
    Boats,
    Reserves
WHERE
    Sailors.sid = Reserves.sid AND Reserves.bid = Boats.bid AND(
        Boats.color = 'red' OR Boats.color = 'green'
    );
SELECT DISTINCT
    (Sailors.sname)
FROM
    Sailors,
    Reserves AS r1,
    Boats AS b1,
    Reserves AS r2,
    Boats AS b2
WHERE
    Sailors.sid = r1.sid AND r1.bid = b1.bid AND Sailors.sid = r2.sid AND r2.bid = b2.bid AND b1.color = 'red' AND b2.color = 'green';
SELECT
    Sailors.sname
FROM
    Sailors
WHERE
    Sailors.sid IN(
    SELECT
        Reserves.sid
    FROM
        Reserves
    WHERE
        Reserves.bid = 103
);
SELECT
    s.sid
FROM
    Sailors s
WHERE
    s.rating >= ALL(
    SELECT
        S2.rating
    FROM
        Sailors S2
);
SELECT
    s.sname
FROM
    Sailors s
WHERE NOT
    EXISTS(
    SELECT
        b.bid
    FROM
        Boats b
    WHERE NOT
        EXISTS(
        SELECT
            r.bid
        FROM
            Reserves r
        WHERE
            r.bid = b.bid AND r.sid = s.sid
    )
);
SELECT
    s.sname,
    s.age
FROM
    Sailors s
WHERE
    s.age =(
    SELECT
        MAX(s2.age)
    FROM
        Sailors s2
);
SELECT
    rating,
    AVG(age) AS avg_age
FROM
    Sailors
GROUP BY
    rating
HAVING
    COUNT(*) > 1;
SELECT
    b.bid,
    COUNT(*) AS sailor
FROM
    Boats b,
    Reserves r
WHERE
    r.bid = b.bid AND b.color = 'red'
GROUP BY
    b.bid;