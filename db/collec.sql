--
-- WRITE by Christine Plumejeaud
-- initialize IRSTEA/collec database
-- 
--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.6
-- Dumped by pg_dump version 9.5.6

-- Started on 2017-07-18 10:14:22 CEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 13 (class 2615 OID 18175)
-- Name: col; Type: SCHEMA; Schema: -; Owner: collec
--

CREATE SCHEMA col;


ALTER SCHEMA col OWNER TO collec;

--
-- TOC entry 12 (class 2615 OID 18050)
-- Name: gacl; Type: SCHEMA; Schema: -; Owner: collec
--

CREATE SCHEMA gacl;


ALTER SCHEMA gacl OWNER TO collec;

--
-- TOC entry 14 (class 2615 OID 26965)
-- Name: zaalpes; Type: SCHEMA; Schema: -; Owner: collec
--

CREATE SCHEMA zaalpes;


ALTER SCHEMA zaalpes OWNER TO collec;

--
-- TOC entry 15 (class 2615 OID 35077)
-- Name: zapvs; Type: SCHEMA; Schema: -; Owner: collec
--

CREATE SCHEMA zapvs;


ALTER SCHEMA zapvs OWNER TO collec;

SET search_path = gacl, pg_catalog;

--
-- TOC entry 1667 (class 1255 OID 26884)
-- Name: create_groups(character varying, character varying); Type: FUNCTION; Schema: gacl; Owner: collec
--

CREATE FUNCTION create_groups(gacl_schema character varying, appli_name character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	appli_id INTEGER :=-1;
	aco_id INTEGER;
	group_id INTEGER;

	test VARCHAR;
	appli_table VARCHAR := gacl_schema||'.'||'aclappli';
	aco_table VARCHAR := gacl_schema||'.'||'aclaco';
	group_table VARCHAR := gacl_schema||'.'||'aclgroup';
	aco_group_table VARCHAR := gacl_schema||'.'||'aclacl';
	login_group_table VARCHAR := gacl_schema||'.'||'acllogingroup';
BEGIN
	-- Find the unique id of the appli in the schema gacl
	EXECUTE 'SELECT aclappli_id FROM '||appli_table||' where appli = '''||appli_name||''' ' INTO appli_id;
	-- raise notice 'Mon identifiant appli %', appli_id;

	IF appli_id is NULL THEN
	        BEGIN
			    RAISE NOTICE 'Insert application % into  %', appli_name, gacl_schema;
				EXECUTE 'INSERT  into '||appli_table||' (appli) values ('''||appli_name ||''')';
			EXCEPTION
				WHEN OTHERS THEN
					RAISE NOTICE 'Error during create_groups on insert application: % / %.', SQLERRM, SQLSTATE;
					RETURN -1;
			END;
	END IF;

	EXECUTE 'SELECT aclappli_id FROM '||appli_table||' where appli = '''||appli_name||''' ' INTO appli_id;
	raise notice 'Mon identifiant appli %', appli_id;

	-- First, insert new corresponding rights for this application (values are invariant, hardcoded in PHP code)
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''admin'');';
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''param'');';
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''projet'');';
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''gestion'');';
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''consult'');';


	-- Second, insert new groups for this application (values are free, but coded in a readable manner for this code)
	-- test := 'insert into '||group_table||'  (groupe) values ( ''param_group'');';
	--raise notice 'insert GROUP %', test;
	EXECUTE 'insert into '||group_table||'  (groupe) values ( ''admin_group'');';
	EXECUTE 'insert into '||group_table||'  (groupe) values ( ''param_group'');';
	EXECUTE 'insert into '||group_table||'  (groupe) values ( ''projet_group'');';
	EXECUTE 'insert into '||group_table||'  (groupe) values ( ''gestion_group'');';
	EXECUTE 'insert into '||group_table||'  (groupe) values ( ''consult_group'');';

	-- Third associate those group to their corresponding rights

	-- Associate the right ''admin'' with the admin_group
    EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''admin'' ' INTO aco_id ;
    EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''admin_group'' ' INTO group_id ;
    EXECUTE 'insert into '||aco_group_table||' (aclaco_id, aclgroup_id) values ('||aco_id||','||group_id||') ;';

	-- Associate the right ''param'' with the param_group
    EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''param'' ' INTO aco_id ;
    EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''param_group'' ' INTO group_id ;
    EXECUTE 'insert into '||aco_group_table||' (aclaco_id, aclgroup_id) values ('||aco_id||','||group_id||') ;';

    --  Associate the right ''projet'' with the projet_group
    EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''projet'' ' INTO aco_id ;
    EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''projet_group'' ' INTO group_id ;
    EXECUTE 'insert into '||aco_group_table||' (aclaco_id, aclgroup_id) values ('||aco_id||','||group_id||') ;';

    -- Associate  the right ''gestion'' with the gestion_group
    EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''gestion'' ' INTO aco_id ;
    EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''gestion_group'' ' INTO group_id ;
    EXECUTE 'insert into '||aco_group_table||' (aclaco_id, aclgroup_id) values ('||aco_id||','||group_id||') ;';

    --  Associate the right ''consult'' with the consult_group
    EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''consult'' ' INTO aco_id ;
    EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''consult_group'' ' INTO group_id ;
    EXECUTE 'insert into '||aco_group_table||' (aclaco_id, aclgroup_id) values ('||aco_id||','||group_id||') ;';

    RETURN appli_id;
END;
$$;


ALTER FUNCTION gacl.create_groups(gacl_schema character varying, appli_name character varying) OWNER TO collec;

--
-- TOC entry 1668 (class 1255 OID 26883)
-- Name: create_rights_for_user(character varying, character varying, integer); Type: FUNCTION; Schema: gacl; Owner: collec
--

CREATE FUNCTION create_rights_for_user(gacl_schema character varying, appli_name character varying, userid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	appli_id INTEGER;
	aco_id INTEGER;
	group_id INTEGER;

	test VARCHAR;
	appli_table VARCHAR := gacl_schema||'.'||'aclappli';
	aco_table VARCHAR := gacl_schema||'.'||'aclaco';
	group_table VARCHAR := gacl_schema||'.'||'aclgroup';
	aco_group_table VARCHAR := gacl_schema||'.'||'aclacl';
	login_group_table VARCHAR := gacl_schema||'.'||'acllogingroup';
BEGIN
	-- Find the unique id of the appli in the schema gacl
	EXECUTE 'SELECT aclappli_id FROM '||appli_table||' where appli = '''||appli_name||''' ' INTO appli_id;
	raise notice 'Mon identifiant appli %', appli_id;

	-- First, insert new corresponding rights for this application (values are invariant, hardcoded in PHP code)
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''admin'');';
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''param'');';
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''projet'');';
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''gestion'');';
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''consult'');';


	-- Second, insert new groups for this application (values are free, but coded in a readable manner for this code)
	-- test := 'insert into '||group_table||'  (groupe) values ( ''param_group'');';
	--raise notice 'insert GROUP %', test;
	EXECUTE 'insert into '||group_table||'  (groupe) values ( ''param_group'');';
	EXECUTE 'insert into '||group_table||'  (groupe) values ( ''projet_group'');';
	EXECUTE 'insert into '||group_table||'  (groupe) values ( ''gestion_group'');';
	EXECUTE 'insert into '||group_table||'  (groupe) values ( ''consult_group'');';

	-- Third associate those group to their corresponding rights and put the user admin into the group

	-- Associate the right ''param'' with the user
    EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''param'' ' INTO aco_id ;
    EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''param_group'' ' INTO group_id ;
    EXECUTE 'insert into '||aco_group_table||' (aclaco_id, aclgroup_id) values ('||aco_id||','||group_id||') ;';
    EXECUTE 'insert into '||login_group_table||' (acllogin_id, aclgroup_id) values ('||userid||','||group_id||') ;';

    --  Associate the right ''projet'' with the user
    EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''projet'' ' INTO aco_id ;
    EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''projet_group'' ' INTO group_id ;
    EXECUTE 'insert into '||aco_group_table||' (aclaco_id, aclgroup_id) values ('||aco_id||','||group_id||') ;';
    EXECUTE 'insert into '||login_group_table||' (acllogin_id, aclgroup_id) values ('||userid||','||group_id||') ;';

    -- Associate  the right ''gestion'' with the user
    EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''gestion'' ' INTO aco_id ;
    EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''gestion_group'' ' INTO group_id ;
    EXECUTE 'insert into '||aco_group_table||' (aclaco_id, aclgroup_id) values ('||aco_id||','||group_id||') ;';
    EXECUTE 'insert into '||login_group_table||' (acllogin_id, aclgroup_id) values ('||userid||','||group_id||') ;';

    --  Associate the right ''consult'' with the user
    EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''consult'' ' INTO aco_id ;
    EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''consult_group'' ' INTO group_id ;
    EXECUTE 'insert into '||aco_group_table||' (aclaco_id, aclgroup_id) values ('||aco_id||','||group_id||') ;';
    EXECUTE 'insert into '||login_group_table||' (acllogin_id, aclgroup_id) values ('||userid||','||group_id||') ;';

    RETURN appli_id;
END;
$$;


ALTER FUNCTION gacl.create_rights_for_user(gacl_schema character varying, appli_name character varying, userid integer) OWNER TO collec;

--
-- TOC entry 1669 (class 1255 OID 26885)
-- Name: set_rights_to_appli(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: gacl; Owner: collec
--

CREATE FUNCTION set_rights_to_appli(gacl_schema character varying, appli_name character varying, login character varying, level character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    userid INTEGER := -1;
	appli_id INTEGER;
	aco_id INTEGER;
	group_id INTEGER;

	test VARCHAR;
	login_table VARCHAR := gacl_schema||'.'||'acllogin';
	appli_table VARCHAR := gacl_schema||'.'||'aclappli';
	aco_table VARCHAR := gacl_schema||'.'||'aclaco';
	group_table VARCHAR := gacl_schema||'.'||'aclgroup';
	aco_group_table VARCHAR := gacl_schema||'.'||'aclacl';
	login_group_table VARCHAR := gacl_schema||'.'||'acllogingroup';
BEGIN
	-- First, Find the unique id of the appli in the schema gacl
	EXECUTE 'SELECT aclappli_id FROM '||appli_table||' where appli = '''||appli_name||''' ' INTO appli_id;
	raise notice 'Application identifier : %', appli_id;

	-- Second, Find the unique id of the user in the schema gacl
	-- insert into acllogin (acllogin_id, login, logindetail) values (1, 'admin', 'admin');
	EXECUTE 'SELECT acllogin_id FROM '||login_table||' where login = '''||login||''' ' INTO userid;
	raise notice 'User identifier :  %', userid;

	-- Third associate the user with the selected level of ACL

    if level = 'all' or level = 'admin'  THEN
        -- Associate the right ''admin'' with the user
        EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''admin'' ' INTO aco_id ;
        EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''admin_group'' ' INTO group_id ;
        EXECUTE 'insert into '||login_group_table||' (acllogin_id, aclgroup_id) values ('||userid||','||group_id||') ;';
    END IF;


    if level = 'all' or level = 'param'  THEN
        -- Associate the right ''param'' with the user
        EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''param'' ' INTO aco_id ;
        EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''param_group'' ' INTO group_id ;
        EXECUTE 'insert into '||login_group_table||' (acllogin_id, aclgroup_id) values ('||userid||','||group_id||') ;';
    END IF;

    if level = 'all' or level = 'projet'  THEN
        --  Associate the right ''projet'' with the user
        EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''projet'' ' INTO aco_id ;
        EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''projet_group'' ' INTO group_id ;
        EXECUTE 'insert into '||login_group_table||' (acllogin_id, aclgroup_id) values ('||userid||','||group_id||') ;';
    END IF;

    if level = 'all' or level = 'gestion'  THEN
        -- Associate  the right ''gestion'' with the user
        EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''gestion'' ' INTO aco_id ;
        EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''gestion_group'' ' INTO group_id ;
        EXECUTE 'insert into '||login_group_table||' (acllogin_id, aclgroup_id) values ('||userid||','||group_id||') ;';
    END IF;

    if level = 'all' or level = 'consult'  THEN
        --  Associate the right ''consult'' with the user
        EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''consult'' ' INTO aco_id ;
        EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''consult_group'' ' INTO group_id ;
        EXECUTE 'insert into '||login_group_table||' (acllogin_id, aclgroup_id) values ('||userid||','||group_id||') ;';
    END IF;

    RETURN userid;
END;
$$;


ALTER FUNCTION gacl.set_rights_to_appli(gacl_schema character varying, appli_name character varying, login character varying, level character varying) OWNER TO collec;

SET search_path = public, pg_catalog;

--
-- TOC entry 1666 (class 1255 OID 18688)
-- Name: create_rights_for_user(character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION create_rights_for_user(gacl_schema character varying, appli_name character varying, userid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	appli_id INTEGER;
	aco_id INTEGER;
	group_id INTEGER;

	test VARCHAR;
	appli_table VARCHAR := gacl_schema||'.'||'aclappli';
	aco_table VARCHAR := gacl_schema||'.'||'aclaco';
	group_table VARCHAR := gacl_schema||'.'||'aclgroup';
	aco_group_table VARCHAR := gacl_schema||'.'||'aclacl';
	login_group_table VARCHAR := gacl_schema||'.'||'acllogingroup';
BEGIN
    -- Find the unique id of the appli in the schema gacl
	EXECUTE 'SELECT aclappli_id FROM '||appli_table||' where appli = '''||appli_name||''' ' INTO appli_id;
	raise notice 'Mon identifiant appli %', appli_id;
	/*
	-- First, insert new corresponding rights for this application (values are invariant, hardcoded in PHP code)
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''admin'');';
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''param'');';
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''projet'');';
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''gestion'');';
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''consult'');';
	*/
	
	-- Second, insert new groups for this application (values are free, but coded in a readable manner for this code)
	test := 'insert into '||group_table||'  (groupe) values ( ''param_group'');';
	raise notice 'insert GROUP %', test;
	EXECUTE 'insert into '||group_table||'  (groupe) values ( ''param_group'');';
	EXECUTE 'insert into '||group_table||'  (groupe) values ( ''projet_group'');';
	EXECUTE 'insert into '||group_table||'  (groupe) values ( ''gestion_group'');';
	EXECUTE 'insert into '||group_table||'  (groupe) values ( ''consult_group'');';

	-- Third associate those group to their corresponding rights and put the user admin into the group

	-- First the right ''param''
	test := 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''param'' '  ;
	raise notice 'insert DROIT PARAM %', test;
    EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''param'' ' INTO aco_id ;
    EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''param_group'' ' INTO group_id ;
    EXECUTE 'insert into '||aco_group_table||' (aclaco_id, aclgroup_id) values ('||aco_id||','||group_id||') ;';
    EXECUTE 'insert into '||login_group_table||' (acllogin_id, aclgroup_id) values ('||userid||','||group_id||') ;';

    --  the right ''projet''
    EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''projet'' ' INTO aco_id ;
    EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''projet_group'' ' INTO group_id ;
    EXECUTE 'insert into '||aco_group_table||' (aclaco_id, aclgroup_id) values ('||aco_id||','||group_id||') ;';
    EXECUTE 'insert into '||login_group_table||' (acllogin_id, aclgroup_id) values ('||userid||','||group_id||') ;';

    --  the right ''gestion''
    EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''gestion'' ' INTO aco_id ;
    EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''gestion_group'' ' INTO group_id ;
    EXECUTE 'insert into '||aco_group_table||' (aclaco_id, aclgroup_id) values ('||aco_id||','||group_id||') ;';
    EXECUTE 'insert into '||login_group_table||' (acllogin_id, aclgroup_id) values ('||userid||','||group_id||') ;';

    --  the right ''consult''
    EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''consult'' ' INTO aco_id ;
    EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''consult_group'' ' INTO group_id ;
    EXECUTE 'insert into '||aco_group_table||' (aclaco_id, aclgroup_id) values ('||aco_id||','||group_id||') ;';
    EXECUTE 'insert into '||login_group_table||' (acllogin_id, aclgroup_id) values ('||userid||','||group_id||') ;';

	--EXECUTE 'ALTER SEQUENCE IF EXISTS '||table_name||'_'||col||'_seq RESTART WITH '||appli_id + 1;
    RETURN appli_id;
END;
$$;


ALTER FUNCTION public.create_rights_for_user(gacl_schema character varying, appli_name character varying, userid integer) OWNER TO postgres;

SET search_path = gacl, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 216 (class 1259 OID 18080)
-- Name: aclgroup; Type: TABLE; Schema: gacl; Owner: collec
--

CREATE TABLE aclgroup (
    aclgroup_id integer NOT NULL,
    groupe character varying NOT NULL,
    aclgroup_id_parent integer
);


ALTER TABLE aclgroup OWNER TO collec;

--
-- TOC entry 4907 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE aclgroup; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON TABLE aclgroup IS 'Groupes des logins';


SET search_path = col, pg_catalog;

--
-- TOC entry 226 (class 1259 OID 18176)
-- Name: aclgroup; Type: VIEW; Schema: col; Owner: collec
--

CREATE VIEW aclgroup AS
 SELECT aclgroup.aclgroup_id,
    aclgroup.groupe,
    aclgroup.aclgroup_id_parent
   FROM gacl.aclgroup;


ALTER TABLE aclgroup OWNER TO collec;

--
-- TOC entry 228 (class 1259 OID 18182)
-- Name: booking; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE booking (
    booking_id integer NOT NULL,
    uid integer NOT NULL,
    booking_date timestamp without time zone NOT NULL,
    date_from timestamp without time zone NOT NULL,
    date_to timestamp without time zone NOT NULL,
    booking_comment character varying,
    booking_login character varying NOT NULL
);


ALTER TABLE booking OWNER TO collec;

--
-- TOC entry 4908 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE booking; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE booking IS 'Table des réservations d''objets';


--
-- TOC entry 4909 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN booking.booking_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN booking.booking_date IS 'Date de la réservation';


--
-- TOC entry 4910 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN booking.date_from; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN booking.date_from IS 'Date-heure de début de la réservation';


--
-- TOC entry 4911 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN booking.date_to; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN booking.date_to IS 'Date-heure de fin de la réservation';


--
-- TOC entry 4912 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN booking.booking_comment; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN booking.booking_comment IS 'Commentaire';


--
-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN booking.booking_login; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN booking.booking_login IS 'Compte ayant réalisé la réservation';


--
-- TOC entry 227 (class 1259 OID 18180)
-- Name: booking_booking_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE booking_booking_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE booking_booking_id_seq OWNER TO collec;

--
-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 227
-- Name: booking_booking_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE booking_booking_id_seq OWNED BY booking.booking_id;


--
-- TOC entry 230 (class 1259 OID 18193)
-- Name: container; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE container (
    container_id integer NOT NULL,
    uid integer NOT NULL,
    container_type_id integer NOT NULL
);


ALTER TABLE container OWNER TO collec;

--
-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE container; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE container IS 'Liste des conteneurs d''échantillon';


--
-- TOC entry 229 (class 1259 OID 18191)
-- Name: container_container_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE container_container_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE container_container_id_seq OWNER TO collec;

--
-- TOC entry 4916 (class 0 OID 0)
-- Dependencies: 229
-- Name: container_container_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE container_container_id_seq OWNED BY container.container_id;


--
-- TOC entry 232 (class 1259 OID 18201)
-- Name: container_family; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE container_family (
    container_family_id integer NOT NULL,
    container_family_name character varying NOT NULL,
    is_movable boolean DEFAULT true NOT NULL
);


ALTER TABLE container_family OWNER TO collec;

--
-- TOC entry 4917 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE container_family; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE container_family IS 'Famille générique des conteneurs';


--
-- TOC entry 4918 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN container_family.is_movable; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN container_family.is_movable IS 'Indique si la famille de conteneurs est déplçable facilement ou non (éprouvette : oui, armoire : non)';


--
-- TOC entry 231 (class 1259 OID 18199)
-- Name: container_family_container_family_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE container_family_container_family_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE container_family_container_family_id_seq OWNER TO collec;

--
-- TOC entry 4919 (class 0 OID 0)
-- Dependencies: 231
-- Name: container_family_container_family_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE container_family_container_family_id_seq OWNED BY container_family.container_family_id;


--
-- TOC entry 234 (class 1259 OID 18213)
-- Name: container_type; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE container_type (
    container_type_id integer NOT NULL,
    container_type_name character varying NOT NULL,
    container_family_id integer NOT NULL,
    storage_condition_id integer,
    label_id integer,
    container_type_description character varying,
    storage_product character varying,
    clp_classification character varying
);


ALTER TABLE container_type OWNER TO collec;

--
-- TOC entry 4920 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE container_type; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE container_type IS 'Table des types de conteneurs';


--
-- TOC entry 4921 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN container_type.container_type_description; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN container_type.container_type_description IS 'Description longue';


--
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN container_type.storage_product; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN container_type.storage_product IS 'Produit utilisé pour le stockage (formol, alcool...)';


--
-- TOC entry 4923 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN container_type.clp_classification; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN container_type.clp_classification IS 'Classification du risque conformément à la directive européenne CLP';


--
-- TOC entry 233 (class 1259 OID 18211)
-- Name: container_type_container_type_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE container_type_container_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE container_type_container_type_id_seq OWNER TO collec;

--
-- TOC entry 4924 (class 0 OID 0)
-- Dependencies: 233
-- Name: container_type_container_type_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE container_type_container_type_id_seq OWNED BY container_type.container_type_id;


--
-- TOC entry 236 (class 1259 OID 18224)
-- Name: document; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE document (
    document_id integer NOT NULL,
    uid integer NOT NULL,
    mime_type_id integer NOT NULL,
    document_import_date timestamp without time zone NOT NULL,
    document_name character varying NOT NULL,
    document_description character varying,
    data bytea,
    thumbnail bytea,
    size integer,
    document_creation_date timestamp without time zone
);


ALTER TABLE document OWNER TO collec;

--
-- TOC entry 4925 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE document; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE document IS 'Documents numériques rattachés à un poisson ou à un événement';


--
-- TOC entry 4926 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN document.document_import_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN document.document_import_date IS 'Date d''import dans la base de données';


--
-- TOC entry 4927 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN document.document_name; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN document.document_name IS 'Nom d''origine du document';


--
-- TOC entry 4928 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN document.document_description; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN document.document_description IS 'Description libre du document';


--
-- TOC entry 4929 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN document.data; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN document.data IS 'Contenu du document';


--
-- TOC entry 4930 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN document.thumbnail; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN document.thumbnail IS 'Vignette au format PNG (documents pdf, jpg ou png)';


--
-- TOC entry 4931 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN document.size; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN document.size IS 'Taille du fichier téléchargé';


--
-- TOC entry 4932 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN document.document_creation_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN document.document_creation_date IS 'Date de création du document (date de prise de vue de la photo)';


--
-- TOC entry 235 (class 1259 OID 18222)
-- Name: document_document_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE document_document_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE document_document_id_seq OWNER TO collec;

--
-- TOC entry 4933 (class 0 OID 0)
-- Dependencies: 235
-- Name: document_document_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE document_document_id_seq OWNED BY document.document_id;


--
-- TOC entry 238 (class 1259 OID 18235)
-- Name: event; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE event (
    event_id integer NOT NULL,
    uid integer NOT NULL,
    event_date timestamp without time zone NOT NULL,
    event_type_id integer NOT NULL,
    still_available character varying,
    event_comment character varying
);


ALTER TABLE event OWNER TO collec;

--
-- TOC entry 4934 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE event; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE event IS 'Table des événements';


--
-- TOC entry 4935 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN event.event_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN event.event_date IS 'Date / heure de l''événement';


--
-- TOC entry 4936 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN event.still_available; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN event.still_available IS 'définit ce qu''il reste de disponible dans l''objet';


--
-- TOC entry 237 (class 1259 OID 18233)
-- Name: event_event_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE event_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_event_id_seq OWNER TO collec;

--
-- TOC entry 4937 (class 0 OID 0)
-- Dependencies: 237
-- Name: event_event_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE event_event_id_seq OWNED BY event.event_id;


--
-- TOC entry 240 (class 1259 OID 18246)
-- Name: event_type; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE event_type (
    event_type_id integer NOT NULL,
    event_type_name character varying NOT NULL,
    is_sample boolean DEFAULT false NOT NULL,
    is_container boolean DEFAULT false NOT NULL
);


ALTER TABLE event_type OWNER TO collec;

--
-- TOC entry 4938 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE event_type; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE event_type IS 'Types d''événement';


--
-- TOC entry 4939 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN event_type.is_sample; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN event_type.is_sample IS 'L''événement s''applique aux échantillons';


--
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN event_type.is_container; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN event_type.is_container IS 'L''événement s''applique aux conteneurs';


--
-- TOC entry 239 (class 1259 OID 18244)
-- Name: event_type_event_type_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE event_type_event_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_type_event_type_id_seq OWNER TO collec;

--
-- TOC entry 4941 (class 0 OID 0)
-- Dependencies: 239
-- Name: event_type_event_type_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE event_type_event_type_id_seq OWNED BY event_type.event_type_id;


--
-- TOC entry 242 (class 1259 OID 18259)
-- Name: identifier_type; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE identifier_type (
    identifier_type_id integer NOT NULL,
    identifier_type_name character varying NOT NULL,
    identifier_type_code character varying NOT NULL
);


ALTER TABLE identifier_type OWNER TO collec;

--
-- TOC entry 4942 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE identifier_type; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE identifier_type IS 'Table des types d''identifiants';


--
-- TOC entry 4943 (class 0 OID 0)
-- Dependencies: 242
-- Name: COLUMN identifier_type.identifier_type_name; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN identifier_type.identifier_type_name IS 'Nom textuel de l''identifiant';


--
-- TOC entry 4944 (class 0 OID 0)
-- Dependencies: 242
-- Name: COLUMN identifier_type.identifier_type_code; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN identifier_type.identifier_type_code IS 'Code utilisé pour la génération des étiquettes';


--
-- TOC entry 241 (class 1259 OID 18257)
-- Name: identifier_type_identifier_type_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE identifier_type_identifier_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identifier_type_identifier_type_id_seq OWNER TO collec;

--
-- TOC entry 4945 (class 0 OID 0)
-- Dependencies: 241
-- Name: identifier_type_identifier_type_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE identifier_type_identifier_type_id_seq OWNED BY identifier_type.identifier_type_id;


--
-- TOC entry 244 (class 1259 OID 18270)
-- Name: label; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE label (
    label_id integer NOT NULL,
    label_name character varying NOT NULL,
    label_xsl character varying NOT NULL,
    label_fields character varying DEFAULT 'uid,id,clp,db'::character varying NOT NULL,
    operation_id integer
);


ALTER TABLE label OWNER TO collec;

--
-- TOC entry 4946 (class 0 OID 0)
-- Dependencies: 244
-- Name: TABLE label; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE label IS 'Table des modèles d''étiquettes';


--
-- TOC entry 4947 (class 0 OID 0)
-- Dependencies: 244
-- Name: COLUMN label.label_name; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN label.label_name IS 'Nom du modèle';


--
-- TOC entry 4948 (class 0 OID 0)
-- Dependencies: 244
-- Name: COLUMN label.label_xsl; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN label.label_xsl IS 'Contenu du fichier XSL utilisé pour la transformation FOP (https://xmlgraphics.apache.org/fop/)';


--
-- TOC entry 4949 (class 0 OID 0)
-- Dependencies: 244
-- Name: COLUMN label.label_fields; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN label.label_fields IS 'Liste des champs à intégrer dans le QRCODE, séparés par une virgule';


--
-- TOC entry 243 (class 1259 OID 18268)
-- Name: label_label_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE label_label_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE label_label_id_seq OWNER TO collec;

--
-- TOC entry 4950 (class 0 OID 0)
-- Dependencies: 243
-- Name: label_label_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE label_label_id_seq OWNED BY label.label_id;


--
-- TOC entry 269 (class 1259 OID 18450)
-- Name: storage; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE storage (
    storage_id integer NOT NULL,
    uid integer NOT NULL,
    container_id integer,
    movement_type_id integer NOT NULL,
    storage_reason_id integer,
    storage_date timestamp without time zone NOT NULL,
    storage_location character varying,
    login character varying NOT NULL,
    storage_comment character varying
);


ALTER TABLE storage OWNER TO collec;

--
-- TOC entry 4951 (class 0 OID 0)
-- Dependencies: 269
-- Name: TABLE storage; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE storage IS 'Gestion du stockage des échantillons';


--
-- TOC entry 4952 (class 0 OID 0)
-- Dependencies: 269
-- Name: COLUMN storage.storage_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN storage.storage_date IS 'Date/heure du mouvement';


--
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 269
-- Name: COLUMN storage.storage_location; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN storage.storage_location IS 'Emplacement de l''échantillon dans le conteneur';


--
-- TOC entry 4954 (class 0 OID 0)
-- Dependencies: 269
-- Name: COLUMN storage.login; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN storage.login IS 'Nom de l''utilisateur ayant réalisé l''opération';


--
-- TOC entry 4955 (class 0 OID 0)
-- Dependencies: 269
-- Name: COLUMN storage.storage_comment; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN storage.storage_comment IS 'Commentaire';


--
-- TOC entry 276 (class 1259 OID 18657)
-- Name: last_movement; Type: VIEW; Schema: col; Owner: collec
--

CREATE VIEW last_movement AS
 SELECT s.uid,
    s.storage_id,
    s.storage_date,
    s.movement_type_id,
    s.container_id,
    c.uid AS container_uid
   FROM (storage s
     LEFT JOIN container c USING (container_id))
  WHERE (s.storage_id = ( SELECT st.storage_id
           FROM storage st
          WHERE (s.uid = st.uid)
          ORDER BY st.storage_date DESC
         LIMIT 1));


ALTER TABLE last_movement OWNER TO collec;

--
-- TOC entry 4956 (class 0 OID 0)
-- Dependencies: 276
-- Name: VIEW last_movement; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON VIEW last_movement IS 'Dernier mouvement d''un objet';


--
-- TOC entry 277 (class 1259 OID 18661)
-- Name: last_photo; Type: VIEW; Schema: col; Owner: collec
--

CREATE VIEW last_photo AS
 SELECT d.document_id,
    d.uid
   FROM document d
  WHERE (d.document_id = ( SELECT d1.document_id
           FROM document d1
          WHERE ((d1.mime_type_id = ANY (ARRAY[4, 5, 6])) AND (d.uid = d1.uid))
          ORDER BY d1.document_creation_date DESC, d1.document_import_date DESC, d1.document_id DESC
         LIMIT 1));


ALTER TABLE last_photo OWNER TO collec;

--
-- TOC entry 282 (class 1259 OID 26888)
-- Name: metadata_form; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE metadata_form (
    metadata_form_id integer NOT NULL,
    metadata_schema json
);


ALTER TABLE metadata_form OWNER TO collec;

--
-- TOC entry 4957 (class 0 OID 0)
-- Dependencies: 282
-- Name: TABLE metadata_form; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE metadata_form IS 'Table des schémas des formulaires de métadonnées';


--
-- TOC entry 4958 (class 0 OID 0)
-- Dependencies: 282
-- Name: COLUMN metadata_form.metadata_schema; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN metadata_form.metadata_schema IS 'Schéma en JSON du formulaire des métadonnées ';


--
-- TOC entry 281 (class 1259 OID 26886)
-- Name: metadata_form_metadata_form_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE metadata_form_metadata_form_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE metadata_form_metadata_form_id_seq OWNER TO collec;

--
-- TOC entry 4959 (class 0 OID 0)
-- Dependencies: 281
-- Name: metadata_form_metadata_form_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE metadata_form_metadata_form_id_seq OWNED BY metadata_form.metadata_form_id;


--
-- TOC entry 246 (class 1259 OID 18318)
-- Name: mime_type; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE mime_type (
    mime_type_id integer NOT NULL,
    extension character varying NOT NULL,
    content_type character varying NOT NULL
);


ALTER TABLE mime_type OWNER TO collec;

--
-- TOC entry 4960 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE mime_type; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE mime_type IS 'Types mime des fichiers importés';


--
-- TOC entry 4961 (class 0 OID 0)
-- Dependencies: 246
-- Name: COLUMN mime_type.extension; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN mime_type.extension IS 'Extension du fichier correspondant';


--
-- TOC entry 4962 (class 0 OID 0)
-- Dependencies: 246
-- Name: COLUMN mime_type.content_type; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN mime_type.content_type IS 'type mime officiel';


--
-- TOC entry 245 (class 1259 OID 18316)
-- Name: mime_type_mime_type_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE mime_type_mime_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mime_type_mime_type_id_seq OWNER TO collec;

--
-- TOC entry 4963 (class 0 OID 0)
-- Dependencies: 245
-- Name: mime_type_mime_type_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE mime_type_mime_type_id_seq OWNED BY mime_type.mime_type_id;


--
-- TOC entry 248 (class 1259 OID 18329)
-- Name: movement_type; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE movement_type (
    movement_type_id integer NOT NULL,
    movement_type_name character varying NOT NULL
);


ALTER TABLE movement_type OWNER TO collec;

--
-- TOC entry 4964 (class 0 OID 0)
-- Dependencies: 248
-- Name: TABLE movement_type; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE movement_type IS 'Type de mouvement';


--
-- TOC entry 247 (class 1259 OID 18327)
-- Name: movement_type_movement_type_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE movement_type_movement_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE movement_type_movement_type_id_seq OWNER TO collec;

--
-- TOC entry 4965 (class 0 OID 0)
-- Dependencies: 247
-- Name: movement_type_movement_type_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE movement_type_movement_type_id_seq OWNED BY movement_type.movement_type_id;


--
-- TOC entry 250 (class 1259 OID 18340)
-- Name: multiple_type; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE multiple_type (
    multiple_type_id integer NOT NULL,
    multiple_type_name character varying NOT NULL
);


ALTER TABLE multiple_type OWNER TO collec;

--
-- TOC entry 4966 (class 0 OID 0)
-- Dependencies: 250
-- Name: TABLE multiple_type; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE multiple_type IS 'Table des types de contenus multiples';


--
-- TOC entry 249 (class 1259 OID 18338)
-- Name: multiple_type_multiple_type_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE multiple_type_multiple_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE multiple_type_multiple_type_id_seq OWNER TO collec;

--
-- TOC entry 4967 (class 0 OID 0)
-- Dependencies: 249
-- Name: multiple_type_multiple_type_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE multiple_type_multiple_type_id_seq OWNED BY multiple_type.multiple_type_id;


--
-- TOC entry 252 (class 1259 OID 18351)
-- Name: object; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE object (
    uid integer NOT NULL,
    identifier character varying,
    object_status_id integer,
    wgs84_x double precision,
    wgs84_y double precision
);


ALTER TABLE object OWNER TO collec;

--
-- TOC entry 4968 (class 0 OID 0)
-- Dependencies: 252
-- Name: TABLE object; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE object IS 'Table des objets
Contient les identifiants génériques';


--
-- TOC entry 4969 (class 0 OID 0)
-- Dependencies: 252
-- Name: COLUMN object.identifier; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN object.identifier IS 'Identifiant fourni le cas échéant par le projet';


--
-- TOC entry 4970 (class 0 OID 0)
-- Dependencies: 252
-- Name: COLUMN object.wgs84_x; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN object.wgs84_x IS 'Longitude GPS, en valeur décimale';


--
-- TOC entry 4971 (class 0 OID 0)
-- Dependencies: 252
-- Name: COLUMN object.wgs84_y; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN object.wgs84_y IS 'Latitude GPS, en décimal';


--
-- TOC entry 254 (class 1259 OID 18362)
-- Name: object_identifier; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE object_identifier (
    object_identifier_id integer NOT NULL,
    uid integer NOT NULL,
    identifier_type_id integer NOT NULL,
    object_identifier_value character varying NOT NULL
);


ALTER TABLE object_identifier OWNER TO collec;

--
-- TOC entry 4972 (class 0 OID 0)
-- Dependencies: 254
-- Name: TABLE object_identifier; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE object_identifier IS 'Table des identifiants complémentaires normalisés';


--
-- TOC entry 4973 (class 0 OID 0)
-- Dependencies: 254
-- Name: COLUMN object_identifier.object_identifier_value; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN object_identifier.object_identifier_value IS 'Valeur de l''identifiant';


--
-- TOC entry 253 (class 1259 OID 18360)
-- Name: object_identifier_object_identifier_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE object_identifier_object_identifier_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE object_identifier_object_identifier_id_seq OWNER TO collec;

--
-- TOC entry 4974 (class 0 OID 0)
-- Dependencies: 253
-- Name: object_identifier_object_identifier_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE object_identifier_object_identifier_id_seq OWNED BY object_identifier.object_identifier_id;


--
-- TOC entry 256 (class 1259 OID 18373)
-- Name: object_status; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE object_status (
    object_status_id integer NOT NULL,
    object_status_name character varying NOT NULL
);


ALTER TABLE object_status OWNER TO collec;

--
-- TOC entry 4975 (class 0 OID 0)
-- Dependencies: 256
-- Name: TABLE object_status; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE object_status IS 'Table des statuts possibles des objets';


--
-- TOC entry 255 (class 1259 OID 18371)
-- Name: object_status_object_status_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE object_status_object_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE object_status_object_status_id_seq OWNER TO collec;

--
-- TOC entry 4976 (class 0 OID 0)
-- Dependencies: 255
-- Name: object_status_object_status_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE object_status_object_status_id_seq OWNED BY object_status.object_status_id;


--
-- TOC entry 251 (class 1259 OID 18349)
-- Name: object_uid_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE object_uid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE object_uid_seq OWNER TO collec;

--
-- TOC entry 4977 (class 0 OID 0)
-- Dependencies: 251
-- Name: object_uid_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE object_uid_seq OWNED BY object.uid;


--
-- TOC entry 258 (class 1259 OID 18384)
-- Name: operation; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE operation (
    operation_id integer NOT NULL,
    protocol_id integer NOT NULL,
    operation_name character varying NOT NULL,
    operation_order integer,
    metadata_form_id integer,
    operation_version character varying,
    last_edit_date timestamp without time zone
);


ALTER TABLE operation OWNER TO collec;

--
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 258
-- Name: COLUMN operation.operation_order; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN operation.operation_order IS 'Ordre de réalisation de l''opération dans le protocole';


--
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 258
-- Name: COLUMN operation.operation_version; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN operation.operation_version IS 'Version de l''opération';


--
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 258
-- Name: COLUMN operation.last_edit_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN operation.last_edit_date IS 'Date de dernière éditione l''opératon';


--
-- TOC entry 257 (class 1259 OID 18382)
-- Name: operation_operation_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE operation_operation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE operation_operation_id_seq OWNER TO collec;

--
-- TOC entry 4981 (class 0 OID 0)
-- Dependencies: 257
-- Name: operation_operation_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE operation_operation_id_seq OWNED BY operation.operation_id;


--
-- TOC entry 260 (class 1259 OID 18395)
-- Name: project; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE project (
    project_id integer NOT NULL,
    project_name character varying NOT NULL
);


ALTER TABLE project OWNER TO collec;

--
-- TOC entry 4982 (class 0 OID 0)
-- Dependencies: 260
-- Name: TABLE project; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE project IS 'Table des projets';


--
-- TOC entry 261 (class 1259 OID 18404)
-- Name: project_group; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE project_group (
    project_id integer NOT NULL,
    aclgroup_id integer NOT NULL
);


ALTER TABLE project_group OWNER TO collec;

--
-- TOC entry 4983 (class 0 OID 0)
-- Dependencies: 261
-- Name: TABLE project_group; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE project_group IS 'Table des autorisations d''accès à un projet';


--
-- TOC entry 259 (class 1259 OID 18393)
-- Name: project_project_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE project_project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project_project_id_seq OWNER TO collec;

--
-- TOC entry 4984 (class 0 OID 0)
-- Dependencies: 259
-- Name: project_project_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE project_project_id_seq OWNED BY project.project_id;


--
-- TOC entry 263 (class 1259 OID 18411)
-- Name: protocol; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE protocol (
    protocol_id integer NOT NULL,
    protocol_name character varying NOT NULL,
    protocol_file bytea,
    protocol_year smallint,
    protocol_version character varying DEFAULT 'v1.0'::character varying NOT NULL
);


ALTER TABLE protocol OWNER TO collec;

--
-- TOC entry 4985 (class 0 OID 0)
-- Dependencies: 263
-- Name: COLUMN protocol.protocol_file; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN protocol.protocol_file IS 'Description PDF du protocole';


--
-- TOC entry 4986 (class 0 OID 0)
-- Dependencies: 263
-- Name: COLUMN protocol.protocol_year; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN protocol.protocol_year IS 'Année du protocole';


--
-- TOC entry 4987 (class 0 OID 0)
-- Dependencies: 263
-- Name: COLUMN protocol.protocol_version; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN protocol.protocol_version IS 'Version du protocole';


--
-- TOC entry 262 (class 1259 OID 18409)
-- Name: protocol_protocol_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE protocol_protocol_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE protocol_protocol_id_seq OWNER TO collec;

--
-- TOC entry 4988 (class 0 OID 0)
-- Dependencies: 262
-- Name: protocol_protocol_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE protocol_protocol_id_seq OWNED BY protocol.protocol_id;


--
-- TOC entry 265 (class 1259 OID 18423)
-- Name: sample; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE sample (
    sample_id integer NOT NULL,
    uid integer NOT NULL,
    project_id integer NOT NULL,
    sample_type_id integer NOT NULL,
    sample_creation_date timestamp without time zone NOT NULL,
    sample_date timestamp without time zone,
    parent_sample_id integer,
    multiple_value double precision,
    sampling_place_id integer,
    dbuid_origin character varying,
    sample_metadata_id integer
);


ALTER TABLE sample OWNER TO collec;

--
-- TOC entry 4989 (class 0 OID 0)
-- Dependencies: 265
-- Name: TABLE sample; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE sample IS 'Table des échantillons';


--
-- TOC entry 4990 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN sample.sample_creation_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN sample.sample_creation_date IS 'Date de création de l''enregistrement dans la base de données';


--
-- TOC entry 4991 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN sample.sample_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN sample.sample_date IS 'Date de création de l''échantillon physique';


--
-- TOC entry 4992 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN sample.multiple_value; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN sample.multiple_value IS 'Nombre initial de sous-échantillons';


--
-- TOC entry 4993 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN sample.dbuid_origin; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN sample.dbuid_origin IS 'référence utilisée dans la base de données d''origine, sous la forme db:uid
Utilisé pour lire les étiquettes créées dans d''autres instances';


--
-- TOC entry 284 (class 1259 OID 26950)
-- Name: sample_metadata; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE sample_metadata (
    sample_metadata_id integer NOT NULL,
    data json
);


ALTER TABLE sample_metadata OWNER TO collec;

--
-- TOC entry 4994 (class 0 OID 0)
-- Dependencies: 284
-- Name: TABLE sample_metadata; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE sample_metadata IS 'Table des métadonnées';


--
-- TOC entry 4995 (class 0 OID 0)
-- Dependencies: 284
-- Name: COLUMN sample_metadata.data; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN sample_metadata.data IS 'Métadonnées en JSON';


--
-- TOC entry 283 (class 1259 OID 26948)
-- Name: sample_metadata_sample_metadata_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE sample_metadata_sample_metadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sample_metadata_sample_metadata_id_seq OWNER TO collec;

--
-- TOC entry 4996 (class 0 OID 0)
-- Dependencies: 283
-- Name: sample_metadata_sample_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE sample_metadata_sample_metadata_id_seq OWNED BY sample_metadata.sample_metadata_id;


--
-- TOC entry 264 (class 1259 OID 18421)
-- Name: sample_sample_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE sample_sample_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sample_sample_id_seq OWNER TO collec;

--
-- TOC entry 4997 (class 0 OID 0)
-- Dependencies: 264
-- Name: sample_sample_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE sample_sample_id_seq OWNED BY sample.sample_id;


--
-- TOC entry 267 (class 1259 OID 18439)
-- Name: sample_type; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE sample_type (
    sample_type_id integer NOT NULL,
    sample_type_name character varying NOT NULL,
    container_type_id integer,
    operation_id integer,
    multiple_type_id integer,
    multiple_unit character varying
);


ALTER TABLE sample_type OWNER TO collec;

--
-- TOC entry 4998 (class 0 OID 0)
-- Dependencies: 267
-- Name: TABLE sample_type; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE sample_type IS 'Types d''échantillons';


--
-- TOC entry 4999 (class 0 OID 0)
-- Dependencies: 267
-- Name: COLUMN sample_type.multiple_unit; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN sample_type.multiple_unit IS 'Unité caractérisant le sous-échantillon';


--
-- TOC entry 266 (class 1259 OID 18437)
-- Name: sample_type_sample_type_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE sample_type_sample_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sample_type_sample_type_id_seq OWNER TO collec;

--
-- TOC entry 5000 (class 0 OID 0)
-- Dependencies: 266
-- Name: sample_type_sample_type_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE sample_type_sample_type_id_seq OWNED BY sample_type.sample_type_id;


--
-- TOC entry 280 (class 1259 OID 18673)
-- Name: sampling_place; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE sampling_place (
    sampling_place_id integer NOT NULL,
    sampling_place_name character varying NOT NULL
);


ALTER TABLE sampling_place OWNER TO collec;

--
-- TOC entry 5001 (class 0 OID 0)
-- Dependencies: 280
-- Name: TABLE sampling_place; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE sampling_place IS 'Table des lieux génériques d''échantillonnage';


--
-- TOC entry 279 (class 1259 OID 18671)
-- Name: sampling_place_sampling_place_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE sampling_place_sampling_place_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sampling_place_sampling_place_id_seq OWNER TO collec;

--
-- TOC entry 5002 (class 0 OID 0)
-- Dependencies: 279
-- Name: sampling_place_sampling_place_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE sampling_place_sampling_place_id_seq OWNED BY sampling_place.sampling_place_id;


--
-- TOC entry 271 (class 1259 OID 18461)
-- Name: storage_condition; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE storage_condition (
    storage_condition_id integer NOT NULL,
    storage_condition_name character varying NOT NULL
);


ALTER TABLE storage_condition OWNER TO collec;

--
-- TOC entry 5003 (class 0 OID 0)
-- Dependencies: 271
-- Name: TABLE storage_condition; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE storage_condition IS 'Condition de stockage';


--
-- TOC entry 270 (class 1259 OID 18459)
-- Name: storage_condition_storage_condition_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE storage_condition_storage_condition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE storage_condition_storage_condition_id_seq OWNER TO collec;

--
-- TOC entry 5004 (class 0 OID 0)
-- Dependencies: 270
-- Name: storage_condition_storage_condition_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE storage_condition_storage_condition_id_seq OWNED BY storage_condition.storage_condition_id;


--
-- TOC entry 273 (class 1259 OID 18472)
-- Name: storage_reason; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE storage_reason (
    storage_reason_id integer NOT NULL,
    storage_reason_name character varying NOT NULL
);


ALTER TABLE storage_reason OWNER TO collec;

--
-- TOC entry 5005 (class 0 OID 0)
-- Dependencies: 273
-- Name: TABLE storage_reason; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE storage_reason IS 'Table des raisons de stockage/déstockage';


--
-- TOC entry 272 (class 1259 OID 18470)
-- Name: storage_reason_storage_reason_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE storage_reason_storage_reason_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE storage_reason_storage_reason_id_seq OWNER TO collec;

--
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 272
-- Name: storage_reason_storage_reason_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE storage_reason_storage_reason_id_seq OWNED BY storage_reason.storage_reason_id;


--
-- TOC entry 268 (class 1259 OID 18448)
-- Name: storage_storage_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE storage_storage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE storage_storage_id_seq OWNER TO collec;

--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 268
-- Name: storage_storage_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE storage_storage_id_seq OWNED BY storage.storage_id;


--
-- TOC entry 275 (class 1259 OID 18483)
-- Name: subsample; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE subsample (
    subsample_id integer NOT NULL,
    sample_id integer NOT NULL,
    subsample_date timestamp without time zone NOT NULL,
    movement_type_id integer NOT NULL,
    subsample_quantity double precision,
    subsample_comment character varying,
    subsample_login character varying NOT NULL
);


ALTER TABLE subsample OWNER TO collec;

--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 275
-- Name: TABLE subsample; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE subsample IS 'Table des prélèvements et restitutions de sous-échantillons';


--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 275
-- Name: COLUMN subsample.subsample_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN subsample.subsample_date IS 'Date/heure de l''opération';


--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 275
-- Name: COLUMN subsample.subsample_quantity; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN subsample.subsample_quantity IS 'Quantité prélevée ou restituée';


--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 275
-- Name: COLUMN subsample.subsample_login; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN subsample.subsample_login IS 'Login de l''utilisateur ayant réalisé l''opération';


--
-- TOC entry 274 (class 1259 OID 18481)
-- Name: subsample_subsample_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE subsample_subsample_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subsample_subsample_id_seq OWNER TO collec;

--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 274
-- Name: subsample_subsample_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE subsample_subsample_id_seq OWNED BY subsample.subsample_id;


--
-- TOC entry 278 (class 1259 OID 18665)
-- Name: v_object_identifier; Type: VIEW; Schema: col; Owner: collec
--

CREATE VIEW v_object_identifier AS
 SELECT object_identifier.uid,
    array_to_string(array_agg((((identifier_type.identifier_type_code)::text || ':'::text) || (object_identifier.object_identifier_value)::text) ORDER BY identifier_type.identifier_type_code, object_identifier.object_identifier_value), ','::text) AS identifiers
   FROM (object_identifier
     JOIN identifier_type USING (identifier_type_id))
  GROUP BY object_identifier.uid
  ORDER BY object_identifier.uid;


ALTER TABLE v_object_identifier OWNER TO collec;

SET search_path = gacl, pg_catalog;

--
-- TOC entry 210 (class 1259 OID 18051)
-- Name: aclacl; Type: TABLE; Schema: gacl; Owner: collec
--

CREATE TABLE aclacl (
    aclaco_id integer NOT NULL,
    aclgroup_id integer NOT NULL
);


ALTER TABLE aclacl OWNER TO collec;

--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE aclacl; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON TABLE aclacl IS 'Table des droits attribués';


--
-- TOC entry 212 (class 1259 OID 18058)
-- Name: aclaco; Type: TABLE; Schema: gacl; Owner: collec
--

CREATE TABLE aclaco (
    aclaco_id integer NOT NULL,
    aclappli_id integer NOT NULL,
    aco character varying NOT NULL
);


ALTER TABLE aclaco OWNER TO collec;

--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE aclaco; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON TABLE aclaco IS 'Table des droits gérés';


--
-- TOC entry 211 (class 1259 OID 18056)
-- Name: aclaco_aclaco_id_seq; Type: SEQUENCE; Schema: gacl; Owner: collec
--

CREATE SEQUENCE aclaco_aclaco_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aclaco_aclaco_id_seq OWNER TO collec;

--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 211
-- Name: aclaco_aclaco_id_seq; Type: SEQUENCE OWNED BY; Schema: gacl; Owner: collec
--

ALTER SEQUENCE aclaco_aclaco_id_seq OWNED BY aclaco.aclaco_id;


--
-- TOC entry 214 (class 1259 OID 18069)
-- Name: aclappli; Type: TABLE; Schema: gacl; Owner: collec
--

CREATE TABLE aclappli (
    aclappli_id integer NOT NULL,
    appli character varying NOT NULL,
    applidetail character varying
);


ALTER TABLE aclappli OWNER TO collec;

--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE aclappli; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON TABLE aclappli IS 'Table des applications gérées';


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 214
-- Name: COLUMN aclappli.appli; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON COLUMN aclappli.appli IS 'Nom de l''application pour la gestion des droits';


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 214
-- Name: COLUMN aclappli.applidetail; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON COLUMN aclappli.applidetail IS 'Description de l''application';


--
-- TOC entry 213 (class 1259 OID 18067)
-- Name: aclappli_aclappli_id_seq; Type: SEQUENCE; Schema: gacl; Owner: collec
--

CREATE SEQUENCE aclappli_aclappli_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aclappli_aclappli_id_seq OWNER TO collec;

--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 213
-- Name: aclappli_aclappli_id_seq; Type: SEQUENCE OWNED BY; Schema: gacl; Owner: collec
--

ALTER SEQUENCE aclappli_aclappli_id_seq OWNED BY aclappli.aclappli_id;


--
-- TOC entry 215 (class 1259 OID 18078)
-- Name: aclgroup_aclgroup_id_seq; Type: SEQUENCE; Schema: gacl; Owner: collec
--

CREATE SEQUENCE aclgroup_aclgroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aclgroup_aclgroup_id_seq OWNER TO collec;

--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 215
-- Name: aclgroup_aclgroup_id_seq; Type: SEQUENCE OWNED BY; Schema: gacl; Owner: collec
--

ALTER SEQUENCE aclgroup_aclgroup_id_seq OWNED BY aclgroup.aclgroup_id;


--
-- TOC entry 218 (class 1259 OID 18091)
-- Name: acllogin; Type: TABLE; Schema: gacl; Owner: collec
--

CREATE TABLE acllogin (
    acllogin_id integer NOT NULL,
    login character varying NOT NULL,
    logindetail character varying NOT NULL
);


ALTER TABLE acllogin OWNER TO collec;

--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE acllogin; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON TABLE acllogin IS 'Table des logins des utilisateurs autorisés';


--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN acllogin.logindetail; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON COLUMN acllogin.logindetail IS 'Nom affiché';


--
-- TOC entry 217 (class 1259 OID 18089)
-- Name: acllogin_acllogin_id_seq; Type: SEQUENCE; Schema: gacl; Owner: collec
--

CREATE SEQUENCE acllogin_acllogin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE acllogin_acllogin_id_seq OWNER TO collec;

--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 217
-- Name: acllogin_acllogin_id_seq; Type: SEQUENCE OWNED BY; Schema: gacl; Owner: collec
--

ALTER SEQUENCE acllogin_acllogin_id_seq OWNED BY acllogin.acllogin_id;


--
-- TOC entry 219 (class 1259 OID 18100)
-- Name: acllogingroup; Type: TABLE; Schema: gacl; Owner: collec
--

CREATE TABLE acllogingroup (
    acllogin_id integer NOT NULL,
    aclgroup_id integer NOT NULL
);


ALTER TABLE acllogingroup OWNER TO collec;

--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE acllogingroup; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON TABLE acllogingroup IS 'Table des relations entre les logins et les groupes';


--
-- TOC entry 225 (class 1259 OID 18163)
-- Name: log; Type: TABLE; Schema: gacl; Owner: collec
--

CREATE TABLE log (
    log_id integer NOT NULL,
    login character varying(32) NOT NULL,
    nom_module character varying,
    log_date timestamp without time zone NOT NULL,
    commentaire character varying,
    ipaddress character varying
);


ALTER TABLE log OWNER TO collec;

--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE log; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON TABLE log IS 'Liste des connexions ou des actions enregistrées';


--
-- TOC entry 5026 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN log.log_date; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON COLUMN log.log_date IS 'Heure de connexion';


--
-- TOC entry 5027 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN log.commentaire; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON COLUMN log.commentaire IS 'Donnees complementaires enregistrees';


--
-- TOC entry 5028 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN log.ipaddress; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON COLUMN log.ipaddress IS 'Adresse IP du client';


--
-- TOC entry 224 (class 1259 OID 18161)
-- Name: log_log_id_seq; Type: SEQUENCE; Schema: gacl; Owner: collec
--

CREATE SEQUENCE log_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE log_log_id_seq OWNER TO collec;

--
-- TOC entry 5029 (class 0 OID 0)
-- Dependencies: 224
-- Name: log_log_id_seq; Type: SEQUENCE OWNED BY; Schema: gacl; Owner: collec
--

ALTER SEQUENCE log_log_id_seq OWNED BY log.log_id;


--
-- TOC entry 221 (class 1259 OID 18144)
-- Name: seq_logingestion_id; Type: SEQUENCE; Schema: gacl; Owner: collec
--

CREATE SEQUENCE seq_logingestion_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 999999
    CACHE 1;


ALTER TABLE seq_logingestion_id OWNER TO collec;

--
-- TOC entry 223 (class 1259 OID 18149)
-- Name: login_oldpassword; Type: TABLE; Schema: gacl; Owner: collec
--

CREATE TABLE login_oldpassword (
    login_oldpassword_id integer NOT NULL,
    id integer DEFAULT nextval('seq_logingestion_id'::regclass) NOT NULL,
    password character varying(255)
);


ALTER TABLE login_oldpassword OWNER TO collec;

--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE login_oldpassword; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON TABLE login_oldpassword IS 'Table contenant les anciens mots de passe';


--
-- TOC entry 222 (class 1259 OID 18147)
-- Name: login_oldpassword_login_oldpassword_id_seq; Type: SEQUENCE; Schema: gacl; Owner: collec
--

CREATE SEQUENCE login_oldpassword_login_oldpassword_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE login_oldpassword_login_oldpassword_id_seq OWNER TO collec;

--
-- TOC entry 5031 (class 0 OID 0)
-- Dependencies: 222
-- Name: login_oldpassword_login_oldpassword_id_seq; Type: SEQUENCE OWNED BY; Schema: gacl; Owner: collec
--

ALTER SEQUENCE login_oldpassword_login_oldpassword_id_seq OWNED BY login_oldpassword.login_oldpassword_id;


--
-- TOC entry 220 (class 1259 OID 18135)
-- Name: logingestion; Type: TABLE; Schema: gacl; Owner: collec
--

CREATE TABLE logingestion (
    id integer DEFAULT nextval('seq_logingestion_id'::regclass) NOT NULL,
    login character varying(32) NOT NULL,
    password character varying(255),
    nom character varying(32),
    prenom character varying(32),
    mail character varying(255),
    datemodif date,
    actif smallint DEFAULT 1
);


ALTER TABLE logingestion OWNER TO collec;

SET search_path = zaalpes, pg_catalog;

--
-- TOC entry 285 (class 1259 OID 26966)
-- Name: aclgroup; Type: VIEW; Schema: zaalpes; Owner: collec
--

CREATE VIEW aclgroup AS
 SELECT aclgroup.aclgroup_id,
    aclgroup.groupe,
    aclgroup.aclgroup_id_parent
   FROM gacl.aclgroup;


ALTER TABLE aclgroup OWNER TO collec;

--
-- TOC entry 287 (class 1259 OID 26972)
-- Name: booking; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE booking (
    booking_id integer NOT NULL,
    uid integer NOT NULL,
    booking_date timestamp without time zone NOT NULL,
    date_from timestamp without time zone NOT NULL,
    date_to timestamp without time zone NOT NULL,
    booking_comment character varying,
    booking_login character varying NOT NULL
);


ALTER TABLE booking OWNER TO collec;

--
-- TOC entry 5032 (class 0 OID 0)
-- Dependencies: 287
-- Name: TABLE booking; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE booking IS 'Table des réservations d''objets';


--
-- TOC entry 5033 (class 0 OID 0)
-- Dependencies: 287
-- Name: COLUMN booking.booking_date; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN booking.booking_date IS 'Date de la réservation';


--
-- TOC entry 5034 (class 0 OID 0)
-- Dependencies: 287
-- Name: COLUMN booking.date_from; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN booking.date_from IS 'Date-heure de début de la réservation';


--
-- TOC entry 5035 (class 0 OID 0)
-- Dependencies: 287
-- Name: COLUMN booking.date_to; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN booking.date_to IS 'Date-heure de fin de la réservation';


--
-- TOC entry 5036 (class 0 OID 0)
-- Dependencies: 287
-- Name: COLUMN booking.booking_comment; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN booking.booking_comment IS 'Commentaire';


--
-- TOC entry 5037 (class 0 OID 0)
-- Dependencies: 287
-- Name: COLUMN booking.booking_login; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN booking.booking_login IS 'Compte ayant réalisé la réservation';


--
-- TOC entry 286 (class 1259 OID 26970)
-- Name: booking_booking_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE booking_booking_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE booking_booking_id_seq OWNER TO collec;

--
-- TOC entry 5038 (class 0 OID 0)
-- Dependencies: 286
-- Name: booking_booking_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE booking_booking_id_seq OWNED BY booking.booking_id;


--
-- TOC entry 289 (class 1259 OID 26983)
-- Name: container; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE container (
    container_id integer NOT NULL,
    uid integer NOT NULL,
    container_type_id integer NOT NULL
);


ALTER TABLE container OWNER TO collec;

--
-- TOC entry 5039 (class 0 OID 0)
-- Dependencies: 289
-- Name: TABLE container; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE container IS 'Liste des conteneurs d''échantillon';


--
-- TOC entry 288 (class 1259 OID 26981)
-- Name: container_container_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE container_container_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE container_container_id_seq OWNER TO collec;

--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 288
-- Name: container_container_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE container_container_id_seq OWNED BY container.container_id;


--
-- TOC entry 291 (class 1259 OID 26991)
-- Name: container_family; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE container_family (
    container_family_id integer NOT NULL,
    container_family_name character varying NOT NULL,
    is_movable boolean DEFAULT true NOT NULL
);


ALTER TABLE container_family OWNER TO collec;

--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 291
-- Name: TABLE container_family; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE container_family IS 'Famille générique des conteneurs';


--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 291
-- Name: COLUMN container_family.is_movable; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN container_family.is_movable IS 'Indique si la famille de conteneurs est déplçable facilement ou non (éprouvette : oui, armoire : non)';


--
-- TOC entry 290 (class 1259 OID 26989)
-- Name: container_family_container_family_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE container_family_container_family_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE container_family_container_family_id_seq OWNER TO collec;

--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 290
-- Name: container_family_container_family_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE container_family_container_family_id_seq OWNED BY container_family.container_family_id;


--
-- TOC entry 293 (class 1259 OID 27003)
-- Name: container_type; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE container_type (
    container_type_id integer NOT NULL,
    container_type_name character varying NOT NULL,
    container_family_id integer NOT NULL,
    storage_condition_id integer,
    label_id integer,
    container_type_description character varying,
    storage_product character varying,
    clp_classification character varying
);


ALTER TABLE container_type OWNER TO collec;

--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 293
-- Name: TABLE container_type; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE container_type IS 'Table des types de conteneurs';


--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 293
-- Name: COLUMN container_type.container_type_description; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN container_type.container_type_description IS 'Description longue';


--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 293
-- Name: COLUMN container_type.storage_product; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN container_type.storage_product IS 'Produit utilisé pour le stockage (formol, alcool...)';


--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 293
-- Name: COLUMN container_type.clp_classification; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN container_type.clp_classification IS 'Classification du risque conformément à la directive européenne CLP';


--
-- TOC entry 292 (class 1259 OID 27001)
-- Name: container_type_container_type_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE container_type_container_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE container_type_container_type_id_seq OWNER TO collec;

--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 292
-- Name: container_type_container_type_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE container_type_container_type_id_seq OWNED BY container_type.container_type_id;


--
-- TOC entry 295 (class 1259 OID 27014)
-- Name: document; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE document (
    document_id integer NOT NULL,
    uid integer NOT NULL,
    mime_type_id integer NOT NULL,
    document_import_date timestamp without time zone NOT NULL,
    document_name character varying NOT NULL,
    document_description character varying,
    data bytea,
    thumbnail bytea,
    size integer,
    document_creation_date timestamp without time zone
);


ALTER TABLE document OWNER TO collec;

--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 295
-- Name: TABLE document; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE document IS 'Documents numériques rattachés à un poisson ou à un événement';


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN document.document_import_date; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN document.document_import_date IS 'Date d''import dans la base de données';


--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN document.document_name; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN document.document_name IS 'Nom d''origine du document';


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN document.document_description; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN document.document_description IS 'Description libre du document';


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN document.data; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN document.data IS 'Contenu du document';


--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN document.thumbnail; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN document.thumbnail IS 'Vignette au format PNG (documents pdf, jpg ou png)';


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN document.size; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN document.size IS 'Taille du fichier téléchargé';


--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN document.document_creation_date; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN document.document_creation_date IS 'Date de création du document (date de prise de vue de la photo)';


--
-- TOC entry 294 (class 1259 OID 27012)
-- Name: document_document_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE document_document_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE document_document_id_seq OWNER TO collec;

--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 294
-- Name: document_document_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE document_document_id_seq OWNED BY document.document_id;


--
-- TOC entry 297 (class 1259 OID 27025)
-- Name: event; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE event (
    event_id integer NOT NULL,
    uid integer NOT NULL,
    event_date timestamp without time zone NOT NULL,
    event_type_id integer NOT NULL,
    still_available character varying,
    event_comment character varying
);


ALTER TABLE event OWNER TO collec;

--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 297
-- Name: TABLE event; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE event IS 'Table des événements';


--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 297
-- Name: COLUMN event.event_date; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN event.event_date IS 'Date / heure de l''événement';


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 297
-- Name: COLUMN event.still_available; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN event.still_available IS 'définit ce qu''il reste de disponible dans l''objet';


--
-- TOC entry 296 (class 1259 OID 27023)
-- Name: event_event_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE event_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_event_id_seq OWNER TO collec;

--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 296
-- Name: event_event_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE event_event_id_seq OWNED BY event.event_id;


--
-- TOC entry 299 (class 1259 OID 27036)
-- Name: event_type; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE event_type (
    event_type_id integer NOT NULL,
    event_type_name character varying NOT NULL,
    is_sample boolean DEFAULT false NOT NULL,
    is_container boolean DEFAULT false NOT NULL
);


ALTER TABLE event_type OWNER TO collec;

--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 299
-- Name: TABLE event_type; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE event_type IS 'Types d''événement';


--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 299
-- Name: COLUMN event_type.is_sample; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN event_type.is_sample IS 'L''événement s''applique aux échantillons';


--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 299
-- Name: COLUMN event_type.is_container; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN event_type.is_container IS 'L''événement s''applique aux conteneurs';


--
-- TOC entry 298 (class 1259 OID 27034)
-- Name: event_type_event_type_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE event_type_event_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_type_event_type_id_seq OWNER TO collec;

--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 298
-- Name: event_type_event_type_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE event_type_event_type_id_seq OWNED BY event_type.event_type_id;


--
-- TOC entry 301 (class 1259 OID 27049)
-- Name: identifier_type; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE identifier_type (
    identifier_type_id integer NOT NULL,
    identifier_type_name character varying NOT NULL,
    identifier_type_code character varying NOT NULL
);


ALTER TABLE identifier_type OWNER TO collec;

--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 301
-- Name: TABLE identifier_type; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE identifier_type IS 'Table des types d''identifiants';


--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 301
-- Name: COLUMN identifier_type.identifier_type_name; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN identifier_type.identifier_type_name IS 'Nom textuel de l''identifiant';


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 301
-- Name: COLUMN identifier_type.identifier_type_code; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN identifier_type.identifier_type_code IS 'Code utilisé pour la génération des étiquettes';


--
-- TOC entry 300 (class 1259 OID 27047)
-- Name: identifier_type_identifier_type_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE identifier_type_identifier_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identifier_type_identifier_type_id_seq OWNER TO collec;

--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 300
-- Name: identifier_type_identifier_type_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE identifier_type_identifier_type_id_seq OWNED BY identifier_type.identifier_type_id;


--
-- TOC entry 303 (class 1259 OID 27060)
-- Name: label; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE label (
    label_id integer NOT NULL,
    label_name character varying NOT NULL,
    label_xsl character varying NOT NULL,
    label_fields character varying DEFAULT 'uid,id,clp,db'::character varying NOT NULL,
    operation_id integer
);


ALTER TABLE label OWNER TO collec;

--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 303
-- Name: TABLE label; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE label IS 'Table des modèles d''étiquettes';


--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 303
-- Name: COLUMN label.label_name; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN label.label_name IS 'Nom du modèle';


--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 303
-- Name: COLUMN label.label_xsl; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN label.label_xsl IS 'Contenu du fichier XSL utilisé pour la transformation FOP (https://xmlgraphics.apache.org/fop/)';


--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 303
-- Name: COLUMN label.label_fields; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN label.label_fields IS 'Liste des champs à intégrer dans le QRCODE, séparés par une virgule';


--
-- TOC entry 302 (class 1259 OID 27058)
-- Name: label_label_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE label_label_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE label_label_id_seq OWNER TO collec;

--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 302
-- Name: label_label_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE label_label_id_seq OWNED BY label.label_id;


--
-- TOC entry 328 (class 1259 OID 27240)
-- Name: storage; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE storage (
    storage_id integer NOT NULL,
    uid integer NOT NULL,
    container_id integer,
    movement_type_id integer NOT NULL,
    storage_reason_id integer,
    storage_date timestamp without time zone NOT NULL,
    storage_location character varying,
    login character varying NOT NULL,
    storage_comment character varying
);


ALTER TABLE storage OWNER TO collec;

--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 328
-- Name: TABLE storage; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE storage IS 'Gestion du stockage des échantillons';


--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 328
-- Name: COLUMN storage.storage_date; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN storage.storage_date IS 'Date/heure du mouvement';


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 328
-- Name: COLUMN storage.storage_location; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN storage.storage_location IS 'Emplacement de l''échantillon dans le conteneur';


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 328
-- Name: COLUMN storage.login; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN storage.login IS 'Nom de l''utilisateur ayant réalisé l''opération';


--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 328
-- Name: COLUMN storage.storage_comment; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN storage.storage_comment IS 'Commentaire';


--
-- TOC entry 335 (class 1259 OID 27447)
-- Name: last_movement; Type: VIEW; Schema: zaalpes; Owner: collec
--

CREATE VIEW last_movement AS
 SELECT s.uid,
    s.storage_id,
    s.storage_date,
    s.movement_type_id,
    s.container_id,
    c.uid AS container_uid
   FROM (col.storage s
     LEFT JOIN col.container c USING (container_id))
  WHERE (s.storage_id = ( SELECT st.storage_id
           FROM storage st
          WHERE (s.uid = st.uid)
          ORDER BY st.storage_date DESC
         LIMIT 1));


ALTER TABLE last_movement OWNER TO collec;

--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 335
-- Name: VIEW last_movement; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON VIEW last_movement IS 'Dernier mouvement d''un objet';


--
-- TOC entry 336 (class 1259 OID 27451)
-- Name: last_photo; Type: VIEW; Schema: zaalpes; Owner: collec
--

CREATE VIEW last_photo AS
 SELECT d.document_id,
    d.uid
   FROM document d
  WHERE (d.document_id = ( SELECT d1.document_id
           FROM document d1
          WHERE ((d1.mime_type_id = ANY (ARRAY[4, 5, 6])) AND (d.uid = d1.uid))
          ORDER BY d1.document_creation_date DESC, d1.document_import_date DESC, d1.document_id DESC
         LIMIT 1));


ALTER TABLE last_photo OWNER TO collec;

--
-- TOC entry 341 (class 1259 OID 27484)
-- Name: metadata_form; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE metadata_form (
    metadata_form_id integer NOT NULL,
    metadata_schema json
);


ALTER TABLE metadata_form OWNER TO collec;

--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 341
-- Name: TABLE metadata_form; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE metadata_form IS 'Table des schémas des formulaires de métadonnées';


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 341
-- Name: COLUMN metadata_form.metadata_schema; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN metadata_form.metadata_schema IS 'Schéma en JSON du formulaire des métadonnées ';


--
-- TOC entry 340 (class 1259 OID 27482)
-- Name: metadata_form_metadata_form_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE metadata_form_metadata_form_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE metadata_form_metadata_form_id_seq OWNER TO collec;

--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 340
-- Name: metadata_form_metadata_form_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE metadata_form_metadata_form_id_seq OWNED BY metadata_form.metadata_form_id;


--
-- TOC entry 305 (class 1259 OID 27108)
-- Name: mime_type; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE mime_type (
    mime_type_id integer NOT NULL,
    extension character varying NOT NULL,
    content_type character varying NOT NULL
);


ALTER TABLE mime_type OWNER TO collec;

--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 305
-- Name: TABLE mime_type; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE mime_type IS 'Types mime des fichiers importés';


--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN mime_type.extension; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN mime_type.extension IS 'Extension du fichier correspondant';


--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN mime_type.content_type; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN mime_type.content_type IS 'type mime officiel';


--
-- TOC entry 304 (class 1259 OID 27106)
-- Name: mime_type_mime_type_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE mime_type_mime_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mime_type_mime_type_id_seq OWNER TO collec;

--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 304
-- Name: mime_type_mime_type_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE mime_type_mime_type_id_seq OWNED BY mime_type.mime_type_id;


--
-- TOC entry 307 (class 1259 OID 27119)
-- Name: movement_type; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE movement_type (
    movement_type_id integer NOT NULL,
    movement_type_name character varying NOT NULL
);


ALTER TABLE movement_type OWNER TO collec;

--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 307
-- Name: TABLE movement_type; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE movement_type IS 'Type de mouvement';


--
-- TOC entry 306 (class 1259 OID 27117)
-- Name: movement_type_movement_type_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE movement_type_movement_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE movement_type_movement_type_id_seq OWNER TO collec;

--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 306
-- Name: movement_type_movement_type_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE movement_type_movement_type_id_seq OWNED BY movement_type.movement_type_id;


--
-- TOC entry 309 (class 1259 OID 27130)
-- Name: multiple_type; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE multiple_type (
    multiple_type_id integer NOT NULL,
    multiple_type_name character varying NOT NULL
);


ALTER TABLE multiple_type OWNER TO collec;

--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 309
-- Name: TABLE multiple_type; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE multiple_type IS 'Table des types de contenus multiples';


--
-- TOC entry 308 (class 1259 OID 27128)
-- Name: multiple_type_multiple_type_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE multiple_type_multiple_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE multiple_type_multiple_type_id_seq OWNER TO collec;

--
-- TOC entry 5091 (class 0 OID 0)
-- Dependencies: 308
-- Name: multiple_type_multiple_type_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE multiple_type_multiple_type_id_seq OWNED BY multiple_type.multiple_type_id;


--
-- TOC entry 311 (class 1259 OID 27141)
-- Name: object; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE object (
    uid integer NOT NULL,
    identifier character varying,
    object_status_id integer,
    wgs84_x double precision,
    wgs84_y double precision
);


ALTER TABLE object OWNER TO collec;

--
-- TOC entry 5092 (class 0 OID 0)
-- Dependencies: 311
-- Name: TABLE object; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE object IS 'Table des objets
Contient les identifiants génériques';


--
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 311
-- Name: COLUMN object.identifier; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN object.identifier IS 'Identifiant fourni le cas échéant par le projet';


--
-- TOC entry 5094 (class 0 OID 0)
-- Dependencies: 311
-- Name: COLUMN object.wgs84_x; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN object.wgs84_x IS 'Longitude GPS, en valeur décimale';


--
-- TOC entry 5095 (class 0 OID 0)
-- Dependencies: 311
-- Name: COLUMN object.wgs84_y; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN object.wgs84_y IS 'Latitude GPS, en décimal';


--
-- TOC entry 313 (class 1259 OID 27152)
-- Name: object_identifier; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE object_identifier (
    object_identifier_id integer NOT NULL,
    uid integer NOT NULL,
    identifier_type_id integer NOT NULL,
    object_identifier_value character varying NOT NULL
);


ALTER TABLE object_identifier OWNER TO collec;

--
-- TOC entry 5096 (class 0 OID 0)
-- Dependencies: 313
-- Name: TABLE object_identifier; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE object_identifier IS 'Table des identifiants complémentaires normalisés';


--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN object_identifier.object_identifier_value; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN object_identifier.object_identifier_value IS 'Valeur de l''identifiant';


--
-- TOC entry 312 (class 1259 OID 27150)
-- Name: object_identifier_object_identifier_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE object_identifier_object_identifier_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE object_identifier_object_identifier_id_seq OWNER TO collec;

--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 312
-- Name: object_identifier_object_identifier_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE object_identifier_object_identifier_id_seq OWNED BY object_identifier.object_identifier_id;


--
-- TOC entry 315 (class 1259 OID 27163)
-- Name: object_status; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE object_status (
    object_status_id integer NOT NULL,
    object_status_name character varying NOT NULL
);


ALTER TABLE object_status OWNER TO collec;

--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 315
-- Name: TABLE object_status; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE object_status IS 'Table des statuts possibles des objets';


--
-- TOC entry 314 (class 1259 OID 27161)
-- Name: object_status_object_status_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE object_status_object_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE object_status_object_status_id_seq OWNER TO collec;

--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 314
-- Name: object_status_object_status_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE object_status_object_status_id_seq OWNED BY object_status.object_status_id;


--
-- TOC entry 310 (class 1259 OID 27139)
-- Name: object_uid_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE object_uid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE object_uid_seq OWNER TO collec;

--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 310
-- Name: object_uid_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE object_uid_seq OWNED BY object.uid;


--
-- TOC entry 317 (class 1259 OID 27174)
-- Name: operation; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE operation (
    operation_id integer NOT NULL,
    protocol_id integer NOT NULL,
    operation_name character varying NOT NULL,
    operation_order integer,
    metadata_form_id integer,
    operation_version character varying,
    last_edit_date timestamp without time zone
);


ALTER TABLE operation OWNER TO collec;

--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN operation.operation_order; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN operation.operation_order IS 'Ordre de réalisation de l''opération dans le protocole';


--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN operation.operation_version; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN operation.operation_version IS 'Version de l''opération';


--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN operation.last_edit_date; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN operation.last_edit_date IS 'Date de dernière éditione l''opératon';


--
-- TOC entry 316 (class 1259 OID 27172)
-- Name: operation_operation_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE operation_operation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE operation_operation_id_seq OWNER TO collec;

--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 316
-- Name: operation_operation_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE operation_operation_id_seq OWNED BY operation.operation_id;


--
-- TOC entry 319 (class 1259 OID 27185)
-- Name: project; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE project (
    project_id integer NOT NULL,
    project_name character varying NOT NULL
);


ALTER TABLE project OWNER TO collec;

--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 319
-- Name: TABLE project; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE project IS 'Table des projets';


--
-- TOC entry 320 (class 1259 OID 27194)
-- Name: project_group; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE project_group (
    project_id integer NOT NULL,
    aclgroup_id integer NOT NULL
);


ALTER TABLE project_group OWNER TO collec;

--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 320
-- Name: TABLE project_group; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE project_group IS 'Table des autorisations d''accès à un projet';


--
-- TOC entry 318 (class 1259 OID 27183)
-- Name: project_project_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE project_project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project_project_id_seq OWNER TO collec;

--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 318
-- Name: project_project_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE project_project_id_seq OWNED BY project.project_id;


--
-- TOC entry 322 (class 1259 OID 27201)
-- Name: protocol; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE protocol (
    protocol_id integer NOT NULL,
    protocol_name character varying NOT NULL,
    protocol_file bytea,
    protocol_year smallint,
    protocol_version character varying DEFAULT 'v1.0'::character varying NOT NULL
);


ALTER TABLE protocol OWNER TO collec;

--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 322
-- Name: COLUMN protocol.protocol_file; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN protocol.protocol_file IS 'Description PDF du protocole';


--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 322
-- Name: COLUMN protocol.protocol_year; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN protocol.protocol_year IS 'Année du protocole';


--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 322
-- Name: COLUMN protocol.protocol_version; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN protocol.protocol_version IS 'Version du protocole';


--
-- TOC entry 321 (class 1259 OID 27199)
-- Name: protocol_protocol_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE protocol_protocol_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE protocol_protocol_id_seq OWNER TO collec;

--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 321
-- Name: protocol_protocol_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE protocol_protocol_id_seq OWNED BY protocol.protocol_id;


--
-- TOC entry 324 (class 1259 OID 27213)
-- Name: sample; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE sample (
    sample_id integer NOT NULL,
    uid integer NOT NULL,
    project_id integer NOT NULL,
    sample_type_id integer NOT NULL,
    sample_creation_date timestamp without time zone NOT NULL,
    sample_date timestamp without time zone,
    parent_sample_id integer,
    multiple_value double precision,
    sampling_place_id integer,
    dbuid_origin character varying,
    sample_metadata_id integer
);


ALTER TABLE sample OWNER TO collec;

--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 324
-- Name: TABLE sample; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE sample IS 'Table des échantillons';


--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 324
-- Name: COLUMN sample.sample_creation_date; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN sample.sample_creation_date IS 'Date de création de l''enregistrement dans la base de données';


--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 324
-- Name: COLUMN sample.sample_date; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN sample.sample_date IS 'Date de création de l''échantillon physique';


--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 324
-- Name: COLUMN sample.multiple_value; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN sample.multiple_value IS 'Nombre initial de sous-échantillons';


--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 324
-- Name: COLUMN sample.dbuid_origin; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN sample.dbuid_origin IS 'référence utilisée dans la base de données d''origine, sous la forme db:uid
Utilisé pour lire les étiquettes créées dans d''autres instances';


--
-- TOC entry 343 (class 1259 OID 27495)
-- Name: sample_metadata; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE sample_metadata (
    sample_metadata_id integer NOT NULL,
    data json
);


ALTER TABLE sample_metadata OWNER TO collec;

--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 343
-- Name: TABLE sample_metadata; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE sample_metadata IS 'Table des métadonnées';


--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 343
-- Name: COLUMN sample_metadata.data; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN sample_metadata.data IS 'Métadonnées en JSON';


--
-- TOC entry 342 (class 1259 OID 27493)
-- Name: sample_metadata_sample_metadata_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE sample_metadata_sample_metadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sample_metadata_sample_metadata_id_seq OWNER TO collec;

--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 342
-- Name: sample_metadata_sample_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE sample_metadata_sample_metadata_id_seq OWNED BY sample_metadata.sample_metadata_id;


--
-- TOC entry 323 (class 1259 OID 27211)
-- Name: sample_sample_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE sample_sample_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sample_sample_id_seq OWNER TO collec;

--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 323
-- Name: sample_sample_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE sample_sample_id_seq OWNED BY sample.sample_id;


--
-- TOC entry 326 (class 1259 OID 27229)
-- Name: sample_type; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE sample_type (
    sample_type_id integer NOT NULL,
    sample_type_name character varying NOT NULL,
    container_type_id integer,
    operation_id integer,
    multiple_type_id integer,
    multiple_unit character varying
);


ALTER TABLE sample_type OWNER TO collec;

--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 326
-- Name: TABLE sample_type; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE sample_type IS 'Types d''échantillons';


--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN sample_type.multiple_unit; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN sample_type.multiple_unit IS 'Unité caractérisant le sous-échantillon';


--
-- TOC entry 325 (class 1259 OID 27227)
-- Name: sample_type_sample_type_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE sample_type_sample_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sample_type_sample_type_id_seq OWNER TO collec;

--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 325
-- Name: sample_type_sample_type_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE sample_type_sample_type_id_seq OWNED BY sample_type.sample_type_id;


--
-- TOC entry 339 (class 1259 OID 27465)
-- Name: sampling_place; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE sampling_place (
    sampling_place_id integer NOT NULL,
    sampling_place_name character varying NOT NULL
);


ALTER TABLE sampling_place OWNER TO collec;

--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 339
-- Name: TABLE sampling_place; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE sampling_place IS 'Table des lieux génériques d''échantillonnage';


--
-- TOC entry 338 (class 1259 OID 27463)
-- Name: sampling_place_sampling_place_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE sampling_place_sampling_place_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sampling_place_sampling_place_id_seq OWNER TO collec;

--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 338
-- Name: sampling_place_sampling_place_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE sampling_place_sampling_place_id_seq OWNED BY sampling_place.sampling_place_id;


--
-- TOC entry 330 (class 1259 OID 27251)
-- Name: storage_condition; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE storage_condition (
    storage_condition_id integer NOT NULL,
    storage_condition_name character varying NOT NULL
);


ALTER TABLE storage_condition OWNER TO collec;

--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 330
-- Name: TABLE storage_condition; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE storage_condition IS 'Condition de stockage';


--
-- TOC entry 329 (class 1259 OID 27249)
-- Name: storage_condition_storage_condition_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE storage_condition_storage_condition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE storage_condition_storage_condition_id_seq OWNER TO collec;

--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 329
-- Name: storage_condition_storage_condition_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE storage_condition_storage_condition_id_seq OWNED BY storage_condition.storage_condition_id;


--
-- TOC entry 332 (class 1259 OID 27262)
-- Name: storage_reason; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE storage_reason (
    storage_reason_id integer NOT NULL,
    storage_reason_name character varying NOT NULL
);


ALTER TABLE storage_reason OWNER TO collec;

--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 332
-- Name: TABLE storage_reason; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE storage_reason IS 'Table des raisons de stockage/déstockage';


--
-- TOC entry 331 (class 1259 OID 27260)
-- Name: storage_reason_storage_reason_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE storage_reason_storage_reason_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE storage_reason_storage_reason_id_seq OWNER TO collec;

--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 331
-- Name: storage_reason_storage_reason_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE storage_reason_storage_reason_id_seq OWNED BY storage_reason.storage_reason_id;


--
-- TOC entry 327 (class 1259 OID 27238)
-- Name: storage_storage_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE storage_storage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE storage_storage_id_seq OWNER TO collec;

--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 327
-- Name: storage_storage_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE storage_storage_id_seq OWNED BY storage.storage_id;


--
-- TOC entry 334 (class 1259 OID 27273)
-- Name: subsample; Type: TABLE; Schema: zaalpes; Owner: collec
--

CREATE TABLE subsample (
    subsample_id integer NOT NULL,
    sample_id integer NOT NULL,
    subsample_date timestamp without time zone NOT NULL,
    movement_type_id integer NOT NULL,
    subsample_quantity double precision,
    subsample_comment character varying,
    subsample_login character varying NOT NULL
);


ALTER TABLE subsample OWNER TO collec;

--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 334
-- Name: TABLE subsample; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON TABLE subsample IS 'Table des prélèvements et restitutions de sous-échantillons';


--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 334
-- Name: COLUMN subsample.subsample_date; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN subsample.subsample_date IS 'Date/heure de l''opération';


--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 334
-- Name: COLUMN subsample.subsample_quantity; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN subsample.subsample_quantity IS 'Quantité prélevée ou restituée';


--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 334
-- Name: COLUMN subsample.subsample_login; Type: COMMENT; Schema: zaalpes; Owner: collec
--

COMMENT ON COLUMN subsample.subsample_login IS 'Login de l''utilisateur ayant réalisé l''opération';


--
-- TOC entry 333 (class 1259 OID 27271)
-- Name: subsample_subsample_id_seq; Type: SEQUENCE; Schema: zaalpes; Owner: collec
--

CREATE SEQUENCE subsample_subsample_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subsample_subsample_id_seq OWNER TO collec;

--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 333
-- Name: subsample_subsample_id_seq; Type: SEQUENCE OWNED BY; Schema: zaalpes; Owner: collec
--

ALTER SEQUENCE subsample_subsample_id_seq OWNED BY subsample.subsample_id;


--
-- TOC entry 337 (class 1259 OID 27455)
-- Name: v_object_identifier; Type: VIEW; Schema: zaalpes; Owner: collec
--

CREATE VIEW v_object_identifier AS
 SELECT object_identifier.uid,
    array_to_string(array_agg((((identifier_type.identifier_type_code)::text || ':'::text) || (object_identifier.object_identifier_value)::text) ORDER BY identifier_type.identifier_type_code, object_identifier.object_identifier_value), ','::text) AS identifiers
   FROM (object_identifier
     JOIN identifier_type USING (identifier_type_id))
  GROUP BY object_identifier.uid
  ORDER BY object_identifier.uid;


ALTER TABLE v_object_identifier OWNER TO collec;

SET search_path = zapvs, pg_catalog;

--
-- TOC entry 344 (class 1259 OID 35078)
-- Name: aclgroup; Type: VIEW; Schema: zapvs; Owner: collec
--

CREATE VIEW aclgroup AS
 SELECT aclgroup.aclgroup_id,
    aclgroup.groupe,
    aclgroup.aclgroup_id_parent
   FROM gacl.aclgroup;


ALTER TABLE aclgroup OWNER TO collec;

--
-- TOC entry 346 (class 1259 OID 35084)
-- Name: booking; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE booking (
    booking_id integer NOT NULL,
    uid integer NOT NULL,
    booking_date timestamp without time zone NOT NULL,
    date_from timestamp without time zone NOT NULL,
    date_to timestamp without time zone NOT NULL,
    booking_comment character varying,
    booking_login character varying NOT NULL
);


ALTER TABLE booking OWNER TO collec;

--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 346
-- Name: TABLE booking; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE booking IS 'Table des réservations d''objets';


--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 346
-- Name: COLUMN booking.booking_date; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN booking.booking_date IS 'Date de la réservation';


--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 346
-- Name: COLUMN booking.date_from; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN booking.date_from IS 'Date-heure de début de la réservation';


--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 346
-- Name: COLUMN booking.date_to; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN booking.date_to IS 'Date-heure de fin de la réservation';


--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 346
-- Name: COLUMN booking.booking_comment; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN booking.booking_comment IS 'Commentaire';


--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 346
-- Name: COLUMN booking.booking_login; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN booking.booking_login IS 'Compte ayant réalisé la réservation';


--
-- TOC entry 345 (class 1259 OID 35082)
-- Name: booking_booking_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE booking_booking_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE booking_booking_id_seq OWNER TO collec;

--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 345
-- Name: booking_booking_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE booking_booking_id_seq OWNED BY booking.booking_id;


--
-- TOC entry 348 (class 1259 OID 35095)
-- Name: container; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE container (
    container_id integer NOT NULL,
    uid integer NOT NULL,
    container_type_id integer NOT NULL
);


ALTER TABLE container OWNER TO collec;

--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 348
-- Name: TABLE container; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE container IS 'Liste des conteneurs d''échantillon';


--
-- TOC entry 347 (class 1259 OID 35093)
-- Name: container_container_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE container_container_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE container_container_id_seq OWNER TO collec;

--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 347
-- Name: container_container_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE container_container_id_seq OWNED BY container.container_id;


--
-- TOC entry 350 (class 1259 OID 35103)
-- Name: container_family; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE container_family (
    container_family_id integer NOT NULL,
    container_family_name character varying NOT NULL,
    is_movable boolean DEFAULT true NOT NULL
);


ALTER TABLE container_family OWNER TO collec;

--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 350
-- Name: TABLE container_family; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE container_family IS 'Famille générique des conteneurs';


--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 350
-- Name: COLUMN container_family.is_movable; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN container_family.is_movable IS 'Indique si la famille de conteneurs est déplçable facilement ou non (éprouvette : oui, armoire : non)';


--
-- TOC entry 349 (class 1259 OID 35101)
-- Name: container_family_container_family_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE container_family_container_family_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE container_family_container_family_id_seq OWNER TO collec;

--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 349
-- Name: container_family_container_family_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE container_family_container_family_id_seq OWNED BY container_family.container_family_id;


--
-- TOC entry 352 (class 1259 OID 35115)
-- Name: container_type; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE container_type (
    container_type_id integer NOT NULL,
    container_type_name character varying NOT NULL,
    container_family_id integer NOT NULL,
    storage_condition_id integer,
    label_id integer,
    container_type_description character varying,
    storage_product character varying,
    clp_classification character varying
);


ALTER TABLE container_type OWNER TO collec;

--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 352
-- Name: TABLE container_type; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE container_type IS 'Table des types de conteneurs';


--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 352
-- Name: COLUMN container_type.container_type_description; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN container_type.container_type_description IS 'Description longue';


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 352
-- Name: COLUMN container_type.storage_product; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN container_type.storage_product IS 'Produit utilisé pour le stockage (formol, alcool...)';


--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 352
-- Name: COLUMN container_type.clp_classification; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN container_type.clp_classification IS 'Classification du risque conformément à la directive européenne CLP';


--
-- TOC entry 351 (class 1259 OID 35113)
-- Name: container_type_container_type_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE container_type_container_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE container_type_container_type_id_seq OWNER TO collec;

--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 351
-- Name: container_type_container_type_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE container_type_container_type_id_seq OWNED BY container_type.container_type_id;


--
-- TOC entry 354 (class 1259 OID 35126)
-- Name: document; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE document (
    document_id integer NOT NULL,
    uid integer NOT NULL,
    mime_type_id integer NOT NULL,
    document_import_date timestamp without time zone NOT NULL,
    document_name character varying NOT NULL,
    document_description character varying,
    data bytea,
    thumbnail bytea,
    size integer,
    document_creation_date timestamp without time zone
);


ALTER TABLE document OWNER TO collec;

--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 354
-- Name: TABLE document; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE document IS 'Documents numériques rattachés à un poisson ou à un événement';


--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 354
-- Name: COLUMN document.document_import_date; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN document.document_import_date IS 'Date d''import dans la base de données';


--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 354
-- Name: COLUMN document.document_name; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN document.document_name IS 'Nom d''origine du document';


--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 354
-- Name: COLUMN document.document_description; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN document.document_description IS 'Description libre du document';


--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 354
-- Name: COLUMN document.data; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN document.data IS 'Contenu du document';


--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 354
-- Name: COLUMN document.thumbnail; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN document.thumbnail IS 'Vignette au format PNG (documents pdf, jpg ou png)';


--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 354
-- Name: COLUMN document.size; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN document.size IS 'Taille du fichier téléchargé';


--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 354
-- Name: COLUMN document.document_creation_date; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN document.document_creation_date IS 'Date de création du document (date de prise de vue de la photo)';


--
-- TOC entry 353 (class 1259 OID 35124)
-- Name: document_document_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE document_document_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE document_document_id_seq OWNER TO collec;

--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 353
-- Name: document_document_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE document_document_id_seq OWNED BY document.document_id;


--
-- TOC entry 356 (class 1259 OID 35137)
-- Name: event; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE event (
    event_id integer NOT NULL,
    uid integer NOT NULL,
    event_date timestamp without time zone NOT NULL,
    event_type_id integer NOT NULL,
    still_available character varying,
    event_comment character varying
);


ALTER TABLE event OWNER TO collec;

--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 356
-- Name: TABLE event; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE event IS 'Table des événements';


--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 356
-- Name: COLUMN event.event_date; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN event.event_date IS 'Date / heure de l''événement';


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 356
-- Name: COLUMN event.still_available; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN event.still_available IS 'définit ce qu''il reste de disponible dans l''objet';


--
-- TOC entry 355 (class 1259 OID 35135)
-- Name: event_event_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE event_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_event_id_seq OWNER TO collec;

--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 355
-- Name: event_event_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE event_event_id_seq OWNED BY event.event_id;


--
-- TOC entry 358 (class 1259 OID 35148)
-- Name: event_type; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE event_type (
    event_type_id integer NOT NULL,
    event_type_name character varying NOT NULL,
    is_sample boolean DEFAULT false NOT NULL,
    is_container boolean DEFAULT false NOT NULL
);


ALTER TABLE event_type OWNER TO collec;

--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 358
-- Name: TABLE event_type; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE event_type IS 'Types d''événement';


--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 358
-- Name: COLUMN event_type.is_sample; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN event_type.is_sample IS 'L''événement s''applique aux échantillons';


--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 358
-- Name: COLUMN event_type.is_container; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN event_type.is_container IS 'L''événement s''applique aux conteneurs';


--
-- TOC entry 357 (class 1259 OID 35146)
-- Name: event_type_event_type_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE event_type_event_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_type_event_type_id_seq OWNER TO collec;

--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 357
-- Name: event_type_event_type_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE event_type_event_type_id_seq OWNED BY event_type.event_type_id;


--
-- TOC entry 360 (class 1259 OID 35161)
-- Name: identifier_type; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE identifier_type (
    identifier_type_id integer NOT NULL,
    identifier_type_name character varying NOT NULL,
    identifier_type_code character varying NOT NULL
);


ALTER TABLE identifier_type OWNER TO collec;

--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 360
-- Name: TABLE identifier_type; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE identifier_type IS 'Table des types d''identifiants';


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 360
-- Name: COLUMN identifier_type.identifier_type_name; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN identifier_type.identifier_type_name IS 'Nom textuel de l''identifiant';


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 360
-- Name: COLUMN identifier_type.identifier_type_code; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN identifier_type.identifier_type_code IS 'Code utilisé pour la génération des étiquettes';


--
-- TOC entry 359 (class 1259 OID 35159)
-- Name: identifier_type_identifier_type_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE identifier_type_identifier_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identifier_type_identifier_type_id_seq OWNER TO collec;

--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 359
-- Name: identifier_type_identifier_type_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE identifier_type_identifier_type_id_seq OWNED BY identifier_type.identifier_type_id;


--
-- TOC entry 362 (class 1259 OID 35172)
-- Name: label; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE label (
    label_id integer NOT NULL,
    label_name character varying NOT NULL,
    label_xsl character varying NOT NULL,
    label_fields character varying DEFAULT 'uid,id,clp,db'::character varying NOT NULL,
    operation_id integer
);


ALTER TABLE label OWNER TO collec;

--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 362
-- Name: TABLE label; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE label IS 'Table des modèles d''étiquettes';


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 362
-- Name: COLUMN label.label_name; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN label.label_name IS 'Nom du modèle';


--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 362
-- Name: COLUMN label.label_xsl; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN label.label_xsl IS 'Contenu du fichier XSL utilisé pour la transformation FOP (https://xmlgraphics.apache.org/fop/)';


--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 362
-- Name: COLUMN label.label_fields; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN label.label_fields IS 'Liste des champs à intégrer dans le QRCODE, séparés par une virgule';


--
-- TOC entry 361 (class 1259 OID 35170)
-- Name: label_label_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE label_label_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE label_label_id_seq OWNER TO collec;

--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 361
-- Name: label_label_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE label_label_id_seq OWNED BY label.label_id;


--
-- TOC entry 387 (class 1259 OID 35352)
-- Name: storage; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE storage (
    storage_id integer NOT NULL,
    uid integer NOT NULL,
    container_id integer,
    movement_type_id integer NOT NULL,
    storage_reason_id integer,
    storage_date timestamp without time zone NOT NULL,
    storage_location character varying,
    login character varying NOT NULL,
    storage_comment character varying
);


ALTER TABLE storage OWNER TO collec;

--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 387
-- Name: TABLE storage; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE storage IS 'Gestion du stockage des échantillons';


--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 387
-- Name: COLUMN storage.storage_date; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN storage.storage_date IS 'Date/heure du mouvement';


--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 387
-- Name: COLUMN storage.storage_location; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN storage.storage_location IS 'Emplacement de l''échantillon dans le conteneur';


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 387
-- Name: COLUMN storage.login; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN storage.login IS 'Nom de l''utilisateur ayant réalisé l''opération';


--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 387
-- Name: COLUMN storage.storage_comment; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN storage.storage_comment IS 'Commentaire';


--
-- TOC entry 394 (class 1259 OID 35559)
-- Name: last_movement; Type: VIEW; Schema: zapvs; Owner: collec
--

CREATE VIEW last_movement AS
 SELECT s.uid,
    s.storage_id,
    s.storage_date,
    s.movement_type_id,
    s.container_id,
    c.uid AS container_uid
   FROM (storage s
     LEFT JOIN container c USING (container_id))
  WHERE (s.storage_id = ( SELECT st.storage_id
           FROM storage st
          WHERE (s.uid = st.uid)
          ORDER BY st.storage_date DESC
         LIMIT 1));


ALTER TABLE last_movement OWNER TO collec;

--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 394
-- Name: VIEW last_movement; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON VIEW last_movement IS 'Dernier mouvement d''un objet';


--
-- TOC entry 395 (class 1259 OID 35563)
-- Name: last_photo; Type: VIEW; Schema: zapvs; Owner: collec
--

CREATE VIEW last_photo AS
 SELECT d.document_id,
    d.uid
   FROM document d
  WHERE (d.document_id = ( SELECT d1.document_id
           FROM document d1
          WHERE ((d1.mime_type_id = ANY (ARRAY[4, 5, 6])) AND (d.uid = d1.uid))
          ORDER BY d1.document_creation_date DESC, d1.document_import_date DESC, d1.document_id DESC
         LIMIT 1));


ALTER TABLE last_photo OWNER TO collec;

--
-- TOC entry 400 (class 1259 OID 35593)
-- Name: metadata_form; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE metadata_form (
    metadata_form_id integer NOT NULL,
    metadata_schema json
);


ALTER TABLE metadata_form OWNER TO collec;

--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 400
-- Name: TABLE metadata_form; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE metadata_form IS 'Table des schémas des formulaires de métadonnées';


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 400
-- Name: COLUMN metadata_form.metadata_schema; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN metadata_form.metadata_schema IS 'Schéma en JSON du formulaire des métadonnées ';


--
-- TOC entry 399 (class 1259 OID 35591)
-- Name: metadata_form_metadata_form_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE metadata_form_metadata_form_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE metadata_form_metadata_form_id_seq OWNER TO collec;

--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 399
-- Name: metadata_form_metadata_form_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE metadata_form_metadata_form_id_seq OWNED BY metadata_form.metadata_form_id;


--
-- TOC entry 364 (class 1259 OID 35220)
-- Name: mime_type; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE mime_type (
    mime_type_id integer NOT NULL,
    extension character varying NOT NULL,
    content_type character varying NOT NULL
);


ALTER TABLE mime_type OWNER TO collec;

--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 364
-- Name: TABLE mime_type; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE mime_type IS 'Types mime des fichiers importés';


--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 364
-- Name: COLUMN mime_type.extension; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN mime_type.extension IS 'Extension du fichier correspondant';


--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 364
-- Name: COLUMN mime_type.content_type; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN mime_type.content_type IS 'type mime officiel';


--
-- TOC entry 363 (class 1259 OID 35218)
-- Name: mime_type_mime_type_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE mime_type_mime_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mime_type_mime_type_id_seq OWNER TO collec;

--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 363
-- Name: mime_type_mime_type_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE mime_type_mime_type_id_seq OWNED BY mime_type.mime_type_id;


--
-- TOC entry 366 (class 1259 OID 35231)
-- Name: movement_type; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE movement_type (
    movement_type_id integer NOT NULL,
    movement_type_name character varying NOT NULL
);


ALTER TABLE movement_type OWNER TO collec;

--
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 366
-- Name: TABLE movement_type; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE movement_type IS 'Type de mouvement';


--
-- TOC entry 365 (class 1259 OID 35229)
-- Name: movement_type_movement_type_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE movement_type_movement_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE movement_type_movement_type_id_seq OWNER TO collec;

--
-- TOC entry 5194 (class 0 OID 0)
-- Dependencies: 365
-- Name: movement_type_movement_type_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE movement_type_movement_type_id_seq OWNED BY movement_type.movement_type_id;


--
-- TOC entry 368 (class 1259 OID 35242)
-- Name: multiple_type; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE multiple_type (
    multiple_type_id integer NOT NULL,
    multiple_type_name character varying NOT NULL
);


ALTER TABLE multiple_type OWNER TO collec;

--
-- TOC entry 5195 (class 0 OID 0)
-- Dependencies: 368
-- Name: TABLE multiple_type; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE multiple_type IS 'Table des types de contenus multiples';


--
-- TOC entry 367 (class 1259 OID 35240)
-- Name: multiple_type_multiple_type_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE multiple_type_multiple_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE multiple_type_multiple_type_id_seq OWNER TO collec;

--
-- TOC entry 5196 (class 0 OID 0)
-- Dependencies: 367
-- Name: multiple_type_multiple_type_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE multiple_type_multiple_type_id_seq OWNED BY multiple_type.multiple_type_id;


--
-- TOC entry 370 (class 1259 OID 35253)
-- Name: object; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE object (
    uid integer NOT NULL,
    identifier character varying,
    object_status_id integer,
    wgs84_x double precision,
    wgs84_y double precision
);


ALTER TABLE object OWNER TO collec;

--
-- TOC entry 5197 (class 0 OID 0)
-- Dependencies: 370
-- Name: TABLE object; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE object IS 'Table des objets
Contient les identifiants génériques';


--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 370
-- Name: COLUMN object.identifier; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN object.identifier IS 'Identifiant fourni le cas échéant par le projet';


--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 370
-- Name: COLUMN object.wgs84_x; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN object.wgs84_x IS 'Longitude GPS, en valeur décimale';


--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 370
-- Name: COLUMN object.wgs84_y; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN object.wgs84_y IS 'Latitude GPS, en décimal';


--
-- TOC entry 372 (class 1259 OID 35264)
-- Name: object_identifier; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE object_identifier (
    object_identifier_id integer NOT NULL,
    uid integer NOT NULL,
    identifier_type_id integer NOT NULL,
    object_identifier_value character varying NOT NULL
);


ALTER TABLE object_identifier OWNER TO collec;

--
-- TOC entry 5201 (class 0 OID 0)
-- Dependencies: 372
-- Name: TABLE object_identifier; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE object_identifier IS 'Table des identifiants complémentaires normalisés';


--
-- TOC entry 5202 (class 0 OID 0)
-- Dependencies: 372
-- Name: COLUMN object_identifier.object_identifier_value; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN object_identifier.object_identifier_value IS 'Valeur de l''identifiant';


--
-- TOC entry 371 (class 1259 OID 35262)
-- Name: object_identifier_object_identifier_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE object_identifier_object_identifier_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE object_identifier_object_identifier_id_seq OWNER TO collec;

--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 371
-- Name: object_identifier_object_identifier_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE object_identifier_object_identifier_id_seq OWNED BY object_identifier.object_identifier_id;


--
-- TOC entry 374 (class 1259 OID 35275)
-- Name: object_status; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE object_status (
    object_status_id integer NOT NULL,
    object_status_name character varying NOT NULL
);


ALTER TABLE object_status OWNER TO collec;

--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 374
-- Name: TABLE object_status; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE object_status IS 'Table des statuts possibles des objets';


--
-- TOC entry 373 (class 1259 OID 35273)
-- Name: object_status_object_status_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE object_status_object_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE object_status_object_status_id_seq OWNER TO collec;

--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 373
-- Name: object_status_object_status_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE object_status_object_status_id_seq OWNED BY object_status.object_status_id;


--
-- TOC entry 369 (class 1259 OID 35251)
-- Name: object_uid_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE object_uid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE object_uid_seq OWNER TO collec;

--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 369
-- Name: object_uid_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE object_uid_seq OWNED BY object.uid;


--
-- TOC entry 376 (class 1259 OID 35286)
-- Name: operation; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE operation (
    operation_id integer NOT NULL,
    protocol_id integer NOT NULL,
    operation_name character varying NOT NULL,
    operation_order integer,
    metadata_form_id integer,
    operation_version character varying,
    last_edit_date timestamp without time zone
);


ALTER TABLE operation OWNER TO collec;

--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 376
-- Name: COLUMN operation.operation_order; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN operation.operation_order IS 'Ordre de réalisation de l''opération dans le protocole';


--
-- TOC entry 5208 (class 0 OID 0)
-- Dependencies: 376
-- Name: COLUMN operation.operation_version; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN operation.operation_version IS 'Version de l''opération';


--
-- TOC entry 5209 (class 0 OID 0)
-- Dependencies: 376
-- Name: COLUMN operation.last_edit_date; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN operation.last_edit_date IS 'Date de dernière éditione l''opératon';


--
-- TOC entry 375 (class 1259 OID 35284)
-- Name: operation_operation_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE operation_operation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE operation_operation_id_seq OWNER TO collec;

--
-- TOC entry 5210 (class 0 OID 0)
-- Dependencies: 375
-- Name: operation_operation_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE operation_operation_id_seq OWNED BY operation.operation_id;


--
-- TOC entry 378 (class 1259 OID 35297)
-- Name: project; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE project (
    project_id integer NOT NULL,
    project_name character varying NOT NULL
);


ALTER TABLE project OWNER TO collec;

--
-- TOC entry 5211 (class 0 OID 0)
-- Dependencies: 378
-- Name: TABLE project; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE project IS 'Table des projets';


--
-- TOC entry 379 (class 1259 OID 35306)
-- Name: project_group; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE project_group (
    project_id integer NOT NULL,
    aclgroup_id integer NOT NULL
);


ALTER TABLE project_group OWNER TO collec;

--
-- TOC entry 5212 (class 0 OID 0)
-- Dependencies: 379
-- Name: TABLE project_group; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE project_group IS 'Table des autorisations d''accès à un projet';


--
-- TOC entry 377 (class 1259 OID 35295)
-- Name: project_project_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE project_project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project_project_id_seq OWNER TO collec;

--
-- TOC entry 5213 (class 0 OID 0)
-- Dependencies: 377
-- Name: project_project_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE project_project_id_seq OWNED BY project.project_id;


--
-- TOC entry 381 (class 1259 OID 35313)
-- Name: protocol; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE protocol (
    protocol_id integer NOT NULL,
    protocol_name character varying NOT NULL,
    protocol_file bytea,
    protocol_year smallint,
    protocol_version character varying DEFAULT 'v1.0'::character varying NOT NULL
);


ALTER TABLE protocol OWNER TO collec;

--
-- TOC entry 5214 (class 0 OID 0)
-- Dependencies: 381
-- Name: COLUMN protocol.protocol_file; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN protocol.protocol_file IS 'Description PDF du protocole';


--
-- TOC entry 5215 (class 0 OID 0)
-- Dependencies: 381
-- Name: COLUMN protocol.protocol_year; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN protocol.protocol_year IS 'Année du protocole';


--
-- TOC entry 5216 (class 0 OID 0)
-- Dependencies: 381
-- Name: COLUMN protocol.protocol_version; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN protocol.protocol_version IS 'Version du protocole';


--
-- TOC entry 380 (class 1259 OID 35311)
-- Name: protocol_protocol_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE protocol_protocol_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE protocol_protocol_id_seq OWNER TO collec;

--
-- TOC entry 5217 (class 0 OID 0)
-- Dependencies: 380
-- Name: protocol_protocol_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE protocol_protocol_id_seq OWNED BY protocol.protocol_id;


--
-- TOC entry 383 (class 1259 OID 35325)
-- Name: sample; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE sample (
    sample_id integer NOT NULL,
    uid integer NOT NULL,
    project_id integer NOT NULL,
    sample_type_id integer NOT NULL,
    sample_creation_date timestamp without time zone NOT NULL,
    sample_date timestamp without time zone,
    parent_sample_id integer,
    multiple_value double precision,
    sampling_place_id integer,
    sample_metadata_id integer,
    dbuid_origin character varying
);


ALTER TABLE sample OWNER TO collec;

--
-- TOC entry 5218 (class 0 OID 0)
-- Dependencies: 383
-- Name: TABLE sample; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE sample IS 'Table des échantillons';


--
-- TOC entry 5219 (class 0 OID 0)
-- Dependencies: 383
-- Name: COLUMN sample.sample_creation_date; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN sample.sample_creation_date IS 'Date de création de l''enregistrement dans la base de données';


--
-- TOC entry 5220 (class 0 OID 0)
-- Dependencies: 383
-- Name: COLUMN sample.sample_date; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN sample.sample_date IS 'Date de création de l''échantillon physique';


--
-- TOC entry 5221 (class 0 OID 0)
-- Dependencies: 383
-- Name: COLUMN sample.multiple_value; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN sample.multiple_value IS 'Nombre initial de sous-échantillons';


--
-- TOC entry 5222 (class 0 OID 0)
-- Dependencies: 383
-- Name: COLUMN sample.dbuid_origin; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN sample.dbuid_origin IS 'référence utilisée dans la base de données d''origine, sous la forme db:uid
Utilisé pour lire les étiquettes créées dans d''autres instances';


--
-- TOC entry 402 (class 1259 OID 35604)
-- Name: sample_metadata; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE sample_metadata (
    sample_metadata_id integer NOT NULL,
    data json
);


ALTER TABLE sample_metadata OWNER TO collec;

--
-- TOC entry 5223 (class 0 OID 0)
-- Dependencies: 402
-- Name: TABLE sample_metadata; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE sample_metadata IS 'Table des métadonnées';


--
-- TOC entry 5224 (class 0 OID 0)
-- Dependencies: 402
-- Name: COLUMN sample_metadata.data; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN sample_metadata.data IS 'Métadonnées en JSON';


--
-- TOC entry 401 (class 1259 OID 35602)
-- Name: sample_metadata_sample_metadata_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE sample_metadata_sample_metadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sample_metadata_sample_metadata_id_seq OWNER TO collec;

--
-- TOC entry 5225 (class 0 OID 0)
-- Dependencies: 401
-- Name: sample_metadata_sample_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE sample_metadata_sample_metadata_id_seq OWNED BY sample_metadata.sample_metadata_id;


--
-- TOC entry 382 (class 1259 OID 35323)
-- Name: sample_sample_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE sample_sample_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sample_sample_id_seq OWNER TO collec;

--
-- TOC entry 5226 (class 0 OID 0)
-- Dependencies: 382
-- Name: sample_sample_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE sample_sample_id_seq OWNED BY sample.sample_id;


--
-- TOC entry 385 (class 1259 OID 35341)
-- Name: sample_type; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE sample_type (
    sample_type_id integer NOT NULL,
    sample_type_name character varying NOT NULL,
    container_type_id integer,
    operation_id integer,
    multiple_type_id integer,
    multiple_unit character varying
);


ALTER TABLE sample_type OWNER TO collec;

--
-- TOC entry 5227 (class 0 OID 0)
-- Dependencies: 385
-- Name: TABLE sample_type; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE sample_type IS 'Types d''échantillons';


--
-- TOC entry 5228 (class 0 OID 0)
-- Dependencies: 385
-- Name: COLUMN sample_type.multiple_unit; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN sample_type.multiple_unit IS 'Unité caractérisant le sous-échantillon';


--
-- TOC entry 384 (class 1259 OID 35339)
-- Name: sample_type_sample_type_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE sample_type_sample_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sample_type_sample_type_id_seq OWNER TO collec;

--
-- TOC entry 5229 (class 0 OID 0)
-- Dependencies: 384
-- Name: sample_type_sample_type_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE sample_type_sample_type_id_seq OWNED BY sample_type.sample_type_id;


--
-- TOC entry 398 (class 1259 OID 35574)
-- Name: sampling_place; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE sampling_place (
    sampling_place_id integer NOT NULL,
    sampling_place_name character varying NOT NULL
);


ALTER TABLE sampling_place OWNER TO collec;

--
-- TOC entry 5230 (class 0 OID 0)
-- Dependencies: 398
-- Name: TABLE sampling_place; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE sampling_place IS 'Table des lieux génériques d''échantillonnage';


--
-- TOC entry 397 (class 1259 OID 35572)
-- Name: sampling_place_sampling_place_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE sampling_place_sampling_place_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sampling_place_sampling_place_id_seq OWNER TO collec;

--
-- TOC entry 5231 (class 0 OID 0)
-- Dependencies: 397
-- Name: sampling_place_sampling_place_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE sampling_place_sampling_place_id_seq OWNED BY sampling_place.sampling_place_id;


--
-- TOC entry 389 (class 1259 OID 35363)
-- Name: storage_condition; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE storage_condition (
    storage_condition_id integer NOT NULL,
    storage_condition_name character varying NOT NULL
);


ALTER TABLE storage_condition OWNER TO collec;

--
-- TOC entry 5232 (class 0 OID 0)
-- Dependencies: 389
-- Name: TABLE storage_condition; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE storage_condition IS 'Condition de stockage';


--
-- TOC entry 388 (class 1259 OID 35361)
-- Name: storage_condition_storage_condition_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE storage_condition_storage_condition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE storage_condition_storage_condition_id_seq OWNER TO collec;

--
-- TOC entry 5233 (class 0 OID 0)
-- Dependencies: 388
-- Name: storage_condition_storage_condition_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE storage_condition_storage_condition_id_seq OWNED BY storage_condition.storage_condition_id;


--
-- TOC entry 391 (class 1259 OID 35374)
-- Name: storage_reason; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE storage_reason (
    storage_reason_id integer NOT NULL,
    storage_reason_name character varying NOT NULL
);


ALTER TABLE storage_reason OWNER TO collec;

--
-- TOC entry 5234 (class 0 OID 0)
-- Dependencies: 391
-- Name: TABLE storage_reason; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE storage_reason IS 'Table des raisons de stockage/déstockage';


--
-- TOC entry 390 (class 1259 OID 35372)
-- Name: storage_reason_storage_reason_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE storage_reason_storage_reason_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE storage_reason_storage_reason_id_seq OWNER TO collec;

--
-- TOC entry 5235 (class 0 OID 0)
-- Dependencies: 390
-- Name: storage_reason_storage_reason_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE storage_reason_storage_reason_id_seq OWNED BY storage_reason.storage_reason_id;


--
-- TOC entry 386 (class 1259 OID 35350)
-- Name: storage_storage_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE storage_storage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE storage_storage_id_seq OWNER TO collec;

--
-- TOC entry 5236 (class 0 OID 0)
-- Dependencies: 386
-- Name: storage_storage_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE storage_storage_id_seq OWNED BY storage.storage_id;


--
-- TOC entry 393 (class 1259 OID 35385)
-- Name: subsample; Type: TABLE; Schema: zapvs; Owner: collec
--

CREATE TABLE subsample (
    subsample_id integer NOT NULL,
    sample_id integer NOT NULL,
    subsample_date timestamp without time zone NOT NULL,
    movement_type_id integer NOT NULL,
    subsample_quantity double precision,
    subsample_comment character varying,
    subsample_login character varying NOT NULL
);


ALTER TABLE subsample OWNER TO collec;

--
-- TOC entry 5237 (class 0 OID 0)
-- Dependencies: 393
-- Name: TABLE subsample; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON TABLE subsample IS 'Table des prélèvements et restitutions de sous-échantillons';


--
-- TOC entry 5238 (class 0 OID 0)
-- Dependencies: 393
-- Name: COLUMN subsample.subsample_date; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN subsample.subsample_date IS 'Date/heure de l''opération';


--
-- TOC entry 5239 (class 0 OID 0)
-- Dependencies: 393
-- Name: COLUMN subsample.subsample_quantity; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN subsample.subsample_quantity IS 'Quantité prélevée ou restituée';


--
-- TOC entry 5240 (class 0 OID 0)
-- Dependencies: 393
-- Name: COLUMN subsample.subsample_login; Type: COMMENT; Schema: zapvs; Owner: collec
--

COMMENT ON COLUMN subsample.subsample_login IS 'Login de l''utilisateur ayant réalisé l''opération';


--
-- TOC entry 392 (class 1259 OID 35383)
-- Name: subsample_subsample_id_seq; Type: SEQUENCE; Schema: zapvs; Owner: collec
--

CREATE SEQUENCE subsample_subsample_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subsample_subsample_id_seq OWNER TO collec;

--
-- TOC entry 5241 (class 0 OID 0)
-- Dependencies: 392
-- Name: subsample_subsample_id_seq; Type: SEQUENCE OWNED BY; Schema: zapvs; Owner: collec
--

ALTER SEQUENCE subsample_subsample_id_seq OWNED BY subsample.subsample_id;


--
-- TOC entry 396 (class 1259 OID 35567)
-- Name: v_object_identifier; Type: VIEW; Schema: zapvs; Owner: collec
--

CREATE VIEW v_object_identifier AS
 SELECT object_identifier.uid,
    array_to_string(array_agg((((identifier_type.identifier_type_code)::text || ':'::text) || (object_identifier.object_identifier_value)::text) ORDER BY identifier_type.identifier_type_code, object_identifier.object_identifier_value), ','::text) AS identifiers
   FROM (object_identifier
     JOIN identifier_type USING (identifier_type_id))
  GROUP BY object_identifier.uid
  ORDER BY object_identifier.uid;


ALTER TABLE v_object_identifier OWNER TO collec;

SET search_path = col, pg_catalog;

--
-- TOC entry 4194 (class 2604 OID 18185)
-- Name: booking_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY booking ALTER COLUMN booking_id SET DEFAULT nextval('booking_booking_id_seq'::regclass);


--
-- TOC entry 4195 (class 2604 OID 18196)
-- Name: container_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container ALTER COLUMN container_id SET DEFAULT nextval('container_container_id_seq'::regclass);


--
-- TOC entry 4196 (class 2604 OID 18204)
-- Name: container_family_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container_family ALTER COLUMN container_family_id SET DEFAULT nextval('container_family_container_family_id_seq'::regclass);


--
-- TOC entry 4198 (class 2604 OID 18216)
-- Name: container_type_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container_type ALTER COLUMN container_type_id SET DEFAULT nextval('container_type_container_type_id_seq'::regclass);


--
-- TOC entry 4199 (class 2604 OID 18227)
-- Name: document_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY document ALTER COLUMN document_id SET DEFAULT nextval('document_document_id_seq'::regclass);


--
-- TOC entry 4200 (class 2604 OID 18238)
-- Name: event_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY event ALTER COLUMN event_id SET DEFAULT nextval('event_event_id_seq'::regclass);


--
-- TOC entry 4201 (class 2604 OID 18249)
-- Name: event_type_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY event_type ALTER COLUMN event_type_id SET DEFAULT nextval('event_type_event_type_id_seq'::regclass);


--
-- TOC entry 4204 (class 2604 OID 18262)
-- Name: identifier_type_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY identifier_type ALTER COLUMN identifier_type_id SET DEFAULT nextval('identifier_type_identifier_type_id_seq'::regclass);


--
-- TOC entry 4205 (class 2604 OID 18273)
-- Name: label_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY label ALTER COLUMN label_id SET DEFAULT nextval('label_label_id_seq'::regclass);


--
-- TOC entry 4224 (class 2604 OID 26891)
-- Name: metadata_form_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY metadata_form ALTER COLUMN metadata_form_id SET DEFAULT nextval('metadata_form_metadata_form_id_seq'::regclass);


--
-- TOC entry 4207 (class 2604 OID 18321)
-- Name: mime_type_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY mime_type ALTER COLUMN mime_type_id SET DEFAULT nextval('mime_type_mime_type_id_seq'::regclass);


--
-- TOC entry 4208 (class 2604 OID 18332)
-- Name: movement_type_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY movement_type ALTER COLUMN movement_type_id SET DEFAULT nextval('movement_type_movement_type_id_seq'::regclass);


--
-- TOC entry 4209 (class 2604 OID 18343)
-- Name: multiple_type_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY multiple_type ALTER COLUMN multiple_type_id SET DEFAULT nextval('multiple_type_multiple_type_id_seq'::regclass);


--
-- TOC entry 4210 (class 2604 OID 18354)
-- Name: uid; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY object ALTER COLUMN uid SET DEFAULT nextval('object_uid_seq'::regclass);


--
-- TOC entry 4211 (class 2604 OID 18365)
-- Name: object_identifier_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY object_identifier ALTER COLUMN object_identifier_id SET DEFAULT nextval('object_identifier_object_identifier_id_seq'::regclass);


--
-- TOC entry 4212 (class 2604 OID 18376)
-- Name: object_status_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY object_status ALTER COLUMN object_status_id SET DEFAULT nextval('object_status_object_status_id_seq'::regclass);


--
-- TOC entry 4213 (class 2604 OID 18387)
-- Name: operation_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY operation ALTER COLUMN operation_id SET DEFAULT nextval('operation_operation_id_seq'::regclass);


--
-- TOC entry 4214 (class 2604 OID 18398)
-- Name: project_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY project ALTER COLUMN project_id SET DEFAULT nextval('project_project_id_seq'::regclass);


--
-- TOC entry 4215 (class 2604 OID 18414)
-- Name: protocol_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY protocol ALTER COLUMN protocol_id SET DEFAULT nextval('protocol_protocol_id_seq'::regclass);


--
-- TOC entry 4217 (class 2604 OID 18426)
-- Name: sample_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample ALTER COLUMN sample_id SET DEFAULT nextval('sample_sample_id_seq'::regclass);


--
-- TOC entry 4225 (class 2604 OID 26953)
-- Name: sample_metadata_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample_metadata ALTER COLUMN sample_metadata_id SET DEFAULT nextval('sample_metadata_sample_metadata_id_seq'::regclass);


--
-- TOC entry 4218 (class 2604 OID 18442)
-- Name: sample_type_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample_type ALTER COLUMN sample_type_id SET DEFAULT nextval('sample_type_sample_type_id_seq'::regclass);


--
-- TOC entry 4223 (class 2604 OID 18676)
-- Name: sampling_place_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sampling_place ALTER COLUMN sampling_place_id SET DEFAULT nextval('sampling_place_sampling_place_id_seq'::regclass);


--
-- TOC entry 4219 (class 2604 OID 18453)
-- Name: storage_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage ALTER COLUMN storage_id SET DEFAULT nextval('storage_storage_id_seq'::regclass);


--
-- TOC entry 4220 (class 2604 OID 18464)
-- Name: storage_condition_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage_condition ALTER COLUMN storage_condition_id SET DEFAULT nextval('storage_condition_storage_condition_id_seq'::regclass);


--
-- TOC entry 4221 (class 2604 OID 18475)
-- Name: storage_reason_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage_reason ALTER COLUMN storage_reason_id SET DEFAULT nextval('storage_reason_storage_reason_id_seq'::regclass);


--
-- TOC entry 4222 (class 2604 OID 18486)
-- Name: subsample_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY subsample ALTER COLUMN subsample_id SET DEFAULT nextval('subsample_subsample_id_seq'::regclass);


SET search_path = gacl, pg_catalog;

--
-- TOC entry 4185 (class 2604 OID 18061)
-- Name: aclaco_id; Type: DEFAULT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclaco ALTER COLUMN aclaco_id SET DEFAULT nextval('aclaco_aclaco_id_seq'::regclass);


--
-- TOC entry 4186 (class 2604 OID 18072)
-- Name: aclappli_id; Type: DEFAULT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclappli ALTER COLUMN aclappli_id SET DEFAULT nextval('aclappli_aclappli_id_seq'::regclass);


--
-- TOC entry 4187 (class 2604 OID 18083)
-- Name: aclgroup_id; Type: DEFAULT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclgroup ALTER COLUMN aclgroup_id SET DEFAULT nextval('aclgroup_aclgroup_id_seq'::regclass);


--
-- TOC entry 4188 (class 2604 OID 18094)
-- Name: acllogin_id; Type: DEFAULT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY acllogin ALTER COLUMN acllogin_id SET DEFAULT nextval('acllogin_acllogin_id_seq'::regclass);


--
-- TOC entry 4193 (class 2604 OID 18166)
-- Name: log_id; Type: DEFAULT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY log ALTER COLUMN log_id SET DEFAULT nextval('log_log_id_seq'::regclass);


--
-- TOC entry 4191 (class 2604 OID 18152)
-- Name: login_oldpassword_id; Type: DEFAULT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY login_oldpassword ALTER COLUMN login_oldpassword_id SET DEFAULT nextval('login_oldpassword_login_oldpassword_id_seq'::regclass);


SET search_path = zaalpes, pg_catalog;

--
-- TOC entry 4226 (class 2604 OID 26975)
-- Name: booking_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY booking ALTER COLUMN booking_id SET DEFAULT nextval('booking_booking_id_seq'::regclass);


--
-- TOC entry 4227 (class 2604 OID 26986)
-- Name: container_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY container ALTER COLUMN container_id SET DEFAULT nextval('container_container_id_seq'::regclass);


--
-- TOC entry 4228 (class 2604 OID 26994)
-- Name: container_family_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY container_family ALTER COLUMN container_family_id SET DEFAULT nextval('container_family_container_family_id_seq'::regclass);


--
-- TOC entry 4230 (class 2604 OID 27006)
-- Name: container_type_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY container_type ALTER COLUMN container_type_id SET DEFAULT nextval('container_type_container_type_id_seq'::regclass);


--
-- TOC entry 4231 (class 2604 OID 27017)
-- Name: document_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY document ALTER COLUMN document_id SET DEFAULT nextval('document_document_id_seq'::regclass);


--
-- TOC entry 4232 (class 2604 OID 27028)
-- Name: event_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY event ALTER COLUMN event_id SET DEFAULT nextval('event_event_id_seq'::regclass);


--
-- TOC entry 4233 (class 2604 OID 27039)
-- Name: event_type_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY event_type ALTER COLUMN event_type_id SET DEFAULT nextval('event_type_event_type_id_seq'::regclass);


--
-- TOC entry 4236 (class 2604 OID 27052)
-- Name: identifier_type_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY identifier_type ALTER COLUMN identifier_type_id SET DEFAULT nextval('identifier_type_identifier_type_id_seq'::regclass);


--
-- TOC entry 4237 (class 2604 OID 27063)
-- Name: label_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY label ALTER COLUMN label_id SET DEFAULT nextval('label_label_id_seq'::regclass);


--
-- TOC entry 4256 (class 2604 OID 27487)
-- Name: metadata_form_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY metadata_form ALTER COLUMN metadata_form_id SET DEFAULT nextval('metadata_form_metadata_form_id_seq'::regclass);


--
-- TOC entry 4239 (class 2604 OID 27111)
-- Name: mime_type_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY mime_type ALTER COLUMN mime_type_id SET DEFAULT nextval('mime_type_mime_type_id_seq'::regclass);


--
-- TOC entry 4240 (class 2604 OID 27122)
-- Name: movement_type_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY movement_type ALTER COLUMN movement_type_id SET DEFAULT nextval('movement_type_movement_type_id_seq'::regclass);


--
-- TOC entry 4241 (class 2604 OID 27133)
-- Name: multiple_type_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY multiple_type ALTER COLUMN multiple_type_id SET DEFAULT nextval('multiple_type_multiple_type_id_seq'::regclass);


--
-- TOC entry 4242 (class 2604 OID 27144)
-- Name: uid; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY object ALTER COLUMN uid SET DEFAULT nextval('object_uid_seq'::regclass);


--
-- TOC entry 4243 (class 2604 OID 27155)
-- Name: object_identifier_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY object_identifier ALTER COLUMN object_identifier_id SET DEFAULT nextval('object_identifier_object_identifier_id_seq'::regclass);


--
-- TOC entry 4244 (class 2604 OID 27166)
-- Name: object_status_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY object_status ALTER COLUMN object_status_id SET DEFAULT nextval('object_status_object_status_id_seq'::regclass);


--
-- TOC entry 4245 (class 2604 OID 27177)
-- Name: operation_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY operation ALTER COLUMN operation_id SET DEFAULT nextval('operation_operation_id_seq'::regclass);


--
-- TOC entry 4246 (class 2604 OID 27188)
-- Name: project_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY project ALTER COLUMN project_id SET DEFAULT nextval('project_project_id_seq'::regclass);


--
-- TOC entry 4247 (class 2604 OID 27204)
-- Name: protocol_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY protocol ALTER COLUMN protocol_id SET DEFAULT nextval('protocol_protocol_id_seq'::regclass);


--
-- TOC entry 4249 (class 2604 OID 27216)
-- Name: sample_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY sample ALTER COLUMN sample_id SET DEFAULT nextval('sample_sample_id_seq'::regclass);


--
-- TOC entry 4257 (class 2604 OID 27498)
-- Name: sample_metadata_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY sample_metadata ALTER COLUMN sample_metadata_id SET DEFAULT nextval('sample_metadata_sample_metadata_id_seq'::regclass);


--
-- TOC entry 4250 (class 2604 OID 27232)
-- Name: sample_type_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY sample_type ALTER COLUMN sample_type_id SET DEFAULT nextval('sample_type_sample_type_id_seq'::regclass);


--
-- TOC entry 4255 (class 2604 OID 27468)
-- Name: sampling_place_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY sampling_place ALTER COLUMN sampling_place_id SET DEFAULT nextval('sampling_place_sampling_place_id_seq'::regclass);


--
-- TOC entry 4251 (class 2604 OID 27243)
-- Name: storage_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY storage ALTER COLUMN storage_id SET DEFAULT nextval('storage_storage_id_seq'::regclass);


--
-- TOC entry 4252 (class 2604 OID 27254)
-- Name: storage_condition_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY storage_condition ALTER COLUMN storage_condition_id SET DEFAULT nextval('storage_condition_storage_condition_id_seq'::regclass);


--
-- TOC entry 4253 (class 2604 OID 27265)
-- Name: storage_reason_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY storage_reason ALTER COLUMN storage_reason_id SET DEFAULT nextval('storage_reason_storage_reason_id_seq'::regclass);


--
-- TOC entry 4254 (class 2604 OID 27276)
-- Name: subsample_id; Type: DEFAULT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY subsample ALTER COLUMN subsample_id SET DEFAULT nextval('subsample_subsample_id_seq'::regclass);


SET search_path = zapvs, pg_catalog;

--
-- TOC entry 4258 (class 2604 OID 35087)
-- Name: booking_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY booking ALTER COLUMN booking_id SET DEFAULT nextval('booking_booking_id_seq'::regclass);


--
-- TOC entry 4259 (class 2604 OID 35098)
-- Name: container_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY container ALTER COLUMN container_id SET DEFAULT nextval('container_container_id_seq'::regclass);


--
-- TOC entry 4260 (class 2604 OID 35106)
-- Name: container_family_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY container_family ALTER COLUMN container_family_id SET DEFAULT nextval('container_family_container_family_id_seq'::regclass);


--
-- TOC entry 4262 (class 2604 OID 35118)
-- Name: container_type_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY container_type ALTER COLUMN container_type_id SET DEFAULT nextval('container_type_container_type_id_seq'::regclass);


--
-- TOC entry 4263 (class 2604 OID 35129)
-- Name: document_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY document ALTER COLUMN document_id SET DEFAULT nextval('document_document_id_seq'::regclass);


--
-- TOC entry 4264 (class 2604 OID 35140)
-- Name: event_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY event ALTER COLUMN event_id SET DEFAULT nextval('event_event_id_seq'::regclass);


--
-- TOC entry 4265 (class 2604 OID 35151)
-- Name: event_type_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY event_type ALTER COLUMN event_type_id SET DEFAULT nextval('event_type_event_type_id_seq'::regclass);


--
-- TOC entry 4268 (class 2604 OID 35164)
-- Name: identifier_type_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY identifier_type ALTER COLUMN identifier_type_id SET DEFAULT nextval('identifier_type_identifier_type_id_seq'::regclass);


--
-- TOC entry 4269 (class 2604 OID 35175)
-- Name: label_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY label ALTER COLUMN label_id SET DEFAULT nextval('label_label_id_seq'::regclass);


--
-- TOC entry 4288 (class 2604 OID 35596)
-- Name: metadata_form_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY metadata_form ALTER COLUMN metadata_form_id SET DEFAULT nextval('metadata_form_metadata_form_id_seq'::regclass);


--
-- TOC entry 4271 (class 2604 OID 35223)
-- Name: mime_type_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY mime_type ALTER COLUMN mime_type_id SET DEFAULT nextval('mime_type_mime_type_id_seq'::regclass);


--
-- TOC entry 4272 (class 2604 OID 35234)
-- Name: movement_type_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY movement_type ALTER COLUMN movement_type_id SET DEFAULT nextval('movement_type_movement_type_id_seq'::regclass);


--
-- TOC entry 4273 (class 2604 OID 35245)
-- Name: multiple_type_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY multiple_type ALTER COLUMN multiple_type_id SET DEFAULT nextval('multiple_type_multiple_type_id_seq'::regclass);


--
-- TOC entry 4274 (class 2604 OID 35256)
-- Name: uid; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY object ALTER COLUMN uid SET DEFAULT nextval('object_uid_seq'::regclass);


--
-- TOC entry 4275 (class 2604 OID 35267)
-- Name: object_identifier_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY object_identifier ALTER COLUMN object_identifier_id SET DEFAULT nextval('object_identifier_object_identifier_id_seq'::regclass);


--
-- TOC entry 4276 (class 2604 OID 35278)
-- Name: object_status_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY object_status ALTER COLUMN object_status_id SET DEFAULT nextval('object_status_object_status_id_seq'::regclass);


--
-- TOC entry 4277 (class 2604 OID 35289)
-- Name: operation_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY operation ALTER COLUMN operation_id SET DEFAULT nextval('operation_operation_id_seq'::regclass);


--
-- TOC entry 4278 (class 2604 OID 35300)
-- Name: project_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY project ALTER COLUMN project_id SET DEFAULT nextval('project_project_id_seq'::regclass);


--
-- TOC entry 4279 (class 2604 OID 35316)
-- Name: protocol_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY protocol ALTER COLUMN protocol_id SET DEFAULT nextval('protocol_protocol_id_seq'::regclass);


--
-- TOC entry 4281 (class 2604 OID 35328)
-- Name: sample_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY sample ALTER COLUMN sample_id SET DEFAULT nextval('sample_sample_id_seq'::regclass);


--
-- TOC entry 4289 (class 2604 OID 35607)
-- Name: sample_metadata_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY sample_metadata ALTER COLUMN sample_metadata_id SET DEFAULT nextval('sample_metadata_sample_metadata_id_seq'::regclass);


--
-- TOC entry 4282 (class 2604 OID 35344)
-- Name: sample_type_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY sample_type ALTER COLUMN sample_type_id SET DEFAULT nextval('sample_type_sample_type_id_seq'::regclass);


--
-- TOC entry 4287 (class 2604 OID 35577)
-- Name: sampling_place_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY sampling_place ALTER COLUMN sampling_place_id SET DEFAULT nextval('sampling_place_sampling_place_id_seq'::regclass);


--
-- TOC entry 4283 (class 2604 OID 35355)
-- Name: storage_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY storage ALTER COLUMN storage_id SET DEFAULT nextval('storage_storage_id_seq'::regclass);


--
-- TOC entry 4284 (class 2604 OID 35366)
-- Name: storage_condition_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY storage_condition ALTER COLUMN storage_condition_id SET DEFAULT nextval('storage_condition_storage_condition_id_seq'::regclass);


--
-- TOC entry 4285 (class 2604 OID 35377)
-- Name: storage_reason_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY storage_reason ALTER COLUMN storage_reason_id SET DEFAULT nextval('storage_reason_storage_reason_id_seq'::regclass);


--
-- TOC entry 4286 (class 2604 OID 35388)
-- Name: subsample_id; Type: DEFAULT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY subsample ALTER COLUMN subsample_id SET DEFAULT nextval('subsample_subsample_id_seq'::regclass);


SET search_path = col, pg_catalog;

--
-- TOC entry 4737 (class 0 OID 18182)
-- Dependencies: 228
-- Data for Name: booking; Type: TABLE DATA; Schema: col; Owner: collec
--



--
-- TOC entry 5242 (class 0 OID 0)
-- Dependencies: 227
-- Name: booking_booking_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('booking_booking_id_seq', 1, false);


--
-- TOC entry 4739 (class 0 OID 18193)
-- Dependencies: 230
-- Data for Name: container; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO container VALUES (1, 1, 1);


--
-- TOC entry 5243 (class 0 OID 0)
-- Dependencies: 229
-- Name: container_container_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('container_container_id_seq', 1, true);


--
-- TOC entry 4741 (class 0 OID 18201)
-- Dependencies: 232
-- Data for Name: container_family; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO container_family VALUES (1, 'Immobilier', false);
INSERT INTO container_family VALUES (2, 'Mobilier', false);


--
-- TOC entry 5244 (class 0 OID 0)
-- Dependencies: 231
-- Name: container_family_container_family_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('container_family_container_family_id_seq', 2, true);


--
-- TOC entry 4743 (class 0 OID 18213)
-- Dependencies: 234
-- Data for Name: container_type; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO container_type VALUES (2, 'Bâtiment', 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO container_type VALUES (3, 'Pièce', 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO container_type VALUES (4, 'Armoire', 2, NULL, NULL, NULL, NULL, NULL);
INSERT INTO container_type VALUES (5, 'Congélateur', 2, NULL, NULL, NULL, NULL, NULL);
INSERT INTO container_type VALUES (1, 'Site', 1, NULL, 1, NULL, NULL, NULL);


--
-- TOC entry 5245 (class 0 OID 0)
-- Dependencies: 233
-- Name: container_type_container_type_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('container_type_container_type_id_seq', 5, true);


--
-- TOC entry 4745 (class 0 OID 18224)
-- Dependencies: 236
-- Data for Name: document; Type: TABLE DATA; Schema: col; Owner: collec
--



--
-- TOC entry 5246 (class 0 OID 0)
-- Dependencies: 235
-- Name: document_document_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('document_document_id_seq', 1, false);


--
-- TOC entry 4747 (class 0 OID 18235)
-- Dependencies: 238
-- Data for Name: event; Type: TABLE DATA; Schema: col; Owner: collec
--



--
-- TOC entry 5247 (class 0 OID 0)
-- Dependencies: 237
-- Name: event_event_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('event_event_id_seq', 1, false);


--
-- TOC entry 4749 (class 0 OID 18246)
-- Dependencies: 240
-- Data for Name: event_type; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO event_type VALUES (1, 'Autre', true, true);
INSERT INTO event_type VALUES (2, 'Conteneur cassé', false, true);
INSERT INTO event_type VALUES (3, 'Échantillon détruit', true, false);
INSERT INTO event_type VALUES (4, 'Prélèvement pour analyse', true, false);
INSERT INTO event_type VALUES (5, 'Échantillon totalement analysé, détruit', true, false);


--
-- TOC entry 5248 (class 0 OID 0)
-- Dependencies: 239
-- Name: event_type_event_type_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('event_type_event_type_id_seq', 5, true);


--
-- TOC entry 4751 (class 0 OID 18259)
-- Dependencies: 242
-- Data for Name: identifier_type; Type: TABLE DATA; Schema: col; Owner: collec
--



--
-- TOC entry 5249 (class 0 OID 0)
-- Dependencies: 241
-- Name: identifier_type_identifier_type_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('identifier_type_identifier_type_id_seq', 1, false);


--
-- TOC entry 4753 (class 0 OID 18270)
-- Dependencies: 244
-- Data for Name: label; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO label VALUES (1, 'Exemple - ne pas utiliser', '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="objects">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="label"
              page-height="5cm" page-width="10cm" margin-left="0.5cm" margin-top="0.5cm" margin-bottom="0cm" margin-right="0.5cm">  
              <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      
      <fo:page-sequence master-reference="label">
         <fo:flow flow-name="xsl-region-body">        
          <fo:block>
          <xsl:apply-templates select="object" />
          </fo:block>

        </fo:flow>
      </fo:page-sequence>
    </fo:root>
   </xsl:template>
  <xsl:template match="object">

  <fo:table table-layout="fixed" border-collapse="collapse"  border-style="none" width="8cm" keep-together.within-page="always">
  <fo:table-column column-width="4cm"/>
  <fo:table-column column-width="4cm" />
 <fo:table-body  border-style="none" >
 	<fo:table-row>
  		<fo:table-cell> 
  		<fo:block>
  		<fo:external-graphic>
      <xsl:attribute name="src">
             <xsl:value-of select="concat(uid,''.png'')" />
       </xsl:attribute>
       <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
       <xsl:attribute name="height">4cm</xsl:attribute>
        <xsl:attribute name="content-width">4cm</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
      
       </fo:external-graphic>
 		</fo:block>
   		</fo:table-cell>
  		<fo:table-cell>
<fo:block><fo:inline font-weight="bold">IRSTEA</fo:inline></fo:block>
  			<fo:block>uid:<fo:inline font-weight="bold"><xsl:value-of select="db"/>:<xsl:value-of select="uid"/></fo:inline></fo:block>
  			<fo:block>id:<fo:inline font-weight="bold"><xsl:value-of select="id"/></fo:inline></fo:block>
  			<fo:block>prj:<fo:inline font-weight="bold"><xsl:value-of select="prj"/></fo:inline></fo:block>
  			<fo:block>clp:<fo:inline font-weight="bold"><xsl:value-of select="clp"/></fo:inline></fo:block>
  		</fo:table-cell>
  	  	</fo:table-row>
  </fo:table-body>
  </fo:table>
   <fo:block page-break-after="always"/>

  </xsl:template>
</xsl:stylesheet>', 'uid,id,clp,db,prj', NULL);


--
-- TOC entry 5250 (class 0 OID 0)
-- Dependencies: 243
-- Name: label_label_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('label_label_id_seq', 1, true);


--
-- TOC entry 4788 (class 0 OID 26888)
-- Dependencies: 282
-- Data for Name: metadata_form; Type: TABLE DATA; Schema: col; Owner: collec
--



--
-- TOC entry 5251 (class 0 OID 0)
-- Dependencies: 281
-- Name: metadata_form_metadata_form_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('metadata_form_metadata_form_id_seq', 1, false);


--
-- TOC entry 4755 (class 0 OID 18318)
-- Dependencies: 246
-- Data for Name: mime_type; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO mime_type VALUES (1, 'pdf', 'application/pdf');
INSERT INTO mime_type VALUES (2, 'zip', 'application/zip');
INSERT INTO mime_type VALUES (3, 'mp3', 'audio/mpeg');
INSERT INTO mime_type VALUES (4, 'jpg', 'image/jpeg');
INSERT INTO mime_type VALUES (5, 'jpeg', 'image/jpeg');
INSERT INTO mime_type VALUES (6, 'png', 'image/png');
INSERT INTO mime_type VALUES (7, 'tiff', 'image/tiff');
INSERT INTO mime_type VALUES (9, 'odt', 'application/vnd.oasis.opendocument.text');
INSERT INTO mime_type VALUES (10, 'ods', 'application/vnd.oasis.opendocument.spreadsheet');
INSERT INTO mime_type VALUES (11, 'xls', 'application/vnd.ms-excel');
INSERT INTO mime_type VALUES (12, 'xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
INSERT INTO mime_type VALUES (13, 'doc', 'application/msword');
INSERT INTO mime_type VALUES (14, 'docx', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document');
INSERT INTO mime_type VALUES (8, 'csv', 'text/csv');


--
-- TOC entry 5252 (class 0 OID 0)
-- Dependencies: 245
-- Name: mime_type_mime_type_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('mime_type_mime_type_id_seq', 1, false);


--
-- TOC entry 4757 (class 0 OID 18329)
-- Dependencies: 248
-- Data for Name: movement_type; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO movement_type VALUES (1, 'Entrée/Entry');
INSERT INTO movement_type VALUES (2, 'Sortie/Exit');


--
-- TOC entry 5253 (class 0 OID 0)
-- Dependencies: 247
-- Name: movement_type_movement_type_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('movement_type_movement_type_id_seq', 1, false);


--
-- TOC entry 4759 (class 0 OID 18340)
-- Dependencies: 250
-- Data for Name: multiple_type; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO multiple_type VALUES (1, 'Unité');
INSERT INTO multiple_type VALUES (2, 'Pourcentage');
INSERT INTO multiple_type VALUES (3, 'Quantité ou volume');
INSERT INTO multiple_type VALUES (4, 'Autre');


--
-- TOC entry 5254 (class 0 OID 0)
-- Dependencies: 249
-- Name: multiple_type_multiple_type_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('multiple_type_multiple_type_id_seq', 4, true);


--
-- TOC entry 4761 (class 0 OID 18351)
-- Dependencies: 252
-- Data for Name: object; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO object VALUES (1, 'Labo LIENSs', 1, -1.1865234375, 46.1676580274212824);
INSERT INTO object VALUES (2, 'pot piège', 1, -0.576782226562498779, 45.7966376252503835);


--
-- TOC entry 4763 (class 0 OID 18362)
-- Dependencies: 254
-- Data for Name: object_identifier; Type: TABLE DATA; Schema: col; Owner: collec
--



--
-- TOC entry 5255 (class 0 OID 0)
-- Dependencies: 253
-- Name: object_identifier_object_identifier_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('object_identifier_object_identifier_id_seq', 1, false);


--
-- TOC entry 4765 (class 0 OID 18373)
-- Dependencies: 256
-- Data for Name: object_status; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO object_status VALUES (1, 'État normal');
INSERT INTO object_status VALUES (2, 'Objet pré-réservé pour usage ultérieur');
INSERT INTO object_status VALUES (3, 'Objet détruit');
INSERT INTO object_status VALUES (4, 'Echantillon vidé de tout contenu');


--
-- TOC entry 5256 (class 0 OID 0)
-- Dependencies: 255
-- Name: object_status_object_status_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('object_status_object_status_id_seq', 4, true);


--
-- TOC entry 5257 (class 0 OID 0)
-- Dependencies: 251
-- Name: object_uid_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('object_uid_seq', 2, true);


--
-- TOC entry 4767 (class 0 OID 18384)
-- Dependencies: 258
-- Data for Name: operation; Type: TABLE DATA; Schema: col; Owner: collec
--



--
-- TOC entry 5258 (class 0 OID 0)
-- Dependencies: 257
-- Name: operation_operation_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('operation_operation_id_seq', 1, false);


--
-- TOC entry 4769 (class 0 OID 18395)
-- Dependencies: 260
-- Data for Name: project; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO project VALUES (1, 'QRcode');


--
-- TOC entry 4770 (class 0 OID 18404)
-- Dependencies: 261
-- Data for Name: project_group; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO project_group VALUES (1, 1);
INSERT INTO project_group VALUES (1, 25);
INSERT INTO project_group VALUES (1, 24);
INSERT INTO project_group VALUES (1, 22);
INSERT INTO project_group VALUES (1, 23);


--
-- TOC entry 5259 (class 0 OID 0)
-- Dependencies: 259
-- Name: project_project_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('project_project_id_seq', 1, true);


--
-- TOC entry 4772 (class 0 OID 18411)
-- Dependencies: 263
-- Data for Name: protocol; Type: TABLE DATA; Schema: col; Owner: collec
--



--
-- TOC entry 5260 (class 0 OID 0)
-- Dependencies: 262
-- Name: protocol_protocol_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('protocol_protocol_id_seq', 1, false);


--
-- TOC entry 4774 (class 0 OID 18423)
-- Dependencies: 265
-- Data for Name: sample; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO sample VALUES (1, 2, 1, 1, '2017-04-19 14:07:51', '2017-04-19 14:07:51', NULL, 3, 1, NULL, NULL);


--
-- TOC entry 4790 (class 0 OID 26950)
-- Dependencies: 284
-- Data for Name: sample_metadata; Type: TABLE DATA; Schema: col; Owner: collec
--



--
-- TOC entry 5261 (class 0 OID 0)
-- Dependencies: 283
-- Name: sample_metadata_sample_metadata_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('sample_metadata_sample_metadata_id_seq', 1, false);


--
-- TOC entry 5262 (class 0 OID 0)
-- Dependencies: 264
-- Name: sample_sample_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('sample_sample_id_seq', 1, true);


--
-- TOC entry 4776 (class 0 OID 18439)
-- Dependencies: 267
-- Data for Name: sample_type; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO sample_type VALUES (1, 'PANTRAP', 1, NULL, 1, NULL);


--
-- TOC entry 5263 (class 0 OID 0)
-- Dependencies: 266
-- Name: sample_type_sample_type_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('sample_type_sample_type_id_seq', 1, true);


--
-- TOC entry 4786 (class 0 OID 18673)
-- Dependencies: 280
-- Data for Name: sampling_place; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO sampling_place VALUES (1, 'Fors');


--
-- TOC entry 5264 (class 0 OID 0)
-- Dependencies: 279
-- Name: sampling_place_sampling_place_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('sampling_place_sampling_place_id_seq', 1, true);


--
-- TOC entry 4778 (class 0 OID 18450)
-- Dependencies: 269
-- Data for Name: storage; Type: TABLE DATA; Schema: col; Owner: collec
--



--
-- TOC entry 4780 (class 0 OID 18461)
-- Dependencies: 271
-- Data for Name: storage_condition; Type: TABLE DATA; Schema: col; Owner: collec
--



--
-- TOC entry 5265 (class 0 OID 0)
-- Dependencies: 270
-- Name: storage_condition_storage_condition_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('storage_condition_storage_condition_id_seq', 1, false);


--
-- TOC entry 4782 (class 0 OID 18472)
-- Dependencies: 273
-- Data for Name: storage_reason; Type: TABLE DATA; Schema: col; Owner: collec
--



--
-- TOC entry 5266 (class 0 OID 0)
-- Dependencies: 272
-- Name: storage_reason_storage_reason_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('storage_reason_storage_reason_id_seq', 1, false);


--
-- TOC entry 5267 (class 0 OID 0)
-- Dependencies: 268
-- Name: storage_storage_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('storage_storage_id_seq', 1, false);


--
-- TOC entry 4784 (class 0 OID 18483)
-- Dependencies: 275
-- Data for Name: subsample; Type: TABLE DATA; Schema: col; Owner: collec
--



--
-- TOC entry 5268 (class 0 OID 0)
-- Dependencies: 274
-- Name: subsample_subsample_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('subsample_subsample_id_seq', 1, false);


SET search_path = gacl, pg_catalog;

--
-- TOC entry 4720 (class 0 OID 18051)
-- Dependencies: 210
-- Data for Name: aclacl; Type: TABLE DATA; Schema: gacl; Owner: collec
--

INSERT INTO aclacl VALUES (1, 1);
INSERT INTO aclacl VALUES (2, 1);
INSERT INTO aclacl VALUES (3, 1);
INSERT INTO aclacl VALUES (4, 1);
INSERT INTO aclacl VALUES (5, 1);
INSERT INTO aclacl VALUES (2, 22);
INSERT INTO aclacl VALUES (3, 23);
INSERT INTO aclacl VALUES (4, 24);
INSERT INTO aclacl VALUES (5, 25);
INSERT INTO aclacl VALUES (11, 31);
INSERT INTO aclacl VALUES (12, 31);
INSERT INTO aclacl VALUES (1, 31);
INSERT INTO aclacl VALUES (15, 31);
INSERT INTO aclacl VALUES (14, 31);
INSERT INTO aclacl VALUES (13, 31);
INSERT INTO aclacl VALUES (15, 32);
INSERT INTO aclacl VALUES (14, 32);
INSERT INTO aclacl VALUES (13, 32);
INSERT INTO aclacl VALUES (11, 1);
INSERT INTO aclacl VALUES (12, 22);
INSERT INTO aclacl VALUES (13, 22);
INSERT INTO aclacl VALUES (14, 22);
INSERT INTO aclacl VALUES (15, 22);
INSERT INTO aclacl VALUES (16, 1);
INSERT INTO aclacl VALUES (17, 1);
INSERT INTO aclacl VALUES (18, 1);
INSERT INTO aclacl VALUES (19, 1);
INSERT INTO aclacl VALUES (20, 1);
INSERT INTO aclacl VALUES (16, 34);
INSERT INTO aclacl VALUES (17, 34);
INSERT INTO aclacl VALUES (18, 34);
INSERT INTO aclacl VALUES (19, 34);
INSERT INTO aclacl VALUES (20, 34);


--
-- TOC entry 4722 (class 0 OID 18058)
-- Dependencies: 212
-- Data for Name: aclaco; Type: TABLE DATA; Schema: gacl; Owner: collec
--

INSERT INTO aclaco VALUES (2, 1, 'param');
INSERT INTO aclaco VALUES (3, 1, 'projet');
INSERT INTO aclaco VALUES (4, 1, 'gestion');
INSERT INTO aclaco VALUES (5, 1, 'consult');
INSERT INTO aclaco VALUES (1, 1, 'admin');
INSERT INTO aclaco VALUES (11, 3, 'admin');
INSERT INTO aclaco VALUES (12, 3, 'param');
INSERT INTO aclaco VALUES (13, 3, 'projet');
INSERT INTO aclaco VALUES (14, 3, 'gestion');
INSERT INTO aclaco VALUES (15, 3, 'consult');
INSERT INTO aclaco VALUES (16, 4, 'admin');
INSERT INTO aclaco VALUES (17, 4, 'param');
INSERT INTO aclaco VALUES (18, 4, 'projet');
INSERT INTO aclaco VALUES (19, 4, 'gestion');
INSERT INTO aclaco VALUES (20, 4, 'consult');


--
-- TOC entry 5269 (class 0 OID 0)
-- Dependencies: 211
-- Name: aclaco_aclaco_id_seq; Type: SEQUENCE SET; Schema: gacl; Owner: collec
--

SELECT pg_catalog.setval('aclaco_aclaco_id_seq', 20, true);


--
-- TOC entry 4724 (class 0 OID 18069)
-- Dependencies: 214
-- Data for Name: aclappli; Type: TABLE DATA; Schema: gacl; Owner: collec
--

INSERT INTO aclappli VALUES (1, 'col', NULL);
INSERT INTO aclappli VALUES (3, 'zaalpes', 'Carottes EDYTEM de roza');
INSERT INTO aclappli VALUES (4, 'zapvs', 'Echantillons de la ZA PVS');


--
-- TOC entry 5270 (class 0 OID 0)
-- Dependencies: 213
-- Name: aclappli_aclappli_id_seq; Type: SEQUENCE SET; Schema: gacl; Owner: collec
--

SELECT pg_catalog.setval('aclappli_aclappli_id_seq', 4, true);


--
-- TOC entry 4726 (class 0 OID 18080)
-- Dependencies: 216
-- Data for Name: aclgroup; Type: TABLE DATA; Schema: gacl; Owner: collec
--

INSERT INTO aclgroup VALUES (25, 'consult_group', NULL);
INSERT INTO aclgroup VALUES (24, 'gestion_group', NULL);
INSERT INTO aclgroup VALUES (23, 'projet_group', NULL);
INSERT INTO aclgroup VALUES (32, 'iper_retro_group', NULL);
INSERT INTO aclgroup VALUES (22, 'param_group', NULL);
INSERT INTO aclgroup VALUES (31, 'admin_roza', NULL);
INSERT INTO aclgroup VALUES (1, 'admin', NULL);
INSERT INTO aclgroup VALUES (33, 'entomo_group', 24);
INSERT INTO aclgroup VALUES (34, 'admin_entomo', NULL);


--
-- TOC entry 5271 (class 0 OID 0)
-- Dependencies: 215
-- Name: aclgroup_aclgroup_id_seq; Type: SEQUENCE SET; Schema: gacl; Owner: collec
--

SELECT pg_catalog.setval('aclgroup_aclgroup_id_seq', 34, true);


--
-- TOC entry 4728 (class 0 OID 18091)
-- Dependencies: 218
-- Data for Name: acllogin; Type: TABLE DATA; Schema: gacl; Owner: collec
--

INSERT INTO acllogin VALUES (1, 'admin', 'admin');
INSERT INTO acllogin VALUES (2, 'cpignol', 'pignol cécile');
INSERT INTO acllogin VALUES (5, 'arnaud_f', 'ARNAUD Fabien');
INSERT INTO acllogin VALUES (4, 'frossard_v', 'FROSSARD V');
INSERT INTO acllogin VALUES (3, 'jenny_jp', 'JENNY Jean-Philippe');
INSERT INTO acllogin VALUES (6, 'test-collec', 'Christine Plumejeaud-Perreau');
INSERT INTO acllogin VALUES (7, 'admindemo', 'admindemo admindemo');
INSERT INTO acllogin VALUES (8, 'mroncoroni', 'RONCORONI Maryline');
INSERT INTO acllogin VALUES (9, 'tfanjas', 'Fanjasmercere Thierry');
INSERT INTO acllogin VALUES (10, 'vbretagnolle', 'BRETAGNOLLE Vincent');


--
-- TOC entry 5272 (class 0 OID 0)
-- Dependencies: 217
-- Name: acllogin_acllogin_id_seq; Type: SEQUENCE SET; Schema: gacl; Owner: collec
--

SELECT pg_catalog.setval('acllogin_acllogin_id_seq', 10, true);


--
-- TOC entry 4729 (class 0 OID 18100)
-- Dependencies: 219
-- Data for Name: acllogingroup; Type: TABLE DATA; Schema: gacl; Owner: collec
--

INSERT INTO acllogingroup VALUES (1, 1);
INSERT INTO acllogingroup VALUES (1, 22);
INSERT INTO acllogingroup VALUES (1, 23);
INSERT INTO acllogingroup VALUES (1, 24);
INSERT INTO acllogingroup VALUES (1, 25);
INSERT INTO acllogingroup VALUES (2, 22);
INSERT INTO acllogingroup VALUES (2, 25);
INSERT INTO acllogingroup VALUES (2, 24);
INSERT INTO acllogingroup VALUES (2, 23);
INSERT INTO acllogingroup VALUES (2, 31);
INSERT INTO acllogingroup VALUES (5, 32);
INSERT INTO acllogingroup VALUES (4, 32);
INSERT INTO acllogingroup VALUES (3, 32);
INSERT INTO acllogingroup VALUES (6, 22);
INSERT INTO acllogingroup VALUES (7, 31);
INSERT INTO acllogingroup VALUES (10, 33);
INSERT INTO acllogingroup VALUES (9, 33);
INSERT INTO acllogingroup VALUES (8, 33);
INSERT INTO acllogingroup VALUES (10, 34);
INSERT INTO acllogingroup VALUES (8, 34);


--
-- TOC entry 4735 (class 0 OID 18163)
-- Dependencies: 225
-- Data for Name: log; Type: TABLE DATA; Schema: gacl; Owner: collec
--

INSERT INTO log VALUES (1, 'unknown', 'col-default', '2017-02-28 15:32:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2, 'unknown', 'col-default', '2017-02-28 15:45:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (3, 'unknown', 'col-default', '2017-02-28 15:46:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (4, 'unknown', 'col-default', '2017-02-28 16:07:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (5, 'unknown', 'col-default', '2017-02-28 16:16:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (6, 'unknown', 'col-connexion', '2017-02-28 16:16:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (7, 'admin', 'col-connexion', '2017-02-28 16:19:11', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (8, 'admin', 'col-default', '2017-02-28 16:19:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (9, 'admin', 'col-loginChangePassword', '2017-02-28 16:22:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (10, 'admin', 'col-loginChangePasswordExec', '2017-02-28 16:23:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (11, 'admin', 'col-password_change', '2017-02-28 16:23:48', 'ip:10.4.2.103', '10.4.2.103');
INSERT INTO log VALUES (12, 'admin', 'col-default', '2017-02-28 16:30:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (13, 'admin', 'col-disconnect', '2017-02-28 16:30:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (14, 'unknown', 'col-connexion', '2017-02-28 16:30:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (15, 'admin', 'col-connexion', '2017-02-28 16:30:48', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (16, 'admin', 'col-default', '2017-02-28 16:30:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (17, 'admin', 'col-disconnect', '2017-02-28 16:32:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (18, 'unknown', 'col-connexion', '2017-02-28 16:32:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (19, 'admin', 'col-connexion', '2017-02-28 16:33:01', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (20, 'admin', 'col-default', '2017-02-28 16:33:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (21, 'admin', 'col-loginChangePassword', '2017-02-28 16:33:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (22, 'admin', 'col-loginChangePasswordExec', '2017-02-28 16:33:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (23, 'admin', 'col-password_change', '2017-02-28 16:33:39', 'ip:10.4.2.103', '10.4.2.103');
INSERT INTO log VALUES (24, 'admin', 'col-default', '2017-02-28 16:34:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (25, 'unknown', 'col-default', '2017-02-28 16:36:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (26, 'admin', 'col-groupList', '2017-02-28 16:51:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (27, 'unknown', 'col-disconnect', '2017-02-28 17:58:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (28, 'unknown', 'col-connexion', '2017-02-28 17:58:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (29, 'admin', 'col-connexion', '2017-02-28 17:58:23', 'db-ko', '10.4.2.103');
INSERT INTO log VALUES (30, 'unknown', 'col-default', '2017-02-28 17:58:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (31, 'unknown', 'col-connexion', '2017-02-28 18:12:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (32, 'admin', 'col-connexion', '2017-02-28 18:12:08', 'db-ko', '10.4.2.103');
INSERT INTO log VALUES (33, 'unknown', 'col-default', '2017-02-28 18:12:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (34, 'unknown', 'col-connexion', '2017-02-28 18:12:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (35, 'admin', 'col-connexion', '2017-02-28 18:12:21', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (36, 'admin', 'col-connexion', '2017-02-28 18:12:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (37, 'admin', 'col-disconnect', '2017-02-28 18:12:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (38, 'unknown', 'col-connexion', '2017-02-28 18:12:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (39, 'admin', 'col-connexion', '2017-02-28 18:13:03', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (40, 'admin', 'col-default', '2017-02-28 18:14:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (41, 'admin', 'col-disconnect', '2017-02-28 18:14:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (42, 'unknown', 'col-connexion', '2017-02-28 18:14:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (43, 'admin', 'col-connexion', '2017-02-28 18:14:47', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (44, 'admin', 'col-default', '2017-02-28 18:14:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (45, 'unknown', 'col-disconnect', '2017-03-01 09:51:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (46, 'unknown', 'col-connexion', '2017-03-01 09:51:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (47, 'admin', 'col-connexion', '2017-03-01 09:51:40', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (48, 'admin', 'col-default', '2017-03-01 09:51:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (49, 'admin', 'col-disconnect', '2017-03-01 09:52:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (50, 'unknown', 'col-connexion', '2017-03-01 09:52:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (51, 'admin', 'col-connexion', '2017-03-01 09:52:45', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (52, 'admin', 'col-default', '2017-03-01 09:58:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (53, 'admin', 'col-disconnect', '2017-03-01 09:58:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (54, 'unknown', 'col-connexion', '2017-03-01 09:58:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (55, 'admin', 'col-connexion', '2017-03-01 09:58:58', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (56, 'admin', 'col-default', '2017-03-01 10:00:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (57, 'admin', 'col-disconnect', '2017-03-01 10:00:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (58, 'unknown', 'col-connexion', '2017-03-01 10:00:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (59, 'admin', 'col-connexion', '2017-03-01 10:00:14', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (60, 'admin', 'col-default', '2017-03-01 10:00:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (61, 'unknown', 'col-default', '2017-03-02 12:05:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (62, 'unknown', 'col-default', '2017-04-18 13:36:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (63, 'unknown', 'col-connexion', '2017-04-18 13:36:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (64, 'admin', 'col-connexion', '2017-04-18 13:36:44', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (65, 'admin', 'col-default', '2017-04-18 13:36:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (66, 'admin', 'col-containerList', '2017-04-18 13:36:50', 'droitko', '10.4.2.103');
INSERT INTO log VALUES (67, 'admin', 'col-droitko', '2017-04-18 13:36:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (68, 'admin', 'col-containerList', '2017-04-18 13:36:54', 'droitko', '10.4.2.103');
INSERT INTO log VALUES (69, 'admin', 'col-droitko', '2017-04-18 13:36:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (70, 'admin', 'col-sampleList', '2017-04-18 13:36:55', 'droitko', '10.4.2.103');
INSERT INTO log VALUES (71, 'admin', 'col-droitko', '2017-04-18 13:36:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (72, 'admin', 'col-loginList', '2017-04-18 13:37:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (73, 'admin', 'col-groupList', '2017-04-18 13:37:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (74, 'admin', 'col-phpinfo', '2017-04-18 13:37:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (75, 'admin', 'col-groupList', '2017-04-18 13:37:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (76, 'admin', 'col-administration', '2017-04-18 13:37:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (77, 'admin', 'col-aclloginList', '2017-04-18 13:37:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (78, 'admin', 'col-administration', '2017-04-18 13:37:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (79, 'admin', 'col-administration', '2017-04-18 13:37:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (80, 'admin', 'col-appliList', '2017-04-18 13:37:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (81, 'admin', 'col-appliDisplay', '2017-04-18 13:37:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (82, 'admin', 'col-acoChange', '2017-04-18 13:37:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (83, 'admin', 'col-sampleList', '2017-04-18 13:37:53', 'droitko', '10.4.2.103');
INSERT INTO log VALUES (84, 'admin', 'col-droitko', '2017-04-18 13:37:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (85, 'admin', 'col-sampleList', '2017-04-18 13:37:56', 'droitko', '10.4.2.103');
INSERT INTO log VALUES (86, 'admin', 'col-droitko', '2017-04-18 13:37:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (87, 'admin', 'col-sampleList', '2017-04-18 13:38:01', 'droitko', '10.4.2.103');
INSERT INTO log VALUES (88, 'admin', 'col-droitko', '2017-04-18 13:38:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (89, 'admin', 'col-sampleList', '2017-04-18 13:38:15', 'droitko', '10.4.2.103');
INSERT INTO log VALUES (90, 'admin', 'col-droitko', '2017-04-18 13:38:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (91, 'admin', 'col-containerList', '2017-04-18 13:38:20', 'droitko', '10.4.2.103');
INSERT INTO log VALUES (92, 'admin', 'col-droitko', '2017-04-18 13:38:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (93, 'unknown', 'col-appliList', '2017-04-18 14:12:46', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (94, 'admin', 'col-connexion', '2017-04-18 14:12:49', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (95, 'admin', 'col-appliList', '2017-04-18 14:12:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (96, 'admin', 'col-appliDisplay', '2017-04-18 14:13:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (97, 'admin', 'col-acoChange', '2017-04-18 14:13:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (98, 'admin', 'col-acoWrite', '2017-04-18 14:14:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (99, 'admin', 'col-Aclaco-write', '2017-04-18 14:14:06', '2', '10.4.2.103');
INSERT INTO log VALUES (100, 'admin', 'col-appliDisplay', '2017-04-18 14:14:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (101, 'admin', 'col-acoChange', '2017-04-18 14:14:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (102, 'admin', 'col-acoWrite', '2017-04-18 14:14:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (103, 'admin', 'col-Aclaco-write', '2017-04-18 14:14:15', '3', '10.4.2.103');
INSERT INTO log VALUES (104, 'admin', 'col-appliDisplay', '2017-04-18 14:14:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (105, 'admin', 'col-acoChange', '2017-04-18 14:14:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (106, 'admin', 'col-acoWrite', '2017-04-18 14:14:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (107, 'admin', 'col-Aclaco-write', '2017-04-18 14:14:24', '4', '10.4.2.103');
INSERT INTO log VALUES (108, 'admin', 'col-appliDisplay', '2017-04-18 14:14:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (109, 'admin', 'col-acoChange', '2017-04-18 14:14:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (110, 'admin', 'col-acoWrite', '2017-04-18 14:14:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (111, 'admin', 'col-Aclaco-write', '2017-04-18 14:14:33', '5', '10.4.2.103');
INSERT INTO log VALUES (112, 'admin', 'col-appliDisplay', '2017-04-18 14:14:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (113, 'admin', 'col-administration-connexion', '2017-04-18 16:15:37', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (114, 'admin', 'col-administration', '2017-04-18 16:15:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (115, 'admin', 'col-containerList', '2017-04-18 16:15:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (116, 'admin', 'col-containerTypeGetFromFamily', '2017-04-18 16:15:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (117, 'admin', 'col-phpinfo', '2017-04-18 16:27:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (118, 'admin', 'col-containerList', '2017-04-18 16:29:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (119, 'admin', 'col-containerTypeGetFromFamily', '2017-04-18 16:29:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (120, 'unknown', 'col-containerList', '2017-04-19 10:10:50', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (121, 'admin', 'col-connexion', '2017-04-19 10:10:51', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (122, 'admin', 'col-containerList', '2017-04-19 10:10:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (123, 'admin', 'col-containerTypeGetFromFamily', '2017-04-19 10:10:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (124, 'admin', 'col-containerList', '2017-04-19 10:14:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (125, 'admin', 'col-containerTypeGetFromFamily', '2017-04-19 10:14:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (126, 'admin', 'col-objets', '2017-04-19 10:14:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (127, 'admin', 'col-containerList', '2017-04-19 10:14:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (128, 'admin', 'col-containerTypeGetFromFamily', '2017-04-19 10:14:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (129, 'admin', 'col-containerList', '2017-04-19 10:14:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (130, 'admin', 'col-containerTypeGetFromFamily', '2017-04-19 10:14:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (131, 'admin', 'col-containerChange', '2017-04-19 10:14:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (132, 'admin', 'col-containerTypeGetFromFamily', '2017-04-19 10:14:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (133, 'admin', 'col-containerTypeGetFromFamily', '2017-04-19 10:15:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (134, 'admin', 'col-containerWrite', '2017-04-19 10:32:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (135, 'admin', 'col-Container-write', '2017-04-19 10:32:45', '1', '10.4.2.103');
INSERT INTO log VALUES (136, 'admin', 'col-containerDisplay', '2017-04-19 10:32:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (137, 'admin', 'col-sampleList-connexion', '2017-04-19 14:03:12', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (138, 'admin', 'col-sampleList', '2017-04-19 14:03:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (139, 'admin', 'col-sampleList', '2017-04-19 14:03:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (140, 'admin', 'col-sampleChange', '2017-04-19 14:03:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (141, 'admin', 'col-projectList', '2017-04-19 14:04:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (142, 'admin', 'col-projectChange', '2017-04-19 14:04:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (143, 'admin', 'col-projectWrite', '2017-04-19 14:05:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (144, 'admin', 'col-Project-write', '2017-04-19 14:05:00', '1', '10.4.2.103');
INSERT INTO log VALUES (145, 'admin', 'col-projectList', '2017-04-19 14:05:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (146, 'admin', 'col-sampleList', '2017-04-19 14:05:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (147, 'admin', 'col-sampleChange', '2017-04-19 14:05:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (148, 'admin', 'col-parametre', '2017-04-19 14:05:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (149, 'admin', 'col-sampleTypeList', '2017-04-19 14:05:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (150, 'admin', 'col-sampleTypeChange', '2017-04-19 14:05:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (151, 'admin', 'col-sampleTypeWrite', '2017-04-19 14:06:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (152, 'admin', 'col-SampleType-write', '2017-04-19 14:06:40', '1', '10.4.2.103');
INSERT INTO log VALUES (153, 'admin', 'col-sampleTypeList', '2017-04-19 14:06:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (154, 'admin', 'col-sampleList', '2017-04-19 14:06:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (155, 'admin', 'col-sampleChange', '2017-04-19 14:06:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (156, 'admin', 'col-parametre', '2017-04-19 14:07:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (157, 'admin', 'col-parametre', '2017-04-19 14:07:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (158, 'admin', 'col-samplingPlaceList', '2017-04-19 14:07:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (159, 'admin', 'col-samplingPlaceChange', '2017-04-19 14:07:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (160, 'admin', 'col-samplingPlaceWrite', '2017-04-19 14:07:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (161, 'admin', 'col-SamplingPlace-write', '2017-04-19 14:07:39', '1', '10.4.2.103');
INSERT INTO log VALUES (162, 'admin', 'col-samplingPlaceList', '2017-04-19 14:07:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (163, 'admin', 'col-objets', '2017-04-19 14:07:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (164, 'admin', 'col-sampleList', '2017-04-19 14:07:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (165, 'admin', 'col-sampleChange', '2017-04-19 14:07:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (166, 'admin', 'col-sampleWrite', '2017-04-19 14:08:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (167, 'admin', 'col-Sample-write', '2017-04-19 14:08:30', '2', '10.4.2.103');
INSERT INTO log VALUES (168, 'admin', 'col-sampleDisplay', '2017-04-19 14:08:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (169, 'admin', 'col-sampleList', '2017-04-19 14:08:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (170, 'admin', 'col-samplePrintLabel', '2017-04-19 14:08:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (171, 'admin', 'col-sampleList', '2017-04-19 14:08:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (172, 'admin', 'col-samplePrintLabel', '2017-04-19 14:09:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (173, 'admin', 'col-sampleList', '2017-04-19 14:09:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (174, 'admin', 'col-administration', '2017-04-19 14:09:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (175, 'admin', 'col-administration', '2017-04-19 14:14:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (176, 'admin', 'col-default', '2017-04-19 14:14:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (177, 'admin', 'col-disconnect', '2017-04-19 14:14:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (178, 'unknown', 'col-connexion', '2017-04-19 14:14:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (179, 'admin', 'col-connexion', '2017-04-19 14:14:17', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (180, 'admin', 'col-default', '2017-04-19 14:14:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (181, 'admin', 'col-sampleList', '2017-04-19 14:14:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (182, 'admin', 'col-sampleList', '2017-04-19 14:14:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (183, 'admin', 'col-samplePrintLabel', '2017-04-19 14:14:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (184, 'admin', 'col-sampleList', '2017-04-19 14:14:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (185, 'admin', 'col-sampleExportCSV', '2017-04-19 14:14:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (186, 'admin', 'col-sampleDisplay', '2017-04-19 14:16:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (187, 'admin', 'col-parametre-connexion', '2017-04-19 16:38:04', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (188, 'admin', 'col-parametre', '2017-04-19 16:38:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (189, 'admin', 'col-protocolList', '2017-04-19 16:38:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (190, 'admin', 'col-operationList', '2017-04-19 16:38:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (191, 'admin', 'col-objets', '2017-04-19 17:01:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (192, 'admin', 'col-containerList', '2017-04-19 17:01:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (193, 'admin', 'col-containerTypeGetFromFamily', '2017-04-19 17:01:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (194, 'admin', 'col-sampleList', '2017-04-19 17:01:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (195, 'admin', 'col-sampleList', '2017-04-19 17:01:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (196, 'admin', 'col-sampleDisplay', '2017-04-19 17:01:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (197, 'admin', 'col-sampleChange', '2017-04-19 17:02:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (198, 'unknown', 'col-sampleList', '2017-04-20 17:02:44', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (199, 'admin', 'col-connexion', '2017-04-20 17:02:45', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (200, 'admin', 'col-sampleList', '2017-04-20 17:02:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (201, 'admin', 'col-sampleList', '2017-04-20 17:02:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (202, 'admin', 'col-samplePrintLabel', '2017-04-20 17:02:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (203, 'admin', 'col-sampleList', '2017-04-20 17:02:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (204, 'admin', 'col-parametre', '2017-04-20 17:06:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (205, 'admin', 'col-sampleTypeList', '2017-04-20 17:06:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (206, 'admin', 'col-parametre', '2017-04-20 17:06:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (207, 'admin', 'col-containerTypeList', '2017-04-20 17:06:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (208, 'admin', 'col-containerTypeChange', '2017-04-20 17:06:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (209, 'admin', 'col-containerTypeWrite', '2017-04-20 17:07:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (210, 'admin', 'col-ContainerType-write', '2017-04-20 17:07:03', '1', '10.4.2.103');
INSERT INTO log VALUES (211, 'admin', 'col-containerTypeList', '2017-04-20 17:07:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (212, 'admin', 'col-objets', '2017-04-20 17:07:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (213, 'admin', 'col-sampleList', '2017-04-20 17:07:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (214, 'admin', 'col-samplePrintLabel', '2017-04-20 17:07:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (215, 'admin', 'col-sampleList', '2017-04-20 17:09:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (216, 'admin', 'col-parametre', '2017-04-20 17:34:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (217, 'admin', 'col-parametre', '2017-04-20 17:34:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (218, 'admin', 'col-parametre', '2017-04-20 17:34:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (219, 'admin', 'col-parametre', '2017-04-20 17:34:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (220, 'admin', 'col-parametre', '2017-04-20 17:34:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (221, 'admin', 'col-labelList', '2017-04-20 17:34:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (222, 'admin', 'col-labelChange', '2017-04-20 17:34:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (223, 'admin', 'col-sampleList', '2017-04-20 17:50:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (224, 'unknown', 'col-sampleDisplay', '2017-04-21 08:52:01', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (225, 'admin', 'col-connexion', '2017-04-21 08:52:03', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (226, 'admin', 'col-sampleDisplay', '2017-04-21 08:52:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (227, 'admin', 'col-sampleList', '2017-04-21 08:52:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (228, 'admin', 'col-sampleList', '2017-04-21 08:52:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (229, 'admin', 'col-sampleDisplay', '2017-04-21 08:52:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (230, 'admin', 'col-containerList', '2017-04-21 08:52:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (231, 'admin', 'col-containerTypeGetFromFamily', '2017-04-21 08:52:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (232, 'admin', 'col-containerList', '2017-04-21 08:52:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (233, 'admin', 'col-containerTypeGetFromFamily', '2017-04-21 08:52:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (234, 'admin', 'col-containerDisplay', '2017-04-21 08:52:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (235, 'admin', 'col-parametre', '2017-04-21 08:53:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (236, 'admin', 'col-containerTypeList', '2017-04-21 08:53:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (237, 'admin', 'col-containerTypeChange', '2017-04-21 08:53:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (238, 'admin', 'col-objets', '2017-04-21 08:54:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (239, 'admin', 'col-samplingPlaceList', '2017-04-21 08:55:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (240, 'admin', 'col-containerTypeList', '2017-04-21 08:55:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (241, 'admin', 'col-containerList', '2017-04-21 08:56:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (242, 'admin', 'col-containerTypeGetFromFamily', '2017-04-21 08:56:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (243, 'admin', 'col-sampleList', '2017-04-21 08:57:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (244, 'admin', 'col-samplePrintLabel', '2017-04-21 08:57:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (245, 'admin', 'col-sampleList', '2017-04-21 09:03:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (246, 'admin', 'col-sampleDisplay', '2017-04-21 09:03:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (247, 'admin', 'col-sampleTypeList', '2017-04-21 09:03:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (248, 'admin', 'col-sampleTypeChange', '2017-04-21 09:03:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (249, 'admin', 'col-parametre', '2017-04-21 09:05:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (250, 'admin', 'col-protocolList', '2017-04-21 09:05:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (251, 'admin', 'col-protocolChange', '2017-04-21 09:05:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (252, 'admin', 'col-parametre', '2017-04-21 09:05:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (253, 'admin', 'col-parametre', '2017-04-21 09:05:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (254, 'admin', 'col-operationList', '2017-04-21 09:05:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (255, 'admin', 'col-operationChange', '2017-04-21 09:05:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (256, 'admin', 'col-containerList', '2017-04-21 09:07:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (257, 'admin', 'col-containerTypeGetFromFamily', '2017-04-21 09:07:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (258, 'admin', 'col-objets', '2017-04-21 09:07:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (259, 'admin', 'col-sampleList', '2017-04-21 09:07:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (260, 'admin', 'col-sampleChange', '2017-04-21 09:07:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (261, 'admin', 'col-operationList', '2017-04-21 09:11:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (262, 'admin', 'col-operationChange', '2017-04-21 09:11:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (263, 'unknown', 'col-default', '2017-04-25 13:28:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (264, 'unknown', 'col-default', '2017-04-25 13:28:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (265, 'unknown', 'col-default', '2017-04-25 13:30:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (266, 'unknown', 'col-default', '2017-04-25 13:30:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (267, 'unknown', 'col-containerList', '2017-04-25 13:30:58', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (268, 'admin', 'col-connexion', '2017-04-25 13:31:00', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (269, 'admin', 'col-containerList', '2017-04-25 13:31:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (270, 'admin', 'col-containerTypeGetFromFamily', '2017-04-25 13:31:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (271, 'admin', 'col-default', '2017-04-25 13:33:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (272, 'admin', 'col-default', '2017-04-25 13:34:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (273, 'admin', 'col-default', '2017-04-25 13:37:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (274, 'admin', 'col-default', '2017-04-25 13:54:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (275, 'admin', 'col-default', '2017-04-25 13:58:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (276, 'admin', 'col-default', '2017-04-25 13:58:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (277, 'admin', 'col-default', '2017-04-25 14:04:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (278, 'admin', 'col-default', '2017-04-25 14:08:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (279, 'admin', 'col-default', '2017-04-25 14:08:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (280, 'admin', 'col-default', '2017-04-25 14:08:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (281, 'admin', 'col-default', '2017-04-25 14:11:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (282, 'admin', 'col-default', '2017-04-25 14:16:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (283, 'admin', 'col-default', '2017-04-25 14:17:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (284, 'admin', 'col-containerList', '2017-04-25 14:17:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (285, 'admin', 'col-containerTypeGetFromFamily', '2017-04-25 14:17:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (286, 'admin', 'col-containerList', '2017-04-25 14:17:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (287, 'admin', 'col-containerTypeGetFromFamily', '2017-04-25 14:17:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (288, 'admin', 'col-objets', '2017-04-25 14:18:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (289, 'admin', 'col-objets', '2017-04-25 14:19:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (290, 'admin', 'col-default', '2017-04-25 14:29:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (291, 'admin', 'col-default', '2017-04-25 14:29:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (292, 'admin', 'col-default', '2017-04-25 14:30:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (293, 'admin', 'col-default', '2017-04-25 14:30:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (294, 'admin', 'col-default', '2017-04-25 14:32:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (295, 'admin', 'col-default', '2017-04-25 14:33:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (296, 'admin', 'col-default', '2017-04-25 14:33:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (297, 'admin', 'col-default', '2017-04-25 14:36:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (298, 'unknown', 'col-default', '2017-06-07 13:48:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (299, 'unknown', 'col-connexion', '2017-06-07 13:48:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (300, 'admin', 'col-connexion', '2017-06-07 13:48:14', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (301, 'admin', 'col-default', '2017-06-07 13:48:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (302, 'admin', 'col-sampleList', '2017-06-07 13:48:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (303, 'admin', 'col-sampleList', '2017-06-07 13:48:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (304, 'admin', 'col-administration-connexion', '2017-06-07 17:50:16', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (305, 'admin', 'col-administration', '2017-06-07 17:50:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (306, 'unknown', 'col-default', '2017-06-13 09:21:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (307, 'unknown', 'col-default', '2017-06-13 09:28:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (308, 'unknown', 'col-connexion', '2017-06-13 09:28:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (309, 'administrateur', 'col-connexion', '2017-06-13 09:30:33', 'db-ko', '10.4.2.103');
INSERT INTO log VALUES (310, 'unknown', 'col-default', '2017-06-13 09:30:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (311, 'unknown', 'col-containerList', '2017-06-13 09:30:39', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (312, 'admin', 'col-connexion', '2017-06-13 09:30:56', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (313, 'admin', 'col-containerList', '2017-06-13 09:30:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (314, 'admin', 'col-containerTypeGetFromFamily', '2017-06-13 09:30:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (315, 'admin', 'col-administration', '2017-06-13 09:32:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (316, 'admin', 'col-groupList', '2017-06-13 09:32:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (317, 'unknown', 'col-labelList', '2017-06-13 14:12:31', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (318, 'admin', 'col-connexion', '2017-06-13 14:12:33', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (319, 'admin', 'col-labelList', '2017-06-13 14:12:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (320, 'admin', 'col-labelChange', '2017-06-13 14:12:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (321, 'unknown', 'col-default', '2017-06-13 14:51:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (322, 'unknown', 'col-default', '2017-06-13 14:52:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (323, 'unknown', 'col-default', '2017-06-13 14:52:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (324, 'unknown', 'col-default', '2017-06-13 14:52:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (325, 'unknown', 'col-default', '2017-06-13 14:53:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (326, 'unknown', 'col-default', '2017-06-13 15:05:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (327, 'admin', 'col-connexion-connexion', '2017-06-13 15:05:12', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (328, 'admin', 'col-connexion', '2017-06-13 15:05:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (329, 'admin', 'col-sampleList', '2017-06-13 15:05:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (330, 'admin', 'col-connexion', '2017-06-13 15:05:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (331, 'admin', 'col-containerList', '2017-06-13 15:05:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (332, 'admin', 'col-containerTypeGetFromFamily', '2017-06-13 15:05:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (333, 'admin', 'col-connexion', '2017-06-13 15:05:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (334, 'admin', 'col-objets', '2017-06-13 15:05:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (335, 'admin', 'col-sampleList', '2017-06-13 15:05:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (336, 'admin', 'col-sampleList', '2017-06-13 15:19:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (337, 'admin', 'col-containerList', '2017-06-13 15:20:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (338, 'admin', 'col-containerTypeGetFromFamily', '2017-06-13 15:20:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (339, 'unknown', 'col-default', '2017-06-13 15:44:42', 'ok', '77.154.204.128');
INSERT INTO log VALUES (340, 'unknown', 'col-default', '2017-06-13 15:45:12', 'ok', '193.48.127.14');
INSERT INTO log VALUES (341, 'unknown', 'col-containerList', '2017-06-13 15:45:31', 'nologin', '193.48.127.14');
INSERT INTO log VALUES (342, 'admin', 'col-loginList', '2017-06-13 15:46:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (343, 'admin', 'col-loginChange', '2017-06-13 15:46:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (344, 'admin', 'col-loginWrite', '2017-06-13 15:49:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (345, 'admin', 'col-LoginGestion-write', '2017-06-13 15:49:57', '3', '10.4.2.103');
INSERT INTO log VALUES (346, 'admin', 'col-loginList', '2017-06-13 15:49:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (347, 'admin', 'col-groupList', '2017-06-13 15:50:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (348, 'admin', 'col-groupList', '2017-06-13 15:50:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (349, 'admin', 'col-administration', '2017-06-13 15:51:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (350, 'admin', 'col-appliList', '2017-06-13 15:51:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (351, 'admin', 'col-appliDisplay', '2017-06-13 15:51:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (352, 'admin', 'col-acoChange', '2017-06-13 15:51:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (353, 'admin', 'col-appliDisplay', '2017-06-13 15:51:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (354, 'admin', 'col-appliList', '2017-06-13 15:51:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (355, 'admin', 'col-appliDisplay', '2017-06-13 15:51:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (356, 'admin', 'col-acoChange', '2017-06-13 15:51:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (357, 'admin', 'col-appliDisplay', '2017-06-13 15:51:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (358, 'admin', 'col-appliList', '2017-06-13 15:51:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (359, 'admin', 'col-appliDisplay', '2017-06-13 15:52:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (360, 'admin', 'col-acoChange', '2017-06-13 15:52:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (361, 'admin', 'col-loginList', '2017-06-13 15:56:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (362, 'admin', 'col-loginChange', '2017-06-13 15:56:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (363, 'admin', 'col-aclloginList', '2017-06-13 15:57:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (364, 'admin', 'col-aclloginChange', '2017-06-13 15:57:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (365, 'admin', 'col-groupList', '2017-06-13 15:57:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (366, 'admin', 'col-groupChange', '2017-06-13 16:00:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (367, 'admin', 'col-groupList', '2017-06-13 16:00:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (368, 'admin', 'col-groupChange', '2017-06-13 16:01:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (369, 'admin', 'col-groupWrite', '2017-06-13 16:01:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (370, 'admin', 'col-Aclgroup-write', '2017-06-13 16:01:15', '22', '10.4.2.103');
INSERT INTO log VALUES (371, 'admin', 'col-groupList', '2017-06-13 16:01:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (372, 'admin', 'col-connexion-connexion', '2017-06-13 16:01:26', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (373, 'admin', 'col-connexion', '2017-06-13 16:01:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (374, 'admin', 'col-disconnect', '2017-06-13 16:01:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (375, 'unknown', 'col-connexion', '2017-06-13 16:01:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (376, 'cpignol', 'col-connexion', '2017-06-13 16:01:43', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (377, 'cpignol', 'col-default', '2017-06-13 16:01:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (378, 'cpignol', 'col-containerList', '2017-06-13 16:03:48', 'droitko', '10.4.2.103');
INSERT INTO log VALUES (379, 'cpignol', 'col-droitko', '2017-06-13 16:03:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (380, 'cpignol', 'col-sampleList', '2017-06-13 16:03:52', 'droitko', '10.4.2.103');
INSERT INTO log VALUES (381, 'cpignol', 'col-droitko', '2017-06-13 16:03:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (382, 'admin', 'col-groupChange', '2017-06-13 16:04:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (383, 'admin', 'col-groupWrite', '2017-06-13 16:04:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (384, 'admin', 'col-Aclgroup-write', '2017-06-13 16:04:17', '27', '10.4.2.103');
INSERT INTO log VALUES (385, 'admin', 'col-groupList', '2017-06-13 16:04:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (386, 'cpignol', 'col-disconnect', '2017-06-13 16:04:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (387, 'unknown', 'col-connexion', '2017-06-13 16:04:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (388, 'cpignol', 'col-connexion', '2017-06-13 16:04:38', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (389, 'cpignol', 'col-default', '2017-06-13 16:04:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (390, 'cpignol', 'col-containerList', '2017-06-13 16:04:42', 'droitko', '10.4.2.103');
INSERT INTO log VALUES (391, 'cpignol', 'col-droitko', '2017-06-13 16:04:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (392, 'admin', 'col-groupChange', '2017-06-13 16:04:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (393, 'admin', 'col-groupWrite', '2017-06-13 16:04:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (394, 'admin', 'col-Aclgroup-write', '2017-06-13 16:04:52', '27', '10.4.2.103');
INSERT INTO log VALUES (395, 'admin', 'col-groupList', '2017-06-13 16:04:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (396, 'admin', 'col-groupChange', '2017-06-13 16:04:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (397, 'admin', 'col-groupWrite', '2017-06-13 16:05:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (398, 'admin', 'col-Aclgroup-write', '2017-06-13 16:05:01', '1', '10.4.2.103');
INSERT INTO log VALUES (399, 'admin', 'col-groupList', '2017-06-13 16:05:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (400, 'cpignol', 'col-disconnect', '2017-06-13 16:05:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (401, 'unknown', 'col-connexion', '2017-06-13 16:05:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (402, 'cpignol', 'col-connexion', '2017-06-13 16:05:18', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (403, 'cpignol', 'col-default', '2017-06-13 16:05:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (404, 'unknown', 'col-default', '2017-06-13 16:46:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (405, 'admin', 'col-connexion-connexion', '2017-06-13 16:46:53', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (406, 'admin', 'col-connexion', '2017-06-13 16:46:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (407, 'admin', 'col-administration', '2017-06-13 16:46:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (408, 'admin', 'col-administration', '2017-06-13 16:46:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (409, 'admin', 'col-groupList', '2017-06-13 16:47:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (410, 'admin', 'col-groupChange', '2017-06-13 16:47:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (411, 'admin', 'col-groupDelete', '2017-06-13 16:47:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (412, 'admin', 'col-groupChange', '2017-06-13 16:47:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (413, 'admin', 'col-groupDelete', '2017-06-13 16:49:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (414, 'admin', 'col-Aclgroup-delete', '2017-06-13 16:49:00', '26', '10.4.2.103');
INSERT INTO log VALUES (415, 'admin', 'col-groupList', '2017-06-13 16:49:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (416, 'admin', 'col-groupChange', '2017-06-13 16:49:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (417, 'admin', 'col-groupWrite', '2017-06-13 16:49:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (418, 'admin', 'col-Aclgroup-write', '2017-06-13 16:49:30', '25', '10.4.2.103');
INSERT INTO log VALUES (419, 'admin', 'col-groupList', '2017-06-13 16:49:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (420, 'admin', 'col-groupChange', '2017-06-13 16:49:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (421, 'admin', 'col-groupWrite', '2017-06-13 16:49:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (422, 'admin', 'col-Aclgroup-write', '2017-06-13 16:49:38', '24', '10.4.2.103');
INSERT INTO log VALUES (423, 'admin', 'col-groupList', '2017-06-13 16:49:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (424, 'admin', 'col-groupChange', '2017-06-13 16:49:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (425, 'admin', 'col-groupWrite', '2017-06-13 16:49:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (426, 'admin', 'col-Aclgroup-write', '2017-06-13 16:49:50', '1', '10.4.2.103');
INSERT INTO log VALUES (427, 'admin', 'col-groupList', '2017-06-13 16:49:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (428, 'unknown', 'col-disconnect', '2017-06-13 16:49:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (429, 'unknown', 'col-connexion', '2017-06-13 16:49:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (430, 'cpignol', 'col-connexion', '2017-06-13 16:50:07', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (431, 'cpignol', 'col-default', '2017-06-13 16:50:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (432, 'cpignol', 'col-containerList', '2017-06-13 16:50:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (433, 'cpignol', 'col-containerTypeGetFromFamily', '2017-06-13 16:50:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (434, 'admin', 'col-groupChange', '2017-06-13 16:50:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (435, 'admin', 'col-groupWrite', '2017-06-13 16:50:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (436, 'admin', 'col-Aclgroup-write', '2017-06-13 16:50:31', '23', '10.4.2.103');
INSERT INTO log VALUES (437, 'admin', 'col-groupList', '2017-06-13 16:50:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (438, 'unknown', 'col-containerList', '2017-06-15 16:42:19', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (439, 'admin', 'col-connexion', '2017-06-15 16:42:23', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (440, 'admin', 'col-containerList', '2017-06-15 16:42:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (441, 'admin', 'col-containerTypeGetFromFamily', '2017-06-15 16:42:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (442, 'admin', 'col-containerFamilyList', '2017-06-15 16:42:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (443, 'admin', 'col-containerFamilyChange', '2017-06-15 16:51:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (444, 'admin', 'col-containerFamilyList', '2017-06-15 16:51:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (445, 'admin', 'col-parametre', '2017-06-15 16:52:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (446, 'admin', 'col-projectList', '2017-06-15 16:52:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (447, 'admin', 'col-projectChange', '2017-06-15 16:52:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (448, 'admin', 'col-projectList', '2017-06-15 16:52:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (449, 'admin', 'col-protocolList', '2017-06-15 16:53:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (450, 'admin', 'col-projectList', '2017-06-15 16:53:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (451, 'admin', 'col-appliList', '2017-06-15 16:53:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (452, 'admin', 'col-appliDisplay', '2017-06-15 16:54:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (453, 'admin', 'col-appliList', '2017-06-15 16:54:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (454, 'admin', 'col-appliDisplay', '2017-06-15 16:54:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (455, 'admin', 'col-appliList', '2017-06-15 16:54:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (456, 'admin', 'col-appliDisplay', '2017-06-15 16:54:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (457, 'admin', 'col-appliChange', '2017-06-15 16:54:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (458, 'admin', 'col-appliDelete', '2017-06-15 17:01:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (459, 'admin', 'col-appliChange', '2017-06-15 17:01:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (460, 'admin', 'col-appliDelete', '2017-06-15 17:05:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (461, 'admin', 'col-Aclappli-delete', '2017-06-15 17:05:21', '2', '10.4.2.103');
INSERT INTO log VALUES (462, 'admin', 'col-appliList', '2017-06-15 17:05:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (463, 'admin', 'col-default', '2017-06-15 17:05:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (464, 'admin', 'col-projectList', '2017-06-15 17:05:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (465, 'admin', 'col-projectList', '2017-06-15 17:06:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (466, 'admin', 'col-projectChange', '2017-06-15 17:06:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (467, 'admin', 'col-administration', '2017-06-15 17:06:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (468, 'admin', 'col-administration', '2017-06-15 17:06:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (469, 'admin', 'col-appliList', '2017-06-15 17:06:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (470, 'admin', 'col-appliChange', '2017-06-15 17:06:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (471, 'admin', 'col-appliWrite', '2017-06-15 17:08:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (472, 'admin', 'col-Aclappli-write', '2017-06-15 17:08:05', '3', '10.4.2.103');
INSERT INTO log VALUES (473, 'admin', 'col-appliDisplay', '2017-06-15 17:08:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (474, 'admin', 'col-acoChange', '2017-06-15 17:09:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (475, 'admin', 'col-default', '2017-06-15 17:09:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (476, 'admin', 'col-appliList', '2017-06-15 17:09:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (477, 'admin', 'col-appliDisplay', '2017-06-15 17:10:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (478, 'admin', 'col-acoChange', '2017-06-15 17:10:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (479, 'admin', 'col-acoWrite', '2017-06-15 17:10:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (480, 'admin', 'col-Aclaco-write', '2017-06-15 17:10:53', '11', '10.4.2.103');
INSERT INTO log VALUES (481, 'admin', 'col-appliDisplay', '2017-06-15 17:10:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (482, 'admin', 'col-acoChange', '2017-06-15 17:10:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (483, 'admin', 'col-acoWrite', '2017-06-15 17:11:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (484, 'admin', 'col-Aclaco-write', '2017-06-15 17:11:06', '12', '10.4.2.103');
INSERT INTO log VALUES (485, 'admin', 'col-appliDisplay', '2017-06-15 17:11:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (486, 'admin', 'col-acoChange', '2017-06-15 17:11:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (487, 'admin', 'col-acoWrite', '2017-06-15 17:11:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (488, 'admin', 'col-Aclaco-write', '2017-06-15 17:11:54', '13', '10.4.2.103');
INSERT INTO log VALUES (489, 'admin', 'col-appliDisplay', '2017-06-15 17:11:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (490, 'admin', 'col-acoChange', '2017-06-15 17:12:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (491, 'admin', 'col-acoWrite', '2017-06-15 17:12:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (492, 'admin', 'col-Aclaco-write', '2017-06-15 17:12:08', '14', '10.4.2.103');
INSERT INTO log VALUES (493, 'admin', 'col-appliDisplay', '2017-06-15 17:12:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (494, 'admin', 'col-acoChange', '2017-06-15 17:12:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (495, 'admin', 'col-acoWrite', '2017-06-15 17:12:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (496, 'admin', 'col-Aclaco-write', '2017-06-15 17:12:16', '15', '10.4.2.103');
INSERT INTO log VALUES (497, 'admin', 'col-appliDisplay', '2017-06-15 17:12:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (498, 'admin', 'col-groupList', '2017-06-15 17:13:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (499, 'admin', 'col-groupChange', '2017-06-15 17:13:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (500, 'admin', 'col-groupWrite', '2017-06-15 17:15:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (501, 'admin', 'col-Aclgroup-write', '2017-06-15 17:15:10', '31', '10.4.2.103');
INSERT INTO log VALUES (502, 'admin', 'col-groupList', '2017-06-15 17:15:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (503, 'admin', 'col-groupChange', '2017-06-15 17:15:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (504, 'admin', 'col-groupList', '2017-06-15 17:16:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (505, 'admin', 'col-groupChange', '2017-06-15 17:16:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (506, 'admin', 'col-groupList', '2017-06-15 17:17:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (507, 'admin', 'col-aclloginList', '2017-06-15 17:17:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (508, 'admin', 'col-aclloginChange', '2017-06-15 17:17:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (509, 'admin', 'col-aclloginList', '2017-06-15 17:17:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (510, 'admin', 'col-appliList', '2017-06-15 17:17:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (511, 'admin', 'col-appliChange', '2017-06-15 17:17:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (512, 'admin', 'col-appliWrite', '2017-06-15 17:17:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (513, 'admin', 'col-Aclappli-write', '2017-06-15 17:17:51', '3', '10.4.2.103');
INSERT INTO log VALUES (514, 'admin', 'col-appliDisplay', '2017-06-15 17:17:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (515, 'admin', 'col-acoChange', '2017-06-15 17:18:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (516, 'admin', 'col-acoWrite', '2017-06-15 17:18:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (517, 'admin', 'col-Aclaco-write', '2017-06-15 17:18:56', '11', '10.4.2.103');
INSERT INTO log VALUES (518, 'admin', 'col-appliDisplay', '2017-06-15 17:18:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (519, 'admin', 'col-acoChange', '2017-06-15 17:19:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (520, 'admin', 'col-appliList', '2017-06-15 17:19:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (521, 'admin', 'col-aclloginList', '2017-06-15 17:19:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (522, 'admin', 'col-aclloginChange', '2017-06-15 17:19:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (523, 'admin', 'col-aclloginList', '2017-06-15 17:19:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (524, 'admin', 'col-groupList', '2017-06-15 17:20:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (525, 'admin', 'col-aclloginList', '2017-06-15 17:20:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (526, 'admin', 'col-aclloginChange', '2017-06-15 17:20:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (527, 'admin', 'col-groupList', '2017-06-15 17:20:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (528, 'admin', 'col-groupChange', '2017-06-15 17:20:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (529, 'admin', 'col-groupList', '2017-06-15 17:21:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (530, 'admin', 'col-disconnect', '2017-06-15 17:24:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (531, 'unknown', 'col-connexion', '2017-06-15 17:24:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (532, 'cpignol', 'col-connexion', '2017-06-15 17:24:36', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (533, 'cpignol', 'col-default', '2017-06-15 17:24:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (534, 'cpignol', 'col-parametre', '2017-06-15 17:24:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (535, 'cpignol', 'col-parametre', '2017-06-15 17:24:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (536, 'cpignol', 'col-parametre', '2017-06-15 17:24:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (537, 'cpignol', 'col-disconnect', '2017-06-15 17:33:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (538, 'unknown', 'col-connexion', '2017-06-15 17:34:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (539, 'admin', 'col-connexion', '2017-06-15 17:34:03', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (540, 'admin', 'col-default', '2017-06-15 17:34:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (541, 'admin', 'col-groupList', '2017-06-15 17:34:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (542, 'admin', 'col-appliList', '2017-06-15 17:34:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (543, 'admin', 'col-appliDisplay', '2017-06-15 17:34:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (544, 'admin', 'col-appliList', '2017-06-15 17:34:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (545, 'admin', 'col-appliDisplay', '2017-06-15 17:34:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (546, 'admin', 'col-acoChange', '2017-06-15 17:34:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (547, 'admin', 'col-appliDisplay', '2017-06-15 17:35:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (548, 'admin', 'col-acoChange', '2017-06-15 17:35:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (549, 'admin', 'col-acoWrite', '2017-06-15 17:35:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (550, 'admin', 'col-Aclaco-write', '2017-06-15 17:35:37', '12', '10.4.2.103');
INSERT INTO log VALUES (551, 'admin', 'col-appliDisplay', '2017-06-15 17:35:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (552, 'admin', 'col-disconnect', '2017-06-15 17:35:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (553, 'unknown', 'col-connexion', '2017-06-15 17:35:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (554, 'cpignol', 'col-connexion', '2017-06-15 17:36:00', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (555, 'cpignol', 'col-default', '2017-06-15 17:36:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (556, 'cpignol', 'col-disconnect', '2017-06-15 17:36:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (557, 'unknown', 'col-connexion', '2017-06-15 17:36:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (558, 'admin', 'col-connexion', '2017-06-15 17:36:22', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (559, 'admin', 'col-default', '2017-06-15 17:36:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (560, 'admin', 'col-groupList', '2017-06-15 17:36:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (561, 'admin', 'col-appliList', '2017-06-15 17:36:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (562, 'admin', 'col-appliDisplay', '2017-06-15 17:36:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (563, 'admin', 'col-acoChange', '2017-06-15 17:37:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (564, 'admin', 'col-acoWrite', '2017-06-15 17:37:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (565, 'admin', 'col-Aclaco-write', '2017-06-15 17:37:18', '1', '10.4.2.103');
INSERT INTO log VALUES (566, 'admin', 'col-appliDisplay', '2017-06-15 17:37:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (567, 'admin', 'col-disconnect', '2017-06-15 17:37:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (568, 'unknown', 'col-connexion', '2017-06-15 17:37:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (569, 'cpignol', 'col-connexion', '2017-06-15 17:37:43', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (570, 'cpignol', 'col-default', '2017-06-15 17:37:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (571, 'cpignol', 'col-appliList', '2017-06-15 17:38:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (572, 'cpignol', 'col-projectList', '2017-06-15 17:38:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (573, 'cpignol', 'col-groupList', '2017-06-15 17:39:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (574, 'cpignol', 'col-appliList', '2017-06-15 17:39:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (575, 'unknown', 'col-appliDisplay', '2017-06-16 10:25:18', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (576, 'cpignol', 'col-connexion', '2017-06-16 10:25:35', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (577, 'cpignol', 'col-default', '2017-06-16 10:25:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (578, 'cpignol', 'zaalpes-disconnect', '2017-06-16 10:26:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (579, 'unknown', 'zaalpes-connexion', '2017-06-16 10:26:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (580, 'cpignol', 'zaalpes-connexion', '2017-06-16 10:27:13', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (581, 'cpignol', 'zaalpes-default', '2017-06-16 10:27:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (582, 'cpignol', 'zaalpes-groupList', '2017-06-16 10:27:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (583, 'cpignol', 'zaalpes-appliList', '2017-06-16 10:27:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (584, 'cpignol', 'zaalpes-appliDisplay', '2017-06-16 10:27:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (585, 'cpignol', 'zaalpes-acoChange', '2017-06-16 10:28:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (586, 'cpignol', 'zaalpes-appliDisplay', '2017-06-16 10:28:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (587, 'cpignol', 'zaalpes-acoChange', '2017-06-16 10:28:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (588, 'cpignol', 'zaalpes-appliDisplay', '2017-06-16 10:28:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (589, 'cpignol', 'zaalpes-acoChange', '2017-06-16 10:28:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (590, 'cpignol', 'zaalpes-acoWrite', '2017-06-16 10:28:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (591, 'cpignol', 'zaalpes-Aclaco-write', '2017-06-16 10:28:42', '15', '10.4.2.103');
INSERT INTO log VALUES (592, 'cpignol', 'zaalpes-appliDisplay', '2017-06-16 10:28:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (593, 'cpignol', 'zaalpes-acoChange', '2017-06-16 10:28:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (594, 'cpignol', 'zaalpes-acoWrite', '2017-06-16 10:28:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (595, 'cpignol', 'zaalpes-Aclaco-write', '2017-06-16 10:28:50', '14', '10.4.2.103');
INSERT INTO log VALUES (596, 'cpignol', 'zaalpes-appliDisplay', '2017-06-16 10:28:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (597, 'cpignol', 'zaalpes-acoChange', '2017-06-16 10:28:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (598, 'cpignol', 'zaalpes-acoWrite', '2017-06-16 10:28:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (599, 'cpignol', 'zaalpes-Aclaco-write', '2017-06-16 10:28:58', '13', '10.4.2.103');
INSERT INTO log VALUES (600, 'cpignol', 'zaalpes-appliDisplay', '2017-06-16 10:28:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (601, 'cpignol', 'zaalpes-default', '2017-06-16 10:30:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (602, 'cpignol', 'zaalpes-disconnect', '2017-06-16 10:30:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (603, 'unknown', 'zaalpes-connexion', '2017-06-16 10:30:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (604, 'cpignol', 'zaalpes-connexion', '2017-06-16 10:31:19', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (605, 'cpignol', 'zaalpes-default', '2017-06-16 10:31:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (606, 'cpignol', 'zaalpes-containerList', '2017-06-16 10:31:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (607, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 10:31:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (608, 'cpignol', 'zaalpes-parametre', '2017-06-16 10:31:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (609, 'cpignol', 'zaalpes-containerFamilyList', '2017-06-16 10:31:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (610, 'cpignol', 'zaalpes-containerFamilyChange', '2017-06-16 10:31:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (611, 'cpignol', 'zaalpes-containerFamilyList', '2017-06-16 10:31:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (612, 'cpignol', 'zaalpes-containerTypeList', '2017-06-16 10:32:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (613, 'cpignol', 'zaalpes-containerTypeChange', '2017-06-16 10:33:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (614, 'cpignol', 'zaalpes-containerTypeList', '2017-06-16 10:33:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (615, 'cpignol', 'zaalpes-storageConditionList', '2017-06-16 10:33:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (616, 'cpignol', 'zaalpes-storageConditionChange', '2017-06-16 10:34:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (617, 'cpignol', 'zaalpes-storageConditionWrite', '2017-06-16 10:35:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (618, 'cpignol', 'zaalpes-StorageCondition-write', '2017-06-16 10:35:29', '1', '10.4.2.103');
INSERT INTO log VALUES (619, 'cpignol', 'zaalpes-storageConditionList', '2017-06-16 10:35:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (620, 'cpignol', 'zaalpes-storageConditionChange', '2017-06-16 10:35:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (621, 'cpignol', 'zaalpes-storageConditionWrite', '2017-06-16 10:35:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (622, 'cpignol', 'zaalpes-StorageCondition-write', '2017-06-16 10:35:46', '2', '10.4.2.103');
INSERT INTO log VALUES (623, 'cpignol', 'zaalpes-storageConditionList', '2017-06-16 10:35:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (624, 'cpignol', 'zaalpes-storageConditionChange', '2017-06-16 10:36:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (625, 'cpignol', 'zaalpes-storageConditionList', '2017-06-16 10:37:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (626, 'cpignol', 'zaalpes-storageReasonList', '2017-06-16 10:37:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (627, 'cpignol', 'zaalpes-containerTypeList', '2017-06-16 10:37:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (628, 'cpignol', 'zaalpes-containerTypeChange', '2017-06-16 10:38:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (629, 'cpignol', 'zaalpes-containerTypeList', '2017-06-16 10:38:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (630, 'cpignol', 'zaalpes-containerTypeChange', '2017-06-16 10:38:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (631, 'cpignol', 'zaalpes-containerTypeList', '2017-06-16 10:39:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (632, 'cpignol', 'zaalpes-containerTypeChange', '2017-06-16 10:39:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (633, 'cpignol', 'zaalpes-containerTypeList', '2017-06-16 10:44:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (634, 'cpignol', 'zaalpes-containerTypeChange', '2017-06-16 10:44:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (635, 'cpignol', 'zaalpes-containerTypeWrite', '2017-06-16 10:46:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (636, 'cpignol', 'zaalpes-ContainerType-write', '2017-06-16 10:46:32', '6', '10.4.2.103');
INSERT INTO log VALUES (637, 'cpignol', 'zaalpes-containerTypeList', '2017-06-16 10:46:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (638, 'cpignol', 'zaalpes-labelList', '2017-06-16 10:46:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (639, 'cpignol', 'zaalpes-labelChange', '2017-06-16 10:46:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (640, 'cpignol', 'zaalpes-labelList', '2017-06-16 10:46:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (641, 'cpignol', 'zaalpes-labelChange', '2017-06-16 10:47:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (642, 'cpignol', 'zaalpes-labelList', '2017-06-16 10:47:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (643, 'cpignol', 'zaalpes-labelChange', '2017-06-16 10:47:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (644, 'cpignol', 'zaalpes-labelList', '2017-06-16 10:48:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (645, 'cpignol', 'zaalpes-labelChange', '2017-06-16 10:48:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (646, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 11:02:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (647, 'cpignol', 'zaalpes-Label-write', '2017-06-16 11:02:45', '2', '10.4.2.103');
INSERT INTO log VALUES (648, 'cpignol', 'zaalpes-labelList', '2017-06-16 11:02:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (649, 'cpignol', 'zaalpes-labelChange', '2017-06-16 11:02:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (650, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 11:16:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (651, 'cpignol', 'zaalpes-Label-write', '2017-06-16 11:16:20', '3', '10.4.2.103');
INSERT INTO log VALUES (652, 'cpignol', 'zaalpes-labelList', '2017-06-16 11:16:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (653, 'cpignol', 'zaalpes-objectStatusList', '2017-06-16 11:17:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (654, 'cpignol', 'zaalpes-sampleTypeList', '2017-06-16 11:17:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (655, 'cpignol', 'zaalpes-sampleTypeChange', '2017-06-16 11:17:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (656, 'cpignol', 'zaalpes-parametre', '2017-06-16 11:18:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (657, 'cpignol', 'zaalpes-containerTypeList', '2017-06-16 11:18:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (658, 'cpignol', 'zaalpes-containerTypeChange', '2017-06-16 11:18:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (659, 'cpignol', 'zaalpes-containerTypeWrite', '2017-06-16 11:20:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (660, 'cpignol', 'zaalpes-ContainerType-write', '2017-06-16 11:20:57', '7', '10.4.2.103');
INSERT INTO log VALUES (661, 'cpignol', 'zaalpes-containerTypeList', '2017-06-16 11:20:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (662, 'cpignol', 'zaalpes-containerTypeChange', '2017-06-16 11:21:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (663, 'cpignol', 'zaalpes-containerTypeWrite', '2017-06-16 11:21:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (664, 'cpignol', 'zaalpes-ContainerType-write', '2017-06-16 11:21:26', '6', '10.4.2.103');
INSERT INTO log VALUES (665, 'cpignol', 'zaalpes-containerTypeList', '2017-06-16 11:21:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (666, 'cpignol', 'zaalpes-projectList', '2017-06-16 11:23:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (667, 'cpignol', 'zaalpes-projectChange-connexion', '2017-06-16 13:48:50', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (668, 'cpignol', 'zaalpes-projectChange', '2017-06-16 13:48:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (669, 'cpignol', 'zaalpes-projectWrite', '2017-06-16 13:49:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (670, 'cpignol', 'zaalpes-Project-write', '2017-06-16 13:49:47', '1', '10.4.2.103');
INSERT INTO log VALUES (671, 'cpignol', 'zaalpes-projectList', '2017-06-16 13:49:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (672, 'cpignol', 'zaalpes-aclloginList', '2017-06-16 13:49:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (673, 'cpignol', 'zaalpes-groupList', '2017-06-16 13:49:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (674, 'cpignol', 'zaalpes-groupChange', '2017-06-16 13:50:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (675, 'cpignol', 'zaalpes-groupWrite', '2017-06-16 13:51:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (676, 'cpignol', 'zaalpes-Aclgroup-write', '2017-06-16 13:51:03', '32', '10.4.2.103');
INSERT INTO log VALUES (677, 'cpignol', 'zaalpes-groupList', '2017-06-16 13:51:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (678, 'cpignol', 'zaalpes-aclloginList', '2017-06-16 13:51:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (679, 'cpignol', 'zaalpes-aclloginChange', '2017-06-16 13:51:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (680, 'cpignol', 'zaalpes-aclloginWrite', '2017-06-16 13:52:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (681, 'cpignol', 'zaalpes-Acllogin-write', '2017-06-16 13:52:52', '3', '10.4.2.103');
INSERT INTO log VALUES (682, 'cpignol', 'zaalpes-aclloginList', '2017-06-16 13:52:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (683, 'cpignol', 'zaalpes-aclloginChange', '2017-06-16 13:52:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (684, 'cpignol', 'zaalpes-aclloginWrite', '2017-06-16 13:53:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (685, 'cpignol', 'zaalpes-Acllogin-write', '2017-06-16 13:53:26', '4', '10.4.2.103');
INSERT INTO log VALUES (686, 'cpignol', 'zaalpes-aclloginList', '2017-06-16 13:53:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (687, 'cpignol', 'zaalpes-aclloginChange', '2017-06-16 13:53:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (688, 'cpignol', 'zaalpes-aclloginWrite', '2017-06-16 13:54:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (689, 'cpignol', 'zaalpes-Acllogin-write', '2017-06-16 13:54:19', '5', '10.4.2.103');
INSERT INTO log VALUES (690, 'cpignol', 'zaalpes-aclloginList', '2017-06-16 13:54:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (691, 'cpignol', 'zaalpes-appliList', '2017-06-16 13:54:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (692, 'cpignol', 'zaalpes-appliDisplay', '2017-06-16 13:54:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (693, 'cpignol', 'zaalpes-acoChange', '2017-06-16 13:54:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (694, 'cpignol', 'zaalpes-acoWrite', '2017-06-16 13:55:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (695, 'cpignol', 'zaalpes-Aclaco-write', '2017-06-16 13:55:43', '15', '10.4.2.103');
INSERT INTO log VALUES (696, 'cpignol', 'zaalpes-appliDisplay', '2017-06-16 13:55:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (697, 'cpignol', 'zaalpes-acoChange', '2017-06-16 13:55:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (698, 'cpignol', 'zaalpes-acoWrite', '2017-06-16 13:56:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (699, 'cpignol', 'zaalpes-Aclaco-write', '2017-06-16 13:56:02', '14', '10.4.2.103');
INSERT INTO log VALUES (700, 'cpignol', 'zaalpes-appliDisplay', '2017-06-16 13:56:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (701, 'cpignol', 'zaalpes-acoChange', '2017-06-16 13:56:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (702, 'cpignol', 'zaalpes-appliDisplay', '2017-06-16 13:56:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (703, 'cpignol', 'zaalpes-acoChange', '2017-06-16 13:57:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (704, 'cpignol', 'zaalpes-acoWrite', '2017-06-16 13:57:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (705, 'cpignol', 'zaalpes-Aclaco-write', '2017-06-16 13:57:54', '13', '10.4.2.103');
INSERT INTO log VALUES (706, 'cpignol', 'zaalpes-appliDisplay', '2017-06-16 13:57:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (707, 'cpignol', 'zaalpes-groupList', '2017-06-16 13:58:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (708, 'cpignol', 'zaalpes-groupChange', '2017-06-16 13:58:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (709, 'cpignol', 'zaalpes-groupWrite', '2017-06-16 13:59:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (710, 'cpignol', 'zaalpes-Aclgroup-write', '2017-06-16 13:59:31', '32', '10.4.2.103');
INSERT INTO log VALUES (711, 'cpignol', 'zaalpes-groupList', '2017-06-16 13:59:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (712, 'cpignol', 'zaalpes-loginList', '2017-06-16 14:00:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (713, 'cpignol', 'zaalpes-aclloginList', '2017-06-16 14:00:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (714, 'cpignol', 'zaalpes-projectList-connexion', '2017-06-16 15:15:49', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (715, 'cpignol', 'zaalpes-projectList', '2017-06-16 15:15:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (716, 'cpignol', 'zaalpes-projectChange', '2017-06-16 15:15:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (717, 'cpignol', 'zaalpes-projectWrite', '2017-06-16 15:17:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (718, 'cpignol', 'zaalpes-Project-write', '2017-06-16 15:17:29', '1', '10.4.2.103');
INSERT INTO log VALUES (719, 'cpignol', 'zaalpes-projectList', '2017-06-16 15:17:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (720, 'cpignol', 'zaalpes-loginList', '2017-06-16 15:17:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (721, 'cpignol', 'zaalpes-aclloginList', '2017-06-16 15:18:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (722, 'cpignol', 'zaalpes-loginList', '2017-06-16 15:18:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (723, 'cpignol', 'zaalpes-loginChange', '2017-06-16 15:18:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (724, 'cpignol', 'zaalpes-loginWrite', '2017-06-16 15:21:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (725, 'cpignol', 'zaalpes-LoginGestion-write', '2017-06-16 15:21:42', '4', '10.4.2.103');
INSERT INTO log VALUES (726, 'cpignol', 'zaalpes-loginList', '2017-06-16 15:21:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (727, 'cpignol', 'zaalpes-aclloginList', '2017-06-16 15:22:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (728, 'cpignol', 'zaalpes-loginList', '2017-06-16 15:22:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (729, 'cpignol', 'zaalpes-loginChange', '2017-06-16 15:22:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (730, 'cpignol', 'zaalpes-loginWrite', '2017-06-16 15:22:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (731, 'cpignol', 'zaalpes-LoginGestion-write', '2017-06-16 15:22:44', '5', '10.4.2.103');
INSERT INTO log VALUES (732, 'cpignol', 'zaalpes-loginList', '2017-06-16 15:22:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (733, 'cpignol', 'zaalpes-aclloginList', '2017-06-16 15:23:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (734, 'cpignol', 'zaalpes-loginList', '2017-06-16 15:24:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (735, 'cpignol', 'zaalpes-loginChange', '2017-06-16 15:24:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (736, 'cpignol', 'zaalpes-loginWrite', '2017-06-16 15:24:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (737, 'cpignol', 'zaalpes-LoginGestion-write', '2017-06-16 15:24:23', '6', '10.4.2.103');
INSERT INTO log VALUES (738, 'cpignol', 'zaalpes-loginList', '2017-06-16 15:24:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (739, 'cpignol', 'zaalpes-containerList', '2017-06-16 15:26:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (740, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:26:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (741, 'cpignol', 'zaalpes-containerChange', '2017-06-16 15:26:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (742, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:26:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (743, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:28:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (744, 'cpignol', 'zaalpes-containerWrite', '2017-06-16 15:30:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (745, 'cpignol', 'zaalpes-Container-write', '2017-06-16 15:30:31', '1', '10.4.2.103');
INSERT INTO log VALUES (746, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:30:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (747, 'cpignol', 'zaalpes-containerChange', '2017-06-16 15:31:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (748, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:31:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (749, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:31:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (750, 'cpignol', 'zaalpes-containerChange', '2017-06-16 15:33:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (751, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:33:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (752, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:34:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (753, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:34:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (754, 'cpignol', 'zaalpes-containerWrite', '2017-06-16 15:35:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (755, 'cpignol', 'zaalpes-Container-write', '2017-06-16 15:35:41', '2', '10.4.2.103');
INSERT INTO log VALUES (756, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:35:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (757, 'cpignol', 'zaalpes-containerChange', '2017-06-16 15:36:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (758, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:36:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (759, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:36:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (760, 'cpignol', 'zaalpes-containerWrite', '2017-06-16 15:36:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (761, 'cpignol', 'zaalpes-Container-write', '2017-06-16 15:36:47', '3', '10.4.2.103');
INSERT INTO log VALUES (762, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:36:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (763, 'cpignol', 'zaalpes-containerList', '2017-06-16 15:37:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (764, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:37:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (765, 'cpignol', 'zaalpes-containerList', '2017-06-16 15:37:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (766, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:37:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (767, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:37:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (768, 'cpignol', 'zaalpes-containerList', '2017-06-16 15:37:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (769, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:37:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (770, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:37:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (771, 'cpignol', 'zaalpes-containerList', '2017-06-16 15:38:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (772, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:38:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (773, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:38:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (774, 'cpignol', 'zaalpes-containerChange', '2017-06-16 15:38:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (775, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:38:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (776, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:38:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (777, 'cpignol', 'zaalpes-containerWrite', '2017-06-16 15:39:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (778, 'cpignol', 'zaalpes-Container-write', '2017-06-16 15:39:00', '4', '10.4.2.103');
INSERT INTO log VALUES (779, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:39:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (780, 'cpignol', 'zaalpes-containerList', '2017-06-16 15:39:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (781, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:39:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (782, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:39:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (783, 'cpignol', 'zaalpes-containerChange', '2017-06-16 15:39:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (784, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:39:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (785, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:39:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (786, 'cpignol', 'zaalpes-containerWrite', '2017-06-16 15:40:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (787, 'cpignol', 'zaalpes-Container-write', '2017-06-16 15:40:49', '5', '10.4.2.103');
INSERT INTO log VALUES (788, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:40:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (789, 'cpignol', 'zaalpes-containerChange', '2017-06-16 15:40:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (790, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:41:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (791, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:41:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (792, 'cpignol', 'zaalpes-containerWrite', '2017-06-16 15:41:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (793, 'cpignol', 'zaalpes-Container-write', '2017-06-16 15:41:44', '6', '10.4.2.103');
INSERT INTO log VALUES (794, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:41:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (795, 'cpignol', 'zaalpes-containerList', '2017-06-16 15:42:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (796, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:42:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (797, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:42:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (798, 'cpignol', 'zaalpes-containerChange', '2017-06-16 15:42:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (799, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:42:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (800, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:42:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (801, 'cpignol', 'zaalpes-containerWrite', '2017-06-16 15:42:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (802, 'cpignol', 'zaalpes-Container-write', '2017-06-16 15:42:50', '7', '10.4.2.103');
INSERT INTO log VALUES (803, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:42:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (804, 'cpignol', 'zaalpes-containerChange', '2017-06-16 15:43:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (805, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:43:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (806, 'cpignol', 'zaalpes-containerList', '2017-06-16 15:43:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (807, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:43:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (808, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:43:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (809, 'cpignol', 'zaalpes-containerChange', '2017-06-16 15:44:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (810, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:44:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (811, 'cpignol', 'zaalpes-containerWrite', '2017-06-16 15:44:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (812, 'cpignol', 'zaalpes-Container-write', '2017-06-16 15:44:24', '7', '10.4.2.103');
INSERT INTO log VALUES (813, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:44:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (814, 'cpignol', 'zaalpes-containerList', '2017-06-16 15:44:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (815, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:44:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (816, 'cpignol', 'zaalpes-containerExportCSV', '2017-06-16 15:45:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (817, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:48:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (818, 'cpignol', 'zaalpes-containerChange', '2017-06-16 15:49:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (819, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:49:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (820, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:49:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (821, 'cpignol', 'zaalpes-containerWrite', '2017-06-16 15:51:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (822, 'cpignol', 'zaalpes-Container-write', '2017-06-16 15:51:01', '8', '10.4.2.103');
INSERT INTO log VALUES (823, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:51:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (824, 'cpignol', 'zaalpes-containerChange', '2017-06-16 15:51:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (825, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:51:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (826, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:52:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (827, 'cpignol', 'zaalpes-containerWrite', '2017-06-16 15:52:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (828, 'cpignol', 'zaalpes-Container-write', '2017-06-16 15:52:14', '9', '10.4.2.103');
INSERT INTO log VALUES (829, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:52:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (830, 'cpignol', 'zaalpes-containerList', '2017-06-16 15:52:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (831, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:52:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (832, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:52:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (833, 'cpignol', 'zaalpes-containerList', '2017-06-16 15:53:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (834, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:53:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (835, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:53:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (836, 'cpignol', 'zaalpes-containerList', '2017-06-16 15:53:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (837, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:53:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (838, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:53:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (839, 'cpignol', 'zaalpes-storagecontainerInput', '2017-06-16 15:54:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (840, 'cpignol', 'zaalpes-containerGetFromUid', '2017-06-16 15:54:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (841, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:54:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (842, 'cpignol', 'zaalpes-containerGetFromType', '2017-06-16 15:54:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (843, 'cpignol', 'zaalpes-storagecontainerWrite', '2017-06-16 15:56:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (844, 'cpignol', 'zaalpes-Storage-write', '2017-06-16 15:56:34', '8', '10.4.2.103');
INSERT INTO log VALUES (845, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 15:56:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (846, 'cpignol', 'zaalpes-containerList', '2017-06-16 15:56:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (847, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 15:56:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (848, 'cpignol', 'zaalpes-containerExportCSV', '2017-06-16 15:57:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (849, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 16:01:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (850, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 16:04:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (851, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 16:05:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (852, 'cpignol', 'zaalpes-containerobjectIdentifierChange', '2017-06-16 16:05:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (853, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:06:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (854, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:06:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (855, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:07:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (856, 'cpignol', 'zaalpes-labelChange', '2017-06-16 16:07:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (857, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 16:09:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (858, 'cpignol', 'zaalpes-Label-write', '2017-06-16 16:09:22', '2', '10.4.2.103');
INSERT INTO log VALUES (859, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:09:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (860, 'cpignol', 'zaalpes-labelChange', '2017-06-16 16:09:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (861, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 16:14:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (862, 'cpignol', 'zaalpes-Label-write', '2017-06-16 16:14:23', '3', '10.4.2.103');
INSERT INTO log VALUES (863, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:14:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (864, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:14:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (865, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:14:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (866, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 16:14:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (867, 'cpignol', 'zaalpes-containerTypeList', '2017-06-16 16:14:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (868, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:15:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (869, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:15:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (870, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 16:15:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (871, 'cpignol', 'zaalpes-containerChange', '2017-06-16 16:15:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (872, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:15:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (873, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 16:15:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (874, 'cpignol', 'zaalpes-containerobjectIdentifierChange', '2017-06-16 16:15:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (875, 'cpignol', 'zaalpes-containerobjectIdentifierWrite', '2017-06-16 16:15:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (876, 'cpignol', 'zaalpes-containerobjectIdentifierChange', '2017-06-16 16:15:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (877, 'cpignol', 'zaalpes-administration', '2017-06-16 16:16:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (878, 'cpignol', 'zaalpes-identifierTypeList', '2017-06-16 16:16:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (879, 'cpignol', 'zaalpes-identifierTypeChange', '2017-06-16 16:17:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (880, 'cpignol', 'zaalpes-identifierTypeWrite', '2017-06-16 16:17:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (881, 'cpignol', 'zaalpes-IdentifierType-write', '2017-06-16 16:17:55', '1', '10.4.2.103');
INSERT INTO log VALUES (882, 'cpignol', 'zaalpes-identifierTypeList', '2017-06-16 16:17:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (883, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:18:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (884, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:18:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (885, 'cpignol', 'zaalpes-identifierTypeList', '2017-06-16 16:18:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (886, 'cpignol', 'zaalpes-identifierTypeChange', '2017-06-16 16:18:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (887, 'cpignol', 'zaalpes-identifierTypeWrite', '2017-06-16 16:19:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (888, 'cpignol', 'zaalpes-IdentifierType-write', '2017-06-16 16:19:46', '1', '10.4.2.103');
INSERT INTO log VALUES (889, 'cpignol', 'zaalpes-identifierTypeList', '2017-06-16 16:19:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (890, 'cpignol', 'zaalpes-identifierTypeChange', '2017-06-16 16:19:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (891, 'cpignol', 'zaalpes-identifierTypeWrite', '2017-06-16 16:20:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (892, 'cpignol', 'zaalpes-IdentifierType-write', '2017-06-16 16:20:09', '1', '10.4.2.103');
INSERT INTO log VALUES (893, 'cpignol', 'zaalpes-identifierTypeList', '2017-06-16 16:20:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (894, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:20:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (895, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:20:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (896, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 16:20:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (897, 'cpignol', 'zaalpes-containerobjectIdentifierChange', '2017-06-16 16:28:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (898, 'cpignol', 'zaalpes-containerobjectIdentifierWrite', '2017-06-16 16:29:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (899, 'cpignol', 'zaalpes-ObjectIdentifier-write', '2017-06-16 16:29:14', '2', '10.4.2.103');
INSERT INTO log VALUES (900, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 16:29:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (901, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:29:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (902, 'cpignol', 'zaalpes-labelChange', '2017-06-16 16:29:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (903, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 16:30:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (904, 'cpignol', 'zaalpes-Label-write', '2017-06-16 16:30:57', '3', '10.4.2.103');
INSERT INTO log VALUES (905, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:30:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (906, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:31:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (907, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:31:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (908, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 16:31:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (909, 'cpignol', 'zaalpes-containerobjectIdentifierChange', '2017-06-16 16:31:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (910, 'cpignol', 'zaalpes-containerobjectIdentifierWrite', '2017-06-16 16:31:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (911, 'cpignol', 'zaalpes-ObjectIdentifier-write', '2017-06-16 16:31:25', '3', '10.4.2.103');
INSERT INTO log VALUES (912, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 16:31:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (913, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:31:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (914, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:31:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (915, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 16:31:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (916, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:31:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (917, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:31:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (918, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 16:31:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (919, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:32:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (920, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:32:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (921, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 16:32:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (922, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 16:32:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (923, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:32:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (924, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:32:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (925, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 16:33:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (926, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:33:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (927, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:33:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (928, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:33:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (929, 'cpignol', 'zaalpes-labelChange', '2017-06-16 16:33:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (930, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 16:33:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (931, 'cpignol', 'zaalpes-Label-write', '2017-06-16 16:33:48', '2', '10.4.2.103');
INSERT INTO log VALUES (932, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:33:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (933, 'cpignol', 'zaalpes-objets', '2017-06-16 16:34:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (934, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:34:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (935, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:34:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (936, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 16:34:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (937, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 16:34:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (938, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 16:35:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (939, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:36:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (940, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:36:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (941, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:36:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (942, 'cpignol', 'zaalpes-labelChange', '2017-06-16 16:36:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (943, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 16:38:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (944, 'cpignol', 'zaalpes-Label-write', '2017-06-16 16:38:10', '3', '10.4.2.103');
INSERT INTO log VALUES (945, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:38:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (946, 'cpignol', 'zaalpes-objets', '2017-06-16 16:38:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (947, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:38:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (948, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:38:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (949, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 16:38:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (950, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:38:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (951, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:38:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (952, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:38:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (953, 'cpignol', 'zaalpes-identifierTypeList', '2017-06-16 16:38:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (954, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:39:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (955, 'cpignol', 'zaalpes-labelChange', '2017-06-16 16:39:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (956, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 16:39:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (957, 'cpignol', 'zaalpes-Label-write', '2017-06-16 16:39:42', '3', '10.4.2.103');
INSERT INTO log VALUES (958, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:39:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (959, 'cpignol', 'zaalpes-objets', '2017-06-16 16:39:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (960, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:39:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (961, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:39:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (962, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 16:40:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (963, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:40:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (964, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:40:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (965, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:40:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (966, 'cpignol', 'zaalpes-labelChange', '2017-06-16 16:40:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (967, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 16:41:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (968, 'cpignol', 'zaalpes-Label-write', '2017-06-16 16:41:37', '3', '10.4.2.103');
INSERT INTO log VALUES (969, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:41:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (970, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:41:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (971, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:41:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (972, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 16:41:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (973, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:41:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (974, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:41:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (975, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 16:42:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (976, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:43:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (977, 'cpignol', 'zaalpes-labelChange', '2017-06-16 16:43:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (978, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 16:46:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (979, 'cpignol', 'zaalpes-Label-write', '2017-06-16 16:46:30', '3', '10.4.2.103');
INSERT INTO log VALUES (980, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:46:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (981, 'cpignol', 'zaalpes-objets', '2017-06-16 16:46:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (982, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:46:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (983, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:46:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (984, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 16:47:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (985, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:47:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (986, 'cpignol', 'zaalpes-labelChange', '2017-06-16 16:47:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (987, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 16:48:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (988, 'cpignol', 'zaalpes-Label-write', '2017-06-16 16:48:31', '3', '10.4.2.103');
INSERT INTO log VALUES (989, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:48:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (990, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:48:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (991, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:48:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (992, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 16:48:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (993, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:53:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (994, 'cpignol', 'zaalpes-labelChange', '2017-06-16 16:53:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (995, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 16:58:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (996, 'cpignol', 'zaalpes-Label-write', '2017-06-16 16:58:20', '3', '10.4.2.103');
INSERT INTO log VALUES (997, 'cpignol', 'zaalpes-labelList', '2017-06-16 16:58:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (998, 'cpignol', 'zaalpes-containerList', '2017-06-16 16:58:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (999, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 16:58:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1000, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 16:58:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1001, 'cpignol', 'zaalpes-labelList', '2017-06-16 17:19:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1002, 'cpignol', 'zaalpes-labelChange', '2017-06-16 17:19:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1003, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 17:22:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1004, 'cpignol', 'zaalpes-Label-write', '2017-06-16 17:22:19', '3', '10.4.2.103');
INSERT INTO log VALUES (1005, 'cpignol', 'zaalpes-labelList', '2017-06-16 17:22:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1006, 'cpignol', 'zaalpes-containerList', '2017-06-16 17:22:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1007, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 17:22:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1008, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 17:22:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1009, 'cpignol', 'zaalpes-containerList', '2017-06-16 17:22:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1010, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 17:22:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1011, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 17:23:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1012, 'cpignol', 'zaalpes-containerList', '2017-06-16 17:23:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1013, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 17:23:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1014, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 17:23:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1015, 'cpignol', 'zaalpes-containerList', '2017-06-16 17:23:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1016, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 17:23:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1017, 'cpignol', 'zaalpes-labelList', '2017-06-16 17:23:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1018, 'cpignol', 'zaalpes-labelChange', '2017-06-16 17:23:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1019, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 17:25:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1020, 'cpignol', 'zaalpes-Label-write', '2017-06-16 17:25:32', '3', '10.4.2.103');
INSERT INTO log VALUES (1021, 'cpignol', 'zaalpes-labelList', '2017-06-16 17:25:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1022, 'cpignol', 'zaalpes-objets', '2017-06-16 17:25:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1023, 'cpignol', 'zaalpes-containerList', '2017-06-16 17:25:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1024, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 17:25:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1025, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 17:25:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1026, 'cpignol', 'zaalpes-parametre', '2017-06-16 17:26:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1027, 'cpignol', 'zaalpes-parametre', '2017-06-16 17:26:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1028, 'cpignol', 'zaalpes-parametre', '2017-06-16 17:26:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1029, 'cpignol', 'zaalpes-default', '2017-06-16 17:27:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1030, 'cpignol', 'zaalpes-labelList', '2017-06-16 17:27:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1031, 'cpignol', 'zaalpes-labelChange', '2017-06-16 17:27:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1032, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 17:28:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1033, 'cpignol', 'zaalpes-Label-write', '2017-06-16 17:28:04', '3', '10.4.2.103');
INSERT INTO log VALUES (1034, 'cpignol', 'zaalpes-labelList', '2017-06-16 17:28:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1035, 'cpignol', 'zaalpes-objets', '2017-06-16 17:28:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1036, 'cpignol', 'zaalpes-containerList', '2017-06-16 17:28:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1037, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 17:28:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1038, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 17:28:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1039, 'cpignol', 'zaalpes-labelList', '2017-06-16 17:32:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1040, 'cpignol', 'zaalpes-labelChange', '2017-06-16 17:32:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1041, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 17:36:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1042, 'cpignol', 'zaalpes-Label-write', '2017-06-16 17:36:22', '3', '10.4.2.103');
INSERT INTO log VALUES (1043, 'cpignol', 'zaalpes-labelList', '2017-06-16 17:36:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1044, 'cpignol', 'zaalpes-containerList', '2017-06-16 17:36:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1045, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 17:36:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1046, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 17:36:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1047, 'cpignol', 'zaalpes-labelList', '2017-06-16 17:37:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1048, 'cpignol', 'zaalpes-labelChange', '2017-06-16 17:37:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1049, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 17:38:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1050, 'cpignol', 'zaalpes-Label-write', '2017-06-16 17:38:04', '3', '10.4.2.103');
INSERT INTO log VALUES (1051, 'cpignol', 'zaalpes-labelList', '2017-06-16 17:38:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1052, 'cpignol', 'zaalpes-containerList', '2017-06-16 17:38:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1053, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 17:38:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1054, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-16 17:38:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1055, 'cpignol', 'zaalpes-containerList', '2017-06-16 17:42:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1056, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 17:42:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1057, 'cpignol', 'zaalpes-containerExportCSV', '2017-06-16 17:43:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1058, 'cpignol', 'zaalpes-containerExportCSV', '2017-06-16 17:43:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1059, 'cpignol', 'zaalpes-importChange', '2017-06-16 17:45:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1060, 'cpignol', 'zaalpes-containerList', '2017-06-16 17:46:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1061, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 17:46:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1062, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 17:46:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1063, 'cpignol', 'zaalpes-importChange', '2017-06-16 17:48:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1064, 'cpignol', 'zaalpes-importControl', '2017-06-16 17:57:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1065, 'cpignol', 'zaalpes-importChange', '2017-06-16 17:57:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1066, 'cpignol', 'zaalpes-importImport', '2017-06-16 17:57:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1067, 'cpignol', 'zaalpes-containerList', '2017-06-16 17:59:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1068, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 17:59:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1069, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 17:59:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1070, 'cpignol', 'zaalpes-storagecontainerInput', '2017-06-16 18:00:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1071, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 18:00:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1072, 'cpignol', 'zaalpes-containerGetFromType', '2017-06-16 18:00:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1073, 'cpignol', 'zaalpes-storagecontainerWrite', '2017-06-16 18:00:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1074, 'cpignol', 'zaalpes-Storage-write', '2017-06-16 18:00:57', '9', '10.4.2.103');
INSERT INTO log VALUES (1075, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 18:00:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1076, 'cpignol', 'zaalpes-containerList', '2017-06-16 18:01:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1077, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 18:01:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1078, 'cpignol', 'zaalpes-importChange', '2017-06-16 18:02:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1079, 'cpignol', 'zaalpes-importControl', '2017-06-16 18:02:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1080, 'cpignol', 'zaalpes-importChange', '2017-06-16 18:02:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1081, 'cpignol', 'zaalpes-importImport', '2017-06-16 18:02:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1082, 'cpignol', 'zaalpes-importChange', '2017-06-16 18:02:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1083, 'cpignol', 'zaalpes-importControl', '2017-06-16 18:04:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1084, 'cpignol', 'zaalpes-importChange', '2017-06-16 18:04:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1085, 'cpignol', 'zaalpes-containerList', '2017-06-16 18:05:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1086, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 18:05:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1087, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 18:06:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1088, 'cpignol', 'zaalpes-containerList', '2017-06-16 18:07:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1089, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 18:07:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1090, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 18:07:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1091, 'cpignol', 'zaalpes-containerList', '2017-06-16 18:18:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1092, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 18:18:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1093, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 18:18:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1094, 'cpignol', 'zaalpes-containerChange', '2017-06-16 18:18:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1095, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 18:18:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1096, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 18:18:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1097, 'cpignol', 'zaalpes-containerobjectIdentifierChange', '2017-06-16 18:18:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1098, 'cpignol', 'zaalpes-containerobjectIdentifierWrite', '2017-06-16 18:18:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1099, 'cpignol', 'zaalpes-ObjectIdentifier-write', '2017-06-16 18:18:56', '81', '10.4.2.103');
INSERT INTO log VALUES (1100, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 18:18:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1101, 'cpignol', 'zaalpes-containerList', '2017-06-16 18:19:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1102, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 18:19:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1103, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 18:19:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1104, 'cpignol', 'zaalpes-containerList', '2017-06-16 18:19:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1105, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 18:19:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1106, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 18:19:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1107, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 18:19:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1108, 'cpignol', 'zaalpes-containerList', '2017-06-16 18:19:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1109, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 18:19:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1110, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 18:19:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1111, 'cpignol', 'zaalpes-containerChange', '2017-06-16 18:20:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1112, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 18:20:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1113, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 18:20:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1114, 'cpignol', 'zaalpes-containerList', '2017-06-16 18:22:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1115, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 18:22:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1116, 'cpignol', 'zaalpes-containerChange', '2017-06-16 18:22:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1117, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 18:22:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1118, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 18:25:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1119, 'cpignol', 'zaalpes-containerWrite', '2017-06-16 18:25:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1120, 'cpignol', 'zaalpes-Container-write', '2017-06-16 18:25:51', '88', '10.4.2.103');
INSERT INTO log VALUES (1121, 'cpignol', 'zaalpes-containerDisplay', '2017-06-16 18:25:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1122, 'cpignol', 'zaalpes-containerList', '2017-06-16 18:26:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1123, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 18:26:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1124, 'cpignol', 'zaalpes-projectList', '2017-06-16 18:44:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1125, 'cpignol', 'zaalpes-protocolList', '2017-06-16 18:44:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1126, 'cpignol', 'zaalpes-protocolChange', '2017-06-16 18:44:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1127, 'cpignol', 'zaalpes-protocolWrite', '2017-06-16 18:45:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1128, 'cpignol', 'zaalpes-Protocol-write', '2017-06-16 18:45:19', '1', '10.4.2.103');
INSERT INTO log VALUES (1129, 'cpignol', 'zaalpes-protocolList', '2017-06-16 18:45:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1130, 'cpignol', 'zaalpes-protocolChange', '2017-06-16 18:45:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1131, 'cpignol', 'zaalpes-protocolList', '2017-06-16 18:45:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1132, 'cpignol', 'zaalpes-operationList', '2017-06-16 18:45:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1133, 'cpignol', 'zaalpes-operationChange', '2017-06-16 18:45:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1134, 'cpignol', 'zaalpes-operationWrite', '2017-06-16 19:01:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1135, 'cpignol', 'zaalpes-Operation-write', '2017-06-16 19:01:59', '1', '10.4.2.103');
INSERT INTO log VALUES (1136, 'cpignol', 'zaalpes-operationList', '2017-06-16 19:01:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1137, 'cpignol', 'zaalpes-operationChange', '2017-06-16 19:02:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1138, 'cpignol', 'zaalpes-operationWrite', '2017-06-16 19:03:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1139, 'cpignol', 'zaalpes-Operation-write', '2017-06-16 19:03:35', '1', '10.4.2.103');
INSERT INTO log VALUES (1140, 'cpignol', 'zaalpes-operationList', '2017-06-16 19:03:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1141, 'cpignol', 'zaalpes-labelChange', '2017-06-16 19:03:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1142, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 19:16:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1143, 'cpignol', 'zaalpes-Label-write', '2017-06-16 19:16:28', '4', '10.4.2.103');
INSERT INTO log VALUES (1144, 'cpignol', 'zaalpes-labelList', '2017-06-16 19:16:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1145, 'cpignol', 'zaalpes-labelChange', '2017-06-16 19:16:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1146, 'cpignol', 'zaalpes-labelList', '2017-06-16 19:17:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1147, 'cpignol', 'zaalpes-labelChange', '2017-06-16 19:17:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1148, 'cpignol', 'zaalpes-labelWrite', '2017-06-16 19:18:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1149, 'cpignol', 'zaalpes-Label-write', '2017-06-16 19:18:42', '5', '10.4.2.103');
INSERT INTO log VALUES (1150, 'cpignol', 'zaalpes-labelList', '2017-06-16 19:18:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1151, 'cpignol', 'zaalpes-sampleList', '2017-06-16 19:18:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1152, 'cpignol', 'zaalpes-sampleChange', '2017-06-16 19:18:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1153, 'cpignol', 'zaalpes-identifierTypeList', '2017-06-16 19:19:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1154, 'cpignol', 'zaalpes-identifierTypeChange', '2017-06-16 19:19:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1155, 'cpignol', 'zaalpes-identifierTypeWrite', '2017-06-16 19:19:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1156, 'cpignol', 'zaalpes-IdentifierType-write', '2017-06-16 19:19:50', '2', '10.4.2.103');
INSERT INTO log VALUES (1157, 'cpignol', 'zaalpes-identifierTypeList', '2017-06-16 19:19:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1158, 'cpignol', 'zaalpes-sampleList', '2017-06-16 19:20:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1159, 'cpignol', 'zaalpes-sampleChange', '2017-06-16 19:20:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1160, 'cpignol', 'zaalpes-sampleTypeList', '2017-06-16 19:21:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1161, 'cpignol', 'zaalpes-sampleTypeChange', '2017-06-16 19:21:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1162, 'cpignol', 'zaalpes-sampleTypeWrite', '2017-06-16 19:22:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1163, 'cpignol', 'zaalpes-SampleType-write', '2017-06-16 19:22:23', '1', '10.4.2.103');
INSERT INTO log VALUES (1164, 'cpignol', 'zaalpes-sampleTypeList', '2017-06-16 19:22:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1165, 'cpignol', 'zaalpes-sampleList', '2017-06-16 19:22:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1166, 'cpignol', 'zaalpes-sampleChange', '2017-06-16 19:22:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1167, 'cpignol', 'zaalpes-metadataFormGetDetail', '2017-06-16 19:23:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1168, 'cpignol', 'zaalpes-sampleWrite', '2017-06-16 19:26:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1169, 'cpignol', 'zaalpes-Sample-write', '2017-06-16 19:26:45', '89', '10.4.2.103');
INSERT INTO log VALUES (1170, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-16 19:26:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1171, 'cpignol', 'zaalpes-storagesampleInput', '2017-06-16 19:27:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1172, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 19:27:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1173, 'cpignol', 'zaalpes-containerGetFromType', '2017-06-16 19:27:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1174, 'cpignol', 'zaalpes-storagesampleWrite', '2017-06-16 19:27:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1175, 'cpignol', 'zaalpes-Storage-write', '2017-06-16 19:27:45', '87', '10.4.2.103');
INSERT INTO log VALUES (1176, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-16 19:27:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1177, 'cpignol', 'zaalpes-sampleList', '2017-06-16 19:28:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1178, 'cpignol', 'zaalpes-sampleList', '2017-06-16 19:28:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1179, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-16 19:28:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1180, 'cpignol', 'zaalpes-sampleobjectIdentifierChange', '2017-06-16 19:28:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1181, 'cpignol', 'zaalpes-sampleobjectIdentifierWrite', '2017-06-16 19:29:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1182, 'cpignol', 'zaalpes-ObjectIdentifier-write', '2017-06-16 19:29:00', '82', '10.4.2.103');
INSERT INTO log VALUES (1183, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-16 19:29:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1184, 'cpignol', 'zaalpes-sampleList', '2017-06-16 19:29:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1185, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-16 19:29:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1186, 'unknown', 'zaalpes-default', '2017-06-16 19:45:19', 'ok', '77.136.87.4');
INSERT INTO log VALUES (1187, 'unknown', 'zaalpes-default', '2017-06-16 19:45:29', 'ok', '77.136.87.4');
INSERT INTO log VALUES (1188, 'unknown', 'zaalpes-connexion', '2017-06-16 19:45:43', 'ok', '77.136.87.4');
INSERT INTO log VALUES (1189, 'Cpignol', 'zaalpes-connexion', '2017-06-16 19:47:02', 'db-ko', '77.136.87.4');
INSERT INTO log VALUES (1190, 'unknown', 'zaalpes-default', '2017-06-16 19:47:02', 'ok', '77.136.87.4');
INSERT INTO log VALUES (1191, 'unknown', 'zaalpes-connexion', '2017-06-16 19:47:09', 'ok', '77.136.87.4');
INSERT INTO log VALUES (1192, 'cpignol', 'zaalpes-connexion', '2017-06-16 19:48:03', 'db-ko', '77.136.87.4');
INSERT INTO log VALUES (1193, 'unknown', 'zaalpes-default', '2017-06-16 19:48:03', 'ok', '77.136.87.4');
INSERT INTO log VALUES (1194, 'unknown', 'zaalpes-connexion', '2017-06-16 19:48:13', 'ok', '77.136.87.4');
INSERT INTO log VALUES (1195, 'cpignol', 'zaalpes-connexion', '2017-06-16 19:48:54', 'db-ok', '77.136.87.4');
INSERT INTO log VALUES (1196, 'cpignol', 'zaalpes-default', '2017-06-16 19:48:54', 'ok', '77.136.87.4');
INSERT INTO log VALUES (1197, 'cpignol', 'zaalpes-sampleList', '2017-06-16 19:49:02', 'ok', '77.136.87.4');
INSERT INTO log VALUES (1198, 'cpignol', 'zaalpes-sampleList', '2017-06-16 19:49:08', 'ok', '77.136.87.4');
INSERT INTO log VALUES (1199, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-16 19:49:57', 'ok', '77.136.87.4');
INSERT INTO log VALUES (1200, 'cpignol', 'zaalpes-labelList', '2017-06-16 19:50:26', 'ok', '77.136.87.4');
INSERT INTO log VALUES (1201, 'cpignol', 'zaalpes-labelChange', '2017-06-16 19:50:35', 'ok', '77.136.87.4');
INSERT INTO log VALUES (1202, 'cpignol', 'zaalpes-disconnect-ipaddress-changed', '2017-06-16 19:58:11', 'old:77.136.87.4-new:92.90.21.40', '92.90.21.40');
INSERT INTO log VALUES (1203, 'cpignol', 'zaalpes-labelList-connexion', '2017-06-16 19:58:11', 'token-ok', '92.90.21.40');
INSERT INTO log VALUES (1204, 'cpignol', 'zaalpes-labelList', '2017-06-16 19:58:11', 'ok', '92.90.21.40');
INSERT INTO log VALUES (1205, 'unknown', 'zaalpes-sampleList', '2017-06-16 19:58:20', 'nologin', '92.90.21.40');
INSERT INTO log VALUES (1206, 'unknown', 'zaalpes-containerList', '2017-06-16 19:58:35', 'nologin', '92.90.21.40');
INSERT INTO log VALUES (1207, 'cpignol', 'zaalpes-connexion', '2017-06-16 19:59:12', 'db-ok', '92.90.21.40');
INSERT INTO log VALUES (1208, 'cpignol', 'zaalpes-containerList', '2017-06-16 19:59:12', 'ok', '92.90.21.40');
INSERT INTO log VALUES (1209, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 19:59:14', 'ok', '92.90.21.40');
INSERT INTO log VALUES (1210, 'cpignol', 'zaalpes-containerList', '2017-06-16 19:59:18', 'ok', '92.90.21.40');
INSERT INTO log VALUES (1211, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-16 19:59:20', 'ok', '92.90.21.40');
INSERT INTO log VALUES (1212, 'cpignol', 'zaalpes-sampleList', '2017-06-16 19:59:34', 'ok', '92.90.21.40');
INSERT INTO log VALUES (1213, 'cpignol', 'zaalpes-sampleList', '2017-06-16 19:59:41', 'ok', '92.90.21.40');
INSERT INTO log VALUES (1214, 'unknown', 'zaalpes-default', '2017-06-17 08:03:15', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1215, 'unknown', 'zaalpes-connexion', '2017-06-17 08:03:54', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1216, 'cpignol', 'zaalpes-connexion', '2017-06-17 08:04:10', 'db-ok', '193.250.222.82');
INSERT INTO log VALUES (1217, 'cpignol', 'zaalpes-default', '2017-06-17 08:04:10', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1218, 'cpignol', 'zaalpes-labelList', '2017-06-17 08:04:23', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1219, 'cpignol', 'zaalpes-labelChange', '2017-06-17 08:04:33', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1220, 'cpignol', 'zaalpes-labelWrite', '2017-06-17 08:06:11', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1221, 'cpignol', 'zaalpes-Label-write', '2017-06-17 08:06:11', '5', '193.250.222.82');
INSERT INTO log VALUES (1222, 'cpignol', 'zaalpes-labelList', '2017-06-17 08:06:11', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1223, 'cpignol', 'zaalpes-sampleList', '2017-06-17 08:06:26', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1224, 'cpignol', 'zaalpes-sampleList', '2017-06-17 08:06:33', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1225, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-17 08:06:46', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1226, 'cpignol', 'zaalpes-sampleList', '2017-06-17 08:07:13', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1227, 'cpignol', 'zaalpes-labelList', '2017-06-17 08:07:50', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1228, 'cpignol', 'zaalpes-labelChange', '2017-06-17 08:08:11', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1229, 'cpignol', 'zaalpes-labelList', '2017-06-17 08:09:09', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1230, 'cpignol', 'zaalpes-labelChange', '2017-06-17 08:09:27', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1231, 'cpignol', 'zaalpes-labelWrite', '2017-06-17 08:12:44', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1232, 'cpignol', 'zaalpes-Label-write', '2017-06-17 08:12:44', '5', '193.250.222.82');
INSERT INTO log VALUES (1233, 'cpignol', 'zaalpes-labelList', '2017-06-17 08:12:44', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1234, 'cpignol', 'zaalpes-identifierTypeList', '2017-06-17 08:13:27', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1235, 'cpignol', 'zaalpes-sampleList', '2017-06-17 08:13:54', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1236, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-17 08:14:22', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1237, 'cpignol', 'zaalpes-sampleChange', '2017-06-17 08:15:46', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1238, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-17 08:17:21', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1239, 'cpignol', 'zaalpes-sampleList', '2017-06-17 08:17:55', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1240, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-17 08:19:16', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1241, 'cpignol', 'zaalpes-sampleList', '2017-06-17 08:19:28', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1242, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-17 08:19:39', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1243, 'cpignol', 'zaalpes-sampleList', '2017-06-17 08:20:18', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1244, 'cpignol', 'zaalpes-labelList', '2017-06-17 08:21:14', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1245, 'cpignol', 'zaalpes-labelChange', '2017-06-17 08:23:32', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1246, 'cpignol', 'zaalpes-labelWrite', '2017-06-17 08:25:46', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1247, 'cpignol', 'zaalpes-Label-write', '2017-06-17 08:25:46', '5', '193.250.222.82');
INSERT INTO log VALUES (1248, 'cpignol', 'zaalpes-labelList', '2017-06-17 08:25:46', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1249, 'cpignol', 'zaalpes-sampleList', '2017-06-17 08:26:00', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1250, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-17 08:26:13', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1251, 'cpignol', 'zaalpes-labelChange', '2017-06-17 08:27:27', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1252, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-17 08:27:37', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1253, 'cpignol', 'zaalpes-labelWrite', '2017-06-17 08:31:29', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1254, 'cpignol', 'zaalpes-Label-write', '2017-06-17 08:31:29', '5', '193.250.222.82');
INSERT INTO log VALUES (1255, 'cpignol', 'zaalpes-labelList', '2017-06-17 08:31:29', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1256, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-17 08:31:57', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1257, 'cpignol', 'zaalpes-labelChange', '2017-06-17 08:32:31', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1258, 'cpignol', 'zaalpes-labelWrite', '2017-06-17 08:34:41', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1259, 'cpignol', 'zaalpes-Label-write', '2017-06-17 08:34:41', '5', '193.250.222.82');
INSERT INTO log VALUES (1260, 'cpignol', 'zaalpes-labelList', '2017-06-17 08:34:41', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1261, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-17 08:34:54', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1262, 'cpignol', 'zaalpes-labelChange', '2017-06-17 08:36:08', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1263, 'cpignol', 'zaalpes-labelWrite', '2017-06-17 08:39:49', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1264, 'cpignol', 'zaalpes-Label-write', '2017-06-17 08:39:49', '5', '193.250.222.82');
INSERT INTO log VALUES (1265, 'cpignol', 'zaalpes-labelList', '2017-06-17 08:39:49', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1266, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-17 08:39:56', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1267, 'cpignol', 'zaalpes-labelChange', '2017-06-17 08:40:24', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1268, 'cpignol', 'zaalpes-labelWrite', '2017-06-17 08:43:14', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1269, 'cpignol', 'zaalpes-Label-write', '2017-06-17 08:43:14', '5', '193.250.222.82');
INSERT INTO log VALUES (1270, 'cpignol', 'zaalpes-labelList', '2017-06-17 08:43:14', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1271, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-17 08:43:21', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1272, 'cpignol', 'zaalpes-labelChange', '2017-06-17 08:43:35', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1273, 'cpignol', 'zaalpes-labelWrite', '2017-06-17 08:43:53', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1274, 'cpignol', 'zaalpes-Label-write', '2017-06-17 08:43:53', '5', '193.250.222.82');
INSERT INTO log VALUES (1275, 'cpignol', 'zaalpes-labelList', '2017-06-17 08:43:53', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1276, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-17 08:43:59', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1277, 'cpignol', 'zaalpes-labelChange', '2017-06-17 08:44:04', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1278, 'cpignol', 'zaalpes-labelWrite', '2017-06-17 08:44:56', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1279, 'cpignol', 'zaalpes-Label-write', '2017-06-17 08:44:56', '5', '193.250.222.82');
INSERT INTO log VALUES (1280, 'cpignol', 'zaalpes-labelList', '2017-06-17 08:44:56', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1281, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-17 08:45:01', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1282, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-17 08:46:05', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1283, 'cpignol', 'zaalpes-labelChange', '2017-06-17 08:49:24', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1284, 'cpignol', 'zaalpes-labelList', '2017-06-17 08:49:33', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1285, 'cpignol', 'zaalpes-labelChange', '2017-06-17 08:49:36', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1286, 'cpignol', 'zaalpes-labelWrite', '2017-06-17 08:51:01', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1287, 'cpignol', 'zaalpes-Label-write', '2017-06-17 08:51:01', '4', '193.250.222.82');
INSERT INTO log VALUES (1288, 'cpignol', 'zaalpes-labelList', '2017-06-17 08:51:01', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1289, 'cpignol', 'zaalpes-sampleList', '2017-06-17 08:51:10', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1290, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-17 08:51:18', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1291, 'cpignol', 'zaalpes-sampleList', '2017-06-17 08:51:42', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1292, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-17 08:51:46', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1293, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-17 08:51:50', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1294, 'cpignol', 'zaalpes-sampleList', '2017-06-17 08:52:09', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1295, 'cpignol', 'zaalpes-containerList', '2017-06-17 09:21:03', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1296, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-17 09:21:04', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1297, 'cpignol', 'zaalpes-containerList', '2017-06-17 09:21:07', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1298, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-17 09:21:07', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1299, 'cpignol', 'zaalpes-containerDisplay', '2017-06-17 09:21:18', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1300, 'cpignol', 'zaalpes-containerList', '2017-06-17 09:21:24', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1301, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-17 09:21:27', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1302, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-17 09:21:46', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1303, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-17 09:22:05', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1304, 'cpignol', 'zaalpes-containerList', '2017-06-17 09:22:17', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1305, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-17 09:22:18', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1306, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-17 09:22:52', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1307, 'cpignol', 'zaalpes-containerList', '2017-06-17 09:23:20', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1308, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-17 09:23:21', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1309, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-17 09:23:40', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1310, 'cpignol', 'zaalpes-containerList', '2017-06-17 09:23:46', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1311, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-17 09:23:47', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1312, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-17 09:23:59', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1313, 'cpignol', 'zaalpes-containerPrintLabel', '2017-06-17 09:24:23', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1314, 'cpignol', 'zaalpes-loginList', '2017-06-17 09:32:17', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1315, 'cpignol', 'zaalpes-groupList', '2017-06-17 09:32:55', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1316, 'cpignol', 'zaalpes-groupChange', '2017-06-17 09:33:04', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1317, 'cpignol', 'zaalpes-appliList', '2017-06-17 09:33:22', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1318, 'cpignol', 'zaalpes-appliDisplay', '2017-06-17 09:33:28', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1319, 'cpignol', 'zaalpes-aclloginList', '2017-06-17 09:33:44', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1320, 'unknown', 'zaalpes-containerList', '2017-06-18 16:53:07', 'nologin', '193.250.222.82');
INSERT INTO log VALUES (1321, 'cpignol', 'zaalpes-connexion', '2017-06-18 17:08:30', 'db-ok', '193.250.222.82');
INSERT INTO log VALUES (1322, 'cpignol', 'zaalpes-containerList', '2017-06-18 17:08:30', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1323, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-18 17:08:31', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1324, 'cpignol', 'zaalpes-appliList', '2017-06-18 17:08:38', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1325, 'cpignol', 'zaalpes-appliDisplay', '2017-06-18 17:17:45', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1326, 'cpignol', 'zaalpes-disconnect', '2017-06-18 17:33:39', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1327, 'unknown', 'zaalpes-connexion', '2017-06-18 17:35:06', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1328, 'cpignol', 'zaalpes-connexion', '2017-06-18 17:35:50', 'db-ok', '193.250.222.82');
INSERT INTO log VALUES (1329, 'cpignol', 'zaalpes-default', '2017-06-18 17:35:50', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1330, 'cpignol', 'zaalpes-aclloginList', '2017-06-18 17:43:26', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1331, 'cpignol', 'zaalpes-loginList', '2017-06-18 17:43:31', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1332, 'cpignol', 'zaalpes-loginChange', '2017-06-18 17:43:40', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1333, 'cpignol', 'zaalpes-loginList', '2017-06-18 17:43:49', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1334, 'cpignol', 'zaalpes-aclloginList', '2017-06-18 18:00:52', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1335, 'cpignol', 'zaalpes-aclloginChange', '2017-06-18 18:00:58', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1336, 'cpignol', 'zaalpes-groupList', '2017-06-18 18:11:43', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1337, 'cpignol', 'zaalpes-appliList-connexion', '2017-06-18 18:54:12', 'token-ok', '193.250.222.82');
INSERT INTO log VALUES (1338, 'cpignol', 'zaalpes-appliList', '2017-06-18 18:54:12', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1339, 'cpignol', 'zaalpes-appliDisplay', '2017-06-18 18:54:18', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1340, 'cpignol', 'zaalpes-acoChange', '2017-06-18 18:54:21', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1341, 'cpignol', 'zaalpes-appliDisplay', '2017-06-18 18:55:09', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1342, 'cpignol', 'zaalpes-acoChange', '2017-06-18 18:55:16', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1343, 'cpignol', 'zaalpes-appliDisplay', '2017-06-18 18:55:19', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1344, 'cpignol', 'zaalpes-acoChange', '2017-06-18 18:55:20', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1345, 'cpignol', 'zaalpes-default', '2017-06-18 19:01:46', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1346, 'cpignol', 'zaalpes-containerFamilyList', '2017-06-18 19:16:25', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1347, 'cpignol', 'zaalpes-containerFamilyChange', '2017-06-18 19:16:29', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1348, 'cpignol', 'zaalpes-containerFamilyList', '2017-06-18 19:16:33', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1349, 'cpignol', 'zaalpes-default', '2017-06-18 19:16:33', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1350, 'cpignol', 'zaalpes-containerTypeList', '2017-06-18 19:16:41', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1351, 'cpignol', 'zaalpes-storageConditionList', '2017-06-18 19:24:49', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1352, 'cpignol', 'zaalpes-identifierTypeList-connexion', '2017-06-18 21:16:23', 'token-ok', '193.250.222.82');
INSERT INTO log VALUES (1353, 'cpignol', 'zaalpes-identifierTypeList', '2017-06-18 21:16:23', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1354, 'cpignol', 'zaalpes-identifierTypeChange', '2017-06-18 21:16:26', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1355, 'cpignol', 'zaalpes-operationList', '2017-06-18 21:20:38', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1356, 'cpignol', 'zaalpes-labelChange', '2017-06-18 21:24:59', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1357, 'cpignol', 'zaalpes-operationList', '2017-06-18 21:25:12', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1358, 'cpignol', 'zaalpes-labelList', '2017-06-18 21:25:19', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1359, 'cpignol', 'zaalpes-labelChange', '2017-06-18 21:25:30', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1360, 'cpignol', 'zaalpes-containerList', '2017-06-18 21:47:39', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1361, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-18 21:47:40', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1362, 'cpignol', 'zaalpes-containerChange', '2017-06-18 21:47:42', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1363, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-18 21:47:43', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1364, 'cpignol', 'zaalpes-containerList', '2017-06-18 21:47:44', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1365, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-18 21:47:45', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1366, 'cpignol', 'zaalpes-containerList', '2017-06-18 21:47:46', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1367, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-18 21:47:46', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1368, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-18 21:47:56', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1369, 'cpignol', 'zaalpes-containerList', '2017-06-18 21:47:57', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1370, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-18 21:47:58', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1371, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-18 21:48:02', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1372, 'cpignol', 'zaalpes-containerList', '2017-06-18 21:48:02', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1373, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-18 21:48:03', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1374, 'cpignol', 'zaalpes-containerList', '2017-06-18 21:48:25', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1375, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-18 21:48:26', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1376, 'cpignol', 'zaalpes-sampleList', '2017-06-18 22:15:03', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1377, 'cpignol', 'zaalpes-sampleList', '2017-06-18 22:15:05', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1378, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-18 22:15:10', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1379, 'cpignol', 'zaalpes-sampleChange', '2017-06-18 22:15:16', 'ok', '193.250.222.82');
INSERT INTO log VALUES (1380, 'unknown', 'zaalpes-sampleList', '2017-06-19 09:17:44', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (1381, 'cpignol', 'zaalpes-connexion', '2017-06-19 09:17:56', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1382, 'cpignol', 'zaalpes-sampleList', '2017-06-19 09:17:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1383, 'cpignol', 'zaalpes-sampleList', '2017-06-19 09:18:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1384, 'cpignol', 'zaalpes-sampleChange', '2017-06-19 09:19:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1385, 'cpignol', 'zaalpes-parametre', '2017-06-19 09:22:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1386, 'cpignol', 'zaalpes-parametre', '2017-06-19 09:22:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1387, 'cpignol', 'zaalpes-parametre', '2017-06-19 09:22:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1388, 'cpignol', 'zaalpes-samplingPlaceList', '2017-06-19 09:22:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1389, 'cpignol', 'zaalpes-samplingPlaceChange', '2017-06-19 09:23:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1390, 'cpignol', 'zaalpes-samplingPlaceWrite', '2017-06-19 09:25:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1391, 'cpignol', 'zaalpes-SamplingPlace-write', '2017-06-19 09:25:42', '1', '10.4.2.103');
INSERT INTO log VALUES (1392, 'cpignol', 'zaalpes-samplingPlaceList', '2017-06-19 09:25:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1393, 'cpignol', 'zaalpes-samplingPlaceChange', '2017-06-19 09:25:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1394, 'cpignol', 'zaalpes-samplingPlaceWrite', '2017-06-19 09:25:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1395, 'cpignol', 'zaalpes-SamplingPlace-write', '2017-06-19 09:25:59', '2', '10.4.2.103');
INSERT INTO log VALUES (1396, 'cpignol', 'zaalpes-samplingPlaceList', '2017-06-19 09:25:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1397, 'cpignol', 'zaalpes-samplingPlaceChange', '2017-06-19 09:33:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1398, 'cpignol', 'zaalpes-samplingPlaceList', '2017-06-19 09:34:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1399, 'cpignol', 'zaalpes-importChange', '2017-06-19 09:35:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1400, 'cpignol', 'zaalpes-sampleTypeList', '2017-06-19 09:42:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1401, 'cpignol', 'zaalpes-objectStatusList', '2017-06-19 09:42:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1402, 'cpignol', 'zaalpes-sampleTypeList', '2017-06-19 09:43:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1403, 'cpignol', 'zaalpes-projectList', '2017-06-19 09:43:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1404, 'cpignol', 'zaalpes-samplingPlaceList', '2017-06-19 09:44:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1405, 'cpignol', 'zaalpes-sampleList', '2017-06-19 09:49:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1406, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-19 09:50:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1407, 'cpignol', 'zaalpes-sampleChange', '2017-06-19 09:50:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1408, 'cpignol', 'zaalpes-sampleWrite', '2017-06-19 09:50:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1409, 'cpignol', 'zaalpes-Sample-write', '2017-06-19 09:50:41', '89', '10.4.2.103');
INSERT INTO log VALUES (1410, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-19 09:50:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1411, 'cpignol', 'zaalpes-importChange', '2017-06-19 10:02:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1412, 'cpignol', 'zaalpes-sampleList', '2017-06-19 10:03:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1413, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-19 10:03:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1414, 'cpignol', 'zaalpes-sampleChange', '2017-06-19 10:03:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1415, 'cpignol', 'zaalpes-sampleList', '2017-06-19 10:04:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1416, 'cpignol', 'zaalpes-containerList', '2017-06-19 10:04:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1417, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-19 10:04:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1418, 'cpignol', 'zaalpes-containerList', '2017-06-19 10:04:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1419, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-19 10:04:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1420, 'cpignol', 'zaalpes-containerDisplay', '2017-06-19 10:04:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1421, 'cpignol', 'zaalpes-containerChange', '2017-06-19 10:04:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1422, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-19 10:04:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1423, 'cpignol', 'zaalpes-containerList', '2017-06-19 10:05:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1424, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-19 10:05:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1425, 'cpignol', 'zaalpes-importChange', '2017-06-19 10:07:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1426, 'cpignol', 'zaalpes-containerList', '2017-06-19 10:14:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1427, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-19 10:14:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1428, 'cpignol', 'zaalpes-objectStatusList', '2017-06-19 10:16:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1429, 'cpignol', 'zaalpes-containerTypeList', '2017-06-19 10:16:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1430, 'cpignol', 'zaalpes-importChange', '2017-06-19 10:28:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1431, 'cpignol', 'zaalpes-importControl', '2017-06-19 10:28:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1432, 'cpignol', 'zaalpes-importChange', '2017-06-19 10:28:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1433, 'cpignol', 'zaalpes-importControl', '2017-06-19 10:28:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1434, 'cpignol', 'zaalpes-importChange', '2017-06-19 10:28:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1435, 'cpignol', 'zaalpes-importControl', '2017-06-19 10:31:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1436, 'cpignol', 'zaalpes-importChange', '2017-06-19 10:31:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1437, 'cpignol', 'zaalpes-importControl', '2017-06-19 10:32:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1438, 'cpignol', 'zaalpes-importChange', '2017-06-19 10:32:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1439, 'cpignol', 'zaalpes-importImport', '2017-06-19 10:32:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1440, 'cpignol', 'zaalpes-importChange', '2017-06-19 10:32:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1441, 'cpignol', 'zaalpes-objets', '2017-06-19 10:33:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1442, 'cpignol', 'zaalpes-sampleList', '2017-06-19 10:33:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1443, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-19 10:33:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1444, 'cpignol', 'zaalpes-containerDisplay', '2017-06-19 10:34:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1445, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-19 10:34:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1446, 'cpignol', 'zaalpes-containerList', '2017-06-19 10:34:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1447, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-19 10:34:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1448, 'cpignol', 'zaalpes-containerDisplay', '2017-06-19 10:35:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1449, 'cpignol', 'zaalpes-containerList', '2017-06-19 10:35:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1450, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-19 10:35:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1451, 'cpignol', 'zaalpes-containerDisplay', '2017-06-19 10:35:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1452, 'cpignol', 'zaalpes-containerList', '2017-06-19 10:36:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1453, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-19 10:36:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1454, 'cpignol', 'zaalpes-containerDisplay', '2017-06-19 10:36:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1455, 'cpignol', 'zaalpes-containerList', '2017-06-19 10:36:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1456, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-19 10:36:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1457, 'cpignol', 'zaalpes-containerDisplay', '2017-06-19 10:36:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1458, 'cpignol', 'zaalpes-containerList', '2017-06-19 10:36:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1459, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-19 10:36:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1460, 'cpignol', 'zaalpes-importChange', '2017-06-19 10:36:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1461, 'cpignol', 'zaalpes-containerList', '2017-06-19 10:42:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1462, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-19 10:42:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1463, 'cpignol', 'zaalpes-objets', '2017-06-19 10:58:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1464, 'cpignol', 'zaalpes-sampleList', '2017-06-19 10:58:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1465, 'cpignol', 'zaalpes-importChange', '2017-06-19 10:58:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1466, 'cpignol', 'zaalpes-importControl', '2017-06-19 10:58:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1467, 'cpignol', 'zaalpes-importChange', '2017-06-19 10:58:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1468, 'cpignol', 'zaalpes-containerList', '2017-06-19 10:59:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1469, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-19 10:59:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1470, 'cpignol', 'zaalpes-containerList', '2017-06-19 11:00:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1471, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-19 11:00:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1472, 'cpignol', 'zaalpes-importChange', '2017-06-19 11:00:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1473, 'cpignol', 'zaalpes-importControl', '2017-06-19 11:00:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1474, 'cpignol', 'zaalpes-importChange', '2017-06-19 11:00:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1475, 'cpignol', 'zaalpes-importImport', '2017-06-19 11:01:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1476, 'cpignol', 'zaalpes-importChange', '2017-06-19 11:01:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1477, 'cpignol', 'zaalpes-sampleList', '2017-06-19 11:01:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1478, 'cpignol', 'zaalpes-sampleList-connexion', '2017-06-19 12:23:45', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (1479, 'cpignol', 'zaalpes-sampleList', '2017-06-19 12:23:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1480, 'cpignol', 'zaalpes-sampleList', '2017-06-19 12:26:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1481, 'cpignol', 'zaalpes-sampleList', '2017-06-19 12:27:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1482, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-19 12:27:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1483, 'cpignol', 'zaalpes-sampleChange', '2017-06-19 12:27:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1484, 'cpignol', 'zaalpes-sampleWrite', '2017-06-19 12:30:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1485, 'cpignol', 'zaalpes-Sample-write', '2017-06-19 12:30:07', '90', '10.4.2.103');
INSERT INTO log VALUES (1486, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-19 12:30:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1487, 'cpignol', 'zaalpes-sampleList', '2017-06-19 12:30:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1488, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-19 12:30:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1489, 'cpignol', 'zaalpes-sampleChange', '2017-06-19 12:30:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1490, 'cpignol', 'zaalpes-sampleWrite', '2017-06-19 12:32:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1491, 'cpignol', 'zaalpes-Sample-write', '2017-06-19 12:32:48', '92', '10.4.2.103');
INSERT INTO log VALUES (1492, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-19 12:32:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1493, 'cpignol', 'zaalpes-sampleList', '2017-06-19 12:32:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1494, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-19 12:33:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1495, 'cpignol', 'zaalpes-labelList-connexion', '2017-06-19 13:17:11', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (1496, 'cpignol', 'zaalpes-labelList', '2017-06-19 13:17:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1497, 'cpignol', 'zaalpes-labelChange', '2017-06-19 13:17:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1498, 'cpignol', 'zaalpes-labelWrite', '2017-06-19 13:29:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1499, 'cpignol', 'zaalpes-Label-write', '2017-06-19 13:29:48', '5', '10.4.2.103');
INSERT INTO log VALUES (1500, 'cpignol', 'zaalpes-labelList', '2017-06-19 13:29:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1501, 'cpignol', 'zaalpes-containerList', '2017-06-19 13:29:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1502, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-19 13:29:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1503, 'cpignol', 'zaalpes-sampleList', '2017-06-19 13:29:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1504, 'cpignol', 'zaalpes-sampleList', '2017-06-19 13:30:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1505, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-19 13:30:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1506, 'cpignol', 'zaalpes-parametre', '2017-06-19 13:31:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1507, 'cpignol', 'zaalpes-labelList', '2017-06-19 13:31:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1508, 'cpignol', 'zaalpes-labelChange', '2017-06-19 13:31:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1509, 'cpignol', 'zaalpes-labelWrite', '2017-06-19 13:31:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1510, 'cpignol', 'zaalpes-Label-write', '2017-06-19 13:31:30', '5', '10.4.2.103');
INSERT INTO log VALUES (1511, 'cpignol', 'zaalpes-labelList', '2017-06-19 13:31:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1512, 'cpignol', 'zaalpes-default', '2017-06-19 13:31:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1513, 'cpignol', 'zaalpes-sampleList', '2017-06-19 13:31:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1514, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-19 13:31:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1515, 'cpignol', 'zaalpes-sampleList', '2017-06-19 13:32:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1516, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-19 13:32:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1517, 'cpignol', 'zaalpes-labelChange', '2017-06-19 13:35:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1518, 'cpignol', 'zaalpes-labelWrite', '2017-06-19 13:41:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1519, 'cpignol', 'zaalpes-Label-write', '2017-06-19 13:41:05', '5', '10.4.2.103');
INSERT INTO log VALUES (1520, 'cpignol', 'zaalpes-labelList', '2017-06-19 13:41:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1521, 'cpignol', 'zaalpes-sampleList', '2017-06-19 13:41:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1522, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-19 13:41:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1523, 'cpignol', 'zaalpes-labelChange', '2017-06-19 13:47:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1524, 'cpignol', 'zaalpes-labelWrite', '2017-06-19 13:48:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1525, 'cpignol', 'zaalpes-Label-write', '2017-06-19 13:48:22', '5', '10.4.2.103');
INSERT INTO log VALUES (1526, 'cpignol', 'zaalpes-labelList', '2017-06-19 13:48:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1527, 'cpignol', 'zaalpes-sampleList', '2017-06-19 13:48:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1528, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-19 13:48:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1529, 'cpignol', 'zaalpes-labelChange', '2017-06-19 13:49:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1530, 'cpignol', 'zaalpes-labelWrite-connexion', '2017-06-19 17:50:14', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (1531, 'cpignol', 'zaalpes-labelWrite', '2017-06-19 17:50:14', 'errorbefore', '10.4.2.103');
INSERT INTO log VALUES (1532, 'cpignol', 'zaalpes-errorbefore', '2017-06-19 17:50:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1533, 'cpignol', 'zaalpes-labelList', '2017-06-19 17:50:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1534, 'cpignol', 'zaalpes-labelChange', '2017-06-19 17:50:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1535, 'cpignol', 'zaalpes-labelWrite', '2017-06-19 17:52:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1536, 'cpignol', 'zaalpes-Label-write', '2017-06-19 17:52:32', '5', '10.4.2.103');
INSERT INTO log VALUES (1537, 'cpignol', 'zaalpes-labelList', '2017-06-19 17:52:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1538, 'cpignol', 'zaalpes-sampleList', '2017-06-19 17:52:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1539, 'cpignol', 'zaalpes-sampleList', '2017-06-19 17:52:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1540, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-19 17:53:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1541, 'cpignol', 'zaalpes-labelChange', '2017-06-19 17:53:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1542, 'cpignol', 'zaalpes-labelWrite', '2017-06-19 17:54:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1543, 'cpignol', 'zaalpes-Label-write', '2017-06-19 17:54:13', '5', '10.4.2.103');
INSERT INTO log VALUES (1544, 'cpignol', 'zaalpes-labelList', '2017-06-19 17:54:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1545, 'cpignol', 'zaalpes-sampleList', '2017-06-19 17:54:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1546, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-19 17:54:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1547, 'cpignol', 'zaalpes-sampleList', '2017-06-19 17:54:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1548, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-19 17:54:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1549, 'cpignol', 'zaalpes-labelChange', '2017-06-19 17:57:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1550, 'cpignol', 'zaalpes-labelWrite', '2017-06-19 17:57:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1551, 'cpignol', 'zaalpes-Label-write', '2017-06-19 17:57:58', '5', '10.4.2.103');
INSERT INTO log VALUES (1552, 'cpignol', 'zaalpes-labelList', '2017-06-19 17:57:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1553, 'cpignol', 'zaalpes-sampleList', '2017-06-19 17:58:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1554, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-19 17:58:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1555, 'cpignol', 'zaalpes-labelChange', '2017-06-19 17:58:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1556, 'cpignol', 'zaalpes-labelWrite', '2017-06-19 17:59:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1557, 'cpignol', 'zaalpes-Label-write', '2017-06-19 17:59:07', '5', '10.4.2.103');
INSERT INTO log VALUES (1558, 'cpignol', 'zaalpes-labelList', '2017-06-19 17:59:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1559, 'cpignol', 'zaalpes-sampleList', '2017-06-19 17:59:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1560, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-19 17:59:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1561, 'cpignol', 'zaalpes-labelChange', '2017-06-19 17:59:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1562, 'cpignol', 'zaalpes-labelWrite', '2017-06-19 18:00:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1563, 'cpignol', 'zaalpes-Label-write', '2017-06-19 18:00:54', '5', '10.4.2.103');
INSERT INTO log VALUES (1564, 'cpignol', 'zaalpes-labelList', '2017-06-19 18:00:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1565, 'cpignol', 'zaalpes-sampleList', '2017-06-19 18:01:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1566, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-19 18:01:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1567, 'unknown', 'zaalpes-default', '2017-06-20 10:07:47', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1568, 'unknown', 'zaalpes-default', '2017-06-20 10:08:12', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1569, 'unknown', 'zaalpes-loginChangePassword', '2017-06-20 10:18:14', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1570, 'cpignol', 'zaalpes-connexion', '2017-06-20 10:18:42', 'db-ok', '193.48.126.37');
INSERT INTO log VALUES (1571, 'cpignol', 'zaalpes-default', '2017-06-20 10:18:42', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1572, 'cpignol', 'zaalpes-containerList', '2017-06-20 10:19:59', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1573, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 10:20:00', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1574, 'cpignol', 'zaalpes-containerFamilyList', '2017-06-20 10:20:19', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1575, 'cpignol', 'zaalpes-containerFamilyChange', '2017-06-20 10:20:27', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1576, 'cpignol', 'zaalpes-containerFamilyList', '2017-06-20 10:20:30', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1577, 'cpignol', 'zaalpes-loginList', '2017-06-20 10:21:00', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1578, 'cpignol', 'zaalpes-loginChange', '2017-06-20 10:21:18', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1579, 'cpignol', 'zaalpes-loginList', '2017-06-20 10:22:03', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1580, 'cpignol', 'zaalpes-loginChange', '2017-06-20 10:22:59', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1581, 'cpignol', 'zaalpes-loginList', '2017-06-20 10:23:05', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1582, 'cpignol', 'zaalpes-appliList', '2017-06-20 10:23:08', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1583, 'cpignol', 'zaalpes-appliDisplay', '2017-06-20 10:23:20', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1584, 'cpignol', 'zaalpes-administration', '2017-06-20 10:23:28', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1585, 'cpignol', 'zaalpes-administration', '2017-06-20 10:23:31', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1586, 'cpignol', 'zaalpes-administration', '2017-06-20 10:23:33', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1587, 'cpignol', 'zaalpes-administration', '2017-06-20 10:23:35', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1588, 'cpignol', 'zaalpes-groupList', '2017-06-20 10:23:40', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1589, 'cpignol', 'zaalpes-administration', '2017-06-20 10:24:41', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1590, 'cpignol', 'zaalpes-groupList', '2017-06-20 10:24:46', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1591, 'cpignol', 'zaalpes-groupChange', '2017-06-20 10:24:50', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1592, 'cpignol', 'zaalpes-groupList', '2017-06-20 10:25:05', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1593, 'cpignol', 'zaalpes-groupChange', '2017-06-20 10:25:08', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1594, 'cpignol', 'zaalpes-groupList', '2017-06-20 10:25:12', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1595, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:26:04', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1596, 'cpignol', 'zaalpes-projectList', '2017-06-20 10:27:00', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1597, 'cpignol', 'zaalpes-projectChange', '2017-06-20 10:28:04', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1598, 'cpignol', 'zaalpes-projectList', '2017-06-20 10:28:59', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1599, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:29:04', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1600, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:29:08', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1601, 'cpignol', 'zaalpes-administration', '2017-06-20 10:31:03', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1602, 'cpignol', 'zaalpes-administration', '2017-06-20 10:31:05', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1603, 'cpignol', 'zaalpes-administration', '2017-06-20 10:31:07', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1604, 'cpignol', 'zaalpes-administration', '2017-06-20 10:31:09', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1605, 'cpignol', 'zaalpes-administration', '2017-06-20 10:31:11', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1606, 'cpignol', 'zaalpes-groupList', '2017-06-20 10:31:38', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1607, 'cpignol', 'zaalpes-containerFamilyList', '2017-06-20 10:33:09', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1608, 'cpignol', 'zaalpes-containerFamilyChange', '2017-06-20 10:33:23', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1609, 'cpignol', 'zaalpes-containerFamilyList', '2017-06-20 10:33:31', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1610, 'cpignol', 'zaalpes-groupList', '2017-06-20 10:34:01', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1611, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:34:05', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1612, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:34:07', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1613, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:34:09', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1614, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:34:11', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1615, 'cpignol', 'zaalpes-storageConditionList', '2017-06-20 10:34:30', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1616, 'cpignol', 'zaalpes-storageConditionChange', '2017-06-20 10:34:55', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1617, 'cpignol', 'zaalpes-storageConditionList', '2017-06-20 10:35:01', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1618, 'cpignol', 'zaalpes-containerTypeList', '2017-06-20 10:35:35', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1619, 'cpignol', 'zaalpes-containerTypeChange', '2017-06-20 10:36:15', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1620, 'cpignol', 'zaalpes-containerTypeList', '2017-06-20 10:36:56', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1621, 'cpignol', 'zaalpes-containerTypeChange', '2017-06-20 10:37:29', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1622, 'cpignol', 'zaalpes-containerTypeList', '2017-06-20 10:37:33', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1623, 'cpignol', 'zaalpes-sampleTypeList', '2017-06-20 10:38:38', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1624, 'cpignol', 'zaalpes-protocolList', '2017-06-20 10:39:46', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1625, 'cpignol', 'zaalpes-protocolChange', '2017-06-20 10:39:55', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1626, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:41:54', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1627, 'cpignol', 'zaalpes-operationList', '2017-06-20 10:42:03', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1628, 'cpignol', 'zaalpes-operationChange', '2017-06-20 10:42:38', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1629, 'cpignol', 'zaalpes-samplingPlaceList', '2017-06-20 10:45:20', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1630, 'cpignol', 'zaalpes-identifierTypeList', '2017-06-20 10:45:52', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1631, 'cpignol', 'zaalpes-samplingPlaceList', '2017-06-20 10:45:58', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1632, 'cpignol', 'zaalpes-samplingPlaceList', '2017-06-20 10:46:08', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1633, 'cpignol', 'zaalpes-samplingPlaceChange', '2017-06-20 10:46:11', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1634, 'cpignol', 'zaalpes-sampleTypeList', '2017-06-20 10:49:29', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1635, 'cpignol', 'zaalpes-sampleTypeChange', '2017-06-20 10:49:33', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1636, 'cpignol', 'zaalpes-objectStatusList', '2017-06-20 10:50:46', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1637, 'cpignol', 'zaalpes-objectStatusChange', '2017-06-20 10:51:48', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1638, 'cpignol', 'zaalpes-objectStatusList', '2017-06-20 10:51:53', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1639, 'cpignol', 'zaalpes-objectStatusChange', '2017-06-20 10:52:09', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1640, 'cpignol', 'zaalpes-objectStatusList', '2017-06-20 10:52:14', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1641, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:52:38', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1642, 'cpignol', 'zaalpes-labelList', '2017-06-20 10:52:42', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1643, 'cpignol', 'zaalpes-labelChange', '2017-06-20 10:52:57', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1644, 'cpignol', 'zaalpes-labelList', '2017-06-20 10:54:06', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1645, 'cpignol', 'zaalpes-labelChange', '2017-06-20 10:54:09', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1646, 'cpignol', 'zaalpes-labelList', '2017-06-20 10:54:21', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1647, 'cpignol', 'zaalpes-labelChange', '2017-06-20 10:54:24', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1648, 'cpignol', 'zaalpes-labelList', '2017-06-20 10:54:29', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1649, 'cpignol', 'zaalpes-labelChange', '2017-06-20 10:54:38', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1650, 'cpignol', 'zaalpes-labelList', '2017-06-20 10:54:41', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1651, 'cpignol', 'zaalpes-administration', '2017-06-20 10:54:45', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1652, 'cpignol', 'zaalpes-multipleTypeList', '2017-06-20 10:54:50', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1653, 'cpignol', 'zaalpes-multipleTypeChange', '2017-06-20 10:55:50', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1654, 'cpignol', 'zaalpes-multipleTypeList', '2017-06-20 10:55:53', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1655, 'cpignol', 'zaalpes-administration', '2017-06-20 10:55:57', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1656, 'cpignol', 'zaalpes-identifierTypeList', '2017-06-20 10:56:02', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1657, 'cpignol', 'zaalpes-identifierTypeChange', '2017-06-20 10:56:06', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1658, 'cpignol', 'zaalpes-identifierTypeList', '2017-06-20 10:56:10', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1659, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:56:12', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1660, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:56:14', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1661, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:56:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1662, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:56:19', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1663, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:56:22', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1664, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:56:24', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1665, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:56:26', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1666, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:56:38', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1667, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:56:54', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1668, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:56:58', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1669, 'cpignol', 'zaalpes-labelList', '2017-06-20 10:57:26', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1670, 'cpignol', 'zaalpes-parametre', '2017-06-20 10:57:43', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1671, 'cpignol', 'zaalpes-containerList', '2017-06-20 10:58:25', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1672, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 10:58:26', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1673, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 10:58:33', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1674, 'cpignol', 'zaalpes-containerList', '2017-06-20 10:58:37', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1675, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 10:58:39', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1676, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:00:09', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1677, 'cpignol', 'zaalpes-containerChange', '2017-06-20 11:22:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1678, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:22:20', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1679, 'cpignol', 'zaalpes-containerWrite', '2017-06-20 11:22:58', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1680, 'cpignol', 'zaalpes-Container-write', '2017-06-20 11:22:58', '2', '193.48.126.37');
INSERT INTO log VALUES (1681, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:22:58', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1682, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:23:45', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1683, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:23:46', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1684, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:23:49', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1685, 'cpignol', 'zaalpes-containerChange', '2017-06-20 11:23:54', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1686, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:23:56', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1687, 'cpignol', 'zaalpes-containerWrite', '2017-06-20 11:24:11', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1688, 'cpignol', 'zaalpes-Container-write', '2017-06-20 11:24:11', '5', '193.48.126.37');
INSERT INTO log VALUES (1689, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:24:11', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1690, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:24:29', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1691, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:24:30', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1692, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:24:36', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1693, 'cpignol', 'zaalpes-containerChange', '2017-06-20 11:27:49', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1694, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:27:51', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1695, 'cpignol', 'zaalpes-containerWrite', '2017-06-20 11:28:07', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1696, 'cpignol', 'zaalpes-Container-write', '2017-06-20 11:28:07', '3', '193.48.126.37');
INSERT INTO log VALUES (1697, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:28:07', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1698, 'cpignol', 'zaalpes-containerChange', '2017-06-20 11:28:46', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1699, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:28:48', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1700, 'cpignol', 'zaalpes-containerWrite', '2017-06-20 11:29:01', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1701, 'cpignol', 'zaalpes-Container-write', '2017-06-20 11:29:01', '3', '193.48.126.37');
INSERT INTO log VALUES (1702, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:29:01', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1703, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:29:04', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1704, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:29:05', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1705, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:29:11', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1706, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:29:19', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1707, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:29:21', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1708, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:29:23', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1709, 'cpignol', 'zaalpes-containerChange', '2017-06-20 11:29:26', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1710, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:29:28', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1711, 'cpignol', 'zaalpes-containerWrite', '2017-06-20 11:29:40', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1712, 'cpignol', 'zaalpes-Container-write', '2017-06-20 11:29:40', '4', '193.48.126.37');
INSERT INTO log VALUES (1713, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:29:40', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1714, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:29:44', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1715, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:29:46', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1716, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:29:48', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1717, 'cpignol', 'zaalpes-containerChange', '2017-06-20 11:29:51', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1718, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:29:54', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1719, 'cpignol', 'zaalpes-containerWrite', '2017-06-20 11:30:10', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1720, 'cpignol', 'zaalpes-Container-write', '2017-06-20 11:30:10', '3', '193.48.126.37');
INSERT INTO log VALUES (1721, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:30:10', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1722, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:30:22', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1723, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:30:24', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1724, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:30:26', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1725, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:31:00', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1726, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:31:01', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1727, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:31:04', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1728, 'cpignol', 'zaalpes-containerChange', '2017-06-20 11:31:16', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1729, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:31:18', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1730, 'cpignol', 'zaalpes-containerWrite', '2017-06-20 11:31:31', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1731, 'cpignol', 'zaalpes-Container-write', '2017-06-20 11:31:31', '6', '193.48.126.37');
INSERT INTO log VALUES (1732, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:31:31', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1733, 'cpignol', 'zaalpes-containerChange', '2017-06-20 11:31:47', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1734, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:31:49', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1735, 'cpignol', 'zaalpes-containerWrite', '2017-06-20 11:32:00', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1736, 'cpignol', 'zaalpes-Container-write', '2017-06-20 11:32:00', '6', '193.48.126.37');
INSERT INTO log VALUES (1737, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:32:00', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1738, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:32:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1739, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:32:18', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1740, 'cpignol', 'zaalpes-containerTypeList', '2017-06-20 11:32:36', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1741, 'cpignol', 'zaalpes-parametre', '2017-06-20 11:32:42', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1742, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:32:45', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1743, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:32:46', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1744, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:32:51', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1745, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:32:54', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1746, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:32:56', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1747, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:32:57', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1748, 'cpignol', 'zaalpes-sampleList', '2017-06-20 11:35:20', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1749, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:35:49', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1750, 'cpignol', 'zaalpes-objets', '2017-06-20 11:35:55', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1751, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:36:00', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1752, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:36:02', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1753, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:36:10', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1754, 'cpignol', 'zaalpes-containerChange', '2017-06-20 11:36:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1755, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:36:19', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1756, 'cpignol', 'zaalpes-containerWrite', '2017-06-20 11:38:01', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1757, 'cpignol', 'zaalpes-Container-write', '2017-06-20 11:38:01', '88', '193.48.126.37');
INSERT INTO log VALUES (1758, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:38:01', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1759, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:38:34', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1760, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:38:36', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1761, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:38:39', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1762, 'cpignol', 'zaalpes-containerChange', '2017-06-20 11:38:47', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1763, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:38:50', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1764, 'cpignol', 'zaalpes-containerWrite', '2017-06-20 11:39:19', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1765, 'cpignol', 'zaalpes-Container-write', '2017-06-20 11:39:19', '2', '193.48.126.37');
INSERT INTO log VALUES (1766, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:39:19', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1767, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:39:23', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1768, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:39:25', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1769, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:39:26', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1770, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:40:08', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1771, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:40:09', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1772, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:40:11', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1773, 'cpignol', 'zaalpes-containerChange', '2017-06-20 11:40:21', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1774, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:40:23', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1775, 'cpignol', 'zaalpes-containerWrite', '2017-06-20 11:40:55', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1776, 'cpignol', 'zaalpes-Container-write', '2017-06-20 11:40:55', '5', '193.48.126.37');
INSERT INTO log VALUES (1777, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:40:55', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1778, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:41:23', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1779, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:41:25', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1780, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:41:26', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1781, 'cpignol', 'zaalpes-containerChange', '2017-06-20 11:41:29', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1782, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:41:31', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1783, 'cpignol', 'zaalpes-containerWrite', '2017-06-20 11:42:31', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1784, 'cpignol', 'zaalpes-Container-write', '2017-06-20 11:42:31', '3', '193.48.126.37');
INSERT INTO log VALUES (1785, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:42:31', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1786, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:42:34', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1787, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:42:36', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1788, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:42:45', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1789, 'cpignol', 'zaalpes-containerChange', '2017-06-20 11:42:49', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1790, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:42:51', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1791, 'cpignol', 'zaalpes-containerWrite', '2017-06-20 11:43:14', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1792, 'cpignol', 'zaalpes-Container-write', '2017-06-20 11:43:14', '4', '193.48.126.37');
INSERT INTO log VALUES (1793, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:43:14', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1794, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:43:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1795, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:43:18', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1796, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:43:20', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1797, 'cpignol', 'zaalpes-containerChange', '2017-06-20 11:43:22', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1798, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:43:25', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1799, 'cpignol', 'zaalpes-containerWrite', '2017-06-20 11:43:42', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1800, 'cpignol', 'zaalpes-Container-write', '2017-06-20 11:43:42', '6', '193.48.126.37');
INSERT INTO log VALUES (1801, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:43:42', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1802, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:43:46', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1803, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:43:47', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1804, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:43:49', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1805, 'cpignol', 'zaalpes-containerChange', '2017-06-20 11:43:54', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1806, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:43:56', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1807, 'cpignol', 'zaalpes-containerWrite', '2017-06-20 11:44:21', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1808, 'cpignol', 'zaalpes-Container-write', '2017-06-20 11:44:21', '7', '193.48.126.37');
INSERT INTO log VALUES (1809, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 11:44:21', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1810, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:44:24', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1811, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:44:26', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1812, 'cpignol', 'zaalpes-objets', '2017-06-20 11:45:18', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1813, 'cpignol', 'zaalpes-containerList', '2017-06-20 11:45:22', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1814, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 11:45:23', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1815, 'cpignol', 'zaalpes-objets', '2017-06-20 11:45:32', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1816, 'cpignol', 'zaalpes-sampleList', '2017-06-20 11:45:40', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1817, 'cpignol', 'zaalpes-sampleList', '2017-06-20 11:45:54', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1818, 'unknown', 'zaalpes-labelList', '2017-06-20 13:06:40', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (1819, 'admin', 'zaalpes-connexion', '2017-06-20 13:06:43', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1820, 'admin', 'zaalpes-labelList', '2017-06-20 13:06:43', 'droitko', '10.4.2.103');
INSERT INTO log VALUES (1821, 'admin', 'zaalpes-droitko', '2017-06-20 13:06:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1822, 'admin', 'zaalpes-disconnect', '2017-06-20 13:06:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1823, 'unknown', 'zaalpes-connexion', '2017-06-20 13:06:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1824, 'cpignol', 'zaalpes-connexion', '2017-06-20 13:07:18', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1825, 'cpignol', 'zaalpes-default', '2017-06-20 13:07:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1826, 'cpignol', 'zaalpes-appliList', '2017-06-20 13:07:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1827, 'cpignol', 'zaalpes-appliDisplay', '2017-06-20 13:07:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1828, 'cpignol', 'zaalpes-acoChange', '2017-06-20 13:07:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1829, 'cpignol', 'zaalpes-acoWrite', '2017-06-20 13:07:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1830, 'cpignol', 'zaalpes-Aclaco-write', '2017-06-20 13:07:43', '11', '10.4.2.103');
INSERT INTO log VALUES (1831, 'cpignol', 'zaalpes-appliDisplay', '2017-06-20 13:07:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1832, 'cpignol', 'zaalpes-labelList', '2017-06-20 13:07:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1833, 'cpignol', 'zaalpes-labelChange', '2017-06-20 13:08:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1834, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 13:12:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1835, 'cpignol', 'zaalpes-Label-write', '2017-06-20 13:12:47', '6', '10.4.2.103');
INSERT INTO log VALUES (1836, 'cpignol', 'zaalpes-labelList', '2017-06-20 13:12:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1837, 'cpignol', 'zaalpes-sampleList', '2017-06-20 13:12:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1838, 'cpignol', 'zaalpes-sampleList', '2017-06-20 13:13:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1839, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 13:13:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1840, 'cpignol', 'zaalpes-labelList', '2017-06-20 13:13:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1841, 'cpignol', 'zaalpes-labelChange', '2017-06-20 13:13:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1842, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 13:14:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1843, 'cpignol', 'zaalpes-Label-write', '2017-06-20 13:14:33', '6', '10.4.2.103');
INSERT INTO log VALUES (1844, 'cpignol', 'zaalpes-labelList', '2017-06-20 13:14:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1845, 'cpignol', 'zaalpes-sampleList', '2017-06-20 13:14:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1846, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 13:14:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1847, 'cpignol', 'zaalpes-labelChange', '2017-06-20 13:16:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1848, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 13:18:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1849, 'cpignol', 'zaalpes-Label-write', '2017-06-20 13:18:49', '6', '10.4.2.103');
INSERT INTO log VALUES (1850, 'cpignol', 'zaalpes-labelList', '2017-06-20 13:18:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1851, 'cpignol', 'zaalpes-sampleList', '2017-06-20 13:18:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1852, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 13:19:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1853, 'cpignol', 'zaalpes-labelChange', '2017-06-20 13:21:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1854, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 13:23:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1855, 'cpignol', 'zaalpes-Label-write', '2017-06-20 13:23:33', '6', '10.4.2.103');
INSERT INTO log VALUES (1856, 'cpignol', 'zaalpes-labelList', '2017-06-20 13:23:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1857, 'cpignol', 'zaalpes-sampleList', '2017-06-20 13:23:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1858, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 13:23:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1859, 'cpignol', 'zaalpes-labelChange', '2017-06-20 13:24:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1860, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 13:24:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1861, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 13:25:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1862, 'cpignol', 'zaalpes-Label-write', '2017-06-20 13:25:30', '6', '10.4.2.103');
INSERT INTO log VALUES (1863, 'cpignol', 'zaalpes-labelList', '2017-06-20 13:25:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1864, 'cpignol', 'zaalpes-sampleList', '2017-06-20 13:25:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1865, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 13:25:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1866, 'cpignol', 'zaalpes-labelChange', '2017-06-20 13:26:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1867, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 13:26:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1868, 'cpignol', 'zaalpes-Label-write', '2017-06-20 13:26:29', '6', '10.4.2.103');
INSERT INTO log VALUES (1869, 'cpignol', 'zaalpes-labelList', '2017-06-20 13:26:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1870, 'cpignol', 'zaalpes-sampleList', '2017-06-20 13:26:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1871, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 13:26:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1872, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 13:26:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1873, 'cpignol', 'zaalpes-labelChange', '2017-06-20 13:27:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1874, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 13:28:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1875, 'cpignol', 'zaalpes-Label-write', '2017-06-20 13:28:02', '6', '10.4.2.103');
INSERT INTO log VALUES (1876, 'cpignol', 'zaalpes-labelList', '2017-06-20 13:28:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1877, 'cpignol', 'zaalpes-sampleList', '2017-06-20 13:28:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1878, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 13:28:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1879, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 13:28:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1880, 'unknown', 'zaalpes-sampleDisplay', '2017-06-20 14:17:12', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (1881, 'admin', 'zaalpes-connexion', '2017-06-20 14:17:15', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1882, 'admin', 'zaalpes-sampleDisplay', '2017-06-20 14:17:15', 'droitko', '10.4.2.103');
INSERT INTO log VALUES (1883, 'admin', 'zaalpes-droitko', '2017-06-20 14:17:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1884, 'admin', 'zaalpes-disconnect', '2017-06-20 14:17:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1885, 'unknown', 'zaalpes-connexion', '2017-06-20 14:17:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1886, 'cpignol', 'zaalpes-connexion', '2017-06-20 14:17:41', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1887, 'cpignol', 'zaalpes-default', '2017-06-20 14:17:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1888, 'cpignol', 'zaalpes-containerList', '2017-06-20 14:17:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1889, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 14:17:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1890, 'cpignol', 'zaalpes-containerList', '2017-06-20 14:17:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1891, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 14:17:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1892, 'cpignol', 'zaalpes-sampleList', '2017-06-20 14:18:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1893, 'cpignol', 'zaalpes-sampleList', '2017-06-20 14:18:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1894, 'cpignol', 'zaalpes-sampleDisplay-connexion', '2017-06-20 14:19:04', 'token-ok', '193.48.126.37');
INSERT INTO log VALUES (1895, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-20 14:19:04', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1896, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-20 14:20:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1897, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 14:21:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1898, 'cpignol', 'zaalpes-containerList', '2017-06-20 14:22:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1899, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 14:22:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1900, 'cpignol', 'zaalpes-sampleList', '2017-06-20 14:22:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1901, 'cpignol', 'zaalpes-containerList', '2017-06-20 14:23:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1902, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 14:23:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1903, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 14:23:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1904, 'cpignol', 'zaalpes-sampleList', '2017-06-20 14:24:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1905, 'cpignol', 'zaalpes-sampleChange', '2017-06-20 14:24:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1906, 'cpignol', 'zaalpes-metadataFormGetDetail', '2017-06-20 14:25:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1907, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 14:26:31', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1908, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-20 14:26:36', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1909, 'cpignol', 'zaalpes-containerDisplay', '2017-06-20 14:26:40', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1910, 'cpignol', 'zaalpes-sampleList', '2017-06-20 14:26:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1911, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-20 14:26:49', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1912, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 14:27:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1913, 'cpignol', 'zaalpes-labelChange', '2017-06-20 14:30:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1914, 'cpignol', 'zaalpes-storagesampleOutput', '2017-06-20 14:30:24', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1915, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-20 14:31:10', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1916, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 14:31:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1917, 'cpignol', 'zaalpes-Label-write', '2017-06-20 14:31:12', '6', '10.4.2.103');
INSERT INTO log VALUES (1918, 'cpignol', 'zaalpes-labelList', '2017-06-20 14:31:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1919, 'cpignol', 'zaalpes-storagesampleInput', '2017-06-20 14:31:16', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1920, 'cpignol', 'zaalpes-containerGetFromUid', '2017-06-20 14:31:20', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1921, 'cpignol', 'zaalpes-labelChange', '2017-06-20 14:31:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1922, 'cpignol', 'zaalpes-containerGetFromUid', '2017-06-20 14:31:21', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1923, 'cpignol', 'zaalpes-containerGetFromUid', '2017-06-20 14:31:22', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1924, 'cpignol', 'zaalpes-containerGetFromUid', '2017-06-20 14:31:22', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1925, 'cpignol', 'zaalpes-containerGetFromUid', '2017-06-20 14:31:23', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1926, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 14:31:29', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1927, 'cpignol', 'zaalpes-containerGetFromType', '2017-06-20 14:31:30', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1928, 'cpignol', 'zaalpes-containerGetFromType', '2017-06-20 14:31:40', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1929, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-20 14:31:45', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1930, 'cpignol', 'zaalpes-containerGetFromType', '2017-06-20 14:31:49', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1931, 'cpignol', 'zaalpes-containerGetFromType', '2017-06-20 14:32:01', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1932, 'cpignol', 'zaalpes-containerGetFromType', '2017-06-20 14:32:04', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1933, 'cpignol', 'zaalpes-containerGetFromType', '2017-06-20 14:32:08', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1934, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-20 14:32:43', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1935, 'cpignol', 'zaalpes-subsampleChange', '2017-06-20 14:34:16', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1936, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-20 14:34:36', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1937, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 14:36:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1938, 'cpignol', 'zaalpes-Label-write', '2017-06-20 14:36:55', '7', '10.4.2.103');
INSERT INTO log VALUES (1939, 'cpignol', 'zaalpes-labelList', '2017-06-20 14:36:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1940, 'cpignol', 'zaalpes-sampleList', '2017-06-20 14:37:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1941, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-20 14:37:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1942, 'cpignol', 'zaalpes-sampleList', '2017-06-20 14:37:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1943, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 14:37:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1944, 'cpignol', 'zaalpes-labelChange', '2017-06-20 14:38:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1945, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 14:38:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1946, 'cpignol', 'zaalpes-Label-write', '2017-06-20 14:38:52', '7', '10.4.2.103');
INSERT INTO log VALUES (1947, 'cpignol', 'zaalpes-labelList', '2017-06-20 14:38:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1948, 'cpignol', 'zaalpes-sampleList', '2017-06-20 14:39:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1949, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 14:39:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1950, 'cpignol', 'zaalpes-labelChange', '2017-06-20 14:41:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1951, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 14:42:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1952, 'cpignol', 'zaalpes-Label-write', '2017-06-20 14:42:09', '7', '10.4.2.103');
INSERT INTO log VALUES (1953, 'cpignol', 'zaalpes-labelList', '2017-06-20 14:42:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1954, 'cpignol', 'zaalpes-sampleList', '2017-06-20 14:42:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1955, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 14:42:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1956, 'cpignol', 'zaalpes-labelChange', '2017-06-20 14:44:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1957, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 14:49:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1958, 'cpignol', 'zaalpes-Label-write', '2017-06-20 14:49:50', '7', '10.4.2.103');
INSERT INTO log VALUES (1959, 'cpignol', 'zaalpes-labelList', '2017-06-20 14:49:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1960, 'cpignol', 'zaalpes-sampleList', '2017-06-20 14:49:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1961, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 14:50:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1962, 'cpignol', 'zaalpes-labelChange', '2017-06-20 14:50:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1963, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 14:51:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1964, 'cpignol', 'zaalpes-Label-write', '2017-06-20 14:51:09', '7', '10.4.2.103');
INSERT INTO log VALUES (1965, 'cpignol', 'zaalpes-labelList', '2017-06-20 14:51:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1966, 'cpignol', 'zaalpes-labelChange', '2017-06-20 14:51:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1967, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 14:52:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1968, 'cpignol', 'zaalpes-Label-write', '2017-06-20 14:52:00', '7', '10.4.2.103');
INSERT INTO log VALUES (1969, 'cpignol', 'zaalpes-labelList', '2017-06-20 14:52:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1970, 'cpignol', 'zaalpes-sampleList', '2017-06-20 14:52:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1971, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 14:52:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1972, 'cpignol', 'zaalpes-labelChange', '2017-06-20 14:52:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1973, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 14:56:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1974, 'cpignol', 'zaalpes-Label-write', '2017-06-20 14:56:58', '7', '10.4.2.103');
INSERT INTO log VALUES (1975, 'cpignol', 'zaalpes-labelList', '2017-06-20 14:56:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1976, 'cpignol', 'zaalpes-sampleList', '2017-06-20 14:57:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1977, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 14:57:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1978, 'cpignol', 'zaalpes-labelChange', '2017-06-20 14:57:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1979, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 14:58:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1980, 'cpignol', 'zaalpes-Label-write', '2017-06-20 14:58:39', '7', '10.4.2.103');
INSERT INTO log VALUES (1981, 'cpignol', 'zaalpes-labelList', '2017-06-20 14:58:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1982, 'cpignol', 'zaalpes-sampleList', '2017-06-20 14:58:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1983, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 14:58:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1984, 'cpignol', 'zaalpes-labelChange', '2017-06-20 14:59:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1985, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:02:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1986, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:02:57', '7', '10.4.2.103');
INSERT INTO log VALUES (1987, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:02:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1988, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:03:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1989, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:03:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1990, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:04:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1991, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:04:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1992, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:04:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1993, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:04:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1994, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:05:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1995, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:05:08', '7', '10.4.2.103');
INSERT INTO log VALUES (1996, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:05:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1997, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:05:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1998, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:05:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1999, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:07:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2000, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:07:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2001, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:07:59', '7', '10.4.2.103');
INSERT INTO log VALUES (2002, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:07:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2003, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:08:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2004, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:08:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2005, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:09:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2006, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:10:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2007, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:10:04', '7', '10.4.2.103');
INSERT INTO log VALUES (2008, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:10:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2009, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:10:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2010, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:10:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2011, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:10:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2012, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:11:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2013, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:12:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2014, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:12:43', '7', '10.4.2.103');
INSERT INTO log VALUES (2015, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:12:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2016, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:12:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2017, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:12:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2018, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:13:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2019, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:14:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2020, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:16:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2021, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:16:11', '7', '10.4.2.103');
INSERT INTO log VALUES (2022, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:16:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2023, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:16:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2024, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:16:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2025, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:17:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2026, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:17:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2027, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:17:34', '7', '10.4.2.103');
INSERT INTO log VALUES (2028, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:17:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2029, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:17:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2030, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:17:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2031, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-20 15:18:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2032, 'cpignol', 'zaalpes-sampleChange', '2017-06-20 15:18:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2033, 'cpignol', 'zaalpes-sampleWrite', '2017-06-20 15:18:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2034, 'cpignol', 'zaalpes-Sample-write', '2017-06-20 15:18:41', '92', '10.4.2.103');
INSERT INTO log VALUES (2035, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-20 15:18:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2036, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:18:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2037, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:18:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2038, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:19:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2039, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:19:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2040, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:19:34', '7', '10.4.2.103');
INSERT INTO log VALUES (2041, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:19:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2042, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:19:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2043, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:19:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2044, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:19:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2045, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:20:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2046, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:24:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2047, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:24:10', '7', '10.4.2.103');
INSERT INTO log VALUES (2048, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:24:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2049, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:24:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2050, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:24:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2051, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:25:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2052, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:25:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2053, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:25:54', '7', '10.4.2.103');
INSERT INTO log VALUES (2054, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:25:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2055, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:26:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2056, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:26:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2057, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:26:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2058, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:28:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2059, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:28:13', '7', '10.4.2.103');
INSERT INTO log VALUES (2060, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:28:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2061, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:28:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2062, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:28:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2063, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:29:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2064, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:31:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2065, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:31:02', '7', '10.4.2.103');
INSERT INTO log VALUES (2066, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:31:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2067, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:31:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2068, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:31:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2069, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:31:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2070, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:32:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2071, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:32:54', '7', '10.4.2.103');
INSERT INTO log VALUES (2072, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:32:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2073, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:33:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2074, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:33:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2075, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:34:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2076, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:35:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2077, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:35:36', '7', '10.4.2.103');
INSERT INTO log VALUES (2078, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:35:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2079, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:35:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2080, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:35:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2081, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:36:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2082, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:39:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2083, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:39:48', '7', '10.4.2.103');
INSERT INTO log VALUES (2084, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:39:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2085, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:39:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2086, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:40:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2087, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:40:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2088, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:42:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2089, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:42:34', '7', '10.4.2.103');
INSERT INTO log VALUES (2090, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:42:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2091, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:42:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2092, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:43:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2093, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:44:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2094, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:45:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2095, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:45:19', '7', '10.4.2.103');
INSERT INTO log VALUES (2096, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:45:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2097, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:45:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2098, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:45:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2099, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:46:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2100, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:47:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2101, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:47:08', '7', '10.4.2.103');
INSERT INTO log VALUES (2102, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:47:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2103, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:47:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2104, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:47:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2105, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:47:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2106, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:48:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2107, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:48:24', '7', '10.4.2.103');
INSERT INTO log VALUES (2108, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:48:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2109, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:48:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2110, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:48:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2111, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:49:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2112, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:50:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2113, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:50:55', '7', '10.4.2.103');
INSERT INTO log VALUES (2114, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:50:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2115, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:51:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2116, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:51:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2117, 'cpignol', 'zaalpes-labelChange', '2017-06-20 15:51:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2118, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 15:52:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2119, 'cpignol', 'zaalpes-Label-write', '2017-06-20 15:52:21', '7', '10.4.2.103');
INSERT INTO log VALUES (2120, 'cpignol', 'zaalpes-labelList', '2017-06-20 15:52:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2121, 'cpignol', 'zaalpes-sampleList', '2017-06-20 15:52:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2122, 'cpignol', 'zaalpes-samplePrintLabel', '2017-06-20 15:52:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2123, 'cpignol', 'zaalpes-labelList', '2017-06-20 16:06:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2124, 'cpignol', 'zaalpes-labelChange', '2017-06-20 16:06:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2125, 'cpignol', 'zaalpes-labelWrite', '2017-06-20 16:06:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2126, 'cpignol', 'zaalpes-Label-write', '2017-06-20 16:06:32', '7', '10.4.2.103');
INSERT INTO log VALUES (2127, 'cpignol', 'zaalpes-labelList', '2017-06-20 16:06:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2128, 'unknown', 'zaalpes-loginList', '2017-06-21 17:34:26', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (2129, 'admin', 'zaalpes-connexion', '2017-06-21 17:34:31', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (2130, 'admin', 'zaalpes-loginList', '2017-06-21 17:34:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2131, 'admin', 'zaalpes-loginList', '2017-06-21 17:34:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2132, 'admin', 'zaalpes-disconnect', '2017-06-21 17:34:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2133, 'unknown', 'zaalpes-connexion', '2017-06-21 17:35:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2134, 'cpignol', 'zaalpes-connexion', '2017-06-21 17:35:16', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (2135, 'cpignol', 'zaalpes-default', '2017-06-21 17:35:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2136, 'cpignol', 'zaalpes-administration', '2017-06-21 17:35:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2137, 'cpignol', 'zaalpes-loginList', '2017-06-21 17:35:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2138, 'cpignol', 'zaalpes-loginChange', '2017-06-21 17:35:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2139, 'cpignol', 'zaalpes-loginWrite', '2017-06-21 17:36:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2140, 'cpignol', 'zaalpes-LoginGestion-write', '2017-06-21 17:36:48', '7', '10.4.2.103');
INSERT INTO log VALUES (2141, 'cpignol', 'zaalpes-loginList', '2017-06-21 17:36:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2142, 'cpignol', 'zaalpes-appliList', '2017-06-21 17:37:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2143, 'cpignol', 'zaalpes-appliDisplay', '2017-06-21 17:37:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2144, 'cpignol', 'zaalpes-acoChange', '2017-06-21 17:37:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2145, 'cpignol', 'zaalpes-appliDisplay', '2017-06-21 17:37:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2146, 'cpignol', 'zaalpes-acoChange', '2017-06-21 17:37:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2147, 'cpignol', 'zaalpes-groupList', '2017-06-21 17:37:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2148, 'cpignol', 'zaalpes-aclloginList', '2017-06-21 17:38:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2149, 'cpignol', 'zaalpes-aclloginChange', '2017-06-21 17:38:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2150, 'cpignol', 'zaalpes-loginList', '2017-06-21 17:38:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2151, 'cpignol', 'zaalpes-loginChange', '2017-06-21 17:38:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2152, 'cpignol', 'zaalpes-groupList', '2017-06-21 17:39:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2153, 'cpignol', 'zaalpes-groupChange', '2017-06-21 17:39:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2154, 'cpignol', 'zaalpes-groupWrite', '2017-06-21 17:39:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2155, 'cpignol', 'zaalpes-Aclgroup-write', '2017-06-21 17:39:21', '22', '10.4.2.103');
INSERT INTO log VALUES (2156, 'cpignol', 'zaalpes-groupList', '2017-06-21 17:39:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2157, 'cpignol', 'zaalpes-appliList', '2017-06-21 17:39:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2158, 'cpignol', 'zaalpes-appliDisplay', '2017-06-21 17:39:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2159, 'cpignol', 'zaalpes-acoChange', '2017-06-21 17:39:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2160, 'cpignol', 'zaalpes-appliList', '2017-06-21 17:40:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2161, 'cpignol', 'zaalpes-appliDisplay', '2017-06-21 17:40:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2162, 'cpignol', 'zaalpes-acoChange', '2017-06-21 17:40:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2163, 'cpignol', 'zaalpes-acoWrite', '2017-06-21 17:40:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2164, 'cpignol', 'zaalpes-Aclaco-write', '2017-06-21 17:40:57', '12', '10.4.2.103');
INSERT INTO log VALUES (2165, 'cpignol', 'zaalpes-appliDisplay', '2017-06-21 17:40:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2166, 'cpignol', 'zaalpes-aclloginList', '2017-06-21 17:41:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2167, 'cpignol', 'zaalpes-aclloginChange', '2017-06-21 17:41:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2168, 'cpignol', 'zaalpes-appliList', '2017-06-21 17:41:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2169, 'cpignol', 'zaalpes-appliDisplay', '2017-06-21 17:41:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2170, 'cpignol', 'zaalpes-acoChange', '2017-06-21 17:41:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2171, 'cpignol', 'zaalpes-acoWrite', '2017-06-21 17:41:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2172, 'cpignol', 'zaalpes-Aclaco-write', '2017-06-21 17:41:53', '13', '10.4.2.103');
INSERT INTO log VALUES (2173, 'cpignol', 'zaalpes-appliDisplay', '2017-06-21 17:41:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2174, 'cpignol', 'zaalpes-acoChange', '2017-06-21 17:42:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2175, 'cpignol', 'zaalpes-acoWrite', '2017-06-21 17:42:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2176, 'cpignol', 'zaalpes-Aclaco-write', '2017-06-21 17:42:08', '14', '10.4.2.103');
INSERT INTO log VALUES (2177, 'cpignol', 'zaalpes-appliDisplay', '2017-06-21 17:42:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2178, 'cpignol', 'zaalpes-acoChange', '2017-06-21 17:42:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2179, 'cpignol', 'zaalpes-acoWrite', '2017-06-21 17:42:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2180, 'cpignol', 'zaalpes-Aclaco-write', '2017-06-21 17:42:17', '15', '10.4.2.103');
INSERT INTO log VALUES (2181, 'cpignol', 'zaalpes-appliDisplay', '2017-06-21 17:42:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2182, 'cpignol', 'zaalpes-aclloginList', '2017-06-21 17:42:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2183, 'cpignol', 'zaalpes-aclloginChange', '2017-06-21 17:42:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2184, 'cpignol', 'zaalpes-disconnect', '2017-06-21 17:42:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2185, 'unknown', 'zaalpes-connexion', '2017-06-21 17:42:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2186, 'test-collec', 'zaalpes-connexion', '2017-06-21 17:42:55', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (2187, 'test-collec', 'zaalpes-default', '2017-06-21 17:42:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2188, 'test-collec', 'zaalpes-sampleList', '2017-06-21 17:43:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2189, 'test-collec', 'zaalpes-sampleList', '2017-06-21 17:43:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2190, 'test-collec', 'zaalpes-sampleDisplay', '2017-06-21 17:43:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2191, 'test-collec', 'zaalpes-disconnect', '2017-06-21 17:43:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2192, 'unknown', 'zaalpes-disconnect', '2017-06-22 09:23:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2193, 'unknown', 'zaalpes-connexion', '2017-06-22 09:23:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2194, 'test-collec', 'zaalpes-connexion', '2017-06-22 09:24:12', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (2195, 'test-collec', 'zaalpes-default', '2017-06-22 09:24:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2196, 'test-collec', 'zaalpes-sampleList', '2017-06-22 09:24:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2197, 'test-collec', 'zaalpes-sampleList', '2017-06-22 09:25:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2198, 'test-collec', 'zaalpes-sampleDisplay', '2017-06-22 09:25:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2199, 'unknown', 'zaalpes-default', '2017-06-22 09:26:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2200, 'unknown', 'zaalpes-connexion', '2017-06-22 09:26:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2201, 'cpignol', 'zaalpes-connexion', '2017-06-22 09:26:51', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (2202, 'cpignol', 'zaalpes-default', '2017-06-22 09:26:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2203, 'cpignol', 'zaalpes-aclloginList', '2017-06-22 09:26:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2204, 'cpignol', 'zaalpes-aclloginChange', '2017-06-22 09:27:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2205, 'cpignol', 'zaalpes-groupList', '2017-06-22 09:27:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2206, 'cpignol', 'zaalpes-groupChange', '2017-06-22 09:27:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2207, 'cpignol', 'zaalpes-appliList', '2017-06-22 09:27:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2208, 'cpignol', 'zaalpes-groupList', '2017-06-22 09:27:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2209, 'cpignol', 'zaalpes-administration', '2017-06-22 09:27:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2210, 'cpignol', 'zaalpes-aclloginList', '2017-06-22 09:28:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2211, 'cpignol', 'zaalpes-aclloginChange', '2017-06-22 09:28:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2212, 'cpignol', 'zaalpes-objets', '2017-06-22 09:28:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2213, 'cpignol', 'zaalpes-sampleList', '2017-06-22 09:28:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2214, 'cpignol', 'zaalpes-sampleList', '2017-06-22 09:28:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2215, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-22 09:28:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2216, 'cpignol', 'zaalpes-projectList', '2017-06-22 09:29:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2217, 'cpignol', 'zaalpes-projectChange', '2017-06-22 09:30:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2218, 'cpignol', 'zaalpes-projectWrite', '2017-06-22 09:30:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2219, 'cpignol', 'zaalpes-Project-write', '2017-06-22 09:30:37', '1', '10.4.2.103');
INSERT INTO log VALUES (2220, 'cpignol', 'zaalpes-projectList', '2017-06-22 09:30:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2221, 'cpignol', 'zaalpes-sampleList', '2017-06-22 09:30:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2222, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-22 09:30:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2223, 'cpignol', 'zaalpes-projectList', '2017-06-22 09:31:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2224, 'cpignol', 'zaalpes-projectChange', '2017-06-22 09:31:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2225, 'cpignol', 'zaalpes-projectWrite', '2017-06-22 09:31:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2226, 'cpignol', 'zaalpes-Project-write', '2017-06-22 09:31:28', '1', '10.4.2.103');
INSERT INTO log VALUES (2227, 'cpignol', 'zaalpes-projectList', '2017-06-22 09:31:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2228, 'test-collec', 'zaalpes-connexion', '2017-06-22 09:31:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2229, 'test-collec', 'zaalpes-projectList', '2017-06-22 09:31:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2230, 'test-collec', 'zaalpes-projectChange', '2017-06-22 09:32:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2231, 'test-collec', 'zaalpes-projectList', '2017-06-22 09:35:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2232, 'test-collec', 'zaalpes-protocolList', '2017-06-22 09:35:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2233, 'test-collec', 'zaalpes-protocolChange', '2017-06-22 09:35:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2234, 'test-collec', 'zaalpes-protocolList', '2017-06-22 09:35:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2235, 'test-collec', 'zaalpes-protocolChange', '2017-06-22 09:35:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2236, 'test-collec', 'zaalpes-protocolList', '2017-06-22 09:36:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2237, 'test-collec', 'zaalpes-protocolChange', '2017-06-22 09:36:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2238, 'test-collec', 'zaalpes-protocolWrite', '2017-06-22 09:37:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2239, 'test-collec', 'zaalpes-Protocol-write', '2017-06-22 09:37:12', '1', '10.4.2.103');
INSERT INTO log VALUES (2240, 'test-collec', 'zaalpes-protocolList', '2017-06-22 09:37:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2241, 'test-collec', 'zaalpes-protocolChange', '2017-06-22 09:37:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2242, 'test-collec', 'zaalpes-protocolWrite', '2017-06-22 09:37:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2243, 'test-collec', 'zaalpes-Protocol-write', '2017-06-22 09:37:26', '1', '10.4.2.103');
INSERT INTO log VALUES (2244, 'test-collec', 'zaalpes-protocolList', '2017-06-22 09:37:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2245, 'test-collec', 'zaalpes-operationList', '2017-06-22 09:37:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2246, 'test-collec', 'zaalpes-operationChange', '2017-06-22 09:37:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2247, 'cpignol', 'zaalpes-appliList', '2017-06-22 09:41:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2248, 'cpignol', 'zaalpes-appliDisplay', '2017-06-22 09:41:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2249, 'cpignol', 'zaalpes-acoChange', '2017-06-22 09:41:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2250, 'cpignol', 'zaalpes-appliList', '2017-06-22 09:42:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2251, 'cpignol', 'zaalpes-appliDisplay', '2017-06-22 09:43:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2252, 'cpignol', 'zaalpes-appliList', '2017-06-22 09:45:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2253, 'cpignol', 'zaalpes-appliDisplay', '2017-06-22 09:46:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2254, 'cpignol', 'zaalpes-appliList', '2017-06-22 09:47:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2255, 'cpignol', 'zaalpes-aclloginList', '2017-06-22 09:48:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2256, 'cpignol', 'zaalpes-aclloginChange', '2017-06-22 09:48:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2257, 'cpignol', 'zaalpes-aclloginList', '2017-06-22 09:49:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2258, 'cpignol', 'zaalpes-aclloginChange', '2017-06-22 09:49:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2259, 'cpignol', 'zaalpes-appliList', '2017-06-22 09:50:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2260, 'test-collec', 'zaalpes-containerList', '2017-06-22 09:58:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2261, 'test-collec', 'zaalpes-containerTypeGetFromFamily', '2017-06-22 09:58:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2262, 'test-collec', 'zaalpes-containerList', '2017-06-22 09:58:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2263, 'test-collec', 'zaalpes-containerTypeGetFromFamily', '2017-06-22 09:58:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2264, 'test-collec', 'zaalpes-containerPrintLabel', '2017-06-22 09:58:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2265, 'cpignol', 'zaalpes-appliDisplay', '2017-06-22 10:06:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2266, 'cpignol', 'zaalpes-aclloginList', '2017-06-22 10:06:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2267, 'cpignol', 'zaalpes-groupList', '2017-06-22 10:21:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2268, 'cpignol', 'zaalpes-aclloginList', '2017-06-22 10:21:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2269, 'cpignol', 'zaalpes-aclloginChange', '2017-06-22 10:21:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2270, 'cpignol', 'zaalpes-aclloginList', '2017-06-22 10:21:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2271, 'cpignol', 'zaalpes-loginList', '2017-06-22 10:21:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2272, 'cpignol', 'zaalpes-loginChange', '2017-06-22 10:21:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2273, 'cpignol', 'zaalpes-appliList', '2017-06-22 10:25:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2274, 'cpignol', 'zaalpes-appliDisplay', '2017-06-22 10:25:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2275, 'cpignol', 'zaalpes-projectList', '2017-06-22 10:34:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2276, 'cpignol', 'zaalpes-projectChange', '2017-06-22 10:37:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2277, 'cpignol', 'zaalpes-aclloginList-connexion', '2017-06-22 13:45:57', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (2278, 'cpignol', 'zaalpes-aclloginList', '2017-06-22 13:45:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2279, 'cpignol', 'zaalpes-aclloginChange', '2017-06-22 13:46:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2280, 'cpignol', 'zaalpes-protocolList-connexion', '2017-06-22 15:01:08', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (2281, 'cpignol', 'zaalpes-protocolList', '2017-06-22 15:01:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2282, 'cpignol', 'zaalpes-protocolChange', '2017-06-22 15:01:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2283, 'cpignol', 'zaalpes-protocolList', '2017-06-22 15:01:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2284, 'cpignol', 'zaalpes-protocolChange', '2017-06-22 15:01:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2285, 'cpignol', 'zaalpes-protocolList', '2017-06-22 15:01:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2286, 'unknown', 'zaalpes-fastInputChange', '2017-06-23 15:05:19', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (2287, 'cpignol', 'zaalpes-connexion', '2017-06-23 15:05:30', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (2288, 'cpignol', 'zaalpes-fastInputChange', '2017-06-23 15:05:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2289, 'cpignol', 'zaalpes-storageBatchOpen', '2017-06-23 15:05:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2290, 'cpignol', 'zaalpes-importChange', '2017-06-23 15:06:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2291, 'cpignol', 'zaalpes-sampleList', '2017-06-23 15:06:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2292, 'cpignol', 'zaalpes-sampleChange', '2017-06-23 15:06:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2293, 'cpignol', 'zaalpes-disconnect', '2017-06-23 15:07:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2294, 'unknown', 'zaalpes-containerList', '2017-06-23 15:07:31', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (2295, 'unknown', 'zaalpes-sampleList', '2017-06-23 15:07:38', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (2296, 'unknown', 'zaalpes-containerList', '2017-06-26 13:59:46', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (2297, 'cpignol', 'zaalpes-connexion', '2017-06-26 14:22:49', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (2298, 'cpignol', 'zaalpes-containerList', '2017-06-26 14:22:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2299, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-26 14:22:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2300, 'cpignol', 'zaalpes-samplingPlaceList', '2017-06-26 14:22:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2301, 'cpignol', 'zaalpes-containerTypeList', '2017-06-26 14:27:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2302, 'cpignol', 'zaalpes-sampleTypeList', '2017-06-26 14:27:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2303, 'cpignol', 'zaalpes-sampleTypeChange', '2017-06-26 14:27:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2304, 'cpignol', 'zaalpes-sampleList', '2017-06-26 14:27:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2305, 'cpignol', 'zaalpes-importChange', '2017-06-26 14:27:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2306, 'unknown', 'zaalpes-disconnect', '2017-06-27 13:45:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2307, 'unknown', 'zaalpes-connexion', '2017-06-27 13:45:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2308, 'cpignol', 'zaalpes-connexion', '2017-06-27 14:14:19', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (2309, 'cpignol', 'zaalpes-default', '2017-06-27 14:14:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2310, 'cpignol', 'zaalpes-loginList', '2017-06-27 14:14:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2311, 'cpignol', 'zaalpes-loginChange', '2017-06-27 14:14:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2312, 'cpignol', 'zaalpes-loginWrite', '2017-06-27 14:16:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2313, 'cpignol', 'zaalpes-LoginGestion-write', '2017-06-27 14:16:30', '8', '10.4.2.103');
INSERT INTO log VALUES (2314, 'cpignol', 'zaalpes-loginList', '2017-06-27 14:16:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2315, 'cpignol', 'zaalpes-appliList', '2017-06-27 14:16:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2316, 'cpignol', 'zaalpes-appliDisplay', '2017-06-27 14:17:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2317, 'cpignol', 'zaalpes-acoChange', '2017-06-27 14:17:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2318, 'cpignol', 'zaalpes-appliList', '2017-06-27 14:17:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2319, 'cpignol', 'zaalpes-appliChange', '2017-06-27 14:17:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2320, 'cpignol', 'zaalpes-groupList', '2017-06-27 14:17:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2321, 'cpignol', 'zaalpes-groupChange', '2017-06-27 14:17:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2322, 'cpignol', 'zaalpes-groupWrite', '2017-06-27 14:18:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2323, 'cpignol', 'zaalpes-Aclgroup-write', '2017-06-27 14:18:05', '1', '10.4.2.103');
INSERT INTO log VALUES (2324, 'cpignol', 'zaalpes-groupList', '2017-06-27 14:18:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2325, 'cpignol', 'zaalpes-groupChange', '2017-06-27 14:18:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2326, 'cpignol', 'zaalpes-groupWrite', '2017-06-27 14:18:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2327, 'cpignol', 'zaalpes-Aclgroup-write', '2017-06-27 14:18:22', '31', '10.4.2.103');
INSERT INTO log VALUES (2328, 'cpignol', 'zaalpes-groupList', '2017-06-27 14:18:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2329, 'cpignol', 'zaalpes-groupChange', '2017-06-27 14:18:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2330, 'cpignol', 'zaalpes-groupWrite', '2017-06-27 14:18:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2331, 'cpignol', 'zaalpes-Aclgroup-write', '2017-06-27 14:18:30', '1', '10.4.2.103');
INSERT INTO log VALUES (2332, 'cpignol', 'zaalpes-groupList', '2017-06-27 14:18:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2333, 'cpignol', 'zaalpes-groupChange', '2017-06-27 14:18:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2334, 'cpignol', 'zaalpes-disconnect', '2017-06-27 14:18:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2335, 'unknown', 'zaalpes-connexion', '2017-06-27 14:18:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2336, 'admindemo', 'zaalpes-connexion', '2017-06-27 14:20:15', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (2337, 'admindemo', 'zaalpes-default', '2017-06-27 14:20:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2338, 'admindemo', 'zaalpes-sampleList', '2017-06-27 14:20:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2339, 'admindemo', 'zaalpes-sampleList', '2017-06-27 14:20:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2340, 'admindemo', 'zaalpes-sampleDisplay', '2017-06-27 14:20:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2341, 'admindemo', 'zaalpes-storage', '2017-06-27 14:20:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2342, 'admindemo', 'zaalpes-fastInputChange', '2017-06-27 14:20:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2343, 'admindemo', 'zaalpes-objectGetDetail', '2017-06-27 14:20:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2344, 'admindemo', 'zaalpes-labelList', '2017-06-27 14:20:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2345, 'admindemo', 'zaalpes-administration', '2017-06-27 14:21:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2346, 'admindemo', 'zaalpes-loginList', '2017-06-27 14:22:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2347, 'admindemo', 'zaalpes-loginChange', '2017-06-27 14:22:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2348, 'admindemo', 'zaalpes-loginList', '2017-06-27 14:22:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2349, 'unknown', 'zaalpes-default', '2017-06-28 10:35:10', 'ok', '10.1.11.130');
INSERT INTO log VALUES (2350, 'unknown', 'zaalpes-sampleList', '2017-06-28 10:35:19', 'nologin', '10.1.11.130');
INSERT INTO log VALUES (2351, 'unknown', 'zaalpes-sampleList', '2017-06-28 15:23:01', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (2352, 'unknown', 'zaalpes-sampleList', '2017-06-28 15:23:08', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (2353, 'unknown', 'zaalpes-connexion', '2017-06-28 15:23:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2354, 'cpignol', 'zaalpes-connexion', '2017-06-28 15:23:24', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (2355, 'cpignol', 'zaalpes-default', '2017-06-28 15:23:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2356, 'cpignol', 'zaalpes-sampleList', '2017-06-28 15:23:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2357, 'cpignol', 'zaalpes-sampleList', '2017-06-28 15:23:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2358, 'cpignol', 'zaalpes-sampleList', '2017-06-28 15:26:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2359, 'cpignol', 'zaalpes-groupList', '2017-06-28 15:28:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2360, 'cpignol', 'zaalpes-appliList', '2017-06-28 15:28:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2361, 'cpignol', 'zaalpes-appliDisplay', '2017-06-28 15:28:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2362, 'cpignol', 'zaalpes-acoChange', '2017-06-28 15:28:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2363, 'cpignol', 'zaalpes-groupList', '2017-06-28 15:29:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2364, 'cpignol', 'zaalpes-groupChange', '2017-06-28 15:29:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2365, 'cpignol', 'zaalpes-projectList', '2017-06-28 15:29:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2366, 'cpignol', 'zaalpes-projectChange', '2017-06-28 15:29:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2367, 'cpignol', 'zaalpes-sampleList', '2017-06-28 15:40:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2368, 'cpignol', 'zaalpes-sampleDisplay', '2017-06-28 15:40:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2369, 'unknown', 'zaalpes-default', '2017-06-29 00:07:31', 'ok', '82.245.12.172');
INSERT INTO log VALUES (2370, 'unknown', 'zaalpes-apropos', '2017-06-29 00:07:44', 'ok', '82.245.12.172');
INSERT INTO log VALUES (2371, 'unknown', 'zaalpes-connexion', '2017-06-29 00:07:55', 'ok', '82.245.12.172');
INSERT INTO log VALUES (2372, 'unknown', 'zaalpes-containerList', '2017-06-29 00:08:01', 'nologin', '82.245.12.172');
INSERT INTO log VALUES (2373, 'unknown', 'zaalpes-quoideneuf', '2017-06-29 00:08:07', 'ok', '82.245.12.172');
INSERT INTO log VALUES (2374, 'unknown', 'zaalpes-default', '2017-06-29 09:15:28', 'ok', '10.1.11.130');
INSERT INTO log VALUES (2375, 'unknown', 'zaalpes-default', '2017-06-30 09:53:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2376, 'unknown', 'zaalpes-connexion', '2017-06-30 09:53:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2377, 'cpignol', 'zaalpes-connexion', '2017-06-30 09:53:16', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (2378, 'cpignol', 'zaalpes-default', '2017-06-30 09:53:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2379, 'cpignol', 'zaalpes-sampleList', '2017-06-30 09:53:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2380, 'cpignol', 'zaalpes-sampleList', '2017-06-30 09:53:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2381, 'unknown', 'zaalpes-default', '2017-06-30 13:51:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2382, 'unknown', 'zaalpes-default', '2017-06-30 13:51:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2383, 'unknown', 'zaalpes-connexion', '2017-06-30 13:51:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2384, 'cpignol', 'zaalpes-connexion', '2017-06-30 13:52:06', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (2385, 'cpignol', 'zaalpes-default', '2017-06-30 13:52:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2386, 'cpignol', 'zaalpes-objets', '2017-06-30 13:52:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2387, 'cpignol', 'zaalpes-sampleList', '2017-06-30 13:52:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2388, 'cpignol', 'zaalpes-sampleList', '2017-06-30 13:52:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2389, 'unknown', 'zaalpes-default', '2017-06-30 13:52:54', 'ok', '10.13.97.182');
INSERT INTO log VALUES (2390, 'unknown', 'zaalpes-connexion', '2017-06-30 13:53:01', 'ok', '10.13.97.182');
INSERT INTO log VALUES (2391, 'unknown', 'zaalpes-default', '2017-06-30 13:53:23', 'ok', '10.13.97.182');
INSERT INTO log VALUES (2392, 'unknown', 'zaalpes-default', '2017-06-30 13:53:36', 'ok', '10.13.97.182');
INSERT INTO log VALUES (2393, 'unknown', 'zaalpes-default', '2017-06-30 14:05:00', 'ok', '10.13.97.182');
INSERT INTO log VALUES (2394, 'unknown', 'zaalpes-sampleList', '2017-06-30 14:34:26', 'nologin', '10.1.11.130');
INSERT INTO log VALUES (2395, 'cpignol', 'zaalpes-connexion-connexion', '2017-06-30 15:58:16', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (2396, 'cpignol', 'zaalpes-connexion', '2017-06-30 15:58:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2397, 'unknown', 'zaalpes-default', '2017-06-30 16:48:13', 'ok', '193.54.246.157');
INSERT INTO log VALUES (2398, 'unknown', 'zaalpes-sampleList', '2017-06-30 16:48:23', 'nologin', '193.54.246.157');
INSERT INTO log VALUES (2399, 'admindemo', 'zaalpes-connexion', '2017-06-30 16:48:44', 'db-ok', '193.54.246.157');
INSERT INTO log VALUES (2400, 'admindemo', 'zaalpes-sampleList', '2017-06-30 16:48:44', 'ok', '193.54.246.157');
INSERT INTO log VALUES (2401, 'admindemo', 'zaalpes-sampleList', '2017-06-30 16:51:33', 'ok', '193.54.246.157');
INSERT INTO log VALUES (2402, 'admindemo', 'zaalpes-sampleDisplay', '2017-06-30 16:52:03', 'ok', '193.54.246.157');
INSERT INTO log VALUES (2403, 'admindemo', 'zaalpes-sampleList', '2017-06-30 17:01:59', 'ok', '193.54.246.157');
INSERT INTO log VALUES (2404, 'admindemo', 'zaalpes-sampleDisplay', '2017-06-30 17:02:04', 'ok', '193.54.246.157');
INSERT INTO log VALUES (2405, 'cpignol', 'zaalpes-containerList-connexion', '2017-06-30 17:19:53', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (2406, 'cpignol', 'zaalpes-containerList', '2017-06-30 17:19:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2407, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-30 17:19:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2408, 'cpignol', 'zaalpes-containerList', '2017-06-30 17:19:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2409, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-06-30 17:19:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2410, 'cpignol', 'zaalpes-sampleList', '2017-06-30 17:20:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2411, 'cpignol', 'zaalpes-sampleList', '2017-06-30 17:20:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2412, 'unknown', 'zaalpes-default', '2017-06-30 17:20:57', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2413, 'unknown', 'zaalpes-loginChangePassword', '2017-06-30 17:21:02', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2414, 'cepignol', 'zaalpes-connexion', '2017-06-30 17:21:29', 'db-ko', '193.48.126.37');
INSERT INTO log VALUES (2415, 'unknown', 'zaalpes-default', '2017-06-30 17:21:29', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2416, 'unknown', 'zaalpes-loginChangePassword', '2017-06-30 17:21:33', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2417, 'cpignol', 'zaalpes-connexion', '2017-06-30 17:21:38', 'db-ok', '193.48.126.37');
INSERT INTO log VALUES (2418, 'cpignol', 'zaalpes-default', '2017-06-30 17:21:38', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2419, 'cpignol', 'zaalpes-loginChangePassword', '2017-06-30 17:28:05', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2420, 'cpignol', 'zaalpes-fastInputChange', '2017-06-30 17:29:32', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2421, 'cpignol', 'zaalpes-fastInputChange', '2017-06-30 17:29:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2422, 'cpignol', 'zaalpes-objectGetDetail', '2017-06-30 17:29:40', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2423, 'cpignol', 'zaalpes-objectGetDetail', '2017-06-30 17:29:46', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2424, 'cpignol', 'zaalpes-objectGetDetail', '2017-06-30 17:30:01', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2425, 'cpignol', 'zaalpes-objectGetDetail', '2017-06-30 17:30:08', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2426, 'cpignol', 'zaalpes-objectGetDetail', '2017-06-30 17:30:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2427, 'cpignol', 'zaalpes-objectGetDetail', '2017-06-30 17:30:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2428, 'cpignol', 'zaalpes-objectGetDetail', '2017-06-30 17:30:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2429, 'cpignol', 'zaalpes-sampleList-connexion', '2017-06-30 18:58:10', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (2430, 'cpignol', 'zaalpes-sampleList', '2017-06-30 18:58:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2431, 'cpignol', 'zaalpes-objectGetDetail', '2017-06-30 18:58:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2432, 'unknown', 'zaalpes-default', '2017-07-03 05:42:43', 'ok', '66.249.64.95');
INSERT INTO log VALUES (2433, 'unknown', 'zaalpes-aide', '2017-07-03 05:45:56', 'ok', '66.249.64.67');
INSERT INTO log VALUES (2434, 'unknown', 'zaalpes-objets', '2017-07-03 05:46:13', 'ok', '66.249.64.95');
INSERT INTO log VALUES (2435, 'unknown', 'zaalpes-apropos', '2017-07-03 05:46:40', 'ok', '66.249.64.64');
INSERT INTO log VALUES (2436, 'unknown', 'zaalpes-connexion', '2017-07-03 05:47:06', 'ok', '66.249.64.95');
INSERT INTO log VALUES (2437, 'unknown', 'zaalpes-sampleList', '2017-07-03 05:47:33', 'nologin', '66.249.64.95');
INSERT INTO log VALUES (2438, 'unknown', 'zaalpes-quoideneuf', '2017-07-03 05:49:36', 'ok', '66.249.64.95');
INSERT INTO log VALUES (2439, 'unknown', 'zaalpes-default', '2017-07-03 16:32:40', 'ok', '194.254.155.15');
INSERT INTO log VALUES (2440, 'unknown', 'zaalpes-connexion', '2017-07-03 16:32:50', 'ok', '194.254.155.15');
INSERT INTO log VALUES (2441, 'admindemo', 'zaalpes-connexion', '2017-07-03 16:33:02', 'db-ok', '194.254.155.15');
INSERT INTO log VALUES (2442, 'admindemo', 'zaalpes-default', '2017-07-03 16:33:02', 'ok', '194.254.155.15');
INSERT INTO log VALUES (2443, 'admindemo', 'zaalpes-containerList', '2017-07-03 16:33:13', 'ok', '194.254.155.15');
INSERT INTO log VALUES (2444, 'admindemo', 'zaalpes-containerTypeGetFromFamily', '2017-07-03 16:33:14', 'ok', '194.254.155.15');
INSERT INTO log VALUES (2445, 'admindemo', 'zaalpes-containerList', '2017-07-03 16:33:20', 'ok', '194.254.155.15');
INSERT INTO log VALUES (2446, 'admindemo', 'zaalpes-containerTypeGetFromFamily', '2017-07-03 16:33:21', 'ok', '194.254.155.15');
INSERT INTO log VALUES (2447, 'admindemo', 'zaalpes-containerDisplay', '2017-07-03 16:33:44', 'ok', '194.254.155.15');
INSERT INTO log VALUES (2448, 'admindemo', 'zaalpes-sampleList', '2017-07-03 16:34:24', 'ok', '194.254.155.15');
INSERT INTO log VALUES (2449, 'admindemo', 'zaalpes-sampleList', '2017-07-03 16:34:30', 'ok', '194.254.155.15');
INSERT INTO log VALUES (2450, 'admindemo', 'zaalpes-samplePrintLabel', '2017-07-03 16:36:25', 'ok', '194.254.155.15');
INSERT INTO log VALUES (2451, 'unknown', 'zaalpes-default', '2017-07-03 17:20:29', 'ok', '194.254.155.15');
INSERT INTO log VALUES (2452, 'admindemo', 'zaalpes-connexion-connexion', '2017-07-03 17:20:33', 'token-ok', '194.254.155.15');
INSERT INTO log VALUES (2453, 'admindemo', 'zaalpes-connexion', '2017-07-03 17:20:33', 'ok', '194.254.155.15');
INSERT INTO log VALUES (2454, 'admindemo', 'zaalpes-storage', '2017-07-03 17:20:37', 'ok', '194.254.155.15');
INSERT INTO log VALUES (2455, 'admindemo', 'zaalpes-fastInputChange', '2017-07-03 17:20:39', 'ok', '194.254.155.15');
INSERT INTO log VALUES (2456, 'admindemo', 'zaalpes-objectGetDetail', '2017-07-03 17:20:51', 'ok', '194.254.155.15');
INSERT INTO log VALUES (2457, 'admindemo', 'zaalpes-operationList', '2017-07-03 17:32:07', 'ok', '194.254.155.15');
INSERT INTO log VALUES (2458, 'unknown', 'zaalpes-setlanguage', '2017-07-03 18:46:24', 'ok', '66.249.64.95');
INSERT INTO log VALUES (2459, 'unknown', 'zaalpes-default', '2017-07-03 18:46:24', 'ok', '66.249.64.95');
INSERT INTO log VALUES (2460, 'unknown', 'zaalpes-containerList', '2017-07-04 04:11:53', 'nologin', '66.249.69.63');
INSERT INTO log VALUES (2461, 'unknown', 'zaalpes-setlanguage', '2017-07-04 07:19:42', 'ok', '66.249.69.35');
INSERT INTO log VALUES (2462, 'unknown', 'zaalpes-default', '2017-07-04 07:19:42', 'ok', '66.249.69.35');
INSERT INTO log VALUES (2463, 'unknown', 'zaalpes-default', '2017-07-04 13:39:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2464, 'unknown', 'zaalpes-connexion', '2017-07-04 13:39:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2465, 'cpignol', 'zaalpes-connexion', '2017-07-04 13:40:02', 'db-ko', '10.4.2.103');
INSERT INTO log VALUES (2466, 'unknown', 'zaalpes-default', '2017-07-04 13:40:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2467, 'unknown', 'zaalpes-connexion', '2017-07-04 13:40:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2468, 'cpignol', 'zaalpes-connexion', '2017-07-04 13:40:24', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (2469, 'cpignol', 'zaalpes-default', '2017-07-04 13:40:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2470, 'cpignol', 'zaalpes-containerList', '2017-07-04 13:40:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2471, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-07-04 13:40:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2472, 'cpignol', 'zaalpes-containerList', '2017-07-04 13:40:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2473, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-07-04 13:40:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2474, 'cpignol', 'zaalpes-containerDisplay', '2017-07-04 13:40:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2475, 'cpignol', 'zaalpes-sampleList', '2017-07-04 13:40:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2476, 'cpignol', 'zaalpes-sampleList', '2017-07-04 13:41:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2477, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-04 13:41:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2478, 'cpignol', 'zaalpes-storage', '2017-07-04 13:41:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2479, 'cpignol', 'zaalpes-fastInputChange', '2017-07-04 13:41:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2480, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-04 14:03:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2481, 'unknown', 'zaalpes-default', '2017-07-04 15:04:40', 'ok', '194.254.155.15');
INSERT INTO log VALUES (2482, 'cpignol', 'zaalpes-objectGetDetail-connexion', '2017-07-04 16:38:54', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (2483, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-04 16:38:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2484, 'unknown', 'zaalpes-setlanguagefr', '2017-07-05 16:27:07', 'ok', '66.249.79.5');
INSERT INTO log VALUES (2485, 'unknown', 'zaalpes-default', '2017-07-05 16:27:07', 'ok', '66.249.79.5');
INSERT INTO log VALUES (2486, 'unknown', 'zaalpes-setlanguageen', '2017-07-05 16:28:12', 'ok', '66.249.79.1');
INSERT INTO log VALUES (2487, 'unknown', 'zaalpes-default', '2017-07-05 16:28:12', 'ok', '66.249.79.1');
INSERT INTO log VALUES (2488, 'unknown', 'zaalpes-loginChangePassword', '2017-07-05 16:29:14', 'ok', '66.249.79.5');
INSERT INTO log VALUES (2489, 'unknown', 'zaalpes-setlanguage', '2017-07-05 16:30:19', 'ok', '66.249.79.5');
INSERT INTO log VALUES (2490, 'unknown', 'zaalpes-default', '2017-07-05 16:30:19', 'ok', '66.249.79.5');
INSERT INTO log VALUES (2491, 'unknown', 'zaalpes-setlanguage', '2017-07-05 16:31:33', 'ok', '66.249.79.31');
INSERT INTO log VALUES (2492, 'unknown', 'zaalpes-default', '2017-07-05 16:31:33', 'ok', '66.249.79.31');
INSERT INTO log VALUES (2493, 'unknown', 'zaalpes-default', '2017-07-11 16:03:40', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2494, 'unknown', 'zaalpes-connexion', '2017-07-11 16:03:44', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2495, 'cpignol', 'zaalpes-connexion', '2017-07-11 16:03:56', 'db-ok', '193.48.126.37');
INSERT INTO log VALUES (2496, 'cpignol', 'zaalpes-default', '2017-07-11 16:03:56', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2497, 'cpignol', 'zaalpes-fastOutputChange', '2017-07-11 16:13:13', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2498, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:13:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2499, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:13:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2500, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:13:23', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2501, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:13:34', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2502, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:13:41', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2503, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:13:41', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2504, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:13:42', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2505, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:13:44', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2506, 'cpignol', 'zaalpes-fastOutputWrite', '2017-07-11 16:16:41', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2507, 'cpignol', 'zaalpes-fastOutputChange', '2017-07-11 16:16:41', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2508, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:16:43', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2509, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:16:43', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2510, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:16:46', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2511, 'cpignol', 'zaalpes-fastInputChange', '2017-07-11 16:17:37', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2512, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:17:41', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2513, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:17:43', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2514, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:17:43', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2515, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:17:47', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2516, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:17:47', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2517, 'cpignol', 'zaalpes-sampleList', '2017-07-11 16:18:06', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2518, 'cpignol', 'zaalpes-storage', '2017-07-11 16:18:15', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2519, 'cpignol', 'zaalpes-parametre', '2017-07-11 16:18:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2520, 'cpignol', 'zaalpes-sampleList', '2017-07-11 16:18:19', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2521, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 16:18:21', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2522, 'unknown', 'zaalpes-sampleChange', '2017-07-11 16:18:57', 'nologin', '193.48.126.37');
INSERT INTO log VALUES (2523, 'unknown', 'zaalpes-loginChangePassword', '2017-07-11 16:19:05', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2524, 'cpignol', 'zaalpes-connexion', '2017-07-11 16:19:33', 'db-ok', '193.48.126.37');
INSERT INTO log VALUES (2525, 'cpignol', 'zaalpes-default', '2017-07-11 16:19:33', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2526, 'cpignol', 'zaalpes-sampleList', '2017-07-11 16:19:36', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2527, 'cpignol', 'zaalpes-sampleList', '2017-07-11 16:19:45', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2528, 'cpignol', 'zaalpes-sampleList', '2017-07-11 16:19:51', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2529, 'cpignol', 'zaalpes-sampleList', '2017-07-11 16:20:02', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2530, 'unknown', 'zaalpes-default', '2017-07-11 16:20:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2531, 'cpignol', 'zaalpes-storage', '2017-07-11 16:20:14', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2532, 'unknown', 'zaalpes-connexion', '2017-07-11 16:20:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2533, 'cpignol', 'zaalpes-fastOutputChange', '2017-07-11 16:20:20', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2534, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:20:23', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2535, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:20:23', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2536, 'cpignol', 'zaalpes-connexion', '2017-07-11 16:20:30', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (2537, 'cpignol', 'zaalpes-default', '2017-07-11 16:20:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2538, 'cpignol', 'zaalpes-objets', '2017-07-11 16:20:34', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2539, 'cpignol', 'zaalpes-sampleList', '2017-07-11 16:20:38', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2540, 'cpignol', 'zaalpes-sampleList', '2017-07-11 16:20:46', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2541, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:21:03', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2542, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:21:05', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2543, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:21:05', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2544, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:21:07', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2545, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:21:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2546, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:21:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2547, 'cpignol', 'zaalpes-storage', '2017-07-11 16:26:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2548, 'cpignol', 'zaalpes-storage', '2017-07-11 16:26:30', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2549, 'cpignol', 'zaalpes-sampleList', '2017-07-11 16:26:48', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2550, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 16:26:53', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2551, 'cpignol', 'zaalpes-sampleList', '2017-07-11 16:29:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2552, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 16:29:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2553, 'cpignol', 'zaalpes-sampleList', '2017-07-11 16:29:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2554, 'cpignol', 'zaalpes-sampleList', '2017-07-11 16:29:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2555, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 16:30:03', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2556, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 16:30:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2557, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 16:32:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2558, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 16:32:30', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2559, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 16:32:42', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2560, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 16:33:29', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2561, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 16:33:56', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2562, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 16:33:59', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2563, 'cpignol', 'zaalpes-metadataFormGetDetail', '2017-07-11 16:34:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2564, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 16:37:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2565, 'cpignol', 'zaalpes-samplebookingChange', '2017-07-11 16:37:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2566, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 16:37:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2567, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 16:37:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2568, 'cpignol', 'zaalpes-metadataFormGetDetail', '2017-07-11 16:40:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2569, 'cpignol', 'zaalpes-protocolList', '2017-07-11 16:48:37', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2570, 'cpignol', 'zaalpes-protocolList', '2017-07-11 16:48:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2571, 'cpignol', 'zaalpes-protocolChange', '2017-07-11 16:48:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2572, 'cpignol', 'zaalpes-protocolChange', '2017-07-11 16:48:49', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2573, 'cpignol', 'zaalpes-protocolList', '2017-07-11 16:48:53', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2574, 'cpignol', 'zaalpes-operationList', '2017-07-11 16:48:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2575, 'cpignol', 'zaalpes-operationList', '2017-07-11 16:49:20', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2576, 'cpignol', 'zaalpes-operationChange', '2017-07-11 16:49:34', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2577, 'cpignol', 'zaalpes-operationChange', '2017-07-11 16:49:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2578, 'cpignol', 'zaalpes-operationList', '2017-07-11 16:49:43', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2579, 'cpignol', 'zaalpes-operationList', '2017-07-11 16:49:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2580, 'cpignol', 'zaalpes-operationChange', '2017-07-11 16:50:00', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2581, 'cpignol', 'zaalpes-operationChange', '2017-07-11 16:50:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2582, 'cpignol', 'zaalpes-operationWrite', '2017-07-11 16:52:59', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2583, 'cpignol', 'zaalpes-Operation-write', '2017-07-11 16:52:59', '2', '193.48.126.37');
INSERT INTO log VALUES (2584, 'cpignol', 'zaalpes-operationList', '2017-07-11 16:52:59', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2585, 'cpignol', 'zaalpes-operationChange', '2017-07-11 16:53:18', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2586, 'cpignol', 'zaalpes-operationChange', '2017-07-11 16:53:23', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2587, 'cpignol', 'zaalpes-operationList', '2017-07-11 16:53:38', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2588, 'cpignol', 'zaalpes-operationList', '2017-07-11 16:53:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2589, 'cpignol', 'zaalpes-operationChange', '2017-07-11 16:53:42', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2590, 'cpignol', 'zaalpes-operationChange', '2017-07-11 16:53:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2591, 'cpignol', 'zaalpes-operationList', '2017-07-11 16:55:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2592, 'cpignol', 'zaalpes-operationChange', '2017-07-11 16:55:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2593, 'cpignol', 'zaalpes-operationList', '2017-07-11 16:56:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2594, 'cpignol', 'zaalpes-operationWrite', '2017-07-11 16:58:07', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2595, 'cpignol', 'zaalpes-Operation-write', '2017-07-11 16:58:07', '2', '193.48.126.37');
INSERT INTO log VALUES (2596, 'cpignol', 'zaalpes-operationList', '2017-07-11 16:58:07', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2597, 'cpignol', 'zaalpes-operationChange', '2017-07-11 16:58:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2598, 'cpignol', 'zaalpes-sampleList', '2017-07-11 16:58:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2599, 'cpignol', 'zaalpes-sampleList', '2017-07-11 16:58:43', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2600, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 16:58:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2601, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 16:58:55', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2602, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 16:59:00', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2603, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 16:59:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2604, 'cpignol', 'zaalpes-fastInputChange', '2017-07-11 16:59:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2605, 'cpignol', 'zaalpes-storage', '2017-07-11 16:59:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2606, 'cpignol', 'zaalpes-objectGetDetail', '2017-07-11 16:59:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2607, 'cpignol', 'zaalpes-sampleList', '2017-07-11 16:59:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2608, 'cpignol', 'zaalpes-parametre', '2017-07-11 16:59:58', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2609, 'cpignol', 'zaalpes-sampleTypeList', '2017-07-11 17:00:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2610, 'cpignol', 'zaalpes-sampleTypeList', '2017-07-11 17:00:05', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2611, 'cpignol', 'zaalpes-sampleTypeChange', '2017-07-11 17:00:10', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2612, 'cpignol', 'zaalpes-sampleTypeChange', '2017-07-11 17:00:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2613, 'cpignol', 'zaalpes-sampleTypeWrite', '2017-07-11 17:03:26', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2614, 'cpignol', 'zaalpes-SampleType-write', '2017-07-11 17:03:26', '2', '193.48.126.37');
INSERT INTO log VALUES (2615, 'cpignol', 'zaalpes-sampleTypeList', '2017-07-11 17:03:26', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2616, 'cpignol', 'zaalpes-sampleTypeList', '2017-07-11 17:03:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2617, 'cpignol', 'zaalpes-sampleTypeChange', '2017-07-11 17:03:36', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2618, 'cpignol', 'zaalpes-operationList', '2017-07-11 17:08:19', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2619, 'cpignol', 'zaalpes-operationList', '2017-07-11 17:09:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2620, 'cpignol', 'zaalpes-operationChange', '2017-07-11 17:09:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2621, 'cpignol', 'zaalpes-operationChange', '2017-07-11 17:09:35', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2622, 'cpignol', 'zaalpes-operationWrite', '2017-07-11 17:14:59', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2623, 'cpignol', 'zaalpes-Operation-write', '2017-07-11 17:14:59', '3', '193.48.126.37');
INSERT INTO log VALUES (2624, 'cpignol', 'zaalpes-operationList', '2017-07-11 17:14:59', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2625, 'cpignol', 'zaalpes-sampleTypeList', '2017-07-11 17:15:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2626, 'cpignol', 'zaalpes-sampleTypeList', '2017-07-11 17:15:28', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2627, 'cpignol', 'zaalpes-sampleTypeChange', '2017-07-11 17:15:38', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2628, 'cpignol', 'zaalpes-sampleTypeWrite', '2017-07-11 17:16:02', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2629, 'cpignol', 'zaalpes-SampleType-write', '2017-07-11 17:16:02', '3', '193.48.126.37');
INSERT INTO log VALUES (2630, 'cpignol', 'zaalpes-sampleTypeList', '2017-07-11 17:16:02', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2631, 'cpignol', 'zaalpes-sampleTypeList', '2017-07-11 17:16:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2632, 'cpignol', 'zaalpes-sampleList', '2017-07-11 17:16:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2633, 'cpignol', 'zaalpes-operationList', '2017-07-11 17:17:45', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2634, 'cpignol', 'zaalpes-operationList', '2017-07-11 17:17:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2635, 'cpignol', 'zaalpes-operationChange', '2017-07-11 17:18:00', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2636, 'cpignol', 'zaalpes-operationChange', '2017-07-11 17:18:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2637, 'cpignol', 'zaalpes-operationWrite', '2017-07-11 17:22:22', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2638, 'cpignol', 'zaalpes-Operation-write', '2017-07-11 17:22:22', '3', '193.48.126.37');
INSERT INTO log VALUES (2639, 'cpignol', 'zaalpes-operationList', '2017-07-11 17:22:22', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2640, 'cpignol', 'zaalpes-operationList', '2017-07-11 17:22:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2641, 'cpignol', 'zaalpes-operationChange', '2017-07-11 17:22:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2642, 'cpignol', 'zaalpes-sampleTypeList', '2017-07-11 17:23:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2643, 'cpignol', 'zaalpes-sampleTypeList', '2017-07-11 17:23:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2644, 'cpignol', 'zaalpes-sampleTypeList', '2017-07-11 17:23:30', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2645, 'unknown', 'zaalpes-loginChangePassword', '2017-07-11 17:25:27', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2646, 'cpignol', 'zaalpes-sampleTypeList', '2017-07-11 17:25:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2647, 'cpignol', 'zaalpes-protocolList', '2017-07-11 17:27:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2648, 'cpignol', 'zaalpes-protocolList', '2017-07-11 17:27:15', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2649, 'cpignol', 'zaalpes-protocolChange', '2017-07-11 17:27:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2650, 'cpignol', 'zaalpes-protocolWrite', '2017-07-11 17:27:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2651, 'cpignol', 'zaalpes-Protocol-write', '2017-07-11 17:27:39', '1', '10.4.2.103');
INSERT INTO log VALUES (2652, 'cpignol', 'zaalpes-protocolList', '2017-07-11 17:27:43', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2653, 'cpignol', 'zaalpes-protocolList', '2017-07-11 17:27:47', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2654, 'cpignol', 'zaalpes-protocolList', '2017-07-11 17:27:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2655, 'cpignol', 'zaalpes-protocolList', '2017-07-11 17:27:52', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2656, 'cpignol', 'zaalpes-protocolFile', '2017-07-11 17:27:55', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2657, 'cpignol', 'zaalpes-protocolFile', '2017-07-11 17:27:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2658, 'cpignol', 'zaalpes-protocolChange', '2017-07-11 17:29:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2659, 'cpignol', 'zaalpes-protocolChange', '2017-07-11 17:29:20', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2660, 'cpignol', 'zaalpes-protocolList', '2017-07-11 17:29:54', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2661, 'cpignol', 'zaalpes-protocolWrite', '2017-07-11 17:30:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2662, 'cpignol', 'zaalpes-Protocol-write', '2017-07-11 17:30:00', '1', '10.4.2.103');
INSERT INTO log VALUES (2663, 'cpignol', 'zaalpes-protocolList', '2017-07-11 17:30:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2664, 'cpignol', 'zaalpes-protocolList', '2017-07-11 17:30:04', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2665, 'cpignol', 'zaalpes-sampleList', '2017-07-11 17:30:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2666, 'cpignol', 'zaalpes-objets', '2017-07-11 17:30:15', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2667, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 17:30:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2668, 'cpignol', 'zaalpes-sampleList', '2017-07-11 17:30:20', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2669, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 17:30:25', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2670, 'cpignol', 'zaalpes-sampleList', '2017-07-11 17:30:42', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2671, 'cpignol', 'zaalpes-objets', '2017-07-11 17:30:42', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2672, 'cpignol', 'zaalpes-protocolList', '2017-07-11 17:30:44', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2673, 'cpignol', 'zaalpes-protocolChange', '2017-07-11 17:30:59', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2674, 'cpignol', 'zaalpes-protocolList', '2017-07-11 17:36:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2675, 'cpignol', 'zaalpes-protocolChange', '2017-07-11 17:36:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2676, 'cpignol', 'zaalpes-protocolList', '2017-07-11 17:36:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2677, 'cpignol', 'zaalpes-protocolChange', '2017-07-11 17:37:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2678, 'cpignol', 'zaalpes-operationList', '2017-07-11 17:37:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2679, 'cpignol', 'zaalpes-operationChange', '2017-07-11 17:37:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2680, 'cpignol', 'zaalpes-operationList', '2017-07-11 17:37:13', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2681, 'cpignol', 'zaalpes-operationChange', '2017-07-11 17:37:16', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2682, 'cpignol', 'zaalpes-operationList', '2017-07-11 17:37:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2683, 'cpignol', 'zaalpes-operationChange', '2017-07-11 17:37:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2684, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 17:39:04', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2685, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 17:39:12', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2686, 'cpignol', 'zaalpes-sampleList', '2017-07-11 17:39:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2687, 'cpignol', 'zaalpes-metadataFormGetDetail', '2017-07-11 17:39:38', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2688, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 17:39:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2689, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 17:39:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2690, 'cpignol', 'zaalpes-metadataFormGetDetail', '2017-07-11 17:40:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2691, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 17:47:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2692, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 17:58:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2693, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 17:59:47', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2694, 'cpignol', 'zaalpes-metadataFormGetDetail', '2017-07-11 18:00:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2695, 'cpignol', 'zaalpes-projectList', '2017-07-11 18:00:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2696, 'cpignol', 'zaalpes-projectChange', '2017-07-11 18:00:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2697, 'cpignol', 'zaalpes-projectWrite', '2017-07-11 18:01:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2698, 'cpignol', 'zaalpes-Project-write', '2017-07-11 18:01:18', '2', '10.4.2.103');
INSERT INTO log VALUES (2699, 'cpignol', 'zaalpes-projectList', '2017-07-11 18:01:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2700, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 18:01:18', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2701, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 18:01:25', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2702, 'cpignol', 'zaalpes-sampleList', '2017-07-11 18:01:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2703, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 18:01:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2704, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 18:01:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2705, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 18:01:41', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2706, 'cpignol', 'zaalpes-sampleList', '2017-07-11 18:02:07', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2707, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 18:02:10', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2708, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 18:02:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2709, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 18:02:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2710, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 18:02:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2711, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 18:03:07', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2712, 'cpignol', 'zaalpes-loginChangePassword', '2017-07-11 18:03:14', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2713, 'cpignol', 'zaalpes-setlanguage', '2017-07-11 18:03:24', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2714, 'cpignol', 'zaalpes-default', '2017-07-11 18:03:24', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2715, 'cpignol', 'zaalpes-disconnect', '2017-07-11 18:03:27', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2716, 'unknown', 'zaalpes-connexion', '2017-07-11 18:03:34', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2717, 'cpignol', 'zaalpes-connexion', '2017-07-11 18:03:39', 'db-ok', '193.48.126.37');
INSERT INTO log VALUES (2718, 'cpignol', 'zaalpes-default', '2017-07-11 18:03:39', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2719, 'cpignol', 'zaalpes-sampleList', '2017-07-11 18:03:42', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2720, 'cpignol', 'zaalpes-objets', '2017-07-11 18:03:47', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2721, 'cpignol', 'zaalpes-sampleList', '2017-07-11 18:03:56', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2722, 'cpignol', 'zaalpes-sampleList', '2017-07-11 18:04:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2723, 'cpignol', 'zaalpes-sampleList', '2017-07-11 18:04:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2724, 'cpignol', 'zaalpes-sampleList', '2017-07-11 18:04:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2725, 'cpignol', 'zaalpes-sampleList', '2017-07-11 18:05:09', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2726, 'cpignol', 'zaalpes-sampleList', '2017-07-11 18:05:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2727, 'cpignol', 'zaalpes-sampleList', '2017-07-11 18:05:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2728, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 18:05:50', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2729, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 18:05:56', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2730, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 18:06:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2731, 'unknown', 'zaalpes-parametre', '2017-07-11 18:06:07', 'nologin', '193.48.126.37');
INSERT INTO log VALUES (2732, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 18:06:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2733, 'cpignol', 'zaalpes-metadataFormGetDetail', '2017-07-11 18:06:15', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2734, 'cpignol', 'zaalpes-metadataFormGetDetail', '2017-07-11 18:06:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2735, 'cpignol', 'zaalpes-sampleWrite', '2017-07-11 18:06:37', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2736, 'cpignol', 'zaalpes-Sample-write', '2017-07-11 18:06:37', '93', '193.48.126.37');
INSERT INTO log VALUES (2737, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 18:06:37', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2738, 'cpignol', 'zaalpes-sampleList', '2017-07-11 18:06:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2739, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 18:07:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2740, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 18:07:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2741, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 18:07:51', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2742, 'cpignol', 'zaalpes-metadataFormGetDetail', '2017-07-11 18:08:10', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2743, 'cpignol', 'zaalpes-metadataFormGetDetail', '2017-07-11 18:08:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2744, 'cpignol', 'zaalpes-sampleTypeList', '2017-07-11 18:08:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2745, 'cpignol', 'zaalpes-sampleTypeChange', '2017-07-11 18:08:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2746, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:09:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2747, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:09:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2748, 'cpignol', 'zaalpes-objets', '2017-07-11 18:09:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2749, 'cpignol', 'zaalpes-objets', '2017-07-11 18:09:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2750, 'cpignol', 'zaalpes-sampleList', '2017-07-11 18:09:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2751, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 18:09:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2752, 'cpignol', 'zaalpes-metadataFormGetDetail', '2017-07-11 18:09:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2753, 'cpignol', 'zaalpes-metadataFormGetDetail', '2017-07-11 18:10:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2754, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:10:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2755, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:10:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2756, 'cpignol', 'zaalpes-operationWrite', '2017-07-11 18:12:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2757, 'cpignol', 'zaalpes-Operation-write', '2017-07-11 18:12:10', '3', '10.4.2.103');
INSERT INTO log VALUES (2758, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:12:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2759, 'cpignol', 'zaalpes-sampleList', '2017-07-11 18:12:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2760, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 18:12:18', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2761, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 18:12:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2762, 'cpignol', 'zaalpes-metadataFormGetDetail', '2017-07-11 18:12:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2763, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:12:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2764, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:12:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2765, 'cpignol', 'zaalpes-parametre', '2017-07-11 18:20:36', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2766, 'cpignol', 'zaalpes-sampleChange', '2017-07-11 18:20:39', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2767, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:21:16', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2768, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:21:20', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2769, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:21:27', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2770, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:30:51', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2771, 'cpignol', 'zaalpes-operationWrite', '2017-07-11 18:32:01', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2772, 'cpignol', 'zaalpes-Operation-write', '2017-07-11 18:32:01', '4', '193.48.126.37');
INSERT INTO log VALUES (2773, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:32:01', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2774, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:32:10', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2775, 'cpignol', 'zaalpes-operationWrite', '2017-07-11 18:32:53', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2776, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:32:53', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2777, 'cpignol', 'zaalpes-sampleList', '2017-07-11 18:33:01', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2778, 'cpignol', 'zaalpes-sampleList', '2017-07-11 18:33:16', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2779, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 18:33:26', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2780, 'cpignol', 'zaalpes-sampleDisplay', '2017-07-11 18:33:38', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2781, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:34:22', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2782, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:34:29', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2783, 'cpignol', 'zaalpes-operationWrite', '2017-07-11 18:34:46', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2784, 'cpignol', 'zaalpes-Operation-write', '2017-07-11 18:34:46', '4', '193.48.126.37');
INSERT INTO log VALUES (2785, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:34:46', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2786, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:34:53', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2787, 'cpignol', 'zaalpes-operationWrite', '2017-07-11 18:35:06', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2788, 'cpignol', 'zaalpes-Operation-write', '2017-07-11 18:35:06', '3', '193.48.126.37');
INSERT INTO log VALUES (2789, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:35:06', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2790, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:35:16', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2791, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:35:24', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2792, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:35:38', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2793, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:35:57', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2794, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:36:06', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2795, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:36:09', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2796, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:36:26', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2797, 'cpignol', 'zaalpes-operationWrite', '2017-07-11 18:37:36', 'errorbefore', '193.48.126.37');
INSERT INTO log VALUES (2798, 'cpignol', 'zaalpes-errorbefore', '2017-07-11 18:37:36', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2799, 'cpignol', 'zaalpes-parametre', '2017-07-11 18:37:40', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2800, 'cpignol', 'zaalpes-parametre', '2017-07-11 18:37:44', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2801, 'cpignol', 'zaalpes-parametre', '2017-07-11 18:37:46', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2802, 'cpignol', 'zaalpes-disconnect', '2017-07-11 18:37:51', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2803, 'unknown', 'zaalpes-connexion', '2017-07-11 18:37:55', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2804, 'cpignol', 'zaalpes-connexion', '2017-07-11 18:37:58', 'db-ok', '193.48.126.37');
INSERT INTO log VALUES (2805, 'cpignol', 'zaalpes-default', '2017-07-11 18:37:58', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2806, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:38:04', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2807, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:38:27', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2808, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:38:35', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2809, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:38:57', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2810, 'cpignol', 'zaalpes-operationWrite', '2017-07-11 18:39:44', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2811, 'cpignol', 'zaalpes-Operation-write', '2017-07-11 18:39:44', '5', '193.48.126.37');
INSERT INTO log VALUES (2812, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:39:44', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2813, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:40:45', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2814, 'cpignol', 'zaalpes-operationWrite', '2017-07-11 18:51:10', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2815, 'cpignol', 'zaalpes-Operation-write', '2017-07-11 18:51:10', '6', '193.48.126.37');
INSERT INTO log VALUES (2816, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:51:10', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2817, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:51:12', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2818, 'cpignol', 'zaalpes-operationWrite', '2017-07-11 18:51:37', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2819, 'cpignol', 'zaalpes-Operation-write', '2017-07-11 18:51:37', '7', '193.48.126.37');
INSERT INTO log VALUES (2820, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:51:37', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2821, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:51:52', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2822, 'cpignol', 'zaalpes-operationWrite', '2017-07-11 18:51:58', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2823, 'cpignol', 'zaalpes-operationWrite', '2017-07-11 18:52:06', 'errorbefore', '193.48.126.37');
INSERT INTO log VALUES (2824, 'cpignol', 'zaalpes-errorbefore', '2017-07-11 18:52:06', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2825, 'cpignol', 'zaalpes-parametre', '2017-07-11 18:52:09', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2826, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:52:13', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2827, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:52:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2828, 'cpignol', 'zaalpes-operationWrite', '2017-07-11 18:52:33', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2829, 'cpignol', 'zaalpes-operationChange', '2017-07-11 18:52:52', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2830, 'cpignol', 'zaalpes-operationList', '2017-07-11 18:53:05', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2831, 'cpignol', 'zaalpes-protocolList', '2017-07-11 18:54:37', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2832, 'cpignol', 'zaalpes-protocolChange', '2017-07-11 18:54:40', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2833, 'cpignol', 'zaalpes-protocolWrite', '2017-07-11 18:55:09', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2834, 'cpignol', 'zaalpes-Protocol-write', '2017-07-11 18:55:09', '2', '193.48.126.37');
INSERT INTO log VALUES (2835, 'cpignol', 'zaalpes-protocolList', '2017-07-11 18:55:16', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2836, 'cpignol', 'zaalpes-protocolFile', '2017-07-11 18:55:38', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2837, 'cpignol', 'zaalpes-protocolChange', '2017-07-11 18:57:06', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2838, 'cpignol', 'zaalpes-protocolWrite', '2017-07-11 18:57:15', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2839, 'cpignol', 'zaalpes-Protocol-write', '2017-07-11 18:57:15', '2', '193.48.126.37');
INSERT INTO log VALUES (2840, 'cpignol', 'zaalpes-protocolList', '2017-07-11 18:57:22', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2841, 'cpignol', 'zaalpes-protocolFile', '2017-07-11 18:59:37', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2842, 'cpignol', 'zaalpes-protocolChange', '2017-07-11 18:59:39', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2843, 'cpignol', 'zaalpes-protocolWrite', '2017-07-11 18:59:55', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2844, 'cpignol', 'zaalpes-Protocol-write', '2017-07-11 18:59:55', '1', '193.48.126.37');
INSERT INTO log VALUES (2845, 'cpignol', 'zaalpes-protocolList', '2017-07-11 19:00:02', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2846, 'cpignol', 'zaalpes-operationList', '2017-07-11 19:00:22', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2847, 'unknown', 'zaalpes-operationChange', '2017-07-12 16:24:16', 'nologin', '193.48.126.37');
INSERT INTO log VALUES (2848, 'cpignol', 'zaalpes-connexion', '2017-07-12 16:24:19', 'db-ok', '193.48.126.37');
INSERT INTO log VALUES (2849, 'cpignol', 'zaalpes-operationChange', '2017-07-12 16:24:19', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2850, 'cpignol', 'zaalpes-parametre', '2017-07-12 16:24:30', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2851, 'cpignol', 'zaalpes-operationList', '2017-07-12 16:24:36', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2852, 'cpignol', 'zaalpes-operationChange', '2017-07-12 16:24:40', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2853, 'cpignol', 'zaalpes-operationList', '2017-07-12 16:24:59', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2854, 'cpignol', 'zaalpes-operationChange', '2017-07-12 16:25:06', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2855, 'cpignol', 'zaalpes-operationWrite', '2017-07-12 16:51:54', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2856, 'cpignol', 'zaalpes-Operation-write', '2017-07-12 16:51:54', '5', '193.48.126.37');
INSERT INTO log VALUES (2857, 'cpignol', 'zaalpes-operationList', '2017-07-12 16:51:55', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2858, 'cpignol', 'zaalpes-operationChange', '2017-07-12 16:52:10', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2859, 'cpignol', 'zaalpes-operationWrite', '2017-07-12 16:52:33', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2860, 'cpignol', 'zaalpes-Operation-write', '2017-07-12 16:52:33', '7', '193.48.126.37');
INSERT INTO log VALUES (2861, 'cpignol', 'zaalpes-operationList', '2017-07-12 16:52:33', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2862, 'cpignol', 'zaalpes-operationChange', '2017-07-12 16:52:43', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2863, 'cpignol', 'zaalpes-operationChange', '2017-07-12 16:52:44', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2864, 'cpignol', 'zaalpes-operationWrite', '2017-07-12 16:52:52', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2865, 'cpignol', 'zaalpes-Operation-write', '2017-07-12 16:52:52', '7', '193.48.126.37');
INSERT INTO log VALUES (2866, 'cpignol', 'zaalpes-operationList', '2017-07-12 16:52:52', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2867, 'cpignol', 'zaalpes-operationChange', '2017-07-12 16:52:58', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2868, 'cpignol', 'zaalpes-operationList', '2017-07-12 16:53:11', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2869, 'cpignol', 'zaalpes-operationChange', '2017-07-12 16:54:28', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2870, 'cpignol', 'zaalpes-operationList', '2017-07-12 16:54:36', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2871, 'cpignol', 'zaalpes-operationChange', '2017-07-12 16:54:45', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2872, 'cpignol', 'zaalpes-operationList', '2017-07-12 16:54:50', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2873, 'cpignol', 'zaalpes-operationChange', '2017-07-12 16:54:54', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2874, 'cpignol', 'zaalpes-operationList', '2017-07-12 16:54:59', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2875, 'cpignol', 'zaalpes-operationChange', '2017-07-12 16:55:04', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2876, 'cpignol', 'zaalpes-operationList', '2017-07-12 16:55:08', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2877, 'cpignol', 'zaalpes-operationChange', '2017-07-12 16:55:12', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2878, 'cpignol', 'zaalpes-operationWrite', '2017-07-12 16:57:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2879, 'cpignol', 'zaalpes-Operation-write', '2017-07-12 16:57:17', '3', '193.48.126.37');
INSERT INTO log VALUES (2880, 'cpignol', 'zaalpes-operationList', '2017-07-12 16:57:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2881, 'cpignol', 'zaalpes-operationChange', '2017-07-12 16:57:26', 'ok', '193.48.126.37');
INSERT INTO log VALUES (2882, 'unknown', 'zaalpes-default', '2017-07-18 08:02:08', 'ok', '86.254.25.156');
INSERT INTO log VALUES (2883, 'unknown', 'zaalpes-connexion', '2017-07-18 08:02:22', 'ok', '86.254.25.156');
INSERT INTO log VALUES (2884, 'cpignol', 'zaalpes-connexion', '2017-07-18 08:02:38', 'db-ok', '86.254.25.156');
INSERT INTO log VALUES (2885, 'cpignol', 'zaalpes-default', '2017-07-18 08:02:38', 'ok', '86.254.25.156');
INSERT INTO log VALUES (2886, 'cpignol', 'zaalpes-containerList', '2017-07-18 08:02:43', 'ok', '86.254.25.156');
INSERT INTO log VALUES (2887, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-07-18 08:02:44', 'ok', '86.254.25.156');
INSERT INTO log VALUES (2888, 'cpignol', 'zaalpes-containerList', '2017-07-18 08:02:46', 'ok', '86.254.25.156');
INSERT INTO log VALUES (2889, 'cpignol', 'zaalpes-containerTypeGetFromFamily', '2017-07-18 08:02:47', 'ok', '86.254.25.156');
INSERT INTO log VALUES (2890, 'cpignol', 'zaalpes-sampleList', '2017-07-18 08:03:08', 'ok', '86.254.25.156');
INSERT INTO log VALUES (2891, 'cpignol', 'zaalpes-sampleList', '2017-07-18 08:03:10', 'ok', '86.254.25.156');
INSERT INTO log VALUES (2892, 'cpignol', 'zaalpes-loginList', '2017-07-18 08:03:32', 'ok', '86.254.25.156');
INSERT INTO log VALUES (2893, 'cpignol', 'zaalpes-disconnect', '2017-07-18 08:10:09', 'ok', '86.254.25.156');
INSERT INTO log VALUES (2894, 'unknown', 'zaalpes-connexion', '2017-07-18 08:10:12', 'ok', '86.254.25.156');
INSERT INTO log VALUES (2895, 'admin', 'zaalpes-connexion', '2017-07-18 08:11:30', 'db-ko', '86.254.25.156');
INSERT INTO log VALUES (2896, 'unknown', 'zaalpes-default', '2017-07-18 08:11:30', 'ok', '86.254.25.156');
INSERT INTO log VALUES (2897, 'unknown', 'zaalpes-connexion', '2017-07-18 08:12:40', 'ok', '86.254.25.156');
INSERT INTO log VALUES (2898, 'admin', 'zaalpes-connexion', '2017-07-18 08:12:56', 'db-ok', '86.254.25.156');
INSERT INTO log VALUES (2899, 'admin', 'zaalpes-default', '2017-07-18 08:12:56', 'ok', '86.254.25.156');
INSERT INTO log VALUES (2900, 'admin', 'zaalpes-disconnect-ipaddress-changed', '2017-07-18 08:14:47', 'old:86.254.25.156-new:10.5.5.50', '10.5.5.50');
INSERT INTO log VALUES (2901, 'admin', 'zaalpes-default-connexion', '2017-07-18 08:14:47', 'token-ok', '10.5.5.50');
INSERT INTO log VALUES (2902, 'admin', 'zaalpes-default', '2017-07-18 08:14:47', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2903, 'admin', 'zaalpes-loginList-connexion', '2017-07-18 08:28:09', 'token-ok', '10.5.5.50');
INSERT INTO log VALUES (2904, 'admin', 'zaalpes-loginList', '2017-07-18 08:28:09', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2905, 'admin', 'zaalpes-loginChange', '2017-07-18 08:28:49', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2906, 'admin', 'zaalpes-loginWrite', '2017-07-18 08:30:21', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2907, 'admin', 'zaalpes-LoginGestion-write', '2017-07-18 08:30:21', '9', '10.5.5.50');
INSERT INTO log VALUES (2908, 'admin', 'zaalpes-loginList', '2017-07-18 08:30:21', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2909, 'admin', 'zaalpes-loginChange', '2017-07-18 08:30:34', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2910, 'admin', 'zaalpes-loginWrite', '2017-07-18 08:32:21', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2911, 'admin', 'zaalpes-LoginGestion-write', '2017-07-18 08:32:21', '10', '10.5.5.50');
INSERT INTO log VALUES (2912, 'admin', 'zaalpes-loginList', '2017-07-18 08:32:21', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2913, 'admin', 'zaalpes-loginChange', '2017-07-18 08:32:41', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2914, 'admin', 'zaalpes-loginWrite', '2017-07-18 08:33:35', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2915, 'admin', 'zaalpes-LoginGestion-write', '2017-07-18 08:33:35', '11', '10.5.5.50');
INSERT INTO log VALUES (2916, 'admin', 'zaalpes-loginList', '2017-07-18 08:33:35', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2917, 'admin', 'zaalpes-appliList', '2017-07-18 08:33:38', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2918, 'admin', 'zaalpes-appliChange', '2017-07-18 08:33:59', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2919, 'admin', 'zaalpes-appliList', '2017-07-18 08:34:05', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2920, 'admin', 'zaalpes-appliDisplay', '2017-07-18 08:34:08', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2921, 'admin', 'zaalpes-appliList', '2017-07-18 08:34:11', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2922, 'admin', 'zaalpes-appliChange', '2017-07-18 08:34:14', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2923, 'admin', 'zaalpes-appliWrite', '2017-07-18 08:34:24', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2924, 'admin', 'zaalpes-Aclappli-write', '2017-07-18 08:34:24', '4', '10.5.5.50');
INSERT INTO log VALUES (2925, 'admin', 'zaalpes-appliDisplay', '2017-07-18 08:34:24', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2926, 'admin', 'zaalpes-appliChange', '2017-07-18 08:34:27', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2927, 'admin', 'zaalpes-appliWrite', '2017-07-18 08:34:37', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2928, 'admin', 'zaalpes-Aclappli-write', '2017-07-18 08:34:37', '4', '10.5.5.50');
INSERT INTO log VALUES (2929, 'admin', 'zaalpes-appliDisplay', '2017-07-18 08:34:37', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2930, 'admin', 'zaalpes-appliList', '2017-07-18 08:34:44', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2931, 'admin', 'zaalpes-appliDisplay', '2017-07-18 08:48:06', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2932, 'admin', 'zapvs-disconnect', '2017-07-18 08:48:54', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2933, 'unknown', 'zapvs-connexion', '2017-07-18 08:48:58', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2934, 'admin', 'zapvs-connexion', '2017-07-18 08:49:08', 'db-ok', '10.5.5.50');
INSERT INTO log VALUES (2935, 'admin', 'zapvs-default', '2017-07-18 08:49:08', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2936, 'admin', 'zapvs-default', '2017-07-18 08:53:44', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2937, 'admin', 'zapvs-disconnect', '2017-07-18 08:53:46', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2938, 'unknown', 'zapvs-connexion', '2017-07-18 08:53:48', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2939, 'admin', 'zapvs-connexion', '2017-07-18 08:54:01', 'db-ok', '10.5.5.50');
INSERT INTO log VALUES (2940, 'admin', 'zapvs-default', '2017-07-18 08:54:01', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2941, 'admin', 'zapvs-appliList', '2017-07-18 08:54:08', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2942, 'admin', 'zapvs-appliDisplay', '2017-07-18 08:54:11', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2943, 'admin', 'zapvs-acoChange', '2017-07-18 08:54:14', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2944, 'admin', 'zapvs-appliDisplay', '2017-07-18 08:54:21', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2945, 'admin', 'zapvs-acoChange', '2017-07-18 08:54:23', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2946, 'admin', 'zapvs-acoWrite', '2017-07-18 08:54:27', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2947, 'admin', 'zapvs-Aclaco-write', '2017-07-18 08:54:27', '17', '10.5.5.50');
INSERT INTO log VALUES (2948, 'admin', 'zapvs-appliDisplay', '2017-07-18 08:54:27', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2949, 'admin', 'zapvs-acoChange', '2017-07-18 08:54:34', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2950, 'admin', 'zapvs-acoWrite', '2017-07-18 08:54:37', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2951, 'admin', 'zapvs-Aclaco-write', '2017-07-18 08:54:37', '18', '10.5.5.50');
INSERT INTO log VALUES (2952, 'admin', 'zapvs-appliDisplay', '2017-07-18 08:54:37', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2953, 'admin', 'zapvs-acoChange', '2017-07-18 08:54:41', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2954, 'admin', 'zapvs-acoWrite', '2017-07-18 08:54:44', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2955, 'admin', 'zapvs-Aclaco-write', '2017-07-18 08:54:44', '19', '10.5.5.50');
INSERT INTO log VALUES (2956, 'admin', 'zapvs-appliDisplay', '2017-07-18 08:54:44', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2957, 'admin', 'zapvs-acoChange', '2017-07-18 08:54:49', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2958, 'admin', 'zapvs-acoWrite', '2017-07-18 08:54:52', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2959, 'admin', 'zapvs-Aclaco-write', '2017-07-18 08:54:52', '20', '10.5.5.50');
INSERT INTO log VALUES (2960, 'admin', 'zapvs-appliDisplay', '2017-07-18 08:54:52', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2961, 'admin', 'zapvs-groupList', '2017-07-18 08:55:08', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2962, 'admin', 'zapvs-groupChange', '2017-07-18 08:55:25', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2963, 'admin', 'zapvs-groupList', '2017-07-18 08:55:30', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2964, 'admin', 'zapvs-groupChange', '2017-07-18 08:56:16', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2965, 'admin', 'zapvs-groupWrite', '2017-07-18 08:56:34', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2966, 'admin', 'zapvs-Aclgroup-write', '2017-07-18 08:56:34', '33', '10.5.5.50');
INSERT INTO log VALUES (2967, 'admin', 'zapvs-groupList', '2017-07-18 08:56:34', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2968, 'admin', 'zapvs-groupChange', '2017-07-18 08:56:37', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2969, 'admin', 'zapvs-groupWrite', '2017-07-18 08:56:44', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2970, 'admin', 'zapvs-Aclgroup-write', '2017-07-18 08:56:44', '33', '10.5.5.50');
INSERT INTO log VALUES (2971, 'admin', 'zapvs-groupList', '2017-07-18 08:56:44', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2972, 'admin', 'zapvs-appliList', '2017-07-18 08:57:15', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2973, 'admin', 'zapvs-appliDisplay', '2017-07-18 08:57:17', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2974, 'admin', 'zapvs-acoChange', '2017-07-18 08:57:20', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2975, 'admin', 'zapvs-appliDisplay', '2017-07-18 08:57:41', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2976, 'admin', 'zapvs-acoChange', '2017-07-18 08:57:43', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2977, 'admin', 'zapvs-groupList', '2017-07-18 08:57:51', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2978, 'admin', 'zapvs-groupChange', '2017-07-18 08:57:56', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2979, 'admin', 'zapvs-groupWrite', '2017-07-18 08:58:15', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2980, 'admin', 'zapvs-Aclgroup-write', '2017-07-18 08:58:15', '34', '10.5.5.50');
INSERT INTO log VALUES (2981, 'admin', 'zapvs-groupList', '2017-07-18 08:58:15', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2982, 'admin', 'zapvs-appliList', '2017-07-18 08:58:30', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2983, 'admin', 'zapvs-appliDisplay', '2017-07-18 08:58:32', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2984, 'admin', 'zapvs-acoChange', '2017-07-18 08:58:34', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2985, 'admin', 'zapvs-acoWrite', '2017-07-18 08:58:49', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2986, 'admin', 'zapvs-Aclaco-write', '2017-07-18 08:58:49', '16', '10.5.5.50');
INSERT INTO log VALUES (2987, 'admin', 'zapvs-appliDisplay', '2017-07-18 08:58:49', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2988, 'admin', 'zapvs-acoChange', '2017-07-18 08:58:57', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2989, 'admin', 'zapvs-acoWrite', '2017-07-18 08:59:01', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2990, 'admin', 'zapvs-Aclaco-write', '2017-07-18 08:59:01', '17', '10.5.5.50');
INSERT INTO log VALUES (2991, 'admin', 'zapvs-appliDisplay', '2017-07-18 08:59:01', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2992, 'admin', 'zapvs-acoChange', '2017-07-18 08:59:04', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2993, 'admin', 'zapvs-acoWrite', '2017-07-18 08:59:07', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2994, 'admin', 'zapvs-Aclaco-write', '2017-07-18 08:59:07', '18', '10.5.5.50');
INSERT INTO log VALUES (2995, 'admin', 'zapvs-appliDisplay', '2017-07-18 08:59:07', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2996, 'admin', 'zapvs-acoChange', '2017-07-18 08:59:10', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2997, 'admin', 'zapvs-acoWrite', '2017-07-18 08:59:12', 'ok', '10.5.5.50');
INSERT INTO log VALUES (2998, 'admin', 'zapvs-Aclaco-write', '2017-07-18 08:59:12', '19', '10.5.5.50');
INSERT INTO log VALUES (2999, 'admin', 'zapvs-appliDisplay', '2017-07-18 08:59:12', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3000, 'admin', 'zapvs-acoChange', '2017-07-18 08:59:14', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3001, 'admin', 'zapvs-acoWrite', '2017-07-18 08:59:17', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3002, 'admin', 'zapvs-Aclaco-write', '2017-07-18 08:59:17', '20', '10.5.5.50');
INSERT INTO log VALUES (3003, 'admin', 'zapvs-appliDisplay', '2017-07-18 08:59:17', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3004, 'admin', 'zapvs-disconnect', '2017-07-18 08:59:23', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3005, 'unknown', 'zapvs-connexion', '2017-07-18 08:59:25', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3006, 'admin', 'zapvs-connexion', '2017-07-18 08:59:32', 'db-ok', '10.5.5.50');
INSERT INTO log VALUES (3007, 'admin', 'zapvs-default', '2017-07-18 08:59:32', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3008, 'admin', 'zapvs-disconnect', '2017-07-18 08:59:39', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3009, 'unknown', 'zapvs-connexion', '2017-07-18 08:59:42', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3010, 'vbretagnolle', 'zapvs-connexion', '2017-07-18 09:00:08', 'db-ok', '10.5.5.50');
INSERT INTO log VALUES (3011, 'vbretagnolle', 'zapvs-default', '2017-07-18 09:00:08', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3012, 'vbretagnolle', 'zapvs-projectList', '2017-07-18 09:00:27', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3013, 'vbretagnolle', 'zapvs-projectChange', '2017-07-18 09:00:32', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3014, 'vbretagnolle', 'zapvs-projectWrite', '2017-07-18 09:00:47', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3015, 'vbretagnolle', 'zapvs-Project-write', '2017-07-18 09:00:47', '1', '10.5.5.50');
INSERT INTO log VALUES (3016, 'vbretagnolle', 'zapvs-projectList', '2017-07-18 09:00:47', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3017, 'vbretagnolle', 'zapvs-protocolList', '2017-07-18 09:00:59', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3018, 'vbretagnolle', 'zapvs-protocolChange', '2017-07-18 09:01:02', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3019, 'vbretagnolle', 'zapvs-protocolWrite', '2017-07-18 09:01:20', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3020, 'vbretagnolle', 'zapvs-Protocol-write', '2017-07-18 09:01:20', '1', '10.5.5.50');
INSERT INTO log VALUES (3021, 'vbretagnolle', 'zapvs-protocolList', '2017-07-18 09:01:20', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3022, 'vbretagnolle', 'zapvs-operationList', '2017-07-18 09:01:24', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3023, 'vbretagnolle', 'zapvs-operationChange', '2017-07-18 09:01:33', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3024, 'vbretagnolle', 'zapvs-operationWrite', '2017-07-18 09:03:23', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3025, 'vbretagnolle', 'zapvs-Operation-write', '2017-07-18 09:03:23', '1', '10.5.5.50');
INSERT INTO log VALUES (3026, 'vbretagnolle', 'zapvs-operationList', '2017-07-18 09:03:23', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3027, 'vbretagnolle', 'zapvs-operationChange', '2017-07-18 09:03:30', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3028, 'vbretagnolle', 'zapvs-operationWrite', '2017-07-18 09:08:20', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3029, 'vbretagnolle', 'zapvs-Operation-write', '2017-07-18 09:08:20', '1', '10.5.5.50');
INSERT INTO log VALUES (3030, 'vbretagnolle', 'zapvs-operationList', '2017-07-18 09:08:20', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3031, 'vbretagnolle', 'zapvs-operationChange', '2017-07-18 09:08:22', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3032, 'vbretagnolle', 'zapvs-operationWrite', '2017-07-18 09:09:25', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3033, 'vbretagnolle', 'zapvs-Operation-write', '2017-07-18 09:09:25', '1', '10.5.5.50');
INSERT INTO log VALUES (3034, 'vbretagnolle', 'zapvs-operationList', '2017-07-18 09:09:25', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3035, 'vbretagnolle', 'zapvs-labelChange', '2017-07-18 09:09:58', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3036, 'vbretagnolle', 'zapvs-labelWrite', '2017-07-18 09:17:41', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3037, 'vbretagnolle', 'zapvs-Label-write', '2017-07-18 09:17:41', '2', '10.5.5.50');
INSERT INTO log VALUES (3038, 'vbretagnolle', 'zapvs-labelList', '2017-07-18 09:17:41', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3039, 'vbretagnolle', 'zapvs-operationList', '2017-07-18 09:17:50', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3040, 'vbretagnolle', 'zapvs-operationChange', '2017-07-18 09:17:53', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3041, 'vbretagnolle', 'zapvs-operationWrite', '2017-07-18 09:19:14', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3042, 'vbretagnolle', 'zapvs-Operation-write', '2017-07-18 09:19:14', '1', '10.5.5.50');
INSERT INTO log VALUES (3043, 'vbretagnolle', 'zapvs-operationList', '2017-07-18 09:19:14', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3044, 'vbretagnolle', 'zapvs-containerTypeList', '2017-07-18 09:19:37', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3045, 'vbretagnolle', 'zapvs-containerTypeChange', '2017-07-18 09:19:50', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3046, 'vbretagnolle', 'zapvs-containerTypeWrite', '2017-07-18 09:20:20', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3047, 'vbretagnolle', 'zapvs-ContainerType-write', '2017-07-18 09:20:20', '6', '10.5.5.50');
INSERT INTO log VALUES (3048, 'vbretagnolle', 'zapvs-containerTypeList', '2017-07-18 09:20:20', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3049, 'vbretagnolle', 'zapvs-containerTypeChange', '2017-07-18 09:20:26', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3050, 'vbretagnolle', 'zapvs-containerTypeWrite', '2017-07-18 09:21:08', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3051, 'vbretagnolle', 'zapvs-ContainerType-write', '2017-07-18 09:21:08', '7', '10.5.5.50');
INSERT INTO log VALUES (3052, 'vbretagnolle', 'zapvs-containerTypeList', '2017-07-18 09:21:08', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3053, 'vbretagnolle', 'zapvs-containerTypeChange', '2017-07-18 09:21:12', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3054, 'vbretagnolle', 'zapvs-containerTypeWrite', '2017-07-18 09:21:56', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3055, 'vbretagnolle', 'zapvs-ContainerType-write', '2017-07-18 09:21:56', '8', '10.5.5.50');
INSERT INTO log VALUES (3056, 'vbretagnolle', 'zapvs-containerTypeList', '2017-07-18 09:21:56', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3057, 'vbretagnolle', 'zapvs-sampleList', '2017-07-18 09:23:57', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3058, 'vbretagnolle', 'zapvs-sampleChange', '2017-07-18 09:24:00', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3059, 'vbretagnolle', 'zapvs-sampleTypeList', '2017-07-18 09:24:44', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3060, 'vbretagnolle', 'zapvs-sampleTypeChange', '2017-07-18 09:24:46', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3061, 'vbretagnolle', 'zapvs-containerTypeList', '2017-07-18 09:25:14', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3062, 'vbretagnolle', 'zapvs-containerTypeChange', '2017-07-18 09:25:20', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3063, 'vbretagnolle', 'zapvs-containerTypeWrite', '2017-07-18 09:25:40', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3064, 'vbretagnolle', 'zapvs-ContainerType-write', '2017-07-18 09:25:40', '9', '10.5.5.50');
INSERT INTO log VALUES (3065, 'vbretagnolle', 'zapvs-containerTypeList', '2017-07-18 09:25:40', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3066, 'vbretagnolle', 'zapvs-sampleTypeList', '2017-07-18 09:33:29', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3067, 'vbretagnolle', 'zapvs-sampleTypeChange', '2017-07-18 09:33:32', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3068, 'vbretagnolle', 'zapvs-sampleTypeWrite', '2017-07-18 09:34:04', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3069, 'vbretagnolle', 'zapvs-SampleType-write', '2017-07-18 09:34:04', '1', '10.5.5.50');
INSERT INTO log VALUES (3070, 'vbretagnolle', 'zapvs-sampleTypeList', '2017-07-18 09:34:04', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3071, 'vbretagnolle', 'zapvs-operationList', '2017-07-18 09:34:11', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3072, 'vbretagnolle', 'zapvs-operationChange', '2017-07-18 09:34:15', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3073, 'vbretagnolle', 'zapvs-operationWrite', '2017-07-18 09:35:01', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3074, 'vbretagnolle', 'zapvs-Operation-write', '2017-07-18 09:35:01', '1', '10.5.5.50');
INSERT INTO log VALUES (3075, 'vbretagnolle', 'zapvs-operationList', '2017-07-18 09:35:01', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3076, 'vbretagnolle', 'zapvs-labelList', '2017-07-18 09:35:10', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3077, 'vbretagnolle', 'zapvs-labelChange', '2017-07-18 09:35:16', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3078, 'vbretagnolle', 'zapvs-labelWrite', '2017-07-18 09:35:40', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3079, 'vbretagnolle', 'zapvs-Label-write', '2017-07-18 09:35:40', '2', '10.5.5.50');
INSERT INTO log VALUES (3080, 'vbretagnolle', 'zapvs-labelList', '2017-07-18 09:35:40', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3081, 'vbretagnolle', 'zapvs-labelChange', '2017-07-18 09:35:44', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3082, 'vbretagnolle', 'zapvs-labelWrite', '2017-07-18 09:35:56', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3083, 'vbretagnolle', 'zapvs-Label-write', '2017-07-18 09:35:56', '2', '10.5.5.50');
INSERT INTO log VALUES (3084, 'vbretagnolle', 'zapvs-labelList', '2017-07-18 09:35:56', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3085, 'vbretagnolle', 'zapvs-sampleList', '2017-07-18 09:36:01', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3086, 'vbretagnolle', 'zapvs-sampleChange', '2017-07-18 09:36:03', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3087, 'vbretagnolle', 'zapvs-metadataFormGetDetail', '2017-07-18 09:36:22', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3088, 'vbretagnolle', 'zapvs-operationList', '2017-07-18 09:36:57', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3089, 'vbretagnolle', 'zapvs-operationChange', '2017-07-18 09:37:04', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3090, 'vbretagnolle', 'zapvs-operationWrite', '2017-07-18 09:38:27', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3091, 'vbretagnolle', 'zapvs-Operation-write', '2017-07-18 09:38:27', '1', '10.5.5.50');
INSERT INTO log VALUES (3092, 'vbretagnolle', 'zapvs-operationList', '2017-07-18 09:38:27', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3093, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:38:44', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3094, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:39:41', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3095, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:39:42', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3096, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:39:45', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3097, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:39:59', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3098, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:39:59', '1', '10.5.5.50');
INSERT INTO log VALUES (3099, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:39:59', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3100, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:40:01', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3101, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:40:12', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3102, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:40:12', '2', '10.5.5.50');
INSERT INTO log VALUES (3103, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:40:12', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3104, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:40:14', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3105, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:40:25', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3106, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:40:25', '3', '10.5.5.50');
INSERT INTO log VALUES (3107, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:40:25', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3108, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:40:27', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3109, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:40:35', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3110, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:40:35', '4', '10.5.5.50');
INSERT INTO log VALUES (3111, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:40:35', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3112, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:40:37', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3113, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:40:44', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3114, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:40:44', '5', '10.5.5.50');
INSERT INTO log VALUES (3115, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:40:44', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3116, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:40:46', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3117, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:40:58', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3118, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:40:58', '6', '10.5.5.50');
INSERT INTO log VALUES (3119, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:40:58', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3120, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:41:01', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3121, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:41:06', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3122, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:41:06', '7', '10.5.5.50');
INSERT INTO log VALUES (3123, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:41:06', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3124, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:41:08', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3125, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:41:15', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3126, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:41:15', '8', '10.5.5.50');
INSERT INTO log VALUES (3127, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:41:15', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3128, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:41:26', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3129, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:41:31', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3130, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:41:31', '9', '10.5.5.50');
INSERT INTO log VALUES (3131, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:41:31', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3132, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:41:44', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3133, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:41:52', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3134, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:41:52', '10', '10.5.5.50');
INSERT INTO log VALUES (3135, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:41:52', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3136, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:41:55', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3137, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:41:59', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3138, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:41:59', '10', '10.5.5.50');
INSERT INTO log VALUES (3139, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:41:59', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3140, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:42:09', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3141, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:42:13', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3142, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:42:13', '11', '10.5.5.50');
INSERT INTO log VALUES (3143, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:42:13', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3144, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:42:16', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3145, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:42:21', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3146, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:42:21', '9', '10.5.5.50');
INSERT INTO log VALUES (3147, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:42:21', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3148, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:42:25', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3149, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:42:29', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3150, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:42:29', '12', '10.5.5.50');
INSERT INTO log VALUES (3151, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:42:29', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3152, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:42:37', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3153, 'vbretagnolle', 'zapvs-samplingPlaceDelete', '2017-07-18 09:42:41', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3154, 'vbretagnolle', 'zapvs-SamplingPlace-delete', '2017-07-18 09:42:41', '12', '10.5.5.50');
INSERT INTO log VALUES (3155, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:42:41', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3156, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:42:47', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3157, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:42:59', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3158, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:42:59', '1', '10.5.5.50');
INSERT INTO log VALUES (3159, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:42:59', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3160, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:43:02', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3161, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:43:07', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3162, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:43:07', '2', '10.5.5.50');
INSERT INTO log VALUES (3163, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:43:07', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3164, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:43:09', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3165, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:43:13', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3166, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:43:13', '3', '10.5.5.50');
INSERT INTO log VALUES (3167, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:43:13', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3168, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:43:15', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3169, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:43:26', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3170, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:43:26', '5', '10.5.5.50');
INSERT INTO log VALUES (3171, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:43:26', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3172, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:43:29', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3173, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:43:33', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3174, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:43:33', '4', '10.5.5.50');
INSERT INTO log VALUES (3175, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:43:33', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3176, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:43:35', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3177, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:43:42', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3178, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:43:42', '6', '10.5.5.50');
INSERT INTO log VALUES (3179, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:43:42', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3180, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:43:49', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3181, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:43:55', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3182, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:43:55', '7', '10.5.5.50');
INSERT INTO log VALUES (3183, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:43:55', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3184, 'vbretagnolle', 'zapvs-samplingPlaceChange', '2017-07-18 09:43:57', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3185, 'vbretagnolle', 'zapvs-samplingPlaceWrite', '2017-07-18 09:44:01', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3186, 'vbretagnolle', 'zapvs-SamplingPlace-write', '2017-07-18 09:44:01', '8', '10.5.5.50');
INSERT INTO log VALUES (3187, 'vbretagnolle', 'zapvs-samplingPlaceList', '2017-07-18 09:44:01', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3188, 'vbretagnolle', 'zapvs-sampleList', '2017-07-18 09:44:11', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3189, 'vbretagnolle', 'zapvs-sampleList', '2017-07-18 09:44:16', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3190, 'vbretagnolle', 'zapvs-sampleChange', '2017-07-18 09:44:20', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3191, 'vbretagnolle', 'zapvs-metadataFormGetDetail', '2017-07-18 09:44:53', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3192, 'vbretagnolle', 'zapvs-sampleWrite', '2017-07-18 09:46:20', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3193, 'vbretagnolle', 'zapvs-Sample-write', '2017-07-18 09:46:20', '1', '10.5.5.50');
INSERT INTO log VALUES (3194, 'vbretagnolle', 'zapvs-sampleDisplay', '2017-07-18 09:46:20', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3195, 'vbretagnolle', 'zapvs-sampleList', '2017-07-18 09:46:36', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3196, 'vbretagnolle', 'zapvs-samplePrintLabel', '2017-07-18 09:46:40', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3197, 'vbretagnolle', 'zapvs-sampleList', '2017-07-18 09:46:40', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3198, 'vbretagnolle', 'zapvs-samplePrintLabel', '2017-07-18 09:46:47', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3199, 'vbretagnolle', 'zapvs-samplePrintLabel', '2017-07-18 09:47:27', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3200, 'vbretagnolle', 'zapvs-sampleList', '2017-07-18 09:47:27', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3201, 'vbretagnolle', 'zapvs-labelList', '2017-07-18 09:47:38', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3202, 'vbretagnolle', 'zapvs-labelChange', '2017-07-18 09:47:42', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3203, 'vbretagnolle', 'zapvs-labelWrite', '2017-07-18 09:48:33', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3204, 'vbretagnolle', 'zapvs-Label-write', '2017-07-18 09:48:33', '2', '10.5.5.50');
INSERT INTO log VALUES (3205, 'vbretagnolle', 'zapvs-labelList', '2017-07-18 09:48:33', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3206, 'vbretagnolle', 'zapvs-sampleList', '2017-07-18 09:48:38', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3207, 'vbretagnolle', 'zapvs-samplePrintLabel', '2017-07-18 09:48:41', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3208, 'vbretagnolle', 'zapvs-sampleList', '2017-07-18 09:48:41', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3209, 'vbretagnolle', 'zapvs-samplePrintLabel', '2017-07-18 09:48:47', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3210, 'vbretagnolle', 'zapvs-samplePrintLabel', '2017-07-18 09:48:58', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3211, 'vbretagnolle', 'zapvs-sampleList', '2017-07-18 09:48:58', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3212, 'vbretagnolle', 'zapvs-disconnect', '2017-07-18 09:54:18', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3213, 'unknown', 'zapvs-connexion', '2017-07-18 09:54:25', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3214, 'mroncoroni', 'zapvs-connexion', '2017-07-18 09:55:01', 'db-ok', '10.5.5.50');
INSERT INTO log VALUES (3215, 'mroncoroni', 'zapvs-default', '2017-07-18 09:55:01', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3216, 'mroncoroni', 'zapvs-sampleList', '2017-07-18 09:55:04', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3217, 'mroncoroni', 'zapvs-sampleList', '2017-07-18 09:55:07', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3218, 'mroncoroni', 'zapvs-samplePrintLabel', '2017-07-18 09:55:19', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3219, 'mroncoroni', 'zapvs-sampleList', '2017-07-18 09:56:08', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3220, 'mroncoroni', 'zapvs-samplePrintLabel', '2017-07-18 09:56:12', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3221, 'mroncoroni', 'zapvs-sampleList', '2017-07-18 09:56:50', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3222, 'mroncoroni', 'zapvs-labelList', '2017-07-18 09:56:55', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3223, 'mroncoroni', 'zapvs-labelChange', '2017-07-18 09:56:59', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3224, 'mroncoroni', 'zapvs-labelWrite', '2017-07-18 09:58:46', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3225, 'mroncoroni', 'zapvs-Label-write', '2017-07-18 09:58:46', '2', '10.5.5.50');
INSERT INTO log VALUES (3226, 'mroncoroni', 'zapvs-labelList', '2017-07-18 09:58:46', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3227, 'mroncoroni', 'zapvs-sampleList', '2017-07-18 09:58:51', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3228, 'mroncoroni', 'zapvs-samplePrintLabel', '2017-07-18 09:58:59', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3229, 'mroncoroni', 'zapvs-sampleList', '2017-07-18 09:59:24', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3230, 'mroncoroni', 'zapvs-labelList', '2017-07-18 09:59:28', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3231, 'mroncoroni', 'zapvs-labelChange', '2017-07-18 09:59:32', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3232, 'mroncoroni', 'zapvs-labelWrite', '2017-07-18 10:00:21', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3233, 'mroncoroni', 'zapvs-Label-write', '2017-07-18 10:00:21', '2', '10.5.5.50');
INSERT INTO log VALUES (3234, 'mroncoroni', 'zapvs-labelList', '2017-07-18 10:00:21', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3235, 'mroncoroni', 'zapvs-sampleList', '2017-07-18 10:00:26', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3236, 'mroncoroni', 'zapvs-samplePrintLabel', '2017-07-18 10:00:33', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3237, 'mroncoroni', 'zapvs-sampleList', '2017-07-18 10:01:19', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3238, 'mroncoroni', 'zapvs-labelList', '2017-07-18 10:01:32', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3239, 'mroncoroni', 'zapvs-labelChange', '2017-07-18 10:01:35', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3240, 'mroncoroni', 'zapvs-labelWrite', '2017-07-18 10:03:15', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3241, 'mroncoroni', 'zapvs-Label-write', '2017-07-18 10:03:15', '2', '10.5.5.50');
INSERT INTO log VALUES (3242, 'mroncoroni', 'zapvs-labelList', '2017-07-18 10:03:15', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3243, 'mroncoroni', 'zapvs-sampleList', '2017-07-18 10:03:19', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3244, 'mroncoroni', 'zapvs-samplePrintLabel', '2017-07-18 10:03:24', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3245, 'mroncoroni', 'zapvs-sampleList', '2017-07-18 10:04:19', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3246, 'mroncoroni', 'zapvs-labelList', '2017-07-18 10:04:23', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3247, 'mroncoroni', 'zapvs-labelChange', '2017-07-18 10:04:25', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3248, 'mroncoroni', 'zapvs-labelWrite', '2017-07-18 10:05:42', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3249, 'mroncoroni', 'zapvs-Label-write', '2017-07-18 10:05:42', '2', '10.5.5.50');
INSERT INTO log VALUES (3250, 'mroncoroni', 'zapvs-labelList', '2017-07-18 10:05:42', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3251, 'mroncoroni', 'zapvs-sampleList', '2017-07-18 10:05:46', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3252, 'mroncoroni', 'zapvs-samplePrintLabel', '2017-07-18 10:05:50', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3253, 'mroncoroni', 'zapvs-sampleList', '2017-07-18 10:06:13', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3254, 'mroncoroni', 'zapvs-labelList', '2017-07-18 10:06:18', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3255, 'mroncoroni', 'zapvs-labelChange', '2017-07-18 10:06:21', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3256, 'mroncoroni', 'zapvs-labelWrite', '2017-07-18 10:07:00', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3257, 'mroncoroni', 'zapvs-Label-write', '2017-07-18 10:07:00', '2', '10.5.5.50');
INSERT INTO log VALUES (3258, 'mroncoroni', 'zapvs-labelList', '2017-07-18 10:07:00', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3259, 'mroncoroni', 'zapvs-sampleList', '2017-07-18 10:07:06', 'ok', '10.5.5.50');
INSERT INTO log VALUES (3260, 'mroncoroni', 'zapvs-samplePrintLabel', '2017-07-18 10:07:09', 'ok', '10.5.5.50');


--
-- TOC entry 5273 (class 0 OID 0)
-- Dependencies: 224
-- Name: log_log_id_seq; Type: SEQUENCE SET; Schema: gacl; Owner: collec
--

SELECT pg_catalog.setval('log_log_id_seq', 3260, true);


--
-- TOC entry 4733 (class 0 OID 18149)
-- Dependencies: 223
-- Data for Name: login_oldpassword; Type: TABLE DATA; Schema: gacl; Owner: collec
--

INSERT INTO login_oldpassword VALUES (1, 1, 'cd916028a2d8a1b901e831246dd5b9b4d3832786ddc63bbf5af4b50d9fc98f50');
INSERT INTO login_oldpassword VALUES (2, 1, 'cfd3c0f2f89c29869f1889a8c45a50098a965d060a5b49d9db99df2970815450');


--
-- TOC entry 5274 (class 0 OID 0)
-- Dependencies: 222
-- Name: login_oldpassword_login_oldpassword_id_seq; Type: SEQUENCE SET; Schema: gacl; Owner: collec
--

SELECT pg_catalog.setval('login_oldpassword_login_oldpassword_id_seq', 2, true);


--
-- TOC entry 4730 (class 0 OID 18135)
-- Dependencies: 220
-- Data for Name: logingestion; Type: TABLE DATA; Schema: gacl; Owner: collec
--

INSERT INTO logingestion VALUES (1, 'admin', '682dd7115477b6e777e5ddb99c8c6936206953ca6a44cd8653f8b0327447a11a', 'Administrator', NULL, NULL, '2017-02-28', 1);
INSERT INTO logingestion VALUES (3, 'cpignol', '9fbd2e4d19289f163a6abb1fb44bc6906aeff84682b19a42d55d0811120b121a', 'pignol', 'cécile', 'cecile.pignol@univ-smb.fr', '2017-06-13', 1);
INSERT INTO logingestion VALUES (4, 'arnaud_f', 'c25948ad1bb8b6df6763d282b2f2806c69f9b8b16a48457519c38e2f12cec311', 'ARNAUD', 'Fabien', NULL, '2017-06-16', 1);
INSERT INTO logingestion VALUES (5, 'frossard_v', '64c98cc6d55e09212f6170c53071c2cdb17ebf5b8ec9292575e682da450213e6', 'FROSSARD', 'V', NULL, '2017-06-16', 1);
INSERT INTO logingestion VALUES (6, 'jenny_jp', '35aa170d400d6cbddd192fa7d7cddebd562239c2bea97e9ca828387f12aa6c84', 'JENNY', 'Jean-Philippe', NULL, '2017-06-16', 1);
INSERT INTO logingestion VALUES (7, 'test-collec', 'a69d07ea1565400a610603d2e22178944ea2c23ad0fbbb429ea09ab3b0751c68', 'Christine', 'Plumejeaud-Perreau', 'christine.plumejeaud-perreau@univ-lr.fr', '2017-06-21', 1);
INSERT INTO logingestion VALUES (8, 'admindemo', 'bca737c4fb3665ed3789f8fca2ef8be24da8f0a8a52fe84d3a06df94d3081162', 'admindemo', 'admindemo', NULL, '2017-06-27', 1);
INSERT INTO logingestion VALUES (9, 'mroncoroni', '33a98faa2d2750abef6984d6b5e3d4fdbcde3d16fbcb25e25f6093d7e0def9f5', 'RONCORONI', 'Maryline', NULL, '2017-07-18', 1);
INSERT INTO logingestion VALUES (10, 'tfanjas', '4ccd96414a70c342e3d83346bd8104d952f92eaef7c4b0771e36373736a8dae5', 'Fanjasmercere', 'Thierry', NULL, '2017-07-18', 1);
INSERT INTO logingestion VALUES (11, 'vbretagnolle', '119839fe050e31d0ce7861d8558538f05539e991142d16bf4e73866f68f8adf5', 'BRETAGNOLLE', 'Vincent', NULL, '2017-07-18', 1);


--
-- TOC entry 5275 (class 0 OID 0)
-- Dependencies: 221
-- Name: seq_logingestion_id; Type: SEQUENCE SET; Schema: gacl; Owner: collec
--

SELECT pg_catalog.setval('seq_logingestion_id', 11, true);


SET search_path = public, pg_catalog;

--
-- TOC entry 4184 (class 0 OID 16703)
-- Dependencies: 190
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: collec
--



SET search_path = zaalpes, pg_catalog;

--
-- TOC entry 4792 (class 0 OID 26972)
-- Dependencies: 287
-- Data for Name: booking; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--



--
-- TOC entry 5276 (class 0 OID 0)
-- Dependencies: 286
-- Name: booking_booking_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('booking_booking_id_seq', 1, false);


--
-- TOC entry 4794 (class 0 OID 26983)
-- Dependencies: 289
-- Data for Name: container; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO container VALUES (1, 1, 1);
INSERT INTO container VALUES (8, 8, 7);
INSERT INTO container VALUES (9, 9, 7);
INSERT INTO container VALUES (11, 11, 7);
INSERT INTO container VALUES (12, 12, 7);
INSERT INTO container VALUES (13, 13, 7);
INSERT INTO container VALUES (14, 14, 7);
INSERT INTO container VALUES (15, 15, 7);
INSERT INTO container VALUES (16, 16, 7);
INSERT INTO container VALUES (17, 17, 7);
INSERT INTO container VALUES (18, 18, 7);
INSERT INTO container VALUES (19, 19, 7);
INSERT INTO container VALUES (20, 20, 7);
INSERT INTO container VALUES (21, 21, 7);
INSERT INTO container VALUES (22, 22, 7);
INSERT INTO container VALUES (23, 23, 7);
INSERT INTO container VALUES (24, 24, 7);
INSERT INTO container VALUES (25, 25, 7);
INSERT INTO container VALUES (26, 26, 7);
INSERT INTO container VALUES (27, 27, 7);
INSERT INTO container VALUES (28, 28, 7);
INSERT INTO container VALUES (29, 29, 7);
INSERT INTO container VALUES (30, 30, 7);
INSERT INTO container VALUES (31, 31, 7);
INSERT INTO container VALUES (32, 32, 7);
INSERT INTO container VALUES (33, 33, 7);
INSERT INTO container VALUES (34, 34, 7);
INSERT INTO container VALUES (35, 35, 7);
INSERT INTO container VALUES (36, 36, 7);
INSERT INTO container VALUES (37, 37, 7);
INSERT INTO container VALUES (38, 38, 7);
INSERT INTO container VALUES (39, 39, 7);
INSERT INTO container VALUES (40, 40, 7);
INSERT INTO container VALUES (41, 41, 7);
INSERT INTO container VALUES (42, 42, 7);
INSERT INTO container VALUES (43, 43, 7);
INSERT INTO container VALUES (44, 44, 7);
INSERT INTO container VALUES (45, 45, 7);
INSERT INTO container VALUES (46, 46, 7);
INSERT INTO container VALUES (47, 47, 7);
INSERT INTO container VALUES (48, 48, 7);
INSERT INTO container VALUES (49, 49, 7);
INSERT INTO container VALUES (50, 50, 7);
INSERT INTO container VALUES (51, 51, 7);
INSERT INTO container VALUES (52, 52, 7);
INSERT INTO container VALUES (53, 53, 7);
INSERT INTO container VALUES (54, 54, 7);
INSERT INTO container VALUES (55, 55, 7);
INSERT INTO container VALUES (56, 56, 7);
INSERT INTO container VALUES (57, 57, 7);
INSERT INTO container VALUES (58, 58, 7);
INSERT INTO container VALUES (59, 59, 7);
INSERT INTO container VALUES (60, 60, 7);
INSERT INTO container VALUES (61, 61, 7);
INSERT INTO container VALUES (62, 62, 7);
INSERT INTO container VALUES (63, 63, 7);
INSERT INTO container VALUES (64, 64, 7);
INSERT INTO container VALUES (65, 65, 7);
INSERT INTO container VALUES (66, 66, 7);
INSERT INTO container VALUES (67, 67, 7);
INSERT INTO container VALUES (68, 68, 7);
INSERT INTO container VALUES (69, 69, 7);
INSERT INTO container VALUES (70, 70, 7);
INSERT INTO container VALUES (71, 71, 7);
INSERT INTO container VALUES (72, 72, 7);
INSERT INTO container VALUES (73, 73, 7);
INSERT INTO container VALUES (74, 74, 7);
INSERT INTO container VALUES (75, 75, 7);
INSERT INTO container VALUES (76, 76, 7);
INSERT INTO container VALUES (77, 77, 7);
INSERT INTO container VALUES (78, 78, 7);
INSERT INTO container VALUES (79, 79, 7);
INSERT INTO container VALUES (80, 80, 7);
INSERT INTO container VALUES (81, 81, 7);
INSERT INTO container VALUES (82, 82, 7);
INSERT INTO container VALUES (83, 83, 7);
INSERT INTO container VALUES (84, 84, 7);
INSERT INTO container VALUES (85, 85, 7);
INSERT INTO container VALUES (86, 86, 7);
INSERT INTO container VALUES (87, 87, 7);
INSERT INTO container VALUES (89, 91, 7);
INSERT INTO container VALUES (88, 88, 6);
INSERT INTO container VALUES (2, 2, 6);
INSERT INTO container VALUES (5, 5, 6);
INSERT INTO container VALUES (3, 3, 6);
INSERT INTO container VALUES (4, 4, 6);
INSERT INTO container VALUES (6, 6, 6);
INSERT INTO container VALUES (7, 7, 6);


--
-- TOC entry 5277 (class 0 OID 0)
-- Dependencies: 288
-- Name: container_container_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('container_container_id_seq', 89, true);


--
-- TOC entry 4796 (class 0 OID 26991)
-- Dependencies: 291
-- Data for Name: container_family; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO container_family VALUES (1, 'Immobilier', false);
INSERT INTO container_family VALUES (2, 'Mobilier', false);


--
-- TOC entry 5278 (class 0 OID 0)
-- Dependencies: 290
-- Name: container_family_container_family_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('container_family_container_family_id_seq', 2, true);


--
-- TOC entry 4798 (class 0 OID 27003)
-- Dependencies: 293
-- Data for Name: container_type; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO container_type VALUES (1, 'Site', 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO container_type VALUES (2, 'Bâtiment', 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO container_type VALUES (3, 'Pièce', 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO container_type VALUES (4, 'Armoire', 2, NULL, NULL, NULL, NULL, NULL);
INSERT INTO container_type VALUES (5, 'Congélateur', 2, NULL, NULL, NULL, NULL, NULL);
INSERT INTO container_type VALUES (7, 'Etui_ou_casier', 2, 1, 3, 'Case de rangement des carottes sédimentaires (run/section/demi_section)', NULL, NULL);
INSERT INTO container_type VALUES (6, 'Chambre froide', 1, 1, 2, 'Pièce pour conservation de carottes (conteneur ou chambre froide) à 4°C, avec ou sans étuis. Etiquettes posées sur les portes.', NULL, NULL);


--
-- TOC entry 5279 (class 0 OID 0)
-- Dependencies: 292
-- Name: container_type_container_type_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('container_type_container_type_id_seq', 7, true);


--
-- TOC entry 4800 (class 0 OID 27014)
-- Dependencies: 295
-- Data for Name: document; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--



--
-- TOC entry 5280 (class 0 OID 0)
-- Dependencies: 294
-- Name: document_document_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('document_document_id_seq', 1, false);


--
-- TOC entry 4802 (class 0 OID 27025)
-- Dependencies: 297
-- Data for Name: event; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--



--
-- TOC entry 5281 (class 0 OID 0)
-- Dependencies: 296
-- Name: event_event_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('event_event_id_seq', 1, false);


--
-- TOC entry 4804 (class 0 OID 27036)
-- Dependencies: 299
-- Data for Name: event_type; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO event_type VALUES (1, 'Autre', true, true);
INSERT INTO event_type VALUES (2, 'Conteneur cassé', false, true);
INSERT INTO event_type VALUES (3, 'Échantillon détruit', true, false);
INSERT INTO event_type VALUES (4, 'Prélèvement pour analyse', true, false);
INSERT INTO event_type VALUES (5, 'Échantillon totalement analysé, détruit', true, false);


--
-- TOC entry 5282 (class 0 OID 0)
-- Dependencies: 298
-- Name: event_type_event_type_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('event_type_event_type_id_seq', 5, true);


--
-- TOC entry 4806 (class 0 OID 27049)
-- Dependencies: 301
-- Data for Name: identifier_type; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO identifier_type VALUES (1, 'conteneur_porte', 'conteneur_porte');
INSERT INTO identifier_type VALUES (2, 'igsn', 'igsn');


--
-- TOC entry 5283 (class 0 OID 0)
-- Dependencies: 300
-- Name: identifier_type_identifier_type_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('identifier_type_identifier_type_id_seq', 2, true);


--
-- TOC entry 4808 (class 0 OID 27060)
-- Dependencies: 303
-- Data for Name: label; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO label VALUES (1, 'Exemple - ne pas utiliser', '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="objects">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="label"
              page-height="5cm" page-width="10cm" margin-left="0.5cm" margin-top="0.5cm" margin-bottom="0cm" margin-right="0.5cm">  
              <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      
      <fo:page-sequence master-reference="label">
         <fo:flow flow-name="xsl-region-body">        
          <fo:block>
          <xsl:apply-templates select="object" />
          </fo:block>

        </fo:flow>
      </fo:page-sequence>
    </fo:root>
   </xsl:template>
  <xsl:template match="object">

  <fo:table table-layout="fixed" border-collapse="collapse"  border-style="none" width="8cm" keep-together.within-page="always">
  <fo:table-column column-width="4cm"/>
  <fo:table-column column-width="4cm" />
 <fo:table-body  border-style="none" >
 	<fo:table-row>
  		<fo:table-cell> 
  		<fo:block>
  		<fo:external-graphic>
      <xsl:attribute name="src">
             <xsl:value-of select="concat(uid,''.png'')" />
       </xsl:attribute>
       <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
       <xsl:attribute name="height">4cm</xsl:attribute>
        <xsl:attribute name="content-width">4cm</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
      
       </fo:external-graphic>
 		</fo:block>
   		</fo:table-cell>
  		<fo:table-cell>
<fo:block><fo:inline font-weight="bold">IRSTEA</fo:inline></fo:block>
  			<fo:block>uid:<fo:inline font-weight="bold"><xsl:value-of select="db"/>:<xsl:value-of select="uid"/></fo:inline></fo:block>
  			<fo:block>id:<fo:inline font-weight="bold"><xsl:value-of select="id"/></fo:inline></fo:block>
  			<fo:block>prj:<fo:inline font-weight="bold"><xsl:value-of select="prj"/></fo:inline></fo:block>
  			<fo:block>clp:<fo:inline font-weight="bold"><xsl:value-of select="clp"/></fo:inline></fo:block>
  		</fo:table-cell>
  	  	</fo:table-row>
  </fo:table-body>
  </fo:table>
   <fo:block page-break-after="always"/>

  </xsl:template>
</xsl:stylesheet>', 'uid,id,clp,db,prj', NULL);
INSERT INTO label VALUES (3, 'Etiquette_casier_ou_étui_chambre_froide', '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="objects">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="label"
              page-height="5.1cm" page-width="7.6cm" margin-left="0.3cm" margin-top="0.3cm" margin-bottom="0.3cm" margin-right="0.3cm">  
              <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      
      <fo:page-sequence master-reference="label">
         <fo:flow flow-name="xsl-region-body">        
          <fo:block>
          <xsl:apply-templates select="object" />
          </fo:block>

        </fo:flow>
      </fo:page-sequence>
    </fo:root>
   </xsl:template>
  <xsl:template match="object">

  <fo:table table-layout="fixed" border-collapse="collapse"  border-style="none" width="7cm" keep-together.within-page="always">
  <fo:table-column column-width="4.5cm"/>
  <fo:table-column column-width="2.5cm" />
  
 <fo:table-body  border-style="none" >
    <fo:table-row>

        <fo:table-cell> 
            <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
            <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
            <fo:block>CONTENEUR:<fo:inline  font-size="12pt"><xsl:value-of select="conteneur_porte"/></fo:inline></fo:block>
            <fo:block> </fo:block>
            <fo:block>CASIER:<fo:inline font-weight="bold" font-size="24pt"><xsl:value-of select="id"/></fo:inline></fo:block>
        </fo:table-cell>
        <fo:table-cell> 
        <fo:block>
        <fo:external-graphic>
            <xsl:attribute name="src">
                 <xsl:value-of select="concat(uid,''.png'')" />
            </xsl:attribute>
            <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
            <xsl:attribute name="content-width">2cm</xsl:attribute>
            <xsl:attribute name="scaling">uniform</xsl:attribute>
        </fo:external-graphic>
        </fo:block>
        </fo:table-cell>
    </fo:table-row>
    <fo:table-row>

        <fo:table-cell> 
            <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
            <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
            <fo:block>CONTENEUR:<fo:inline font-size="12pt"><xsl:value-of select="conteneur_porte"/></fo:inline></fo:block>
            <fo:block> </fo:block>
            <fo:block>CASIER:<fo:inline font-weight="bold" font-size="24pt"><xsl:value-of select="id"/></fo:inline></fo:block>

        </fo:table-cell>
        <fo:table-cell> 
        <fo:block>
        <fo:external-graphic>
            <xsl:attribute name="src">
                 <xsl:value-of select="concat(uid,''.png'')" />
            </xsl:attribute>
            <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
            <xsl:attribute name="content-width">2cm</xsl:attribute>
            <xsl:attribute name="scaling">uniform</xsl:attribute>
        </fo:external-graphic>
        </fo:block>
        </fo:table-cell>
    </fo:table-row>
  </fo:table-body>
  </fo:table>

  </xsl:template>
</xsl:stylesheet>', 'uid,id,db,conteneur_porte', NULL);
INSERT INTO label VALUES (2, 'Etiquette_porte_chambre_froide', '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="objects">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="label"
              page-height="5.1cm" page-width="7.6cm" margin-left="0.5cm" margin-top="0.5cm" margin-bottom="0cm" margin-right="0.5cm">  
              <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      
      <fo:page-sequence master-reference="label">
         <fo:flow flow-name="xsl-region-body">        
          <fo:block>
          <xsl:apply-templates select="object" />
          </fo:block>

        </fo:flow>
      </fo:page-sequence>
    </fo:root>
   </xsl:template>
  <xsl:template match="object">

  <fo:table table-layout="fixed" border-collapse="collapse"  border-style="none" width="7cm" keep-together.within-page="always">
  <fo:table-column column-width="3.5cm"/>
  <fo:table-column column-width="3.5cm" />
 <fo:table-body  border-style="none" >
    <fo:table-row>
        <fo:table-cell> 
        <fo:block>
        <fo:external-graphic>
      <xsl:attribute name="src">
             <xsl:value-of select="concat(uid,''.png'')" />
       </xsl:attribute>
       <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
       <xsl:attribute name="height">3.5cm</xsl:attribute>
        <xsl:attribute name="content-width">3.5cm</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
         <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
      
       </fo:external-graphic>
        </fo:block>
        </fo:table-cell>
        <fo:table-cell> 
<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
<fo:block><fo:inline font-weight="bold">PORTE</fo:inline></fo:block>
            <fo:block><fo:inline font-weight="bold"><xsl:value-of select="db"/></fo:inline></fo:block>
<fo:block> </fo:block>
            <fo:block>id:<fo:inline font-weight="bold"  font-size="24pt"><xsl:value-of select="id"/></fo:inline></fo:block>
        </fo:table-cell>
        </fo:table-row>
  </fo:table-body>
  </fo:table>
  </xsl:template>
</xsl:stylesheet>', 'id,db,uid', NULL);
INSERT INTO label VALUES (4, 'Etiquette_run_section_beforeIGSN', '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="objects">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="label"
              page-height="3.2cm" page-width="5.7cm" margin-left="0.35cm" margin-top="0.1cm" margin-bottom="0.1cm" margin-right="0.35cm">  
              <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      
      <fo:page-sequence master-reference="label">
         <fo:flow flow-name="xsl-region-body">        
          <fo:block>
          <xsl:apply-templates select="object" />
          </fo:block>

        </fo:flow>
      </fo:page-sequence>
    </fo:root>
   </xsl:template>
  <xsl:template match="object">

  <fo:table table-layout="fixed" border-collapse="collapse"  border-style="none" width="5cm" keep-together.within-page="always">
  <fo:table-column column-width="2cm"/>
  <fo:table-column column-width="3cm" />
 <fo:table-body  border-style="none" >
    <fo:table-row>
        <fo:table-cell> 
        <fo:block>
        <fo:external-graphic>
      <xsl:attribute name="src">
             <xsl:value-of select="concat(uid,''.png'')" />
       </xsl:attribute>
       <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
       <xsl:attribute name="height">1.9cm</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
       </fo:external-graphic>
        </fo:block>
<fo:block  linefeed-treatment="preserve"><fo:inline font-size="7pt">EDYTEM &#xA; igsn in progress</fo:inline></fo:block>
        </fo:table-cell>
        <fo:table-cell> 
<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
            <fo:block font-size="9pt">uid:<fo:inline font-weight="bold"><xsl:value-of select="db"/>:<xsl:value-of select="uid"/></fo:inline></fo:block>
            <fo:block><fo:inline font-size="9pt"><xsl:value-of select="SITE"/></fo:inline></fo:block>
            <fo:block><fo:inline font-size="9pt"><xsl:value-of select="TYPE"/></fo:inline></fo:block>
            <fo:block><fo:inline font-size="10pt" font-weight="bold"><xsl:value-of select="id"/></fo:inline></fo:block>
            <fo:block><fo:inline font-size="9pt"><xsl:value-of select="LONGUEUR"/> (L) / <xsl:value-of select="PROFONDEUR"/> (Z)</fo:inline></fo:block>
            <fo:block><fo:inline font-size="9pt"><xsl:value-of select="PI"/></fo:inline></fo:block>
        </fo:table-cell>
        </fo:table-row>
  </fo:table-body>
  </fo:table>
  </xsl:template>
</xsl:stylesheet>', 'db,uid,id,prj,cd,x,y,PI', NULL);
INSERT INTO label VALUES (5, 'Etiquette_run_section_IGSN', '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="objects">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="label"
              page-height="3.2cm" page-width="5.7cm" margin-left="0cm" margin-top="0cm" margin-bottom="0cm" margin-right="0cm">  
              <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      
      <fo:page-sequence master-reference="label">
         <fo:flow flow-name="xsl-region-body">        
          <fo:block>
          <xsl:apply-templates select="object" />
          </fo:block>

        </fo:flow>
      </fo:page-sequence>
    </fo:root>
   </xsl:template>
  <xsl:template match="object">

<fo:table table-layout="fixed" border-collapse="collapse"  border-style="none" width="5cm" keep-together.within-page="always">
  <fo:table-column column-width="3cm"/>
  <fo:table-column column-width="2cm" />
 <fo:table-body  border-style="none" >
    <fo:table-row>
        <fo:table-cell> 
        <fo:block>
        <fo:external-graphic>
      <xsl:attribute name="src">
             <xsl:value-of select="concat(uid,''.png'')" />
       </xsl:attribute>
       <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
       <xsl:attribute name="height">2.5cm</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
       </fo:external-graphic>
        </fo:block>
<fo:block  linefeed-treatment="preserve" line-height="110%"><fo:inline font-size="7pt">igsn: <xsl:value-of select="igsn"/></fo:inline></fo:block>
        </fo:table-cell>
        <fo:table-cell> 
<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
            <fo:block font-size="7pt" line-height="120%">uid:<fo:inline font-weight="bold"><xsl:value-of select="db"/>:<xsl:value-of select="uid"/></fo:inline></fo:block>
            <fo:block line-height="110%"><fo:inline font-size="7pt"><xsl:value-of select="SITE"/></fo:inline></fo:block>
            <fo:block line-height="110%"><fo:inline font-size="7pt"><xsl:value-of select="TYPE"/></fo:inline></fo:block>
            <fo:block line-height="110%"><fo:inline font-size="7pt" font-weight="bold"><xsl:value-of select="id"/></fo:inline></fo:block>
            <fo:block line-height="110%"><fo:inline font-size="7pt"><xsl:value-of select="LONGUEUR"/> (L) / <xsl:value-of select="PROFONDEUR"/> (Z)</fo:inline></fo:block>
            <fo:block line-height="110%"><fo:inline font-size="7pt"><xsl:value-of select="PI"/></fo:inline></fo:block>
        </fo:table-cell>
        </fo:table-row>
  </fo:table-body>
  </fo:table>
  
  </xsl:template>
</xsl:stylesheet>', 'db,uid,id,prj,cd,x,y,PI,igsn', NULL);
INSERT INTO label VALUES (6, 'Etiquettes_tube', '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="objects">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="label"
              page-height="1.2cm" page-width="4.1cm" margin-left="0.4cm" margin-top="0.1cm" margin-bottom="0cm" margin-right="0.3cm">  
              <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      
      <fo:page-sequence master-reference="label">
         <fo:flow flow-name="xsl-region-body">        
          <fo:block>
          <xsl:apply-templates select="object" />
          </fo:block>

        </fo:flow>
      </fo:page-sequence>
    </fo:root>
   </xsl:template>
  <xsl:template match="object">

  <fo:table table-layout="fixed" border-collapse="collapse"  border-style="none" width="35cm" keep-together.within-page="always">
  <fo:table-column column-width="1.5cm"/>
  <fo:table-column column-width="2cm" />
 <fo:table-body  border-style="none" >
    <fo:table-row>
        <fo:table-cell> 
        <fo:block>
        <fo:external-graphic>
      <xsl:attribute name="src">
             <xsl:value-of select="concat(uid,''.png'')" />
       </xsl:attribute>
       <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
       <xsl:attribute name="height">1cm</xsl:attribute>
        <xsl:attribute name="content-width">1cm</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
      
       </fo:external-graphic>
        </fo:block>
        </fo:table-cell>
        <fo:table-cell>

            <fo:block>uid:<fo:inline font-weight="bold"><xsl:value-of select="uid"/></fo:inline></fo:block>
            
        </fo:table-cell>
        </fo:table-row>
  </fo:table-body>
  </fo:table>
   <fo:block page-break-after="always"/>

  </xsl:template>
</xsl:stylesheet>
', 'uid', NULL);
INSERT INTO label VALUES (7, 'Etiquettes_tube_QRrectangle', '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="objects">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="label"
              page-height="1.2cm" page-width="4.1cm" margin-left="0.4cm" margin-top="0.1cm" margin-bottom="0cm" margin-right="0.7cm">  
              <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      
      <fo:page-sequence master-reference="label">
         <fo:flow flow-name="xsl-region-body">        
          <fo:block>
          <xsl:apply-templates select="object" />
          </fo:block>

        </fo:flow>
      </fo:page-sequence>
    </fo:root>
   </xsl:template>
  <xsl:template match="object">

  <fo:table table-layout="fixed" border-collapse="collapse" border="1pt" border-style="none" width="2.8cm" keep-together.within-page="always" keep-together.within-column="always">
  <fo:table-column column-width="1.5cm"/>
  <fo:table-column column-width="1cm" />
  <fo:table-column column-width="0.3cm" />
 <fo:table-body  border-style="none" >
    <fo:table-row>

        <fo:table-cell> 
        <fo:block>
        <fo:external-graphic>
      <xsl:attribute name="src">
             <xsl:value-of select="concat(uid,''.png'')" />
       </xsl:attribute>
       <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
       <xsl:attribute name="height">1cm</xsl:attribute>
        <xsl:attribute name="content-width">1cm</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
       </fo:external-graphic>
        </fo:block>
        </fo:table-cell>

        <fo:table-cell> 
        <fo:block>
        <fo:external-graphic>
      <xsl:attribute name="src">
             <xsl:value-of select="concat(uid,''.png'')" />
       </xsl:attribute>
       <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
       <xsl:attribute name="height">1cm</xsl:attribute>
        <xsl:attribute name="content-width">1cm</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
       </fo:external-graphic>
        </fo:block>
        </fo:table-cell>

        <fo:table-cell>
            <fo:block wrap-option="wrap"><fo:inline font-size="6pt"><xsl:value-of select="id"/></fo:inline></fo:block>          
        </fo:table-cell>
        </fo:table-row>
  </fo:table-body>
  </fo:table>

  </xsl:template>
</xsl:stylesheet>', 'uid,db', NULL);


--
-- TOC entry 5284 (class 0 OID 0)
-- Dependencies: 302
-- Name: label_label_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('label_label_id_seq', 7, true);


--
-- TOC entry 4843 (class 0 OID 27484)
-- Dependencies: 341
-- Data for Name: metadata_form; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO metadata_form VALUES (1, '[{"nom":"SITE","type":"string","require":true,"helperChoice":false,"description":"Nom du lac/site d''extraction","meusureUnit":"champs libre"},{"nom":"TYPE","type":"select","choiceList":["SEDIMENT","SOL","LIQUIDE","ROCHE"],"require":false,"helperChoice":true,"helper":"type des substrat depuis lequel la carotte est extraite","description":"type des substrat depuis lequel la carotte est extraite","meusureUnit":"liste de choix"},{"nom":"SAMPLE_NAME","type":"string","require":true,"helperChoice":true,"helper":"Identifiant STOCK de la carotte","description":"Identifiant STOCK de la carotte","meusureUnit":"sans"},{"nom":"LONGUEUR","type":"string","require":false,"helperChoice":true,"helper":"Longueur du run ou de la section","description":"Longueur du run ou de la section","meusureUnit":"cm"},{"nom":"PROFONDEUR","type":"string","require":true,"helperChoice":true,"helper":"Profondeur de la carotte en cm (bottom - top)","description":"Profondeur de la carotte en cm (bottom - top)","meusureUnit":"cm"},{"nom":"PI","type":"string","require":true,"helperChoice":true,"helper":"Nom du propriétaire de la carotte","description":"Nom du propriétaire de la carotte","meusureUnit":"sans"}]');
INSERT INTO metadata_form VALUES (2, '[{"nom":"Long TOP (mousse) cm","type":"number","require":false,"helperChoice":true,"helper":"Longueur au top de la mousse (en cm)","description":"Longueur TOP de la mousse","meusureUnit":"cm"},{"nom":"Long sediment cm","type":"number","require":false,"helperChoice":true,"helper":"Longueur sediment (en cm)","description":"Longueur sediment (en cm)","meusureUnit":"cm"},{"nom":"Long mousse BOT cm","type":"string","require":false,"helperChoice":true,"helper":"Longueur au BOT de la mousse (en cm)","description":"Longueur au BOT de la mousse (en cm)","meusureUnit":"cm"},{"nom":"Commentaire","type":"string","require":false,"helperChoice":true,"helper":"Commentaire","description":"Commentaire","meusureUnit":"sans"}]');
INSERT INTO metadata_form VALUES (4, '[{"nom":"Long TOP (mousse) cm","type":"number","require":false,"helperChoice":true,"helper":"Longueur au top de la mousse (en cm)","description":"Longueur TOP de la mousse","meusureUnit":"cm"},{"nom":"Long sediment cm","type":"number","require":false,"helperChoice":true,"helper":"Longueur sediment (en cm)","description":"Longueur sediment (en cm)","meusureUnit":"cm"},{"nom":"Long mousse BOT cm","type":"string","require":false,"helperChoice":true,"helper":"Longueur au BOT de la mousse (en cm)","description":"Longueur au BOT de la mousse (en cm)","meusureUnit":"cm"},{"nom":"Commentaire","type":"string","require":false,"helperChoice":true,"helper":"Commentaire","description":"Commentaire","meusureUnit":"sans"}]');
INSERT INTO metadata_form VALUES (6, '[{"nom":"NOM DECOUPE","type":"string","require":false,"helperChoice":true,"helper":"nom du run + sufixe \"A\" pour section SUPERIEUR  ou ou B pour section INFERIEUR","description":"Nom du run\n+ \nsufixe \"A\" pour section SUPÉRIEUR  \nou \nou B pour section INFÉRIEUR","meusureUnit":"cm"},{"nom":"Prof TOP Section dans le RUN","type":"number","require":false,"helperChoice":true,"helper":"Profondeur TOP dans le run parent ","description":"Profondeur TOP dans le run parent ","meusureUnit":"cm"},{"nom":"Prof BOTTUM Section dans le RUN","type":"string","require":false,"helperChoice":true,"helper":"Profondeur BOT dans le run parent ","description":"Profondeur TOP dans le RUN parent ","meusureUnit":"cm"}]');
INSERT INTO metadata_form VALUES (5, '[{"nom":"Long TOP (mousse) cm","type":"number","require":false,"helperChoice":true,"helper":"Longueur au top de la mousse (en cm)","description":"Longueur TOP de la mousse","meusureUnit":"cm"},{"nom":"Long sediment cm","type":"number","require":false,"helperChoice":true,"helper":"Longueur sediment (en cm)","description":"Longueur sediment (en cm)","meusureUnit":"cm"},{"nom":"Long mousse BOT cm","type":"string","require":false,"helperChoice":true,"helper":"Longueur au BOT de la mousse (en cm)","description":"Longueur au BOT de la mousse (en cm)","meusureUnit":"cm"},{"nom":"Sample-type SESAR","type":"textarea","require":false,"helperChoice":true,"helper":"Core Section Half (half-cylindrical products of along-axis split of a section or its component fragments through a selected diameter)","description":"Core Section Half   : half-cylindrical products of along-axis split of a section or its component fragments through a selected diameter.\n12/07/2017\nChristine : \"Sample-type SESAR\"\nhttp://www.geosamples.org/help/vocabularies#object\nCe type est d''info est a stocker ds la base (systématiquement). \nOn en a besoin pour faire la déclaration à SESAR pour avoir un code unique IGSN. A discuter lors de l’interopérabilité de Collect avec Cyber-C à l''automne. Mais il faut le prévoir dès à présent","meusureUnit":"sans"}]');
INSERT INTO metadata_form VALUES (7, '[]');
INSERT INTO metadata_form VALUES (3, '[{"nom":"Numero d''échantillon","type":"string","require":false,"helperChoice":true,"helper":"A définir par opérateur","description":"A définir par opérateur","meusureUnit":"sans"},{"nom":"Type de sous-échantillons","type":"select","choiceList":["Echantillons discrets","Echantillons stratigraphiques "],"require":true,"helperChoice":false,"description":"discrets  (ponctuels) ou stratigraphiques (U-chanel, Plaquettes, Lame minces,...)","meusureUnit":"discrets ou stratigraphiques"},{"nom":"Prof Top sediment","type":"number","require":false,"helperChoice":false,"description":"Prof Top sédiment","meusureUnit":"cm"},{"nom":"Sample_type (SESAR)","type":"string","require":false,"helperChoice":false,"description":"Core Sub-Piece - unambiguously mated portion of a larger piece noted for curatorial management of the material. \n","meusureUnit":"sans"},{"nom":"Prof Bot sediment","type":"number","require":false,"helperChoice":false,"description":"Prof Bot sediment","meusureUnit":"cm"},{"nom":"Poids humide (g)","type":"number","require":false,"helperChoice":false,"description":"Poids humide (g)","meusureUnit":"g"},{"nom":"Poids sec","type":"number","require":false,"helperChoice":false,"description":"Poids sec (g)","meusureUnit":"(g)"}]');


--
-- TOC entry 5285 (class 0 OID 0)
-- Dependencies: 340
-- Name: metadata_form_metadata_form_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('metadata_form_metadata_form_id_seq', 7, true);


--
-- TOC entry 4810 (class 0 OID 27108)
-- Dependencies: 305
-- Data for Name: mime_type; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO mime_type VALUES (1, 'pdf', 'application/pdf');
INSERT INTO mime_type VALUES (2, 'zip', 'application/zip');
INSERT INTO mime_type VALUES (3, 'mp3', 'audio/mpeg');
INSERT INTO mime_type VALUES (4, 'jpg', 'image/jpeg');
INSERT INTO mime_type VALUES (5, 'jpeg', 'image/jpeg');
INSERT INTO mime_type VALUES (6, 'png', 'image/png');
INSERT INTO mime_type VALUES (7, 'tiff', 'image/tiff');
INSERT INTO mime_type VALUES (9, 'odt', 'application/vnd.oasis.opendocument.text');
INSERT INTO mime_type VALUES (10, 'ods', 'application/vnd.oasis.opendocument.spreadsheet');
INSERT INTO mime_type VALUES (11, 'xls', 'application/vnd.ms-excel');
INSERT INTO mime_type VALUES (12, 'xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
INSERT INTO mime_type VALUES (13, 'doc', 'application/msword');
INSERT INTO mime_type VALUES (14, 'docx', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document');
INSERT INTO mime_type VALUES (8, 'csv', 'text/csv');


--
-- TOC entry 5286 (class 0 OID 0)
-- Dependencies: 304
-- Name: mime_type_mime_type_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('mime_type_mime_type_id_seq', 1, false);


--
-- TOC entry 4812 (class 0 OID 27119)
-- Dependencies: 307
-- Data for Name: movement_type; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO movement_type VALUES (1, 'Entrée/Entry');
INSERT INTO movement_type VALUES (2, 'Sortie/Exit');


--
-- TOC entry 5287 (class 0 OID 0)
-- Dependencies: 306
-- Name: movement_type_movement_type_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('movement_type_movement_type_id_seq', 1, false);


--
-- TOC entry 4814 (class 0 OID 27130)
-- Dependencies: 309
-- Data for Name: multiple_type; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO multiple_type VALUES (1, 'Unité');
INSERT INTO multiple_type VALUES (2, 'Pourcentage');
INSERT INTO multiple_type VALUES (3, 'Quantité ou volume');
INSERT INTO multiple_type VALUES (4, 'Autre');


--
-- TOC entry 5288 (class 0 OID 0)
-- Dependencies: 308
-- Name: multiple_type_multiple_type_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('multiple_type_multiple_type_id_seq', 4, true);


--
-- TOC entry 4816 (class 0 OID 27141)
-- Dependencies: 311
-- Data for Name: object; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO object VALUES (1, 'EDYTEM', 1, 5.857086181640625, 45.6516803279697285);
INSERT INTO object VALUES (8, 'A6', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (9, 'B11', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (10, 'B4', 1, NULL, NULL);
INSERT INTO object VALUES (11, 'B4', 1, NULL, NULL);
INSERT INTO object VALUES (12, 'I5', 1, NULL, NULL);
INSERT INTO object VALUES (13, 'M14', 1, NULL, NULL);
INSERT INTO object VALUES (14, 'F1', 1, NULL, NULL);
INSERT INTO object VALUES (15, 'A6', 1, NULL, NULL);
INSERT INTO object VALUES (16, 'B11', 1, NULL, NULL);
INSERT INTO object VALUES (17, 'A5', 1, NULL, NULL);
INSERT INTO object VALUES (18, 'E1', 1, NULL, NULL);
INSERT INTO object VALUES (19, 'I 10', 1, NULL, NULL);
INSERT INTO object VALUES (20, 'A6', 1, NULL, NULL);
INSERT INTO object VALUES (21, 'B9', 1, NULL, NULL);
INSERT INTO object VALUES (22, 'I5', 1, NULL, NULL);
INSERT INTO object VALUES (23, 'M14', 1, NULL, NULL);
INSERT INTO object VALUES (24, 'B9', 1, NULL, NULL);
INSERT INTO object VALUES (25, 'A11', 1, NULL, NULL);
INSERT INTO object VALUES (26, 'C13', 1, NULL, NULL);
INSERT INTO object VALUES (27, 'M15', 1, NULL, NULL);
INSERT INTO object VALUES (28, 'A9', 1, NULL, NULL);
INSERT INTO object VALUES (29, 'A9', 1, NULL, NULL);
INSERT INTO object VALUES (30, 'B9', 1, NULL, NULL);
INSERT INTO object VALUES (31, 'F13', 1, NULL, NULL);
INSERT INTO object VALUES (32, 'B9', 1, NULL, NULL);
INSERT INTO object VALUES (33, 'A13', 1, NULL, NULL);
INSERT INTO object VALUES (34, 'B15', 1, NULL, NULL);
INSERT INTO object VALUES (35, 'C10', 1, NULL, NULL);
INSERT INTO object VALUES (36, 'B13', 1, NULL, NULL);
INSERT INTO object VALUES (37, 'A7', 1, NULL, NULL);
INSERT INTO object VALUES (38, 'A5', 1, NULL, NULL);
INSERT INTO object VALUES (39, 'A10', 1, NULL, NULL);
INSERT INTO object VALUES (40, 'C14', 1, NULL, NULL);
INSERT INTO object VALUES (41, 'E15', 1, NULL, NULL);
INSERT INTO object VALUES (42, 'G1', 1, NULL, NULL);
INSERT INTO object VALUES (43, 'F13', 1, NULL, NULL);
INSERT INTO object VALUES (44, 'E1', 1, NULL, NULL);
INSERT INTO object VALUES (45, 'B7', 1, NULL, NULL);
INSERT INTO object VALUES (46, 'A12', 1, NULL, NULL);
INSERT INTO object VALUES (47, 'A12', 1, NULL, NULL);
INSERT INTO object VALUES (48, 'A7', 1, NULL, NULL);
INSERT INTO object VALUES (49, 'A11', 1, NULL, NULL);
INSERT INTO object VALUES (50, 'H7', 1, NULL, NULL);
INSERT INTO object VALUES (51, 'C13', 1, NULL, NULL);
INSERT INTO object VALUES (52, 'B6', 1, NULL, NULL);
INSERT INTO object VALUES (53, 'A3', 1, NULL, NULL);
INSERT INTO object VALUES (54, 'A11', 1, NULL, NULL);
INSERT INTO object VALUES (55, 'B9', 1, NULL, NULL);
INSERT INTO object VALUES (56, 'C10', 1, NULL, NULL);
INSERT INTO object VALUES (57, 'I5', 1, NULL, NULL);
INSERT INTO object VALUES (58, 'B14', 1, NULL, NULL);
INSERT INTO object VALUES (59, 'A12', 1, NULL, NULL);
INSERT INTO object VALUES (60, 'D13', 1, NULL, NULL);
INSERT INTO object VALUES (61, 'A13', 1, NULL, NULL);
INSERT INTO object VALUES (62, 'B13', 1, NULL, NULL);
INSERT INTO object VALUES (63, 'B6', 1, NULL, NULL);
INSERT INTO object VALUES (64, 'C10', 1, NULL, NULL);
INSERT INTO object VALUES (65, 'A9', 1, NULL, NULL);
INSERT INTO object VALUES (66, 'A5', 1, NULL, NULL);
INSERT INTO object VALUES (67, 'G6', 1, NULL, NULL);
INSERT INTO object VALUES (68, 'B9', 1, NULL, NULL);
INSERT INTO object VALUES (69, 'A10', 1, NULL, NULL);
INSERT INTO object VALUES (70, 'A10', 1, NULL, NULL);
INSERT INTO object VALUES (71, 'M14', 1, NULL, NULL);
INSERT INTO object VALUES (72, 'A9', 1, NULL, NULL);
INSERT INTO object VALUES (73, 'M15', 1, NULL, NULL);
INSERT INTO object VALUES (74, 'A12', 1, NULL, NULL);
INSERT INTO object VALUES (75, 'I 10', 1, NULL, NULL);
INSERT INTO object VALUES (76, 'A3', 1, NULL, NULL);
INSERT INTO object VALUES (77, 'C10', 1, NULL, NULL);
INSERT INTO object VALUES (78, 'A10', 1, NULL, NULL);
INSERT INTO object VALUES (79, 'B4', 1, NULL, NULL);
INSERT INTO object VALUES (80, 'F1', 1, NULL, NULL);
INSERT INTO object VALUES (81, 'E13', 1, NULL, NULL);
INSERT INTO object VALUES (82, 'M14', 1, NULL, NULL);
INSERT INTO object VALUES (83, 'E15', 1, NULL, NULL);
INSERT INTO object VALUES (84, 'B15', 1, NULL, NULL);
INSERT INTO object VALUES (85, 'A4', 1, NULL, NULL);
INSERT INTO object VALUES (86, 'A13', 1, NULL, NULL);
INSERT INTO object VALUES (87, 'E13', 1, NULL, NULL);
INSERT INTO object VALUES (89, 'LDB10-T1-60-04', 1, 5.82969399999999993, 45.7959439999999987);
INSERT INTO object VALUES (91, 'I5', 1, NULL, NULL);
INSERT INTO object VALUES (90, 'LEM10-P6-02a', 1, 6.57589999999999986, 46.4473830000000021);
INSERT INTO object VALUES (88, 'CHAMBRE EDYTEM', 1, 5.87203145027160467, 45.6403269473863986);
INSERT INTO object VALUES (2, 'CONTENEUR 1', 1, 5.872916579246521, 45.6400912224206365);
INSERT INTO object VALUES (5, 'CONTENEUR 2', 1, 5.87271407246589483, 45.6400565293241414);
INSERT INTO object VALUES (3, 'CI - P1', 1, 5.87298631668090731, 45.6400985361005382);
INSERT INTO object VALUES (4, 'CI - P2', 1, 5.87283074855804532, 45.6401004114021873);
INSERT INTO object VALUES (6, 'CII - P3', 1, 5.87275698781013578, 45.6400780953055687);
INSERT INTO object VALUES (7, 'CII - P4', 1, 5.87268188595771612, 45.6400743447006789);
INSERT INTO object VALUES (92, 'LDB10-06A', 1, 5.8549439999999997, 45.7619439999999997);
INSERT INTO object VALUES (93, 'LDB10-T1-60-04 x', 1, NULL, NULL);


--
-- TOC entry 4818 (class 0 OID 27152)
-- Dependencies: 313
-- Data for Name: object_identifier; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO object_identifier VALUES (2, 8, 1, 'CI - P2');
INSERT INTO object_identifier VALUES (3, 9, 1, 'CI - P2');
INSERT INTO object_identifier VALUES (5, 12, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (6, 13, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (7, 14, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (8, 15, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (9, 16, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (10, 17, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (11, 18, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (12, 19, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (13, 20, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (14, 21, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (15, 22, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (16, 23, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (17, 24, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (18, 25, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (19, 26, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (20, 27, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (21, 28, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (22, 29, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (23, 30, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (24, 31, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (25, 32, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (26, 33, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (27, 34, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (28, 35, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (29, 36, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (30, 37, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (31, 38, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (32, 39, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (33, 40, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (34, 41, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (35, 42, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (36, 43, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (37, 44, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (38, 45, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (39, 46, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (40, 47, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (41, 48, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (42, 49, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (43, 50, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (44, 51, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (45, 52, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (46, 53, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (47, 54, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (48, 55, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (49, 56, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (50, 57, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (51, 58, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (52, 59, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (53, 60, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (54, 61, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (55, 62, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (56, 63, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (57, 64, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (58, 65, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (59, 66, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (60, 67, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (61, 68, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (62, 69, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (63, 70, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (64, 71, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (65, 72, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (66, 73, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (67, 74, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (68, 75, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (69, 76, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (70, 77, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (71, 78, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (72, 79, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (73, 80, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (74, 81, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (75, 82, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (76, 83, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (77, 84, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (78, 85, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (79, 86, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (80, 87, 1, '	CI - P2');
INSERT INTO object_identifier VALUES (81, 11, 1, 'CI - P2');
INSERT INTO object_identifier VALUES (82, 89, 2, 'IEFRA004W');
INSERT INTO object_identifier VALUES (83, 92, 2, 'IEFRA00NW');
INSERT INTO object_identifier VALUES (85, 90, 2, 'IEFRA00XF');


--
-- TOC entry 5289 (class 0 OID 0)
-- Dependencies: 312
-- Name: object_identifier_object_identifier_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('object_identifier_object_identifier_id_seq', 85, true);


--
-- TOC entry 4820 (class 0 OID 27163)
-- Dependencies: 315
-- Data for Name: object_status; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO object_status VALUES (1, 'État normal');
INSERT INTO object_status VALUES (2, 'Objet pré-réservé pour usage ultérieur');
INSERT INTO object_status VALUES (3, 'Objet détruit');
INSERT INTO object_status VALUES (4, 'Echantillon vidé de tout contenu');


--
-- TOC entry 5290 (class 0 OID 0)
-- Dependencies: 314
-- Name: object_status_object_status_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('object_status_object_status_id_seq', 4, true);


--
-- TOC entry 5291 (class 0 OID 0)
-- Dependencies: 310
-- Name: object_uid_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('object_uid_seq', 93, true);


--
-- TOC entry 4822 (class 0 OID 27174)
-- Dependencies: 317
-- Data for Name: operation; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO operation VALUES (1, 1, 'extraction_run', 1, 1, 'v1', '2017-06-16 19:03:35');
INSERT INTO operation VALUES (2, 1, 'Ouverture Core', 2, 2, 'v1', '2017-07-11 16:58:07');
INSERT INTO operation VALUES (4, 1, '2-Créer une carotte "archive" (X)', 4, 4, '1', '2017-07-11 18:34:46');
INSERT INTO operation VALUES (6, 1, 'DECOUPE RUN en SECTION (A)', 1, 6, '1', '2017-07-11 18:51:10');
INSERT INTO operation VALUES (5, 1, '1-Ouverture d''une carotte : créer une carotte "TRAVAIL" (w) ', 2, 5, '1', '2017-07-12 16:51:54');
INSERT INTO operation VALUES (7, 1, 'DECOUPE RUN en SECTION (B)', 1, 7, '1', '2017-07-12 16:52:52');
INSERT INTO operation VALUES (3, 1, '3-Sous-échantilonnage d''une 1/2 section', 3, 3, '1', '2017-07-12 16:57:17');


--
-- TOC entry 5292 (class 0 OID 0)
-- Dependencies: 316
-- Name: operation_operation_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('operation_operation_id_seq', 7, true);


--
-- TOC entry 4824 (class 0 OID 27185)
-- Dependencies: 319
-- Data for Name: project; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO project VALUES (1, 'ANR 2008 IPER-RETRO (http://www6.inra.fr/iper_retro)');
INSERT INTO project VALUES (2, 'tartanpion');


--
-- TOC entry 4825 (class 0 OID 27194)
-- Dependencies: 320
-- Data for Name: project_group; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO project_group VALUES (1, 32);
INSERT INTO project_group VALUES (1, 31);
INSERT INTO project_group VALUES (2, 31);
INSERT INTO project_group VALUES (2, 32);


--
-- TOC entry 5293 (class 0 OID 0)
-- Dependencies: 318
-- Name: project_project_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('project_project_id_seq', 2, true);


--
-- TOC entry 4827 (class 0 OID 27201)
-- Dependencies: 322
-- Data for Name: protocol; Type: TABLE DATA; Schema: zaalpes; Owner: collec
insert into zaalpes.protocol(protocol_id, protocol_name, protocol_year, protocol_version) values 
(1, 'ROZA_carottes_sedimentaires', 2017, '1.0');
insert into zaalpes.protocol(protocol_id, protocol_name, protocol_year, protocol_version) values 
(2, 'ORCHAMPS_SOLS', 2017, '1.0');



--
-- TOC entry 5294 (class 0 OID 0)
-- Dependencies: 321
-- Name: protocol_protocol_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('protocol_protocol_id_seq', 2, true);


--
-- TOC entry 4829 (class 0 OID 27213)
-- Dependencies: 324
-- Data for Name: sample; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO sample VALUES (1, 89, 1, 1, '2017-06-16 19:22:35', '2012-05-30 19:22:35', NULL, 65, 16, NULL, 1);
INSERT INTO sample VALUES (2, 90, 1, 1, '2017-06-19 10:32:44', '2012-05-30 00:00:00', NULL, 64, 2, NULL, 2);
INSERT INTO sample VALUES (3, 92, 1, 1, '2017-06-19 11:01:04', '2012-05-30 00:00:00', NULL, 104, 16, NULL, 3);
INSERT INTO sample VALUES (4, 93, 2, 2, '2017-07-11 18:05:56', '2017-07-11 18:05:56', 1, NULL, NULL, NULL, 4);


--
-- TOC entry 4845 (class 0 OID 27495)
-- Dependencies: 343
-- Data for Name: sample_metadata; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO sample_metadata VALUES (1, '{"SITE":"BOURGET","TYPE":"SEDIMENT","SAMPLE_NAME":"LDB10-T1-60-04","LONGUEUR":"65","PROFONDEUR":"65","PI":"FROSSARD V"}');
INSERT INTO sample_metadata VALUES (2, '{"SITE":"LEMAN","TYPE":"SEDIMENT","SAMPLE_NAME":"LEM10-P6-02a","LONGUEUR":"64","PROFONDEUR":"315","PI":"JENNY JP (ORCID:0000-0002-2740-174X)"}');
INSERT INTO sample_metadata VALUES (3, '{"SITE":"BOURGET","TYPE":"SEDIMENT","SAMPLE_NAME":"LDB10-06A","LONGUEUR":"104","PROFONDEUR":"NA","PI":"JENNY JP (ORCID:0000-0002-2740-174X)"}');
INSERT INTO sample_metadata VALUES (4, '{"Long TOP (mousse) cm":5,"Long sediment cm":50,"Long mousse BOT cm":"2","Commentaire":"rtergfef"}');


--
-- TOC entry 5295 (class 0 OID 0)
-- Dependencies: 342
-- Name: sample_metadata_sample_metadata_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('sample_metadata_sample_metadata_id_seq', 4, true);


--
-- TOC entry 5296 (class 0 OID 0)
-- Dependencies: 323
-- Name: sample_sample_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('sample_sample_id_seq', 4, true);


--
-- TOC entry 4831 (class 0 OID 27229)
-- Dependencies: 326
-- Data for Name: sample_type; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO sample_type VALUES (1, 'CORE', 7, 1, 3, 'cm');
INSERT INTO sample_type VALUES (2, '1/2 Section de core (niv3)', 7, 2, 3, 'cm');
INSERT INTO sample_type VALUES (3, 'Sous-Echantillons', 7, 3, 3, 'cm');


--
-- TOC entry 5297 (class 0 OID 0)
-- Dependencies: 325
-- Name: sample_type_sample_type_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('sample_type_sample_type_id_seq', 3, true);


--
-- TOC entry 4841 (class 0 OID 27465)
-- Dependencies: 339
-- Data for Name: sampling_place; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO sampling_place VALUES (1, 'ANNECY');
INSERT INTO sampling_place VALUES (2, 'LEMAN');
INSERT INTO sampling_place VALUES (3, 'ABBAYE SALINS');
INSERT INTO sampling_place VALUES (4, 'ALLOS');
INSERT INTO sampling_place VALUES (5, 'ANTERNE');
INSERT INTO sampling_place VALUES (6, 'ARMOR');
INSERT INTO sampling_place VALUES (7, 'ARVOIN');
INSERT INTO sampling_place VALUES (8, 'BASTANI');
INSERT INTO sampling_place VALUES (9, 'BENIT');
INSERT INTO sampling_place VALUES (10, 'BERGSEE');
INSERT INTO sampling_place VALUES (11, 'BLANC AIGUILLE ROUGE');
INSERT INTO sampling_place VALUES (12, 'BLANC BELLEDONNE');
INSERT INTO sampling_place VALUES (13, 'BLANC BELLEDONNE (PETIT)');
INSERT INTO sampling_place VALUES (14, 'BLED Blejsko Jezero');
INSERT INTO sampling_place VALUES (15, 'BOHINJ Bohinjsko Jezero');
INSERT INTO sampling_place VALUES (16, 'BOURGET');
INSERT INTO sampling_place VALUES (17, 'BREVENT');
INSERT INTO sampling_place VALUES (18, 'CANARD');
INSERT INTO sampling_place VALUES (19, 'CAPITELLO');
INSERT INTO sampling_place VALUES (20, 'CORNU');
INSERT INTO sampling_place VALUES (21, 'CREUSATES (Tourbière)');
INSERT INTO sampling_place VALUES (22, 'DOMENON INF');
INSERT INTO sampling_place VALUES (23, 'DOMENON Inf Petit');
INSERT INTO sampling_place VALUES (24, 'DOMENON SUP');
INSERT INTO sampling_place VALUES (25, 'EGORGEOU');
INSERT INTO sampling_place VALUES (26, 'EYCHAUDA');
INSERT INTO sampling_place VALUES (27, 'FARAVEL');
INSERT INTO sampling_place VALUES (28, 'FOREANT');
INSERT INTO sampling_place VALUES (29, 'FOUGERES');
INSERT INTO sampling_place VALUES (30, 'GD LAC ESTARIS');
INSERT INTO sampling_place VALUES (31, 'GERS');
INSERT INTO sampling_place VALUES (32, 'GIROTTE');
INSERT INTO sampling_place VALUES (33, 'GOLEON');
INSERT INTO sampling_place VALUES (34, 'GROS');
INSERT INTO sampling_place VALUES (35, 'GUYNEMER');
INSERT INTO sampling_place VALUES (36, 'INFERIORE DI LAURES');
INSERT INTO sampling_place VALUES (37, 'ISEO');
INSERT INTO sampling_place VALUES (38, 'KERLOCH');
INSERT INTO sampling_place VALUES (39, 'KRN');
INSERT INTO sampling_place VALUES (40, 'LAUVITEL');
INSERT INTO sampling_place VALUES (41, 'LAUZANIER');
INSERT INTO sampling_place VALUES (42, 'LAUZIERE');
INSERT INTO sampling_place VALUES (43, 'LEDVICAH');
INSERT INTO sampling_place VALUES (44, 'LES ROBERTS');
INSERT INTO sampling_place VALUES (45, 'LONG Mercantour');
INSERT INTO sampling_place VALUES (46, 'LOU');
INSERT INTO sampling_place VALUES (47, 'LUITEL');
INSERT INTO sampling_place VALUES (48, 'MADDALENA');
INSERT INTO sampling_place VALUES (49, 'MELO');
INSERT INTO sampling_place VALUES (50, 'MIAGE (Lac)');
INSERT INTO sampling_place VALUES (51, 'MUZELLE');
INSERT INTO sampling_place VALUES (52, 'NAR');
INSERT INTO sampling_place VALUES (53, 'NINO');
INSERT INTO sampling_place VALUES (54, 'NOIR AIGUILLE ROUGE Bas');
INSERT INTO sampling_place VALUES (55, 'ORONAYE');
INSERT INTO sampling_place VALUES (56, 'PALLUEL');
INSERT INTO sampling_place VALUES (57, 'PETAREL');
INSERT INTO sampling_place VALUES (58, 'PETIT');
INSERT INTO sampling_place VALUES (59, 'PETO');
INSERT INTO sampling_place VALUES (60, 'PLAN');
INSERT INTO sampling_place VALUES (61, 'PLAN VIANNEY');
INSERT INTO sampling_place VALUES (62, 'PLANINI');
INSERT INTO sampling_place VALUES (63, 'PONTET');
INSERT INTO sampling_place VALUES (64, 'PORMENAZ');
INSERT INTO sampling_place VALUES (65, 'PORT COUVREUX');
INSERT INTO sampling_place VALUES (66, 'POULE');
INSERT INTO sampling_place VALUES (67, 'PREDIL');
INSERT INTO sampling_place VALUES (68, 'RING ANSE');
INSERT INTO sampling_place VALUES (69, 'RIOT');
INSERT INTO sampling_place VALUES (70, 'ROCHEBUT');
INSERT INTO sampling_place VALUES (71, 'SAINT-ANDRE');
INSERT INTO sampling_place VALUES (72, 'SERRE HOMME');
INSERT INTO sampling_place VALUES (73, 'SESTO');
INSERT INTO sampling_place VALUES (74, 'SORME');
INSERT INTO sampling_place VALUES (75, 'THUILE');
INSERT INTO sampling_place VALUES (76, 'TIERCELIN');
INSERT INTO sampling_place VALUES (77, 'URBINO');
INSERT INTO sampling_place VALUES (78, 'VALLON');
INSERT INTO sampling_place VALUES (79, 'VERNEY');


--
-- TOC entry 5298 (class 0 OID 0)
-- Dependencies: 338
-- Name: sampling_place_sampling_place_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('sampling_place_sampling_place_id_seq', 79, true);


--
-- TOC entry 4833 (class 0 OID 27240)
-- Dependencies: 328
-- Data for Name: storage; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO storage VALUES (1, 2, 1, 1, NULL, '2017-06-16 15:35:41', NULL, 'cpignol', NULL);
INSERT INTO storage VALUES (2, 3, 2, 1, NULL, '2017-06-16 15:36:47', NULL, 'cpignol', NULL);
INSERT INTO storage VALUES (3, 4, 2, 1, NULL, '2017-06-16 15:39:00', NULL, 'cpignol', NULL);
INSERT INTO storage VALUES (4, 5, 1, 1, NULL, '2017-06-16 15:40:49', NULL, 'cpignol', NULL);
INSERT INTO storage VALUES (5, 6, 5, 1, NULL, '2017-06-16 15:41:44', NULL, 'cpignol', NULL);
INSERT INTO storage VALUES (6, 7, 5, 1, NULL, '2017-06-16 15:42:50', NULL, 'cpignol', NULL);
INSERT INTO storage VALUES (7, 8, 4, 1, NULL, '2017-06-16 15:51:01', NULL, 'cpignol', NULL);
INSERT INTO storage VALUES (8, 9, 4, 1, NULL, '2017-06-16 15:54:09', 'Grille B11', 'cpignol', 'pas d''étui');
INSERT INTO storage VALUES (9, 10, 4, 1, NULL, '2017-06-16 18:00:24', 'B4', 'cpignol', NULL);
INSERT INTO storage VALUES (10, 11, 4, 1, NULL, '2017-06-16 18:02:47', 'B4', 'cpignol', NULL);
INSERT INTO storage VALUES (11, 12, 4, 1, NULL, '2017-06-16 18:02:47', 'I5', 'cpignol', NULL);
INSERT INTO storage VALUES (12, 13, 4, 1, NULL, '2017-06-16 18:02:47', 'M14', 'cpignol', NULL);
INSERT INTO storage VALUES (13, 14, 4, 1, NULL, '2017-06-16 18:02:47', 'F1', 'cpignol', NULL);
INSERT INTO storage VALUES (14, 15, 4, 1, NULL, '2017-06-16 18:02:47', 'A6', 'cpignol', NULL);
INSERT INTO storage VALUES (15, 16, 4, 1, NULL, '2017-06-16 18:02:47', 'B11', 'cpignol', NULL);
INSERT INTO storage VALUES (16, 17, 4, 1, NULL, '2017-06-16 18:02:47', 'A5', 'cpignol', NULL);
INSERT INTO storage VALUES (17, 18, 4, 1, NULL, '2017-06-16 18:02:47', 'E1', 'cpignol', NULL);
INSERT INTO storage VALUES (18, 19, 4, 1, NULL, '2017-06-16 18:02:47', 'I 10', 'cpignol', NULL);
INSERT INTO storage VALUES (19, 20, 4, 1, NULL, '2017-06-16 18:02:47', 'A6', 'cpignol', NULL);
INSERT INTO storage VALUES (20, 21, 4, 1, NULL, '2017-06-16 18:02:47', 'B9', 'cpignol', NULL);
INSERT INTO storage VALUES (21, 22, 4, 1, NULL, '2017-06-16 18:02:47', 'I5', 'cpignol', NULL);
INSERT INTO storage VALUES (22, 23, 4, 1, NULL, '2017-06-16 18:02:47', 'M14', 'cpignol', NULL);
INSERT INTO storage VALUES (23, 24, 4, 1, NULL, '2017-06-16 18:02:47', 'B9', 'cpignol', NULL);
INSERT INTO storage VALUES (24, 25, 4, 1, NULL, '2017-06-16 18:02:47', 'A11', 'cpignol', NULL);
INSERT INTO storage VALUES (25, 26, 4, 1, NULL, '2017-06-16 18:02:47', 'C13', 'cpignol', NULL);
INSERT INTO storage VALUES (26, 27, 4, 1, NULL, '2017-06-16 18:02:47', 'M15', 'cpignol', NULL);
INSERT INTO storage VALUES (27, 28, 4, 1, NULL, '2017-06-16 18:02:47', 'A9', 'cpignol', NULL);
INSERT INTO storage VALUES (28, 29, 4, 1, NULL, '2017-06-16 18:02:47', 'A9', 'cpignol', NULL);
INSERT INTO storage VALUES (29, 30, 4, 1, NULL, '2017-06-16 18:02:47', 'B9', 'cpignol', NULL);
INSERT INTO storage VALUES (30, 31, 4, 1, NULL, '2017-06-16 18:02:47', 'F13', 'cpignol', NULL);
INSERT INTO storage VALUES (31, 32, 4, 1, NULL, '2017-06-16 18:02:47', 'B9', 'cpignol', NULL);
INSERT INTO storage VALUES (32, 33, 4, 1, NULL, '2017-06-16 18:02:47', 'A13', 'cpignol', NULL);
INSERT INTO storage VALUES (33, 34, 4, 1, NULL, '2017-06-16 18:02:47', 'B15', 'cpignol', NULL);
INSERT INTO storage VALUES (34, 35, 4, 1, NULL, '2017-06-16 18:02:47', 'C10', 'cpignol', NULL);
INSERT INTO storage VALUES (35, 36, 4, 1, NULL, '2017-06-16 18:02:47', 'B13', 'cpignol', NULL);
INSERT INTO storage VALUES (36, 37, 4, 1, NULL, '2017-06-16 18:02:47', 'A7', 'cpignol', NULL);
INSERT INTO storage VALUES (37, 38, 4, 1, NULL, '2017-06-16 18:02:47', 'A5', 'cpignol', NULL);
INSERT INTO storage VALUES (38, 39, 4, 1, NULL, '2017-06-16 18:02:47', 'A10', 'cpignol', NULL);
INSERT INTO storage VALUES (39, 40, 4, 1, NULL, '2017-06-16 18:02:47', 'C14', 'cpignol', NULL);
INSERT INTO storage VALUES (40, 41, 4, 1, NULL, '2017-06-16 18:02:47', 'E15', 'cpignol', NULL);
INSERT INTO storage VALUES (41, 42, 4, 1, NULL, '2017-06-16 18:02:47', 'G1', 'cpignol', NULL);
INSERT INTO storage VALUES (42, 43, 4, 1, NULL, '2017-06-16 18:02:47', 'F13', 'cpignol', NULL);
INSERT INTO storage VALUES (43, 44, 4, 1, NULL, '2017-06-16 18:02:47', 'E1', 'cpignol', NULL);
INSERT INTO storage VALUES (44, 45, 4, 1, NULL, '2017-06-16 18:02:47', 'B7', 'cpignol', NULL);
INSERT INTO storage VALUES (45, 46, 4, 1, NULL, '2017-06-16 18:02:47', 'A12', 'cpignol', NULL);
INSERT INTO storage VALUES (46, 47, 4, 1, NULL, '2017-06-16 18:02:47', 'A12', 'cpignol', NULL);
INSERT INTO storage VALUES (47, 48, 4, 1, NULL, '2017-06-16 18:02:47', 'A7', 'cpignol', NULL);
INSERT INTO storage VALUES (48, 49, 4, 1, NULL, '2017-06-16 18:02:47', 'A11', 'cpignol', NULL);
INSERT INTO storage VALUES (49, 50, 4, 1, NULL, '2017-06-16 18:02:47', 'H7', 'cpignol', NULL);
INSERT INTO storage VALUES (50, 51, 4, 1, NULL, '2017-06-16 18:02:47', 'C13', 'cpignol', NULL);
INSERT INTO storage VALUES (51, 52, 4, 1, NULL, '2017-06-16 18:02:47', 'B6', 'cpignol', NULL);
INSERT INTO storage VALUES (52, 53, 4, 1, NULL, '2017-06-16 18:02:47', 'A3', 'cpignol', NULL);
INSERT INTO storage VALUES (53, 54, 4, 1, NULL, '2017-06-16 18:02:47', 'A11', 'cpignol', NULL);
INSERT INTO storage VALUES (54, 55, 4, 1, NULL, '2017-06-16 18:02:47', 'B9', 'cpignol', NULL);
INSERT INTO storage VALUES (55, 56, 4, 1, NULL, '2017-06-16 18:02:47', 'C10', 'cpignol', NULL);
INSERT INTO storage VALUES (56, 57, 4, 1, NULL, '2017-06-16 18:02:47', 'I5', 'cpignol', NULL);
INSERT INTO storage VALUES (57, 58, 4, 1, NULL, '2017-06-16 18:02:47', 'B14', 'cpignol', NULL);
INSERT INTO storage VALUES (58, 59, 4, 1, NULL, '2017-06-16 18:02:47', 'A12', 'cpignol', NULL);
INSERT INTO storage VALUES (59, 60, 4, 1, NULL, '2017-06-16 18:02:47', 'D13', 'cpignol', NULL);
INSERT INTO storage VALUES (60, 61, 4, 1, NULL, '2017-06-16 18:02:47', 'A13', 'cpignol', NULL);
INSERT INTO storage VALUES (61, 62, 4, 1, NULL, '2017-06-16 18:02:47', 'B13', 'cpignol', NULL);
INSERT INTO storage VALUES (62, 63, 4, 1, NULL, '2017-06-16 18:02:47', 'B6', 'cpignol', NULL);
INSERT INTO storage VALUES (63, 64, 4, 1, NULL, '2017-06-16 18:02:47', 'C10', 'cpignol', NULL);
INSERT INTO storage VALUES (64, 65, 4, 1, NULL, '2017-06-16 18:02:47', 'A9', 'cpignol', NULL);
INSERT INTO storage VALUES (65, 66, 4, 1, NULL, '2017-06-16 18:02:47', 'A5', 'cpignol', NULL);
INSERT INTO storage VALUES (66, 67, 4, 1, NULL, '2017-06-16 18:02:47', 'G6', 'cpignol', NULL);
INSERT INTO storage VALUES (67, 68, 4, 1, NULL, '2017-06-16 18:02:47', 'B9', 'cpignol', NULL);
INSERT INTO storage VALUES (68, 69, 4, 1, NULL, '2017-06-16 18:02:47', 'A10', 'cpignol', NULL);
INSERT INTO storage VALUES (69, 70, 4, 1, NULL, '2017-06-16 18:02:47', 'A10', 'cpignol', NULL);
INSERT INTO storage VALUES (70, 71, 4, 1, NULL, '2017-06-16 18:02:47', 'M14', 'cpignol', NULL);
INSERT INTO storage VALUES (71, 72, 4, 1, NULL, '2017-06-16 18:02:47', 'A9', 'cpignol', NULL);
INSERT INTO storage VALUES (72, 73, 4, 1, NULL, '2017-06-16 18:02:47', 'M15', 'cpignol', NULL);
INSERT INTO storage VALUES (73, 74, 4, 1, NULL, '2017-06-16 18:02:47', 'A12', 'cpignol', NULL);
INSERT INTO storage VALUES (74, 75, 4, 1, NULL, '2017-06-16 18:02:47', 'I 10', 'cpignol', NULL);
INSERT INTO storage VALUES (75, 76, 4, 1, NULL, '2017-06-16 18:02:47', 'A3', 'cpignol', NULL);
INSERT INTO storage VALUES (76, 77, 4, 1, NULL, '2017-06-16 18:02:47', 'C10', 'cpignol', NULL);
INSERT INTO storage VALUES (77, 78, 4, 1, NULL, '2017-06-16 18:02:47', 'A10', 'cpignol', NULL);
INSERT INTO storage VALUES (78, 79, 4, 1, NULL, '2017-06-16 18:02:47', 'B4', 'cpignol', NULL);
INSERT INTO storage VALUES (79, 80, 4, 1, NULL, '2017-06-16 18:02:47', 'F1', 'cpignol', NULL);
INSERT INTO storage VALUES (80, 81, 4, 1, NULL, '2017-06-16 18:02:47', 'E13', 'cpignol', NULL);
INSERT INTO storage VALUES (81, 82, 4, 1, NULL, '2017-06-16 18:02:47', 'M14', 'cpignol', NULL);
INSERT INTO storage VALUES (82, 83, 4, 1, NULL, '2017-06-16 18:02:47', 'E15', 'cpignol', NULL);
INSERT INTO storage VALUES (83, 84, 4, 1, NULL, '2017-06-16 18:02:47', 'B15', 'cpignol', NULL);
INSERT INTO storage VALUES (84, 85, 4, 1, NULL, '2017-06-16 18:02:47', 'A4', 'cpignol', NULL);
INSERT INTO storage VALUES (85, 86, 4, 1, NULL, '2017-06-16 18:02:47', 'A13', 'cpignol', NULL);
INSERT INTO storage VALUES (86, 87, 4, 1, NULL, '2017-06-16 18:02:47', 'E13', 'cpignol', NULL);
INSERT INTO storage VALUES (87, 89, 71, 1, NULL, '2017-06-16 19:27:24', 'M14', 'cpignol', NULL);
INSERT INTO storage VALUES (88, 91, 4, 1, NULL, '2017-06-19 10:32:44', 'C1 P2', 'cpignol', NULL);
INSERT INTO storage VALUES (89, 90, 89, 1, NULL, '2017-06-19 10:32:44', 'I5', 'cpignol', NULL);
INSERT INTO storage VALUES (90, 92, 11, 1, NULL, '2017-06-19 11:01:04', 'B4', 'cpignol', NULL);


--
-- TOC entry 4835 (class 0 OID 27251)
-- Dependencies: 330
-- Data for Name: storage_condition; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--

INSERT INTO storage_condition VALUES (1, 'Froid 4°C');
INSERT INTO storage_condition VALUES (2, 'Sec 20°C');


--
-- TOC entry 5299 (class 0 OID 0)
-- Dependencies: 329
-- Name: storage_condition_storage_condition_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('storage_condition_storage_condition_id_seq', 2, true);


--
-- TOC entry 4837 (class 0 OID 27262)
-- Dependencies: 332
-- Data for Name: storage_reason; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--



--
-- TOC entry 5300 (class 0 OID 0)
-- Dependencies: 331
-- Name: storage_reason_storage_reason_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('storage_reason_storage_reason_id_seq', 1, false);


--
-- TOC entry 5301 (class 0 OID 0)
-- Dependencies: 327
-- Name: storage_storage_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('storage_storage_id_seq', 90, true);


--
-- TOC entry 4839 (class 0 OID 27273)
-- Dependencies: 334
-- Data for Name: subsample; Type: TABLE DATA; Schema: zaalpes; Owner: collec
--



--
-- TOC entry 5302 (class 0 OID 0)
-- Dependencies: 333
-- Name: subsample_subsample_id_seq; Type: SEQUENCE SET; Schema: zaalpes; Owner: collec
--

SELECT pg_catalog.setval('subsample_subsample_id_seq', 1, false);


SET search_path = zapvs, pg_catalog;

--
-- TOC entry 4847 (class 0 OID 35084)
-- Dependencies: 346
-- Data for Name: booking; Type: TABLE DATA; Schema: zapvs; Owner: collec
--



--
-- TOC entry 5303 (class 0 OID 0)
-- Dependencies: 345
-- Name: booking_booking_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('booking_booking_id_seq', 1, false);


--
-- TOC entry 4849 (class 0 OID 35095)
-- Dependencies: 348
-- Data for Name: container; Type: TABLE DATA; Schema: zapvs; Owner: collec
--



--
-- TOC entry 5304 (class 0 OID 0)
-- Dependencies: 347
-- Name: container_container_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('container_container_id_seq', 1, false);


--
-- TOC entry 4851 (class 0 OID 35103)
-- Dependencies: 350
-- Data for Name: container_family; Type: TABLE DATA; Schema: zapvs; Owner: collec
--

INSERT INTO container_family VALUES (1, 'Immobilier', false);
INSERT INTO container_family VALUES (2, 'Mobilier', false);


--
-- TOC entry 5305 (class 0 OID 0)
-- Dependencies: 349
-- Name: container_family_container_family_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('container_family_container_family_id_seq', 2, true);


--
-- TOC entry 4853 (class 0 OID 35115)
-- Dependencies: 352
-- Data for Name: container_type; Type: TABLE DATA; Schema: zapvs; Owner: collec
--

INSERT INTO container_type VALUES (1, 'Site', 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO container_type VALUES (2, 'Bâtiment', 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO container_type VALUES (3, 'Pièce', 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO container_type VALUES (4, 'Armoire', 2, NULL, NULL, NULL, NULL, NULL);
INSERT INTO container_type VALUES (5, 'Congélateur', 2, NULL, NULL, NULL, NULL, NULL);
INSERT INTO container_type VALUES (6, 'Etagère', 2, NULL, NULL, 'Armoire ou étagère de rangement', NULL, NULL);
INSERT INTO container_type VALUES (7, 'Carton', 1, NULL, NULL, 'Carton de déménagement contenant des piluliers ou des boîtes pour mini-tubes', NULL, NULL);
INSERT INTO container_type VALUES (8, 'Boites de 100 mini-tubes', 1, NULL, NULL, 'Boites  en carton contenant 100 mini-tubes d''entomo', NULL, NULL);
INSERT INTO container_type VALUES (9, 'Pilulier', 2, NULL, NULL, 'Pilulier', NULL, NULL);


--
-- TOC entry 5306 (class 0 OID 0)
-- Dependencies: 351
-- Name: container_type_container_type_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('container_type_container_type_id_seq', 9, true);


--
-- TOC entry 4855 (class 0 OID 35126)
-- Dependencies: 354
-- Data for Name: document; Type: TABLE DATA; Schema: zapvs; Owner: collec
--



--
-- TOC entry 5307 (class 0 OID 0)
-- Dependencies: 353
-- Name: document_document_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('document_document_id_seq', 1, false);


--
-- TOC entry 4857 (class 0 OID 35137)
-- Dependencies: 356
-- Data for Name: event; Type: TABLE DATA; Schema: zapvs; Owner: collec
--



--
-- TOC entry 5308 (class 0 OID 0)
-- Dependencies: 355
-- Name: event_event_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('event_event_id_seq', 1, false);


--
-- TOC entry 4859 (class 0 OID 35148)
-- Dependencies: 358
-- Data for Name: event_type; Type: TABLE DATA; Schema: zapvs; Owner: collec
--

INSERT INTO event_type VALUES (1, 'Autre', true, true);
INSERT INTO event_type VALUES (2, 'Conteneur cassé', false, true);
INSERT INTO event_type VALUES (3, 'Échantillon détruit', true, false);
INSERT INTO event_type VALUES (4, 'Prélèvement pour analyse', true, false);
INSERT INTO event_type VALUES (5, 'Échantillon totalement analysé, détruit', true, false);


--
-- TOC entry 5309 (class 0 OID 0)
-- Dependencies: 357
-- Name: event_type_event_type_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('event_type_event_type_id_seq', 5, true);


--
-- TOC entry 4861 (class 0 OID 35161)
-- Dependencies: 360
-- Data for Name: identifier_type; Type: TABLE DATA; Schema: zapvs; Owner: collec
--



--
-- TOC entry 5310 (class 0 OID 0)
-- Dependencies: 359
-- Name: identifier_type_identifier_type_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('identifier_type_identifier_type_id_seq', 1, false);


--
-- TOC entry 4863 (class 0 OID 35172)
-- Dependencies: 362
-- Data for Name: label; Type: TABLE DATA; Schema: zapvs; Owner: collec
--

INSERT INTO label VALUES (1, 'Exemple - ne pas utiliser', '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="objects">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="label"
              page-height="5cm" page-width="10cm" margin-left="0.5cm" margin-top="0.5cm" margin-bottom="0cm" margin-right="0.5cm">  
              <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      
      <fo:page-sequence master-reference="label">
         <fo:flow flow-name="xsl-region-body">        
          <fo:block>
          <xsl:apply-templates select="object" />
          </fo:block>

        </fo:flow>
      </fo:page-sequence>
    </fo:root>
   </xsl:template>
  <xsl:template match="object">

  <fo:table table-layout="fixed" border-collapse="collapse"  border-style="none" width="8cm" keep-together.within-page="always">
  <fo:table-column column-width="4cm"/>
  <fo:table-column column-width="4cm" />
 <fo:table-body  border-style="none" >
 	<fo:table-row>
  		<fo:table-cell> 
  		<fo:block>
  		<fo:external-graphic>
      <xsl:attribute name="src">
             <xsl:value-of select="concat(uid,''.png'')" />
       </xsl:attribute>
       <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
       <xsl:attribute name="height">4cm</xsl:attribute>
        <xsl:attribute name="content-width">4cm</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
      
       </fo:external-graphic>
 		</fo:block>
   		</fo:table-cell>
  		<fo:table-cell>
<fo:block><fo:inline font-weight="bold">IRSTEA</fo:inline></fo:block>
  			<fo:block>uid:<fo:inline font-weight="bold"><xsl:value-of select="db"/>:<xsl:value-of select="uid"/></fo:inline></fo:block>
  			<fo:block>id:<fo:inline font-weight="bold"><xsl:value-of select="id"/></fo:inline></fo:block>
  			<fo:block>prj:<fo:inline font-weight="bold"><xsl:value-of select="prj"/></fo:inline></fo:block>
  			<fo:block>clp:<fo:inline font-weight="bold"><xsl:value-of select="clp"/></fo:inline></fo:block>
  		</fo:table-cell>
  	  	</fo:table-row>
  </fo:table-body>
  </fo:table>
   <fo:block page-break-after="always"/>

  </xsl:template>
</xsl:stylesheet>', 'uid,id,clp,db,prj', NULL);
INSERT INTO label VALUES (2, 'Etiquette_pot_piege_collecte', '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="objects">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="label"
              page-height="3.2cm" page-width="5.7cm" margin-left="0.35cm" margin-top="0.1cm" margin-bottom="0.1cm" margin-right="0.35cm">  
              <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      
      <fo:page-sequence master-reference="label">
         <fo:flow flow-name="xsl-region-body">        
          <fo:block>
          <xsl:apply-templates select="object" />
          </fo:block>

        </fo:flow>
      </fo:page-sequence>
    </fo:root>
   </xsl:template>
  <xsl:template match="object">

  <fo:table table-layout="fixed" border-collapse="collapse"  border-style="none" width="5cm" keep-together.within-page="always">
  <fo:table-column column-width="2cm"/>
  <fo:table-column column-width="3cm" />
 <fo:table-body  border-style="none" >
    <fo:table-row>
        <fo:table-cell> 
        <fo:block>
        <fo:external-graphic>
      <xsl:attribute name="src">
             <xsl:value-of select="concat(uid,''.png'')" />
       </xsl:attribute>
       <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
       <xsl:attribute name="height">1.9cm</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
       </fo:external-graphic>
        </fo:block>
<fo:block  linefeed-treatment="preserve"><fo:inline font-size="9pt" font-weight="bold">pot: <xsl:value-of select="id"/></fo:inline></fo:block>
            <fo:block><fo:inline font-size="6pt"><xsl:value-of select="x"/></fo:inline></fo:block> 
        </fo:table-cell>
        <fo:table-cell> 
<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
            <!-- <fo:block font-size="9pt">uid:<fo:inline font-weight="bold"><xsl:value-of select="db"/>:<xsl:value-of select="uid"/></fo:inline></fo:block>-->
            <fo:block><fo:inline font-size="9pt"><xsl:value-of select="PROTOCOLE"/>/<xsl:value-of select="ANNEE"/></fo:inline></fo:block>
            <fo:block><fo:inline font-size="8pt">c <xsl:value-of select="CARRE"/></fo:inline></fo:block>
            <fo:block><fo:inline font-size="8pt">p <xsl:value-of select="PARCELLE"/></fo:inline></fo:block>
            <fo:block><fo:inline font-size="9pt">session <xsl:value-of select="SESSION"/>, <xsl:value-of select="cd"/></fo:inline></fo:block>
            <fo:block><fo:inline font-size="6pt">, <xsl:value-of select="y"/></fo:inline></fo:block> 
        </fo:table-cell>
        </fo:table-row>
  </fo:table-body>
  </fo:table>
  </xsl:template>
</xsl:stylesheet>', 'db,uid,id,x,y,cd,PROTOCOLE,ANNEE,SESSION,CARRE,PARCELLE', NULL);


--
-- TOC entry 5311 (class 0 OID 0)
-- Dependencies: 361
-- Name: label_label_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('label_label_id_seq', 2, true);


--
-- TOC entry 4898 (class 0 OID 35593)
-- Dependencies: 400
-- Data for Name: metadata_form; Type: TABLE DATA; Schema: zapvs; Owner: collec
--

INSERT INTO metadata_form VALUES (1, '[{"nom":"PROTOCOLE","type":"select","choiceList":["PANTRAP","BARBER","F.FAUCHOIR","PRED.GRAINE","TOURNESOL","TENTE.EMERG"],"require":true,"helperChoice":false,"description":"PANTRAP","meusureUnit":"PANTRAP, BARBER, F.FAUCHOIR, PRED.GRAINE, TOURNESOL, TENTE.EMERG"},{"nom":"ANNEE","type":"number","require":true,"helperChoice":true,"helper":"Année de récolte sur 4 digits","description":"Année de récolte sur 4 digits","meusureUnit":"sans"},{"nom":"SESSION","type":"select","choiceList":["1","2"],"require":true,"helperChoice":true,"helper":"Numéro de session terrain","description":"Numéro de session terrain","meusureUnit":"Sans (1 ou 2)"},{"nom":"CARRE","type":"string","require":true,"helperChoice":true,"helper":"Numéro du carré farmland","description":"Numéro du carré farmland","meusureUnit":"Sans"},{"nom":"PARCELLE","type":"string","require":true,"helperChoice":true,"helper":"Identifiant de la parcelle de culture","description":"Identifiant de la parcelle de culture","meusureUnit":"Sans"},{"nom":"OBSERVATEUR","type":"string","require":true,"helperChoice":true,"helper":"Le prénom et le nom de l''opérateur terrain.","description":"Le prénom et le nom de l''opérateur terrain.","meusureUnit":"Sans"}]');


--
-- TOC entry 5312 (class 0 OID 0)
-- Dependencies: 399
-- Name: metadata_form_metadata_form_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('metadata_form_metadata_form_id_seq', 1, true);


--
-- TOC entry 4865 (class 0 OID 35220)
-- Dependencies: 364
-- Data for Name: mime_type; Type: TABLE DATA; Schema: zapvs; Owner: collec
--

INSERT INTO mime_type VALUES (1, 'pdf', 'application/pdf');
INSERT INTO mime_type VALUES (2, 'zip', 'application/zip');
INSERT INTO mime_type VALUES (3, 'mp3', 'audio/mpeg');
INSERT INTO mime_type VALUES (4, 'jpg', 'image/jpeg');
INSERT INTO mime_type VALUES (5, 'jpeg', 'image/jpeg');
INSERT INTO mime_type VALUES (6, 'png', 'image/png');
INSERT INTO mime_type VALUES (7, 'tiff', 'image/tiff');
INSERT INTO mime_type VALUES (9, 'odt', 'application/vnd.oasis.opendocument.text');
INSERT INTO mime_type VALUES (10, 'ods', 'application/vnd.oasis.opendocument.spreadsheet');
INSERT INTO mime_type VALUES (11, 'xls', 'application/vnd.ms-excel');
INSERT INTO mime_type VALUES (12, 'xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
INSERT INTO mime_type VALUES (13, 'doc', 'application/msword');
INSERT INTO mime_type VALUES (14, 'docx', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document');
INSERT INTO mime_type VALUES (8, 'csv', 'text/csv');


--
-- TOC entry 5313 (class 0 OID 0)
-- Dependencies: 363
-- Name: mime_type_mime_type_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('mime_type_mime_type_id_seq', 1, false);


--
-- TOC entry 4867 (class 0 OID 35231)
-- Dependencies: 366
-- Data for Name: movement_type; Type: TABLE DATA; Schema: zapvs; Owner: collec
--

INSERT INTO movement_type VALUES (1, 'Entrée/Entry');
INSERT INTO movement_type VALUES (2, 'Sortie/Exit');


--
-- TOC entry 5314 (class 0 OID 0)
-- Dependencies: 365
-- Name: movement_type_movement_type_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('movement_type_movement_type_id_seq', 1, false);


--
-- TOC entry 4869 (class 0 OID 35242)
-- Dependencies: 368
-- Data for Name: multiple_type; Type: TABLE DATA; Schema: zapvs; Owner: collec
--

INSERT INTO multiple_type VALUES (1, 'Unité');
INSERT INTO multiple_type VALUES (2, 'Pourcentage');
INSERT INTO multiple_type VALUES (3, 'Quantité ou volume');
INSERT INTO multiple_type VALUES (4, 'Autre');


--
-- TOC entry 5315 (class 0 OID 0)
-- Dependencies: 367
-- Name: multiple_type_multiple_type_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('multiple_type_multiple_type_id_seq', 4, true);


--
-- TOC entry 4871 (class 0 OID 35253)
-- Dependencies: 370
-- Data for Name: object; Type: TABLE DATA; Schema: zapvs; Owner: collec
--

INSERT INTO object VALUES (1, '1a', 1, -0.476806741207838114, 46.1417827375923082);


--
-- TOC entry 4873 (class 0 OID 35264)
-- Dependencies: 372
-- Data for Name: object_identifier; Type: TABLE DATA; Schema: zapvs; Owner: collec
--



--
-- TOC entry 5316 (class 0 OID 0)
-- Dependencies: 371
-- Name: object_identifier_object_identifier_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('object_identifier_object_identifier_id_seq', 1, false);


--
-- TOC entry 4875 (class 0 OID 35275)
-- Dependencies: 374
-- Data for Name: object_status; Type: TABLE DATA; Schema: zapvs; Owner: collec
--

INSERT INTO object_status VALUES (1, 'État normal');
INSERT INTO object_status VALUES (2, 'Objet pré-réservé pour usage ultérieur');
INSERT INTO object_status VALUES (3, 'Objet détruit');
INSERT INTO object_status VALUES (4, 'Echantillon vidé de tout contenu');


--
-- TOC entry 5317 (class 0 OID 0)
-- Dependencies: 373
-- Name: object_status_object_status_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('object_status_object_status_id_seq', 4, true);


--
-- TOC entry 5318 (class 0 OID 0)
-- Dependencies: 369
-- Name: object_uid_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('object_uid_seq', 1, true);


--
-- TOC entry 4877 (class 0 OID 35286)
-- Dependencies: 376
-- Data for Name: operation; Type: TABLE DATA; Schema: zapvs; Owner: collec
--

INSERT INTO operation VALUES (1, 1, 'collecte_terrain', 1, 1, 'v1', '2017-07-18 09:38:27');


--
-- TOC entry 5319 (class 0 OID 0)
-- Dependencies: 375
-- Name: operation_operation_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('operation_operation_id_seq', 1, true);


--
-- TOC entry 4879 (class 0 OID 35297)
-- Dependencies: 378
-- Data for Name: project; Type: TABLE DATA; Schema: zapvs; Owner: collec
--

INSERT INTO project VALUES (1, 'Pots_pièges');


--
-- TOC entry 4880 (class 0 OID 35306)
-- Dependencies: 379
-- Data for Name: project_group; Type: TABLE DATA; Schema: zapvs; Owner: collec
--

INSERT INTO project_group VALUES (1, 34);
INSERT INTO project_group VALUES (1, 33);


--
-- TOC entry 5320 (class 0 OID 0)
-- Dependencies: 377
-- Name: project_project_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('project_project_id_seq', 1, true);


--
-- TOC entry 4882 (class 0 OID 35313)
-- Dependencies: 381
-- Data for Name: protocol; Type: TABLE DATA; Schema: zapvs; Owner: collec
--

INSERT INTO protocol VALUES (1, 'pots_pièges', NULL, 2017, '1.0');


--
-- TOC entry 5321 (class 0 OID 0)
-- Dependencies: 380
-- Name: protocol_protocol_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('protocol_protocol_id_seq', 1, true);


--
-- TOC entry 4884 (class 0 OID 35325)
-- Dependencies: 383
-- Data for Name: sample; Type: TABLE DATA; Schema: zapvs; Owner: collec
--

INSERT INTO sample VALUES (1, 1, 1, 1, '2017-07-18 09:44:20', '2017-07-18 09:44:20', NULL, NULL, 8, 1, NULL);


--
-- TOC entry 4900 (class 0 OID 35604)
-- Dependencies: 402
-- Data for Name: sample_metadata; Type: TABLE DATA; Schema: zapvs; Owner: collec
--

INSERT INTO sample_metadata VALUES (1, '{"PROTOCOLE":"PANTRAP","ANNEE":2017,"SESSION":"1","CARRE":"123456789","PARCELLE":"159159159","OBSERVATEUR":"Thierry Fanjas"}');


--
-- TOC entry 5322 (class 0 OID 0)
-- Dependencies: 401
-- Name: sample_metadata_sample_metadata_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('sample_metadata_sample_metadata_id_seq', 1, true);


--
-- TOC entry 5323 (class 0 OID 0)
-- Dependencies: 382
-- Name: sample_sample_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('sample_sample_id_seq', 1, true);


--
-- TOC entry 4886 (class 0 OID 35341)
-- Dependencies: 385
-- Data for Name: sample_type; Type: TABLE DATA; Schema: zapvs; Owner: collec
--

INSERT INTO sample_type VALUES (1, 'pot_piège_terrain', 9, 1, NULL, NULL);


--
-- TOC entry 5324 (class 0 OID 0)
-- Dependencies: 384
-- Name: sample_type_sample_type_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('sample_type_sample_type_id_seq', 1, true);


--
-- TOC entry 4896 (class 0 OID 35574)
-- Dependencies: 398
-- Data for Name: sampling_place; Type: TABLE DATA; Schema: zapvs; Owner: collec
--

INSERT INTO sampling_place VALUES (10, 'Sainte-Blandine (SB)');
INSERT INTO sampling_place VALUES (11, 'Vaubalier (VA)');
INSERT INTO sampling_place VALUES (9, 'Ruralies (RU)');
INSERT INTO sampling_place VALUES (1, 'Beauvoir (BE)');
INSERT INTO sampling_place VALUES (2, 'Cherves (CH)');
INSERT INTO sampling_place VALUES (3, 'ForetChizé (FC)');
INSERT INTO sampling_place VALUES (5, 'Fors (FO)');
INSERT INTO sampling_place VALUES (4, 'Foye-Monjault (FM)');
INSERT INTO sampling_place VALUES (6, 'Mougon (MO)');
INSERT INTO sampling_place VALUES (7, 'Nouveau secteur (NO)');
INSERT INTO sampling_place VALUES (8, 'Prissé (PR)');


--
-- TOC entry 5325 (class 0 OID 0)
-- Dependencies: 397
-- Name: sampling_place_sampling_place_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('sampling_place_sampling_place_id_seq', 12, true);


--
-- TOC entry 4888 (class 0 OID 35352)
-- Dependencies: 387
-- Data for Name: storage; Type: TABLE DATA; Schema: zapvs; Owner: collec
--



--
-- TOC entry 4890 (class 0 OID 35363)
-- Dependencies: 389
-- Data for Name: storage_condition; Type: TABLE DATA; Schema: zapvs; Owner: collec
--



--
-- TOC entry 5326 (class 0 OID 0)
-- Dependencies: 388
-- Name: storage_condition_storage_condition_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('storage_condition_storage_condition_id_seq', 1, false);


--
-- TOC entry 4892 (class 0 OID 35374)
-- Dependencies: 391
-- Data for Name: storage_reason; Type: TABLE DATA; Schema: zapvs; Owner: collec
--



--
-- TOC entry 5327 (class 0 OID 0)
-- Dependencies: 390
-- Name: storage_reason_storage_reason_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('storage_reason_storage_reason_id_seq', 1, false);


--
-- TOC entry 5328 (class 0 OID 0)
-- Dependencies: 386
-- Name: storage_storage_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('storage_storage_id_seq', 1, false);


--
-- TOC entry 4894 (class 0 OID 35385)
-- Dependencies: 393
-- Data for Name: subsample; Type: TABLE DATA; Schema: zapvs; Owner: collec
--



--
-- TOC entry 5329 (class 0 OID 0)
-- Dependencies: 392
-- Name: subsample_subsample_id_seq; Type: SEQUENCE SET; Schema: zapvs; Owner: collec
--

SELECT pg_catalog.setval('subsample_subsample_id_seq', 1, false);


SET search_path = col, pg_catalog;

--
-- TOC entry 4311 (class 2606 OID 18190)
-- Name: booking_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY booking
    ADD CONSTRAINT booking_pk PRIMARY KEY (booking_id);


--
-- TOC entry 4315 (class 2606 OID 18210)
-- Name: container_family_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container_family
    ADD CONSTRAINT container_family_pk PRIMARY KEY (container_family_id);


--
-- TOC entry 4313 (class 2606 OID 18198)
-- Name: container_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container
    ADD CONSTRAINT container_pk PRIMARY KEY (container_id);


--
-- TOC entry 4317 (class 2606 OID 18221)
-- Name: container_type_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container_type
    ADD CONSTRAINT container_type_pk PRIMARY KEY (container_type_id);


--
-- TOC entry 4319 (class 2606 OID 18232)
-- Name: document_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY document
    ADD CONSTRAINT document_pk PRIMARY KEY (document_id);


--
-- TOC entry 4321 (class 2606 OID 18243)
-- Name: event_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY event
    ADD CONSTRAINT event_pk PRIMARY KEY (event_id);


--
-- TOC entry 4323 (class 2606 OID 18256)
-- Name: event_type_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY event_type
    ADD CONSTRAINT event_type_pk PRIMARY KEY (event_type_id);


--
-- TOC entry 4325 (class 2606 OID 18267)
-- Name: identifier_type_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY identifier_type
    ADD CONSTRAINT identifier_type_pk PRIMARY KEY (identifier_type_id);


--
-- TOC entry 4327 (class 2606 OID 18279)
-- Name: label_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY label
    ADD CONSTRAINT label_pk PRIMARY KEY (label_id);


--
-- TOC entry 4365 (class 2606 OID 26896)
-- Name: metadata_form_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY metadata_form
    ADD CONSTRAINT metadata_form_pk PRIMARY KEY (metadata_form_id);


--
-- TOC entry 4329 (class 2606 OID 18326)
-- Name: mime_type_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY mime_type
    ADD CONSTRAINT mime_type_pk PRIMARY KEY (mime_type_id);


--
-- TOC entry 4331 (class 2606 OID 18337)
-- Name: movement_type_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY movement_type
    ADD CONSTRAINT movement_type_pk PRIMARY KEY (movement_type_id);


--
-- TOC entry 4333 (class 2606 OID 18348)
-- Name: multiple_type_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY multiple_type
    ADD CONSTRAINT multiple_type_pk PRIMARY KEY (multiple_type_id);


--
-- TOC entry 4337 (class 2606 OID 18370)
-- Name: object_identifier_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY object_identifier
    ADD CONSTRAINT object_identifier_pk PRIMARY KEY (object_identifier_id);


--
-- TOC entry 4335 (class 2606 OID 18359)
-- Name: object_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY object
    ADD CONSTRAINT object_pk PRIMARY KEY (uid);


--
-- TOC entry 4339 (class 2606 OID 18381)
-- Name: object_status_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY object_status
    ADD CONSTRAINT object_status_pk PRIMARY KEY (object_status_id);


--
-- TOC entry 4341 (class 2606 OID 26927)
-- Name: operation_name_version_unique; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY operation
    ADD CONSTRAINT operation_name_version_unique UNIQUE (operation_name, operation_version);


--
-- TOC entry 4343 (class 2606 OID 18392)
-- Name: operation_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY operation
    ADD CONSTRAINT operation_pk PRIMARY KEY (operation_id);


--
-- TOC entry 4347 (class 2606 OID 18408)
-- Name: project_group_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY project_group
    ADD CONSTRAINT project_group_pk PRIMARY KEY (project_id, aclgroup_id);


--
-- TOC entry 4345 (class 2606 OID 18403)
-- Name: project_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_pk PRIMARY KEY (project_id);


--
-- TOC entry 4349 (class 2606 OID 18420)
-- Name: protocol_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY protocol
    ADD CONSTRAINT protocol_pk PRIMARY KEY (protocol_id);


--
-- TOC entry 4367 (class 2606 OID 26958)
-- Name: sample_metadata_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample_metadata
    ADD CONSTRAINT sample_metadata_pk PRIMARY KEY (sample_metadata_id);


--
-- TOC entry 4351 (class 2606 OID 18428)
-- Name: sample_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_pk PRIMARY KEY (sample_id);


--
-- TOC entry 4353 (class 2606 OID 18447)
-- Name: sample_type_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample_type
    ADD CONSTRAINT sample_type_pk PRIMARY KEY (sample_type_id);


--
-- TOC entry 4363 (class 2606 OID 18681)
-- Name: sampling_place_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sampling_place
    ADD CONSTRAINT sampling_place_pk PRIMARY KEY (sampling_place_id);


--
-- TOC entry 4357 (class 2606 OID 18469)
-- Name: storage_condition_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage_condition
    ADD CONSTRAINT storage_condition_pk PRIMARY KEY (storage_condition_id);


--
-- TOC entry 4355 (class 2606 OID 18458)
-- Name: storage_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT storage_pk PRIMARY KEY (storage_id);


--
-- TOC entry 4359 (class 2606 OID 18480)
-- Name: storage_reason_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage_reason
    ADD CONSTRAINT storage_reason_pk PRIMARY KEY (storage_reason_id);


--
-- TOC entry 4361 (class 2606 OID 18491)
-- Name: subsample_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY subsample
    ADD CONSTRAINT subsample_pk PRIMARY KEY (subsample_id);


SET search_path = gacl, pg_catalog;

--
-- TOC entry 4291 (class 2606 OID 18055)
-- Name: aclacl_pk; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclacl
    ADD CONSTRAINT aclacl_pk PRIMARY KEY (aclaco_id, aclgroup_id);


--
-- TOC entry 4293 (class 2606 OID 18066)
-- Name: aclaco_pk; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclaco
    ADD CONSTRAINT aclaco_pk PRIMARY KEY (aclaco_id);


--
-- TOC entry 4295 (class 2606 OID 18077)
-- Name: aclappli_pk; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclappli
    ADD CONSTRAINT aclappli_pk PRIMARY KEY (aclappli_id);


--
-- TOC entry 4297 (class 2606 OID 18088)
-- Name: aclgroup_pk; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclgroup
    ADD CONSTRAINT aclgroup_pk PRIMARY KEY (aclgroup_id);


--
-- TOC entry 4299 (class 2606 OID 18099)
-- Name: acllogin_pk; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY acllogin
    ADD CONSTRAINT acllogin_pk PRIMARY KEY (acllogin_id);


--
-- TOC entry 4301 (class 2606 OID 18104)
-- Name: acllogingroup_pk; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY acllogingroup
    ADD CONSTRAINT acllogingroup_pk PRIMARY KEY (acllogin_id, aclgroup_id);


--
-- TOC entry 4309 (class 2606 OID 18171)
-- Name: log_pk; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY log
    ADD CONSTRAINT log_pk PRIMARY KEY (log_id);


--
-- TOC entry 4305 (class 2606 OID 18155)
-- Name: login_oldpassword_pk; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY login_oldpassword
    ADD CONSTRAINT login_oldpassword_pk PRIMARY KEY (login_oldpassword_id);


--
-- TOC entry 4303 (class 2606 OID 18143)
-- Name: pk_logingestion; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY logingestion
    ADD CONSTRAINT pk_logingestion PRIMARY KEY (id);


SET search_path = zaalpes, pg_catalog;

--
-- TOC entry 4369 (class 2606 OID 26980)
-- Name: booking_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY booking
    ADD CONSTRAINT booking_pk PRIMARY KEY (booking_id);


--
-- TOC entry 4373 (class 2606 OID 27000)
-- Name: container_family_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY container_family
    ADD CONSTRAINT container_family_pk PRIMARY KEY (container_family_id);


--
-- TOC entry 4371 (class 2606 OID 26988)
-- Name: container_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY container
    ADD CONSTRAINT container_pk PRIMARY KEY (container_id);


--
-- TOC entry 4375 (class 2606 OID 27011)
-- Name: container_type_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY container_type
    ADD CONSTRAINT container_type_pk PRIMARY KEY (container_type_id);


--
-- TOC entry 4377 (class 2606 OID 27022)
-- Name: document_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY document
    ADD CONSTRAINT document_pk PRIMARY KEY (document_id);


--
-- TOC entry 4379 (class 2606 OID 27033)
-- Name: event_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY event
    ADD CONSTRAINT event_pk PRIMARY KEY (event_id);


--
-- TOC entry 4381 (class 2606 OID 27046)
-- Name: event_type_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY event_type
    ADD CONSTRAINT event_type_pk PRIMARY KEY (event_type_id);


--
-- TOC entry 4383 (class 2606 OID 27057)
-- Name: identifier_type_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY identifier_type
    ADD CONSTRAINT identifier_type_pk PRIMARY KEY (identifier_type_id);


--
-- TOC entry 4385 (class 2606 OID 27069)
-- Name: label_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY label
    ADD CONSTRAINT label_pk PRIMARY KEY (label_id);


--
-- TOC entry 4423 (class 2606 OID 27492)
-- Name: metadata_form_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY metadata_form
    ADD CONSTRAINT metadata_form_pk PRIMARY KEY (metadata_form_id);


--
-- TOC entry 4387 (class 2606 OID 27116)
-- Name: mime_type_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY mime_type
    ADD CONSTRAINT mime_type_pk PRIMARY KEY (mime_type_id);


--
-- TOC entry 4389 (class 2606 OID 27127)
-- Name: movement_type_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY movement_type
    ADD CONSTRAINT movement_type_pk PRIMARY KEY (movement_type_id);


--
-- TOC entry 4391 (class 2606 OID 27138)
-- Name: multiple_type_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY multiple_type
    ADD CONSTRAINT multiple_type_pk PRIMARY KEY (multiple_type_id);


--
-- TOC entry 4395 (class 2606 OID 27160)
-- Name: object_identifier_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY object_identifier
    ADD CONSTRAINT object_identifier_pk PRIMARY KEY (object_identifier_id);


--
-- TOC entry 4393 (class 2606 OID 27149)
-- Name: object_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY object
    ADD CONSTRAINT object_pk PRIMARY KEY (uid);


--
-- TOC entry 4397 (class 2606 OID 27171)
-- Name: object_status_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY object_status
    ADD CONSTRAINT object_status_pk PRIMARY KEY (object_status_id);


--
-- TOC entry 4399 (class 2606 OID 27505)
-- Name: operation_name_version_unique; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY operation
    ADD CONSTRAINT operation_name_version_unique UNIQUE (operation_name, operation_version);


--
-- TOC entry 4401 (class 2606 OID 27182)
-- Name: operation_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY operation
    ADD CONSTRAINT operation_pk PRIMARY KEY (operation_id);


--
-- TOC entry 4405 (class 2606 OID 27198)
-- Name: project_group_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY project_group
    ADD CONSTRAINT project_group_pk PRIMARY KEY (project_id, aclgroup_id);


--
-- TOC entry 4403 (class 2606 OID 27193)
-- Name: project_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_pk PRIMARY KEY (project_id);


--
-- TOC entry 4407 (class 2606 OID 27210)
-- Name: protocol_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY protocol
    ADD CONSTRAINT protocol_pk PRIMARY KEY (protocol_id);


--
-- TOC entry 4425 (class 2606 OID 27503)
-- Name: sample_metadata_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY sample_metadata
    ADD CONSTRAINT sample_metadata_pk PRIMARY KEY (sample_metadata_id);


--
-- TOC entry 4409 (class 2606 OID 27218)
-- Name: sample_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_pk PRIMARY KEY (sample_id);


--
-- TOC entry 4411 (class 2606 OID 27237)
-- Name: sample_type_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY sample_type
    ADD CONSTRAINT sample_type_pk PRIMARY KEY (sample_type_id);


--
-- TOC entry 4421 (class 2606 OID 27473)
-- Name: sampling_place_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY sampling_place
    ADD CONSTRAINT sampling_place_pk PRIMARY KEY (sampling_place_id);


--
-- TOC entry 4415 (class 2606 OID 27259)
-- Name: storage_condition_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY storage_condition
    ADD CONSTRAINT storage_condition_pk PRIMARY KEY (storage_condition_id);


--
-- TOC entry 4413 (class 2606 OID 27248)
-- Name: storage_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT storage_pk PRIMARY KEY (storage_id);


--
-- TOC entry 4417 (class 2606 OID 27270)
-- Name: storage_reason_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY storage_reason
    ADD CONSTRAINT storage_reason_pk PRIMARY KEY (storage_reason_id);


--
-- TOC entry 4419 (class 2606 OID 27281)
-- Name: subsample_pk; Type: CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY subsample
    ADD CONSTRAINT subsample_pk PRIMARY KEY (subsample_id);


SET search_path = zapvs, pg_catalog;

--
-- TOC entry 4427 (class 2606 OID 35092)
-- Name: booking_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY booking
    ADD CONSTRAINT booking_pk PRIMARY KEY (booking_id);


--
-- TOC entry 4431 (class 2606 OID 35112)
-- Name: container_family_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY container_family
    ADD CONSTRAINT container_family_pk PRIMARY KEY (container_family_id);


--
-- TOC entry 4429 (class 2606 OID 35100)
-- Name: container_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY container
    ADD CONSTRAINT container_pk PRIMARY KEY (container_id);


--
-- TOC entry 4433 (class 2606 OID 35123)
-- Name: container_type_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY container_type
    ADD CONSTRAINT container_type_pk PRIMARY KEY (container_type_id);


--
-- TOC entry 4435 (class 2606 OID 35134)
-- Name: document_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY document
    ADD CONSTRAINT document_pk PRIMARY KEY (document_id);


--
-- TOC entry 4437 (class 2606 OID 35145)
-- Name: event_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY event
    ADD CONSTRAINT event_pk PRIMARY KEY (event_id);


--
-- TOC entry 4439 (class 2606 OID 35158)
-- Name: event_type_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY event_type
    ADD CONSTRAINT event_type_pk PRIMARY KEY (event_type_id);


--
-- TOC entry 4441 (class 2606 OID 35169)
-- Name: identifier_type_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY identifier_type
    ADD CONSTRAINT identifier_type_pk PRIMARY KEY (identifier_type_id);


--
-- TOC entry 4443 (class 2606 OID 35181)
-- Name: label_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY label
    ADD CONSTRAINT label_pk PRIMARY KEY (label_id);


--
-- TOC entry 4481 (class 2606 OID 35601)
-- Name: metadata_form_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY metadata_form
    ADD CONSTRAINT metadata_form_pk PRIMARY KEY (metadata_form_id);


--
-- TOC entry 4445 (class 2606 OID 35228)
-- Name: mime_type_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY mime_type
    ADD CONSTRAINT mime_type_pk PRIMARY KEY (mime_type_id);


--
-- TOC entry 4447 (class 2606 OID 35239)
-- Name: movement_type_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY movement_type
    ADD CONSTRAINT movement_type_pk PRIMARY KEY (movement_type_id);


--
-- TOC entry 4449 (class 2606 OID 35250)
-- Name: multiple_type_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY multiple_type
    ADD CONSTRAINT multiple_type_pk PRIMARY KEY (multiple_type_id);


--
-- TOC entry 4453 (class 2606 OID 35272)
-- Name: object_identifier_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY object_identifier
    ADD CONSTRAINT object_identifier_pk PRIMARY KEY (object_identifier_id);


--
-- TOC entry 4451 (class 2606 OID 35261)
-- Name: object_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY object
    ADD CONSTRAINT object_pk PRIMARY KEY (uid);


--
-- TOC entry 4455 (class 2606 OID 35283)
-- Name: object_status_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY object_status
    ADD CONSTRAINT object_status_pk PRIMARY KEY (object_status_id);


--
-- TOC entry 4457 (class 2606 OID 35614)
-- Name: operation_name_version_unique; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY operation
    ADD CONSTRAINT operation_name_version_unique UNIQUE (operation_name, operation_version);


--
-- TOC entry 4459 (class 2606 OID 35294)
-- Name: operation_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY operation
    ADD CONSTRAINT operation_pk PRIMARY KEY (operation_id);


--
-- TOC entry 4463 (class 2606 OID 35310)
-- Name: project_group_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY project_group
    ADD CONSTRAINT project_group_pk PRIMARY KEY (project_id, aclgroup_id);


--
-- TOC entry 4461 (class 2606 OID 35305)
-- Name: project_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_pk PRIMARY KEY (project_id);


--
-- TOC entry 4465 (class 2606 OID 35322)
-- Name: protocol_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY protocol
    ADD CONSTRAINT protocol_pk PRIMARY KEY (protocol_id);


--
-- TOC entry 4483 (class 2606 OID 35612)
-- Name: sample_metadata_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY sample_metadata
    ADD CONSTRAINT sample_metadata_pk PRIMARY KEY (sample_metadata_id);


--
-- TOC entry 4467 (class 2606 OID 35330)
-- Name: sample_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_pk PRIMARY KEY (sample_id);


--
-- TOC entry 4469 (class 2606 OID 35349)
-- Name: sample_type_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY sample_type
    ADD CONSTRAINT sample_type_pk PRIMARY KEY (sample_type_id);


--
-- TOC entry 4479 (class 2606 OID 35582)
-- Name: sampling_place_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY sampling_place
    ADD CONSTRAINT sampling_place_pk PRIMARY KEY (sampling_place_id);


--
-- TOC entry 4473 (class 2606 OID 35371)
-- Name: storage_condition_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY storage_condition
    ADD CONSTRAINT storage_condition_pk PRIMARY KEY (storage_condition_id);


--
-- TOC entry 4471 (class 2606 OID 35360)
-- Name: storage_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT storage_pk PRIMARY KEY (storage_id);


--
-- TOC entry 4475 (class 2606 OID 35382)
-- Name: storage_reason_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY storage_reason
    ADD CONSTRAINT storage_reason_pk PRIMARY KEY (storage_reason_id);


--
-- TOC entry 4477 (class 2606 OID 35393)
-- Name: subsample_pk; Type: CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY subsample
    ADD CONSTRAINT subsample_pk PRIMARY KEY (subsample_id);


SET search_path = gacl, pg_catalog;

--
-- TOC entry 4306 (class 1259 OID 18172)
-- Name: log_date_idx; Type: INDEX; Schema: gacl; Owner: collec
--

CREATE INDEX log_date_idx ON log USING btree (log_date);


--
-- TOC entry 4307 (class 1259 OID 18173)
-- Name: log_login_idx; Type: INDEX; Schema: gacl; Owner: collec
--

CREATE INDEX log_login_idx ON log USING btree (login);


SET search_path = col, pg_catalog;

--
-- TOC entry 4496 (class 2606 OID 18497)
-- Name: container_family_container_type_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container_type
    ADD CONSTRAINT container_family_container_type_fk FOREIGN KEY (container_family_id) REFERENCES container_family(container_family_id);


--
-- TOC entry 4520 (class 2606 OID 18492)
-- Name: container_storage_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT container_storage_fk FOREIGN KEY (container_id) REFERENCES container(container_id);


--
-- TOC entry 4493 (class 2606 OID 18502)
-- Name: container_type_container_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container
    ADD CONSTRAINT container_type_container_fk FOREIGN KEY (container_type_id) REFERENCES container_type(container_type_id);


--
-- TOC entry 4516 (class 2606 OID 18507)
-- Name: container_type_sample_type_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample_type
    ADD CONSTRAINT container_type_sample_type_fk FOREIGN KEY (container_type_id) REFERENCES container_type(container_type_id);


--
-- TOC entry 4500 (class 2606 OID 18512)
-- Name: event_type_event_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY event
    ADD CONSTRAINT event_type_event_fk FOREIGN KEY (event_type_id) REFERENCES event_type(event_type_id);


--
-- TOC entry 4504 (class 2606 OID 18517)
-- Name: identifier_type_object_identifier_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY object_identifier
    ADD CONSTRAINT identifier_type_object_identifier_fk FOREIGN KEY (identifier_type_id) REFERENCES identifier_type(identifier_type_id);


--
-- TOC entry 4495 (class 2606 OID 18522)
-- Name: label_container_type_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container_type
    ADD CONSTRAINT label_container_type_fk FOREIGN KEY (label_id) REFERENCES label(label_id);


--
-- TOC entry 4501 (class 2606 OID 26908)
-- Name: label_operation_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY label
    ADD CONSTRAINT label_operation_fk FOREIGN KEY (operation_id) REFERENCES operation(operation_id);


--
-- TOC entry 4505 (class 2606 OID 26928)
-- Name: metadata_form_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY operation
    ADD CONSTRAINT metadata_form_fk FOREIGN KEY (metadata_form_id) REFERENCES metadata_form(metadata_form_id);


--
-- TOC entry 4498 (class 2606 OID 18547)
-- Name: mime_type_document_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY document
    ADD CONSTRAINT mime_type_document_fk FOREIGN KEY (mime_type_id) REFERENCES mime_type(mime_type_id);


--
-- TOC entry 4519 (class 2606 OID 18552)
-- Name: movement_type_storage_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT movement_type_storage_fk FOREIGN KEY (movement_type_id) REFERENCES movement_type(movement_type_id);


--
-- TOC entry 4522 (class 2606 OID 18557)
-- Name: movement_type_subsample_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY subsample
    ADD CONSTRAINT movement_type_subsample_fk FOREIGN KEY (movement_type_id) REFERENCES movement_type(movement_type_id);


--
-- TOC entry 4515 (class 2606 OID 18562)
-- Name: multiple_type_sample_type_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample_type
    ADD CONSTRAINT multiple_type_sample_type_fk FOREIGN KEY (multiple_type_id) REFERENCES multiple_type(multiple_type_id);


--
-- TOC entry 4491 (class 2606 OID 18567)
-- Name: object_booking_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY booking
    ADD CONSTRAINT object_booking_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4492 (class 2606 OID 18572)
-- Name: object_container_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container
    ADD CONSTRAINT object_container_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4497 (class 2606 OID 18577)
-- Name: object_document_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY document
    ADD CONSTRAINT object_document_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4499 (class 2606 OID 18582)
-- Name: object_event_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY event
    ADD CONSTRAINT object_event_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4503 (class 2606 OID 18587)
-- Name: object_object_identifier_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY object_identifier
    ADD CONSTRAINT object_object_identifier_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4513 (class 2606 OID 18592)
-- Name: object_sample_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT object_sample_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4502 (class 2606 OID 18602)
-- Name: object_status_object_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY object
    ADD CONSTRAINT object_status_object_fk FOREIGN KEY (object_status_id) REFERENCES object_status(object_status_id);


--
-- TOC entry 4518 (class 2606 OID 18597)
-- Name: object_storage_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT object_storage_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4514 (class 2606 OID 18607)
-- Name: operation_sample_type_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample_type
    ADD CONSTRAINT operation_sample_type_fk FOREIGN KEY (operation_id) REFERENCES operation(operation_id);


--
-- TOC entry 4507 (class 2606 OID 18612)
-- Name: project_project_group_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY project_group
    ADD CONSTRAINT project_project_group_fk FOREIGN KEY (project_id) REFERENCES project(project_id);


--
-- TOC entry 4512 (class 2606 OID 18617)
-- Name: project_sample_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT project_sample_fk FOREIGN KEY (project_id) REFERENCES project(project_id);


--
-- TOC entry 4506 (class 2606 OID 18622)
-- Name: protocol_operation_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY operation
    ADD CONSTRAINT protocol_operation_fk FOREIGN KEY (protocol_id) REFERENCES protocol(protocol_id);


--
-- TOC entry 4508 (class 2606 OID 26959)
-- Name: sample_metadata_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_metadata_fk FOREIGN KEY (sample_metadata_id) REFERENCES sample_metadata(sample_metadata_id);


--
-- TOC entry 4511 (class 2606 OID 18627)
-- Name: sample_sample_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_sample_fk FOREIGN KEY (parent_sample_id) REFERENCES sample(sample_id);


--
-- TOC entry 4521 (class 2606 OID 18637)
-- Name: sample_subsample_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY subsample
    ADD CONSTRAINT sample_subsample_fk FOREIGN KEY (sample_id) REFERENCES sample(sample_id);


--
-- TOC entry 4510 (class 2606 OID 18642)
-- Name: sample_type_sample_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_type_sample_fk FOREIGN KEY (sample_type_id) REFERENCES sample_type(sample_type_id);


--
-- TOC entry 4509 (class 2606 OID 18682)
-- Name: sampling_place_sample_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sampling_place_sample_fk FOREIGN KEY (sampling_place_id) REFERENCES sampling_place(sampling_place_id);


--
-- TOC entry 4494 (class 2606 OID 18647)
-- Name: storage_condition_container_type_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container_type
    ADD CONSTRAINT storage_condition_container_type_fk FOREIGN KEY (storage_condition_id) REFERENCES storage_condition(storage_condition_id);


--
-- TOC entry 4517 (class 2606 OID 18652)
-- Name: storage_reason_storage_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT storage_reason_storage_fk FOREIGN KEY (storage_reason_id) REFERENCES storage_reason(storage_reason_id);


SET search_path = gacl, pg_catalog;

--
-- TOC entry 4485 (class 2606 OID 18105)
-- Name: aclaco_aclacl_fk; Type: FK CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclacl
    ADD CONSTRAINT aclaco_aclacl_fk FOREIGN KEY (aclaco_id) REFERENCES aclaco(aclaco_id);


--
-- TOC entry 4486 (class 2606 OID 18110)
-- Name: aclappli_aclaco_fk; Type: FK CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclaco
    ADD CONSTRAINT aclappli_aclaco_fk FOREIGN KEY (aclappli_id) REFERENCES aclappli(aclappli_id);


--
-- TOC entry 4484 (class 2606 OID 18115)
-- Name: aclgroup_aclacl_fk; Type: FK CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclacl
    ADD CONSTRAINT aclgroup_aclacl_fk FOREIGN KEY (aclgroup_id) REFERENCES aclgroup(aclgroup_id);


--
-- TOC entry 4487 (class 2606 OID 18120)
-- Name: aclgroup_aclgroup_fk; Type: FK CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclgroup
    ADD CONSTRAINT aclgroup_aclgroup_fk FOREIGN KEY (aclgroup_id_parent) REFERENCES aclgroup(aclgroup_id);


--
-- TOC entry 4489 (class 2606 OID 18125)
-- Name: aclgroup_acllogingroup_fk; Type: FK CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY acllogingroup
    ADD CONSTRAINT aclgroup_acllogingroup_fk FOREIGN KEY (aclgroup_id) REFERENCES aclgroup(aclgroup_id);


--
-- TOC entry 4488 (class 2606 OID 18130)
-- Name: acllogin_acllogingroup_fk; Type: FK CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY acllogingroup
    ADD CONSTRAINT acllogin_acllogingroup_fk FOREIGN KEY (acllogin_id) REFERENCES acllogin(acllogin_id);


--
-- TOC entry 4490 (class 2606 OID 18156)
-- Name: logingestion_login_oldpassword_fk; Type: FK CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY login_oldpassword
    ADD CONSTRAINT logingestion_login_oldpassword_fk FOREIGN KEY (id) REFERENCES logingestion(id);


SET search_path = zaalpes, pg_catalog;

--
-- TOC entry 4528 (class 2606 OID 27287)
-- Name: container_family_container_type_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY container_type
    ADD CONSTRAINT container_family_container_type_fk FOREIGN KEY (container_family_id) REFERENCES container_family(container_family_id);


--
-- TOC entry 4552 (class 2606 OID 27282)
-- Name: container_storage_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT container_storage_fk FOREIGN KEY (container_id) REFERENCES container(container_id);


--
-- TOC entry 4525 (class 2606 OID 27292)
-- Name: container_type_container_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY container
    ADD CONSTRAINT container_type_container_fk FOREIGN KEY (container_type_id) REFERENCES container_type(container_type_id);


--
-- TOC entry 4548 (class 2606 OID 27297)
-- Name: container_type_sample_type_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY sample_type
    ADD CONSTRAINT container_type_sample_type_fk FOREIGN KEY (container_type_id) REFERENCES container_type(container_type_id);


--
-- TOC entry 4532 (class 2606 OID 27302)
-- Name: event_type_event_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY event
    ADD CONSTRAINT event_type_event_fk FOREIGN KEY (event_type_id) REFERENCES event_type(event_type_id);


--
-- TOC entry 4536 (class 2606 OID 27307)
-- Name: identifier_type_object_identifier_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY object_identifier
    ADD CONSTRAINT identifier_type_object_identifier_fk FOREIGN KEY (identifier_type_id) REFERENCES identifier_type(identifier_type_id);


--
-- TOC entry 4527 (class 2606 OID 27312)
-- Name: label_container_type_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY container_type
    ADD CONSTRAINT label_container_type_fk FOREIGN KEY (label_id) REFERENCES label(label_id);


--
-- TOC entry 4533 (class 2606 OID 27516)
-- Name: label_operation_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY label
    ADD CONSTRAINT label_operation_fk FOREIGN KEY (operation_id) REFERENCES operation(operation_id);


--
-- TOC entry 4537 (class 2606 OID 27506)
-- Name: metadata_form_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY operation
    ADD CONSTRAINT metadata_form_fk FOREIGN KEY (metadata_form_id) REFERENCES metadata_form(metadata_form_id);


--
-- TOC entry 4530 (class 2606 OID 27337)
-- Name: mime_type_document_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY document
    ADD CONSTRAINT mime_type_document_fk FOREIGN KEY (mime_type_id) REFERENCES mime_type(mime_type_id);


--
-- TOC entry 4551 (class 2606 OID 27342)
-- Name: movement_type_storage_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT movement_type_storage_fk FOREIGN KEY (movement_type_id) REFERENCES movement_type(movement_type_id);


--
-- TOC entry 4554 (class 2606 OID 27347)
-- Name: movement_type_subsample_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY subsample
    ADD CONSTRAINT movement_type_subsample_fk FOREIGN KEY (movement_type_id) REFERENCES movement_type(movement_type_id);


--
-- TOC entry 4547 (class 2606 OID 27352)
-- Name: multiple_type_sample_type_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY sample_type
    ADD CONSTRAINT multiple_type_sample_type_fk FOREIGN KEY (multiple_type_id) REFERENCES multiple_type(multiple_type_id);


--
-- TOC entry 4523 (class 2606 OID 27357)
-- Name: object_booking_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY booking
    ADD CONSTRAINT object_booking_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4524 (class 2606 OID 27362)
-- Name: object_container_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY container
    ADD CONSTRAINT object_container_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4529 (class 2606 OID 27367)
-- Name: object_document_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY document
    ADD CONSTRAINT object_document_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4531 (class 2606 OID 27372)
-- Name: object_event_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY event
    ADD CONSTRAINT object_event_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4535 (class 2606 OID 27377)
-- Name: object_object_identifier_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY object_identifier
    ADD CONSTRAINT object_object_identifier_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4545 (class 2606 OID 27382)
-- Name: object_sample_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT object_sample_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4534 (class 2606 OID 27392)
-- Name: object_status_object_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY object
    ADD CONSTRAINT object_status_object_fk FOREIGN KEY (object_status_id) REFERENCES object_status(object_status_id);


--
-- TOC entry 4550 (class 2606 OID 27387)
-- Name: object_storage_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT object_storage_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4546 (class 2606 OID 27397)
-- Name: operation_sample_type_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY sample_type
    ADD CONSTRAINT operation_sample_type_fk FOREIGN KEY (operation_id) REFERENCES operation(operation_id);


--
-- TOC entry 4539 (class 2606 OID 27402)
-- Name: project_project_group_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY project_group
    ADD CONSTRAINT project_project_group_fk FOREIGN KEY (project_id) REFERENCES project(project_id);


--
-- TOC entry 4544 (class 2606 OID 27407)
-- Name: project_sample_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT project_sample_fk FOREIGN KEY (project_id) REFERENCES project(project_id);


--
-- TOC entry 4538 (class 2606 OID 27412)
-- Name: protocol_operation_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY operation
    ADD CONSTRAINT protocol_operation_fk FOREIGN KEY (protocol_id) REFERENCES protocol(protocol_id);


--
-- TOC entry 4540 (class 2606 OID 27511)
-- Name: sample_metadata_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_metadata_fk FOREIGN KEY (sample_metadata_id) REFERENCES sample_metadata(sample_metadata_id);


--
-- TOC entry 4543 (class 2606 OID 27417)
-- Name: sample_sample_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_sample_fk FOREIGN KEY (parent_sample_id) REFERENCES sample(sample_id);


--
-- TOC entry 4553 (class 2606 OID 27427)
-- Name: sample_subsample_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY subsample
    ADD CONSTRAINT sample_subsample_fk FOREIGN KEY (sample_id) REFERENCES sample(sample_id);


--
-- TOC entry 4542 (class 2606 OID 27432)
-- Name: sample_type_sample_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_type_sample_fk FOREIGN KEY (sample_type_id) REFERENCES sample_type(sample_type_id);


--
-- TOC entry 4541 (class 2606 OID 27474)
-- Name: sampling_place_sample_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sampling_place_sample_fk FOREIGN KEY (sampling_place_id) REFERENCES sampling_place(sampling_place_id);


--
-- TOC entry 4526 (class 2606 OID 27437)
-- Name: storage_condition_container_type_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY container_type
    ADD CONSTRAINT storage_condition_container_type_fk FOREIGN KEY (storage_condition_id) REFERENCES storage_condition(storage_condition_id);


--
-- TOC entry 4549 (class 2606 OID 27442)
-- Name: storage_reason_storage_fk; Type: FK CONSTRAINT; Schema: zaalpes; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT storage_reason_storage_fk FOREIGN KEY (storage_reason_id) REFERENCES storage_reason(storage_reason_id);


SET search_path = zapvs, pg_catalog;

--
-- TOC entry 4560 (class 2606 OID 35399)
-- Name: container_family_container_type_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY container_type
    ADD CONSTRAINT container_family_container_type_fk FOREIGN KEY (container_family_id) REFERENCES container_family(container_family_id);


--
-- TOC entry 4584 (class 2606 OID 35394)
-- Name: container_storage_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT container_storage_fk FOREIGN KEY (container_id) REFERENCES container(container_id);


--
-- TOC entry 4557 (class 2606 OID 35404)
-- Name: container_type_container_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY container
    ADD CONSTRAINT container_type_container_fk FOREIGN KEY (container_type_id) REFERENCES container_type(container_type_id);


--
-- TOC entry 4580 (class 2606 OID 35409)
-- Name: container_type_sample_type_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY sample_type
    ADD CONSTRAINT container_type_sample_type_fk FOREIGN KEY (container_type_id) REFERENCES container_type(container_type_id);


--
-- TOC entry 4564 (class 2606 OID 35414)
-- Name: event_type_event_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY event
    ADD CONSTRAINT event_type_event_fk FOREIGN KEY (event_type_id) REFERENCES event_type(event_type_id);


--
-- TOC entry 4568 (class 2606 OID 35419)
-- Name: identifier_type_object_identifier_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY object_identifier
    ADD CONSTRAINT identifier_type_object_identifier_fk FOREIGN KEY (identifier_type_id) REFERENCES identifier_type(identifier_type_id);


--
-- TOC entry 4559 (class 2606 OID 35424)
-- Name: label_container_type_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY container_type
    ADD CONSTRAINT label_container_type_fk FOREIGN KEY (label_id) REFERENCES label(label_id);


--
-- TOC entry 4565 (class 2606 OID 35625)
-- Name: label_operation_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY label
    ADD CONSTRAINT label_operation_fk FOREIGN KEY (operation_id) REFERENCES operation(operation_id);


--
-- TOC entry 4569 (class 2606 OID 35615)
-- Name: metadata_form_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY operation
    ADD CONSTRAINT metadata_form_fk FOREIGN KEY (metadata_form_id) REFERENCES metadata_form(metadata_form_id);


--
-- TOC entry 4562 (class 2606 OID 35449)
-- Name: mime_type_document_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY document
    ADD CONSTRAINT mime_type_document_fk FOREIGN KEY (mime_type_id) REFERENCES mime_type(mime_type_id);


--
-- TOC entry 4583 (class 2606 OID 35454)
-- Name: movement_type_storage_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT movement_type_storage_fk FOREIGN KEY (movement_type_id) REFERENCES movement_type(movement_type_id);


--
-- TOC entry 4586 (class 2606 OID 35459)
-- Name: movement_type_subsample_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY subsample
    ADD CONSTRAINT movement_type_subsample_fk FOREIGN KEY (movement_type_id) REFERENCES movement_type(movement_type_id);


--
-- TOC entry 4579 (class 2606 OID 35464)
-- Name: multiple_type_sample_type_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY sample_type
    ADD CONSTRAINT multiple_type_sample_type_fk FOREIGN KEY (multiple_type_id) REFERENCES multiple_type(multiple_type_id);


--
-- TOC entry 4555 (class 2606 OID 35469)
-- Name: object_booking_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY booking
    ADD CONSTRAINT object_booking_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4556 (class 2606 OID 35474)
-- Name: object_container_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY container
    ADD CONSTRAINT object_container_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4561 (class 2606 OID 35479)
-- Name: object_document_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY document
    ADD CONSTRAINT object_document_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4563 (class 2606 OID 35484)
-- Name: object_event_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY event
    ADD CONSTRAINT object_event_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4567 (class 2606 OID 35489)
-- Name: object_object_identifier_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY object_identifier
    ADD CONSTRAINT object_object_identifier_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4577 (class 2606 OID 35494)
-- Name: object_sample_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT object_sample_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4566 (class 2606 OID 35504)
-- Name: object_status_object_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY object
    ADD CONSTRAINT object_status_object_fk FOREIGN KEY (object_status_id) REFERENCES object_status(object_status_id);


--
-- TOC entry 4582 (class 2606 OID 35499)
-- Name: object_storage_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT object_storage_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 4578 (class 2606 OID 35509)
-- Name: operation_sample_type_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY sample_type
    ADD CONSTRAINT operation_sample_type_fk FOREIGN KEY (operation_id) REFERENCES operation(operation_id);


--
-- TOC entry 4571 (class 2606 OID 35514)
-- Name: project_project_group_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY project_group
    ADD CONSTRAINT project_project_group_fk FOREIGN KEY (project_id) REFERENCES project(project_id);


--
-- TOC entry 4576 (class 2606 OID 35519)
-- Name: project_sample_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT project_sample_fk FOREIGN KEY (project_id) REFERENCES project(project_id);


--
-- TOC entry 4570 (class 2606 OID 35524)
-- Name: protocol_operation_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY operation
    ADD CONSTRAINT protocol_operation_fk FOREIGN KEY (protocol_id) REFERENCES protocol(protocol_id);


--
-- TOC entry 4572 (class 2606 OID 35620)
-- Name: sample_metadata_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_metadata_fk FOREIGN KEY (sample_metadata_id) REFERENCES sample_metadata(sample_metadata_id);


--
-- TOC entry 4575 (class 2606 OID 35529)
-- Name: sample_sample_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_sample_fk FOREIGN KEY (parent_sample_id) REFERENCES sample(sample_id);


--
-- TOC entry 4585 (class 2606 OID 35539)
-- Name: sample_subsample_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY subsample
    ADD CONSTRAINT sample_subsample_fk FOREIGN KEY (sample_id) REFERENCES sample(sample_id);


--
-- TOC entry 4574 (class 2606 OID 35544)
-- Name: sample_type_sample_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_type_sample_fk FOREIGN KEY (sample_type_id) REFERENCES sample_type(sample_type_id);


--
-- TOC entry 4573 (class 2606 OID 35583)
-- Name: sampling_place_sample_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sampling_place_sample_fk FOREIGN KEY (sampling_place_id) REFERENCES sampling_place(sampling_place_id);


--
-- TOC entry 4558 (class 2606 OID 35549)
-- Name: storage_condition_container_type_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY container_type
    ADD CONSTRAINT storage_condition_container_type_fk FOREIGN KEY (storage_condition_id) REFERENCES storage_condition(storage_condition_id);


--
-- TOC entry 4581 (class 2606 OID 35554)
-- Name: storage_reason_storage_fk; Type: FK CONSTRAINT; Schema: zapvs; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT storage_reason_storage_fk FOREIGN KEY (storage_reason_id) REFERENCES storage_reason(storage_reason_id);


--
-- TOC entry 4906 (class 0 OID 0)
-- Dependencies: 10
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2017-07-18 10:14:26 CEST

--
-- PostgreSQL database dump complete
--



/*
 * Modifiez la ligne 4 si necessaire, pour mettre a jour tous vos schemas de donnees
 */
set search_path = 'col';

CREATE SEQUENCE "dbversion_dbversion_id_seq";

CREATE TABLE "dbversion" (
                "dbversion_id" INTEGER NOT NULL DEFAULT nextval('"dbversion_dbversion_id_seq"'),
                "dbversion_number" VARCHAR NOT NULL,
                "dbversion_date" TIMESTAMP NOT NULL,
                CONSTRAINT "dbversion_pk" PRIMARY KEY ("dbversion_id")
);
COMMENT ON TABLE "dbversion" IS 'Table des versions de la base de donnees';
COMMENT ON COLUMN "dbversion"."dbversion_number" IS 'Numero de la version';
COMMENT ON COLUMN "dbversion"."dbversion_date" IS 'Date de la version';


ALTER SEQUENCE "dbversion_dbversion_id_seq" OWNED BY "dbversion"."dbversion_id";

insert into dbversion(dbversion_number, dbversion_date) values ('1.0.8', '2017-06-02');

/*
 * Modifiez la ligne 4 si necessaire, pour mettre a jour tous vos schemas de donnees
 */
set search_path = 'zaalpes';

CREATE SEQUENCE "dbversion_dbversion_id_seq";

CREATE TABLE "dbversion" (
                "dbversion_id" INTEGER NOT NULL DEFAULT nextval('"dbversion_dbversion_id_seq"'),
                "dbversion_number" VARCHAR NOT NULL,
                "dbversion_date" TIMESTAMP NOT NULL,
                CONSTRAINT "dbversion_pk" PRIMARY KEY ("dbversion_id")
);
COMMENT ON TABLE "dbversion" IS 'Table des versions de la base de donnees';
COMMENT ON COLUMN "dbversion"."dbversion_number" IS 'Numero de la version';
COMMENT ON COLUMN "dbversion"."dbversion_date" IS 'Date de la version';


ALTER SEQUENCE "dbversion_dbversion_id_seq" OWNED BY "dbversion"."dbversion_id";

insert into dbversion(dbversion_number, dbversion_date) values ('1.0.8', '2017-06-02');


/*
 * Modifiez la ligne 4 si necessaire, pour mettre a jour tous vos schemas de donnees
 */
set search_path = 'zapvs';

CREATE SEQUENCE "dbversion_dbversion_id_seq";

CREATE TABLE "dbversion" (
                "dbversion_id" INTEGER NOT NULL DEFAULT nextval('"dbversion_dbversion_id_seq"'),
                "dbversion_number" VARCHAR NOT NULL,
                "dbversion_date" TIMESTAMP NOT NULL,
                CONSTRAINT "dbversion_pk" PRIMARY KEY ("dbversion_id")
);
COMMENT ON TABLE "dbversion" IS 'Table des versions de la base de donnees';
COMMENT ON COLUMN "dbversion"."dbversion_number" IS 'Numero de la version';
COMMENT ON COLUMN "dbversion"."dbversion_date" IS 'Date de la version';


ALTER SEQUENCE "dbversion_dbversion_id_seq" OWNED BY "dbversion"."dbversion_id";

insert into dbversion(dbversion_number, dbversion_date) values ('1.0.8', '2017-06-02');
