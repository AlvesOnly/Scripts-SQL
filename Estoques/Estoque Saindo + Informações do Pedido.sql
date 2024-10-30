/*
Autor: Igor Alves
Descrição:
Este script SQL busca informações sobre pedidos de venda em aberto, incluindo detalhes dos produtos, quantidade e valor de venda, 
além do estoque atual desses produtos. O filtro exclui registros logicamente deletados e transferências entre filiais.
*/

SELECT

    -- Informações de Estoque Saindo e Clientes

    C5_X_DESC,                                      -- Descrição do pedido
    ISNULL(A3_NOME, 'Sem Representante') AS 'A3_NOME', -- Nome do representante ou "Sem Representante" se não houver
    C5_X_CVEND,                                     -- Código do vendedor
    CASE C5_X_TPDIG                                 -- Tipo de pedido, traduzido de acordo com o código
        WHEN '1' THEN 'ECOMMERCE'                   -- Tipo de pedido: 1 = ECOMMERCE
        WHEN '2' THEN 'INVENTA'                     -- Tipo de pedido: 2 = INVENTA
        WHEN '3' THEN 'SHOPEE'                      -- Tipo de pedido: 3 = SHOPEE
        WHEN '4' THEN 'MERCADO LIVRE'               -- Tipo de pedido: 4 = MERCADO LIVRE
        ELSE 'B2B'                                  -- Tipo padrão: B2B (Business-to-Business)
    END AS 'C5_X_TPDIG',                            -- Tipo de pedido com descrição
    C5_NUM,                                         -- Número do pedido
    C5_CGCINT,                                      -- CNPJ do cliente
    C5_EMISSAO,                                     -- Data de emissão do pedido
    C5_FILIAL,                                      -- Filial onde o pedido foi realizado
    C6_PRODUTO,                                     -- Código do produto
    C6_DESCRI,                                      -- Descrição do produto
    C6_UM,                                          -- Unidade de medida do produto
    C6_QTDVEN,                                      -- Quantidade vendida do produto
    C6_VALOR,                                       -- Valor do produto no pedido

    -- Informações do Estoque Atual

    B2_FILIAL,                                      -- Filial onde o produto está em estoque
    B2_COD,                                         -- Código do produto no estoque
    B2_LOCAL,                                       -- Local de armazenamento do produto
    B1_UM,                                          -- Unidade de medida do produto no estoque
    B1_DESC,                                        -- Descrição do produto no estoque
    B2_QATU                                         -- Quantidade atual do produto em estoque

FROM
    SC6010                                          -- Tabela de itens dos pedidos
    INNER JOIN SC5010 ON                            -- Tabela de cabeçalho de pedidos
        C5_NUM = C6_NUM AND C6_FILIAL = C5_FILIAL   -- Junção pelo número do pedido e filial
    INNER JOIN SB1010 ON B1_COD = C6_PRODUTO        -- Tabela de produtos para buscar a descrição do produto
    LEFT JOIN SB2010 ON                             
        B1_COD = B2_COD AND B2_FILIAL = C6_FILIAL   -- Tabela de estoque atual, vinculando o produto com sua filial
    LEFT JOIN SA3010 ON A3_COD = C5_VEND1           -- Tabela de vendedores para obter o nome do representante

WHERE
    C5_LIBEROK = ''                                 -- Filtra apenas pedidos em aberto (não liberados para faturamento)
    AND B1_TIPO IN ('PA', 'ME', 'KT')               -- Filtra apenas produtos acabados, materiais e kits (PA, ME, KT)
    AND SC5010.D_E_L_E_T_ <> '*'                    -- Exclui registros deletados logicamente na tabela de cabeçalho de pedidos
    AND C6_TES <> '551'                             -- Exclui transações de transferência entre filiais (código TES 551)
    AND SB1010.D_E_L_E_T_ <> '*'                    -- Exclui registros deletados logicamente na tabela de produtos
    AND SB2010.D_E_L_E_T_ <> '*'                    -- Exclui registros deletados logicamente na tabela de estoque
    AND SC6010.D_E_L_E_T_ <> '*'                    -- Exclui registros deletados logicamente na tabela de itens dos pedidos
    AND SC5010.D_E_L_E_T_ <> '*'                    -- Exclui registros deletados logicamente na tabela de cabeçalho de pedidos
    AND SA3010.D_E_L_E_T_ <> '*'                    -- Exclui registros deletados logicamente na tabela de vendedores
    AND B2_FILIAL <> '01'                           -- Exclui produtos da filial 01
