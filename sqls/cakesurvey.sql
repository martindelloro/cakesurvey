--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.10
-- Dumped by pg_dump version 9.3.10
-- Started on 2016-02-01 16:50:33 ART

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 7 (class 2615 OID 16394)
-- Name: encuestas; Type: SCHEMA; Schema: -; Owner: encuestas
--

CREATE SCHEMA encuestas;


ALTER SCHEMA encuestas OWNER TO encuestas;

SET search_path = encuestas, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 173 (class 1259 OID 16987)
-- Name: encuestas; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE encuestas (
    id integer NOT NULL,
    usuario_id integer,
    created timestamp without time zone,
    modified timestamp without time zone,
    preguntas_count integer,
    grupo_count integer,
    nombre character varying,
    anio character varying,
    "cantXpag" integer,
    partes integer,
    categoria_id integer,
    subcategoria_id integer,
    importada boolean DEFAULT false,
    activada boolean,
    fuentes character varying
);


ALTER TABLE encuestas.encuestas OWNER TO encuestas;

--
-- TOC entry 174 (class 1259 OID 16994)
-- Name: encuestas_grupos; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE encuestas_grupos (
    id integer NOT NULL,
    encuesta_id integer,
    grupo_id integer,
    created timestamp without time zone,
    modified timestamp without time zone,
    owner_id integer
);


ALTER TABLE encuestas.encuestas_grupos OWNER TO encuestas;

--
-- TOC entry 175 (class 1259 OID 16997)
-- Name: grupos_usuarios; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE grupos_usuarios (
    id integer NOT NULL,
    grupo_id integer,
    usuario_id integer,
    encuesta_id integer,
    created timestamp without time zone,
    modified timestamp without time zone,
    owner_id integer
);


ALTER TABLE encuestas.grupos_usuarios OWNER TO encuestas;

--
-- TOC entry 176 (class 1259 OID 17000)
-- Name: cantidad_usuarios_encuesta; Type: VIEW; Schema: encuestas; Owner: encuestas
--

CREATE VIEW cantidad_usuarios_encuesta AS
 SELECT enc.id,
    count(grus.grupo_id) AS cantidad_usuarios
   FROM ((encuestas enc
     LEFT JOIN encuestas_grupos encgru ON ((enc.id = encgru.encuesta_id)))
     LEFT JOIN grupos_usuarios grus ON ((encgru.grupo_id = grus.grupo_id)))
  GROUP BY enc.id, grus.grupo_id;


ALTER TABLE encuestas.cantidad_usuarios_encuesta OWNER TO encuestas;

--
-- TOC entry 177 (class 1259 OID 17005)
-- Name: grupos; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE grupos (
    id integer NOT NULL,
    nombre character varying,
    categoria_id integer,
    subcategoria_id integer,
    created timestamp without time zone,
    modified timestamp without time zone,
    owner_id integer
);


ALTER TABLE encuestas.grupos OWNER TO encuestas;

--
-- TOC entry 178 (class 1259 OID 17011)
-- Name: cantidad_usuarios_grupo; Type: VIEW; Schema: encuestas; Owner: encuestas
--

CREATE VIEW cantidad_usuarios_grupo AS
 SELECT grupo.id,
    count(grupo.id) AS cantidad_usuarios_grupo
   FROM (grupos grupo
     LEFT JOIN grupos_usuarios usugr ON ((usugr.grupo_id = grupo.id)))
  GROUP BY grupo.id;


ALTER TABLE encuestas.cantidad_usuarios_grupo OWNER TO encuestas;

--
-- TOC entry 179 (class 1259 OID 17015)
-- Name: carreras_unla; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE carreras_unla (
    id integer NOT NULL,
    nombre character varying,
    id_departamento integer
);


ALTER TABLE encuestas.carreras_unla OWNER TO encuestas;

--
-- TOC entry 180 (class 1259 OID 17021)
-- Name: carreras_unla_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE carreras_unla_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.carreras_unla_id_seq OWNER TO encuestas;

--
-- TOC entry 2565 (class 0 OID 0)
-- Dependencies: 180
-- Name: carreras_unla_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE carreras_unla_id_seq OWNED BY carreras_unla.id;


--
-- TOC entry 181 (class 1259 OID 17023)
-- Name: categorias; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE categorias (
    id integer NOT NULL,
    name character varying,
    type character(1),
    created timestamp without time zone,
    modified timestamp without time zone,
    owner_id integer,
    pregunta_count integer,
    opcion_count integer,
    encuesta_count integer,
    reporte_count integer,
    subcategoria_count integer
);


ALTER TABLE encuestas.categorias OWNER TO encuestas;

--
-- TOC entry 182 (class 1259 OID 17029)
-- Name: categorias_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE categorias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.categorias_id_seq OWNER TO encuestas;

--
-- TOC entry 2566 (class 0 OID 0)
-- Dependencies: 182
-- Name: categorias_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE categorias_id_seq OWNED BY categorias.id;


