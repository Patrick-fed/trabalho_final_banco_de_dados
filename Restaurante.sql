CREATE TABLE cliente(
  id SERIAL PRIMARY KEY NOT NULL,
  nome VARCHAR(40) NOT NULL
);
CREATE TABLE pedido(
  id SERIAL PRIMARY KEY NOT NULL,
  id_cliente INTEGER NOT NULL,
  data_pedido DATE DEFAULT CURRENT_DATE NOT NULL,
  CONSTRAINT id_cliente_fk FOREIGN KEY (id_cliente) REFERENCES cliente (id)
);
CREATE TABLE itens(
  id SERIAL PRIMARY KEY NOT NULL,
  item VARCHAR(50) NOT NULL,
  preco INTEGER NOT NULL,
  despesa_item INTEGER NOT NULL
);
CREATE TABLE cardapio(
  id SERIAL PRIMARY KEY NOT NULL,
  itens_id INTEGER NOT NULL,
  CONSTRAINT id_item_fk FOREIGN KEY (itens_id) REFERENCES itens (id)
);
CREATE TABLE item_pedido(
  id SERIAL PRIMARY KEY NOT NULL,
  id_pedido INTEGER NOT NULL,
  id_cardapio INTEGER NOT NULL,
  CONSTRAINT id_pedido_fk FOREIGN KEY (id_pedido) REFERENCES pedido (id),
  CONSTRAINT id_cardapio_fk FOREIGN KEY (id_cardapio) REFERENCES cardapio (id)
);

DROP TABLE item_pedido;
DROP TABLE cardapio CASCADE;

INSERT INTO cliente (nome) VALUES('Patrick');
INSERT INTO cliente (nome) VALUES('Ronaldo');
INSERT INTO cliente (nome) VALUES('Samuel');
INSERT INTO cliente (nome) VALUES('Lucas');
INSERT INTO cliente (nome) VALUES('Bruno');
INSERT INTO cliente (nome) VALUES('Luis');
INSERT INTO cliente (nome) VALUES('Josefino Jackson');
INSERT INTO cliente (nome) VALUES('Gustavo Barros Moles');

INSERT INTO itens (item, preco, despesa_item) VALUES('coca cola', 600, 400);
INSERT INTO itens (item, preco, despesa_item) VALUES('bife acebolado', 3000, 1500);
INSERT INTO itens (item, preco, despesa_item) VALUES('batata frita', 1600, 1000);
INSERT INTO itens (item, preco, despesa_item) VALUES('pepsi twist', 620, 400);
INSERT INTO itens (item, preco, despesa_item) VALUES('costelinha de porco', 2500, 1000);
INSERT INTO itens (item, preco, despesa_item) VALUES('frango xadrez', 3200, 900);
INSERT INTO itens (item, preco, despesa_item) VALUES('coq au vin', 20000, 400);

INSERT INTO pedido(id_cliente) VALUES (1);
INSERT INTO pedido(id_cliente) VALUES (2);
INSERT INTO pedido(id_cliente) VALUES (3);
INSERT INTO pedido(id_cliente) VALUES (4);
INSERT INTO pedido(id_cliente) VALUES (5);
INSERT INTO pedido(id_cliente) VALUES (6);
INSERT INTO pedido(id_cliente) VALUES (7);

INSERT INTO cardapio(itens_id) VALUES (1);
INSERT INTO cardapio(itens_id) VALUES (2);
INSERT INTO cardapio(itens_id) VALUES (3);
INSERT INTO cardapio(itens_id) VALUES (4);
INSERT INTO cardapio(itens_id) VALUES (5);
INSERT INTO cardapio(itens_id) VALUES (6);

INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (1,2);
INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (2,3);
INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (3,4);
INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (4,5);
INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (5,2);
INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (5,2);

INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (1, 1); -- coca cola
INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (1, 2); -- bife acebolado
INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (1, 3); -- batata frita

INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (2, 2); 
INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (2, 3); 

INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (3, 7); -- coq au vin (20.000)
INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (3, 1); 

INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (4, 1);
INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (4, 2);
INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (4, 3);
INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (4, 4);
INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (4, 5);
INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (4, 6);

INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (5, 3);
INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (5, 3);
INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (5, 1);

INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (6, 4);
INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (6, 1);

INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (7, 6);
INSERT INTO item_pedido(id_pedido, id_cardapio) VALUES (7, 5);

