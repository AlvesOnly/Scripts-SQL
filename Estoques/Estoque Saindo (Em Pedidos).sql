/*
Autor: Igor Alves
Descrição: 
Script que seleciona informações de pedidos de venda que estão em aberto, filtrando transferências entre filiais.
O código traz detalhes dos produtos vendidos, como quantidade e valor, e inclui apenas os pedidos não liberados para faturamento.
*/

SELECT
    C5_NUM,                      -- Número do pedido
    C5_CGCINT,                   -- CNPJ do cliente interno
    C5_EMISSAO,                  -- Data de emissão do pedido
    C5_FILIAL,                   -- Filial do pedido
    C6_PRODUTO,                  -- Código do produto
    C6_DESCRI,                   -- Descrição do produto
    C6_UM,                       -- Unidade de medida do produto
    C6_QTDVEN AS 'QTD',          -- Quantidade vendida do produto no pedido
    C6_VALOR AS 'VALOR'          -- Valor do produto no pedido

FROM
    SC6010                        -- Tabela de itens dos pedidos
    INNER JOIN SC5010 ON          -- Tabela de cabeçalhos de pedidos
        C5_NUM = C6_NUM           -- Junção pelo número do pedido
        AND C6_FILIAL = C5_FILIAL -- Garantindo que a filial dos itens e do cabeçalho coincidem

WHERE
    C5_LIBEROK = ''               -- Filtra apenas pedidos que estão em aberto (não liberados)
    AND SC5010.D_E_L_E_T_ = ''    -- Exclui registros logicamente deletados da tabela de cabeçalhos de pedidos
    AND SC6010.D_E_L_E_T_ = ''    -- Exclui registros logicamente deletados da tabela de itens dos pedidos
    AND C6_TES <> '551'           -- Exclui transferências entre filiais (TES 551)
