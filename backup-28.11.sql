--
-- PostgreSQL database dump
--

\restrict GevwhkZHDL75WCLV9ueSOrAXTKOprPCAdgSdzIufgANJU4uZlKRvTXUFx8uEqk6

-- Dumped from database version 15.14 (Debian 15.14-1.pgdg13+1)
-- Dumped by pg_dump version 15.14 (Debian 15.14-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: exercise_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.exercise_type_enum AS ENUM (
    'MULTIPLE_CHOICE',
    'MULTIPLE_CHOICE_IMGS',
    'MATCHING',
    'MATCHING_AUDIO',
    'TRANSLATION',
    'LISTENING',
    'SPEAKING',
    'FILL_BLANK',
    'REORDER',
    'TRUE_FALSE'
);


ALTER TYPE public.exercise_type_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alphabet_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alphabet_item (
    id integer NOT NULL,
    letter character varying NOT NULL,
    transcription character varying NOT NULL,
    "audioUrl" character varying,
    "exampleWord" character varying,
    "exampleTranslation" character varying,
    "exampleImageUrl" character varying,
    "order" integer NOT NULL,
    "languageId" integer NOT NULL
);


ALTER TABLE public.alphabet_item OWNER TO postgres;

--
-- Name: alphabet_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alphabet_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alphabet_item_id_seq OWNER TO postgres;

--
-- Name: alphabet_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alphabet_item_id_seq OWNED BY public.alphabet_item.id;


--
-- Name: demo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.demo (
    cmd_output text
);


ALTER TABLE public.demo OWNER TO postgres;

--
-- Name: exercise; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exercise (
    id integer NOT NULL,
    type public.exercise_type_enum DEFAULT 'MULTIPLE_CHOICE'::public.exercise_type_enum NOT NULL,
    title character varying NOT NULL,
    instructions text,
    content jsonb NOT NULL,
    points integer DEFAULT 10 NOT NULL,
    "order" integer DEFAULT 1 NOT NULL,
    hints jsonb,
    explanation text,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "lessonId" integer,
    "languageId" integer
);


ALTER TABLE public.exercise OWNER TO postgres;

--
-- Name: exercise_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exercise_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.exercise_id_seq OWNER TO postgres;

--
-- Name: exercise_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exercise_id_seq OWNED BY public.exercise.id;


--
-- Name: language; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    "flagEmoji" character varying,
    "flagUrl" character varying,
    description text,
    difficulty integer DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "totalModules" integer DEFAULT 0 NOT NULL,
    "totalExercises" integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    vocabulary jsonb
);


ALTER TABLE public.language OWNER TO postgres;

--
-- Name: language_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.language_id_seq OWNER TO postgres;

--
-- Name: language_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_id_seq OWNED BY public.language.id;


--
-- Name: learning_modules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.learning_modules (
    id integer NOT NULL,
    title character varying NOT NULL,
    description text NOT NULL,
    "order" integer NOT NULL,
    difficulty character varying DEFAULT 'BEGINNER'::character varying NOT NULL,
    "imageUrl" character varying,
    "estimatedDuration" integer DEFAULT 0 NOT NULL,
    "totalLessons" integer DEFAULT 0 NOT NULL,
    "totalExercises" integer DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "languageId" integer
);


ALTER TABLE public.learning_modules OWNER TO postgres;

--
-- Name: learning_modules_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.learning_modules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.learning_modules_id_seq OWNER TO postgres;

--
-- Name: learning_modules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.learning_modules_id_seq OWNED BY public.learning_modules.id;


--
-- Name: lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesson (
    id integer NOT NULL,
    title character varying NOT NULL,
    description text NOT NULL,
    "order" integer NOT NULL,
    duration integer DEFAULT 0 NOT NULL,
    "videoUrl" character varying,
    vocabulary jsonb,
    "grammarNotes" text,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "modsId" integer,
    "languageId" integer
);


ALTER TABLE public.lesson OWNER TO postgres;

--
-- Name: lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lesson_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lesson_id_seq OWNER TO postgres;

--
-- Name: lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lesson_id_seq OWNED BY public.lesson.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    "timestamp" bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.migrations_id_seq OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    name character varying(100) NOT NULL,
    "avatarUrl" character varying,
    "isActive" boolean DEFAULT true NOT NULL,
    age integer,
    sex character varying,
    phone character varying,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_exercise_progress; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_exercise_progress (
    id integer NOT NULL,
    completed boolean DEFAULT false NOT NULL,
    score integer DEFAULT 0 NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    "userAnswers" jsonb,
    "timeSpent" integer DEFAULT 0 NOT NULL,
    "startedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "completedAt" timestamp without time zone,
    "userId" uuid,
    "exerciseId" integer
);


ALTER TABLE public.user_exercise_progress OWNER TO postgres;

--
-- Name: user_exercise_progress_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_exercise_progress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_exercise_progress_id_seq OWNER TO postgres;

--
-- Name: user_exercise_progress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_exercise_progress_id_seq OWNED BY public.user_exercise_progress.id;


--
-- Name: user_language; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_language (
    id integer NOT NULL,
    level integer DEFAULT 1 NOT NULL,
    progress numeric(5,2) DEFAULT '0'::numeric NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "totalPoints" integer DEFAULT 0 NOT NULL,
    streak integer DEFAULT 0 NOT NULL,
    "startedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "lastPracticedAt" timestamp without time zone,
    "userId" uuid,
    "languageId" integer
);


ALTER TABLE public.user_language OWNER TO postgres;

--
-- Name: user_language_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_language_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_language_id_seq OWNER TO postgres;

--
-- Name: user_language_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_language_id_seq OWNED BY public.user_language.id;


--
-- Name: user_lesson_progress; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_lesson_progress (
    id integer NOT NULL,
    completed boolean DEFAULT false NOT NULL,
    progress numeric(5,2) DEFAULT '0'::numeric NOT NULL,
    score integer DEFAULT 0 NOT NULL,
    "timeSpent" integer DEFAULT 0 NOT NULL,
    "startedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "completedAt" timestamp without time zone,
    "userId" uuid,
    "lessonId" integer
);


ALTER TABLE public.user_lesson_progress OWNER TO postgres;

--
-- Name: user_lesson_progress_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_lesson_progress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_lesson_progress_id_seq OWNER TO postgres;

--
-- Name: user_lesson_progress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_lesson_progress_id_seq OWNED BY public.user_lesson_progress.id;


--
-- Name: user_module_progress; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_module_progress (
    id integer NOT NULL,
    completed boolean DEFAULT false NOT NULL,
    progress numeric(5,2) DEFAULT '0'::numeric NOT NULL,
    score integer DEFAULT 0 NOT NULL,
    "timeSpent" integer DEFAULT 0 NOT NULL,
    "startedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "completedAt" timestamp without time zone,
    "userId" uuid,
    "modsId" integer
);


ALTER TABLE public.user_module_progress OWNER TO postgres;

--
-- Name: user_module_progress_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_module_progress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_module_progress_id_seq OWNER TO postgres;

--
-- Name: user_module_progress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_module_progress_id_seq OWNED BY public.user_module_progress.id;


--
-- Name: user_progress; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_progress (
    id integer NOT NULL,
    "overallProgress" numeric(5,2) DEFAULT '0'::numeric NOT NULL,
    "totalPoints" integer DEFAULT 0 NOT NULL,
    "completedExercises" integer DEFAULT 0 NOT NULL,
    "totalExercises" integer DEFAULT 0 NOT NULL,
    "completedLessons" integer DEFAULT 0 NOT NULL,
    "totalLessons" integer DEFAULT 0 NOT NULL,
    "completedModules" integer DEFAULT 0 NOT NULL,
    "totalModules" integer DEFAULT 0 NOT NULL,
    streak integer DEFAULT 0 NOT NULL,
    "dailyGoal" integer DEFAULT 0 NOT NULL,
    "dailyProgress" integer DEFAULT 0 NOT NULL,
    "lastActivityAt" timestamp without time zone DEFAULT now() NOT NULL,
    "lastActivityDate" date NOT NULL,
    "userId" uuid,
    "languageId" integer
);


ALTER TABLE public.user_progress OWNER TO postgres;

--
-- Name: user_progress_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_progress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_progress_id_seq OWNER TO postgres;

--
-- Name: user_progress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_progress_id_seq OWNED BY public.user_progress.id;


--
-- Name: alphabet_item id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alphabet_item ALTER COLUMN id SET DEFAULT nextval('public.alphabet_item_id_seq'::regclass);


--
-- Name: exercise id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercise ALTER COLUMN id SET DEFAULT nextval('public.exercise_id_seq'::regclass);


--
-- Name: language id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language ALTER COLUMN id SET DEFAULT nextval('public.language_id_seq'::regclass);


--
-- Name: learning_modules id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learning_modules ALTER COLUMN id SET DEFAULT nextval('public.learning_modules_id_seq'::regclass);


