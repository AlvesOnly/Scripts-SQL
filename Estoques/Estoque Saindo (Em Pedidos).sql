/*
Autor: Igor Alves
Descri��o: 
Script que seleciona informa��es de pedidos de venda que est�o em aberto, filtrando transfer�ncias entre filiais.
O c�digo traz detalhes dos produtos vendidos, como quantidade e valor, e inclui apenas os pedidos n�o liberados para faturamento.
*/

SELECT
    C5_NUM,                      -- N�mero do pedido
    C5_CGCINT,                   -- CNPJ do cliente interno
    C5_EMISSAO,                  -- Data de emiss�o do pedido
    C5_FILIAL,                   -- Filial do pedido
    C6_PRODUTO,                  -- C�digo do produto
    C6_DESCRI,                   -- Descri��o do produto
    C6_UM,                       -- Unidade de medida do produto
    C6_QTDVEN AS 'QTD',          -- Quantidade vendida do produto no pedido
    C6_VALOR AS 'VALOR'          -- Valor do produto no pedido

FROM
    SC6010                        -- Tabela de itens dos pedidos
    INNER JOIN SC5010 ON          -- Tabela de cabe�alhos de pedidos
        C5_NUM = C6_NUM           -- Jun��o pelo n�mero do pedido
        AND C6_FILIAL = C5_FILIAL -- Garantindo que a filial dos itens e do cabe�alho coincidem

WHERE
    C5_LIBEROK = ''               -- Filtra apenas pedidos que est�o em aberto (n�o liberados)
    AND SC5010.D_E_L_E_T_ = ''    -- Exclui registros logicamente deletados da tabela de cabe�alhos de pedidos
    AND SC6010.D_E_L_E_T_ = ''    -- Exclui registros logicamente deletados da tabela de itens dos pedidos
    AND C6_TES <> '551'           -- Exclui transfer�ncias entre filiais (TES 551)
