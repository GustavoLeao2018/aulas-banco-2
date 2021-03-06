PGDMP     ,    ;    	            w            petshop    11.0    11.0 s    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    41002    petshop    DATABASE     �   CREATE DATABASE petshop WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Portuguese_Brazil.1252' LC_CTYPE = 'Portuguese_Brazil.1252';
    DROP DATABASE petshop;
             postgres    false            �            1255    41003    areacirc(numeric)    FUNCTION     �   CREATE FUNCTION public.areacirc(numeric) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$select  PI()*power($1,2);$_$;
 (   DROP FUNCTION public.areacirc(numeric);
       public       postgres    false            �            1255    41004    areaq(numeric)    FUNCTION     w   CREATE FUNCTION public.areaq(numeric) RETURNS numeric
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$select  $1 * $1;$_$;
 %   DROP FUNCTION public.areaq(numeric);
       public       postgres    false            �            1255    41005    areatri(numeric, numeric)    FUNCTION     �   CREATE FUNCTION public.areatri(numeric, numeric) RETURNS numeric
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$select  $1 * $2/2;$_$;
 0   DROP FUNCTION public.areatri(numeric, numeric);
       public       postgres    false            �            1255    41006    get_id(character varying)    FUNCTION     E  CREATE FUNCTION public.get_id(character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
        variavel_id INTEGER;
BEGIN
        SELECT INTO variavel_id id FROM usuario 
                WHERE upper(nm_login) = upper($1);--para achar qualquer situação de digitação
        RETURN variavel_id;
END;
$_$;
 0   DROP FUNCTION public.get_id(character varying);
       public       postgres    false            �            1255    41007 $   mediapond(numeric, numeric, numeric)    FUNCTION     �   CREATE FUNCTION public.mediapond(numeric, numeric, numeric) RETURNS numeric
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$select  ($1*5+$2*3+$3*2) / (5+3+2);$_$;
 ;   DROP FUNCTION public.mediapond(numeric, numeric, numeric);
       public       postgres    false            �            1255    41008 9   set_tentativa_login(character varying, character varying)    FUNCTION     ^  CREATE FUNCTION public.set_tentativa_login(character varying, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
        registro RECORD;
        tentativas INTEGER;
BEGIN
        --raise notice 'teste'; 
        SELECT INTO registro id, fg_bloqueado, nu_tentativa_login FROM usuario 
                            WHERE nm_login = $1 AND ds_senha = $2;
        IF registro IS NULL -- Não encontrou Login nem senha correspondente
        THEN
            SELECT INTO tentativas nu_tentativa_login FROM usuario 
                            WHERE nm_login = $1;
            tentativas := tentativas + 1;
            IF tentativas > 2 -- verifica numero de tentativas 
            THEN 
               
                UPDATE usuario SET nu_tentativa_login = tentativas, 
                                  fg_bloqueado = TRUE where nm_login = $1;
                
                RAISE notice 'Ultrapassou numero de tentativas válidas';
            ELSE
                UPDATE usuario SET nu_tentativa_login = tentativas 
                                  where nm_login = $1;
            END IF;
        ELSE  --Encontrou Login e senha correspondente
            Raise notice 'Usuario e senha OK!'; -- Mensagem mostrada na area de mensagens
            UPDATE usuario SET nu_tentativa_login = 0 where nm_login = $1;
            
        END IF;
END;
$_$;
 P   DROP FUNCTION public.set_tentativa_login(character varying, character varying);
       public       postgres    false            �            1255    41009     somar_inteiros(integer, integer)    FUNCTION     �   CREATE FUNCTION public.somar_inteiros(integer, integer) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$select $1 + $2;$_$;
 7   DROP FUNCTION public.somar_inteiros(integer, integer);
       public       postgres    false            �            1259    41010    animal    TABLE     �   CREATE TABLE public.animal (
    nome character varying(50) NOT NULL,
    datanascimento date NOT NULL,
    dtulttrat date,
    idracas integer NOT NULL,
    idespecie integer NOT NULL,
    idanimal integer NOT NULL
);
    DROP TABLE public.animal;
       public         postgres    false            �            1259    41013    pessoas    TABLE     �   CREATE TABLE public.pessoas (
    nome character varying(50) NOT NULL,
    contato character varying(15),
    dtnasc date,
    dtultsolic date,
    matric integer,
    idpessoa integer NOT NULL
);
    DROP TABLE public.pessoas;
       public         postgres    false            �            1259    41016    servicos    TABLE        CREATE TABLE public.servicos (
    descricao character varying(40),
    valor numeric(10,2),
    idservico integer NOT NULL
);
    DROP TABLE public.servicos;
       public         postgres    false            �            1259    41019    solicita    TABLE     �   CREATE TABLE public.solicita (
    datasolicitacao date NOT NULL,
    hora time without time zone NOT NULL,
    valor numeric(10,2),
    idanimal integer NOT NULL,
    idservico integer NOT NULL,
    idpessoa integer NOT NULL,
    matric integer
);
    DROP TABLE public.solicita;
       public         postgres    false            �            1259    41022    agendasolicitacao    VIEW     ;  CREATE VIEW public.agendasolicitacao AS
 SELECT solicita.datasolicitacao,
    solicita.hora,
    a.nome,
    servicos.descricao,
    p.nome AS funcionario
   FROM (((public.solicita
     JOIN public.servicos USING (idservico))
     JOIN public.animal a USING (idanimal))
     JOIN public.pessoas p USING (matric));
 $   DROP VIEW public.agendasolicitacao;
       public       postgres    false    199    196    196    197    197    198    198    199    199    199    199            �            1259    41027    animal_idanimal_seq    SEQUENCE     |   CREATE SEQUENCE public.animal_idanimal_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.animal_idanimal_seq;
       public       postgres    false    196            �           0    0    animal_idanimal_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.animal_idanimal_seq OWNED BY public.animal.idanimal;
            public       postgres    false    201            �            1259    41029    animalnãoatendido    VIEW     �   CREATE VIEW public."animalnãoatendido" AS
 SELECT a.nome,
    s.descricao
   FROM ((public.solicita
     JOIN public.servicos s USING (idservico))
     RIGHT JOIN public.animal a USING (idanimal))
  WHERE (s.descricao IS NULL);
 '   DROP VIEW public."animalnãoatendido";
       public       postgres    false    198    198    196    196    199    199            �            1259    41033    animalservico    VIEW     :  CREATE VIEW public.animalservico AS
 SELECT a.nome,
    p.nome AS dono,
    s.descricao,
    solicita.datasolicitacao,
    solicita.hora,
    s.valor
   FROM (((public.solicita
     JOIN public.pessoas p USING (idpessoa))
     JOIN public.animal a USING (idanimal))
     JOIN public.servicos s USING (idservico));
     DROP VIEW public.animalservico;
       public       postgres    false    199    199    199    196    196    197    198    197    199    198    198    199            �            1259    41038    especies    TABLE     d   CREATE TABLE public.especies (
    especie character varying(40),
    idespecie integer NOT NULL
);
    DROP TABLE public.especies;
       public         postgres    false            �            1259    41041    possui    TABLE     K   CREATE TABLE public.possui (
    idanimal integer,
    idpessoa integer
);
    DROP TABLE public.possui;
       public         postgres    false            �            1259    41044    racas    TABLE     ]   CREATE TABLE public.racas (
    racas character varying(40),
    idracas integer NOT NULL
);
    DROP TABLE public.racas;
       public         postgres    false            �            1259    41047    animaltotal    VIEW     o  CREATE VIEW public.animaltotal AS
 SELECT a.nome AS animal,
    p.nome,
    p.contato,
    especies.especie,
    racas.racas
   FROM ((((public.animal a
     JOIN public.possui USING (idanimal))
     JOIN public.pessoas p USING (idpessoa))
     JOIN public.racas USING (idracas))
     JOIN public.especies USING (idespecie))
  ORDER BY especies.especie, racas.racas;
    DROP VIEW public.animaltotal;
       public       postgres    false    196    206    206    205    205    204    204    197    197    197    196    196    196            �            1259    41052    animalxprop    VIEW     �   CREATE VIEW public.animalxprop AS
 SELECT a.nome AS animal,
    p.nome,
    p.contato
   FROM ((public.animal a
     JOIN public.possui USING (idanimal))
     JOIN public.pessoas p USING (idpessoa));
    DROP VIEW public.animalxprop;
       public       postgres    false    205    205    197    197    197    196    196            �            1259    41056    atendenteanimal    VIEW     �   CREATE VIEW public.atendenteanimal AS
 SELECT a.nome,
    p.nome AS atendente,
    solicita.datasolicitacao
   FROM ((public.solicita
     JOIN public.pessoas p USING (matric))
     JOIN public.animal a USING (idanimal));
 "   DROP VIEW public.atendenteanimal;
       public       postgres    false    199    196    196    197    197    199    199            �            1259    41060    consulta    TABLE     �   CREATE TABLE public.consulta (
    idanimal integer,
    idpessoa integer,
    hora time without time zone,
    datacons date,
    obs text,
    idconsulta integer NOT NULL
);
    DROP TABLE public.consulta;
       public         postgres    false            �            1259    41066    consulta_idconsulta_seq    SEQUENCE     �   CREATE SEQUENCE public.consulta_idconsulta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.consulta_idconsulta_seq;
       public       postgres    false    210            �           0    0    consulta_idconsulta_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.consulta_idconsulta_seq OWNED BY public.consulta.idconsulta;
            public       postgres    false    211            �            1259    41068    especies_idespecie_seq    SEQUENCE        CREATE SEQUENCE public.especies_idespecie_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.especies_idespecie_seq;
       public       postgres    false    204            �           0    0    especies_idespecie_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.especies_idespecie_seq OWNED BY public.especies.idespecie;
            public       postgres    false    212            �            1259    41070 
   fornecedor    TABLE     m   CREATE TABLE public.fornecedor (
    idfornecedor integer NOT NULL,
    razaosocial character varying(50)
);
    DROP TABLE public.fornecedor;
       public         postgres    false            �            1259    41073    itens    TABLE     �   CREATE TABLE public.itens (
    valor numeric(10,2),
    qtd integer,
    numnf integer,
    idremedioprod integer,
    iditem integer NOT NULL
);
    DROP TABLE public.itens;
       public         postgres    false            �            1259    41076    movfinanceira    TABLE     �   CREATE TABLE public.movfinanceira (
    idfinanceiro integer NOT NULL,
    datavenc date NOT NULL,
    valorprev numeric(10,2) NOT NULL,
    datapagto date,
    valorpagto date,
    tipo integer,
    numnf integer
);
 !   DROP TABLE public.movfinanceira;
       public         postgres    false            �            1259    41079    nf    TABLE     �   CREATE TABLE public.nf (
    numnf integer NOT NULL,
    datanf date,
    tipo smallint,
    atualizada smallint,
    idfornecedor integer,
    idprop integer
);
    DROP TABLE public.nf;
       public         postgres    false            �            1259    41082    remediosprodutos    TABLE     �   CREATE TABLE public.remediosprodutos (
    tipo integer,
    nome character varying(40),
    preco numeric(8,2),
    dtvalidade date,
    qtdestoque integer,
    idremedioproduto integer NOT NULL
);
 $   DROP TABLE public.remediosprodutos;
       public         postgres    false            �            1259    41085 	   nfentrada    VIEW     �  CREATE VIEW public.nfentrada AS
 SELECT nf.numnf,
    to_char((nf.datanf)::timestamp with time zone, 'dd/mm/YYYY'::text) AS data_nf,
    fornecedor.razaosocial,
    remediosprodutos.nome AS remedprod,
    itens.qtd,
    itens.valor,
    ((itens.qtd)::numeric * itens.valor)
   FROM (((public.nf
     JOIN public.itens USING (numnf))
     JOIN public.fornecedor USING (idfornecedor))
     JOIN public.remediosprodutos ON ((itens.idremedioprod = remediosprodutos.idremedioproduto)))
  WHERE (nf.tipo = 0);
    DROP VIEW public.nfentrada;
       public       postgres    false    216    216    217    216    217    214    214    213    213    214    214    216            �            1259    41090    nfsaida    VIEW     �  CREATE VIEW public.nfsaida AS
 SELECT nf.numnf,
    to_char((nf.datanf)::timestamp with time zone, 'dd/mm/YYYY'::text) AS data_nf,
    p.nome,
    rp.nome AS "remed/prod",
    itens.qtd,
    itens.valor,
    ((itens.qtd)::numeric * itens.valor) AS totitem
   FROM (((public.nf
     JOIN public.itens USING (numnf))
     JOIN public.pessoas p ON ((p.idpessoa = nf.idprop)))
     JOIN public.remediosprodutos rp ON ((itens.idremedioprod = rp.idremedioproduto)))
  WHERE (nf.tipo = 1);
    DROP VIEW public.nfsaida;
       public       postgres    false    217    217    216    216    216    216    214    214    214    214    197    197            �            1259    41095 	   pessoapet    VIEW     6  CREATE VIEW public.pessoapet AS
 SELECT p.nome,
    a.nome AS nomepet,
    especies.especie,
    racas.racas
   FROM ((((public.possui
     JOIN public.pessoas p USING (idpessoa))
     JOIN public.animal a USING (idanimal))
     JOIN public.especies USING (idespecie))
     JOIN public.racas USING (idracas));
    DROP VIEW public.pessoapet;
       public       postgres    false    205    205    206    206    196    196    196    196    197    197    204    204            �            1259    41100    pessoas_idpessoa_seq    SEQUENCE     }   CREATE SEQUENCE public.pessoas_idpessoa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.pessoas_idpessoa_seq;
       public       postgres    false    197            �           0    0    pessoas_idpessoa_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.pessoas_idpessoa_seq OWNED BY public.pessoas.idpessoa;
            public       postgres    false    221            �            1259    41102    racas_idracas_seq    SEQUENCE     z   CREATE SEQUENCE public.racas_idracas_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.racas_idracas_seq;
       public       postgres    false    206            �           0    0    racas_idracas_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.racas_idracas_seq OWNED BY public.racas.idracas;
            public       postgres    false    222            �            1259    41104 %   remediosprodutos_idremedioproduto_seq    SEQUENCE     �   CREATE SEQUENCE public.remediosprodutos_idremedioproduto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public.remediosprodutos_idremedioproduto_seq;
       public       postgres    false    217            �           0    0 %   remediosprodutos_idremedioproduto_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public.remediosprodutos_idremedioproduto_seq OWNED BY public.remediosprodutos.idremedioproduto;
            public       postgres    false    223            �            1259    41106    servicos_idservico_seq    SEQUENCE        CREATE SEQUENCE public.servicos_idservico_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.servicos_idservico_seq;
       public       postgres    false    198            �           0    0    servicos_idservico_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.servicos_idservico_seq OWNED BY public.servicos.idservico;
            public       postgres    false    224            �            1259    41108    totalnfentrada    VIEW     �   CREATE VIEW public.totalnfentrada AS
 SELECT nf.numnf,
    sum((itens.valor * (itens.qtd)::numeric)) AS sum
   FROM (public.nf
     JOIN public.itens USING (numnf))
  WHERE (nf.tipo = 0)
  GROUP BY nf.numnf;
 !   DROP VIEW public.totalnfentrada;
       public       postgres    false    216    214    214    214    216            �            1259    41112    totalnfsaida    VIEW       CREATE VIEW public.totalnfsaida AS
 SELECT nf.numnf,
    p.nome,
    sum(((itens.qtd)::numeric * itens.valor)) AS sum
   FROM ((public.nf
     JOIN public.itens USING (numnf))
     JOIN public.pessoas p ON ((p.idpessoa = nf.idprop)))
  WHERE (nf.tipo = 1)
  GROUP BY nf.numnf, p.nome;
    DROP VIEW public.totalnfsaida;
       public       postgres    false    216    216    214    214    197    197    214    216            �            1259    41117    totalnfsaidaview    VIEW     �   CREATE VIEW public.totalnfsaidaview AS
 SELECT nfsaida.numnf,
    nfsaida.nome,
    sum(nfsaida.totitem) AS sum
   FROM public.nfsaida
  GROUP BY nfsaida.numnf, nfsaida.nome;
 #   DROP VIEW public.totalnfsaidaview;
       public       postgres    false    219    219    219            �            1259    41121 
   tratamento    TABLE     Y   CREATE TABLE public.tratamento (
    idconsulta integer,
    idremedioproduto integer
);
    DROP TABLE public.tratamento;
       public         postgres    false            �            1259    41124    usuario    TABLE     �   CREATE TABLE public.usuario (
    id integer NOT NULL,
    nm_login character varying,
    ds_senha character varying,
    fg_bloqueado boolean,
    nu_tentativa_login integer
);
    DROP TABLE public.usuario;
       public         postgres    false            �            1259    41130    veterinarios    TABLE     a   CREATE TABLE public.veterinarios (
    crv integer,
    dtadmissao date,
    idpessoa integer
);
     DROP TABLE public.veterinarios;
       public         postgres    false            �
           2604    41133    animal idanimal    DEFAULT     r   ALTER TABLE ONLY public.animal ALTER COLUMN idanimal SET DEFAULT nextval('public.animal_idanimal_seq'::regclass);
 >   ALTER TABLE public.animal ALTER COLUMN idanimal DROP DEFAULT;
       public       postgres    false    201    196                       2604    41134    consulta idconsulta    DEFAULT     z   ALTER TABLE ONLY public.consulta ALTER COLUMN idconsulta SET DEFAULT nextval('public.consulta_idconsulta_seq'::regclass);
 B   ALTER TABLE public.consulta ALTER COLUMN idconsulta DROP DEFAULT;
       public       postgres    false    211    210                       2604    41135    especies idespecie    DEFAULT     x   ALTER TABLE ONLY public.especies ALTER COLUMN idespecie SET DEFAULT nextval('public.especies_idespecie_seq'::regclass);
 A   ALTER TABLE public.especies ALTER COLUMN idespecie DROP DEFAULT;
       public       postgres    false    212    204            �
           2604    41136    pessoas idpessoa    DEFAULT     t   ALTER TABLE ONLY public.pessoas ALTER COLUMN idpessoa SET DEFAULT nextval('public.pessoas_idpessoa_seq'::regclass);
 ?   ALTER TABLE public.pessoas ALTER COLUMN idpessoa DROP DEFAULT;
       public       postgres    false    221    197                       2604    41137    racas idracas    DEFAULT     n   ALTER TABLE ONLY public.racas ALTER COLUMN idracas SET DEFAULT nextval('public.racas_idracas_seq'::regclass);
 <   ALTER TABLE public.racas ALTER COLUMN idracas DROP DEFAULT;
       public       postgres    false    222    206                       2604    41138 !   remediosprodutos idremedioproduto    DEFAULT     �   ALTER TABLE ONLY public.remediosprodutos ALTER COLUMN idremedioproduto SET DEFAULT nextval('public.remediosprodutos_idremedioproduto_seq'::regclass);
 P   ALTER TABLE public.remediosprodutos ALTER COLUMN idremedioproduto DROP DEFAULT;
       public       postgres    false    223    217                        2604    41139    servicos idservico    DEFAULT     x   ALTER TABLE ONLY public.servicos ALTER COLUMN idservico SET DEFAULT nextval('public.servicos_idservico_seq'::regclass);
 A   ALTER TABLE public.servicos ALTER COLUMN idservico DROP DEFAULT;
       public       postgres    false    224    198            �          0    41010    animal 
   TABLE DATA               _   COPY public.animal (nome, datanascimento, dtulttrat, idracas, idespecie, idanimal) FROM stdin;
    public       postgres    false    196   D�       �          0    41060    consulta 
   TABLE DATA               W   COPY public.consulta (idanimal, idpessoa, hora, datacons, obs, idconsulta) FROM stdin;
    public       postgres    false    210   )�       �          0    41038    especies 
   TABLE DATA               6   COPY public.especies (especie, idespecie) FROM stdin;
    public       postgres    false    204   ��       �          0    41070 
   fornecedor 
   TABLE DATA               ?   COPY public.fornecedor (idfornecedor, razaosocial) FROM stdin;
    public       postgres    false    213   ��       �          0    41073    itens 
   TABLE DATA               I   COPY public.itens (valor, qtd, numnf, idremedioprod, iditem) FROM stdin;
    public       postgres    false    214   S�       �          0    41076    movfinanceira 
   TABLE DATA               n   COPY public.movfinanceira (idfinanceiro, datavenc, valorprev, datapagto, valorpagto, tipo, numnf) FROM stdin;
    public       postgres    false    215   �       �          0    41079    nf 
   TABLE DATA               S   COPY public.nf (numnf, datanf, tipo, atualizada, idfornecedor, idprop) FROM stdin;
    public       postgres    false    216   ��       �          0    41013    pessoas 
   TABLE DATA               V   COPY public.pessoas (nome, contato, dtnasc, dtultsolic, matric, idpessoa) FROM stdin;
    public       postgres    false    197   k�       �          0    41041    possui 
   TABLE DATA               4   COPY public.possui (idanimal, idpessoa) FROM stdin;
    public       postgres    false    205   H�       �          0    41044    racas 
   TABLE DATA               /   COPY public.racas (racas, idracas) FROM stdin;
    public       postgres    false    206   ��       �          0    41082    remediosprodutos 
   TABLE DATA               g   COPY public.remediosprodutos (tipo, nome, preco, dtvalidade, qtdestoque, idremedioproduto) FROM stdin;
    public       postgres    false    217   3�       �          0    41016    servicos 
   TABLE DATA               ?   COPY public.servicos (descricao, valor, idservico) FROM stdin;
    public       postgres    false    198   ��       �          0    41019    solicita 
   TABLE DATA               g   COPY public.solicita (datasolicitacao, hora, valor, idanimal, idservico, idpessoa, matric) FROM stdin;
    public       postgres    false    199   �       �          0    41121 
   tratamento 
   TABLE DATA               B   COPY public.tratamento (idconsulta, idremedioproduto) FROM stdin;
    public       postgres    false    228   ��       �          0    41124    usuario 
   TABLE DATA               [   COPY public.usuario (id, nm_login, ds_senha, fg_bloqueado, nu_tentativa_login) FROM stdin;
    public       postgres    false    229   Ҝ       �          0    41130    veterinarios 
   TABLE DATA               A   COPY public.veterinarios (crv, dtadmissao, idpessoa) FROM stdin;
    public       postgres    false    230   H�       �           0    0    animal_idanimal_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.animal_idanimal_seq', 14, true);
            public       postgres    false    201            �           0    0    consulta_idconsulta_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.consulta_idconsulta_seq', 5, true);
            public       postgres    false    211            �           0    0    especies_idespecie_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.especies_idespecie_seq', 10, true);
            public       postgres    false    212            �           0    0    pessoas_idpessoa_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.pessoas_idpessoa_seq', 10, true);
            public       postgres    false    221            �           0    0    racas_idracas_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.racas_idracas_seq', 26, true);
            public       postgres    false    222            �           0    0 %   remediosprodutos_idremedioproduto_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public.remediosprodutos_idremedioproduto_seq', 4, true);
            public       postgres    false    223            �           0    0    servicos_idservico_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.servicos_idservico_seq', 5, true);
            public       postgres    false    224                       2606    41141    animal animal_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.animal
    ADD CONSTRAINT animal_pkey PRIMARY KEY (idanimal);
 <   ALTER TABLE ONLY public.animal DROP CONSTRAINT animal_pkey;
       public         postgres    false    196                       2606    41143    consulta consulta_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.consulta
    ADD CONSTRAINT consulta_pkey PRIMARY KEY (idconsulta);
 @   ALTER TABLE ONLY public.consulta DROP CONSTRAINT consulta_pkey;
       public         postgres    false    210                       2606    41145    especies especies_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.especies
    ADD CONSTRAINT especies_pkey PRIMARY KEY (idespecie);
 @   ALTER TABLE ONLY public.especies DROP CONSTRAINT especies_pkey;
       public         postgres    false    204                       2606    41147    fornecedor fornecedor_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.fornecedor
    ADD CONSTRAINT fornecedor_pkey PRIMARY KEY (idfornecedor);
 D   ALTER TABLE ONLY public.fornecedor DROP CONSTRAINT fornecedor_pkey;
       public         postgres    false    213                       2606    41149    itens itens_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.itens
    ADD CONSTRAINT itens_pkey PRIMARY KEY (iditem);
 :   ALTER TABLE ONLY public.itens DROP CONSTRAINT itens_pkey;
       public         postgres    false    214                       2606    41151    pessoas matricunica 
   CONSTRAINT     P   ALTER TABLE ONLY public.pessoas
    ADD CONSTRAINT matricunica UNIQUE (matric);
 =   ALTER TABLE ONLY public.pessoas DROP CONSTRAINT matricunica;
       public         postgres    false    197                       2606    41153     movfinanceira movfinanceira_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.movfinanceira
    ADD CONSTRAINT movfinanceira_pkey PRIMARY KEY (idfinanceiro);
 J   ALTER TABLE ONLY public.movfinanceira DROP CONSTRAINT movfinanceira_pkey;
       public         postgres    false    215                       2606    41155 
   nf nf_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY public.nf
    ADD CONSTRAINT nf_pkey PRIMARY KEY (numnf);
 4   ALTER TABLE ONLY public.nf DROP CONSTRAINT nf_pkey;
       public         postgres    false    216            
           2606    41157    pessoas pessoas_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.pessoas
    ADD CONSTRAINT pessoas_pkey PRIMARY KEY (idpessoa);
 >   ALTER TABLE ONLY public.pessoas DROP CONSTRAINT pessoas_pkey;
       public         postgres    false    197                        2606    41159    usuario pk_usuario 
   CONSTRAINT     P   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT pk_usuario PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.usuario DROP CONSTRAINT pk_usuario;
       public         postgres    false    229                       2606    41161    racas racas_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.racas
    ADD CONSTRAINT racas_pkey PRIMARY KEY (idracas);
 :   ALTER TABLE ONLY public.racas DROP CONSTRAINT racas_pkey;
       public         postgres    false    206                       2606    41163 &   remediosprodutos remediosprodutos_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.remediosprodutos
    ADD CONSTRAINT remediosprodutos_pkey PRIMARY KEY (idremedioproduto);
 P   ALTER TABLE ONLY public.remediosprodutos DROP CONSTRAINT remediosprodutos_pkey;
       public         postgres    false    217                       2606    41165    servicos servicos_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.servicos
    ADD CONSTRAINT servicos_pkey PRIMARY KEY (idservico);
 @   ALTER TABLE ONLY public.servicos DROP CONSTRAINT servicos_pkey;
       public         postgres    false    198                       2606    41167    solicita solicita_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.solicita
    ADD CONSTRAINT solicita_pkey PRIMARY KEY (datasolicitacao, idanimal, idservico, idpessoa);
 @   ALTER TABLE ONLY public.solicita DROP CONSTRAINT solicita_pkey;
       public         postgres    false    199    199    199    199            !           2606    41168    animal animal_idespecie_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.animal
    ADD CONSTRAINT animal_idespecie_fkey FOREIGN KEY (idespecie) REFERENCES public.especies(idespecie);
 F   ALTER TABLE ONLY public.animal DROP CONSTRAINT animal_idespecie_fkey;
       public       postgres    false    204    2832    196            "           2606    41173    animal animal_idracas_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.animal
    ADD CONSTRAINT animal_idracas_fkey FOREIGN KEY (idracas) REFERENCES public.racas(idracas);
 D   ALTER TABLE ONLY public.animal DROP CONSTRAINT animal_idracas_fkey;
       public       postgres    false    206    2834    196            )           2606    41178    consulta consulta_idanimal_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.consulta
    ADD CONSTRAINT consulta_idanimal_fkey FOREIGN KEY (idanimal) REFERENCES public.animal(idanimal);
 I   ALTER TABLE ONLY public.consulta DROP CONSTRAINT consulta_idanimal_fkey;
       public       postgres    false    210    196    2822            *           2606    41183    consulta consulta_idpessoa_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.consulta
    ADD CONSTRAINT consulta_idpessoa_fkey FOREIGN KEY (idpessoa) REFERENCES public.pessoas(idpessoa);
 I   ALTER TABLE ONLY public.consulta DROP CONSTRAINT consulta_idpessoa_fkey;
       public       postgres    false    2826    210    197            +           2606    41188    itens itens_idremedioprod_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.itens
    ADD CONSTRAINT itens_idremedioprod_fkey FOREIGN KEY (idremedioprod) REFERENCES public.remediosprodutos(idremedioproduto);
 H   ALTER TABLE ONLY public.itens DROP CONSTRAINT itens_idremedioprod_fkey;
       public       postgres    false    217    214    2846            ,           2606    41193    itens itens_numnf_fkey    FK CONSTRAINT     s   ALTER TABLE ONLY public.itens
    ADD CONSTRAINT itens_numnf_fkey FOREIGN KEY (numnf) REFERENCES public.nf(numnf);
 @   ALTER TABLE ONLY public.itens DROP CONSTRAINT itens_numnf_fkey;
       public       postgres    false    216    2844    214            -           2606    41198 &   movfinanceira movfinanceira_numnf_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.movfinanceira
    ADD CONSTRAINT movfinanceira_numnf_fkey FOREIGN KEY (numnf) REFERENCES public.nf(numnf);
 P   ALTER TABLE ONLY public.movfinanceira DROP CONSTRAINT movfinanceira_numnf_fkey;
       public       postgres    false    215    216    2844            .           2606    41203    nf nf_idfornecedor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.nf
    ADD CONSTRAINT nf_idfornecedor_fkey FOREIGN KEY (idfornecedor) REFERENCES public.fornecedor(idfornecedor);
 A   ALTER TABLE ONLY public.nf DROP CONSTRAINT nf_idfornecedor_fkey;
       public       postgres    false    213    216    2838            /           2606    41208    nf nf_idprop_fkey    FK CONSTRAINT     w   ALTER TABLE ONLY public.nf
    ADD CONSTRAINT nf_idprop_fkey FOREIGN KEY (idprop) REFERENCES public.pessoas(idpessoa);
 ;   ALTER TABLE ONLY public.nf DROP CONSTRAINT nf_idprop_fkey;
       public       postgres    false    216    197    2826            '           2606    41213    possui possui_idanimal_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.possui
    ADD CONSTRAINT possui_idanimal_fkey FOREIGN KEY (idanimal) REFERENCES public.animal(idanimal);
 E   ALTER TABLE ONLY public.possui DROP CONSTRAINT possui_idanimal_fkey;
       public       postgres    false    2822    205    196            (           2606    41218    possui possui_idpessoa_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.possui
    ADD CONSTRAINT possui_idpessoa_fkey FOREIGN KEY (idpessoa) REFERENCES public.pessoas(idpessoa);
 E   ALTER TABLE ONLY public.possui DROP CONSTRAINT possui_idpessoa_fkey;
       public       postgres    false    197    2826    205            #           2606    41223    solicita solicita_idanimal_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.solicita
    ADD CONSTRAINT solicita_idanimal_fkey FOREIGN KEY (idanimal) REFERENCES public.animal(idanimal);
 I   ALTER TABLE ONLY public.solicita DROP CONSTRAINT solicita_idanimal_fkey;
       public       postgres    false    199    196    2822            $           2606    41228    solicita solicita_idpessoa_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.solicita
    ADD CONSTRAINT solicita_idpessoa_fkey FOREIGN KEY (idpessoa) REFERENCES public.pessoas(idpessoa);
 I   ALTER TABLE ONLY public.solicita DROP CONSTRAINT solicita_idpessoa_fkey;
       public       postgres    false    2826    199    197            %           2606    41233     solicita solicita_idservico_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.solicita
    ADD CONSTRAINT solicita_idservico_fkey FOREIGN KEY (idservico) REFERENCES public.servicos(idservico);
 J   ALTER TABLE ONLY public.solicita DROP CONSTRAINT solicita_idservico_fkey;
       public       postgres    false    2828    199    198            &           2606    41238    solicita solicita_matric_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.solicita
    ADD CONSTRAINT solicita_matric_fkey FOREIGN KEY (matric) REFERENCES public.pessoas(matric);
 G   ALTER TABLE ONLY public.solicita DROP CONSTRAINT solicita_matric_fkey;
       public       postgres    false    197    199    2824            0           2606    41243 %   tratamento tratamento_idconsulta_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tratamento
    ADD CONSTRAINT tratamento_idconsulta_fkey FOREIGN KEY (idconsulta) REFERENCES public.consulta(idconsulta);
 O   ALTER TABLE ONLY public.tratamento DROP CONSTRAINT tratamento_idconsulta_fkey;
       public       postgres    false    2836    228    210            1           2606    41248 +   tratamento tratamento_idremedioproduto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tratamento
    ADD CONSTRAINT tratamento_idremedioproduto_fkey FOREIGN KEY (idremedioproduto) REFERENCES public.remediosprodutos(idremedioproduto);
 U   ALTER TABLE ONLY public.tratamento DROP CONSTRAINT tratamento_idremedioproduto_fkey;
       public       postgres    false    228    2846    217            2           2606    41253 '   veterinarios veterinarios_idpessoa_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.veterinarios
    ADD CONSTRAINT veterinarios_idpessoa_fkey FOREIGN KEY (idpessoa) REFERENCES public.pessoas(idpessoa);
 Q   ALTER TABLE ONLY public.veterinarios DROP CONSTRAINT veterinarios_idpessoa_fkey;
       public       postgres    false    197    2826    230            �   �   x���1n�0Eg�� ���h�S萴C�,B!Ԃ	M����&M�B�������#��\G��a�c����5	[�j"��mxrL��\����
�#�oA�J�����.��8,�t���g�����}�a�K[�k��4]�B,��G|Nǋ��:�"c�:�2�ն�i0��U����a�ҿ*���&ǌO�̋xCN�;�Cq��D<?{MG      �   p   x�3�4�44�20 "N#C3]]KN��"��D��ĒDNC.cNNCSLUa�əy�ŜF\&��*�R��R9��L9�A�&����ɉ)��&\����f�m1����� �%E      �   ;   x�sK�����4�rN�1����SS�8����,(���4�
8���8�(�Ӕ+F��� �z      �   O   x�3�tN����WHUp�L�2��IL�/J,�/��W��L,�2�H-)V�)II�2��MM�LN�M�+�/Vpu����� 
�      �      x�M��!��`,�G.�kkX툗(
��@�QK\w���	Sk̄%	���p���D �Lc��Ȭ�L=w��L����X£yO�b)n�S�+���WK�z�����,�x�;�
�|TD�\$J      �      x������ � �      �   \   x�mϻ� E��ޅ��,��?G0MA�<��ca�TR�D����F?� �b'H���4at�z�4.[ܾ8��	+޼�֏� ��P&�      �   �   x�=��j1��һ���t�%��.}�\�%��B�}��+��t�0�9�[݀�NR2�"�.c~����C<���( Ykl�;5?��Y����:r���){�@�2\��y���'�xZN A.=�o�W)�!����I�p��)̬ܳ~�u���2����9�wyl�֛yejؐ����[is���O�͜��"�m�N�      �   5   x�%��	  �ޓb�������p�GB�e�]A$C����af�洿�r� ��g      �   �   x�E�=�@����YğR��#lk�����$���y.�vV��$�-/�7P������q���l��#T����;��"/�F�£�6{�Nh�vL�hݐ��o�$t��'�l�N�٧���B���_����߉T�Nd����,#3�      �   p   x�3�tK�K-JO��44�30�4204�50�56����4�2�K-��L+M�W�J��4�3+��5��56)2�2�t��I�,J�44"c�xIbNr>����%LԄ+F��� ��      �   P   x�sJ���WpN�����41�30�4�r������F\����e�P5�\!��@�)�c�X\�����i�5����� �z       �   �   x�u�]
� �g��%��V=DO���c�ȲMa�� 3D&�z#.�I�(m~#FMD�rbHL�1y0v�lj��}K�fR���F���l4xڞJ5�s �L{�����A��!E�2G���w�CG�Vk� �Y9�      �      x�3�4�2�4�2bcNc�=... ]�      �   f   x�%��	�0��l1b�؀g/������D/;�a%rK7��J
�I����#['Ikq�>.�3Z�S��(`��GKh\�OB*��E���� c�@�6���W      �   $   x�361331112�4204�50�50�4����� J��     