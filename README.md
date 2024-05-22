## Разработка приложений СУБД

### Задание 2

* Запросите должности сотрудников из таблицы EMP.
* Подсчитайте количество сотрудников в каждом департаменте.
* Найдите среднюю зарплату по каждой должности.
* Определите минимальную и максимальную зарплату по каждой должности.
* Подсчитайте суммарную зарплату по каждому департаменту.
* Сформируйте все возможные пары менеджеров.

### Задание 3

* Просмотрите системные табличные представления (ALL_TABLES, USER_TABLES).
* Выведите содержимое таблицы из ALL_TABLES, не присутствующей в USER_TABLES.
* Создайте таблицу с базовыми типами данных.
* Создайте несколько таблиц с типами правил целостности.
* Добавьте правило целостности к таблице EMP, ограничивающее размер зарплаты. Убедитесь, что оно будет отображаться в соответствующем системном представлении.
* Исследуйте представления, связанные с индексами.
* Подсчитайте количество индексов в своей схеме.
* Создайте и заполните индексно-организованную таблицу DEPT1.

### Задание 4

* Создайте представления:
    + cотрудники, принятые на работу зимой;  
    + начальники с не менее чем тремя подчиненными. 
* Создайте секвенцию для DEPT1 (CASH = 20) и сгенерируйте 10 значений.
* Создайте функции:
    + для вычисления факториала числа;
    + для подсчета дней работы сотрудников;
    + для списка начальников сотрудников.
* Создайте процедуру для статистики по сотрудникам и департаментам.
* Создайте таблицу debug_log и секвенцию для нее.
* Создайте процедуру для определения дат приема на работу сотрудников и записи в debug_log.
* Создайте процедуру для фиксации динамических ошибок.
* Спровоцируйте и зафиксируйте 3 разных динамических ошибки в debug_log.

### Задание 5

* Создайте триггер для автоматической генерации значений с использованием секвенции.
* Создайте триггер для автоматической генерации значений без секвенции.
* Создайте триггер для записи в журнал событий создания, изменения и удаления объектов.

### Задание 6

Напишите 3 запроса с использованием подсказок оптимизатору.

### Задание 9

* Создайте таблицу с ненормированными данными (не менее 200 записей, минимум 3 показателя).
* Выберите нормировку и постройте целевую функцию.
* Найдите лучших представителей по результатам целевой функции.

### Задание 10

На основе данных из файла electric power.xml создайте аналитический запрос о суммарном потреблении электроэнергии за указанные периоды.

### Задание 12

Создайте приложение для выполнения и журналирования задания. Задание должно создавать точку с координатами в вспомогательной таблице.
