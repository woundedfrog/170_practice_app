--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.14
-- Dumped by pg_dump version 9.5.14

SET statement_timeout = 0;
SET lock_timeout = 0;
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
-- Name: class_type; Type: TYPE; Schema: public; Owner: lucin
--

CREATE TYPE public.class_type AS ENUM (
    'attacker',
    'healer',
    'debuffer',
    'buffer',
    'tank',
    ''
);


ALTER TYPE public.class_type OWNER TO lucin;

--
-- Name: ele_type; Type: TYPE; Schema: public; Owner: lucin
--

CREATE TYPE public.ele_type AS ENUM (
    'water',
    'fire',
    'earth',
    '',
    'grass',
    'light',
    'dark'
);


ALTER TYPE public.ele_type OWNER TO lucin;

--
-- Name: starcount; Type: TYPE; Schema: public; Owner: lucin
--

CREATE TYPE public.starcount AS ENUM (
    '3',
    '',
    '4',
    '5'
);


ALTER TYPE public.starcount OWNER TO lucin;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: mainstats; Type: TABLE; Schema: public; Owner: lucin
--

CREATE TABLE public.mainstats (
    unit_id integer NOT NULL,
    stars public.starcount DEFAULT '5'::public.starcount NOT NULL,
    type public.class_type DEFAULT 'attacker'::public.class_type NOT NULL,
    element public.ele_type DEFAULT 'fire'::public.ele_type NOT NULL,
    tier text DEFAULT '0 0 0 0'::text
);


ALTER TABLE public.mainstats OWNER TO lucin;

--
-- Name: profilepics; Type: TABLE; Schema: public; Owner: lucin
--

CREATE TABLE public.profilepics (
    unit_id integer NOT NULL,
    pic1 text DEFAULT 'emptyunit0.png'::text,
    pic2 text DEFAULT ''::text,
    pic3 text DEFAULT ''::text,
    pic4 text DEFAULT ''::text
);


ALTER TABLE public.profilepics OWNER TO lucin;

--
-- Name: scstats; Type: TABLE; Schema: public; Owner: lucin
--

CREATE TABLE public.scstats (
    sc_id integer NOT NULL,
    pic1 text DEFAULT 'blankcard.jpg'::text,
    stars public.starcount DEFAULT '5'::public.starcount,
    stats text DEFAULT 'TBA'::text,
    passive text DEFAULT 'Restrictions: none.'::text
);


ALTER TABLE public.scstats OWNER TO lucin;

--
-- Name: soulcards; Type: TABLE; Schema: public; Owner: lucin
--

