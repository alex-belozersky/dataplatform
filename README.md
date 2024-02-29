# dataplatform
Data Platform demo

# Демонстрационный репозиторий с вебинара VK Cloud

## Как построить аналитическую инфраструктуру уровня PRO своими руками или с небольшой командой

Запись вебинара доступна по ссылке
https://vk.com/vk__cloud?z=video-164978780_456239342%2Fln-JDpSV4oXbQzfGUiFCL%2Fpl_-164978780_-2
https://www.youtube.com/watch?v=1m9qqa9jGGE


## Содержание репозитория

В репозитории собран демонстрационный проект легковесной платформы данных на основе сервисов Airflow, DBT. В качестве хранилища данных используется Greenplum (Arenadata DB).


## Сетап / Шаги по воспроизведению 

Для воспроизведения платформы данных нужны

1) Установленный Apache Airflow. В примере использовался Airflow установленный на ВМ в virtualenv + стейт приложения хранился в DB-aaS PostgreSQL облака. 
2) В окружение Airflow установлены библиотеки из requirements.txt
3) БД Greenplum - в примере Arenadata DB 6.26 Enterprise Edition в облаке VK Cloud как PaaS
4) PXF коннектор к БД Airflow Postgres как именованный сервер
5) DBT profiles.yml с 2 настроенными окружениями test, prod с использованием коннектора dbt-greenplum
6) Apache Superset как пример BI. В вебинаре использовался демонстрационный сетап Superset 3.1 на основе docker-compose


## Хотите знать больше?

Канал "Данные на стероидах"
https://t.me/sterodata

Канал автора:
https://t.me/analyticsfromzero
