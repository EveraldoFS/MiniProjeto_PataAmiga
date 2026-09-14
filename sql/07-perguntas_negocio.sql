-- =====================================================
-- 07-perguntas_negocio.sql
-- Responde as 5 perguntas de negócio
-- =====================================================

-- =====================================================
-- P1: ONDE ESTÁ O GARGALO DA ENTREGA?
-- =====================================================

SELECT 
    'Integração → Separação' AS etapa,
    ROUND(AVG(dias_integracao_separacao), 2) AS dias_medio
FROM fato_pedido WHERE dias_integracao_separacao IS NOT NULL
UNION ALL
SELECT 'Separação → Nota Fiscal', ROUND(AVG(dias_separacao_nota), 2)
FROM fato_pedido WHERE dias_separacao_nota IS NOT NULL
UNION ALL
SELECT 'Nota Fiscal → Despacho', ROUND(AVG(dias_nota_despacho), 2)
FROM fato_pedido WHERE dias_nota_despacho IS NOT NULL
UNION ALL
SELECT 'Despacho → Entrega', ROUND(AVG(dias_despacho_entrega), 2)
FROM fato_pedido WHERE dias_despacho_entrega IS NOT NULL
UNION ALL
SELECT 'TOTAL (ERP → Entrega)', ROUND(AVG(dias_total_ate_entrega), 2)
FROM fato_pedido WHERE dias_total_ate_entrega IS NOT NULL;

-- =====================================================
-- P2: QUAL CATEGORIA CONCENTRA O FATURAMENTO?
-- =====================================================

SELECT 
    dc.nome_categoria,
    ROUND(SUM(fp.vl_liquido)::NUMERIC, 2) AS faturamento,
    ROUND(100.0 * SUM(fp.vl_liquido) / (SELECT SUM(vl_liquido) FROM fato_pedido), 2) AS percentual
FROM fato_pedido fp
JOIN dim_categoria dc ON fp.sk_categoria = dc.sk_categoria
WHERE fp.sk_categoria != -1
GROUP BY dc.nome_categoria
ORDER BY faturamento DESC;

-- =====================================================
-- P3: O DESCONTO FUNCIONA IGUAL EM TODO CANAL?
-- =====================================================

SELECT 
    canal_pedido,
    houve_desconto,
    COUNT(*) AS total_pedidos,
    ROUND(AVG(vl_liquido)::NUMERIC, 2) AS ticket_medio,
    ROUND(SUM(vl_liquido)::NUMERIC, 2) AS faturamento
FROM fato_pedido
WHERE vl_liquido IS NOT NULL
GROUP BY canal_pedido, houve_desconto
ORDER BY canal_pedido, houve_desconto;

-- =====================================================
-- P4: QUAL PRAÇA CONCENTRA O FATURAMENTO?
-- =====================================================

WITH faturamento_loja AS (
    SELECT dl.cod_loja, SUM(fp.vl_liquido) AS faturamento_loja
    FROM fato_pedido fp
    JOIN dim_loja dl ON fp.sk_loja = dl.sk_loja
    WHERE fp.sk_loja != -1 AND fp.vl_liquido IS NOT NULL
    GROUP BY dl.cod_loja
)
SELECT 
    dp.regional,
    ROUND(SUM(fl.faturamento_loja * bp.fator_publico)::NUMERIC, 2) AS faturamento_rateado,
    ROUND(100.0 * SUM(fl.faturamento_loja * bp.fator_publico) / (SELECT SUM(vl_liquido) FROM fato_pedido), 2) AS percentual
FROM faturamento_loja fl
JOIN bridge_loja_praca bp ON fl.cod_loja = bp.cod_loja
JOIN dim_praca dp ON bp.sk_praca = dp.sk_praca
GROUP BY dp.regional
ORDER BY faturamento_rateado DESC;

-- =====================================================
-- P5a: RANKING DE LOJAS POR ITENS/1000 HAB
-- =====================================================

SELECT 
    dl.nome_loja,
    dl.cidade,
    dl.populacao_cidade,
    SUM(fp.qt_itens) AS total_itens,
    ROUND(SUM(fp.qt_itens)::NUMERIC / NULLIF(dl.populacao_cidade, 0) * 1000, 2) AS itens_por_mil_hab,
    ROUND(AVG(fp.dias_total_ate_entrega), 2) AS tempo_medio_entrega,
    dl.faixa_franquia
FROM fato_pedido fp
JOIN dim_loja dl ON fp.sk_loja = dl.sk_loja
WHERE fp.sk_loja != -1 AND dl.populacao_cidade > 0 AND fp.dias_total_ate_entrega IS NOT NULL
GROUP BY dl.nome_loja, dl.cidade, dl.populacao_cidade, dl.faixa_franquia
ORDER BY itens_por_mil_hab DESC;

-- =====================================================
-- P5b: FATURAMENTO POR FAIXA ATUAL
-- =====================================================

SELECT 
    dl.faixa_franquia,
    COUNT(DISTINCT dl.cod_loja) AS total_lojas,
    ROUND(SUM(fp.vl_liquido)::NUMERIC, 2) AS faturamento,
    ROUND(100.0 * SUM(fp.vl_liquido) / (SELECT SUM(vl_liquido) FROM fato_pedido), 2) AS percentual
FROM fato_pedido fp
JOIN dim_loja dl ON fp.sk_loja = dl.sk_loja
WHERE fp.sk_loja != -1 AND fp.vl_liquido IS NOT NULL
GROUP BY dl.faixa_franquia
ORDER BY faturamento DESC;

-- =====================================================
-- P5c: O QUE FICOU DE FORA
-- =====================================================

SELECT 'Pedidos sem loja' AS metrica, COUNT(*)::TEXT AS valor FROM fato_pedido WHERE sk_loja = -1
UNION ALL
SELECT 'Entregas não concluídas', COUNT(*)::TEXT FROM fato_pedido WHERE sk_tempo_entrega = -1
UNION ALL
SELECT 'Itens em branco', COUNT(*)::TEXT FROM fato_pedido WHERE qt_itens IS NULL
UNION ALL
SELECT 'Valores em branco', COUNT(*)::TEXT FROM fato_pedido WHERE vl_liquido IS NULL
UNION ALL
SELECT 'Total de pedidos', COUNT(*)::TEXT FROM fato_pedido;