--
-- TOC entry 183 (class 1259 OID 17031)
-- Name: departamentos_unla; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE departamentos_unla (
    id integer NOT NULL,
    nombre character varying
);


ALTER TABLE encuestas.departamentos_unla OWNER TO encuestas;

--
-- TOC entry 184 (class 1259 OID 17037)
-- Name: departamentos_unla_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE departamentos_unla_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.departamentos_unla_id_seq OWNER TO encuestas;

--
-- TOC entry 2567 (class 0 OID 0)
-- Dependencies: 184
-- Name: departamentos_unla_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE departamentos_unla_id_seq OWNED BY departamentos_unla.id;


--
-- TOC entry 185 (class 1259 OID 17039)
-- Name: encuestas_grupos_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE encuestas_grupos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.encuestas_grupos_id_seq OWNER TO encuestas;

--
-- TOC entry 2568 (class 0 OID 0)
-- Dependencies: 185
-- Name: encuestas_grupos_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE encuestas_grupos_id_seq OWNED BY encuestas_grupos.id;


--
-- TOC entry 186 (class 1259 OID 17041)
-- Name: encuestas_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE encuestas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.encuestas_id_seq OWNER TO encuestas;

--
-- TOC entry 2569 (class 0 OID 0)
-- Dependencies: 186
-- Name: encuestas_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE encuestas_id_seq OWNED BY encuestas.id;


--
-- TOC entry 187 (class 1259 OID 17043)
-- Name: encuestas_preguntas; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE encuestas_preguntas (
    id integer NOT NULL,
    encuesta_id integer,
    pregunta_id integer,
    orden integer,
    created timestamp without time zone,
    modified timestamp without time zone
);


ALTER TABLE encuestas.encuestas_preguntas OWNER TO encuestas;

--
-- TOC entry 188 (class 1259 OID 17046)
-- Name: encuestas_preguntas_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE encuestas_preguntas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.encuestas_preguntas_id_seq OWNER TO encuestas;

--
-- TOC entry 2570 (class 0 OID 0)
-- Dependencies: 188
-- Name: encuestas_preguntas_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE encuestas_preguntas_id_seq OWNED BY encuestas_preguntas.id;


--
-- TOC entry 189 (class 1259 OID 17048)
-- Name: filtros; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE filtros (
    id integer NOT NULL,
    sub_reporte_id integer,
    si_no boolean,
    pregunta_id integer,
    tipo integer,
    created timestamp without time zone,
    modified timestamp without time zone,
    owner_id integer
);


ALTER TABLE encuestas.filtros OWNER TO encuestas;

--
-- TOC entry 190 (class 1259 OID 17051)
-- Name: filtros_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE filtros_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.filtros_id_seq OWNER TO encuestas;

--
-- TOC entry 2571 (class 0 OID 0)
-- Dependencies: 190
-- Name: filtros_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE filtros_id_seq OWNED BY filtros.id;


--
-- TOC entry 191 (class 1259 OID 17053)
-- Name: filtros_opciones; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE filtros_opciones (
    filtro_id integer,
    opcion_id integer,
    id integer NOT NULL,
    created timestamp without time zone,
    modified timestamp without time zone,
    owner_id integer
);


ALTER TABLE encuestas.filtros_opciones OWNER TO encuestas;

--
-- TOC entry 192 (class 1259 OID 17056)
-- Name: filtros_opciones_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE filtros_opciones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.filtros_opciones_id_seq OWNER TO encuestas;

--
-- TOC entry 2572 (class 0 OID 0)
-- Dependencies: 192
-- Name: filtros_opciones_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE filtros_opciones_id_seq OWNED BY filtros_opciones.id;


--
-- TOC entry 193 (class 1259 OID 17058)
-- Name: grupos_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE grupos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.grupos_id_seq OWNER TO encuestas;

--
-- TOC entry 2573 (class 0 OID 0)
-- Dependencies: 193
-- Name: grupos_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE grupos_id_seq OWNED BY grupos.id;


--
-- TOC entry 194 (class 1259 OID 17060)
-- Name: grupos_usuarios_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE grupos_usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.grupos_usuarios_id_seq OWNER TO encuestas;

--
-- TOC entry 2574 (class 0 OID 0)
-- Dependencies: 194
-- Name: grupos_usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE grupos_usuarios_id_seq OWNED BY grupos_usuarios.id;


--
-- TOC entry 195 (class 1259 OID 17062)
-- Name: mail; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE mail (
    id integer NOT NULL,
    grupo_id integer,
    encuesta_id integer,
    usuario_id integer,
    created date,
    modified date,
    tipo_envio integer
);


ALTER TABLE encuestas.mail OWNER TO encuestas;

--
-- TOC entry 196 (class 1259 OID 17065)
-- Name: mail_grupos; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE mail_grupos (
    id integer NOT NULL,
    mail_id integer,
    grupo_id integer,
    created timestamp without time zone,
    modified timestamp without time zone
);


