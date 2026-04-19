-- DIGITAL LIBRARY AUDIT SYSTEM DATABASE SCHEMA

-- Books Table Creation
CREATE TABLE Books (
    Book_ID NUMBER PRIMARY KEY,
    Title_Of_Book VARCHAR(100),
    Author_Name VARCHAR(100),
    Category_Of_Book VARCHAR(50)
);

-- Students Table Creation
CREATE TABLE Students(
    Student_ID NUMBER PRIMARY KEY,
    Name_Of_Student VARCHAR(100),
    Email_Address VARCHAR(100),
    JoinDate_Of_Student DATE
);


--Status column
ALTER TABLE Students ADD Status VARCHAR(20);

--Issued Books
CREATE TABLE IssuedBooks(
    Issue_ID NUMBER PRIMARY KEY,
    Student_ID NUMBER,
    Book_ID NUMBER,
    Issue_Date DATE,
    Return_DATE DATE,
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID),
    FOREIGN KEY(Book_ID) REFERENCES Books(Book_ID)
);


--Inserting data into Books table
INSERT INTO Books VALUES (1, 'A Man Called Ove', 'Fredrik Backman', 'Contemporary Fiction');
INSERT INTO Books VALUES (2, 'Pride and Prejudice', 'Jane Austen', 'Classic Romance');
INSERT INTO Books VALUES (3, 'The Hobbit', 'J.R.R. Tolkien', 'Fantasy');
INSERT INTO Books VALUES (4, 'The Story of My Experiments with the Truth', 'Mahatma Gandhi ', 'Autobiography');
INSERT INTO Books VALUES(5,'A Guardian and a Thief ',' Megha Majumdar','Literary Fiction');
INSERT INTO Books VALUES (6, 'The Night We Met', 'Abby Jimenez', 'Romance/Contemporary');
INSERT INTO Books VALUES (7, 'A Thousand Splendid Suns', 'Khaled Hosseini', 'Historical Fiction');
INSERT INTO Books VALUES (8, 'The Picture of Dorian Gray', 'Oscar Wilde', 'Gothic Fiction');
INSERT INTO Books VALUES (9, 'Fahrenheit 451 ', 'Ray Bradbury', ' Dystopian/Sci-Fi');
INSERT INTO Books VALUES (10, 'Outlive ', 'Peter Attia', 'Health/Longevity');
INSERT INTO Books VALUES (11, 'Artificial Intelligence', 'Stuart Russell', 'Science');
INSERT INTO Books VALUES (12, 'Wings of Fire', 'A.P.J Abdul Kalam', 'Biography');

--Inserting data into Students table
INSERT INTO Students VALUES (101, 'Ishani', 'ishanimishra2004@gmail.com', DATE '2022-01-10', 'Active');
INSERT INTO Students VALUES (102, 'Tanisha', 'tanishamohnaty2003@gmail.com', DATE '2021-05-12', 'Active');
INSERT INTO Students VALUES (103, 'Rahul', 'rahulanand2002@gmail.com', DATE '2020-03-15', 'Active');
INSERT INTO Students VALUES(104,  'Amit','amitbikrama2002@gmail.com',DATE'2019-06-12','Active');
INSERT INTO Students VALUES (105, 'Priya', 'priyashi2005@gmail.com', DATE '2023-02-20', 'Active');
INSERT INTO Students VALUES (106, 'Karan', 'karanzohar2006@gmail.com', DATE '2018-11-05', 'Active');
INSERT INTO Students VALUES (107, 'Neha', 'nehakumari2004@gmail.com', DATE '2020-07-18', 'Active');
INSERT INTO Students VALUES (108, 'Rohit', 'rohitsharma2003@gmail.com', DATE '2021-09-25', 'Active');
INSERT INTO Students VALUES (109, 'Sneha', 'snehapatra2002@gmail.com', DATE '2017-03-14', 'Active');
INSERT INTO Students VALUES (110, 'Arjun', 'arjunkanungo2001@gmail.com', DATE '2022-12-01', 'Active');

--Inserting data into IssuedBooks table
INSERT INTO IssuedBooks VALUES (1, 101, 1, SYSDATE-20, NULL);
INSERT INTO IssuedBooks VALUES (2, 102, 2, SYSDATE-5, SYSDATE-1);
INSERT INTO IssuedBooks VALUES (3, 101, 3, SYSDATE-30, NULL);
INSERT INTO IssuedBooks VALUES (4, 103, 4, SYSDATE-2, NULL);
INSERT INTO IssuedBooks VALUES (5, 104, 5, SYSDATE-40, NULL);
INSERT INTO IssuedBooks VALUES (6, 105, 6, SYSDATE-3, SYSDATE-1);
INSERT INTO IssuedBooks VALUES (7, 106, 7, SYSDATE-60, NULL);
INSERT INTO IssuedBooks VALUES (8, 107, 8, SYSDATE-10, NULL);
INSERT INTO IssuedBooks VALUES (9, 108, 9, SYSDATE-25, NULL);
INSERT INTO IssuedBooks VALUES (10,109, 10, SYSDATE-400, NULL);

--OVERDUE BOOKS(More than 14 days and not returned)
SELECT s.Name_Of_Student,b.Title_Of_Book,i.Issue_Date
FROM IssuedBooks i
JOIN Students s ON i.Student_ID = s.Student_ID
JOIN Books b ON i.Book_ID = b.Book_ID
WHERE i.Return_Date IS NULL
AND i.Issue_Date < SYSDATE - 14;

--Most borrowed category
SELECT b.Category_Of_Book,COUNT(*) AS TotalBorrows
FROM IssuedBooks i
JOIN Books b ON i.Book_ID = b.Book_ID
GROUP BY b.Category_Of_Book
ORDER BY TotalBorrows DESC;

--Mark Inactive Students(Students who haven't borrowed any book in the last 3 Years)
UPDATE Students
SET Status = 'Inactive'
WHERE Student_ID NOT IN(
    SELECT DISTINCT Student_ID
     FROM IssuedBooks
     WHERE Issue_Date >= SYSDATE - (365 * 3)
);
