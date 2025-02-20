--
-- PostgreSQL database dump
--

-- Dumped from database version 12.17 (Ubuntu 12.17-1.pgdg22.04+1)
-- Dumped by pg_dump version 12.17 (Ubuntu 12.17-1.pgdg22.04+1)

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

DROP DATABASE periodic_table;
--
-- Name: periodic_table; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE periodic_table WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8';


ALTER DATABASE periodic_table OWNER TO postgres;

\connect periodic_table

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: elements; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.elements (
    atomic_number integer NOT NULL,
    symbol character varying(2),
    name character varying(40)
);


ALTER TABLE public.elements OWNER TO freecodecamp;

--
-- Name: properties; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.properties (
    atomic_number integer NOT NULL,
    type character varying(30),
    weight numeric(9,6) NOT NULL,
    melting_point numeric,
    boiling_point numeric
);


ALTER TABLE public.properties OWNER TO freecodecamp;

--
-- Data for Name: elements; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.elements VALUES (1, 'H', 'Hydrogen');
INSERT INTO public.elements VALUES (2, 'he', 'Helium');
INSERT INTO public.elements VALUES (3, 'li', 'Lithium');
INSERT INTO public.elements VALUES (4, 'Be', 'Beryllium');
INSERT INTO public.elements VALUES (5, 'B', 'Boron');
INSERT INTO public.elements VALUES (6, 'C', 'Carbon');
INSERT INTO public.elements VALUES (7, 'N', 'Nitrogen');
INSERT INTO public.elements VALUES (8, 'O', 'Oxygen');
INSERT INTO public.elements VALUES (1000, 'mT', 'moTanium');


--
-- Data for Name: properties; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.properties VALUES (1, 'nonmetal', 1.008000, -259.1, -252.9);
INSERT INTO public.properties VALUES (2, 'nonmetal', 4.002600, -272.2, -269);
INSERT INTO public.properties VALUES (3, 'metal', 6.940000, 180.54, 1342);
INSERT INTO public.properties VALUES (4, 'metal', 9.012200, 1287, 2470);
INSERT INTO public.properties VALUES (5, 'metalloid', 10.810000, 2075, 4000);
INSERT INTO public.properties VALUES (6, 'nonmetal', 12.011000, 3550, 4027);
INSERT INTO public.properties VALUES (7, 'nonmetal', 14.007000, -210.1, -195.8);
INSERT INTO public.properties VALUES (8, 'nonmetal', 15.999000, -218, -183);
INSERT INTO public.properties VALUES (1000, 'metalloid', 1.000000, 10, 100);


--
-- Name: elements elements_atomic_number_key; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.elements
    ADD CONSTRAINT elements_atomic_number_key UNIQUE (atomic_number);


--
-- Name: elements elements_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.elements
    ADD CONSTRAINT elements_pkey PRIMARY KEY (atomic_number);


--
-- Name: properties properties_atomic_number_key; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_atomic_number_key UNIQUE (atomic_number);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (atomic_number);


--
-- PostgreSQL database dump complete
--


--
-- Database updates
--

alter table public.properties rename column weight to atomic_mass;

alter table public.properties rename melting_point to melting_point_celsius;

alter table public.properties rename boiling_point to boiling_point_celsius;

alter table public.properties alter column melting_point_celsius set not null;

alter table public.properties alter column boiling_point_celsius set not null;

alter table public.elements add unique (symbol);

alter table public.elements add unique (name);

alter table public.elements alter column symbol set not null;

alter table public.elements alter column name set not null;

alter table public.properties add constraint atomic_number_fk foreign key (atomic_number) references public.elements(atomic_number);

create table public.types(type_id serial not null unique primary key, type varchar(30) not null);
alter table types owner to freecodecamp;
insert into public.types (type) select distinct(type) from public.properties order by type;

alter table public.properties add column type_id int;

alter table public.properties add constraint type_id_fk foreign key (type_id) references public.types(type_id);
update public.properties set type_id=types.type_id from public.types where properties.type=types.type;
alter table public.properties alter column type_id set not null;

alter table public.properties drop column type;

update public.elements set symbol=concat(upper(left(symbol, 1)), substr(symbol, 2));

alter table public.properties alter column atomic_mass type real using atomic_mass::real;

delete from public.properties where atomic_number=1000;
delete from public.elements where atomic_number=1000;

insert into public.elements (atomic_number, symbol, name) values (9, 'F', 'Fluorine');
insert into public.properties (atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) values (9, 'nonmetal', 18.998, -220, -188.1, 3);

insert into public.elements (atomic_number, symbol, name) values (10, 'Ne', 'Neon');
insert into public.properties (atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) values (10, 'nonmetal', 20.18, -248.6, -246.1, 3);
