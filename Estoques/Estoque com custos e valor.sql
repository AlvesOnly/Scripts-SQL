SELECT
    B1_DESC     AS 'NOME',                -- Nome do produto
    B1_COD      AS 'CODIGO',              -- Código do produto
    B2_LOCAL    AS 'ESTOQUE',             -- Código do armazém ou local de armazenamento do produto
    B2_QATU     AS 'QNTD',                -- Quantidade atual do produto em estoque
    B2_VFIM1    AS 'V FINAN',             -- Valor financeiro do estoque do produto (provavelmente o valor de venda)
    B2_VATU1    AS 'SALDO ATUAL EM VALOR',-- Valor total atual do estoque desse produto
    B2_CM1      AS 'CUSTO MEDIO',         -- Custo médio do produto no estoque
    B2_DMOV     AS 'DATA'                 -- Data do último movimento do estoque para esse produto

FROM
    SB2010                                -- Tabela de estoque, contendo dados sobre o produto em cada local
    INNER JOIN SB1010 ON B1_COD = B2_COD  -- Junção com a tabela de produtos, trazendo detalhes sobre o produto

WHERE
    B1_LOCPAD IN ('01', '02', '03', '04', '05', '06', '10', '11') -- Filtra para produtos em locais específicos (estoques principais)
    AND SB2010.D_E_L_E_T_ = ''            -- Exclui registros de estoque que foram deletados logicamente
    AND SB1010.D_E_L_E_T_ = ''            -- Exclui produtos que foram deletados logicamente na tabela principal
