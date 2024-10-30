/*
Autor: Igor Alves
Descrição: Script que retorna o estoque atual dos produtos em diferentes filiais e armazéns, 
com filtros para excluir produtos bloqueados, itens deletados e produtos em uma filial específica.
*/

SELECT
    B2_FILIAL	AS 'FILIAL',             -- Código da filial onde o produto está localizado
    B2_COD		AS 'COD PRODUTO',        -- Código do produto
    B1_DESC		AS 'DESC PRODUTO',       -- Descrição do produto
    B2_LOCAL	AS 'ARMAZEM',            -- Código do armazém onde o produto está armazenado
    B1_UM		AS 'UN MEDIDA',          -- Unidade de medida do produto
    B2_QATU		AS 'QUANTIDADE',         -- Quantidade atual do produto em estoque
    B1_TIPO		AS 'TIPO'                -- Tipo de produto (PA para produto acabado, ME para material em estoque)

FROM
    SB1010                                -- Tabela principal de produtos (contém detalhes do produto)
    LEFT JOIN SB2010 ON B1_COD = B2_COD   -- Junção com a tabela de estoque por código de produto, trazendo os dados de estoque

WHERE
    B1_TIPO IN ('PA', 'ME')               -- Filtra para incluir apenas produtos acabados (PA) e materiais em estoque (ME)
    AND SB1010.D_E_L_E_T_ = ''            -- Exclui produtos que foram deletados logicamente (marcação de exclusão)
    AND SB2010.D_E_L_E_T_ = ''            -- Exclui registros de estoque que foram deletados logicamente
    AND B2_FILIAL <> '01'                 -- Exclui registros de estoque da filial 01
    AND B1_MSBLQL = '2'                   -- Exclui produtos bloqueados (indicador de bloqueio de movimentação de estoque)
    AND B2_LOCAL < 10                     -- Filtra para incluir apenas armazéns com código menor que 10 (possivelmente armazenamento específico)