CREATE TABLE public.soulcards (
    id integer NOT NULL,
    name text DEFAULT 'TBA'::text NOT NULL,
    created_on date DEFAULT ('now'::text)::date,
    enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.soulcards OWNER TO lucin;

--
-- Name: soulcards_id_seq; Type: SEQUENCE; Schema: public; Owner: lucin
--

CREATE SEQUENCE public.soulcards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.soulcards_id_seq OWNER TO lucin;

--
-- Name: soulcards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lucin
--

ALTER SEQUENCE public.soulcards_id_seq OWNED BY public.soulcards.id;


--
-- Name: substats; Type: TABLE; Schema: public; Owner: lucin
--

CREATE TABLE public.substats (
    unit_id integer NOT NULL,
    leader text DEFAULT ''::text,
    auto text DEFAULT ''::text,
    tap text DEFAULT ''::text,
    slide text DEFAULT ''::text,
    drive text DEFAULT ''::text,
    notes text DEFAULT ''::text
);


ALTER TABLE public.substats OWNER TO lucin;

--
-- Name: test; Type: TABLE; Schema: public; Owner: lucin
--

CREATE TABLE public.test (
    id integer NOT NULL,
    name text
);


ALTER TABLE public.test OWNER TO lucin;

--
-- Name: test_id_seq; Type: SEQUENCE; Schema: public; Owner: lucin
--

CREATE SEQUENCE public.test_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.test_id_seq OWNER TO lucin;

--
-- Name: test_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lucin
--

ALTER SEQUENCE public.test_id_seq OWNED BY public.test.id;


--
-- Name: units; Type: TABLE; Schema: public; Owner: lucin
--

CREATE TABLE public.units (
    id integer NOT NULL,
    name character varying(60) DEFAULT 'tba'::character varying NOT NULL,
    created_on date DEFAULT ('now'::text)::date,
    enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.units OWNER TO lucin;

--
-- Name: units_id_seq; Type: SEQUENCE; Schema: public; Owner: lucin
--

CREATE SEQUENCE public.units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.units_id_seq OWNER TO lucin;

--
-- Name: units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lucin
--

ALTER SEQUENCE public.units_id_seq OWNED BY public.units.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.soulcards ALTER COLUMN id SET DEFAULT nextval('public.soulcards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.test ALTER COLUMN id SET DEFAULT nextval('public.test_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.units ALTER COLUMN id SET DEFAULT nextval('public.units_id_seq'::regclass);


--
-- Data for Name: mainstats; Type: TABLE DATA; Schema: public; Owner: lucin
--

COPY public.mainstats (unit_id, stars, type, element, tier) FROM stdin;
7	5	tank	light	10 10 10 8
5	5	buffer	water	10 10 10 10
8	5	healer	light	10 8 10 10
14	5	attacker	fire	9 9 10 10
15	5	healer	light	9 9 9 9
16	5	attacker	dark	9 9 9 9
18	5	attacker	light	9 9 9 9
19	5	attacker	light	9 9 10 10
24	5	debuffer	water	9 9 3 3
26	5	attacker	dark	8 8 8 8
28	5	attacker	light	8 6 7 7
29	5	debuffer	light	8 8 7 8
30	5	tank	water	8 8 8 10
31	5	attacker	fire	8 8 8 8
32	5	debuffer	fire	8 6 9 9
33	5	debuffer	dark	8 8 6 5
34	5	buffer	fire	8 7 10 9
35	5	attacker	water	8 6 8 8
38	5	attacker	water	7 6 7 8
39	5	attacker	water	7 7 6 7
40	5	debuffer	water	7 7 5 5
41	5	buffer	water	7 8 7 7
42	5	attacker	fire	7 5 7 10
43	5	buffer	fire	7 4 6 6
44	5	healer	water	7 6 6 3
46	5	buffer	dark	7 6 7 9
50	5	debuffer	dark	7 7 7 6
51	5	healer	fire	7 7 8 6
52	5	attacker	light	7 7 6 7
54	5	attacker	dark	7 7 10 10
55	5	debuffer	fire	7 7 5 5
56	5	buffer	light	7 7 7 8
57	5	attacker	dark	7 8 10 10
59	5	buffer	water	7 7 8 10
60	5	debuffer	light	7 8 3 3
61	5	buffer	light	7 7 10 9
62	5	debuffer	light	7 6 8 10
64	5	attacker	water	6 4 4 6
65	5	tank	fire	6 7 6 3
66	5	tank	water	6 6 6 9
68	5	attacker	fire	6 6 5 8
69	5	attacker	fire	6 6 8 8
70	5	attacker	water	6 6 6 7
71	5	attacker	light	6 6 5 7
73	5	buffer	water	6 5 6 10
74	5	debuffer	water	6 6 6 7
76	5	attacker	light	6 7 7 8
80	5	attacker	dark	6 6 7 8
81	5	attacker	light	6 6 9 8
82	5	buffer	light	6 6 9 7
84	5	buffer	dark	6 8 6 6
85	5	tank	light	6 8 4 4
87	5	tank	fire	6 5 5 5
88	5	healer	fire	6 5 7 6
91	5	debuffer	fire	6 6 7 7
93	5	attacker	fire	6 5 7 8
94	5	buffer	fire	6 6 7 10
96	5	tank	light	6 7 5 3
97	5	attacker	fire	6 6 9 8
100	5	buffer	dark	6 6 10 10
102	5	healer	water	6 6 6 5
106	5	healer	dark	6 6 7 3
107	5	buffer	light	6 7 10 10
108	5	debuffer	dark	6 6 3 3
109	5	buffer	fire	6 6 8 9
111	5	attacker	water	5 5 6 9
223	5	attacker	earth	6 7 7 7
114	5	attacker	dark	5 3 3 3
115	5	buffer	water	5 5 4 8
116	5	buffer	water	5 4 9 8
117	5	tank	fire	5 3 9 7
120	5	debuffer	light	5 3 4 3
121	5	tank	dark	5 5 5 3
122	5	tank	dark	4 4 4 3
123	5	tank	dark	4 3 3 3
124	5	buffer	light	4 4 4 9
125	5	healer	dark	4 4 4 4
127	5	debuffer	water	4 4 5 9
6	5	attacker	water	10 10 10 10
128	5	buffer	dark	3 4 8 7
36	5	attacker	fire	8 9 10 9
12	5	buffer	grass	10 10 10 10
17	5	attacker	grass	9 9 9 9
25	5	healer	grass	9 9 8 5
27	5	attacker	grass	8 7 9 8
37	5	healer	grass	7 8 8 6
45	5	attacker	grass	7 6 7 8
48	5	tank	grass	7 7 7 5
49	5	debuffer	grass	7 6 7 7
53	5	debuffer	grass	7 9 6 7
58	5	attacker	grass	7 7 10 10
63	5	buffer	grass	6 6 5 5
67	5	buffer	grass	6 3 8 5
75	5	debuffer	grass	6 6 9 9
77	5	attacker	grass	6 6 10 9
78	5	debuffer	grass	6 7 5 5
79	5	attacker	grass	6 6 7 7
89	5	buffer	grass	6 5 9 9
92	5	attacker	grass	6 6 7 9
99	5	debuffer	grass	6 8 5 5
110	5	debuffer	grass	6 6 6 6
112	5	tank	grass	5 4 4 3
113	5	buffer	grass	5 5 5 5
119	5	tank	grass	5 5 5 3
145	4	buffer	light	10 6 9 9
146	4	debuffer	dark	8 8 9 9
147	4	healer	earth	8 6 9 6
148	4	healer	light	7 6 7 6
149	4	attacker	dark	7 7 7 8
150	4	attacker	earth	7 5 7 7
151	4	debuffer	earth	7 7 4 5
152	4	attacker	dark	7 8 8 8
153	4	buffer	light	7 6 8 7
154	4	healer	fire	7 5 7 6
155	4	debuffer	earth	7 7 5 5
156	4	attacker	earth	7 6 8 10
157	4	attacker	water	7 6 7 10
158	4	attacker	water	7 9 8 9
159	4	attacker	light	6 6 6 8
160	4	attacker	light	6 7 6 7
161	4	attacker	light	6 7 6 7
162	4	attacker	light	6 6 7 8
163	4	debuffer	light	6 5 5 6
164	4	tank	light	6 6 6 5
165	4	healer	light	6 5 6 6
166	4	attacker	dark	6 6 6 7
167	4	tank	dark	6 4 6 6
168	4	healer	dark	6 6 6 6
169	4	buffer	fire	6 4 6 7
170	4	tank	fire	6 6 6 4
171	4	debuffer	water	6 3 5 5
172	4	buffer	water	6 3 5 4
173	4	buffer	water	6 4 6 6
174	4	healer	water	6 6 6 6
175	4	attacker	earth	6 6 7 8
176	4	attacker	earth	6 6 6 8
177	4	buffer	earth	6 6 6 6
178	4	buffer	light	6 6 8 7
179	4	debuffer	dark	6 6 7 9
180	4	buffer	dark	6 6 7 7
181	4	attacker	water	6 5 6 7
182	4	debuffer	water	6 5 3 3
183	4	attacker	light	6 7 7 7
184	4	attacker	fire	6 4 5 7
185	4	debuffer	fire	6 5 8 9
186	4	buffer	earth	5 5 5 5
187	4	tank	light	5 5 5 5
188	4	attacker	fire	5 5 7 7
189	4	tank	earth	5 5 5 5
190	4	buffer	fire	5 5 5 5
191	4	attacker	fire	4 4 6 7
192	4	attacker	fire	4 4 4 4
193	4	tank	fire	4 4 4 4
194	4	attacker	dark	4 4 4 4
195	4	tank	dark	3 3 3 3
196	4	tank	earth	3 3 3 3
197	4	tank	water	3 3 3 3
198	4	tank	earth	3 3 3 3
199	4	tank	dark	3 3 3 3
200	4	tank	fire	3 3 3 3
201	4	tank	fire	3 3 3 3
202	4	tank	water	3 3 3 3
203	3	buffer	water	6 6 7 9
204	3	debuffer	fire	6 6 7 8
205	3	attacker	fire	5 4 3 6
206	3	tank	dark	4 3 3 1
212	5	buffer	water	6 6 7 8
213	5	tank	water	6 6 6 6
218	5	debuffer	fire	8 9 7 7
221	5	healer	fire	7 7 8 8
215	5	debuffer	dark	6 9 5 7
216	5	attacker	water	8 7 9 7
220	5	debuffer	water	6 8 5 5
224	5	buffer	fire	6 6 7 10
\.


--
-- Data for Name: profilepics; Type: TABLE DATA; Schema: public; Owner: lucin
--

COPY public.profilepics (unit_id, pic1, pic2, pic3, pic4) FROM stdin;
5	/images/kouga0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
8	/images/maat0.png	/images/maat1.png	emptyunit0.png	emptyunit0.png
12	/images/newbiemona0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
14	/images/kouka0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
15	/images/innocentvenus0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
16	/images/frey0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
17	/images/gkouga0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
18	/images/mafdet0.png	/images/mafdet1.png	emptyunit0.png	emptyunit0.png
19	/images/cleopatra0.png	/images/cleopatra2.png	emptyunit0.png	emptyunit0.png
24	/images/orga0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
25	/images/syrinx0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
26	/images/khepri0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
27	/images/krampus0.png	/images/krampus1.png	emptyunit0.png	emptyunit0.png
28	/images/charlotte0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
29	/images/nirrti0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
30	/images/maris0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
31	/images/hestia0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
32	/images/jupiter0.png	/images/jupiter1.png	emptyunit0.png	emptyunit0.png
33	/images/lanfei0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
34	/images/christmasleda0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
35	/images/kasumi0.png	/images/kasumi1.png	/images/kasumi3.png	emptyunit0.png
37	/images/astraea0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
38	/images/chunli0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
39	/images/bari0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
40	/images/isolde0.png	/images/isolde1.png	emptyunit0.png	emptyunit0.png
41	/images/anemone0.png	/images/anemone1.png	emptyunit0.png	emptyunit0.png
42	/images/tyrfing0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
43	/images/verdel0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
44	/images/snowmiku0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
45	/images/siren0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
46	/images/durandal0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
48	/images/marierose0.png	/images/marierose1.png	/images/marierose2.png	emptyunit0.png
49	/images/cammy0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
50	/images/rita0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
51	/images/aurora0.png	/images/aurora1.png	emptyunit0.png	emptyunit0.png
52	/images/ashtoreth0.png	/images/ashtoreth1.png	emptyunit0.png	emptyunit0.png
53	/images/bathory0.png	/images/bathory1.png	emptyunit0.png	emptyunit0.png
54	/images/mysterioussaturn0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
55	/images/studenteve0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
56	/images/aria0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
57	/images/prettymars0.png	/images/prettymars1.png	emptyunit0.png	emptyunit0.png
58	/images/nicole0.png	/images/nicole1.png	emptyunit0.png	emptyunit0.png
59	/images/naiad0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
60	/images/moa0.png	/images/moa1.png	emptyunit0.png	emptyunit0.png
61	/images/hardworkerneptune0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
62	/images/kagurawarwolf0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
63	/images/brownie0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
64	/images/busterliza0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
65	/images/hades0.png	/images/hades1.png	emptyunit0.png	emptyunit0.png
66	/images/eshu0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
67	/images/epona0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
68	/images/maoudavi0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
69	/images/morgan0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
70	/images/thanatos0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
71	/images/hildr0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
73	/images/bikinidavi0.png	/images/bikinidavi1.png	emptyunit0.png	emptyunit0.png
74	/images/santa0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
75	/images/midas0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
76	/images/bastet0.png	/images/bastet1.png	emptyunit0.png	emptyunit0.png
77	/images/jiseihi0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
78	/images/ruin0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
79	/images/abaddon0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
80	/images/elizabeth0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
81	/images/freylight0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
82	/images/nevanlight0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
84	/images/pallas0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
85	/images/athena0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
87	/images/brigette.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
88	/images/honoka0.png	/images/honoka1.png	/images/honoka2.png	emptyunit0.png
89	/images/bikinilisa0.png	/images/bikinilisa1.png	emptyunit0.png	emptyunit0.png
91	/images/scubamona0.png	/images/scubamona1.png	emptyunit0.png	emptyunit0.png
92	/images/magicianohad0.png	/images/magicianohad1.png	emptyunit0.png	emptyunit0.png
93	/images/magicianailill0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
94	/images/partystarmedb0.png	/images/partystarmedb1.png	emptyunit0.png	emptyunit0.png
96	/images/diablo0.png	/images/diablo1.png	emptyunit0.png	emptyunit0.png
7	/images/dana0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
97	/images/medb0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
99	/images/lovesitri0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
100	/images/pantheon0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
102	/images/rusalka0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
106	/images/metis0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
107	/images/sitri0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
108	/images/medusa0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
109	/images/hermes0.png	/images/hermes1.png	emptyunit0.png	emptyunit0.png
110	/images/pan0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
111	/images/calypso0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
112	/images/hera0.png	/images/hera1.png	emptyunit0.png	emptyunit0.png
113	/images/yanagi0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
114	/images/darkmaat0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
115	/images/myrina0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
116	/images/hatsunemiku0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
117	/images/dinashi0.png	/images/dinashi1.png	emptyunit0.png	emptyunit0.png
119	/images/mammon0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
120	/images/horus0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
121	/images/bimoa0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
122	/images/redcross0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
123	/images/ai0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
124	/images/luna0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
125	/images/darkmidas0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
127	/images/tethys0.png	emptyunit0.png	emptyunit0.png	emptyunit0.png
6	/images/eve0.png	/images/eve1.png	/images/emptyunit0.png	/images/emptyunit0.png
128	/images/warwolf0.png	/images/warwolf1.png	/images/emptyunit0.png	/images/emptyunit0.png
36	/images/oiranbathory0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
145	/images/4leda0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
146	/images/4persephone0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
147	/images/4selene0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
148	/images/4merlin0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
149	/images/4inanna0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
150	/images/4korra0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
151	/images/4muse0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
152	/images/4artemis0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
153	/images/4bast0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
154	/images/4daphne0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
155	/images/4agamemnon0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
156	/images/4amor0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
157	/images/4sonnet0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
158	/images/4elysium0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
159	/images/4orora0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
160	/images/4calchas0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
161	/images/4maidendetective0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
162	/images/4titania0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
163	/images/4ishtar0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
164	/images/4heracles0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
165	/images/4pomona0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
166	/images/4morrigu0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
167	/images/4cybele0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
168	/images/4zelos0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
169	/images/4fortuna0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
170	/images/4eldorado0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
171	/images/4yaga0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
172	/images/4kirinus0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
173	/images/4mayahuel0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
174	/images/4isis0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
175	/images/4tisiphone0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
176	/images/4ambrosia0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
177	/images/4flora0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
178	/images/4erato0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
179	/images/4nevan0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
180	/images/4melpomene0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
181	/images/4danu0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
182	/images/4arges0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
183	/images/4victrix0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
184	/images/4neid0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
185	/images/4freesia0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
186	/images/4rednose0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
187	/images/4frigga0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
188	/images/4yuna0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
189	/images/4europa0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
190	/images/4rudolph0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
191	/images/4fenrir0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
192	/images/4hector0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
193	/images/4lady0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
194	/images/4guillotine0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
195	/images/4aten0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
196	/images/4hat-trick0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
197	/images/4halloween0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
198	/images/4ankh0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
199	/images/4bakje0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
200	/images/4chimaera0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
201	/images/4fairy0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
202	/images/4thoth0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
203	/images/3lisa0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
204	/images/3tiamat0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
205	/images/3davi0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
206	/images/3mona0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
218	/images/demeter0.png	/images/demeter1.png	/images/emptyunit0.png	/images/emptyunit0.png
221	/images/profdana0.png	/images/profdana1.png	/images/emptyunit0.png	/images/emptyunit0.png
212	/images/princessmiku0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
215	/images/banshee0.png	/images/banshee1.png	/images/emptyunit0.png	/images/emptyunit0.png
213	/images/bes0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
216	/images/dino0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
220	/images/babel0.png	/images/babel1.png	/images/emptyunit0.png	/images/emptyunit0.png
223	/images/daphnis0.png	/images/daphnis1.png	/images/emptyunit0.png	/images/emptyunit0.png
224	/images/ganesh0.png	/images/emptyunit0.png	/images/emptyunit0.png	/images/emptyunit0.png
\.


--
-- Data for Name: scstats; Type: TABLE DATA; Schema: public; Owner: lucin
--

COPY public.scstats (sc_id, pic1, stars, stats, passive) FROM stdin;
1	/images/sc/afternoonnap.jpg	5	HP: 1040 at lvl0 / 2020 at lvl50 / 3535 at lvl50 +5. \r\n\r\nCritical: 270 at lvl0  / 1250] at lvl50 / 2187 at lvl50 +5.	Restriction: None. \r\n\r\nDoT Accuracy +30% (55% at lvl50 +5) in WorldBoss
2	/images/sc/wisteriatree.jpg	5	HP: 1030 at lvl0 / 2010at lvl50 / 3517 at lvl50 +5. \r\n\r\nCritical: 270 at lvl0  / 1250 at lvl50 / 2187 at lvl50 +5.	Restriction: Grass type. \r\n\r\nBleed Resist +35% (50% at lvl50 +5)\t\r\n
3	/images/sc/vacation.jpg	5	Defense: 550at lvl0 / 1530 at lvl50 / 2677 at lvl50 +5. \r\n\r\nAgility: 280 at lvl0  / 1260 at lvl50 / 2205 at lvl50 +5.	Restrictions: None. \r\nPoison evasion +35% (50% at lvl50 +5) in Devil Rumble.
4	/images/sc/assbaringdevil.jpg	5	Attack: 520 at lvl0 / 1500 at lvl50 / 2625 at lvl50 +5. \r\n\r\nDefense: 270 at lvl0  / 1250 at lvl50 / 2187 at lvl50 +5.	Restriction: none. \r\n\r\nBleed + 200 (400 at lvl50 +5) in WorldBoss.
5	/images/sc/believe.jpg	5	Defense: 520 at lvl0 / 1500 at lvl50 / 2625 at lvl50 +5. \r\n\r\nCritical: 1250 at lvl0  / 1250 at lvl50 / 2187 at lvl50 +5.	Restriction: Grass type. \r\n\r\nPoison damage received -250 (500 at lvl50 +5) in Devil Rumble.
6	/images/sc/herooflegends.jpg	5	HP: 1030 at lvl0 / 2010 at lvl50 / 3517 at lvl50 +5. \r\n\r\nDefense: 520 at lvl0  / 1500 at lvl50 / 2625 at lvl50 +5.	Restriction: Attacker. \r\n\r\nIgnore Defense Damage + 200 (450 at lvl50 +5) on slide in Devil Rumble.
7	/images/sc/higginsdaughters.jpg	5	Attack: 570 at lvl0 / 1550 at lvl50 / 2712 at lvl50 +5. \r\n\r\nCritical: 320 at lvl0  / 1300 at lvl50 / 2275 at lvl50 +5.	Restriction: none. \r\n\r\n(14%) of critical is added to attack.
8	/images/sc/endosiblings.jpg	5	Attack: 570 at lvl0 / 1550 at lvl50 / 2712 at lvl50 +5. \r\n\r\nAgility:320 at lvl0  / 1300 at lvl50 / 2275 at lvl50 +5.	Restriction: none. \r\n(14%) of agility is added to attack.
9	/images/sc/huntingdevil.jpg	5	Attack: 530 at lvl0 / 1510 at lvl50 / 2642 at lvl50 +5. \r\n\r\nAgility: 270 at lvl0  / 1250 at lvl50 / 2187 at lvl50 +5.	Restriction: Dark. \r\n\r\nCritical damage +4000 in Ragna.
10	/images/sc/latenightpartner.jpg	5	HP: 1000 at lvl0 / 1980 at lvl50 / 3465 at lvl50 +5. \r\n\r\nDefense: 530 at lvl0  / 1510 at lvl50 / 2642 at lvl50 +5.	Restriction: Tank.  \r\nEffectiveness of Reflect +3% (11.5% at lvl50 +5) in Devil Rumble.
11	/images/sc/judgementday.jpg	5	HP: 1020 at lvl0 / 2000 at lvl50 / 3500 at lvl50 +5. \r\n\r\nDefense: 530 at lvl0  / 1500 at lvl50 / 2625 at lvl50 +5.	Restriction: Light. \r\n\r\nPoison damage received -250 (500 at lvl50 +5) in Devil Rumble.
12	/images/sc/togetherwithmeat.jpg	5	HP: 1020 at lvl0 / 2000 at lvl50 / 3500 at lvl50 +5. \r\n\r\nAttack: 520 at lvl0  / 1500 at lvl50 / 2625 at lvl50 +5.	Restriction: None. \r\nHealblock Resist +40%.
13	/images/sc/piercingbluesky.jpg	5	Attack: 520 at lvl0 / 1500 at lvl50 / 2625 at lvl50 +5. \r\n\r\nCritical: 270 at lvl0  / 1250 at lvl50 / 2187 at lvl50 +5.	Restriction: Light + Attacker. \r\n50% (65% at lvl50 +5) chance to ignore provocation.
14	/images/sc/powerofsmile.jpg	5	HP: 1020 at lvl0 / 2000 at lvl50 / 3500 at lvl50 +5. \r\n\r\nAttack: 520 at lvl0  / 1500 at lvl50 / 2625 at lvl50 +5.	Restriction: Grass + Attacker. \r\nPoison Resist +35% (50% at lvl50 +5).
15	/images/sc/princesscarry.jpg	5	HP: 1020 at lvl0 / 2000 at lvl50 / 3500 at lvl50 +5. \r\n\r\nAttack: 520 at lvl0  / 1500 at lvl50 / 2625 at lvl50 +5.	Restriction: None. \r\nBleed +200 (400 at lvl50 +5) in Underground.
16	/images/sc/stf.jpg	5	Attack: 530 at lvl0 / 1510 at lvl50 / 2642 at lvl50 +5. \r\n\r\nCritical: 270 at lvl0  / 1250 at lvl50 / 2187 at lvl50 +5.	Restriction: Light. \r\n\r\nCurse +200.
17	/images/sc/summerfestivalnight.jpg	5	HP: 1018 at lvl0 / 1998 at lvl50 / 3296 at lvl50 +5. \r\nAgility: 268 at lvl0  / 1248 at lvl50 / 2184 at lvl50 +5.	Restriction: None. \r\n\r\nFreeze evasion +8.5% (18.5%).
18	/images/sc/throne.jpg	5	HP: 1020 at lvl0 / 2000 at lvl50 / 3500 at lvl50 +5. \r\nDefense: 520 at lvl0  / 1500 at lvl50 / 2625 at lvl50 +5.	Restriction: None. \r\nSilence Resist +25% (50% at lvl50 +5) in Devil Rumble.
19	/images/sc/trainingexpert.jpg	5	HP: 1030 at lvl0 / 2010 at lvl50 / 3517 at lvl50 +5. \r\n\r\nDefense: 520 at lvl0  / 1500 at lvl50 / 2625 at lvl50 +5.	Restriction: Tank. \r\nWhen less than 3000 (5000) Hp, evasion +20% (27.5% at lvl50 +5)  in Devil Rumble.
20	/images/sc/underseadate.jpg	5	Defense: 540 at lvl0 / 1520 at lvl50 / 2660 at lvl50 +5. \r\n\r\nAgility: 280 at lvl0  / 1260 at lvl50 / 2205 at lvl50 +5.	Restriction: Water type. \r\n\r\nPoison +500 (+750 at lvl50 +5) in Underground.
21	/images/sc/wanderingdoctor.jpg	5	Attack: 500 at lvl0 / 1480 at lvl50 / 2590 at lvl50 +5. \r\n\r\nDefense: 540 at lvl0  / 1520 at lvl50 / 2660 at lvl50 +5.	Restriction: Attacker. \r\n\r\nLifesteal +200 (450 at lvl50 +5) in Underground.
22	/images/sc/bladesun.jpg	5	Attack: 560 at lvl0 / 1540 at lvl50 / 2695 at lvl50 +5. \r\n\r\nAgility: 270 at lvl0  / 1250 at lvl50 / 2187 at lvl50 +5.	Restriction: None. \r\n\r\nFinal attack +700 (1200 at lvl50 +5) in Underground.
23	/images/sc/seasidegoddess.jpg	5	HP: 1040 at lvl0 / 2020 at lvl50 / 3535 at lvl50 +5. \r\n\r\nDefense: 550 at lvl0  / 1530 at lvl50 / 2677 at lvl50 +5.	Restrictions: None. \r\n\r\nBleed +220 (320 at lvl50 +5) in Devil Rumble.
24	/images/sc/beachrelax.jpg	5	Attack: 540 at lvl0 / 1200 at lvl50 / 2660 at lvl50 +5. \r\n\r\nCritical: 280 at lvl0  / 1260 at lvl50 / 2205 at lvl50 +5.	Restriction: Grass type. \r\n\r\nFinal attack +700 in Ragna. \r\nIf card is +5 then +1200 in Ragna.
25	/images/sc/azuregirl.jpg	5	Attack: 520 at lvl0 / 1500 at lvl50 / 2625 at lvl50 +5. \r\n\r\nAgility: 270 at lvl0  / 1250 at lvl50 / 2187 at lvl50 +5.	Restriction: Water type. \r\n\r\nPoison +1000 (1500) in WorldBoss.
26	/images/sc/dive.jpg	5	[stat]: [basenumber] at lvl0 / [lvl50 number] at lvl50 / [lvl50 +5 number] at lvl50 +5.\r\n\r\n[stat]: [basenumber] at lvl0  / [lvl50 number] at lvl50 / [lvl50 +5 number] at lvl50 +5.	Restriction: [if none write none]\r\n\r\n[Write info]
27	/images/sc/scupgrade5.jpg	5	Increases + EXP by 480.	Restriction: None.
28	/images/sc/sow.jpg	5	[stat]: [basenumber] at lvl0 / [lvl50 number] at lvl50 / [lvl50 +5 number] at lvl50 +5.\r\n\r\n[stat]: [basenumber] at lvl0  / [lvl50 number] at lvl50 / [lvl50 +5 number] at lvl50 +5.	Restriction: [if none write none]\r\n\r\n[Write info]
29	/images/sc/shakingfeeling.jpg	5	HP: 1040 at lvl0 / [lvl50 number] at lvl50 / 3535 at lvl50 +5. \r\n\r\nAttack: 530 at lvl0  / [lvl50 number] at lvl50 / 2642 at lvl50 +5.	Restriction: None. \r\n\r\nIncrease 12% chance to stun in Devil Rumble.
30	/images/sc/crossedheart.jpg	5	HP: 1050 at lvl0 / 3552 at lvl50 +5. \r\n\r\nDefense: 560 at lvl0  / 2695 at lvl50 +5.	Restriction: none. \r\n\r\nIncrease Stun Ignore by 30% in Devil Rumble.
31	/images/sc/runaway.jpg	5	Attack: 560 at lvl0 / 2695 at lvl50 +5. \r\n\r\nCritical: 290 at lvl0 / 2222 at lvl50 +5.	Restriction: Light. \r\n\r\nIncrease Critical attack by 800 in Raid Boss.
32	/images/sc/forbiddenfruit.jpg	5	Attack: 560 at lvl0 / 2695 at lvl50 +5. \r\n\r\nAgility: 290 at lvl0  / 2222 at lvl50 +5.	Restriction: none. \r\n\r\n30% chance to ignore Death Heal in Raid Boss.
33	/images/sc/icedamericano.jpg	5	HP: 1078 at lvl0 / 2058 at lvl50 / 3601 at lvl50 +5. \r\n\r\nDefence: 586 at lvl0  /1566 at lvl50 / 2740 at lvl50 +5.	Restriction: Attacker. \r\n\r\nUsing a slide skill grants a 40% (45.5%) chance to get 700HP(1250HP) barrier for 10 seconds in Underground.
34	/images/sc/tamaki.jpg	5	Attack: 580 at lvl0 / [lvl50 +5 number] at lvl50 +5. \r\n\r\nDefense: 540 at lvl0  / [lvl50 +5 number] at lvl50 +5.	Restriction: Attacker. \r\n\r\nHeal 1500HP when enemy is killed.
35	/images/sc/ayane.jpg	5	HP: 1070 at lvl0 / [lvl50 +5 number] at lvl50 +5. \r\n \r\nAgility: 300 at lvl0 / [lvl50 +5 number] at lvl50 +5.	Restriction: None. \r\n\r\nIncrease Petrify resist +30% in Devil Rumble.
36	/images/sc/ganryudavi.jpg	5	Attack: 550 at lvl0 / ~ at lvl50 / ~ at lvl50 +5. \r\n\r\nDefense: 590 at lvl0 / ~ at lvl50 / ~ at lvl50 +5.	Restriction: None. \r\nAdd 9% of your final defense to your final attack power.
37	/images/sc/halloweendiva.jpg	5	Defense: 550 at lvl0 / ~ at lvl50 / ~ at lvl50 +5. \r\n\r\nAgility: 310 at lvl0  / ~ at lvl50 / ~ at lvl50 +5.	Restriction: none.\r\n\r\nIncrease Final HP +1500.
38	/images/sc/undertherose.jpg	5	Defense: 590 at lvl0 / ~ at lvl50 / ~ at lvl50 +5. \r\n\r\nAgility: 320 at lvl0  / ~ at lvl50 / ~ at lvl50 +5.	Restriction: None. \r\n\r\nIncrease "Dancing Blade" debuff damage in Devil Rumble +170.
39	/images/sc/showtime.jpg	5	HP: 1080 at lvl0 / ~ at lvl50 / ~ at lvl50 +5. \r\n\r\nCritical: 300 at lvl0  / ~ at lvl50 / ~ at lvl50 +5.	Restriction: Fire. \r\nIncrease 15% chance to debuff in WorldBoss.
40	/images/sc/queenofnight.jpg	5	HP: 1020 at lvl0 / ~ at lvl50 / ~ at lvl50 +5. \r\n\r\nCritical: 270 at lvl0  / ~ at lvl50 / ~ at lvl50 +5.	Restriction: None. \r\n\r\nIncrease Final Attack +500.
41	/images/sc/inspiration.jpg	5	Attack: 590 at lvl0 / ~ at lvl50 / ~ at lvl50 +5. \r\n\r\nCritical: 310 at lvl0  / ~ at lvl50 / ~ at lvl50 +5.	Restriction: Dark. \r\n\r\nIgnore Damage +350 added to normal skill in Raid Boss.
42	/images/sc/starrystage.jpg	5	HP: 1090 at lvl0 / ~ at lvl50 / ~ at lvl50 +5. \r\n\r\nAgility: 330 at lvl0  / ~ at lvl50 / ~ at lvl50 +5.	Restriction: None. \r\n\r\nIncrease Instant Heal received +800.
43	/images/sc/nobalnewyear.jpg	5	Attack: 600 at lvl0. \r\n\r\nCritical: 340 at lvl0.	Restriction: Light. Increase Final attack +1150 at WorldBoss.
44	/images/sc/ilovesake.jpg	5	HP: 1100 at lvl0. \r\n\r\nDefense: 600 at lvl0.	Restriction: Light. \r\n\r\nIncrease Final Defense +800.
45	/images/sc/christmasgift.jpg	5	Attack: 590 at lvl0. \r\n\r\nAgility: 330 at lvl0.	Restriction: Attacker. \r\nSlide skill damage +350.
46	/images/sc/racingsuit.jpg	5	Attack: 620 at lvl0 / 2800 at lvl50 +5. \r\n\r\nCritical: 350 at lvl0 / 2327 at lvl50 +5.	Restriction: Dark attacker. \r\n\r\nSlide skill critical damage +11%.
47	/images/sc/brieftranquility.jpg	5	Attack: 620 at lvl0 / 2800 at lvl50 +5. \r\n\r\nCritical: 350 at lvl0 / 2327 at lvl50 +5.	Restriction: Water attacker. \r\nSlide skill critical damage + 11%.
48	/images/sc/handsomeadventure.jpg	5	Attack: 620 at lvl0 / 2800 at lvl50 +5. \r\n\r\nAgility: 350 at lvl0 / 2327 at lvl50 +5.	Restriction: Water attacker. \r\n\r\nIncrease critical rate by 6%.
49	/images/sc/cakeaesthetics.jpg	5	Attack: 610 at lvl0 / 2782 at lvl50 +5. \r\n\r\nCritical: 340 at lvl0 / 2310 at lvl50 +5.	Restriction: Fire attacker. \r\n\r\nSlide skill critical damage +10%
50	/images/sc/meltychristmas.jpg	5	Attack: 610 at lvl0 / 2782 at lvl50 +5. \r\n\r\nCritical: 340 at lvl0 / 2310 at lvl50 +5.	Restriction: Grass attacker. \r\n\r\nSlide skill critical damage +10%.
51	/images/sc/darktownleader.jpg	5	Attack: 610 at lvl0 / 2782 at lvl50 +5. \r\n\r\nAgility: 340 at lvl0 / 2310 at lvl50 +5.	Restriction: Dark attacker. \r\n\r\nIncrease critical hit chance by 5%.
52	/images/sc/dangerousgambler.jpg	5	Attack: 610 at lvl0 / 2782 at lvl50 +5. \r\n\r\nAgility: 340 at lvl0 / 2310 at lvl50 +5.	Restriction: Light attacker. \r\n\r\nSlide skill critical damage +10%.
53	/images/sc/importantttreasure.jpg	5	Attack: 610 at lvl0 / 2782 at lvl50 +5. \r\n\r\nAgility: 340 at lvl0 / 2310 at lvl50 +5.	Restriction: Grass attacker. \r\nIncrease Critical hit chance by 5%.\r\n
54	/images/sc/godhavemercy.jpg	5	Attack: 610 at lvl0 / 2782 at lvl50 +5. \r\n\r\nAgility: 340 at lvl0 / 2310 at lvl50 +5.	Restriction: Light attacker. \r\n\r\nIncrease critical hit chance by 5%.
55	/images/sc/treasurehunter.jpg	5	Attack: 610 at lvl0 / 2782 at lvl50 +5. \r\n\r\nAgility: 340 at lvl0 / 2310 at lvl50 +5.	Restriction: Fire attacker. \r\nIncrease Critical hit chance by 5%.\r\n
56	/images/sc/kitakubunewyear.jpg	5	Defense: 590 at lvl0. \r\n\r\nAgility: 330 at lvl0.	Restriction: none. \r\n\r\nHP +9% of agility.
57	/images/sc/callthecops.jpg	5	HP: 1090 at lvl0 / [lvl50 +5 number] at lvl50 +5.  \r\n\r\nDefense: 59 at lvl0 / [lvl50 +5 number] at lvl50 +5.	Restriction: None. \r\n9% of defense stat is added to critical hit chance. \r\n
58	/images/sc/straylamb.jpg	5	Attack: 520 at lvl0. \r\n\r\nCritical: 270 at lvl0.	Restriction: none. \r\n\r\nFinal Agility +250.
59	/images/sc/extremecarnage.jpg	5	Defense: 520 at lvl0. \r\nAgility: 270 at lvl0.	Restriction: none. \r\nFinal HP +1000.
60	/images/sc/lostdream.jpg	5	[stat]: 1100 at lvl0. \r\n[stat]: 600 at lvl0.	Restriction: Fire. \r\n"Deadly poison" damage +250.
61	/images/sc/baptismgoddess.jpg	4	HP: 765 at lvl0 / 1350 at lvl40 / 1836 at lvl50 +4. \r\n\r\nDefense: 390 at lvl0  / 975 at lvl40 / 1326 at lvl40 +4.	Restriction: None. \r\n\r\nRegeneration Received +25 (125 at lvl40 +4).
62	/images/sc/castlepleasure.jpg	4	HP: 775 at lvl0 / 1340 at lvl40 / 1849 at lvl40 +4. \r\n\r\nDefense: 395 at lvl0  / 980 at lvl40 / 1332 at lvl40 +4.	Restriction: Grass. \r\n\r\nInstant Heal Received +400 (800 at lvl40 +4).
63	/images/sc/hero.jpg	4	Attack: 390 at lvl0 / 975 at lvl40 / 1326 at lvl40 +4. \r\nAgility: 202 at lvl0 / 787 at lvl40 / 1070 at lvl40 +4.\r\n	Restriction: None. \r\n\r\nAbsorb 100HP in Devil Rumble.
64	/images/sc/highjump.jpg	4	Attack: 390 at lvl0 / 975 at lvl40 / 1326 at lvl40 +4. \r\n\r\nCritical: 202 at lvl0 / 787 at lvl40 / 1070 at lvl40 +4.	Restriction: None. \r\n\r\nBleed +70.
65	/images/sc/strategistnight.jpg	4	HP: 775 at lvl0 / 1340 at lvl40 / 1849 at lvl40 +4. \r\n\r\nDefense: 395 at lvl0 / 980 at lvl40 / 1332 at lvl40 +4.	Restriction: Tank. \r\n\r\nFinal Defense +10%.
66	/images/sc/goodmoa.jpg	4	HP: 765 at lvl0 / 1350 at lvl40 / 1836 at lvl40 +4. \r\n\r\nAgility: 202 at lvl0  / 787 at lvl40 / 1070 at lvl40 +4.	Restriction: None. \r\nPoison +50 (250 at lvl40 +4).\r\n
67	/images/sc/timeover.jpg	4	HP: 765 at lvl0 / 1350 at lvl40 / 1836 at lvl40 +4. \r\n\r\nAttack: 390 at lvl0  / 975 at lvl40 / 1326 at lvl40 +4.	Restriction: None. \r\n\r\nSilence Resist +10% (16% at lvl40 +4) in Devil Rumble.
68	/images/sc/scupgrade4.jpg	4	Increases + EXP by 84.	Restriction: none.
69	/images/sc/dreamteam.jpg	4	Attack: 415 at lvl0 / 1000 at lvl40 / 1360 at lvl40 +4. \r\nDefense: 365 at lvl0 / 960 at lvl40 / 1305 at lvl40 +4.	Restriction: None. \r\n\r\nHeal 700 (1500 at lvl40 +4) HP when kill enemy.
70	/images/sc/runa.jpg	4	Defense: 395 at lvl0 / [lvl40 +4 number] at lvl40 +4. \r\n\r\nAgility: 210 at lvl0  / [lvl40 +4 number] at lvl40 +4.	Restriction: None. \r\n\r\nIncrease Blind Resist by +15% in Devil Rumble.
71	/images/sc/lookupatclouds.jpg	4	Attack: 430 at lvl0 / [lvl40 +4 number] at lvl40 +4. \r\n\r\nAgility: 206 at lvl0  / [lvl40 +4 number] at lvl40 +4.	Restriction: none. \r\n\r\nAdd 3% of your Final attack power to your Final agility power.
72	/images/sc/lacia.jpg	4	HP: 790 at lvl0 / [lvl40 +4 number] at lvl40 +4. \r\n\r\nDefense: 400 at lvl0  / [lvl40 +4 number] at lvl40 +4.	Restriction: none. \r\n\r\nAdd 2% of your Final attack power to your Final critical power.
73	/images/sc/onnatengu.jpg	4	HP: 775 at lvl0 / [lvl40 +4 number] at lvl40 +4. \r\n\r\nCritical: 210 at lvl0  / [lvl40 +4 number] at lvl40 +4.	Restriction: Light. \r\n \r\nIncrease Curse damage by +75.
74	/images/sc/afternoontrain.jpg	3	HP: 765 at lvl0 / 1350 at lvl30 / 1836 at lvl30 +3. \r\nAgility: 202 at lvl0 / 787 at lvl30 / 1070 at lvl30 +3.	Restriction: Light. \r\n\r\nCurse +20.
75	/images/sc/marineidol.jpg	3	HP: 510 at lvl0 / 800 at lvl30 / 1220 at lvl30 +3. \r\n\r\nAgility: 135 at lvl0 / 425 at lvl30 / 648 at lvl30 +3.	Restriction: Water. \r\nPoison +30 (120 at lvl30 +3).
76	/images/sc/secretdate.jpg	3	HP: 510 at lvl0 / 800 at lvl30 / 1220 at lvl30 +3. \r\nCritical: 135 at lvl0 / 425 at lvl30 / 648 at lvl30 +3.	Restriction: Grass. \r\n\r\nHP +200.
77	/images/sc/seriousworker.jpg	3	Attack: 260 at lvl0 / 550 at lvl30 / 838 at lvl30 +3. \r\nCritical: 135 at lvl0 / 425 at lvl30 / 648 at lvl30 +3.	Restriction: Dark. \r\n\r\nFinal Defense +200.
78	/images/sc/sweetpropose.jpg	3	HP: 510 at lvl0 / 800 at lvl30 / 1220 at lvl30 +3. \r\nAttack: 260 at lvl0 / 550 at lvl30 / 839 at lvl30 +3.	Restriction: None. \r\n\r\nBleed +20.
79	/images/sc/smallassailant.jpg	3	Attack: 260 at lvl0 / 550 at lvl30 / 838 at lvl30 +3. \r\nAgility: 135 at lvl0 / 425 at lvl30 / 648 at lvl30 +3.	Restriction: Attacker. \r\n\r\nFinal Attack +300 (600 at lvl30 +3).
80	/images/sc/scupgrade3.jpg	3	Increase + EXP by 28.	Restriction: None.
81	/images/sc/kokoro.jpg	3	Attack: 270 at lvl0 / [lvl30 +3 number] at lvl30 +3. \r\n\r\nDefense: 250 at lvl0 / [lvl30 +3 number] at lvl30 +3.	Restriction: none. \r\n\r\nIncrease Final critical by +100.
82	/images/sc/misaki.jpg	3	Defense: 260 at lvl0 / [lvl30 +3 number] at lvl30 +3. \r\n\r\nCritical: 145 at lvl0  / [lvl30 +3 number] at lvl30 +3.	Restriction: none. \r\n\r\nIncrease HoT received by +15.
\.


--
-- Data for Name: soulcards; Type: TABLE DATA; Schema: public; Owner: lucin
--

COPY public.soulcards (id, name, created_on, enabled) FROM stdin;
1	afternoon nap	2018-12-30	t
2	wisteria tree	2018-12-30	t
3	vacation	2018-12-30	t
4	ass baring devil	2018-12-30	t
5	believe	2018-12-30	t
6	hero of legends	2018-12-30	t
7	higgins daughters	2018-12-30	t
8	endo siblings	2018-12-30	t
9	hunting devil	2018-12-30	t
10	late night partner	2018-12-30	t
11	judgement day	2018-12-30	t
12	meat together	2018-12-30	t
13	piercing blue sky	2018-12-30	t
14	power of smile	2018-12-30	t
15	princess carry	2018-12-30	t
16	stf	2018-12-30	t
17	summer night	2018-12-30	t
18	throne	2018-12-30	t
19	training expert	2018-12-30	t
20	undersea date	2018-12-30	t
21	wandering doctor	2018-12-30	t
22	blade of hot sun	2018-12-30	t
23	seaside goddess	2018-12-30	t
24	beach relaxation	2018-12-30	t
25	azure girl	2018-12-30	t
59	extreme carnage	2019-02-28	t
60	lost dream	2019-02-28	t
58	stray lamb	2019-02-28	t
57	home-made chocolate	2019-02-28	t
26	dive	2018-12-30	t
27	sc booster 5	2018-12-30	t
28	sow	2018-12-30	t
29	feeling tremors	2018-12-30	t
30	crossed hearts	2018-12-30	t
31	7th runaway	2018-12-30	t
32	forbidden fruit	2018-12-30	t
33	iced americano	2018-12-30	t
34	tamaki	2018-12-30	t
35	ayane	2018-12-30	t
36	ganryu davi	2018-12-30	t
37	halloween diva	2018-12-30	t
38	under the rose	2018-12-30	t
39	show time!	2018-12-30	t
40	queen of the night	2018-12-30	t
41	inspiration	2018-12-30	t
42	starry stage	2018-12-30	t
44	i love sake!	2018-12-30	t
45	christmas gift	2018-12-30	t
46	racing suit	2018-12-30	t
47	tba2	2018-12-30	t
48	tba1	2018-12-30	t
49	cake aesthetics	2018-12-30	t
50	melty christmas	2018-12-30	t
51	dark town mistress	2018-12-30	t
52	dangerous gambler	2018-12-30	t
53	important present	2018-12-30	t
54	god have mercy	2018-12-30	t
55	treasure hunter	2018-12-30	t
56	go-home club	2018-12-30	t
61	baptism goddess	2018-12-30	t
62	castle of pleasure	2018-12-30	t
63	hero	2018-12-30	t
64	high jump	2018-12-30	t
65	strategist night	2018-12-30	t
66	good moa	2018-12-30	t
67	time over	2018-12-30	t
68	sc booster 4	2018-12-30	t
69	dream team	2018-12-30	t
70	luna	2018-12-30	t
71	in the clouds	2018-12-30	t
72	lacia	2018-12-30	t
73	nyotengu	2018-12-30	t
74	afternoon train	2018-12-30	t
75	marine idol	2018-12-30	t
76	secret date	2018-12-30	t
77	serious worker	2018-12-30	t
78	sweet propose	2018-12-30	t
79	small assailant	2018-12-30	t
80	sc booster 3	2018-12-30	t
81	kokoro	2018-12-30	t
82	misaki	2018-12-30	t
43	nobalmans new year	2018-12-30	t
\.


--
-- Name: soulcards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lucin
--

SELECT pg_catalog.setval('public.soulcards_id_seq', 93, true);


--
-- Data for Name: substats; Type: TABLE DATA; Schema: public; Owner: lucin
--

COPY public.substats (unit_id, leader, auto, tap, slide, drive, notes) FROM stdin;
14	+15% attack for Fire element allie	Deal 113 auto attack damage.	Prioritizing debuffer types, Deal 484 damage to target and apply "Bleed" (Deal 80 Damage over Time every 2 seconds) for 14 seconds.	Prioritizing enemies with "Bleed", Deal 829 damage to target and Deal 570 defense ignore damage 3 times (Additional 400 damage if enemy has "Bleed".	Deal 2484 damage to 4 enemies randomly and a 90% chance to apply itself "Awakening" (increase critical damage up to 30% and increase Slide skill damage by the amount of buffs you have) for 20 seconds.	
15	Increase HP recovery of all allies (instant or HoT) +10%.	Deal 96 auto attack damage.	Prioritizing allies with the lowest HP remaining, heal 314 to 2 allies.	For 8 seconds to 4 allies except herself, apply "Immortal" (HP cannot drop below 1 when being attacked). \r\nPrioritizing allies with least HP, HoT 231 (once every 2 seconds) to 2 allies for 12 seconds. 	Deal 1597 damage to 4 enemies randomly. \r\nPrioritizing allies with least HP remaining, apply "Debuff Clear" to 3 allies (Cancels after 14 seconds or 2 debuff attacks) and heals 1691 HP.	
26	Tap Skill Damage +5% to Dark Allies	Deals 113 Damages.	Deals 486 Damages, +100 ignore defense damage and +100 Additional damages if Debuff Type.	Deals 100 additional Damages + Tap damage 2 hits to 2 enemies (Prioritizing Debuff Types) and Apply Blind (20% chance to miss) for 6seconds.	Deals 2586 Damages to 4random enemies and 70% to apply Confuse to 2 random enemies (Confused Targets will attack their own allies and heals the enemy) for 6seconds.	
27	Tap skill damage +5% to grass units.	Deals 113 damage to target.	Deals 483 damage to target, if Water unit deal additional 150 damage.	Deals 100 damage and Tap skill 2 times to two random enemies, and Absorbs 20% of damage as HP.	Deals 2290 damage to all enemies.	
28	 +5% Slide Skill damage to light type allies	Deals 113 damage.	Deals 150 additional damage to target 3x times.	Deals 955 damage and 1000 Defense Ignore damage to 2 enemies with lowest HP.\r\nIf a barrier is applied, deals 1800 additional damage.	Deals 2539 damage to 4 enemies with lowest HP.	
8	Heal and Regeneration (Heal every 2seconds) amount +5% to Light units	Deals 95 damage.	Deals 330 damage to target, and removes freeze and petrification from 1 ally.	Gives 146HP Regeneration (Heal every 2seconds) for 20s to all allies.	Revives 1 dead ally to 1000HP and gives 300HP Regeneration (Heal every 2seconds) for 16s to 3 allies with lowest HP.	Maat + Leda combos are really strong, especially with Leda's leader skill. Maat is very useful in PVE and can be a real annoyance for the enemy in PVP.
7	Slide Skill defense +5% to Light units	Deals 92 damage.	Deals 319 damage to target and gains immunity to debuffs for 3s.	Deals 578 damage to target and gives +1400HP barrier and +35% Defense for 14s to 5 allies with lowest HP.	Deals 1480 damage to 2 random enemies and drive Skill defense +30% for 15s to all allies.	Dana is the best tank in the game in all modes, except WorldBoss where Maris (water tank) is better. Her shields + defense up helps to survive against raid drives. Running Dana with a single healer like Maat or Leda will give your team high survivability.
16	Drive skill damage +1000 to Dark Units	Deals 113 damage.	Deals 485 damage to enemy with lowest HP and critical rate +40% for 12s to self.	Deals 612 (135%) damage to 3 enemies with lowest HP.	Deals 2484 damage and Debuff Explosion (removes last applied debuff and damage enemy according to debuff) to all enemies.	A really good damage dealer and can self-crit boost. Although he may seem lackluster early, with higher unbinds he becomes probably the strongest attacker in the game. Passive skill on Drive can give nice added damage.
17	+5% to Tap damage for all allies. 	Deals 113 damage.	Deal 527 damage to target and additional 300 damage if target is Petrified or Frozen and 200 Ignore defense if target is Water type.	Deals 400 damages + Tap damage 3times to 1 enemy  (Prioritizing attacker Types) and absorb 200 damage as HP.	Deals 2329 damage to 3 enemies with lowest hp	The best attacker in her element and because she focuses single targets she is great in PVP. Useful in all content.
18	Drive skill damage +10% to Light units	Deals 112 damage.	Deals 477 damage to enemy with lowest HP with 150 additional damage if Dark type.	Deals 797 damage plus 350 additional damage and apply heal block (excludes Lifesteal and absorption) for 16s to 3 enemies with lowest HP.	Deals 2341 damage to all enemies and apply heal block (excludes Lifesteal and absorption) for 25s to 3 enemies with lowest HP.	A very good damage dealer and very useful in PVP against teams with healers.
24	Skill gauge charge rate -15% to all enemies.	Deals 100 damage.	Deals 375 damage and skill gauge charge rate -20% for 10s to target.	Deals 600 damage and 60% chance Silence (cannot use skills and gauge reset) for 5s to 2 random enemies.	Deals 1827 damage and skill gauge charge rate -45% for 22s and reduce skill gauge by 45% to 3 random enemies.	Wola is great for CC in PVP. His Leader skill is great helps you get to drive before enemy does. Even though his debuffs are not 100%, they are still high enough for him to be a very useful unit to use in PVP and PVE. His debuffs are useless in Raids and WorldBoss modes. Some SoulCards can counter his "Silence" debuff.
19	Attack +10% to Light Allies	Deals 113 damage.	Deals 477 damage to target and Additional 100 damage if target is Dark Type and 55% chance to Apply "Concentration" (100% Critital Rate and Hit Rate) to self for 13seconds.	Deals 927 damage and 800 ignore defense and Apply "Curse" (80 damages per 2seconds and additional damage when "Curse" ends) for 8seconds to 2 lowest HP enemies.	Deals 2327 damage to 4 lowest HP enemies and additional 500 damage if target is cursed.	A strong attacker in all content. Great against Dark Raids where her self-crit will allow you to have crit during fever - Damage monster.
29	Debuff evasion rate -15% to all dark enemies	Deals 101 damage.	Deals 391 damage and removes one buff to target.	Deals 610 damage to 2 enemies with highest attack and 75% chance Confuse for 10s to target with highest attack.	Deals 2017 damage, removes one buff and enemy drive gauge -10% to 3 enemies with the highest attack.	A very good unit that can steal buffs and cause enemies to attack themselves. Good in PVP and PVE, and sometimes useable in Raids and WorldBoss.
30	Tap Skill defense +5% to Water units.	Deals 92 damage.	Deals 314 damage to target and absorb 26% of the damage as HP.	Deals 573 damage to target and gives +1200HP barrier to all allies and 118HP Regeneration (Heal every 2seconds) to self for 14s.	Deals 1466 damage to 3 random enemies and drive Skill defense +20% for 15s to all allies.	Not as great as Dana in terms of shield and damage protection, but is the second best tank in the game and is the best tank in WorldBoss. She gives barrier to all allies, regardless of element.
34	+8% auto attack for fire element allies (Additional +8% On Raid Boss). 	Deal 100 auto damage. 	Deal 1253 damage to target. Prioritizing the ally with highest ATK, increase tap skill damage by +874 for 20 seconds and a 72.7% chance to cancel "Snow Bomb" to 2 allies.	Deal 1716 damage to target. Prioritizing the ally with least HP, Apply +1859 of "Barrier" (Shield consuming enemies attacks over HP) to 3 allies and Increase Attack +19% to 3 Fire Type allies with highest ATK for 16 seconds.  For Raid Boss Only, Increase Slide Skill +1280  for 16 seconds.	Deal 4327 damage to 2 enemies randomly. Prioritizing 5 ally with least HP, Apply +2000 of "Barrier" (Shield consuming enemies attacks over HP) for 20 seconds and Prioritizing 3 allies with least HP, HoT 264 for 18 seconds. 	
35	+12% attack for Water type allies	Deal 297 damage.	Deal 1568 damage and, if the target is poisoned, 189 additional damage.	Prioritizing the enemies with the highests attack power, deal 2077 damage to 3 enemies, gives 620 defense ignore damage, and if you do a critical hit, gives a 62% chance to apply "Stun" for 4 seconds (adds 1 second to max 5 seconds when attacking in a stunning state.	Deal 5363 damage to 3 enemies randomly, 700 additional damage or "Evasion" +40% to self for 20 seconds.	
37	Instant Heal +8% to grass Allies	Deals 96 damage.	Deals 337 damage to target and Instant Heal for 214 HP and Apply "Secret Healing" (Heals 200 damages when attack and receives attacks) for 2 turns to 2 lowest HP allies.	Deals 515 damage to target and Instant Heal for 1091 HP and 75% chance to remove "Heal Block" to 3 lowest HP allies.	Deals 1548 damage to 2 random enemies and Apply "Regeneration" (Heal 300 Hp per 2 seconds) and Apply "Secret Healing" (Heals 1200 damages when attack and receives attacks) for 16 seconds to 3 lowest HP allies.	
38	Slide Skill Damage +5% to Water Allies	Deals 113 Damages.	Deals 477 Damages to 1 enemy and +180 additional damages if target Tank Types.	Deals 70 additional damages +  Tap damages to 2 random enemies (prioritizing stunned enemies) and +100 ignore defense if target is stunned.	Deals 2130 Damages to all enmies and +500 additional damages to stunned enemies.	
39	+5% slide damage for Water element allies	Deal 112 auto attack damage.	Deals 476 damage to target with a 70% chance to prevent recovery (Except Vampirism and Absorbing) for 8 seconds.	Prioritizing enemies with buffs, deals 821 to 2 enemies, if the target is a Defender, apply 800 weakness damage for 20 seconds and apply "Stigma" (Continuous damage every 4 seconds [Buffs target number + 11x 50 continuous damage, maximum 6 buffs [Final Tick 7] ).	Deal 2212 damage to 4 random enemies and apply Debuff Explosion (remove 1 debuff and deal damage depending on the debuff type) if the target is debuffed.	
40	-15% attack for Fire type enemies	Deal 101 auto attack damage.	Deal 387 damage to target with a 60% chance to Apply "Freeze" (Skill Charge Speed, Drive Gauge Decrease and Bleeding debuff damage increase) for 8 seconds.	Deal 645 damage to 2 enemies with the highest attack. Skill Gauge Charge -20% and Apply "Water Balloon" (Deals 300 Damage when receives an attack, it last 10 seconds or 2 attacks. Cancel Skill Gauge) tor 14 seconds.	Proritizing healer types, Deal 1994 damage to 3 enemies with a 90% chance to Apply "Freeze" (Skill Charge Speed, Drive Gauge Decrease and Bleeding debuff damage increase) for 16 seconds.	
41	+10% skill charge rate for water element allies	Deal 100 auto attack damage.	Deal 380 damage to the target, priorizing an ally 2 with least HP, recover 280 HP 2 times, plus a 60% chance to puriy 2 bleeding allies (Convert Bleeding Into Recover).	Deal 660 to target. Prioritizing 2 alles with highest ATK, grants Skill gauge charge +35% and Increase ATK +1600 for 14 seconds, plus "Patience"\r\n(Grants +1 of "Endure" [lgnore all damage.] per debuff [Maximum 3] for 10 seconds).	Deal 1734 to 3 enemies ramdomly. Prioritizing 2 allies with least HP, grants 1230 instant HP recovery for 16 seconds, and prioritizing 2 allies with highest ATK, grants Skill gauge charge +30%.	
42	Attack +5% to all Allies (Additional +8% on Worldboss)	Deals 113 Damages.	Deals 486 Damages to 1 enemy and Apply Bleed (80 damages per 2seconds) for 10seconds. On Worldboss Only, +500 additional Damage.	Deals 930 Damges and +500 additional damages to 3 random enemies and +700 ignore defense if Bleed/Poison. On Worldboss Only, Apply "Sever" 3times (800 Additional damages if target is Bleeding/Poisoned).	Deals 2238 Damages to 4 random enemies and Apply "Sever" 1 time (1000 Damage if target is Bleeding/Poisoned).	
43	 +50 Bleed damage for Bleeds applied by allies. Additional +200 in Devil Rumble	Deal 100 damage.	Deal 370 damage, apply +20% crit damage to 2 allies with the highest attack for 8 seconds.	Deal 568 damage to 2 enemies (prioritizes Bleeding enemies) with 70% chance to apply "Wounded" (increase Bleed duration and effect), and apply +1200 attack to 5 Fire element allies for 18 seconds.	Deal 1670 damage to 3 targets (prioritizes "Wounded" enemies), apply Bleeding (120 damage) for 6 seconds, and charge +35% skill gauge to 2 allies with the highest attack.	
44	+800 max hp to all allies. Additional +800 in Ragna.	Deal 95 damage.	Deal 331 damage to target and heals 1 ally with the lowest hp for 318 HP.	Deal 507 damage to target and heal 3 allies with the lowest hp for 989 HP and 75% chance to apply "Purification" to 2 allies with the Bleeding status (convert Bleed damage to health).	Deal 1528 damage to 2 random enemies and heals 5 allies with the lowest hp for 1259 HP and 90% chance to apply "Purification" to 5 allies with the Bleeding status.	
45	Drive skill damage +10% to grass units.	Deals 111 damage.	Deals 140 damage plus Auto damage 4 times to target and gives "Lifesteal" (10% of damages dealt becomes heals) for 2 turns to self.	Deals 523 (120%) damage to 3 enemies (prioritizing Water types) .	Deals 2184 damage to 4 enemies with lowest HP.	
31	Drive skill damage +10% to Fire units	Deals 112 damage.	Deals 477 damage to enemy with lowest HP with 150 additional damage if grass type.	Deals 797 damage and Bleeding (100 damage every 2s) for 12s to 2 enemies with lowest HP with 120 additional damage if debuff type.	Deals 2317 damage to all enemies.	One of the best Fire attackers with good damage and bleed on slide. Good for eating through Syrinx buffs in PVP.
32	Defense -10% to all enemies	Deals 100 damage.	Deals 369 damage and Defense -5% for 6s to target.	Deals 588 damage and Bleeding (100 damage every 2s) for 14s to 2 enemies with lowest Defense.	Deals 1806 damage, removes one buff and Defense -25% for 20s to 3 random enemies.	A great debuffer in all content and has added bonus of doing bleed damage on slide. Jupiter > Freesia > Tiamat.
33	Attack -15% to Light enemies	Deals 101 damage.	Deals 387 damage and attack -700 for 10s to target.	Deals 608 damage plus 500 ignore Defense damage to 2 enemies with highest attack and enemy drive gauge -8%.	Deals 2012 damage to 3 enemies with the highest Defense, removes one buff and enemy drive gauge -10%.	Her special skills only worked on early raid bosses. Good for PVP and PVE.\n
46	Critical Rate +15% to all allies (Critical Damage +30% in Devil Rumble).	Deals 100 damage.	Deals 375 damage to target. \r\nGives +30% Critical Rate to self and 1 Attack Type ally for 10s.	Deals 856 damage to 2 random enemies. \r\nGives 35% Skill Gauge Charge to 3 Allies (Priotizing Dark Attacker Types) for 15s. \r\nGives +1200 Slide Skill Damage to 3 Allies (Priotizing Dark Attacker Types) for 15s.	Deals 2021 damage to 3 enemies (Prioritizing Light Types). \r\nApply "Blind" (60% chance to miss) to target for 25s. \r\nGives +30% Attack to 3 highest attack Allies for 25s.	
48	+8% skill damage defense for wood type allies.	Deal 228 damage.	Deal 1020 damage, increase 21.3% all skill damage defense (Cancels after 24 seconds or 3 attacks).	Deal 1442 damage, apply "Endure" to 4 allies except self (Cancels after 14 seconds or 2 attacks) and gives Silence resistance +22.7 for 14 seconds.	Deal 3480 damage to 2 enemies randomly, +40% of Defense Power to 5 allies and DoT Resistance +50% for 20 seconds.	
49	Weakness Defense -8% to Water Types enemies	Deals 101 Damages.	Deals 389 Damages and +160 additional damages if target Support Types.	Deals 669 Damges to 2 highest attack enemies, 60% chances to Apply Stun (target is unable to use skills and within 4sec any attack received increases Stun duration by 1sec to a max of 5secs) and -1200 attack for 12seconds.	Deals 1965 Damages to 3enemies (prioritizing Water Types) and -33% Skill Gauge Speed for 16seconds.	
50	-10% Debuff Evasion to all enemies.	Deal 261 damage.	Deal 1281 damage to 1 enemy with highest ATK stat, then reduces the ATK of the target by -16.4% for 10 seconds.	Deal 1575 dmg to 2 enemies with lowest HP, then 72.7% chance to inflict Death Heal (enemy receives dmg equal to the HP heal received, Vampirism/HP Absorb excluded) for 14 seconds, and reduces skill gauge by -39.1%.	Deal 4699 dmg to 3 targets, and apply Disintegration (500 damage every 2 seconds, debuffs inflicted will last shorter and cannot be extended) for 14 seconds.	
51	Heal and Regeneration (Heal every 2seconds) amount +5% to Fire units.	Deals 95 damage.	Deals 330 damage to target and gives instant heal +30% for 20s to 5 Fire units.	Heals 1776HP to 2 allies with lowest HP and 75% chance to remove all skill damage reduction type debuffs to 2 debuffed allies.	Gives 272HP Regeneration (Heal every 2seconds) for 18s to 3 allies with lowest HP, and heals an additional 319HP if the target is affected by a damage type debuff.	
52	Tap Skill Damage +5% to Light Allies	Deals 113 damage	Deals 505 damage to highest attack enemy. 65% chance to Apply "Direct Hit" (Ignore "Invincibility") to self for 13 seconds	Deals 830 damage to 3 highest attack enemies. Ignore 800 defense. ·Additional 800 damage IF target is "Confused" or have "Invincibility".	Deals 2339 damage to 4 highest attack enemies. 70% chance to Apply "Confuse" (Confused Targets will attack their own allies and heals the enemy) to target for 10 seconds. 90% chance to Apply "Direct Hit" (Ignore "Invincibility") to self for 18 seconds.	
53	Final drive skill damage for all enemies -25% (Additional, deduce DoT debuff damage -50% in Devil Rumble).	Deal 102 auto attack damage.	Prioritizing enemies with many buffs, deal 399 damage to target, reduce debuff evasion of enemy -10% for 20 seconds and reduce defense power -10% for 8 seconds.	Prioritizing enemies with the least HP, deal 702 damage to do 2 enemies, apply "Dancing blade" (Reduce defense power -20% and apply 200 DoT every 2 seconds) for 14 seconds and reduce Defense power -700.	Prioritizing enemies with many buffs, deal 2089 to 3 enemies and apply "Stigma" (Continuous damage every 4 seconds [Buffs target number +1] x 250 continuous damage, maximum 6 buffs [Final tick 7]) for 20 seconds.	
54	+10% increase WeakPoint skill damage for dark type allies (Additional +10% in Raid Boss).	Deal 113 auto attack damage.	Deal 481 to target and if the target is a Light type, deal 250 additional damage.	Prioritizing supporter enemies, deal 958 damage to 3 enemies, gives 800 defense ignore damage, and if the target is a Light type, deal 600 additional damage.	Deal 2598 damage to 4 enemies and increase self WeakPoint skill damage +50% for 20 seconds.	
55	-15% debuff evasion for grass enemies.	Deal 102 auto attack damage.	Prioritizing enemies with "Endure" buff, deal 394 to 2 enemies and a 75% chance to cancel(remove) "Endure" buff.	Prioritizing debuffer enemies, deal 674 to 2 enemies, a 60% chance to apply "Stun" (Adds 1 second to max 5 second when attack in a stunning state) for 4 seconds, -800 Agility for 12 seconds. 	Deal 2029 to 3 enemies randomly. For 2 turns, add +2 seconds on enemy slide skill cooldown, and reduce enemy drive gauge -12%.	
57	+15% increase attack power for dark type allies.	Deal 113 auto attack damage.	Deal 485 damage to target. \r\nIncrease own critical chance to +45% for 12 seconds.	Prioritizing Light type enemies, deal 904 damage to target, gives 470 Defense Ignore damage 3 times, and if the target is a light type, deal 400 additional damage. 	Prioritizing enemies with the least HP remaining, deal 2485 damage to 4 enemies.	
58	+8% Final slide skill damage for Wood element allies. 	Deal 113 auto damage. 	Deal 3 tap skills plus 250 damage to the target and absorb 220 of damage as HP. 	Prioritizing the enemies with least HP, Deal 2206 damage to 2 enemies, gives 945 defense ignore damage and apply 220 damage per buff (up to 8 applications). 	Deal 5544 damage to 4 enemies randomly and apply "Snow Bomb" to a enemy randomly (After 10 seconds, deal 1500 damage and reset skill gauge)	
78	Defense -15% to Water Types Enemies.	Deals 101 damage.	Deals 390 damage to highest attack enemy. \r\nReduce -350 Defense to target.	Deals 619 damage to 2 lowest HP enemies. \r\nApply "Anti-Barrier" (Removes "Barrier" and 70% of the remaning barrier is dealt as damage) to target. \r\nApply "Invincibility Explosion" (Removes up to 2stacks of "Invincibility" and if 3 or more stacks was removed, deals 500 damage per stacks) to target.	Deals 1916 to 3 enemies (Prioritizing enemies with "Invincibility" buff). \r\nApply "Invincibility Explosion" (Removes up to 2stacks of "Invincibility" and if 3 or more stacks was removed, deals 1500 damage per stacks) to target.	
56	Max HP +800 for all Allies (in raids +600 added)	Deal 99 damage to target	Deal 370 damage, grant Barrier (absorbs +400 damage before HP is affected) on 1 random Ally for 8 seconds	Deal 555 Damage to 2 random Enemies and 300 of Ignore DEF Damage, Ally Drive Gauge +100	Deal 1751 Damage to 2 random Enemies, Regen 80 HP (once per 2 seconds) for 2 Allies (Lowest HP) for 26 seconds and Drive Gauge + 10% for allies	Aria is an important child for helping you to reach 4th fever in world boss
61	+8% increase skill gauge speed for all allies (Additional in Raid Boss, Increase instant heal +10%).	Deal 101 auto attack damage.	Deal 387 damage to target. \r\nPrioritizing allies with least HP remaining, Heal +30% of HP to 2 allies for 20 seconds. \r\nFor Raid Boss only, delete target stacking buff (Attack/ defense power) 5 times ONLY.	Deal 676 damage to target. \r\nPrioritizing 2 allies with least HP remaining, increase skill gauge speed +30% and heal 1251 HP for 16 seconds. \r\nFor Raid Boss only, prioritizing an ally with the most attack power, get a 30% chance to apply "Double-Edge Sword" (Increase attack power and reduce defense) for 16 seconds.\r\n	Deal 1816 damage to 3 enemies randomly. \r\nApply "Life Bind" up to 5 allies (Convert 50% of the damage received into healing, the rest of the HP buff is spread to 2 allies with the least HP) for 20 seconds. 	
62	-15% Defense against Dark type enemies (Additional -10% WeakPoint defense in WorldBoss).	Deal 102 auto attack damage.	Deal 394 to target and apply -400 Tap Defense for 8 seconds. For WorldBoss only - get a 75% chance to cancel "Rage" buff to enemy.	Deal 675 damage to 2 enemies randomly, gives 600 defense ignore damage and apply -500 enemy slide skill defense for 12 seconds. For WoldBoss only - apply -500 defense for all enemy skills for 12 seconds.	Deal 2030 damage to 3 enemies randomly, apply -20% debuff evasion and -20% defense for all enemy skills for 16 seconds.	
63	Skill Gauge Charge +8% to grass Allies	Deals 99 damage.	Deals 368 damage to target and gives +150 skill gauge to 2 grass Attacker.	Deals 578 damage to target and gives +30% skill gauge charge and debuff duration -20% (excluding petrification) for 15seconds to 3 grass allies.	Deals 1673 damage to 3 random enemies and 70% chance to apply Stun for 14seconds (target is unable to use skills and any attack received increases Stun duration by 1sec to a max of 5secs) and gives "LifeSteal" (25% of damage dealt restores HP) to 3 lowest HP allies. Buff is Stackable.	
64	Tap Skill Damage +5% to Water Allies	Deals 113 Damages.	Deals 140 Damages 3 times and Apply "Poison" (Deals 100 damages when attack and receives attacks) for 2 turns.	Deals 883 damages and +500 ignore defense to 3 Lowest HP enemies.\r\n66% chance to Apply "Overload" (+30% all skills damages except "Drives skills" and Skill Cooldown Increased + Skill Charge Rate Descreased) to self for 23 seconds.	Deals 2496 damages and Apply "Outbreak" (remove first applied debuff and damage target according to debuff duration) to 4 Lowest HP enemies.	
65	Tap Skill defense +5% to Fire units	Deals 91 damage.	Deals 313 damage to target and gains +600 barrier for 4s and Fury (saves up to 300% damage received and returns 1 time).	Deals 517 damage to 2 random enemies and gains Reflect (returns 15% of damage received) and Taunt (88% provocation) for 10s.	Deals 1409 damage to 2 random enemies and gives a +15%HP barrier for 20s to 3 units with lowest HP, including self (if own HP is the lowest, barrier will only be applied to 2 targets).	
66	Slide skill damage +5% to Water allies.	Deals 91 Damage.	Deals 305 Damage, Gives +500 barrier to 5 Water allies for 8 seconds.	Deals 547 Damage, Gives Taunt (88% provocation) for 24 seconds and Reflect (24% damage returned to enemy) for 24sec or 2 or 7 hits (random number of hits applied).	Deals 1436 Damage to 2 random enemies, Gives Reflect (24% damaged returned to enemy) for 16seconds or 2 hits to 9 allies prioritizing the front row.	
67	Defense +8% to grass units	Deals 99 damage	Deals 363 damages to target and Gives +20% Defense and +15% Debuff Evasion to 2 lowest HP allies for 10secs.	Gives +1800 Barrier and Apply "Lifesteal" (15% of damage dealt restores HP) for 22seconds to 3 lowest HP allies.	Deals 1703 damage to 2 random enemies and Defense +35% and +2000HP barrier for 25s to 3 allies with lowest HP	
68	Slide Skills Damage +8% to Fire Allies	Deals 113 damage.	Deals 50 damage 3times to target.	Deals 1205 damage to 2 highest attack enemies and 700 ignore defense additional 500 damage to target with "Regeneration" buff and 35% chance to Apply "Double-Edge"(Increase Attack and Decrease Defense) to self for 23seconds.	Deals 1488 damage to all enemies and Apply "Bleed"(250 damage per 2seconds) to 2 lowest HP enemies for 12seconds.	
69	  +8% slide damage to fire element allies	Deal 113 damage.	Deal 485 damage, apply Bleed (100 damage) for 8 seconds, and apply +35% crit rate to self for 12 seconds.	Deal 902 damage to 3 random enemies, plus 550 defense ignoring damage per hit, plus 650 additional damage if target is Bleeding.	Deal 2480 damage to 4 enemies with the lowest HP.	
70	Drive skill damage +1000 to Water units	Deals 111 damage.	Deals 95 damage plus Auto damage 4 times to target.	Deals 733 damage and Poison (deals 300 damage when enemy attacks and receives attacks) for 4 turns to 2 enemies with highest attack with 175 additional damage if Fire type.	Deals 2151 damage to 4 enemies with lowest HP.	
71	+8% slide skill damage for Light type allies	Deal 113 auto attack damage.	Deal 486 damage and has a 65% chance to apply "Long-Range Attack" (ignore Taunt and Reflect) to self for 13 seconds. In Underground, 430 additional damage to target.	Attack 2 enemies twice each (prioritizing Dark type), dealing 755 damage. If the target is a Debuff type, deal 150 additional damage and if the target is a Dark type, deal 200 additional piecing damage.	Deal 2588 damage to all enemies.	
73	+8% defense for all allies (additional +12% on WorldBoss)	Deal 100 auto attack damage.	Deal 382 damage and a 70% chance to cancel 2 debuffs ("Burn" and "Scalp").	Deal 660 damage and a 50% to apply "Double-Edge Sword" (Increase attack, but decrease defense) to 5 water allies for 16 seconds. For WorldBoss Only, Slide Skill Damage +1250 for 16 seconds.	Deal 1733 damage to 2 enemies randomly and allies drive gauge +400. For WorldBoss Only, Attack power +30% for 20 seconds.	
74	Skill gauge charge rate -18% to Water enemies.	Deals 101 damage to target.	Deals 385 damage to target, if grass unit deal additional 150 damage.	Deals 672 damage to 2 random enemies, 70% chance to freeze (reduces skill gauge charge rate and charge amount) for 10s.	Deals 1875 damage to 2 random enemies, 90% chance to freeze (reduces skill gauge charge rate and charge amount) for 16s.	
75	Weakness Defense -8% to all enemies.	Deals 101 damage.	Deals 379 damage to target and -10% weakness Defense for 8s.	Deals 599 damages and 450 ignore defense and -10% weakness Defense for 14s to 2 enemies (prioritizing Water Types).	Deals 1836 damage and Apply "Poison" (620 damages when attack and receives attacks) for 2 turns and removes 1 buff to 3 lowest HP enemies.	
76	Drive skill damage +1000 to Light units. 	Deals 111 damage. 	Deals Auto damage + Additional 135 damage 4 times to target. \r\nApply "Blind" (-20% Accuracy) to target for 6 seconds.	Deals 761 damage to 3 highest attack enemies. \r\nApply "Blind" (-30% Accuracy) to target for 12 seconds.	Deals 2161 damage to 4 enemies with highest attack.	
77	·Tap Damage +8% to grass Types Allies (Additional +10% In Ragna)	·Deals 113 damage	Deals 491 damage. \r\nIn Ragna, Give +1000 Weakness Skill Final Damage to self for 16seconds	Deals 958 damage to 3 random enemies. \r\nApply "Absorption" (Heal 200 HP per hit). \r\nAdditional 1000 damage IF Water Type target.	Deals 2498 damage to 4 random enemies. \r\nAdditional 700 damage IF Water Type target. \r\nIn Ragna, Ignore 4000 Defense IF Water Type target.	
79	Drive skill damage +1000 to all grass type allies. (bonus +1000 drive damage to all allies on Ragnas)	Deals 112 damage.	Deals 120 damage plus Auto damage 4 times to target.	Deals 771 damages to 3 random enemies and Absorb 350 damage as HP.	Deals 2237 damages to 4 lowest HP enemies and Gives +50% Skill Gauge Charge for 2 turn to self.	
80	Slide skill damage +4% to Dark units	Deals 111 damage.	Deals 120 damage plus Auto damage 4 times to target.	Deals 528 (120%) damage to 3 random enemies.	Deals 2992 (250%) damage to target and Bleeding (200 damage every 2s) for 12s to 4 random enemies.	
81	+8% Tap Skill Damage to Light Allies | Additional +8% in Ragna.	Deal 302 damage.	Deal 1604 (109.4%) damage & +350 Ignore Defense Damage if enemy is Dark Attribute.	Deal Tap Skill Damage 2 times, plus 200 additional damage to 2 enemies prioritizing Debuffer type (+660 Additional damage if during Ragna and if enemy is Dark Attribute).	Deal 10870 (250%) damage to 2 enemies & apply "Curse" (300 damage every 2 seconds) for 8 seconds.	
82	+10% Debuff Evasion for Light Allies | Additional +10% in Ragna.	Deal 256 damage.	Deal 1245 Damage & 72.7% chance to remove "Death Heal" debuff from 2 allies.	Deal 1709 damage to 1 enemy + increase ATK by +1680 & Slide Skill Damage by +1280 for 3 Light Allies (Prioritizing Highest ATK) for 16 seconds | Additionally increase Skill Gauge +23.4% for 2 Light Allies in Ragna.	Deal 4332 damage to 3 enemies & +40% ATK + "Silence Immunity" for 10 seconds to 2 Allies (Prioritizing highest ATK).	
84	-10% duration of debuffs (Except "Wither") (Additional -10% in Devil Rumble).	Deal 256 damage.	Deal 1242 damage to target and a 72% change to apply "Target" (Concentrate attacks on one target) for 12 seconds.	Deal 1709 damage to target, prioritizing 2 allies with less HP, Heal over Time +144 and a 77% chance to Cancel any DoT of 2 allies for 16 seconds.	Deal 3307 damage to 3 enemies randomly, prioritizing 3 allies with less HP apply Skill Damage Protection +30% (Cancels after 32 seconds or 4 attacks) and apply "Immortal" (HP cannot be reduce to 1 or less) or 14 seconds.	
85	+1500 max HP for all allies (Additional +2000 in Devil Rumble)	Deal 226 damage.	Deal 1003 damage to target, a 72.7% chance to apply "Debuff Provocation" on self (You steal one ally debuff) for 20 seconds. Reduce debuff duration -26% (Except "Wither", "Water Balloon", and "Petrify") for 20 seconds.	Deal 1386 damage to target, increase Defense Power +42.2% and apply "Taunt" (With 90% of the chance) for 12 seconds.	Deal 3426 damage to 2 enemies randomly, prioritizing 3 allies with less HP (Including self) apply "Reflect" (Return 30% of the damage receive) for 20 seconds (If you receive "Reflect" buff, it will be applies to 2 allies).	
87	+10% Defense for Fire allies (Additional +10% in Underground).	Deal 92 attack damage.	Prioritizing enemies with "Barrier", deal 320 damage to target and give "Anti-Barrier" (Cancel Barrier and do 50% damage of the remaining barrier).	Deal 525 damage to 2 targets randomly. Prioritizing 4 fire type allies, apply "Pain Adapt" (Increase defense +600, defense increase in proportion to HP loss [4% increase in defense per 2% decrease in HP - maximum increase to 80%] for 14 seconds. \r\nPlus apply "Damage Reflect" (Return 20% of received damage for 14 seconds or 3 attacks). For Underground Only, recover sustained 118HP (Once every 2 seconds) for 14 seconds.	Deal 1443 damage to 2 targets randomly. Prioritizing 5 Fire allies, increase defense +1200 and gives +1500 barrier (Shield consumes enemy attacks over HP) for 20 seconds. \r\nFor Underground Only, apply "Painful Sublimation" (Increase attack +200, attack increases in proportion to HP loss [36% increase in attack per 2% decrease in HP - maximum increase to 720%])	
88	+15% Critical for Fire allies (Additional +25% on Devil Rumble).	Deal 241 damage.	Deals 1111 damage and, prioritizing an ally with least HP, gives 752 HP.	Prioritizing the allies with least HP, HoT 220 to 3 allies and if you do a critical hit, adds +38.4% skill gauge for 14 seconds.	Deal 3872 damage to 2 enemies randomly, prioritizing the allies with least HP, HoT 313 to 5 allies for 16 seconds and increase Critical attack +2000 for 20 seconds .	
89	+10% weak Point final damage for grass Types (Additional +10% on Raid Boss)	Deal 100 auto attack damage.	Deal 381 damage to target. Prioritizing allies with lowest HP. Heal 104 to 2 allies (Every 2 Seconds) for 8 seconds, and a chance of 70% to Cancel "Water Balloon" debuff.	Deal 662 damage to target. Apply +25% Defense to 3 grass type allies with highest attack power. +10% WeakPoint Skill Damage and a 70% chance to Cancel "Frozen" debuff for 16 seconds.	Deal 1763 damage to 3 random enemies. Prioritizing 2 allies with highest attack power, increase attack power +30% and Normal Skill Damage +800 for 20 seconds.	
91	-15% skill charge speed for all enemies.	Deal 101 auto attack damage.	Deal 392 damage and -350 defense to target for 8 second.	Deal 673 damage to 2 enemies (Prioritizing the highest defense enemies) and apply "Scald" (Skill Damage Defense -5%) and "Burn" [100 sustained dmg every 2 seconds. \r\nIt last 8 seconds][Scald effect will be reapplied when you receive an attack other than Fever Time if "Burn" is happening]) for 12 seconds.	Deal 2026 damage to 3 enemies randomly and apply "Blade Dancer" (Defense Power -20% and 300 sustained damage every 2 seconds) for 16 seconds.	
92	+12% attack for Grass type allies.	Deal 113 attack damage.	Deal 482 damage to target. Apply "Lifesteal" on herself (Recovers 15% of the HP on attack) for 20 seconds.	Pyritizing Water Type enemies, deal 852 damage to 3 enemies. If the enemy is Water Type, add 800 piercing damaging and apply "Stigma" to 2 enemies at random: (Continuous damage every 2 seconds [Buffs target number +1] x50 continuous damage, maximum 6 buffs [Final tick 7]) for 20 seconds.	Deal 2227 damage to 4 enemies randomly, if the enemy has "Stigma", deal 500 additional damage.	
93	+8% Slide skill damage for all Fire allies.	Deal 113 auto attack damage.	Deal 486 damage to target. For WorldBoss Only apply "Fire Prison" (additional 1500 damage in proportion to the number of Fire type allies, maximum 10 childs).	Prioritizing Wood type enemies, deal 942 damage to 3 enemies plus 850 piercing damage. If the enemy is Wood Type, add 600 additional damage.	Deal 2386 damage to target.	
94	+10% skill gauge increase for Fire type allies. (Increase WeakPoint damage + 10% in WorldBoss)	deal 100 auto attack damage.	Deal 382 damage to target, increase Skill Gauge for two Fire type Attacker allies +15%.	Deal 660 damage to target. Increase Skill Gauge +35% to 3 highest attack power Fire type allies for 16 seconds and increase Slide skill damage +1100. For WorldBoss Only, prioritizing highest attack power fire type allies, increase WeakPoint damage +10%.	Deal 1733 damage to 3 enemies randomly. Prioritizing the allies with the least HP, heal 1525 up to 5 allies. For WorldBoss only, increase Normal skill damage for the back row +1500 for 20seconds.	
96	Tap Skill defense +5% to Light units	Deals 91 damage.	Deals 297 damage to target and Skill defense +18% for (24s or 3 hits) and Taunt (88% provocation) for 10s to self.	Deals 487 damage to 2 random enemy and gains Immortality (HP will not go under 1) and Fury (saves up to 350% damage and returns.	Deals 1397 damage to 2 random enemies and Skill defense +25% for 20s to 5 Light units.	
97	Tap damage +5% to Fire units	Deals 112 damage.	Deals 475 damage to target with 150 additional damage if enemy is buffed.	Deals 100 damage plus Tap damage (including bonus damage effect on Tap skill) 2 times to 2 random enemies.	Deals 2355 damage to 3 enemies with lowest HP.	
109	Attack +10% to Fire allies.	Deals 99 damage.	Deals 363 damage and gives +10% attack for 8s to 1 random ally.	Deals 552 damage to 2 random enemies and gives +800 attack and Tap skill attack +100 for 18s to 3 allies with highest attack.	Deals 1696 damage to 3 random enemies and gives +30% attack and Slide skill attack +300 for 25s to 3 allies with highest attack.	
110	Grass enemy skill gauge charge -15%.	Deal 101 auto damage.	Inflict 392 dmg, 65% chance to reset enemy gauge & for 8s, 70% chance to inflict Heal Block.	Target priority 2 highest attackers, inflict 672dmg and for 12s, 70% to erase speed buff; slow skill gauge by 40% and -35% skill guage.	Target 3 random targets, inflict 2025, 80% to reset enemy guage amd for 16s skill gauge charge -45%.	
111	Attack +10% to Water Allies (Additional +8% on Worldboss)	Deals 113 damage.	Deals 530 damage to target and Additional 350 damage IF target is Debuff Type.	Deals 400 damage + Tap Damage 3times to 1 enemy(Prioritizing Debuff Type) and 500 ignore defense IF target is "Poisoned". On WorldBoss Only, Apply "Tsunami" (Additional 700 Damage depending on the number of Water Allies in the party up to 10times).	Deals 2589 damage to 3 lowest HP enemies.	
112	Tap Skill defense +5% to grass units	Deals 91 damage.	Deals 306 damage to target and Apply "Lifesteal" (10% of damage dealt restores HP) and "Poison" damage reduction -25% to 2 lowest HP allies.	Deals 545 damage to target and gives Skill Defense +10% (for 32seconds or 4hits) and "Poison damage reduction -35% for 15seconds to 3allies (prioritizing grass allies).	Deals 1419 damage to 2 random enemies and gives "Lifesteal" (20% of damage dealt restores HP (Doubled if grass allies)) to all allies.	
113	+8% Skill Gauge Charge to all Allies	Deal 99 auto attack damage.	Heal 330 HP twice to the ally with the lowest remaining HP.	Deal 578 damage to the target, Heal +700 HP, apply "Regeneration" (79 HP heal every 2 seconds) for 14 seconds and 70% chance to apply "Detoxification" (Cleanse poison and heal 1 tick worth of poison damage) to 2 allies with the lowest remaining HP.	Heal 1224 HP to all allies and 90% chance to apply "Detoxification" (Cleanse poison and heal 1 tick worth of poison damage) to 3 poisoned allies.	
114	  +5% slide damage to Dark allies	Deal 113 damage.	Attack 2 targets twice each, dealing auto-attack damage plus 40 additional damage per hit (prioritizes enemies with buff effects).	Deal 1329 damage to all enemies, plus 500 defense ignoring damage, with a 70% chance to apply Chaser (upon killing an enemy, deal 1500 additional fixed damage to 1 random remaining enemy) to self for 14 seconds.	Deal 2285 damage to all enemies and apply Resurrect to self for 10 seconds (upon dying, revive with 50% HP, fully charge skill gauge, and Attack Up (stacks up to 5 times)).	
115	 +10% weakness damage for water allies. Additional 20% in Ragna.	Deal 100 damage.	Deal 385 damage, apply +250 tap damage to 1 water element ally with the highest attack for 8 seconds.	Deal 660 damage, apply +1500 attack for 14 seconds and +30% skill charge rate for 16 seconds to 3 water allies with the highest attack.	Deal 1982 damage to 3 random enemies and apply +25% weakness damage to 3 allies with the highest attack. Additional 40% in Ragna.	
116	  +8% tap damage for water allies. Additional +8% in Ragna.	Deals 99 damage.	Deal 368 damage to target and grant +30% heal/regen rate to 3 water allies for 10 seconds.	Deal 604 damage to target and apply +1200 attack to 3 allies with the highest attack for 16 seconds and 70% chance to grant "Cheer" to 5 water allies for 14 seconds (+15% weakness skill damage and increase attack based on number of buffs).	Deal 1715 damage to 2 random enemies and apply +50% drive damage to 5 water allies for 33 seconds and +300 to ally drive gauge.	
100	Critical rate +15% to Dark units	Deals 99 damage.	Deals 364 damage to target and critical rate +35% for 7s to 1 random ally.	Critical rate +40% and critical damage +30% for 18s to 2 allies with highest attack.	Deals 1705 damage to 2 random enemies, critical damage +50% and critical rate +70% for 22s to 2 allies with highest attack.	Can be used in all content, but is better in Raids and Worldboss events.
102	Heal and Regeneration (Heal every 2seconds) amount +5% to Water units.	Deals 96 damage.	Heals 233HP to 2 allies with lowest HP.	Gives 1.8%HP+21HP Regeneration (Heal every 2seconds) for 8s and Immortality (HP will not go under 1) for 10s to 2 allies with lowest HP.	Heals 12%HP+90HP and gives Immortality (HP will not go under 1) for 14s to 3 allies with lowest HP.	Her immortality can be a lifesaver sometimes, but her overall healing is not very strong.
107	Maximum hp +1000 to all Light Allies (+3000 additional hp on Worldboss)	Deals 100 Damages.	Deals 380 Damages to 1 enemy. On Worldboss Only, removes 5 Attack and Defense stacks.	Deals 656 Damages to 1 enemy and Apply +1600 Attack to 9 allies (prioritizing Lights). On Worldboss Only, Apply -2 Cooldown for 2 Turns and +1000 Slide Skill Damage for 20seconds to 5highest attack Allies (prioritizing back row).	Deals 1745 Damages to 2 random enemies and Apply +2000 barrier to 9 allies lowest HP (Prioritizing front row) and +1500 Tap Skill Damage to 9 highest attacks Allies (Prioritizing back row).	Attack buffer and specifically made for WB but can do just as well in other modes.
108	Debuff resist +15% from Light Types Enemies.	Deals 101 damage.	·Deals 390 damage to target. \r\n·Reduce 12% Attack to target for 10s.	Deals 619 to 2 random enemies. \r\nApply "Taunt" (20% Provocation) to self for 12s. Apply "Counter Petrification" (70% chance to apply "Petrify" (unable to act for 10seconds or after being hit 1 time) enemies that attack Medusa) to self for 12s.	Deal 4837 damage to 3 enemies plus 500 additional damage to "Petrified" targets and 90% change to "Petrify" (unable to act for 15 seconds or after being hit 2 times) to targets.	Can be useful for PVP.
120	Attack -15% to Dark Type Enemies	Deals 101 damage.	Deals 386 damage and Reduce -700 Attack for 8 seconds and 60% chance to increase "Curse" damage and duration for 8 seconds to target.	Deals 604 damage and 500ignore defense to 2 highest attack enemies and Apply "Blind" (40% chance to miss) for 12seconds.	Dreals 1910 damage to 3 random enemies and Apply "Blind" (60% chance to miss) for 14seconds and if they are inflicted with "Bleed", "Poison", "Curse" within 6seconds debuff duration is increased by +50% to 3random enemies.	
121	+12% Defense for dark type allies.	Deal 92 auto attack damage.	Deal 315 to target and apply "Reflect" on self (returns 15% of received damage) for 10 seconds.	Deals 563 to target, Apply "Rage" on self (Stores up to 250% damage and adds it to the next skill) and apply "Taunt" (with a 90% chance to activate) for 12 seconds.	Deal 1469 damage to 2 enemies randomly, apply +30% defense for all enemy skills for 20 seconds and apply "Taunt" (with a 98% chance to activate for 16 seconds.	
122	Tap Skill defense +5% to Dark units	Deals 91 damage	Deals 301 damage to target and gives +850 Defense and +600 barrier for 10s to 1 ally with lowest HP	Deals 540 damage and gives Reflect (12% of received damage) to 3 allies with lowest HP with priorities to Dark types for 15s and +12% Defense (for 24s or 3 hits) to 2 allies with priorities to Dark types.	Deals 1405 damage to 2 random enemies and gives Reflect (returns 25% of damage received) for 20s to 2 allies with the lowest HP, including self (if own HP is the lowest, it will only be applied to self, no second target).	
123	Gives Reflect (returns 3% of damage received) to Dark units (bonus +3% on Ragnas)	Deals 90 damage.	Deals 294 damage to target and Defense +900 to self and gains Taunt (85% provocation) for 11s.	Deals 539 damage to target, gives Reflect (returns 13% of damage received) to self and gives Defense +850 to 3 units with priority to Dark Units (including self).	Deals 1386 damage to 2 random enemies and gives Reflect (returns 20% of damage received) for 18s to 5 allies.	
124	Skill Gauge Charge +8% to Light Types Allies (Additional +8% on Worldboss)	Deals 100 damage.	Deals 382 damage to target. \r\n70% chance to remove "Petrify" from 2 "Petrified" allies.	Deals 660 damage to target. \r\nGive Skill Gauge Charge +30% to 3 random allies for 16s. \r\nOn WorldBoss, Apply "Sharp Blade" (Weakness skill damage +3% multiplied by the amount of buffed allies up to 7) to 7 light allies for 16s.	Deals 1733 damage to 2 random enemies. \r\nFor 22s, all allies are immune to "Petrify". \r\nGives Skill Damage +25% to 5 light allies for 22s. \r\nOn Worldboss, Give +30% attack to the back row for 22s.	
125	Weakness Skill Final Damage -8% to Light Types enemies	Deal 96 auto attack damage	Deals 335 damage to target and Reduce -40% heals of "Instant Heal" and "Regeneration" to 2 random enemies for 12 seconds	Deal 511 to 2 enemies (prioritizing enemies with debuffs) and Give "Regeneration" (Heal 171 HP per 2 seconds) to 2 lowest HP allies and Apply "Divine Justice" (On Ally, Instant Heal 150 HP multiplied by the number of buffs +1 up to 4 buffs (Total 5[4+1] ) to 2 allies [prioritizing allies with buffs]). (On Enemy, Deals 200 damage multiplied by the number of debuffs +1 up to 4 debuffs (Total 5[4+1]) to 2 enemies [prioritizing enemies with debuffs]) for 14 seconds	Deal 1537 damage to 2 random enemies and Apply "Divine Justice" (On Ally, "Instant Heal" 350 HP multiplied by the number of buffs +1 up to 4 buffs (Total 5[4+1]) to 3 lowest HP allies). (On Enemy, Deal 400 damage multiplied by the number of debuffs +1 up to 4 debuffs (Total 5[4+1]) to 3 lowest HP enemies).	
128	Attack +10% to Dark Allies (Additional +5% in Ragna)	Deals 253 damage.	Deals 376 damage to target and Give +12% Attack to highest attack ally and 70% chance to remove "Curse" from 1 ally.	Deals 650 damage to 2 random enemies and Gives +1200 Attack and 70% chance to "Awaken"(+30% Critical Damage and Slide Skill damage (increase by the number of buffs)) to 3 Dark Type Allies for 16seconds.	Deals 1751 damage to 3 random enemies and Give +30% Attack and +50% Critical Rate to 3 Allies (Prioritizing Dark Types).	She's ok in raids.
162	Agility +400 to Light units	Deals 81 damage.	Deals 300 damage to enemy with lowest HP with 100 additional damage if Dark type.	Deals 90 damage plus Tap damage 3 times to 1 enemy with priority to Dark units and gains Reflect (returns 7% of damage received) for 15s.	Deals 1324 damage to 4 random enemies, 90% chance to apply heal block (Excludes Lifesteal and HP absorption) for 10s.	
164	Maximum Health +800 to Light units.	Deals 68 damage.	Deals 206 damage to target and gains Fury (saves up to 250% damage received and returns 1 time).	Deals 388 damage to target and drive Skill defense +15% to all allies and gains Taunt (84% provocation) for 10s.	Deals 797 damage to 2 random enemies and Skill defense +20% from 3 enemies for 16s to 3 allies with lowest HP.	
117	Tap Skill defense +5% to Fire units	Deals 92 damage.	Deals 326 damage to target and gives +500HP barrier for 8s to 5 Fire units.	Deals 572 damage to target and gives 50% Double-Edge (increase attack and reduce Defense) for 16s to 5 Fire units.	Deals 1474 damage to 2 random enemies and drive Skill defense +30% for 15s to 5 allies.	A very good unit for Fire Raids and ok in WorldBoss, but she loses usefulness when teams or the attackers are not Fire.
119	Tap Skill defense +5% to grass units.	Deals 91 damage	Deals 311 damage to target and Gives +25% defense for 15s to self.	Deals 564 damage to target and Gives Skill defense +20% to self and Taunt (90% provocation) for 12s.	Deals 1456 damage to 2 random enemies and drive Skill defense +30% for 15s to 5 allies.	Pull him, lock him, then forget him, but do not diss him.
127	Drive Gauge Charge -5% to all enemies (Additional 8% on Worldboss).	Deals 101 damage	Deals 381 damage to target and Apply "Poison" (Deals 200 damages when attack and receives attacks).\r\nWithin 8s debuff effect on 2 enemies will have it's duration extended by 30% (from current remaining duration).	Deals 617 damage to 2 random enemies and 70% chance to remove 1 buff from the target (last applied buff).\r\nApply "Debuff Explosion" (removes first applied debuff and deals damage according to the debuff type x200 modifier).	Deals 1983 damages to 3 random enemies and Apply "Poison" (Deals 800 damages when attack and receives attacks) for 3turns.	Similar to Nirrti, but more offensive than defensive in terms of skills.
146	Attack -10% to all enemies.	Deals 74 damage.	Deals 240 damage and critical -25% for 9s to target.	Deals 441 damage, attack -800 and weakness defense -3% for 12s to 2 enemies with highest attack.	Deals 1162 damage to 2 enemies with priority to Light units, attack -30% and weakness defense -20%.	
147	Healing +8% to grass units.	Deals 70 damage.	Heals 184 HP to 2 allies with lowest hp.	Heals 381HP and 110HP Regeneration (Heal every 2seconds) for 10s to 3 allies with lowest HP.	Deals 841 damage to 2 random enemies, and gives 110HP Regeneration (Heal every 2s) for 18s to 3 allies with lowest HP. If debuffed additional 60HP Regeneration (Heal every 2seconds)	
148	Regeneration (Heal every 2seconds) +50 to all units.	Deals 71 damage.	Deals 210 damage to target, and Healing -40% for 12s.	Deals 372 damage to target, instant heal 516HP and Regeneration (Heal every 2s) 140 for 12s to 2 allies with lowest HP.	Deals 854 damage to 2 random enemies, 110HP Regeneration (Heal every 2s) and 50HP additional Regeneration (Heal every 2s) in the case of a damage debuff for 18s to 3 allies lowest HP.	
149	Tap skill damage +80 to Dark units.	Deals 80 damage.	Deals 296 damage to enemy with lowest HP with 100 additional damage if Light type.	Deals 95 damage plus Tap damage 2 times to target (450 ignore Defense damage).	Deals 1313 damage to 4 random enemies.	
150	Attack +500 to grass units.	Deals 80 damage.	Deals 296 damage to enemy with lowest HP with 100 additional damage if Water unit.	Deals Tap damage 2 times, 150 additional damage if Water unit to 1 enemy with priority to Water unit.	Deals 1425 damage to 3 enemies with lowest HP.	
157	Auto damage +40 to Water units.	Deals 80 damage.	Deals 80 damage plus Auto damage 3 times to target.	Deals 531 damage and Poison (Deals 380 damage when enemy attacks and receives attacks) for 3 turns to 2 enemies with priority to fire units, if fire type deal 150 additional damage.	Deals 1389 damage to 3 random enemies.	Sonnet is good against single target fights such as Raids and WorldBoss, because she has the highest poison per tick compared with Elysium and Eve. Can easily be added to any element WB teams to give poison damage.
151	Attack -10% to Water enemies.	Deals 74 damage.	Deals 239 damage to target, and weakness Defense -3% for 6s if Water unit.	Deals 439 damage and skill gauge charge rate -22.5% for 14s to 2 enemies with highest attack.	Deals 1154 damage to 3 random enemies, weakness Defense -15% for 16s if Water unit.	
152	Attack +500 to Dark units.	Deals 81 damage.	Deals 300 damage to target and critical rate +25% for 10s to self.	Deals 75 damage plus Tap damage 3 times to target (500 ignore Defense damage).	Deals 1433 damage and Bleeding (160 continuous damage every 2s) for 8s to 3 random enemies.	
36	+10% Final slide skill damage for Fire allies (Additional +30% chance of critical damage on self in Devil Rumble)	Deal 114 auto attack damage.	Deal 495 damage to target, apply "Yell" to self (increase ATK +15%, can be stacked up to 3 times) for 15 seconds and a 75% chance to apply "Direct Hit" (Attack ignoring "Endure" effect).	Prioritizing 2 enemies with highest attack, deal 986 twice, gives 489 defense ignore damage and 300 additional damage.	Prioritizing enemies with least HP, deal 2657 damage to 4 enemies.	She's so cute.
153	Weakness Defense +5% to Light Allies.	Deals 73 damage.	Deals 223 damage and 60% chance to remove "Confusion" from 1 allies.	Deals 446 damage to target and Give "Regeneration" (Heal 67HP per 2s) for 16s and 70% chance to remove "Bleed", "Poison", "Curse" to 2 lowest HP allies.	Deals 1097 damge to 3 random enemies and Instant Heal 3 lowest Hp Allies for 516 HP.	
154	Regeneration (Heal every 2seconds)s +50 to all allies.	Deals 70 damage.	Deals 206 damage to target, instant heal 189 to 2 allies with lowest HP.	Gives continous heal 120 HP and 500 HP barrier for 14s to 3 allies with lowest HP .	Gives 1000 HP instant heal to 3 allies with lowest HP, additional 240 HP instant heal if Fire type.	
155	Charge Speed -10% to Water Type Enemies.	Deals 74 damage.	Deals 240 damage to target and reduce -400 attack for 8s and 40% chance to remove 1 buff from target.	Deals 454 damages to 2 enemies (prioritizing enemies with Speed Charge type buffs) and 300 ignore defense and 40% chance to Apply "Time Alter" (remove 1 buff and -40% Skill gauge Charge rate) for 12s.	Deals 1194 to 3 random enemies and -30% Skill gauge Charge rate for 16s.	
156	Auto damage +40 to grass units.	Deals 80 damage.	Deals 297 damage to target and gives Lifesteal (absorb 3% of the damage as HP) for 16s to self.	Deals 537 damage to 3 enemies with priority to Water units, deals additional 200 damage if Water unit.	Deals 1314 damage to 4 random enemies.	
159	Agility +400 to Light Units	Deals 80 damage.	Deals 293 damage to enemy with lowest HP with 100 additional damage if Dark type.	Deals 80 damage plus Tap damage 2 times to target and gains Reflect (returns 7% of damage received) for 15s, priority to Dark enemies.	Deals 1417 damage to 3 enemies with lowest HP.	
160	Tap attack damage +40 to Light units	Deals 80 damage.	Deals 80 damage plus Auto damage 3 times to target.	Deals 507 damage and Healing -25% for 14s to 2 enemies with lowest HP.	Deals 1406 damage and Bleeding (160 continuous damage every 2 seconds) for 8s to 3 random enemies.	
161	Attack +500 to Light units	Deals 80 damage.	Deals 295 damage to enemy with lowest HP with 100 additional damage if Dark type.	Deals 572 damage and Healing -25% for 12s to 3 enemies with lowest HP.	Deals 1409 damage and Bleeding (160 continuous damage every 2 seconds) for 10s to 4 random enemies.	
163	Critical rate -20% to Dark enemies.	Deals 73 damage.	Deals 236 damage to target，if Dark gives weakness Defense -3% for 6s.	Deals 437 damage to 2 enemies and agility -700 for 12s.	Deals 1149 damage to 3 random enemies and Blind (-35% Accuracy) for 10s.	
158	Tap damage +80 to Water units.	Deals 80 damage.	Deals 295 damage to enemy with lowest HP with 100 additional damage if Fire type.	Deals 560 damage and Poison (Deals 350 damage when enemy attacks and recieves attacks) for 3 turns to 3 enemies with lowest HP.	Deals 1422 damage to 3 enemies with lowest HP.	Not the strongest poison dealer, but hits more targets than Eve or Sonnest, which makes her great for PVP teams.
165	Regeneration (Heal every 2s) +50 to Light units.	Deals 70 damage.	Deals 205 damage to target, and Healing +30% to 2 ally with lowest HP.	Heals 291HP to 3 allies with lowest HP, and gives 101HP Regeneration (Heal every 2s) for 10s .	Gives 1100HP instant heal to 3 allies with lowest HP.	
166	Damage +40 to Dark units.	Deals 80 damage.	Deals 294 damage to enemy with lowest HP with additional 100 damage if Light type.	Deals 271 (105%) damage to 3 enemies with priority to Light units.	Deals 1417 damage to 3 enemies with lowest HP.	
167	Gives Reflect (returns 3% of damage received) to Dark units (bonus +3% on Ragnas).	Deals 68 damage.	Deals 195 damage to target and Defense +500 for 12s to 2 allies with priority to Dark units.	Deals 379 damage to target, gives Reflect (returns 9% of damage received) and 900 HP barrier for 10s to 5 Dark units.	Deals 823 damage to 2 random enemies, and 1500 HP barrier for 16s to 3 units with lowest HP.	
168	Gives +50 HP Regeneration (Heal every 2s).	Deals 71 damage.	Deals 206 damage to target and 50% chance to remove enemy regeneration, Lifesteal, and healing buffs.	Deals 378 damage to 2 random enemies and 167HP Regeneration (Heal every 2s) for 14s to 2 allies with lowest HP.	Heals 1000HP for 3 allies with lowest HP, additional healing of 200HP if Dark unit.	
169	Attack +8% to all allies.	Deals 73 damage.	Deals 229 damage to target and attack +200 for 8s to 1 random ally.	Deals 431 damage to target and attack +700 for 22s to 2 allies with highest attack and 70% chance to remove confusion.	Deals 1058 damage to 2 random enemies and skill damage +25% for 16s to 3 random allies.	
170	Defense +300 to Fire units.	Deals 68 damage.	Deals 193 damage to target and Skill defense by +45 for 10s to self.	Deals 340 damage to target, and gains a +680HP barrier and Taunt (84% provocation) for 10s.	Gives a +2500 HP barrier for 20s to 3 allies with lowest HP.	
171	Skill gauge charge speed -10% to Fire enemies.	Deals 74 damage.	Deals 238 damage to target and remove 30% of target skills gauge.	Deals 427 damage and skill gauge charge speed -25% for 12s to 2 enemies with highest attack.	Deals 1157 damage and skill gauge charge speed -40% for 16s to 3 random enemies.	
172	Skill gauge charge speed +5% to all allies.	Deals 73 damage.	Deals 231 damage to target, and agility +300 to 2 allies with highest attack.	Deals 408 damage to target and skill gauge charge speed 20% for 16s to 2 allies with highest attack.	Deals 1075 damage to 2 random enemies and Attack +1000 for 18s to 2 allies with highest attack.	
173	Skill gauge charge +4% to all allies.	Deals 73 damage.	Deals 232 damage to target and skill gauge charge speed 25% for 6s to 1 random ally.	Deals 435 damage to target and skill gauge charge +26% for 18s to 2 allies with highest attack.	Deals 1120 damage and 75% chance to Confuse for 10s to 2 random enemies and heal 250HP to 3 allies with lowest HP.	
174	Regeneration (Heal every 2seconds) +50 to Water units.	Deals 70 damage.	Deals 209HP to target, and Heals 181 to ally with lowest HP.	Gives 111HP Regeneration (Heal every 2seconds) with additional 41HP if ally is debuffed for 12s to 3 allies with lowest HP.	Heals 1100 HP to 3 allies with lowest HP.	
175	Tap skill damage +80 to grass units.	Deals 81 damage.	Deals 75 damage plus Auto damage 3 times to target and gains Lifesteal (Absorbs 40HP per hit) for 20s.	Deals 589 damage to 3 random enemies and absorb 8% of the damage as HP.	Deals 1432 damage to 3 enemies with lowest HP.	
176	Critical +400 to grass units.	Deals 80 damage.	Deals 293 damage to enemy with lowest HP with 100 additional damage if Water unit.	Deals 278 (108%) damage to 2 random enemies.	Deals 1393 damage to 3 random enemies.	
177	Defense +7% to all allies.	Deals 73 damage.	Deals 231 damage to target and 50% chance to remove stun to 1 stunned ally.	Deals 408 damage to target and gives a +600HP barrier and Defense +450 for 16s to 2 allies with lowest HP.	Deals 1076 damage to 3 random enemies, and gives a +1200HP barrier for 18s for 3 allies with lowest HP.	
178	Maximum HP +500 to all allies	Deals 73 damage	Deals 230 damage to target, and 50% chance to remove silence from ally.	Gives 60 HP Regeneration for 16s to 2 allies with lowest HP and 70% chance to remove bleeding and poison debuff from 2 allies.	Deals 1070 damage to 2 random enemies, give Reflect (returns 10% of damaged received) for 20s to 2 allies with lowest HP.	
179	Attack -15% to all enemies.	Deals 74 damage.	Deals 243 damage to target with highest attack and Attack -10% for 6s.	Deals 518 damage to 2 enemies with highest attack, Attack -700, and critical rate -25% for 12s.	Deals 1355 damage to 2 enemies with highest attack, drive skill gauge -5%, and Attack -30% for 15s.	
180	Critical rate +10% to all allies.	Deals 73 damage.	Deals 233 damage to target and critical rate +30% for 10s to 1 random ally.	Critical rate +30% and critical damage +25% for 16s to 2 allies with highest attack.	Deals 1119 damage to 2 random enemies, skill damage +25% for 16s to 2 allies with highest attack and 75% confusion for 10s to 1 random enemy.	
181	Critical +400 to Water units.	Deals 81 damage.	Deals 300 damage and Poison (Deals 150 damage when enemy attacks and recieves attacks) for 3 turns to target.	Deals 80 damage plus Tap damage 3 times to target and 300 ignore Defense damage.	Deals 1319 damage to 4 random enemies.	
182	Attack -10% to Fire enemies.	Deals 74 damage.	Deals 237 damage to target, and remove 30% of target skill gauge.	Deals 438 damage and skill gauge charge speed -20% for 12s to 2 random enemies.	Deals 1151 damage and skill gauge charge speed -30% for 16s to 3 random enemies.	
183	Tap Damage +80 to Light units.	Deals 80 damage.	Deals 298 damage and Healing -25% for 8s to target.	Deals 587 damage 3 enemies priority to Dark, ignore 300 Defense power and gains Reflect (returns 9% of damage received) for 15s.	Deals 1460 damage, Bleeding (200 continuous damage every 2s) for 10s and block heals (excludes absorption and lifesteal) for 14s to 3 enemies with lowest HP.	
184	Tap damage +80 to Fire units.	Deals 81 damage.	Deals 300 damage and Bleeding (45 continuous damage every 2s) for 6s to target.	Deals 50 damage plus Tap damage 3 times to target plus 300 ignore Defense damage.	Deals 1454 damage plus 500 ignore Defense damage and 90% chance to apply heal block for 10s to 3 enemies with lowest HP.	
186	Defense +7% to all allies.	Deals 73 damage.	Deals 229 damage to target, and Defense +10% for 10s to 1 random ally.	Deals 419 damage to target, 50% chance to remove bleeding and poison.	Deals 1072 damage to 3 random enemies, and +1200 HP Barrier for 18s to 3 allies with lowest hp.	
187	Evasion rate +10% to Light units.	Deals 68 damage.	Deals 194 damage to target and Defense +530 for 10s.	Deals 357 damage to target, and gain a 1000HP barrier, Taunt(84% provocation) for 10s.	Deals 820 damage to 2 random enemies and gains Fury (Up to 100% of damage is received and returned).	
188	Critical +400 to Fire units.	Deals 80 damage.	Deals 295 damage to enemy with lowest HP with 100 additional damage if grass type.	Deals 560 damage 3 enemies with priority to grass type with 200 additional damage if grass type.	Deals 1310 damage to 4 random enemies.	
189	Gives Lifesteal (Absorbs 3% of the damage as HP) to grass units.	Deals 68 damage.	Deals 193 damage to target and absorb 100HP.	Deals 376 damage to target, Lifesteal (Absorbs 10% of the damage as HP) to 5 units, and 900 HP barrier for 12s to 2 grass units.	Deals 901 damage to target, Defense +30% and Taunt (95% provocation) for 15s to self.	
190	Attack +8% to all allies.	Deals 73 damage.	Deals 234 damage to target, 70% chance to remove freeze from ally.	Deals 449 damage to target, 80% chance to swap attack and Defense for 20s to 2 allies with lowest HP.	Deals 1086 damage to 3 random units, attack +25% for 25s to 3 units with highest attack.	
191	Attack +500 to Fire units.	Deals 80 damage.	Deals 80 damage plus Auto damage 3 times to target.	Deals 458 damage to 2 enemies and Bleeding (60 continuous damage every 2s) for 10s, with 80 additional damage if grass type.	Deals 1395 damage to 3 enemies, and Bleeding (200 continuous damage every 2s) for 8s.	
192	Auto damage +40 to Fire units.	Deals 80 damage.	Deals 294 damage to enemy with lowest HP with 100 additional damage if grass type.	Deals 470 damage and Bleeding (120 continuous damage every 2s) for 8s to 2 enemies with priority to grass type.	Deals 1417 damage to 3 enemies with lowest HP.	
193	HP +800 to Fire units.	Deals 68 damage.	Deals 189 damage to target and Defense +540 for 10s to self.	Deals 337 damage to target and gains a +1000HP barrier and Taunt (84% provocation) for 8s.	Deals 834 damage to target, and gains a +3000HP barrier and Taunt (95% provocation) for 15s.	
194	Critical +400 to Dark units.	Deals 80 damage.	Deals 80 damage plus Auto damage 3 times to target.	Deals 286 (110%) damage to 2 random enemies.	Deals 1399 damage to 3 random enemies.	
195	Defense +300 to Dark Units.	Deals 67 damage.	Deals 187 damage to target and Skill defense +45 for 10s to self.	Deals 371 damage to target, and gains Reflect (returns 11% of damage received) and Taunt (84% provocation) for 10s.	Gives Reflect (returns 21% of damage received) for 20s to ally with lowest HP and self.	
196	HP +800 for grass units.	Deals 68 damage.	Deals 189 damage to target and gains Lifesteal (Absorbs 6% of damage per hit) for 12s .	Gains 1100HP barrier and Taunt (84% provocation) for 10s.	Deals 897 damage to target, and including self gives 2500HP barrier to 3 allies with lowest HP.	
197	Defense +300 to Water units.	Deals 68 damage.	Deals 187 damage to target and Defense +500 for 10s to self.	Deals 372 damage to target, and Defense +600 and gains Taunt (84% provocation) for 10s to self.	Defense +30% for 20s to 5 allies.	
198	Defense +7% to grass Allies.	Deals 68 damage.	Deals 196 damage and give +15% Defense to 2 grass Allies and Apply "Taunt" (84% Provocation) to self for 10seconds.	Deals 404 damage and Absorb 20% of the damage as HP and gives +100 Skill Damage Defense to 3 grass Allies for 10seconds.	Deals 912 damage to 2 random enemies and gives +1500 Barrier to 4 lowest HP Allies for 18seconds.	
199	Gives Reflect (50 damage per hit) to Dark units.	Deals 68 damage.	Deals 187 damage to target and Defense +540 for 10s to self.	Deals 397 damage to target, and gives Reflect (returns 10% of damage received) and Taunt (84% provocation) for 10s.	Deals 786 damage to target, and gives Reflect (returns 8% of damage received) for 20s to 5 allies.	
200	Reflect (50 damage per hit) to Fire units.	Deals 68 damage.	Deals 192 damage to target and Defense +480 for 12s to 2 Fire units.	Deals 337 damage to target and gives a +900HP barrier and Defense +500 for 12s to 3 Fire units.	Deals 897 damage to 1 random enemies and Defense +30% and Taunt (95% provocation) to self.	
201	Maximum HP +800 to Fire units.	Deals 67 damage.	Deals 187 damage to target, and Defense +580 for 10s to self.	Deals 383 damage to target, +1200 HP Barrier and Taunt (85% Provocation) for 10s to self.	Deals 851 damage to 2 random enemies, and gives +2000 HP Barrier for 20s to 2 allies with lowest hp.	
202	HP +800 to Water units.	Deals 68 damage.	Deals 194 damage to target and Defense +520 for 12s to 2 Water units.	Deals 378 damage to target, gives Defense +20% and 800HP barrier to 5 Water units.	Deals 819 damage to 2 random enemies, skill damage Defense +20% for 16s to 3 Water units.	
203	Attack +8% to all allies.	Deals 54 damage.	Deals 149 damage to target and skill gauge charge rate +20% for 8s to 1 ally with highest attack.	Deals 307 damage to target and attack +500 for 14s to all allies.	Deals 753 damage to 2 random enemies and skill gauge charge rate +45% and skill gauge charge +40% for 23s to 2 allies with highest attack.	
205	Slide damage +60 to Fire units.	Deals 58 damage.	Deals 193 damage and Bleeding (70 continuous damage) for 6s to target.	Deals 405 damage to all enemies.	Deals 949 damage to all enemies and Bleeding (120 continuous damage) for 10s to 3 enemies with highest HP.	
206	Maximum HP +400 to Dark units.	Deals 51 damage.	Deals 126 damage to target and gains Lifesteal (Absorbs 50HP per hit) for 2 turns.	Deals 281 damage to target and gives +30% Defense and Taunt (84% provocation) for 10s to self.	Deals 622 damage to 3 random enemies and +1200 HP barrier for 15s to all allies.	
204	Defense -7% to all enemies.	Deals 54 damage.	Deals 156 damage and Defense -250 for 8s to target.	Deals 306 damage and Defense -4% for 12s to 2 random enemies.	Deals 831 damage and Defense -17% for 14s to 3 random enemies.	Cheap version of Freesia and Jupiter, but easier to uncap and does great debuff work in all content - cheap, but good.
212	Skill Gauge Charge Speed +10% for Water type allies.	Deal 99 auto attack damage.	Deal 368 damage to target, skill gauge +13% for 2 water type allies (excluding self).	Deal 603 damage to target, attack +1200 and crit rate +30% to 3 water type allies with the highest attack for 16 seconds.	Deal 1713 damage to 3 random enemies, grant barrier (absorbs +2000 damage before HP is affected) to up to 5 water type allies for 20 seconds, and heal 1224HP for them.	
213	Water allies +2000 HP & self +1000 HP.	Deal 228 auto damage.	Deal 1020 damage to target and apply Max HP +759(Priority: Lowest HP) for 8 sec to 1 ally (if own HP is the lowest, Max HP will only be applied to self).	Deal 1455 damage to target, Apply DoT debuff resist chance 30% to 2 allies (Priority: Lowest HP) for 14 sec (if own HP is the lowest, DoT Resist will only be applied to self) and grant Barrier (absorbs 1700 damage before HP is affected) up to 5 allies (Priority: Lowest HP).	Do "Emergency Transfusion" to 2 allies with less than 50% HP (Consumes 40% of own current HP and distributes to target allies, not affected by "Heal block" and "Death Heal") and apply Max HP +2000 to 3 allies (Priority: Lowest HP) for 20 sec (if own HP is the lowest, Max HP will only be applied to self and 2 allies).	(call-the-cops).
221	Excluding self, resurrect the first ally that dies, and revives with 50% HP.	Deals 96 damage.	Deal 337 damage to enemy, for 20 seconds increase recovery amount (heal, regen) by 32% to 3 allies with lowest HP.	Heals 1291 and Grants +1400 shield to 3 allies with the lowest HP allies for 14 seconds.	Deals 1549 damage to 2 enemies with lowest HP, Heals 1791 and 220 HP Regeneration (Heal every 2s) to 3 allies with lowest HP for 16 seconds.	
218	Defense -15% to grass enemies.	Deals 261 damage	Deals 1279 damage, 77.7% chance of removing one buff from target.	Prioritizing enemies with the lowest HP, deal 1725 to 2 targets, and Deadly Poison (deals 292 damage every 2 seconds and reduce healing by 50%, duration cannot be shorten/extended) for 10 seconds.	Prioritizing enemies with deadly poison, deals 4670 damage to 3 enemies, Defend -30% and 90% change of Deadly Poison amplification (increases damage of Deadly Poison and further reduces healing amount) for 16 seconds.	
215	-15% to debuff accuracy for enemy debuffer units.	Prioritizing enemy debuffers, reduce debuff accuracy by -11%.	Hits 2 targets with 72% chance to inflict Sleep (can't atttack and Def becomes 0) for 8 seconds, and Attack -1950 for 12 seconds.	Hits 3 targets prioritizing enemy with highest Attack stat, then inflict Attack -40% and Defense -30% for 16 seconds.		
216	Slide final damage +8% for water allies and (during Ragna, +40% critical damage to self).	Deals 301 damage.	Deals 1611 damage to enemy with 570 ignore Defense damage if fire type.	Prioritizing fire types, deal 2251 to 3 targets and 945 ignore Defense damage, and if fire type deals 758 bonus damage.	Deals 5707 damage to 4 enemies, Gives Berserk (Increase attack by +90% and becomes immune to damage, afterwards unit will be stunned for 5s) to self for 14s.	
5	Skill gauge charge rate +8% to Water units.	Deals 100 damage.	Deals 381 damage to target and 52.5% chance to fully charge skill gauge to random ally (excluding self).	Deals 663 damage to target and skill gauge charge +40% for 2 turns and slide cooldown -2s to 2 allies with highest attack.	Deals 1789 damage and 80% chance to stun for 12s to 3 enemies that are charging skill and +400 drive gauge.	Kouga is the best support unit in the game and a must have. Her buffs can help attackers deal more damage or help your team survive by targeting a healer on the team - Healers have long cooldowns, so Kouga is great at decreasing it with her slide. Her tap is usually more RNG even at +6 uncap, and even at 83% she will not activate her tap passive skill if spammed. The tap skill will also only fully charge an ally skill gauge if they are not on a counter cooldown, so use it wisely. Great with Dana or Syrinx.
12	Skill Gauge Charge +8% to all Allies (Additional +8% in Devil Rumble).	Deals 101 damage.	Deals 379 damage to target. 50% chance to remove "Bleed", "Poison" , "Curse" from 2 allies. Gives "Lifesteal"(Absorbs 15% of the damage as HP) for 14s to 2 allies.	Deals 667 damage to 2 random enemies.·Gives +30% Skill Gauge Charge for 2 turns to 2 highest attack allies. 70% chance to Apply "Cheer" (15% weakness skill damage and increase attack based on the current number of buffs) for 2 turns to 2 highest attack allies.	Deals 1803 damage to 3 random enemies.\r\nGives +40% Skill Gauge Charge for 3 turns to 3 allies (prioritizing grass Types). \r\nApply "Cheer" (15% weakness skill damage and increase attack based on the current number of buffs) for 3 turns to 3 allies (prioritizing grass Types).	Great in all content and can easily replace Kouga when skill cooldown is not as important as speed buff and damage buff. Can be used with Kouga to get a really speedy team.
6	Drive skill damage +10% to Water units	Deals 113 damage.	Deals 485 damage with 250 additional damage if Fire type to enemy with lowest Defense	Deals 855 damage with 450 additional damage and Poison (300 damage when enemy attacks and receives attacks) for 3 turns to 2 enemies with lowest HP.	Deals 2437 damage to all enemies.	She is great in all content. Though, at lower uncap levels she will not be as great as Ely or Sonnet in regards to poison, but she does more raw damage.
220	-15% debuff evasion chance to fire type enemies.	Deals 102 damage.	Prioritizing highest attack enemy, Deal 394 damage and 75% chance of removing one buff from target.	Prioritizing healer types, Deal 677 damage to 2 enemies and skill gauge charge speed -30% for 12s and enemy drive gauge -8%.	Deals 2012 damage to 3 enemies, removing one buff from targets and 80% chance of silence (can't use skills and gauge reset) for 5s.	
223	+15% attack for grass type allies	Deals 113 damage.	Deals 485 damage to target, if the target is a defense type, deal 150 bonus damage.	Prioritizing defense types, deal 855 to 2 targets 2 times, if the target is a defense type, deal 400 bonus damage and absorbs 350 damage as HP.	Deals 2489 damage to all enemies, 70% chance to stun 2 random enemies for 4s? (stunned for 1s more when attacked, up to 5s max).	
224	+15% critical rate to fire type allies (In WB +20% critical damage).	Deals 101 damage.	Deals 385 damage to target, grants +15% evasion for 10s to 2 lowest HP allies.	Deal 663 damage to target, for 16s, all allies in front roll, +1000 Defense and 2 allies with the highest attack +43% critical rate. For WB only, 5 highest attack fire allies, +43% critical rate and +25% critical damage for 16s.	Deals 1742 damage to 3 enemies, for 20s, 5 highest attack fire allies +40% attack. For WB only, grants Attack stance (only these 5 childs will attack during fever) to 5 highest attack fire allies	
25	Heal and Regeneration (Heal every 2seconds) amount +5% to grass units	Deals 96 damage.	Deals 335 damage to target and gives Invincibility for 10s or 2 hits to ally with highest attack.	Gives 141HP Regeneration (Heal every 2seconds) for 14s and Invincibility for 20s or 4 hits to 2 allies with lowest HP.	Gives 199HP Regeneration (Heal every 2seconds) for 16s and Invincibility for 15s or 3 hits to 3 allies with lowest HP.	Syrinx does not have the strongest heals per tick, but her Fortitude (invincibility) buffs help minimize(decrease to 0) the damage received and thus less healing is required. In PVP her buff can help negate damage when a poisoned ally is attacking since each attack (regardless of number of hits) only destroys one stack of Fortitude - Bleeding destroys stacks much faster.. Not a great healer in WorldBoss.
59	Skill gauge charge rate +10% to all Water unit allies.	Deals 99 damage.	Deals 365 damage to target and gives +25% drive gauge charge speed for 10seconds to 1 ally.	Deals 550 damage and -30% skill gauge charge rate for 2 turns to 2 random enemies, and gives cooldown -1s for 2 turns to 3 random allies.	Deals 1705 damage to 2 random enemies. Gives Skill Gauge Charge Rate +20% to all Allies for 20 seconds. Gives Skill Gauge Charge Speed +20% to all Allies for 20 seconds.	Not as good as Kouga in some aspects, but her slide and drive are really useful in WorldBoss events.
60	Dark enemy debuff evasion rate -10%	Deals 100 damage.	Deals 381 damage to target, and debuff evasion rate -10% for 8s.	Deals 595 damage to 2 enemies with highest attack, and 70% chance to petrify (unable to act for 10s or after being hit 2 times).	Deals 2096 damage to 2 random enemies, and 90% chance to petrify (unable to act for 15s or after being hit 3 times).	A PVP cc unit and great in combination with Wola. Also great with DoT teams and Gkouga. Moa is great at stalling the enemies to get to fever/drive first. Useless in Raids and WorldBoss.
99	Weakness Defense -8% to Water Types enemies	Deal 101 auto attack damage	With priority on Debuffers, Deal 390 damage and, if the target is a Debuffer type, deal 160 additional damage.	With priority on Attackers type, Deal 669 damage to 2 targets, plus skill gauge charge speed -30% and a 70% chance to get "Attraction" (invalidates buffs, cannot be dispelled) for 12 seconds.	With priority on Debuffers, Deal 1967 damage to 3 targets, plus skill gauge charge amount -33% for 16 seconds and a 80% chance of "Stun" (increase\r\nduration of Stun by 1 second to max 5 seconds for each attack) for 4 seconds.	A PVP annoyance - great if she is on your team, not when she is on the enemy. A clear counter to Kouga in PVP.
106	Heal and Regeneration (Heal every 2seconds) amount +5% to Dark units	Deals 96 damage.	Deals 335 damage to target and heals 201HP to ally with lowest HP.	Gives 1.5%HP+21HP Regeneration (Heal every 2seconds) for 10s and Immortality (HP will not go under 1) for 10s to 2 allies with lowest HP.	Gives Berserk (Increase attack by +70% and becomes immune to damage, afterwards unit will be stunned for 5s) for 14s to 2 allies with lowest HP.	Similar to Rusalka, but Metis Berserk buff on drive is very useful in UndergroundEx and even raids - The downside is that her drive is hard to get the attacker buffed because she only buffs the lowest HP units, and then stuns for 5 seconds. With RNG on your side she can be quite good.
145	Healing +2.5% to all allies.	Deals 73 damage.	Deals 229 damage to target and gives a +250HP barrier for 8s to 1 random ally.	Gives Regeneration (Heal every 2s) ability +30% to all allies and 60HP Regeneration (Heal every 2s) for 16s to 2 allies with lowest HP.	Deals 1108 damage to 2 random enemies and give Lifesteal (Absorbs 20% of the damage as HP) for 20s to 2 allies with lowest HP.	She isn't a healer, but doesn't have the long cooldowns that healers do. A great supportive healer in content where a ton of damage is dealt, but can easily be used as a solo healer. Arguably best "healer" in the game.
185	Defense -8% to grass enemies.	Deals 74 damage.	Deals 240 damage to target with least Defense, and Defense -300 for 8s to enemy with highest defense.	Deals 441 damage and Defense -350 for 12s to 2 enemies with highest attack.	Deals 1101 damage to 3 enemies with highest Defense, and Defense -1000 for 16s.	4 star version of Jupiter with some decrease in debuff power, but still a great unit and is easier to uncap.
\.


--
-- Data for Name: test; Type: TABLE DATA; Schema: public; Owner: lucin
--

COPY public.test (id, name) FROM stdin;
21	one2
22	two1
23	one2
24	two1
25	one2
26	two1
27	one2
28	two1
1	e2
2	r1
3	e2
4	r1
5	e2
6	r1
7	e2
8	r1
9	e2
10	r1
11	e2
12	r1
13	e2
14	r1
15	e2
16	r1
17	e2
18	r1
19	e2
20	r1
30	e2
31	r1
32	e2
33	r1
34	e2
35	r1
60	nana
\.


--
-- Name: test_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lucin
--

SELECT pg_catalog.setval('public.test_id_seq', 35, true);


--
-- Data for Name: units; Type: TABLE DATA; Schema: public; Owner: lucin
--

COPY public.units (id, name, created_on, enabled) FROM stdin;
223	daphnis	2019-03-29	t
7	dana	2018-11-28	t
5	kouga	2018-11-28	t
8	maat	2018-11-28	t
12	newbie mona	2018-11-28	t
14	kouka	2018-11-28	t
15	innocent venus	2018-12-05	t
16	frey	2018-11-28	t
17	gkouga	2018-11-28	t
18	mafdet	2018-11-28	t
19	cleopatra	2018-11-28	t
24	orga (wola)	2018-11-28	t
25	syrinx	2018-11-28	t
26	khepri	2018-11-28	t
27	krampus	2018-11-28	t
28	charlotte	2018-11-28	t
29	nirrti	2018-11-28	t
30	maris	2018-11-28	t
31	hestia	2018-11-28	t
32	jupiter	2018-11-28	t
33	lan fei	2018-11-28	t
34	christmas leda	2018-12-25	t
37	astraeas	2018-11-28	t
38	chun-li	2018-11-28	t
39	bari	2018-11-28	t
40	isolde	2018-11-28	t
41	anemone	2018-11-28	t
42	tirfing	2018-11-28	t
43	verdel	2018-11-28	t
44	snow miku	2018-11-28	t
45	siren	2018-11-28	t
46	durandal	2018-11-28	t
48	marie rose	2018-11-28	t
49	cammy	2018-11-28	t
50	rita	2018-11-28	t
51	aurora	2018-11-28	t
52	ashtoreth	2018-11-28	t
53	lady bathory	2018-12-05	t
54	mysterious saturn	2018-12-05	t
55	student eve	2018-12-05	t
56	aria	2018-11-28	t
57	pretty mars	2018-12-05	t
58	nicole	2018-12-25	t
59	naiad	2018-11-28	t
60	cube moa	2018-11-28	t
61	neptune	2018-12-05	t
62	kagura warwolf	2019-01-03	t
63	brownie	2018-11-28	t
64	buster lisa	2018-11-28	t
65	hades	2018-11-28	t
66	eshu	2018-11-28	t
67	epona	2018-11-28	t
68	maou davi	2018-11-28	t
69	morgan	2018-11-28	t
70	thanatos	2018-11-28	t
71	hildr	2018-11-28	t
73	bikini davi	2018-11-28	t
74	santa	2018-11-28	t
75	midas	2018-11-28	t
76	bastet	2018-11-28	t
77	jiseihi	2018-11-28	t
78	ruin	2018-11-28	t
79	abaddon	2018-11-28	t
80	elizabeth	2018-11-28	t
81	frey (light)	2018-11-28	t
82	nevan (light)	2018-11-28	t
84	pallas	2018-11-28	t
85	athena	2018-11-28	t
87	brigette	2018-11-28	t
88	honoka	2018-11-28	t
89	bikini lisa	2018-11-28	t
91	scuba mona	2018-11-28	t
92	magician ohad	2018-11-28	t
93	magician ailill	2018-11-28	t
94	party star medb	2018-11-28	t
96	diablo	2018-11-28	t
97	medb	2018-11-28	t
99	love sitri	2018-11-28	t
100	pantheon	2018-11-28	t
102	rusalka	2018-11-28	t
106	metis	2018-11-28	t
107	sitri	2018-11-28	t
108	medusa	2018-11-28	t
109	hermes	2018-11-28	t
110	pan	2019-01-28	t
111	calypso	2018-11-28	t
112	hera	2018-11-28	t
113	willow	2018-11-28	t
114	dark maat	2018-11-28	t
115	myrina	2018-11-28	t
116	hatsune miku	2018-11-28	t
117	dinashi	2018-11-28	t
119	mammon	2018-11-28	t
120	horus	2018-11-28	t
121	bi moa	2019-01-03	t
122	redcross	2018-11-28	t
123	ai	2018-11-28	t
124	luna	2018-11-28	t
125	dark midas	2018-11-28	t
127	tethys	2018-11-28	t
145	leda	2018-11-28	t
146	persephone	2018-11-28	t
147	selene	2018-11-28	t
148	merlin	2018-11-28	t
149	inanna	2018-11-28	t
150	korra	2018-11-28	t
151	muse	2018-11-28	t
152	artemis	2018-11-28	t
153	bast	2018-11-28	t
6	eve	2018-11-28	t
154	daphne	2018-11-28	t
128	warwolf	2018-11-28	t
155	agamemnon	2018-11-28	t
156	amor	2018-11-28	t
157	sonnet	2018-11-28	t
36	oiran bathory	2019-01-03	t
158	elysium	2018-11-28	t
159	orora	2018-11-28	t
173	maya	2018-11-28	t
160	calchas	2018-11-28	t
161	maiden detective	2018-11-28	t
162	titania	2018-11-28	t
163	ishtar	2018-11-28	t
164	heracles	2018-11-28	t
165	pomona	2018-11-28	t
166	morrigu	2018-11-28	t
167	cybele	2018-11-28	t
168	zelos	2018-11-28	t
169	fortuna	2018-11-28	t
170	el dorado	2018-11-28	t
171	yaga	2018-11-28	t
172	kirinus	2018-11-28	t
174	isis	2018-11-28	t
175	tisiphone	2018-11-28	t
176	ambrosia	2018-11-28	t
177	flora	2018-11-28	t
178	erato	2018-11-28	t
179	neman	2018-11-28	t
180	melpomene	2018-11-28	t
181	danu	2018-11-28	t
182	arges	2018-11-28	t
183	victrix	2018-12-25	t
184	neid	2018-12-25	t
185	freesia	2018-11-28	t
186	rednose	2018-11-28	t
187	frigga	2018-11-28	t
188	yuna	2018-11-28	t
189	europa	2018-11-28	t
190	rudolph	2018-11-28	t
35	kasumi	2018-11-28	t
191	fenrir	2018-11-28	t
192	hector	2018-11-28	t
193	lady	2018-11-28	t
194	guillotine	2018-11-28	t
195	aten	2018-11-28	t
196	hat-trick	2018-11-28	t
197	halloween	2018-11-28	t
198	ankh	2018-11-28	t
199	bakje	2018-11-28	t
200	chimaera	2018-11-28	t
201	fairy	2018-11-28	t
202	thoth	2018-11-28	t
203	lisa	2018-11-28	t
204	tiamat	2018-11-28	t
205	davi	2018-11-28	t
206	mona	2018-11-28	t
220	babel	2019-03-26	t
224	ganesh	2019-03-29	t
212	princess miku	2019-03-26	t
213	bes	2019-03-26	t
218	demeter	2019-03-26	t
221	prophet dana	2019-03-26	t
215	banshee	2019-03-26	t
216	deino	2019-03-26	t
\.


--
-- Name: units_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lucin
--

SELECT pg_catalog.setval('public.units_id_seq', 225, true);


--
-- Name: mainstats_unit_id_key; Type: CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.mainstats
    ADD CONSTRAINT mainstats_unit_id_key UNIQUE (unit_id);


--
-- Name: profilepics_unit_id_key; Type: CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.profilepics
    ADD CONSTRAINT profilepics_unit_id_key UNIQUE (unit_id);


--
-- Name: soulcards_name_key; Type: CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.soulcards
    ADD CONSTRAINT soulcards_name_key UNIQUE (name);


--
-- Name: soulcards_pkey; Type: CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.soulcards
    ADD CONSTRAINT soulcards_pkey PRIMARY KEY (id);


--
-- Name: substats_unit_id_key; Type: CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.substats
    ADD CONSTRAINT substats_unit_id_key UNIQUE (unit_id);


--
-- Name: test_id_key; Type: CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.test
    ADD CONSTRAINT test_id_key UNIQUE (id);


--
-- Name: units_name_key; Type: CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_name_key UNIQUE (name);


--
-- Name: units_pkey; Type: CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- Name: mainstats_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.mainstats
    ADD CONSTRAINT mainstats_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id) ON DELETE CASCADE;


--
-- Name: profilepics_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.profilepics
    ADD CONSTRAINT profilepics_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id) ON DELETE CASCADE;


--
-- Name: scstats_sc_id_key; Type: FK CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.scstats
    ADD CONSTRAINT scstats_sc_id_key FOREIGN KEY (sc_id) REFERENCES public.soulcards(id) ON DELETE CASCADE;


--
-- Name: substats_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.substats
    ADD CONSTRAINT substats_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