ALTER TABLE encuestas.mail_grupos OWNER TO encuestas;

--
-- TOC entry 197 (class 1259 OID 17068)
-- Name: mail_grupos_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE mail_grupos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.mail_grupos_id_seq OWNER TO encuestas;

--
-- TOC entry 2575 (class 0 OID 0)
-- Dependencies: 197
-- Name: mail_grupos_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE mail_grupos_id_seq OWNED BY mail_grupos.id;


--
-- TOC entry 198 (class 1259 OID 17070)
-- Name: mail_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE mail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.mail_id_seq OWNER TO encuestas;

--
-- TOC entry 2576 (class 0 OID 0)
-- Dependencies: 198
-- Name: mail_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE mail_id_seq OWNED BY mail.id;


--
-- TOC entry 199 (class 1259 OID 17072)
-- Name: mail_usuarios; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE mail_usuarios (
    id integer NOT NULL,
    mail_id integer,
    usuario_id integer,
    created timestamp without time zone,
    modified timestamp without time zone,
    estado integer
);


ALTER TABLE encuestas.mail_usuarios OWNER TO encuestas;

--
-- TOC entry 200 (class 1259 OID 17075)
-- Name: mail_usuarios_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE mail_usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.mail_usuarios_id_seq OWNER TO encuestas;

--
-- TOC entry 2577 (class 0 OID 0)
-- Dependencies: 200
-- Name: mail_usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE mail_usuarios_id_seq OWNED BY mail_usuarios.id;


--
-- TOC entry 201 (class 1259 OID 17077)
-- Name: opciones; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE opciones (
    id integer NOT NULL,
    nombre character varying,
    pregunta_id integer,
    categoria_id integer,
    subcategoria_id integer,
    created timestamp without time zone,
    modified timestamp without time zone,
    owner_id integer
);


ALTER TABLE encuestas.opciones OWNER TO encuestas;

--
-- TOC entry 202 (class 1259 OID 17083)
-- Name: opciones_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE opciones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.opciones_id_seq OWNER TO encuestas;

--
-- TOC entry 2578 (class 0 OID 0)
-- Dependencies: 202
-- Name: opciones_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE opciones_id_seq OWNED BY opciones.id;


--
-- TOC entry 203 (class 1259 OID 17085)
-- Name: preguntas; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE preguntas (
    id integer NOT NULL,
    nombre character varying,
    tipo_id integer,
    opcion_count integer DEFAULT 0,
    categoria_id integer,
    subcategoria_id integer,
    created timestamp without time zone,
    modified timestamp without time zone,
    owner_id integer
);


ALTER TABLE encuestas.preguntas OWNER TO encuestas;

--
-- TOC entry 204 (class 1259 OID 17092)
-- Name: preguntas_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE preguntas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.preguntas_id_seq OWNER TO encuestas;

--
-- TOC entry 2579 (class 0 OID 0)
-- Dependencies: 204
-- Name: preguntas_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE preguntas_id_seq OWNED BY preguntas.id;


--
-- TOC entry 205 (class 1259 OID 17094)
-- Name: reglas; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE reglas (
    id integer NOT NULL,
    regla character varying,
    "ruleCake" character varying,
    orden integer
);


ALTER TABLE encuestas.reglas OWNER TO encuestas;

--
-- TOC entry 206 (class 1259 OID 17100)
-- Name: reglas_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE reglas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.reglas_id_seq OWNER TO encuestas;

--
-- TOC entry 2580 (class 0 OID 0)
-- Dependencies: 206
-- Name: reglas_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE reglas_id_seq OWNED BY reglas.id;


--
-- TOC entry 207 (class 1259 OID 17102)
-- Name: reportes; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE reportes (
    id integer NOT NULL,
    nombre character varying,
    encuesta_id integer,
    owner_id integer,
    created timestamp without time zone,
    modified timestamp without time zone
);


ALTER TABLE encuestas.reportes OWNER TO encuestas;

--
-- TOC entry 208 (class 1259 OID 17108)
-- Name: reportes_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE reportes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.reportes_id_seq OWNER TO encuestas;

--
-- TOC entry 2581 (class 0 OID 0)
-- Dependencies: 208
-- Name: reportes_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE reportes_id_seq OWNED BY reportes.id;


--
-- TOC entry 209 (class 1259 OID 17110)
-- Name: respuestas; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE respuestas (
    id integer NOT NULL,
    tipo_id integer,
    created timestamp without time zone,
    modified timestamp without time zone,
    respuesta_texto character varying,
    respuesta_opcion integer,
    respuesta_sino boolean,
    respuesta_rango_minimo integer,
    respuesta_rango_maximo integer,
    respuesta_valor integer,
    usuario_id integer,
    pregunta_id integer,
    encuesta_id integer,
    owner_id integer
);


ALTER TABLE encuestas.respuestas OWNER TO encuestas;

--
-- TOC entry 210 (class 1259 OID 17116)
-- Name: respuestas_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE respuestas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.respuestas_id_seq OWNER TO encuestas;

