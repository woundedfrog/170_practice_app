--
-- PostgreSQL database dump
--

-- Dumped from database version 10.6 (Ubuntu 10.6-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.6 (Ubuntu 10.6-0ubuntu0.18.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: class_type; Type: TYPE; Schema: public; Owner: curmet
--

CREATE TYPE public.class_type AS ENUM (
    'attacker',
    'healer',
    'debuffer',
    'buffer',
    'tank'
);


ALTER TYPE public.class_type OWNER TO curmet;

--
-- Name: ele_type; Type: TYPE; Schema: public; Owner: curmet
--

CREATE TYPE public.ele_type AS ENUM (
    'water',
    'fire',
    'earth',
    'light',
    'dark'
);


ALTER TYPE public.ele_type OWNER TO curmet;

--
-- Name: starcount; Type: TYPE; Schema: public; Owner: curmet
--

CREATE TYPE public.starcount AS ENUM (
    '3',
    '4',
    '5'
);


ALTER TYPE public.starcount OWNER TO curmet;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: mainstats; Type: TABLE; Schema: public; Owner: curmet
--

CREATE TABLE public.mainstats (
    unit_id integer NOT NULL,
    stars public.starcount NOT NULL,
    type public.class_type NOT NULL,
    element public.ele_type NOT NULL,
    tier text DEFAULT 0,
    id integer NOT NULL
);


ALTER TABLE public.mainstats OWNER TO curmet;

--
-- Name: mainstats_id_seq; Type: SEQUENCE; Schema: public; Owner: curmet
--

CREATE SEQUENCE public.mainstats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mainstats_id_seq OWNER TO curmet;

--
-- Name: mainstats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: curmet
--

ALTER SEQUENCE public.mainstats_id_seq OWNED BY public.mainstats.id;


--
-- Name: mainstats_unit_id_seq; Type: SEQUENCE; Schema: public; Owner: curmet
--

CREATE SEQUENCE public.mainstats_unit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mainstats_unit_id_seq OWNER TO curmet;

--
-- Name: mainstats_unit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: curmet
--

ALTER SEQUENCE public.mainstats_unit_id_seq OWNED BY public.mainstats.unit_id;


--
-- Name: substats; Type: TABLE; Schema: public; Owner: curmet
--

CREATE TABLE public.substats (
    unit_id integer NOT NULL,
    leader text,
    auto text,
    tap text,
    slide text,
    drive text
);


ALTER TABLE public.substats OWNER TO curmet;

--
-- Name: substats_unit_id_seq; Type: SEQUENCE; Schema: public; Owner: curmet
--

CREATE SEQUENCE public.substats_unit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.substats_unit_id_seq OWNER TO curmet;

--
-- Name: substats_unit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: curmet
--

ALTER SEQUENCE public.substats_unit_id_seq OWNED BY public.substats.unit_id;


--
-- Name: units; Type: TABLE; Schema: public; Owner: curmet
--

CREATE TABLE public.units (
    id integer NOT NULL,
    name character varying(60) NOT NULL,
    created_on date DEFAULT CURRENT_DATE
);


ALTER TABLE public.units OWNER TO curmet;

--
-- Name: units_id_seq; Type: SEQUENCE; Schema: public; Owner: curmet
--

CREATE SEQUENCE public.units_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.units_id_seq OWNER TO curmet;

--
-- Name: units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: curmet
--

ALTER SEQUENCE public.units_id_seq OWNED BY public.units.id;


--
-- Name: mainstats unit_id; Type: DEFAULT; Schema: public; Owner: curmet
--

ALTER TABLE ONLY public.mainstats ALTER COLUMN unit_id SET DEFAULT nextval('public.mainstats_unit_id_seq'::regclass);


--
-- Name: mainstats id; Type: DEFAULT; Schema: public; Owner: curmet
--

ALTER TABLE ONLY public.mainstats ALTER COLUMN id SET DEFAULT nextval('public.mainstats_id_seq'::regclass);


--
-- Name: substats unit_id; Type: DEFAULT; Schema: public; Owner: curmet
--

ALTER TABLE ONLY public.substats ALTER COLUMN unit_id SET DEFAULT nextval('public.substats_unit_id_seq'::regclass);


--
-- Name: units id; Type: DEFAULT; Schema: public; Owner: curmet
--

ALTER TABLE ONLY public.units ALTER COLUMN id SET DEFAULT nextval('public.units_id_seq'::regclass);


--
-- Data for Name: mainstats; Type: TABLE DATA; Schema: public; Owner: curmet
--

INSERT INTO public.mainstats VALUES (2, '5', 'buffer', 'water', '10 10 10 10', 1);
INSERT INTO public.mainstats VALUES (5, '5', 'attacker', 'water', '10 10 10 10', 2);
INSERT INTO public.mainstats VALUES (3, '3', 'healer', 'earth', '10 10 10 8', 4);


--
-- Data for Name: substats; Type: TABLE DATA; Schema: public; Owner: curmet
--



--
-- Data for Name: units; Type: TABLE DATA; Schema: public; Owner: curmet
--

INSERT INTO public.units VALUES (2, 'Kouga', '2019-03-18');
INSERT INTO public.units VALUES (3, 'Syrinx', '2019-03-18');
INSERT INTO public.units VALUES (4, 'Dana', '2019-03-18');
INSERT INTO public.units VALUES (5, 'Eve', '2019-03-18');


--
-- Name: mainstats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: curmet
--

SELECT pg_catalog.setval('public.mainstats_id_seq', 5, true);


--
-- Name: mainstats_unit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: curmet
--

SELECT pg_catalog.setval('public.mainstats_unit_id_seq', 2, true);


--
-- Name: substats_unit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: curmet
--

SELECT pg_catalog.setval('public.substats_unit_id_seq', 1, false);


--
-- Name: units_id_seq; Type: SEQUENCE SET; Schema: public; Owner: curmet
--

SELECT pg_catalog.setval('public.units_id_seq', 6, true);


--
-- Name: mainstats mainstats_pkey; Type: CONSTRAINT; Schema: public; Owner: curmet
--

ALTER TABLE ONLY public.mainstats
    ADD CONSTRAINT mainstats_pkey PRIMARY KEY (id);


--
-- Name: units units_name_key; Type: CONSTRAINT; Schema: public; Owner: curmet
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_name_key UNIQUE (name);


--
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: curmet
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- Name: mainstats mainstats_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: curmet
--

ALTER TABLE ONLY public.mainstats
    ADD CONSTRAINT mainstats_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id) ON DELETE CASCADE;


--
-- Name: substats substats_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: curmet
--

ALTER TABLE ONLY public.substats
    ADD CONSTRAINT substats_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