SELECT c.nome, p.id, p.data_pedido
FROM pedido p
INNER JOIN cliente c ON c.id = p.id_cliente;

SELECT c.nome,
 p.data_pedido,
 ip.id_cardapio, 
 card.itens_id, 
 i.nome AS nome_item FROM item_pedido ip
INNER JOIN cardapio card ON card.id = ip.id_cardapio
INNER JOIN itens i ON i.id = card.itens_id
INNER JOIN pedido p ON p.id = ip.id_pedido
INNER JOIN cliente c ON c.id = p.id_cliente;

ALTER TABLE item_pedido DROP column id_cardapio;
ALTER TABLE item_pedido ADD COLUMN id_itens INT;
ALTER TABLE item_pedido ADD constraint id_item_fk FOREIGN KEY (id_itens) REFERENCES itens (id);

-- 1 Quais são os itens mais vendidos do cardápio?

SELECT i.item AS nome_item,
COUNT(ip.id_itens) AS total_vendido
FROM item_pedido ip
INNER JOIN itens i ON i.id = ip.id_itens
GROUP BY i.id, i.item
ORDER BY total_vendido DESC;


-- 2 Quais clientes realizaram o maior número de pedidos no último mês?

SELECT c.nome,
COUNT(DISTINCT p.id) AS total_pedidos,
SUM(i.preco) AS total_gasto_no_mes
FROM cliente AS c
INNER JOIN pedido AS p ON c.id = p.id_cliente
INNER JOIN item_pedido AS ip ON p.id = ip.id_pedido
INNER JOIN itens AS i ON ip.id_itens = i.id
WHERE p.data_pedido >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY c.nome
ORDER BY total_pedidos DESC;


-- 3 Quais itens foram pedidos em determinado pedido específico?

SELECT i.item AS nome_item, c.nome, p.id
FROM item_pedido ip
INNER JOIN itens i ON i.id = ip.id_itens
INNER JOIN pedido p ON p.id = ip.id_pedido
INNER JOIN cliente c ON c.id = p.id_cliente
WHERE p.id = 1;


-- 4 Quais clientes gastaram mais de R$ 500 no último mês?

SELECT
c.nome,
SUM(i.preco) AS total_gasto_no_mes FROM cliente AS c
INNER JOIN pedido AS p ON c.id = p.id_cliente
inner JOIN item_pedido AS ip ON p.id = ip.id_pedido
inner JOIN itens AS i ON ip.id_itens = i.id
WHERE p.data_pedido >= '2025-11-07'
GROUP BY c.nome
HAVING SUM(i.preco)>500;


-- 5 Quais itens são mais frequentemente vendidos em conjunto?

SELECT 
LEAST(i1.item, i2.item) AS item_a,
GREATEST(i1.item, i2.item) AS item_b,
COUNT(*) AS vezes_vendidos_juntos
FROM item_pedido ip1
INNER JOIN item_pedido ip2 
    ON ip1.id_pedido = ip2.id_pedido
   AND ip1.id_item < ip2.id_item       
JOIN itens i1 ON i1.id = ip1.id_item
JOIN itens i2 ON i2.id = ip2.id_item
GROUP BY 
    LEAST(i1.item, i2.item),
    GREATEST(i1.item, i2.item)
ORDER BY vezes_vendidos_juntos DESC;


-- 6 Quais pratos do cardápio são os mais lucrativos (maior diferença entre custo e preço de venda)?

select  item,  preco,  despesa_item, 
(preco - despesa_item) as lucro
from itens
order by lucro desc;

-- 7 Qual cliente realizou o pedido mais caro?

select 
  c.nome, 
  sum(i.preco) as valor_total_pedido
from Cliente as c
inner join pedido as p on c.id = p.id_cliente
inner join item_pedido as ip on p.id = ip.id_pedido
inner join itens as i on ip.id_itens = i.id
group by c.nome, p.id
order by valor_total_pedido desc
limit 1;

-- 8 Quais pedidos estão associados a mais de cinco itens?

SELECT p.id AS id_pedido, c.nome AS cliente,
COUNT(ip.id_item) AS quantidade_itens
FROM pedido p
JOIN cliente c ON c.id = p.id_cliente
JOIN item_pedido ip ON ip.id_pedido = p.id
GROUP BY p.id, c.nome
HAVING COUNT(ip.id_item) > 5
ORDER BY quantidade_itens DESC;

SELECT * FROM item_pedido;
SELECT * FROM cliente;
SELECT * FROM itens;
SELECT * FROM pedido;