--
-- TOC entry 2582 (class 0 OID 0)
-- Dependencies: 210
-- Name: respuestas_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE respuestas_id_seq OWNED BY respuestas.id;


--
-- TOC entry 211 (class 1259 OID 17118)
-- Name: respuestas_opciones; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE respuestas_opciones (
    id integer NOT NULL,
    respuesta_id integer,
    opcion_id integer,
    created timestamp without time zone,
    modified timestamp without time zone
);


ALTER TABLE encuestas.respuestas_opciones OWNER TO encuestas;

--
-- TOC entry 212 (class 1259 OID 17121)
-- Name: respuestas_opciones_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE respuestas_opciones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.respuestas_opciones_id_seq OWNER TO encuestas;

--
-- TOC entry 2583 (class 0 OID 0)
-- Dependencies: 212
-- Name: respuestas_opciones_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE respuestas_opciones_id_seq OWNED BY respuestas_opciones.id;


--
-- TOC entry 213 (class 1259 OID 17123)
-- Name: subcategorias; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE subcategorias (
    id integer NOT NULL,
    name character varying,
    type character(1),
    created timestamp without time zone,
    modified timestamp without time zone,
    categoria_id integer,
    pregunta_count integer,
    opcion_count integer,
    encuesta_count integer,
    reporte_count integer
);


ALTER TABLE encuestas.subcategorias OWNER TO encuestas;

--
-- TOC entry 214 (class 1259 OID 17129)
-- Name: subcategorias_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE subcategorias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.subcategorias_id_seq OWNER TO encuestas;

--
-- TOC entry 2584 (class 0 OID 0)
-- Dependencies: 214
-- Name: subcategorias_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE subcategorias_id_seq OWNED BY subcategorias.id;


--
-- TOC entry 215 (class 1259 OID 17131)
-- Name: tipos; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE tipos (
    id integer NOT NULL,
    nombre character varying,
    created timestamp without time zone,
    modified timestamp without time zone
);


ALTER TABLE encuestas.tipos OWNER TO encuestas;

--
-- TOC entry 216 (class 1259 OID 17137)
-- Name: tipos_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE tipos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.tipos_id_seq OWNER TO encuestas;

--
-- TOC entry 2585 (class 0 OID 0)
-- Dependencies: 216
-- Name: tipos_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE tipos_id_seq OWNED BY tipos.id;


--
-- TOC entry 217 (class 1259 OID 17139)
-- Name: usuarios; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE usuarios (
    id integer NOT NULL,
    dni character varying,
    apellido character varying,
    nombre character varying,
    sexo character varying,
    usuario character varying,
    rol character varying,
    fecha_nac date,
    cod_depto character varying,
    cod_loc character varying,
    cod_prov character varying,
    calle character varying,
    email_1 character varying,
    email_2 character varying,
    tel_fijo character varying,
    celular character varying,
    facebook character varying,
    twitter character varying,
    foto_perfil character varying,
    created timestamp without time zone,
    modified timestamp without time zone,
    localidad character varying,
    provincia character varying,
    password character varying,
    cohorte character varying,
    promedio_sin_aplazo double precision,
    fecha_ultima_materia date,
    fecha_emision_titulo character varying,
    promedio_con_aplazo character varying,
    fecha_solicitud_titulo date,
    cohorte_graduacion character varying,
    hashactivador character varying,
    activado boolean DEFAULT false,
    owner_id integer,
    estado_civil character varying,
    carrera character varying,
    nivel character varying,
    titulo character varying,
    departamento character varying,
    "departamentoUnla" character varying,
    "carreraUnla" character varying
);


ALTER TABLE encuestas.usuarios OWNER TO encuestas;

--
-- TOC entry 2586 (class 0 OID 0)
-- Dependencies: 217
-- Name: COLUMN usuarios."departamentoUnla"; Type: COMMENT; Schema: encuestas; Owner: encuestas
--

COMMENT ON COLUMN usuarios."departamentoUnla" IS 'Esto es si tiene un rol de Secretario, para que la búsqueda luego sea filtrado';


--
-- TOC entry 218 (class 1259 OID 17146)
-- Name: usuarios_carreras; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE usuarios_carreras (
    id integer NOT NULL,
    usuario_id integer,
    departamento_id integer,
    carrera_id integer
);


ALTER TABLE encuestas.usuarios_carreras OWNER TO encuestas;

--
-- TOC entry 219 (class 1259 OID 17149)
-- Name: usuarios_carreras_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE usuarios_carreras_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.usuarios_carreras_id_seq OWNER TO encuestas;

--
-- TOC entry 2587 (class 0 OID 0)
-- Dependencies: 219
-- Name: usuarios_carreras_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE usuarios_carreras_id_seq OWNED BY usuarios_carreras.id;


--
-- TOC entry 220 (class 1259 OID 17151)
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.usuarios_id_seq OWNER TO encuestas;

