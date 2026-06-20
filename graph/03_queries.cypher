// Вопрос 1: есть ли дубли СУ в одном абонементе?
// (в графе - повторяющееся ребро INCLUDES между той же парой узлов)
MATCH (s:Subscription)-[:INCLUDES]->(ss:SportService)
WITH s, ss, COUNT(*) AS occurrences
WHERE occurrences > 1
RETURN s.subscription_id, ss.sport_service_id, occurrences;

// Вопрос 2: самые популярные СУ (по числу абонементов)
MATCH (s:Subscription)-[:INCLUDES]->(ss:SportService)
RETURN ss.sport_service_id, ss.title, COUNT(s) AS subscriptions_count
ORDER BY subscriptions_count DESC;

// Вопрос 2: самые популярные СУ (по числу уникальных клиентов)
MATCH (c:Client)-[:HAS_SUBSCRIPTION]->(:Subscription)-[:INCLUDES]->(ss:SportService)
RETURN ss.sport_service_id, ss.title, COUNT(DISTINCT c) AS unique_clients_count
ORDER BY unique_clients_count DESC;

// Вопрос 3: рекомендации к услуге А (sport_service_id = 1)
MATCH (target:SportService {sport_service_id: 1})<-[:INCLUDES]-(s:Subscription)-[:INCLUDES]->(other:SportService)
WHERE other.sport_service_id <> target.sport_service_id
RETURN other.sport_service_id AS recommended_service_id, other.title AS recommended_service_title,
       COUNT(*) AS co_occurrence_count
ORDER BY co_occurrence_count DESC;

// Вопрос 4: устойчивые кластеры СУ (пары услуг с lift > 1)
MATCH (a:SportService)<-[:INCLUDES]-(s:Subscription)-[:INCLUDES]->(b:SportService)
WHERE a.sport_service_id < b.sport_service_id
WITH a, b, COUNT(DISTINCT s) AS support
WHERE support >= 2
MATCH (a)<-[:INCLUDES]-(sa:Subscription)
WITH a, b, support, COUNT(DISTINCT sa) AS a_count
MATCH (b)<-[:INCLUDES]-(sb:Subscription)
WITH a, b, support, a_count, COUNT(DISTINCT sb) AS b_count
MATCH (t:Subscription)
WITH a, b, support, a_count, b_count, COUNT(DISTINCT t) AS total
RETURN a.title AS service_a, b.title AS service_b, support AS times_together,
       ROUND( ((support * 1.0 / total) / ((a_count * 1.0 / total) * (b_count * 1.0 / total))) * 100 ) / 100 AS lift
ORDER BY lift DESC, support DESC;

// Пример ошибочной операции: не пройдёт, так как client_id = 1
// уже занят constraint-ом client_id_unique
CREATE (:Client {client_id: 1, surname: 'Дубликат', name: 'Тест', patronymic: null,
                  gender: 'М', birth_date: date('2000-01-01'),
                  phone: '+79009999999', email: 'duplicate@example.com'});
