-- Вопрос 1: есть ли дубли СУ в одном абонементе?
SELECT subscription_id, sport_service_id, COUNT(*) AS occurrences
FROM SubscriptionItem
GROUP BY subscription_id, sport_service_id
HAVING COUNT(*) > 1;

-- Вопрос 2: самые популярные СУ (по числу абонементов)
SELECT ss.sport_service_id, ss.title, COUNT(si.subscription_id) AS subscriptions_count
FROM SportService ss
JOIN SubscriptionItem si ON si.sport_service_id = ss.sport_service_id
GROUP BY ss.sport_service_id, ss.title
ORDER BY subscriptions_count DESC;

-- Вопрос 2: самые популярные СУ (по числу уникальных клиентов)
SELECT ss.sport_service_id, ss.title, COUNT(DISTINCT s.client_id) AS unique_clients_count
FROM SportService ss
JOIN SubscriptionItem si ON si.sport_service_id = ss.sport_service_id
JOIN Subscription s ON s.subscription_id = si.subscription_id
GROUP BY ss.sport_service_id, ss.title
ORDER BY unique_clients_count DESC;

-- Вопрос 3: рекомендации к услуге А (sport_service_id = 1)
SELECT other.sport_service_id AS recommended_service_id, other_service.title AS recommended_service_title,
       COUNT(*) AS co_occurrence_count
FROM SubscriptionItem AS target
JOIN SubscriptionItem AS other
    ON other.subscription_id = target.subscription_id
   AND other.sport_service_id <> target.sport_service_id
JOIN SportService AS other_service ON other_service.sport_service_id = other.sport_service_id
WHERE target.sport_service_id = 1
GROUP BY other.sport_service_id, other_service.title
ORDER BY co_occurrence_count DESC;

-- Вопрос 4: устойчивые кластеры СУ (пары услуг с lift > 1)
WITH service_subscription_count AS (
    SELECT sport_service_id, COUNT(DISTINCT subscription_id) AS subs_count
    FROM SubscriptionItem
    GROUP BY sport_service_id
),
total_subscriptions AS (
    SELECT COUNT(DISTINCT subscription_id) AS total FROM Subscription
),
pairs AS (
    SELECT a.sport_service_id AS service_a_id, b.sport_service_id AS service_b_id,
           COUNT(DISTINCT a.subscription_id) AS support
    FROM SubscriptionItem a
    JOIN SubscriptionItem b
        ON a.subscription_id = b.subscription_id
       AND a.sport_service_id < b.sport_service_id
    GROUP BY a.sport_service_id, b.sport_service_id
)
SELECT sa.title AS service_a, sb.title AS service_b, p.support AS times_together,
    ROUND((p.support * 1.0 / t.total) / ((sca.subs_count * 1.0 / t.total) * (scb.subs_count * 1.0 / t.total)), 2) AS lift
FROM pairs p
JOIN SportService sa ON sa.sport_service_id = p.service_a_id
JOIN SportService sb ON sb.sport_service_id = p.service_b_id
JOIN service_subscription_count sca ON sca.sport_service_id = p.service_a_id
JOIN service_subscription_count scb ON scb.sport_service_id = p.service_b_id
JOIN total_subscriptions t
WHERE p.support >= 2
ORDER BY lift DESC, p.support DESC;

-- Пример ошибочного INSERT: не пройдёт, так как пара
-- (subscription_id=1, sport_service_id=8) уже есть в SubscriptionItem,
-- а на неё стоит UNIQUE-индекс
INSERT INTO SubscriptionItem (subscription_id, sport_service_id) VALUES (1, 8);