--
-- TOC entry 2588 (class 0 OID 0)
-- Dependencies: 220
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE usuarios_id_seq OWNED BY usuarios.id;


--
-- TOC entry 221 (class 1259 OID 17153)
-- Name: v_resumen_usuario_respuestas; Type: VIEW; Schema: encuestas; Owner: encuestas
--

CREATE VIEW v_resumen_usuario_respuestas AS
 SELECT a.id AS encuesta_id,
    d.usuario_id,
    count(e.usuario_id) AS cantrespuestas,
    count(DISTINCT b.pregunta_id) AS totalpreguntas,
        CASE
            WHEN ((count(b.encuesta_id))::double precision > (0.0)::double precision) THEN (((count(e.usuario_id))::double precision / (count(DISTINCT b.pregunta_id))::double precision) * (100)::double precision)
            ELSE ((0)::bigint)::double precision
        END AS porcentaje,
    min(DISTINCT e.created) AS fecha_primer_respuesta,
    max(DISTINCT e.created) AS fecha_ultima_respuesta,
    d.grupo_id
   FROM ((((encuestas a
     LEFT JOIN encuestas_preguntas b ON ((a.id = b.encuesta_id)))
     LEFT JOIN encuestas_grupos c ON ((c.encuesta_id = a.id)))
     JOIN grupos_usuarios d ON ((c.grupo_id = d.grupo_id)))
     LEFT JOIN respuestas e ON ((((b.pregunta_id = e.pregunta_id) AND (e.encuesta_id = a.id)) AND (e.usuario_id = d.usuario_id))))
  GROUP BY a.id, d.usuario_id, d.grupo_id
  ORDER BY d.usuario_id DESC;


ALTER TABLE encuestas.v_resumen_usuario_respuestas OWNER TO encuestas;

--
-- TOC entry 222 (class 1259 OID 17158)
-- Name: v_email_datos_contacto; Type: VIEW; Schema: encuestas; Owner: encuestas
--

CREATE VIEW v_email_datos_contacto AS
 SELECT v_user.encuesta_id,
    v_user.usuario_id,
    v_user.porcentaje,
    u.apellido,
    u.nombre,
    u.sexo,
    u.usuario,
    u.rol,
    u.email_1
   FROM (v_resumen_usuario_respuestas v_user
     LEFT JOIN usuarios u ON ((v_user.usuario_id = u.id)))
  WHERE (((v_user.porcentaje = (100)::double precision) AND (u.created = u.modified)) OR (u.modified IS NULL));


ALTER TABLE encuestas.v_email_datos_contacto OWNER TO encuestas;

--
-- TOC entry 2589 (class 0 OID 0)
-- Dependencies: 222
-- Name: VIEW v_email_datos_contacto; Type: COMMENT; Schema: encuestas; Owner: encuestas
--

COMMENT ON VIEW v_email_datos_contacto IS 'Usuarios que hayan completado la encuesta al 100% pero no han actualizado los datos de contacto';


--
-- TOC entry 223 (class 1259 OID 17163)
-- Name: v_email_dc_recordatorio; Type: VIEW; Schema: encuestas; Owner: encuestas
--

CREATE VIEW v_email_dc_recordatorio AS
 SELECT u.id,
    u.dni,
    u.apellido,
    u.nombre,
    u.sexo,
    u.usuario,
    u.rol,
    u.fecha_nac,
    u.cod_depto,
    u.cod_loc,
    u.cod_prov,
    u.calle,
    u.email_1,
    u.email_2,
    u.tel_fijo,
    u.celular,
    u.facebook,
    u.twitter,
    u.foto_perfil,
    u.created,
    u.modified,
    u.localidad,
    u.provincia,
    u.password,
    u.cohorte,
    u.promedio_sin_aplazo,
    u.fecha_ultima_materia,
    u.fecha_emision_titulo,
    u.promedio_con_aplazo,
    u.fecha_solicitud_titulo,
    u.cohorte_graduacion,
    u.hashactivador,
    u.activado,
    gru.grupo_id
   FROM (usuarios u
     LEFT JOIN grupos_usuarios gru ON ((gru.usuario_id = u.id)))
  WHERE ((((u.rol)::text ~~* 'graduado'::text) AND (u.created = u.modified)) OR (u.modified >= (('now'::text)::date + 180)));


ALTER TABLE encuestas.v_email_dc_recordatorio OWNER TO encuestas;

--
-- TOC entry 2590 (class 0 OID 0)
-- Dependencies: 223
-- Name: VIEW v_email_dc_recordatorio; Type: COMMENT; Schema: encuestas; Owner: encuestas
--

COMMENT ON VIEW v_email_dc_recordatorio IS 'Enviar mail a contactos que no hayan actualizado sus datos o que sea mayor a 180 días (6 meses)';


--
-- TOC entry 224 (class 1259 OID 17168)
-- Name: v_encuesta_grupos; Type: VIEW; Schema: encuestas; Owner: encuestas
--

