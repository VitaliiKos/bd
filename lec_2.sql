show tables;
# 1.Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
SELECT *
from client
WHERE LENGTH(FirstName) < 6;

# 2.Вибрати львівські відділення банку.
SELECT *
FROM department
WHERE DepartmentCity = 'LVIV';

# 3.Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
SELECT *
FROM client
WHERE Education LIKE 'high'
ORDER BY LastName;

# 4.Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
SELECT *
FROM application
ORDER BY idApplication DESC
LIMIT 5;

# 5.Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
SELECT *
FROM client
WHERE LastName LIKE '%IV'
   OR LastName LIKE '%KO';

# 6.Вивести клієнтів банку, які обслуговуються київськими відділеннями.
SELECT *
FROM client
         JOIN department ON department.idDepartment = client.Department_idDepartment
WHERE DepartmentCity = 'KYIV';

# 7.Знайти унікальні імена клієнтів.
SELECT DISTINCT idClient, FirstName
FROM client;

# 8.Вивести дані про клієнтів, які мають кредит більше ніж на 5000 гривень.
SELECT *
FROM client
         JOIN application on client.idClient = application.Client_idClient
WHERE Sum > 5000
  AND Currency = 'Gryvnia';
# 9.Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
SELECT COUNT(*) AS departmentClientCountByLvivDepartment
FROM client
         JOIN department on client.Department_idDepartment = department.idDepartment
WHERE DepartmentCity = 'LVIV';
#and
SELECT COUNT(*) AS departmentClientCountAllDepartment
FROM client
         JOIN department on client.Department_idDepartment = department.idDepartment;
#or
select (select count(*)
        from client
                 join department d on d.idDepartment = client.Department_idDepartment)
           AS departmentClientCountAllDepartment,
       (select count(*)
        from client
                 join department d on d.idDepartment = client.Department_idDepartment
        where DepartmentCity = 'lviv')
           AS departmentClientCountByLvivDepartment;

# 10.Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
SELECT MAX(Sum) AS MaxSum, client.*
FROM client
         JOIN application on client.idClient = application.Client_idClient
GROUP BY idClient;

# 11. Визначити кількість заявок на крдеит для кожного клієнта.
SELECT COUNT(*) AS ApplicationCount, client.*
FROM client
         JOIN application on client.idClient = application.Client_idClient
GROUP BY idClient;

# 12. Визначити найбільший та найменший кредити.
SELECT MAX(Sum) AS MaxCredit, MIN(Sum) AS MinCredit
FROM application;

# 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
SELECT COUNT(Sum) AS CountApplication, client.*
FROM client
         JOIN application on client.idClient = application.Client_idClient
WHERE client.Education = 'high'
GROUP BY idClient;

# 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
SELECT AVG(Sum) AS AvgSum, client.*
FROM client
         JOIN application on client.idClient = application.Client_idClient
GROUP BY idClient
ORDER BY AvgSum DESC
LIMIT 1;

# 15. Вивести відділення, яке видало в кредити найбільше грошей
SELECT SUM(Sum) AS SumCredit, department.*
FROM department
         JOIN client on department.idDepartment = client.Department_idDepartment
         JOIN application on client.idClient = application.Client_idClient
GROUP BY idDepartment
ORDER BY SumCredit DESC
LIMIT 1;
# 16. Вивести відділення, яке видало найбільший кредит.
SELECT MAX(Sum) AS MaxCredit, department.*
FROM department
         JOIN client on department.idDepartment = client.Department_idDepartment
         JOIN application on client.idClient = application.Client_idClient
GROUP BY idDepartment
ORDER BY MaxCredit DESC
LIMIT 1;

# 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
UPDATE client JOIN application on client.idClient = application.Client_idClient
SET Sum      = 6000,
    Currency = 'Gryvnia'
WHERE Education = 'high';

# 18. Усіх клієнтів київських відділень пересилити до Києва.
UPDATE client JOIN department on department.idDepartment = client.Department_idDepartment
SET City = 'KYIV'
WHERE Department_idDepartment = 1
   OR Department_idDepartment = 4;

# 19. Видалити усі кредити, які є повернені.
DELETE
FROM application
WHERE CreditState = 'Returned';

# 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
DELETE application
FROM application
         join client on client.idClient = application.Client_idClient
WHERE LastName LIKE '_a%'
   OR LastName LIKE '_o%'
   OR LastName LIKE '_e%'
   OR LastName LIKE '_i%'
   OR LastName LIKE '_y%'
   OR LastName LIKE '_u%'
;
# 21.Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
SELECT SUM(Sum) AS SumCredit, idDepartment, DepartmentCity
FROM department
         JOIN client on department.idDepartment = client.Department_idDepartment
         JOIN application on client.idClient = application.Client_idClient
WHERE DepartmentCity = 'LVIV'
GROUP BY idDepartment
HAVING SumCredit > 5000;

# 22.Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
SELECT *
FROM client
         JOIN application on client.idClient = application.Client_idClient
         JOIN department on department.idDepartment = client.Department_idDepartment
WHERE CreditState = 'Returned'
  AND Sum > 5000;
# 23.Знайти максимальний неповернений кредит.
SELECT *
FROM application
WHERE CreditState = 'Not returned'
ORDER BY Sum DESC
LIMIT 1;

# 24.Знайти клієнта, сума кредиту якого найменша
SELECT Sum, client.*
FROM client
         JOIN application on client.idClient = application.Client_idClient
ORDER BY Sum
LIMIT 1;

# 25.Знайти кредити, сума яких більша за середнє значення усіх кредитів
SELECT Sum
FROM application
WHERE Sum > (SELECT AVG(Sum) FROM application);

# 26. Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів
SELECT *
FROM client
WHERE City = (SELECT City
              FROM client
                       JOIN application a on client.idClient = a.Client_idClient
              GROUP BY idClient
              ORDER BY COUNT(idApplication) DESC
              LIMIT 1);

# 27. Місто клієнта з найбільшою кількістю кредитів
SELECT City
FROM client
         JOIN application a on client.idClient = a.Client_idClient
GROUP BY idClient
ORDER BY COUNT(idApplication) DESC
LIMIT 1;