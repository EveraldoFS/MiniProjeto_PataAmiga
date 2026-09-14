-- =====================================================
-- 06-conferencia.sql
-- Valida os números do projeto
-- =====================================================

-- 1. Total de pedidos (deve ser 4.044)
SELECT COUNT(*) AS total_pedidos FROM fato_pedido;

-- 2. Faturamento total (deve ser 1.793.308,51)
SELECT ROUND(SUM(vl_liquido)::NUMERIC, 2) AS faturamento_total FROM fato_pedido;

-- 3. Pedidos sem loja (deve ser 3)
SELECT COUNT(*) AS sem_loja FROM fato_pedido WHERE sk_loja = -1;

-- 4. Pedidos sem categoria (deve ser 0)
SELECT COUNT(*) AS sem_categoria FROM fato_pedido WHERE sk_categoria = -1;

-- 5. Pedidos sem tempo de pedido (deve ser 0)
SELECT COUNT(*) AS sem_tempo_pedido FROM fato_pedido WHERE sk_tempo_pedido = -1;

-- 6. Pedidos sem entrega (deve ser 1.953)
SELECT COUNT(*) AS sem_entrega FROM fato_pedido WHERE sk_tempo_entrega = -1;