CREATE VIEW v_encuesta_grupos AS
 SELECT a.encuesta_id,
    a.grupo_id,
    b.nombre
   FROM (encuestas_grupos a
     LEFT JOIN grupos b ON ((a.grupo_id = b.id)));


ALTER TABLE encuestas.v_encuesta_grupos OWNER TO encuestas;

--
-- TOC entry 225 (class 1259 OID 17172)
-- Name: v_encuestas_preguntas; Type: VIEW; Schema: encuestas; Owner: encuestas
--

CREATE VIEW v_encuestas_preguntas AS
 SELECT a.id AS encuesta_id,
    c.id,
    c.nombre,
    c.tipo_id,
    c.opcion_count,
    c.categoria_id,
    c.subcategoria_id,
    c.created,
    c.modified,
    c.owner_id,
    b.orden,
    p.nombre AS tipo_pregunta,
    c.id AS pregunta_id
   FROM (((encuestas a
     LEFT JOIN encuestas_preguntas b ON ((a.id = b.encuesta_id)))
     LEFT JOIN preguntas c ON ((b.pregunta_id = c.id)))
     LEFT JOIN tipos p ON ((p.id = c.tipo_id)))
  ORDER BY b.orden;


ALTER TABLE encuestas.v_encuestas_preguntas OWNER TO encuestas;

--
-- TOC entry 226 (class 1259 OID 17177)
-- Name: v_enviar_mail; Type: VIEW; Schema: encuestas; Owner: encuestas
--

CREATE VIEW v_enviar_mail AS
 SELECT ((gru_usu.grupo_id || (usu.usuario)::text) || enc_gru.encuesta_id) AS id,
    usu.id AS usuario_id,
    gru_usu.grupo_id,
    usu.dni,
    usu.apellido,
    usu.nombre,
    usu.usuario,
    usu.rol,
    usu.email_1,
    enc_gru.encuesta_id
   FROM ((grupos_usuarios gru_usu
     LEFT JOIN usuarios usu ON ((usu.id = gru_usu.usuario_id)))
     LEFT JOIN encuestas_grupos enc_gru ON ((enc_gru.grupo_id = gru_usu.grupo_id)))
  WHERE ((((usu.email_1)::text <> ''::text) AND ((usu.email_1)::text ~~ '%@%'::text)) AND ((usu.email_1)::text ~~ '%.com%'::text));


ALTER TABLE encuestas.v_enviar_mail OWNER TO encuestas;

--
-- TOC entry 227 (class 1259 OID 17182)
-- Name: v_enviar_mail_primera_vez; Type: VIEW; Schema: encuestas; Owner: encuestas
--

CREATE VIEW v_enviar_mail_primera_vez AS
 SELECT ((gru_usu.grupo_id || (usu.usuario)::text) || enc_gru.encuesta_id) AS id,
    usu.id AS usuario_id,
    gru_usu.grupo_id,
    usu.dni,
    usu.apellido,
    usu.nombre,
    usu.usuario,
    usu.rol,
    usu.email_1,
    enc_gru.encuesta_id
   FROM ((grupos_usuarios gru_usu
     LEFT JOIN usuarios usu ON ((usu.id = gru_usu.usuario_id)))
     LEFT JOIN encuestas_grupos enc_gru ON ((enc_gru.grupo_id = gru_usu.grupo_id)))
  WHERE (((((usu.email_1)::text <> ''::text) AND ((usu.email_1)::text ~~ '%@%'::text)) AND ((usu.email_1)::text ~~ '%.com%'::text)) AND (NOT ((((gru_usu.usuario_id)::text || gru_usu.grupo_id) || enc_gru.encuesta_id) IN ( SELECT (((m.usuario_id)::text || m.grupo_id) || m.encuesta_id) AS idcomp
           FROM mail m))));


ALTER TABLE encuestas.v_enviar_mail_primera_vez OWNER TO encuestas;

--
-- TOC entry 2591 (class 0 OID 0)
-- Dependencies: 227
-- Name: VIEW v_enviar_mail_primera_vez; Type: COMMENT; Schema: encuestas; Owner: encuestas
--

COMMENT ON VIEW v_enviar_mail_primera_vez IS 'Enviar mail a los usuarios que tienen una encuesta asignada por primera vez. No están en la tabla mail';


--
-- TOC entry 228 (class 1259 OID 17187)
-- Name: v_enviar_mail_recordatorio; Type: VIEW; Schema: encuestas; Owner: encuestas
--

CREATE VIEW v_enviar_mail_recordatorio AS
 SELECT m.id,
    m.grupo_id,
    m.encuesta_id,
    m.usuario_id,
    m.created,
    resu.cantrespuestas,
    resu.totalpreguntas,
    resu.porcentaje,
    usu.dni,
    usu.apellido,
    usu.nombre,
    usu.usuario,
    usu.rol,
    usu.email_1
   FROM ((mail m
     JOIN v_resumen_usuario_respuestas resu ON ((((m.usuario_id = resu.usuario_id) AND (m.encuesta_id = resu.encuesta_id)) AND (resu.porcentaje < (90)::double precision))))
     LEFT JOIN usuarios usu ON ((usu.id = m.usuario_id)));


