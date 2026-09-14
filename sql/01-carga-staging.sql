-- =====================================================
-- 01-carga-staging.sql
-- Cria e carrega as tabelas staging
-- =====================================================

DROP TABLE IF EXISTS stg_pedido CASCADE;
CREATE TABLE stg_pedido (
    "NumeroPedido" VARCHAR(100),
    "DtHoraPedido" VARCHAR(100),
    "CategoriaProduto" VARCHAR(200),
    "QTD.Itens" VARCHAR(50),
    "ValorLiquidoPedido(R$)" VARCHAR(100),
    "HouveDesconto" VARCHAR(50),
    "CanalPedido" VARCHAR(50),
    "Cod Loja" VARCHAR(50),
    "Loja-Nome" VARCHAR(200),
    "DtHoraIntegracaoERP" VARCHAR(100),
    "Dt Separacao Estoque" VARCHAR(100),
    "DtNotaFiscal" VARCHAR(100),
    "Dt_Despacho_Transportador" VARCHAR(100),
    "DtEntregaCliente" VARCHAR(100),
    "ValorBruto" VARCHAR(100)
);

DROP TABLE IF EXISTS stg_loja CASCADE;
CREATE TABLE stg_loja (
    "Cod Loja" VARCHAR(50),
    "Loja-Nome" VARCHAR(200),
    "Cidade" VARCHAR(100),
    "UF" VARCHAR(10),
    "Mesorregiao" VARCHAR(100),
    "Populacao_Cidade" VARCHAR(50),
    "Area_Venda_m2" VARCHAR(50),
    "Porte" VARCHAR(50),
    "Faixa_Franquia" VARCHAR(50),
    "Formato_Loja" VARCHAR(50)
);

DROP TABLE IF EXISTS stg_loja_praca CASCADE;
CREATE TABLE stg_loja_praca (
    "Cod Loja" VARCHAR(50),
    "Cod_Praca" VARCHAR(50),
    "Nome_Praca" VARCHAR(200),
    "Regional" VARCHAR(100),
    "Domicilios_Com_Pet" VARCHAR(50),
    "Percentual_Publico" VARCHAR(50)
);