--
-- Name: lesson id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson ALTER COLUMN id SET DEFAULT nextval('public.lesson_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: user_exercise_progress id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_exercise_progress ALTER COLUMN id SET DEFAULT nextval('public.user_exercise_progress_id_seq'::regclass);


--
-- Name: user_language id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_language ALTER COLUMN id SET DEFAULT nextval('public.user_language_id_seq'::regclass);


--
-- Name: user_lesson_progress id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_lesson_progress ALTER COLUMN id SET DEFAULT nextval('public.user_lesson_progress_id_seq'::regclass);


--
-- Name: user_module_progress id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_module_progress ALTER COLUMN id SET DEFAULT nextval('public.user_module_progress_id_seq'::regclass);


--
-- Name: user_progress id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_progress ALTER COLUMN id SET DEFAULT nextval('public.user_progress_id_seq'::regclass);


--
-- Data for Name: alphabet_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alphabet_item (id, letter, transcription, "audioUrl", "exampleWord", "exampleTranslation", "exampleImageUrl", "order", "languageId") FROM stdin;
55	А		/api/files/Буква «А»-5423-205dc374-45c0-4a2b-8f79-feedfec764b2.mp3	\N	\N	\N	1	1
56	Аь		/api/files/Буква «Аь»-5423-60f1e59e-6019-429a-831f-1021ce837b31.mp3	\N	\N	\N	2	1
57	Б		/api/files/Буква «Б»-5423-c3fe2842-f871-412b-a00b-ad3df7ecf69a.mp3	\N	\N	\N	3	1
58	В		/api/files/Буква «В»-5423-8bb3a792-805c-40e8-b459-8d2f1811b712.mp3	\N	\N	\N	4	1
59	Г		/api/files/Буква «Г»-5423-1193d602-b531-49c9-803d-aaecebecf946.mp3	\N	\N	\N	5	1
60	Гъ		/api/files/Буква «Гъ»-5423-cf74ffe0-f10e-4df0-86ca-884feac78dea.mp3	\N	\N	\N	6	1
61	Гь		/api/files/Буква «Гь»-5423-2091eee5-5dbe-4751-877a-23a1a62c79d0.mp3	\N	\N	\N	7	1
62	Д		/api/files/Буква «Д»-5423-1e319ae8-126e-4ac2-9f8e-d4f5a30e2cf2.mp3	\N	\N	\N	8	1
63	Е		/api/files/Буква «Е»-5423-4d6ab352-0953-4809-a866-f4b0b1b86ad1.mp3	\N	\N	\N	9	1
64	Ё		/api/files/Буква «Ё»-5423-58e870b5-f6f2-41b2-a257-2aee2cd2f1d4.mp3	\N	\N	\N	10	1
65	Ж		/api/files/Буква «Ж»-5423-fd96a4e1-8e95-4cd4-96d1-668db06d0c41.mp3	\N	\N	\N	11	1
66	З		/api/files/Буква «З»-5423-61c9fc04-277c-49b9-bede-9772166f4067.mp3	\N	\N	\N	12	1
67	И		/api/files/Буква «И»-5423-5f119fb8-917f-4e9d-9da0-1a1b70123063.mp3	\N	\N	\N	13	1
68	Й		/api/files/Буква «Й»-5423-2f4872d1-1d8a-4ce6-a198-9f94867cdc23.mp3	\N	\N	\N	14	1
69	К		/api/files/Буква «К»-5423-97f7a464-4d30-4b5d-bc3e-11a2a3819b60.mp3	\N	\N	\N	15	1
70	Кк		/api/files/Буква «Кк»-5423-25c969d3-184c-4eb9-842d-ffe9bdf94c80.mp3	\N	\N	\N	16	1
71	Къ		/api/files/Буква «Къ»-5423-1eb4e51c-b457-4f6a-87c8-ee3696a7c2a5.mp3	\N	\N	\N	17	1
72	Кь		/api/files/Буква «Кь»-5423-13b2da0f-d95d-4ed0-a429-dca96f91b8dd.mp3	\N	\N	\N	18	1
73	К1		/api/files/Буква «К1»-5423-2e78f332-f670-4e60-818d-e958fbc4cd94.mp3	\N	\N	\N	19	1
74	Л		/api/files/Буква «Л»-5423-cbf025af-6358-4e23-be0e-7002e284b63d.mp3	\N	\N	\N	20	1
75	М		/api/files/Буква «М»-5423-435c2373-91ae-4748-b5cf-940097d1b7a8.mp3	\N	\N	\N	21	1
76	Н		/api/files/Буква «Н»-5423-aee5829b-9c67-4fa3-83b9-56ca551ac333.mp3	\N	\N	\N	22	1
77	О		/api/files/Буква «О»-5423-7bf93f92-5cc5-4110-843e-57e9c42ceaf9.mp3	\N	\N	\N	23	1
78	Оь		/api/files/Буква «Оь»-5423-cd264ef8-5c98-4f5a-b165-07b004e86c16.mp3	\N	\N	\N	24	1
79	П		/api/files/Буква «П»-5423-7f561bec-69f1-4bb7-a2c9-e0b9aff66b68.mp3	\N	\N	\N	25	1
80	Пп		/api/files/Буква «Пп»-5423-4283434c-b704-40ee-9e97-6f388ede7859.mp3	\N	\N	\N	26	1
81	П1		/api/files/Буква «П1»-5423-caff322e-492e-4c0d-b918-a5b0622828b5.mp3	\N	\N	\N	27	1
82	Р		/api/files/Буква «Р»-5423-2e2f4ea4-c672-4af5-b65b-ace5a01054d2.mp3	\N	\N	\N	28	1
83	С		/api/files/Буква «С»-5423-be00bab7-bbe1-46a7-ac4b-2500524d930d.mp3	\N	\N	\N	29	1
84	Сс		/api/files/Буква «Сс»-5423-3e6ccb4f-c14b-4bf7-bd02-0afce26dfe14.mp3	\N	\N	\N	30	1
85	Т		/api/files/Буква «Т»-5423-e68a61db-0ba8-4bc1-bcc7-f01e19152761.mp3	\N	\N	\N	31	1
86	Тт		/api/files/Буква «Тт»-5423-473f9c67-07ca-463b-8201-12e3fe1321fd.mp3	\N	\N	\N	32	1
87	Т1		/api/files/Буква «Т1»-5423-6da97c11-0886-46ba-8b39-56b49d44184d.mp3	\N	\N	\N	33	1
88	У		/api/files/Буква «У»-5423-97fdb723-9cf0-4966-844b-63e75f7f5979.mp3	\N	\N	\N	34	1
89	Ф		/api/files/Буква «Ф»-5423-382cce9c-2a40-4acb-97b2-397f31f54d7f.mp3	\N	\N	\N	35	1
90	Х		/api/files/Буква «Х»-5423-4f751a03-e198-43b7-bba5-c9737695a787.mp3	\N	\N	\N	36	1
91	Хх		/api/files/Буква «Хх»-5423-d890fffd-39b9-4d6a-8b77-c6a496284be8.mp3	\N	\N	\N	37	1
92	Хъ		/api/files/Буква «Хъ»-5423-3d65370e-4781-41a3-be93-52ad49a163cc.mp3	\N	\N	\N	38	1
93	Хь		/api/files/Буква «Хь»-5423-65f8c597-4f5b-4a4d-9735-a4166a9aeb4b.mp3	\N	\N	\N	39	1
94	Хьхь		/api/files/Буква «Хьхь»-5423-56ed3a41-8b64-42c1-be50-f2cfe9553b23.mp3	\N	\N	\N	40	1
95	Х1		/api/files/Буква «Х1»-5423-77177207-586e-4093-bf68-02c6df00fa2d.mp3	\N	\N	\N	41	1
96	Ц		/api/files/Буква «Ц»-5423-80dcb1e2-16a6-4a3f-9e3f-5c943b7d4dc3.mp3	\N	\N	\N	42	1
97	Цц		/api/files/Буква «Цц»-5423-193a4888-79cb-47ba-a24e-6a213dcd3a0b.mp3	\N	\N	\N	43	1
98	Ц1		/api/files/Буква «Ц1»-5423-ae248115-40e6-4e0d-97a5-da226407afac.mp3	\N	\N	\N	44	1
99	Ч		/api/files/Буква «Ч»-5423-0f4c83ef-9f9c-4ba9-9871-4c63a8192118.mp3	\N	\N	\N	45	1
100	Чч		/api/files/Буква «Чч»-5423-59130039-e4e7-4306-a77d-5758837463dc.mp3	\N	\N	\N	46	1
101	Ч1		/api/files/Буква «Ч1»-5423-3321c0ed-e345-47f1-a2b0-57edd63ad399.mp3	\N	\N	\N	47	1
102	Ш		/api/files/Буква «Ш»-5423-5129fdb5-5b7f-475b-af53-9ad637749666.mp3	\N	\N	\N	48	1
103	Щ		/api/files/Буква «Щ»-5423-217be1e3-58bf-44ef-b954-d2e71c80b649.mp3	\N	\N	\N	49	1
104	Ъ			\N	\N	\N	50	1
105	Ы		/api/files/Буква «Ы»-5423-44822234-d185-44da-970c-58241629e24b.mp3	\N	\N	\N	51	1
106	Ь			\N	\N	\N	52	1
107	Э		/api/files/Буква «Э»-5423-b3936de9-8821-468d-9ed0-d4f23b3a4e74.mp3	\N	\N	\N	53	1
108	Ю		/api/files/Буква «Ю»-5423-58ae8960-c23b-4054-8380-0845496c2736.mp3	\N	\N	\N	54	1
109	Я		/api/files/Буква «Я»-5423-2d879ffc-bc0e-4429-8aaf-dbeec698948b.mp3	\N	\N	\N	55	1
\.


--
-- Data for Name: demo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.demo (cmd_output) FROM stdin;
\.


--
-- Data for Name: exercise; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exercise (id, type, title, instructions, content, points, "order", hints, explanation, "isActive", "createdAt", "lessonId", "languageId") FROM stdin;
5	LISTENING	Задание 5 (Познакомься с буквой «И»)	\N	{"name": "Задание 5 (Познакомься с буквой «И»)", "word": "", "order": "5", "letter": {"id": 13, "order": 13, "letter": "И", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "1", "variants": [{"word": "Ису", "correct": true, "audioUrl": "/api/files/Ису-5423-d495b78d-b8b0-4cfe-95ed-fe28339bbaa7.mp3", "imageUrl": "/api/files/ису – сова-5423-25ab62ce-bd50-442d-874d-66b498b8fc5c.png"}]}	10	5	\N	\N	t	2025-11-26 14:41:11.774946	1	1
6	MULTIPLE_CHOICE	Задание 6 (Выбери слово с буквой «И»)	\N	{"name": "Задание 6 (Выбери слово с буквой «И»)", "word": "", "order": "6", "letter": {"id": 13, "order": 13, "letter": "И", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "1", "variants": [{"word": "Ажари", "correct": false, "audioUrl": "/api/files/Ажари-5423-4fae985d-eb8a-49e9-a567-bab993d1e1a6.mp3", "imageUrl": "/api/files/ажари – петух-5423-eeb08795-825b-4b3b-b11f-27eaf21be608.png"}, {"word": "Ису", "correct": true, "audioUrl": "/api/files/Ису-5423-d495b78d-b8b0-4cfe-95ed-fe28339bbaa7.mp3", "imageUrl": "/api/files/ису – сова-5423-25ab62ce-bd50-442d-874d-66b498b8fc5c.png"}, {"word": "Аьнак1и", "correct": false, "audioUrl": "/api/files/Аьнак1и-5423-145a9194-5325-4fc9-b855-76052ea734cb.mp3", "imageUrl": "/api/files/аьнак1и – курица-5423-6bc282d3-c244-4644-a59a-b4bfdaba5164.png"}]}	10	6	\N	\N	t	2025-11-26 14:41:57.645686	1	1
7	LISTENING	Задание 7 (Познакомься с буквой «Е») 	\N	{"name": "Задание 7 (Познакомься с буквой «Е») ", "word": "", "order": "7", "letter": {"id": 9, "order": 9, "letter": "Е", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "1", "variants": [{"word": "Меч1", "correct": true, "audioUrl": "/api/files/Меч1-5423-b8725c6d-32c1-46af-86ef-49da7ab0ee2a.mp3", "imageUrl": "/api/files/меч1 – крапива-5423-ea80e01c-8946-4d1d-ba12-176949339b74.png"}]}	10	7	\N	\N	t	2025-11-26 14:42:19.573867	1	1
9	LISTENING	Задание 9 (Познакомься с буквой «Й») 	\N	{"name": "Задание 9 (Познакомься с буквой «Й») ", "word": "", "order": "9", "letter": {"id": 14, "order": 14, "letter": "Й", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "1", "variants": [{"word": "Тяй", "correct": true, "audioUrl": "/api/files/Тяй-5423-f9be5d68-d382-4ca9-bc8d-8e42a5299a30.mp3", "imageUrl": "/api/files/тяй – жеребенок-5423-8d6be7c8-bfaa-493b-9d7a-1a541a337935.png"}]}	10	9	\N	\N	t	2025-11-26 14:43:07.643276	1	1
8	MULTIPLE_CHOICE	Задание 8 (Выбери слово с буквой «Е»)	\N	{"name": "Задание 8 (Выбери слово с буквой «Е»)", "word": "", "order": "8", "letter": {"id": 9, "order": 9, "letter": "Е", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "1", "variants": [{"word": "Аьнак1и", "correct": false, "audioUrl": "/api/files/Аьнак1и-5423-145a9194-5325-4fc9-b855-76052ea734cb.mp3", "imageUrl": "/api/files/аьнак1и – курица-5423-6bc282d3-c244-4644-a59a-b4bfdaba5164.png"}, {"word": "Ису", "correct": false, "audioUrl": "/api/files/Ису-5423-d495b78d-b8b0-4cfe-95ed-fe28339bbaa7.mp3", "imageUrl": "/api/files/ису – сова-5423-25ab62ce-bd50-442d-874d-66b498b8fc5c.png"}, {"word": "Меч1", "correct": true, "audioUrl": "/api/files/Меч1-5423-b8725c6d-32c1-46af-86ef-49da7ab0ee2a.mp3", "imageUrl": "/api/files/меч1 – крапива-5423-ea80e01c-8946-4d1d-ba12-176949339b74.png"}]}	10	8	\N	\N	t	2025-11-26 14:42:45.223421	1	1
49	MULTIPLE_CHOICE	Задание 4 (Выбери слово с буквой «Ж»)	\N	{"name": "Задание 4 (Выбери слово с буквой «Ж»)", "word": "", "order": "4", "letter": {"id": 65, "order": 11, "letter": "Ж", "audioUrl": "/api/files/Буква «Ж»-5423-fd96a4e1-8e95-4cd4-96d1-668db06d0c41.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "4", "variants": [{"word": "Зимиз", "correct": false, "audioUrl": "/api/files/Зимиз-5423-9fc2ebb0-4d6b-493e-a603-24d04c632440.mp3", "imageUrl": "/api/files/зимиз – муха -5423-3a2a2c73-11fd-4b4e-8062-a5481de3cc0c.png"}, {"word": "Жулар", "correct": true, "audioUrl": "/api/files/Жулар-5423-033f4ba4-67d6-4733-80a5-f0d9850e4cb6.mp3", "imageUrl": "/api/files/жулар – носок -5423-988b736f-6a14-45fd-8f5d-ad7b7fc60aaf.png"}, {"word": "Дач1у", "correct": false, "audioUrl": "/api/files/Дач1у-5423-d023263e-7278-4ce4-b116-1ba54bb8a29a.mp3", "imageUrl": "/api/files/дач1у – барабан -5423-6154300e-8016-4f0b-80ab-2cd78f1d49e8.png"}]}	10	4	\N	\N	t	2025-11-27 10:16:14.462036	4	1
59	MULTIPLE_CHOICE	Задание 4 (Выбери слово с буквой «Кь»)	\N	{"name": "Задание 4 (Выбери слово с буквой «Кь»)", "word": "", "order": "4", "letter": {"id": 72, "order": 18, "letter": "Кь", "audioUrl": "/api/files/Буква «Кь»-5423-13b2da0f-d95d-4ed0-a429-dca96f91b8dd.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "5", "variants": [{"word": "Маз", "correct": false, "audioUrl": "/api/files/Маз-5423-6df0f25a-9709-41bf-bbdd-7dfd6b93ff19.mp3", "imageUrl": "/api/files/маз – язык -5423-4eaf3e5b-5b87-42d9-bef8-e41ccc5c084e.png"}, {"word": "Кьая", "correct": true, "audioUrl": "/api/files/Кьая-5423-9cf55d89-2f2e-4cd9-9bd6-7fd4421f2c47.mp3", "imageUrl": "/api/files/кьая – редька-5423-22506d23-2672-4532-a093-209d4903c938.png"}, {"word": "Къаз", "correct": false, "audioUrl": "/api/files/Къаз-5423-9d345a0a-ffd9-40f9-a89d-41cbc56a7bc2.mp3", "imageUrl": "/api/files/къаз – гусь -5423-2d9bd2c8-8e7e-4e91-b088-37cd23ef8218.png"}]}	10	4	\N	\N	t	2025-11-27 10:20:54.506516	5	1
68	LISTENING	Задание 3 (Познакомься с буквой «П»)	\N	{"name": "Задание 3 (Познакомься с буквой «П»)", "word": "", "order": "3", "letter": {"id": 79, "order": 25, "letter": "П", "audioUrl": "/api/files/Буква «П»-5423-7f561bec-69f1-4bb7-a2c9-e0b9aff66b68.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "6", "variants": [{"word": "Пил", "correct": true, "audioUrl": "/api/files/Пил-5423-1e467421-f7fe-4ab0-a926-37ff87a5256b.mp3", "imageUrl": "/api/files/пил – слон-5423-294c88cc-959d-4ebf-b728-e68db16f4da2.png"}]}	10	3	\N	\N	t	2025-11-27 10:24:57.514894	6	1
16	LISTENING	Задание 3 (Познакомься с буквой «У»)	\N	{"name": "Задание 3 (Познакомься с буквой «У»)", "word": "", "order": "3", "letter": {"id": 33, "order": 33, "letter": "У", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "2", "variants": [{"word": "Урдак", "correct": true, "audioUrl": "/api/files/Урдак-5423-aaab9cfa-0d6d-4405-a082-62e6ce609ca7.mp3", "imageUrl": "/api/files/урдак – утка-5423-8d677b5d-31d1-484a-857b-3af8809d9608.png"}]}	10	3	\N	\N	t	2025-11-26 15:01:16.370924	2	1
10	MULTIPLE_CHOICE	Задание 10 (Выбери слово с буквой «Й») 	\N	{"name": "Задание 10 (Выбери слово с буквой «Й») ", "word": "", "order": "10", "letter": {"id": 14, "order": 14, "letter": "Й", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "1", "variants": [{"word": "Ажари", "correct": false, "audioUrl": "/api/files/Ажари-5423-4fae985d-eb8a-49e9-a567-bab993d1e1a6.mp3", "imageUrl": "/api/files/ажари – петух-5423-eeb08795-825b-4b3b-b11f-27eaf21be608.png"}, {"word": "Тяй", "correct": true, "audioUrl": "/api/files/Тяй-5423-f9be5d68-d382-4ca9-bc8d-8e42a5299a30.mp3", "imageUrl": "/api/files/тяй – жеребенок-5423-8d6be7c8-bfaa-493b-9d7a-1a541a337935.png"}, {"word": "Ису", "correct": false, "audioUrl": "/api/files/Ису-5423-d495b78d-b8b0-4cfe-95ed-fe28339bbaa7.mp3", "imageUrl": "/api/files/ису – сова-5423-25ab62ce-bd50-442d-874d-66b498b8fc5c.png"}, {"word": "Аьнак1и", "correct": false, "audioUrl": "/api/files/Аьнак1и-5423-145a9194-5325-4fc9-b855-76052ea734cb.mp3", "imageUrl": "/api/files/аьнак1и – курица-5423-6bc282d3-c244-4644-a59a-b4bfdaba5164.png"}]}	10	10	\N	\N	t	2025-11-26 14:43:43.353182	1	1
15	MULTIPLE_CHOICE	Задание 2 (Выбери слово с буквой «Оь»)	\N	{"name": "Задание 2 (Выбери слово с буквой «Оь»)", "word": "", "order": "2", "letter": {"id": 24, "order": 24, "letter": "Оь", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "2", "variants": [{"word": "Аьнак1и", "correct": false, "audioUrl": "/api/files/Аьнак1и-5423-145a9194-5325-4fc9-b855-76052ea734cb.mp3", "imageUrl": "/api/files/аьнак1и – курица-5423-6bc282d3-c244-4644-a59a-b4bfdaba5164.png"}, {"word": "Оьл", "correct": true, "audioUrl": "/api/files/Оьл-5423-5be65dae-9035-41d3-8bcc-39fe7db887fb.mp3", "imageUrl": "/api/files/оьл – корова-5423-94a343b3-c217-4585-b1d1-088d08da4174.png"}, {"word": "Урдак", "correct": false, "audioUrl": "/api/files/Урдак-5423-aaab9cfa-0d6d-4405-a082-62e6ce609ca7.mp3", "imageUrl": "/api/files/урдак – утка-5423-8d677b5d-31d1-484a-857b-3af8809d9608.png"}]}	10	2	\N	\N	t	2025-11-26 15:00:52.626661	2	1
18	LISTENING	Задание 5 (Познакомься с буквой «Я»)	\N	{"name": "Задание 5 (Познакомься с буквой «Я»)", "word": "", "order": "5", "letter": {"id": 54, "order": 54, "letter": "Я", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "2", "variants": [{"word": "Яру", "correct": true, "audioUrl": "/api/files/Яру-5423-e8debc29-7767-4905-b4ca-41d8d7435ab6.mp3", "imageUrl": "/api/files/яру – глаза-5423-ea0d0855-1a66-4103-9f6d-fae76160d6f7.png"}]}	10	5	\N	\N	t	2025-11-26 15:02:18.223586	2	1
22	LISTENING	Задание 9 (Познакомься с буквой «Э»)	\N	{"name": "Задание 9 (Познакомься с буквой «Э»)", "word": "", "order": "9", "letter": {"id": 52, "order": 52, "letter": "Э", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "2", "variants": [{"word": "Экьрав", "correct": true, "audioUrl": "/api/files/Экьрав-5423-cf4158a2-45b7-4d58-b61b-a78522eadc33.mp3", "imageUrl": "/api/files/экьрав – скорпион-5423-c73780d7-d375-48c6-b749-b9ad41ec3164.png"}]}	10	9	\N	\N	t	2025-11-26 15:03:51.144676	2	1
17	MULTIPLE_CHOICE	Задание 4 (Выбери слово с буквой «У»)	\N	{"name": "Задание 4 (Выбери слово с буквой «У»)", "word": "", "order": "4", "letter": {"id": 33, "order": 33, "letter": "У", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "2", "variants": [{"word": "Ажари", "correct": false, "audioUrl": "/api/files/Ажари-5423-4fae985d-eb8a-49e9-a567-bab993d1e1a6.mp3", "imageUrl": "/api/files/ажари – петух-5423-eeb08795-825b-4b3b-b11f-27eaf21be608.png"}, {"word": "Урдак", "correct": true, "audioUrl": "/api/files/Урдак-5423-aaab9cfa-0d6d-4405-a082-62e6ce609ca7.mp3", "imageUrl": "/api/files/урдак – утка-5423-8d677b5d-31d1-484a-857b-3af8809d9608.png"}, {"word": "Оьл", "correct": false, "audioUrl": "/api/files/Оьл-5423-5be65dae-9035-41d3-8bcc-39fe7db887fb.mp3", "imageUrl": "/api/files/оьл – корова-5423-94a343b3-c217-4585-b1d1-088d08da4174.png"}]}	10	4	\N	\N	t	2025-11-26 15:01:58.091001	2	1
19	MULTIPLE_CHOICE	Задание 6 (Выбери слово с буквой «Я»)	\N	{"name": "Задание 6 (Выбери слово с буквой «Я»)", "word": "", "order": "6", "letter": {"id": 54, "order": 54, "letter": "Я", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "2", "variants": [{"word": "Меч1", "correct": false, "audioUrl": "/api/files/Меч1-5423-b8725c6d-32c1-46af-86ef-49da7ab0ee2a.mp3", "imageUrl": "/api/files/меч1 – крапива-5423-ea80e01c-8946-4d1d-ba12-176949339b74.png"}, {"word": "Яру", "correct": true, "audioUrl": "/api/files/Яру-5423-e8debc29-7767-4905-b4ca-41d8d7435ab6.mp3", "imageUrl": "/api/files/яру – глаза-5423-ea0d0855-1a66-4103-9f6d-fae76160d6f7.png"}, {"word": "Тяй", "correct": false, "audioUrl": "/api/files/Тяй-5423-f9be5d68-d382-4ca9-bc8d-8e42a5299a30.mp3", "imageUrl": "/api/files/тяй – жеребенок-5423-8d6be7c8-bfaa-493b-9d7a-1a541a337935.png"}, {"word": "Урдак", "correct": false, "audioUrl": "/api/files/Урдак-5423-aaab9cfa-0d6d-4405-a082-62e6ce609ca7.mp3", "imageUrl": "/api/files/урдак – утка-5423-8d677b5d-31d1-484a-857b-3af8809d9608.png"}]}	10	6	\N	\N	t	2025-11-26 15:02:51.550191	2	1
23	MULTIPLE_CHOICE	Задание 10 (Выбери слово с буквой «Э»)	\N	{"name": "Задание 10 (Выбери слово с буквой «Э»)", "word": "", "order": "10", "letter": {"id": 52, "order": 52, "letter": "Э", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "2", "variants": [{"word": "Меч1", "correct": false, "audioUrl": "/api/files/Меч1-5423-b8725c6d-32c1-46af-86ef-49da7ab0ee2a.mp3", "imageUrl": "/api/files/меч1 – крапива-5423-ea80e01c-8946-4d1d-ba12-176949339b74.png"}, {"word": "Экьрав", "correct": true, "audioUrl": "/api/files/Экьрав-5423-cf4158a2-45b7-4d58-b61b-a78522eadc33.mp3", "imageUrl": "/api/files/экьрав – скорпион-5423-c73780d7-d375-48c6-b749-b9ad41ec3164.png"}, {"word": "Урдак", "correct": false, "audioUrl": "/api/files/Урдак-5423-aaab9cfa-0d6d-4405-a082-62e6ce609ca7.mp3", "imageUrl": "/api/files/урдак – утка-5423-8d677b5d-31d1-484a-857b-3af8809d9608.png"}, {"word": "Аьнак1и", "correct": false, "audioUrl": "/api/files/Аьнак1и-5423-145a9194-5325-4fc9-b855-76052ea734cb.mp3", "imageUrl": "/api/files/аьнак1и – курица-5423-6bc282d3-c244-4644-a59a-b4bfdaba5164.png"}]}	10	10	\N	\N	t	2025-11-26 15:04:19.075646	2	1
27	LISTENING	Задание 1 (Познакомься с буквой «Б»)	\N	{"name": "Задание 1 (Познакомься с буквой «Б»)", "word": "", "order": 1, "letter": {"id": 3, "order": 3, "letter": "Б", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "3", "variants": [{"word": "Бюрх", "correct": true, "audioUrl": "/api/files/Бюрх-5423-e34b1ce4-d465-4b4a-95dc-37d3e90b0d5b.mp3", "imageUrl": "/api/files/бюрх – заяц-5423-fcb9fe42-2ec2-4285-997c-625ac853554c.png"}]}	10	1	\N	\N	t	2025-11-26 15:11:44.973518	3	1
28	LISTENING	Задание 3 (Познакомься с буквой «В»)	\N	{"name": "Задание 3 (Познакомься с буквой «В»)", "word": "", "order": "3", "letter": {"id": 4, "order": 4, "letter": "В", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "3", "variants": [{"word": "Варани", "correct": true, "audioUrl": "/api/files/Варани-5423-d240c8f1-693b-4743-a5e9-69528441fc8d.mp3", "imageUrl": "/api/files/варани – верблюд -5423-ac1e345f-90cd-4262-bdda-906b15ac8158.png"}]}	10	3	\N	\N	t	2025-11-26 15:11:58.961025	3	1
30	LISTENING	Задание 7 (Познакомься с буквой «Гъ»)	\N	{"name": "Задание 7 (Познакомься с буквой «Гъ»)", "word": "", "order": "7", "letter": {"id": 7, "order": 7, "letter": "Гъ", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "3", "variants": [{"word": "Гъангъарат1и", "correct": true, "audioUrl": "/api/files/Гъангъарат1и-5423-a006b9d8-9fcc-47c8-b6ca-bc90c69652c8.mp3", "imageUrl": "/api/files/гъангъарат1и – жук -5423-64c975ef-0b52-4f74-824b-cbde8e47f63f.png"}]}	10	7	\N	\N	t	2025-11-26 15:13:10.354557	3	1
31	LISTENING	Задание 9 (Познакомься с буквой «Гь»)	\N	{"name": "Задание 9 (Познакомься с буквой «Гь»)", "word": "", "order": "9", "letter": {"id": 6, "order": 6, "letter": "Гь", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "3", "variants": [{"word": "Гьивч", "correct": true, "audioUrl": "/api/files/Гьивч-5423-53ae75a7-f970-4121-ad10-5187e78e1ccf.mp3", "imageUrl": "/api/files/гьивч – яблоко -5423-2a30a4b4-1f1b-4ba9-b641-5ce5ac5ccf8b.png"}]}	10	9	\N	\N	t	2025-11-26 15:13:23.716068	3	1
32	MULTIPLE_CHOICE	Задание 2 (Выбери слово с буквой «Б»)	\N	{"name": "Задание 2 (Выбери слово с буквой «Б»)", "word": "", "order": "2", "letter": {"id": 3, "order": 3, "letter": "Б", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "3", "variants": [{"word": "Гюнгут1и", "correct": false, "audioUrl": "/api/files/Гюнгут1и-5423-3062f0ad-cfcb-4401-a889-88d31f5d7cde.mp3", "imageUrl": "/api/files/гюнгут1и – колокольчик -5423-65824ac5-bcfc-4988-a684-bcef7b72c785.png"}, {"word": "Бюрх", "correct": true, "audioUrl": "/api/files/Бюрх-5423-e34b1ce4-d465-4b4a-95dc-37d3e90b0d5b.mp3", "imageUrl": "/api/files/бюрх – заяц-5423-fcb9fe42-2ec2-4285-997c-625ac853554c.png"}, {"word": "Гьивч", "correct": false, "audioUrl": "/api/files/Гьивч-5423-53ae75a7-f970-4121-ad10-5187e78e1ccf.mp3", "imageUrl": "/api/files/гьивч – яблоко -5423-2a30a4b4-1f1b-4ba9-b641-5ce5ac5ccf8b.png"}]}	10	2	\N	\N	t	2025-11-26 15:13:58.602041	3	1
33	MULTIPLE_CHOICE	Задание 4 (Выбери слово с буквой «В»)	\N	{"name": "Задание 4 (Выбери слово с буквой «В»)", "word": "", "order": "4", "letter": {"id": 4, "order": 4, "letter": "В", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "3", "variants": [{"word": "Бюрх", "correct": false, "audioUrl": "/api/files/Бюрх-5423-e34b1ce4-d465-4b4a-95dc-37d3e90b0d5b.mp3", "imageUrl": "/api/files/бюрх – заяц-5423-fcb9fe42-2ec2-4285-997c-625ac853554c.png"}, {"word": "Варани", "correct": true, "audioUrl": "/api/files/Варани-5423-d240c8f1-693b-4743-a5e9-69528441fc8d.mp3", "imageUrl": "/api/files/варани – верблюд -5423-ac1e345f-90cd-4262-bdda-906b15ac8158.png"}, {"word": "Гьивч", "correct": false, "audioUrl": "/api/files/Гьивч-5423-53ae75a7-f970-4121-ad10-5187e78e1ccf.mp3", "imageUrl": "/api/files/гьивч – яблоко -5423-2a30a4b4-1f1b-4ba9-b641-5ce5ac5ccf8b.png"}]}	10	4	\N	\N	t	2025-11-26 15:14:17.481358	3	1
34	MULTIPLE_CHOICE	Задание 6 (Выбери слово с буквой «Г») 	\N	{"name": "Задание 6 (Выбери слово с буквой «Г») ", "word": "", "order": "6", "letter": {"id": 5, "order": 5, "letter": "Г", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "3", "variants": [{"word": "Бюрх", "correct": false, "audioUrl": "/api/files/Бюрх-5423-e34b1ce4-d465-4b4a-95dc-37d3e90b0d5b.mp3", "imageUrl": "/api/files/бюрх – заяц-5423-fcb9fe42-2ec2-4285-997c-625ac853554c.png"}, {"word": "Гюнгут1и", "correct": true, "audioUrl": "/api/files/Гюнгут1и-5423-3062f0ad-cfcb-4401-a889-88d31f5d7cde.mp3", "imageUrl": "/api/files/гюнгут1и – колокольчик -5423-65824ac5-bcfc-4988-a684-bcef7b72c785.png"}, {"word": "Варани", "correct": false, "audioUrl": "/api/files/Варани-5423-d240c8f1-693b-4743-a5e9-69528441fc8d.mp3", "imageUrl": "/api/files/варани – верблюд -5423-ac1e345f-90cd-4262-bdda-906b15ac8158.png"}, {"word": "Гьивч", "correct": false, "audioUrl": "/api/files/Гьивч-5423-53ae75a7-f970-4121-ad10-5187e78e1ccf.mp3", "imageUrl": "/api/files/гьивч – яблоко -5423-2a30a4b4-1f1b-4ba9-b641-5ce5ac5ccf8b.png"}]}	10	6	\N	\N	t	2025-11-26 15:14:47.521014	3	1
36	MULTIPLE_CHOICE	Задание 10 (Выбери слово с буквой «Гь»)	\N	{"name": "Задание 10 (Выбери слово с буквой «Гь»)", "word": "", "order": "10", "letter": {"id": 6, "order": 6, "letter": "Гь", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "3", "variants": [{"word": "Варани", "correct": false, "audioUrl": "/api/files/Варани-5423-d240c8f1-693b-4743-a5e9-69528441fc8d.mp3", "imageUrl": "/api/files/варани – верблюд -5423-ac1e345f-90cd-4262-bdda-906b15ac8158.png"}, {"word": "Гьивч", "correct": true, "audioUrl": "/api/files/Гьивч-5423-53ae75a7-f970-4121-ad10-5187e78e1ccf.mp3", "imageUrl": "/api/files/гьивч – яблоко -5423-2a30a4b4-1f1b-4ba9-b641-5ce5ac5ccf8b.png"}, {"word": "Гъангъарат1и", "correct": false, "audioUrl": "/api/files/Гъангъарат1и-5423-a006b9d8-9fcc-47c8-b6ca-bc90c69652c8.mp3", "imageUrl": "/api/files/гъангъарат1и – жук -5423-64c975ef-0b52-4f74-824b-cbde8e47f63f.png"}, {"word": "Бюрх", "correct": false, "audioUrl": "/api/files/Бюрх-5423-e34b1ce4-d465-4b4a-95dc-37d3e90b0d5b.mp3", "imageUrl": "/api/files/бюрх – заяц-5423-fcb9fe42-2ec2-4285-997c-625ac853554c.png"}]}	10	10	\N	\N	t	2025-11-26 15:15:52.892314	3	1
60	LISTENING	Задание 5 (Познакомься с буквой «К1»)	\N	{"name": "Задание 5 (Познакомься с буквой «К1»)", "word": "", "order": "5", "letter": {"id": 73, "order": 19, "letter": "К1", "audioUrl": "/api/files/Буква «К1»-5423-2e78f332-f670-4e60-818d-e958fbc4cd94.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "5", "variants": [{"word": "К1улу", "correct": true, "audioUrl": "/api/files/К1улу-5423-cc7be8cb-bf3d-4f03-a954-61b1e7a67d35.mp3", "imageUrl": "/api/files/к1улу – мышь-5423-6d23212a-a27b-47f4-81d2-4ef7cf2afc68.png"}]}	10	5	\N	\N	t	2025-11-27 10:21:21.367542	5	1
76	LISTENING	Задание 1 (Познакомься с буквой «С»)	\N	{"name": "Задание 1 (Познакомься с буквой «С»)", "word": "", "order": 1, "letter": {"id": 83, "order": 29, "letter": "С", "audioUrl": "/api/files/Буква «С»-5423-be00bab7-bbe1-46a7-ac4b-2500524d930d.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "7", "variants": [{"word": "Сунув", "correct": true, "audioUrl": "/api/files/Сунув-5423-b1ec48eb-1442-4011-9d12-223c55ceefaa.mp3", "imageUrl": "/api/files/сунув – гранат -5423-47757f19-a541-44ac-a19b-a479b549918b.png"}]}	10	1	\N	\N	t	2025-11-27 10:29:04.38551	7	1
29	LISTENING	Задание 5 (Познакомься с буквой «Г»)	\N	{"name": "Задание 5 (Познакомься с буквой «Г»)", "word": "", "order": "5", "letter": {"id": 5, "order": 5, "letter": "Г", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "3", "variants": [{"word": "Гюнгут1и", "correct": true, "audioUrl": "/api/files/Гюнгут1и-5423-3062f0ad-cfcb-4401-a889-88d31f5d7cde.mp3", "imageUrl": "/api/files/гюнгут1и – колокольчик -5423-65824ac5-bcfc-4988-a684-bcef7b72c785.png"}]}	10	5	\N	\N	t	2025-11-26 15:12:15.635561	3	1
20	LISTENING	Задание 7 (Познакомься с буквой «Ю»)	\N	{"name": "Задание 7 (Познакомься с буквой «Ю»)", "word": "", "order": "7", "letter": {"id": 53, "order": 53, "letter": "Ю", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "2", "variants": [{"word": "Юзбаши", "correct": true, "audioUrl": "/api/files/Юзбаши-5423-32e46037-82f5-410c-8883-b1cd10292d9a.mp3", "imageUrl": "/api/files/юзбаши – аульный староста-5423-ce25193e-5b33-4538-a4cb-42ff17944585.png"}]}	10	7	\N	\N	t	2025-11-26 15:03:10.654918	2	1
14	LISTENING	Задание 1 (Познакомься с буквой «Оь»)	\N	{"name": "Задание 1 (Познакомься с буквой «Оь»)", "word": "", "order": 1, "letter": {"id": 24, "order": 24, "letter": "Оь", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "2", "variants": [{"word": "Оьл", "correct": true, "audioUrl": "/api/files/Оьл-5423-5be65dae-9035-41d3-8bcc-39fe7db887fb.mp3", "imageUrl": "/api/files/оьл – корова-5423-94a343b3-c217-4585-b1d1-088d08da4174.png"}]}	10	1	\N	\N	t	2025-11-26 15:00:15.169031	2	1
1	LISTENING	Задание 1 (Познакомься с буквой «А»)	\N	{"name": "Задание 1 (Познакомься с буквой «А»)", "word": "", "order": 1, "letter": {"id": 55, "order": 1, "letter": "А", "audioUrl": "/api/files/Буква «А»-5423-205dc374-45c0-4a2b-8f79-feedfec764b2.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "1", "variants": [{"word": "Ажари", "correct": true, "audioUrl": "/api/files/Ажари-5423-4fae985d-eb8a-49e9-a567-bab993d1e1a6.mp3", "imageUrl": "/api/files/ажари – петух-5423-eeb08795-825b-4b3b-b11f-27eaf21be608.png"}]}	10	1	\N	\N	t	2025-11-26 14:38:32.739325	1	1
58	LISTENING	Задание 3 (Познакомься с буквой «Кь»)	\N	{"name": "Задание 3 (Познакомься с буквой «Кь»)", "word": "", "order": "3", "letter": {"id": 72, "order": 18, "letter": "Кь", "audioUrl": "/api/files/Буква «Кь»-5423-13b2da0f-d95d-4ed0-a429-dca96f91b8dd.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "5", "variants": [{"word": "Кьая", "correct": true, "audioUrl": "/api/files/Кьая-5423-9cf55d89-2f2e-4cd9-9bd6-7fd4421f2c47.mp3", "imageUrl": "/api/files/кьая – редька-5423-22506d23-2672-4532-a093-209d4903c938.png"}]}	10	3	\N	\N	t	2025-11-27 10:20:12.76612	5	1
84	LISTENING	Задание 9 (Познакомься с буквой «Т1»)	\N	{"name": "Задание 9 (Познакомься с буквой «Т1»)", "word": "", "order": "9", "letter": {"id": 87, "order": 33, "letter": "Т1", "audioUrl": "/api/files/Буква «Т1»-5423-6da97c11-0886-46ba-8b39-56b49d44184d.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "7", "variants": [{"word": "Т1ут1и", "correct": true, "audioUrl": "/api/files/Т1ут1и-5423-1d2c8c3a-935b-4f01-9f9a-724d23a4577c.mp3", "imageUrl": "/api/files/т1ут1и – цветок-5423-09fd4c0e-ac2d-4011-9be0-af0d28c14545.png"}]}	10	9	\N	\N	t	2025-11-27 10:32:04.006868	7	1
92	LISTENING	Задание 7 (Познакомься с буквой «Хь»)	\N	{"name": "Задание 7 (Познакомься с буквой «Хь»)", "word": "", "order": "7", "letter": {"id": 93, "order": 39, "letter": "Хь", "audioUrl": "/api/files/Буква «Хь»-5423-65f8c597-4f5b-4a4d-9735-a4166a9aeb4b.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "8", "variants": [{"word": "Хьама", "correct": true, "audioUrl": "/api/files/Хьама-5423-2179d416-572b-4885-bbd9-9fa3c989e83b.mp3", "imageUrl": "/api/files/хьама – пена -5423-51e6ed2b-ed99-4ca2-9ffa-5ae4add9f5b3.JPG"}]}	10	7	\N	\N	t	2025-11-27 10:35:23.223512	8	1
100	LISTENING	Задание 5 (Познакомься с буквой «Цц»)	\N	{"name": "Задание 5 (Познакомься с буквой «Цц»)", "word": "", "order": "5", "letter": {"id": 97, "order": 43, "letter": "Цц", "audioUrl": "/api/files/Буква «Цц»-5423-193a4888-79cb-47ba-a24e-6a213dcd3a0b.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "9", "variants": [{"word": "Ццацк1улу", "correct": true, "audioUrl": "/api/files/Ццацк1улу-5423-7019adad-1f77-497c-96f4-b22b1c6f307b.mp3", "imageUrl": "/api/files/ццацк1улу – еж -5423-569c58e3-41a7-494f-ae4d-fe4ab0b9dbb9.JPG"}]}	10	5	\N	\N	t	2025-11-27 10:38:48.821916	9	1
38	LISTENING	Задание 3 (Познакомься с буквой «Аь»)	\N	{"name": "Задание 3 (Познакомься с буквой «Аь»)", "word": "", "order": "3", "letter": {"id": 56, "order": 2, "letter": "Аь", "audioUrl": "/api/files/Буква «Аь»-5423-60f1e59e-6019-429a-831f-1021ce837b31.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "1", "variants": [{"word": "Аьнак1и", "correct": true, "audioUrl": "/api/files/Аьнак1и-5423-145a9194-5325-4fc9-b855-76052ea734cb.mp3", "imageUrl": "/api/files/аьнак1и – курица-5423-6bc282d3-c244-4644-a59a-b4bfdaba5164.png"}]}	10	3	\N	\N	t	2025-11-27 09:41:49.176188	1	1
4	MULTIPLE_CHOICE	Задание 4 (Выбери слово с буквой «Аь»)	\N	{"name": "Задание 4 (Выбери слово с буквой «Аь»)", "word": "", "order": "4", "letter": {"id": 2, "order": 2, "letter": "Аь", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "1", "variants": [{"word": "Ажари", "correct": false, "audioUrl": "/api/files/Ажари-5423-4fae985d-eb8a-49e9-a567-bab993d1e1a6.mp3", "imageUrl": "/api/files/ажари – петух-5423-eeb08795-825b-4b3b-b11f-27eaf21be608.png"}, {"word": "Аьнак1и", "correct": true, "audioUrl": "/api/files/Аьнак1и-5423-145a9194-5325-4fc9-b855-76052ea734cb.mp3", "imageUrl": "/api/files/аьнак1и – курица-5423-6bc282d3-c244-4644-a59a-b4bfdaba5164.png"}]}	10	4	\N	\N	t	2025-11-26 14:40:41.956934	1	1
39	MULTIPLE_CHOICE	Задание 2 (Выбери слово с буквой «А»)	\N	{"name": "Задание 2 (Выбери слово с буквой «А»)", "word": "", "order": "2", "letter": {"id": 55, "order": 1, "letter": "А", "audioUrl": "/api/files/Буква «А»-5423-205dc374-45c0-4a2b-8f79-feedfec764b2.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "1", "variants": [{"word": "Аьнак1и", "correct": false, "audioUrl": "/api/files/Аьнак1и-5423-145a9194-5325-4fc9-b855-76052ea734cb.mp3", "imageUrl": "/api/files/аьнак1и – курица-5423-6bc282d3-c244-4644-a59a-b4bfdaba5164.png"}, {"word": "Ажари", "correct": true, "audioUrl": "/api/files/Ажари-5423-4fae985d-eb8a-49e9-a567-bab993d1e1a6.mp3", "imageUrl": "/api/files/ажари – петух-5423-eeb08795-825b-4b3b-b11f-27eaf21be608.png"}, {"word": "Ису", "correct": false, "audioUrl": "/api/files/Ису-5423-d495b78d-b8b0-4cfe-95ed-fe28339bbaa7.mp3", "imageUrl": "/api/files/ису – сова-5423-25ab62ce-bd50-442d-874d-66b498b8fc5c.png"}]}	10	2	\N	\N	t	2025-11-27 09:45:20.38341	1	1
21	MULTIPLE_CHOICE	Задание 8 (Выбери слово с буквой «Ю»)	\N	{"name": "Задание 8 (Выбери слово с буквой «Ю»)", "word": "", "order": "8", "letter": {"id": 53, "order": 53, "letter": "Ю", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "2", "variants": [{"word": "Яру", "correct": false, "audioUrl": "/api/files/Яру-5423-e8debc29-7767-4905-b4ca-41d8d7435ab6.mp3", "imageUrl": "/api/files/яру – глаза-5423-ea0d0855-1a66-4103-9f6d-fae76160d6f7.png"}, {"word": "Урдак", "correct": false, "audioUrl": "/api/files/Урдак-5423-aaab9cfa-0d6d-4405-a082-62e6ce609ca7.mp3", "imageUrl": "/api/files/урдак – утка-5423-8d677b5d-31d1-484a-857b-3af8809d9608.png"}, {"word": "Юзбаши", "correct": true, "audioUrl": "/api/files/Юзбаши-5423-32e46037-82f5-410c-8883-b1cd10292d9a.mp3", "imageUrl": "/api/files/юзбаши – аульный староста-5423-ce25193e-5b33-4538-a4cb-42ff17944585.png"}, {"word": "Оьл", "correct": false, "audioUrl": "/api/files/Оьл-5423-5be65dae-9035-41d3-8bcc-39fe7db887fb.mp3", "imageUrl": "/api/files/оьл – корова-5423-94a343b3-c217-4585-b1d1-088d08da4174.png"}]}	10	8	\N	\N	t	2025-11-26 15:03:34.960088	2	1
35	MULTIPLE_CHOICE	Задание 8 (Выбери слово с буквой «Гъ»)	\N	{"name": "Задание 8 (Выбери слово с буквой «Гъ»)", "word": "", "order": "8", "letter": {"id": 7, "order": 7, "letter": "Гъ", "audioUrl": "/api/files/1.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "3", "variants": [{"word": "Бюрх", "correct": false, "audioUrl": "/api/files/Бюрх-5423-e34b1ce4-d465-4b4a-95dc-37d3e90b0d5b.mp3", "imageUrl": "/api/files/бюрх – заяц-5423-fcb9fe42-2ec2-4285-997c-625ac853554c.png"}, {"word": "Варани", "correct": false, "audioUrl": "/api/files/Варани-5423-d240c8f1-693b-4743-a5e9-69528441fc8d.mp3", "imageUrl": "/api/files/варани – верблюд -5423-ac1e345f-90cd-4262-bdda-906b15ac8158.png"}, {"word": "Гъангъарат1и", "correct": true, "audioUrl": "/api/files/Гъангъарат1и-5423-a006b9d8-9fcc-47c8-b6ca-bc90c69652c8.mp3", "imageUrl": "/api/files/гъангъарат1и – жук -5423-64c975ef-0b52-4f74-824b-cbde8e47f63f.png"}, {"word": "Гюнгут1и", "correct": false, "audioUrl": "/api/files/Гюнгут1и-5423-3062f0ad-cfcb-4401-a889-88d31f5d7cde.mp3", "imageUrl": "/api/files/гюнгут1и – колокольчик -5423-65824ac5-bcfc-4988-a684-bcef7b72c785.png"}]}	10	8	\N	\N	t	2025-11-26 15:15:30.319013	3	1
40	MATCHING	Задание 11 (Найди пару)	\N	{"left": {"isLetter": true, "onlyAudio": false}, "name": "Задание 11 (Найди пару)", "word": "", "order": "11", "pairs": [{"id": "7c9d208b-a439-43f6-9c47-a55d2d736c70", "left": {"value": "А", "audioUrl": "/api/files/Буква «А»-5423-205dc374-45c0-4a2b-8f79-feedfec764b2.mp3"}, "right": {"value": "ажари"}}, {"id": "fd09d281-3e29-4d9a-b669-d877ccf73dfd", "left": {"value": "Е", "audioUrl": "/api/files/Буква «Е»-5423-4d6ab352-0953-4809-a866-f4b0b1b86ad1.mp3"}, "right": {"value": "меч1"}}, {"id": "36d806b0-4573-4e93-a039-5450805c99b5", "left": {"value": "И", "audioUrl": "/api/files/Буква «И»-5423-5f119fb8-917f-4e9d-9da0-1a1b70123063.mp3"}, "right": {"value": "ису"}}, {"id": "9ff50192-08c7-4b8e-a84c-bc8d35773e3f", "left": {"value": "Й", "audioUrl": "/api/files/Буква «Й»-5423-2f4872d1-1d8a-4ce6-a198-9f94867cdc23.mp3"}, "right": {"value": "тяй"}}, {"id": "219eeb64-b252-47d8-9a18-0d3695f77416", "left": {"value": "Аь", "audioUrl": "/api/files/Буква «Аь»-5423-60f1e59e-6019-429a-831f-1021ce837b31.mp3"}, "right": {"value": "аьнак1и"}}], "right": {"isLetter": false, "onlyAudio": false}, "lessonId": "1"}	10	11	\N	\N	t	2025-11-27 09:58:49.667262	1	1
43	MATCHING	Задание 11 (Найди пару)	\N	{"left": {"isLetter": true, "onlyAudio": false}, "name": "Задание 11 (Найди пару)", "word": "", "order": "11", "pairs": [{"id": "116d9e26-8e28-42ce-9cfd-adf0ea971bbb", "left": {"value": "У", "audioUrl": "/api/files/Буква «У»-5423-97fdb723-9cf0-4966-844b-63e75f7f5979.mp3"}, "right": {"value": "урдак"}}, {"id": "63a266bc-ee72-486d-a25b-9a5e6c82f824", "left": {"value": "Оь", "audioUrl": "/api/files/Буква «Оь»-5423-cd264ef8-5c98-4f5a-b165-07b004e86c16.mp3"}, "right": {"value": "оьл"}}, {"id": "013ec4f0-79e9-450c-a219-05b55c5c5767", "left": {"value": "А", "audioUrl": "/api/files/Буква «А»-5423-205dc374-45c0-4a2b-8f79-feedfec764b2.mp3"}, "right": {"value": "ажари"}}, {"id": "6b92d7eb-83f3-4a5e-8e91-b027283cd306", "left": {"value": "Е", "audioUrl": "/api/files/Буква «Е»-5423-4d6ab352-0953-4809-a866-f4b0b1b86ad1.mp3"}, "right": {"value": "меч1"}}, {"id": "c65a27cb-1004-450a-b2e4-1c7fd04a1335", "left": {"value": "И", "audioUrl": "/api/files/Буква «И»-5423-5f119fb8-917f-4e9d-9da0-1a1b70123063.mp3"}, "right": {"value": "ису"}}, {"id": "97bcefcd-c6c6-414f-9760-74cf32fa2106", "left": {"value": "Й", "audioUrl": "/api/files/Буква «Й»-5423-2f4872d1-1d8a-4ce6-a198-9f94867cdc23.mp3"}, "right": {"value": "тяй"}}, {"id": "d19f61e9-506a-41a9-a1fd-e3ed5ff7e6e8", "left": {"value": "Аь", "audioUrl": "/api/files/Буква «Аь»-5423-60f1e59e-6019-429a-831f-1021ce837b31.mp3"}, "right": {"value": "аьнак1и"}}, {"id": "a21b7db5-a409-41cd-81b7-c43d390e4729", "left": {"value": "Я", "audioUrl": "/api/files/Буква «Я»-5423-2d879ffc-bc0e-4429-8aaf-dbeec698948b.mp3"}, "right": {"value": "яру"}}, {"id": "7dc54eef-9421-451f-bbc9-0020db5ca24f", "left": {"value": "Э", "audioUrl": "/api/files/Буква «Э»-5423-b3936de9-8821-468d-9ed0-d4f23b3a4e74.mp3"}, "right": {"value": "экьрав"}}, {"id": "46440c53-4310-4677-9ff9-84a9ebd60bc0", "left": {"value": "Ю", "audioUrl": "/api/files/Буква «Ю»-5423-58ae8960-c23b-4054-8380-0845496c2736.mp3"}, "right": {"value": "юзбаши"}}], "right": {"isLetter": false, "onlyAudio": false}, "lessonId": "2"}	10	11	\N	\N	t	2025-11-27 10:02:17.751028	2	1
46	LISTENING	Задание 1 (Познакомься с буквой «Д»)	\N	{"name": "Задание 1 (Познакомься с буквой «Д»)", "word": "", "order": 1, "letter": {"id": 62, "order": 8, "letter": "Д", "audioUrl": "/api/files/Буква «Д»-5423-1e319ae8-126e-4ac2-9f8e-d4f5a30e2cf2.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "4", "variants": [{"word": "Дач1у", "correct": true, "audioUrl": "/api/files/Дач1у-5423-d023263e-7278-4ce4-b116-1ba54bb8a29a.mp3", "imageUrl": "/api/files/дач1у – барабан -5423-6154300e-8016-4f0b-80ab-2cd78f1d49e8.png"}]}	10	1	\N	\N	t	2025-11-27 10:15:02.292817	4	1
47	MULTIPLE_CHOICE	Задание 2 (Выбери слово с буквой «Д»)	\N	{"name": "Задание 2 (Выбери слово с буквой «Д»)", "word": "", "order": "2", "letter": {"id": 62, "order": 8, "letter": "Д", "audioUrl": "/api/files/Буква «Д»-5423-1e319ae8-126e-4ac2-9f8e-d4f5a30e2cf2.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "4", "variants": [{"word": "Ккунук", "correct": false, "audioUrl": "/api/files/Ккунук-5423-e29eacd5-d889-4a9c-a1f5-d4b53c83d9db.mp3", "imageUrl": "/api/files/ккунук – яйцо -5423-2fbeeb23-1931-41d8-be6d-7290c1ef6f75.png"}, {"word": "Дач1у", "correct": true, "audioUrl": "/api/files/Дач1у-5423-d023263e-7278-4ce4-b116-1ba54bb8a29a.mp3", "imageUrl": "/api/files/дач1у – барабан -5423-6154300e-8016-4f0b-80ab-2cd78f1d49e8.png"}, {"word": "Жулар", "correct": false, "audioUrl": "/api/files/Жулар-5423-033f4ba4-67d6-4733-80a5-f0d9850e4cb6.mp3", "imageUrl": "/api/files/жулар – носок -5423-988b736f-6a14-45fd-8f5d-ad7b7fc60aaf.png"}]}	10	2	\N	\N	t	2025-11-27 10:15:34.298574	4	1
48	LISTENING	Задание 3 (Познакомься с буквой «Ж»)	\N	{"name": "Задание 3 (Познакомься с буквой «Ж»)", "word": "", "order": "3", "letter": {"id": 65, "order": 11, "letter": "Ж", "audioUrl": "/api/files/Буква «Ж»-5423-fd96a4e1-8e95-4cd4-96d1-668db06d0c41.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "4", "variants": [{"word": "Жулар", "correct": true, "audioUrl": "/api/files/Жулар-5423-033f4ba4-67d6-4733-80a5-f0d9850e4cb6.mp3", "imageUrl": "/api/files/жулар – носок -5423-988b736f-6a14-45fd-8f5d-ad7b7fc60aaf.png"}]}	10	3	\N	\N	t	2025-11-27 10:15:51.634509	4	1
50	LISTENING	Задание 5 (Познакомься с буквой «З»)	\N	{"name": "Задание 5 (Познакомься с буквой «З»)", "word": "", "order": "5", "letter": {"id": 66, "order": 12, "letter": "З", "audioUrl": "/api/files/Буква «З»-5423-61c9fc04-277c-49b9-bede-9772166f4067.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "4", "variants": [{"word": "Зимиз", "correct": true, "audioUrl": "/api/files/Зимиз-5423-9fc2ebb0-4d6b-493e-a603-24d04c632440.mp3", "imageUrl": "/api/files/зимиз – муха -5423-3a2a2c73-11fd-4b4e-8062-a5481de3cc0c.png"}]}	10	5	\N	\N	t	2025-11-27 10:16:30.853516	4	1
51	MULTIPLE_CHOICE	Задание 6 (Выбери слово с буквой «З»)	\N	{"name": "Задание 6 (Выбери слово с буквой «З»)", "word": "", "order": "6", "letter": {"id": 66, "order": 12, "letter": "З", "audioUrl": "/api/files/Буква «З»-5423-61c9fc04-277c-49b9-bede-9772166f4067.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "4", "variants": [{"word": "Ккунук", "correct": false, "audioUrl": "/api/files/Ккунук-5423-e29eacd5-d889-4a9c-a1f5-d4b53c83d9db.mp3", "imageUrl": "/api/files/ккунук – яйцо -5423-2fbeeb23-1931-41d8-be6d-7290c1ef6f75.png"}, {"word": "Зимиз", "correct": true, "audioUrl": "/api/files/Зимиз-5423-9fc2ebb0-4d6b-493e-a603-24d04c632440.mp3", "imageUrl": "/api/files/зимиз – муха -5423-3a2a2c73-11fd-4b4e-8062-a5481de3cc0c.png"}, {"word": "Ка", "correct": false, "audioUrl": "/api/files/Ка-5423-58a6f62d-e223-4ffd-8e16-0eb1fb05b8ce.mp3", "imageUrl": "/api/files/ка – рука -5423-a7fc0feb-1ae9-4db0-8180-dfbcac12388c.png"}, {"word": "Жулар", "correct": false, "audioUrl": "/api/files/Жулар-5423-033f4ba4-67d6-4733-80a5-f0d9850e4cb6.mp3", "imageUrl": "/api/files/жулар – носок -5423-988b736f-6a14-45fd-8f5d-ad7b7fc60aaf.png"}]}	10	6	\N	\N	t	2025-11-27 10:17:00.587538	4	1
52	LISTENING	Задание 7 (Познакомься с буквой «К»)	\N	{"name": "Задание 7 (Познакомься с буквой «К»)", "word": "", "order": "7", "letter": {"id": 69, "order": 15, "letter": "К", "audioUrl": "/api/files/Буква «К»-5423-97f7a464-4d30-4b5d-bc3e-11a2a3819b60.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "4", "variants": [{"word": "Ка", "correct": true, "audioUrl": "/api/files/Ка-5423-58a6f62d-e223-4ffd-8e16-0eb1fb05b8ce.mp3", "imageUrl": "/api/files/ка – рука -5423-a7fc0feb-1ae9-4db0-8180-dfbcac12388c.png"}]}	10	7	\N	\N	t	2025-11-27 10:17:19.784516	4	1
53	MULTIPLE_CHOICE	Задание 8 (Выбери слово с буквой «К»)	\N	{"name": "Задание 8 (Выбери слово с буквой «К»)", "word": "", "order": "8", "letter": {"id": 69, "order": 15, "letter": "К", "audioUrl": "/api/files/Буква «К»-5423-97f7a464-4d30-4b5d-bc3e-11a2a3819b60.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "4", "variants": [{"word": "Жулар", "correct": false, "audioUrl": "/api/files/Жулар-5423-033f4ba4-67d6-4733-80a5-f0d9850e4cb6.mp3", "imageUrl": "/api/files/жулар – носок -5423-988b736f-6a14-45fd-8f5d-ad7b7fc60aaf.png"}, {"word": "Дач1у", "correct": false, "audioUrl": "/api/files/Дач1у-5423-d023263e-7278-4ce4-b116-1ba54bb8a29a.mp3", "imageUrl": "/api/files/дач1у – барабан -5423-6154300e-8016-4f0b-80ab-2cd78f1d49e8.png"}, {"word": "Ка", "correct": true, "audioUrl": "/api/files/Ка-5423-58a6f62d-e223-4ffd-8e16-0eb1fb05b8ce.mp3", "imageUrl": "/api/files/ка – рука -5423-a7fc0feb-1ae9-4db0-8180-dfbcac12388c.png"}, {"word": "Зимиз", "correct": false, "audioUrl": "/api/files/Зимиз-5423-9fc2ebb0-4d6b-493e-a603-24d04c632440.mp3", "imageUrl": "/api/files/зимиз – муха -5423-3a2a2c73-11fd-4b4e-8062-a5481de3cc0c.png"}]}	10	8	\N	\N	t	2025-11-27 10:18:03.103541	4	1
54	LISTENING	Задание 9 (Познакомься с буквой «Кк»)	\N	{"name": "Задание 9 (Познакомься с буквой «Кк»)", "word": "", "order": "9", "letter": {"id": 70, "order": 16, "letter": "Кк", "audioUrl": "/api/files/Буква «Кк»-5423-25c969d3-184c-4eb9-842d-ffe9bdf94c80.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "4", "variants": [{"word": "Ккунук", "correct": true, "audioUrl": "/api/files/Ккунук-5423-e29eacd5-d889-4a9c-a1f5-d4b53c83d9db.mp3", "imageUrl": "/api/files/ккунук – яйцо -5423-2fbeeb23-1931-41d8-be6d-7290c1ef6f75.png"}]}	10	9	\N	\N	t	2025-11-27 10:18:23.076287	4	1
55	MULTIPLE_CHOICE	Задание 10 (Выбери слово с буквой «Кк») 	\N	{"name": "Задание 10 (Выбери слово с буквой «Кк») ", "word": "", "order": "10", "letter": {"id": 70, "order": 16, "letter": "Кк", "audioUrl": "/api/files/Буква «Кк»-5423-25c969d3-184c-4eb9-842d-ffe9bdf94c80.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "4", "variants": [{"word": "Дач1у", "correct": false, "audioUrl": "/api/files/Дач1у-5423-d023263e-7278-4ce4-b116-1ba54bb8a29a.mp3", "imageUrl": "/api/files/дач1у – барабан -5423-6154300e-8016-4f0b-80ab-2cd78f1d49e8.png"}, {"word": "Ккунук", "correct": true, "audioUrl": "/api/files/Ккунук-5423-e29eacd5-d889-4a9c-a1f5-d4b53c83d9db.mp3", "imageUrl": "/api/files/ккунук – яйцо -5423-2fbeeb23-1931-41d8-be6d-7290c1ef6f75.png"}, {"word": "Зимиз", "correct": false, "audioUrl": "/api/files/Зимиз-5423-9fc2ebb0-4d6b-493e-a603-24d04c632440.mp3", "imageUrl": "/api/files/зимиз – муха -5423-3a2a2c73-11fd-4b4e-8062-a5481de3cc0c.png"}, {"word": "Ка", "correct": false, "audioUrl": "/api/files/Ка-5423-58a6f62d-e223-4ffd-8e16-0eb1fb05b8ce.mp3", "imageUrl": "/api/files/ка – рука -5423-a7fc0feb-1ae9-4db0-8180-dfbcac12388c.png"}]}	10	10	\N	\N	t	2025-11-27 10:18:55.259962	4	1
56	LISTENING	Задание 1 (Познакомься с буквой «Къ»)	\N	{"name": "Задание 1 (Познакомься с буквой «Къ»)", "word": "", "order": 1, "letter": {"id": 71, "order": 17, "letter": "Къ", "audioUrl": "/api/files/Буква «Къ»-5423-1eb4e51c-b457-4f6a-87c8-ee3696a7c2a5.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "5", "variants": [{"word": "Къаз", "correct": true, "audioUrl": "/api/files/Къаз-5423-9d345a0a-ffd9-40f9-a89d-41cbc56a7bc2.mp3", "imageUrl": "/api/files/къаз – гусь -5423-2d9bd2c8-8e7e-4e91-b088-37cd23ef8218.png"}]}	10	1	\N	\N	t	2025-11-27 10:19:25.587215	5	1
57	MULTIPLE_CHOICE	Задание 2 (Выбери слово с буквой «Къ»)	\N	{"name": "Задание 2 (Выбери слово с буквой «Къ»)", "word": "", "order": "2", "letter": {"id": 71, "order": 17, "letter": "Къ", "audioUrl": "/api/files/Буква «Къ»-5423-1eb4e51c-b457-4f6a-87c8-ee3696a7c2a5.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "5", "variants": [{"word": "Кьая", "correct": false, "audioUrl": "/api/files/Кьая-5423-9cf55d89-2f2e-4cd9-9bd6-7fd4421f2c47.mp3", "imageUrl": "/api/files/кьая – редька-5423-22506d23-2672-4532-a093-209d4903c938.png"}, {"word": "Къаз", "correct": true, "audioUrl": "/api/files/Къаз-5423-9d345a0a-ffd9-40f9-a89d-41cbc56a7bc2.mp3", "imageUrl": "/api/files/къаз – гусь -5423-2d9bd2c8-8e7e-4e91-b088-37cd23ef8218.png"}, {"word": "К1улу", "correct": false, "audioUrl": "/api/files/К1улу-5423-cc7be8cb-bf3d-4f03-a954-61b1e7a67d35.mp3", "imageUrl": "/api/files/к1улу – мышь-5423-6d23212a-a27b-47f4-81d2-4ef7cf2afc68.png"}]}	10	2	\N	\N	t	2025-11-27 10:19:53.720829	5	1
61	MULTIPLE_CHOICE	Задание 6 (Выбери слово с буквой «К1») 	\N	{"name": "Задание 6 (Выбери слово с буквой «К1») ", "word": "", "order": "6", "letter": {"id": 73, "order": 19, "letter": "К1", "audioUrl": "/api/files/Буква «К1»-5423-2e78f332-f670-4e60-818d-e958fbc4cd94.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "5", "variants": [{"word": "Къаз", "correct": false, "audioUrl": "/api/files/Къаз-5423-9d345a0a-ffd9-40f9-a89d-41cbc56a7bc2.mp3", "imageUrl": "/api/files/къаз – гусь -5423-2d9bd2c8-8e7e-4e91-b088-37cd23ef8218.png"}, {"word": "К1улу", "correct": true, "audioUrl": "/api/files/К1улу-5423-cc7be8cb-bf3d-4f03-a954-61b1e7a67d35.mp3", "imageUrl": "/api/files/к1улу – мышь-5423-6d23212a-a27b-47f4-81d2-4ef7cf2afc68.png"}, {"word": "Маз", "correct": false, "audioUrl": "/api/files/Маз-5423-6df0f25a-9709-41bf-bbdd-7dfd6b93ff19.mp3", "imageUrl": "/api/files/маз – язык -5423-4eaf3e5b-5b87-42d9-bef8-e41ccc5c084e.png"}, {"word": "Кьая", "correct": false, "audioUrl": "/api/files/Кьая-5423-9cf55d89-2f2e-4cd9-9bd6-7fd4421f2c47.mp3", "imageUrl": "/api/files/кьая – редька-5423-22506d23-2672-4532-a093-209d4903c938.png"}]}	10	6	\N	\N	t	2025-11-27 10:21:48.131508	5	1
62	LISTENING	Задание 7 (Познакомься с буквой «Л»)	\N	{"name": "Задание 7 (Познакомься с буквой «Л»)", "word": "", "order": "7", "letter": {"id": 74, "order": 20, "letter": "Л", "audioUrl": "/api/files/Буква «Л»-5423-cbf025af-6358-4e23-be0e-7002e284b63d.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "5", "variants": [{"word": "Лу", "correct": true, "audioUrl": "/api/files/Лу-5423-51c358a4-04e0-48c6-916c-e773bec81a25.mp3", "imageUrl": "/api/files/лу – книга -5423-cc1025eb-74c2-4156-a7c5-6551f9e082b5.png"}]}	10	7	\N	\N	t	2025-11-27 10:22:09.545513	5	1
63	MULTIPLE_CHOICE	Задание 8 (Выбери слово с буквой «Л»)	\N	{"name": "Задание 8 (Выбери слово с буквой «Л»)", "word": "", "order": "8", "letter": {"id": 74, "order": 20, "letter": "Л", "audioUrl": "/api/files/Буква «Л»-5423-cbf025af-6358-4e23-be0e-7002e284b63d.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "5", "variants": [{"word": "Кьая", "correct": false, "audioUrl": "/api/files/Кьая-5423-9cf55d89-2f2e-4cd9-9bd6-7fd4421f2c47.mp3", "imageUrl": "/api/files/кьая – редька-5423-22506d23-2672-4532-a093-209d4903c938.png"}, {"word": "Къаз", "correct": false, "audioUrl": "/api/files/Къаз-5423-9d345a0a-ffd9-40f9-a89d-41cbc56a7bc2.mp3", "imageUrl": "/api/files/къаз – гусь -5423-2d9bd2c8-8e7e-4e91-b088-37cd23ef8218.png"}, {"word": "Лу", "correct": true, "audioUrl": "/api/files/Лу-5423-51c358a4-04e0-48c6-916c-e773bec81a25.mp3", "imageUrl": "/api/files/лу – книга -5423-cc1025eb-74c2-4156-a7c5-6551f9e082b5.png"}, {"word": "Маз", "correct": false, "audioUrl": "/api/files/Маз-5423-6df0f25a-9709-41bf-bbdd-7dfd6b93ff19.mp3", "imageUrl": "/api/files/маз – язык -5423-4eaf3e5b-5b87-42d9-bef8-e41ccc5c084e.png"}]}	10	8	\N	\N	t	2025-11-27 10:22:35.016846	5	1
64	LISTENING	Задание 9 (Познакомься с буквой «М»)	\N	{"name": "Задание 9 (Познакомься с буквой «М»)", "word": "", "order": "9", "letter": {"id": 75, "order": 21, "letter": "М", "audioUrl": "/api/files/Буква «М»-5423-435c2373-91ae-4748-b5cf-940097d1b7a8.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "5", "variants": [{"word": "Маз", "correct": true, "audioUrl": "/api/files/Маз-5423-6df0f25a-9709-41bf-bbdd-7dfd6b93ff19.mp3", "imageUrl": "/api/files/маз – язык -5423-4eaf3e5b-5b87-42d9-bef8-e41ccc5c084e.png"}]}	10	9	\N	\N	t	2025-11-27 10:22:51.702937	5	1
65	MULTIPLE_CHOICE	Задание 10 (Выбери слово с буквой «М»)	\N	{"name": "Задание 10 (Выбери слово с буквой «М»)", "word": "", "order": "10", "letter": {"id": 75, "order": 21, "letter": "М", "audioUrl": "/api/files/Буква «М»-5423-435c2373-91ae-4748-b5cf-940097d1b7a8.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "5", "variants": [{"word": "Лу", "correct": false, "audioUrl": "/api/files/Лу-5423-51c358a4-04e0-48c6-916c-e773bec81a25.mp3", "imageUrl": "/api/files/лу – книга -5423-cc1025eb-74c2-4156-a7c5-6551f9e082b5.png"}, {"word": "Маз", "correct": true, "audioUrl": "/api/files/Маз-5423-6df0f25a-9709-41bf-bbdd-7dfd6b93ff19.mp3", "imageUrl": "/api/files/маз – язык -5423-4eaf3e5b-5b87-42d9-bef8-e41ccc5c084e.png"}, {"word": "Кьая", "correct": false, "audioUrl": "/api/files/Кьая-5423-9cf55d89-2f2e-4cd9-9bd6-7fd4421f2c47.mp3", "imageUrl": "/api/files/кьая – редька-5423-22506d23-2672-4532-a093-209d4903c938.png"}, {"word": "Къаз", "correct": false, "audioUrl": "/api/files/Къаз-5423-9d345a0a-ffd9-40f9-a89d-41cbc56a7bc2.mp3", "imageUrl": "/api/files/къаз – гусь -5423-2d9bd2c8-8e7e-4e91-b088-37cd23ef8218.png"}]}	10	10	\N	\N	t	2025-11-27 10:23:20.757514	5	1
66	LISTENING	Задание 1 (Познакомься с буквой «Н»)	\N	{"name": "Задание 1 (Познакомься с буквой «Н»)", "word": "", "order": 1, "letter": {"id": 76, "order": 22, "letter": "Н", "audioUrl": "/api/files/Буква «Н»-5423-aee5829b-9c67-4fa3-83b9-56ca551ac333.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "6", "variants": [{"word": "Нисварти", "correct": true, "audioUrl": "/api/files/Нисварти-5423-ad262047-12e7-4316-91ae-3c4716980ed6.mp3", "imageUrl": "/api/files/нисварти – огурец -5423-58b5c08c-168c-4cc9-8f11-a5af74d28ec8.png"}]}	10	1	\N	\N	t	2025-11-27 10:24:14.872511	6	1
67	MULTIPLE_CHOICE	Задание 2 (Выбери слово с буквой «Н»)	\N	{"name": "Задание 2 (Выбери слово с буквой «Н»)", "word": "", "order": "2", "letter": {"id": 76, "order": 22, "letter": "Н", "audioUrl": "/api/files/Буква «Н»-5423-aee5829b-9c67-4fa3-83b9-56ca551ac333.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "6", "variants": [{"word": "Пил", "correct": false, "audioUrl": "/api/files/Пил-5423-1e467421-f7fe-4ab0-a926-37ff87a5256b.mp3", "imageUrl": "/api/files/пил – слон-5423-294c88cc-959d-4ebf-b728-e68db16f4da2.png"}, {"word": "Нисварти", "correct": true, "audioUrl": "/api/files/Нисварти-5423-ad262047-12e7-4316-91ae-3c4716980ed6.mp3", "imageUrl": "/api/files/нисварти – огурец -5423-58b5c08c-168c-4cc9-8f11-a5af74d28ec8.png"}, {"word": "Рах1у", "correct": false, "audioUrl": "/api/files/Рах1у-5423-c278504c-3c51-4569-a3a6-31fb6f08e129.mp3", "imageUrl": "/api/files/рах1у – шуба-5423-48de76be-578b-484f-8c51-2ea1abc1b03e.png"}]}	10	2	\N	\N	t	2025-11-27 10:24:40.584293	6	1
69	MULTIPLE_CHOICE	Задание 4 (Выбери слово с буквой «П»)	\N	{"name": "Задание 4 (Выбери слово с буквой «П»)", "word": "", "order": "4", "letter": {"id": 79, "order": 25, "letter": "П", "audioUrl": "/api/files/Буква «П»-5423-7f561bec-69f1-4bb7-a2c9-e0b9aff66b68.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "6", "variants": [{"word": "П1илц1у", "correct": false, "audioUrl": "/api/files/П1илц1у-5423-bf175349-5444-4c77-ba45-84a142b6fd4d.mp3", "imageUrl": "/api/files/п1илц1у – искра-5423-db1a3c58-44eb-47f5-a5fb-6eb727b68f97.png"}, {"word": "Пил", "correct": true, "audioUrl": "/api/files/Пил-5423-1e467421-f7fe-4ab0-a926-37ff87a5256b.mp3", "imageUrl": "/api/files/пил – слон-5423-294c88cc-959d-4ebf-b728-e68db16f4da2.png"}, {"word": "Ппиринж", "correct": false, "audioUrl": "/api/files/Ппиринж-5423-256f06ad-f196-4cef-884f-0ac21a9d92a3.mp3", "imageUrl": "/api/files/ппиринж – рис-5423-f8a47d88-e5fa-4c6d-baf4-682b42d7890b.png"}]}	10	4	\N	\N	t	2025-11-27 10:25:23.73377	6	1
70	LISTENING	Задание 5 (Познакомься с буквой «Пп»)	\N	{"name": "Задание 5 (Познакомься с буквой «Пп»)", "word": "", "order": "5", "letter": {"id": 80, "order": 26, "letter": "Пп", "audioUrl": "/api/files/Буква «Пп»-5423-4283434c-b704-40ee-9e97-6f388ede7859.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "6", "variants": [{"word": "Ппиринж", "correct": true, "audioUrl": "/api/files/Ппиринж-5423-256f06ad-f196-4cef-884f-0ac21a9d92a3.mp3", "imageUrl": "/api/files/ппиринж – рис-5423-f8a47d88-e5fa-4c6d-baf4-682b42d7890b.png"}]}	10	5	\N	\N	t	2025-11-27 10:25:40.295502	6	1
71	MULTIPLE_CHOICE	Задание 6 (Выбери слово с буквой «Пп»)	\N	{"name": "Задание 6 (Выбери слово с буквой «Пп»)", "word": "", "order": "6", "letter": {"id": 80, "order": 26, "letter": "Пп", "audioUrl": "/api/files/Буква «Пп»-5423-4283434c-b704-40ee-9e97-6f388ede7859.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "6", "variants": [{"word": "П1илц1у", "correct": false, "audioUrl": "/api/files/П1илц1у-5423-bf175349-5444-4c77-ba45-84a142b6fd4d.mp3", "imageUrl": "/api/files/п1илц1у – искра-5423-db1a3c58-44eb-47f5-a5fb-6eb727b68f97.png"}, {"word": "Ппиринж", "correct": true, "audioUrl": "/api/files/Ппиринж-5423-256f06ad-f196-4cef-884f-0ac21a9d92a3.mp3", "imageUrl": "/api/files/ппиринж – рис-5423-f8a47d88-e5fa-4c6d-baf4-682b42d7890b.png"}, {"word": "Пил", "correct": false, "audioUrl": "/api/files/Пил-5423-1e467421-f7fe-4ab0-a926-37ff87a5256b.mp3", "imageUrl": "/api/files/пил – слон-5423-294c88cc-959d-4ebf-b728-e68db16f4da2.png"}, {"word": "Рах1у", "correct": false, "audioUrl": "/api/files/Рах1у-5423-c278504c-3c51-4569-a3a6-31fb6f08e129.mp3", "imageUrl": "/api/files/рах1у – шуба-5423-48de76be-578b-484f-8c51-2ea1abc1b03e.png"}]}	10	6	\N	\N	t	2025-11-27 10:26:20.847121	6	1
72	LISTENING	Задание 7 (Познакомься с буквой «П1»)	\N	{"name": "Задание 7 (Познакомься с буквой «П1»)", "word": "", "order": "7", "letter": {"id": 81, "order": 27, "letter": "П1", "audioUrl": "/api/files/Буква «П1»-5423-caff322e-492e-4c0d-b918-a5b0622828b5.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "6", "variants": [{"word": "П1илц1у", "correct": true, "audioUrl": "/api/files/П1илц1у-5423-bf175349-5444-4c77-ba45-84a142b6fd4d.mp3", "imageUrl": "/api/files/п1илц1у – искра-5423-db1a3c58-44eb-47f5-a5fb-6eb727b68f97.png"}]}	10	7	\N	\N	t	2025-11-27 10:26:39.89407	6	1
73	MULTIPLE_CHOICE	Задание 8 (Выбери слово с буквой «П1»)	\N	{"name": "Задание 8 (Выбери слово с буквой «П1»)", "word": "", "order": "8", "letter": {"id": 81, "order": 27, "letter": "П1", "audioUrl": "/api/files/Буква «П1»-5423-caff322e-492e-4c0d-b918-a5b0622828b5.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "6", "variants": [{"word": "Нисварти", "correct": false, "audioUrl": "/api/files/Нисварти-5423-ad262047-12e7-4316-91ae-3c4716980ed6.mp3", "imageUrl": "/api/files/нисварти – огурец -5423-58b5c08c-168c-4cc9-8f11-a5af74d28ec8.png"}, {"word": "Пил", "correct": false, "audioUrl": "/api/files/Пил-5423-1e467421-f7fe-4ab0-a926-37ff87a5256b.mp3", "imageUrl": "/api/files/пил – слон-5423-294c88cc-959d-4ebf-b728-e68db16f4da2.png"}, {"word": "П1илц1у", "correct": true, "audioUrl": "/api/files/П1илц1у-5423-bf175349-5444-4c77-ba45-84a142b6fd4d.mp3", "imageUrl": "/api/files/п1илц1у – искра-5423-db1a3c58-44eb-47f5-a5fb-6eb727b68f97.png"}, {"word": "Ппиринж", "correct": false, "audioUrl": "/api/files/Ппиринж-5423-256f06ad-f196-4cef-884f-0ac21a9d92a3.mp3", "imageUrl": "/api/files/ппиринж – рис-5423-f8a47d88-e5fa-4c6d-baf4-682b42d7890b.png"}]}	10	8	\N	\N	t	2025-11-27 10:27:08.034537	6	1
74	MULTIPLE_CHOICE	Задание 10 (Выбери слово с буквой «Р»)	\N	{"name": "Задание 10 (Выбери слово с буквой «Р»)", "word": "", "order": "10", "letter": {"id": 82, "order": 28, "letter": "Р", "audioUrl": "/api/files/Буква «Р»-5423-2e2f4ea4-c672-4af5-b65b-ace5a01054d2.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "6", "variants": [{"word": "Ппиринж", "correct": false, "audioUrl": "/api/files/Ппиринж-5423-256f06ad-f196-4cef-884f-0ac21a9d92a3.mp3", "imageUrl": "/api/files/ппиринж – рис-5423-f8a47d88-e5fa-4c6d-baf4-682b42d7890b.png"}, {"word": "Рах1у", "correct": true, "audioUrl": "/api/files/Рах1у-5423-c278504c-3c51-4569-a3a6-31fb6f08e129.mp3", "imageUrl": "/api/files/рах1у – шуба-5423-48de76be-578b-484f-8c51-2ea1abc1b03e.png"}, {"word": "Пил", "correct": false, "audioUrl": "/api/files/Пил-5423-1e467421-f7fe-4ab0-a926-37ff87a5256b.mp3", "imageUrl": "/api/files/пил – слон-5423-294c88cc-959d-4ebf-b728-e68db16f4da2.png"}, {"word": "Нисварти", "correct": false, "audioUrl": "/api/files/Нисварти-5423-ad262047-12e7-4316-91ae-3c4716980ed6.mp3", "imageUrl": "/api/files/нисварти – огурец -5423-58b5c08c-168c-4cc9-8f11-a5af74d28ec8.png"}]}	10	10	\N	\N	t	2025-11-27 10:27:24.182518	6	1
75	LISTENING	Задание 9 (Познакомься с буквой «Р»)	\N	{"name": "Задание 9 (Познакомься с буквой «Р»)", "word": "", "order": "9", "letter": {"id": 82, "order": 28, "letter": "Р", "audioUrl": "/api/files/Буква «Р»-5423-2e2f4ea4-c672-4af5-b65b-ace5a01054d2.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "6", "variants": [{"word": "Рах1у", "correct": true, "audioUrl": "/api/files/Рах1у-5423-c278504c-3c51-4569-a3a6-31fb6f08e129.mp3", "imageUrl": "/api/files/рах1у – шуба-5423-48de76be-578b-484f-8c51-2ea1abc1b03e.png"}]}	10	9	\N	\N	t	2025-11-27 10:28:31.618029	6	1
77	MULTIPLE_CHOICE	Задание 2 (Выбери слово с буквой «С»)	\N	{"name": "Задание 2 (Выбери слово с буквой «С»)", "word": "", "order": "2", "letter": {"id": 83, "order": 29, "letter": "С", "audioUrl": "/api/files/Буква «С»-5423-be00bab7-bbe1-46a7-ac4b-2500524d930d.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "7", "variants": [{"word": "Ссят", "correct": false, "audioUrl": "/api/files/Ссят-5423-fdd5aacf-971c-405a-a547-3b561bf68e55.mp3", "imageUrl": "/api/files/ссят – часы -5423-ca5d4cc0-84ca-4bef-a396-abf1358530c8.png"}, {"word": "Сунув", "correct": true, "audioUrl": "/api/files/Сунув-5423-b1ec48eb-1442-4011-9d12-223c55ceefaa.mp3", "imageUrl": "/api/files/сунув – гранат -5423-47757f19-a541-44ac-a19b-a479b549918b.png"}, {"word": "Тах", "correct": false, "audioUrl": "/api/files/Тах-5423-86612fd5-07ff-4b32-915b-44cbaa2c1730.mp3", "imageUrl": "/api/files/тах – кровать -5423-362924bc-0723-4a3a-883d-80fdc2529b03.png"}]}	10	2	\N	\N	t	2025-11-27 10:29:26.325889	7	1
78	LISTENING	Задание 3 (Познакомься с буквой «Сс») 	\N	{"name": "Задание 3 (Познакомься с буквой «Сс») ", "word": "", "order": "3", "letter": {"id": 84, "order": 30, "letter": "Сс", "audioUrl": "/api/files/Буква «Сс»-5423-3e6ccb4f-c14b-4bf7-bd02-0afce26dfe14.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "7", "variants": [{"word": "Ссят", "correct": true, "audioUrl": "/api/files/Ссят-5423-fdd5aacf-971c-405a-a547-3b561bf68e55.mp3", "imageUrl": "/api/files/ссят – часы -5423-ca5d4cc0-84ca-4bef-a396-abf1358530c8.png"}]}	10	3	\N	\N	t	2025-11-27 10:29:39.631883	7	1
79	MULTIPLE_CHOICE	Задание 4 (Выбери слово с буквой «Сс»)	\N	{"name": "Задание 4 (Выбери слово с буквой «Сс»)", "word": "", "order": "4", "letter": {"id": 84, "order": 30, "letter": "Сс", "audioUrl": "/api/files/Буква «Сс»-5423-3e6ccb4f-c14b-4bf7-bd02-0afce26dfe14.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "7", "variants": [{"word": "Сунув", "correct": false, "audioUrl": "/api/files/Сунув-5423-b1ec48eb-1442-4011-9d12-223c55ceefaa.mp3", "imageUrl": "/api/files/сунув – гранат -5423-47757f19-a541-44ac-a19b-a479b549918b.png"}, {"word": "Ссят", "correct": true, "audioUrl": "/api/files/Ссят-5423-fdd5aacf-971c-405a-a547-3b561bf68e55.mp3", "imageUrl": "/api/files/ссят – часы -5423-ca5d4cc0-84ca-4bef-a396-abf1358530c8.png"}, {"word": "Т1ут1и", "correct": false, "audioUrl": "/api/files/Т1ут1и-5423-1d2c8c3a-935b-4f01-9f9a-724d23a4577c.mp3", "imageUrl": "/api/files/т1ут1и – цветок-5423-09fd4c0e-ac2d-4011-9be0-af0d28c14545.png"}]}	10	4	\N	\N	t	2025-11-27 10:30:02.613894	7	1
80	LISTENING	Задание 5 (Познакомься с буквой «Т»)	\N	{"name": "Задание 5 (Познакомься с буквой «Т»)", "word": "", "order": "5", "letter": {"id": 85, "order": 31, "letter": "Т", "audioUrl": "/api/files/Буква «Т»-5423-e68a61db-0ba8-4bc1-bcc7-f01e19152761.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "7", "variants": [{"word": "Тах", "correct": true, "audioUrl": "/api/files/Тах-5423-86612fd5-07ff-4b32-915b-44cbaa2c1730.mp3", "imageUrl": "/api/files/тах – кровать -5423-362924bc-0723-4a3a-883d-80fdc2529b03.png"}]}	10	5	\N	\N	t	2025-11-27 10:30:22.988188	7	1
81	MULTIPLE_CHOICE	Задание 6 (Выбери слово с буквой «Т»)	\N	{"name": "Задание 6 (Выбери слово с буквой «Т»)", "word": "", "order": "6", "letter": {"id": 85, "order": 31, "letter": "Т", "audioUrl": "/api/files/Буква «Т»-5423-e68a61db-0ba8-4bc1-bcc7-f01e19152761.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "7", "variants": [{"word": "Ттукку", "correct": false, "audioUrl": "/api/files/Ттукку-5423-4372c22c-15b7-4ba6-8c3f-7c1d055e69ca.mp3", "imageUrl": "/api/files/ттукку – осел -5423-e99c97b6-f7c5-4e6a-ab98-7dff16936290.png"}, {"word": "Тах", "correct": true, "audioUrl": "/api/files/Тах-5423-86612fd5-07ff-4b32-915b-44cbaa2c1730.mp3", "imageUrl": "/api/files/тах – кровать -5423-362924bc-0723-4a3a-883d-80fdc2529b03.png"}, {"word": "Т1ут1и", "correct": false, "audioUrl": "/api/files/Т1ут1и-5423-1d2c8c3a-935b-4f01-9f9a-724d23a4577c.mp3", "imageUrl": "/api/files/т1ут1и – цветок-5423-09fd4c0e-ac2d-4011-9be0-af0d28c14545.png"}, {"word": "Ссят", "correct": false, "audioUrl": "/api/files/Ссят-5423-fdd5aacf-971c-405a-a547-3b561bf68e55.mp3", "imageUrl": "/api/files/ссят – часы -5423-ca5d4cc0-84ca-4bef-a396-abf1358530c8.png"}]}	10	6	\N	\N	t	2025-11-27 10:30:56.371564	7	1
82	LISTENING	Задание 7 (Познакомься с буквой «Тт»)	\N	{"name": "Задание 7 (Познакомься с буквой «Тт»)", "word": "", "order": "7", "letter": {"id": 86, "order": 32, "letter": "Тт", "audioUrl": "/api/files/Буква «Тт»-5423-473f9c67-07ca-463b-8201-12e3fe1321fd.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "7", "variants": [{"word": "Ттукку", "correct": true, "audioUrl": "/api/files/Ттукку-5423-4372c22c-15b7-4ba6-8c3f-7c1d055e69ca.mp3", "imageUrl": "/api/files/ттукку – осел -5423-e99c97b6-f7c5-4e6a-ab98-7dff16936290.png"}]}	10	7	\N	\N	t	2025-11-27 10:31:11.621924	7	1
83	MULTIPLE_CHOICE	Задание 8 (Выбери слово с буквой «Тт»)	\N	{"name": "Задание 8 (Выбери слово с буквой «Тт»)", "word": "", "order": "8", "letter": {"id": 86, "order": 32, "letter": "Тт", "audioUrl": "/api/files/Буква «Тт»-5423-473f9c67-07ca-463b-8201-12e3fe1321fd.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "7", "variants": [{"word": "Т1ут1и", "correct": false, "audioUrl": "/api/files/Т1ут1и-5423-1d2c8c3a-935b-4f01-9f9a-724d23a4577c.mp3", "imageUrl": "/api/files/т1ут1и – цветок-5423-09fd4c0e-ac2d-4011-9be0-af0d28c14545.png"}, {"word": "Тах", "correct": false, "audioUrl": "/api/files/Тах-5423-86612fd5-07ff-4b32-915b-44cbaa2c1730.mp3", "imageUrl": "/api/files/тах – кровать -5423-362924bc-0723-4a3a-883d-80fdc2529b03.png"}, {"word": "Ттукку", "correct": true, "audioUrl": "/api/files/Ттукку-5423-4372c22c-15b7-4ba6-8c3f-7c1d055e69ca.mp3", "imageUrl": "/api/files/ттукку – осел -5423-e99c97b6-f7c5-4e6a-ab98-7dff16936290.png"}, {"word": "Ссят", "correct": false, "audioUrl": "/api/files/Ссят-5423-fdd5aacf-971c-405a-a547-3b561bf68e55.mp3", "imageUrl": "/api/files/ссят – часы -5423-ca5d4cc0-84ca-4bef-a396-abf1358530c8.png"}]}	10	8	\N	\N	t	2025-11-27 10:31:37.933513	7	1
85	MULTIPLE_CHOICE	Задание 10 (Выбери слово с буквой «Т1»)	\N	{"name": "Задание 10 (Выбери слово с буквой «Т1»)", "word": "", "order": "10", "letter": {"id": 87, "order": 33, "letter": "Т1", "audioUrl": "/api/files/Буква «Т1»-5423-6da97c11-0886-46ba-8b39-56b49d44184d.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "7", "variants": [{"word": "Ссят", "correct": false, "audioUrl": "/api/files/Ссят-5423-fdd5aacf-971c-405a-a547-3b561bf68e55.mp3", "imageUrl": "/api/files/ссят – часы -5423-ca5d4cc0-84ca-4bef-a396-abf1358530c8.png"}, {"word": "Т1ут1и", "correct": true, "audioUrl": "/api/files/Т1ут1и-5423-1d2c8c3a-935b-4f01-9f9a-724d23a4577c.mp3", "imageUrl": "/api/files/т1ут1и – цветок-5423-09fd4c0e-ac2d-4011-9be0-af0d28c14545.png"}, {"word": "Ттукку", "correct": false, "audioUrl": "/api/files/Ттукку-5423-4372c22c-15b7-4ba6-8c3f-7c1d055e69ca.mp3", "imageUrl": "/api/files/ттукку – осел -5423-e99c97b6-f7c5-4e6a-ab98-7dff16936290.png"}, {"word": "Тах", "correct": false, "audioUrl": "/api/files/Тах-5423-86612fd5-07ff-4b32-915b-44cbaa2c1730.mp3", "imageUrl": "/api/files/тах – кровать -5423-362924bc-0723-4a3a-883d-80fdc2529b03.png"}]}	10	10	\N	\N	t	2025-11-27 10:32:29.704513	7	1
86	LISTENING	Задание 1 (Познакомься с буквой «Х») 	\N	{"name": "Задание 1 (Познакомься с буквой «Х») ", "word": "", "order": 1, "letter": {"id": 90, "order": 36, "letter": "Х", "audioUrl": "/api/files/Буква «Х»-5423-4f751a03-e198-43b7-bba5-c9737695a787.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "8", "variants": [{"word": "Хялат", "correct": true, "audioUrl": "/api/files/Хялат-5423-5d9c657a-4b1f-499d-88de-3a06c4d8a256.mp3", "imageUrl": "/api/files/хялат – халат -5423-eec5eb7b-a86f-4f2d-a6f6-cc312b22d810.png"}]}	10	1	\N	\N	t	2025-11-27 10:32:57.881539	8	1
87	MULTIPLE_CHOICE	Задание 2 (Выбери слово с буквой «Х»)	\N	{"name": "Задание 2 (Выбери слово с буквой «Х»)", "word": "", "order": "2", "letter": {"id": 90, "order": 36, "letter": "Х", "audioUrl": "/api/files/Буква «Х»-5423-4f751a03-e198-43b7-bba5-c9737695a787.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "8", "variants": [{"word": "Хьхьи", "correct": false, "audioUrl": "/api/files/Хьхьи-5423-9ffe58df-d76f-4f48-b464-57a904329c69.mp3", "imageUrl": "/api/files/хьхьи – голубь -5423-9726990a-fed5-4c98-b12b-805f1ed04d24.JPG"}, {"word": "Хялат", "correct": true, "audioUrl": "/api/files/Хялат-5423-5d9c657a-4b1f-499d-88de-3a06c4d8a256.mp3", "imageUrl": "/api/files/хялат – халат -5423-eec5eb7b-a86f-4f2d-a6f6-cc312b22d810.png"}, {"word": "Хьама", "correct": false, "audioUrl": "/api/files/Хьама-5423-2179d416-572b-4885-bbd9-9fa3c989e83b.mp3", "imageUrl": "/api/files/хьама – пена -5423-51e6ed2b-ed99-4ca2-9ffa-5ae4add9f5b3.JPG"}]}	10	2	\N	\N	t	2025-11-27 10:33:22.150533	8	1
88	LISTENING	Задание 3 (Познакомься с буквой «Хх»)	\N	{"name": "Задание 3 (Познакомься с буквой «Хх»)", "word": "", "order": "3", "letter": {"id": 91, "order": 37, "letter": "Хх", "audioUrl": "/api/files/Буква «Хх»-5423-d890fffd-39b9-4d6a-8b77-c6a496284be8.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "8", "variants": [{"word": "Ххалаххи", "correct": true, "audioUrl": "/api/files/Ххалаххи-5423-8c2f31cb-c9a3-4f8d-950f-6d683f24aba9.mp3", "imageUrl": "/api/files/ххалаххи – иголка -5423-07c039eb-b891-4ad7-a1b7-9227e515fa36.JPG"}]}	10	3	\N	\N	t	2025-11-27 10:33:37.449516	8	1
89	MULTIPLE_CHOICE	Задание 4 (Выбери слово с буквой «Хх») 	\N	{"name": "Задание 4 (Выбери слово с буквой «Хх») ", "word": "", "order": "4", "letter": {"id": 91, "order": 37, "letter": "Хх", "audioUrl": "/api/files/Буква «Хх»-5423-d890fffd-39b9-4d6a-8b77-c6a496284be8.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "8", "variants": [{"word": "Хъат1у", "correct": false, "audioUrl": "/api/files/Хъат1у-5423-8779ce6e-d293-4197-8c96-af5dfd80a783.mp3", "imageUrl": "/api/files/хъат1у – ворон -5423-c80ca21c-0bed-4fe7-ad08-5f68da2bd49a.JPG"}, {"word": "Ххалаххи", "correct": true, "audioUrl": "/api/files/Ххалаххи-5423-8c2f31cb-c9a3-4f8d-950f-6d683f24aba9.mp3", "imageUrl": "/api/files/ххалаххи – иголка -5423-07c039eb-b891-4ad7-a1b7-9227e515fa36.JPG"}, {"word": "Хьхьи", "correct": false, "audioUrl": "/api/files/Хьхьи-5423-9ffe58df-d76f-4f48-b464-57a904329c69.mp3", "imageUrl": "/api/files/хьхьи – голубь -5423-9726990a-fed5-4c98-b12b-805f1ed04d24.JPG"}]}	10	4	\N	\N	t	2025-11-27 10:34:03.133509	8	1
90	LISTENING	Задание 5 (Познакомься с буквой «Хъ»)	\N	{"name": "Задание 5 (Познакомься с буквой «Хъ»)", "word": "", "order": "5", "letter": {"id": 92, "order": 38, "letter": "Хъ", "audioUrl": "/api/files/Буква «Хъ»-5423-3d65370e-4781-41a3-be93-52ad49a163cc.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "8", "variants": [{"word": "Хъат1у", "correct": true, "audioUrl": "/api/files/Хъат1у-5423-8779ce6e-d293-4197-8c96-af5dfd80a783.mp3", "imageUrl": "/api/files/хъат1у – ворон -5423-c80ca21c-0bed-4fe7-ad08-5f68da2bd49a.JPG"}]}	10	5	\N	\N	t	2025-11-27 10:34:22.592512	8	1
91	MULTIPLE_CHOICE	Задание 6 (Выбери слово с буквой «Хъ»)	\N	{"name": "Задание 6 (Выбери слово с буквой «Хъ»)", "word": "", "order": "6", "letter": {"id": 92, "order": 38, "letter": "Хъ", "audioUrl": "/api/files/Буква «Хъ»-5423-3d65370e-4781-41a3-be93-52ad49a163cc.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "8", "variants": [{"word": "Хялат", "correct": false, "audioUrl": "/api/files/Хялат-5423-5d9c657a-4b1f-499d-88de-3a06c4d8a256.mp3", "imageUrl": "/api/files/хялат – халат -5423-eec5eb7b-a86f-4f2d-a6f6-cc312b22d810.png"}, {"word": "Хъат1у", "correct": true, "audioUrl": "/api/files/Хъат1у-5423-8779ce6e-d293-4197-8c96-af5dfd80a783.mp3", "imageUrl": "/api/files/хъат1у – ворон -5423-c80ca21c-0bed-4fe7-ad08-5f68da2bd49a.JPG"}, {"word": "Хьама", "correct": false, "audioUrl": "/api/files/Хьама-5423-2179d416-572b-4885-bbd9-9fa3c989e83b.mp3", "imageUrl": "/api/files/хьама – пена -5423-51e6ed2b-ed99-4ca2-9ffa-5ae4add9f5b3.JPG"}, {"word": "Ххалаххи", "correct": false, "audioUrl": "/api/files/Ххалаххи-5423-8c2f31cb-c9a3-4f8d-950f-6d683f24aba9.mp3", "imageUrl": "/api/files/ххалаххи – иголка -5423-07c039eb-b891-4ad7-a1b7-9227e515fa36.JPG"}]}	10	6	\N	\N	t	2025-11-27 10:34:59.019525	8	1
93	MULTIPLE_CHOICE	Задание 8 (Выбери слово с буквой «Хь»)	\N	{"name": "Задание 8 (Выбери слово с буквой «Хь»)", "word": "", "order": "8", "letter": {"id": 93, "order": 39, "letter": "Хь", "audioUrl": "/api/files/Буква «Хь»-5423-65f8c597-4f5b-4a4d-9735-a4166a9aeb4b.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "8", "variants": [{"word": "Хъат1у", "correct": false, "audioUrl": "/api/files/Хъат1у-5423-8779ce6e-d293-4197-8c96-af5dfd80a783.mp3", "imageUrl": "/api/files/хъат1у – ворон -5423-c80ca21c-0bed-4fe7-ad08-5f68da2bd49a.JPG"}, {"word": "Хьхьи", "correct": false, "audioUrl": "/api/files/Хьхьи-5423-9ffe58df-d76f-4f48-b464-57a904329c69.mp3", "imageUrl": "/api/files/хьхьи – голубь -5423-9726990a-fed5-4c98-b12b-805f1ed04d24.JPG"}, {"word": "Хьама", "correct": true, "audioUrl": "/api/files/Хьама-5423-2179d416-572b-4885-bbd9-9fa3c989e83b.mp3", "imageUrl": "/api/files/хьама – пена -5423-51e6ed2b-ed99-4ca2-9ffa-5ae4add9f5b3.JPG"}, {"word": "Ххалаххи", "correct": false, "audioUrl": "/api/files/Ххалаххи-5423-8c2f31cb-c9a3-4f8d-950f-6d683f24aba9.mp3", "imageUrl": "/api/files/ххалаххи – иголка -5423-07c039eb-b891-4ad7-a1b7-9227e515fa36.JPG"}]}	10	8	\N	\N	t	2025-11-27 10:35:55.203512	8	1
94	LISTENING	Задание 9 (Познакомься с буквой «Хьхь»)	\N	{"name": "Задание 9 (Познакомься с буквой «Хьхь»)", "word": "", "order": "9", "letter": {"id": 94, "order": 40, "letter": "Хьхь", "audioUrl": "/api/files/Буква «Хьхь»-5423-56ed3a41-8b64-42c1-be50-f2cfe9553b23.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "8", "variants": [{"word": "Хьхьи", "correct": true, "audioUrl": "/api/files/Хьхьи-5423-9ffe58df-d76f-4f48-b464-57a904329c69.mp3", "imageUrl": "/api/files/хьхьи – голубь -5423-9726990a-fed5-4c98-b12b-805f1ed04d24.JPG"}]}	10	9	\N	\N	t	2025-11-27 10:36:12.111814	8	1
95	MULTIPLE_CHOICE	Задание 10 (Выбери слово с буквой «Хьхь»)	\N	{"name": "Задание 10 (Выбери слово с буквой «Хьхь»)", "word": "", "order": "10", "letter": {"id": 94, "order": 40, "letter": "Хьхь", "audioUrl": "/api/files/Буква «Хьхь»-5423-56ed3a41-8b64-42c1-be50-f2cfe9553b23.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "8", "variants": [{"word": "Хьама", "correct": false, "audioUrl": "/api/files/Хьама-5423-2179d416-572b-4885-bbd9-9fa3c989e83b.mp3", "imageUrl": "/api/files/хьама – пена -5423-51e6ed2b-ed99-4ca2-9ffa-5ae4add9f5b3.JPG"}, {"word": "Хьхьи", "correct": true, "audioUrl": "/api/files/Хьхьи-5423-9ffe58df-d76f-4f48-b464-57a904329c69.mp3", "imageUrl": "/api/files/хьхьи – голубь -5423-9726990a-fed5-4c98-b12b-805f1ed04d24.JPG"}, {"word": "Хялат", "correct": false, "audioUrl": "/api/files/Хялат-5423-5d9c657a-4b1f-499d-88de-3a06c4d8a256.mp3", "imageUrl": "/api/files/хялат – халат -5423-eec5eb7b-a86f-4f2d-a6f6-cc312b22d810.png"}, {"word": "Хъат1у", "correct": false, "audioUrl": "/api/files/Хъат1у-5423-8779ce6e-d293-4197-8c96-af5dfd80a783.mp3", "imageUrl": "/api/files/хъат1у – ворон -5423-c80ca21c-0bed-4fe7-ad08-5f68da2bd49a.JPG"}]}	10	10	\N	\N	t	2025-11-27 10:37:04.946602	8	1
96	LISTENING	Задание 1 (Познакомься с буквой «Х1»)	\N	{"name": "Задание 1 (Познакомься с буквой «Х1»)", "word": "", "order": 1, "letter": {"id": 95, "order": 41, "letter": "Х1", "audioUrl": "/api/files/Буква «Х1»-5423-77177207-586e-4093-bf68-02c6df00fa2d.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "9", "variants": [{"word": "Х1ажак", "correct": true, "audioUrl": "/api/files/Х1ажак-5423-8557aac4-bad1-498e-9d08-26c9f42e0a7f.mp3", "imageUrl": "/api/files/х1ажак – брюки -5423-f5c25c91-abc5-46fa-83c0-d28377126407.JPG"}]}	10	1	\N	\N	t	2025-11-27 10:37:27.163982	9	1
97	MULTIPLE_CHOICE	Задание 2 (Выбери слово с буквой «Х1»)	\N	{"name": "Задание 2 (Выбери слово с буквой «Х1»)", "word": "", "order": "2", "letter": {"id": 95, "order": 41, "letter": "Х1", "audioUrl": "/api/files/Буква «Х1»-5423-77177207-586e-4093-bf68-02c6df00fa2d.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "9", "variants": [{"word": "Цулч1а", "correct": false, "audioUrl": "/api/files/Цулч1а-5423-4c57264c-5953-4413-8ac3-8786bd40b51b.mp3", "imageUrl": "/api/files/цулч1а – лиса -5423-5d1f2ef3-f238-41c3-bb53-c19bf2295f2a.JPG"}, {"word": "Х1ажак", "correct": true, "audioUrl": "/api/files/Х1ажак-5423-8557aac4-bad1-498e-9d08-26c9f42e0a7f.mp3", "imageUrl": "/api/files/х1ажак – брюки -5423-f5c25c91-abc5-46fa-83c0-d28377126407.JPG"}, {"word": "Хьама", "correct": false, "audioUrl": "/api/files/Хьама-5423-2179d416-572b-4885-bbd9-9fa3c989e83b.mp3", "imageUrl": "/api/files/хьама – пена -5423-51e6ed2b-ed99-4ca2-9ffa-5ae4add9f5b3.JPG"}]}	10	2	\N	\N	t	2025-11-27 10:37:52.527535	9	1
98	LISTENING	Задание 3 (Познакомься с буквой «Ц»)	\N	{"name": "Задание 3 (Познакомься с буквой «Ц»)", "word": "", "order": "3", "letter": {"id": 96, "order": 42, "letter": "Ц", "audioUrl": "/api/files/Буква «Ц»-5423-80dcb1e2-16a6-4a3f-9e3f-5c943b7d4dc3.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "9", "variants": [{"word": "Цулч1а", "correct": true, "audioUrl": "/api/files/Цулч1а-5423-4c57264c-5953-4413-8ac3-8786bd40b51b.mp3", "imageUrl": "/api/files/цулч1а – лиса -5423-5d1f2ef3-f238-41c3-bb53-c19bf2295f2a.JPG"}]}	10	3	\N	\N	t	2025-11-27 10:38:08.960536	9	1
99	MULTIPLE_CHOICE	Задание 4 (Выбери слово с буквой «Ц») 	\N	{"name": "Задание 4 (Выбери слово с буквой «Ц») ", "word": "", "order": "4", "letter": {"id": 96, "order": 42, "letter": "Ц", "audioUrl": "/api/files/Буква «Ц»-5423-80dcb1e2-16a6-4a3f-9e3f-5c943b7d4dc3.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "9", "variants": [{"word": "Ц1уку", "correct": false, "audioUrl": "/api/files/Ц1уку-5423-e124ecd1-275a-4f30-b999-bb1a6fe016a9.mp3", "imageUrl": "/api/files/ц1уку – коза -5423-c6f73f4b-90aa-4292-85d6-8b75e62860ed.JPG"}, {"word": "Цулч1а", "correct": true, "audioUrl": "/api/files/Цулч1а-5423-4c57264c-5953-4413-8ac3-8786bd40b51b.mp3", "imageUrl": "/api/files/цулч1а – лиса -5423-5d1f2ef3-f238-41c3-bb53-c19bf2295f2a.JPG"}, {"word": "Ццацк1улу", "correct": false, "audioUrl": "/api/files/Ццацк1улу-5423-7019adad-1f77-497c-96f4-b22b1c6f307b.mp3", "imageUrl": "/api/files/ццацк1улу – еж -5423-569c58e3-41a7-494f-ae4d-fe4ab0b9dbb9.JPG"}]}	10	4	\N	\N	t	2025-11-27 10:38:31.346519	9	1
101	MULTIPLE_CHOICE	Задание 6 (Выбери слово с буквой «Цц»)	\N	{"name": "Задание 6 (Выбери слово с буквой «Цц»)", "word": "", "order": "6", "letter": {"id": 97, "order": 43, "letter": "Цц", "audioUrl": "/api/files/Буква «Цц»-5423-193a4888-79cb-47ba-a24e-6a213dcd3a0b.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "9", "variants": [{"word": "Х1ажак", "correct": false, "audioUrl": "/api/files/Х1ажак-5423-8557aac4-bad1-498e-9d08-26c9f42e0a7f.mp3", "imageUrl": "/api/files/х1ажак – брюки -5423-f5c25c91-abc5-46fa-83c0-d28377126407.JPG"}, {"word": "Ццацк1улу", "correct": true, "audioUrl": "/api/files/Ццацк1улу-5423-7019adad-1f77-497c-96f4-b22b1c6f307b.mp3", "imageUrl": "/api/files/ццацк1улу – еж -5423-569c58e3-41a7-494f-ae4d-fe4ab0b9dbb9.JPG"}, {"word": "Ц1уку", "correct": false, "audioUrl": "/api/files/Ц1уку-5423-e124ecd1-275a-4f30-b999-bb1a6fe016a9.mp3", "imageUrl": "/api/files/ц1уку – коза -5423-c6f73f4b-90aa-4292-85d6-8b75e62860ed.JPG"}, {"word": "Цулч1а", "correct": false, "audioUrl": "/api/files/Цулч1а-5423-4c57264c-5953-4413-8ac3-8786bd40b51b.mp3", "imageUrl": "/api/files/цулч1а – лиса -5423-5d1f2ef3-f238-41c3-bb53-c19bf2295f2a.JPG"}]}	10	6	\N	\N	t	2025-11-27 10:39:19.067512	9	1
102	LISTENING	Задание 7 (Познакомься с буквой «Ц1»)	\N	{"name": "Задание 7 (Познакомься с буквой «Ц1»)", "word": "", "order": "7", "letter": {"id": 98, "order": 44, "letter": "Ц1", "audioUrl": "/api/files/Буква «Ц1»-5423-ae248115-40e6-4e0d-97a5-da226407afac.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "9", "variants": [{"word": "Ц1уку", "correct": true, "audioUrl": "/api/files/Ц1уку-5423-e124ecd1-275a-4f30-b999-bb1a6fe016a9.mp3", "imageUrl": "/api/files/ц1уку – коза -5423-c6f73f4b-90aa-4292-85d6-8b75e62860ed.JPG"}]}	10	7	\N	\N	t	2025-11-27 10:39:41.626857	9	1
103	MULTIPLE_CHOICE	Задание 8 (Выбери слово с буквой «Ц1»)	\N	{"name": "Задание 8 (Выбери слово с буквой «Ц1»)", "word": "", "order": "8", "letter": {"id": 98, "order": 44, "letter": "Ц1", "audioUrl": "/api/files/Буква «Ц1»-5423-ae248115-40e6-4e0d-97a5-da226407afac.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "9", "variants": [{"word": "Цулч1а", "correct": false, "audioUrl": "/api/files/Цулч1а-5423-4c57264c-5953-4413-8ac3-8786bd40b51b.mp3", "imageUrl": "/api/files/цулч1а – лиса -5423-5d1f2ef3-f238-41c3-bb53-c19bf2295f2a.JPG"}, {"word": "Ццацк1улу", "correct": false, "audioUrl": "/api/files/Ццацк1улу-5423-7019adad-1f77-497c-96f4-b22b1c6f307b.mp3", "imageUrl": "/api/files/ццацк1улу – еж -5423-569c58e3-41a7-494f-ae4d-fe4ab0b9dbb9.JPG"}, {"word": "Ц1уку", "correct": true, "audioUrl": "/api/files/Ц1уку-5423-e124ecd1-275a-4f30-b999-bb1a6fe016a9.mp3", "imageUrl": "/api/files/ц1уку – коза -5423-c6f73f4b-90aa-4292-85d6-8b75e62860ed.JPG"}, {"word": "Х1ажак", "correct": false, "audioUrl": "/api/files/Х1ажак-5423-8557aac4-bad1-498e-9d08-26c9f42e0a7f.mp3", "imageUrl": "/api/files/х1ажак – брюки -5423-f5c25c91-abc5-46fa-83c0-d28377126407.JPG"}]}	10	8	\N	\N	t	2025-11-27 10:40:06.802514	9	1
104	LISTENING	Задание 1 (Познакомься с буквой «Ч»)	\N	{"name": "Задание 1 (Познакомься с буквой «Ч»)", "word": "", "order": "1", "letter": {"id": 99, "order": 45, "letter": "Ч", "audioUrl": "/api/files/Буква «Ч»-5423-0f4c83ef-9f9c-4ba9-9871-4c63a8192118.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "10", "variants": [{"word": "Чассаг", "correct": true, "audioUrl": "/api/files/Чассаг-5423-04d3fa61-41cc-4c60-a0c0-b7a9d241556c.mp3", "imageUrl": "/api/files/чассаг - финик -5423-0c7fbde1-82d1-4e64-8cd3-1151513a63a7.JPG"}]}	10	1	\N	\N	t	2025-11-27 10:40:36.580241	10	1
105	MULTIPLE_CHOICE	Задание 2 (Выбери слово с буквой «Ч»)	\N	{"name": "Задание 2 (Выбери слово с буквой «Ч»)", "word": "", "order": "2", "letter": {"id": 99, "order": 45, "letter": "Ч", "audioUrl": "/api/files/Буква «Ч»-5423-0f4c83ef-9f9c-4ba9-9871-4c63a8192118.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "10", "variants": [{"word": "Ч1и", "correct": false, "audioUrl": "/api/files/Ч1и-5423-7c374dc7-c32c-4b22-82af-36513c662a98.mp3", "imageUrl": "/api/files/ч1и - ягненок-5423-2f36c65a-5c1a-4260-977c-646af5bb59f8.JPG"}, {"word": "Чассаг", "correct": true, "audioUrl": "/api/files/Чассаг-5423-04d3fa61-41cc-4c60-a0c0-b7a9d241556c.mp3", "imageUrl": "/api/files/чассаг - финик -5423-0c7fbde1-82d1-4e64-8cd3-1151513a63a7.JPG"}, {"word": "Ччиту", "correct": false, "audioUrl": "/api/files/Ччиту-5423-13bc4875-ed49-4ef4-ae39-4488410ef7b8.mp3", "imageUrl": "/api/files/ччиту – кошка -5423-e388b617-4628-45f8-9d6c-a41232d2ce67.JPG"}]}	10	2	\N	\N	t	2025-11-27 10:40:59.92151	10	1
106	LISTENING	Задание 3 (Познакомься с буквой «Чч»)	\N	{"name": "Задание 3 (Познакомься с буквой «Чч»)", "word": "", "order": "3", "letter": {"id": 100, "order": 46, "letter": "Чч", "audioUrl": "/api/files/Буква «Чч»-5423-59130039-e4e7-4306-a77d-5758837463dc.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "10", "variants": [{"word": "Ччиту", "correct": true, "audioUrl": "/api/files/Ччиту-5423-13bc4875-ed49-4ef4-ae39-4488410ef7b8.mp3", "imageUrl": "/api/files/ччиту – кошка -5423-e388b617-4628-45f8-9d6c-a41232d2ce67.JPG"}]}	10	3	\N	\N	t	2025-11-27 10:41:13.570203	10	1
107	MULTIPLE_CHOICE	Задание 4 (Выбери слово с буквой «Чч»)	\N	{"name": "Задание 4 (Выбери слово с буквой «Чч»)", "word": "", "order": "4", "letter": {"id": 100, "order": 46, "letter": "Чч", "audioUrl": "/api/files/Буква «Чч»-5423-59130039-e4e7-4306-a77d-5758837463dc.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "10", "variants": [{"word": "Чассаг", "correct": false, "audioUrl": "/api/files/Чассаг-5423-04d3fa61-41cc-4c60-a0c0-b7a9d241556c.mp3", "imageUrl": "/api/files/чассаг - финик -5423-0c7fbde1-82d1-4e64-8cd3-1151513a63a7.JPG"}, {"word": "Ччиту", "correct": true, "audioUrl": "/api/files/Ччиту-5423-13bc4875-ed49-4ef4-ae39-4488410ef7b8.mp3", "imageUrl": "/api/files/ччиту – кошка -5423-e388b617-4628-45f8-9d6c-a41232d2ce67.JPG"}, {"word": "Ч1и", "correct": false, "audioUrl": "/api/files/Ч1и-5423-7c374dc7-c32c-4b22-82af-36513c662a98.mp3", "imageUrl": "/api/files/ч1и - ягненок-5423-2f36c65a-5c1a-4260-977c-646af5bb59f8.JPG"}]}	10	4	\N	\N	t	2025-11-27 10:41:43.860009	10	1
108	LISTENING	Задание 5 (Познакомься с буквой «Ч1»)	\N	{"name": "Задание 5 (Познакомься с буквой «Ч1»)", "word": "", "order": "5", "letter": {"id": 101, "order": 47, "letter": "Ч1", "audioUrl": "/api/files/Буква «Ч1»-5423-3321c0ed-e345-47f1-a2b0-57edd63ad399.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "10", "variants": [{"word": "Ч1и", "correct": true, "audioUrl": "/api/files/Ч1и-5423-7c374dc7-c32c-4b22-82af-36513c662a98.mp3", "imageUrl": "/api/files/ч1и - ягненок-5423-2f36c65a-5c1a-4260-977c-646af5bb59f8.JPG"}]}	10	5	\N	\N	t	2025-11-27 10:41:57.29951	10	1
109	MULTIPLE_CHOICE	Задание 6 (Выбери слово с буквой «Ч1»)	\N	{"name": "Задание 6 (Выбери слово с буквой «Ч1»)", "word": "", "order": "6", "letter": {"id": 101, "order": 47, "letter": "Ч1", "audioUrl": "/api/files/Буква «Ч1»-5423-3321c0ed-e345-47f1-a2b0-57edd63ad399.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "10", "variants": [{"word": "Чассаг", "correct": false, "audioUrl": "/api/files/Чассаг-5423-04d3fa61-41cc-4c60-a0c0-b7a9d241556c.mp3", "imageUrl": "/api/files/чассаг - финик -5423-0c7fbde1-82d1-4e64-8cd3-1151513a63a7.JPG"}, {"word": "Ч1и", "correct": true, "audioUrl": "/api/files/Ч1и-5423-7c374dc7-c32c-4b22-82af-36513c662a98.mp3", "imageUrl": "/api/files/ч1и - ягненок-5423-2f36c65a-5c1a-4260-977c-646af5bb59f8.JPG"}, {"word": "Ччиту", "correct": false, "audioUrl": "/api/files/Ччиту-5423-13bc4875-ed49-4ef4-ae39-4488410ef7b8.mp3", "imageUrl": "/api/files/ччиту – кошка -5423-e388b617-4628-45f8-9d6c-a41232d2ce67.JPG"}, {"word": "Шанч1ап1и", "correct": false, "audioUrl": "/api/files/Шанч1ап1и-5423-42153ba9-6fba-4823-a938-3da4806b7396.mp3", "imageUrl": "/api/files/шанч1ап1и – клевер -5423-7f93cef5-4fc8-4116-920c-6a34703d9bda.JPG"}]}	10	6	\N	\N	t	2025-11-27 10:42:28.568629	10	1
110	LISTENING	Задание 7 (Познакомься с буквой «Ш»)	\N	{"name": "Задание 7 (Познакомься с буквой «Ш»)", "word": "", "order": "7", "letter": {"id": 102, "order": 48, "letter": "Ш", "audioUrl": "/api/files/Буква «Ш»-5423-5129fdb5-5b7f-475b-af53-9ad637749666.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "10", "variants": [{"word": "Шанч1ап1и", "correct": true, "audioUrl": "/api/files/Шанч1ап1и-5423-42153ba9-6fba-4823-a938-3da4806b7396.mp3", "imageUrl": "/api/files/шанч1ап1и – клевер -5423-7f93cef5-4fc8-4116-920c-6a34703d9bda.JPG"}]}	10	7	\N	\N	t	2025-11-27 10:42:46.206514	10	1
111	MULTIPLE_CHOICE	Задание 8 (Выбери слово с буквой «Ш»)	\N	{"name": "Задание 8 (Выбери слово с буквой «Ш»)", "word": "", "order": "8", "letter": {"id": 102, "order": 48, "letter": "Ш", "audioUrl": "/api/files/Буква «Ш»-5423-5129fdb5-5b7f-475b-af53-9ad637749666.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "10", "variants": [{"word": "Щин", "correct": false, "audioUrl": "/api/files/Щин-5423-8477bc67-2b27-4b9c-a600-ac2720c57fa0.mp3", "imageUrl": "/api/files/щин – вода-5423-718f0685-bdfb-4eba-be76-41403eb1a9ef.png"}, {"word": "Чассаг", "correct": false, "audioUrl": "/api/files/Чассаг-5423-04d3fa61-41cc-4c60-a0c0-b7a9d241556c.mp3", "imageUrl": "/api/files/чассаг - финик -5423-0c7fbde1-82d1-4e64-8cd3-1151513a63a7.JPG"}, {"word": "Шанч1ап1и", "correct": true, "audioUrl": "/api/files/Шанч1ап1и-5423-42153ba9-6fba-4823-a938-3da4806b7396.mp3", "imageUrl": "/api/files/шанч1ап1и – клевер -5423-7f93cef5-4fc8-4116-920c-6a34703d9bda.JPG"}, {"word": "Ч1и", "correct": false, "audioUrl": "/api/files/Ч1и-5423-7c374dc7-c32c-4b22-82af-36513c662a98.mp3", "imageUrl": "/api/files/ч1и - ягненок-5423-2f36c65a-5c1a-4260-977c-646af5bb59f8.JPG"}]}	10	8	\N	\N	t	2025-11-27 10:43:15.364515	10	1
112	LISTENING	Задание 9 (Познакомься с буквой «Щ»)	\N	{"name": "Задание 9 (Познакомься с буквой «Щ»)", "word": "", "order": "9", "letter": {"id": 103, "order": 49, "letter": "Щ", "audioUrl": "/api/files/Буква «Щ»-5423-217be1e3-58bf-44ef-b954-d2e71c80b649.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "10", "variants": [{"word": "Щин", "correct": true, "audioUrl": "/api/files/Щин-5423-8477bc67-2b27-4b9c-a600-ac2720c57fa0.mp3", "imageUrl": "/api/files/щин – вода-5423-718f0685-bdfb-4eba-be76-41403eb1a9ef.png"}]}	10	9	\N	\N	t	2025-11-27 10:43:36.831565	10	1
113	MULTIPLE_CHOICE	Задание 10 (Выбери слово с буквой «Щ»)	\N	{"name": "Задание 10 (Выбери слово с буквой «Щ»)", "word": "", "order": "10", "letter": {"id": 103, "order": 49, "letter": "Щ", "audioUrl": "/api/files/Буква «Щ»-5423-217be1e3-58bf-44ef-b954-d2e71c80b649.mp3", "exampleWord": null, "transcription": "", "exampleImageUrl": null, "exampleTranslation": null}, "lessonId": "10", "variants": [{"word": "Шанч1ап1и", "correct": false, "audioUrl": "/api/files/Шанч1ап1и-5423-42153ba9-6fba-4823-a938-3da4806b7396.mp3", "imageUrl": "/api/files/шанч1ап1и – клевер -5423-7f93cef5-4fc8-4116-920c-6a34703d9bda.JPG"}, {"word": "Щин", "correct": true, "audioUrl": "/api/files/Щин-5423-8477bc67-2b27-4b9c-a600-ac2720c57fa0.mp3", "imageUrl": "/api/files/щин – вода-5423-718f0685-bdfb-4eba-be76-41403eb1a9ef.png"}, {"word": "Ччиту", "correct": false, "audioUrl": "/api/files/Ччиту-5423-13bc4875-ed49-4ef4-ae39-4488410ef7b8.mp3", "imageUrl": "/api/files/ччиту – кошка -5423-e388b617-4628-45f8-9d6c-a41232d2ce67.JPG"}, {"word": "Чассаг", "correct": false, "audioUrl": "/api/files/Чассаг-5423-04d3fa61-41cc-4c60-a0c0-b7a9d241556c.mp3", "imageUrl": "/api/files/чассаг - финик -5423-0c7fbde1-82d1-4e64-8cd3-1151513a63a7.JPG"}]}	10	10	\N	\N	t	2025-11-27 10:44:00.446112	10	1
114	MATCHING_AUDIO	Задание 12 (Прослушай аудио и выбери букву) 	\N	{"left": {"isLetter": true, "onlyAudio": true}, "name": "Задание 12 (Прослушай аудио и выбери букву) ", "word": "", "order": "12", "pairs": [{"id": "4d343a51-09f6-4299-98c4-58bfc1fa2a14", "left": {"value": "А", "audioUrl": "/api/files/Буква «А»-5423-205dc374-45c0-4a2b-8f79-feedfec764b2.mp3"}, "right": {"value": "А", "audioUrl": "/api/files/Буква «А»-5423-205dc374-45c0-4a2b-8f79-feedfec764b2.mp3"}}, {"id": "660d87c7-da2d-4ac9-b7c1-934ad340d999", "left": {"value": "Аь", "audioUrl": "/api/files/Буква «Аь»-5423-60f1e59e-6019-429a-831f-1021ce837b31.mp3"}, "right": {"value": "Аь", "audioUrl": "/api/files/Буква «Аь»-5423-60f1e59e-6019-429a-831f-1021ce837b31.mp3"}}, {"id": "df63e3a2-d7cf-42c8-ae94-af6454d90273", "left": {"value": "И", "audioUrl": "/api/files/Буква «И»-5423-5f119fb8-917f-4e9d-9da0-1a1b70123063.mp3"}, "right": {"value": "И", "audioUrl": "/api/files/Буква «И»-5423-5f119fb8-917f-4e9d-9da0-1a1b70123063.mp3"}}, {"id": "84bbe966-a5fd-47d7-b8be-9c6b2c577d21", "left": {"value": "Е", "audioUrl": "/api/files/Буква «Е»-5423-4d6ab352-0953-4809-a866-f4b0b1b86ad1.mp3"}, "right": {"value": "Е", "audioUrl": "/api/files/Буква «Е»-5423-4d6ab352-0953-4809-a866-f4b0b1b86ad1.mp3"}}, {"id": "61f40392-0b49-4d4b-b108-8a260b9f1091", "left": {"value": "Й", "audioUrl": "/api/files/Буква «Й»-5423-2f4872d1-1d8a-4ce6-a198-9f94867cdc23.mp3"}, "right": {"value": "Й", "audioUrl": "/api/files/Буква «Й»-5423-2f4872d1-1d8a-4ce6-a198-9f94867cdc23.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "1"}	10	12	\N	\N	t	2025-11-27 17:32:20.423893	1	1
127	MATCHING	Задание 11 (Найди пару)	\N	{"left": {"isLetter": true, "onlyAudio": false}, "name": "Задание 11 (Найди пару)", "word": "", "order": "11", "pairs": [{"id": "f634fe23-7ff2-432d-810f-89a11c2fa4b8", "left": {"value": "Кь", "audioUrl": "/api/files/Буква «Кь»-5423-13b2da0f-d95d-4ed0-a429-dca96f91b8dd.mp3"}, "right": {"value": "кьая"}}, {"id": "9364de30-917c-44a1-bbbc-f0ce0f0cfcc0", "left": {"value": "Къ", "audioUrl": "/api/files/Буква «Къ»-5423-1eb4e51c-b457-4f6a-87c8-ee3696a7c2a5.mp3"}, "right": {"value": "къаз"}}, {"id": "f7cd48cd-62a3-4086-ab2a-d06830d7ee79", "left": {"value": "Н", "audioUrl": "/api/files/Буква «Н»-5423-aee5829b-9c67-4fa3-83b9-56ca551ac333.mp3"}, "right": {"value": "нисварти"}}, {"id": "f19195b9-5d24-48fa-ac47-69dadf2826a9", "left": {"value": "П", "audioUrl": "/api/files/Буква «П»-5423-7f561bec-69f1-4bb7-a2c9-e0b9aff66b68.mp3"}, "right": {"value": "пил"}}, {"id": "cf96a80f-dab4-45c0-9226-693151072f4a", "left": {"value": "Пп", "audioUrl": "/api/files/Буква «Пп»-5423-4283434c-b704-40ee-9e97-6f388ede7859.mp3"}, "right": {"value": "ппиринж"}}, {"id": "e4eff76e-5dfa-4f4a-8857-f05ca8c3fe99", "left": {"value": "П1", "audioUrl": "/api/files/Буква «П1»-5423-caff322e-492e-4c0d-b918-a5b0622828b5.mp3"}, "right": {"value": "п1илц1у"}}, {"id": "32462c33-122b-4eab-b96e-f281367a8d78", "left": {"value": "Р", "audioUrl": "/api/files/Буква «Р»-5423-2e2f4ea4-c672-4af5-b65b-ace5a01054d2.mp3"}, "right": {"value": "рах1у"}}, {"id": "a1f43676-76f3-4b00-bf57-c66f101bc7ee", "left": {"value": "К1", "audioUrl": "/api/files/Буква «К1»-5423-2e78f332-f670-4e60-818d-e958fbc4cd94.mp3"}, "right": {"value": "к1улу"}}, {"id": "b211984e-3aa1-48fd-839e-0a75a51cb51c", "left": {"value": "Л", "audioUrl": "/api/files/Буква «Л»-5423-cbf025af-6358-4e23-be0e-7002e284b63d.mp3"}, "right": {"value": "лу"}}, {"id": "7fe6c02a-f3f8-44ea-bdaa-f54a24caa0a1", "left": {"value": "М", "audioUrl": "/api/files/Буква «М»-5423-435c2373-91ae-4748-b5cf-940097d1b7a8.mp3"}, "right": {"value": "маз"}}], "right": {"isLetter": false, "onlyAudio": false}, "lessonId": "6"}	10	11	\N	\N	t	2025-11-27 17:55:19.795513	6	1
115	MATCHING_AUDIO	Задание 13 (Найди пару) 	\N	{"left": {"isLetter": false, "onlyAudio": false}, "name": "Задание 13 (Найди пару) ", "word": "", "order": "13", "pairs": [{"id": "6c38ae85-9d46-4dd0-b327-81bf0dd68846", "left": {"value": "Тяй", "audioUrl": "/api/files/Тяй-5423-f9be5d68-d382-4ca9-bc8d-8e42a5299a30.mp3", "displayValue": "Тя..."}, "right": {"value": "Й", "audioUrl": "/api/files/Буква «Й»-5423-2f4872d1-1d8a-4ce6-a198-9f94867cdc23.mp3"}}, {"id": "37d98ec5-4c1b-4585-bfb8-4e4fa4fbdb05", "left": {"value": "Ису", "audioUrl": "/api/files/Ису-5423-d495b78d-b8b0-4cfe-95ed-fe28339bbaa7.mp3", "displayValue": "...су"}, "right": {"value": "И", "audioUrl": "/api/files/Буква «И»-5423-5f119fb8-917f-4e9d-9da0-1a1b70123063.mp3"}}, {"id": "778c4cad-89c5-479b-979b-f5e0748d4387", "left": {"value": "Аьнак1и", "audioUrl": "/api/files/Аьнак1и-5423-145a9194-5325-4fc9-b855-76052ea734cb.mp3", "displayValue": "...нак1и"}, "right": {"value": "Аь", "audioUrl": "/api/files/Буква «Аь»-5423-60f1e59e-6019-429a-831f-1021ce837b31.mp3"}}, {"id": "baca3bbc-fcf9-4c60-9f06-638a10467d0b", "left": {"value": "Ажари", "audioUrl": "/api/files/Ажари-5423-4fae985d-eb8a-49e9-a567-bab993d1e1a6.mp3", "displayValue": "...жари"}, "right": {"value": "А", "audioUrl": "/api/files/Буква «А»-5423-205dc374-45c0-4a2b-8f79-feedfec764b2.mp3"}}, {"id": "a488b99d-45ad-4147-982b-fb048effd949", "left": {"value": "Меч1", "audioUrl": "/api/files/Меч1-5423-b8725c6d-32c1-46af-86ef-49da7ab0ee2a.mp3", "displayValue": "М...ч1"}, "right": {"value": "Е", "audioUrl": "/api/files/Буква «Е»-5423-4d6ab352-0953-4809-a866-f4b0b1b86ad1.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "1"}	10	13	\N	\N	t	2025-11-27 17:34:17.390031	1	1
116	MATCHING_AUDIO	Задание 12 (Прослушай аудио и выбери букву)	\N	{"left": {"isLetter": true, "onlyAudio": true}, "name": "Задание 12 (Прослушай аудио и выбери букву)", "word": "", "order": "12", "pairs": [{"id": "3cbb9de4-e764-47c4-af9f-a41cbde78d65", "left": {"value": "Оь", "audioUrl": "/api/files/Буква «Оь»-5423-cd264ef8-5c98-4f5a-b165-07b004e86c16.mp3"}, "right": {"value": "Оь", "audioUrl": "/api/files/Буква «Оь»-5423-cd264ef8-5c98-4f5a-b165-07b004e86c16.mp3"}}, {"id": "262fa67b-5441-4085-91fe-61e1b53f217c", "left": {"value": "У", "audioUrl": "/api/files/Буква «У»-5423-97fdb723-9cf0-4966-844b-63e75f7f5979.mp3"}, "right": {"value": "У", "audioUrl": "/api/files/Буква «У»-5423-97fdb723-9cf0-4966-844b-63e75f7f5979.mp3"}}, {"id": "95734505-9e3f-4a2a-aee4-3d0557eaf8c8", "left": {"value": "Я", "audioUrl": "/api/files/Буква «Я»-5423-2d879ffc-bc0e-4429-8aaf-dbeec698948b.mp3"}, "right": {"value": "Я", "audioUrl": "/api/files/Буква «Я»-5423-2d879ffc-bc0e-4429-8aaf-dbeec698948b.mp3"}}, {"id": "8084b64c-8425-4744-b561-aa248d438b9d", "left": {"value": "Ю", "audioUrl": "/api/files/Буква «Ю»-5423-58ae8960-c23b-4054-8380-0845496c2736.mp3"}, "right": {"value": "Ю", "audioUrl": "/api/files/Буква «Ю»-5423-58ae8960-c23b-4054-8380-0845496c2736.mp3"}}, {"id": "cddedbe9-5927-4f13-bddd-67f6db1555f6", "left": {"value": "Э", "audioUrl": "/api/files/Буква «Э»-5423-b3936de9-8821-468d-9ed0-d4f23b3a4e74.mp3"}, "right": {"value": "Э", "audioUrl": "/api/files/Буква «Э»-5423-b3936de9-8821-468d-9ed0-d4f23b3a4e74.mp3"}}, {"id": "0b1d3783-407b-46b7-aa7f-cb7151ffa491", "left": {"value": "Аь", "audioUrl": "/api/files/Буква «Аь»-5423-60f1e59e-6019-429a-831f-1021ce837b31.mp3"}, "right": {"value": "Аь", "audioUrl": "/api/files/Буква «Аь»-5423-60f1e59e-6019-429a-831f-1021ce837b31.mp3"}}, {"id": "94b46610-43d6-4f90-823f-00bda75c2dd8", "left": {"value": "Е", "audioUrl": "/api/files/Буква «Е»-5423-4d6ab352-0953-4809-a866-f4b0b1b86ad1.mp3"}, "right": {"value": "Е", "audioUrl": "/api/files/Буква «Е»-5423-4d6ab352-0953-4809-a866-f4b0b1b86ad1.mp3"}}, {"id": "abc6d819-3ac9-46a8-a5bc-3ebddf8400e9", "left": {"value": "И", "audioUrl": "/api/files/Буква «И»-5423-5f119fb8-917f-4e9d-9da0-1a1b70123063.mp3"}, "right": {"value": "И", "audioUrl": "/api/files/Буква «И»-5423-5f119fb8-917f-4e9d-9da0-1a1b70123063.mp3"}}, {"id": "39840241-c12b-4588-97ce-11889029593b", "left": {"value": "А", "audioUrl": "/api/files/Буква «А»-5423-205dc374-45c0-4a2b-8f79-feedfec764b2.mp3"}, "right": {"value": "А", "audioUrl": "/api/files/Буква «А»-5423-205dc374-45c0-4a2b-8f79-feedfec764b2.mp3"}}, {"id": "7d090765-9e95-4beb-98c5-122b78686e42", "left": {"value": "Й", "audioUrl": "/api/files/Буква «Й»-5423-2f4872d1-1d8a-4ce6-a198-9f94867cdc23.mp3"}, "right": {"value": "Й", "audioUrl": "/api/files/Буква «Й»-5423-2f4872d1-1d8a-4ce6-a198-9f94867cdc23.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "2"}	10	12	\N	\N	t	2025-11-27 17:36:44.683592	2	1
117	MATCHING_AUDIO	Задание 13 (Найди пару) 	\N	{"left": {"isLetter": false, "onlyAudio": false}, "name": "Задание 13 (Найди пару) ", "word": "", "order": "13", "pairs": [{"id": "3442409f-c56f-4a94-8b3f-64a75eddf6fb", "left": {"value": "Юзбаши", "audioUrl": "/api/files/Юзбаши-5423-32e46037-82f5-410c-8883-b1cd10292d9a.mp3", "displayValue": "...збаши"}, "right": {"value": "Ю", "audioUrl": "/api/files/Буква «Ю»-5423-58ae8960-c23b-4054-8380-0845496c2736.mp3"}}, {"id": "2da7837b-cfc2-4068-85b6-ff9484d9bb31", "left": {"value": "Яру", "audioUrl": "/api/files/Яру-5423-e8debc29-7767-4905-b4ca-41d8d7435ab6.mp3", "displayValue": "...ру"}, "right": {"value": "Я", "audioUrl": "/api/files/Буква «Я»-5423-2d879ffc-bc0e-4429-8aaf-dbeec698948b.mp3"}}, {"id": "0bdfa8f4-d33e-46e4-9ed4-937db31765e2", "left": {"value": "Экьрав", "audioUrl": "/api/files/Экьрав-5423-cf4158a2-45b7-4d58-b61b-a78522eadc33.mp3", "displayValue": "...кьрав"}, "right": {"value": "Э", "audioUrl": "/api/files/Буква «Э»-5423-b3936de9-8821-468d-9ed0-d4f23b3a4e74.mp3"}}, {"id": "8137a843-3084-441e-a449-084b6806ecb4", "left": {"value": "Урдак", "audioUrl": "/api/files/Урдак-5423-aaab9cfa-0d6d-4405-a082-62e6ce609ca7.mp3", "displayValue": "...рдак"}, "right": {"value": "У", "audioUrl": "/api/files/Буква «У»-5423-97fdb723-9cf0-4966-844b-63e75f7f5979.mp3"}}, {"id": "06710795-0c20-43b6-8002-05e43409282f", "left": {"value": "Оьл", "audioUrl": "/api/files/Оьл-5423-5be65dae-9035-41d3-8bcc-39fe7db887fb.mp3", "displayValue": "...л"}, "right": {"value": "Оь", "audioUrl": "/api/files/Буква «Оь»-5423-cd264ef8-5c98-4f5a-b165-07b004e86c16.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "2"}	10	13	\N	\N	t	2025-11-27 17:37:56.508519	2	1
118	MATCHING	Задание 11 (Найди пару) 	\N	{"left": {"isLetter": true, "onlyAudio": false}, "name": "Задание 11 (Найди пару) ", "word": "", "order": "11", "pairs": [{"id": "75b6cc04-3bd1-45df-a240-f68616ad3211", "left": {"value": "Гъ", "audioUrl": "/api/files/Буква «Гъ»-5423-cf74ffe0-f10e-4df0-86ca-884feac78dea.mp3"}, "right": {"value": "гъангъарат1и"}}, {"id": "5b427f06-08e8-46f8-90c5-a04be64781ca", "left": {"value": "Гь", "audioUrl": "/api/files/Буква «Гь»-5423-2091eee5-5dbe-4751-877a-23a1a62c79d0.mp3"}, "right": {"value": "гьивч"}}, {"id": "ceec8c84-666c-4e50-9937-5730355cfe29", "left": {"value": "Г", "audioUrl": "/api/files/Буква «Г»-5423-1193d602-b531-49c9-803d-aaecebecf946.mp3"}, "right": {"value": "гюнгут1и"}}, {"id": "c89554b6-69a7-4078-bba1-b0e33646dddd", "left": {"value": "Б", "audioUrl": "/api/files/Буква «Б»-5423-c3fe2842-f871-412b-a00b-ad3df7ecf69a.mp3"}, "right": {"value": "бюрх"}}, {"id": "dc9f3440-619b-4ba6-b840-55808da4fb18", "left": {"value": "В", "audioUrl": "/api/files/Буква «В»-5423-8bb3a792-805c-40e8-b459-8d2f1811b712.mp3"}, "right": {"value": "варани"}}], "right": {"isLetter": false, "onlyAudio": false}, "lessonId": "3"}	10	11	\N	\N	t	2025-11-27 17:39:49.242374	3	1
119	MATCHING_AUDIO	Задание 12 (Прослушай аудио и выбери букву)	\N	{"left": {"isLetter": true, "onlyAudio": true}, "name": "Задание 12 (Прослушай аудио и выбери букву)", "word": "", "order": "12", "pairs": [{"id": "9d3a234e-3ef6-4356-b7dd-3125685bfb15", "left": {"value": "Гъ", "audioUrl": "/api/files/Буква «Гъ»-5423-cf74ffe0-f10e-4df0-86ca-884feac78dea.mp3"}, "right": {"value": "Гъ", "audioUrl": "/api/files/Буква «Гъ»-5423-cf74ffe0-f10e-4df0-86ca-884feac78dea.mp3"}}, {"id": "566b2bd1-8ab2-40ed-b4d8-2d40b6d8630f", "left": {"value": "Г", "audioUrl": "/api/files/Буква «Г»-5423-1193d602-b531-49c9-803d-aaecebecf946.mp3"}, "right": {"value": "Г", "audioUrl": "/api/files/Буква «Г»-5423-1193d602-b531-49c9-803d-aaecebecf946.mp3"}}, {"id": "75119a1e-5f09-41ef-90da-16d9ac46a2aa", "left": {"value": "Б", "audioUrl": "/api/files/Буква «Б»-5423-c3fe2842-f871-412b-a00b-ad3df7ecf69a.mp3"}, "right": {"value": "Б", "audioUrl": "/api/files/Буква «Б»-5423-c3fe2842-f871-412b-a00b-ad3df7ecf69a.mp3"}}, {"id": "d62931af-d658-48aa-a78b-078855f79bc5", "left": {"value": "В", "audioUrl": "/api/files/Буква «В»-5423-8bb3a792-805c-40e8-b459-8d2f1811b712.mp3"}, "right": {"value": "В", "audioUrl": "/api/files/Буква «В»-5423-8bb3a792-805c-40e8-b459-8d2f1811b712.mp3"}}, {"id": "7de8c973-5eb6-4103-82c6-904ccf2971be", "left": {"value": "Гь", "audioUrl": "/api/files/Буква «Гь»-5423-2091eee5-5dbe-4751-877a-23a1a62c79d0.mp3"}, "right": {"value": "Гь", "audioUrl": "/api/files/Буква «Гь»-5423-2091eee5-5dbe-4751-877a-23a1a62c79d0.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "3"}	10	12	\N	\N	t	2025-11-27 17:40:45.454248	3	1
120	MATCHING_AUDIO	Задание 13 (Найди пару)	\N	{"left": {"isLetter": false, "onlyAudio": false}, "name": "Задание 13 (Найди пару)", "word": "", "order": "13", "pairs": [{"id": "5d6c32e1-2602-4623-bd08-ccced048f80b", "left": {"value": "Варани", "audioUrl": "/api/files/Варани-5423-d240c8f1-693b-4743-a5e9-69528441fc8d.mp3", "displayValue": "...арани"}, "right": {"value": "В", "audioUrl": "/api/files/Буква «В»-5423-8bb3a792-805c-40e8-b459-8d2f1811b712.mp3"}}, {"id": "a00795ad-a672-4704-a6f1-dd00fb5a0aff", "left": {"value": "Бюрх", "audioUrl": "/api/files/Бюрх-5423-e34b1ce4-d465-4b4a-95dc-37d3e90b0d5b.mp3", "displayValue": "...юрх"}, "right": {"value": "Б", "audioUrl": "/api/files/Буква «Б»-5423-c3fe2842-f871-412b-a00b-ad3df7ecf69a.mp3"}}, {"id": "81dc326b-e2f2-4abe-85e0-b24e17dc717c", "left": {"value": "Гъангъарат1и", "audioUrl": "/api/files/Гъангъарат1и-5423-a006b9d8-9fcc-47c8-b6ca-bc90c69652c8.mp3", "displayValue": "...ангъарат1и"}, "right": {"value": "Гъ", "audioUrl": "/api/files/Буква «Гъ»-5423-cf74ffe0-f10e-4df0-86ca-884feac78dea.mp3"}}, {"id": "9e26a43d-fb93-4b32-8147-5ff1eb604b6f", "left": {"value": "Гьивч", "audioUrl": "/api/files/Гьивч-5423-53ae75a7-f970-4121-ad10-5187e78e1ccf.mp3", "displayValue": "...ивч"}, "right": {"value": "Гь", "audioUrl": "/api/files/Буква «Гь»-5423-2091eee5-5dbe-4751-877a-23a1a62c79d0.mp3"}}, {"id": "e4b21a9d-8c57-4c28-95b2-e8cbf895bc73", "left": {"value": "Гюнгут1и", "audioUrl": "/api/files/Гюнгут1и-5423-3062f0ad-cfcb-4401-a889-88d31f5d7cde.mp3", "displayValue": "...юнгут1и"}, "right": {"value": "Г", "audioUrl": "/api/files/Буква «Г»-5423-1193d602-b531-49c9-803d-aaecebecf946.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "3"}	10	13	\N	\N	t	2025-11-27 17:42:31.409436	3	1
121	MATCHING	Задание 11 (Найди пару)	\N	{"left": {"isLetter": true, "onlyAudio": false}, "name": "Задание 11 (Найди пару)", "word": "", "order": "11", "pairs": [{"id": "4bcb0310-9df7-4fdf-83eb-09cc0b459f06", "left": {"value": "К", "audioUrl": "/api/files/Буква «К»-5423-97f7a464-4d30-4b5d-bc3e-11a2a3819b60.mp3"}, "right": {"value": "ка"}}, {"id": "4ad2ac26-214c-4cd8-bc15-84b49ae5c86d", "left": {"value": "Кк", "audioUrl": "/api/files/Буква «Кк»-5423-25c969d3-184c-4eb9-842d-ffe9bdf94c80.mp3"}, "right": {"value": "ккунук"}}, {"id": "83504285-f2e1-4393-801d-2fcfc4505fd5", "left": {"value": "Б", "audioUrl": "/api/files/Буква «Б»-5423-c3fe2842-f871-412b-a00b-ad3df7ecf69a.mp3"}, "right": {"value": "бюрх"}}, {"id": "dff659f6-2812-4a3e-a07b-75eec128fca4", "left": {"value": "Г", "audioUrl": "/api/files/Буква «Г»-5423-1193d602-b531-49c9-803d-aaecebecf946.mp3"}, "right": {"value": "гюнгут1и"}}, {"id": "a6f65546-8048-48d7-bedf-45b5540f1443", "left": {"value": "Гь", "audioUrl": "/api/files/Буква «Гь»-5423-2091eee5-5dbe-4751-877a-23a1a62c79d0.mp3"}, "right": {"value": "гьивч"}}, {"id": "25fcd1c8-4199-4675-9941-011a2de059d9", "left": {"value": "Гъ", "audioUrl": "/api/files/Буква «Гъ»-5423-cf74ffe0-f10e-4df0-86ca-884feac78dea.mp3"}, "right": {"value": "гъангъарат1и"}}, {"id": "f37fdc3a-937d-47ce-b23a-78bf1a0988ef", "left": {"value": "В", "audioUrl": "/api/files/Буква «В»-5423-8bb3a792-805c-40e8-b459-8d2f1811b712.mp3"}, "right": {"value": "варани"}}, {"id": "033c0714-21e5-4bcd-a590-7f0334c20394", "left": {"value": "Ж", "audioUrl": "/api/files/Буква «Ж»-5423-fd96a4e1-8e95-4cd4-96d1-668db06d0c41.mp3"}, "right": {"value": "жулар"}}, {"id": "90f40e64-d09d-46e1-914e-23dc83973735", "left": {"value": "З", "audioUrl": "/api/files/Буква «З»-5423-61c9fc04-277c-49b9-bede-9772166f4067.mp3"}, "right": {"value": "зимиз"}}, {"id": "3b7230da-2fa3-4361-82a1-fbabd4cae377", "left": {"value": "Д", "audioUrl": "/api/files/Буква «Д»-5423-1e319ae8-126e-4ac2-9f8e-d4f5a30e2cf2.mp3"}, "right": {"value": "дач1у"}}], "right": {"isLetter": false, "onlyAudio": false}, "lessonId": "4"}	10	11	\N	\N	t	2025-11-27 17:44:20.094659	4	1
122	MATCHING_AUDIO	Задание 12 (Прослушай аудио и выбери букву)	\N	{"left": {"isLetter": true, "onlyAudio": true}, "name": "Задание 12 (Прослушай аудио и выбери букву)", "word": "", "order": "12", "pairs": [{"id": "42347bb5-bce5-4717-87dc-d7f11f61c03f", "left": {"value": "Б", "audioUrl": "/api/files/Буква «Б»-5423-c3fe2842-f871-412b-a00b-ad3df7ecf69a.mp3"}, "right": {"value": "Б", "audioUrl": "/api/files/Буква «Б»-5423-c3fe2842-f871-412b-a00b-ad3df7ecf69a.mp3"}}, {"id": "28807c8a-31c6-4b44-a097-8273a9a423f6", "left": {"value": "В", "audioUrl": "/api/files/Буква «В»-5423-8bb3a792-805c-40e8-b459-8d2f1811b712.mp3"}, "right": {"value": "В", "audioUrl": "/api/files/Буква «В»-5423-8bb3a792-805c-40e8-b459-8d2f1811b712.mp3"}}, {"id": "8e6c01c6-0adf-4046-943d-c5cf325d5aec", "left": {"value": "Г", "audioUrl": "/api/files/Буква «Г»-5423-1193d602-b531-49c9-803d-aaecebecf946.mp3"}, "right": {"value": "Г", "audioUrl": "/api/files/Буква «Г»-5423-1193d602-b531-49c9-803d-aaecebecf946.mp3"}}, {"id": "757c9659-980f-4510-8bb1-e16f8fc0db4a", "left": {"value": "Гъ", "audioUrl": "/api/files/Буква «Гъ»-5423-cf74ffe0-f10e-4df0-86ca-884feac78dea.mp3"}, "right": {"value": "Гъ", "audioUrl": "/api/files/Буква «Гъ»-5423-cf74ffe0-f10e-4df0-86ca-884feac78dea.mp3"}}, {"id": "2e569ffc-f7eb-4cc6-acfd-205a21dac4a0", "left": {"value": "Гь", "audioUrl": "/api/files/Буква «Гь»-5423-2091eee5-5dbe-4751-877a-23a1a62c79d0.mp3"}, "right": {"value": "Гь", "audioUrl": "/api/files/Буква «Гь»-5423-2091eee5-5dbe-4751-877a-23a1a62c79d0.mp3"}}, {"id": "f92b686b-05a8-49f6-af7e-54b81829a53b", "left": {"value": "Д", "audioUrl": "/api/files/Буква «Д»-5423-1e319ae8-126e-4ac2-9f8e-d4f5a30e2cf2.mp3"}, "right": {"value": "Д", "audioUrl": "/api/files/Буква «Д»-5423-1e319ae8-126e-4ac2-9f8e-d4f5a30e2cf2.mp3"}}, {"id": "65df7b45-af8b-4e86-be4f-333f15a1f99e", "left": {"value": "Кк", "audioUrl": "/api/files/Буква «Кк»-5423-25c969d3-184c-4eb9-842d-ffe9bdf94c80.mp3"}, "right": {"value": "Кк", "audioUrl": "/api/files/Буква «Кк»-5423-25c969d3-184c-4eb9-842d-ffe9bdf94c80.mp3"}}, {"id": "b2851a0c-b0ae-4639-ac7c-be92c2ecce01", "left": {"value": "Ж", "audioUrl": "/api/files/Буква «Ж»-5423-fd96a4e1-8e95-4cd4-96d1-668db06d0c41.mp3"}, "right": {"value": "Ж", "audioUrl": "/api/files/Буква «Ж»-5423-fd96a4e1-8e95-4cd4-96d1-668db06d0c41.mp3"}}, {"id": "d204ea38-fb17-470f-9e4a-16fa7fad20b5", "left": {"value": "З", "audioUrl": "/api/files/Буква «З»-5423-61c9fc04-277c-49b9-bede-9772166f4067.mp3"}, "right": {"value": "З", "audioUrl": "/api/files/Буква «З»-5423-61c9fc04-277c-49b9-bede-9772166f4067.mp3"}}, {"id": "c04dfb05-9d75-4b04-90b8-fda0117ee311", "left": {"value": "К", "audioUrl": "/api/files/Буква «К»-5423-97f7a464-4d30-4b5d-bc3e-11a2a3819b60.mp3"}, "right": {"value": "К", "audioUrl": "/api/files/Буква «К»-5423-97f7a464-4d30-4b5d-bc3e-11a2a3819b60.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "4"}	10	12	\N	\N	t	2025-11-27 17:46:02.952929	4	1
128	MATCHING_AUDIO	Задание 12 (Прослушай аудио и выбери букву)	\N	{"left": {"isLetter": true, "onlyAudio": true}, "name": "Задание 12 (Прослушай аудио и выбери букву)", "word": "", "order": "12", "pairs": [{"id": "613caa71-1c61-475d-8a5f-b98a1068aeb7", "left": {"value": "Н", "audioUrl": "/api/files/Буква «Н»-5423-aee5829b-9c67-4fa3-83b9-56ca551ac333.mp3"}, "right": {"value": "Н", "audioUrl": "/api/files/Буква «Н»-5423-aee5829b-9c67-4fa3-83b9-56ca551ac333.mp3"}}, {"id": "afdc4846-8447-4dcf-94a7-9fda399c4c96", "left": {"value": "Къ", "audioUrl": "/api/files/Буква «Къ»-5423-1eb4e51c-b457-4f6a-87c8-ee3696a7c2a5.mp3"}, "right": {"value": "Къ", "audioUrl": "/api/files/Буква «Къ»-5423-1eb4e51c-b457-4f6a-87c8-ee3696a7c2a5.mp3"}}, {"id": "ea5a8935-6598-4e81-b092-ea5f09f9eb4f", "left": {"value": "Кь", "audioUrl": "/api/files/Буква «Кь»-5423-13b2da0f-d95d-4ed0-a429-dca96f91b8dd.mp3"}, "right": {"value": "Кь", "audioUrl": "/api/files/Буква «Кь»-5423-13b2da0f-d95d-4ed0-a429-dca96f91b8dd.mp3"}}, {"id": "7f3d8e02-3e8e-46ca-baa9-6cd7d5c9c193", "left": {"value": "П", "audioUrl": "/api/files/Буква «П»-5423-7f561bec-69f1-4bb7-a2c9-e0b9aff66b68.mp3"}, "right": {"value": "П", "audioUrl": "/api/files/Буква «П»-5423-7f561bec-69f1-4bb7-a2c9-e0b9aff66b68.mp3"}}, {"id": "9781d034-53aa-4559-8e8b-e80e527b82c2", "left": {"value": "Пп", "audioUrl": "/api/files/Буква «Пп»-5423-4283434c-b704-40ee-9e97-6f388ede7859.mp3"}, "right": {"value": "Пп", "audioUrl": "/api/files/Буква «Пп»-5423-4283434c-b704-40ee-9e97-6f388ede7859.mp3"}}, {"id": "cfe2a015-a1e2-44e7-95c2-a9a741eb0d8e", "left": {"value": "К1", "audioUrl": "/api/files/Буква «К1»-5423-2e78f332-f670-4e60-818d-e958fbc4cd94.mp3"}, "right": {"value": "К1", "audioUrl": "/api/files/Буква «К1»-5423-2e78f332-f670-4e60-818d-e958fbc4cd94.mp3"}}, {"id": "22b89960-cdc0-4fb6-bc10-ac11b9d44a15", "left": {"value": "М", "audioUrl": "/api/files/Буква «М»-5423-435c2373-91ae-4748-b5cf-940097d1b7a8.mp3"}, "right": {"value": "М", "audioUrl": "/api/files/Буква «М»-5423-435c2373-91ae-4748-b5cf-940097d1b7a8.mp3"}}, {"id": "774d52ae-9180-4dce-b312-7c244f8ef585", "left": {"value": "П1", "audioUrl": "/api/files/Буква «П1»-5423-caff322e-492e-4c0d-b918-a5b0622828b5.mp3"}, "right": {"value": "П1", "audioUrl": "/api/files/Буква «П1»-5423-caff322e-492e-4c0d-b918-a5b0622828b5.mp3"}}, {"id": "06949a15-cf05-4d6b-9957-f96d3ab6d5b2", "left": {"value": "Л", "audioUrl": "/api/files/Буква «Л»-5423-cbf025af-6358-4e23-be0e-7002e284b63d.mp3"}, "right": {"value": "Л", "audioUrl": "/api/files/Буква «Л»-5423-cbf025af-6358-4e23-be0e-7002e284b63d.mp3"}}, {"id": "817c3af0-c71f-499e-b7dc-a1e4deceaa3b", "left": {"value": "Р", "audioUrl": "/api/files/Буква «Р»-5423-2e2f4ea4-c672-4af5-b65b-ace5a01054d2.mp3"}, "right": {"value": "Р", "audioUrl": "/api/files/Буква «Р»-5423-2e2f4ea4-c672-4af5-b65b-ace5a01054d2.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "6"}	10	12	\N	\N	t	2025-11-27 17:56:44.350923	6	1
123	MATCHING_AUDIO	Задание 13 (Найди пару)	\N	{"left": {"isLetter": false, "onlyAudio": false}, "name": "Задание 13 (Найди пару)", "word": "", "order": "13", "pairs": [{"id": "c0ad4fec-0cca-42fe-874a-1621b68bf8c4", "left": {"value": "Ка", "audioUrl": "/api/files/Ка-5423-58a6f62d-e223-4ffd-8e16-0eb1fb05b8ce.mp3", "displayValue": "...а"}, "right": {"value": "К", "audioUrl": "/api/files/Буква «К»-5423-97f7a464-4d30-4b5d-bc3e-11a2a3819b60.mp3"}}, {"id": "46e99467-bbb3-45a8-87f3-c1bf1f075967", "left": {"value": "Дач1у", "audioUrl": "/api/files/Дач1у-5423-d023263e-7278-4ce4-b116-1ba54bb8a29a.mp3", "displayValue": "...ач1у"}, "right": {"value": "Д", "audioUrl": "/api/files/Буква «Д»-5423-1e319ae8-126e-4ac2-9f8e-d4f5a30e2cf2.mp3"}}, {"id": "51dcd11e-bdf5-4633-9905-4ca910e6c4e3", "left": {"value": "Ккунук", "audioUrl": "/api/files/Ккунук-5423-e29eacd5-d889-4a9c-a1f5-d4b53c83d9db.mp3", "displayValue": "...унук"}, "right": {"value": "Кк", "audioUrl": "/api/files/Буква «Кк»-5423-25c969d3-184c-4eb9-842d-ffe9bdf94c80.mp3"}}, {"id": "a207717c-9e8c-49f0-b164-142529b3231e", "left": {"value": "Жулар", "audioUrl": "/api/files/Жулар-5423-033f4ba4-67d6-4733-80a5-f0d9850e4cb6.mp3", "displayValue": "...улар"}, "right": {"value": "Ж", "audioUrl": "/api/files/Буква «Ж»-5423-fd96a4e1-8e95-4cd4-96d1-668db06d0c41.mp3"}}, {"id": "ac89ba67-914d-41e5-83e7-4dd59fa403bb", "left": {"value": "Зимиз", "audioUrl": "/api/files/Зимиз-5423-9fc2ebb0-4d6b-493e-a603-24d04c632440.mp3", "displayValue": "...имиз"}, "right": {"value": "З", "audioUrl": "/api/files/Буква «З»-5423-61c9fc04-277c-49b9-bede-9772166f4067.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "4"}	10	13	\N	\N	t	2025-11-27 17:49:41.126028	4	1
124	MATCHING	Задание 11 (Найди пару)	\N	{"left": {"isLetter": true, "onlyAudio": false}, "name": "Задание 11 (Найди пару)", "word": "", "order": "11", "pairs": [{"id": "a7a11d02-1306-4ea4-adb5-27ed09879654", "left": {"value": "М", "audioUrl": "/api/files/Буква «М»-5423-435c2373-91ae-4748-b5cf-940097d1b7a8.mp3"}, "right": {"value": "маз"}}, {"id": "dc7cd840-0c7b-45cb-bc86-807053c4b328", "left": {"value": "К1", "audioUrl": "/api/files/Буква «К1»-5423-2e78f332-f670-4e60-818d-e958fbc4cd94.mp3"}, "right": {"value": "к1улу"}}, {"id": "7fcf876b-c15b-44ed-88a2-e2bd54e251d6", "left": {"value": "Л", "audioUrl": "/api/files/Буква «Л»-5423-cbf025af-6358-4e23-be0e-7002e284b63d.mp3"}, "right": {"value": "лу"}}, {"id": "4a67c5c2-921f-49a4-ba7a-92be64b3a0a2", "left": {"value": "Къ", "audioUrl": "/api/files/Буква «Къ»-5423-1eb4e51c-b457-4f6a-87c8-ee3696a7c2a5.mp3"}, "right": {"value": "къаз"}}, {"id": "181bc528-1c76-4b77-97f8-2b9521a91651", "left": {"value": "Кь", "audioUrl": "/api/files/Буква «Кь»-5423-13b2da0f-d95d-4ed0-a429-dca96f91b8dd.mp3"}, "right": {"value": "кьая"}}], "right": {"isLetter": false, "onlyAudio": false}, "lessonId": "5"}	10	11	\N	\N	t	2025-11-27 17:50:51.129507	5	1
125	MATCHING_AUDIO	Задание 12 (Прослушай аудио и выбери букву)	\N	{"left": {"isLetter": true, "onlyAudio": true}, "name": "Задание 12 (Прослушай аудио и выбери букву)", "word": "", "order": "12", "pairs": [{"id": "c9bba2fd-12e9-4066-9ccf-ff034ea37015", "left": {"value": "Кь", "audioUrl": "/api/files/Буква «Кь»-5423-13b2da0f-d95d-4ed0-a429-dca96f91b8dd.mp3"}, "right": {"value": "Кь", "audioUrl": "/api/files/Буква «Кь»-5423-13b2da0f-d95d-4ed0-a429-dca96f91b8dd.mp3"}}, {"id": "210b6cd8-f755-4bba-be3a-b436e613a012", "left": {"value": "Къ", "audioUrl": "/api/files/Буква «Къ»-5423-1eb4e51c-b457-4f6a-87c8-ee3696a7c2a5.mp3"}, "right": {"value": "Къ", "audioUrl": "/api/files/Буква «Къ»-5423-1eb4e51c-b457-4f6a-87c8-ee3696a7c2a5.mp3"}}, {"id": "e71faf31-2b86-459d-b375-07a1bf088a33", "left": {"value": "К1", "audioUrl": "/api/files/Буква «К1»-5423-2e78f332-f670-4e60-818d-e958fbc4cd94.mp3"}, "right": {"value": "К1", "audioUrl": "/api/files/Буква «К1»-5423-2e78f332-f670-4e60-818d-e958fbc4cd94.mp3"}}, {"id": "90decf86-bb93-429f-bea4-5bde724597d9", "left": {"value": "Л", "audioUrl": "/api/files/Буква «Л»-5423-cbf025af-6358-4e23-be0e-7002e284b63d.mp3"}, "right": {"value": "Л", "audioUrl": "/api/files/Буква «Л»-5423-cbf025af-6358-4e23-be0e-7002e284b63d.mp3"}}, {"id": "6aa1c56d-d2b4-4f72-956a-b3d38d6996d7", "left": {"value": "М", "audioUrl": "/api/files/Буква «М»-5423-435c2373-91ae-4748-b5cf-940097d1b7a8.mp3"}, "right": {"value": "М", "audioUrl": "/api/files/Буква «М»-5423-435c2373-91ae-4748-b5cf-940097d1b7a8.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "5"}	10	12	\N	\N	t	2025-11-27 17:51:43.245323	5	1
126	MATCHING_AUDIO	Задание 13 (Найди пару) 	\N	{"left": {"isLetter": false, "onlyAudio": false}, "name": "Задание 13 (Найди пару) ", "word": "", "order": "13", "pairs": [{"id": "e295cacc-8489-486f-aad8-ac035c88fd39", "left": {"value": "Маз", "audioUrl": "/api/files/Маз-5423-6df0f25a-9709-41bf-bbdd-7dfd6b93ff19.mp3", "displayValue": "...аз"}, "right": {"value": "М", "audioUrl": "/api/files/Буква «М»-5423-435c2373-91ae-4748-b5cf-940097d1b7a8.mp3"}}, {"id": "8f8f4976-8284-4b7a-8798-9f29deee6787", "left": {"value": "Кьая", "audioUrl": "/api/files/Кьая-5423-9cf55d89-2f2e-4cd9-9bd6-7fd4421f2c47.mp3", "displayValue": "...ая"}, "right": {"value": "Кь", "audioUrl": "/api/files/Буква «Кь»-5423-13b2da0f-d95d-4ed0-a429-dca96f91b8dd.mp3"}}, {"id": "1878677b-1f0c-4aa9-a507-f82942b00be9", "left": {"value": "К1улу", "audioUrl": "/api/files/К1улу-5423-cc7be8cb-bf3d-4f03-a954-61b1e7a67d35.mp3", "displayValue": "...улу"}, "right": {"value": "К1", "audioUrl": "/api/files/Буква «К1»-5423-2e78f332-f670-4e60-818d-e958fbc4cd94.mp3"}}, {"id": "206a28a7-bfb7-476f-92c7-1ab94d844162", "left": {"value": "Лу", "audioUrl": "/api/files/Лу-5423-51c358a4-04e0-48c6-916c-e773bec81a25.mp3", "displayValue": "...у"}, "right": {"value": "Л", "audioUrl": "/api/files/Буква «Л»-5423-cbf025af-6358-4e23-be0e-7002e284b63d.mp3"}}, {"id": "d54d4094-d1a8-4cc5-b151-a9611d2a52cf", "left": {"value": "Къаз", "audioUrl": "/api/files/Къаз-5423-9d345a0a-ffd9-40f9-a89d-41cbc56a7bc2.mp3", "displayValue": "...аз"}, "right": {"value": "Къ", "audioUrl": "/api/files/Буква «Къ»-5423-1eb4e51c-b457-4f6a-87c8-ee3696a7c2a5.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "5"}	10	13	\N	\N	t	2025-11-27 17:53:41.888963	5	1
129	MATCHING_AUDIO	Задание 13 (Найди пару) 	\N	{"left": {"isLetter": false, "onlyAudio": false}, "name": "Задание 13 (Найди пару) ", "word": "", "order": "13", "pairs": [{"id": "7870ea89-ffb8-42dd-9a2a-98b7d1db1c8c", "left": {"value": "Рах1у", "audioUrl": "/api/files/Рах1у-5423-c278504c-3c51-4569-a3a6-31fb6f08e129.mp3", "displayValue": "...ах1у"}, "right": {"value": "Р", "audioUrl": "/api/files/Буква «Р»-5423-2e2f4ea4-c672-4af5-b65b-ace5a01054d2.mp3"}}, {"id": "2e44b0ee-831d-4ed1-85ef-364cdd490e69", "left": {"value": "П1илц1у", "audioUrl": "/api/files/П1илц1у-5423-bf175349-5444-4c77-ba45-84a142b6fd4d.mp3", "displayValue": "...илц1у"}, "right": {"value": "П1", "audioUrl": "/api/files/Буква «П1»-5423-caff322e-492e-4c0d-b918-a5b0622828b5.mp3"}}, {"id": "2aaccb7c-7e4b-446a-8750-d09feaadd7c6", "left": {"value": "Ппиринж", "audioUrl": "/api/files/Ппиринж-5423-256f06ad-f196-4cef-884f-0ac21a9d92a3.mp3", "displayValue": "...иринж"}, "right": {"value": "Пп", "audioUrl": "/api/files/Буква «Пп»-5423-4283434c-b704-40ee-9e97-6f388ede7859.mp3"}}, {"id": "b6211924-19bf-4edf-bf56-df67303ad14d", "left": {"value": "Пил", "audioUrl": "/api/files/Пил-5423-1e467421-f7fe-4ab0-a926-37ff87a5256b.mp3", "displayValue": "...ил"}, "right": {"value": "П", "audioUrl": "/api/files/Буква «П»-5423-7f561bec-69f1-4bb7-a2c9-e0b9aff66b68.mp3"}}, {"id": "4ac862ef-5c42-4007-a588-8d7ae63a657b", "left": {"value": "Нисварти", "audioUrl": "/api/files/Нисварти-5423-ad262047-12e7-4316-91ae-3c4716980ed6.mp3", "displayValue": "...исварти"}, "right": {"value": "Н", "audioUrl": "/api/files/Буква «Н»-5423-aee5829b-9c67-4fa3-83b9-56ca551ac333.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "6"}	10	13	\N	\N	t	2025-11-27 17:58:06.361889	6	1
130	MATCHING	Задание 11 (Найди пару)	\N	{"left": {"isLetter": true, "onlyAudio": false}, "name": "Задание 11 (Найди пару)", "word": "", "order": "11", "pairs": [{"id": "7bb828ff-67e0-4c86-a0c3-bdb5ac9e7bf5", "left": {"value": "С", "audioUrl": "/api/files/Буква «С»-5423-be00bab7-bbe1-46a7-ac4b-2500524d930d.mp3"}, "right": {"value": "сунув"}}, {"id": "b4f49154-fc16-4397-bfd6-27608f6516b9", "left": {"value": "Сс", "audioUrl": "/api/files/Буква «Сс»-5423-3e6ccb4f-c14b-4bf7-bd02-0afce26dfe14.mp3"}, "right": {"value": "ссят"}}, {"id": "4a30a30f-a2e0-4d78-9c6c-73a51e1f60e2", "left": {"value": "Т", "audioUrl": "/api/files/Буква «Т»-5423-e68a61db-0ba8-4bc1-bcc7-f01e19152761.mp3"}, "right": {"value": "тах"}}, {"id": "10dabc40-9921-4cd4-a0d6-e5e95fa4ec16", "left": {"value": "Тт", "audioUrl": "/api/files/Буква «Тт»-5423-473f9c67-07ca-463b-8201-12e3fe1321fd.mp3"}, "right": {"value": "ттукку"}}, {"id": "7d84119f-89fa-4505-bbb0-03e773f1cd13", "left": {"value": "Т1", "audioUrl": "/api/files/Буква «Т1»-5423-6da97c11-0886-46ba-8b39-56b49d44184d.mp3"}, "right": {"value": "т1ут1и"}}], "right": {"isLetter": false, "onlyAudio": false}, "lessonId": "7"}	10	11	\N	\N	t	2025-11-27 17:59:20.507371	7	1
131	MATCHING_AUDIO	Задание 12 (Прослушай аудио и выбери букву)	\N	{"left": {"isLetter": true, "onlyAudio": true}, "name": "Задание 12 (Прослушай аудио и выбери букву)", "word": "", "order": "12", "pairs": [{"id": "5edf4ef7-9f30-4b2f-aa48-1112b1177872", "left": {"value": "Сс", "audioUrl": "/api/files/Буква «Сс»-5423-3e6ccb4f-c14b-4bf7-bd02-0afce26dfe14.mp3"}, "right": {"value": "Сс", "audioUrl": "/api/files/Буква «Сс»-5423-3e6ccb4f-c14b-4bf7-bd02-0afce26dfe14.mp3"}}, {"id": "cb477198-bd5e-4236-92c6-7879157a1f41", "left": {"value": "С", "audioUrl": "/api/files/Буква «С»-5423-be00bab7-bbe1-46a7-ac4b-2500524d930d.mp3"}, "right": {"value": "С", "audioUrl": "/api/files/Буква «С»-5423-be00bab7-bbe1-46a7-ac4b-2500524d930d.mp3"}}, {"id": "7982a032-66ed-4bf5-946f-c46793f78d83", "left": {"value": "Т1", "audioUrl": "/api/files/Буква «Т1»-5423-6da97c11-0886-46ba-8b39-56b49d44184d.mp3"}, "right": {"value": "Т1", "audioUrl": "/api/files/Буква «Т1»-5423-6da97c11-0886-46ba-8b39-56b49d44184d.mp3"}}, {"id": "595f598e-c32c-4d79-8b4f-0366e663b071", "left": {"value": "Тт", "audioUrl": "/api/files/Буква «Тт»-5423-473f9c67-07ca-463b-8201-12e3fe1321fd.mp3"}, "right": {"value": "Тт", "audioUrl": "/api/files/Буква «Тт»-5423-473f9c67-07ca-463b-8201-12e3fe1321fd.mp3"}}, {"id": "ba54bf19-a5dc-4c78-a9ef-78bb4bf0be68", "left": {"value": "Т", "audioUrl": "/api/files/Буква «Т»-5423-e68a61db-0ba8-4bc1-bcc7-f01e19152761.mp3"}, "right": {"value": "Т", "audioUrl": "/api/files/Буква «Т»-5423-e68a61db-0ba8-4bc1-bcc7-f01e19152761.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "7"}	10	12	\N	\N	t	2025-11-27 18:00:01.988537	7	1
132	MATCHING_AUDIO	Задание 13 (Найди пару)	\N	{"left": {"isLetter": false, "onlyAudio": false}, "name": "Задание 13 (Найди пару)", "word": "", "order": "13", "pairs": [{"id": "8717ae7d-8628-4f07-9352-d31323ffdcca", "left": {"value": "Т1ут1и", "audioUrl": "/api/files/Т1ут1и-5423-1d2c8c3a-935b-4f01-9f9a-724d23a4577c.mp3", "displayValue": "...ут1и"}, "right": {"value": "Т1", "audioUrl": "/api/files/Буква «Т1»-5423-6da97c11-0886-46ba-8b39-56b49d44184d.mp3"}}, {"id": "16d80a59-0238-4c63-bfda-e7a752b383fd", "left": {"value": "Ттукку", "audioUrl": "/api/files/Ттукку-5423-4372c22c-15b7-4ba6-8c3f-7c1d055e69ca.mp3", "displayValue": "...укку"}, "right": {"value": "Тт", "audioUrl": "/api/files/Буква «Тт»-5423-473f9c67-07ca-463b-8201-12e3fe1321fd.mp3"}}, {"id": "c966ac6f-0fe7-4001-8ebc-30275400bb63", "left": {"value": "Тах", "audioUrl": "/api/files/Тах-5423-86612fd5-07ff-4b32-915b-44cbaa2c1730.mp3", "displayValue": "...ах"}, "right": {"value": "Т", "audioUrl": "/api/files/Буква «Т»-5423-e68a61db-0ba8-4bc1-bcc7-f01e19152761.mp3"}}, {"id": "6cfe8f7c-9e2b-4d87-8708-5a064aa4b76f", "left": {"value": "Сунув", "audioUrl": "/api/files/Сунув-5423-b1ec48eb-1442-4011-9d12-223c55ceefaa.mp3", "displayValue": "...унув"}, "right": {"value": "С", "audioUrl": "/api/files/Буква «С»-5423-be00bab7-bbe1-46a7-ac4b-2500524d930d.mp3"}}, {"id": "cbc14405-27eb-45c3-917b-bbb8cdf8fabb", "left": {"value": "Ссят", "audioUrl": "/api/files/Ссят-5423-fdd5aacf-971c-405a-a547-3b561bf68e55.mp3", "displayValue": "...ят"}, "right": {"value": "Сс", "audioUrl": "/api/files/Буква «Сс»-5423-3e6ccb4f-c14b-4bf7-bd02-0afce26dfe14.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "7"}	10	13	\N	\N	t	2025-11-27 18:01:48.148511	7	1
133	MATCHING	Задание 11 (Найди пару)	\N	{"left": {"isLetter": true, "onlyAudio": false}, "name": "Задание 11 (Найди пару)", "word": "", "order": "11", "pairs": [{"id": "d87e90a0-b25f-446c-bf13-f8447392020c", "left": {"value": "С", "audioUrl": "/api/files/Буква «С»-5423-be00bab7-bbe1-46a7-ac4b-2500524d930d.mp3"}, "right": {"value": "сунув"}}, {"id": "5ad0c028-ba57-4a83-9822-1fe30645afd4", "left": {"value": "Сс", "audioUrl": "/api/files/Буква «Сс»-5423-3e6ccb4f-c14b-4bf7-bd02-0afce26dfe14.mp3"}, "right": {"value": "ссят"}}, {"id": "38d88d12-8ea2-4d96-8a31-0b57838e9437", "left": {"value": "Х", "audioUrl": "/api/files/Буква «Х»-5423-4f751a03-e198-43b7-bba5-c9737695a787.mp3"}, "right": {"value": "хялат"}}, {"id": "96229a4f-8557-4b31-a9d4-b97fdc628f15", "left": {"value": "Хх", "audioUrl": "/api/files/Буква «Хх»-5423-d890fffd-39b9-4d6a-8b77-c6a496284be8.mp3"}, "right": {"value": "ххалаххи"}}, {"id": "15cf7594-08fd-4694-b649-9d33e5a64006", "left": {"value": "Хъ", "audioUrl": "/api/files/Буква «Хъ»-5423-3d65370e-4781-41a3-be93-52ad49a163cc.mp3"}, "right": {"value": "хъат1у"}}, {"id": "256ceab9-4c5e-4648-8e48-ed94706d87bd", "left": {"value": "Хь", "audioUrl": "/api/files/Буква «Хь»-5423-65f8c597-4f5b-4a4d-9735-a4166a9aeb4b.mp3"}, "right": {"value": "хьама"}}, {"id": "57ab114b-1ea9-4ce2-a75a-f25d22b892ed", "left": {"value": "Хьхь", "audioUrl": "/api/files/Буква «Хьхь»-5423-56ed3a41-8b64-42c1-be50-f2cfe9553b23.mp3"}, "right": {"value": "хьхьи"}}, {"id": "57e33805-8d45-4712-a833-63343d7b54af", "left": {"value": "Т", "audioUrl": "/api/files/Буква «Т»-5423-e68a61db-0ba8-4bc1-bcc7-f01e19152761.mp3"}, "right": {"value": "тах"}}, {"id": "7732c9ce-9f7d-4150-ba2e-687b039912b0", "left": {"value": "Тт", "audioUrl": "/api/files/Буква «Тт»-5423-473f9c67-07ca-463b-8201-12e3fe1321fd.mp3"}, "right": {"value": "ттукку"}}, {"id": "9420fb62-b5fd-47bc-836f-8f33aac42f39", "left": {"value": "Т1", "audioUrl": "/api/files/Буква «Т1»-5423-6da97c11-0886-46ba-8b39-56b49d44184d.mp3"}, "right": {"value": "т1ут1ти"}}], "right": {"isLetter": false, "onlyAudio": false}, "lessonId": "8"}	10	11	\N	\N	t	2025-11-27 18:03:57.794357	8	1
134	MATCHING_AUDIO	Задание 12 (Прослушай аудио и выбери букву) 	\N	{"left": {"isLetter": true, "onlyAudio": true}, "name": "Задание 12 (Прослушай аудио и выбери букву) ", "word": "", "order": "12", "pairs": [{"id": "beb7a1b4-7196-47c5-9b57-b0160e00e869", "left": {"value": "Х", "audioUrl": "/api/files/Буква «Х»-5423-4f751a03-e198-43b7-bba5-c9737695a787.mp3"}, "right": {"value": "Х", "audioUrl": "/api/files/Буква «Х»-5423-4f751a03-e198-43b7-bba5-c9737695a787.mp3"}}, {"id": "6f8b0925-2abe-430f-83a8-6807d2bb0b98", "left": {"value": "Тт", "audioUrl": "/api/files/Буква «Тт»-5423-473f9c67-07ca-463b-8201-12e3fe1321fd.mp3"}, "right": {"value": "Тт", "audioUrl": "/api/files/Буква «Тт»-5423-473f9c67-07ca-463b-8201-12e3fe1321fd.mp3"}}, {"id": "39e506bf-64d7-4dea-be9c-18c9917004aa", "left": {"value": "Хъ", "audioUrl": "/api/files/Буква «Хъ»-5423-3d65370e-4781-41a3-be93-52ad49a163cc.mp3"}, "right": {"value": "Хъ", "audioUrl": "/api/files/Буква «Хъ»-5423-3d65370e-4781-41a3-be93-52ad49a163cc.mp3"}}, {"id": "3b44443b-5a24-41b2-aa07-9ab56c0c6a40", "left": {"value": "Хх", "audioUrl": "/api/files/Буква «Хх»-5423-d890fffd-39b9-4d6a-8b77-c6a496284be8.mp3"}, "right": {"value": "Хх", "audioUrl": "/api/files/Буква «Хх»-5423-d890fffd-39b9-4d6a-8b77-c6a496284be8.mp3"}}, {"id": "c151b580-4f4d-42e0-bffd-2e749452d70a", "left": {"value": "Т1", "audioUrl": "/api/files/Буква «Т1»-5423-6da97c11-0886-46ba-8b39-56b49d44184d.mp3"}, "right": {"value": "Т1", "audioUrl": "/api/files/Буква «Т1»-5423-6da97c11-0886-46ba-8b39-56b49d44184d.mp3"}}, {"id": "414b7d1b-7289-4f75-927e-2099ba9f47d3", "left": {"value": "Т", "audioUrl": "/api/files/Буква «Т»-5423-e68a61db-0ba8-4bc1-bcc7-f01e19152761.mp3"}, "right": {"value": "Т", "audioUrl": "/api/files/Буква «Т»-5423-e68a61db-0ba8-4bc1-bcc7-f01e19152761.mp3"}}, {"id": "41ca6254-e22a-4c92-838c-892dce13ab22", "left": {"value": "Хь", "audioUrl": "/api/files/Буква «Хь»-5423-65f8c597-4f5b-4a4d-9735-a4166a9aeb4b.mp3"}, "right": {"value": "Хь", "audioUrl": "/api/files/Буква «Хь»-5423-65f8c597-4f5b-4a4d-9735-a4166a9aeb4b.mp3"}}, {"id": "c2b26286-574f-4b7b-9fea-cab95d5fd507", "left": {"value": "Хьхь", "audioUrl": "/api/files/Буква «Хьхь»-5423-56ed3a41-8b64-42c1-be50-f2cfe9553b23.mp3"}, "right": {"value": "Хьхь", "audioUrl": "/api/files/Буква «Хьхь»-5423-56ed3a41-8b64-42c1-be50-f2cfe9553b23.mp3"}}, {"id": "e6190543-c3a4-47c1-bf3b-14802614c86f", "left": {"value": "С", "audioUrl": "/api/files/Буква «С»-5423-be00bab7-bbe1-46a7-ac4b-2500524d930d.mp3"}, "right": {"value": "С", "audioUrl": "/api/files/Буква «С»-5423-be00bab7-bbe1-46a7-ac4b-2500524d930d.mp3"}}, {"id": "a8173127-bc56-4ecb-9b90-f5e2baeb4665", "left": {"value": "Сс", "audioUrl": "/api/files/Буква «Сс»-5423-3e6ccb4f-c14b-4bf7-bd02-0afce26dfe14.mp3"}, "right": {"value": "Сс", "audioUrl": "/api/files/Буква «Сс»-5423-3e6ccb4f-c14b-4bf7-bd02-0afce26dfe14.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "8"}	10	12	\N	\N	t	2025-11-27 18:05:41.953911	8	1
135	MATCHING_AUDIO	Задание 13 (Найди пару)	\N	{"left": {"isLetter": false, "onlyAudio": false}, "name": "Задание 13 (Найди пару)", "word": "", "order": "13", "pairs": [{"id": "35d1755b-8280-4357-a66e-4e40f6c0848b", "left": {"value": "Хялат", "audioUrl": "/api/files/Хялат-5423-5d9c657a-4b1f-499d-88de-3a06c4d8a256.mp3", "displayValue": "...ялат"}, "right": {"value": "Х", "audioUrl": "/api/files/Буква «Х»-5423-4f751a03-e198-43b7-bba5-c9737695a787.mp3"}}, {"id": "19a1e072-85a0-433e-8067-59aca0aba412", "left": {"value": "Ххалаххи", "audioUrl": "/api/files/Ххалаххи-5423-8c2f31cb-c9a3-4f8d-950f-6d683f24aba9.mp3", "displayValue": "...алаххи"}, "right": {"value": "Хх", "audioUrl": "/api/files/Буква «Хх»-5423-d890fffd-39b9-4d6a-8b77-c6a496284be8.mp3"}}, {"id": "198052c8-2297-43e5-a7b5-9692cb2748cc", "left": {"value": "Хъат1у", "audioUrl": "/api/files/Хъат1у-5423-8779ce6e-d293-4197-8c96-af5dfd80a783.mp3", "displayValue": "...ат1у"}, "right": {"value": "Хъ", "audioUrl": "/api/files/Буква «Хъ»-5423-3d65370e-4781-41a3-be93-52ad49a163cc.mp3"}}, {"id": "707c6b73-d228-42a1-8852-1be128ece783", "left": {"value": "Хьама", "audioUrl": "/api/files/Хьама-5423-2179d416-572b-4885-bbd9-9fa3c989e83b.mp3", "displayValue": "...ама"}, "right": {"value": "Хь", "audioUrl": "/api/files/Буква «Хь»-5423-65f8c597-4f5b-4a4d-9735-a4166a9aeb4b.mp3"}}, {"id": "ee3738d9-e1b9-4c14-bb5d-4195c7ff97a4", "left": {"value": "Хьхьи", "audioUrl": "/api/files/Хьхьи-5423-9ffe58df-d76f-4f48-b464-57a904329c69.mp3", "displayValue": "...и"}, "right": {"value": "Хьхь", "audioUrl": "/api/files/Буква «Хьхь»-5423-56ed3a41-8b64-42c1-be50-f2cfe9553b23.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "8"}	10	13	\N	\N	t	2025-11-27 18:06:52.607075	8	1
136	MATCHING	Задание 9 (Найди пару)	\N	{"left": {"isLetter": true, "onlyAudio": false}, "name": "Задание 9 (Найди пару)", "word": "", "order": "9", "pairs": [{"id": "c3f84182-8481-466c-a08b-50f09aceae7d", "left": {"value": "Х1", "audioUrl": "/api/files/Буква «Х1»-5423-77177207-586e-4093-bf68-02c6df00fa2d.mp3"}, "right": {"value": "х1ажак"}}, {"id": "f6b2dcb2-222a-412c-8395-f9ffa9ab3c7f", "left": {"value": "Ц", "audioUrl": "/api/files/Буква «Ц»-5423-80dcb1e2-16a6-4a3f-9e3f-5c943b7d4dc3.mp3"}, "right": {"value": "цулч1а"}}, {"id": "44f804fe-79fa-433d-998d-79dbbed80a1c", "left": {"value": "Цц", "audioUrl": "/api/files/Буква «Цц»-5423-193a4888-79cb-47ba-a24e-6a213dcd3a0b.mp3"}, "right": {"value": "ццацк1улу"}}, {"id": "2f810d62-854f-42d6-b82a-eae124a12766", "left": {"value": "Ц1", "audioUrl": "/api/files/Буква «Ц1»-5423-ae248115-40e6-4e0d-97a5-da226407afac.mp3"}, "right": {"value": "ц1уку"}}], "right": {"isLetter": false, "onlyAudio": false}, "lessonId": "9"}	10	9	\N	\N	t	2025-11-27 18:08:13.646056	9	1
137	MATCHING_AUDIO	Задание 10 (Прослушай аудио и выбери букву) 	\N	{"left": {"isLetter": true, "onlyAudio": true}, "name": "Задание 10 (Прослушай аудио и выбери букву) ", "word": "", "order": "10", "pairs": [{"id": "dd10e8f8-f4be-47be-b47a-c98ebfc09f0d", "left": {"value": "Цц", "audioUrl": "/api/files/Буква «Цц»-5423-193a4888-79cb-47ba-a24e-6a213dcd3a0b.mp3"}, "right": {"value": "Цц", "audioUrl": "/api/files/Буква «Цц»-5423-193a4888-79cb-47ba-a24e-6a213dcd3a0b.mp3"}}, {"id": "bd60bf70-d5f0-47b4-8898-8b53d31a68a3", "left": {"value": "Ц", "audioUrl": "/api/files/Буква «Ц»-5423-80dcb1e2-16a6-4a3f-9e3f-5c943b7d4dc3.mp3"}, "right": {"value": "Ц", "audioUrl": "/api/files/Буква «Ц»-5423-80dcb1e2-16a6-4a3f-9e3f-5c943b7d4dc3.mp3"}}, {"id": "9ba4811f-13eb-49c9-839e-2a626110fb0a", "left": {"value": "Х1", "audioUrl": "/api/files/Буква «Х1»-5423-77177207-586e-4093-bf68-02c6df00fa2d.mp3"}, "right": {"value": "Х1", "audioUrl": "/api/files/Буква «Х1»-5423-77177207-586e-4093-bf68-02c6df00fa2d.mp3"}}, {"id": "58017146-995e-4004-a39c-10648eb23844", "left": {"value": "Ц1", "audioUrl": "/api/files/Буква «Ц1»-5423-ae248115-40e6-4e0d-97a5-da226407afac.mp3"}, "right": {"value": "Ц1", "audioUrl": "/api/files/Буква «Ц1»-5423-ae248115-40e6-4e0d-97a5-da226407afac.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "9"}	10	10	\N	\N	t	2025-11-27 18:09:20.925539	9	1
138	MATCHING_AUDIO	Задание 11 (Найди пару)	\N	{"left": {"isLetter": false, "onlyAudio": false}, "name": "Задание 11 (Найди пару)", "word": "", "order": "11", "pairs": [{"id": "72812f41-2b91-4e43-986d-b5e9baaf1219", "left": {"value": "Х1ажак", "audioUrl": "/api/files/Х1ажак-5423-8557aac4-bad1-498e-9d08-26c9f42e0a7f.mp3", "displayValue": "Х1ажак"}, "right": {"value": "Х1", "audioUrl": "/api/files/Буква «Х1»-5423-77177207-586e-4093-bf68-02c6df00fa2d.mp3"}}, {"id": "55c5f873-67ab-4c76-81f4-5a96e9b49644", "left": {"value": "Цулч1а", "audioUrl": "/api/files/Цулч1а-5423-4c57264c-5953-4413-8ac3-8786bd40b51b.mp3", "displayValue": "Цулч1а"}, "right": {"value": "Ц", "audioUrl": "/api/files/Буква «Ц»-5423-80dcb1e2-16a6-4a3f-9e3f-5c943b7d4dc3.mp3"}}, {"id": "b9c9594f-f88a-4dcc-8762-49ed728cec2e", "left": {"value": "Ццацк1улу", "audioUrl": "/api/files/Ццацк1улу-5423-7019adad-1f77-497c-96f4-b22b1c6f307b.mp3", "displayValue": "Ццацк1улу"}, "right": {"value": "Цц", "audioUrl": "/api/files/Буква «Цц»-5423-193a4888-79cb-47ba-a24e-6a213dcd3a0b.mp3"}}, {"id": "ee3a30e1-e307-4122-8959-cd0519036655", "left": {"value": "Ц1уку", "audioUrl": "/api/files/Ц1уку-5423-e124ecd1-275a-4f30-b999-bb1a6fe016a9.mp3", "displayValue": "Ц1уку"}, "right": {"value": "Ц1", "audioUrl": "/api/files/Буква «Ц1»-5423-ae248115-40e6-4e0d-97a5-da226407afac.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "9"}	10	11	\N	\N	t	2025-11-27 18:10:26.563512	9	1
139	MATCHING	Задание 11 (Найди пару)	\N	{"left": {"isLetter": true, "onlyAudio": false}, "name": "Задание 11 (Найди пару)", "word": "", "order": "11", "pairs": [{"id": "db3952fe-0315-4517-9c06-21645d7d0914", "left": {"value": "Х1", "audioUrl": "/api/files/Буква «Х1»-5423-77177207-586e-4093-bf68-02c6df00fa2d.mp3"}, "right": {"value": "х1ажак"}}, {"id": "32b5f79d-068e-468a-9b73-5acdaa7a246f", "left": {"value": "Ц", "audioUrl": "/api/files/Буква «Ц»-5423-80dcb1e2-16a6-4a3f-9e3f-5c943b7d4dc3.mp3"}, "right": {"value": "цулч1а"}}, {"id": "9794ea21-117c-4915-a5cf-f592487c04ad", "left": {"value": "Ш", "audioUrl": "/api/files/Буква «Ш»-5423-5129fdb5-5b7f-475b-af53-9ad637749666.mp3"}, "right": {"value": "шанч1ап1и"}}, {"id": "d64c6551-db03-4ba6-a2ab-d4c60a3c0b93", "left": {"value": "Ч", "audioUrl": "/api/files/Буква «Ч»-5423-0f4c83ef-9f9c-4ba9-9871-4c63a8192118.mp3"}, "right": {"value": "чассаг"}}, {"id": "f080c4f1-8b86-44e8-8d13-a69c0e96282f", "left": {"value": "Чч", "audioUrl": "/api/files/Буква «Чч»-5423-59130039-e4e7-4306-a77d-5758837463dc.mp3"}, "right": {"value": "ччиту"}}, {"id": "fda509d3-0e50-4705-b46a-027c1981edab", "left": {"value": "Ч1", "audioUrl": "/api/files/Буква «Ч1»-5423-3321c0ed-e345-47f1-a2b0-57edd63ad399.mp3"}, "right": {"value": "ч1и"}}, {"id": "3d4685de-ca38-4bbc-8bbf-5fc220ebf1b3", "left": {"value": "Щ", "audioUrl": "/api/files/Буква «Щ»-5423-217be1e3-58bf-44ef-b954-d2e71c80b649.mp3"}, "right": {"value": "щин"}}, {"id": "b40be19d-925f-45d0-8287-d2b74c615791", "left": {"value": "Цц", "audioUrl": "/api/files/Буква «Цц»-5423-193a4888-79cb-47ba-a24e-6a213dcd3a0b.mp3"}, "right": {"value": "ццацк1улу"}}, {"id": "224e2b0a-947c-47a0-b183-7fbaf786a16b", "left": {"value": "Ц1", "audioUrl": "/api/files/Буква «Ц1»-5423-ae248115-40e6-4e0d-97a5-da226407afac.mp3"}, "right": {"value": "ц1уку"}}], "right": {"isLetter": false, "onlyAudio": false}, "lessonId": "10"}	10	11	\N	\N	t	2025-11-27 18:11:59.556854	10	1
140	MATCHING_AUDIO	Задание 12 (Прослушай аудио и выбери букву)	\N	{"left": {"isLetter": true, "onlyAudio": true}, "name": "Задание 12 (Прослушай аудио и выбери букву)", "word": "", "order": "12", "pairs": [{"id": "523657f6-d08e-444e-88f2-e64077d9b4bd", "left": {"value": "Х1", "audioUrl": "/api/files/Буква «Х1»-5423-77177207-586e-4093-bf68-02c6df00fa2d.mp3"}, "right": {"value": "Х1", "audioUrl": "/api/files/Буква «Х1»-5423-77177207-586e-4093-bf68-02c6df00fa2d.mp3"}}, {"id": "7147401d-083e-4f24-88e5-f4fa2cc6c4b7", "left": {"value": "Ц", "audioUrl": "/api/files/Буква «Ц»-5423-80dcb1e2-16a6-4a3f-9e3f-5c943b7d4dc3.mp3"}, "right": {"value": "Ц", "audioUrl": "/api/files/Буква «Ц»-5423-80dcb1e2-16a6-4a3f-9e3f-5c943b7d4dc3.mp3"}}, {"id": "ee3a4bc1-2e69-46f2-ab6f-747726d8a15f", "left": {"value": "Цц", "audioUrl": "/api/files/Буква «Цц»-5423-193a4888-79cb-47ba-a24e-6a213dcd3a0b.mp3"}, "right": {"value": "Цц", "audioUrl": "/api/files/Буква «Цц»-5423-193a4888-79cb-47ba-a24e-6a213dcd3a0b.mp3"}}, {"id": "f59f1ca1-cb94-4778-82e2-5964d6e83116", "left": {"value": "Ц1", "audioUrl": "/api/files/Буква «Ц1»-5423-ae248115-40e6-4e0d-97a5-da226407afac.mp3"}, "right": {"value": "Ц1", "audioUrl": "/api/files/Буква «Ц1»-5423-ae248115-40e6-4e0d-97a5-da226407afac.mp3"}}, {"id": "72e7e1dc-2ba2-4d54-934c-c1cb346710a0", "left": {"value": "Ч", "audioUrl": "/api/files/Буква «Ч»-5423-0f4c83ef-9f9c-4ba9-9871-4c63a8192118.mp3"}, "right": {"value": "Ч", "audioUrl": "/api/files/Буква «Ч»-5423-0f4c83ef-9f9c-4ba9-9871-4c63a8192118.mp3"}}, {"id": "2e687e2f-b5b0-4ab9-856a-2740ea03068c", "left": {"value": "Чч", "audioUrl": "/api/files/Буква «Чч»-5423-59130039-e4e7-4306-a77d-5758837463dc.mp3"}, "right": {"value": "Чч", "audioUrl": "/api/files/Буква «Чч»-5423-59130039-e4e7-4306-a77d-5758837463dc.mp3"}}, {"id": "df476701-2ba3-4d23-8a6a-bbed32baf760", "left": {"value": "Ч1", "audioUrl": "/api/files/Буква «Ч1»-5423-3321c0ed-e345-47f1-a2b0-57edd63ad399.mp3"}, "right": {"value": "Ч1", "audioUrl": "/api/files/Буква «Ч1»-5423-3321c0ed-e345-47f1-a2b0-57edd63ad399.mp3"}}, {"id": "ec2804ce-24ef-4181-afbe-a1061b2d5cc1", "left": {"value": "Ш", "audioUrl": "/api/files/Буква «Ш»-5423-5129fdb5-5b7f-475b-af53-9ad637749666.mp3"}, "right": {"value": "Ш", "audioUrl": "/api/files/Буква «Ш»-5423-5129fdb5-5b7f-475b-af53-9ad637749666.mp3"}}, {"id": "968979cf-0828-48af-903e-88a8f24cfe4f", "left": {"value": "Щ", "audioUrl": "/api/files/Буква «Щ»-5423-217be1e3-58bf-44ef-b954-d2e71c80b649.mp3"}, "right": {"value": "Щ", "audioUrl": "/api/files/Буква «Щ»-5423-217be1e3-58bf-44ef-b954-d2e71c80b649.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "10"}	10	12	\N	\N	t	2025-11-27 18:13:14.880533	10	1
141	MATCHING_AUDIO	Задание 13 (Найди пару) 	\N	{"left": {"isLetter": false, "onlyAudio": false}, "name": "Задание 13 (Найди пару) ", "word": "", "order": "13", "pairs": [{"id": "705c766b-6139-4535-9b3f-7a7b2eb0d981", "left": {"value": "Чассаг", "audioUrl": "/api/files/Чассаг-5423-04d3fa61-41cc-4c60-a0c0-b7a9d241556c.mp3", "displayValue": "...ассаг"}, "right": {"value": "Ч", "audioUrl": "/api/files/Буква «Ч»-5423-0f4c83ef-9f9c-4ba9-9871-4c63a8192118.mp3"}}, {"id": "a0f7c069-bf47-459e-aa17-5992a767619f", "left": {"value": "Ччиту", "audioUrl": "/api/files/Ччиту-5423-13bc4875-ed49-4ef4-ae39-4488410ef7b8.mp3", "displayValue": "...иту"}, "right": {"value": "Чч", "audioUrl": "/api/files/Буква «Чч»-5423-59130039-e4e7-4306-a77d-5758837463dc.mp3"}}, {"id": "a0dc1797-c85a-4af0-9324-1e6e420d6316", "left": {"value": "Ч1и", "audioUrl": "/api/files/Ч1и-5423-7c374dc7-c32c-4b22-82af-36513c662a98.mp3", "displayValue": "...и"}, "right": {"value": "Ч1", "audioUrl": "/api/files/Буква «Ч1»-5423-3321c0ed-e345-47f1-a2b0-57edd63ad399.mp3"}}, {"id": "7ff3e7dd-51aa-4520-8d6d-11c9269bc698", "left": {"value": "Шанч1ап1и", "audioUrl": "/api/files/Шанч1ап1и-5423-42153ba9-6fba-4823-a938-3da4806b7396.mp3", "displayValue": "...анч1ап1и"}, "right": {"value": "Ш", "audioUrl": "/api/files/Буква «Ш»-5423-5129fdb5-5b7f-475b-af53-9ad637749666.mp3"}}, {"id": "605d9d2e-5faf-487e-b2c7-2d252b07587a", "left": {"value": "Щин", "audioUrl": "/api/files/Щин-5423-8477bc67-2b27-4b9c-a600-ac2720c57fa0.mp3", "displayValue": "...ин"}, "right": {"value": "Щ", "audioUrl": "/api/files/Буква «Щ»-5423-217be1e3-58bf-44ef-b954-d2e71c80b649.mp3"}}], "right": {"isLetter": true, "onlyAudio": false}, "lessonId": "10"}	10	13	\N	\N	t	2025-11-27 18:14:55.00835	10	1
\.


--
-- Data for Name: language; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.language (id, code, name, "flagEmoji", "flagUrl", description, difficulty, "isActive", "totalModules", "totalExercises", "createdAt", vocabulary) FROM stdin;
1	la	Лакский	\N	\N	\N	0	t	0	0	2025-11-12 10:43:45.389638	[{"word": "Ажари", "audioUrl": "/api/files/Ажари-5423-4fae985d-eb8a-49e9-a567-bab993d1e1a6.mp3", "imageUrl": "/api/files/ажари – петух-5423-eeb08795-825b-4b3b-b11f-27eaf21be608.png"}, {"word": "Аьнак1и", "audioUrl": "/api/files/Аьнак1и-5423-145a9194-5325-4fc9-b855-76052ea734cb.mp3", "imageUrl": "/api/files/аьнак1и – курица-5423-6bc282d3-c244-4644-a59a-b4bfdaba5164.png"}, {"word": "Бюрх", "audioUrl": "/api/files/Бюрх-5423-e34b1ce4-d465-4b4a-95dc-37d3e90b0d5b.mp3", "imageUrl": "/api/files/бюрх – заяц-5423-fcb9fe42-2ec2-4285-997c-625ac853554c.png"}, {"word": "Варани", "audioUrl": "/api/files/Варани-5423-d240c8f1-693b-4743-a5e9-69528441fc8d.mp3", "imageUrl": "/api/files/варани – верблюд -5423-ac1e345f-90cd-4262-bdda-906b15ac8158.png"}, {"word": "Гъангъарат1и", "audioUrl": "/api/files/Гъангъарат1и-5423-a006b9d8-9fcc-47c8-b6ca-bc90c69652c8.mp3", "imageUrl": "/api/files/гъангъарат1и – жук -5423-64c975ef-0b52-4f74-824b-cbde8e47f63f.png"}, {"word": "Гьивч", "audioUrl": "/api/files/Гьивч-5423-53ae75a7-f970-4121-ad10-5187e78e1ccf.mp3", "imageUrl": "/api/files/гьивч – яблоко -5423-2a30a4b4-1f1b-4ba9-b641-5ce5ac5ccf8b.png"}, {"word": "Гюнгут1и", "audioUrl": "/api/files/Гюнгут1и-5423-3062f0ad-cfcb-4401-a889-88d31f5d7cde.mp3", "imageUrl": "/api/files/гюнгут1и – колокольчик -5423-65824ac5-bcfc-4988-a684-bcef7b72c785.png"}, {"word": "Дач1у", "audioUrl": "/api/files/Дач1у-5423-d023263e-7278-4ce4-b116-1ba54bb8a29a.mp3", "imageUrl": "/api/files/дач1у – барабан -5423-6154300e-8016-4f0b-80ab-2cd78f1d49e8.png"}, {"word": "Жулар", "audioUrl": "/api/files/Жулар-5423-033f4ba4-67d6-4733-80a5-f0d9850e4cb6.mp3", "imageUrl": "/api/files/жулар – носок -5423-988b736f-6a14-45fd-8f5d-ad7b7fc60aaf.png"}, {"word": "Зимиз", "audioUrl": "/api/files/Зимиз-5423-9fc2ebb0-4d6b-493e-a603-24d04c632440.mp3", "imageUrl": "/api/files/зимиз – муха -5423-3a2a2c73-11fd-4b4e-8062-a5481de3cc0c.png"}, {"word": "Ису", "audioUrl": "/api/files/Ису-5423-d495b78d-b8b0-4cfe-95ed-fe28339bbaa7.mp3", "imageUrl": "/api/files/ису – сова-5423-25ab62ce-bd50-442d-874d-66b498b8fc5c.png"}, {"word": "К1улу", "audioUrl": "/api/files/К1улу-5423-cc7be8cb-bf3d-4f03-a954-61b1e7a67d35.mp3", "imageUrl": "/api/files/к1улу – мышь-5423-6d23212a-a27b-47f4-81d2-4ef7cf2afc68.png"}, {"word": "Ка", "audioUrl": "/api/files/Ка-5423-58a6f62d-e223-4ffd-8e16-0eb1fb05b8ce.mp3", "imageUrl": "/api/files/ка – рука -5423-a7fc0feb-1ae9-4db0-8180-dfbcac12388c.png"}, {"word": "Ккунук", "audioUrl": "/api/files/Ккунук-5423-e29eacd5-d889-4a9c-a1f5-d4b53c83d9db.mp3", "imageUrl": "/api/files/ккунук – яйцо -5423-2fbeeb23-1931-41d8-be6d-7290c1ef6f75.png"}, {"word": "Къаз", "audioUrl": "/api/files/Къаз-5423-9d345a0a-ffd9-40f9-a89d-41cbc56a7bc2.mp3", "imageUrl": "/api/files/къаз – гусь -5423-2d9bd2c8-8e7e-4e91-b088-37cd23ef8218.png"}, {"word": "Кьая", "audioUrl": "/api/files/Кьая-5423-9cf55d89-2f2e-4cd9-9bd6-7fd4421f2c47.mp3", "imageUrl": "/api/files/кьая – редька-5423-22506d23-2672-4532-a093-209d4903c938.png"}, {"word": "Лу", "audioUrl": "/api/files/Лу-5423-51c358a4-04e0-48c6-916c-e773bec81a25.mp3", "imageUrl": "/api/files/лу – книга -5423-cc1025eb-74c2-4156-a7c5-6551f9e082b5.png"}, {"word": "Маз", "audioUrl": "/api/files/Маз-5423-6df0f25a-9709-41bf-bbdd-7dfd6b93ff19.mp3", "imageUrl": "/api/files/маз – язык -5423-4eaf3e5b-5b87-42d9-bef8-e41ccc5c084e.png"}, {"word": "Меч1", "audioUrl": "/api/files/Меч1-5423-b8725c6d-32c1-46af-86ef-49da7ab0ee2a.mp3", "imageUrl": "/api/files/меч1 – крапива-5423-ea80e01c-8946-4d1d-ba12-176949339b74.png"}, {"word": "Нисварти", "audioUrl": "/api/files/Нисварти-5423-ad262047-12e7-4316-91ae-3c4716980ed6.mp3", "imageUrl": "/api/files/нисварти – огурец -5423-58b5c08c-168c-4cc9-8f11-a5af74d28ec8.png"}, {"word": "Оьл", "audioUrl": "/api/files/Оьл-5423-5be65dae-9035-41d3-8bcc-39fe7db887fb.mp3", "imageUrl": "/api/files/оьл – корова-5423-94a343b3-c217-4585-b1d1-088d08da4174.png"}, {"word": "П1илц1у", "audioUrl": "/api/files/П1илц1у-5423-bf175349-5444-4c77-ba45-84a142b6fd4d.mp3", "imageUrl": "/api/files/п1илц1у – искра-5423-db1a3c58-44eb-47f5-a5fb-6eb727b68f97.png"}, {"word": "Пил", "audioUrl": "/api/files/Пил-5423-1e467421-f7fe-4ab0-a926-37ff87a5256b.mp3", "imageUrl": "/api/files/пил – слон-5423-294c88cc-959d-4ebf-b728-e68db16f4da2.png"}, {"word": "Ппиринж", "audioUrl": "/api/files/Ппиринж-5423-256f06ad-f196-4cef-884f-0ac21a9d92a3.mp3", "imageUrl": "/api/files/ппиринж – рис-5423-f8a47d88-e5fa-4c6d-baf4-682b42d7890b.png"}, {"word": "Рах1у", "audioUrl": "/api/files/Рах1у-5423-c278504c-3c51-4569-a3a6-31fb6f08e129.mp3", "imageUrl": "/api/files/рах1у – шуба-5423-48de76be-578b-484f-8c51-2ea1abc1b03e.png"}, {"word": "Ссят", "audioUrl": "/api/files/Ссят-5423-fdd5aacf-971c-405a-a547-3b561bf68e55.mp3", "imageUrl": "/api/files/ссят – часы -5423-ca5d4cc0-84ca-4bef-a396-abf1358530c8.png"}, {"word": "Сунув", "audioUrl": "/api/files/Сунув-5423-b1ec48eb-1442-4011-9d12-223c55ceefaa.mp3", "imageUrl": "/api/files/сунув – гранат -5423-47757f19-a541-44ac-a19b-a479b549918b.png"}, {"word": "Т1ут1и", "audioUrl": "/api/files/Т1ут1и-5423-1d2c8c3a-935b-4f01-9f9a-724d23a4577c.mp3", "imageUrl": "/api/files/т1ут1и – цветок-5423-09fd4c0e-ac2d-4011-9be0-af0d28c14545.png"}, {"word": "Тах", "audioUrl": "/api/files/Тах-5423-86612fd5-07ff-4b32-915b-44cbaa2c1730.mp3", "imageUrl": "/api/files/тах – кровать -5423-362924bc-0723-4a3a-883d-80fdc2529b03.png"}, {"word": "Ттукку", "audioUrl": "/api/files/Ттукку-5423-4372c22c-15b7-4ba6-8c3f-7c1d055e69ca.mp3", "imageUrl": "/api/files/ттукку – осел -5423-e99c97b6-f7c5-4e6a-ab98-7dff16936290.png"}, {"word": "Урдак", "audioUrl": "/api/files/Урдак-5423-aaab9cfa-0d6d-4405-a082-62e6ce609ca7.mp3", "imageUrl": "/api/files/урдак – утка-5423-8d677b5d-31d1-484a-857b-3af8809d9608.png"}, {"word": "Х1ажак", "audioUrl": "/api/files/Х1ажак-5423-8557aac4-bad1-498e-9d08-26c9f42e0a7f.mp3", "imageUrl": "/api/files/х1ажак – брюки -5423-f5c25c91-abc5-46fa-83c0-d28377126407.JPG"}, {"word": "Ххалаххи", "audioUrl": "/api/files/Ххалаххи-5423-8c2f31cb-c9a3-4f8d-950f-6d683f24aba9.mp3", "imageUrl": "/api/files/ххалаххи – иголка -5423-07c039eb-b891-4ad7-a1b7-9227e515fa36.JPG"}, {"word": "Хъат1у", "audioUrl": "/api/files/Хъат1у-5423-8779ce6e-d293-4197-8c96-af5dfd80a783.mp3", "imageUrl": "/api/files/хъат1у – ворон -5423-c80ca21c-0bed-4fe7-ad08-5f68da2bd49a.JPG"}, {"word": "Хьама", "audioUrl": "/api/files/Хьама-5423-2179d416-572b-4885-bbd9-9fa3c989e83b.mp3", "imageUrl": "/api/files/хьама – пена -5423-51e6ed2b-ed99-4ca2-9ffa-5ae4add9f5b3.JPG"}, {"word": "Хьхьи", "audioUrl": "/api/files/Хьхьи-5423-9ffe58df-d76f-4f48-b464-57a904329c69.mp3", "imageUrl": "/api/files/хьхьи – голубь -5423-9726990a-fed5-4c98-b12b-805f1ed04d24.JPG"}, {"word": "Хялат", "audioUrl": "/api/files/Хялат-5423-5d9c657a-4b1f-499d-88de-3a06c4d8a256.mp3", "imageUrl": "/api/files/хялат – халат -5423-eec5eb7b-a86f-4f2d-a6f6-cc312b22d810.png"}, {"word": "Ц1уку", "audioUrl": "/api/files/Ц1уку-5423-e124ecd1-275a-4f30-b999-bb1a6fe016a9.mp3", "imageUrl": "/api/files/ц1уку – коза -5423-c6f73f4b-90aa-4292-85d6-8b75e62860ed.JPG"}, {"word": "Цулч1а", "audioUrl": "/api/files/Цулч1а-5423-4c57264c-5953-4413-8ac3-8786bd40b51b.mp3", "imageUrl": "/api/files/цулч1а – лиса -5423-5d1f2ef3-f238-41c3-bb53-c19bf2295f2a.JPG"}, {"word": "Чассаг", "audioUrl": "/api/files/Чассаг-5423-04d3fa61-41cc-4c60-a0c0-b7a9d241556c.mp3", "imageUrl": "/api/files/чассаг - финик -5423-0c7fbde1-82d1-4e64-8cd3-1151513a63a7.JPG"}, {"word": "Ч1и", "audioUrl": "/api/files/Ч1и-5423-7c374dc7-c32c-4b22-82af-36513c662a98.mp3", "imageUrl": "/api/files/ч1и - ягненок-5423-2f36c65a-5c1a-4260-977c-646af5bb59f8.JPG"}, {"word": "Ццацк1улу", "audioUrl": "/api/files/Ццацк1улу-5423-7019adad-1f77-497c-96f4-b22b1c6f307b.mp3", "imageUrl": "/api/files/ццацк1улу – еж -5423-569c58e3-41a7-494f-ae4d-fe4ab0b9dbb9.JPG"}, {"word": "Тяй", "audioUrl": "/api/files/Тяй-5423-f9be5d68-d382-4ca9-bc8d-8e42a5299a30.mp3", "imageUrl": "/api/files/тяй – жеребенок-5423-8d6be7c8-bfaa-493b-9d7a-1a541a337935.png"}, {"word": "Ччиту", "audioUrl": "/api/files/Ччиту-5423-13bc4875-ed49-4ef4-ae39-4488410ef7b8.mp3", "imageUrl": "/api/files/ччиту – кошка -5423-e388b617-4628-45f8-9d6c-a41232d2ce67.JPG"}, {"word": "Шанч1ап1и", "audioUrl": "/api/files/Шанч1ап1и-5423-42153ba9-6fba-4823-a938-3da4806b7396.mp3", "imageUrl": "/api/files/шанч1ап1и – клевер -5423-7f93cef5-4fc8-4116-920c-6a34703d9bda.JPG"}, {"word": "Щин", "audioUrl": "/api/files/Щин-5423-8477bc67-2b27-4b9c-a600-ac2720c57fa0.mp3", "imageUrl": "/api/files/щин – вода-5423-718f0685-bdfb-4eba-be76-41403eb1a9ef.png"}, {"word": "Экьрав", "audioUrl": "/api/files/Экьрав-5423-cf4158a2-45b7-4d58-b61b-a78522eadc33.mp3", "imageUrl": "/api/files/экьрав – скорпион-5423-c73780d7-d375-48c6-b749-b9ad41ec3164.png"}, {"word": "Юзбаши", "audioUrl": "/api/files/Юзбаши-5423-32e46037-82f5-410c-8883-b1cd10292d9a.mp3", "imageUrl": "/api/files/юзбаши – аульный староста-5423-ce25193e-5b33-4538-a4cb-42ff17944585.png"}, {"word": "Яру", "audioUrl": "/api/files/Яру-5423-e8debc29-7767-4905-b4ca-41d8d7435ab6.mp3", "imageUrl": "/api/files/яру – глаза-5423-ea0d0855-1a66-4103-9f6d-fae76160d6f7.png"}]
\.


--
-- Data for Name: learning_modules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.learning_modules (id, title, description, "order", difficulty, "imageUrl", "estimatedDuration", "totalLessons", "totalExercises", "isActive", "createdAt", "languageId") FROM stdin;
1	Модуль 1 – изучение алфавита	изучение алфавита	0	BEGINNER	\N	0	0	0	t	2025-11-26 14:17:43.226358	1
\.


--
-- Data for Name: lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lesson (id, title, description, "order", duration, "videoUrl", vocabulary, "grammarNotes", "isActive", "createdAt", "modsId", "languageId") FROM stdin;
1	1 урок (а,аь,и,е,й) 	а,аь,и,е,й	1	0	\N	\N	\N	t	2025-11-26 14:18:14.475376	1	1
2	2 урок (оь,у, я, э,ю)	оь,у, я, э,ю	2	0	\N	\N	\N	t	2025-11-26 14:35:59.226944	1	1
3	3 урок (б,в,г,гъ,гь)	б,в,г,гъ,гь	3	0	\N	\N	\N	t	2025-11-26 14:36:12.004428	1	1
4	4 урок (д,ж,з,к,кк) 	д,ж,з,к,кк	4	0	\N	\N	\N	t	2025-11-26 14:36:23.01392	1	1
5	5 урок (къ,кь,к1,л,м)	къ,кь,к1,л,м	5	0	\N	\N	\N	t	2025-11-26 14:36:34.500318	1	1
6	6 урок (н,п,пп,п1,р)	н,п,пп,п1,р	6	0	\N	\N	\N	t	2025-11-26 14:36:48.925228	1	1
7	7 урок (с,сс,т,тт,т1)	с,сс,т,тт,т1	7	0	\N	\N	\N	t	2025-11-26 14:37:03.87563	1	1
8	8 урок (х,хх,хъ,хь,хьхь) 	х,хх,хъ,хь,хьхь	8	0	\N	\N	\N	t	2025-11-26 14:37:15.953755	1	1
9	9 урок (х1,ц,цц,ц1)	х1,ц,цц,ц1	9	0	\N	\N	\N	t	2025-11-26 14:37:29.4599	1	1
10	10 урок (ч,чч,ч1,ш,щ)	ч,чч,ч1,ш,щ	10	0	\N	\N	\N	t	2025-11-26 14:37:39.972359	1	1
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, "timestamp", name) FROM stdin;
1	1761984700587	Initial1761984700587
2	1762330687092	Alphabet1762330687092
3	1762412927105	FixExercise1762412927105
4	1763283620498	AddExerciseType1763283620498
5	1764143928742	AddVocabularyToLanguage1764143928742
6	1764154949809	AddLanguageToLesson1764154949809
7	1764155523285	UpdateLessonProgress1764155523285
8	1764247094416	AddExerciseType1764247094416
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, email, password, name, "avatarUrl", "isActive", age, sex, phone, "createdAt", "updatedAt") FROM stdin;
f4bae21f-59b5-464c-ab15-1c13fb756d4c	admin@lingo.ru	$2b$10$tEVXtLjTJ4x9BvRxsDj8WeTnP2acpwzjdUSbpaCQb1xxysH7v2PQa	admin	\N	t	\N	\N	\N	2025-11-12 10:37:49.468321	2025-11-12 10:37:49.468321
1db23048-2d66-416d-b41c-d68d4155a393	test@lingo.ru	$2b$10$qrOHbFLCm/xzGVZoQdbciO/NYQKzlJRmnJC3zjSDZOMuzjXv2PlwG	test	\N	t	\N	\N	\N	2025-11-16 13:32:15.960083	2025-11-16 13:32:15.960083
\.


--
-- Data for Name: user_exercise_progress; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_exercise_progress (id, completed, score, attempts, "userAnswers", "timeSpent", "startedAt", "completedAt", "userId", "exerciseId") FROM stdin;
\.


--
-- Data for Name: user_language; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_language (id, level, progress, "isActive", "totalPoints", streak, "startedAt", "lastPracticedAt", "userId", "languageId") FROM stdin;
\.


--
-- Data for Name: user_lesson_progress; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_lesson_progress (id, completed, progress, score, "timeSpent", "startedAt", "completedAt", "userId", "lessonId") FROM stdin;
\.


--
-- Data for Name: user_module_progress; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_module_progress (id, completed, progress, score, "timeSpent", "startedAt", "completedAt", "userId", "modsId") FROM stdin;
\.


--
-- Data for Name: user_progress; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_progress (id, "overallProgress", "totalPoints", "completedExercises", "totalExercises", "completedLessons", "totalLessons", "completedModules", "totalModules", streak, "dailyGoal", "dailyProgress", "lastActivityAt", "lastActivityDate", "userId", "languageId") FROM stdin;
\.


--
-- Name: alphabet_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alphabet_item_id_seq', 109, true);


--
-- Name: exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exercise_id_seq', 141, true);


--
-- Name: language_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.language_id_seq', 2, true);


--
-- Name: learning_modules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.learning_modules_id_seq', 1, true);


--
-- Name: lesson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lesson_id_seq', 10, true);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 8, true);


--
-- Name: user_exercise_progress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_exercise_progress_id_seq', 1, false);


--
-- Name: user_language_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_language_id_seq', 1, false);


--
-- Name: user_lesson_progress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_lesson_progress_id_seq', 1, false);


--
-- Name: user_module_progress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_module_progress_id_seq', 1, false);


--
-- Name: user_progress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_progress_id_seq', 1, false);


--
-- Name: lesson PK_0ef25918f0237e68696dee455bd; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT "PK_0ef25918f0237e68696dee455bd" PRIMARY KEY (id);


--
-- Name: user_lesson_progress PK_2d52c2d4b5f26e61b3169d3d01a; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_lesson_progress
    ADD CONSTRAINT "PK_2d52c2d4b5f26e61b3169d3d01a" PRIMARY KEY (id);


--
-- Name: learning_modules PK_5884364b4820dc6ee536d3f65ff; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learning_modules
    ADD CONSTRAINT "PK_5884364b4820dc6ee536d3f65ff" PRIMARY KEY (id);


--
-- Name: user_progress PK_7b5eb2436efb0051fdf05cbe839; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_progress
    ADD CONSTRAINT "PK_7b5eb2436efb0051fdf05cbe839" PRIMARY KEY (id);


--
-- Name: migrations PK_8c82d7f526340ab734260ea46be; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id);


--
-- Name: user_module_progress PK_8d9058401cea716db7be56855d9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_module_progress
    ADD CONSTRAINT "PK_8d9058401cea716db7be56855d9" PRIMARY KEY (id);


--
-- Name: user_language PK_948d2ecd168ffdbb308c1bc8a27; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_language
    ADD CONSTRAINT "PK_948d2ecd168ffdbb308c1bc8a27" PRIMARY KEY (id);


--
-- Name: user_exercise_progress PK_9546a0f74c6871e58d880443221; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_exercise_progress
    ADD CONSTRAINT "PK_9546a0f74c6871e58d880443221" PRIMARY KEY (id);


--
-- Name: exercise PK_a0f107e3a2ef2742c1e91d97c14; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercise
    ADD CONSTRAINT "PK_a0f107e3a2ef2742c1e91d97c14" PRIMARY KEY (id);


--
-- Name: alphabet_item PK_aec691af3c032eaab355004afd1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alphabet_item
    ADD CONSTRAINT "PK_aec691af3c032eaab355004afd1" PRIMARY KEY (id);


--
-- Name: user PK_cace4a159ff9f2512dd42373760; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "PK_cace4a159ff9f2512dd42373760" PRIMARY KEY (id);


--
-- Name: language PK_cc0a99e710eb3733f6fb42b1d4c; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language
    ADD CONSTRAINT "PK_cc0a99e710eb3733f6fb42b1d4c" PRIMARY KEY (id);


--
-- Name: language UQ_465b3173cdddf0ac2d3fe73a33c; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language
    ADD CONSTRAINT "UQ_465b3173cdddf0ac2d3fe73a33c" UNIQUE (code);


--
-- Name: user UQ_e12875dfb3b1d92d7d7c5377e22; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "UQ_e12875dfb3b1d92d7d7c5377e22" UNIQUE (email);


--
-- Name: exercise FK_20dd373d7e46d388216b913062b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercise
    ADD CONSTRAINT "FK_20dd373d7e46d388216b913062b" FOREIGN KEY ("languageId") REFERENCES public.language(id) ON DELETE SET NULL;


--
-- Name: user_lesson_progress FK_27792bdc478c840e0b84095bf96; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_lesson_progress
    ADD CONSTRAINT "FK_27792bdc478c840e0b84095bf96" FOREIGN KEY ("userId") REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: user_language FK_43d5b919c56d00a9f61ae8bf4cf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_language
    ADD CONSTRAINT "FK_43d5b919c56d00a9f61ae8bf4cf" FOREIGN KEY ("userId") REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: user_exercise_progress FK_67ec8aab514c6c114dfaedc178a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_exercise_progress
    ADD CONSTRAINT "FK_67ec8aab514c6c114dfaedc178a" FOREIGN KEY ("exerciseId") REFERENCES public.exercise(id);


--
-- Name: user_lesson_progress FK_881fed870b83f86385c3d94523c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_lesson_progress
    ADD CONSTRAINT "FK_881fed870b83f86385c3d94523c" FOREIGN KEY ("lessonId") REFERENCES public.lesson(id) ON DELETE SET NULL;


--
-- Name: lesson FK_8f346da43831459ea8601f5a847; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT "FK_8f346da43831459ea8601f5a847" FOREIGN KEY ("modsId") REFERENCES public.learning_modules(id);


--
-- Name: user_module_progress FK_a05dcf2280e8e1b61a0c6eac265; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_module_progress
    ADD CONSTRAINT "FK_a05dcf2280e8e1b61a0c6eac265" FOREIGN KEY ("userId") REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: user_module_progress FK_a6fa58bb2cad4b99b8ac5796d4f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_module_progress
    ADD CONSTRAINT "FK_a6fa58bb2cad4b99b8ac5796d4f" FOREIGN KEY ("modsId") REFERENCES public.learning_modules(id);


--
-- Name: learning_modules FK_afe8c5092e31ef6f9c9f7b21398; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learning_modules
    ADD CONSTRAINT "FK_afe8c5092e31ef6f9c9f7b21398" FOREIGN KEY ("languageId") REFERENCES public.language(id);


--
-- Name: user_progress FK_b5d0e1b57bc6c761fb49e79bf89; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_progress
    ADD CONSTRAINT "FK_b5d0e1b57bc6c761fb49e79bf89" FOREIGN KEY ("userId") REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: exercise FK_c69ee003b92a04b61c8255d6deb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercise
    ADD CONSTRAINT "FK_c69ee003b92a04b61c8255d6deb" FOREIGN KEY ("lessonId") REFERENCES public.lesson(id) ON DELETE SET NULL;


--
-- Name: user_language FK_ce64abf864b84feda3b2d3d923e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_language
    ADD CONSTRAINT "FK_ce64abf864b84feda3b2d3d923e" FOREIGN KEY ("languageId") REFERENCES public.language(id);


--
-- Name: user_progress FK_d45e84b24bb0a4987f7dc7c5bcd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_progress
    ADD CONSTRAINT "FK_d45e84b24bb0a4987f7dc7c5bcd" FOREIGN KEY ("languageId") REFERENCES public.language(id);


--
-- Name: lesson FK_d56e101695dc9292af226db76b2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT "FK_d56e101695dc9292af226db76b2" FOREIGN KEY ("languageId") REFERENCES public.language(id);


--
-- Name: user_exercise_progress FK_d9794ca634e8d389350c3861f49; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_exercise_progress
    ADD CONSTRAINT "FK_d9794ca634e8d389350c3861f49" FOREIGN KEY ("userId") REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: alphabet_item FK_e252dd568669d8533409b9a9ff7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alphabet_item
    ADD CONSTRAINT "FK_e252dd568669d8533409b9a9ff7" FOREIGN KEY ("languageId") REFERENCES public.language(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict GevwhkZHDL75WCLV9ueSOrAXTKOprPCAdgSdzIufgANJU4uZlKRvTXUFx8uEqk6