ALTER TABLE encuestas.v_enviar_mail_recordatorio OWNER TO encuestas;

--
-- TOC entry 2592 (class 0 OID 0)
-- Dependencies: 228
-- Name: VIEW v_enviar_mail_recordatorio; Type: COMMENT; Schema: encuestas; Owner: encuestas
--

COMMENT ON VIEW v_enviar_mail_recordatorio IS 'Muestra los usuarios a los que no se han enviado el mail.
No muestra los que aparecen en la tabla mail que son los que han recibido el mail emitido por el sistema.';


--
-- TOC entry 229 (class 1259 OID 17192)
-- Name: v_grupos_encuesta; Type: VIEW; Schema: encuestas; Owner: encuestas
--

CREATE VIEW v_grupos_encuesta AS
 SELECT a.encuesta_id,
    a.grupo_id,
    b.nombre
   FROM (encuestas_grupos a
     LEFT JOIN grupos b ON ((a.grupo_id = b.id)));


ALTER TABLE encuestas.v_grupos_encuesta OWNER TO encuestas;

--
-- TOC entry 230 (class 1259 OID 17196)
-- Name: v_resumen_encuestas; Type: VIEW; Schema: encuestas; Owner: encuestas
--

CREATE VIEW v_resumen_encuestas AS
 SELECT a.id AS encuesta_id,
    b.completas,
    b.incompletas,
    b.usuarios,
    c.grupos,
    d.preguntas,
    (((b.completas)::double precision / (b.usuarios)::double precision) * (100)::double precision) AS porcentaje,
    b.totalrespuestas AS respuestas_cargadas,
    (b.usuarios * d.preguntas) AS respuestas_aprox,
    b.fecha_ultima_respuesta,
    b.fecha_primer_respuesta
   FROM (((encuestas a
     LEFT JOIN ( SELECT a_1.id AS encuesta_id,
            sum(
                CASE
                    WHEN (b_1.porcentaje = (100)::double precision) THEN 1
                    ELSE 0
                END) AS completas,
            sum(
                CASE
                    WHEN (b_1.porcentaje <> (100)::double precision) THEN 1
                    ELSE 0
                END) AS incompletas,
            count(b_1.usuario_id) AS usuarios,
            sum(b_1.cantrespuestas) AS totalrespuestas,
            max(b_1.fecha_ultima_respuesta) AS fecha_ultima_respuesta,
            min(b_1.fecha_primer_respuesta) AS fecha_primer_respuesta
           FROM (encuestas a_1
             LEFT JOIN v_resumen_usuario_respuestas b_1 ON ((a_1.id = b_1.encuesta_id)))
          GROUP BY a_1.id) b ON ((a.id = b.encuesta_id)))
     LEFT JOIN ( SELECT a_1.id AS encuesta_id,
            count(b_1.grupo_id) AS grupos
           FROM (encuestas a_1
             LEFT JOIN encuestas_grupos b_1 ON ((a_1.id = b_1.encuesta_id)))
          GROUP BY a_1.id) c ON ((a.id = c.encuesta_id)))
     LEFT JOIN ( SELECT a_1.id AS encuesta_id,
            count(b_1.pregunta_id) AS preguntas
           FROM (encuestas a_1
             LEFT JOIN encuestas_preguntas b_1 ON ((a_1.id = b_1.encuesta_id)))
          GROUP BY a_1.id) d ON ((a.id = d.encuesta_id)));


ALTER TABLE encuestas.v_resumen_encuestas OWNER TO encuestas;

--
-- TOC entry 231 (class 1259 OID 17201)
-- Name: v_usuarios_encuestas; Type: VIEW; Schema: encuestas; Owner: encuestas
--

CREATE VIEW v_usuarios_encuestas AS
 SELECT e.encuesta_id,
    e.grupo_id,
    g.usuario_id
   FROM (encuestas_grupos e
     JOIN grupos_usuarios g ON ((g.grupo_id = e.grupo_id)));


ALTER TABLE encuestas.v_usuarios_encuestas OWNER TO encuestas;

--
-- TOC entry 232 (class 1259 OID 17205)
-- Name: validaciones; Type: TABLE; Schema: encuestas; Owner: encuestas; Tablespace: 
--

CREATE TABLE validaciones (
    id integer NOT NULL,
    pregunta_id integer,
    owner_id integer,
    regla_id integer,
    obligatoria boolean,
    usuario_id integer,
    maximo integer,
    minimo integer,
    mensaje character varying,
    vacia boolean,
    created timestamp without time zone,
    modified timestamp without time zone
);


ALTER TABLE encuestas.validaciones OWNER TO encuestas;

--
-- TOC entry 233 (class 1259 OID 17211)
-- Name: validaciones_id_seq; Type: SEQUENCE; Schema: encuestas; Owner: encuestas
--

