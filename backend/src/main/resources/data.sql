--
-- PostgreSQL database dump
--

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', 'public', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.study_program_study_program_variant DROP CONSTRAINT IF EXISTS fkrw5qu09op9xtpyuawp11jti45;
ALTER TABLE IF EXISTS ONLY public.review DROP CONSTRAINT IF EXISTS fkkbomyw1m8bhfmhav3qc70ut8l;
ALTER TABLE IF EXISTS ONLY public.faculty DROP CONSTRAINT IF EXISTS fkivqbiytd9en6sk09duabc6scc;
ALTER TABLE IF EXISTS ONLY public.user_education DROP CONSTRAINT IF EXISTS fki2vuwhhphh7ftmu13r07icv5u;
ALTER TABLE IF EXISTS ONLY public.user_education DROP CONSTRAINT IF EXISTS fkhpolxn5tobqe2mal81sr0ucuw;
ALTER TABLE IF EXISTS ONLY public.study_program_study_program_variant DROP CONSTRAINT IF EXISTS fkhiwa2ps7r17xp64buaxyds6x5;
ALTER TABLE IF EXISTS ONLY public.review DROP CONSTRAINT IF EXISTS fkc7y0l3wac4n2ewm6a2uecd54c;
ALTER TABLE IF EXISTS ONLY public.review DROP CONSTRAINT IF EXISTS fka975g8id1wtw80rprash0h69p;
ALTER TABLE IF EXISTS ONLY public.user_education DROP CONSTRAINT IF EXISTS fk51obeorhqrynkktl2v92ew3gd;
ALTER TABLE IF EXISTS ONLY public.study_program DROP CONSTRAINT IF EXISTS fk48g3nmfegilglqllax2cfjokq;
ALTER TABLE IF EXISTS ONLY public.user_education DROP CONSTRAINT IF EXISTS user_education_pkey;
ALTER TABLE IF EXISTS ONLY public.university DROP CONSTRAINT IF EXISTS university_pkey;
ALTER TABLE IF EXISTS ONLY public.university DROP CONSTRAINT IF EXISTS ukru212k5vib3yvu360fuy3h1g5;
ALTER TABLE IF EXISTS ONLY public.faculty DROP CONSTRAINT IF EXISTS ukgwljg7p88cg96uan9osjipot9;
ALTER TABLE IF EXISTS ONLY public.university DROP CONSTRAINT IF EXISTS ukfvtw0p17nv23wqyviitui41a9;
ALTER TABLE IF EXISTS ONLY public.study_program_variant DROP CONSTRAINT IF EXISTS ukey4t9937e9h395lv9i4rpfic3;
ALTER TABLE IF EXISTS ONLY public.review DROP CONSTRAINT IF EXISTS uk_review_user_program;
ALTER TABLE IF EXISTS ONLY public.app_user DROP CONSTRAINT IF EXISTS uk1j9d9a06i600gd43uu3km82jw;
ALTER TABLE IF EXISTS ONLY public.study_program_variant DROP CONSTRAINT IF EXISTS study_program_variant_pkey;
ALTER TABLE IF EXISTS ONLY public.study_program DROP CONSTRAINT IF EXISTS study_program_pkey;
ALTER TABLE IF EXISTS ONLY public.review DROP CONSTRAINT IF EXISTS review_pkey;
ALTER TABLE IF EXISTS ONLY public.faculty DROP CONSTRAINT IF EXISTS faculty_pkey;
ALTER TABLE IF EXISTS ONLY public.app_user DROP CONSTRAINT IF EXISTS app_user_pkey;
DROP TABLE IF EXISTS public.user_education;
DROP TABLE IF EXISTS public.university;
DROP TABLE IF EXISTS public.study_program_variant;
DROP TABLE IF EXISTS public.study_program_study_program_variant;
DROP TABLE IF EXISTS public.study_program;
DROP TABLE IF EXISTS public.review;
DROP TABLE IF EXISTS public.faculty;
DROP TABLE IF EXISTS public.app_user;
DROP SCHEMA IF EXISTS public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

-- peter@stuba.sk
-- 1234abcd!!A
--
-- artur@student.euba.sk
-- moh123MOH@
--
-- andrej@student.upjs.sk
-- HattHH23!
--
-- antonio1@stud.uniza.sk
-- HH1mofdsh12!!
--
-- martin1@student.tuke.sk
-- Kop123@!@




--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: app_user; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE IF NOT EXISTS public.app_user (
                                 id uuid NOT NULL,
                                 created_at timestamp(6) without time zone NOT NULL,
                                 email character varying(255) NOT NULL,
                                 enabled boolean NOT NULL,
                                 last_login timestamp(6) without time zone,
                                 password character varying(255) NOT NULL,
                                 role character varying(255) NOT NULL,
                                 verification_code character varying(255),
                                 verification_code_expires_at timestamp(6) without time zone,
                                 CONSTRAINT app_user_role_check CHECK (((role)::text = ANY ((ARRAY['ADMIN'::character varying, 'STUDENT'::character varying, 'USER'::character varying])::text[])))
);


ALTER TABLE IF EXISTS ONLY public.app_user OWNER TO "user";

--
-- Name: faculty; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE IF NOT EXISTS public.faculty (
                                id bigint NOT NULL,
                                name character varying(255) NOT NULL,
                                university_id bigint NOT NULL
);


ALTER TABLE IF EXISTS ONLY public.faculty OWNER TO "user";

--
-- Name: faculty_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.faculty ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.faculty_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
    );


--
-- Name: review; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE IF NOT EXISTS public.review (
                               id bigint NOT NULL,
                               anonymous boolean NOT NULL,
                               comment character varying(255),
                               created_at timestamp(6) without time zone NOT NULL,
                               rating integer NOT NULL,
                               updated_at timestamp(6) without time zone NOT NULL,
                               study_program_id bigint NOT NULL,
                               study_program_variant_id bigint NOT NULL,
                               user_id uuid NOT NULL,
                               CONSTRAINT review_rating_check CHECK (((rating >= 1) AND (rating <= 10)))
);


ALTER TABLE IF EXISTS ONLY public.review OWNER TO "user";

--
-- Name: review_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.review ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
    );


--
-- Name: study_program; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE IF NOT EXISTS public.study_program (
                                      id bigint NOT NULL,
                                      name character varying(255) NOT NULL,
                                      study_field character varying(255) NOT NULL,
                                      faculty_id bigint NOT NULL
);


ALTER TABLE IF EXISTS ONLY public.study_program OWNER TO "user";

--
-- Name: study_program_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.study_program ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.study_program_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
    );


--
-- Name: study_program_study_program_variant; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE IF NOT EXISTS public.study_program_study_program_variant (
                                                            study_program_id bigint NOT NULL,
                                                            study_program_variant_id bigint CONSTRAINT study_program_study_program_v_study_program_variant_id_not_null NOT NULL
);


ALTER TABLE IF EXISTS ONLY public.study_program_study_program_variant OWNER TO "user";

--
-- Name: study_program_variant; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE IF NOT EXISTS public.study_program_variant (
                                              id bigint NOT NULL,
                                              language character varying(255) NOT NULL,
                                              study_form character varying(255),
                                              title character varying(255),
                                              CONSTRAINT study_program_variant_study_form_check CHECK (((study_form)::text = ANY ((ARRAY['FULL_TIME'::character varying, 'PART_TIME'::character varying])::text[])))
);


ALTER TABLE IF EXISTS ONLY public.study_program_variant OWNER TO "user";

--
-- Name: study_program_variant_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.study_program_variant ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.study_program_variant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
    );


--
-- Name: university; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE IF NOT EXISTS public.university (
                                   id bigint NOT NULL,
                                   name character varying(255) NOT NULL,
                                   university_email_domain character varying(255)
);


ALTER TABLE IF EXISTS ONLY public.university OWNER TO "user";

--
-- Name: university_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.university ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.university_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
    );


--
-- Name: user_education; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE IF NOT EXISTS public.user_education (
                                       id bigint NOT NULL,
                                       status character varying(255),
                                       study_program_id bigint NOT NULL,
                                       study_program_variant_id bigint NOT NULL,
                                       user_id uuid NOT NULL,
                                       CONSTRAINT user_education_status_check CHECK (((status)::text = ANY ((ARRAY['ENROLLED'::character varying, 'ON_HOLD'::character varying, 'COMPLETED'::character varying, 'DROPPED_OUT'::character varying])::text[])))
);


ALTER TABLE IF EXISTS ONLY public.user_education OWNER TO "user";

--
-- Name: user_education_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.user_education ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.user_education_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
    );


--
-- Data for Name: app_user; Type: TABLE DATA; Schema: public; Owner: user
--

INSERT INTO public.app_user VALUES ('ff129217-d4d3-4e53-b8ef-12fe9bad1657', '2025-12-12 17:41:37.499091', 'peter@stuba.sk', true, NULL, '$2a$10$H9bHbFcgnPV9hW2GPMfwWupYNnC6N4HA5t6yDzZY.Uvp24vv.Izzi', 'USER', NULL, NULL);
INSERT INTO public.app_user VALUES ('4f509766-2f3e-49f5-a088-a7a1b6ae5f06', '2025-12-12 17:45:24.598787', 'artur@student.euba.sk', true, NULL, '$2a$10$FbDdY0YaPHpz46qQS3aQwe1RdwuB3dp2x5Z5lgUsFsqjr1R29x9ia', 'USER', NULL, NULL);
INSERT INTO public.app_user VALUES ('c4f36c3f-96e1-4f8a-a5d3-a2c4a39db7b1', '2025-12-12 17:48:19.594848', 'andrej@student.upjs.sk', true, NULL, '$2a$10$bcnOQf2PxC6jdlqEVgvmHuJxkmikZXCFhy7n3J.4MvioRfcDXf6JG', 'USER', NULL, NULL);
INSERT INTO public.app_user VALUES ('9fd495f3-6d6e-4255-bee4-8f287ca59ba2', '2025-12-12 17:51:46.813288', 'antonio1@stud.uniza.sk', true, NULL, '$2a$10$tYvwFnfN2Ifs.u8ZIZhqauS1G5haf3tNcrHzF76yvsgyFVu54qwpu', 'USER', NULL, NULL);
INSERT INTO public.app_user VALUES ('d8d146f8-aeff-4963-b173-5463ce99b914', '2025-12-12 17:53:42.087844', 'martin1@student.tuke.sk', true, NULL, '$2a$10$auC4XOIwWOdsaaKptWQIMui1X3DPyxmyJfnZ39dmgSxDse11wyquK', 'USER', NULL, NULL);


--
-- Data for Name: faculty; Type: TABLE DATA; Schema: public; Owner: user
--

INSERT INTO public.faculty VALUES (1, 'Letecká fakulta', 1);
INSERT INTO public.faculty VALUES (2, 'Fakulta prevádzky a ekonomiky dopravy a spojov', 2);
INSERT INTO public.faculty VALUES (3, 'Fakulta elektrotechniky a informatiky', 1);
INSERT INTO public.faculty VALUES (4, 'Fakulta výrobných technológií so sídlom v Prešove', 1);
INSERT INTO public.faculty VALUES (5, 'Prírodovedecká fakulta', 3);
INSERT INTO public.faculty VALUES (6, 'Fakulta elektrotechniky a informačných technológií', 2);
INSERT INTO public.faculty VALUES (7, 'Strojnícka fakulta', 1);
INSERT INTO public.faculty VALUES (8, 'Podnikovohospodárska fakulta v Košiciach', 4);
INSERT INTO public.faculty VALUES (9, 'Fakulta materiálov, metalurgie a recyklácie', 1);
INSERT INTO public.faculty VALUES (10, 'Stavebná fakulta', 2);
INSERT INTO public.faculty VALUES (11, 'Fakulta bezpečnostného inžinierstva', 2);
INSERT INTO public.faculty VALUES (12, 'Fakulta sociálnych a ekonomických vied', 3);
INSERT INTO public.faculty VALUES (13, 'Národohospodárska fakulta', 4);
INSERT INTO public.faculty VALUES (14, 'Fakulta baníctva, ekológie, riadenia a geotechnológií', 1);
INSERT INTO public.faculty VALUES (15, 'Fakulta riadenia a informatiky', 2);
INSERT INTO public.faculty VALUES (16, 'Obchodná fakulta', 4);
INSERT INTO public.faculty VALUES (17, 'Fakulta matematiky, fyziky a informatiky', 3);
INSERT INTO public.faculty VALUES (18, 'Fakulta hospodárskej informatiky', 4);
INSERT INTO public.faculty VALUES (19, 'Fakulta chemickej a potravinárskej technológie', 5);
INSERT INTO public.faculty VALUES (20, 'Prírodovedecká fakulta', 6);
INSERT INTO public.faculty VALUES (21, 'Jesseniova lekárska fakulta v Martine', 3);
INSERT INTO public.faculty VALUES (22, 'Lekárska fakulta', 6);
INSERT INTO public.faculty VALUES (23, 'Lekárska fakulta', 3);
INSERT INTO public.faculty VALUES (24, 'Filozofická fakulta', 3);
INSERT INTO public.faculty VALUES (25, 'Filozofická fakulta', 6);
INSERT INTO public.faculty VALUES (26, 'Fakulta elektrotechniky a informatiky', 5);
INSERT INTO public.faculty VALUES (27, 'Fakulta informatiky a informačných technológií', 5);
INSERT INTO public.faculty VALUES (28, 'Materiálovotechnologická fakulta so sídlom v Trnave', 5);
INSERT INTO public.faculty VALUES (29, 'Stavebná fakulta', 5);
INSERT INTO public.faculty VALUES (30, 'Strojnícka fakulta', 5);
INSERT INTO public.faculty VALUES (31, 'Fakulta aplikovaných jazykov', 4);
INSERT INTO public.faculty VALUES (32, 'Fakulta architektúry a dizajnu', 5);
INSERT INTO public.faculty VALUES (33, 'Fakulta umení', 1);
INSERT INTO public.faculty VALUES (34, 'Strojnícka fakulta', 2);
INSERT INTO public.faculty VALUES (35, 'Pedagogická fakulta', 3);
INSERT INTO public.faculty VALUES (36, 'Fakulta podnikového manažmentu', 4);
INSERT INTO public.faculty VALUES (37, 'Ekonomická fakulta', 1);
INSERT INTO public.faculty VALUES (38, 'Právnická fakulta', 3);
INSERT INTO public.faculty VALUES (39, 'Fakulta verejnej správy', 6);
INSERT INTO public.faculty VALUES (40, 'Evanjelická bohoslovecká fakulta', 3);
INSERT INTO public.faculty VALUES (41, 'Farmaceutická fakulta', 3);
INSERT INTO public.faculty VALUES (42, 'Fakulta medzinárodných vzťahov', 4);
INSERT INTO public.faculty VALUES (43, 'Stavebná fakulta', 1);
INSERT INTO public.faculty VALUES (44, 'Rímskokatolícka cyrilometodská bohoslovecká fakulta', 3);
INSERT INTO public.faculty VALUES (45, 'Fakulta managementu', 3);
INSERT INTO public.faculty VALUES (46, 'Právnická fakulta', 6);
INSERT INTO public.faculty VALUES (47, 'Fakulta telesnej výchovy a športu', 3);


--
-- Data for Name: review; Type: TABLE DATA; Schema: public; Owner: user
--

INSERT INTO public.review VALUES (1, true, 'Toto je moja prva review mam to tu moc rad.', '2025-12-12 17:42:27.772174', 5, '2025-12-12 17:42:27.772174', 83, 11, 'ff129217-d4d3-4e53-b8ef-12fe9bad1657');
INSERT INTO public.review VALUES (2, true, 'Rad obchodujem s topankami.', '2025-12-12 17:46:27.770256', 5, '2025-12-12 17:46:27.770256', 57, 1, '4f509766-2f3e-49f5-a088-a7a1b6ae5f06');
INSERT INTO public.review VALUES (3, false, 'Operoval som niekoho a typek zomrel.', '2025-12-12 17:49:03.911241', 5, '2025-12-12 17:49:03.911241', 170, 16, 'c4f36c3f-96e1-4f8a-a5d3-a2c4a39db7b1');


--
-- Data for Name: study_program; Type: TABLE DATA; Schema: public; Owner: user
--

