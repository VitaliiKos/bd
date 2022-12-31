show tables;
# 1. знайти всі машини старші за 2000 р.
SELECT * FROM cars WHERE year > 2000;

# 2. знайти всі машини молодші 2015 р.
SELECT * FROM cars WHERE year < 2015;

# 3. знайти всі машини 2008, 2009, 2010 років
SELECT * FROM cars WHERE year IN (2008, 2009, 2010);

# 4. знайти всі машини не з цих років 2008, 2009, 2010
SELECT * FROM cars WHERE NOT year IN (2008, 2009, 2010);

# 5. знайти всі машини де year==price
SELECT * FROM cars WHERE year=price;

# 6. знайти всі машини bmw старші за 2014 р.
SELECT * FROM cars WHERE model = 'bmw' AND year > 2014;

# 7. знайти всі машини audi молодші 2014 р.
SELECT * FROM cars WHERE model = 'audi' AND year < 2014;

# 8. знайти перші 5 машин
SELECT * FROM cars LIMIT 5;

# 9. знайти останні 5 машин
SELECT * FROM cars ORDER BY id DESC LIMIT 5 ;

# 10. найти среднее арифметическое цен машин модели KIA
SELECT avg(price) AS average FROM cars WHERE model = 'KIA';

# 11. найти среднее арифметическое цен каждой машины
SELECT model, avg(price) AS average FROM cars GROUP BY model ORDER BY average DESC;

# 12. посчитать количество каждой марки машин
SELECT model, count(*) AS model_count FROM cars GROUP BY model ORDER BY model_count DESC;

# 13. найти марку машины количество которых больше всего
SELECT model, count(*) AS model_count FROM cars GROUP BY model ORDER BY model_count DESC LIMIT 1;

# 14. знайти марку машини в назві яких друга та передостання буква "a"
SELECT * FROM cars WHERE model LIKE '_a%a_';

# 15. знайти всі машини назва моделі яких більше за 8 символів
SELECT * FROM cars WHERE LENGTH(model) > 8;

# 16. ***знайти машини ціна котрих більше ніж ціна середнього арифметичного всіх машин
SELECT model, price FROM cars WHERE price > (SELECT avg(price) AS average FROM cars);