CREATE SEQUENCE validaciones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE encuestas.validaciones_id_seq OWNER TO encuestas;

--
-- TOC entry 2593 (class 0 OID 0)
-- Dependencies: 233
-- Name: validaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: encuestas; Owner: encuestas
--

ALTER SEQUENCE validaciones_id_seq OWNED BY validaciones.id;


--
-- TOC entry 2417 (class 2604 OID 17529)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY carreras_unla ALTER COLUMN id SET DEFAULT nextval('carreras_unla_id_seq'::regclass);


--
-- TOC entry 2418 (class 2604 OID 17530)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY categorias ALTER COLUMN id SET DEFAULT nextval('categorias_id_seq'::regclass);


--
-- TOC entry 2419 (class 2604 OID 17531)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY departamentos_unla ALTER COLUMN id SET DEFAULT nextval('departamentos_unla_id_seq'::regclass);


--
-- TOC entry 2413 (class 2604 OID 17532)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY encuestas ALTER COLUMN id SET DEFAULT nextval('encuestas_id_seq'::regclass);


--
-- TOC entry 2414 (class 2604 OID 17533)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY encuestas_grupos ALTER COLUMN id SET DEFAULT nextval('encuestas_grupos_id_seq'::regclass);


--
-- TOC entry 2420 (class 2604 OID 17534)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY encuestas_preguntas ALTER COLUMN id SET DEFAULT nextval('encuestas_preguntas_id_seq'::regclass);


--
-- TOC entry 2421 (class 2604 OID 17535)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY filtros ALTER COLUMN id SET DEFAULT nextval('filtros_id_seq'::regclass);


--
-- TOC entry 2422 (class 2604 OID 17536)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY filtros_opciones ALTER COLUMN id SET DEFAULT nextval('filtros_opciones_id_seq'::regclass);


--
-- TOC entry 2416 (class 2604 OID 17537)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY grupos ALTER COLUMN id SET DEFAULT nextval('grupos_id_seq'::regclass);


--
-- TOC entry 2415 (class 2604 OID 17538)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY grupos_usuarios ALTER COLUMN id SET DEFAULT nextval('grupos_usuarios_id_seq'::regclass);


--
-- TOC entry 2423 (class 2604 OID 17539)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY mail ALTER COLUMN id SET DEFAULT nextval('mail_id_seq'::regclass);


--
-- TOC entry 2424 (class 2604 OID 17540)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY mail_grupos ALTER COLUMN id SET DEFAULT nextval('mail_grupos_id_seq'::regclass);


--
-- TOC entry 2425 (class 2604 OID 17541)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY mail_usuarios ALTER COLUMN id SET DEFAULT nextval('mail_usuarios_id_seq'::regclass);


--
-- TOC entry 2426 (class 2604 OID 17542)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY opciones ALTER COLUMN id SET DEFAULT nextval('opciones_id_seq'::regclass);


--
-- TOC entry 2428 (class 2604 OID 17543)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY preguntas ALTER COLUMN id SET DEFAULT nextval('preguntas_id_seq'::regclass);


--
-- TOC entry 2429 (class 2604 OID 17544)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY reglas ALTER COLUMN id SET DEFAULT nextval('reglas_id_seq'::regclass);


--
-- TOC entry 2430 (class 2604 OID 17545)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY reportes ALTER COLUMN id SET DEFAULT nextval('reportes_id_seq'::regclass);


--
-- TOC entry 2431 (class 2604 OID 17546)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY respuestas ALTER COLUMN id SET DEFAULT nextval('respuestas_id_seq'::regclass);


--
-- TOC entry 2432 (class 2604 OID 17547)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY respuestas_opciones ALTER COLUMN id SET DEFAULT nextval('respuestas_opciones_id_seq'::regclass);


--
-- TOC entry 2433 (class 2604 OID 17548)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY subcategorias ALTER COLUMN id SET DEFAULT nextval('subcategorias_id_seq'::regclass);


--
-- TOC entry 2434 (class 2604 OID 17549)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY tipos ALTER COLUMN id SET DEFAULT nextval('tipos_id_seq'::regclass);


--
-- TOC entry 2436 (class 2604 OID 17550)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY usuarios ALTER COLUMN id SET DEFAULT nextval('usuarios_id_seq'::regclass);


--
-- TOC entry 2437 (class 2604 OID 17551)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY usuarios_carreras ALTER COLUMN id SET DEFAULT nextval('usuarios_carreras_id_seq'::regclass);


--
-- TOC entry 2438 (class 2604 OID 17552)
-- Name: id; Type: DEFAULT; Schema: encuestas; Owner: encuestas
--

ALTER TABLE ONLY validaciones ALTER COLUMN id SET DEFAULT nextval('validaciones_id_seq'::regclass);


-- Completed on 2016-02-01 16:50:33 ART

--
-- PostgreSQL database dump complete
--