INSERT INTO public.study_program VALUES (1, 'Aerospace Engineering (letecké a kozmické inžinierstvo)', 'doprava', 1);
INSERT INTO public.study_program VALUES (2, 'Aerospace Systems (letecké a kozmické systémy)', 'doprava', 1);
INSERT INTO public.study_program VALUES (3, 'Air Transport', 'doprava', 2);
INSERT INTO public.study_program VALUES (4, 'Air Transport Management (manažérstvo leteckej dopravy)', 'doprava', 1);
INSERT INTO public.study_program VALUES (5, 'Artificial Intelligence', 'informatika', 3);
INSERT INTO public.study_program VALUES (6, 'Automotive Production Technologies', 'strojárstvo', 4);
INSERT INTO public.study_program VALUES (7, 'Biological Chemistry', 'biológia', 5);
INSERT INTO public.study_program VALUES (8, 'Biomedical Engineering', 'elektrotechnika', 6);
INSERT INTO public.study_program VALUES (9, 'Biomedical engineering (biomedicínske inžinierstvo)', 'elektrotechnika', 7);
INSERT INTO public.study_program VALUES (10, 'Business Economics and Management', 'ekonómia a manažment', 8);
INSERT INTO public.study_program VALUES (11, 'Chemical Processes in Raw Materials Processing and Materials Production', 'získavanie a spracovanie zemských zdrojov', 9);
INSERT INTO public.study_program VALUES (12, 'Chemistry', 'chémia', 5);
INSERT INTO public.study_program VALUES (13, 'Commercial Entrepreneurship', 'ekonómia a manažment', 8);
INSERT INTO public.study_program VALUES (14, 'Computer Aided Manufacturing Technologies', 'strojárstvo', 4);
INSERT INTO public.study_program VALUES (15, 'Computer-aided mechanical engineering production (Počítačová podpora strojárskej výroby)', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (16, 'Computer-aided mechanical engineering production (počítačová podpora strojárskej výroby)', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (17, 'Construction Management', 'stavebníctvo', 10);
INSERT INTO public.study_program VALUES (18, 'Corporate Financial Management', 'ekonómia a manažment', 8);
INSERT INTO public.study_program VALUES (19, 'Crisis Management', 'bezpečnostné vedy', 11);
INSERT INTO public.study_program VALUES (20, 'Design and Quality of Materials', 'strojárstvo', 9);
INSERT INTO public.study_program VALUES (21, 'Digitalization of Metallurgical processes', 'získavanie a spracovanie zemských zdrojov', 9);
INSERT INTO public.study_program VALUES (22, 'Distribution Technologies and Services', 'doprava', 2);
INSERT INTO public.study_program VALUES (23, 'E-commerce and management', 'ekonómia a manažment', 2);
INSERT INTO public.study_program VALUES (24, 'Electrical Engineering', 'elektrotechnika', 3);
INSERT INTO public.study_program VALUES (25, 'Environmental Studies', 'ekologické a environmentálne vedy', 5);
INSERT INTO public.study_program VALUES (26, 'European Governance and Politics', 'politické vedy', 12);
INSERT INTO public.study_program VALUES (27, 'Finance', 'ekonómia a manažment', 13);
INSERT INTO public.study_program VALUES (28, 'Finance, Banking and Investment', 'ekonómia a manažment', 13);
INSERT INTO public.study_program VALUES (29, 'Freight forwarding and logistics', 'doprava', 2);
INSERT INTO public.study_program VALUES (30, 'Geotourism (geoturizmus)', 'získavanie a spracovanie zemských zdrojov', 14);
INSERT INTO public.study_program VALUES (31, 'Industrial Manufacturing Management', 'strojárstvo', 4);
INSERT INTO public.study_program VALUES (32, 'Industrial engineering (Priemyselné inžinierstvo)', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (33, 'Industrial engineering (priemyselné inžinierstvo)', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (34, 'Industrial mechatronics (priemyselná mechatronika)', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (35, 'Informatika', 'informatika', 15);
INSERT INTO public.study_program VALUES (36, 'Innovative Recycling and Environmental Technologies', 'získavanie a spracovanie zemských zdrojov', 9);
INSERT INTO public.study_program VALUES (37, 'Intelligent systems (inteligentné systémy)', 'informatika', 3);
INSERT INTO public.study_program VALUES (38, 'International Business Management', 'ekonómia a manažment', 16);
INSERT INTO public.study_program VALUES (39, 'Manufacturing Technologies', 'strojárstvo', 4);
INSERT INTO public.study_program VALUES (40, 'Marketing and Trade Management', 'ekonómia a manažment', 16);
INSERT INTO public.study_program VALUES (41, 'Materials', 'strojárstvo', 9);
INSERT INTO public.study_program VALUES (42, 'Materials Engineering', 'strojárstvo', 9);
INSERT INTO public.study_program VALUES (43, 'Mechanical engineering Technologies (strojárske technológie)', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (44, 'Metallurgical Technology and Digital Transformation of Industry', 'získavanie a spracovanie zemských zdrojov', 9);
INSERT INTO public.study_program VALUES (45, 'Physics of the Earth', 'fyzika', 17);
INSERT INTO public.study_program VALUES (46, 'Process Engineering', 'strojárstvo', 4);
INSERT INTO public.study_program VALUES (47, 'Prosthetics and orthotics (Protetika a ortotika)', 'elektrotechnika', 7);
INSERT INTO public.study_program VALUES (48, 'Quality and Safety (kvalita a bezpečnosť)', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (49, 'Railway Transport', 'doprava', 2);
INSERT INTO public.study_program VALUES (50, 'Recycling and Environmental Technologies', 'získavanie a spracovanie zemských zdrojov', 9);
INSERT INTO public.study_program VALUES (51, 'Rescue Services', 'bezpečnostné vedy', 11);
INSERT INTO public.study_program VALUES (52, 'Road Transport', 'doprava', 2);
INSERT INTO public.study_program VALUES (53, 'Robotics and robototechnology (robotika a robototechnológie)', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (54, 'Sociálny manažment a ľudské zdroje', 'ekonómia a manažment', 13);
INSERT INTO public.study_program VALUES (55, 'Theory and Structures of Buildings', 'stavebníctvo', 10);
INSERT INTO public.study_program VALUES (56, 'Theory and Structures of Engineering Constructions', 'stavebníctvo', 10);
INSERT INTO public.study_program VALUES (57, 'Tourism Management', 'ekonómia a manažment', 16);
INSERT INTO public.study_program VALUES (58, 'aktuárstvo', 'ekonómia a manažment', 18);
INSERT INTO public.study_program VALUES (59, 'analytická chémia', 'chémia', 5);
INSERT INTO public.study_program VALUES (60, 'analytická chémia', 'chémia', 19);
INSERT INTO public.study_program VALUES (61, 'analytická chémia', 'chémia', 20);
INSERT INTO public.study_program VALUES (62, 'analýza dát a umelá inteligencia', 'matematika', 20);
INSERT INTO public.study_program VALUES (63, 'anatómia, histológia a embryológia', 'všeobecné lekárstvo', 21);
INSERT INTO public.study_program VALUES (64, 'anatómia, histológia a embryológia', 'všeobecné lekárstvo', 22);
INSERT INTO public.study_program VALUES (65, 'anatómia, histológia a embryológia', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (66, 'anestéziológia a resuscitácia', 'všeobecné lekárstvo', 21);
INSERT INTO public.study_program VALUES (67, 'anglický jazyk a kultúra (v kombinácii)', 'filológia', 24);
INSERT INTO public.study_program VALUES (68, 'anglický jazyk pre európske inštitúcie a ekonomiku', 'filológia', 25);
INSERT INTO public.study_program VALUES (69, 'anorganická chémia', 'chémia', 5);
INSERT INTO public.study_program VALUES (70, 'anorganická chémia', 'chémia', 19);
INSERT INTO public.study_program VALUES (71, 'anorganická chémia', 'chémia', 20);
INSERT INTO public.study_program VALUES (72, 'anorganické technológie a materiály', 'chemické inžinierstvo a technológie', 19);
INSERT INTO public.study_program VALUES (73, 'aplikovaná ekonómia', 'ekonómia a manažment', 13);
INSERT INTO public.study_program VALUES (74, 'aplikovaná ekonómia', 'ekonómia a manažment', 12);
INSERT INTO public.study_program VALUES (75, 'aplikovaná elektrotechnika', 'elektrotechnika', 26);
INSERT INTO public.study_program VALUES (76, 'aplikovaná elektrotechnika', 'elektrotechnika', 3);
INSERT INTO public.study_program VALUES (77, 'aplikovaná geofyzika', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (78, 'aplikovaná informatika', 'informatika', 20);
INSERT INTO public.study_program VALUES (79, 'aplikovaná informatika', 'informatika', 27);
INSERT INTO public.study_program VALUES (80, 'aplikovaná informatika', 'informatika', 17);
INSERT INTO public.study_program VALUES (81, 'aplikovaná informatika', 'informatika', 15);
INSERT INTO public.study_program VALUES (82, 'aplikovaná informatika', 'informatika', 3);
INSERT INTO public.study_program VALUES (83, 'aplikovaná informatika', 'informatika', 26);
INSERT INTO public.study_program VALUES (84, 'aplikovaná informatika (konverzný)', 'informatika', 15);
INSERT INTO public.study_program VALUES (85, 'aplikovaná informatika a automatizácia v priemysle', 'kybernetika', 28);
INSERT INTO public.study_program VALUES (86, 'aplikovaná matematika', 'matematika', 20);
INSERT INTO public.study_program VALUES (87, 'aplikovaná matematika', 'matematika', 29);
INSERT INTO public.study_program VALUES (88, 'aplikovaná matematika', 'matematika', 17);
INSERT INTO public.study_program VALUES (89, 'aplikovaná mechanika', 'strojárstvo', 30);
INSERT INTO public.study_program VALUES (90, 'aplikovaná mechanika', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (91, 'aplikovaná mechanika (Applied mechanics)', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (92, 'aplikovaná mechanika a mechatronika', 'strojárstvo', 30);
INSERT INTO public.study_program VALUES (93, 'aplikovaná mechatronika a elektromobilita', 'kybernetika', 26);
INSERT INTO public.study_program VALUES (94, 'aplikované cudzie jazyky v odbornej komunikácii', 'filológia', 31);
INSERT INTO public.study_program VALUES (95, 'aplikované sieťové inžinierstvo', 'informatika', 15);
INSERT INTO public.study_program VALUES (96, 'aplikované sieťové inžinierstvo (konverzný)', 'informatika', 15);
INSERT INTO public.study_program VALUES (97, 'arabský jazyk a kultúra (v kombinácii)', 'filológia', 24);
INSERT INTO public.study_program VALUES (98, 'archeológia', 'historické vedy', 24);
INSERT INTO public.study_program VALUES (99, 'architektonické konštrukcie a projektovanie', 'stavebníctvo', 29);
INSERT INTO public.study_program VALUES (100, 'architektúra', 'architektúra a urbanizmus', 32);
INSERT INTO public.study_program VALUES (101, 'architektúra a urbanizmus', 'architektúra a urbanizmus', 33);
INSERT INTO public.study_program VALUES (102, 'architektúra a urbanizmus', 'architektúra a urbanizmus', 32);
INSERT INTO public.study_program VALUES (103, 'archívnictvo, muzeológia a digitalizácia historického dedičstva', 'historické vedy', 24);
INSERT INTO public.study_program VALUES (104, 'astronómia a astrofyzika', 'fyzika', 17);
INSERT INTO public.study_program VALUES (105, 'automatizované výrobné systémy', 'strojárstvo', 34);
INSERT INTO public.study_program VALUES (106, 'automatizácia', 'kybernetika', 6);
INSERT INTO public.study_program VALUES (107, 'automatizácia a digitalizácia výroby', 'strojárstvo', 34);
INSERT INTO public.study_program VALUES (108, 'automatizácia a informatizácia procesov', 'kybernetika', 28);
INSERT INTO public.study_program VALUES (109, 'automatizácia a informatizácia procesov v priemysle', 'kybernetika', 28);
INSERT INTO public.study_program VALUES (110, 'automatizácia a informatizácia strojov a procesov', 'kybernetika', 30);
INSERT INTO public.study_program VALUES (111, 'automatizácia a informatizácia v chémii a potravinárstve', 'kybernetika', 19);
INSERT INTO public.study_program VALUES (112, 'automatizácia a riadenie procesov získavania a spracovania surovín', 'kybernetika', 14);
INSERT INTO public.study_program VALUES (113, 'automobilová elektronika', 'elektrotechnika', 3);
INSERT INTO public.study_program VALUES (114, 'automobilová mechatronika', 'kybernetika', 26);
INSERT INTO public.study_program VALUES (115, 'automobilová výroba', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (116, 'automobily a mobilné pracovné stroje', 'strojárstvo', 30);
INSERT INTO public.study_program VALUES (117, 'banská geológia a geologický prieskum', 'získavanie a spracovanie zemských zdrojov', 14);
INSERT INTO public.study_program VALUES (118, 'banské meračstvo a geodézia', 'získavanie a spracovanie zemských zdrojov', 14);
INSERT INTO public.study_program VALUES (119, 'baníctvo a geotechnika', 'získavanie a spracovanie zemských zdrojov', 14);
INSERT INTO public.study_program VALUES (120, 'bezpečnostný manažment', 'bezpečnostné vedy', 11);
INSERT INTO public.study_program VALUES (121, 'bezpečnosť technických systémov', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (122, 'biochémia', 'chémia', 20);
INSERT INTO public.study_program VALUES (123, 'biochémia', 'chémia', 5);
INSERT INTO public.study_program VALUES (124, 'biochémia', 'chémia', 19);
INSERT INTO public.study_program VALUES (125, 'biochémia (konverzný)', 'chémia', 5);
INSERT INTO public.study_program VALUES (126, 'biochémia a biofyzikálna chémia pre farmaceutické aplikácie', 'chémia', 19);
INSERT INTO public.study_program VALUES (127, 'biochémia a biofyzikálna chémia pre farmaceutické aplikácie (konverzný)', 'chémia', 19);
INSERT INTO public.study_program VALUES (128, 'biochémia a biomedicínske technológie', 'biotechnológie', 19);
INSERT INTO public.study_program VALUES (129, 'biofyzika', 'fyzika', 20);
INSERT INTO public.study_program VALUES (130, 'biofyzika', 'fyzika', 17);
INSERT INTO public.study_program VALUES (131, 'bioinformatika', 'informatika', 17);
INSERT INTO public.study_program VALUES (132, 'bioinformatika (konverzný program)', 'informatika', 17);
INSERT INTO public.study_program VALUES (133, 'biológia', 'biológia', 20);
INSERT INTO public.study_program VALUES (134, 'biológia', 'biológia', 5);
INSERT INTO public.study_program VALUES (135, 'biológia - chémia', 'biológia', 20);
INSERT INTO public.study_program VALUES (136, 'biológia - geografia', 'biológia', 20);
INSERT INTO public.study_program VALUES (137, 'biológia - informatika', 'biológia', 20);
INSERT INTO public.study_program VALUES (138, 'biológia - psychológia', 'biológia', 20);
INSERT INTO public.study_program VALUES (139, 'biomedicínska fyzika', 'Fyzika', 17);
INSERT INTO public.study_program VALUES (140, 'biomedicínska informatika', 'informatika', 15);
INSERT INTO public.study_program VALUES (141, 'biomedicínska informatika (konverzný)', 'informatika', 15);
INSERT INTO public.study_program VALUES (142, 'biomedicínske inžinierstvo', 'elektrotechnika', 6);
INSERT INTO public.study_program VALUES (143, 'biomedicínske inžinierstvo', 'elektrotechnika', 7);
INSERT INTO public.study_program VALUES (144, 'biomedicínske inžinierstvo (Biomedical engineering)', 'elektrotechnika', 7);
INSERT INTO public.study_program VALUES (145, 'biotechnológia', 'biotechnológie', 19);
INSERT INTO public.study_program VALUES (146, 'biotechnológia (konverzný)', 'biotechnológie', 19);
INSERT INTO public.study_program VALUES (147, 'biotechnológie', 'biotechnológie', 5);
INSERT INTO public.study_program VALUES (148, 'biotechnológie', 'biotechnológie', 19);
INSERT INTO public.study_program VALUES (149, 'biznis a marketing', 'ekonómia a manažment', 16);
INSERT INTO public.study_program VALUES (150, 'biznis v cestovnom ruchu', 'ekonómia a manažment', 16);
INSERT INTO public.study_program VALUES (151, 'botanika', 'biológia', 5);
INSERT INTO public.study_program VALUES (152, 'botanika a fyziológia rastlín', 'biológia', 20);
INSERT INTO public.study_program VALUES (153, 'britské a americké štúdiá', 'filológia', 25);
INSERT INTO public.study_program VALUES (154, 'britské a americké štúdiá - biológia', 'filológia', 25);
INSERT INTO public.study_program VALUES (155, 'britské a americké štúdiá - filozofia', 'filológia', 25);
INSERT INTO public.study_program VALUES (156, 'britské a americké štúdiá - geografia', 'filológia', 25);
INSERT INTO public.study_program VALUES (157, 'britské a americké štúdiá - informatika', 'filológia', 25);
INSERT INTO public.study_program VALUES (158, 'britské a americké štúdiá - matematika', 'filológia', 25);
INSERT INTO public.study_program VALUES (159, 'britské a americké štúdiá - nemecký jazyk a literatúra', 'filológia', 25);
INSERT INTO public.study_program VALUES (160, 'britské a americké štúdiá - psychológia', 'filológia', 25);
INSERT INTO public.study_program VALUES (161, 'britské a americké štúdiá', 'filológia', 25);
INSERT INTO public.study_program VALUES (162, 'bulharský jazyk a kultúra (v kombinácii)', 'filológia', 24);
INSERT INTO public.study_program VALUES (163, 'cestná doprava', 'doprava', 2);
INSERT INTO public.study_program VALUES (164, 'chemické a potravinárske stroje a zariadenia', 'strojárstvo', 30);
INSERT INTO public.study_program VALUES (165, 'chemické inžinierstvo', 'chemické inžinierstvo a technológie', 19);
INSERT INTO public.study_program VALUES (166, 'chemické inžinierstvo (konverzný)', 'chemické inžinierstvo a technológie', 19);
INSERT INTO public.study_program VALUES (167, 'chemické procesy v spracovaní surovín a výrobe materiálov', 'získavanie a spracovanie zemských zdrojov', 9);
INSERT INTO public.study_program VALUES (168, 'chemické technológie', 'chemické inžinierstvo a technológie', 19);
INSERT INTO public.study_program VALUES (169, 'chemický laborant – špecialista', 'chémia', 20);
INSERT INTO public.study_program VALUES (170, 'chirurgia', 'všeobecné lekárstvo', 22);
INSERT INTO public.study_program VALUES (171, 'chirurgia', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (172, 'chirurgia', 'všeobecné lekárstvo', 21);
INSERT INTO public.study_program VALUES (173, 'chémia', 'chémia', 20);
INSERT INTO public.study_program VALUES (174, 'chémia', 'chémia', 5);
INSERT INTO public.study_program VALUES (175, 'chémia (konverzný)', 'chémia', 5);
INSERT INTO public.study_program VALUES (176, 'chémia - geografia', 'chémia', 20);
INSERT INTO public.study_program VALUES (177, 'chémia - informatika', 'chémia', 20);
INSERT INTO public.study_program VALUES (178, 'chémia a chemické technológie', 'chemické inžinierstvo a technológie', 19);
INSERT INTO public.study_program VALUES (179, 'chémia a technológia požívatín', 'potravinárstvo', 19);
INSERT INTO public.study_program VALUES (180, 'chémia a technológia životného prostredia', 'chemické inžinierstvo a technológie', 19);
INSERT INTO public.study_program VALUES (181, 'chémia, medicínska chémia a chemické materiály', 'chémia', 19);
INSERT INTO public.study_program VALUES (182, 'chémia, medicínska chémia a chemické materiály (konverzný)', 'chémia', 19);
INSERT INTO public.study_program VALUES (183, 'civil engineering', 'stavebníctvo', 29);
INSERT INTO public.study_program VALUES (184, 'cudzie jazyky a interkultúrna komunikácia', 'filológia', 31);
INSERT INTO public.study_program VALUES (185, 'data science v ekonómii', 'ekonómia a manažment', 18);
INSERT INTO public.study_program VALUES (186, 'dejiny filozofie', 'filozofia', 25);
INSERT INTO public.study_program VALUES (187, 'dejiny umenia', 'vedy o umení a kultúre', 24);
INSERT INTO public.study_program VALUES (188, 'dejiny umenia - história', 'vedy o umení a kultúre', 24);
INSERT INTO public.study_program VALUES (189, 'dermatovenerológia', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (190, 'didaktika biológie', 'učiteľstvo a pedagogické vedy', 5);
INSERT INTO public.study_program VALUES (191, 'didaktika cudzích jazykov a literatúr', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (192, 'didaktika dejepisu', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (193, 'didaktika umelecko-výchovných predmetov', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (194, 'digitalizácia metalurgických procesov', 'získavanie a spracovanie zemských zdrojov', 9);
INSERT INTO public.study_program VALUES (195, 'digitálne technológie', 'kybernetika', 26);
INSERT INTO public.study_program VALUES (196, 'diskrétna matematika', 'matematika', 20);
INSERT INTO public.study_program VALUES (197, 'distribučné technológie a služby', 'doprava', 2);
INSERT INTO public.study_program VALUES (198, 'dizajn', 'umenie', 32);
INSERT INTO public.study_program VALUES (199, 'dizajn', 'umenie', 33);
INSERT INTO public.study_program VALUES (200, 'dizajn a kvalita materiálov', 'strojárstvo', 9);
INSERT INTO public.study_program VALUES (201, 'doprava', 'doprava', 2);
INSERT INTO public.study_program VALUES (202, 'dopravná logistika podniku', 'doprava', 14);
INSERT INTO public.study_program VALUES (203, 'dopravná technika a logistika', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (204, 'dopravné služby a logistika', 'doprava', 2);
INSERT INTO public.study_program VALUES (205, 'dopravné služby v osobnej doprave', 'doprava', 2);
INSERT INTO public.study_program VALUES (206, 'dopravné staviteľstvo', 'stavebníctvo', 10);
INSERT INTO public.study_program VALUES (207, 'dopravné stroje a zariadenia', 'strojárstvo', 30);
INSERT INTO public.study_program VALUES (208, 'dynamická geológia', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (209, 'dátová analytika a kontroling', 'ekonómia a manažment', 18);
INSERT INTO public.study_program VALUES (210, 'dátová veda', 'informatika', 17);
INSERT INTO public.study_program VALUES (211, 'dátová veda (konverzný program)', 'informatika', 17);
INSERT INTO public.study_program VALUES (212, 'ekológia a ochrana životného prostredia', 'ekologické a environmentálne vedy', 5);
INSERT INTO public.study_program VALUES (213, 'ekonomicko-finančná matematika a modelovanie', 'matematika', 17);
INSERT INTO public.study_program VALUES (214, 'ekonomická a finančná matematika', 'matematika', 20);
INSERT INTO public.study_program VALUES (215, 'ekonomická a finančná matematika', 'matematika', 17);
INSERT INTO public.study_program VALUES (216, 'ekonomická a politická geografia a demografia', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (217, 'ekonomická a sociálna geografia, demografia a územný rozvoj', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (218, 'ekonomika a manažment podniku', 'ekonómia a manažment', 2);
INSERT INTO public.study_program VALUES (219, 'ekonomika a manažment podniku', 'ekonómia a manažment', 8);
INSERT INTO public.study_program VALUES (220, 'ekonomika a manažment podniku', 'ekonómia a manažment', 36);
INSERT INTO public.study_program VALUES (221, 'ekonomika a manažment v energetike', 'ekonómia a manažment', 36);
INSERT INTO public.study_program VALUES (222, 'ekonomika a manažment v energetike', 'elektrotechnika', 26);
INSERT INTO public.study_program VALUES (223, 'ekonomika a manažment verejnej správy', 'ekonómia a manažment', 37);
INSERT INTO public.study_program VALUES (224, 'ekonomika dopravy, spojov a služieb', 'ekonómia a manažment', 2);
INSERT INTO public.study_program VALUES (225, 'ekonomika podniku', 'ekonómia a manažment', 36);
INSERT INTO public.study_program VALUES (226, 'ekonomika zemských zdrojov', 'získavanie a spracovanie zemských zdrojov', 14);
INSERT INTO public.study_program VALUES (227, 'ekonómia', 'ekonómia a manažment', 13);
INSERT INTO public.study_program VALUES (228, 'ekonómia', 'ekonómia a manažment', 12);
INSERT INTO public.study_program VALUES (229, 'ekonómia a právo', 'ekonómia a manažment', 13);
INSERT INTO public.study_program VALUES (230, 'ekonómia a právo', 'ekonómia a manažment', 38);
INSERT INTO public.study_program VALUES (231, 'elektroenergetika', 'elektrotechnika', 26);
INSERT INTO public.study_program VALUES (232, 'elektroenergetika', 'elektrotechnika', 3);
INSERT INTO public.study_program VALUES (233, 'elektronické inžinierstvo a medzinárodné podnikanie', 'ekonómia a manažment', 16);
INSERT INTO public.study_program VALUES (234, 'elektronické inžinierstvo a medzinárodné podnikanie', 'elektrotechnika', 26);
INSERT INTO public.study_program VALUES (235, 'elektronické systémy a návrh čipov', 'elektrotechnika', 26);
INSERT INTO public.study_program VALUES (236, 'elektronický obchod a manažment', 'ekonómia a manažment', 2);
INSERT INTO public.study_program VALUES (237, 'elektronika', 'elektrotechnika', 26);
INSERT INTO public.study_program VALUES (238, 'elektronika a fotonika', 'elektrotechnika', 26);
INSERT INTO public.study_program VALUES (239, 'elektrooptika', 'elektrotechnika', 6);
INSERT INTO public.study_program VALUES (240, 'elektrotechnické inžinierstvo', 'elektrotechnika', 6);
INSERT INTO public.study_program VALUES (241, 'elektrotechnika', 'elektrotechnika', 26);
INSERT INTO public.study_program VALUES (242, 'elektrotechnika', 'elektrotechnika', 3);
INSERT INTO public.study_program VALUES (243, 'elektrotechnika', 'elektrotechnika', 6);
INSERT INTO public.study_program VALUES (244, 'elektrotechnológie a materiály', 'elektrotechnika', 6);
INSERT INTO public.study_program VALUES (245, 'energetická a environmentálna technika', 'strojárstvo', 34);
INSERT INTO public.study_program VALUES (246, 'energetické stroje a zariadenia', 'strojárstvo', 34);
INSERT INTO public.study_program VALUES (247, 'energetické stroje a zariadenia', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (248, 'energetické stroje a zariadenia', 'strojárstvo', 30);
INSERT INTO public.study_program VALUES (249, 'environmentalistika', 'ekologické a environmentálne vedy', 5);
INSERT INTO public.study_program VALUES (250, 'environmentálna fyzika a meteorológia', 'fyzika', 17);
INSERT INTO public.study_program VALUES (251, 'environmentálna fyzika, obnoviteľné zdroje energie, meteorológia a klimatológia', 'fyzika', 17);
INSERT INTO public.study_program VALUES (252, 'environmentálna geochémia', 'ekologické a environmentálne vedy', 5);
INSERT INTO public.study_program VALUES (253, 'environmentálna výrobná technika', 'strojárstvo', 30);
INSERT INTO public.study_program VALUES (254, 'epidemiológia', 'všeobecné lekárstvo', 22);
INSERT INTO public.study_program VALUES (255, 'estetika', 'filozofia', 24);
INSERT INTO public.study_program VALUES (256, 'etnológia', 'historické vedy', 24);
INSERT INTO public.study_program VALUES (257, 'etnológia - filozofia', 'historické vedy', 24);
INSERT INTO public.study_program VALUES (258, 'etnológia - história', 'historické vedy', 24);
INSERT INTO public.study_program VALUES (259, 'etnológia - muzikológia', 'historické vedy', 24);
INSERT INTO public.study_program VALUES (260, 'etnológia - religionistika', 'historické vedy', 24);
INSERT INTO public.study_program VALUES (261, 'etnológia a kultúrna antropológia', 'historické vedy', 24);
INSERT INTO public.study_program VALUES (262, 'európska verejná správa', 'politické vedy', 39);
INSERT INTO public.study_program VALUES (263, 'európske spravovanie a politiky', 'politické vedy', 12);
INSERT INTO public.study_program VALUES (264, 'európske štúdiá', 'politické vedy', 12);
INSERT INTO public.study_program VALUES (265, 'európske štúdiá a politiky', 'politické vedy', 12);
INSERT INTO public.study_program VALUES (266, 'evanjelická teológia', 'teológia', 40);
INSERT INTO public.study_program VALUES (267, 'evanjelická teológia so zameraním na riadenie sociálnej pomoci', 'teológia', 40);
INSERT INTO public.study_program VALUES (268, 'evanjelická teológia so zameraním na sociálnu pomoc', 'teológia', 40);
INSERT INTO public.study_program VALUES (269, 'farmaceutická chémia', 'farmácia', 41);
INSERT INTO public.study_program VALUES (270, 'farmaceutická technológia', 'farmácia', 41);
INSERT INTO public.study_program VALUES (271, 'farmakognózia', 'farmácia', 41);
INSERT INTO public.study_program VALUES (272, 'farmakológia', 'farmácia', 41);
INSERT INTO public.study_program VALUES (273, 'farmakológia', 'farmácia', 21);
INSERT INTO public.study_program VALUES (274, 'farmácia', 'farmácia', 41);
INSERT INTO public.study_program VALUES (275, 'farmácia', 'farmácia', 22);
INSERT INTO public.study_program VALUES (276, 'filozofia', 'filozofia', 25);
INSERT INTO public.study_program VALUES (277, 'filozofia', 'filozofia', 24);
INSERT INTO public.study_program VALUES (278, 'filozofia - história', 'filozofia', 24);
INSERT INTO public.study_program VALUES (279, 'filozofia - psychológia', 'filozofia', 25);
INSERT INTO public.study_program VALUES (280, 'filozofia - religionistika', 'filozofia', 24);
INSERT INTO public.study_program VALUES (281, 'filozofia - sociológia', 'filozofia', 24);
INSERT INTO public.study_program VALUES (282, 'financie', 'ekonómia a manažment', 13);
INSERT INTO public.study_program VALUES (283, 'financie', 'ekonómia a manažment', 37);
INSERT INTO public.study_program VALUES (284, 'financie a dane', 'ekonómia a manažment', 13);
INSERT INTO public.study_program VALUES (285, 'financie, bankovníctvo a investovanie', 'ekonómia a manažment', 37);
INSERT INTO public.study_program VALUES (286, 'financie, bankovníctvo a investovanie', 'ekonómia a manažment', 13);
INSERT INTO public.study_program VALUES (287, 'financie, bankovníctvo a poisťovníctvo', 'ekonómia a manažment', 13);
INSERT INTO public.study_program VALUES (288, 'finančné riadenie podniku', 'ekonómia a manažment', 8);
INSERT INTO public.study_program VALUES (289, 'finančné trhy a investovanie', 'ekonómia a manažment', 13);
INSERT INTO public.study_program VALUES (290, 'finančný manažment', 'ekonómia a manažment', 2);
INSERT INTO public.study_program VALUES (291, 'fintech a finančné inovácie', 'informatika', 26);
INSERT INTO public.study_program VALUES (292, 'fintech a finančné inovácie', 'ekonómia a manažment', 13);
INSERT INTO public.study_program VALUES (293, 'fotonika', 'elektrotechnika', 6);
INSERT INTO public.study_program VALUES (294, 'francúzsky jazyk a kultúra (v kombinácii)', 'filológia', 24);
INSERT INTO public.study_program VALUES (295, 'fyzická geografia a geoinformatika', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (296, 'fyzická geografia, geoekológia a geoinformatika', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (297, 'fyzika', 'fyzika', 17);
INSERT INTO public.study_program VALUES (298, 'fyzika', 'fyzika', 20);
INSERT INTO public.study_program VALUES (299, 'fyzika (konverzný program)', 'fyzika', 17);
INSERT INTO public.study_program VALUES (300, 'fyzika - biológia', 'fyzika', 20);
INSERT INTO public.study_program VALUES (301, 'fyzika - chémia', 'fyzika', 20);
INSERT INTO public.study_program VALUES (302, 'fyzika - geografia', 'fyzika', 20);
INSERT INTO public.study_program VALUES (303, 'fyzika - informatika', 'fyzika', 20);
INSERT INTO public.study_program VALUES (304, 'fyzika kondenzovaných látok', 'fyzika', 20);
INSERT INTO public.study_program VALUES (305, 'fyzika kondenzovaných látok a akustika', 'fyzika', 17);
INSERT INTO public.study_program VALUES (306, 'fyzika plazmy', 'fyzika', 17);
INSERT INTO public.study_program VALUES (307, 'fyzika tuhých látok', 'fyzika', 17);
INSERT INTO public.study_program VALUES (308, 'fyzikálna chémia', 'chémia', 5);
INSERT INTO public.study_program VALUES (309, 'fyzikálna chémia', 'chémia', 19);
INSERT INTO public.study_program VALUES (310, 'fyzikálna chémia', 'chémia', 20);
INSERT INTO public.study_program VALUES (311, 'fyzikálne inžinierstvo', 'elektrotechnika', 26);
INSERT INTO public.study_program VALUES (312, 'fyzikálne inžinierstvo progresívnych materiálov', 'elektrotechnika', 3);
INSERT INTO public.study_program VALUES (313, 'fyziológia rastlín', 'biológia', 20);
INSERT INTO public.study_program VALUES (314, 'fyziológia rastlín', 'biológia', 5);
INSERT INTO public.study_program VALUES (315, 'fyziológia živočíchov', 'biológia', 5);
INSERT INTO public.study_program VALUES (316, 'fyziológia živočíchov a etológia', 'biológia', 5);
INSERT INTO public.study_program VALUES (317, 'fyzioterapia', 'zdravotnícke vedy', 22);
INSERT INTO public.study_program VALUES (318, 'genetika', 'biológia', 5);
INSERT INTO public.study_program VALUES (319, 'genetika a molekulárna cytológia', 'biológia', 20);
INSERT INTO public.study_program VALUES (320, 'geodézia a kartografia', 'geodézia a kartografia', 29);
INSERT INTO public.study_program VALUES (321, 'geodézia a kartografia', 'geodézia a kartografia', 10);
INSERT INTO public.study_program VALUES (322, 'geodézia a kataster nehnuteľností', 'geodézia a kartografia', 14);
INSERT INTO public.study_program VALUES (323, 'geografia - filozofia', 'vedy o Zemi', 20);
INSERT INTO public.study_program VALUES (324, 'geografia - informatika', 'vedy o Zemi', 20);
INSERT INTO public.study_program VALUES (325, 'geografia - psychológia', 'vedy o Zemi', 20);
INSERT INTO public.study_program VALUES (326, 'geografia a geoinformatika', 'vedy o Zemi', 20);
INSERT INTO public.study_program VALUES (327, 'geografia, kartografia a geoinformatika', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (328, 'geografia, rozvoj regiónov a európska integrácia', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (329, 'geoinformatika a diaľkový prieskum Zeme', 'vedy o Zemi', 20);
INSERT INTO public.study_program VALUES (330, 'geologické inžinierstvo', 'získavanie a spracovanie zemských zdrojov', 14);
INSERT INTO public.study_program VALUES (331, 'geológia', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (332, 'geológia a regionálny rozvoj', 'získavanie a spracovanie zemských zdrojov', 14);
INSERT INTO public.study_program VALUES (333, 'geometria a topológia', 'matematika', 17);
INSERT INTO public.study_program VALUES (334, 'geoturizmus', 'získavanie a spracovanie zemských zdrojov', 14);
INSERT INTO public.study_program VALUES (335, 'germánske štúdiá', 'filológia', 24);
INSERT INTO public.study_program VALUES (336, 'grécky jazyk a kultúra (v kombinácii)', 'filológia', 24);
INSERT INTO public.study_program VALUES (337, 'gynekológia a pôrodníctvo', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (338, 'gynekológia a pôrodníctvo', 'všeobecné lekárstvo', 21);
INSERT INTO public.study_program VALUES (339, 'gynekológia a pôrodníctvo', 'všeobecné lekárstvo', 22);
INSERT INTO public.study_program VALUES (340, 'história', 'historické vedy', 24);
INSERT INTO public.study_program VALUES (341, 'história', 'historické vedy', 25);
INSERT INTO public.study_program VALUES (342, 'história - britské a americké štúdiá', 'historické vedy', 25);
INSERT INTO public.study_program VALUES (343, 'história - filozofia', 'historické vedy', 25);
INSERT INTO public.study_program VALUES (344, 'história - geografia', 'historické vedy', 25);
INSERT INTO public.study_program VALUES (345, 'história - nemecký jazyk a literatúra', 'historické vedy', 25);
INSERT INTO public.study_program VALUES (346, 'história - psychológia', 'historické vedy', 25);
INSERT INTO public.study_program VALUES (347, 'história - religionistika', 'historické vedy', 24);
INSERT INTO public.study_program VALUES (348, 'história - slovenský jazyk a literatúra', 'historické vedy', 25);
INSERT INTO public.study_program VALUES (349, 'holandský jazyk a kultúra (v kombinácii)', 'filológia', 24);
INSERT INTO public.study_program VALUES (350, 'hospodárska diplomacia', 'ekonómia a manažment', 42);
INSERT INTO public.study_program VALUES (351, 'hospodárska informatika', 'informatika', 3);
INSERT INTO public.study_program VALUES (352, 'hospodárska informatika', 'ekonómia a manažment', 18);
INSERT INTO public.study_program VALUES (353, 'humánna geografia a demografia', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (354, 'hutníctvo', 'získavanie a spracovanie zemských zdrojov', 9);
INSERT INTO public.study_program VALUES (355, 'hygiena', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (356, 'hygiena, epidemiológia, sociálne a preventívne lekárstvo', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (357, 'informatika', 'informatika', 3);
INSERT INTO public.study_program VALUES (358, 'informatika', 'informatika', 20);
INSERT INTO public.study_program VALUES (359, 'informatika', 'informatika', 27);
INSERT INTO public.study_program VALUES (360, 'informatika', 'informatika', 17);
INSERT INTO public.study_program VALUES (361, 'informatika (konverzný program)', 'informatika', 17);
INSERT INTO public.study_program VALUES (362, 'informatika (konverzný)', 'informatika', 15);
INSERT INTO public.study_program VALUES (363, 'informatika a riadenie', 'informatika', 15);
INSERT INTO public.study_program VALUES (364, 'informatizácia procesov získavania a spracovania surovín', 'získavanie a spracovanie zemských zdrojov', 14);
INSERT INTO public.study_program VALUES (365, 'informačná bezpečnosť', 'informatika', 27);
INSERT INTO public.study_program VALUES (366, 'informačná bezpečnosť (konverzný)', 'informatika', 27);
INSERT INTO public.study_program VALUES (367, 'informačné a komunikačné technológie', 'informatika', 26);
INSERT INTO public.study_program VALUES (368, 'informačné a sieťové technológie', 'informatika', 15);
INSERT INTO public.study_program VALUES (369, 'informačné systémy', 'informatika', 15);
INSERT INTO public.study_program VALUES (370, 'informačné systémy (konverzný)', 'informatika', 15);
INSERT INTO public.study_program VALUES (371, 'informačné systémy vo verejnej správe', 'politické vedy', 39);
INSERT INTO public.study_program VALUES (372, 'informačné štúdiá', 'mediálne a komunikačné štúdiá', 24);
INSERT INTO public.study_program VALUES (373, 'informačné štúdiá - muzeológia', 'mediálne a komunikačné štúdiá', 24);
INSERT INTO public.study_program VALUES (374, 'informačný manažment', 'ekonómia a manažment', 15);
INSERT INTO public.study_program VALUES (375, 'informačný manažment', 'ekonómia a manažment', 18);
INSERT INTO public.study_program VALUES (376, 'informačný manažment (konverzný)', 'ekonómia a manažment', 15);
INSERT INTO public.study_program VALUES (377, 'inovatívne recyklačné a environmentálne technológie', 'získavanie a spracovanie zemských zdrojov', 9);
INSERT INTO public.study_program VALUES (378, 'integratívna sociálna práca', 'sociálna práca', 25);
INSERT INTO public.study_program VALUES (379, 'integrovaná bezpečnosť', 'bezpečnostné vedy', 28);
INSERT INTO public.study_program VALUES (380, 'inteligentné informačné systémy', 'informatika', 15);
INSERT INTO public.study_program VALUES (381, 'inteligentné informačné systémy (konverzný)', 'informatika', 15);
INSERT INTO public.study_program VALUES (382, 'inteligentné riadenie procesov', 'kybernetika', 19);
INSERT INTO public.study_program VALUES (383, 'inteligentné softvérové systémy', 'informatika', 27);
INSERT INTO public.study_program VALUES (384, 'inteligentné softvérové systémy (konverzný)', 'informatika', 27);
INSERT INTO public.study_program VALUES (385, 'inteligentné systémy', 'informatika', 3);
INSERT INTO public.study_program VALUES (386, 'inteligentné technológie a automobilová mechatronika', 'kybernetika', 26);
INSERT INTO public.study_program VALUES (387, 'inteligentné technológie v priemysle', 'strojárstvo', 4);
INSERT INTO public.study_program VALUES (388, 'inžinierska geodézia a kataster nehnuteľností', 'geodézia a kartografia', 14);
INSERT INTO public.study_program VALUES (389, 'inžinierska geológia a hydrogeológia', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (390, 'inžinierske konštrukcie a dopravné stavby', 'stavebníctvo', 10);
INSERT INTO public.study_program VALUES (391, 'inžinierske konštrukcie a dopravné stavby', 'stavebníctvo', 43);
INSERT INTO public.study_program VALUES (392, 'inžinierske konštrukcie a dopravné stavby', 'stavebníctvo', 29);
INSERT INTO public.study_program VALUES (393, 'jadrová a subjadrová fyzika', 'fyzika', 17);
INSERT INTO public.study_program VALUES (394, 'jadrová chémia a rádioekológia', 'chémia', 5);
INSERT INTO public.study_program VALUES (395, 'jadrová energetika', 'elektrotechnika', 26);
INSERT INTO public.study_program VALUES (396, 'jadrové a fyzikálne inžinierstvo', 'elektrotechnika', 26);
INSERT INTO public.study_program VALUES (397, 'katolícka teológia', 'teológia', 44);
INSERT INTO public.study_program VALUES (398, 'klasické jazyky', 'filológia', 24);
INSERT INTO public.study_program VALUES (399, 'klinická biochémia', 'všeobecné lekárstvo', 22);
INSERT INTO public.study_program VALUES (400, 'klinická farmakológia', 'všeobecné lekárstvo', 21);
INSERT INTO public.study_program VALUES (401, 'klinická farmakológia', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (402, 'klinická farmácia', 'farmácia', 41);
INSERT INTO public.study_program VALUES (403, 'klinická psychológia', 'psychológia', 24);
INSERT INTO public.study_program VALUES (404, 'kognitívna veda', 'informatika', 17);
INSERT INTO public.study_program VALUES (405, 'komerčná logistika', 'doprava', 14);
INSERT INTO public.study_program VALUES (406, 'komunikačné a informačné technológie', 'informatika', 6);
INSERT INTO public.study_program VALUES (407, 'kozmické inžinierstvo', 'elektrotechnika', 26);
INSERT INTO public.study_program VALUES (408, 'koľajové vozidlá', 'strojárstvo', 34);
INSERT INTO public.study_program VALUES (409, 'krajinárstvo', 'poľnohospodárstvo a krajinárstvo', 29);
INSERT INTO public.study_program VALUES (410, 'krajinárstvo a krajinné plánovanie', 'poľnohospodárstvo a krajinárstvo', 29);
INSERT INTO public.study_program VALUES (411, 'krízový manažment', 'bezpečnostné vedy', 11);
INSERT INTO public.study_program VALUES (412, 'kultúry a náboženstvá sveta', 'historické vedy', 24);
INSERT INTO public.study_program VALUES (413, 'kvalita a bezpečnosť', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (414, 'kvalita a bezpečnosť (Quality and Safety)', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (415, 'kvantová elektronika a optika a optická spektroskopia', 'fyzika', 17);
INSERT INTO public.study_program VALUES (416, 'kyberbezpečnosť', 'informatika', 3);
INSERT INTO public.study_program VALUES (417, 'kybernetika v chemických a potravinárskych technológiách', 'kybernetika', 19);
INSERT INTO public.study_program VALUES (418, 'kánonické právo', 'právo', 38);
INSERT INTO public.study_program VALUES (419, 'laboratórne vyšetrovacie metódy v zdravotníctve', 'zdravotnícke vedy', 22);
INSERT INTO public.study_program VALUES (420, 'latinský jazyk a kultúra (v kombinácii)', 'filológia', 24);
INSERT INTO public.study_program VALUES (421, 'latinský jazyk a literatúra - britské a americké štúdiá', 'filológia', 25);
INSERT INTO public.study_program VALUES (422, 'latinský jazyk a literatúra - filozofia', 'filológia', 25);
INSERT INTO public.study_program VALUES (423, 'latinský jazyk a literatúra - história', 'filológia', 25);
INSERT INTO public.study_program VALUES (424, 'latinský jazyk a literatúra - nemecký jazyk a literatúra', 'filológia', 25);
INSERT INTO public.study_program VALUES (425, 'latinský jazyk a literatúra - slovenský jazyk a literatúra', 'filológia', 25);
INSERT INTO public.study_program VALUES (426, 'lekárska biofyzika', 'všeobecné lekárstvo', 21);
INSERT INTO public.study_program VALUES (427, 'lekárska biológia a klinická genetika', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (428, 'lekárska farmakológia', 'farmácia', 22);
INSERT INTO public.study_program VALUES (429, 'lekárska mikrobiológia a imunológia', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (430, 'lekárska, klinická a farmaceutická biochémia', 'všeobecné lekárstvo', 21);
INSERT INTO public.study_program VALUES (431, 'lekárska, klinická a farmaceutická biochémia', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (432, 'lekárske neurovedy', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (433, 'letecká a kozmická technika (Aerospace Technology)', 'doprava', 1);
INSERT INTO public.study_program VALUES (434, 'letecká doprava', 'doprava', 2);
INSERT INTO public.study_program VALUES (435, 'letecké a kozmické inžinierstvo', 'doprava', 1);
INSERT INTO public.study_program VALUES (436, 'letecké a kozmické systémy', 'doprava', 1);
INSERT INTO public.study_program VALUES (437, 'liečebná pedagogika', 'logopédia a liečebná pedagogika', 35);
INSERT INTO public.study_program VALUES (438, 'literárna veda', 'filológia', 25);
INSERT INTO public.study_program VALUES (439, 'literárna veda', 'filológia', 24);
INSERT INTO public.study_program VALUES (440, 'logopédia', 'logopédia a liečebná pedagogika', 35);
INSERT INTO public.study_program VALUES (441, 'ložisková geológia', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (442, 'management in nuclear', 'elektrotechnika', 26);
INSERT INTO public.study_program VALUES (443, 'management in nuclear', 'ekonómia a manažment', 36);
INSERT INTO public.study_program VALUES (444, 'manažment', 'ekonómia a manažment', 45);
INSERT INTO public.study_program VALUES (445, 'manažment', 'ekonómia a manažment', 15);
INSERT INTO public.study_program VALUES (446, 'manažment a právo', 'ekonómia a manažment', 38);
INSERT INTO public.study_program VALUES (447, 'manažment a zdravotnícke technológie', 'verejné zdravotníctvo', 41);
INSERT INTO public.study_program VALUES (448, 'manažment cestovného ruchu', 'ekonómia a manažment', 16);
INSERT INTO public.study_program VALUES (449, 'manažment medzinárodného obchodu', 'ekonómia a manažment', 16);
INSERT INTO public.study_program VALUES (450, 'manažment medzinárodného podnikania', 'ekonómia a manažment', 16);
INSERT INTO public.study_program VALUES (451, 'manažment verejných politík', 'ekonómia a manažment', 13);
INSERT INTO public.study_program VALUES (452, 'manažérska matematika', 'matematika', 20);
INSERT INTO public.study_program VALUES (453, 'manažérska matematika', 'matematika', 17);
INSERT INTO public.study_program VALUES (454, 'manažérstvo leteckej dopravy', 'doprava', 1);
INSERT INTO public.study_program VALUES (455, 'manažérstvo procesov', 'získavanie a spracovanie zemských zdrojov', 14);
INSERT INTO public.study_program VALUES (456, 'manažérstvo zemských zdrojov', 'získavanie a spracovanie zemských zdrojov', 14);
INSERT INTO public.study_program VALUES (457, 'marketingová komunikácia', 'mediálne a komunikačné štúdiá', 24);
INSERT INTO public.study_program VALUES (458, 'marketingový a obchodný manažment', 'ekonómia a manažment', 16);
INSERT INTO public.study_program VALUES (459, 'matematicko-počítačové modelovanie', 'matematika', 29);
INSERT INTO public.study_program VALUES (460, 'matematická optimalizácia', 'matematika', 20);
INSERT INTO public.study_program VALUES (461, 'matematika', 'matematika', 20);
INSERT INTO public.study_program VALUES (462, 'matematika', 'matematika', 17);
INSERT INTO public.study_program VALUES (463, 'matematika - biológia', 'matematika', 20);
INSERT INTO public.study_program VALUES (464, 'matematika - chémia', 'matematika', 20);
INSERT INTO public.study_program VALUES (465, 'matematika - ekonomické a matematické modelovanie', 'matematika', 20);
INSERT INTO public.study_program VALUES (466, 'matematika - fyzika', 'matematika', 20);
INSERT INTO public.study_program VALUES (467, 'matematika - geografia', 'matematika', 20);
INSERT INTO public.study_program VALUES (468, 'matematika - informatika', 'matematika', 20);
INSERT INTO public.study_program VALUES (469, 'matematika - psychológia', 'matematika', 20);
INSERT INTO public.study_program VALUES (470, 'materiálové inžinierstvo', 'strojárstvo', 28);
INSERT INTO public.study_program VALUES (471, 'materiálové inžinierstvo', 'strojárstvo', 34);
INSERT INTO public.study_program VALUES (472, 'materiálové inžinierstvo', 'strojárstvo', 9);
INSERT INTO public.study_program VALUES (473, 'materiály', 'strojárstvo', 9);
INSERT INTO public.study_program VALUES (474, 'maďarský jazyk - editorstvo a vydavateľská prax', 'filológia', 24);
INSERT INTO public.study_program VALUES (475, 'maďarský jazyk a kultúra (v kombinácii)', 'filológia', 24);
INSERT INTO public.study_program VALUES (476, 'mechanika a konštrukcia strojov', 'strojárstvo', 34);
INSERT INTO public.study_program VALUES (477, 'mechatronické systémy', 'kybernetika', 26);
INSERT INTO public.study_program VALUES (478, 'mechatronika v technologických zariadeniach', 'kybernetika', 28);
INSERT INTO public.study_program VALUES (479, 'mediamatika', 'mediálne a komunikačné štúdiá', 12);
INSERT INTO public.study_program VALUES (480, 'medicínska biológia', 'biológia', 5);
INSERT INTO public.study_program VALUES (481, 'mediácia a probácia', 'právo', 38);
INSERT INTO public.study_program VALUES (482, 'mediálne a komunikačné štúdiá', 'mediálne a komunikačné štúdiá', 24);
INSERT INTO public.study_program VALUES (483, 'medzinárodné ekonomické vzťahy', 'ekonómia a manažment', 42);
INSERT INTO public.study_program VALUES (484, 'medzinárodné podnikanie', 'ekonómia a manažment', 16);
INSERT INTO public.study_program VALUES (485, 'medzinárodné právo', 'právo', 46);
INSERT INTO public.study_program VALUES (486, 'medzinárodné právo', 'právo', 38);
INSERT INTO public.study_program VALUES (487, 'medzinárodný manažment', 'ekonómia a manažment', 45);
INSERT INTO public.study_program VALUES (488, 'meracia technika', 'elektrotechnika', 26);
INSERT INTO public.study_program VALUES (489, 'meranie a manažérstvo kvality v strojárstve', 'strojárstvo', 30);
INSERT INTO public.study_program VALUES (490, 'meranie a skúšobníctvo', 'strojárstvo', 30);
INSERT INTO public.study_program VALUES (491, 'metalurgické technológie a digitálna transformácia priemyslu', 'získavanie a spracovanie zemských zdrojov', 9);
INSERT INTO public.study_program VALUES (492, 'metrológia', 'strojárstvo', 30);
INSERT INTO public.study_program VALUES (493, 'mikrobiológia a virológia', 'biológia', 5);
INSERT INTO public.study_program VALUES (494, 'mineralurgia a environmentálne technológie', 'získavanie a spracovanie zemských zdrojov', 14);
INSERT INTO public.study_program VALUES (495, 'mineralógia a petrológia', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (496, 'mineralógia, petrológia a ložisková geológia', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (497, 'molekulárna biológia', 'biológia', 5);
INSERT INTO public.study_program VALUES (498, 'molekulárna cytológia a genetika', 'biológia', 20);
INSERT INTO public.study_program VALUES (499, 'multimediálne informačné a komunikačné technológie', 'informatika', 26);
INSERT INTO public.study_program VALUES (500, 'multimediálne inžinierstvo', 'informatika', 6);
INSERT INTO public.study_program VALUES (501, 'multimediálne technológie', 'informatika', 6);
INSERT INTO public.study_program VALUES (502, 'muzikológia', 'vedy o umení a kultúre', 24);
INSERT INTO public.study_program VALUES (503, 'nemecký jazyk a kultúra (v kombinácii)', 'filológia', 24);
INSERT INTO public.study_program VALUES (504, 'nemecký jazyk a literatúra - filozofia', 'filológia', 25);
INSERT INTO public.study_program VALUES (505, 'nemecký jazyk a literatúra - geografia', 'filológia', 25);
INSERT INTO public.study_program VALUES (506, 'nemecký jazyk a literatúra - informatika', 'filológia', 25);
INSERT INTO public.study_program VALUES (507, 'nemecký jazyk a literatúra - psychológia', 'filológia', 25);
INSERT INTO public.study_program VALUES (508, 'nemecký jazyk pre firemnú prax a projektový manažment', 'filológia', 25);
INSERT INTO public.study_program VALUES (509, 'neurológia', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (510, 'neurológia', 'všeobecné lekárstvo', 21);
INSERT INTO public.study_program VALUES (511, 'neurológia', 'všeobecné lekárstvo', 22);
INSERT INTO public.study_program VALUES (512, 'normálna a patologická fyziológia', 'všeobecné lekárstvo', 21);
INSERT INTO public.study_program VALUES (513, 'normálna a patologická fyziológia', 'všeobecné lekárstvo', 22);
INSERT INTO public.study_program VALUES (514, 'normálna a patologická fyziológia', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (515, 'nosné konštrukcie a dopravné stavby', 'stavebníctvo', 43);
INSERT INTO public.study_program VALUES (516, 'nosné konštrukcie stavieb', 'stavebníctvo', 29);
INSERT INTO public.study_program VALUES (517, 'náuka o materiáloch', 'strojárstvo', 9);
INSERT INTO public.study_program VALUES (518, 'obchodné a finančné právo', 'právo', 38);
INSERT INTO public.study_program VALUES (519, 'obchodné a finančné právo', 'právo', 46);
INSERT INTO public.study_program VALUES (520, 'obchodné podnikanie', 'ekonómia a manažment', 8);
INSERT INTO public.study_program VALUES (521, 'obnoviteľné zdroje energie', 'strojárstvo', 4);
INSERT INTO public.study_program VALUES (522, 'obnoviteľné zdroje energie a environmentálna fyzika', 'fyzika', 17);
INSERT INTO public.study_program VALUES (523, 'obnoviteľné zdroje energie a environmentálna fyzika (konverzný program)', 'fyzika', 17);
INSERT INTO public.study_program VALUES (524, 'občianske právo', 'právo', 38);
INSERT INTO public.study_program VALUES (525, 'občianske právo', 'právo', 46);
INSERT INTO public.study_program VALUES (526, 'ochrana materiálov a objektov dedičstva', 'chemické inžinierstvo a technológie', 19);
INSERT INTO public.study_program VALUES (527, 'ochrana životného prostredia a ekotechnológie surovín', 'získavanie a spracovanie zemských zdrojov', 14);
INSERT INTO public.study_program VALUES (528, 'odborová didaktika', 'učiteľstvo a pedagogické vedy', 5);
INSERT INTO public.study_program VALUES (529, 'oftalmológia', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (530, 'onkológia', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (531, 'optika, lasery a optická spektroskopia', 'fyzika', 17);
INSERT INTO public.study_program VALUES (532, 'organická a bioorganická chémia', 'chémia', 5);
INSERT INTO public.study_program VALUES (533, 'organická chémia', 'chémia', 5);
INSERT INTO public.study_program VALUES (534, 'organická chémia', 'chémia', 19);
INSERT INTO public.study_program VALUES (535, 'organická chémia', 'chémia', 20);
INSERT INTO public.study_program VALUES (536, 'organizácia a riadenie športu', 'vedy o športe', 47);
INSERT INTO public.study_program VALUES (537, 'ortopédia', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (538, 'otorinolaryngológia', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (539, 'ošetrovateľstvo', 'ošetrovateľstvo', 21);
INSERT INTO public.study_program VALUES (540, 'ošetrovateľstvo', 'ošetrovateľstvo', 22);
INSERT INTO public.study_program VALUES (541, 'paleontológia', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (542, 'patologická anatómia a súdne lekárstvo', 'všeobecné lekárstvo', 21);
INSERT INTO public.study_program VALUES (543, 'patologická anatómia a súdne lekárstvo', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (544, 'pedagogika', 'učiteľstvo a pedagogické vedy', 24);
INSERT INTO public.study_program VALUES (545, 'pediatria', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (546, 'pediatria', 'všeobecné lekárstvo', 21);
INSERT INTO public.study_program VALUES (547, 'pilot', 'doprava', 1);
INSERT INTO public.study_program VALUES (548, 'podnikanie', 'ekonómia a manažment', 45);
INSERT INTO public.study_program VALUES (549, 'podnikanie v cestovnom ruchu a službách', 'ekonómia a manažment', 16);
INSERT INTO public.study_program VALUES (550, 'podnikový obchod a marketing', 'ekonómia a manažment', 8);
INSERT INTO public.study_program VALUES (551, 'poistná matematika', 'matematika', 17);
INSERT INTO public.study_program VALUES (552, 'politológia', 'politické vedy', 25);
INSERT INTO public.study_program VALUES (553, 'politológia', 'politické vedy', 24);
INSERT INTO public.study_program VALUES (554, 'potraviny, hygiena, kozmetika', 'potravinárstvo', 19);
INSERT INTO public.study_program VALUES (555, 'potraviny, výživa, kozmetika', 'potravinárstvo', 19);
INSERT INTO public.study_program VALUES (556, 'potraviny, výživa, kozmetika (konverzný)', 'potravinárstvo', 19);
INSERT INTO public.study_program VALUES (557, 'pozemné stavby', 'stavebníctvo', 43);
INSERT INTO public.study_program VALUES (558, 'pozemné stavby a architektúra', 'stavebníctvo', 43);
INSERT INTO public.study_program VALUES (559, 'pozemné stavby a architektúra', 'stavebníctvo', 29);
INSERT INTO public.study_program VALUES (560, 'pozemné staviteľstvo', 'stavebníctvo', 10);
INSERT INTO public.study_program VALUES (561, 'počítačová grafika a geometria', 'matematika', 17);
INSERT INTO public.study_program VALUES (562, 'počítačová grafika a geometria - konverzný program', 'matematika', 17);
INSERT INTO public.study_program VALUES (563, 'počítačová podpora návrhu a výroby', 'strojárstvo', 28);
INSERT INTO public.study_program VALUES (564, 'počítačová podpora strojárskej výroby', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (565, 'počítačová podpora výrobných technológií', 'strojárstvo', 4);
INSERT INTO public.study_program VALUES (566, 'počítačová podpora výrobných technológií', 'strojárstvo', 28);
INSERT INTO public.study_program VALUES (567, 'počítačové inžinierstvo', 'informatika', 15);
INSERT INTO public.study_program VALUES (568, 'počítačové inžinierstvo (konverzný)', 'informatika', 15);
INSERT INTO public.study_program VALUES (569, 'počítačové konštruovanie a simulácie', 'strojárstvo', 34);
INSERT INTO public.study_program VALUES (570, 'počítačové modelovanie', 'informatika', 3);
INSERT INTO public.study_program VALUES (571, 'počítačové modelovanie a simulácie v strojárstve', 'strojárstvo', 34);
INSERT INTO public.study_program VALUES (572, 'počítačové siete', 'informatika', 3);
INSERT INTO public.study_program VALUES (573, 'poštové inžinierstvo', 'doprava', 2);
INSERT INTO public.study_program VALUES (574, 'pracovné právo', 'právo', 38);
INSERT INTO public.study_program VALUES (575, 'pravdepodobnosť a matematická štatistika', 'matematika', 17);
INSERT INTO public.study_program VALUES (576, 'predškolská a elementárna pedagogika', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (577, 'prevádzkový technik dopravnej a výrobnej techniky', 'strojárstvo', 30);
INSERT INTO public.study_program VALUES (578, 'priemyselná elektrotechnika', 'elektrotechnika', 3);
INSERT INTO public.study_program VALUES (579, 'priemyselná logistika', 'doprava', 14);
INSERT INTO public.study_program VALUES (580, 'priemyselná mechatronika', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (581, 'priemyselné inžinierstvo', 'strojárstvo', 34);
INSERT INTO public.study_program VALUES (582, 'priemyselné inžinierstvo', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (583, 'priemyselné manažérstvo', 'strojárstvo', 28);
INSERT INTO public.study_program VALUES (584, 'priemyselný manažment', 'strojárstvo', 4);
INSERT INTO public.study_program VALUES (585, 'priestorová a regionálna ekonómia', 'ekonómia a manažment', 37);
INSERT INTO public.study_program VALUES (586, 'procesná technika', 'strojárstvo', 30);
INSERT INTO public.study_program VALUES (587, 'procesná technika', 'strojárstvo', 4);
INSERT INTO public.study_program VALUES (588, 'process control', 'kybernetika', 19);
INSERT INTO public.study_program VALUES (589, 'process control (remedial)', 'kybernetika', 19);
INSERT INTO public.study_program VALUES (590, 'progresívne materiály', 'fyzika', 20);
INSERT INTO public.study_program VALUES (591, 'progresívne materiály a materiálový dizajn', 'strojárstvo', 28);
INSERT INTO public.study_program VALUES (592, 'protetika a ortotika', 'elektrotechnika', 7);
INSERT INTO public.study_program VALUES (593, 'právo', 'právo', 46);
INSERT INTO public.study_program VALUES (594, 'právo', 'právo', 38);
INSERT INTO public.study_program VALUES (595, 'právo Európskej únie', 'právo', 38);
INSERT INTO public.study_program VALUES (596, 'právo a ekonómia', 'právo', 13);
INSERT INTO public.study_program VALUES (597, 'právo a ekonómia', 'právo', 38);
INSERT INTO public.study_program VALUES (598, 'právo informačných technológií', 'právo', 38);
INSERT INTO public.study_program VALUES (599, 'prírodné a syntetické polyméry', 'chemické inžinierstvo a technológie', 19);
INSERT INTO public.study_program VALUES (600, 'psychiatria', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (601, 'psychológia', 'psychológia', 25);
INSERT INTO public.study_program VALUES (602, 'psychológia', 'psychológia', 24);
INSERT INTO public.study_program VALUES (603, 'psychológia zdravia', 'psychológia', 12);
INSERT INTO public.study_program VALUES (604, 'pôdna ekofyziológia', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (605, 'pôrodná asistencia', 'pôrodná asistencia', 21);
INSERT INTO public.study_program VALUES (692, 'teoretická fyzika a matematická fyzika', 'fyzika', 17);
INSERT INTO public.study_program VALUES (606, 'recyklačné a environmentálne technológie', 'získavanie a spracovanie zemských zdrojov', 9);
INSERT INTO public.study_program VALUES (607, 'regionálna geografia', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (608, 'regionálna geografia, rozvoj regiónov a európska integrácia', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (609, 'religionistika', 'historické vedy', 24);
INSERT INTO public.study_program VALUES (610, 'riadenie a ekonomika podniku', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (611, 'riadenie leteckej dopravy', 'doprava', 1);
INSERT INTO public.study_program VALUES (612, 'riadenie priemyselnej výroby', 'strojárstvo', 4);
INSERT INTO public.study_program VALUES (613, 'riadenie procesov', 'kybernetika', 6);
INSERT INTO public.study_program VALUES (614, 'riadenie procesov', 'kybernetika', 19);
INSERT INTO public.study_program VALUES (615, 'riadenie procesov', 'kybernetika', 14);
INSERT INTO public.study_program VALUES (616, 'riadenie procesov (konverzný)', 'kybernetika', 19);
INSERT INTO public.study_program VALUES (617, 'riadenie procesov získavania a spracovania surovín', 'kybernetika', 14);
INSERT INTO public.study_program VALUES (618, 'robotika a kybernetika', 'kybernetika', 26);
INSERT INTO public.study_program VALUES (619, 'robotika a robototechnológie', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (620, 'románske štúdiá', 'filológia', 24);
INSERT INTO public.study_program VALUES (621, 'ruské a východoeurópske štúdiá', 'filológia', 24);
INSERT INTO public.study_program VALUES (622, 'ruský jazyk a kultúra (v kombinácii)', 'filológia', 24);
INSERT INTO public.study_program VALUES (623, 'rádiológia', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (624, 'rímske právo', 'právo', 38);
INSERT INTO public.study_program VALUES (625, 'röntgenológia a rádiológia', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (626, 'silnoprúdová elektrotechnika', 'elektrotechnika', 6);
INSERT INTO public.study_program VALUES (627, 'slavistika', 'filológia', 24);
INSERT INTO public.study_program VALUES (628, 'slovakisticko-mediálne štúdiá', 'filológia', 25);
INSERT INTO public.study_program VALUES (629, 'slovanské štúdiá', 'filológia', 24);
INSERT INTO public.study_program VALUES (630, 'slovenská literatúra', 'filológia', 24);
INSERT INTO public.study_program VALUES (631, 'slovenské dejiny', 'historické vedy', 24);
INSERT INTO public.study_program VALUES (632, 'slovenské dejiny', 'historické vedy', 25);
INSERT INTO public.study_program VALUES (633, 'slovenský jazyk', 'filológia', 24);
INSERT INTO public.study_program VALUES (634, 'slovenský jazyk a kultúra (v kombinácii)', 'filológia', 24);
INSERT INTO public.study_program VALUES (635, 'slovenský jazyk a literatúra', 'filológia', 24);
INSERT INTO public.study_program VALUES (636, 'slovenský jazyk a literatúra - biológia', 'filológia', 25);
INSERT INTO public.study_program VALUES (637, 'slovenský jazyk a literatúra - britské a americké štúdiá', 'filológia', 25);
INSERT INTO public.study_program VALUES (638, 'slovenský jazyk a literatúra - filozofia', 'filológia', 25);
INSERT INTO public.study_program VALUES (639, 'slovenský jazyk a literatúra - geografia', 'filológia', 25);
INSERT INTO public.study_program VALUES (640, 'slovenský jazyk a literatúra - informatika', 'filológia', 25);
INSERT INTO public.study_program VALUES (641, 'slovenský jazyk a literatúra - matematika', 'filológia', 25);
INSERT INTO public.study_program VALUES (642, 'slovenský jazyk a literatúra - nemecký jazyk a literatúra', 'filológia', 25);
INSERT INTO public.study_program VALUES (643, 'slovenský jazyk a literatúra - psychológia', 'filológia', 25);
INSERT INTO public.study_program VALUES (644, 'smart technológie v priemysle', 'strojárstvo', 4);
INSERT INTO public.study_program VALUES (645, 'sociológia', 'sociológia a sociálna antropológia', 24);
INSERT INTO public.study_program VALUES (646, 'sociálna a pracovná psychológia', 'psychológia', 12);
INSERT INTO public.study_program VALUES (647, 'sociálna antropológia', 'sociológia a sociálna antropológia', 12);
INSERT INTO public.study_program VALUES (648, 'sociálna práca', 'sociálna práca', 35);
INSERT INTO public.study_program VALUES (649, 'sociálna práca', 'sociálna práca', 25);
INSERT INTO public.study_program VALUES (650, 'sociálna práca s konverzným ročníkom', 'sociálna práca', 25);
INSERT INTO public.study_program VALUES (651, 'sociálna psychológia a psychológia práce', 'psychológia', 25);
INSERT INTO public.study_program VALUES (652, 'sociálna psychológia a psychológia práce', 'psychológia', 25);
INSERT INTO public.study_program VALUES (653, 'space engineering', 'elektrotechnika', 26);
INSERT INTO public.study_program VALUES (654, 'spracovanie a recyklácia odpadov', 'získavanie a spracovanie zemských zdrojov', 9);
INSERT INTO public.study_program VALUES (655, 'správne právo', 'právo', 38);
INSERT INTO public.study_program VALUES (656, 'stratégia a podnikanie', 'ekonómia a manažment', 45);
INSERT INTO public.study_program VALUES (657, 'stredoeurópske štúdiá', 'filológia', 24);
INSERT INTO public.study_program VALUES (658, 'strojné inžinierstvo', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (659, 'strojárske technológie', 'strojárstvo', 34);
INSERT INTO public.study_program VALUES (660, 'strojárske technológie', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (661, 'strojárske technológie a materiály', 'strojárstvo', 30);
INSERT INTO public.study_program VALUES (662, 'strojárske technológie a materiály', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (663, 'strojárske technológie a materiály', 'strojárstvo', 28);
INSERT INTO public.study_program VALUES (664, 'strojárske technológie a materiály (Mechanical engineering technologies and materials)', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (665, 'strojárstvo', 'strojárstvo', 34);
INSERT INTO public.study_program VALUES (666, 'systematická biológia', 'biológia', 5);
INSERT INTO public.study_program VALUES (667, 'systematická filozofia', 'filozofia', 24);
INSERT INTO public.study_program VALUES (668, 'taliansky jazyk a kultúra (v kombinácii)', 'filológia', 24);
INSERT INTO public.study_program VALUES (669, 'technická chémia', 'chémia', 19);
INSERT INTO public.study_program VALUES (670, 'technická fyzika', 'fyzika', 17);
INSERT INTO public.study_program VALUES (671, 'technická fyzika (konverzný program)', 'fyzika', 17);
INSERT INTO public.study_program VALUES (672, 'technické materiály', 'strojárstvo', 34);
INSERT INTO public.study_program VALUES (673, 'technické zariadenia budov', 'stavebníctvo', 29);
INSERT INTO public.study_program VALUES (674, 'technika ochrany životného prostredia', 'strojárstvo', 30);
INSERT INTO public.study_program VALUES (675, 'technika prostredia', 'strojárstvo', 34);
INSERT INTO public.study_program VALUES (676, 'technológia a manažment stavieb', 'stavebníctvo', 10);
INSERT INTO public.study_program VALUES (677, 'technológia a manažment v stavebníctve', 'stavebníctvo', 43);
INSERT INTO public.study_program VALUES (678, 'technológia polymérnych materiálov', 'chemické inžinierstvo a technológie', 19);
INSERT INTO public.study_program VALUES (679, 'technológia stavieb', 'stavebníctvo', 29);
INSERT INTO public.study_program VALUES (680, 'technológie a manažérstvo stavieb', 'stavebníctvo', 29);
INSERT INTO public.study_program VALUES (681, 'technológie automobilovej výroby', 'strojárstvo', 4);
INSERT INTO public.study_program VALUES (682, 'technológie ochrany životného prostredia', 'chemické inžinierstvo a technológie', 19);
INSERT INTO public.study_program VALUES (683, 'technológie spracovania a nástroje na spracovanie polymérnych materiálov', 'chemické inžinierstvo a technológie', 19);
INSERT INTO public.study_program VALUES (684, 'technológie, manažment a inovácie strojárskej výroby', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (685, 'tektonika a sedimentológia', 'vedy o Zemi', 5);
INSERT INTO public.study_program VALUES (686, 'telekomunikačné a rádiokomunikačné inžinierstvo', 'informatika', 6);
INSERT INTO public.study_program VALUES (687, 'telekomunikácie', 'informatika', 26);
INSERT INTO public.study_program VALUES (688, 'telekomunikácie', 'informatika', 6);
INSERT INTO public.study_program VALUES (689, 'teoretická a počítačová chémia', 'chémia', 5);
INSERT INTO public.study_program VALUES (690, 'teoretická elektrotechnika', 'elektrotechnika', 6);
INSERT INTO public.study_program VALUES (691, 'teoretická fyzika', 'fyzika', 17);
INSERT INTO public.study_program VALUES (693, 'teória a dejiny štátu a práva', 'právo', 38);
INSERT INTO public.study_program VALUES (694, 'teória a dejiny štátu a práva', 'právo', 46);
INSERT INTO public.study_program VALUES (695, 'teória a konštrukcie inžinierskych stavieb', 'stavebníctvo', 29);
INSERT INTO public.study_program VALUES (696, 'teória a konštrukcie inžinierskych stavieb', 'stavebníctvo', 10);
INSERT INTO public.study_program VALUES (697, 'teória a konštrukcie pozemných stavieb', 'stavebníctvo', 29);
INSERT INTO public.study_program VALUES (698, 'teória a konštrukcie pozemných stavieb', 'stavebníctvo', 10);
INSERT INTO public.study_program VALUES (699, 'teória a navrhovanie inžinierskych stavieb', 'stavebníctvo', 43);
INSERT INTO public.study_program VALUES (700, 'teória a technika prostredia budov', 'stavebníctvo', 29);
INSERT INTO public.study_program VALUES (701, 'teória technológie a riadenia v stavebníctve', 'stavebníctvo', 43);
INSERT INTO public.study_program VALUES (702, 'teória tvorby budov a prostredia', 'stavebníctvo', 43);
INSERT INTO public.study_program VALUES (703, 'teória vyučovania fyziky', 'fyzika', 20);
INSERT INTO public.study_program VALUES (704, 'teória vyučovania fyziky', 'fyzika', 17);
INSERT INTO public.study_program VALUES (705, 'teória vyučovania informatiky', 'informatika', 17);
INSERT INTO public.study_program VALUES (706, 'teória vyučovania matematiky', 'matematika', 20);
INSERT INTO public.study_program VALUES (707, 'translatológia', 'filológia', 24);
INSERT INTO public.study_program VALUES (708, 'trestné právo', 'právo', 46);
INSERT INTO public.study_program VALUES (709, 'trestné právo', 'právo', 38);
INSERT INTO public.study_program VALUES (710, 'trénerstvo', 'vedy o športe', 47);
INSERT INTO public.study_program VALUES (711, 'trénerstvo a učiteľstvo telesnej výchovy', 'vedy o športe', 47);
INSERT INTO public.study_program VALUES (712, 'umelá inteligencia', 'informatika', 3);
INSERT INTO public.study_program VALUES (713, 'umenie vo verejnom priestore', 'umenie', 32);
INSERT INTO public.study_program VALUES (714, 'umenovedné štúdiá', 'vedy o umení a kultúre', 24);
INSERT INTO public.study_program VALUES (715, 'urbanizmus', 'architektúra a urbanizmus', 32);
INSERT INTO public.study_program VALUES (716, 'urbanizmus', 'ekonómia a manažment', 16);
INSERT INTO public.study_program VALUES (717, 'urológia', 'všeobecné lekárstvo', 21);
INSERT INTO public.study_program VALUES (718, 'urológia', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (719, 'učiteľstvo anglického jazyka a literatúry (v kombinácii)', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (720, 'učiteľstvo anglického jazyka a literatúry (v kombinácii)', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (721, 'učiteľstvo anglického jazyka a literatúry (v kombinácii)', 'učiteľstvo a pedagogické vedy', 24);
INSERT INTO public.study_program VALUES (722, 'učiteľstvo anglického jazyka a literatúry a biológie', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (723, 'učiteľstvo anglického jazyka a literatúry a geografie', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (724, 'učiteľstvo anglického jazyka a literatúry a informatiky', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (725, 'učiteľstvo anglického jazyka a literatúry a matematiky', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (726, 'učiteľstvo anglického jazyka a literatúry a psychológie', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (727, 'učiteľstvo anglického jazyka a literatúry a výchovy k občianstvu', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (728, 'učiteľstvo biológie (v kombinácii)', 'učiteľstvo a pedagogické vedy', 5);
INSERT INTO public.study_program VALUES (729, 'učiteľstvo biológie (v kombinácii)', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (730, 'učiteľstvo biológie a chémie', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (731, 'učiteľstvo biológie a geografie', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (732, 'učiteľstvo biológie a informatiky', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (733, 'učiteľstvo biológie a psychológie', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (734, 'učiteľstvo chémie (v kombinácii)', 'učiteľstvo a pedagogické vedy', 5);
INSERT INTO public.study_program VALUES (735, 'učiteľstvo chémie (v kombinácii)', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (736, 'učiteľstvo chémie a geografie', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (737, 'učiteľstvo chémie a informatiky', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (738, 'učiteľstvo deskriptívnej geometrie (v kombinácii)', 'učiteľstvo a pedagogické vedy', 17);
INSERT INTO public.study_program VALUES (739, 'učiteľstvo deskriptívnej geometrie (v kombinácii) - konverzný ŠP', 'učiteľstvo a pedagogické vedy', 17);
INSERT INTO public.study_program VALUES (740, 'učiteľstvo estetickej výchovy (v kombinácii)', 'učiteľstvo a pedagogické vedy', 24);
INSERT INTO public.study_program VALUES (741, 'učiteľstvo etickej výchovy (v kombinácii)', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (742, 'učiteľstvo etickej výchovy a psychológie', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (743, 'učiteľstvo filozofie (v kombinácii)', 'učiteľstvo a pedagogické vedy', 24);
INSERT INTO public.study_program VALUES (744, 'učiteľstvo fyziky (v kombinácii)', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (745, 'učiteľstvo fyziky (v kombinácii)', 'učiteľstvo a pedagogické vedy', 17);
INSERT INTO public.study_program VALUES (746, 'učiteľstvo fyziky (v kombinácii) - konverzný ŠP', 'učiteľstvo a pedagogické vedy', 17);
INSERT INTO public.study_program VALUES (747, 'učiteľstvo fyziky a biológie', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (748, 'učiteľstvo fyziky a chémie', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (749, 'učiteľstvo fyziky a geografie', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (750, 'učiteľstvo fyziky a informatiky', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (751, 'učiteľstvo geografie (v kombinácii)', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (752, 'učiteľstvo geografie (v kombinácii)', 'učiteľstvo a pedagogické vedy', 5);
INSERT INTO public.study_program VALUES (753, 'učiteľstvo geografie a informatiky', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (754, 'učiteľstvo geografie a psychológie', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (755, 'učiteľstvo geografie a výchovy k občianstvu', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (756, 'učiteľstvo histórie (v kombinácii)', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (757, 'učiteľstvo histórie (v kombinácii)', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (758, 'učiteľstvo histórie (v kombinácii)', 'učiteľstvo a pedagogické vedy', 24);
INSERT INTO public.study_program VALUES (759, 'učiteľstvo histórie a anglického jazyka a literatúry', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (760, 'učiteľstvo histórie a geografie', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (761, 'učiteľstvo histórie a matematiky', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (762, 'učiteľstvo histórie a nemeckého jazyka a literatúry', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (763, 'učiteľstvo histórie a psychológie', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (764, 'učiteľstvo histórie a slovenského jazyka a literatúry', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (765, 'učiteľstvo histórie a výchovy k občianstvu', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (766, 'učiteľstvo hudobného umenia (v kombinácii)', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (767, 'učiteľstvo informatiky (v kombinácii)', 'učiteľstvo a pedagogické vedy', 17);
INSERT INTO public.study_program VALUES (768, 'učiteľstvo informatiky (v kombinácii)', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (769, 'učiteľstvo informatiky (v kombinácii) - konverzný ŠP', 'učiteľstvo a pedagogické vedy', 17);
INSERT INTO public.study_program VALUES (770, 'učiteľstvo latinského jazyka a literatúry (v kombinácii)', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (771, 'učiteľstvo latinského jazyka a literatúry a anglického jazyka a literatúry', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (772, 'učiteľstvo latinského jazyka a literatúry a histórie', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (773, 'učiteľstvo latinského jazyka a literatúry a slovenského jazyka a literatúry', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (774, 'učiteľstvo matematiky (v kombinácii)', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (775, 'učiteľstvo matematiky (v kombinácii)', 'učiteľstvo a pedagogické vedy', 17);
INSERT INTO public.study_program VALUES (776, 'učiteľstvo matematiky (v kombinácii) - konverzný ŠP', 'učiteľstvo a pedagogické vedy', 17);
INSERT INTO public.study_program VALUES (777, 'učiteľstvo matematiky a biológie', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (778, 'učiteľstvo matematiky a chémie', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (779, 'učiteľstvo matematiky a fyziky', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (780, 'učiteľstvo matematiky a geografie', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (781, 'učiteľstvo matematiky a informatiky', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (782, 'učiteľstvo matematiky a psychológie', 'učiteľstvo a pedagogické vedy', 20);
INSERT INTO public.study_program VALUES (783, 'učiteľstvo maďarského jazyka a literatúry (v kombinácii)', 'učiteľstvo a pedagogické vedy', 24);
INSERT INTO public.study_program VALUES (784, 'učiteľstvo nemeckého jazyka a literatúry (v kombinácii)', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (785, 'učiteľstvo nemeckého jazyka a literatúry (v kombinácii)', 'učiteľstvo a pedagogické vedy', 24);
INSERT INTO public.study_program VALUES (786, 'učiteľstvo nemeckého jazyka a literatúry (v kombinácii)', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (787, 'učiteľstvo nemeckého jazyka a literatúry a anglického jazyka a literatúry', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (788, 'učiteľstvo nemeckého jazyka a literatúry a informatiky', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (789, 'učiteľstvo nemeckého jazyka a literatúry a psychológie', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (790, 'učiteľstvo nemeckého jazyka a literatúry a výchovy k občianstvu', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (791, 'učiteľstvo náboženskej výchovy (v kombinácii)', 'učiteľstvo a pedagogické vedy', 40);
INSERT INTO public.study_program VALUES (792, 'učiteľstvo pedagogiky (v kombinácii)', 'učiteľstvo a pedagogické vedy', 24);
INSERT INTO public.study_program VALUES (793, 'učiteľstvo pedagogiky (v kombinácii)', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (794, 'učiteľstvo pre primárne vzdelávanie', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (795, 'učiteľstvo pre základné školy - vzdelávacia oblasť jazyk a komunikácia', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (796, 'učiteľstvo pre základné školy - vzdelávacia oblasť matematika a informatika', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (797, 'učiteľstvo pre základné školy - vzdelávacia oblasť umenie a kultúra', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (798, 'učiteľstvo pre základné školy - vzdelávacia oblasť človek a spoločnosť', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (799, 'učiteľstvo psychológie (v kombinácii)', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (800, 'učiteľstvo psychológie (v kombinácii)', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (801, 'učiteľstvo slovenského jazyka a literatúry (v kombinácii)', 'učiteľstvo a pedagogické vedy', 24);
INSERT INTO public.study_program VALUES (802, 'učiteľstvo slovenského jazyka a literatúry (v kombinácii)', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (803, 'učiteľstvo slovenského jazyka a literatúry (v kombinácii)', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (804, 'učiteľstvo slovenského jazyka a literatúry a anglického jazyka a literatúry', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (805, 'učiteľstvo slovenského jazyka a literatúry a biológie', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (806, 'učiteľstvo slovenského jazyka a literatúry a geografie', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (807, 'učiteľstvo slovenského jazyka a literatúry a informatiky', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (808, 'učiteľstvo slovenského jazyka a literatúry a matematiky', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (809, 'učiteľstvo slovenského jazyka a literatúry a nemeckého jazyka a literatúry', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (810, 'učiteľstvo slovenského jazyka a literatúry a psychológie', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (811, 'učiteľstvo slovenského jazyka a literatúry a výchovy k občianstvu', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (812, 'učiteľstvo talianskeho jazyka a literatúry (v kombinácii)', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (813, 'učiteľstvo telesnej výchovy (v kombinácii)', 'učiteľstvo a pedagogické vedy', 47);
INSERT INTO public.study_program VALUES (814, 'učiteľstvo výchovy k občianstvu (v kombinácii)', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (815, 'učiteľstvo výchovy k občianstvu (v kombinácii)', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (816, 'učiteľstvo výchovy k občianstvu a psychológie', 'učiteľstvo a pedagogické vedy', 25);
INSERT INTO public.study_program VALUES (817, 'učiteľstvo španielskeho jazyka a literatúry (v kombinácii)', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (818, 'vedy o športe', 'vedy o športe', 47);
INSERT INTO public.study_program VALUES (819, 'verejná politika', 'politické vedy', 12);
INSERT INTO public.study_program VALUES (820, 'verejná správa', 'politické vedy', 39);
INSERT INTO public.study_program VALUES (821, 'verejné zdravotníctvo', 'verejné zdravotníctvo', 22);
INSERT INTO public.study_program VALUES (822, 'verejné zdravotníctvo', 'verejné zdravotníctvo', 21);
INSERT INTO public.study_program VALUES (823, 'vnútorné choroby', 'všeobecné lekárstvo', 21);
INSERT INTO public.study_program VALUES (824, 'vnútorné choroby', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (825, 'vnútorné choroby', 'všeobecné lekárstvo', 22);
INSERT INTO public.study_program VALUES (826, 'vodná doprava', 'doprava', 2);
INSERT INTO public.study_program VALUES (827, 'vodné stavby a vodné hospodárstvo', 'stavebníctvo', 29);
INSERT INTO public.study_program VALUES (828, 'vodohospodárske inžinierstvo', 'stavebníctvo', 29);
INSERT INTO public.study_program VALUES (829, 'vozidlá a motory', 'strojárstvo', 34);
INSERT INTO public.study_program VALUES (830, 'voľné výtvarné umenie', 'umenie', 33);
INSERT INTO public.study_program VALUES (831, 'využívanie a ochrana zemských zdrojov', 'získavanie a spracovanie zemských zdrojov', 14);
INSERT INTO public.study_program VALUES (832, 'využívanie alternatívnych zdrojov energie', 'získavanie a spracovanie zemských zdrojov', 14);
INSERT INTO public.study_program VALUES (833, 'východoázijské jazyky a kultúry', 'filológia', 24);
INSERT INTO public.study_program VALUES (834, 'výkonové elektronické systémy', 'elektrotechnika', 6);
INSERT INTO public.study_program VALUES (835, 'výrobná technika', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (836, 'výrobné stroje a zariadenia', 'strojárstvo', 30);
INSERT INTO public.study_program VALUES (837, 'výrobné systémy a manažérstvo kvality', 'strojárstvo', 30);
INSERT INTO public.study_program VALUES (838, 'výrobné technológie', 'strojárstvo', 4);
INSERT INTO public.study_program VALUES (839, 'výrobné technológie', 'strojárstvo', 28);
INSERT INTO public.study_program VALUES (840, 'výrobné technológie a výrobný manažment', 'strojárstvo', 28);
INSERT INTO public.study_program VALUES (841, 'výrobné zariadenia a systémy', 'strojárstvo', 28);
INSERT INTO public.study_program VALUES (842, 'výtvarná edukácia (v kombinácii)', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (843, 'všeobecná jazykoveda', 'filológia', 24);
INSERT INTO public.study_program VALUES (844, 'všeobecné dejiny', 'historické vedy', 24);
INSERT INTO public.study_program VALUES (845, 'všeobecné lekárstvo', 'všeobecné lekárstvo', 21);
INSERT INTO public.study_program VALUES (846, 'všeobecné lekárstvo', 'všeobecné lekárstvo', 22);
INSERT INTO public.study_program VALUES (847, 'všeobecné lekárstvo', 'všeobecné lekárstvo', 23);
INSERT INTO public.study_program VALUES (848, 'všeobecný manažment', 'ekonómia a manažment', 36);
INSERT INTO public.study_program VALUES (849, 'zasielateľstvo a logistika', 'doprava', 2);
INSERT INTO public.study_program VALUES (850, 'zdravotnícke a diagnostické pomôcky', 'zdravotnícke vedy', 41);
INSERT INTO public.study_program VALUES (851, 'zoológia', 'biológia', 5);
INSERT INTO public.study_program VALUES (852, 'zoológia a fyziológia živočíchov', 'biológia', 20);
INSERT INTO public.study_program VALUES (853, 'zubné lekárstvo', 'zubné lekárstvo', 21);
INSERT INTO public.study_program VALUES (854, 'zubné lekárstvo', 'zubné lekárstvo', 23);
INSERT INTO public.study_program VALUES (855, 'zubné lekárstvo', 'zubné lekárstvo', 22);
INSERT INTO public.study_program VALUES (856, 'záchranné služby', 'bezpečnostné vedy', 11);
INSERT INTO public.study_program VALUES (857, 'záchranárska, požiarna a bezpečnostná technika', 'získavanie a spracovanie zemských zdrojov', 14);
INSERT INTO public.study_program VALUES (858, 'ústavné právo', 'právo', 38);
INSERT INTO public.study_program VALUES (859, 'účtovníctvo', 'ekonómia a manažment', 18);
INSERT INTO public.study_program VALUES (860, 'účtovníctvo a auditorstvo', 'ekonómia a manažment', 18);
INSERT INTO public.study_program VALUES (861, 'časti a mechanizmy strojov', 'strojárstvo', 34);
INSERT INTO public.study_program VALUES (862, 'časti a mechanizmy strojov', 'strojárstvo', 7);
INSERT INTO public.study_program VALUES (863, 'španielsky jazyk a kultúra (v kombinácii)', 'filológia', 24);
INSERT INTO public.study_program VALUES (864, 'špeciálna pedagogika', 'učiteľstvo a pedagogické vedy', 35);
INSERT INTO public.study_program VALUES (865, 'športový manažment', 'vedy o športe', 47);
INSERT INTO public.study_program VALUES (866, 'ťažba nerastov a inžinierske geotechnológie', 'získavanie a spracovanie zemských zdrojov', 14);
INSERT INTO public.study_program VALUES (867, 'železničná doprava', 'doprava', 2);
INSERT INTO public.study_program VALUES (868, 'žurnalistika', 'mediálne a komunikačné štúdiá', 24);
INSERT INTO public.study_program VALUES (869, '​učiteľstvo pre základné školy - primárne vzdelávanie', 'učiteľstvo a pedagogické vedy', 35);


--
-- Data for Name: study_program_study_program_variant; Type: TABLE DATA; Schema: public; Owner: user
--

INSERT INTO public.study_program_study_program_variant VALUES (1, 1);
INSERT INTO public.study_program_study_program_variant VALUES (2, 2);
INSERT INTO public.study_program_study_program_variant VALUES (2, 3);
INSERT INTO public.study_program_study_program_variant VALUES (3, 1);
INSERT INTO public.study_program_study_program_variant VALUES (3, 4);
INSERT INTO public.study_program_study_program_variant VALUES (4, 5);
INSERT INTO public.study_program_study_program_variant VALUES (4, 4);
INSERT INTO public.study_program_study_program_variant VALUES (4, 6);
INSERT INTO public.study_program_study_program_variant VALUES (4, 1);
INSERT INTO public.study_program_study_program_variant VALUES (5, 2);
INSERT INTO public.study_program_study_program_variant VALUES (5, 3);
INSERT INTO public.study_program_study_program_variant VALUES (6, 4);
INSERT INTO public.study_program_study_program_variant VALUES (6, 1);
INSERT INTO public.study_program_study_program_variant VALUES (7, 4);
INSERT INTO public.study_program_study_program_variant VALUES (8, 2);
INSERT INTO public.study_program_study_program_variant VALUES (8, 3);
INSERT INTO public.study_program_study_program_variant VALUES (9, 1);
INSERT INTO public.study_program_study_program_variant VALUES (10, 4);
INSERT INTO public.study_program_study_program_variant VALUES (11, 4);
INSERT INTO public.study_program_study_program_variant VALUES (11, 1);
INSERT INTO public.study_program_study_program_variant VALUES (12, 7);
INSERT INTO public.study_program_study_program_variant VALUES (13, 4);
INSERT INTO public.study_program_study_program_variant VALUES (14, 2);
INSERT INTO public.study_program_study_program_variant VALUES (14, 3);
INSERT INTO public.study_program_study_program_variant VALUES (15, 4);
INSERT INTO public.study_program_study_program_variant VALUES (16, 1);
INSERT INTO public.study_program_study_program_variant VALUES (17, 3);
INSERT INTO public.study_program_study_program_variant VALUES (17, 2);
INSERT INTO public.study_program_study_program_variant VALUES (18, 1);
INSERT INTO public.study_program_study_program_variant VALUES (19, 1);
INSERT INTO public.study_program_study_program_variant VALUES (20, 4);
INSERT INTO public.study_program_study_program_variant VALUES (21, 4);
INSERT INTO public.study_program_study_program_variant VALUES (21, 1);
INSERT INTO public.study_program_study_program_variant VALUES (22, 1);
INSERT INTO public.study_program_study_program_variant VALUES (23, 1);
INSERT INTO public.study_program_study_program_variant VALUES (24, 3);
INSERT INTO public.study_program_study_program_variant VALUES (24, 2);
INSERT INTO public.study_program_study_program_variant VALUES (25, 4);
INSERT INTO public.study_program_study_program_variant VALUES (26, 3);
INSERT INTO public.study_program_study_program_variant VALUES (26, 2);
INSERT INTO public.study_program_study_program_variant VALUES (27, 1);
INSERT INTO public.study_program_study_program_variant VALUES (27, 3);
INSERT INTO public.study_program_study_program_variant VALUES (28, 4);
INSERT INTO public.study_program_study_program_variant VALUES (29, 1);
INSERT INTO public.study_program_study_program_variant VALUES (30, 4);
INSERT INTO public.study_program_study_program_variant VALUES (30, 1);
INSERT INTO public.study_program_study_program_variant VALUES (31, 3);
INSERT INTO public.study_program_study_program_variant VALUES (31, 2);
INSERT INTO public.study_program_study_program_variant VALUES (32, 4);
INSERT INTO public.study_program_study_program_variant VALUES (33, 1);
INSERT INTO public.study_program_study_program_variant VALUES (34, 1);
INSERT INTO public.study_program_study_program_variant VALUES (34, 4);
INSERT INTO public.study_program_study_program_variant VALUES (34, 2);
INSERT INTO public.study_program_study_program_variant VALUES (34, 3);
INSERT INTO public.study_program_study_program_variant VALUES (35, 8);
INSERT INTO public.study_program_study_program_variant VALUES (36, 3);
INSERT INTO public.study_program_study_program_variant VALUES (36, 2);
INSERT INTO public.study_program_study_program_variant VALUES (37, 4);
INSERT INTO public.study_program_study_program_variant VALUES (37, 2);
INSERT INTO public.study_program_study_program_variant VALUES (37, 1);
INSERT INTO public.study_program_study_program_variant VALUES (37, 3);
INSERT INTO public.study_program_study_program_variant VALUES (38, 1);
INSERT INTO public.study_program_study_program_variant VALUES (39, 3);
INSERT INTO public.study_program_study_program_variant VALUES (39, 2);
INSERT INTO public.study_program_study_program_variant VALUES (40, 2);
INSERT INTO public.study_program_study_program_variant VALUES (40, 1);
INSERT INTO public.study_program_study_program_variant VALUES (40, 3);
INSERT INTO public.study_program_study_program_variant VALUES (41, 2);
INSERT INTO public.study_program_study_program_variant VALUES (41, 3);
INSERT INTO public.study_program_study_program_variant VALUES (42, 1);
INSERT INTO public.study_program_study_program_variant VALUES (43, 1);
INSERT INTO public.study_program_study_program_variant VALUES (44, 2);
INSERT INTO public.study_program_study_program_variant VALUES (44, 3);
INSERT INTO public.study_program_study_program_variant VALUES (45, 9);
INSERT INTO public.study_program_study_program_variant VALUES (46, 2);
INSERT INTO public.study_program_study_program_variant VALUES (46, 3);
INSERT INTO public.study_program_study_program_variant VALUES (47, 4);
INSERT INTO public.study_program_study_program_variant VALUES (48, 2);
INSERT INTO public.study_program_study_program_variant VALUES (48, 3);
INSERT INTO public.study_program_study_program_variant VALUES (49, 1);
INSERT INTO public.study_program_study_program_variant VALUES (50, 1);
INSERT INTO public.study_program_study_program_variant VALUES (50, 4);
INSERT INTO public.study_program_study_program_variant VALUES (51, 1);
INSERT INTO public.study_program_study_program_variant VALUES (52, 1);
INSERT INTO public.study_program_study_program_variant VALUES (53, 1);
INSERT INTO public.study_program_study_program_variant VALUES (54, 10);
INSERT INTO public.study_program_study_program_variant VALUES (55, 3);
INSERT INTO public.study_program_study_program_variant VALUES (55, 2);
INSERT INTO public.study_program_study_program_variant VALUES (56, 2);
INSERT INTO public.study_program_study_program_variant VALUES (56, 3);
INSERT INTO public.study_program_study_program_variant VALUES (57, 3);
INSERT INTO public.study_program_study_program_variant VALUES (57, 2);
INSERT INTO public.study_program_study_program_variant VALUES (57, 1);
INSERT INTO public.study_program_study_program_variant VALUES (58, 11);
INSERT INTO public.study_program_study_program_variant VALUES (61, 13);
INSERT INTO public.study_program_study_program_variant VALUES (61, 12);
INSERT INTO public.study_program_study_program_variant VALUES (61, 14);
INSERT INTO public.study_program_study_program_variant VALUES (59, 12);
INSERT INTO public.study_program_study_program_variant VALUES (59, 13);
INSERT INTO public.study_program_study_program_variant VALUES (59, 14);
INSERT INTO public.study_program_study_program_variant VALUES (60, 2);
INSERT INTO public.study_program_study_program_variant VALUES (60, 13);
INSERT INTO public.study_program_study_program_variant VALUES (60, 3);
INSERT INTO public.study_program_study_program_variant VALUES (60, 12);
INSERT INTO public.study_program_study_program_variant VALUES (62, 8);
INSERT INTO public.study_program_study_program_variant VALUES (62, 15);
INSERT INTO public.study_program_study_program_variant VALUES (63, 3);
INSERT INTO public.study_program_study_program_variant VALUES (63, 12);
INSERT INTO public.study_program_study_program_variant VALUES (63, 2);
INSERT INTO public.study_program_study_program_variant VALUES (63, 13);
INSERT INTO public.study_program_study_program_variant VALUES (64, 12);
INSERT INTO public.study_program_study_program_variant VALUES (64, 13);
INSERT INTO public.study_program_study_program_variant VALUES (64, 3);
INSERT INTO public.study_program_study_program_variant VALUES (64, 2);
INSERT INTO public.study_program_study_program_variant VALUES (65, 13);
INSERT INTO public.study_program_study_program_variant VALUES (65, 2);
INSERT INTO public.study_program_study_program_variant VALUES (65, 12);
INSERT INTO public.study_program_study_program_variant VALUES (65, 3);
INSERT INTO public.study_program_study_program_variant VALUES (66, 2);
INSERT INTO public.study_program_study_program_variant VALUES (66, 12);
INSERT INTO public.study_program_study_program_variant VALUES (66, 13);
INSERT INTO public.study_program_study_program_variant VALUES (66, 3);
INSERT INTO public.study_program_study_program_variant VALUES (67, 8);
INSERT INTO public.study_program_study_program_variant VALUES (67, 15);
INSERT INTO public.study_program_study_program_variant VALUES (68, 14);
INSERT INTO public.study_program_study_program_variant VALUES (68, 10);
INSERT INTO public.study_program_study_program_variant VALUES (71, 3);
INSERT INTO public.study_program_study_program_variant VALUES (71, 2);
INSERT INTO public.study_program_study_program_variant VALUES (71, 14);
INSERT INTO public.study_program_study_program_variant VALUES (71, 13);
INSERT INTO public.study_program_study_program_variant VALUES (71, 12);
INSERT INTO public.study_program_study_program_variant VALUES (70, 13);
INSERT INTO public.study_program_study_program_variant VALUES (70, 3);
INSERT INTO public.study_program_study_program_variant VALUES (70, 2);
INSERT INTO public.study_program_study_program_variant VALUES (70, 12);
INSERT INTO public.study_program_study_program_variant VALUES (69, 13);
INSERT INTO public.study_program_study_program_variant VALUES (69, 12);
INSERT INTO public.study_program_study_program_variant VALUES (69, 14);
INSERT INTO public.study_program_study_program_variant VALUES (72, 3);
INSERT INTO public.study_program_study_program_variant VALUES (72, 12);
INSERT INTO public.study_program_study_program_variant VALUES (72, 2);
INSERT INTO public.study_program_study_program_variant VALUES (72, 13);
INSERT INTO public.study_program_study_program_variant VALUES (73, 10);
INSERT INTO public.study_program_study_program_variant VALUES (73, 1);
INSERT INTO public.study_program_study_program_variant VALUES (73, 11);
INSERT INTO public.study_program_study_program_variant VALUES (73, 4);
INSERT INTO public.study_program_study_program_variant VALUES (74, 8);
INSERT INTO public.study_program_study_program_variant VALUES (74, 15);
INSERT INTO public.study_program_study_program_variant VALUES (75, 11);
INSERT INTO public.study_program_study_program_variant VALUES (76, 10);
INSERT INTO public.study_program_study_program_variant VALUES (76, 11);
INSERT INTO public.study_program_study_program_variant VALUES (77, 13);
INSERT INTO public.study_program_study_program_variant VALUES (77, 12);
INSERT INTO public.study_program_study_program_variant VALUES (77, 14);
INSERT INTO public.study_program_study_program_variant VALUES (82, 10);
INSERT INTO public.study_program_study_program_variant VALUES (78, 10);
INSERT INTO public.study_program_study_program_variant VALUES (78, 14);
INSERT INTO public.study_program_study_program_variant VALUES (80, 8);
INSERT INTO public.study_program_study_program_variant VALUES (80, 7);
INSERT INTO public.study_program_study_program_variant VALUES (80, 15);
INSERT INTO public.study_program_study_program_variant VALUES (81, 17);
INSERT INTO public.study_program_study_program_variant VALUES (81, 16);
INSERT INTO public.study_program_study_program_variant VALUES (81, 11);
INSERT INTO public.study_program_study_program_variant VALUES (79, 16);
INSERT INTO public.study_program_study_program_variant VALUES (79, 3);
INSERT INTO public.study_program_study_program_variant VALUES (79, 17);
INSERT INTO public.study_program_study_program_variant VALUES (79, 2);
INSERT INTO public.study_program_study_program_variant VALUES (83, 11);
INSERT INTO public.study_program_study_program_variant VALUES (83, 10);
INSERT INTO public.study_program_study_program_variant VALUES (83, 16);
INSERT INTO public.study_program_study_program_variant VALUES (83, 17);
INSERT INTO public.study_program_study_program_variant VALUES (83, 2);
INSERT INTO public.study_program_study_program_variant VALUES (83, 3);
INSERT INTO public.study_program_study_program_variant VALUES (84, 11);
INSERT INTO public.study_program_study_program_variant VALUES (85, 8);
INSERT INTO public.study_program_study_program_variant VALUES (86, 17);
INSERT INTO public.study_program_study_program_variant VALUES (86, 16);
INSERT INTO public.study_program_study_program_variant VALUES (88, 3);
INSERT INTO public.study_program_study_program_variant VALUES (88, 17);
INSERT INTO public.study_program_study_program_variant VALUES (88, 2);
INSERT INTO public.study_program_study_program_variant VALUES (88, 16);
INSERT INTO public.study_program_study_program_variant VALUES (87, 3);
INSERT INTO public.study_program_study_program_variant VALUES (87, 16);
INSERT INTO public.study_program_study_program_variant VALUES (87, 2);
INSERT INTO public.study_program_study_program_variant VALUES (87, 17);
INSERT INTO public.study_program_study_program_variant VALUES (90, 13);
INSERT INTO public.study_program_study_program_variant VALUES (90, 12);
INSERT INTO public.study_program_study_program_variant VALUES (89, 12);
INSERT INTO public.study_program_study_program_variant VALUES (89, 3);
INSERT INTO public.study_program_study_program_variant VALUES (89, 13);
INSERT INTO public.study_program_study_program_variant VALUES (89, 2);
INSERT INTO public.study_program_study_program_variant VALUES (91, 3);
INSERT INTO public.study_program_study_program_variant VALUES (91, 2);
INSERT INTO public.study_program_study_program_variant VALUES (92, 11);
INSERT INTO public.study_program_study_program_variant VALUES (92, 4);
INSERT INTO public.study_program_study_program_variant VALUES (92, 1);
INSERT INTO public.study_program_study_program_variant VALUES (92, 10);
INSERT INTO public.study_program_study_program_variant VALUES (93, 11);
INSERT INTO public.study_program_study_program_variant VALUES (94, 18);
INSERT INTO public.study_program_study_program_variant VALUES (94, 19);
INSERT INTO public.study_program_study_program_variant VALUES (95, 20);
INSERT INTO public.study_program_study_program_variant VALUES (96, 20);
INSERT INTO public.study_program_study_program_variant VALUES (97, 21);
INSERT INTO public.study_program_study_program_variant VALUES (97, 22);
INSERT INTO public.study_program_study_program_variant VALUES (98, 15);
INSERT INTO public.study_program_study_program_variant VALUES (98, 8);
INSERT INTO public.study_program_study_program_variant VALUES (99, 11);
INSERT INTO public.study_program_study_program_variant VALUES (100, 2);
INSERT INTO public.study_program_study_program_variant VALUES (100, 13);
INSERT INTO public.study_program_study_program_variant VALUES (100, 12);
INSERT INTO public.study_program_study_program_variant VALUES (100, 23);
INSERT INTO public.study_program_study_program_variant VALUES (100, 24);
INSERT INTO public.study_program_study_program_variant VALUES (100, 3);
INSERT INTO public.study_program_study_program_variant VALUES (102, 4);
INSERT INTO public.study_program_study_program_variant VALUES (102, 10);
INSERT INTO public.study_program_study_program_variant VALUES (101, 10);
INSERT INTO public.study_program_study_program_variant VALUES (101, 24);
INSERT INTO public.study_program_study_program_variant VALUES (103, 10);
INSERT INTO public.study_program_study_program_variant VALUES (103, 14);
INSERT INTO public.study_program_study_program_variant VALUES (104, 17);
INSERT INTO public.study_program_study_program_variant VALUES (104, 16);
INSERT INTO public.study_program_study_program_variant VALUES (104, 15);
INSERT INTO public.study_program_study_program_variant VALUES (104, 3);
INSERT INTO public.study_program_study_program_variant VALUES (105, 17);
INSERT INTO public.study_program_study_program_variant VALUES (105, 16);
INSERT INTO public.study_program_study_program_variant VALUES (105, 20);
INSERT INTO public.study_program_study_program_variant VALUES (106, 10);
INSERT INTO public.study_program_study_program_variant VALUES (107, 10);
INSERT INTO public.study_program_study_program_variant VALUES (108, 17);
INSERT INTO public.study_program_study_program_variant VALUES (108, 3);
INSERT INTO public.study_program_study_program_variant VALUES (108, 2);
INSERT INTO public.study_program_study_program_variant VALUES (108, 16);
INSERT INTO public.study_program_study_program_variant VALUES (109, 20);
INSERT INTO public.study_program_study_program_variant VALUES (110, 11);
INSERT INTO public.study_program_study_program_variant VALUES (110, 13);
INSERT INTO public.study_program_study_program_variant VALUES (110, 12);
INSERT INTO public.study_program_study_program_variant VALUES (110, 10);
INSERT INTO public.study_program_study_program_variant VALUES (111, 20);
INSERT INTO public.study_program_study_program_variant VALUES (111, 1);
INSERT INTO public.study_program_study_program_variant VALUES (112, 10);
INSERT INTO public.study_program_study_program_variant VALUES (112, 25);
INSERT INTO public.study_program_study_program_variant VALUES (112, 6);
INSERT INTO public.study_program_study_program_variant VALUES (112, 4);
INSERT INTO public.study_program_study_program_variant VALUES (113, 10);
INSERT INTO public.study_program_study_program_variant VALUES (113, 11);
INSERT INTO public.study_program_study_program_variant VALUES (114, 10);
INSERT INTO public.study_program_study_program_variant VALUES (115, 4);
INSERT INTO public.study_program_study_program_variant VALUES (115, 1);
INSERT INTO public.study_program_study_program_variant VALUES (115, 11);
INSERT INTO public.study_program_study_program_variant VALUES (115, 10);
INSERT INTO public.study_program_study_program_variant VALUES (116, 10);
INSERT INTO public.study_program_study_program_variant VALUES (116, 11);
INSERT INTO public.study_program_study_program_variant VALUES (117, 3);
INSERT INTO public.study_program_study_program_variant VALUES (117, 2);
INSERT INTO public.study_program_study_program_variant VALUES (117, 13);
INSERT INTO public.study_program_study_program_variant VALUES (117, 12);
INSERT INTO public.study_program_study_program_variant VALUES (118, 2);
INSERT INTO public.study_program_study_program_variant VALUES (118, 3);
INSERT INTO public.study_program_study_program_variant VALUES (118, 12);
INSERT INTO public.study_program_study_program_variant VALUES (118, 13);
INSERT INTO public.study_program_study_program_variant VALUES (119, 25);
INSERT INTO public.study_program_study_program_variant VALUES (120, 13);
INSERT INTO public.study_program_study_program_variant VALUES (120, 25);
INSERT INTO public.study_program_study_program_variant VALUES (120, 26);
INSERT INTO public.study_program_study_program_variant VALUES (120, 12);
INSERT INTO public.study_program_study_program_variant VALUES (120, 2);
INSERT INTO public.study_program_study_program_variant VALUES (120, 11);
INSERT INTO public.study_program_study_program_variant VALUES (120, 10);
INSERT INTO public.study_program_study_program_variant VALUES (120, 3);
INSERT INTO public.study_program_study_program_variant VALUES (121, 11);
INSERT INTO public.study_program_study_program_variant VALUES (123, 13);
INSERT INTO public.study_program_study_program_variant VALUES (123, 12);
INSERT INTO public.study_program_study_program_variant VALUES (123, 10);
INSERT INTO public.study_program_study_program_variant VALUES (123, 14);
INSERT INTO public.study_program_study_program_variant VALUES (124, 13);
INSERT INTO public.study_program_study_program_variant VALUES (124, 3);
INSERT INTO public.study_program_study_program_variant VALUES (124, 2);
INSERT INTO public.study_program_study_program_variant VALUES (124, 12);
INSERT INTO public.study_program_study_program_variant VALUES (122, 3);
INSERT INTO public.study_program_study_program_variant VALUES (122, 12);
INSERT INTO public.study_program_study_program_variant VALUES (122, 14);
INSERT INTO public.study_program_study_program_variant VALUES (122, 13);
INSERT INTO public.study_program_study_program_variant VALUES (122, 2);
INSERT INTO public.study_program_study_program_variant VALUES (125, 10);
INSERT INTO public.study_program_study_program_variant VALUES (126, 8);
INSERT INTO public.study_program_study_program_variant VALUES (126, 10);
INSERT INTO public.study_program_study_program_variant VALUES (126, 4);
INSERT INTO public.study_program_study_program_variant VALUES (127, 4);
INSERT INTO public.study_program_study_program_variant VALUES (127, 10);
INSERT INTO public.study_program_study_program_variant VALUES (128, 11);
INSERT INTO public.study_program_study_program_variant VALUES (128, 1);
INSERT INTO public.study_program_study_program_variant VALUES (130, 16);
INSERT INTO public.study_program_study_program_variant VALUES (130, 17);
INSERT INTO public.study_program_study_program_variant VALUES (129, 14);
INSERT INTO public.study_program_study_program_variant VALUES (129, 10);
INSERT INTO public.study_program_study_program_variant VALUES (129, 12);
INSERT INTO public.study_program_study_program_variant VALUES (129, 3);
INSERT INTO public.study_program_study_program_variant VALUES (129, 2);
INSERT INTO public.study_program_study_program_variant VALUES (129, 13);
INSERT INTO public.study_program_study_program_variant VALUES (131, 8);
INSERT INTO public.study_program_study_program_variant VALUES (132, 8);
INSERT INTO public.study_program_study_program_variant VALUES (133, 10);
INSERT INTO public.study_program_study_program_variant VALUES (134, 14);
INSERT INTO public.study_program_study_program_variant VALUES (134, 16);
INSERT INTO public.study_program_study_program_variant VALUES (134, 10);
INSERT INTO public.study_program_study_program_variant VALUES (134, 17);
INSERT INTO public.study_program_study_program_variant VALUES (135, 10);
INSERT INTO public.study_program_study_program_variant VALUES (136, 10);
INSERT INTO public.study_program_study_program_variant VALUES (137, 10);
INSERT INTO public.study_program_study_program_variant VALUES (138, 10);
INSERT INTO public.study_program_study_program_variant VALUES (139, 8);
INSERT INTO public.study_program_study_program_variant VALUES (139, 15);
INSERT INTO public.study_program_study_program_variant VALUES (139, 7);
INSERT INTO public.study_program_study_program_variant VALUES (140, 20);
INSERT INTO public.study_program_study_program_variant VALUES (141, 20);
INSERT INTO public.study_program_study_program_variant VALUES (142, 13);
INSERT INTO public.study_program_study_program_variant VALUES (142, 11);
INSERT INTO public.study_program_study_program_variant VALUES (142, 10);
INSERT INTO public.study_program_study_program_variant VALUES (142, 12);
INSERT INTO public.study_program_study_program_variant VALUES (143, 11);
INSERT INTO public.study_program_study_program_variant VALUES (143, 12);
INSERT INTO public.study_program_study_program_variant VALUES (143, 13);
INSERT INTO public.study_program_study_program_variant VALUES (144, 3);
INSERT INTO public.study_program_study_program_variant VALUES (144, 2);
INSERT INTO public.study_program_study_program_variant VALUES (145, 11);
INSERT INTO public.study_program_study_program_variant VALUES (145, 8);
INSERT INTO public.study_program_study_program_variant VALUES (145, 10);
INSERT INTO public.study_program_study_program_variant VALUES (145, 12);
INSERT INTO public.study_program_study_program_variant VALUES (145, 13);
INSERT INTO public.study_program_study_program_variant VALUES (145, 4);
INSERT INTO public.study_program_study_program_variant VALUES (145, 2);
INSERT INTO public.study_program_study_program_variant VALUES (145, 3);
INSERT INTO public.study_program_study_program_variant VALUES (145, 1);
INSERT INTO public.study_program_study_program_variant VALUES (146, 4);
INSERT INTO public.study_program_study_program_variant VALUES (146, 10);
INSERT INTO public.study_program_study_program_variant VALUES (147, 14);
INSERT INTO public.study_program_study_program_variant VALUES (147, 12);
INSERT INTO public.study_program_study_program_variant VALUES (147, 13);
INSERT INTO public.study_program_study_program_variant VALUES (148, 27);
INSERT INTO public.study_program_study_program_variant VALUES (148, 3);
INSERT INTO public.study_program_study_program_variant VALUES (149, 28);
INSERT INTO public.study_program_study_program_variant VALUES (149, 8);
INSERT INTO public.study_program_study_program_variant VALUES (150, 10);
INSERT INTO public.study_program_study_program_variant VALUES (151, 14);
INSERT INTO public.study_program_study_program_variant VALUES (151, 12);
INSERT INTO public.study_program_study_program_variant VALUES (151, 13);
INSERT INTO public.study_program_study_program_variant VALUES (152, 14);
INSERT INTO public.study_program_study_program_variant VALUES (152, 7);
INSERT INTO public.study_program_study_program_variant VALUES (153, 3);
INSERT INTO public.study_program_study_program_variant VALUES (153, 6);
INSERT INTO public.study_program_study_program_variant VALUES (153, 7);
INSERT INTO public.study_program_study_program_variant VALUES (153, 29);
INSERT INTO public.study_program_study_program_variant VALUES (153, 4);
INSERT INTO public.study_program_study_program_variant VALUES (153, 2);
INSERT INTO public.study_program_study_program_variant VALUES (154, 10);
INSERT INTO public.study_program_study_program_variant VALUES (155, 10);
INSERT INTO public.study_program_study_program_variant VALUES (156, 10);
INSERT INTO public.study_program_study_program_variant VALUES (157, 10);
INSERT INTO public.study_program_study_program_variant VALUES (158, 10);
INSERT INTO public.study_program_study_program_variant VALUES (159, 4);
INSERT INTO public.study_program_study_program_variant VALUES (160, 10);
INSERT INTO public.study_program_study_program_variant VALUES (161, 17);
INSERT INTO public.study_program_study_program_variant VALUES (161, 16);
INSERT INTO public.study_program_study_program_variant VALUES (162, 30);
INSERT INTO public.study_program_study_program_variant VALUES (162, 31);
INSERT INTO public.study_program_study_program_variant VALUES (163, 20);
INSERT INTO public.study_program_study_program_variant VALUES (163, 8);
INSERT INTO public.study_program_study_program_variant VALUES (164, 11);
INSERT INTO public.study_program_study_program_variant VALUES (165, 1);
INSERT INTO public.study_program_study_program_variant VALUES (165, 16);
INSERT INTO public.study_program_study_program_variant VALUES (165, 8);
INSERT INTO public.study_program_study_program_variant VALUES (165, 20);
INSERT INTO public.study_program_study_program_variant VALUES (165, 2);
INSERT INTO public.study_program_study_program_variant VALUES (165, 4);
INSERT INTO public.study_program_study_program_variant VALUES (165, 3);
INSERT INTO public.study_program_study_program_variant VALUES (165, 17);
INSERT INTO public.study_program_study_program_variant VALUES (166, 8);
INSERT INTO public.study_program_study_program_variant VALUES (166, 4);
INSERT INTO public.study_program_study_program_variant VALUES (167, 11);
INSERT INTO public.study_program_study_program_variant VALUES (167, 10);
INSERT INTO public.study_program_study_program_variant VALUES (168, 1);
INSERT INTO public.study_program_study_program_variant VALUES (168, 20);
INSERT INTO public.study_program_study_program_variant VALUES (169, 10);
INSERT INTO public.study_program_study_program_variant VALUES (170, 17);
INSERT INTO public.study_program_study_program_variant VALUES (170, 16);
INSERT INTO public.study_program_study_program_variant VALUES (172, 12);
INSERT INTO public.study_program_study_program_variant VALUES (172, 3);
INSERT INTO public.study_program_study_program_variant VALUES (172, 2);
INSERT INTO public.study_program_study_program_variant VALUES (172, 13);
INSERT INTO public.study_program_study_program_variant VALUES (171, 12);
INSERT INTO public.study_program_study_program_variant VALUES (171, 13);
INSERT INTO public.study_program_study_program_variant VALUES (171, 2);
INSERT INTO public.study_program_study_program_variant VALUES (171, 3);
INSERT INTO public.study_program_study_program_variant VALUES (173, 10);
INSERT INTO public.study_program_study_program_variant VALUES (174, 10);
INSERT INTO public.study_program_study_program_variant VALUES (175, 10);
INSERT INTO public.study_program_study_program_variant VALUES (176, 10);
INSERT INTO public.study_program_study_program_variant VALUES (177, 10);
INSERT INTO public.study_program_study_program_variant VALUES (178, 27);
INSERT INTO public.study_program_study_program_variant VALUES (178, 3);
INSERT INTO public.study_program_study_program_variant VALUES (179, 3);
INSERT INTO public.study_program_study_program_variant VALUES (179, 2);
INSERT INTO public.study_program_study_program_variant VALUES (179, 12);
INSERT INTO public.study_program_study_program_variant VALUES (179, 13);
INSERT INTO public.study_program_study_program_variant VALUES (180, 13);
INSERT INTO public.study_program_study_program_variant VALUES (180, 12);
INSERT INTO public.study_program_study_program_variant VALUES (180, 2);
INSERT INTO public.study_program_study_program_variant VALUES (180, 3);
INSERT INTO public.study_program_study_program_variant VALUES (181, 8);
INSERT INTO public.study_program_study_program_variant VALUES (181, 10);
INSERT INTO public.study_program_study_program_variant VALUES (181, 4);
INSERT INTO public.study_program_study_program_variant VALUES (182, 10);
INSERT INTO public.study_program_study_program_variant VALUES (182, 4);
INSERT INTO public.study_program_study_program_variant VALUES (183, 8);
INSERT INTO public.study_program_study_program_variant VALUES (183, 20);
INSERT INTO public.study_program_study_program_variant VALUES (183, 1);
INSERT INTO public.study_program_study_program_variant VALUES (183, 4);
INSERT INTO public.study_program_study_program_variant VALUES (184, 32);
INSERT INTO public.study_program_study_program_variant VALUES (184, 33);
INSERT INTO public.study_program_study_program_variant VALUES (184, 34);
INSERT INTO public.study_program_study_program_variant VALUES (184, 35);
INSERT INTO public.study_program_study_program_variant VALUES (184, 36);
INSERT INTO public.study_program_study_program_variant VALUES (184, 37);
INSERT INTO public.study_program_study_program_variant VALUES (185, 12);
INSERT INTO public.study_program_study_program_variant VALUES (185, 13);
INSERT INTO public.study_program_study_program_variant VALUES (185, 11);
INSERT INTO public.study_program_study_program_variant VALUES (185, 10);
INSERT INTO public.study_program_study_program_variant VALUES (186, 13);
INSERT INTO public.study_program_study_program_variant VALUES (186, 12);
INSERT INTO public.study_program_study_program_variant VALUES (187, 10);
INSERT INTO public.study_program_study_program_variant VALUES (188, 10);
INSERT INTO public.study_program_study_program_variant VALUES (189, 3);
INSERT INTO public.study_program_study_program_variant VALUES (189, 2);
INSERT INTO public.study_program_study_program_variant VALUES (189, 12);
INSERT INTO public.study_program_study_program_variant VALUES (189, 13);
INSERT INTO public.study_program_study_program_variant VALUES (190, 13);
INSERT INTO public.study_program_study_program_variant VALUES (190, 12);
INSERT INTO public.study_program_study_program_variant VALUES (191, 13);
INSERT INTO public.study_program_study_program_variant VALUES (191, 12);
INSERT INTO public.study_program_study_program_variant VALUES (192, 13);
INSERT INTO public.study_program_study_program_variant VALUES (192, 12);
INSERT INTO public.study_program_study_program_variant VALUES (193, 12);
INSERT INTO public.study_program_study_program_variant VALUES (193, 13);
INSERT INTO public.study_program_study_program_variant VALUES (194, 10);
INSERT INTO public.study_program_study_program_variant VALUES (194, 11);
INSERT INTO public.study_program_study_program_variant VALUES (195, 8);
INSERT INTO public.study_program_study_program_variant VALUES (196, 17);
INSERT INTO public.study_program_study_program_variant VALUES (196, 16);
INSERT INTO public.study_program_study_program_variant VALUES (197, 8);
INSERT INTO public.study_program_study_program_variant VALUES (197, 11);
INSERT INTO public.study_program_study_program_variant VALUES (199, 38);
INSERT INTO public.study_program_study_program_variant VALUES (199, 39);
INSERT INTO public.study_program_study_program_variant VALUES (199, 40);
INSERT INTO public.study_program_study_program_variant VALUES (199, 10);
INSERT INTO public.study_program_study_program_variant VALUES (198, 10);
INSERT INTO public.study_program_study_program_variant VALUES (198, 38);
INSERT INTO public.study_program_study_program_variant VALUES (198, 40);
INSERT INTO public.study_program_study_program_variant VALUES (198, 39);
INSERT INTO public.study_program_study_program_variant VALUES (200, 10);
INSERT INTO public.study_program_study_program_variant VALUES (201, 17);
INSERT INTO public.study_program_study_program_variant VALUES (201, 16);
INSERT INTO public.study_program_study_program_variant VALUES (202, 4);
INSERT INTO public.study_program_study_program_variant VALUES (202, 26);
INSERT INTO public.study_program_study_program_variant VALUES (202, 25);
INSERT INTO public.study_program_study_program_variant VALUES (202, 10);
INSERT INTO public.study_program_study_program_variant VALUES (202, 1);
INSERT INTO public.study_program_study_program_variant VALUES (202, 11);
INSERT INTO public.study_program_study_program_variant VALUES (203, 11);
INSERT INTO public.study_program_study_program_variant VALUES (204, 17);
INSERT INTO public.study_program_study_program_variant VALUES (204, 16);
INSERT INTO public.study_program_study_program_variant VALUES (205, 8);
INSERT INTO public.study_program_study_program_variant VALUES (206, 10);
INSERT INTO public.study_program_study_program_variant VALUES (206, 25);
INSERT INTO public.study_program_study_program_variant VALUES (207, 13);
INSERT INTO public.study_program_study_program_variant VALUES (207, 12);
INSERT INTO public.study_program_study_program_variant VALUES (208, 14);
INSERT INTO public.study_program_study_program_variant VALUES (209, 10);
INSERT INTO public.study_program_study_program_variant VALUES (210, 8);
INSERT INTO public.study_program_study_program_variant VALUES (211, 8);
INSERT INTO public.study_program_study_program_variant VALUES (212, 14);
INSERT INTO public.study_program_study_program_variant VALUES (212, 13);
INSERT INTO public.study_program_study_program_variant VALUES (212, 12);
INSERT INTO public.study_program_study_program_variant VALUES (213, 15);
INSERT INTO public.study_program_study_program_variant VALUES (213, 7);
INSERT INTO public.study_program_study_program_variant VALUES (215, 8);
INSERT INTO public.study_program_study_program_variant VALUES (214, 10);
INSERT INTO public.study_program_study_program_variant VALUES (214, 14);
INSERT INTO public.study_program_study_program_variant VALUES (216, 10);
INSERT INTO public.study_program_study_program_variant VALUES (217, 14);
INSERT INTO public.study_program_study_program_variant VALUES (220, 3);
INSERT INTO public.study_program_study_program_variant VALUES (220, 10);
INSERT INTO public.study_program_study_program_variant VALUES (220, 2);
INSERT INTO public.study_program_study_program_variant VALUES (220, 12);
INSERT INTO public.study_program_study_program_variant VALUES (220, 4);
INSERT INTO public.study_program_study_program_variant VALUES (220, 13);
INSERT INTO public.study_program_study_program_variant VALUES (219, 25);
INSERT INTO public.study_program_study_program_variant VALUES (219, 12);
INSERT INTO public.study_program_study_program_variant VALUES (219, 10);
INSERT INTO public.study_program_study_program_variant VALUES (219, 13);
INSERT INTO public.study_program_study_program_variant VALUES (218, 20);
INSERT INTO public.study_program_study_program_variant VALUES (218, 17);
INSERT INTO public.study_program_study_program_variant VALUES (218, 8);
INSERT INTO public.study_program_study_program_variant VALUES (218, 16);
INSERT INTO public.study_program_study_program_variant VALUES (221, 8);
INSERT INTO public.study_program_study_program_variant VALUES (221, 20);
INSERT INTO public.study_program_study_program_variant VALUES (222, 8);
INSERT INTO public.study_program_study_program_variant VALUES (222, 20);
INSERT INTO public.study_program_study_program_variant VALUES (223, 6);
INSERT INTO public.study_program_study_program_variant VALUES (223, 10);
INSERT INTO public.study_program_study_program_variant VALUES (223, 4);
INSERT INTO public.study_program_study_program_variant VALUES (223, 26);
INSERT INTO public.study_program_study_program_variant VALUES (223, 11);
INSERT INTO public.study_program_study_program_variant VALUES (223, 1);
INSERT INTO public.study_program_study_program_variant VALUES (223, 5);
INSERT INTO public.study_program_study_program_variant VALUES (223, 25);
INSERT INTO public.study_program_study_program_variant VALUES (224, 16);
INSERT INTO public.study_program_study_program_variant VALUES (224, 17);
INSERT INTO public.study_program_study_program_variant VALUES (225, 11);
INSERT INTO public.study_program_study_program_variant VALUES (226, 3);
INSERT INTO public.study_program_study_program_variant VALUES (226, 2);
INSERT INTO public.study_program_study_program_variant VALUES (226, 13);
INSERT INTO public.study_program_study_program_variant VALUES (226, 12);
INSERT INTO public.study_program_study_program_variant VALUES (227, 3);
INSERT INTO public.study_program_study_program_variant VALUES (228, 16);
INSERT INTO public.study_program_study_program_variant VALUES (230, 25);
INSERT INTO public.study_program_study_program_variant VALUES (230, 10);
INSERT INTO public.study_program_study_program_variant VALUES (229, 25);
INSERT INTO public.study_program_study_program_variant VALUES (229, 10);
INSERT INTO public.study_program_study_program_variant VALUES (231, 2);
INSERT INTO public.study_program_study_program_variant VALUES (231, 17);
INSERT INTO public.study_program_study_program_variant VALUES (231, 3);
INSERT INTO public.study_program_study_program_variant VALUES (231, 16);
INSERT INTO public.study_program_study_program_variant VALUES (231, 11);
INSERT INTO public.study_program_study_program_variant VALUES (231, 10);
INSERT INTO public.study_program_study_program_variant VALUES (232, 10);
INSERT INTO public.study_program_study_program_variant VALUES (232, 11);
INSERT INTO public.study_program_study_program_variant VALUES (232, 4);
INSERT INTO public.study_program_study_program_variant VALUES (232, 1);
INSERT INTO public.study_program_study_program_variant VALUES (233, 20);
INSERT INTO public.study_program_study_program_variant VALUES (234, 20);
INSERT INTO public.study_program_study_program_variant VALUES (235, 8);
INSERT INTO public.study_program_study_program_variant VALUES (236, 8);
INSERT INTO public.study_program_study_program_variant VALUES (236, 20);
INSERT INTO public.study_program_study_program_variant VALUES (237, 10);
INSERT INTO public.study_program_study_program_variant VALUES (238, 2);
INSERT INTO public.study_program_study_program_variant VALUES (238, 11);
INSERT INTO public.study_program_study_program_variant VALUES (238, 17);
INSERT INTO public.study_program_study_program_variant VALUES (238, 16);
INSERT INTO public.study_program_study_program_variant VALUES (238, 3);
INSERT INTO public.study_program_study_program_variant VALUES (238, 1);
INSERT INTO public.study_program_study_program_variant VALUES (239, 10);
INSERT INTO public.study_program_study_program_variant VALUES (240, 11);
INSERT INTO public.study_program_study_program_variant VALUES (241, 10);
INSERT INTO public.study_program_study_program_variant VALUES (242, 12);
INSERT INTO public.study_program_study_program_variant VALUES (242, 13);
INSERT INTO public.study_program_study_program_variant VALUES (243, 10);
INSERT INTO public.study_program_study_program_variant VALUES (243, 25);
INSERT INTO public.study_program_study_program_variant VALUES (244, 13);
INSERT INTO public.study_program_study_program_variant VALUES (244, 2);
INSERT INTO public.study_program_study_program_variant VALUES (244, 12);
INSERT INTO public.study_program_study_program_variant VALUES (244, 3);
INSERT INTO public.study_program_study_program_variant VALUES (245, 10);
INSERT INTO public.study_program_study_program_variant VALUES (246, 16);
INSERT INTO public.study_program_study_program_variant VALUES (246, 17);
INSERT INTO public.study_program_study_program_variant VALUES (247, 13);
INSERT INTO public.study_program_study_program_variant VALUES (247, 12);
INSERT INTO public.study_program_study_program_variant VALUES (247, 11);
INSERT INTO public.study_program_study_program_variant VALUES (248, 10);
INSERT INTO public.study_program_study_program_variant VALUES (248, 11);
INSERT INTO public.study_program_study_program_variant VALUES (248, 16);
INSERT INTO public.study_program_study_program_variant VALUES (248, 17);
INSERT INTO public.study_program_study_program_variant VALUES (249, 10);
INSERT INTO public.study_program_study_program_variant VALUES (250, 16);
INSERT INTO public.study_program_study_program_variant VALUES (250, 3);
INSERT INTO public.study_program_study_program_variant VALUES (250, 17);
INSERT INTO public.study_program_study_program_variant VALUES (250, 2);
INSERT INTO public.study_program_study_program_variant VALUES (251, 7);
INSERT INTO public.study_program_study_program_variant VALUES (251, 15);
INSERT INTO public.study_program_study_program_variant VALUES (252, 14);
INSERT INTO public.study_program_study_program_variant VALUES (252, 12);
INSERT INTO public.study_program_study_program_variant VALUES (252, 13);
INSERT INTO public.study_program_study_program_variant VALUES (253, 11);
INSERT INTO public.study_program_study_program_variant VALUES (253, 10);
INSERT INTO public.study_program_study_program_variant VALUES (253, 1);
INSERT INTO public.study_program_study_program_variant VALUES (254, 16);
INSERT INTO public.study_program_study_program_variant VALUES (254, 17);
INSERT INTO public.study_program_study_program_variant VALUES (255, 10);
INSERT INTO public.study_program_study_program_variant VALUES (255, 14);
INSERT INTO public.study_program_study_program_variant VALUES (256, 8);
INSERT INTO public.study_program_study_program_variant VALUES (257, 10);
INSERT INTO public.study_program_study_program_variant VALUES (258, 10);
INSERT INTO public.study_program_study_program_variant VALUES (259, 10);
INSERT INTO public.study_program_study_program_variant VALUES (260, 10);
INSERT INTO public.study_program_study_program_variant VALUES (261, 15);
INSERT INTO public.study_program_study_program_variant VALUES (262, 10);
INSERT INTO public.study_program_study_program_variant VALUES (262, 14);
INSERT INTO public.study_program_study_program_variant VALUES (262, 41);
INSERT INTO public.study_program_study_program_variant VALUES (263, 12);
INSERT INTO public.study_program_study_program_variant VALUES (263, 13);
INSERT INTO public.study_program_study_program_variant VALUES (264, 7);
INSERT INTO public.study_program_study_program_variant VALUES (264, 15);
INSERT INTO public.study_program_study_program_variant VALUES (264, 8);
INSERT INTO public.study_program_study_program_variant VALUES (265, 2);
INSERT INTO public.study_program_study_program_variant VALUES (265, 3);
INSERT INTO public.study_program_study_program_variant VALUES (265, 16);
INSERT INTO public.study_program_study_program_variant VALUES (265, 17);
INSERT INTO public.study_program_study_program_variant VALUES (266, 7);
INSERT INTO public.study_program_study_program_variant VALUES (266, 12);
INSERT INTO public.study_program_study_program_variant VALUES (266, 13);
INSERT INTO public.study_program_study_program_variant VALUES (266, 3);
INSERT INTO public.study_program_study_program_variant VALUES (266, 2);
INSERT INTO public.study_program_study_program_variant VALUES (266, 14);
INSERT INTO public.study_program_study_program_variant VALUES (267, 14);
INSERT INTO public.study_program_study_program_variant VALUES (267, 42);
INSERT INTO public.study_program_study_program_variant VALUES (268, 25);
INSERT INTO public.study_program_study_program_variant VALUES (268, 10);
INSERT INTO public.study_program_study_program_variant VALUES (269, 3);
INSERT INTO public.study_program_study_program_variant VALUES (269, 13);
INSERT INTO public.study_program_study_program_variant VALUES (269, 12);
INSERT INTO public.study_program_study_program_variant VALUES (269, 2);
INSERT INTO public.study_program_study_program_variant VALUES (270, 12);
INSERT INTO public.study_program_study_program_variant VALUES (270, 3);
INSERT INTO public.study_program_study_program_variant VALUES (270, 13);
INSERT INTO public.study_program_study_program_variant VALUES (270, 2);
INSERT INTO public.study_program_study_program_variant VALUES (271, 2);
INSERT INTO public.study_program_study_program_variant VALUES (271, 12);
INSERT INTO public.study_program_study_program_variant VALUES (271, 3);
INSERT INTO public.study_program_study_program_variant VALUES (271, 13);
INSERT INTO public.study_program_study_program_variant VALUES (273, 3);
INSERT INTO public.study_program_study_program_variant VALUES (273, 13);
INSERT INTO public.study_program_study_program_variant VALUES (273, 2);
INSERT INTO public.study_program_study_program_variant VALUES (273, 12);
INSERT INTO public.study_program_study_program_variant VALUES (272, 13);
INSERT INTO public.study_program_study_program_variant VALUES (272, 2);
INSERT INTO public.study_program_study_program_variant VALUES (272, 12);
INSERT INTO public.study_program_study_program_variant VALUES (272, 3);
INSERT INTO public.study_program_study_program_variant VALUES (274, 14);
INSERT INTO public.study_program_study_program_variant VALUES (274, 7);
INSERT INTO public.study_program_study_program_variant VALUES (275, 14);
INSERT INTO public.study_program_study_program_variant VALUES (276, 16);
INSERT INTO public.study_program_study_program_variant VALUES (276, 10);
INSERT INTO public.study_program_study_program_variant VALUES (276, 17);
INSERT INTO public.study_program_study_program_variant VALUES (276, 14);
INSERT INTO public.study_program_study_program_variant VALUES (277, 10);
INSERT INTO public.study_program_study_program_variant VALUES (277, 14);
INSERT INTO public.study_program_study_program_variant VALUES (278, 10);
INSERT INTO public.study_program_study_program_variant VALUES (279, 10);
INSERT INTO public.study_program_study_program_variant VALUES (280, 10);
INSERT INTO public.study_program_study_program_variant VALUES (281, 10);
INSERT INTO public.study_program_study_program_variant VALUES (282, 12);
INSERT INTO public.study_program_study_program_variant VALUES (282, 13);
INSERT INTO public.study_program_study_program_variant VALUES (283, 3);
INSERT INTO public.study_program_study_program_variant VALUES (283, 2);
INSERT INTO public.study_program_study_program_variant VALUES (283, 13);
INSERT INTO public.study_program_study_program_variant VALUES (283, 12);
INSERT INTO public.study_program_study_program_variant VALUES (284, 11);
INSERT INTO public.study_program_study_program_variant VALUES (284, 1);
INSERT INTO public.study_program_study_program_variant VALUES (284, 26);
INSERT INTO public.study_program_study_program_variant VALUES (286, 25);
INSERT INTO public.study_program_study_program_variant VALUES (286, 10);
INSERT INTO public.study_program_study_program_variant VALUES (285, 1);
INSERT INTO public.study_program_study_program_variant VALUES (285, 26);
INSERT INTO public.study_program_study_program_variant VALUES (285, 6);
INSERT INTO public.study_program_study_program_variant VALUES (285, 5);
INSERT INTO public.study_program_study_program_variant VALUES (285, 4);
INSERT INTO public.study_program_study_program_variant VALUES (285, 10);
INSERT INTO public.study_program_study_program_variant VALUES (285, 11);
INSERT INTO public.study_program_study_program_variant VALUES (285, 25);
INSERT INTO public.study_program_study_program_variant VALUES (287, 4);
INSERT INTO public.study_program_study_program_variant VALUES (287, 25);
INSERT INTO public.study_program_study_program_variant VALUES (287, 10);
INSERT INTO public.study_program_study_program_variant VALUES (288, 26);
INSERT INTO public.study_program_study_program_variant VALUES (288, 11);
INSERT INTO public.study_program_study_program_variant VALUES (289, 11);
INSERT INTO public.study_program_study_program_variant VALUES (290, 20);
INSERT INTO public.study_program_study_program_variant VALUES (290, 8);
INSERT INTO public.study_program_study_program_variant VALUES (291, 8);
INSERT INTO public.study_program_study_program_variant VALUES (292, 8);
INSERT INTO public.study_program_study_program_variant VALUES (293, 11);
INSERT INTO public.study_program_study_program_variant VALUES (294, 43);
INSERT INTO public.study_program_study_program_variant VALUES (294, 44);
INSERT INTO public.study_program_study_program_variant VALUES (295, 14);
INSERT INTO public.study_program_study_program_variant VALUES (296, 13);
INSERT INTO public.study_program_study_program_variant VALUES (296, 12);
INSERT INTO public.study_program_study_program_variant VALUES (297, 8);
INSERT INTO public.study_program_study_program_variant VALUES (298, 10);
INSERT INTO public.study_program_study_program_variant VALUES (298, 3);
INSERT INTO public.study_program_study_program_variant VALUES (298, 14);
INSERT INTO public.study_program_study_program_variant VALUES (298, 12);
INSERT INTO public.study_program_study_program_variant VALUES (298, 13);
INSERT INTO public.study_program_study_program_variant VALUES (299, 8);
INSERT INTO public.study_program_study_program_variant VALUES (300, 10);
INSERT INTO public.study_program_study_program_variant VALUES (301, 10);
INSERT INTO public.study_program_study_program_variant VALUES (302, 10);
INSERT INTO public.study_program_study_program_variant VALUES (303, 10);
INSERT INTO public.study_program_study_program_variant VALUES (304, 13);
INSERT INTO public.study_program_study_program_variant VALUES (304, 12);
INSERT INTO public.study_program_study_program_variant VALUES (304, 2);
INSERT INTO public.study_program_study_program_variant VALUES (304, 14);
INSERT INTO public.study_program_study_program_variant VALUES (304, 7);
INSERT INTO public.study_program_study_program_variant VALUES (304, 3);
INSERT INTO public.study_program_study_program_variant VALUES (305, 3);
INSERT INTO public.study_program_study_program_variant VALUES (305, 16);
INSERT INTO public.study_program_study_program_variant VALUES (306, 13);
INSERT INTO public.study_program_study_program_variant VALUES (306, 12);
INSERT INTO public.study_program_study_program_variant VALUES (306, 7);
INSERT INTO public.study_program_study_program_variant VALUES (306, 3);
INSERT INTO public.study_program_study_program_variant VALUES (306, 2);
INSERT INTO public.study_program_study_program_variant VALUES (306, 15);
INSERT INTO public.study_program_study_program_variant VALUES (307, 15);
INSERT INTO public.study_program_study_program_variant VALUES (307, 7);
INSERT INTO public.study_program_study_program_variant VALUES (310, 13);
INSERT INTO public.study_program_study_program_variant VALUES (310, 12);
INSERT INTO public.study_program_study_program_variant VALUES (310, 14);
INSERT INTO public.study_program_study_program_variant VALUES (308, 14);
INSERT INTO public.study_program_study_program_variant VALUES (308, 13);
INSERT INTO public.study_program_study_program_variant VALUES (308, 12);
INSERT INTO public.study_program_study_program_variant VALUES (309, 13);
INSERT INTO public.study_program_study_program_variant VALUES (309, 12);
INSERT INTO public.study_program_study_program_variant VALUES (309, 2);
INSERT INTO public.study_program_study_program_variant VALUES (309, 3);
INSERT INTO public.study_program_study_program_variant VALUES (311, 17);
INSERT INTO public.study_program_study_program_variant VALUES (311, 2);
INSERT INTO public.study_program_study_program_variant VALUES (311, 16);
INSERT INTO public.study_program_study_program_variant VALUES (311, 3);
INSERT INTO public.study_program_study_program_variant VALUES (312, 2);
INSERT INTO public.study_program_study_program_variant VALUES (312, 3);
INSERT INTO public.study_program_study_program_variant VALUES (312, 12);
INSERT INTO public.study_program_study_program_variant VALUES (312, 13);
INSERT INTO public.study_program_study_program_variant VALUES (312, 11);
INSERT INTO public.study_program_study_program_variant VALUES (312, 10);
INSERT INTO public.study_program_study_program_variant VALUES (313, 13);
INSERT INTO public.study_program_study_program_variant VALUES (314, 14);
INSERT INTO public.study_program_study_program_variant VALUES (314, 13);
INSERT INTO public.study_program_study_program_variant VALUES (314, 12);
INSERT INTO public.study_program_study_program_variant VALUES (315, 13);
INSERT INTO public.study_program_study_program_variant VALUES (315, 12);
INSERT INTO public.study_program_study_program_variant VALUES (316, 14);
INSERT INTO public.study_program_study_program_variant VALUES (317, 10);
INSERT INTO public.study_program_study_program_variant VALUES (317, 14);
INSERT INTO public.study_program_study_program_variant VALUES (318, 13);
INSERT INTO public.study_program_study_program_variant VALUES (318, 14);
INSERT INTO public.study_program_study_program_variant VALUES (318, 12);
INSERT INTO public.study_program_study_program_variant VALUES (319, 7);
INSERT INTO public.study_program_study_program_variant VALUES (319, 14);
INSERT INTO public.study_program_study_program_variant VALUES (321, 25);
INSERT INTO public.study_program_study_program_variant VALUES (321, 10);
INSERT INTO public.study_program_study_program_variant VALUES (320, 17);
INSERT INTO public.study_program_study_program_variant VALUES (320, 3);
INSERT INTO public.study_program_study_program_variant VALUES (320, 11);
INSERT INTO public.study_program_study_program_variant VALUES (320, 10);
INSERT INTO public.study_program_study_program_variant VALUES (320, 16);
INSERT INTO public.study_program_study_program_variant VALUES (320, 2);
INSERT INTO public.study_program_study_program_variant VALUES (322, 10);
INSERT INTO public.study_program_study_program_variant VALUES (323, 10);
INSERT INTO public.study_program_study_program_variant VALUES (324, 10);
INSERT INTO public.study_program_study_program_variant VALUES (325, 10);
INSERT INTO public.study_program_study_program_variant VALUES (326, 14);
INSERT INTO public.study_program_study_program_variant VALUES (326, 10);
INSERT INTO public.study_program_study_program_variant VALUES (327, 10);
INSERT INTO public.study_program_study_program_variant VALUES (328, 10);
INSERT INTO public.study_program_study_program_variant VALUES (329, 2);
INSERT INTO public.study_program_study_program_variant VALUES (329, 3);
INSERT INTO public.study_program_study_program_variant VALUES (329, 12);
INSERT INTO public.study_program_study_program_variant VALUES (329, 13);
INSERT INTO public.study_program_study_program_variant VALUES (330, 11);
INSERT INTO public.study_program_study_program_variant VALUES (331, 10);
INSERT INTO public.study_program_study_program_variant VALUES (332, 10);
INSERT INTO public.study_program_study_program_variant VALUES (333, 2);
INSERT INTO public.study_program_study_program_variant VALUES (333, 17);
INSERT INTO public.study_program_study_program_variant VALUES (333, 16);
INSERT INTO public.study_program_study_program_variant VALUES (333, 3);
INSERT INTO public.study_program_study_program_variant VALUES (334, 26);
INSERT INTO public.study_program_study_program_variant VALUES (334, 25);
INSERT INTO public.study_program_study_program_variant VALUES (334, 10);
INSERT INTO public.study_program_study_program_variant VALUES (334, 11);
INSERT INTO public.study_program_study_program_variant VALUES (335, 45);
INSERT INTO public.study_program_study_program_variant VALUES (335, 46);
INSERT INTO public.study_program_study_program_variant VALUES (336, 10);
INSERT INTO public.study_program_study_program_variant VALUES (336, 14);
INSERT INTO public.study_program_study_program_variant VALUES (339, 2);
INSERT INTO public.study_program_study_program_variant VALUES (339, 3);
INSERT INTO public.study_program_study_program_variant VALUES (339, 12);
INSERT INTO public.study_program_study_program_variant VALUES (339, 13);
INSERT INTO public.study_program_study_program_variant VALUES (337, 3);
INSERT INTO public.study_program_study_program_variant VALUES (337, 2);
INSERT INTO public.study_program_study_program_variant VALUES (337, 13);
INSERT INTO public.study_program_study_program_variant VALUES (337, 12);
INSERT INTO public.study_program_study_program_variant VALUES (338, 13);
INSERT INTO public.study_program_study_program_variant VALUES (338, 12);
INSERT INTO public.study_program_study_program_variant VALUES (338, 3);
INSERT INTO public.study_program_study_program_variant VALUES (338, 2);
INSERT INTO public.study_program_study_program_variant VALUES (340, 10);
INSERT INTO public.study_program_study_program_variant VALUES (340, 14);
INSERT INTO public.study_program_study_program_variant VALUES (341, 10);
INSERT INTO public.study_program_study_program_variant VALUES (341, 14);
INSERT INTO public.study_program_study_program_variant VALUES (342, 10);
INSERT INTO public.study_program_study_program_variant VALUES (343, 10);
INSERT INTO public.study_program_study_program_variant VALUES (344, 10);
INSERT INTO public.study_program_study_program_variant VALUES (345, 10);
INSERT INTO public.study_program_study_program_variant VALUES (346, 10);
INSERT INTO public.study_program_study_program_variant VALUES (347, 10);
INSERT INTO public.study_program_study_program_variant VALUES (348, 10);
INSERT INTO public.study_program_study_program_variant VALUES (349, 47);
INSERT INTO public.study_program_study_program_variant VALUES (349, 48);
INSERT INTO public.study_program_study_program_variant VALUES (350, 1);
INSERT INTO public.study_program_study_program_variant VALUES (350, 11);
INSERT INTO public.study_program_study_program_variant VALUES (352, 10);
INSERT INTO public.study_program_study_program_variant VALUES (351, 10);
INSERT INTO public.study_program_study_program_variant VALUES (351, 11);
INSERT INTO public.study_program_study_program_variant VALUES (353, 13);
INSERT INTO public.study_program_study_program_variant VALUES (353, 12);
INSERT INTO public.study_program_study_program_variant VALUES (354, 11);
INSERT INTO public.study_program_study_program_variant VALUES (354, 13);
INSERT INTO public.study_program_study_program_variant VALUES (354, 12);
INSERT INTO public.study_program_study_program_variant VALUES (354, 10);
INSERT INTO public.study_program_study_program_variant VALUES (355, 13);
INSERT INTO public.study_program_study_program_variant VALUES (355, 12);
INSERT INTO public.study_program_study_program_variant VALUES (355, 2);
INSERT INTO public.study_program_study_program_variant VALUES (355, 3);
INSERT INTO public.study_program_study_program_variant VALUES (356, 3);
INSERT INTO public.study_program_study_program_variant VALUES (356, 13);
INSERT INTO public.study_program_study_program_variant VALUES (356, 2);
INSERT INTO public.study_program_study_program_variant VALUES (356, 12);
INSERT INTO public.study_program_study_program_variant VALUES (358, 2);
INSERT INTO public.study_program_study_program_variant VALUES (358, 12);
INSERT INTO public.study_program_study_program_variant VALUES (358, 14);
INSERT INTO public.study_program_study_program_variant VALUES (358, 10);
INSERT INTO public.study_program_study_program_variant VALUES (358, 3);
INSERT INTO public.study_program_study_program_variant VALUES (358, 13);
INSERT INTO public.study_program_study_program_variant VALUES (357, 1);
INSERT INTO public.study_program_study_program_variant VALUES (357, 4);
INSERT INTO public.study_program_study_program_variant VALUES (357, 12);
INSERT INTO public.study_program_study_program_variant VALUES (357, 3);
INSERT INTO public.study_program_study_program_variant VALUES (357, 2);
INSERT INTO public.study_program_study_program_variant VALUES (357, 11);
INSERT INTO public.study_program_study_program_variant VALUES (357, 10);
INSERT INTO public.study_program_study_program_variant VALUES (357, 13);
INSERT INTO public.study_program_study_program_variant VALUES (359, 8);
INSERT INTO public.study_program_study_program_variant VALUES (359, 4);
INSERT INTO public.study_program_study_program_variant VALUES (360, 8);
INSERT INTO public.study_program_study_program_variant VALUES (360, 15);
INSERT INTO public.study_program_study_program_variant VALUES (360, 16);
INSERT INTO public.study_program_study_program_variant VALUES (360, 2);
INSERT INTO public.study_program_study_program_variant VALUES (360, 3);
INSERT INTO public.study_program_study_program_variant VALUES (360, 7);
INSERT INTO public.study_program_study_program_variant VALUES (360, 17);
INSERT INTO public.study_program_study_program_variant VALUES (361, 8);
INSERT INTO public.study_program_study_program_variant VALUES (362, 8);
INSERT INTO public.study_program_study_program_variant VALUES (363, 8);
INSERT INTO public.study_program_study_program_variant VALUES (364, 1);
INSERT INTO public.study_program_study_program_variant VALUES (364, 5);
INSERT INTO public.study_program_study_program_variant VALUES (364, 26);
INSERT INTO public.study_program_study_program_variant VALUES (364, 11);
INSERT INTO public.study_program_study_program_variant VALUES (365, 20);
INSERT INTO public.study_program_study_program_variant VALUES (366, 20);
INSERT INTO public.study_program_study_program_variant VALUES (367, 10);
INSERT INTO public.study_program_study_program_variant VALUES (368, 8);
INSERT INTO public.study_program_study_program_variant VALUES (369, 20);
INSERT INTO public.study_program_study_program_variant VALUES (370, 20);
INSERT INTO public.study_program_study_program_variant VALUES (371, 8);
INSERT INTO public.study_program_study_program_variant VALUES (372, 8);
INSERT INTO public.study_program_study_program_variant VALUES (372, 15);
INSERT INTO public.study_program_study_program_variant VALUES (373, 10);
INSERT INTO public.study_program_study_program_variant VALUES (374, 11);
INSERT INTO public.study_program_study_program_variant VALUES (374, 26);
INSERT INTO public.study_program_study_program_variant VALUES (375, 11);
INSERT INTO public.study_program_study_program_variant VALUES (376, 11);
INSERT INTO public.study_program_study_program_variant VALUES (377, 13);
INSERT INTO public.study_program_study_program_variant VALUES (377, 12);
INSERT INTO public.study_program_study_program_variant VALUES (378, 16);
INSERT INTO public.study_program_study_program_variant VALUES (378, 12);
INSERT INTO public.study_program_study_program_variant VALUES (378, 13);
INSERT INTO public.study_program_study_program_variant VALUES (378, 17);
INSERT INTO public.study_program_study_program_variant VALUES (379, 16);
INSERT INTO public.study_program_study_program_variant VALUES (379, 20);
INSERT INTO public.study_program_study_program_variant VALUES (379, 2);
INSERT INTO public.study_program_study_program_variant VALUES (379, 17);
INSERT INTO public.study_program_study_program_variant VALUES (379, 3);
INSERT INTO public.study_program_study_program_variant VALUES (379, 8);
INSERT INTO public.study_program_study_program_variant VALUES (380, 20);
INSERT INTO public.study_program_study_program_variant VALUES (381, 20);
INSERT INTO public.study_program_study_program_variant VALUES (382, 2);
INSERT INTO public.study_program_study_program_variant VALUES (382, 17);
INSERT INTO public.study_program_study_program_variant VALUES (382, 3);
INSERT INTO public.study_program_study_program_variant VALUES (382, 16);
INSERT INTO public.study_program_study_program_variant VALUES (383, 20);
INSERT INTO public.study_program_study_program_variant VALUES (384, 20);
INSERT INTO public.study_program_study_program_variant VALUES (385, 12);
INSERT INTO public.study_program_study_program_variant VALUES (385, 11);
INSERT INTO public.study_program_study_program_variant VALUES (385, 10);
INSERT INTO public.study_program_study_program_variant VALUES (385, 13);
INSERT INTO public.study_program_study_program_variant VALUES (386, 8);
INSERT INTO public.study_program_study_program_variant VALUES (387, 11);
INSERT INTO public.study_program_study_program_variant VALUES (388, 11);
INSERT INTO public.study_program_study_program_variant VALUES (389, 14);
INSERT INTO public.study_program_study_program_variant VALUES (389, 16);
INSERT INTO public.study_program_study_program_variant VALUES (389, 17);
INSERT INTO public.study_program_study_program_variant VALUES (392, 10);
INSERT INTO public.study_program_study_program_variant VALUES (391, 10);
INSERT INTO public.study_program_study_program_variant VALUES (391, 4);
INSERT INTO public.study_program_study_program_variant VALUES (390, 25);
INSERT INTO public.study_program_study_program_variant VALUES (390, 11);
INSERT INTO public.study_program_study_program_variant VALUES (390, 10);
INSERT INTO public.study_program_study_program_variant VALUES (390, 26);
INSERT INTO public.study_program_study_program_variant VALUES (390, 4);
INSERT INTO public.study_program_study_program_variant VALUES (390, 1);
INSERT INTO public.study_program_study_program_variant VALUES (393, 7);
INSERT INTO public.study_program_study_program_variant VALUES (393, 15);
INSERT INTO public.study_program_study_program_variant VALUES (393, 2);
INSERT INTO public.study_program_study_program_variant VALUES (393, 3);
INSERT INTO public.study_program_study_program_variant VALUES (393, 16);
INSERT INTO public.study_program_study_program_variant VALUES (393, 17);
INSERT INTO public.study_program_study_program_variant VALUES (394, 12);
INSERT INTO public.study_program_study_program_variant VALUES (394, 14);
INSERT INTO public.study_program_study_program_variant VALUES (394, 13);
INSERT INTO public.study_program_study_program_variant VALUES (395, 2);
INSERT INTO public.study_program_study_program_variant VALUES (395, 16);
INSERT INTO public.study_program_study_program_variant VALUES (395, 3);
INSERT INTO public.study_program_study_program_variant VALUES (395, 17);
INSERT INTO public.study_program_study_program_variant VALUES (396, 1);
INSERT INTO public.study_program_study_program_variant VALUES (396, 10);
INSERT INTO public.study_program_study_program_variant VALUES (396, 11);
INSERT INTO public.study_program_study_program_variant VALUES (397, 12);
INSERT INTO public.study_program_study_program_variant VALUES (397, 13);
INSERT INTO public.study_program_study_program_variant VALUES (397, 14);
INSERT INTO public.study_program_study_program_variant VALUES (398, 10);
INSERT INTO public.study_program_study_program_variant VALUES (399, 3);
INSERT INTO public.study_program_study_program_variant VALUES (399, 12);
INSERT INTO public.study_program_study_program_variant VALUES (399, 13);
INSERT INTO public.study_program_study_program_variant VALUES (399, 2);
INSERT INTO public.study_program_study_program_variant VALUES (400, 12);
INSERT INTO public.study_program_study_program_variant VALUES (400, 3);
INSERT INTO public.study_program_study_program_variant VALUES (400, 2);
INSERT INTO public.study_program_study_program_variant VALUES (400, 13);
INSERT INTO public.study_program_study_program_variant VALUES (401, 2);
INSERT INTO public.study_program_study_program_variant VALUES (401, 12);
INSERT INTO public.study_program_study_program_variant VALUES (401, 13);
INSERT INTO public.study_program_study_program_variant VALUES (401, 3);
INSERT INTO public.study_program_study_program_variant VALUES (402, 2);
INSERT INTO public.study_program_study_program_variant VALUES (402, 3);
INSERT INTO public.study_program_study_program_variant VALUES (402, 13);
INSERT INTO public.study_program_study_program_variant VALUES (402, 12);
INSERT INTO public.study_program_study_program_variant VALUES (403, 12);
INSERT INTO public.study_program_study_program_variant VALUES (403, 13);
INSERT INTO public.study_program_study_program_variant VALUES (404, 7);
INSERT INTO public.study_program_study_program_variant VALUES (405, 10);
INSERT INTO public.study_program_study_program_variant VALUES (406, 10);
INSERT INTO public.study_program_study_program_variant VALUES (407, 16);
INSERT INTO public.study_program_study_program_variant VALUES (407, 20);
INSERT INTO public.study_program_study_program_variant VALUES (408, 17);
INSERT INTO public.study_program_study_program_variant VALUES (408, 16);
INSERT INTO public.study_program_study_program_variant VALUES (409, 17);
INSERT INTO public.study_program_study_program_variant VALUES (409, 16);
INSERT INTO public.study_program_study_program_variant VALUES (409, 2);
INSERT INTO public.study_program_study_program_variant VALUES (409, 3);
INSERT INTO public.study_program_study_program_variant VALUES (410, 10);
INSERT INTO public.study_program_study_program_variant VALUES (410, 11);
INSERT INTO public.study_program_study_program_variant VALUES (411, 25);
INSERT INTO public.study_program_study_program_variant VALUES (411, 13);
INSERT INTO public.study_program_study_program_variant VALUES (411, 26);
INSERT INTO public.study_program_study_program_variant VALUES (411, 3);
INSERT INTO public.study_program_study_program_variant VALUES (411, 12);
INSERT INTO public.study_program_study_program_variant VALUES (411, 2);
INSERT INTO public.study_program_study_program_variant VALUES (411, 10);
INSERT INTO public.study_program_study_program_variant VALUES (411, 11);
INSERT INTO public.study_program_study_program_variant VALUES (412, 16);
INSERT INTO public.study_program_study_program_variant VALUES (412, 17);
INSERT INTO public.study_program_study_program_variant VALUES (413, 13);
INSERT INTO public.study_program_study_program_variant VALUES (413, 12);
INSERT INTO public.study_program_study_program_variant VALUES (414, 8);
INSERT INTO public.study_program_study_program_variant VALUES (415, 3);
INSERT INTO public.study_program_study_program_variant VALUES (415, 16);
INSERT INTO public.study_program_study_program_variant VALUES (415, 2);
INSERT INTO public.study_program_study_program_variant VALUES (415, 17);
INSERT INTO public.study_program_study_program_variant VALUES (416, 10);
INSERT INTO public.study_program_study_program_variant VALUES (416, 1);
INSERT INTO public.study_program_study_program_variant VALUES (416, 11);
INSERT INTO public.study_program_study_program_variant VALUES (416, 4);
INSERT INTO public.study_program_study_program_variant VALUES (417, 49);
INSERT INTO public.study_program_study_program_variant VALUES (418, 42);
INSERT INTO public.study_program_study_program_variant VALUES (418, 2);
INSERT INTO public.study_program_study_program_variant VALUES (418, 3);
INSERT INTO public.study_program_study_program_variant VALUES (418, 14);
INSERT INTO public.study_program_study_program_variant VALUES (418, 13);
INSERT INTO public.study_program_study_program_variant VALUES (418, 29);
INSERT INTO public.study_program_study_program_variant VALUES (418, 12);
INSERT INTO public.study_program_study_program_variant VALUES (418, 7);
INSERT INTO public.study_program_study_program_variant VALUES (419, 10);
INSERT INTO public.study_program_study_program_variant VALUES (420, 10);
INSERT INTO public.study_program_study_program_variant VALUES (421, 10);
INSERT INTO public.study_program_study_program_variant VALUES (422, 10);
INSERT INTO public.study_program_study_program_variant VALUES (423, 10);
INSERT INTO public.study_program_study_program_variant VALUES (424, 50);
INSERT INTO public.study_program_study_program_variant VALUES (425, 10);
INSERT INTO public.study_program_study_program_variant VALUES (426, 3);
INSERT INTO public.study_program_study_program_variant VALUES (426, 2);
INSERT INTO public.study_program_study_program_variant VALUES (426, 13);
INSERT INTO public.study_program_study_program_variant VALUES (426, 12);
INSERT INTO public.study_program_study_program_variant VALUES (427, 13);
INSERT INTO public.study_program_study_program_variant VALUES (427, 2);
INSERT INTO public.study_program_study_program_variant VALUES (427, 12);
INSERT INTO public.study_program_study_program_variant VALUES (427, 3);
INSERT INTO public.study_program_study_program_variant VALUES (428, 17);
INSERT INTO public.study_program_study_program_variant VALUES (428, 16);
INSERT INTO public.study_program_study_program_variant VALUES (429, 3);
INSERT INTO public.study_program_study_program_variant VALUES (429, 13);
INSERT INTO public.study_program_study_program_variant VALUES (429, 2);
INSERT INTO public.study_program_study_program_variant VALUES (429, 12);
INSERT INTO public.study_program_study_program_variant VALUES (430, 13);
INSERT INTO public.study_program_study_program_variant VALUES (430, 12);
INSERT INTO public.study_program_study_program_variant VALUES (430, 3);
INSERT INTO public.study_program_study_program_variant VALUES (430, 2);
INSERT INTO public.study_program_study_program_variant VALUES (431, 12);
INSERT INTO public.study_program_study_program_variant VALUES (431, 2);
INSERT INTO public.study_program_study_program_variant VALUES (431, 13);
INSERT INTO public.study_program_study_program_variant VALUES (431, 3);
INSERT INTO public.study_program_study_program_variant VALUES (432, 12);
INSERT INTO public.study_program_study_program_variant VALUES (432, 13);
INSERT INTO public.study_program_study_program_variant VALUES (432, 3);
INSERT INTO public.study_program_study_program_variant VALUES (432, 2);
INSERT INTO public.study_program_study_program_variant VALUES (433, 25);
INSERT INTO public.study_program_study_program_variant VALUES (433, 10);
INSERT INTO public.study_program_study_program_variant VALUES (433, 4);
INSERT INTO public.study_program_study_program_variant VALUES (433, 6);
INSERT INTO public.study_program_study_program_variant VALUES (434, 8);
INSERT INTO public.study_program_study_program_variant VALUES (434, 20);
INSERT INTO public.study_program_study_program_variant VALUES (435, 11);
INSERT INTO public.study_program_study_program_variant VALUES (436, 12);
INSERT INTO public.study_program_study_program_variant VALUES (436, 13);
INSERT INTO public.study_program_study_program_variant VALUES (437, 10);
INSERT INTO public.study_program_study_program_variant VALUES (437, 14);
INSERT INTO public.study_program_study_program_variant VALUES (438, 17);
INSERT INTO public.study_program_study_program_variant VALUES (438, 16);
INSERT INTO public.study_program_study_program_variant VALUES (439, 13);
INSERT INTO public.study_program_study_program_variant VALUES (439, 12);
INSERT INTO public.study_program_study_program_variant VALUES (440, 12);
INSERT INTO public.study_program_study_program_variant VALUES (440, 14);
INSERT INTO public.study_program_study_program_variant VALUES (440, 13);
INSERT INTO public.study_program_study_program_variant VALUES (440, 3);
INSERT INTO public.study_program_study_program_variant VALUES (440, 2);
INSERT INTO public.study_program_study_program_variant VALUES (441, 12);
INSERT INTO public.study_program_study_program_variant VALUES (441, 13);
INSERT INTO public.study_program_study_program_variant VALUES (442, 1);
INSERT INTO public.study_program_study_program_variant VALUES (443, 1);
INSERT INTO public.study_program_study_program_variant VALUES (444, 3);
INSERT INTO public.study_program_study_program_variant VALUES (444, 7);
INSERT INTO public.study_program_study_program_variant VALUES (444, 10);
INSERT INTO public.study_program_study_program_variant VALUES (444, 4);
INSERT INTO public.study_program_study_program_variant VALUES (444, 12);
INSERT INTO public.study_program_study_program_variant VALUES (444, 25);
INSERT INTO public.study_program_study_program_variant VALUES (444, 13);
INSERT INTO public.study_program_study_program_variant VALUES (444, 2);
INSERT INTO public.study_program_study_program_variant VALUES (444, 42);
INSERT INTO public.study_program_study_program_variant VALUES (444, 14);
INSERT INTO public.study_program_study_program_variant VALUES (445, 10);
INSERT INTO public.study_program_study_program_variant VALUES (445, 25);
INSERT INTO public.study_program_study_program_variant VALUES (445, 17);
INSERT INTO public.study_program_study_program_variant VALUES (445, 16);
INSERT INTO public.study_program_study_program_variant VALUES (446, 4);
INSERT INTO public.study_program_study_program_variant VALUES (447, 14);
INSERT INTO public.study_program_study_program_variant VALUES (447, 42);
INSERT INTO public.study_program_study_program_variant VALUES (448, 20);
INSERT INTO public.study_program_study_program_variant VALUES (448, 17);
INSERT INTO public.study_program_study_program_variant VALUES (448, 16);
INSERT INTO public.study_program_study_program_variant VALUES (449, 20);
INSERT INTO public.study_program_study_program_variant VALUES (450, 17);
INSERT INTO public.study_program_study_program_variant VALUES (450, 3);
INSERT INTO public.study_program_study_program_variant VALUES (450, 16);
INSERT INTO public.study_program_study_program_variant VALUES (451, 10);
INSERT INTO public.study_program_study_program_variant VALUES (451, 11);
INSERT INTO public.study_program_study_program_variant VALUES (452, 14);
INSERT INTO public.study_program_study_program_variant VALUES (453, 8);
INSERT INTO public.study_program_study_program_variant VALUES (453, 7);
INSERT INTO public.study_program_study_program_variant VALUES (453, 15);
INSERT INTO public.study_program_study_program_variant VALUES (454, 26);
INSERT INTO public.study_program_study_program_variant VALUES (454, 25);
INSERT INTO public.study_program_study_program_variant VALUES (454, 10);
INSERT INTO public.study_program_study_program_variant VALUES (454, 11);
INSERT INTO public.study_program_study_program_variant VALUES (455, 25);
INSERT INTO public.study_program_study_program_variant VALUES (455, 10);
INSERT INTO public.study_program_study_program_variant VALUES (456, 25);
INSERT INTO public.study_program_study_program_variant VALUES (456, 26);
INSERT INTO public.study_program_study_program_variant VALUES (456, 10);
INSERT INTO public.study_program_study_program_variant VALUES (456, 1);
INSERT INTO public.study_program_study_program_variant VALUES (456, 4);
INSERT INTO public.study_program_study_program_variant VALUES (456, 11);
INSERT INTO public.study_program_study_program_variant VALUES (457, 10);
INSERT INTO public.study_program_study_program_variant VALUES (457, 14);
INSERT INTO public.study_program_study_program_variant VALUES (458, 51);
INSERT INTO public.study_program_study_program_variant VALUES (458, 20);
INSERT INTO public.study_program_study_program_variant VALUES (458, 17);
INSERT INTO public.study_program_study_program_variant VALUES (458, 16);
INSERT INTO public.study_program_study_program_variant VALUES (459, 11);
INSERT INTO public.study_program_study_program_variant VALUES (459, 10);
INSERT INTO public.study_program_study_program_variant VALUES (460, 14);
INSERT INTO public.study_program_study_program_variant VALUES (461, 16);
INSERT INTO public.study_program_study_program_variant VALUES (461, 10);
INSERT INTO public.study_program_study_program_variant VALUES (462, 8);
INSERT INTO public.study_program_study_program_variant VALUES (462, 15);
INSERT INTO public.study_program_study_program_variant VALUES (462, 7);
INSERT INTO public.study_program_study_program_variant VALUES (462, 17);
INSERT INTO public.study_program_study_program_variant VALUES (462, 16);
INSERT INTO public.study_program_study_program_variant VALUES (462, 3);
INSERT INTO public.study_program_study_program_variant VALUES (462, 2);
INSERT INTO public.study_program_study_program_variant VALUES (463, 10);
INSERT INTO public.study_program_study_program_variant VALUES (464, 10);
INSERT INTO public.study_program_study_program_variant VALUES (465, 10);
INSERT INTO public.study_program_study_program_variant VALUES (466, 10);
INSERT INTO public.study_program_study_program_variant VALUES (467, 10);
INSERT INTO public.study_program_study_program_variant VALUES (468, 10);
INSERT INTO public.study_program_study_program_variant VALUES (469, 10);
INSERT INTO public.study_program_study_program_variant VALUES (472, 11);
INSERT INTO public.study_program_study_program_variant VALUES (470, 8);
INSERT INTO public.study_program_study_program_variant VALUES (470, 20);
INSERT INTO public.study_program_study_program_variant VALUES (471, 11);
INSERT INTO public.study_program_study_program_variant VALUES (471, 16);
INSERT INTO public.study_program_study_program_variant VALUES (471, 17);
INSERT INTO public.study_program_study_program_variant VALUES (473, 10);
INSERT INTO public.study_program_study_program_variant VALUES (473, 13);
INSERT INTO public.study_program_study_program_variant VALUES (473, 12);
INSERT INTO public.study_program_study_program_variant VALUES (474, 52);
INSERT INTO public.study_program_study_program_variant VALUES (474, 53);
INSERT INTO public.study_program_study_program_variant VALUES (475, 54);
INSERT INTO public.study_program_study_program_variant VALUES (475, 55);
INSERT INTO public.study_program_study_program_variant VALUES (476, 17);
INSERT INTO public.study_program_study_program_variant VALUES (476, 16);
INSERT INTO public.study_program_study_program_variant VALUES (477, 2);
INSERT INTO public.study_program_study_program_variant VALUES (477, 17);
INSERT INTO public.study_program_study_program_variant VALUES (477, 16);
INSERT INTO public.study_program_study_program_variant VALUES (477, 3);
INSERT INTO public.study_program_study_program_variant VALUES (478, 8);
INSERT INTO public.study_program_study_program_variant VALUES (479, 10);
INSERT INTO public.study_program_study_program_variant VALUES (479, 15);
INSERT INTO public.study_program_study_program_variant VALUES (480, 10);
INSERT INTO public.study_program_study_program_variant VALUES (481, 14);
INSERT INTO public.study_program_study_program_variant VALUES (481, 42);
INSERT INTO public.study_program_study_program_variant VALUES (482, 17);
INSERT INTO public.study_program_study_program_variant VALUES (482, 16);
INSERT INTO public.study_program_study_program_variant VALUES (483, 13);
INSERT INTO public.study_program_study_program_variant VALUES (483, 3);
INSERT INTO public.study_program_study_program_variant VALUES (483, 10);
INSERT INTO public.study_program_study_program_variant VALUES (483, 4);
INSERT INTO public.study_program_study_program_variant VALUES (483, 2);
INSERT INTO public.study_program_study_program_variant VALUES (483, 12);
INSERT INTO public.study_program_study_program_variant VALUES (484, 8);
INSERT INTO public.study_program_study_program_variant VALUES (485, 13);
INSERT INTO public.study_program_study_program_variant VALUES (485, 12);
INSERT INTO public.study_program_study_program_variant VALUES (486, 2);
INSERT INTO public.study_program_study_program_variant VALUES (486, 12);
INSERT INTO public.study_program_study_program_variant VALUES (486, 3);
INSERT INTO public.study_program_study_program_variant VALUES (486, 13);
INSERT INTO public.study_program_study_program_variant VALUES (487, 56);
INSERT INTO public.study_program_study_program_variant VALUES (487, 10);
INSERT INTO public.study_program_study_program_variant VALUES (488, 2);
INSERT INTO public.study_program_study_program_variant VALUES (488, 17);
INSERT INTO public.study_program_study_program_variant VALUES (488, 16);
INSERT INTO public.study_program_study_program_variant VALUES (488, 3);
INSERT INTO public.study_program_study_program_variant VALUES (489, 4);
INSERT INTO public.study_program_study_program_variant VALUES (489, 10);
INSERT INTO public.study_program_study_program_variant VALUES (490, 11);
INSERT INTO public.study_program_study_program_variant VALUES (491, 12);
INSERT INTO public.study_program_study_program_variant VALUES (491, 13);
INSERT INTO public.study_program_study_program_variant VALUES (492, 13);
INSERT INTO public.study_program_study_program_variant VALUES (492, 3);
INSERT INTO public.study_program_study_program_variant VALUES (492, 12);
INSERT INTO public.study_program_study_program_variant VALUES (492, 2);
INSERT INTO public.study_program_study_program_variant VALUES (493, 14);
INSERT INTO public.study_program_study_program_variant VALUES (493, 16);
INSERT INTO public.study_program_study_program_variant VALUES (493, 17);
INSERT INTO public.study_program_study_program_variant VALUES (494, 11);
INSERT INTO public.study_program_study_program_variant VALUES (494, 2);
INSERT INTO public.study_program_study_program_variant VALUES (494, 12);
INSERT INTO public.study_program_study_program_variant VALUES (494, 3);
INSERT INTO public.study_program_study_program_variant VALUES (494, 13);
INSERT INTO public.study_program_study_program_variant VALUES (495, 16);
INSERT INTO public.study_program_study_program_variant VALUES (495, 17);
INSERT INTO public.study_program_study_program_variant VALUES (496, 14);
INSERT INTO public.study_program_study_program_variant VALUES (497, 14);
INSERT INTO public.study_program_study_program_variant VALUES (497, 12);
INSERT INTO public.study_program_study_program_variant VALUES (497, 13);
INSERT INTO public.study_program_study_program_variant VALUES (498, 13);
INSERT INTO public.study_program_study_program_variant VALUES (498, 3);
INSERT INTO public.study_program_study_program_variant VALUES (499, 11);
INSERT INTO public.study_program_study_program_variant VALUES (500, 11);
INSERT INTO public.study_program_study_program_variant VALUES (501, 8);
INSERT INTO public.study_program_study_program_variant VALUES (502, 10);
INSERT INTO public.study_program_study_program_variant VALUES (502, 14);
INSERT INTO public.study_program_study_program_variant VALUES (503, 50);
INSERT INTO public.study_program_study_program_variant VALUES (503, 57);
INSERT INTO public.study_program_study_program_variant VALUES (504, 10);
INSERT INTO public.study_program_study_program_variant VALUES (505, 10);
INSERT INTO public.study_program_study_program_variant VALUES (506, 10);
INSERT INTO public.study_program_study_program_variant VALUES (507, 10);
INSERT INTO public.study_program_study_program_variant VALUES (508, 50);
INSERT INTO public.study_program_study_program_variant VALUES (509, 3);
INSERT INTO public.study_program_study_program_variant VALUES (509, 2);
INSERT INTO public.study_program_study_program_variant VALUES (509, 13);
INSERT INTO public.study_program_study_program_variant VALUES (509, 12);
INSERT INTO public.study_program_study_program_variant VALUES (511, 16);
INSERT INTO public.study_program_study_program_variant VALUES (511, 17);
INSERT INTO public.study_program_study_program_variant VALUES (510, 2);
INSERT INTO public.study_program_study_program_variant VALUES (510, 3);
INSERT INTO public.study_program_study_program_variant VALUES (510, 12);
INSERT INTO public.study_program_study_program_variant VALUES (510, 13);
INSERT INTO public.study_program_study_program_variant VALUES (513, 2);
INSERT INTO public.study_program_study_program_variant VALUES (513, 13);
INSERT INTO public.study_program_study_program_variant VALUES (513, 12);
INSERT INTO public.study_program_study_program_variant VALUES (513, 3);
INSERT INTO public.study_program_study_program_variant VALUES (514, 13);
INSERT INTO public.study_program_study_program_variant VALUES (514, 12);
INSERT INTO public.study_program_study_program_variant VALUES (514, 3);
INSERT INTO public.study_program_study_program_variant VALUES (514, 2);
INSERT INTO public.study_program_study_program_variant VALUES (512, 12);
INSERT INTO public.study_program_study_program_variant VALUES (512, 2);
INSERT INTO public.study_program_study_program_variant VALUES (512, 3);
INSERT INTO public.study_program_study_program_variant VALUES (512, 13);
INSERT INTO public.study_program_study_program_variant VALUES (515, 1);
INSERT INTO public.study_program_study_program_variant VALUES (515, 11);
INSERT INTO public.study_program_study_program_variant VALUES (516, 11);
INSERT INTO public.study_program_study_program_variant VALUES (517, 17);
INSERT INTO public.study_program_study_program_variant VALUES (517, 16);
INSERT INTO public.study_program_study_program_variant VALUES (519, 13);
INSERT INTO public.study_program_study_program_variant VALUES (519, 12);
INSERT INTO public.study_program_study_program_variant VALUES (518, 3);
INSERT INTO public.study_program_study_program_variant VALUES (518, 13);
INSERT INTO public.study_program_study_program_variant VALUES (518, 2);
INSERT INTO public.study_program_study_program_variant VALUES (518, 12);
INSERT INTO public.study_program_study_program_variant VALUES (520, 10);
INSERT INTO public.study_program_study_program_variant VALUES (521, 10);
INSERT INTO public.study_program_study_program_variant VALUES (521, 11);
INSERT INTO public.study_program_study_program_variant VALUES (522, 8);
INSERT INTO public.study_program_study_program_variant VALUES (523, 8);
INSERT INTO public.study_program_study_program_variant VALUES (524, 13);
INSERT INTO public.study_program_study_program_variant VALUES (524, 12);
INSERT INTO public.study_program_study_program_variant VALUES (525, 12);
INSERT INTO public.study_program_study_program_variant VALUES (525, 13);
INSERT INTO public.study_program_study_program_variant VALUES (526, 11);
INSERT INTO public.study_program_study_program_variant VALUES (526, 1);
INSERT INTO public.study_program_study_program_variant VALUES (527, 10);
INSERT INTO public.study_program_study_program_variant VALUES (528, 12);
INSERT INTO public.study_program_study_program_variant VALUES (528, 13);
INSERT INTO public.study_program_study_program_variant VALUES (529, 2);
INSERT INTO public.study_program_study_program_variant VALUES (529, 3);
INSERT INTO public.study_program_study_program_variant VALUES (529, 13);
INSERT INTO public.study_program_study_program_variant VALUES (529, 12);
INSERT INTO public.study_program_study_program_variant VALUES (530, 3);
INSERT INTO public.study_program_study_program_variant VALUES (530, 2);
INSERT INTO public.study_program_study_program_variant VALUES (530, 13);
INSERT INTO public.study_program_study_program_variant VALUES (530, 12);
INSERT INTO public.study_program_study_program_variant VALUES (531, 7);
INSERT INTO public.study_program_study_program_variant VALUES (531, 15);
INSERT INTO public.study_program_study_program_variant VALUES (532, 14);
INSERT INTO public.study_program_study_program_variant VALUES (533, 12);
INSERT INTO public.study_program_study_program_variant VALUES (533, 13);
INSERT INTO public.study_program_study_program_variant VALUES (535, 14);
INSERT INTO public.study_program_study_program_variant VALUES (535, 13);
INSERT INTO public.study_program_study_program_variant VALUES (535, 12);
INSERT INTO public.study_program_study_program_variant VALUES (534, 12);
INSERT INTO public.study_program_study_program_variant VALUES (534, 3);
INSERT INTO public.study_program_study_program_variant VALUES (534, 13);
INSERT INTO public.study_program_study_program_variant VALUES (534, 2);
INSERT INTO public.study_program_study_program_variant VALUES (536, 14);
INSERT INTO public.study_program_study_program_variant VALUES (537, 12);
INSERT INTO public.study_program_study_program_variant VALUES (537, 13);
INSERT INTO public.study_program_study_program_variant VALUES (537, 2);
INSERT INTO public.study_program_study_program_variant VALUES (537, 3);
INSERT INTO public.study_program_study_program_variant VALUES (538, 12);
INSERT INTO public.study_program_study_program_variant VALUES (538, 13);
INSERT INTO public.study_program_study_program_variant VALUES (538, 3);
INSERT INTO public.study_program_study_program_variant VALUES (538, 2);
INSERT INTO public.study_program_study_program_variant VALUES (539, 10);
INSERT INTO public.study_program_study_program_variant VALUES (539, 25);
INSERT INTO public.study_program_study_program_variant VALUES (539, 14);
INSERT INTO public.study_program_study_program_variant VALUES (539, 42);
INSERT INTO public.study_program_study_program_variant VALUES (539, 13);
INSERT INTO public.study_program_study_program_variant VALUES (539, 12);
INSERT INTO public.study_program_study_program_variant VALUES (540, 14);
INSERT INTO public.study_program_study_program_variant VALUES (540, 42);
INSERT INTO public.study_program_study_program_variant VALUES (540, 16);
INSERT INTO public.study_program_study_program_variant VALUES (540, 10);
INSERT INTO public.study_program_study_program_variant VALUES (540, 17);
INSERT INTO public.study_program_study_program_variant VALUES (541, 14);
INSERT INTO public.study_program_study_program_variant VALUES (541, 10);
INSERT INTO public.study_program_study_program_variant VALUES (541, 12);
INSERT INTO public.study_program_study_program_variant VALUES (541, 13);
INSERT INTO public.study_program_study_program_variant VALUES (543, 12);
INSERT INTO public.study_program_study_program_variant VALUES (543, 2);
INSERT INTO public.study_program_study_program_variant VALUES (543, 3);
INSERT INTO public.study_program_study_program_variant VALUES (543, 13);
INSERT INTO public.study_program_study_program_variant VALUES (542, 3);
INSERT INTO public.study_program_study_program_variant VALUES (542, 12);
INSERT INTO public.study_program_study_program_variant VALUES (542, 2);
INSERT INTO public.study_program_study_program_variant VALUES (542, 13);
INSERT INTO public.study_program_study_program_variant VALUES (544, 10);
INSERT INTO public.study_program_study_program_variant VALUES (544, 14);
INSERT INTO public.study_program_study_program_variant VALUES (546, 3);
INSERT INTO public.study_program_study_program_variant VALUES (546, 2);
INSERT INTO public.study_program_study_program_variant VALUES (546, 12);
INSERT INTO public.study_program_study_program_variant VALUES (546, 13);
INSERT INTO public.study_program_study_program_variant VALUES (545, 12);
INSERT INTO public.study_program_study_program_variant VALUES (545, 13);
INSERT INTO public.study_program_study_program_variant VALUES (545, 3);
INSERT INTO public.study_program_study_program_variant VALUES (545, 2);
INSERT INTO public.study_program_study_program_variant VALUES (547, 10);
INSERT INTO public.study_program_study_program_variant VALUES (547, 4);
INSERT INTO public.study_program_study_program_variant VALUES (548, 10);
INSERT INTO public.study_program_study_program_variant VALUES (549, 8);
INSERT INTO public.study_program_study_program_variant VALUES (550, 58);
INSERT INTO public.study_program_study_program_variant VALUES (551, 8);
INSERT INTO public.study_program_study_program_variant VALUES (552, 25);
INSERT INTO public.study_program_study_program_variant VALUES (552, 17);
INSERT INTO public.study_program_study_program_variant VALUES (552, 42);
INSERT INTO public.study_program_study_program_variant VALUES (552, 16);
INSERT INTO public.study_program_study_program_variant VALUES (552, 13);
INSERT INTO public.study_program_study_program_variant VALUES (552, 14);
INSERT INTO public.study_program_study_program_variant VALUES (552, 12);
INSERT INTO public.study_program_study_program_variant VALUES (552, 10);
INSERT INTO public.study_program_study_program_variant VALUES (553, 17);
INSERT INTO public.study_program_study_program_variant VALUES (553, 16);
INSERT INTO public.study_program_study_program_variant VALUES (553, 8);
INSERT INTO public.study_program_study_program_variant VALUES (553, 15);
INSERT INTO public.study_program_study_program_variant VALUES (554, 1);
INSERT INTO public.study_program_study_program_variant VALUES (554, 11);
INSERT INTO public.study_program_study_program_variant VALUES (555, 8);
INSERT INTO public.study_program_study_program_variant VALUES (555, 4);
INSERT INTO public.study_program_study_program_variant VALUES (555, 10);
INSERT INTO public.study_program_study_program_variant VALUES (556, 4);
INSERT INTO public.study_program_study_program_variant VALUES (556, 10);
INSERT INTO public.study_program_study_program_variant VALUES (557, 1);
INSERT INTO public.study_program_study_program_variant VALUES (557, 11);
INSERT INTO public.study_program_study_program_variant VALUES (558, 4);
INSERT INTO public.study_program_study_program_variant VALUES (558, 10);
INSERT INTO public.study_program_study_program_variant VALUES (559, 10);
INSERT INTO public.study_program_study_program_variant VALUES (559, 11);
INSERT INTO public.study_program_study_program_variant VALUES (560, 10);
INSERT INTO public.study_program_study_program_variant VALUES (560, 11);
INSERT INTO public.study_program_study_program_variant VALUES (561, 15);
INSERT INTO public.study_program_study_program_variant VALUES (561, 7);
INSERT INTO public.study_program_study_program_variant VALUES (562, 15);
INSERT INTO public.study_program_study_program_variant VALUES (562, 7);
INSERT INTO public.study_program_study_program_variant VALUES (563, 20);
INSERT INTO public.study_program_study_program_variant VALUES (564, 11);
INSERT INTO public.study_program_study_program_variant VALUES (564, 10);
INSERT INTO public.study_program_study_program_variant VALUES (566, 8);
INSERT INTO public.study_program_study_program_variant VALUES (565, 25);
INSERT INTO public.study_program_study_program_variant VALUES (565, 10);
INSERT INTO public.study_program_study_program_variant VALUES (565, 26);
INSERT INTO public.study_program_study_program_variant VALUES (565, 13);
INSERT INTO public.study_program_study_program_variant VALUES (565, 12);
INSERT INTO public.study_program_study_program_variant VALUES (565, 11);
INSERT INTO public.study_program_study_program_variant VALUES (567, 8);
INSERT INTO public.study_program_study_program_variant VALUES (567, 20);
INSERT INTO public.study_program_study_program_variant VALUES (568, 20);
INSERT INTO public.study_program_study_program_variant VALUES (569, 10);
INSERT INTO public.study_program_study_program_variant VALUES (569, 11);
INSERT INTO public.study_program_study_program_variant VALUES (570, 11);
INSERT INTO public.study_program_study_program_variant VALUES (570, 10);
INSERT INTO public.study_program_study_program_variant VALUES (571, 20);
INSERT INTO public.study_program_study_program_variant VALUES (572, 1);
INSERT INTO public.study_program_study_program_variant VALUES (572, 4);
INSERT INTO public.study_program_study_program_variant VALUES (572, 10);
INSERT INTO public.study_program_study_program_variant VALUES (572, 11);
INSERT INTO public.study_program_study_program_variant VALUES (573, 11);
INSERT INTO public.study_program_study_program_variant VALUES (574, 13);
INSERT INTO public.study_program_study_program_variant VALUES (574, 3);
INSERT INTO public.study_program_study_program_variant VALUES (574, 12);
INSERT INTO public.study_program_study_program_variant VALUES (574, 2);
INSERT INTO public.study_program_study_program_variant VALUES (575, 15);
INSERT INTO public.study_program_study_program_variant VALUES (575, 7);
INSERT INTO public.study_program_study_program_variant VALUES (576, 13);
INSERT INTO public.study_program_study_program_variant VALUES (576, 12);
INSERT INTO public.study_program_study_program_variant VALUES (576, 10);
INSERT INTO public.study_program_study_program_variant VALUES (576, 25);
INSERT INTO public.study_program_study_program_variant VALUES (577, 10);
INSERT INTO public.study_program_study_program_variant VALUES (578, 12);
INSERT INTO public.study_program_study_program_variant VALUES (578, 11);
INSERT INTO public.study_program_study_program_variant VALUES (578, 10);
INSERT INTO public.study_program_study_program_variant VALUES (578, 13);
INSERT INTO public.study_program_study_program_variant VALUES (578, 3);
INSERT INTO public.study_program_study_program_variant VALUES (578, 2);
INSERT INTO public.study_program_study_program_variant VALUES (579, 11);
INSERT INTO public.study_program_study_program_variant VALUES (579, 25);
INSERT INTO public.study_program_study_program_variant VALUES (579, 2);
INSERT INTO public.study_program_study_program_variant VALUES (579, 3);
INSERT INTO public.study_program_study_program_variant VALUES (579, 13);
INSERT INTO public.study_program_study_program_variant VALUES (579, 12);
INSERT INTO public.study_program_study_program_variant VALUES (579, 10);
INSERT INTO public.study_program_study_program_variant VALUES (580, 10);
INSERT INTO public.study_program_study_program_variant VALUES (580, 12);
INSERT INTO public.study_program_study_program_variant VALUES (580, 11);
INSERT INTO public.study_program_study_program_variant VALUES (580, 13);
INSERT INTO public.study_program_study_program_variant VALUES (582, 11);
INSERT INTO public.study_program_study_program_variant VALUES (582, 10);
INSERT INTO public.study_program_study_program_variant VALUES (582, 12);
INSERT INTO public.study_program_study_program_variant VALUES (582, 13);
INSERT INTO public.study_program_study_program_variant VALUES (581, 16);
INSERT INTO public.study_program_study_program_variant VALUES (581, 20);
INSERT INTO public.study_program_study_program_variant VALUES (581, 10);
INSERT INTO public.study_program_study_program_variant VALUES (581, 17);
INSERT INTO public.study_program_study_program_variant VALUES (583, 8);
INSERT INTO public.study_program_study_program_variant VALUES (583, 20);
INSERT INTO public.study_program_study_program_variant VALUES (583, 3);
INSERT INTO public.study_program_study_program_variant VALUES (583, 16);
INSERT INTO public.study_program_study_program_variant VALUES (583, 2);
INSERT INTO public.study_program_study_program_variant VALUES (583, 17);
INSERT INTO public.study_program_study_program_variant VALUES (584, 10);
INSERT INTO public.study_program_study_program_variant VALUES (584, 25);
INSERT INTO public.study_program_study_program_variant VALUES (584, 11);
INSERT INTO public.study_program_study_program_variant VALUES (584, 26);
INSERT INTO public.study_program_study_program_variant VALUES (585, 13);
INSERT INTO public.study_program_study_program_variant VALUES (585, 3);
INSERT INTO public.study_program_study_program_variant VALUES (585, 12);
INSERT INTO public.study_program_study_program_variant VALUES (585, 2);
INSERT INTO public.study_program_study_program_variant VALUES (587, 13);
INSERT INTO public.study_program_study_program_variant VALUES (587, 12);
INSERT INTO public.study_program_study_program_variant VALUES (586, 13);
INSERT INTO public.study_program_study_program_variant VALUES (586, 12);
INSERT INTO public.study_program_study_program_variant VALUES (588, 4);
INSERT INTO public.study_program_study_program_variant VALUES (589, 4);
INSERT INTO public.study_program_study_program_variant VALUES (590, 13);
INSERT INTO public.study_program_study_program_variant VALUES (590, 12);
INSERT INTO public.study_program_study_program_variant VALUES (590, 3);
INSERT INTO public.study_program_study_program_variant VALUES (590, 2);
INSERT INTO public.study_program_study_program_variant VALUES (591, 2);
INSERT INTO public.study_program_study_program_variant VALUES (591, 17);
INSERT INTO public.study_program_study_program_variant VALUES (591, 3);
INSERT INTO public.study_program_study_program_variant VALUES (591, 16);
INSERT INTO public.study_program_study_program_variant VALUES (592, 10);
INSERT INTO public.study_program_study_program_variant VALUES (594, 10);
INSERT INTO public.study_program_study_program_variant VALUES (594, 14);
INSERT INTO public.study_program_study_program_variant VALUES (594, 42);
INSERT INTO public.study_program_study_program_variant VALUES (594, 25);
INSERT INTO public.study_program_study_program_variant VALUES (594, 7);
INSERT INTO public.study_program_study_program_variant VALUES (593, 35);
INSERT INTO public.study_program_study_program_variant VALUES (593, 25);
INSERT INTO public.study_program_study_program_variant VALUES (593, 42);
INSERT INTO public.study_program_study_program_variant VALUES (593, 10);
INSERT INTO public.study_program_study_program_variant VALUES (593, 14);
INSERT INTO public.study_program_study_program_variant VALUES (595, 2);
INSERT INTO public.study_program_study_program_variant VALUES (595, 16);
INSERT INTO public.study_program_study_program_variant VALUES (595, 17);
INSERT INTO public.study_program_study_program_variant VALUES (595, 3);
INSERT INTO public.study_program_study_program_variant VALUES (596, 14);
INSERT INTO public.study_program_study_program_variant VALUES (597, 14);
INSERT INTO public.study_program_study_program_variant VALUES (598, 12);
INSERT INTO public.study_program_study_program_variant VALUES (598, 3);
INSERT INTO public.study_program_study_program_variant VALUES (598, 2);
INSERT INTO public.study_program_study_program_variant VALUES (598, 13);
INSERT INTO public.study_program_study_program_variant VALUES (599, 11);
INSERT INTO public.study_program_study_program_variant VALUES (599, 1);
INSERT INTO public.study_program_study_program_variant VALUES (600, 2);
INSERT INTO public.study_program_study_program_variant VALUES (600, 3);
INSERT INTO public.study_program_study_program_variant VALUES (600, 12);
INSERT INTO public.study_program_study_program_variant VALUES (600, 13);
INSERT INTO public.study_program_study_program_variant VALUES (601, 10);
INSERT INTO public.study_program_study_program_variant VALUES (601, 7);
INSERT INTO public.study_program_study_program_variant VALUES (601, 14);
INSERT INTO public.study_program_study_program_variant VALUES (602, 14);
INSERT INTO public.study_program_study_program_variant VALUES (602, 10);
INSERT INTO public.study_program_study_program_variant VALUES (603, 16);
INSERT INTO public.study_program_study_program_variant VALUES (603, 17);
INSERT INTO public.study_program_study_program_variant VALUES (603, 2);
INSERT INTO public.study_program_study_program_variant VALUES (603, 3);
INSERT INTO public.study_program_study_program_variant VALUES (604, 17);
INSERT INTO public.study_program_study_program_variant VALUES (604, 16);
INSERT INTO public.study_program_study_program_variant VALUES (604, 14);
INSERT INTO public.study_program_study_program_variant VALUES (605, 10);
INSERT INTO public.study_program_study_program_variant VALUES (605, 42);
INSERT INTO public.study_program_study_program_variant VALUES (605, 14);
INSERT INTO public.study_program_study_program_variant VALUES (606, 10);
INSERT INTO public.study_program_study_program_variant VALUES (606, 11);
INSERT INTO public.study_program_study_program_variant VALUES (607, 12);
INSERT INTO public.study_program_study_program_variant VALUES (607, 13);
INSERT INTO public.study_program_study_program_variant VALUES (608, 14);
INSERT INTO public.study_program_study_program_variant VALUES (609, 10);
INSERT INTO public.study_program_study_program_variant VALUES (609, 14);
INSERT INTO public.study_program_study_program_variant VALUES (610, 11);
INSERT INTO public.study_program_study_program_variant VALUES (610, 8);
INSERT INTO public.study_program_study_program_variant VALUES (611, 16);
INSERT INTO public.study_program_study_program_variant VALUES (611, 17);
INSERT INTO public.study_program_study_program_variant VALUES (612, 12);
INSERT INTO public.study_program_study_program_variant VALUES (612, 13);
INSERT INTO public.study_program_study_program_variant VALUES (615, 2);
INSERT INTO public.study_program_study_program_variant VALUES (615, 13);
INSERT INTO public.study_program_study_program_variant VALUES (615, 12);
INSERT INTO public.study_program_study_program_variant VALUES (615, 3);
INSERT INTO public.study_program_study_program_variant VALUES (614, 10);
INSERT INTO public.study_program_study_program_variant VALUES (614, 8);
INSERT INTO public.study_program_study_program_variant VALUES (614, 3);
INSERT INTO public.study_program_study_program_variant VALUES (614, 2);
INSERT INTO public.study_program_study_program_variant VALUES (614, 13);
INSERT INTO public.study_program_study_program_variant VALUES (614, 12);
INSERT INTO public.study_program_study_program_variant VALUES (613, 11);
INSERT INTO public.study_program_study_program_variant VALUES (613, 2);
INSERT INTO public.study_program_study_program_variant VALUES (613, 13);
INSERT INTO public.study_program_study_program_variant VALUES (613, 3);
INSERT INTO public.study_program_study_program_variant VALUES (613, 12);
INSERT INTO public.study_program_study_program_variant VALUES (616, 10);
INSERT INTO public.study_program_study_program_variant VALUES (617, 26);
INSERT INTO public.study_program_study_program_variant VALUES (617, 5);
INSERT INTO public.study_program_study_program_variant VALUES (617, 1);
INSERT INTO public.study_program_study_program_variant VALUES (617, 11);
INSERT INTO public.study_program_study_program_variant VALUES (618, 2);
INSERT INTO public.study_program_study_program_variant VALUES (618, 10);
INSERT INTO public.study_program_study_program_variant VALUES (618, 11);
INSERT INTO public.study_program_study_program_variant VALUES (618, 16);
INSERT INTO public.study_program_study_program_variant VALUES (618, 3);
INSERT INTO public.study_program_study_program_variant VALUES (618, 17);
INSERT INTO public.study_program_study_program_variant VALUES (619, 11);
INSERT INTO public.study_program_study_program_variant VALUES (620, 59);
INSERT INTO public.study_program_study_program_variant VALUES (620, 60);
INSERT INTO public.study_program_study_program_variant VALUES (621, 61);
INSERT INTO public.study_program_study_program_variant VALUES (621, 62);
INSERT INTO public.study_program_study_program_variant VALUES (622, 62);
INSERT INTO public.study_program_study_program_variant VALUES (622, 61);
INSERT INTO public.study_program_study_program_variant VALUES (623, 2);
INSERT INTO public.study_program_study_program_variant VALUES (623, 12);
INSERT INTO public.study_program_study_program_variant VALUES (623, 13);
INSERT INTO public.study_program_study_program_variant VALUES (623, 3);
INSERT INTO public.study_program_study_program_variant VALUES (624, 12);
INSERT INTO public.study_program_study_program_variant VALUES (624, 2);
INSERT INTO public.study_program_study_program_variant VALUES (624, 13);
INSERT INTO public.study_program_study_program_variant VALUES (624, 3);
INSERT INTO public.study_program_study_program_variant VALUES (625, 3);
INSERT INTO public.study_program_study_program_variant VALUES (625, 2);
INSERT INTO public.study_program_study_program_variant VALUES (625, 13);
INSERT INTO public.study_program_study_program_variant VALUES (625, 12);
INSERT INTO public.study_program_study_program_variant VALUES (626, 13);
INSERT INTO public.study_program_study_program_variant VALUES (626, 3);
INSERT INTO public.study_program_study_program_variant VALUES (626, 2);
INSERT INTO public.study_program_study_program_variant VALUES (626, 12);
INSERT INTO public.study_program_study_program_variant VALUES (627, 63);
INSERT INTO public.study_program_study_program_variant VALUES (627, 64);
INSERT INTO public.study_program_study_program_variant VALUES (628, 14);
INSERT INTO public.study_program_study_program_variant VALUES (628, 10);
INSERT INTO public.study_program_study_program_variant VALUES (629, 65);
INSERT INTO public.study_program_study_program_variant VALUES (629, 66);
INSERT INTO public.study_program_study_program_variant VALUES (630, 13);
INSERT INTO public.study_program_study_program_variant VALUES (630, 12);
INSERT INTO public.study_program_study_program_variant VALUES (631, 12);
INSERT INTO public.study_program_study_program_variant VALUES (631, 13);
INSERT INTO public.study_program_study_program_variant VALUES (632, 12);
INSERT INTO public.study_program_study_program_variant VALUES (632, 13);
INSERT INTO public.study_program_study_program_variant VALUES (633, 13);
INSERT INTO public.study_program_study_program_variant VALUES (633, 12);
INSERT INTO public.study_program_study_program_variant VALUES (634, 10);
INSERT INTO public.study_program_study_program_variant VALUES (634, 14);
INSERT INTO public.study_program_study_program_variant VALUES (635, 10);
INSERT INTO public.study_program_study_program_variant VALUES (635, 14);
INSERT INTO public.study_program_study_program_variant VALUES (636, 10);
INSERT INTO public.study_program_study_program_variant VALUES (637, 10);
INSERT INTO public.study_program_study_program_variant VALUES (638, 10);
INSERT INTO public.study_program_study_program_variant VALUES (639, 10);
INSERT INTO public.study_program_study_program_variant VALUES (640, 10);
INSERT INTO public.study_program_study_program_variant VALUES (641, 10);
INSERT INTO public.study_program_study_program_variant VALUES (642, 10);
INSERT INTO public.study_program_study_program_variant VALUES (643, 10);
INSERT INTO public.study_program_study_program_variant VALUES (644, 10);
INSERT INTO public.study_program_study_program_variant VALUES (645, 13);
INSERT INTO public.study_program_study_program_variant VALUES (645, 12);
INSERT INTO public.study_program_study_program_variant VALUES (645, 10);
INSERT INTO public.study_program_study_program_variant VALUES (645, 14);
INSERT INTO public.study_program_study_program_variant VALUES (646, 15);
INSERT INTO public.study_program_study_program_variant VALUES (646, 4);
INSERT INTO public.study_program_study_program_variant VALUES (646, 8);
INSERT INTO public.study_program_study_program_variant VALUES (647, 16);
INSERT INTO public.study_program_study_program_variant VALUES (647, 17);
INSERT INTO public.study_program_study_program_variant VALUES (647, 15);
INSERT INTO public.study_program_study_program_variant VALUES (647, 2);
INSERT INTO public.study_program_study_program_variant VALUES (647, 8);
INSERT INTO public.study_program_study_program_variant VALUES (647, 3);
INSERT INTO public.study_program_study_program_variant VALUES (649, 25);
INSERT INTO public.study_program_study_program_variant VALUES (649, 10);
INSERT INTO public.study_program_study_program_variant VALUES (649, 14);
INSERT INTO public.study_program_study_program_variant VALUES (649, 42);
INSERT INTO public.study_program_study_program_variant VALUES (648, 7);
INSERT INTO public.study_program_study_program_variant VALUES (648, 14);
INSERT INTO public.study_program_study_program_variant VALUES (648, 42);
INSERT INTO public.study_program_study_program_variant VALUES (648, 10);
INSERT INTO public.study_program_study_program_variant VALUES (648, 25);
INSERT INTO public.study_program_study_program_variant VALUES (648, 13);
INSERT INTO public.study_program_study_program_variant VALUES (648, 3);
INSERT INTO public.study_program_study_program_variant VALUES (648, 12);
INSERT INTO public.study_program_study_program_variant VALUES (648, 2);
INSERT INTO public.study_program_study_program_variant VALUES (650, 42);
INSERT INTO public.study_program_study_program_variant VALUES (650, 14);
INSERT INTO public.study_program_study_program_variant VALUES (651, 3);
INSERT INTO public.study_program_study_program_variant VALUES (651, 2);
INSERT INTO public.study_program_study_program_variant VALUES (651, 12);
INSERT INTO public.study_program_study_program_variant VALUES (651, 13);
INSERT INTO public.study_program_study_program_variant VALUES (652, 16);
INSERT INTO public.study_program_study_program_variant VALUES (652, 17);
INSERT INTO public.study_program_study_program_variant VALUES (653, 3);
INSERT INTO public.study_program_study_program_variant VALUES (653, 1);
INSERT INTO public.study_program_study_program_variant VALUES (654, 11);
INSERT INTO public.study_program_study_program_variant VALUES (654, 10);
INSERT INTO public.study_program_study_program_variant VALUES (655, 13);
INSERT INTO public.study_program_study_program_variant VALUES (655, 3);
INSERT INTO public.study_program_study_program_variant VALUES (655, 2);
INSERT INTO public.study_program_study_program_variant VALUES (655, 12);
INSERT INTO public.study_program_study_program_variant VALUES (656, 14);
INSERT INTO public.study_program_study_program_variant VALUES (657, 67);
INSERT INTO public.study_program_study_program_variant VALUES (657, 68);
INSERT INTO public.study_program_study_program_variant VALUES (658, 4);
INSERT INTO public.study_program_study_program_variant VALUES (658, 10);
INSERT INTO public.study_program_study_program_variant VALUES (658, 11);
INSERT INTO public.study_program_study_program_variant VALUES (658, 1);
INSERT INTO public.study_program_study_program_variant VALUES (660, 11);
INSERT INTO public.study_program_study_program_variant VALUES (659, 20);
INSERT INTO public.study_program_study_program_variant VALUES (659, 10);
INSERT INTO public.study_program_study_program_variant VALUES (659, 17);
INSERT INTO public.study_program_study_program_variant VALUES (659, 16);
INSERT INTO public.study_program_study_program_variant VALUES (661, 4);
INSERT INTO public.study_program_study_program_variant VALUES (661, 10);
INSERT INTO public.study_program_study_program_variant VALUES (661, 11);
INSERT INTO public.study_program_study_program_variant VALUES (661, 13);
INSERT INTO public.study_program_study_program_variant VALUES (661, 12);
INSERT INTO public.study_program_study_program_variant VALUES (663, 16);
INSERT INTO public.study_program_study_program_variant VALUES (663, 17);
INSERT INTO public.study_program_study_program_variant VALUES (662, 13);
INSERT INTO public.study_program_study_program_variant VALUES (662, 12);
INSERT INTO public.study_program_study_program_variant VALUES (664, 2);
INSERT INTO public.study_program_study_program_variant VALUES (664, 3);
INSERT INTO public.study_program_study_program_variant VALUES (665, 26);
INSERT INTO public.study_program_study_program_variant VALUES (665, 25);
INSERT INTO public.study_program_study_program_variant VALUES (666, 10);
INSERT INTO public.study_program_study_program_variant VALUES (667, 12);
INSERT INTO public.study_program_study_program_variant VALUES (667, 13);
INSERT INTO public.study_program_study_program_variant VALUES (668, 69);
INSERT INTO public.study_program_study_program_variant VALUES (668, 70);
INSERT INTO public.study_program_study_program_variant VALUES (669, 11);
INSERT INTO public.study_program_study_program_variant VALUES (669, 1);
INSERT INTO public.study_program_study_program_variant VALUES (670, 8);
INSERT INTO public.study_program_study_program_variant VALUES (670, 4);
INSERT INTO public.study_program_study_program_variant VALUES (671, 8);
INSERT INTO public.study_program_study_program_variant VALUES (671, 4);
INSERT INTO public.study_program_study_program_variant VALUES (672, 17);
INSERT INTO public.study_program_study_program_variant VALUES (672, 16);
INSERT INTO public.study_program_study_program_variant VALUES (672, 20);
INSERT INTO public.study_program_study_program_variant VALUES (673, 11);
INSERT INTO public.study_program_study_program_variant VALUES (674, 10);
INSERT INTO public.study_program_study_program_variant VALUES (675, 20);
INSERT INTO public.study_program_study_program_variant VALUES (676, 11);
INSERT INTO public.study_program_study_program_variant VALUES (676, 25);
INSERT INTO public.study_program_study_program_variant VALUES (676, 26);
INSERT INTO public.study_program_study_program_variant VALUES (676, 13);
INSERT INTO public.study_program_study_program_variant VALUES (676, 10);
INSERT INTO public.study_program_study_program_variant VALUES (676, 12);
INSERT INTO public.study_program_study_program_variant VALUES (677, 25);
INSERT INTO public.study_program_study_program_variant VALUES (677, 10);
INSERT INTO public.study_program_study_program_variant VALUES (677, 26);
INSERT INTO public.study_program_study_program_variant VALUES (677, 11);
INSERT INTO public.study_program_study_program_variant VALUES (677, 4);
INSERT INTO public.study_program_study_program_variant VALUES (677, 1);
INSERT INTO public.study_program_study_program_variant VALUES (678, 13);
INSERT INTO public.study_program_study_program_variant VALUES (678, 3);
INSERT INTO public.study_program_study_program_variant VALUES (678, 2);
INSERT INTO public.study_program_study_program_variant VALUES (678, 12);
INSERT INTO public.study_program_study_program_variant VALUES (679, 17);
INSERT INTO public.study_program_study_program_variant VALUES (679, 16);
INSERT INTO public.study_program_study_program_variant VALUES (679, 2);
INSERT INTO public.study_program_study_program_variant VALUES (679, 11);
INSERT INTO public.study_program_study_program_variant VALUES (679, 3);
INSERT INTO public.study_program_study_program_variant VALUES (680, 10);
INSERT INTO public.study_program_study_program_variant VALUES (681, 11);
INSERT INTO public.study_program_study_program_variant VALUES (681, 10);
INSERT INTO public.study_program_study_program_variant VALUES (682, 11);
INSERT INTO public.study_program_study_program_variant VALUES (682, 1);
INSERT INTO public.study_program_study_program_variant VALUES (683, 27);
INSERT INTO public.study_program_study_program_variant VALUES (684, 10);
INSERT INTO public.study_program_study_program_variant VALUES (685, 16);
INSERT INTO public.study_program_study_program_variant VALUES (685, 17);
INSERT INTO public.study_program_study_program_variant VALUES (686, 20);
INSERT INTO public.study_program_study_program_variant VALUES (687, 17);
INSERT INTO public.study_program_study_program_variant VALUES (687, 16);
INSERT INTO public.study_program_study_program_variant VALUES (687, 2);
INSERT INTO public.study_program_study_program_variant VALUES (687, 3);
INSERT INTO public.study_program_study_program_variant VALUES (688, 2);
INSERT INTO public.study_program_study_program_variant VALUES (688, 13);
INSERT INTO public.study_program_study_program_variant VALUES (688, 12);
INSERT INTO public.study_program_study_program_variant VALUES (688, 3);
INSERT INTO public.study_program_study_program_variant VALUES (689, 14);
INSERT INTO public.study_program_study_program_variant VALUES (689, 12);
INSERT INTO public.study_program_study_program_variant VALUES (689, 13);
INSERT INTO public.study_program_study_program_variant VALUES (690, 2);
INSERT INTO public.study_program_study_program_variant VALUES (690, 12);
INSERT INTO public.study_program_study_program_variant VALUES (690, 3);
INSERT INTO public.study_program_study_program_variant VALUES (690, 13);
INSERT INTO public.study_program_study_program_variant VALUES (691, 7);
INSERT INTO public.study_program_study_program_variant VALUES (691, 15);
INSERT INTO public.study_program_study_program_variant VALUES (692, 2);
INSERT INTO public.study_program_study_program_variant VALUES (692, 3);
INSERT INTO public.study_program_study_program_variant VALUES (692, 17);
INSERT INTO public.study_program_study_program_variant VALUES (692, 16);
INSERT INTO public.study_program_study_program_variant VALUES (694, 13);
INSERT INTO public.study_program_study_program_variant VALUES (694, 12);
INSERT INTO public.study_program_study_program_variant VALUES (693, 12);
INSERT INTO public.study_program_study_program_variant VALUES (693, 3);
INSERT INTO public.study_program_study_program_variant VALUES (693, 13);
INSERT INTO public.study_program_study_program_variant VALUES (693, 2);
INSERT INTO public.study_program_study_program_variant VALUES (696, 12);
INSERT INTO public.study_program_study_program_variant VALUES (696, 13);
INSERT INTO public.study_program_study_program_variant VALUES (695, 16);
INSERT INTO public.study_program_study_program_variant VALUES (695, 2);
INSERT INTO public.study_program_study_program_variant VALUES (695, 17);
INSERT INTO public.study_program_study_program_variant VALUES (695, 3);
INSERT INTO public.study_program_study_program_variant VALUES (698, 13);
INSERT INTO public.study_program_study_program_variant VALUES (698, 12);
INSERT INTO public.study_program_study_program_variant VALUES (697, 3);
INSERT INTO public.study_program_study_program_variant VALUES (697, 16);
INSERT INTO public.study_program_study_program_variant VALUES (697, 17);
INSERT INTO public.study_program_study_program_variant VALUES (697, 2);
INSERT INTO public.study_program_study_program_variant VALUES (699, 3);
INSERT INTO public.study_program_study_program_variant VALUES (699, 12);
INSERT INTO public.study_program_study_program_variant VALUES (699, 2);
INSERT INTO public.study_program_study_program_variant VALUES (699, 13);
INSERT INTO public.study_program_study_program_variant VALUES (700, 16);
INSERT INTO public.study_program_study_program_variant VALUES (700, 17);
INSERT INTO public.study_program_study_program_variant VALUES (700, 2);
INSERT INTO public.study_program_study_program_variant VALUES (700, 3);
INSERT INTO public.study_program_study_program_variant VALUES (701, 13);
INSERT INTO public.study_program_study_program_variant VALUES (701, 3);
INSERT INTO public.study_program_study_program_variant VALUES (701, 12);
INSERT INTO public.study_program_study_program_variant VALUES (701, 2);
INSERT INTO public.study_program_study_program_variant VALUES (702, 3);
INSERT INTO public.study_program_study_program_variant VALUES (702, 2);
INSERT INTO public.study_program_study_program_variant VALUES (702, 12);
INSERT INTO public.study_program_study_program_variant VALUES (702, 13);
INSERT INTO public.study_program_study_program_variant VALUES (703, 3);
INSERT INTO public.study_program_study_program_variant VALUES (703, 13);
INSERT INTO public.study_program_study_program_variant VALUES (703, 12);
INSERT INTO public.study_program_study_program_variant VALUES (703, 2);
INSERT INTO public.study_program_study_program_variant VALUES (704, 16);
INSERT INTO public.study_program_study_program_variant VALUES (704, 2);
INSERT INTO public.study_program_study_program_variant VALUES (704, 17);
INSERT INTO public.study_program_study_program_variant VALUES (705, 16);
INSERT INTO public.study_program_study_program_variant VALUES (705, 17);
INSERT INTO public.study_program_study_program_variant VALUES (706, 17);
INSERT INTO public.study_program_study_program_variant VALUES (706, 16);
INSERT INTO public.study_program_study_program_variant VALUES (707, 12);
INSERT INTO public.study_program_study_program_variant VALUES (707, 13);
INSERT INTO public.study_program_study_program_variant VALUES (708, 12);
INSERT INTO public.study_program_study_program_variant VALUES (708, 13);
INSERT INTO public.study_program_study_program_variant VALUES (709, 13);
INSERT INTO public.study_program_study_program_variant VALUES (709, 12);
INSERT INTO public.study_program_study_program_variant VALUES (709, 2);
INSERT INTO public.study_program_study_program_variant VALUES (709, 3);
INSERT INTO public.study_program_study_program_variant VALUES (710, 14);
INSERT INTO public.study_program_study_program_variant VALUES (710, 10);
INSERT INTO public.study_program_study_program_variant VALUES (711, 10);
INSERT INTO public.study_program_study_program_variant VALUES (711, 14);
INSERT INTO public.study_program_study_program_variant VALUES (712, 13);
INSERT INTO public.study_program_study_program_variant VALUES (712, 12);
INSERT INTO public.study_program_study_program_variant VALUES (713, 71);
INSERT INTO public.study_program_study_program_variant VALUES (714, 17);
INSERT INTO public.study_program_study_program_variant VALUES (714, 16);
INSERT INTO public.study_program_study_program_variant VALUES (715, 72);
INSERT INTO public.study_program_study_program_variant VALUES (716, 72);
INSERT INTO public.study_program_study_program_variant VALUES (717, 13);
INSERT INTO public.study_program_study_program_variant VALUES (717, 12);
INSERT INTO public.study_program_study_program_variant VALUES (718, 13);
INSERT INTO public.study_program_study_program_variant VALUES (718, 12);
INSERT INTO public.study_program_study_program_variant VALUES (718, 2);
INSERT INTO public.study_program_study_program_variant VALUES (718, 3);
INSERT INTO public.study_program_study_program_variant VALUES (720, 14);
INSERT INTO public.study_program_study_program_variant VALUES (719, 28);
INSERT INTO public.study_program_study_program_variant VALUES (719, 15);
INSERT INTO public.study_program_study_program_variant VALUES (719, 73);
INSERT INTO public.study_program_study_program_variant VALUES (719, 8);
INSERT INTO public.study_program_study_program_variant VALUES (721, 7);
INSERT INTO public.study_program_study_program_variant VALUES (721, 8);
INSERT INTO public.study_program_study_program_variant VALUES (722, 14);
INSERT INTO public.study_program_study_program_variant VALUES (723, 14);
INSERT INTO public.study_program_study_program_variant VALUES (724, 14);
INSERT INTO public.study_program_study_program_variant VALUES (725, 14);
INSERT INTO public.study_program_study_program_variant VALUES (726, 14);
INSERT INTO public.study_program_study_program_variant VALUES (727, 14);
INSERT INTO public.study_program_study_program_variant VALUES (728, 10);
INSERT INTO public.study_program_study_program_variant VALUES (728, 14);
INSERT INTO public.study_program_study_program_variant VALUES (729, 15);
INSERT INTO public.study_program_study_program_variant VALUES (730, 14);
INSERT INTO public.study_program_study_program_variant VALUES (731, 14);
INSERT INTO public.study_program_study_program_variant VALUES (732, 14);
INSERT INTO public.study_program_study_program_variant VALUES (733, 14);
INSERT INTO public.study_program_study_program_variant VALUES (734, 14);
INSERT INTO public.study_program_study_program_variant VALUES (734, 10);
INSERT INTO public.study_program_study_program_variant VALUES (735, 14);
INSERT INTO public.study_program_study_program_variant VALUES (736, 14);
INSERT INTO public.study_program_study_program_variant VALUES (737, 14);
INSERT INTO public.study_program_study_program_variant VALUES (738, 8);
INSERT INTO public.study_program_study_program_variant VALUES (738, 15);
INSERT INTO public.study_program_study_program_variant VALUES (739, 15);
INSERT INTO public.study_program_study_program_variant VALUES (740, 14);
INSERT INTO public.study_program_study_program_variant VALUES (741, 14);
INSERT INTO public.study_program_study_program_variant VALUES (742, 14);
INSERT INTO public.study_program_study_program_variant VALUES (743, 14);
INSERT INTO public.study_program_study_program_variant VALUES (743, 10);
INSERT INTO public.study_program_study_program_variant VALUES (744, 14);
INSERT INTO public.study_program_study_program_variant VALUES (745, 15);
INSERT INTO public.study_program_study_program_variant VALUES (745, 8);
INSERT INTO public.study_program_study_program_variant VALUES (746, 15);
INSERT INTO public.study_program_study_program_variant VALUES (747, 14);
INSERT INTO public.study_program_study_program_variant VALUES (748, 14);
INSERT INTO public.study_program_study_program_variant VALUES (749, 14);
INSERT INTO public.study_program_study_program_variant VALUES (750, 14);
INSERT INTO public.study_program_study_program_variant VALUES (751, 14);
INSERT INTO public.study_program_study_program_variant VALUES (752, 10);
INSERT INTO public.study_program_study_program_variant VALUES (752, 14);
INSERT INTO public.study_program_study_program_variant VALUES (753, 14);
INSERT INTO public.study_program_study_program_variant VALUES (754, 14);
INSERT INTO public.study_program_study_program_variant VALUES (755, 14);
INSERT INTO public.study_program_study_program_variant VALUES (756, 14);
INSERT INTO public.study_program_study_program_variant VALUES (757, 14);
INSERT INTO public.study_program_study_program_variant VALUES (757, 10);
INSERT INTO public.study_program_study_program_variant VALUES (758, 10);
INSERT INTO public.study_program_study_program_variant VALUES (758, 14);
INSERT INTO public.study_program_study_program_variant VALUES (759, 14);
INSERT INTO public.study_program_study_program_variant VALUES (760, 14);
INSERT INTO public.study_program_study_program_variant VALUES (761, 14);
INSERT INTO public.study_program_study_program_variant VALUES (762, 14);
INSERT INTO public.study_program_study_program_variant VALUES (763, 14);
INSERT INTO public.study_program_study_program_variant VALUES (764, 14);
INSERT INTO public.study_program_study_program_variant VALUES (765, 14);
INSERT INTO public.study_program_study_program_variant VALUES (766, 10);
INSERT INTO public.study_program_study_program_variant VALUES (768, 14);
INSERT INTO public.study_program_study_program_variant VALUES (767, 8);
INSERT INTO public.study_program_study_program_variant VALUES (767, 15);
INSERT INTO public.study_program_study_program_variant VALUES (769, 15);
INSERT INTO public.study_program_study_program_variant VALUES (770, 14);
INSERT INTO public.study_program_study_program_variant VALUES (771, 14);
INSERT INTO public.study_program_study_program_variant VALUES (772, 14);
INSERT INTO public.study_program_study_program_variant VALUES (773, 14);
INSERT INTO public.study_program_study_program_variant VALUES (774, 14);
INSERT INTO public.study_program_study_program_variant VALUES (775, 8);
INSERT INTO public.study_program_study_program_variant VALUES (775, 15);
INSERT INTO public.study_program_study_program_variant VALUES (776, 15);
INSERT INTO public.study_program_study_program_variant VALUES (777, 14);
INSERT INTO public.study_program_study_program_variant VALUES (778, 14);
INSERT INTO public.study_program_study_program_variant VALUES (779, 14);
INSERT INTO public.study_program_study_program_variant VALUES (780, 14);
INSERT INTO public.study_program_study_program_variant VALUES (781, 14);
INSERT INTO public.study_program_study_program_variant VALUES (782, 14);
INSERT INTO public.study_program_study_program_variant VALUES (783, 54);
INSERT INTO public.study_program_study_program_variant VALUES (783, 55);
INSERT INTO public.study_program_study_program_variant VALUES (784, 74);
INSERT INTO public.study_program_study_program_variant VALUES (784, 50);
INSERT INTO public.study_program_study_program_variant VALUES (784, 75);
INSERT INTO public.study_program_study_program_variant VALUES (784, 57);
INSERT INTO public.study_program_study_program_variant VALUES (785, 57);
INSERT INTO public.study_program_study_program_variant VALUES (785, 50);
INSERT INTO public.study_program_study_program_variant VALUES (786, 14);
INSERT INTO public.study_program_study_program_variant VALUES (787, 14);
INSERT INTO public.study_program_study_program_variant VALUES (788, 14);
INSERT INTO public.study_program_study_program_variant VALUES (789, 14);
INSERT INTO public.study_program_study_program_variant VALUES (790, 14);
INSERT INTO public.study_program_study_program_variant VALUES (791, 10);
INSERT INTO public.study_program_study_program_variant VALUES (791, 14);
INSERT INTO public.study_program_study_program_variant VALUES (792, 10);
INSERT INTO public.study_program_study_program_variant VALUES (792, 14);
INSERT INTO public.study_program_study_program_variant VALUES (793, 14);
INSERT INTO public.study_program_study_program_variant VALUES (793, 10);
INSERT INTO public.study_program_study_program_variant VALUES (794, 42);
INSERT INTO public.study_program_study_program_variant VALUES (794, 14);
INSERT INTO public.study_program_study_program_variant VALUES (795, 14);
INSERT INTO public.study_program_study_program_variant VALUES (796, 14);
INSERT INTO public.study_program_study_program_variant VALUES (797, 14);
INSERT INTO public.study_program_study_program_variant VALUES (798, 14);
INSERT INTO public.study_program_study_program_variant VALUES (799, 10);
INSERT INTO public.study_program_study_program_variant VALUES (799, 25);
INSERT INTO public.study_program_study_program_variant VALUES (800, 14);
INSERT INTO public.study_program_study_program_variant VALUES (801, 10);
INSERT INTO public.study_program_study_program_variant VALUES (801, 14);
INSERT INTO public.study_program_study_program_variant VALUES (803, 14);
INSERT INTO public.study_program_study_program_variant VALUES (802, 25);
INSERT INTO public.study_program_study_program_variant VALUES (802, 42);
INSERT INTO public.study_program_study_program_variant VALUES (802, 10);
INSERT INTO public.study_program_study_program_variant VALUES (802, 14);
INSERT INTO public.study_program_study_program_variant VALUES (804, 14);
INSERT INTO public.study_program_study_program_variant VALUES (805, 14);
INSERT INTO public.study_program_study_program_variant VALUES (806, 14);
INSERT INTO public.study_program_study_program_variant VALUES (807, 14);
INSERT INTO public.study_program_study_program_variant VALUES (808, 14);
INSERT INTO public.study_program_study_program_variant VALUES (809, 14);
INSERT INTO public.study_program_study_program_variant VALUES (810, 14);
INSERT INTO public.study_program_study_program_variant VALUES (811, 14);
INSERT INTO public.study_program_study_program_variant VALUES (812, 70);
INSERT INTO public.study_program_study_program_variant VALUES (812, 69);
INSERT INTO public.study_program_study_program_variant VALUES (813, 14);
INSERT INTO public.study_program_study_program_variant VALUES (813, 10);
INSERT INTO public.study_program_study_program_variant VALUES (815, 14);
INSERT INTO public.study_program_study_program_variant VALUES (814, 42);
INSERT INTO public.study_program_study_program_variant VALUES (814, 25);
INSERT INTO public.study_program_study_program_variant VALUES (814, 14);
INSERT INTO public.study_program_study_program_variant VALUES (814, 10);
INSERT INTO public.study_program_study_program_variant VALUES (816, 14);
INSERT INTO public.study_program_study_program_variant VALUES (817, 76);
INSERT INTO public.study_program_study_program_variant VALUES (817, 77);
INSERT INTO public.study_program_study_program_variant VALUES (818, 3);
INSERT INTO public.study_program_study_program_variant VALUES (818, 2);
INSERT INTO public.study_program_study_program_variant VALUES (818, 12);
INSERT INTO public.study_program_study_program_variant VALUES (818, 13);
INSERT INTO public.study_program_study_program_variant VALUES (819, 15);
INSERT INTO public.study_program_study_program_variant VALUES (820, 25);
INSERT INTO public.study_program_study_program_variant VALUES (820, 12);
INSERT INTO public.study_program_study_program_variant VALUES (820, 42);
INSERT INTO public.study_program_study_program_variant VALUES (820, 10);
INSERT INTO public.study_program_study_program_variant VALUES (820, 14);
INSERT INTO public.study_program_study_program_variant VALUES (820, 13);
INSERT INTO public.study_program_study_program_variant VALUES (822, 12);
INSERT INTO public.study_program_study_program_variant VALUES (822, 13);
INSERT INTO public.study_program_study_program_variant VALUES (822, 14);
INSERT INTO public.study_program_study_program_variant VALUES (822, 10);
INSERT INTO public.study_program_study_program_variant VALUES (822, 2);
INSERT INTO public.study_program_study_program_variant VALUES (822, 3);
INSERT INTO public.study_program_study_program_variant VALUES (821, 3);
INSERT INTO public.study_program_study_program_variant VALUES (821, 13);
INSERT INTO public.study_program_study_program_variant VALUES (821, 12);
INSERT INTO public.study_program_study_program_variant VALUES (821, 10);
INSERT INTO public.study_program_study_program_variant VALUES (821, 14);
INSERT INTO public.study_program_study_program_variant VALUES (821, 2);
INSERT INTO public.study_program_study_program_variant VALUES (823, 13);
INSERT INTO public.study_program_study_program_variant VALUES (823, 12);
INSERT INTO public.study_program_study_program_variant VALUES (823, 2);
INSERT INTO public.study_program_study_program_variant VALUES (823, 3);
INSERT INTO public.study_program_study_program_variant VALUES (825, 16);
INSERT INTO public.study_program_study_program_variant VALUES (825, 17);
INSERT INTO public.study_program_study_program_variant VALUES (824, 3);
INSERT INTO public.study_program_study_program_variant VALUES (824, 12);
INSERT INTO public.study_program_study_program_variant VALUES (824, 13);
INSERT INTO public.study_program_study_program_variant VALUES (824, 2);
INSERT INTO public.study_program_study_program_variant VALUES (826, 8);
INSERT INTO public.study_program_study_program_variant VALUES (827, 10);
INSERT INTO public.study_program_study_program_variant VALUES (827, 11);
INSERT INTO public.study_program_study_program_variant VALUES (828, 17);
INSERT INTO public.study_program_study_program_variant VALUES (828, 3);
INSERT INTO public.study_program_study_program_variant VALUES (828, 2);
INSERT INTO public.study_program_study_program_variant VALUES (828, 16);
INSERT INTO public.study_program_study_program_variant VALUES (829, 20);
INSERT INTO public.study_program_study_program_variant VALUES (829, 10);
INSERT INTO public.study_program_study_program_variant VALUES (830, 39);
INSERT INTO public.study_program_study_program_variant VALUES (830, 38);
INSERT INTO public.study_program_study_program_variant VALUES (830, 40);
INSERT INTO public.study_program_study_program_variant VALUES (830, 10);
INSERT INTO public.study_program_study_program_variant VALUES (831, 13);
INSERT INTO public.study_program_study_program_variant VALUES (831, 12);
INSERT INTO public.study_program_study_program_variant VALUES (831, 2);
INSERT INTO public.study_program_study_program_variant VALUES (831, 3);
INSERT INTO public.study_program_study_program_variant VALUES (832, 11);
INSERT INTO public.study_program_study_program_variant VALUES (832, 26);
INSERT INTO public.study_program_study_program_variant VALUES (832, 10);
INSERT INTO public.study_program_study_program_variant VALUES (832, 25);
INSERT INTO public.study_program_study_program_variant VALUES (832, 1);
INSERT INTO public.study_program_study_program_variant VALUES (832, 4);
INSERT INTO public.study_program_study_program_variant VALUES (833, 78);
INSERT INTO public.study_program_study_program_variant VALUES (833, 79);
INSERT INTO public.study_program_study_program_variant VALUES (834, 11);
INSERT INTO public.study_program_study_program_variant VALUES (835, 12);
INSERT INTO public.study_program_study_program_variant VALUES (835, 13);
INSERT INTO public.study_program_study_program_variant VALUES (836, 12);
INSERT INTO public.study_program_study_program_variant VALUES (836, 2);
INSERT INTO public.study_program_study_program_variant VALUES (836, 3);
INSERT INTO public.study_program_study_program_variant VALUES (836, 13);
INSERT INTO public.study_program_study_program_variant VALUES (837, 1);
INSERT INTO public.study_program_study_program_variant VALUES (837, 11);
INSERT INTO public.study_program_study_program_variant VALUES (839, 8);
INSERT INTO public.study_program_study_program_variant VALUES (838, 12);
INSERT INTO public.study_program_study_program_variant VALUES (838, 13);
INSERT INTO public.study_program_study_program_variant VALUES (840, 11);
INSERT INTO public.study_program_study_program_variant VALUES (841, 8);
INSERT INTO public.study_program_study_program_variant VALUES (842, 10);
INSERT INTO public.study_program_study_program_variant VALUES (842, 14);
INSERT INTO public.study_program_study_program_variant VALUES (843, 13);
INSERT INTO public.study_program_study_program_variant VALUES (843, 12);
INSERT INTO public.study_program_study_program_variant VALUES (844, 13);
INSERT INTO public.study_program_study_program_variant VALUES (844, 12);
INSERT INTO public.study_program_study_program_variant VALUES (847, 80);
INSERT INTO public.study_program_study_program_variant VALUES (847, 81);
INSERT INTO public.study_program_study_program_variant VALUES (846, 81);
INSERT INTO public.study_program_study_program_variant VALUES (846, 80);
INSERT INTO public.study_program_study_program_variant VALUES (845, 80);
INSERT INTO public.study_program_study_program_variant VALUES (845, 81);
INSERT INTO public.study_program_study_program_variant VALUES (848, 1);
INSERT INTO public.study_program_study_program_variant VALUES (848, 11);
INSERT INTO public.study_program_study_program_variant VALUES (849, 8);
INSERT INTO public.study_program_study_program_variant VALUES (849, 20);
INSERT INTO public.study_program_study_program_variant VALUES (850, 10);
INSERT INTO public.study_program_study_program_variant VALUES (851, 12);
INSERT INTO public.study_program_study_program_variant VALUES (851, 13);
INSERT INTO public.study_program_study_program_variant VALUES (851, 14);
INSERT INTO public.study_program_study_program_variant VALUES (852, 13);
INSERT INTO public.study_program_study_program_variant VALUES (852, 12);
INSERT INTO public.study_program_study_program_variant VALUES (852, 14);
INSERT INTO public.study_program_study_program_variant VALUES (854, 13);
INSERT INTO public.study_program_study_program_variant VALUES (854, 82);
INSERT INTO public.study_program_study_program_variant VALUES (854, 2);
INSERT INTO public.study_program_study_program_variant VALUES (854, 83);
INSERT INTO public.study_program_study_program_variant VALUES (854, 12);
INSERT INTO public.study_program_study_program_variant VALUES (854, 3);
INSERT INTO public.study_program_study_program_variant VALUES (855, 3);
INSERT INTO public.study_program_study_program_variant VALUES (855, 83);
INSERT INTO public.study_program_study_program_variant VALUES (855, 82);
INSERT INTO public.study_program_study_program_variant VALUES (855, 2);
INSERT INTO public.study_program_study_program_variant VALUES (855, 12);
INSERT INTO public.study_program_study_program_variant VALUES (855, 13);
INSERT INTO public.study_program_study_program_variant VALUES (853, 82);
INSERT INTO public.study_program_study_program_variant VALUES (853, 12);
INSERT INTO public.study_program_study_program_variant VALUES (853, 13);
INSERT INTO public.study_program_study_program_variant VALUES (856, 13);
INSERT INTO public.study_program_study_program_variant VALUES (856, 2);
INSERT INTO public.study_program_study_program_variant VALUES (856, 25);
INSERT INTO public.study_program_study_program_variant VALUES (856, 26);
INSERT INTO public.study_program_study_program_variant VALUES (856, 12);
INSERT INTO public.study_program_study_program_variant VALUES (856, 3);
INSERT INTO public.study_program_study_program_variant VALUES (856, 11);
INSERT INTO public.study_program_study_program_variant VALUES (856, 10);
INSERT INTO public.study_program_study_program_variant VALUES (857, 11);
INSERT INTO public.study_program_study_program_variant VALUES (857, 25);
INSERT INTO public.study_program_study_program_variant VALUES (857, 10);
INSERT INTO public.study_program_study_program_variant VALUES (858, 13);
INSERT INTO public.study_program_study_program_variant VALUES (858, 3);
INSERT INTO public.study_program_study_program_variant VALUES (858, 2);
INSERT INTO public.study_program_study_program_variant VALUES (858, 12);
INSERT INTO public.study_program_study_program_variant VALUES (859, 10);
INSERT INTO public.study_program_study_program_variant VALUES (859, 13);
INSERT INTO public.study_program_study_program_variant VALUES (860, 11);
INSERT INTO public.study_program_study_program_variant VALUES (862, 12);
INSERT INTO public.study_program_study_program_variant VALUES (862, 13);
INSERT INTO public.study_program_study_program_variant VALUES (861, 17);
INSERT INTO public.study_program_study_program_variant VALUES (861, 16);
INSERT INTO public.study_program_study_program_variant VALUES (863, 76);
INSERT INTO public.study_program_study_program_variant VALUES (863, 77);
INSERT INTO public.study_program_study_program_variant VALUES (864, 84);
INSERT INTO public.study_program_study_program_variant VALUES (864, 85);
INSERT INTO public.study_program_study_program_variant VALUES (864, 86);
INSERT INTO public.study_program_study_program_variant VALUES (864, 87);
INSERT INTO public.study_program_study_program_variant VALUES (864, 13);
INSERT INTO public.study_program_study_program_variant VALUES (864, 12);
INSERT INTO public.study_program_study_program_variant VALUES (865, 10);
INSERT INTO public.study_program_study_program_variant VALUES (866, 13);
INSERT INTO public.study_program_study_program_variant VALUES (866, 2);
INSERT INTO public.study_program_study_program_variant VALUES (866, 12);
INSERT INTO public.study_program_study_program_variant VALUES (866, 3);
INSERT INTO public.study_program_study_program_variant VALUES (867, 51);
INSERT INTO public.study_program_study_program_variant VALUES (867, 25);
INSERT INTO public.study_program_study_program_variant VALUES (867, 10);
INSERT INTO public.study_program_study_program_variant VALUES (867, 20);
INSERT INTO public.study_program_study_program_variant VALUES (868, 14);
INSERT INTO public.study_program_study_program_variant VALUES (868, 10);
INSERT INTO public.study_program_study_program_variant VALUES (869, 14);


--
-- Data for Name: study_program_variant; Type: TABLE DATA; Schema: public; Owner: user
--

INSERT INTO public.study_program_variant VALUES (1, 'anglický jazyk', 'FULL_TIME', 'Ing.');
INSERT INTO public.study_program_variant VALUES (2, 'anglický jazyk', 'PART_TIME', 'PhD.');
INSERT INTO public.study_program_variant VALUES (3, 'anglický jazyk', 'FULL_TIME', 'PhD.');
INSERT INTO public.study_program_variant VALUES (4, 'anglický jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (5, 'anglický jazyk', 'PART_TIME', 'Ing.');
INSERT INTO public.study_program_variant VALUES (6, 'anglický jazyk', 'PART_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (7, 'anglický jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (8, 'anglický jazyk,slovenský jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (9, 'anglický jazyk', 'FULL_TIME', 'MSc.');
INSERT INTO public.study_program_variant VALUES (10, 'slovenský jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (11, 'slovenský jazyk', 'FULL_TIME', 'Ing.');
INSERT INTO public.study_program_variant VALUES (12, 'slovenský jazyk', 'PART_TIME', 'PhD.');
INSERT INTO public.study_program_variant VALUES (13, 'slovenský jazyk', 'FULL_TIME', 'PhD.');
INSERT INTO public.study_program_variant VALUES (14, 'slovenský jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (15, 'anglický jazyk,slovenský jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (16, 'anglický jazyk,slovenský jazyk', 'FULL_TIME', 'PhD.');
INSERT INTO public.study_program_variant VALUES (17, 'anglický jazyk,slovenský jazyk', 'PART_TIME', 'PhD.');
INSERT INTO public.study_program_variant VALUES (18, '', 'PART_TIME', 'PhD.');
INSERT INTO public.study_program_variant VALUES (19, 'anglický jazyk,francúzsky jazyk,nemecký jazyk,ruský jazyk,slovenský jazyk,španielsky jazyk', 'FULL_TIME', 'PhD.');
INSERT INTO public.study_program_variant VALUES (20, 'anglický jazyk,slovenský jazyk', 'FULL_TIME', 'Ing.');
INSERT INTO public.study_program_variant VALUES (21, 'arabský jazyk,slovenský jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (22, 'arabský jazyk,slovenský jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (23, 'anglický jazyk', 'FULL_TIME', 'Ing. arch.');
INSERT INTO public.study_program_variant VALUES (24, 'slovenský jazyk', 'FULL_TIME', 'Ing. arch.');
INSERT INTO public.study_program_variant VALUES (25, 'slovenský jazyk', 'PART_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (26, 'slovenský jazyk', 'PART_TIME', 'Ing.');
INSERT INTO public.study_program_variant VALUES (27, 'anglický jazyk,slovenský jazyk,český jazyk', 'FULL_TIME', 'PhD.');
INSERT INTO public.study_program_variant VALUES (28, 'anglický jazyk,slovenský jazyk', 'PART_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (29, 'anglický jazyk', 'PART_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (30, 'bulharský jazyk,slovenský jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (31, 'bulharský jazyk,slovenský jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (32, 'anglický jazyk,nemecký jazyk,slovenský jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (33, 'anglický jazyk,francúzsky jazyk,slovenský jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (34, 'anglický jazyk,slovenský jazyk,španielsky jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (35, 'anglický jazyk,francúzsky jazyk,slovenský jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (36, 'anglický jazyk,nemecký jazyk,slovenský jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (37, 'anglický jazyk,slovenský jazyk,španielsky jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (38, 'slovenský jazyk', 'FULL_TIME', 'ArtD.');
INSERT INTO public.study_program_variant VALUES (39, 'slovenský jazyk', 'PART_TIME', 'ArtD.');
INSERT INTO public.study_program_variant VALUES (40, 'slovenský jazyk', 'FULL_TIME', 'Mgr. art.');
INSERT INTO public.study_program_variant VALUES (41, 'anglický jazyk,nemecký jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (42, 'slovenský jazyk', 'PART_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (43, 'francúzsky jazyk,slovenský jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (44, 'francúzsky jazyk,slovenský jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (45, 'holandský jazyk,nemecký jazyk,slovenský jazyk,švédsky jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (46, 'holandský jazyk,nemecký jazyk,slovenský jazyk,švédsky jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (47, 'holandský jazyk,slovenský jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (48, 'holandský jazyk,slovenský jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (49, 'anglický jazyk,slovenský jazyk,český jazyk', 'FULL_TIME', 'Ing.');
INSERT INTO public.study_program_variant VALUES (50, 'nemecký jazyk,slovenský jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (51, 'anglický jazyk,slovenský jazyk', 'PART_TIME', 'Ing.');
INSERT INTO public.study_program_variant VALUES (52, 'maďarský jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (53, 'maďarský jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (54, 'maďarský jazyk,slovenský jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (55, 'maďarský jazyk,slovenský jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (56, 'anglický jazyk,francúzsky jazyk,nemecký jazyk,slovenský jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (57, 'nemecký jazyk,slovenský jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (58, 'anglický jazyk,ruský jazyk,slovenský jazyk', 'FULL_TIME', 'Ing.');
INSERT INTO public.study_program_variant VALUES (59, 'francúzsky jazyk,portugalský jazyk,rumunský jazyk,slovenský jazyk,španielsky jazyk,taliansky jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (60, 'francúzsky jazyk,portugalský jazyk,rumunský jazyk,slovenský jazyk,španielsky jazyk,taliansky jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (61, 'ruský jazyk,slovenský jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (62, 'ruský jazyk,slovenský jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (63, 'ruský jazyk,slovenský jazyk', 'PART_TIME', 'PhD.');
INSERT INTO public.study_program_variant VALUES (64, 'ruský jazyk,slovenský jazyk', 'FULL_TIME', 'PhD.');
INSERT INTO public.study_program_variant VALUES (65, 'bulharský jazyk,chorvátsky jazyk,poľský jazyk,slovenský jazyk,slovinský jazyk,srbský jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (66, 'bulharský jazyk,chorvátsky jazyk,poľský jazyk,slovenský jazyk,slovinský jazyk,srbský jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (67, 'poľský jazyk,slovenský jazyk,český jazyk,slovinský jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (68, 'anglický jazyk,maďarský jazyk,nemecký jazyk,poľský jazyk,slovenský jazyk,slovinský jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (69, 'slovenský jazyk,taliansky jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (70, 'slovenský jazyk,taliansky jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (71, 'anglický jazyk,slovenský jazyk', 'FULL_TIME', 'Mgr. art.');
INSERT INTO public.study_program_variant VALUES (72, 'anglický jazyk,slovenský jazyk', 'FULL_TIME', 'Ing. arch.');
INSERT INTO public.study_program_variant VALUES (73, 'anglický jazyk,slovenský jazyk', 'PART_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (74, 'nemecký jazyk,slovenský jazyk', 'PART_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (75, 'nemecký jazyk,slovenský jazyk', 'PART_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (76, 'slovenský jazyk,španielsky jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (77, 'slovenský jazyk,španielsky jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (78, 'slovenský jazyk,japonský jazyk,čínsky jazyk,kórejský jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (79, 'slovenský jazyk,japonský jazyk,čínsky jazyk,kórejský jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (80, 'anglický jazyk', 'FULL_TIME', 'MUDr.');
INSERT INTO public.study_program_variant VALUES (81, 'slovenský jazyk', 'FULL_TIME', 'MUDr.');
INSERT INTO public.study_program_variant VALUES (82, 'slovenský jazyk', 'FULL_TIME', 'MDDr.');
INSERT INTO public.study_program_variant VALUES (83, 'anglický jazyk', 'FULL_TIME', 'MDDr.');
INSERT INTO public.study_program_variant VALUES (84, 'slovenský jazyk,český jazyk', 'FULL_TIME', 'Mgr.');
INSERT INTO public.study_program_variant VALUES (85, 'slovenský jazyk,český jazyk', 'PART_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (86, 'slovenský jazyk,český jazyk', 'FULL_TIME', 'Bc.');
INSERT INTO public.study_program_variant VALUES (87, 'slovenský jazyk,český jazyk', 'PART_TIME', 'Mgr.');


--
-- Data for Name: university; Type: TABLE DATA; Schema: public; Owner: user
--

INSERT INTO public.university VALUES (1, 'Technická univerzita v Košiciach', 'student.tuke.sk');
INSERT INTO public.university VALUES (2, 'Žilinská univerzita v Žiline', 'stud.uniza.sk');
INSERT INTO public.university VALUES (3, 'Univerzita Komenského v Bratislave', 'uniba.sk');
INSERT INTO public.university VALUES (4, 'Ekonomická univerzita v Bratislave', 'student.euba.sk');
INSERT INTO public.university VALUES (5, 'Slovenská technická univerzita v Bratislave', 'stuba.sk');
INSERT INTO public.university VALUES (6, 'Univerzita Pavla Jozefa Šafárika v Košiciach', 'student.upjs.sk');


--
-- Data for Name: user_education; Type: TABLE DATA; Schema: public; Owner: user
--

INSERT INTO public.user_education VALUES (1, 'ENROLLED', 83, 11, 'ff129217-d4d3-4e53-b8ef-12fe9bad1657');
INSERT INTO public.user_education VALUES (2, 'ENROLLED', 57, 1, '4f509766-2f3e-49f5-a088-a7a1b6ae5f06');
INSERT INTO public.user_education VALUES (3, 'ENROLLED', 170, 16, 'c4f36c3f-96e1-4f8a-a5d3-a2c4a39db7b1');


--
-- Name: faculty_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.faculty_id_seq', 47, true);


--
-- Name: review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.review_id_seq', 3, true);


--
-- Name: study_program_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.study_program_id_seq', 869, true);


--
-- Name: study_program_variant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.study_program_variant_id_seq', 87, true);


--
-- Name: university_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.university_id_seq', 6, true);


--
-- Name: user_education_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.user_education_id_seq', 3, true);


--
-- Name: app_user app_user_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.app_user
    ADD CONSTRAINT app_user_pkey PRIMARY KEY (id);


--
-- Name: faculty faculty_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.faculty
    ADD CONSTRAINT faculty_pkey PRIMARY KEY (id);


--
-- Name: review review_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.review
    ADD CONSTRAINT review_pkey PRIMARY KEY (id);


--
-- Name: study_program study_program_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.study_program
    ADD CONSTRAINT study_program_pkey PRIMARY KEY (id);


--
-- Name: study_program_variant study_program_variant_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.study_program_variant
    ADD CONSTRAINT study_program_variant_pkey PRIMARY KEY (id);


--
-- Name: app_user uk1j9d9a06i600gd43uu3km82jw; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.app_user
    ADD CONSTRAINT uk1j9d9a06i600gd43uu3km82jw UNIQUE (email);


--
-- Name: review uk_review_user_program; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.review
    ADD CONSTRAINT uk_review_user_program UNIQUE (user_id, study_program_id);


--
-- Name: study_program_variant ukey4t9937e9h395lv9i4rpfic3; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.study_program_variant
    ADD CONSTRAINT ukey4t9937e9h395lv9i4rpfic3 UNIQUE (language, study_form, title);


--
-- Name: university ukfvtw0p17nv23wqyviitui41a9; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.university
    ADD CONSTRAINT ukfvtw0p17nv23wqyviitui41a9 UNIQUE (university_email_domain);


--
-- Name: faculty ukgwljg7p88cg96uan9osjipot9; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.faculty
    ADD CONSTRAINT ukgwljg7p88cg96uan9osjipot9 UNIQUE (university_id, name);


--
-- Name: university ukru212k5vib3yvu360fuy3h1g5; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.university
    ADD CONSTRAINT ukru212k5vib3yvu360fuy3h1g5 UNIQUE (name);


--
-- Name: university university_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.university
    ADD CONSTRAINT university_pkey PRIMARY KEY (id);


--
-- Name: user_education user_education_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.user_education
    ADD CONSTRAINT user_education_pkey PRIMARY KEY (id);


--
-- Name: study_program fk48g3nmfegilglqllax2cfjokq; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.study_program
    ADD CONSTRAINT fk48g3nmfegilglqllax2cfjokq FOREIGN KEY (faculty_id) REFERENCES public.faculty(id);


--
-- Name: user_education fk51obeorhqrynkktl2v92ew3gd; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.user_education
    ADD CONSTRAINT fk51obeorhqrynkktl2v92ew3gd FOREIGN KEY (user_id) REFERENCES public.app_user(id);


--
-- Name: review fka975g8id1wtw80rprash0h69p; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.review
    ADD CONSTRAINT fka975g8id1wtw80rprash0h69p FOREIGN KEY (study_program_variant_id) REFERENCES public.study_program_variant(id);


--
-- Name: review fkc7y0l3wac4n2ewm6a2uecd54c; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.review
    ADD CONSTRAINT fkc7y0l3wac4n2ewm6a2uecd54c FOREIGN KEY (user_id) REFERENCES public.app_user(id);


--
-- Name: study_program_study_program_variant fkhiwa2ps7r17xp64buaxyds6x5; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.study_program_study_program_variant
    ADD CONSTRAINT fkhiwa2ps7r17xp64buaxyds6x5 FOREIGN KEY (study_program_variant_id) REFERENCES public.study_program_variant(id);


--
-- Name: user_education fkhpolxn5tobqe2mal81sr0ucuw; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.user_education
    ADD CONSTRAINT fkhpolxn5tobqe2mal81sr0ucuw FOREIGN KEY (study_program_id) REFERENCES public.study_program(id);


--
-- Name: user_education fki2vuwhhphh7ftmu13r07icv5u; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.user_education
    ADD CONSTRAINT fki2vuwhhphh7ftmu13r07icv5u FOREIGN KEY (study_program_variant_id) REFERENCES public.study_program_variant(id);


--
-- Name: faculty fkivqbiytd9en6sk09duabc6scc; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.faculty
    ADD CONSTRAINT fkivqbiytd9en6sk09duabc6scc FOREIGN KEY (university_id) REFERENCES public.university(id);


--
-- Name: review fkkbomyw1m8bhfmhav3qc70ut8l; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.review
    ADD CONSTRAINT fkkbomyw1m8bhfmhav3qc70ut8l FOREIGN KEY (study_program_id) REFERENCES public.study_program(id);


--
-- Name: study_program_study_program_variant fkrw5qu09op9xtpyuawp11jti45; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE IF EXISTS ONLY public.study_program_study_program_variant
    ADD CONSTRAINT fkrw5qu09op9xtpyuawp11jti45 FOREIGN KEY (study_program_id) REFERENCES public.study_program(id);


