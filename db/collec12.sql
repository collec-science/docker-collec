-- For demo, by Christine Plumejeaud-Perreau
-- PostgreSQL database dump of collec12 (release 1.2) of 23/10/2017
-- 

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.6
-- Dumped by pg_dump version 9.5.6

-- Started on 2017-10-23 13:11:35 CEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 39900)
-- Name: col; Type: SCHEMA; Schema: -; Owner: collec
--

CREATE SCHEMA col;


ALTER SCHEMA col OWNER TO collec;

--
-- TOC entry 8 (class 2615 OID 39901)
-- Name: gacl; Type: SCHEMA; Schema: -; Owner: collec
--

CREATE SCHEMA gacl;


ALTER SCHEMA gacl OWNER TO collec;

SET search_path = gacl, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 183 (class 1259 OID 39902)
-- Name: aclgroup; Type: TABLE; Schema: gacl; Owner: collec
--

CREATE TABLE aclgroup (
    aclgroup_id integer NOT NULL,
    groupe character varying NOT NULL,
    aclgroup_id_parent integer
);


ALTER TABLE aclgroup OWNER TO collec;

--
-- TOC entry 2641 (class 0 OID 0)
-- Dependencies: 183
-- Name: TABLE aclgroup; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON TABLE aclgroup IS 'Groupes des logins';


SET search_path = col, pg_catalog;

--
-- TOC entry 184 (class 1259 OID 39908)
-- Name: aclgroup; Type: VIEW; Schema: col; Owner: collec
--

CREATE VIEW aclgroup AS
 SELECT aclgroup.aclgroup_id,
    aclgroup.groupe,
    aclgroup.aclgroup_id_parent
   FROM gacl.aclgroup;


ALTER TABLE aclgroup OWNER TO collec;

--
-- TOC entry 185 (class 1259 OID 39912)
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
-- TOC entry 2642 (class 0 OID 0)
-- Dependencies: 185
-- Name: TABLE booking; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE booking IS 'Table des réservations d''objets';


--
-- TOC entry 2643 (class 0 OID 0)
-- Dependencies: 185
-- Name: COLUMN booking.booking_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN booking.booking_date IS 'Date de la réservation';


--
-- TOC entry 2644 (class 0 OID 0)
-- Dependencies: 185
-- Name: COLUMN booking.date_from; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN booking.date_from IS 'Date-heure de début de la réservation';


--
-- TOC entry 2645 (class 0 OID 0)
-- Dependencies: 185
-- Name: COLUMN booking.date_to; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN booking.date_to IS 'Date-heure de fin de la réservation';


--
-- TOC entry 2646 (class 0 OID 0)
-- Dependencies: 185
-- Name: COLUMN booking.booking_comment; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN booking.booking_comment IS 'Commentaire';


--
-- TOC entry 2647 (class 0 OID 0)
-- Dependencies: 185
-- Name: COLUMN booking.booking_login; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN booking.booking_login IS 'Compte ayant réalisé la réservation';


--
-- TOC entry 186 (class 1259 OID 39918)
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
-- TOC entry 2648 (class 0 OID 0)
-- Dependencies: 186
-- Name: booking_booking_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE booking_booking_id_seq OWNED BY booking.booking_id;


--
-- TOC entry 187 (class 1259 OID 39920)
-- Name: container; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE container (
    container_id integer NOT NULL,
    uid integer NOT NULL,
    container_type_id integer NOT NULL
);


ALTER TABLE container OWNER TO collec;

--
-- TOC entry 2649 (class 0 OID 0)
-- Dependencies: 187
-- Name: TABLE container; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE container IS 'Liste des conteneurs d''échantillon';


--
-- TOC entry 188 (class 1259 OID 39923)
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
-- TOC entry 2650 (class 0 OID 0)
-- Dependencies: 188
-- Name: container_container_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE container_container_id_seq OWNED BY container.container_id;


--
-- TOC entry 189 (class 1259 OID 39925)
-- Name: container_family; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE container_family (
    container_family_id integer NOT NULL,
    container_family_name character varying NOT NULL,
    is_movable boolean DEFAULT true NOT NULL
);


ALTER TABLE container_family OWNER TO collec;

--
-- TOC entry 2651 (class 0 OID 0)
-- Dependencies: 189
-- Name: TABLE container_family; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE container_family IS 'Famille générique des conteneurs';


--
-- TOC entry 2652 (class 0 OID 0)
-- Dependencies: 189
-- Name: COLUMN container_family.is_movable; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN container_family.is_movable IS 'Indique si la famille de conteneurs est déplçable facilement ou non (éprouvette : oui, armoire : non)';


--
-- TOC entry 190 (class 1259 OID 39932)
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
-- TOC entry 2653 (class 0 OID 0)
-- Dependencies: 190
-- Name: container_family_container_family_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE container_family_container_family_id_seq OWNED BY container_family.container_family_id;


--
-- TOC entry 191 (class 1259 OID 39934)
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
    clp_classification character varying,
    lines integer DEFAULT 1 NOT NULL,
    columns integer DEFAULT 1 NOT NULL,
    first_line character varying DEFAULT 'T'::character varying NOT NULL
);


ALTER TABLE container_type OWNER TO collec;

--
-- TOC entry 2654 (class 0 OID 0)
-- Dependencies: 191
-- Name: TABLE container_type; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE container_type IS 'Table des types de conteneurs';


--
-- TOC entry 2655 (class 0 OID 0)
-- Dependencies: 191
-- Name: COLUMN container_type.container_type_description; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN container_type.container_type_description IS 'Description longue';


--
-- TOC entry 2656 (class 0 OID 0)
-- Dependencies: 191
-- Name: COLUMN container_type.storage_product; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN container_type.storage_product IS 'Produit utilisé pour le stockage (formol, alcool...)';


--
-- TOC entry 2657 (class 0 OID 0)
-- Dependencies: 191
-- Name: COLUMN container_type.clp_classification; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN container_type.clp_classification IS 'Classification du risque conformément à la directive européenne CLP';


--
-- TOC entry 2658 (class 0 OID 0)
-- Dependencies: 191
-- Name: COLUMN container_type.lines; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN container_type.lines IS 'Nombre de lignes de stockage dans le container';


--
-- TOC entry 2659 (class 0 OID 0)
-- Dependencies: 191
-- Name: COLUMN container_type.columns; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN container_type.columns IS 'Nombre de colonnes de stockage dans le container';


--
-- TOC entry 2660 (class 0 OID 0)
-- Dependencies: 191
-- Name: COLUMN container_type.first_line; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN container_type.first_line IS 'T : top, premiere ligne en haut
B: bottom, premiere ligne en bas';


--
-- TOC entry 192 (class 1259 OID 39943)
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
-- TOC entry 2661 (class 0 OID 0)
-- Dependencies: 192
-- Name: container_type_container_type_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE container_type_container_type_id_seq OWNED BY container_type.container_type_id;


--
-- TOC entry 262 (class 1259 OID 40546)
-- Name: dbparam; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE dbparam (
    dbparam_id integer NOT NULL,
    dbparam_name character varying NOT NULL,
    dbparam_value character varying
);


ALTER TABLE dbparam OWNER TO collec;

--
-- TOC entry 2662 (class 0 OID 0)
-- Dependencies: 262
-- Name: TABLE dbparam; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE dbparam IS 'Table des parametres associes de maniere intrinseque a l''instance';


--
-- TOC entry 2663 (class 0 OID 0)
-- Dependencies: 262
-- Name: COLUMN dbparam.dbparam_name; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN dbparam.dbparam_name IS 'Nom du parametre';


--
-- TOC entry 2664 (class 0 OID 0)
-- Dependencies: 262
-- Name: COLUMN dbparam.dbparam_value; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN dbparam.dbparam_value IS 'Valeur du paramètre';


--
-- TOC entry 193 (class 1259 OID 39945)
-- Name: dbversion; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE dbversion (
    dbversion_id integer NOT NULL,
    dbversion_number character varying NOT NULL,
    dbversion_date timestamp without time zone NOT NULL
);


ALTER TABLE dbversion OWNER TO collec;

--
-- TOC entry 2665 (class 0 OID 0)
-- Dependencies: 193
-- Name: TABLE dbversion; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE dbversion IS 'Table des versions de la base de donnees';


--
-- TOC entry 2666 (class 0 OID 0)
-- Dependencies: 193
-- Name: COLUMN dbversion.dbversion_number; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN dbversion.dbversion_number IS 'Numero de la version';


--
-- TOC entry 2667 (class 0 OID 0)
-- Dependencies: 193
-- Name: COLUMN dbversion.dbversion_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN dbversion.dbversion_date IS 'Date de la version';


--
-- TOC entry 194 (class 1259 OID 39951)
-- Name: dbversion_dbversion_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE dbversion_dbversion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dbversion_dbversion_id_seq OWNER TO collec;

--
-- TOC entry 2668 (class 0 OID 0)
-- Dependencies: 194
-- Name: dbversion_dbversion_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE dbversion_dbversion_id_seq OWNED BY dbversion.dbversion_id;


--
-- TOC entry 195 (class 1259 OID 39953)
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
-- TOC entry 2669 (class 0 OID 0)
-- Dependencies: 195
-- Name: TABLE document; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE document IS 'Documents numériques rattachés à un poisson ou à un événement';


--
-- TOC entry 2670 (class 0 OID 0)
-- Dependencies: 195
-- Name: COLUMN document.document_import_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN document.document_import_date IS 'Date d''import dans la base de données';


--
-- TOC entry 2671 (class 0 OID 0)
-- Dependencies: 195
-- Name: COLUMN document.document_name; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN document.document_name IS 'Nom d''origine du document';


--
-- TOC entry 2672 (class 0 OID 0)
-- Dependencies: 195
-- Name: COLUMN document.document_description; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN document.document_description IS 'Description libre du document';


--
-- TOC entry 2673 (class 0 OID 0)
-- Dependencies: 195
-- Name: COLUMN document.data; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN document.data IS 'Contenu du document';


--
-- TOC entry 2674 (class 0 OID 0)
-- Dependencies: 195
-- Name: COLUMN document.thumbnail; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN document.thumbnail IS 'Vignette au format PNG (documents pdf, jpg ou png)';


--
-- TOC entry 2675 (class 0 OID 0)
-- Dependencies: 195
-- Name: COLUMN document.size; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN document.size IS 'Taille du fichier téléchargé';


--
-- TOC entry 2676 (class 0 OID 0)
-- Dependencies: 195
-- Name: COLUMN document.document_creation_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN document.document_creation_date IS 'Date de création du document (date de prise de vue de la photo)';


--
-- TOC entry 196 (class 1259 OID 39959)
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
-- TOC entry 2677 (class 0 OID 0)
-- Dependencies: 196
-- Name: document_document_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE document_document_id_seq OWNED BY document.document_id;


--
-- TOC entry 197 (class 1259 OID 39961)
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
-- TOC entry 2678 (class 0 OID 0)
-- Dependencies: 197
-- Name: TABLE event; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE event IS 'Table des événements';


--
-- TOC entry 2679 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN event.event_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN event.event_date IS 'Date / heure de l''événement';


--
-- TOC entry 2680 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN event.still_available; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN event.still_available IS 'définit ce qu''il reste de disponible dans l''objet';


--
-- TOC entry 198 (class 1259 OID 39967)
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
-- TOC entry 2681 (class 0 OID 0)
-- Dependencies: 198
-- Name: event_event_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE event_event_id_seq OWNED BY event.event_id;


--
-- TOC entry 199 (class 1259 OID 39969)
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
-- TOC entry 2682 (class 0 OID 0)
-- Dependencies: 199
-- Name: TABLE event_type; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE event_type IS 'Types d''événement';


--
-- TOC entry 2683 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN event_type.is_sample; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN event_type.is_sample IS 'L''événement s''applique aux échantillons';


--
-- TOC entry 2684 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN event_type.is_container; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN event_type.is_container IS 'L''événement s''applique aux conteneurs';


--
-- TOC entry 200 (class 1259 OID 39977)
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
-- TOC entry 2685 (class 0 OID 0)
-- Dependencies: 200
-- Name: event_type_event_type_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE event_type_event_type_id_seq OWNED BY event_type.event_type_id;


--
-- TOC entry 201 (class 1259 OID 39979)
-- Name: identifier_type; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE identifier_type (
    identifier_type_id integer NOT NULL,
    identifier_type_name character varying NOT NULL,
    identifier_type_code character varying NOT NULL,
    used_for_search boolean DEFAULT false NOT NULL
);


ALTER TABLE identifier_type OWNER TO collec;

--
-- TOC entry 2686 (class 0 OID 0)
-- Dependencies: 201
-- Name: TABLE identifier_type; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE identifier_type IS 'Table des types d''identifiants';


--
-- TOC entry 2687 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN identifier_type.identifier_type_name; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN identifier_type.identifier_type_name IS 'Nom textuel de l''identifiant';


--
-- TOC entry 2688 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN identifier_type.identifier_type_code; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN identifier_type.identifier_type_code IS 'Code utilisé pour la génération des étiquettes';


--
-- TOC entry 2689 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN identifier_type.used_for_search; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN identifier_type.used_for_search IS 'Indique si l''identifiant doit être utilise pour les recherches a partir des codes-barres';


--
-- TOC entry 202 (class 1259 OID 39985)
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
-- TOC entry 2690 (class 0 OID 0)
-- Dependencies: 202
-- Name: identifier_type_identifier_type_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE identifier_type_identifier_type_id_seq OWNED BY identifier_type.identifier_type_id;


--
-- TOC entry 203 (class 1259 OID 39987)
-- Name: label; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE label (
    label_id integer NOT NULL,
    label_name character varying NOT NULL,
    label_xsl character varying NOT NULL,
    label_fields character varying DEFAULT 'uid,id,clp,db'::character varying NOT NULL,
    metadata_id integer,
    identifier_only boolean DEFAULT false NOT NULL
);


ALTER TABLE label OWNER TO collec;

--
-- TOC entry 2691 (class 0 OID 0)
-- Dependencies: 203
-- Name: TABLE label; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE label IS 'Table des modèles d''étiquettes';


--
-- TOC entry 2692 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN label.label_name; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN label.label_name IS 'Nom du modèle';


--
-- TOC entry 2693 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN label.label_xsl; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN label.label_xsl IS 'Contenu du fichier XSL utilisé pour la transformation FOP (https://xmlgraphics.apache.org/fop/)';


--
-- TOC entry 2694 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN label.label_fields; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN label.label_fields IS 'Liste des champs à intégrer dans le QRCODE, séparés par une virgule';


--
-- TOC entry 2695 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN label.identifier_only; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN label.identifier_only IS 'true : le qrcode ne contient qu''un identifiant metier';


--
-- TOC entry 204 (class 1259 OID 39994)
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
-- TOC entry 2696 (class 0 OID 0)
-- Dependencies: 204
-- Name: label_label_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE label_label_id_seq OWNED BY label.label_id;


--
-- TOC entry 205 (class 1259 OID 39996)
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
    storage_comment character varying,
    line_number integer DEFAULT 1 NOT NULL,
    column_number integer DEFAULT 1 NOT NULL
);


ALTER TABLE storage OWNER TO collec;

--
-- TOC entry 2697 (class 0 OID 0)
-- Dependencies: 205
-- Name: TABLE storage; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE storage IS 'Gestion du stockage des échantillons';


--
-- TOC entry 2698 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN storage.storage_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN storage.storage_date IS 'Date/heure du mouvement';


--
-- TOC entry 2699 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN storage.storage_location; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN storage.storage_location IS 'Emplacement de l''échantillon dans le conteneur';


--
-- TOC entry 2700 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN storage.login; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN storage.login IS 'Nom de l''utilisateur ayant réalisé l''opération';


--
-- TOC entry 2701 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN storage.storage_comment; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN storage.storage_comment IS 'Commentaire';


--
-- TOC entry 2702 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN storage.line_number; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN storage.line_number IS 'N° de la ligne de stockage dans le container';


--
-- TOC entry 2703 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN storage.column_number; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN storage.column_number IS 'Numéro de la colonne de stockage dans le container';


--
-- TOC entry 206 (class 1259 OID 40004)
-- Name: last_movement; Type: VIEW; Schema: col; Owner: collec
--

CREATE VIEW last_movement AS
 SELECT s.uid,
    s.storage_id,
    s.storage_date,
    s.movement_type_id,
    s.container_id,
    c.uid AS container_uid,
    s.line_number,
    s.column_number
   FROM (storage s
     LEFT JOIN container c USING (container_id))
  WHERE (s.storage_id = ( SELECT st.storage_id
           FROM storage st
          WHERE (s.uid = st.uid)
          ORDER BY st.storage_date DESC
         LIMIT 1));


ALTER TABLE last_movement OWNER TO collec;

--
-- TOC entry 207 (class 1259 OID 40009)
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
-- TOC entry 208 (class 1259 OID 40013)
-- Name: metadata; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE metadata (
    metadata_id integer NOT NULL,
    metadata_name character varying NOT NULL,
    metadata_schema json
);


ALTER TABLE metadata OWNER TO collec;

--
-- TOC entry 2704 (class 0 OID 0)
-- Dependencies: 208
-- Name: TABLE metadata; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE metadata IS 'Table des metadata utilisables dans les types d''echantillons';


--
-- TOC entry 2705 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN metadata.metadata_name; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN metadata.metadata_name IS 'Nom du jeu de metadonnees';


--
-- TOC entry 2706 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN metadata.metadata_schema; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN metadata.metadata_schema IS 'Schéma en JSON du formulaire des métadonnées';


--
-- TOC entry 209 (class 1259 OID 40019)
-- Name: metadata_metadata_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE metadata_metadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE metadata_metadata_id_seq OWNER TO collec;

--
-- TOC entry 2707 (class 0 OID 0)
-- Dependencies: 209
-- Name: metadata_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE metadata_metadata_id_seq OWNED BY metadata.metadata_id;


--
-- TOC entry 210 (class 1259 OID 40021)
-- Name: mime_type; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE mime_type (
    mime_type_id integer NOT NULL,
    extension character varying NOT NULL,
    content_type character varying NOT NULL
);


ALTER TABLE mime_type OWNER TO collec;

--
-- TOC entry 2708 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE mime_type; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE mime_type IS 'Types mime des fichiers importés';


--
-- TOC entry 2709 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN mime_type.extension; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN mime_type.extension IS 'Extension du fichier correspondant';


--
-- TOC entry 2710 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN mime_type.content_type; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN mime_type.content_type IS 'type mime officiel';


--
-- TOC entry 211 (class 1259 OID 40027)
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
-- TOC entry 2711 (class 0 OID 0)
-- Dependencies: 211
-- Name: mime_type_mime_type_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE mime_type_mime_type_id_seq OWNED BY mime_type.mime_type_id;


--
-- TOC entry 212 (class 1259 OID 40029)
-- Name: movement_type; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE movement_type (
    movement_type_id integer NOT NULL,
    movement_type_name character varying NOT NULL
);


ALTER TABLE movement_type OWNER TO collec;

--
-- TOC entry 2712 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE movement_type; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE movement_type IS 'Type de mouvement';


--
-- TOC entry 213 (class 1259 OID 40035)
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
-- TOC entry 2713 (class 0 OID 0)
-- Dependencies: 213
-- Name: movement_type_movement_type_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE movement_type_movement_type_id_seq OWNED BY movement_type.movement_type_id;


--
-- TOC entry 214 (class 1259 OID 40037)
-- Name: multiple_type; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE multiple_type (
    multiple_type_id integer NOT NULL,
    multiple_type_name character varying NOT NULL
);


ALTER TABLE multiple_type OWNER TO collec;

--
-- TOC entry 2714 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE multiple_type; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE multiple_type IS 'Table des types de contenus multiples';


--
-- TOC entry 215 (class 1259 OID 40043)
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
-- TOC entry 2715 (class 0 OID 0)
-- Dependencies: 215
-- Name: multiple_type_multiple_type_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE multiple_type_multiple_type_id_seq OWNED BY multiple_type.multiple_type_id;


--
-- TOC entry 216 (class 1259 OID 40045)
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
-- TOC entry 2716 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE object; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE object IS 'Table des objets
Contient les identifiants génériques';


--
-- TOC entry 2717 (class 0 OID 0)
-- Dependencies: 216
-- Name: COLUMN object.identifier; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN object.identifier IS 'Identifiant fourni le cas échéant par le projet';


--
-- TOC entry 2718 (class 0 OID 0)
-- Dependencies: 216
-- Name: COLUMN object.wgs84_x; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN object.wgs84_x IS 'Longitude GPS, en valeur décimale';


--
-- TOC entry 2719 (class 0 OID 0)
-- Dependencies: 216
-- Name: COLUMN object.wgs84_y; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN object.wgs84_y IS 'Latitude GPS, en décimal';


--
-- TOC entry 217 (class 1259 OID 40051)
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
-- TOC entry 2720 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE object_identifier; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE object_identifier IS 'Table des identifiants complémentaires normalisés';


--
-- TOC entry 2721 (class 0 OID 0)
-- Dependencies: 217
-- Name: COLUMN object_identifier.object_identifier_value; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN object_identifier.object_identifier_value IS 'Valeur de l''identifiant';


--
-- TOC entry 218 (class 1259 OID 40057)
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
-- TOC entry 2722 (class 0 OID 0)
-- Dependencies: 218
-- Name: object_identifier_object_identifier_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE object_identifier_object_identifier_id_seq OWNED BY object_identifier.object_identifier_id;


--
-- TOC entry 219 (class 1259 OID 40059)
-- Name: object_status; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE object_status (
    object_status_id integer NOT NULL,
    object_status_name character varying NOT NULL
);


ALTER TABLE object_status OWNER TO collec;

--
-- TOC entry 2723 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE object_status; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE object_status IS 'Table des statuts possibles des objets';


--
-- TOC entry 220 (class 1259 OID 40065)
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
-- TOC entry 2724 (class 0 OID 0)
-- Dependencies: 220
-- Name: object_status_object_status_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE object_status_object_status_id_seq OWNED BY object_status.object_status_id;


--
-- TOC entry 221 (class 1259 OID 40067)
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
-- TOC entry 2725 (class 0 OID 0)
-- Dependencies: 221
-- Name: object_uid_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE object_uid_seq OWNED BY object.uid;


--
-- TOC entry 222 (class 1259 OID 40069)
-- Name: operation; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE operation (
    operation_id integer NOT NULL,
    protocol_id integer NOT NULL,
    operation_name character varying NOT NULL,
    operation_order integer,
    operation_version character varying,
    last_edit_date timestamp without time zone
);


ALTER TABLE operation OWNER TO collec;

--
-- TOC entry 2726 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN operation.operation_order; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN operation.operation_order IS 'Ordre de réalisation de l''opération dans le protocole';


--
-- TOC entry 2727 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN operation.operation_version; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN operation.operation_version IS 'Version de l''opération';


--
-- TOC entry 2728 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN operation.last_edit_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN operation.last_edit_date IS 'Date de dernière édition de l opération';


--
-- TOC entry 223 (class 1259 OID 40075)
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
-- TOC entry 2729 (class 0 OID 0)
-- Dependencies: 223
-- Name: operation_operation_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE operation_operation_id_seq OWNED BY operation.operation_id;


--
-- TOC entry 224 (class 1259 OID 40077)
-- Name: printer; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE printer (
    printer_id integer NOT NULL,
    printer_name character varying NOT NULL,
    printer_queue character varying NOT NULL,
    printer_server character varying,
    printer_user character varying,
    printer_comment character varying
);


ALTER TABLE printer OWNER TO collec;

--
-- TOC entry 2730 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE printer; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE printer IS 'Table des imprimantes gerees directement par le serveur';


--
-- TOC entry 2731 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN printer.printer_name; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN printer.printer_name IS 'Nom general de l''imprimante, affiche dans les masques de saisie';


--
-- TOC entry 2732 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN printer.printer_queue; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN printer.printer_queue IS 'Nom de l''imprimante telle qu''elle est connue par le systeme';


--
-- TOC entry 2733 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN printer.printer_server; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN printer.printer_server IS 'Adresse du serveur, si imprimante non locale';


--
-- TOC entry 2734 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN printer.printer_user; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN printer.printer_user IS 'Utilisateur autorise a imprimer ';


--
-- TOC entry 2735 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN printer.printer_comment; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN printer.printer_comment IS 'Commentaire';


--
-- TOC entry 225 (class 1259 OID 40083)
-- Name: printer_printer_id_seq; Type: SEQUENCE; Schema: col; Owner: collec
--

CREATE SEQUENCE printer_printer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE printer_printer_id_seq OWNER TO collec;

--
-- TOC entry 2736 (class 0 OID 0)
-- Dependencies: 225
-- Name: printer_printer_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE printer_printer_id_seq OWNED BY printer.printer_id;


--
-- TOC entry 226 (class 1259 OID 40085)
-- Name: project; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE project (
    project_id integer NOT NULL,
    project_name character varying NOT NULL
);


ALTER TABLE project OWNER TO collec;

--
-- TOC entry 2737 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE project; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE project IS 'Table des projets';


--
-- TOC entry 227 (class 1259 OID 40091)
-- Name: project_group; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE project_group (
    project_id integer NOT NULL,
    aclgroup_id integer NOT NULL
);


ALTER TABLE project_group OWNER TO collec;

--
-- TOC entry 2738 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE project_group; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE project_group IS 'Table des autorisations d''accès à un projet';


--
-- TOC entry 228 (class 1259 OID 40094)
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
-- TOC entry 2739 (class 0 OID 0)
-- Dependencies: 228
-- Name: project_project_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE project_project_id_seq OWNED BY project.project_id;


--
-- TOC entry 229 (class 1259 OID 40096)
-- Name: protocol; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE protocol (
    protocol_id integer NOT NULL,
    protocol_name character varying NOT NULL,
    protocol_file bytea,
    protocol_year smallint,
    protocol_version character varying DEFAULT 'v1.0'::character varying NOT NULL,
    project_id integer
);


ALTER TABLE protocol OWNER TO collec;

--
-- TOC entry 2740 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN protocol.protocol_file; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN protocol.protocol_file IS 'Description PDF du protocole';


--
-- TOC entry 2741 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN protocol.protocol_year; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN protocol.protocol_year IS 'Année du protocole';


--
-- TOC entry 2742 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN protocol.protocol_version; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN protocol.protocol_version IS 'Version du protocole';


--
-- TOC entry 230 (class 1259 OID 40103)
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
-- TOC entry 2743 (class 0 OID 0)
-- Dependencies: 230
-- Name: protocol_protocol_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE protocol_protocol_id_seq OWNED BY protocol.protocol_id;


--
-- TOC entry 231 (class 1259 OID 40105)
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
    metadata json
);


ALTER TABLE sample OWNER TO collec;

--
-- TOC entry 2744 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE sample; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE sample IS 'Table des échantillons';


--
-- TOC entry 2745 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN sample.sample_creation_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN sample.sample_creation_date IS 'Date de création de l''enregistrement dans la base de données';


--
-- TOC entry 2746 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN sample.sample_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN sample.sample_date IS 'Date de création de l''échantillon physique';


--
-- TOC entry 2747 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN sample.multiple_value; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN sample.multiple_value IS 'Nombre initial de sous-échantillons';


--
-- TOC entry 2748 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN sample.dbuid_origin; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN sample.dbuid_origin IS 'référence utilisée dans la base de données d''origine, sous la forme db:uid
Utilisé pour lire les étiquettes créées dans d''autres instances';


--
-- TOC entry 232 (class 1259 OID 40111)
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
-- TOC entry 2749 (class 0 OID 0)
-- Dependencies: 232
-- Name: sample_sample_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE sample_sample_id_seq OWNED BY sample.sample_id;


--
-- TOC entry 233 (class 1259 OID 40113)
-- Name: sample_type; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE sample_type (
    sample_type_id integer NOT NULL,
    sample_type_name character varying NOT NULL,
    container_type_id integer,
    multiple_type_id integer,
    multiple_unit character varying,
    operation_id integer,
    metadata_id integer
);


ALTER TABLE sample_type OWNER TO collec;

--
-- TOC entry 2750 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE sample_type; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE sample_type IS 'Types d''échantillons';


--
-- TOC entry 2751 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN sample_type.multiple_unit; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN sample_type.multiple_unit IS 'Unité caractérisant le sous-échantillon';


--
-- TOC entry 234 (class 1259 OID 40119)
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
-- TOC entry 2752 (class 0 OID 0)
-- Dependencies: 234
-- Name: sample_type_sample_type_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE sample_type_sample_type_id_seq OWNED BY sample_type.sample_type_id;


--
-- TOC entry 235 (class 1259 OID 40121)
-- Name: sampling_place; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE sampling_place (
    sampling_place_id integer NOT NULL,
    sampling_place_name character varying NOT NULL
);


ALTER TABLE sampling_place OWNER TO collec;

--
-- TOC entry 2753 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE sampling_place; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE sampling_place IS 'Table des lieux génériques d''échantillonnage';


--
-- TOC entry 236 (class 1259 OID 40127)
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
-- TOC entry 2754 (class 0 OID 0)
-- Dependencies: 236
-- Name: sampling_place_sampling_place_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE sampling_place_sampling_place_id_seq OWNED BY sampling_place.sampling_place_id;


--
-- TOC entry 237 (class 1259 OID 40129)
-- Name: storage_condition; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE storage_condition (
    storage_condition_id integer NOT NULL,
    storage_condition_name character varying NOT NULL
);


ALTER TABLE storage_condition OWNER TO collec;

--
-- TOC entry 2755 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE storage_condition; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE storage_condition IS 'Condition de stockage';


--
-- TOC entry 238 (class 1259 OID 40135)
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
-- TOC entry 2756 (class 0 OID 0)
-- Dependencies: 238
-- Name: storage_condition_storage_condition_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE storage_condition_storage_condition_id_seq OWNED BY storage_condition.storage_condition_id;


--
-- TOC entry 239 (class 1259 OID 40137)
-- Name: storage_reason; Type: TABLE; Schema: col; Owner: collec
--

CREATE TABLE storage_reason (
    storage_reason_id integer NOT NULL,
    storage_reason_name character varying NOT NULL
);


ALTER TABLE storage_reason OWNER TO collec;

--
-- TOC entry 2757 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE storage_reason; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE storage_reason IS 'Table des raisons de stockage/déstockage';


--
-- TOC entry 240 (class 1259 OID 40143)
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
-- TOC entry 2758 (class 0 OID 0)
-- Dependencies: 240
-- Name: storage_reason_storage_reason_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE storage_reason_storage_reason_id_seq OWNED BY storage_reason.storage_reason_id;


--
-- TOC entry 241 (class 1259 OID 40145)
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
-- TOC entry 2759 (class 0 OID 0)
-- Dependencies: 241
-- Name: storage_storage_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE storage_storage_id_seq OWNED BY storage.storage_id;


--
-- TOC entry 242 (class 1259 OID 40147)
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
-- TOC entry 2760 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE subsample; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON TABLE subsample IS 'Table des prélèvements et restitutions de sous-échantillons';


--
-- TOC entry 2761 (class 0 OID 0)
-- Dependencies: 242
-- Name: COLUMN subsample.subsample_date; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN subsample.subsample_date IS 'Date/heure de l''opération';


--
-- TOC entry 2762 (class 0 OID 0)
-- Dependencies: 242
-- Name: COLUMN subsample.subsample_quantity; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN subsample.subsample_quantity IS 'Quantité prélevée ou restituée';


--
-- TOC entry 2763 (class 0 OID 0)
-- Dependencies: 242
-- Name: COLUMN subsample.subsample_login; Type: COMMENT; Schema: col; Owner: collec
--

COMMENT ON COLUMN subsample.subsample_login IS 'Login de l''utilisateur ayant réalisé l''opération';


--
-- TOC entry 243 (class 1259 OID 40153)
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
-- TOC entry 2764 (class 0 OID 0)
-- Dependencies: 243
-- Name: subsample_subsample_id_seq; Type: SEQUENCE OWNED BY; Schema: col; Owner: collec
--

ALTER SEQUENCE subsample_subsample_id_seq OWNED BY subsample.subsample_id;


--
-- TOC entry 244 (class 1259 OID 40155)
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
-- TOC entry 245 (class 1259 OID 40159)
-- Name: aclacl; Type: TABLE; Schema: gacl; Owner: collec
--

CREATE TABLE aclacl (
    aclaco_id integer NOT NULL,
    aclgroup_id integer NOT NULL
);


ALTER TABLE aclacl OWNER TO collec;

--
-- TOC entry 2765 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE aclacl; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON TABLE aclacl IS 'Table des droits attribués';


--
-- TOC entry 246 (class 1259 OID 40162)
-- Name: aclaco; Type: TABLE; Schema: gacl; Owner: collec
--

CREATE TABLE aclaco (
    aclaco_id integer NOT NULL,
    aclappli_id integer NOT NULL,
    aco character varying NOT NULL
);


ALTER TABLE aclaco OWNER TO collec;

--
-- TOC entry 2766 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE aclaco; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON TABLE aclaco IS 'Table des droits gérés';


--
-- TOC entry 247 (class 1259 OID 40168)
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
-- TOC entry 2767 (class 0 OID 0)
-- Dependencies: 247
-- Name: aclaco_aclaco_id_seq; Type: SEQUENCE OWNED BY; Schema: gacl; Owner: collec
--

ALTER SEQUENCE aclaco_aclaco_id_seq OWNED BY aclaco.aclaco_id;


--
-- TOC entry 248 (class 1259 OID 40170)
-- Name: aclappli; Type: TABLE; Schema: gacl; Owner: collec
--

CREATE TABLE aclappli (
    aclappli_id integer NOT NULL,
    appli character varying NOT NULL,
    applidetail character varying
);


ALTER TABLE aclappli OWNER TO collec;

--
-- TOC entry 2768 (class 0 OID 0)
-- Dependencies: 248
-- Name: TABLE aclappli; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON TABLE aclappli IS 'Table des applications gérées';


--
-- TOC entry 2769 (class 0 OID 0)
-- Dependencies: 248
-- Name: COLUMN aclappli.appli; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON COLUMN aclappli.appli IS 'Nom de l''application pour la gestion des droits';


--
-- TOC entry 2770 (class 0 OID 0)
-- Dependencies: 248
-- Name: COLUMN aclappli.applidetail; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON COLUMN aclappli.applidetail IS 'Description de l''application';


--
-- TOC entry 249 (class 1259 OID 40176)
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
-- TOC entry 2771 (class 0 OID 0)
-- Dependencies: 249
-- Name: aclappli_aclappli_id_seq; Type: SEQUENCE OWNED BY; Schema: gacl; Owner: collec
--

ALTER SEQUENCE aclappli_aclappli_id_seq OWNED BY aclappli.aclappli_id;


--
-- TOC entry 250 (class 1259 OID 40178)
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
-- TOC entry 2772 (class 0 OID 0)
-- Dependencies: 250
-- Name: aclgroup_aclgroup_id_seq; Type: SEQUENCE OWNED BY; Schema: gacl; Owner: collec
--

ALTER SEQUENCE aclgroup_aclgroup_id_seq OWNED BY aclgroup.aclgroup_id;


--
-- TOC entry 251 (class 1259 OID 40180)
-- Name: acllogin; Type: TABLE; Schema: gacl; Owner: collec
--

CREATE TABLE acllogin (
    acllogin_id integer NOT NULL,
    login character varying NOT NULL,
    logindetail character varying NOT NULL
);


ALTER TABLE acllogin OWNER TO collec;

--
-- TOC entry 2773 (class 0 OID 0)
-- Dependencies: 251
-- Name: TABLE acllogin; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON TABLE acllogin IS 'Table des logins des utilisateurs autorisés';


--
-- TOC entry 2774 (class 0 OID 0)
-- Dependencies: 251
-- Name: COLUMN acllogin.logindetail; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON COLUMN acllogin.logindetail IS 'Nom affiché';


--
-- TOC entry 252 (class 1259 OID 40186)
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
-- TOC entry 2775 (class 0 OID 0)
-- Dependencies: 252
-- Name: acllogin_acllogin_id_seq; Type: SEQUENCE OWNED BY; Schema: gacl; Owner: collec
--

ALTER SEQUENCE acllogin_acllogin_id_seq OWNED BY acllogin.acllogin_id;


--
-- TOC entry 253 (class 1259 OID 40188)
-- Name: acllogingroup; Type: TABLE; Schema: gacl; Owner: collec
--

CREATE TABLE acllogingroup (
    acllogin_id integer NOT NULL,
    aclgroup_id integer NOT NULL
);


ALTER TABLE acllogingroup OWNER TO collec;

--
-- TOC entry 2776 (class 0 OID 0)
-- Dependencies: 253
-- Name: TABLE acllogingroup; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON TABLE acllogingroup IS 'Table des relations entre les logins et les groupes';


--
-- TOC entry 254 (class 1259 OID 40191)
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
-- TOC entry 2777 (class 0 OID 0)
-- Dependencies: 254
-- Name: TABLE log; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON TABLE log IS 'Liste des connexions ou des actions enregistrées';


--
-- TOC entry 2778 (class 0 OID 0)
-- Dependencies: 254
-- Name: COLUMN log.log_date; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON COLUMN log.log_date IS 'Heure de connexion';


--
-- TOC entry 2779 (class 0 OID 0)
-- Dependencies: 254
-- Name: COLUMN log.commentaire; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON COLUMN log.commentaire IS 'Donnees complementaires enregistrees';


--
-- TOC entry 2780 (class 0 OID 0)
-- Dependencies: 254
-- Name: COLUMN log.ipaddress; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON COLUMN log.ipaddress IS 'Adresse IP du client';


--
-- TOC entry 255 (class 1259 OID 40197)
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
-- TOC entry 2781 (class 0 OID 0)
-- Dependencies: 255
-- Name: log_log_id_seq; Type: SEQUENCE OWNED BY; Schema: gacl; Owner: collec
--

ALTER SEQUENCE log_log_id_seq OWNED BY log.log_id;


--
-- TOC entry 256 (class 1259 OID 40199)
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
-- TOC entry 257 (class 1259 OID 40201)
-- Name: login_oldpassword; Type: TABLE; Schema: gacl; Owner: collec
--

CREATE TABLE login_oldpassword (
    login_oldpassword_id integer NOT NULL,
    id integer DEFAULT nextval('seq_logingestion_id'::regclass) NOT NULL,
    password character varying(255)
);


ALTER TABLE login_oldpassword OWNER TO collec;

--
-- TOC entry 2782 (class 0 OID 0)
-- Dependencies: 257
-- Name: TABLE login_oldpassword; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON TABLE login_oldpassword IS 'Table contenant les anciens mots de passe';


--
-- TOC entry 258 (class 1259 OID 40205)
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
-- TOC entry 2783 (class 0 OID 0)
-- Dependencies: 258
-- Name: login_oldpassword_login_oldpassword_id_seq; Type: SEQUENCE OWNED BY; Schema: gacl; Owner: collec
--

ALTER SEQUENCE login_oldpassword_login_oldpassword_id_seq OWNED BY login_oldpassword.login_oldpassword_id;


--
-- TOC entry 259 (class 1259 OID 40207)
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

--
-- TOC entry 260 (class 1259 OID 40215)
-- Name: passwordlost; Type: TABLE; Schema: gacl; Owner: collec
--

CREATE TABLE passwordlost (
    passwordlost_id integer NOT NULL,
    id integer NOT NULL,
    token character varying NOT NULL,
    expiration timestamp without time zone NOT NULL,
    usedate timestamp without time zone
);


ALTER TABLE passwordlost OWNER TO collec;

--
-- TOC entry 2784 (class 0 OID 0)
-- Dependencies: 260
-- Name: TABLE passwordlost; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON TABLE passwordlost IS 'Table de suivi des pertes de mots de passe';


--
-- TOC entry 2785 (class 0 OID 0)
-- Dependencies: 260
-- Name: COLUMN passwordlost.token; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON COLUMN passwordlost.token IS 'Jeton utilise pour le renouvellement';


--
-- TOC entry 2786 (class 0 OID 0)
-- Dependencies: 260
-- Name: COLUMN passwordlost.expiration; Type: COMMENT; Schema: gacl; Owner: collec
--

COMMENT ON COLUMN passwordlost.expiration IS 'Date d''expiration du jeton';


--
-- TOC entry 261 (class 1259 OID 40221)
-- Name: passwordlost_passwordlost_id_seq; Type: SEQUENCE; Schema: gacl; Owner: collec
--

CREATE SEQUENCE passwordlost_passwordlost_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE passwordlost_passwordlost_id_seq OWNER TO collec;

--
-- TOC entry 2787 (class 0 OID 0)
-- Dependencies: 261
-- Name: passwordlost_passwordlost_id_seq; Type: SEQUENCE OWNED BY; Schema: gacl; Owner: collec
--

ALTER SEQUENCE passwordlost_passwordlost_id_seq OWNED BY passwordlost.passwordlost_id;


SET search_path = col, pg_catalog;

--
-- TOC entry 2267 (class 2604 OID 40223)
-- Name: booking_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY booking ALTER COLUMN booking_id SET DEFAULT nextval('booking_booking_id_seq'::regclass);


--
-- TOC entry 2268 (class 2604 OID 40224)
-- Name: container_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container ALTER COLUMN container_id SET DEFAULT nextval('container_container_id_seq'::regclass);


--
-- TOC entry 2270 (class 2604 OID 40225)
-- Name: container_family_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container_family ALTER COLUMN container_family_id SET DEFAULT nextval('container_family_container_family_id_seq'::regclass);


--
-- TOC entry 2274 (class 2604 OID 40226)
-- Name: container_type_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container_type ALTER COLUMN container_type_id SET DEFAULT nextval('container_type_container_type_id_seq'::regclass);


--
-- TOC entry 2275 (class 2604 OID 40227)
-- Name: dbversion_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY dbversion ALTER COLUMN dbversion_id SET DEFAULT nextval('dbversion_dbversion_id_seq'::regclass);


--
-- TOC entry 2276 (class 2604 OID 40228)
-- Name: document_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY document ALTER COLUMN document_id SET DEFAULT nextval('document_document_id_seq'::regclass);


--
-- TOC entry 2277 (class 2604 OID 40229)
-- Name: event_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY event ALTER COLUMN event_id SET DEFAULT nextval('event_event_id_seq'::regclass);


--
-- TOC entry 2280 (class 2604 OID 40230)
-- Name: event_type_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY event_type ALTER COLUMN event_type_id SET DEFAULT nextval('event_type_event_type_id_seq'::regclass);


--
-- TOC entry 2281 (class 2604 OID 40231)
-- Name: identifier_type_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY identifier_type ALTER COLUMN identifier_type_id SET DEFAULT nextval('identifier_type_identifier_type_id_seq'::regclass);


--
-- TOC entry 2284 (class 2604 OID 40232)
-- Name: label_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY label ALTER COLUMN label_id SET DEFAULT nextval('label_label_id_seq'::regclass);


--
-- TOC entry 2289 (class 2604 OID 40233)
-- Name: metadata_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY metadata ALTER COLUMN metadata_id SET DEFAULT nextval('metadata_metadata_id_seq'::regclass);


--
-- TOC entry 2290 (class 2604 OID 40234)
-- Name: mime_type_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY mime_type ALTER COLUMN mime_type_id SET DEFAULT nextval('mime_type_mime_type_id_seq'::regclass);


--
-- TOC entry 2291 (class 2604 OID 40235)
-- Name: movement_type_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY movement_type ALTER COLUMN movement_type_id SET DEFAULT nextval('movement_type_movement_type_id_seq'::regclass);


--
-- TOC entry 2292 (class 2604 OID 40236)
-- Name: multiple_type_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY multiple_type ALTER COLUMN multiple_type_id SET DEFAULT nextval('multiple_type_multiple_type_id_seq'::regclass);


--
-- TOC entry 2293 (class 2604 OID 40237)
-- Name: uid; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY object ALTER COLUMN uid SET DEFAULT nextval('object_uid_seq'::regclass);


--
-- TOC entry 2294 (class 2604 OID 40238)
-- Name: object_identifier_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY object_identifier ALTER COLUMN object_identifier_id SET DEFAULT nextval('object_identifier_object_identifier_id_seq'::regclass);


--
-- TOC entry 2295 (class 2604 OID 40239)
-- Name: object_status_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY object_status ALTER COLUMN object_status_id SET DEFAULT nextval('object_status_object_status_id_seq'::regclass);


--
-- TOC entry 2296 (class 2604 OID 40240)
-- Name: operation_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY operation ALTER COLUMN operation_id SET DEFAULT nextval('operation_operation_id_seq'::regclass);


--
-- TOC entry 2297 (class 2604 OID 40241)
-- Name: printer_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY printer ALTER COLUMN printer_id SET DEFAULT nextval('printer_printer_id_seq'::regclass);


--
-- TOC entry 2298 (class 2604 OID 40242)
-- Name: project_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY project ALTER COLUMN project_id SET DEFAULT nextval('project_project_id_seq'::regclass);


--
-- TOC entry 2300 (class 2604 OID 40243)
-- Name: protocol_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY protocol ALTER COLUMN protocol_id SET DEFAULT nextval('protocol_protocol_id_seq'::regclass);


--
-- TOC entry 2301 (class 2604 OID 40244)
-- Name: sample_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample ALTER COLUMN sample_id SET DEFAULT nextval('sample_sample_id_seq'::regclass);


--
-- TOC entry 2302 (class 2604 OID 40245)
-- Name: sample_type_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample_type ALTER COLUMN sample_type_id SET DEFAULT nextval('sample_type_sample_type_id_seq'::regclass);


--
-- TOC entry 2303 (class 2604 OID 40246)
-- Name: sampling_place_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sampling_place ALTER COLUMN sampling_place_id SET DEFAULT nextval('sampling_place_sampling_place_id_seq'::regclass);


--
-- TOC entry 2288 (class 2604 OID 40247)
-- Name: storage_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage ALTER COLUMN storage_id SET DEFAULT nextval('storage_storage_id_seq'::regclass);


--
-- TOC entry 2304 (class 2604 OID 40248)
-- Name: storage_condition_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage_condition ALTER COLUMN storage_condition_id SET DEFAULT nextval('storage_condition_storage_condition_id_seq'::regclass);


--
-- TOC entry 2305 (class 2604 OID 40249)
-- Name: storage_reason_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage_reason ALTER COLUMN storage_reason_id SET DEFAULT nextval('storage_reason_storage_reason_id_seq'::regclass);


--
-- TOC entry 2306 (class 2604 OID 40250)
-- Name: subsample_id; Type: DEFAULT; Schema: col; Owner: collec
--

ALTER TABLE ONLY subsample ALTER COLUMN subsample_id SET DEFAULT nextval('subsample_subsample_id_seq'::regclass);


SET search_path = gacl, pg_catalog;

--
-- TOC entry 2307 (class 2604 OID 40251)
-- Name: aclaco_id; Type: DEFAULT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclaco ALTER COLUMN aclaco_id SET DEFAULT nextval('aclaco_aclaco_id_seq'::regclass);


--
-- TOC entry 2308 (class 2604 OID 40252)
-- Name: aclappli_id; Type: DEFAULT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclappli ALTER COLUMN aclappli_id SET DEFAULT nextval('aclappli_aclappli_id_seq'::regclass);


--
-- TOC entry 2266 (class 2604 OID 40253)
-- Name: aclgroup_id; Type: DEFAULT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclgroup ALTER COLUMN aclgroup_id SET DEFAULT nextval('aclgroup_aclgroup_id_seq'::regclass);


--
-- TOC entry 2309 (class 2604 OID 40254)
-- Name: acllogin_id; Type: DEFAULT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY acllogin ALTER COLUMN acllogin_id SET DEFAULT nextval('acllogin_acllogin_id_seq'::regclass);


--
-- TOC entry 2310 (class 2604 OID 40255)
-- Name: log_id; Type: DEFAULT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY log ALTER COLUMN log_id SET DEFAULT nextval('log_log_id_seq'::regclass);


--
-- TOC entry 2312 (class 2604 OID 40256)
-- Name: login_oldpassword_id; Type: DEFAULT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY login_oldpassword ALTER COLUMN login_oldpassword_id SET DEFAULT nextval('login_oldpassword_login_oldpassword_id_seq'::regclass);


--
-- TOC entry 2315 (class 2604 OID 40257)
-- Name: passwordlost_id; Type: DEFAULT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY passwordlost ALTER COLUMN passwordlost_id SET DEFAULT nextval('passwordlost_passwordlost_id_seq'::regclass);


SET search_path = col, pg_catalog;

--
-- TOC entry 2560 (class 0 OID 39912)
-- Dependencies: 185
-- Data for Name: booking; Type: TABLE DATA; Schema: col; Owner: collec
--



--
-- TOC entry 2788 (class 0 OID 0)
-- Dependencies: 186
-- Name: booking_booking_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('booking_booking_id_seq', 1, false);


--
-- TOC entry 2562 (class 0 OID 39920)
-- Dependencies: 187
-- Data for Name: container; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO container VALUES (1, 1, 3);
INSERT INTO container VALUES (2, 2, 8);
INSERT INTO container VALUES (3, 8, 2);
INSERT INTO container VALUES (4, 9, 7);
INSERT INTO container VALUES (5, 10, 12);
INSERT INTO container VALUES (6, 11, 12);
INSERT INTO container VALUES (7, 12, 7);
INSERT INTO container VALUES (8, 13, 12);
INSERT INTO container VALUES (9, 14, 12);
INSERT INTO container VALUES (10, 15, 6);
INSERT INTO container VALUES (11, 16, 6);
INSERT INTO container VALUES (12, 17, 6);
INSERT INTO container VALUES (13, 18, 6);
INSERT INTO container VALUES (14, 19, 6);
INSERT INTO container VALUES (15, 20, 6);
INSERT INTO container VALUES (16, 21, 6);
INSERT INTO container VALUES (17, 22, 6);
INSERT INTO container VALUES (18, 23, 6);
INSERT INTO container VALUES (19, 24, 6);
INSERT INTO container VALUES (20, 25, 6);
INSERT INTO container VALUES (21, 26, 6);
INSERT INTO container VALUES (22, 27, 6);
INSERT INTO container VALUES (23, 28, 6);
INSERT INTO container VALUES (24, 29, 6);
INSERT INTO container VALUES (25, 30, 6);
INSERT INTO container VALUES (26, 31, 6);
INSERT INTO container VALUES (27, 32, 6);
INSERT INTO container VALUES (28, 33, 6);
INSERT INTO container VALUES (29, 34, 6);
INSERT INTO container VALUES (30, 35, 6);
INSERT INTO container VALUES (31, 36, 6);
INSERT INTO container VALUES (32, 37, 6);
INSERT INTO container VALUES (33, 38, 6);
INSERT INTO container VALUES (34, 39, 6);
INSERT INTO container VALUES (35, 40, 6);
INSERT INTO container VALUES (36, 41, 6);
INSERT INTO container VALUES (37, 42, 6);
INSERT INTO container VALUES (38, 43, 6);
INSERT INTO container VALUES (39, 44, 6);
INSERT INTO container VALUES (40, 45, 6);
INSERT INTO container VALUES (41, 46, 6);
INSERT INTO container VALUES (42, 47, 6);
INSERT INTO container VALUES (43, 48, 6);
INSERT INTO container VALUES (44, 49, 6);
INSERT INTO container VALUES (45, 50, 6);
INSERT INTO container VALUES (46, 51, 6);
INSERT INTO container VALUES (47, 52, 6);
INSERT INTO container VALUES (48, 53, 6);
INSERT INTO container VALUES (49, 54, 6);
INSERT INTO container VALUES (50, 55, 6);
INSERT INTO container VALUES (51, 56, 6);
INSERT INTO container VALUES (52, 57, 6);
INSERT INTO container VALUES (53, 58, 6);
INSERT INTO container VALUES (54, 59, 6);
INSERT INTO container VALUES (55, 60, 6);
INSERT INTO container VALUES (56, 61, 6);
INSERT INTO container VALUES (57, 62, 6);
INSERT INTO container VALUES (58, 63, 6);
INSERT INTO container VALUES (59, 64, 6);
INSERT INTO container VALUES (60, 65, 6);
INSERT INTO container VALUES (61, 66, 6);
INSERT INTO container VALUES (62, 67, 6);
INSERT INTO container VALUES (63, 68, 6);
INSERT INTO container VALUES (64, 69, 6);
INSERT INTO container VALUES (65, 70, 6);
INSERT INTO container VALUES (66, 71, 6);
INSERT INTO container VALUES (67, 72, 6);
INSERT INTO container VALUES (68, 73, 6);
INSERT INTO container VALUES (69, 74, 6);
INSERT INTO container VALUES (70, 75, 6);
INSERT INTO container VALUES (71, 76, 6);
INSERT INTO container VALUES (72, 77, 6);
INSERT INTO container VALUES (73, 78, 6);
INSERT INTO container VALUES (74, 79, 6);
INSERT INTO container VALUES (75, 80, 6);
INSERT INTO container VALUES (76, 81, 6);
INSERT INTO container VALUES (77, 82, 6);
INSERT INTO container VALUES (78, 83, 6);
INSERT INTO container VALUES (79, 84, 6);
INSERT INTO container VALUES (80, 85, 6);
INSERT INTO container VALUES (81, 86, 6);
INSERT INTO container VALUES (82, 87, 6);
INSERT INTO container VALUES (83, 88, 6);
INSERT INTO container VALUES (84, 89, 6);
INSERT INTO container VALUES (85, 90, 6);
INSERT INTO container VALUES (86, 91, 6);
INSERT INTO container VALUES (87, 92, 6);
INSERT INTO container VALUES (88, 93, 6);


--
-- TOC entry 2789 (class 0 OID 0)
-- Dependencies: 188
-- Name: container_container_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('container_container_id_seq', 88, true);


--
-- TOC entry 2564 (class 0 OID 39925)
-- Dependencies: 189
-- Data for Name: container_family; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO container_family VALUES (1, 'Immobilier', false);
INSERT INTO container_family VALUES (2, 'Mobilier', false);


--
-- TOC entry 2790 (class 0 OID 0)
-- Dependencies: 190
-- Name: container_family_container_family_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('container_family_container_family_id_seq', 2, true);


--
-- TOC entry 2566 (class 0 OID 39934)
-- Dependencies: 191
-- Data for Name: container_type; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO container_type VALUES (1, 'Site', 1, NULL, NULL, NULL, NULL, NULL, 1, 1, 'T');
INSERT INTO container_type VALUES (2, 'Bâtiment', 1, NULL, NULL, NULL, NULL, NULL, 1, 1, 'T');
INSERT INTO container_type VALUES (3, 'Pièce', 1, NULL, NULL, NULL, NULL, NULL, 1, 1, 'T');
INSERT INTO container_type VALUES (4, 'Armoire', 2, NULL, NULL, NULL, NULL, NULL, 1, 1, 'T');
INSERT INTO container_type VALUES (5, 'Congélateur', 2, NULL, NULL, NULL, NULL, NULL, 1, 1, 'T');
INSERT INTO container_type VALUES (7, 'Chambre froide', 1, 1, 2, 'Pièce pour conservation de carottes (conteneur ou chambre froide) à 4°C, avec ou sans étuis. Etiquettes posées sur les portes.', NULL, NULL, 1, 1, 'T');
INSERT INTO container_type VALUES (8, 'Etagère', 2, NULL, NULL, 'Armoire ou étagère de rangement', NULL, NULL, 1, 1, 'T');
INSERT INTO container_type VALUES (9, 'Carton', 2, NULL, NULL, 'Carton de déménagement contenant des piluliers ou des boîtes pour mini-tubes', NULL, NULL, 1, 1, 'T');
INSERT INTO container_type VALUES (10, 'Boite de 100 mini-tubes', 2, NULL, NULL, NULL, NULL, NULL, 1, 1, 'T');
INSERT INTO container_type VALUES (11, 'Pilulier', 2, NULL, NULL, 'Pilulier', NULL, NULL, 1, 1, 'T');
INSERT INTO container_type VALUES (12, 'Grille', 2, 1, 2, 'Grille de rangement des étuis dans les chambres froides', NULL, NULL, 50, 15, 'T');
INSERT INTO container_type VALUES (6, 'Etui_ou_casier', 2, 1, 3, 'Case de rangement des carottes sédimentaires (run/section/demi_section)', NULL, NULL, 1, 1, 'T');


--
-- TOC entry 2791 (class 0 OID 0)
-- Dependencies: 192
-- Name: container_type_container_type_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('container_type_container_type_id_seq', 12, true);


--
-- TOC entry 2634 (class 0 OID 40546)
-- Dependencies: 262
-- Data for Name: dbparam; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO dbparam VALUES (1, 'APPLI_code', 'TEST');


--
-- TOC entry 2568 (class 0 OID 39945)
-- Dependencies: 193
-- Data for Name: dbversion; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO dbversion VALUES (1, '1.1', '2017-09-01 00:00:00');
INSERT INTO dbversion VALUES (2, '1.2', '2017-10-20 00:00:00');


--
-- TOC entry 2792 (class 0 OID 0)
-- Dependencies: 194
-- Name: dbversion_dbversion_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('dbversion_dbversion_id_seq', 2, true);


--
-- TOC entry 2570 (class 0 OID 39953)
-- Dependencies: 195
-- Data for Name: document; Type: TABLE DATA; Schema: col; Owner: collec
--



--
-- TOC entry 2793 (class 0 OID 0)
-- Dependencies: 196
-- Name: document_document_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('document_document_id_seq', 1, false);


--
-- TOC entry 2572 (class 0 OID 39961)
-- Dependencies: 197
-- Data for Name: event; Type: TABLE DATA; Schema: col; Owner: collec
--



--
-- TOC entry 2794 (class 0 OID 0)
-- Dependencies: 198
-- Name: event_event_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('event_event_id_seq', 1, false);


--
-- TOC entry 2574 (class 0 OID 39969)
-- Dependencies: 199
-- Data for Name: event_type; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO event_type VALUES (1, 'Autre', true, true);
INSERT INTO event_type VALUES (2, 'Conteneur cassé', false, true);
INSERT INTO event_type VALUES (3, 'Échantillon détruit', true, false);
INSERT INTO event_type VALUES (4, 'Prélèvement pour analyse', true, false);
INSERT INTO event_type VALUES (5, 'Échantillon totalement analysé, détruit', true, false);


--
-- TOC entry 2795 (class 0 OID 0)
-- Dependencies: 200
-- Name: event_type_event_type_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('event_type_event_type_id_seq', 5, true);


--
-- TOC entry 2576 (class 0 OID 39979)
-- Dependencies: 201
-- Data for Name: identifier_type; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO identifier_type VALUES (1, 'conteneur_porte', 'conteneur_porte', false);
INSERT INTO identifier_type VALUES (2, 'igsn', 'igsn', false);


--
-- TOC entry 2796 (class 0 OID 0)
-- Dependencies: 202
-- Name: identifier_type_identifier_type_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('identifier_type_identifier_type_id_seq', 2, true);


--
-- TOC entry 2578 (class 0 OID 39987)
-- Dependencies: 203
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
</xsl:stylesheet>', 'uid,id,clp,db,prj', NULL, false);
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
</xsl:stylesheet>', 'id,db,uid', NULL, false);
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
</xsl:stylesheet>', 'uid,id,db,conteneur_porte', NULL, false);
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
</xsl:stylesheet>', 'uid,db', NULL, false);
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
            <fo:block><fo:inline font-size="9pt"><xsl:value-of select="site"/></fo:inline></fo:block>
            <fo:block><fo:inline font-size="9pt"><xsl:value-of select="type"/></fo:inline></fo:block>
            <fo:block><fo:inline font-size="10pt" font-weight="bold"><xsl:value-of select="id"/></fo:inline></fo:block>
            <fo:block><fo:inline font-size="9pt"><xsl:value-of select="profondeur_top"/> / <xsl:value-of select="profondeur_bottom"/> (cm)</fo:inline></fo:block>
            <fo:block><fo:inline font-size="9pt"><xsl:value-of select="pi"/></fo:inline></fo:block>
        </fo:table-cell>
        </fo:table-row>
  </fo:table-body>
  </fo:table>
  </xsl:template>
</xsl:stylesheet>', 'db,uid,id,prj,cd,x,y,pi', 3, false);
INSERT INTO label VALUES (5, 'Etiquette_run_section_IGSN', '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="objects">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="label"
              page-height="3.17cm" page-width="5.71cm" margin-left="0cm" margin-top="0cm" margin-bottom="0cm" margin-right="0cm">  
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
  <fo:table-column column-width="2.7cm"/>
  <fo:table-column column-width="2.3cm" />
 <fo:table-body  border-style="none" >
    <fo:table-row>

        <fo:table-cell > 
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
<fo:block  linefeed-treatment="preserve" line-height="90%" margin-left="0.2cm"><fo:inline font-size="7pt">igsn: <xsl:value-of select="igsn"/></fo:inline></fo:block>
        </fo:table-cell>

        <fo:table-cell> 
<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
            <fo:block font-size="7pt" line-height="120%">uid:<fo:inline font-weight="bold"><xsl:value-of select="db"/>:<xsl:value-of select="uid"/></fo:inline></fo:block>
            <fo:block line-height="110%"><fo:inline font-size="7pt"><xsl:value-of select="site"/></fo:inline></fo:block>
            <fo:block line-height="110%"><fo:inline font-size="7pt"><xsl:value-of select="type"/></fo:inline></fo:block>
            <fo:block line-height="110%"><fo:inline font-size="7pt" font-weight="bold"><xsl:value-of select="id"/></fo:inline></fo:block>
            <fo:block line-height="110%"><fo:inline font-size="7pt"><xsl:value-of select="profondeur_top"/> / <xsl:value-of select="profondeur_bottom"/> (cm)</fo:inline></fo:block>
            <fo:block line-height="90%"><fo:inline font-size="6pt"><xsl:value-of select="pi"/></fo:inline></fo:block>
        </fo:table-cell>
        </fo:table-row>
  </fo:table-body>
  </fo:table>
  
  </xsl:template>
</xsl:stylesheet>', 'db,uid,id,prj,cd,x,y,pi,igsn', 4, false);
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
', 'uid,db', NULL, false);
INSERT INTO label VALUES (11, 'minitubes_special', '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="objects">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="label"
              page-height="1cm" page-width="4.1cm" margin-left="0.4cm" margin-top="0.1cm" margin-bottom="0cm" margin-right="0.7cm">  
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

  <fo:table table-layout="fixed" border-collapse="collapse"  border-style="none" width="2.8cm" keep-together.within-page="always" keep-together.within-column="always">
  <fo:table-column column-width="1.5cm"/>
  <fo:table-column column-width="1cm" />
  <fo:table-column column-width="0.3cm" />
 <fo:table-body  border-style="none" >
    <fo:table-row>

        <fo:table-cell> 
        <fo:block>
<fo:inline font-size="10pt">
<xsl:value-of select="id"/> 
</fo:inline>
        </fo:block>
        </fo:table-cell>
 
        <fo:table-cell>
        <fo:block>
        <fo:external-graphic>
      <xsl:attribute name="src">
             <xsl:value-of select="concat(uid,''.png'')" />
       </xsl:attribute>
       <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
       <xsl:attribute name="height">0.8cm</xsl:attribute>
        <xsl:attribute name="content-width">0.8cm</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
       </fo:external-graphic>
        </fo:block>
        </fo:table-cell>

        <fo:table-cell  font-size="1pt" margin-top="0.1cm">
<fo:block wrap-option="wrap" linefeed-treatment="preserve">
<fo:inline font-size="5pt">
<xsl:value-of select="PROTOCOLE"/><xsl:value-of select="ANNEE"/>s<xsl:value-of select="SESSION"/></fo:inline>
</fo:block> 
<fo:block wrap-option="wrap" linefeed-treatment="preserve">
<fo:inline font-size="5pt">
<xsl:value-of select="CARRE"/> </fo:inline>
</fo:block> 
<fo:block wrap-option="wrap" linefeed-treatment="preserve">
<fo:inline font-size="5pt">
<xsl:value-of select="PARCELLE"/> </fo:inline>
</fo:block> 
<fo:block wrap-option="wrap" linefeed-treatment="preserve">
<fo:inline font-size="5pt">
<xsl:value-of select="id"/>
</fo:inline>
</fo:block> 
         
        </fo:table-cell>
        </fo:table-row>
  </fo:table-body>
  </fo:table>

  </xsl:template>
</xsl:stylesheet>', 'uid,db', NULL, false);
INSERT INTO label VALUES (9, 'etiquette_minitube_entomo', '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="objects">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="label"
              page-height="0.8cm" page-width="5.1cm" margin-left="1cm" margin-top="0cm" margin-bottom="0cm" margin-right="1cm">  
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

  <fo:table table-layout="fixed" border-collapse="collapse"  border-style="none" width="2.8cm" keep-together.within-page="always" keep-together.within-column="always">
  <fo:table-column column-width="1.5cm"/>
  <fo:table-column column-width="1cm" />
  <fo:table-column column-width="0.3cm" />
 <fo:table-body  border-style="none" >
    <fo:table-row>

        <fo:table-cell margin-top="0.2cm"> 
        <fo:block>
<fo:inline font-size="10pt">
<xsl:value-of select="id"/> 
</fo:inline>
        </fo:block>
        </fo:table-cell>
 
        <fo:table-cell margin-top="0.1cm">
        <fo:block>
        <fo:external-graphic>
      <xsl:attribute name="src">
             <xsl:value-of select="concat(uid,''.png'')" />
       </xsl:attribute>
       <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
       <xsl:attribute name="height">0.8cm</xsl:attribute>
        <xsl:attribute name="content-width">0.8cm</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
       </fo:external-graphic>
        </fo:block>
        </fo:table-cell>

        <fo:table-cell  font-size="1pt" margin-top="0.2cm">
<fo:block wrap-option="wrap" linefeed-treatment="preserve">
<fo:inline font-size="5pt">
<xsl:value-of select="protocole"/><xsl:value-of select="annee"/>s<xsl:value-of select="session"/></fo:inline>
</fo:block> 
<fo:block wrap-option="wrap" linefeed-treatment="preserve">
<fo:inline font-size="5pt">
<xsl:value-of select="carre"/> </fo:inline>
</fo:block> 
<fo:block wrap-option="wrap" linefeed-treatment="preserve">
<fo:inline font-size="5pt">
<xsl:value-of select="parcelle"/> </fo:inline>
</fo:block> 
<fo:block wrap-option="wrap" linefeed-treatment="preserve">
<fo:inline font-size="5pt">
<xsl:value-of select="id"/>
</fo:inline>
</fo:block> 
         
        </fo:table-cell>
        </fo:table-row>
  </fo:table-body>
  </fo:table>

  </xsl:template>
</xsl:stylesheet>', 'uid,db', 2, false);
INSERT INTO label VALUES (10, 'Etiquette_pot_piege_collecte', '<?xml version="1.0" encoding="utf-8"?>
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
            <fo:block><fo:inline font-size="9pt"><xsl:value-of select="protocole"/>/<xsl:value-of select="annee"/></fo:inline></fo:block>
            <fo:block><fo:inline font-size="8pt">c <xsl:value-of select="carre"/></fo:inline></fo:block>
            <fo:block><fo:inline font-size="8pt">p <xsl:value-of select="parcelle"/></fo:inline></fo:block>
            <fo:block><fo:inline font-size="9pt">session <xsl:value-of select="session"/>, <xsl:value-of select="cd"/></fo:inline></fo:block>
            <fo:block><fo:inline font-size="6pt">, <xsl:value-of select="y"/></fo:inline></fo:block> 
        </fo:table-cell>
        </fo:table-row>
  </fo:table-body>
  </fo:table>
  </xsl:template>
</xsl:stylesheet>', 'db,uid,id,x,y,cd,protocole,annee,session,carre,parcelle', 1, false);
INSERT INTO label VALUES (8, 'Etiquette_etagere', '<?xml version="1.0" encoding="utf-8"?>
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
<fo:block><fo:inline font-weight="bold">CHIZE - ZA PVS</fo:inline></fo:block>
  			<fo:block>uid:<fo:inline font-weight="bold"><xsl:value-of select="db"/>:<xsl:value-of select="uid"/></fo:inline></fo:block>
  			<fo:block>ETAGERE:<fo:inline font-weight="bold"><xsl:value-of select="id"/></fo:inline></fo:block>
    		</fo:table-cell>
  	  	</fo:table-row>
  </fo:table-body>
  </fo:table>
   <fo:block page-break-after="always"/>

  </xsl:template>
</xsl:stylesheet>', 'uid,db,id', NULL, false);


--
-- TOC entry 2797 (class 0 OID 0)
-- Dependencies: 204
-- Name: label_label_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('label_label_id_seq', 11, true);


--
-- TOC entry 2581 (class 0 OID 40013)
-- Dependencies: 208
-- Data for Name: metadata; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO metadata VALUES (3, 'ROZA_extraction_run', '[{"name":"site","type":"select","choiceList":["ABBAYE SALINS","ALLOS","ANTERNE","ARMOR","ARVOIN","BASTANI","BENIT","BERGSEE","BLANC AIGUILLE ROUGE","BLANC BELLEDONNE","BLANC BELLEDONNE (PETIT)","BLED Blejsko Jezero","BOHINJ Bohinjsko Jezero","BOURGET","BREVENT","CANARD","CAPITELLO","CORNU","CREUSATES (Tourbière)","DOMENON INF","DOMENON Inf Petit","DOMENON SUP","EGORGEOU","EYCHAUDA","FARAVEL","FOREANT","FOUGERES","GD LAC ESTARIS","GERS","GIROTTE","GOLEON","GROS","GUYNEMER","INFERIORE DI LAURES","ISEO","KERLOCH","KRN","LAUVITEL","LAUZANIER","LAUZIERE","LEDVICAH","LEMAN","LES ROBERTS","LONG Mercantour","LOU","LUITEL","MADDALENA","MELO","MIAGE (Lac)","MUZELLE","NAR","NINO","NOIR AIGUILLE ROUGE Bas","ORONAYE","PALLUEL","PETAREL","PETIT","PETO","PLAN","PLAN VIANNEY","PLANINI","PONTET","PORMENAZ","PORT COUVREUX","POULE","PREDIL","RING ANSE","RIOT","ROCHEBUT","SAINT-ANDRE","SERRE HOMME","SESTO","SORME","THUILE","TIERCELIN","URBINO","VALLON","VERNEY",""],"required":true,"helperChoice":true,"helper":"Nom du lac dont le run est extrait","description":"Nom du lac dont le run est extrait","measureUnit":"Sans (49 lacs possibles)"},{"name":"type","type":"select","choiceList":["sediment","sol","liquide","roche"],"required":true,"helperChoice":true,"helper":"type des substrat depuis lequel la carotte est extraite","description":"type des substrat depuis lequel la carotte est extraite","measureUnit":"sediment, sol, liquide, roche"},{"name":"sample_name","type":"string","required":true,"helperChoice":true,"helper":"Identifiant STOCK de la carotte","description":"Identifiant STOCK de la carotte","measureUnit":"Sans"},{"name":"profondeur_top","type":"number","required":true,"helperChoice":true,"helper":"Profondeur du haut de la carotte (cm)","description":"Profondeur du haut de la carotte (cm)","measureUnit":"cm"},{"name":"profondeur_bottom","type":"number","required":true,"helperChoice":true,"helper":"Profondeur du bas de la carotte (cm)","description":"Profondeur du bas de la carotte (cm)","measureUnit":"cm"},{"name":"pi","type":"string","required":true,"helperChoice":true,"helper":"Principal Investigateur (=chercheur responsable de la carotte)","description":"Nom et prénom ou ORCID du Principal Investigateur (=chercheur responsable de la carotte)","measureUnit":"Sans"}]');
INSERT INTO metadata VALUES (1, 'Insectes_collecte_terrain', '[{"name":"protocole","type":"select","choiceList":["PT","BB","FF","PG","TO","TE"],"required":true,"helperChoice":true,"helper":"Choisir le code du protocole : PT pour PANTRAP, BB pour BARBER, FF pour FILET FAUCHOIR, PG pour PREDATION GRAINE, TO pour TOURNESOL, TE pour  TENTE à EMERGENCE","description":"Le code du protocole mis en oeuvre pour la récolte dans ce pot piège","measureUnit":"Modalités : PT pour PANTRAP, BB pour BARBER, FF pour FILET FAUCHOIR, PG pour PREDATION GRAINE, TO pour TOURNESOL, TE pour  TENTE à EMERGENCE"},{"name":"annee","type":"number","required":true,"helperChoice":true,"helper":"Année de récolte sur 4 digits","description":"Année de récolte sur 4 digits","measureUnit":"Sans"},{"name":"session","type":"select","choiceList":["1","2"],"required":true,"helperChoice":true,"helper":"Numéro de session terrain","description":"Numéro de session terrain","measureUnit":"1 ou 2"},{"name":"carre","type":"string","required":true,"helperChoice":true,"helper":"Numéro du carré farmland","description":"Numéro du carré farmland","measureUnit":"Sans"},{"name":"parcelle","type":"string","required":true,"helperChoice":true,"helper":"Identifiant de la parcelle de culture","description":"Identifiant de la parcelle de culture","measureUnit":"Sans"},{"name":"observateur","type":"string","required":true,"helperChoice":true,"helper":"Le prénom et le nom de l''opérateur terrain.","description":"Le prénom et le nom de l''opérateur terrain.","measureUnit":"Sans"},{"name":"commentaire","type":"textarea","required":false,"helperChoice":true,"helper":"Dites ce que vous voulez","description":"Dites ce que vous voulez","measureUnit":"Sans"}]');
INSERT INTO metadata VALUES (2, 'Insectes_identification_taxonomique', '[{"name":"protocole","type":"select","choiceList":["PT","BB","FF","PG","TO","TE"],"required":true,"helperChoice":true,"helper":"Choisir le code du protocole : PT pour PANTRAP, BB pour BARBER, FF pour FILET FAUCHOIR, PG pour PREDATION GRAINE, TO pour TOURNESOL, TE pour  TENTE à EMERGENCE","description":"Le code du protocole mis en oeuvre pour la récolte dans ce pot piège","measureUnit":"Modalités : PT pour PANTRAP, BB pour BARBER, FF pour FILET FAUCHOIR, PG pour PREDATION GRAINE, TO pour TOURNESOL, TE pour  TENTE à EMERGENCE"},{"name":"annee","type":"number","required":true,"helperChoice":true,"helper":"Année de récolte sur 4 digits","description":"Année de récolte sur 4 digits","measureUnit":"Sans"},{"name":"session","type":"select","choiceList":["1","2"],"required":true,"helperChoice":true,"helper":"Numéro de session terrain","description":"Numéro de session terrain","measureUnit":"1 ou 2"},{"name":"carre","type":"string","required":true,"helperChoice":true,"helper":"Numéro du carré farmland","description":"Numéro du carré farmland","measureUnit":"Sans"},{"name":"parcelle","type":"string","required":true,"helperChoice":true,"helper":"Identifiant de la parcelle de culture","description":"Identifiant de la parcelle de culture","measureUnit":"Sans"},{"name":"observateur","type":"string","required":true,"helperChoice":true,"helper":"Le prénom et le nom de l''opérateur terrain.","description":"Le prénom et le nom de l''opérateur terrain.","measureUnit":"Sans"},{"name":"commentaire","type":"textarea","required":false,"helperChoice":true,"helper":"Dites ce que vous voulez","description":"Dites ce que vous voulez","measureUnit":"Sans"},{"name":"pot","type":"string","required":true,"helperChoice":true,"helper":"Identifiant du pot piège dont est extrait l''insecte identifié","description":"Identifiant du pot piège dont est extrait l''insecte identifié","measureUnit":"Sans"}]');
INSERT INTO metadata VALUES (4, 'ROZA_ouverture_core', '[{"name":"site","type":"select","choiceList":["ABBAYE SALINS","ALLOS","ANTERNE","ARMOR","ARVOIN","BASTANI","BENIT","BERGSEE","BLANC AIGUILLE ROUGE","BLANC BELLEDONNE","BLANC BELLEDONNE (PETIT)","BLED Blejsko Jezero","BOHINJ Bohinjsko Jezero","BOURGET","BREVENT","CANARD","CAPITELLO","CORNU","CREUSATES (Tourbière)","DOMENON INF","DOMENON Inf Petit","DOMENON SUP","EGORGEOU","EYCHAUDA","FARAVEL","FOREANT","FOUGERES","GD LAC ESTARIS","GERS","GIROTTE","GOLEON","GROS","GUYNEMER","INFERIORE DI LAURES","ISEO","KERLOCH","KRN","LAUVITEL","LAUZANIER","LAUZIERE","LEDVICAH","LEMAN","LES ROBERTS","LONG Mercantour","LOU","LUITEL","MADDALENA","MELO","MIAGE (Lac)","MUZELLE","NAR","NINO","NOIR AIGUILLE ROUGE Bas","ORONAYE","PALLUEL","PETAREL","PETIT","PETO","PLAN","PLAN VIANNEY","PLANINI","PONTET","PORMENAZ","PORT COUVREUX","POULE","PREDIL","RING ANSE","RIOT","ROCHEBUT","SAINT-ANDRE","SERRE HOMME","SESTO","SORME","THUILE","TIERCELIN","URBINO","VALLON","VERNEY",""],"required":true,"helperChoice":true,"helper":"Nom du lac dont le run est extrait","description":"Nom du lac dont le run est extrait","measureUnit":"Sans (49 lacs possibles)"},{"name":"type","type":"select","choiceList":["sediment","sol","liquide","roche"],"required":true,"helperChoice":true,"helper":"type des substrat depuis lequel la carotte est extraite","description":"type des substrat depuis lequel la carotte est extraite","measureUnit":"sediment, sol, liquide, roche"},{"name":"sample_name","type":"string","required":true,"helperChoice":true,"helper":"Identifiant STOCK de la carotte","description":"Identifiant STOCK de la carotte","measureUnit":"Sans"},{"name":"profondeur_top","type":"number","required":true,"helperChoice":true,"helper":"Profondeur du haut de la carotte (cm)","description":"Profondeur du haut de la carotte (cm)","measureUnit":"cm"},{"name":"profondeur_bottom","type":"number","required":true,"helperChoice":true,"helper":"Profondeur du bas de la carotte (cm)","description":"Profondeur du bas de la carotte (cm)","measureUnit":"cm"},{"name":"pi","type":"string","required":true,"helperChoice":true,"helper":"Principal Investigateur (=chercheur responsable de la carotte)","description":"Nom et prénom ou ORCID du Principal Investigateur (=chercheur responsable de la carotte)","measureUnit":"Sans"},{"name":"moitie","type":"select","choiceList":["W","X"],"required":true,"helperChoice":true,"helper":"Moitié réservée aux archives (X) ou pour le travail (W)","description":"Moitié réservée aux archives (X) ou pour le travail (W)","measureUnit":"X ou W"},{"name":"longueur","type":"number","required":true,"helperChoice":true,"helper":"Longueur totale conservée (profondeur bottom - profondeur top) en cm","description":"Longueur totale conservée (profondeur bottom - profondeur top) en cm","measureUnit":"cm"},{"name":"commentaire","type":"textarea","required":false,"helperChoice":true,"helper":"Commentaire descriptif libre","description":"Commentaire descriptif libre","measureUnit":"Sans"}]');


--
-- TOC entry 2798 (class 0 OID 0)
-- Dependencies: 209
-- Name: metadata_metadata_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('metadata_metadata_id_seq', 4, true);


--
-- TOC entry 2583 (class 0 OID 40021)
-- Dependencies: 210
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
-- TOC entry 2799 (class 0 OID 0)
-- Dependencies: 211
-- Name: mime_type_mime_type_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('mime_type_mime_type_id_seq', 1, false);


--
-- TOC entry 2585 (class 0 OID 40029)
-- Dependencies: 212
-- Data for Name: movement_type; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO movement_type VALUES (1, 'Entrée/Entry');
INSERT INTO movement_type VALUES (2, 'Sortie/Exit');


--
-- TOC entry 2800 (class 0 OID 0)
-- Dependencies: 213
-- Name: movement_type_movement_type_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('movement_type_movement_type_id_seq', 1, false);


--
-- TOC entry 2587 (class 0 OID 40037)
-- Dependencies: 214
-- Data for Name: multiple_type; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO multiple_type VALUES (1, 'Unité');
INSERT INTO multiple_type VALUES (2, 'Pourcentage');
INSERT INTO multiple_type VALUES (3, 'Quantité ou volume');
INSERT INTO multiple_type VALUES (4, 'Autre');
INSERT INTO multiple_type VALUES (5, 'Profondeur (top - bot) cm');


--
-- TOC entry 2801 (class 0 OID 0)
-- Dependencies: 215
-- Name: multiple_type_multiple_type_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('multiple_type_multiple_type_id_seq', 5, true);


--
-- TOC entry 2589 (class 0 OID 40045)
-- Dependencies: 216
-- Data for Name: object; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO object VALUES (1, 'Ouest 28', 1, -0.425376799999999999, 46.1471269999999976);
INSERT INTO object VALUES (2, 'Etagère 1', 1, -0.425376799999999999, 46.1471269999999976);
INSERT INTO object VALUES (3, 'b1', 1, -0.476806700000000028, 46.1417827000000003);
INSERT INTO object VALUES (8, 'EDYTEM', 1, 5.85708618164061967, 45.6516803279697001);
INSERT INTO object VALUES (9, 'CONTENEUR 1', 1, 5.86899518966674982, 45.6410748096943024);
INSERT INTO object VALUES (10, 'CI - P1', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (11, 'CI - P2', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (12, 'CONTENEUR 2', 1, 5.86890935897826971, 45.6412338322581022);
INSERT INTO object VALUES (13, 'CII - P3', 1, 5.86890935000000002, 45.641233800000002);
INSERT INTO object VALUES (14, 'CII - P4', 1, 5.86890935000000002, 45.641233800000002);
INSERT INTO object VALUES (15, 'A6', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (16, 'B11', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (17, 'B4', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (18, 'I5', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (19, 'M14', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (20, 'F1', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (21, 'A6', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (22, 'B11', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (23, 'A5', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (24, 'E1', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (25, 'I10', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (26, 'A6', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (27, 'B9', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (28, 'I5', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (29, 'M14', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (30, 'B9', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (31, 'A11', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (32, 'C13', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (33, 'M15', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (34, 'A9', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (35, 'A9', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (36, 'B9', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (37, 'F13', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (38, 'B9', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (39, 'A13', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (40, 'B15', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (41, 'C10', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (42, 'B13', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (43, 'A7', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (44, 'A5', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (45, 'A10', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (46, 'C14', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (47, 'E15', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (48, 'G1', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (49, 'F13', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (50, 'E1', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (51, 'B7', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (52, 'A12', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (53, 'A12', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (54, 'A7', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (55, 'A11', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (56, 'H7', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (57, 'C13', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (58, 'B6', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (59, 'A3', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (60, 'A11', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (61, 'B9', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (62, 'C10', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (63, 'I5', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (64, 'B14', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (65, 'A12', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (66, 'D13', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (67, 'A13', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (68, 'B13', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (69, 'B6', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (70, 'C10', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (71, 'A9', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (72, 'A5', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (73, 'G6', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (74, 'B9', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (75, 'A10', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (76, 'A10', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (77, 'M14', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (78, 'A9', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (79, 'M15', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (80, 'A12', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (81, 'I 10', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (82, 'A3', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (83, 'C10', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (84, 'A10', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (85, 'B4', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (86, 'F1', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (87, 'E13', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (88, 'M14', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (89, 'E15', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (90, 'B15', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (91, 'A4', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (92, 'A13', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (93, 'E13', 1, 5.86899517999999976, 45.6410747999999984);
INSERT INTO object VALUES (97, 'LDB10-T1-60-04W', 1, 5.82969399999999993, 45.7959439999999987);
INSERT INTO object VALUES (99, 'LDB10-T1-60-04X', 1, 5.82969399999999993, 45.7959439999999987);
INSERT INTO object VALUES (94, 'LDB10-T1-60-04', 1, 5.82969399999999993, 45.7959439999999987);
INSERT INTO object VALUES (100, 'LEM10-P6-02a', 1, 6.57589999999999986, 46.4473800000000026);
INSERT INTO object VALUES (101, 'LDB10-06A', 1, 5.8549439999999997, 45.7619439999999997);
INSERT INTO object VALUES (7, 'AAB', 1, 0.0769042900000000001, 45.6207227000000017);
INSERT INTO object VALUES (4, 'b2', 1, 0.0769042900000000001, 45.6207227000000017);
INSERT INTO object VALUES (5, 'c1', 1, 0.0769042900000000001, 45.6207227000000017);
INSERT INTO object VALUES (6, 'c2', 1, 0.0769042900000000001, 45.6207227000000017);


--
-- TOC entry 2590 (class 0 OID 40051)
-- Dependencies: 217
-- Data for Name: object_identifier; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO object_identifier VALUES (1, 94, 2, 'IEFRA004W');
INSERT INTO object_identifier VALUES (2, 101, 2, 'IEFRA00NW');
INSERT INTO object_identifier VALUES (3, 100, 2, 'IEFRA00XF');
INSERT INTO object_identifier VALUES (4, 15, 1, 'CI P2');


--
-- TOC entry 2802 (class 0 OID 0)
-- Dependencies: 218
-- Name: object_identifier_object_identifier_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('object_identifier_object_identifier_id_seq', 4, true);


--
-- TOC entry 2592 (class 0 OID 40059)
-- Dependencies: 219
-- Data for Name: object_status; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO object_status VALUES (1, 'État normal');
INSERT INTO object_status VALUES (2, 'Objet pré-réservé pour usage ultérieur');
INSERT INTO object_status VALUES (3, 'Objet détruit');
INSERT INTO object_status VALUES (4, 'Echantillon vidé de tout contenu');


--
-- TOC entry 2803 (class 0 OID 0)
-- Dependencies: 220
-- Name: object_status_object_status_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('object_status_object_status_id_seq', 4, true);


--
-- TOC entry 2804 (class 0 OID 0)
-- Dependencies: 221
-- Name: object_uid_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('object_uid_seq', 101, true);


--
-- TOC entry 2595 (class 0 OID 40069)
-- Dependencies: 222
-- Data for Name: operation; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO operation VALUES (3, 1, '3-Sous-échantilonnage d''une 1/2 section', 3, 'v1', '2017-09-19 23:55:31');
INSERT INTO operation VALUES (5, 1, '1-Ouverture d''une carotte : créer une carotte "TRAVAIL" (w)', 2, 'v1', '2017-09-19 23:56:28');
INSERT INTO operation VALUES (8, 2, 'collecte_terrain', 1, 'v2.0', '2017-09-20 22:47:32');
INSERT INTO operation VALUES (9, 2, 'identification_taxonomique', 2, 'v1', '2017-09-20 22:47:56');
INSERT INTO operation VALUES (10, 1, '4 - Aliquot échantillons', 4, '1', '2017-09-25 17:07:29');
INSERT INTO operation VALUES (6, 1, '0-DECOUPE RUN en SECTION (A)', 1, 'v1', '2017-09-25 17:07:58');
INSERT INTO operation VALUES (7, 1, '0-DECOUPE RUN en SECTION (B)', 1, 'v1', '2017-09-25 17:08:11');
INSERT INTO operation VALUES (4, 1, '2-Ouverture d''une carotte : Créer une carotte "archive" (X)', 2, 'v1', '2017-09-25 17:09:15');
INSERT INTO operation VALUES (1, 1, 'Ouverture Core', 10, 'v1', '2017-09-25 17:09:30');
INSERT INTO operation VALUES (2, 1, 'extraction_run', 10, 'v1', '2017-09-25 17:09:53');


--
-- TOC entry 2805 (class 0 OID 0)
-- Dependencies: 223
-- Name: operation_operation_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('operation_operation_id_seq', 10, true);


--
-- TOC entry 2597 (class 0 OID 40077)
-- Dependencies: 224
-- Data for Name: printer; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO printer VALUES (1, 'zebraGX430T-test', 'nom imprimante connu par CUPS', 'pepper_mint', 'root', 'imprimante reliée au pi de christine à LIENS');


--
-- TOC entry 2806 (class 0 OID 0)
-- Dependencies: 225
-- Name: printer_printer_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('printer_printer_id_seq', 1, true);


--
-- TOC entry 2599 (class 0 OID 40085)
-- Dependencies: 226
-- Data for Name: project; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO project VALUES (1, 'ANR 2008 IPER-RETRO (http://www6.inra.fr/iper_retro)');
INSERT INTO project VALUES (3, 'Pots_pièges');


--
-- TOC entry 2600 (class 0 OID 40091)
-- Dependencies: 227
-- Data for Name: project_group; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO project_group VALUES (1, 1);
INSERT INTO project_group VALUES (3, 1);
INSERT INTO project_group VALUES (1, 7);
INSERT INTO project_group VALUES (3, 6);


--
-- TOC entry 2807 (class 0 OID 0)
-- Dependencies: 228
-- Name: project_project_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('project_project_id_seq', 3, true);


--
-- TOC entry 2602 (class 0 OID 40096)
-- Dependencies: 229
-- Data for Name: protocol; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO protocol VALUES (1, 'ROZA_carottes_sedimentaires ', NULL, 2017, '1.0', 1);
INSERT INTO protocol VALUES (2, 'pots_pièges', NULL, 2017, '1.0', 3);


--
-- TOC entry 2808 (class 0 OID 0)
-- Dependencies: 230
-- Name: protocol_protocol_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('protocol_protocol_id_seq', 2, true);


--
-- TOC entry 2604 (class 0 OID 40105)
-- Dependencies: 231
-- Data for Name: sample; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO sample VALUES (9, 97, 1, 2, '2017-09-24 17:13:16', '2017-09-24 17:13:16', 6, NULL, 11, NULL, '{"site":"BOURGET","type":"sediment","sample_name":"LDB10-T1-60-04","profondeur_top":"65","profondeur_bottom":"0","pi":"FROSSARD V","moitie":"W","longueur":"65"}');
INSERT INTO sample VALUES (11, 99, 1, 2, '2017-09-24 17:20:46', '2017-09-24 17:20:46', 6, NULL, 11, NULL, '{"site":"BOURGET","type":"sediment","sample_name":"LDB10-T1-60-04","profondeur_top":"0","profondeur_bottom":"65","pi":"FROSSARD V","moitie":"X","longueur":"65"}');
INSERT INTO sample VALUES (6, 94, 1, 1, '2017-09-24 17:01:09', '2012-05-30 00:00:00', NULL, NULL, 11, NULL, '{"site":"BOURGET","type":"sediment","sample_name":"LDB10-T1-60-04","profondeur_top":"0","profondeur_bottom":"65","pi":"FROSSARD V"}');
INSERT INTO sample VALUES (12, 100, 1, 1, '2017-09-24 17:27:44', '2012-05-30 00:00:00', NULL, NULL, 12, NULL, '{"site":"LEMAN","type":"sediment","sample_name":"LEM10-P6-02a","profondeur_top":"315","profondeur_bottom":"379","pi":"JENNY JP (ORCID:0000-0002-2740-174X)"}');
INSERT INTO sample VALUES (13, 101, 1, 1, '2017-09-24 17:37:40', '2012-05-30 00:00:00', NULL, NULL, 11, NULL, '{"site":"BOURGET","type":"sediment","sample_name":"LEM10-P6-02a","profondeur_top":"315","profondeur_bottom":"379","pi":"JENNY JP (ORCID:0000-0002-2740-174X)"}');
INSERT INTO sample VALUES (1, 3, 3, 4, '2017-09-24 15:04:25', '2017-09-24 15:04:25', NULL, NULL, 7, NULL, '{"protocole":"BB","annee":"2017","session":"1","carre":"123456789","parcelle":"159159159","observateur":"Thierry Fanjas","commentaire":"Le pot s''est renvers\u00e9. "}');
INSERT INTO sample VALUES (5, 7, 3, 5, '2017-09-24 15:12:38', '2017-09-24 15:12:38', 2, NULL, 4, NULL, '{"protocole":"BB","annee":"2017","session":"2","carre":"456456","parcelle":"a123145","observateur":"Edo Tedesco","commentaire":"Un moustique ?","pot":"b2"}');
INSERT INTO sample VALUES (2, 4, 3, 4, '2017-09-24 15:06:55', '2017-09-24 15:04:25', NULL, NULL, 4, NULL, '{"protocole":"BB","annee":"2017","session":"2","carre":"456456","parcelle":"a123145","observateur":"Edo Tedesco"}');
INSERT INTO sample VALUES (3, 5, 3, 4, '2017-09-24 15:10:04', '2017-09-24 15:04:25', NULL, NULL, 4, NULL, '{"protocole":"BB","annee":"2017","session":"2","carre":"456456","parcelle":"a123145","observateur":"Edo Tedesco"}');
INSERT INTO sample VALUES (4, 6, 3, 4, '2017-09-24 15:11:06', '2017-09-24 15:04:25', NULL, NULL, 4, NULL, '{"protocole":"BB","annee":"2017","session":"2","carre":"456456","parcelle":"a123145","observateur":"Edo Tedesco","commentaire":"Les insectes ont commenc\u00e9 \u00e0 se noyer."}');


--
-- TOC entry 2809 (class 0 OID 0)
-- Dependencies: 232
-- Name: sample_sample_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('sample_sample_id_seq', 13, true);


--
-- TOC entry 2606 (class 0 OID 40113)
-- Dependencies: 233
-- Data for Name: sample_type; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO sample_type VALUES (3, 'Sous-Echantillons', 6, 3, 'cm', 3, NULL);
INSERT INTO sample_type VALUES (4, 'pot_piège_terrain', 11, NULL, NULL, 8, 1);
INSERT INTO sample_type VALUES (5, 'minitube_entomo', NULL, NULL, NULL, 9, 2);
INSERT INTO sample_type VALUES (1, 'CORE', 6, 3, 'cm', 2, 3);
INSERT INTO sample_type VALUES (2, '1/2 Section de core (niv3)', 6, 3, 'cm', 2, 4);


--
-- TOC entry 2810 (class 0 OID 0)
-- Dependencies: 234
-- Name: sample_type_sample_type_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('sample_type_sample_type_id_seq', 5, true);


--
-- TOC entry 2608 (class 0 OID 40121)
-- Dependencies: 235
-- Data for Name: sampling_place; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO sampling_place VALUES (1, 'Beauvoir (BE)');
INSERT INTO sampling_place VALUES (2, 'Cherves (CH)');
INSERT INTO sampling_place VALUES (3, 'Foret Chizé (FC)');
INSERT INTO sampling_place VALUES (4, 'Fors (FO)');
INSERT INTO sampling_place VALUES (5, 'La Foye-Monjault (FM)');
INSERT INTO sampling_place VALUES (6, 'Mougon (MO)');
INSERT INTO sampling_place VALUES (7, 'Prissé (PR)');
INSERT INTO sampling_place VALUES (8, 'Ruralies (RU)');
INSERT INTO sampling_place VALUES (9, 'Sainte-Blandine (SB)');
INSERT INTO sampling_place VALUES (10, 'Nouveau secteur (NO)');
INSERT INTO sampling_place VALUES (11, 'LAC du Bourget');
INSERT INTO sampling_place VALUES (12, 'LAC du Léman');


--
-- TOC entry 2811 (class 0 OID 0)
-- Dependencies: 236
-- Name: sampling_place_sampling_place_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('sampling_place_sampling_place_id_seq', 12, true);


--
-- TOC entry 2580 (class 0 OID 39996)
-- Dependencies: 205
-- Data for Name: storage; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO storage VALUES (1, 2, 1, 1, NULL, '2017-09-24 14:56:59', NULL, 'admin', NULL, 1, 1);
INSERT INTO storage VALUES (2, 10, 4, 1, NULL, '2017-09-24 16:46:22', NULL, 'admindemo', NULL, 1, 1);
INSERT INTO storage VALUES (3, 11, 4, 1, NULL, '2017-09-24 16:47:10', NULL, 'admindemo', NULL, 1, 1);
INSERT INTO storage VALUES (4, 13, 7, 1, NULL, '2017-09-24 16:47:59', NULL, 'admindemo', NULL, 1, 1);
INSERT INTO storage VALUES (5, 14, 7, 1, NULL, '2017-09-24 16:48:27', NULL, 'admindemo', NULL, 1, 1);
INSERT INTO storage VALUES (6, 9, 3, 1, NULL, '2017-09-24 16:49:13', NULL, 'admindemo', NULL, 1, 1);
INSERT INTO storage VALUES (7, 12, 3, 1, NULL, '2017-09-24 16:49:41', NULL, 'admindemo', NULL, 1, 1);
INSERT INTO storage VALUES (8, 15, 6, 1, NULL, '2017-09-24 16:54:11', 'A6', 'admindemo', NULL, 1, 6);
INSERT INTO storage VALUES (9, 16, 6, 1, NULL, '2017-09-24 16:54:11', 'B11', 'admindemo', NULL, 2, 11);
INSERT INTO storage VALUES (10, 17, 6, 1, NULL, '2017-09-24 16:54:11', 'B4', 'admindemo', NULL, 2, 4);
INSERT INTO storage VALUES (11, 18, 6, 1, NULL, '2017-09-24 16:54:11', 'I5', 'admindemo', NULL, 9, 5);
INSERT INTO storage VALUES (12, 19, 6, 1, NULL, '2017-09-24 16:54:11', 'M14', 'admindemo', NULL, 13, 14);
INSERT INTO storage VALUES (13, 20, 6, 1, NULL, '2017-09-24 16:54:11', 'F1', 'admindemo', NULL, 6, 1);
INSERT INTO storage VALUES (14, 21, 6, 1, NULL, '2017-09-24 16:54:11', 'A6', 'admindemo', NULL, 1, 6);
INSERT INTO storage VALUES (15, 22, 6, 1, NULL, '2017-09-24 16:54:11', 'B11', 'admindemo', NULL, 2, 11);
INSERT INTO storage VALUES (16, 23, 6, 1, NULL, '2017-09-24 16:54:11', 'A5', 'admindemo', NULL, 1, 5);
INSERT INTO storage VALUES (17, 24, 6, 1, NULL, '2017-09-24 16:54:11', 'E1', 'admindemo', NULL, 5, 1);
INSERT INTO storage VALUES (18, 25, 6, 1, NULL, '2017-09-24 16:54:11', 'I10', 'admindemo', NULL, 9, 10);
INSERT INTO storage VALUES (19, 26, 6, 1, NULL, '2017-09-24 16:54:11', 'A6', 'admindemo', NULL, 1, 6);
INSERT INTO storage VALUES (20, 27, 6, 1, NULL, '2017-09-24 16:54:11', 'B9', 'admindemo', NULL, 2, 9);
INSERT INTO storage VALUES (21, 28, 6, 1, NULL, '2017-09-24 16:54:11', 'I5', 'admindemo', NULL, 9, 5);
INSERT INTO storage VALUES (22, 29, 6, 1, NULL, '2017-09-24 16:54:11', 'M14', 'admindemo', NULL, 13, 14);
INSERT INTO storage VALUES (23, 30, 6, 1, NULL, '2017-09-24 16:54:11', 'B9', 'admindemo', NULL, 2, 9);
INSERT INTO storage VALUES (24, 31, 6, 1, NULL, '2017-09-24 16:54:11', 'A11', 'admindemo', NULL, 1, 11);
INSERT INTO storage VALUES (25, 32, 6, 1, NULL, '2017-09-24 16:54:11', 'C13', 'admindemo', NULL, 3, 13);
INSERT INTO storage VALUES (26, 33, 6, 1, NULL, '2017-09-24 16:54:11', 'M15', 'admindemo', NULL, 13, 15);
INSERT INTO storage VALUES (27, 34, 6, 1, NULL, '2017-09-24 16:54:11', 'A9', 'admindemo', NULL, 1, 9);
INSERT INTO storage VALUES (28, 35, 6, 1, NULL, '2017-09-24 16:54:11', 'A9', 'admindemo', NULL, 1, 9);
INSERT INTO storage VALUES (29, 36, 6, 1, NULL, '2017-09-24 16:54:11', 'B9', 'admindemo', NULL, 2, 9);
INSERT INTO storage VALUES (30, 37, 6, 1, NULL, '2017-09-24 16:54:11', 'F13', 'admindemo', NULL, 6, 13);
INSERT INTO storage VALUES (31, 38, 6, 1, NULL, '2017-09-24 16:54:11', 'B9', 'admindemo', NULL, 2, 9);
INSERT INTO storage VALUES (32, 39, 6, 1, NULL, '2017-09-24 16:54:11', 'A13', 'admindemo', NULL, 1, 13);
INSERT INTO storage VALUES (33, 40, 6, 1, NULL, '2017-09-24 16:54:11', 'B15', 'admindemo', NULL, 2, 15);
INSERT INTO storage VALUES (34, 41, 6, 1, NULL, '2017-09-24 16:54:11', 'C10', 'admindemo', NULL, 3, 10);
INSERT INTO storage VALUES (35, 42, 6, 1, NULL, '2017-09-24 16:54:11', 'B13', 'admindemo', NULL, 2, 13);
INSERT INTO storage VALUES (36, 43, 6, 1, NULL, '2017-09-24 16:54:11', 'A7', 'admindemo', NULL, 1, 7);
INSERT INTO storage VALUES (37, 44, 6, 1, NULL, '2017-09-24 16:54:11', 'A5', 'admindemo', NULL, 1, 5);
INSERT INTO storage VALUES (38, 45, 6, 1, NULL, '2017-09-24 16:54:11', 'A10', 'admindemo', NULL, 1, 10);
INSERT INTO storage VALUES (39, 46, 6, 1, NULL, '2017-09-24 16:54:11', 'C14', 'admindemo', NULL, 3, 14);
INSERT INTO storage VALUES (40, 47, 6, 1, NULL, '2017-09-24 16:54:11', 'E15', 'admindemo', NULL, 5, 15);
INSERT INTO storage VALUES (41, 48, 6, 1, NULL, '2017-09-24 16:54:11', 'G1', 'admindemo', NULL, 7, 1);
INSERT INTO storage VALUES (42, 49, 6, 1, NULL, '2017-09-24 16:54:11', 'F13', 'admindemo', NULL, 6, 13);
INSERT INTO storage VALUES (43, 50, 6, 1, NULL, '2017-09-24 16:54:11', 'E1', 'admindemo', NULL, 5, 1);
INSERT INTO storage VALUES (44, 51, 6, 1, NULL, '2017-09-24 16:54:11', 'B7', 'admindemo', NULL, 2, 7);
INSERT INTO storage VALUES (45, 52, 6, 1, NULL, '2017-09-24 16:54:11', 'A12', 'admindemo', NULL, 1, 12);
INSERT INTO storage VALUES (46, 53, 6, 1, NULL, '2017-09-24 16:54:11', 'A12', 'admindemo', NULL, 1, 12);
INSERT INTO storage VALUES (47, 54, 6, 1, NULL, '2017-09-24 16:54:11', 'A7', 'admindemo', NULL, 1, 7);
INSERT INTO storage VALUES (48, 55, 6, 1, NULL, '2017-09-24 16:54:11', 'A11', 'admindemo', NULL, 1, 11);
INSERT INTO storage VALUES (49, 56, 6, 1, NULL, '2017-09-24 16:54:11', 'H7', 'admindemo', NULL, 8, 7);
INSERT INTO storage VALUES (50, 57, 6, 1, NULL, '2017-09-24 16:54:11', 'C13', 'admindemo', NULL, 3, 13);
INSERT INTO storage VALUES (51, 58, 6, 1, NULL, '2017-09-24 16:54:11', 'B6', 'admindemo', NULL, 2, 6);
INSERT INTO storage VALUES (52, 59, 6, 1, NULL, '2017-09-24 16:54:11', 'A3', 'admindemo', NULL, 1, 3);
INSERT INTO storage VALUES (53, 60, 6, 1, NULL, '2017-09-24 16:54:11', 'A11', 'admindemo', NULL, 1, 11);
INSERT INTO storage VALUES (54, 61, 6, 1, NULL, '2017-09-24 16:54:11', 'B9', 'admindemo', NULL, 2, 9);
INSERT INTO storage VALUES (55, 62, 6, 1, NULL, '2017-09-24 16:54:11', 'C10', 'admindemo', NULL, 3, 10);
INSERT INTO storage VALUES (56, 63, 6, 1, NULL, '2017-09-24 16:54:11', 'I5', 'admindemo', NULL, 9, 5);
INSERT INTO storage VALUES (57, 64, 6, 1, NULL, '2017-09-24 16:54:11', 'B14', 'admindemo', NULL, 2, 14);
INSERT INTO storage VALUES (58, 65, 6, 1, NULL, '2017-09-24 16:54:11', 'A12', 'admindemo', NULL, 1, 12);
INSERT INTO storage VALUES (59, 66, 6, 1, NULL, '2017-09-24 16:54:11', 'D13', 'admindemo', NULL, 4, 13);
INSERT INTO storage VALUES (60, 67, 6, 1, NULL, '2017-09-24 16:54:11', 'A13', 'admindemo', NULL, 1, 13);
INSERT INTO storage VALUES (61, 68, 6, 1, NULL, '2017-09-24 16:54:11', 'B13', 'admindemo', NULL, 2, 13);
INSERT INTO storage VALUES (62, 69, 6, 1, NULL, '2017-09-24 16:54:11', 'B6', 'admindemo', NULL, 2, 6);
INSERT INTO storage VALUES (63, 70, 6, 1, NULL, '2017-09-24 16:54:11', 'C10', 'admindemo', NULL, 3, 10);
INSERT INTO storage VALUES (64, 71, 6, 1, NULL, '2017-09-24 16:54:11', 'A9', 'admindemo', NULL, 1, 9);
INSERT INTO storage VALUES (65, 72, 6, 1, NULL, '2017-09-24 16:54:11', 'A5', 'admindemo', NULL, 1, 5);
INSERT INTO storage VALUES (66, 73, 6, 1, NULL, '2017-09-24 16:54:11', 'G6', 'admindemo', NULL, 7, 6);
INSERT INTO storage VALUES (67, 74, 6, 1, NULL, '2017-09-24 16:54:11', 'B9', 'admindemo', NULL, 2, 9);
INSERT INTO storage VALUES (68, 75, 6, 1, NULL, '2017-09-24 16:54:11', 'A10', 'admindemo', NULL, 1, 10);
INSERT INTO storage VALUES (69, 76, 6, 1, NULL, '2017-09-24 16:54:11', 'A10', 'admindemo', NULL, 1, 10);
INSERT INTO storage VALUES (70, 77, 6, 1, NULL, '2017-09-24 16:54:11', 'M14', 'admindemo', NULL, 13, 14);
INSERT INTO storage VALUES (71, 78, 6, 1, NULL, '2017-09-24 16:54:11', 'A9', 'admindemo', NULL, 1, 9);
INSERT INTO storage VALUES (72, 79, 6, 1, NULL, '2017-09-24 16:54:11', 'M15', 'admindemo', NULL, 13, 15);
INSERT INTO storage VALUES (73, 80, 6, 1, NULL, '2017-09-24 16:54:11', 'A12', 'admindemo', NULL, 1, 12);
INSERT INTO storage VALUES (74, 81, 6, 1, NULL, '2017-09-24 16:54:11', 'I 10', 'admindemo', NULL, 9, 10);
INSERT INTO storage VALUES (75, 82, 6, 1, NULL, '2017-09-24 16:54:11', 'A3', 'admindemo', NULL, 1, 3);
INSERT INTO storage VALUES (76, 83, 6, 1, NULL, '2017-09-24 16:54:11', 'C10', 'admindemo', NULL, 3, 10);
INSERT INTO storage VALUES (77, 84, 6, 1, NULL, '2017-09-24 16:54:11', 'A10', 'admindemo', NULL, 1, 10);
INSERT INTO storage VALUES (78, 85, 6, 1, NULL, '2017-09-24 16:54:11', 'B4', 'admindemo', NULL, 2, 4);
INSERT INTO storage VALUES (79, 86, 6, 1, NULL, '2017-09-24 16:54:11', 'F1', 'admindemo', NULL, 6, 1);
INSERT INTO storage VALUES (80, 87, 6, 1, NULL, '2017-09-24 16:54:11', 'E13', 'admindemo', NULL, 5, 13);
INSERT INTO storage VALUES (81, 88, 6, 1, NULL, '2017-09-24 16:54:11', 'M14', 'admindemo', NULL, 13, 14);
INSERT INTO storage VALUES (82, 89, 6, 1, NULL, '2017-09-24 16:54:11', 'E15', 'admindemo', NULL, 5, 15);
INSERT INTO storage VALUES (83, 90, 6, 1, NULL, '2017-09-24 16:54:11', 'B15', 'admindemo', NULL, 2, 15);
INSERT INTO storage VALUES (84, 91, 6, 1, NULL, '2017-09-24 16:54:11', 'A4', 'admindemo', NULL, 1, 4);
INSERT INTO storage VALUES (85, 92, 6, 1, NULL, '2017-09-24 16:54:11', 'A13', 'admindemo', NULL, 1, 13);
INSERT INTO storage VALUES (86, 93, 6, 1, NULL, '2017-09-24 16:54:11', 'E13', 'admindemo', NULL, 5, 13);
INSERT INTO storage VALUES (87, 97, 16, 1, NULL, '2017-09-25 16:33:55', NULL, 'cpignol', NULL, 1, 1);
INSERT INTO storage VALUES (88, 99, NULL, 2, 4, '2017-09-25 17:01:31', NULL, 'cpignol', NULL, 1, 1);


--
-- TOC entry 2610 (class 0 OID 40129)
-- Dependencies: 237
-- Data for Name: storage_condition; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO storage_condition VALUES (1, 'Froid 4°C');
INSERT INTO storage_condition VALUES (2, 'Sec 20°C');
INSERT INTO storage_condition VALUES (3, 'Froid -20°C');
INSERT INTO storage_condition VALUES (4, 'Froid -80°C');
INSERT INTO storage_condition VALUES (5, 'Sec 15°C (cave)');


--
-- TOC entry 2812 (class 0 OID 0)
-- Dependencies: 238
-- Name: storage_condition_storage_condition_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('storage_condition_storage_condition_id_seq', 5, true);


--
-- TOC entry 2612 (class 0 OID 40137)
-- Dependencies: 239
-- Data for Name: storage_reason; Type: TABLE DATA; Schema: col; Owner: collec
--

INSERT INTO storage_reason VALUES (2, 'ÉCHANTILLON JETE');
INSERT INTO storage_reason VALUES (1, 'ENVOI LABO EXT (STOCKAGE)');
INSERT INTO storage_reason VALUES (7, 'ENVOI LABO EXT (POUR ANALYSES)');
INSERT INTO storage_reason VALUES (4, 'PRÉLÈVEMENT DESTRUCTIF');
INSERT INTO storage_reason VALUES (8, 'PRÉLÈVEMENT SEMI-DESTRUCTIF (ex Granulo)');
INSERT INTO storage_reason VALUES (5, 'ANALYSE NON DESTRUCTIVE (PHOTO, XRF, MSCL, SPECTROCOLORIMETRIE, ...)');
INSERT INTO storage_reason VALUES (6, 'liste thesaurus analytique ?');


--
-- TOC entry 2813 (class 0 OID 0)
-- Dependencies: 240
-- Name: storage_reason_storage_reason_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('storage_reason_storage_reason_id_seq', 8, true);


--
-- TOC entry 2814 (class 0 OID 0)
-- Dependencies: 241
-- Name: storage_storage_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('storage_storage_id_seq', 88, true);


--
-- TOC entry 2615 (class 0 OID 40147)
-- Dependencies: 242
-- Data for Name: subsample; Type: TABLE DATA; Schema: col; Owner: collec
--



--
-- TOC entry 2815 (class 0 OID 0)
-- Dependencies: 243
-- Name: subsample_subsample_id_seq; Type: SEQUENCE SET; Schema: col; Owner: collec
--

SELECT pg_catalog.setval('subsample_subsample_id_seq', 1, false);


SET search_path = gacl, pg_catalog;

--
-- TOC entry 2617 (class 0 OID 40159)
-- Dependencies: 245
-- Data for Name: aclacl; Type: TABLE DATA; Schema: gacl; Owner: collec
--

INSERT INTO aclacl VALUES (1, 1);
INSERT INTO aclacl VALUES (2, 5);
INSERT INTO aclacl VALUES (3, 4);
INSERT INTO aclacl VALUES (4, 3);
INSERT INTO aclacl VALUES (5, 2);


--
-- TOC entry 2618 (class 0 OID 40162)
-- Dependencies: 246
-- Data for Name: aclaco; Type: TABLE DATA; Schema: gacl; Owner: collec
--

INSERT INTO aclaco VALUES (1, 1, 'admin');
INSERT INTO aclaco VALUES (2, 1, 'param');
INSERT INTO aclaco VALUES (3, 1, 'projet');
INSERT INTO aclaco VALUES (4, 1, 'gestion');
INSERT INTO aclaco VALUES (5, 1, 'consult');


--
-- TOC entry 2816 (class 0 OID 0)
-- Dependencies: 247
-- Name: aclaco_aclaco_id_seq; Type: SEQUENCE SET; Schema: gacl; Owner: collec
--

SELECT pg_catalog.setval('aclaco_aclaco_id_seq', 5, true);


--
-- TOC entry 2620 (class 0 OID 40170)
-- Dependencies: 248
-- Data for Name: aclappli; Type: TABLE DATA; Schema: gacl; Owner: collec
--

INSERT INTO aclappli VALUES (1, 'col', NULL);


--
-- TOC entry 2817 (class 0 OID 0)
-- Dependencies: 249
-- Name: aclappli_aclappli_id_seq; Type: SEQUENCE SET; Schema: gacl; Owner: collec
--

SELECT pg_catalog.setval('aclappli_aclappli_id_seq', 1, true);


--
-- TOC entry 2559 (class 0 OID 39902)
-- Dependencies: 183
-- Data for Name: aclgroup; Type: TABLE DATA; Schema: gacl; Owner: collec
--

INSERT INTO aclgroup VALUES (1, 'admin', NULL);
INSERT INTO aclgroup VALUES (2, 'consult', NULL);
INSERT INTO aclgroup VALUES (3, 'gestion', 2);
INSERT INTO aclgroup VALUES (6, 'param_zapvs', 5);
INSERT INTO aclgroup VALUES (7, 'param_zaalpes', 5);
INSERT INTO aclgroup VALUES (4, 'projet', 3);
INSERT INTO aclgroup VALUES (5, 'param', 4);


--
-- TOC entry 2818 (class 0 OID 0)
-- Dependencies: 250
-- Name: aclgroup_aclgroup_id_seq; Type: SEQUENCE SET; Schema: gacl; Owner: collec
--

SELECT pg_catalog.setval('aclgroup_aclgroup_id_seq', 7, true);


--
-- TOC entry 2623 (class 0 OID 40180)
-- Dependencies: 251
-- Data for Name: acllogin; Type: TABLE DATA; Schema: gacl; Owner: collec
--

INSERT INTO acllogin VALUES (1, 'admin', 'admin');
INSERT INTO acllogin VALUES (2, 'cpignol', 'Pignol Cécile');
INSERT INTO acllogin VALUES (3, 'vbretagnolle', 'Bretagnolle Vincent');


--
-- TOC entry 2819 (class 0 OID 0)
-- Dependencies: 252
-- Name: acllogin_acllogin_id_seq; Type: SEQUENCE SET; Schema: gacl; Owner: collec
--

SELECT pg_catalog.setval('acllogin_acllogin_id_seq', 3, true);


--
-- TOC entry 2625 (class 0 OID 40188)
-- Dependencies: 253
-- Data for Name: acllogingroup; Type: TABLE DATA; Schema: gacl; Owner: collec
--

INSERT INTO acllogingroup VALUES (1, 1);
INSERT INTO acllogingroup VALUES (1, 5);
INSERT INTO acllogingroup VALUES (3, 5);
INSERT INTO acllogingroup VALUES (2, 5);
INSERT INTO acllogingroup VALUES (1, 6);
INSERT INTO acllogingroup VALUES (3, 6);
INSERT INTO acllogingroup VALUES (1, 7);
INSERT INTO acllogingroup VALUES (2, 7);
INSERT INTO acllogingroup VALUES (2, 4);
INSERT INTO acllogingroup VALUES (1, 4);
INSERT INTO acllogingroup VALUES (3, 4);


--
-- TOC entry 2626 (class 0 OID 40191)
-- Dependencies: 254
-- Data for Name: log; Type: TABLE DATA; Schema: gacl; Owner: collec
--

INSERT INTO log VALUES (1, 'unknown', 'col-objets', '2017-09-15 11:52:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (2, 'unknown', 'col-objets', '2017-09-15 11:56:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (3, 'unknown', 'col-objets', '2017-09-15 11:56:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (4, 'unknown', 'col-collecindex.phpList', '2017-09-15 11:57:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (5, 'unknown', 'col-collecindex.phpList', '2017-09-15 11:57:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (6, 'unknown', 'col-collecindex.phpList', '2017-09-15 11:58:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (7, 'unknown', 'col-collecindex.phpList', '2017-09-15 12:00:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (8, 'unknown', 'col-collecindex.phpList', '2017-09-15 12:01:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (9, 'unknown', 'col-collecindex.phpList', '2017-09-15 12:02:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (10, 'unknown', 'col-apropos', '2017-09-15 12:02:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (11, 'unknown', 'col-collecindex.phpList', '2017-09-15 12:02:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (12, 'unknown', 'col-containerList', '2017-09-15 12:02:41', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (13, 'unknown', 'col-containerList', '2017-09-15 12:03:13', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (14, 'unknown', 'col-containerList', '2017-09-15 12:03:27', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (15, 'unknown', 'col-containerList', '2017-09-15 12:04:25', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (16, 'unknown', 'col-containerList', '2017-09-15 12:05:16', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (17, 'unknown', 'col-containerList', '2017-09-15 12:07:55', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (18, 'unknown', 'col-containerList', '2017-09-15 12:08:24', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (19, 'admin', 'col-connexion', '2017-09-15 12:08:39', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (20, 'admin', 'col-containerList', '2017-09-15 12:08:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (21, 'admin', 'col-containerTypeGetFromFamily', '2017-09-15 12:08:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (22, 'admin', 'col-collecindex.phpList', '2017-09-15 12:11:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (23, 'admin', 'col-collecindex.phpList', '2017-09-15 12:14:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (24, 'unknown', 'col-collecindex.phpList', '2017-09-15 12:16:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (25, 'unknown', 'col-collecindex.phpList', '2017-09-15 12:16:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (26, 'unknown', 'col-collecindex.phpList', '2017-09-15 12:22:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (27, 'unknown', 'col-connexion', '2017-09-15 12:22:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (28, 'admin', 'col-connexion', '2017-09-15 12:22:10', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (29, 'admin', 'col-default', '2017-09-15 12:22:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (30, 'admin', 'col-sampleList', '2017-09-15 12:22:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (31, 'admin', 'col-collecindex.php?moduleBase=sample&action=List&isSearch=1&name=&project_id=&uid_min=0&uid_max=0&sample_type_id=&sampling_place_id=&object_status_id=1&metadata_value=List', '2017-09-15 12:22:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (32, 'admin', 'col-containerList', '2017-09-15 12:22:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (33, 'admin', 'col-containerTypeGetFromFamily', '2017-09-15 12:22:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (34, 'admin', 'col-objets', '2017-09-15 12:22:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (35, 'admin', 'col-printerList', '2017-09-15 12:22:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (36, 'admin', 'col-protocolList', '2017-09-15 12:23:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (37, 'admin', 'col-operationList', '2017-09-15 12:23:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (38, 'admin', 'col-sampleTypeList', '2017-09-15 12:23:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (39, 'admin', 'col-metadataList', '2017-09-15 12:23:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (40, 'admin', 'col-importChange', '2017-09-15 12:23:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (41, 'unknown', 'col-collecindex.phpList', '2017-09-15 12:28:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (42, 'unknown', 'col-importChange', '2017-09-15 12:29:27', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (43, 'admin', 'col-connexion', '2017-09-15 13:40:04', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (44, 'admin', 'col-sampleImportStage1', '2017-09-15 13:40:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (45, 'admin', 'col-sampleList', '2017-09-15 13:40:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (46, 'admin', 'col-collecindex.php?moduleBase=sample&action=List&isSearch=1&name=&project_id=&uid_min=0&uid_max=0&sample_type_id=&sampling_place_id=&object_status_id=1&metadata_value=List', '2017-09-15 13:40:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (47, 'unknown', 'col-collecindex.php?moduleBase=sample&action=List&isSearch=1&name=&project_id=&uid_min=0&uid_max=0&sample_type_id=&sampling_place_id=&object_status_id=1&metadata_value=List', '2017-09-15 13:42:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (48, 'unknown', 'col-default', '2017-09-15 14:04:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (49, 'unknown', 'col-connexion', '2017-09-15 14:04:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (50, 'admin', 'col-connexion', '2017-09-15 14:04:44', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (51, 'admin', 'col-default', '2017-09-15 14:04:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (52, 'admin', 'col-connexion', '2017-09-15 14:14:53', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (53, 'admin', 'col-printerList', '2017-09-15 14:14:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (54, 'admin', 'col-printerChange', '2017-09-15 14:14:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (55, 'admin', 'col-printerWrite', '2017-09-15 14:19:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (56, 'admin', 'col-Printer-write', '2017-09-15 14:19:03', '1', '10.4.2.103');
INSERT INTO log VALUES (57, 'admin', 'col-printerList', '2017-09-15 14:19:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (58, 'admin', 'col-printerChange', '2017-09-15 14:19:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (59, 'admin', 'col-printerWrite', '2017-09-15 14:19:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (60, 'admin', 'col-Printer-write', '2017-09-15 14:19:32', '1', '10.4.2.103');
INSERT INTO log VALUES (61, 'admin', 'col-printerList', '2017-09-15 14:19:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (62, 'unknown', 'col-printerList', '2017-09-15 15:56:27', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (63, 'unknown', 'col-objets', '2017-09-18 13:28:21', 'ok', '147.99.101.36');
INSERT INTO log VALUES (64, 'unknown', 'col-containerList', '2017-09-18 13:28:39', 'nologin', '147.99.101.36');
INSERT INTO log VALUES (65, 'unknown', 'col-objets', '2017-09-18 13:28:45', 'ok', '147.99.101.36');
INSERT INTO log VALUES (66, 'unknown', 'col-connexion', '2017-09-18 13:28:54', 'ok', '147.99.101.36');
INSERT INTO log VALUES (67, 'admin', 'col-connexion', '2017-09-18 13:29:02', 'db-ok', '147.99.101.36');
INSERT INTO log VALUES (68, 'admin', 'col-default', '2017-09-18 13:29:02', 'ok', '147.99.101.36');
INSERT INTO log VALUES (69, 'admin', 'col-containerList', '2017-09-18 13:29:13', 'ok', '147.99.101.36');
INSERT INTO log VALUES (70, 'admin', 'col-containerTypeGetFromFamily', '2017-09-18 13:29:13', 'ok', '147.99.101.36');
INSERT INTO log VALUES (71, 'admin', 'col-connexion', '2017-09-18 13:29:24', 'ok', '147.99.101.36');
INSERT INTO log VALUES (72, 'admin', 'col-sampleList', '2017-09-18 13:29:27', 'ok', '147.99.101.36');
INSERT INTO log VALUES (73, 'admin', 'col-sampleList', '2017-09-18 13:29:35', 'ok', '147.99.101.36');
INSERT INTO log VALUES (74, 'admin', 'col-metadataList', '2017-09-18 13:29:47', 'ok', '147.99.101.36');
INSERT INTO log VALUES (75, 'admin', 'col-setlanguage', '2017-09-18 13:29:52', 'ok', '147.99.101.36');
INSERT INTO log VALUES (76, 'admin', 'col-default', '2017-09-18 13:29:52', 'ok', '147.99.101.36');
INSERT INTO log VALUES (77, 'unknown', 'col-default', '2017-09-19 10:35:06', 'ok', '193.48.126.37');
INSERT INTO log VALUES (78, 'unknown', 'col-connexion', '2017-09-19 10:35:10', 'ok', '193.48.126.37');
INSERT INTO log VALUES (79, 'admin', 'col-connexion', '2017-09-19 10:36:02', 'db-ko', '193.48.126.37');
INSERT INTO log VALUES (80, 'unknown', 'col-default', '2017-09-19 10:36:02', 'ok', '193.48.126.37');
INSERT INTO log VALUES (81, 'unknown', 'col-containerList', '2017-09-19 10:36:27', 'nologin', '193.48.126.37');
INSERT INTO log VALUES (82, 'admin', 'col-connexion', '2017-09-19 10:36:48', 'db-ok', '193.48.126.37');
INSERT INTO log VALUES (83, 'admin', 'col-containerList', '2017-09-19 10:36:48', 'ok', '193.48.126.37');
INSERT INTO log VALUES (84, 'admin', 'col-containerTypeGetFromFamily', '2017-09-19 10:36:49', 'ok', '193.48.126.37');
INSERT INTO log VALUES (85, 'admin', 'col-connexion', '2017-09-19 14:19:42', 'token-ok', '193.48.126.37');
INSERT INTO log VALUES (86, 'admin', 'col-containerList', '2017-09-19 14:19:42', 'ok', '193.48.126.37');
INSERT INTO log VALUES (87, 'admin', 'col-containerTypeGetFromFamily', '2017-09-19 14:19:43', 'ok', '193.48.126.37');
INSERT INTO log VALUES (88, 'unknown', 'col-default', '2017-09-19 23:37:22', 'ok', '37.172.184.153');
INSERT INTO log VALUES (89, 'cpignol', 'col-connexion', '2017-09-19 23:39:26', 'ok', '37.172.184.153');
INSERT INTO log VALUES (90, 'cpignol', 'col-containerTypeList', '2017-09-19 23:39:56', 'ok', '37.172.184.153');
INSERT INTO log VALUES (91, 'cpignol', 'col-containerTypeChange', '2017-09-19 23:40:11', 'ok', '37.172.184.153');
INSERT INTO log VALUES (92, 'cpignol', 'col-containerTypeWrite', '2017-09-19 23:40:45', 'ok', '37.172.184.153');
INSERT INTO log VALUES (93, 'cpignol', 'col-ContainerType-write', '2017-09-19 23:40:45', '6', '37.172.184.153');
INSERT INTO log VALUES (94, 'cpignol', 'col-containerTypeList', '2017-09-19 23:40:45', 'ok', '37.172.184.153');
INSERT INTO log VALUES (95, 'cpignol', 'col-labelList', '2017-09-19 23:41:17', 'ok', '37.172.184.153');
INSERT INTO log VALUES (96, 'cpignol', 'col-labelChange', '2017-09-19 23:41:20', 'ok', '37.172.184.153');
INSERT INTO log VALUES (97, 'cpignol', 'col-labelWrite', '2017-09-19 23:41:52', 'ok', '37.172.184.153');
INSERT INTO log VALUES (98, 'cpignol', 'col-Label-write', '2017-09-19 23:41:52', '2', '37.172.184.153');
INSERT INTO log VALUES (99, 'cpignol', 'col-labelList', '2017-09-19 23:41:52', 'ok', '37.172.184.153');
INSERT INTO log VALUES (100, 'cpignol', 'col-labelChange', '2017-09-19 23:42:13', 'ok', '37.172.184.153');
INSERT INTO log VALUES (101, 'cpignol', 'col-labelWrite', '2017-09-19 23:42:38', 'ok', '37.172.184.153');
INSERT INTO log VALUES (102, 'cpignol', 'col-Label-write', '2017-09-19 23:42:38', '3', '37.172.184.153');
INSERT INTO log VALUES (103, 'cpignol', 'col-labelList', '2017-09-19 23:42:38', 'ok', '37.172.184.153');
INSERT INTO log VALUES (104, 'cpignol', 'col-labelChange', '2017-09-19 23:43:00', 'ok', '37.172.184.153');
INSERT INTO log VALUES (105, 'cpignol', 'col-labelWrite', '2017-09-19 23:43:31', 'ok', '37.172.184.153');
INSERT INTO log VALUES (106, 'cpignol', 'col-Label-write', '2017-09-19 23:43:31', '4', '37.172.184.153');
INSERT INTO log VALUES (107, 'cpignol', 'col-labelList', '2017-09-19 23:43:31', 'ok', '37.172.184.153');
INSERT INTO log VALUES (108, 'cpignol', 'col-labelChange', '2017-09-19 23:43:50', 'ok', '37.172.184.153');
INSERT INTO log VALUES (109, 'cpignol', 'col-labelWrite', '2017-09-19 23:44:12', 'ok', '37.172.184.153');
INSERT INTO log VALUES (110, 'cpignol', 'col-Label-write', '2017-09-19 23:44:12', '5', '37.172.184.153');
INSERT INTO log VALUES (111, 'cpignol', 'col-labelList', '2017-09-19 23:44:12', 'ok', '37.172.184.153');
INSERT INTO log VALUES (112, 'cpignol', 'col-labelChange', '2017-09-19 23:44:25', 'ok', '37.172.184.153');
INSERT INTO log VALUES (113, 'cpignol', 'col-labelWrite', '2017-09-19 23:44:46', 'ok', '37.172.184.153');
INSERT INTO log VALUES (114, 'cpignol', 'col-Label-write', '2017-09-19 23:44:46', '6', '37.172.184.153');
INSERT INTO log VALUES (115, 'cpignol', 'col-labelList', '2017-09-19 23:44:46', 'ok', '37.172.184.153');
INSERT INTO log VALUES (116, 'cpignol', 'col-labelChange', '2017-09-19 23:45:00', 'ok', '37.172.184.153');
INSERT INTO log VALUES (117, 'cpignol', 'col-labelWrite', '2017-09-19 23:45:32', 'ok', '37.172.184.153');
INSERT INTO log VALUES (118, 'cpignol', 'col-Label-write', '2017-09-19 23:45:32', '7', '37.172.184.153');
INSERT INTO log VALUES (119, 'cpignol', 'col-labelList', '2017-09-19 23:45:32', 'ok', '37.172.184.153');
INSERT INTO log VALUES (120, 'cpignol', 'col-labelChange', '2017-09-19 23:45:37', 'ok', '37.172.184.153');
INSERT INTO log VALUES (121, 'cpignol', 'col-labelWrite', '2017-09-19 23:45:45', 'ok', '37.172.184.153');
INSERT INTO log VALUES (122, 'cpignol', 'col-Label-write', '2017-09-19 23:45:45', '6', '37.172.184.153');
INSERT INTO log VALUES (123, 'cpignol', 'col-labelList', '2017-09-19 23:45:45', 'ok', '37.172.184.153');
INSERT INTO log VALUES (124, 'cpignol', 'col-identifierTypeList', '2017-09-19 23:46:27', 'ok', '37.172.184.153');
INSERT INTO log VALUES (125, 'cpignol', 'col-identifierTypeChange', '2017-09-19 23:46:29', 'ok', '37.172.184.153');
INSERT INTO log VALUES (126, 'cpignol', 'col-identifierTypeWrite', '2017-09-19 23:46:40', 'ok', '37.172.184.153');
INSERT INTO log VALUES (127, 'cpignol', 'col-IdentifierType-write', '2017-09-19 23:46:40', '1', '37.172.184.153');
INSERT INTO log VALUES (128, 'cpignol', 'col-identifierTypeList', '2017-09-19 23:46:40', 'ok', '37.172.184.153');
INSERT INTO log VALUES (129, 'cpignol', 'col-identifierTypeChange', '2017-09-19 23:46:51', 'ok', '37.172.184.153');
INSERT INTO log VALUES (130, 'cpignol', 'col-identifierTypeWrite', '2017-09-19 23:47:01', 'ok', '37.172.184.153');
INSERT INTO log VALUES (131, 'cpignol', 'col-IdentifierType-write', '2017-09-19 23:47:01', '2', '37.172.184.153');
INSERT INTO log VALUES (132, 'cpignol', 'col-identifierTypeList', '2017-09-19 23:47:01', 'ok', '37.172.184.153');
INSERT INTO log VALUES (133, 'cpignol', 'col-containerTypeList', '2017-09-19 23:47:39', 'ok', '37.172.184.153');
INSERT INTO log VALUES (134, 'cpignol', 'col-containerTypeChange', '2017-09-19 23:47:54', 'ok', '37.172.184.153');
INSERT INTO log VALUES (135, 'cpignol', 'col-containerTypeWrite', '2017-09-19 23:48:45', 'ok', '37.172.184.153');
INSERT INTO log VALUES (136, 'cpignol', 'col-ContainerType-write', '2017-09-19 23:48:45', '7', '37.172.184.153');
INSERT INTO log VALUES (137, 'cpignol', 'col-containerTypeList', '2017-09-19 23:48:45', 'ok', '37.172.184.153');
INSERT INTO log VALUES (138, 'cpignol', 'col-storageConditionList', '2017-09-19 23:48:50', 'ok', '37.172.184.153');
INSERT INTO log VALUES (139, 'cpignol', 'col-storageConditionChange', '2017-09-19 23:49:03', 'ok', '37.172.184.153');
INSERT INTO log VALUES (140, 'cpignol', 'col-storageConditionWrite', '2017-09-19 23:49:06', 'ok', '37.172.184.153');
INSERT INTO log VALUES (141, 'cpignol', 'col-StorageCondition-write', '2017-09-19 23:49:06', '1', '37.172.184.153');
INSERT INTO log VALUES (142, 'cpignol', 'col-storageConditionList', '2017-09-19 23:49:06', 'ok', '37.172.184.153');
INSERT INTO log VALUES (143, 'cpignol', 'col-storageConditionChange', '2017-09-19 23:49:09', 'ok', '37.172.184.153');
INSERT INTO log VALUES (144, 'cpignol', 'col-storageConditionWrite', '2017-09-19 23:49:18', 'ok', '37.172.184.153');
INSERT INTO log VALUES (145, 'cpignol', 'col-StorageCondition-write', '2017-09-19 23:49:18', '2', '37.172.184.153');
INSERT INTO log VALUES (146, 'cpignol', 'col-storageConditionList', '2017-09-19 23:49:18', 'ok', '37.172.184.153');
INSERT INTO log VALUES (147, 'cpignol', 'col-containerTypeList', '2017-09-19 23:49:23', 'ok', '37.172.184.153');
INSERT INTO log VALUES (148, 'cpignol', 'col-containerTypeChange', '2017-09-19 23:49:26', 'ok', '37.172.184.153');
INSERT INTO log VALUES (149, 'cpignol', 'col-containerTypeWrite', '2017-09-19 23:49:30', 'ok', '37.172.184.153');
INSERT INTO log VALUES (150, 'cpignol', 'col-ContainerType-write', '2017-09-19 23:49:30', '7', '37.172.184.153');
INSERT INTO log VALUES (151, 'cpignol', 'col-containerTypeList', '2017-09-19 23:49:30', 'ok', '37.172.184.153');
INSERT INTO log VALUES (152, 'cpignol', 'col-containerTypeChange', '2017-09-19 23:49:52', 'ok', '37.172.184.153');
INSERT INTO log VALUES (153, 'cpignol', 'col-containerTypeWrite', '2017-09-19 23:49:57', 'ok', '37.172.184.153');
INSERT INTO log VALUES (154, 'cpignol', 'col-ContainerType-write', '2017-09-19 23:49:57', '6', '37.172.184.153');
INSERT INTO log VALUES (155, 'cpignol', 'col-containerTypeList', '2017-09-19 23:49:57', 'ok', '37.172.184.153');
INSERT INTO log VALUES (156, 'cpignol', 'col-containerTypeChange', '2017-09-19 23:49:59', 'ok', '37.172.184.153');
INSERT INTO log VALUES (157, 'cpignol', 'col-containerTypeWrite', '2017-09-19 23:50:16', 'ok', '37.172.184.153');
INSERT INTO log VALUES (158, 'cpignol', 'col-ContainerType-write', '2017-09-19 23:50:16', '6', '37.172.184.153');
INSERT INTO log VALUES (159, 'cpignol', 'col-containerTypeList', '2017-09-19 23:50:16', 'ok', '37.172.184.153');
INSERT INTO log VALUES (160, 'cpignol', 'col-sampleTypeList', '2017-09-19 23:50:32', 'ok', '37.172.184.153');
INSERT INTO log VALUES (161, 'cpignol', 'col-sampleTypeChange', '2017-09-19 23:50:51', 'ok', '37.172.184.153');
INSERT INTO log VALUES (162, 'cpignol', 'col-sampleTypeWrite', '2017-09-19 23:51:13', 'ok', '37.172.184.153');
INSERT INTO log VALUES (163, 'cpignol', 'col-SampleType-write', '2017-09-19 23:51:13', '1', '37.172.184.153');
INSERT INTO log VALUES (164, 'cpignol', 'col-sampleTypeList', '2017-09-19 23:51:13', 'ok', '37.172.184.153');
INSERT INTO log VALUES (165, 'cpignol', 'col-protocolList', '2017-09-19 23:51:38', 'ok', '37.172.184.153');
INSERT INTO log VALUES (166, 'cpignol', 'col-protocolChange', '2017-09-19 23:51:41', 'ok', '37.172.184.153');
INSERT INTO log VALUES (167, 'cpignol', 'col-protocolWrite', '2017-09-19 23:51:58', 'ok', '37.172.184.153');
INSERT INTO log VALUES (168, 'cpignol', 'col-Protocol-write', '2017-09-19 23:51:58', '1', '37.172.184.153');
INSERT INTO log VALUES (169, 'cpignol', 'col-protocolList', '2017-09-19 23:51:58', 'ok', '37.172.184.153');
INSERT INTO log VALUES (170, 'cpignol', 'col-projectList', '2017-09-19 23:52:04', 'ok', '37.172.184.153');
INSERT INTO log VALUES (171, 'cpignol', 'col-projectChange', '2017-09-19 23:52:20', 'ok', '37.172.184.153');
INSERT INTO log VALUES (172, 'cpignol', 'col-projectWrite', '2017-09-19 23:52:45', 'ok', '37.172.184.153');
INSERT INTO log VALUES (173, 'cpignol', 'col-Project-write', '2017-09-19 23:52:45', '1', '37.172.184.153');
INSERT INTO log VALUES (174, 'cpignol', 'col-projectList', '2017-09-19 23:52:45', 'ok', '37.172.184.153');
INSERT INTO log VALUES (175, 'cpignol', 'col-projectChange', '2017-09-19 23:53:02', 'ok', '37.172.184.153');
INSERT INTO log VALUES (176, 'cpignol', 'col-projectWrite', '2017-09-19 23:53:06', 'ok', '37.172.184.153');
INSERT INTO log VALUES (177, 'cpignol', 'col-Project-write', '2017-09-19 23:53:06', '2', '37.172.184.153');
INSERT INTO log VALUES (178, 'cpignol', 'col-projectList', '2017-09-19 23:53:06', 'ok', '37.172.184.153');
INSERT INTO log VALUES (179, 'cpignol', 'col-operationList', '2017-09-19 23:53:46', 'ok', '37.172.184.153');
INSERT INTO log VALUES (180, 'cpignol', 'col-operationChange', '2017-09-19 23:53:49', 'ok', '37.172.184.153');
INSERT INTO log VALUES (181, 'cpignol', 'col-operationWrite', '2017-09-19 23:54:09', 'ok', '37.172.184.153');
INSERT INTO log VALUES (182, 'cpignol', 'col-Operation-write', '2017-09-19 23:54:09', '1', '37.172.184.153');
INSERT INTO log VALUES (183, 'cpignol', 'col-operationList', '2017-09-19 23:54:09', 'ok', '37.172.184.153');
INSERT INTO log VALUES (184, 'cpignol', 'col-operationChange', '2017-09-19 23:54:35', 'ok', '37.172.184.153');
INSERT INTO log VALUES (185, 'cpignol', 'col-operationWrite', '2017-09-19 23:54:44', 'ok', '37.172.184.153');
INSERT INTO log VALUES (186, 'cpignol', 'col-Operation-write', '2017-09-19 23:54:44', '2', '37.172.184.153');
INSERT INTO log VALUES (187, 'cpignol', 'col-operationList', '2017-09-19 23:54:44', 'ok', '37.172.184.153');
INSERT INTO log VALUES (188, 'cpignol', 'col-operationChange', '2017-09-19 23:54:47', 'ok', '37.172.184.153');
INSERT INTO log VALUES (189, 'cpignol', 'col-operationWrite', '2017-09-19 23:54:53', 'ok', '37.172.184.153');
INSERT INTO log VALUES (190, 'cpignol', 'col-Operation-write', '2017-09-19 23:54:53', '1', '37.172.184.153');
INSERT INTO log VALUES (191, 'cpignol', 'col-operationList', '2017-09-19 23:54:53', 'ok', '37.172.184.153');
INSERT INTO log VALUES (192, 'cpignol', 'col-operationChange', '2017-09-19 23:55:21', 'ok', '37.172.184.153');
INSERT INTO log VALUES (193, 'cpignol', 'col-operationWrite', '2017-09-19 23:55:31', 'ok', '37.172.184.153');
INSERT INTO log VALUES (194, 'cpignol', 'col-Operation-write', '2017-09-19 23:55:31', '3', '37.172.184.153');
INSERT INTO log VALUES (195, 'cpignol', 'col-operationList', '2017-09-19 23:55:31', 'ok', '37.172.184.153');
INSERT INTO log VALUES (196, 'cpignol', 'col-operationChange', '2017-09-19 23:55:45', 'ok', '37.172.184.153');
INSERT INTO log VALUES (197, 'cpignol', 'col-operationWrite', '2017-09-19 23:55:54', 'ok', '37.172.184.153');
INSERT INTO log VALUES (198, 'cpignol', 'col-Operation-write', '2017-09-19 23:55:54', '4', '37.172.184.153');
INSERT INTO log VALUES (199, 'cpignol', 'col-operationList', '2017-09-19 23:55:54', 'ok', '37.172.184.153');
INSERT INTO log VALUES (200, 'cpignol', 'col-operationChange', '2017-09-19 23:56:18', 'ok', '37.172.184.153');
INSERT INTO log VALUES (201, 'cpignol', 'col-operationWrite', '2017-09-19 23:56:28', 'ok', '37.172.184.153');
INSERT INTO log VALUES (202, 'cpignol', 'col-Operation-write', '2017-09-19 23:56:28', '5', '37.172.184.153');
INSERT INTO log VALUES (203, 'cpignol', 'col-operationList', '2017-09-19 23:56:28', 'ok', '37.172.184.153');
INSERT INTO log VALUES (204, 'cpignol', 'col-operationChange', '2017-09-19 23:56:52', 'ok', '37.172.184.153');
INSERT INTO log VALUES (205, 'cpignol', 'col-operationWrite', '2017-09-19 23:57:00', 'ok', '37.172.184.153');
INSERT INTO log VALUES (206, 'cpignol', 'col-Operation-write', '2017-09-19 23:57:00', '6', '37.172.184.153');
INSERT INTO log VALUES (207, 'cpignol', 'col-operationList', '2017-09-19 23:57:00', 'ok', '37.172.184.153');
INSERT INTO log VALUES (208, 'cpignol', 'col-operationChange', '2017-09-19 23:57:04', 'ok', '37.172.184.153');
INSERT INTO log VALUES (209, 'cpignol', 'col-operationWrite', '2017-09-19 23:57:28', 'ok', '37.172.184.153');
INSERT INTO log VALUES (210, 'cpignol', 'col-Operation-write', '2017-09-19 23:57:28', '7', '37.172.184.153');
INSERT INTO log VALUES (211, 'cpignol', 'col-operationList', '2017-09-19 23:57:28', 'ok', '37.172.184.153');
INSERT INTO log VALUES (212, 'cpignol', 'col-sampleTypeList', '2017-09-19 23:58:02', 'ok', '37.172.184.153');
INSERT INTO log VALUES (213, 'cpignol', 'col-sampleTypeChange', '2017-09-19 23:58:06', 'ok', '37.172.184.153');
INSERT INTO log VALUES (214, 'cpignol', 'col-sampleTypeWrite', '2017-09-19 23:58:17', 'ok', '37.172.184.153');
INSERT INTO log VALUES (215, 'cpignol', 'col-SampleType-write', '2017-09-19 23:58:17', '1', '37.172.184.153');
INSERT INTO log VALUES (216, 'cpignol', 'col-sampleTypeList', '2017-09-19 23:58:17', 'ok', '37.172.184.153');
INSERT INTO log VALUES (217, 'cpignol', 'col-sampleTypeChange', '2017-09-19 23:58:33', 'ok', '37.172.184.153');
INSERT INTO log VALUES (218, 'cpignol', 'col-sampleTypeWrite', '2017-09-19 23:58:49', 'ok', '37.172.184.153');
INSERT INTO log VALUES (219, 'cpignol', 'col-SampleType-write', '2017-09-19 23:58:49', '2', '37.172.184.153');
INSERT INTO log VALUES (220, 'cpignol', 'col-sampleTypeList', '2017-09-19 23:58:49', 'ok', '37.172.184.153');
INSERT INTO log VALUES (221, 'cpignol', 'col-sampleTypeChange', '2017-09-19 23:59:16', 'ok', '37.172.184.153');
INSERT INTO log VALUES (222, 'cpignol', 'col-sampleTypeWrite', '2017-09-19 23:59:43', 'ok', '37.172.184.153');
INSERT INTO log VALUES (223, 'cpignol', 'col-SampleType-write', '2017-09-19 23:59:43', '3', '37.172.184.153');
INSERT INTO log VALUES (224, 'cpignol', 'col-sampleTypeList', '2017-09-19 23:59:43', 'ok', '37.172.184.153');
INSERT INTO log VALUES (225, 'cpignol', 'col-protocolList', '2017-09-20 00:00:25', 'ok', '37.172.184.153');
INSERT INTO log VALUES (226, 'cpignol', 'col-protocolChange', '2017-09-20 00:00:27', 'ok', '37.172.184.153');
INSERT INTO log VALUES (227, 'cpignol', 'col-protocolWrite', '2017-09-20 00:00:34', 'ok', '37.172.184.153');
INSERT INTO log VALUES (228, 'cpignol', 'col-Protocol-write', '2017-09-20 00:00:34', '1', '37.172.184.153');
INSERT INTO log VALUES (229, 'cpignol', 'col-protocolList', '2017-09-20 00:00:34', 'ok', '37.172.184.153');
INSERT INTO log VALUES (230, 'cpignol', 'col-sampleTypeList', '2017-09-20 00:00:41', 'ok', '37.172.184.153');
INSERT INTO log VALUES (231, 'cpignol', 'col-sampleTypeChange', '2017-09-20 00:01:01', 'ok', '37.172.184.153');
INSERT INTO log VALUES (232, 'cpignol', 'col-sampleTypeWrite', '2017-09-20 00:01:09', 'ok', '37.172.184.153');
INSERT INTO log VALUES (233, 'cpignol', 'col-SampleType-write', '2017-09-20 00:01:09', '2', '37.172.184.153');
INSERT INTO log VALUES (234, 'cpignol', 'col-sampleTypeList', '2017-09-20 00:01:09', 'ok', '37.172.184.153');
INSERT INTO log VALUES (235, 'unknown', 'col-default', '2017-09-20 22:43:07', 'ok', '37.168.189.69');
INSERT INTO log VALUES (236, 'unknown', 'col-connexion', '2017-09-20 22:43:10', 'ok', '37.168.189.69');
INSERT INTO log VALUES (237, 'admin', 'col-connexion', '2017-09-20 22:43:18', 'db-ok', '37.168.189.69');
INSERT INTO log VALUES (238, 'admin', 'col-default', '2017-09-20 22:43:18', 'ok', '37.168.189.69');
INSERT INTO log VALUES (239, 'admin', 'col-projectList', '2017-09-20 22:45:29', 'ok', '37.168.189.69');
INSERT INTO log VALUES (240, 'admin', 'col-projectChange', '2017-09-20 22:45:33', 'ok', '37.168.189.69');
INSERT INTO log VALUES (241, 'admin', 'col-projectWrite', '2017-09-20 22:45:52', 'ok', '37.168.189.69');
INSERT INTO log VALUES (242, 'admin', 'col-Project-write', '2017-09-20 22:45:52', '3', '37.168.189.69');
INSERT INTO log VALUES (243, 'admin', 'col-projectList', '2017-09-20 22:45:52', 'ok', '37.168.189.69');
INSERT INTO log VALUES (244, 'admin', 'col-protocolList', '2017-09-20 22:46:16', 'ok', '37.168.189.69');
INSERT INTO log VALUES (245, 'admin', 'col-protocolChange', '2017-09-20 22:46:20', 'ok', '37.168.189.69');
INSERT INTO log VALUES (246, 'admin', 'col-protocolWrite', '2017-09-20 22:46:38', 'ok', '37.168.189.69');
INSERT INTO log VALUES (247, 'admin', 'col-Protocol-write', '2017-09-20 22:46:38', '2', '37.168.189.69');
INSERT INTO log VALUES (248, 'admin', 'col-protocolList', '2017-09-20 22:46:38', 'ok', '37.168.189.69');
INSERT INTO log VALUES (249, 'admin', 'col-operationList', '2017-09-20 22:47:15', 'ok', '37.168.189.69');
INSERT INTO log VALUES (250, 'admin', 'col-operationChange', '2017-09-20 22:47:19', 'ok', '37.168.189.69');
INSERT INTO log VALUES (251, 'admin', 'col-operationWrite', '2017-09-20 22:47:32', 'ok', '37.168.189.69');
INSERT INTO log VALUES (252, 'admin', 'col-Operation-write', '2017-09-20 22:47:32', '8', '37.168.189.69');
INSERT INTO log VALUES (253, 'admin', 'col-operationList', '2017-09-20 22:47:32', 'ok', '37.168.189.69');
INSERT INTO log VALUES (254, 'admin', 'col-operationChange', '2017-09-20 22:47:44', 'ok', '37.168.189.69');
INSERT INTO log VALUES (255, 'admin', 'col-operationWrite', '2017-09-20 22:47:56', 'ok', '37.168.189.69');
INSERT INTO log VALUES (256, 'admin', 'col-Operation-write', '2017-09-20 22:47:56', '9', '37.168.189.69');
INSERT INTO log VALUES (257, 'admin', 'col-operationList', '2017-09-20 22:47:56', 'ok', '37.168.189.69');
INSERT INTO log VALUES (258, 'admin', 'col-labelList', '2017-09-20 22:48:24', 'ok', '37.168.189.69');
INSERT INTO log VALUES (259, 'admin', 'col-labelChange', '2017-09-20 22:48:30', 'ok', '37.168.189.69');
INSERT INTO log VALUES (260, 'admin', 'col-labelWrite', '2017-09-20 22:48:59', 'ok', '37.168.189.69');
INSERT INTO log VALUES (261, 'admin', 'col-Label-write', '2017-09-20 22:48:59', '8', '37.168.189.69');
INSERT INTO log VALUES (262, 'admin', 'col-labelList', '2017-09-20 22:48:59', 'ok', '37.168.189.69');
INSERT INTO log VALUES (263, 'admin', 'col-labelChange', '2017-09-20 22:49:20', 'ok', '37.168.189.69');
INSERT INTO log VALUES (264, 'admin', 'col-labelWrite', '2017-09-20 22:49:44', 'ok', '37.168.189.69');
INSERT INTO log VALUES (265, 'admin', 'col-Label-write', '2017-09-20 22:49:44', '9', '37.168.189.69');
INSERT INTO log VALUES (266, 'admin', 'col-labelList', '2017-09-20 22:49:44', 'ok', '37.168.189.69');
INSERT INTO log VALUES (267, 'admin', 'col-labelChange', '2017-09-20 22:50:03', 'ok', '37.168.189.69');
INSERT INTO log VALUES (268, 'admin', 'col-labelWrite', '2017-09-20 22:50:27', 'ok', '37.168.189.69');
INSERT INTO log VALUES (269, 'admin', 'col-Label-write', '2017-09-20 22:50:27', '10', '37.168.189.69');
INSERT INTO log VALUES (270, 'admin', 'col-labelList', '2017-09-20 22:50:27', 'ok', '37.168.189.69');
INSERT INTO log VALUES (271, 'admin', 'col-labelChange', '2017-09-20 22:50:48', 'ok', '37.168.189.69');
INSERT INTO log VALUES (272, 'admin', 'col-labelWrite', '2017-09-20 22:51:06', 'ok', '37.168.189.69');
INSERT INTO log VALUES (273, 'admin', 'col-Label-write', '2017-09-20 22:51:06', '11', '37.168.189.69');
INSERT INTO log VALUES (274, 'admin', 'col-labelList', '2017-09-20 22:51:06', 'ok', '37.168.189.69');
INSERT INTO log VALUES (275, 'admin', 'col-containerTypeList', '2017-09-20 22:51:52', 'ok', '37.168.189.69');
INSERT INTO log VALUES (276, 'admin', 'col-containerTypeChange', '2017-09-20 22:52:17', 'ok', '37.168.189.69');
INSERT INTO log VALUES (277, 'admin', 'col-containerTypeWrite', '2017-09-20 22:52:46', 'ok', '37.168.189.69');
INSERT INTO log VALUES (278, 'admin', 'col-ContainerType-write', '2017-09-20 22:52:46', '8', '37.168.189.69');
INSERT INTO log VALUES (279, 'admin', 'col-containerTypeList', '2017-09-20 22:52:46', 'ok', '37.168.189.69');
INSERT INTO log VALUES (280, 'admin', 'col-containerTypeChange', '2017-09-20 22:53:29', 'ok', '37.168.189.69');
INSERT INTO log VALUES (281, 'admin', 'col-containerTypeWrite', '2017-09-20 22:53:44', 'ok', '37.168.189.69');
INSERT INTO log VALUES (282, 'admin', 'col-ContainerType-write', '2017-09-20 22:53:44', '9', '37.168.189.69');
INSERT INTO log VALUES (283, 'admin', 'col-containerTypeList', '2017-09-20 22:53:44', 'ok', '37.168.189.69');
INSERT INTO log VALUES (284, 'admin', 'col-containerTypeChange', '2017-09-20 22:53:59', 'ok', '37.168.189.69');
INSERT INTO log VALUES (285, 'admin', 'col-containerTypeWrite', '2017-09-20 22:54:14', 'ok', '37.168.189.69');
INSERT INTO log VALUES (286, 'admin', 'col-ContainerType-write', '2017-09-20 22:54:14', '10', '37.168.189.69');
INSERT INTO log VALUES (287, 'admin', 'col-containerTypeList', '2017-09-20 22:54:14', 'ok', '37.168.189.69');
INSERT INTO log VALUES (288, 'admin', 'col-containerTypeChange', '2017-09-20 22:54:32', 'ok', '37.168.189.69');
INSERT INTO log VALUES (289, 'admin', 'col-containerTypeWrite', '2017-09-20 22:54:40', 'ok', '37.168.189.69');
INSERT INTO log VALUES (290, 'admin', 'col-ContainerType-write', '2017-09-20 22:54:40', '11', '37.168.189.69');
INSERT INTO log VALUES (291, 'admin', 'col-containerTypeList', '2017-09-20 22:54:40', 'ok', '37.168.189.69');
INSERT INTO log VALUES (292, 'admin', 'col-sampleTypeList', '2017-09-20 22:55:58', 'ok', '37.168.189.69');
INSERT INTO log VALUES (293, 'admin', 'col-sampleTypeChange', '2017-09-20 22:56:04', 'ok', '37.168.189.69');
INSERT INTO log VALUES (294, 'admin', 'col-sampleTypeWrite', '2017-09-20 22:56:47', 'ok', '37.168.189.69');
INSERT INTO log VALUES (295, 'admin', 'col-SampleType-write', '2017-09-20 22:56:47', '4', '37.168.189.69');
INSERT INTO log VALUES (296, 'admin', 'col-sampleTypeList', '2017-09-20 22:56:47', 'ok', '37.168.189.69');
INSERT INTO log VALUES (297, 'admin', 'col-sampleTypeChange', '2017-09-20 22:56:54', 'ok', '37.168.189.69');
INSERT INTO log VALUES (298, 'admin', 'col-sampleTypeWrite', '2017-09-20 22:57:30', 'ok', '37.168.189.69');
INSERT INTO log VALUES (299, 'admin', 'col-SampleType-write', '2017-09-20 22:57:30', '5', '37.168.189.69');
INSERT INTO log VALUES (300, 'admin', 'col-sampleTypeList', '2017-09-20 22:57:30', 'ok', '37.168.189.69');
INSERT INTO log VALUES (301, 'unknown', 'col-containerList', '2017-09-21 14:59:42', 'nologin', '193.48.126.37');
INSERT INTO log VALUES (302, 'admin', 'col-connexion', '2017-09-21 15:00:16', 'db-ok', '193.48.126.37');
INSERT INTO log VALUES (303, 'admin', 'col-containerList', '2017-09-21 15:00:16', 'ok', '193.48.126.37');
INSERT INTO log VALUES (304, 'admin', 'col-containerTypeGetFromFamily', '2017-09-21 15:00:16', 'ok', '193.48.126.37');
INSERT INTO log VALUES (305, 'admin', 'col-containerTypeList', '2017-09-21 15:00:26', 'ok', '193.48.126.37');
INSERT INTO log VALUES (306, 'admin', 'col-objets', '2017-09-21 15:00:57', 'ok', '193.48.126.37');
INSERT INTO log VALUES (307, 'admin', 'col-containerList', '2017-09-21 15:00:59', 'ok', '193.48.126.37');
INSERT INTO log VALUES (308, 'admin', 'col-containerTypeGetFromFamily', '2017-09-21 15:01:00', 'ok', '193.48.126.37');
INSERT INTO log VALUES (309, 'admin', 'col-sampleList', '2017-09-21 15:01:19', 'ok', '193.48.126.37');
INSERT INTO log VALUES (310, 'admin', 'col-sampleList', '2017-09-21 15:01:25', 'ok', '193.48.126.37');
INSERT INTO log VALUES (311, 'unknown', 'col-default', '2017-09-24 13:44:06', 'ok', '86.254.27.65');
INSERT INTO log VALUES (312, 'unknown', 'col-connexion', '2017-09-24 13:44:09', 'ok', '86.254.27.65');
INSERT INTO log VALUES (313, 'admin', 'col-connexion', '2017-09-24 13:44:17', 'db-ok', '86.254.27.65');
INSERT INTO log VALUES (314, 'admin', 'col-default', '2017-09-24 13:44:18', 'ok', '86.254.27.65');
INSERT INTO log VALUES (315, 'admin', 'col-containerList', '2017-09-24 13:44:20', 'ok', '86.254.27.65');
INSERT INTO log VALUES (316, 'admin', 'col-containerTypeGetFromFamily', '2017-09-24 13:44:21', 'ok', '86.254.27.65');
INSERT INTO log VALUES (317, 'admin', 'col-objets', '2017-09-24 13:44:30', 'ok', '86.254.27.65');
INSERT INTO log VALUES (318, 'admin', 'col-sampleList', '2017-09-24 13:44:32', 'ok', '86.254.27.65');
INSERT INTO log VALUES (319, 'admin', 'col-sampleList', '2017-09-24 13:44:34', 'ok', '86.254.27.65');
INSERT INTO log VALUES (320, 'admin', 'col-projectList', '2017-09-24 13:44:52', 'ok', '86.254.27.65');
INSERT INTO log VALUES (321, 'admin', 'col-projectChange', '2017-09-24 13:45:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (322, 'admin', 'col-projectList', '2017-09-24 13:45:20', 'ok', '86.254.27.65');
INSERT INTO log VALUES (323, 'admin', 'col-projectChange', '2017-09-24 13:45:21', 'ok', '86.254.27.65');
INSERT INTO log VALUES (324, 'admin', 'col-operationList', '2017-09-24 13:45:34', 'ok', '86.254.27.65');
INSERT INTO log VALUES (325, 'admin', 'col-operationChange', '2017-09-24 13:46:20', 'ok', '86.254.27.65');
INSERT INTO log VALUES (326, 'admin', 'col-operationList', '2017-09-24 13:46:26', 'ok', '86.254.27.65');
INSERT INTO log VALUES (327, 'admin', 'col-operationChange', '2017-09-24 13:46:33', 'ok', '86.254.27.65');
INSERT INTO log VALUES (328, 'admin', 'col-operationList', '2017-09-24 13:46:39', 'ok', '86.254.27.65');
INSERT INTO log VALUES (329, 'admin', 'col-operationChange', '2017-09-24 13:46:41', 'ok', '86.254.27.65');
INSERT INTO log VALUES (330, 'admin', 'col-operationList', '2017-09-24 13:46:45', 'ok', '86.254.27.65');
INSERT INTO log VALUES (331, 'admin', 'col-operationChange', '2017-09-24 13:46:50', 'ok', '86.254.27.65');
INSERT INTO log VALUES (332, 'admin', 'col-operationList', '2017-09-24 13:46:55', 'ok', '86.254.27.65');
INSERT INTO log VALUES (333, 'admin', 'col-operationChange', '2017-09-24 13:47:05', 'ok', '86.254.27.65');
INSERT INTO log VALUES (334, 'admin', 'col-operationList', '2017-09-24 13:47:09', 'ok', '86.254.27.65');
INSERT INTO log VALUES (335, 'admin', 'col-operationChange', '2017-09-24 13:47:14', 'ok', '86.254.27.65');
INSERT INTO log VALUES (336, 'admin', 'col-operationList', '2017-09-24 13:47:18', 'ok', '86.254.27.65');
INSERT INTO log VALUES (337, 'admin', 'col-operationChange', '2017-09-24 13:47:22', 'ok', '86.254.27.65');
INSERT INTO log VALUES (338, 'admin', 'col-operationList', '2017-09-24 13:47:27', 'ok', '86.254.27.65');
INSERT INTO log VALUES (339, 'admin', 'col-operationChange', '2017-09-24 13:47:34', 'ok', '86.254.27.65');
INSERT INTO log VALUES (340, 'admin', 'col-eventTypeList', '2017-09-24 13:47:40', 'ok', '86.254.27.65');
INSERT INTO log VALUES (341, 'admin', 'col-containerFamilyList', '2017-09-24 13:47:49', 'ok', '86.254.27.65');
INSERT INTO log VALUES (342, 'admin', 'col-storageConditionList', '2017-09-24 13:48:05', 'ok', '86.254.27.65');
INSERT INTO log VALUES (343, 'admin', 'col-storageReasonList', '2017-09-24 13:48:18', 'ok', '86.254.27.65');
INSERT INTO log VALUES (344, 'admin', 'col-containerTypeList', '2017-09-24 13:48:22', 'ok', '86.254.27.65');
INSERT INTO log VALUES (345, 'admin', 'col-objectStatusList', '2017-09-24 13:49:28', 'ok', '86.254.27.65');
INSERT INTO log VALUES (346, 'admin', 'col-sampleTypeList', '2017-09-24 13:49:42', 'ok', '86.254.27.65');
INSERT INTO log VALUES (347, 'admin', 'col-sampleTypeChange', '2017-09-24 13:50:25', 'ok', '86.254.27.65');
INSERT INTO log VALUES (348, 'admin', 'col-sampleTypeList', '2017-09-24 13:50:52', 'ok', '86.254.27.65');
INSERT INTO log VALUES (349, 'admin', 'col-sampleTypeChange', '2017-09-24 13:50:56', 'ok', '86.254.27.65');
INSERT INTO log VALUES (350, 'admin', 'col-containerTypeList', '2017-09-24 13:51:01', 'ok', '86.254.27.65');
INSERT INTO log VALUES (351, 'admin', 'col-sampleTypeList', '2017-09-24 13:51:06', 'ok', '86.254.27.65');
INSERT INTO log VALUES (352, 'admin', 'col-sampleTypeChange', '2017-09-24 13:51:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (353, 'admin', 'col-operationList', '2017-09-24 13:51:29', 'ok', '86.254.27.65');
INSERT INTO log VALUES (354, 'admin', 'col-sampleTypeList', '2017-09-24 13:53:22', 'ok', '86.254.27.65');
INSERT INTO log VALUES (355, 'admin', 'col-sampleTypeChange', '2017-09-24 13:53:30', 'ok', '86.254.27.65');
INSERT INTO log VALUES (356, 'admin', 'col-sampleTypeList', '2017-09-24 13:53:44', 'ok', '86.254.27.65');
INSERT INTO log VALUES (357, 'admin', 'col-sampleTypeChange', '2017-09-24 13:53:49', 'ok', '86.254.27.65');
INSERT INTO log VALUES (358, 'admin', 'col-sampleTypeList', '2017-09-24 13:53:55', 'ok', '86.254.27.65');
INSERT INTO log VALUES (359, 'admin', 'col-multipleTypeList', '2017-09-24 13:54:01', 'ok', '86.254.27.65');
INSERT INTO log VALUES (360, 'admin', 'col-samplingPlaceList', '2017-09-24 13:54:05', 'ok', '86.254.27.65');
INSERT INTO log VALUES (361, 'admin', 'col-parametre', '2017-09-24 13:54:10', 'ok', '86.254.27.65');
INSERT INTO log VALUES (362, 'admin', 'col-metadataList', '2017-09-24 14:20:40', 'ok', '86.254.27.65');
INSERT INTO log VALUES (363, 'admin', 'col-metadataChange', '2017-09-24 14:20:52', 'ok', '86.254.27.65');
INSERT INTO log VALUES (364, 'admin', 'col-metadataWrite', '2017-09-24 14:26:31', 'ok', '86.254.27.65');
INSERT INTO log VALUES (365, 'admin', 'col-Metadata-write', '2017-09-24 14:26:31', '1', '86.254.27.65');
INSERT INTO log VALUES (366, 'admin', 'col-metadataList', '2017-09-24 14:26:31', 'ok', '86.254.27.65');
INSERT INTO log VALUES (367, 'admin', 'col-metadataChange', '2017-09-24 14:26:36', 'ok', '86.254.27.65');
INSERT INTO log VALUES (368, 'admin', 'col-metadataWrite', '2017-09-24 14:31:15', 'ok', '86.254.27.65');
INSERT INTO log VALUES (369, 'admin', 'col-Metadata-write', '2017-09-24 14:31:15', '1', '86.254.27.65');
INSERT INTO log VALUES (370, 'admin', 'col-metadataList', '2017-09-24 14:31:15', 'ok', '86.254.27.65');
INSERT INTO log VALUES (371, 'admin', 'col-metadataChange', '2017-09-24 14:32:21', 'ok', '86.254.27.65');
INSERT INTO log VALUES (372, 'admin', 'col-metadataWrite', '2017-09-24 14:34:29', 'ok', '86.254.27.65');
INSERT INTO log VALUES (373, 'admin', 'col-Metadata-write', '2017-09-24 14:34:29', '1', '86.254.27.65');
INSERT INTO log VALUES (374, 'admin', 'col-metadataList', '2017-09-24 14:34:29', 'ok', '86.254.27.65');
INSERT INTO log VALUES (375, 'admin', 'col-metadataCopy', '2017-09-24 14:36:07', 'ok', '86.254.27.65');
INSERT INTO log VALUES (376, 'admin', 'col-metadataWrite', '2017-09-24 14:37:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (377, 'admin', 'col-Metadata-write', '2017-09-24 14:37:11', '2', '86.254.27.65');
INSERT INTO log VALUES (378, 'admin', 'col-metadataList', '2017-09-24 14:37:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (379, 'admin', 'col-labelList', '2017-09-24 14:41:57', 'ok', '86.254.27.65');
INSERT INTO log VALUES (380, 'admin', 'col-labelChange', '2017-09-24 14:42:30', 'ok', '86.254.27.65');
INSERT INTO log VALUES (381, 'admin', 'col-metadataGetschema', '2017-09-24 14:44:03', 'ok', '86.254.27.65');
INSERT INTO log VALUES (382, 'admin', 'col-labelWrite', '2017-09-24 14:44:58', 'ok', '86.254.27.65');
INSERT INTO log VALUES (383, 'admin', 'col-Label-write', '2017-09-24 14:44:58', '9', '86.254.27.65');
INSERT INTO log VALUES (384, 'admin', 'col-labelList', '2017-09-24 14:44:58', 'ok', '86.254.27.65');
INSERT INTO log VALUES (385, 'admin', 'col-labelChange', '2017-09-24 14:45:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (386, 'admin', 'col-metadataGetschema', '2017-09-24 14:45:20', 'ok', '86.254.27.65');
INSERT INTO log VALUES (387, 'admin', 'col-labelList', '2017-09-24 14:45:36', 'ok', '86.254.27.65');
INSERT INTO log VALUES (388, 'admin', 'col-labelChange', '2017-09-24 14:45:43', 'ok', '86.254.27.65');
INSERT INTO log VALUES (389, 'admin', 'col-metadataGetschema', '2017-09-24 14:47:32', 'ok', '86.254.27.65');
INSERT INTO log VALUES (390, 'admin', 'col-labelWrite', '2017-09-24 14:47:34', 'errorbefore', '86.254.27.65');
INSERT INTO log VALUES (391, 'admin', 'col-errorbefore', '2017-09-24 14:47:34', 'ok', '86.254.27.65');
INSERT INTO log VALUES (392, 'admin', 'col-labelList', '2017-09-24 14:47:39', 'ok', '86.254.27.65');
INSERT INTO log VALUES (393, 'admin', 'col-labelChange', '2017-09-24 14:47:50', 'ok', '86.254.27.65');
INSERT INTO log VALUES (394, 'admin', 'col-metadataGetschema', '2017-09-24 14:48:02', 'ok', '86.254.27.65');
INSERT INTO log VALUES (395, 'admin', 'col-labelWrite', '2017-09-24 14:48:05', 'ok', '86.254.27.65');
INSERT INTO log VALUES (396, 'admin', 'col-Label-write', '2017-09-24 14:48:05', '10', '86.254.27.65');
INSERT INTO log VALUES (397, 'admin', 'col-labelList', '2017-09-24 14:48:05', 'ok', '86.254.27.65');
INSERT INTO log VALUES (398, 'admin', 'col-labelChange', '2017-09-24 14:48:09', 'ok', '86.254.27.65');
INSERT INTO log VALUES (399, 'admin', 'col-metadataGetschema', '2017-09-24 14:48:09', 'ok', '86.254.27.65');
INSERT INTO log VALUES (400, 'admin', 'col-labelWrite', '2017-09-24 14:49:00', 'ok', '86.254.27.65');
INSERT INTO log VALUES (401, 'admin', 'col-Label-write', '2017-09-24 14:49:00', '10', '86.254.27.65');
INSERT INTO log VALUES (402, 'admin', 'col-labelList', '2017-09-24 14:49:00', 'ok', '86.254.27.65');
INSERT INTO log VALUES (403, 'admin', 'col-labelChange', '2017-09-24 14:50:22', 'ok', '86.254.27.65');
INSERT INTO log VALUES (404, 'admin', 'col-labelWrite', '2017-09-24 14:50:43', 'ok', '86.254.27.65');
INSERT INTO log VALUES (405, 'admin', 'col-Label-write', '2017-09-24 14:50:43', '8', '86.254.27.65');
INSERT INTO log VALUES (406, 'admin', 'col-labelList', '2017-09-24 14:50:43', 'ok', '86.254.27.65');
INSERT INTO log VALUES (407, 'admin', 'col-containerTypeList', '2017-09-24 14:51:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (408, 'admin', 'col-containerList', '2017-09-24 14:54:10', 'ok', '86.254.27.65');
INSERT INTO log VALUES (409, 'admin', 'col-containerTypeGetFromFamily', '2017-09-24 14:54:10', 'ok', '86.254.27.65');
INSERT INTO log VALUES (410, 'admin', 'col-containerChange', '2017-09-24 14:54:16', 'ok', '86.254.27.65');
INSERT INTO log VALUES (411, 'admin', 'col-containerTypeGetFromFamily', '2017-09-24 14:54:17', 'ok', '86.254.27.65');
INSERT INTO log VALUES (412, 'admin', 'col-containerTypeGetFromFamily', '2017-09-24 14:54:49', 'ok', '86.254.27.65');
INSERT INTO log VALUES (413, 'admin', 'col-containerWrite', '2017-09-24 14:55:55', 'ok', '86.254.27.65');
INSERT INTO log VALUES (414, 'admin', 'col-Container-write', '2017-09-24 14:55:55', '1', '86.254.27.65');
INSERT INTO log VALUES (415, 'admin', 'col-containerDisplay', '2017-09-24 14:55:55', 'ok', '86.254.27.65');
INSERT INTO log VALUES (416, 'admin', 'col-containerChange', '2017-09-24 14:56:08', 'ok', '86.254.27.65');
INSERT INTO log VALUES (417, 'admin', 'col-containerTypeGetFromFamily', '2017-09-24 14:56:09', 'ok', '86.254.27.65');
INSERT INTO log VALUES (418, 'admin', 'col-containerTypeGetFromFamily', '2017-09-24 14:56:44', 'ok', '86.254.27.65');
INSERT INTO log VALUES (419, 'admin', 'col-containerWrite', '2017-09-24 14:56:59', 'ok', '86.254.27.65');
INSERT INTO log VALUES (420, 'admin', 'col-Container-write', '2017-09-24 14:56:59', '2', '86.254.27.65');
INSERT INTO log VALUES (421, 'admin', 'col-containerDisplay', '2017-09-24 14:56:59', 'ok', '86.254.27.65');
INSERT INTO log VALUES (422, 'admin', 'col-samplingPlaceList', '2017-09-24 14:58:26', 'ok', '86.254.27.65');
INSERT INTO log VALUES (423, 'admin', 'col-samplingPlaceChange', '2017-09-24 14:59:20', 'ok', '86.254.27.65');
INSERT INTO log VALUES (424, 'admin', 'col-samplingPlaceWrite', '2017-09-24 14:59:30', 'ok', '86.254.27.65');
INSERT INTO log VALUES (425, 'admin', 'col-SamplingPlace-write', '2017-09-24 14:59:30', '1', '86.254.27.65');
INSERT INTO log VALUES (426, 'admin', 'col-samplingPlaceList', '2017-09-24 14:59:30', 'ok', '86.254.27.65');
INSERT INTO log VALUES (427, 'admin', 'col-samplingPlaceChange', '2017-09-24 14:59:49', 'ok', '86.254.27.65');
INSERT INTO log VALUES (428, 'admin', 'col-samplingPlaceWrite', '2017-09-24 14:59:51', 'ok', '86.254.27.65');
INSERT INTO log VALUES (429, 'admin', 'col-SamplingPlace-write', '2017-09-24 14:59:51', '2', '86.254.27.65');
INSERT INTO log VALUES (430, 'admin', 'col-samplingPlaceList', '2017-09-24 14:59:51', 'ok', '86.254.27.65');
INSERT INTO log VALUES (431, 'admin', 'col-samplingPlaceChange', '2017-09-24 14:59:59', 'ok', '86.254.27.65');
INSERT INTO log VALUES (432, 'admin', 'col-samplingPlaceWrite', '2017-09-24 15:00:01', 'ok', '86.254.27.65');
INSERT INTO log VALUES (433, 'admin', 'col-SamplingPlace-write', '2017-09-24 15:00:01', '3', '86.254.27.65');
INSERT INTO log VALUES (434, 'admin', 'col-samplingPlaceList', '2017-09-24 15:00:01', 'ok', '86.254.27.65');
INSERT INTO log VALUES (435, 'admin', 'col-samplingPlaceChange', '2017-09-24 15:00:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (436, 'admin', 'col-samplingPlaceWrite', '2017-09-24 15:00:12', 'ok', '86.254.27.65');
INSERT INTO log VALUES (437, 'admin', 'col-SamplingPlace-write', '2017-09-24 15:00:12', '4', '86.254.27.65');
INSERT INTO log VALUES (438, 'admin', 'col-samplingPlaceList', '2017-09-24 15:00:12', 'ok', '86.254.27.65');
INSERT INTO log VALUES (439, 'admin', 'col-samplingPlaceChange', '2017-09-24 15:00:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (440, 'admin', 'col-samplingPlaceWrite', '2017-09-24 15:00:21', 'ok', '86.254.27.65');
INSERT INTO log VALUES (441, 'admin', 'col-SamplingPlace-write', '2017-09-24 15:00:21', '5', '86.254.27.65');
INSERT INTO log VALUES (442, 'admin', 'col-samplingPlaceList', '2017-09-24 15:00:21', 'ok', '86.254.27.65');
INSERT INTO log VALUES (443, 'admin', 'col-samplingPlaceChange', '2017-09-24 15:00:31', 'ok', '86.254.27.65');
INSERT INTO log VALUES (444, 'admin', 'col-samplingPlaceWrite', '2017-09-24 15:00:33', 'ok', '86.254.27.65');
INSERT INTO log VALUES (445, 'admin', 'col-SamplingPlace-write', '2017-09-24 15:00:33', '6', '86.254.27.65');
INSERT INTO log VALUES (446, 'admin', 'col-samplingPlaceList', '2017-09-24 15:00:33', 'ok', '86.254.27.65');
INSERT INTO log VALUES (447, 'admin', 'col-samplingPlaceChange', '2017-09-24 15:00:40', 'ok', '86.254.27.65');
INSERT INTO log VALUES (448, 'admin', 'col-samplingPlaceWrite', '2017-09-24 15:00:42', 'ok', '86.254.27.65');
INSERT INTO log VALUES (449, 'admin', 'col-SamplingPlace-write', '2017-09-24 15:00:42', '7', '86.254.27.65');
INSERT INTO log VALUES (450, 'admin', 'col-samplingPlaceList', '2017-09-24 15:00:42', 'ok', '86.254.27.65');
INSERT INTO log VALUES (451, 'admin', 'col-samplingPlaceChange', '2017-09-24 15:00:49', 'ok', '86.254.27.65');
INSERT INTO log VALUES (452, 'admin', 'col-samplingPlaceWrite', '2017-09-24 15:00:51', 'ok', '86.254.27.65');
INSERT INTO log VALUES (453, 'admin', 'col-SamplingPlace-write', '2017-09-24 15:00:51', '8', '86.254.27.65');
INSERT INTO log VALUES (454, 'admin', 'col-samplingPlaceList', '2017-09-24 15:00:51', 'ok', '86.254.27.65');
INSERT INTO log VALUES (455, 'admin', 'col-samplingPlaceChange', '2017-09-24 15:00:58', 'ok', '86.254.27.65');
INSERT INTO log VALUES (456, 'admin', 'col-samplingPlaceWrite', '2017-09-24 15:00:59', 'ok', '86.254.27.65');
INSERT INTO log VALUES (457, 'admin', 'col-SamplingPlace-write', '2017-09-24 15:00:59', '9', '86.254.27.65');
INSERT INTO log VALUES (458, 'admin', 'col-samplingPlaceList', '2017-09-24 15:00:59', 'ok', '86.254.27.65');
INSERT INTO log VALUES (459, 'admin', 'col-samplingPlaceChange', '2017-09-24 15:01:12', 'ok', '86.254.27.65');
INSERT INTO log VALUES (460, 'admin', 'col-samplingPlaceWrite', '2017-09-24 15:01:13', 'ok', '86.254.27.65');
INSERT INTO log VALUES (461, 'admin', 'col-SamplingPlace-write', '2017-09-24 15:01:13', '10', '86.254.27.65');
INSERT INTO log VALUES (462, 'admin', 'col-samplingPlaceList', '2017-09-24 15:01:13', 'ok', '86.254.27.65');
INSERT INTO log VALUES (463, 'admin', 'col-sampleList', '2017-09-24 15:01:22', 'ok', '86.254.27.65');
INSERT INTO log VALUES (464, 'admin', 'col-sampleChange', '2017-09-24 15:02:14', 'ok', '86.254.27.65');
INSERT INTO log VALUES (465, 'admin', 'col-sampleTypeMetadata', '2017-09-24 15:02:53', 'ok', '86.254.27.65');
INSERT INTO log VALUES (466, 'admin', 'col-sampleList', '2017-09-24 15:03:50', 'ok', '86.254.27.65');
INSERT INTO log VALUES (467, 'admin', 'col-sampleTypeList', '2017-09-24 15:03:58', 'ok', '86.254.27.65');
INSERT INTO log VALUES (468, 'admin', 'col-sampleTypeChange', '2017-09-24 15:04:01', 'ok', '86.254.27.65');
INSERT INTO log VALUES (469, 'admin', 'col-sampleTypeWrite', '2017-09-24 15:04:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (470, 'admin', 'col-SampleType-write', '2017-09-24 15:04:11', '4', '86.254.27.65');
INSERT INTO log VALUES (471, 'admin', 'col-sampleTypeList', '2017-09-24 15:04:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (472, 'admin', 'col-sampleTypeChange', '2017-09-24 15:04:15', 'ok', '86.254.27.65');
INSERT INTO log VALUES (473, 'admin', 'col-sampleTypeWrite', '2017-09-24 15:04:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (474, 'admin', 'col-SampleType-write', '2017-09-24 15:04:19', '5', '86.254.27.65');
INSERT INTO log VALUES (475, 'admin', 'col-sampleTypeList', '2017-09-24 15:04:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (476, 'admin', 'col-sampleList', '2017-09-24 15:04:23', 'ok', '86.254.27.65');
INSERT INTO log VALUES (477, 'admin', 'col-sampleChange', '2017-09-24 15:04:25', 'ok', '86.254.27.65');
INSERT INTO log VALUES (478, 'admin', 'col-sampleTypeMetadata', '2017-09-24 15:04:49', 'ok', '86.254.27.65');
INSERT INTO log VALUES (479, 'admin', 'col-sampleWrite', '2017-09-24 15:06:18', 'ok', '86.254.27.65');
INSERT INTO log VALUES (480, 'admin', 'col-Sample-write', '2017-09-24 15:06:18', '3', '86.254.27.65');
INSERT INTO log VALUES (481, 'admin', 'col-sampleDisplay', '2017-09-24 15:06:18', 'ok', '86.254.27.65');
INSERT INTO log VALUES (482, 'admin', 'col-sampleChange', '2017-09-24 15:06:55', 'ok', '86.254.27.65');
INSERT INTO log VALUES (483, 'admin', 'col-sampleTypeMetadata', '2017-09-24 15:06:56', 'ok', '86.254.27.65');
INSERT INTO log VALUES (484, 'admin', 'col-sampleWrite', '2017-09-24 15:08:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (485, 'admin', 'col-Sample-write', '2017-09-24 15:08:38', '4', '86.254.27.65');
INSERT INTO log VALUES (486, 'admin', 'col-sampleDisplay', '2017-09-24 15:08:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (487, 'admin', 'col-sampleChange', '2017-09-24 15:10:04', 'ok', '86.254.27.65');
INSERT INTO log VALUES (488, 'admin', 'col-sampleTypeMetadata', '2017-09-24 15:10:05', 'ok', '86.254.27.65');
INSERT INTO log VALUES (489, 'admin', 'col-sampleWrite', '2017-09-24 15:10:58', 'ok', '86.254.27.65');
INSERT INTO log VALUES (490, 'admin', 'col-Sample-write', '2017-09-24 15:10:58', '5', '86.254.27.65');
INSERT INTO log VALUES (491, 'admin', 'col-sampleDisplay', '2017-09-24 15:10:58', 'ok', '86.254.27.65');
INSERT INTO log VALUES (492, 'admin', 'col-sampleChange', '2017-09-24 15:11:06', 'ok', '86.254.27.65');
INSERT INTO log VALUES (493, 'admin', 'col-sampleTypeMetadata', '2017-09-24 15:11:06', 'ok', '86.254.27.65');
INSERT INTO log VALUES (494, 'admin', 'col-sampleWrite', '2017-09-24 15:11:44', 'ok', '86.254.27.65');
INSERT INTO log VALUES (495, 'admin', 'col-Sample-write', '2017-09-24 15:11:44', '6', '86.254.27.65');
INSERT INTO log VALUES (496, 'admin', 'col-sampleDisplay', '2017-09-24 15:11:44', 'ok', '86.254.27.65');
INSERT INTO log VALUES (497, 'admin', 'col-sampleChange', '2017-09-24 15:12:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (498, 'admin', 'col-sampleTypeMetadata', '2017-09-24 15:13:05', 'ok', '86.254.27.65');
INSERT INTO log VALUES (499, 'admin', 'col-sampleWrite', '2017-09-24 15:13:24', 'ok', '86.254.27.65');
INSERT INTO log VALUES (500, 'admin', 'col-Sample-write', '2017-09-24 15:13:24', '7', '86.254.27.65');
INSERT INTO log VALUES (501, 'admin', 'col-sampleDisplay', '2017-09-24 15:13:24', 'ok', '86.254.27.65');
INSERT INTO log VALUES (502, 'admin', 'col-sampleChange', '2017-09-24 15:13:45', 'ok', '86.254.27.65');
INSERT INTO log VALUES (503, 'admin', 'col-sampleTypeMetadata', '2017-09-24 15:13:45', 'ok', '86.254.27.65');
INSERT INTO log VALUES (504, 'admin', 'col-sampleList', '2017-09-24 15:13:54', 'ok', '86.254.27.65');
INSERT INTO log VALUES (505, 'admin', 'col-sampleDisplay', '2017-09-24 15:14:02', 'ok', '86.254.27.65');
INSERT INTO log VALUES (506, 'admin', 'col-sampleChange', '2017-09-24 15:14:05', 'ok', '86.254.27.65');
INSERT INTO log VALUES (507, 'admin', 'col-sampleTypeMetadata', '2017-09-24 15:14:06', 'ok', '86.254.27.65');
INSERT INTO log VALUES (508, 'admin', 'col-sampleWrite', '2017-09-24 15:14:25', 'ok', '86.254.27.65');
INSERT INTO log VALUES (509, 'admin', 'col-Sample-write', '2017-09-24 15:14:25', '3', '86.254.27.65');
INSERT INTO log VALUES (510, 'admin', 'col-sampleDisplay', '2017-09-24 15:14:25', 'ok', '86.254.27.65');
INSERT INTO log VALUES (511, 'admin', 'col-projectList', '2017-09-24 15:14:31', 'ok', '86.254.27.65');
INSERT INTO log VALUES (512, 'admin', 'col-projectChange', '2017-09-24 15:14:43', 'ok', '86.254.27.65');
INSERT INTO log VALUES (513, 'admin', 'col-projectList', '2017-09-24 15:14:48', 'ok', '86.254.27.65');
INSERT INTO log VALUES (514, 'admin', 'col-sampleList', '2017-09-24 15:14:56', 'ok', '86.254.27.65');
INSERT INTO log VALUES (515, 'admin', 'col-sampleDisplay', '2017-09-24 15:15:13', 'ok', '86.254.27.65');
INSERT INTO log VALUES (516, 'admin', 'col-sampleChange', '2017-09-24 15:15:18', 'ok', '86.254.27.65');
INSERT INTO log VALUES (517, 'admin', 'col-sampleTypeMetadata', '2017-09-24 15:15:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (518, 'admin', 'col-sampleWrite', '2017-09-24 15:16:58', 'errorbefore', '86.254.27.65');
INSERT INTO log VALUES (519, 'admin', 'col-errorbefore', '2017-09-24 15:16:58', 'ok', '86.254.27.65');
INSERT INTO log VALUES (520, 'admin', 'col-sampleList', '2017-09-24 15:17:01', 'ok', '86.254.27.65');
INSERT INTO log VALUES (521, 'admin', 'col-sampleDisplay', '2017-09-24 15:17:15', 'ok', '86.254.27.65');
INSERT INTO log VALUES (522, 'admin', 'col-sampleChange', '2017-09-24 15:17:32', 'ok', '86.254.27.65');
INSERT INTO log VALUES (523, 'admin', 'col-sampleTypeMetadata', '2017-09-24 15:17:32', 'ok', '86.254.27.65');
INSERT INTO log VALUES (524, 'admin', 'col-sampleWrite', '2017-09-24 15:18:00', 'ok', '86.254.27.65');
INSERT INTO log VALUES (525, 'admin', 'col-Sample-write', '2017-09-24 15:18:00', '3', '86.254.27.65');
INSERT INTO log VALUES (526, 'admin', 'col-sampleDisplay', '2017-09-24 15:18:00', 'ok', '86.254.27.65');
INSERT INTO log VALUES (527, 'admin', 'col-sampleList', '2017-09-24 15:18:09', 'ok', '86.254.27.65');
INSERT INTO log VALUES (528, 'admin', 'col-sampleDisplay', '2017-09-24 15:18:16', 'ok', '86.254.27.65');
INSERT INTO log VALUES (529, 'admin', 'col-sampleChange', '2017-09-24 15:18:24', 'ok', '86.254.27.65');
INSERT INTO log VALUES (530, 'admin', 'col-sampleTypeMetadata', '2017-09-24 15:18:24', 'ok', '86.254.27.65');
INSERT INTO log VALUES (531, 'admin', 'col-sampleWrite', '2017-09-24 15:18:37', 'ok', '86.254.27.65');
INSERT INTO log VALUES (532, 'admin', 'col-Sample-write', '2017-09-24 15:18:37', '3', '86.254.27.65');
INSERT INTO log VALUES (533, 'admin', 'col-sampleDisplay', '2017-09-24 15:18:37', 'ok', '86.254.27.65');
INSERT INTO log VALUES (534, 'admin', 'col-sampleList', '2017-09-24 15:18:42', 'ok', '86.254.27.65');
INSERT INTO log VALUES (535, 'admin', 'col-sampleDisplay', '2017-09-24 15:18:48', 'ok', '86.254.27.65');
INSERT INTO log VALUES (536, 'admin', 'col-sampleChange', '2017-09-24 15:18:51', 'ok', '86.254.27.65');
INSERT INTO log VALUES (537, 'admin', 'col-sampleTypeMetadata', '2017-09-24 15:18:52', 'ok', '86.254.27.65');
INSERT INTO log VALUES (538, 'admin', 'col-sampleWrite', '2017-09-24 15:19:07', 'ok', '86.254.27.65');
INSERT INTO log VALUES (539, 'admin', 'col-Sample-write', '2017-09-24 15:19:07', '3', '86.254.27.65');
INSERT INTO log VALUES (540, 'admin', 'col-sampleDisplay', '2017-09-24 15:19:07', 'ok', '86.254.27.65');
INSERT INTO log VALUES (541, 'admin', 'col-sampleList', '2017-09-24 15:19:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (542, 'admindemo', 'col-containerTypeList', '2017-09-24 15:21:18', 'ok', '86.254.27.65');
INSERT INTO log VALUES (543, 'admindemo', 'col-metadataList', '2017-09-24 15:21:34', 'ok', '86.254.27.65');
INSERT INTO log VALUES (544, 'admindemo', 'col-protocolList', '2017-09-24 15:32:02', 'ok', '86.254.27.65');
INSERT INTO log VALUES (545, 'admindemo', 'col-metadataList', '2017-09-24 15:32:27', 'ok', '86.254.27.65');
INSERT INTO log VALUES (546, 'admindemo', 'col-metadataChange', '2017-09-24 15:32:31', 'ok', '86.254.27.65');
INSERT INTO log VALUES (547, 'admindemo', 'col-metadataWrite', '2017-09-24 15:35:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (548, 'admindemo', 'col-Metadata-write', '2017-09-24 15:35:11', '3', '86.254.27.65');
INSERT INTO log VALUES (549, 'admindemo', 'col-metadataList', '2017-09-24 15:35:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (550, 'admindemo', 'col-metadataChange', '2017-09-24 15:35:14', 'ok', '86.254.27.65');
INSERT INTO log VALUES (551, 'admindemo', 'col-metadataWrite', '2017-09-24 15:38:30', 'ok', '86.254.27.65');
INSERT INTO log VALUES (552, 'admindemo', 'col-Metadata-write', '2017-09-24 15:38:30', '3', '86.254.27.65');
INSERT INTO log VALUES (553, 'admindemo', 'col-metadataList', '2017-09-24 15:38:30', 'ok', '86.254.27.65');
INSERT INTO log VALUES (554, 'admindemo', 'col-metadataChange', '2017-09-24 15:38:36', 'ok', '86.254.27.65');
INSERT INTO log VALUES (555, 'admindemo', 'col-metadataWrite', '2017-09-24 15:40:11', 'errorbefore', '86.254.27.65');
INSERT INTO log VALUES (556, 'admindemo', 'col-errorbefore', '2017-09-24 15:40:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (557, 'admindemo', 'col-metadataList', '2017-09-24 15:40:15', 'ok', '86.254.27.65');
INSERT INTO log VALUES (558, 'admindemo', 'col-metadataChange', '2017-09-24 15:40:17', 'ok', '86.254.27.65');
INSERT INTO log VALUES (559, 'admindemo', 'col-metadataWrite', '2017-09-24 15:48:59', 'ok', '86.254.27.65');
INSERT INTO log VALUES (560, 'admindemo', 'col-Metadata-write', '2017-09-24 15:48:59', '3', '86.254.27.65');
INSERT INTO log VALUES (561, 'admindemo', 'col-metadataList', '2017-09-24 15:48:59', 'ok', '86.254.27.65');
INSERT INTO log VALUES (562, 'admindemo', 'col-metadataChange', '2017-09-24 15:49:02', 'ok', '86.254.27.65');
INSERT INTO log VALUES (563, 'admindemo', 'col-metadataList', '2017-09-24 15:49:20', 'ok', '86.254.27.65');
INSERT INTO log VALUES (564, 'admindemo', 'col-metadataCopy', '2017-09-24 15:49:52', 'ok', '86.254.27.65');
INSERT INTO log VALUES (565, 'admindemo', 'col-metadataWrite', '2017-09-24 15:52:48', 'ok', '86.254.27.65');
INSERT INTO log VALUES (566, 'admindemo', 'col-Metadata-write', '2017-09-24 15:52:48', '4', '86.254.27.65');
INSERT INTO log VALUES (567, 'admindemo', 'col-metadataList', '2017-09-24 15:52:48', 'ok', '86.254.27.65');
INSERT INTO log VALUES (568, 'admindemo', 'col-metadataChange', '2017-09-24 15:53:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (569, 'admindemo', 'col-metadataWrite', '2017-09-24 15:54:52', 'ok', '86.254.27.65');
INSERT INTO log VALUES (570, 'admindemo', 'col-Metadata-write', '2017-09-24 15:54:52', '4', '86.254.27.65');
INSERT INTO log VALUES (571, 'admindemo', 'col-metadataList', '2017-09-24 15:54:52', 'ok', '86.254.27.65');
INSERT INTO log VALUES (572, 'admindemo', 'col-metadataChange', '2017-09-24 15:55:01', 'ok', '86.254.27.65');
INSERT INTO log VALUES (573, 'admindemo', 'col-metadataWrite', '2017-09-24 15:56:08', 'errorbefore', '86.254.27.65');
INSERT INTO log VALUES (574, 'admindemo', 'col-errorbefore', '2017-09-24 15:56:08', 'ok', '86.254.27.65');
INSERT INTO log VALUES (575, 'admindemo', 'col-importChange', '2017-09-24 16:01:56', 'ok', '86.254.27.65');
INSERT INTO log VALUES (576, 'admindemo', 'col-containerTypeList', '2017-09-24 16:10:34', 'ok', '86.254.27.65');
INSERT INTO log VALUES (577, 'admindemo', 'col-containerTypeChange', '2017-09-24 16:12:31', 'ok', '86.254.27.65');
INSERT INTO log VALUES (578, 'admindemo', 'col-containerTypeList', '2017-09-24 16:13:24', 'ok', '86.254.27.65');
INSERT INTO log VALUES (579, 'admindemo', 'col-containerTypeChange', '2017-09-24 16:13:55', 'ok', '86.254.27.65');
INSERT INTO log VALUES (580, 'admindemo', 'col-containerTypeWrite', '2017-09-24 16:15:03', 'ok', '86.254.27.65');
INSERT INTO log VALUES (581, 'admindemo', 'col-ContainerType-write', '2017-09-24 16:15:03', '12', '86.254.27.65');
INSERT INTO log VALUES (582, 'admindemo', 'col-containerTypeList', '2017-09-24 16:15:03', 'ok', '86.254.27.65');
INSERT INTO log VALUES (583, 'admindemo', 'col-objectStatusList', '2017-09-24 16:16:10', 'ok', '86.254.27.65');
INSERT INTO log VALUES (584, 'admindemo', 'col-containerList', '2017-09-24 16:16:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (585, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:16:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (586, 'admindemo', 'col-containerTypeList', '2017-09-24 16:19:10', 'ok', '86.254.27.65');
INSERT INTO log VALUES (587, 'admindemo', 'col-containerTypeChange', '2017-09-24 16:26:53', 'ok', '86.254.27.65');
INSERT INTO log VALUES (588, 'admindemo', 'col-containerTypeWrite', '2017-09-24 16:26:59', 'ok', '86.254.27.65');
INSERT INTO log VALUES (589, 'admindemo', 'col-ContainerType-write', '2017-09-24 16:26:59', '12', '86.254.27.65');
INSERT INTO log VALUES (590, 'admindemo', 'col-containerTypeList', '2017-09-24 16:26:59', 'ok', '86.254.27.65');
INSERT INTO log VALUES (591, 'admindemo', 'col-importChange', '2017-09-24 16:29:01', 'ok', '86.254.27.65');
INSERT INTO log VALUES (592, 'admindemo', 'col-importControl', '2017-09-24 16:29:12', 'ok', '86.254.27.65');
INSERT INTO log VALUES (593, 'admindemo', 'col-importChange', '2017-09-24 16:29:12', 'ok', '86.254.27.65');
INSERT INTO log VALUES (594, 'admindemo', 'col-importControl', '2017-09-24 16:29:31', 'ok', '86.254.27.65');
INSERT INTO log VALUES (595, 'admindemo', 'col-importChange', '2017-09-24 16:29:31', 'ok', '86.254.27.65');
INSERT INTO log VALUES (596, 'admindemo', 'col-importControl', '2017-09-24 16:30:04', 'ok', '86.254.27.65');
INSERT INTO log VALUES (597, 'admindemo', 'col-importChange', '2017-09-24 16:30:04', 'ok', '86.254.27.65');
INSERT INTO log VALUES (598, 'admindemo', 'col-importControl', '2017-09-24 16:30:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (599, 'admindemo', 'col-importChange', '2017-09-24 16:30:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (600, 'admindemo', 'col-importControl', '2017-09-24 16:30:33', 'ok', '86.254.27.65');
INSERT INTO log VALUES (601, 'admindemo', 'col-importChange', '2017-09-24 16:30:33', 'ok', '86.254.27.65');
INSERT INTO log VALUES (602, 'admindemo', 'col-importControl', '2017-09-24 16:31:04', 'ok', '86.254.27.65');
INSERT INTO log VALUES (603, 'admindemo', 'col-importChange', '2017-09-24 16:31:04', 'ok', '86.254.27.65');
INSERT INTO log VALUES (604, 'admindemo', 'col-importControl', '2017-09-24 16:31:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (605, 'admindemo', 'col-importChange', '2017-09-24 16:31:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (606, 'admindemo', 'col-importControl', '2017-09-24 16:31:30', 'ok', '86.254.27.65');
INSERT INTO log VALUES (607, 'admindemo', 'col-importChange', '2017-09-24 16:31:30', 'ok', '86.254.27.65');
INSERT INTO log VALUES (608, 'admindemo', 'col-importControl', '2017-09-24 16:37:23', 'ok', '86.254.27.65');
INSERT INTO log VALUES (609, 'admindemo', 'col-importChange', '2017-09-24 16:37:23', 'ok', '86.254.27.65');
INSERT INTO log VALUES (610, 'admindemo', 'col-default', '2017-09-24 16:38:33', 'ok', '86.254.27.65');
INSERT INTO log VALUES (611, 'admindemo', 'col-containerList', '2017-09-24 16:38:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (612, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:38:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (613, 'admindemo', 'col-importChange', '2017-09-24 16:38:46', 'ok', '86.254.27.65');
INSERT INTO log VALUES (614, 'admindemo', 'col-importControl', '2017-09-24 16:38:56', 'ok', '86.254.27.65');
INSERT INTO log VALUES (615, 'admindemo', 'col-importChange', '2017-09-24 16:38:56', 'ok', '86.254.27.65');
INSERT INTO log VALUES (616, 'admindemo', 'col-importControl', '2017-09-24 16:40:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (617, 'admindemo', 'col-importChange', '2017-09-24 16:40:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (618, 'admindemo', 'col-importImport', '2017-09-24 16:40:44', 'ok', '86.254.27.65');
INSERT INTO log VALUES (619, 'admindemo', 'col-importChange', '2017-09-24 16:40:44', 'ok', '86.254.27.65');
INSERT INTO log VALUES (620, 'admindemo', 'col-containerList', '2017-09-24 16:40:54', 'ok', '86.254.27.65');
INSERT INTO log VALUES (621, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:40:55', 'ok', '86.254.27.65');
INSERT INTO log VALUES (622, 'admindemo', 'col-containerDisplay', '2017-09-24 16:41:15', 'ok', '86.254.27.65');
INSERT INTO log VALUES (623, 'admindemo', 'col-containerChange', '2017-09-24 16:41:44', 'ok', '86.254.27.65');
INSERT INTO log VALUES (624, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:41:45', 'ok', '86.254.27.65');
INSERT INTO log VALUES (625, 'admindemo', 'col-containerList', '2017-09-24 16:42:58', 'ok', '86.254.27.65');
INSERT INTO log VALUES (626, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:42:59', 'ok', '86.254.27.65');
INSERT INTO log VALUES (627, 'admindemo', 'col-containerDisplay', '2017-09-24 16:46:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (628, 'admindemo', 'col-storagecontainerInput', '2017-09-24 16:46:22', 'ok', '86.254.27.65');
INSERT INTO log VALUES (629, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:46:37', 'ok', '86.254.27.65');
INSERT INTO log VALUES (630, 'admindemo', 'col-containerGetFromType', '2017-09-24 16:46:40', 'ok', '86.254.27.65');
INSERT INTO log VALUES (631, 'admindemo', 'col-storagecontainerWrite', '2017-09-24 16:46:54', 'ok', '86.254.27.65');
INSERT INTO log VALUES (632, 'admindemo', 'col-Storage-write', '2017-09-24 16:46:54', '2', '86.254.27.65');
INSERT INTO log VALUES (633, 'admindemo', 'col-containerDisplay', '2017-09-24 16:46:54', 'ok', '86.254.27.65');
INSERT INTO log VALUES (634, 'admindemo', 'col-containerList', '2017-09-24 16:47:04', 'ok', '86.254.27.65');
INSERT INTO log VALUES (635, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:47:04', 'ok', '86.254.27.65');
INSERT INTO log VALUES (636, 'admindemo', 'col-containerDisplay', '2017-09-24 16:47:08', 'ok', '86.254.27.65');
INSERT INTO log VALUES (637, 'admindemo', 'col-storagecontainerInput', '2017-09-24 16:47:10', 'ok', '86.254.27.65');
INSERT INTO log VALUES (638, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:47:16', 'ok', '86.254.27.65');
INSERT INTO log VALUES (639, 'admindemo', 'col-containerGetFromType', '2017-09-24 16:47:18', 'ok', '86.254.27.65');
INSERT INTO log VALUES (640, 'admindemo', 'col-storagecontainerWrite', '2017-09-24 16:47:26', 'ok', '86.254.27.65');
INSERT INTO log VALUES (641, 'admindemo', 'col-Storage-write', '2017-09-24 16:47:26', '3', '86.254.27.65');
INSERT INTO log VALUES (642, 'admindemo', 'col-containerDisplay', '2017-09-24 16:47:26', 'ok', '86.254.27.65');
INSERT INTO log VALUES (643, 'admindemo', 'col-containerList', '2017-09-24 16:47:32', 'ok', '86.254.27.65');
INSERT INTO log VALUES (644, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:47:33', 'ok', '86.254.27.65');
INSERT INTO log VALUES (645, 'admindemo', 'col-containerDisplay', '2017-09-24 16:47:36', 'ok', '86.254.27.65');
INSERT INTO log VALUES (646, 'admindemo', 'col-containerList', '2017-09-24 16:47:50', 'ok', '86.254.27.65');
INSERT INTO log VALUES (647, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:47:51', 'ok', '86.254.27.65');
INSERT INTO log VALUES (648, 'admindemo', 'col-containerDisplay', '2017-09-24 16:47:56', 'ok', '86.254.27.65');
INSERT INTO log VALUES (649, 'admindemo', 'col-storagecontainerInput', '2017-09-24 16:47:59', 'ok', '86.254.27.65');
INSERT INTO log VALUES (650, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:48:04', 'ok', '86.254.27.65');
INSERT INTO log VALUES (651, 'admindemo', 'col-containerGetFromType', '2017-09-24 16:48:06', 'ok', '86.254.27.65');
INSERT INTO log VALUES (652, 'admindemo', 'col-storagecontainerWrite', '2017-09-24 16:48:10', 'ok', '86.254.27.65');
INSERT INTO log VALUES (653, 'admindemo', 'col-Storage-write', '2017-09-24 16:48:10', '4', '86.254.27.65');
INSERT INTO log VALUES (654, 'admindemo', 'col-containerDisplay', '2017-09-24 16:48:10', 'ok', '86.254.27.65');
INSERT INTO log VALUES (655, 'admindemo', 'col-containerList', '2017-09-24 16:48:13', 'ok', '86.254.27.65');
INSERT INTO log VALUES (656, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:48:13', 'ok', '86.254.27.65');
INSERT INTO log VALUES (657, 'admindemo', 'col-containerDisplay', '2017-09-24 16:48:18', 'ok', '86.254.27.65');
INSERT INTO log VALUES (658, 'admindemo', 'col-storagecontainerInput', '2017-09-24 16:48:27', 'ok', '86.254.27.65');
INSERT INTO log VALUES (659, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:48:31', 'ok', '86.254.27.65');
INSERT INTO log VALUES (660, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:48:35', 'ok', '86.254.27.65');
INSERT INTO log VALUES (661, 'admindemo', 'col-containerGetFromType', '2017-09-24 16:48:37', 'ok', '86.254.27.65');
INSERT INTO log VALUES (662, 'admindemo', 'col-storagecontainerWrite', '2017-09-24 16:48:40', 'ok', '86.254.27.65');
INSERT INTO log VALUES (663, 'admindemo', 'col-Storage-write', '2017-09-24 16:48:40', '5', '86.254.27.65');
INSERT INTO log VALUES (664, 'admindemo', 'col-containerDisplay', '2017-09-24 16:48:40', 'ok', '86.254.27.65');
INSERT INTO log VALUES (665, 'admindemo', 'col-containerList', '2017-09-24 16:48:45', 'ok', '86.254.27.65');
INSERT INTO log VALUES (666, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:48:45', 'ok', '86.254.27.65');
INSERT INTO log VALUES (667, 'admindemo', 'col-containerDisplay', '2017-09-24 16:49:08', 'ok', '86.254.27.65');
INSERT INTO log VALUES (668, 'admindemo', 'col-storagecontainerInput', '2017-09-24 16:49:13', 'ok', '86.254.27.65');
INSERT INTO log VALUES (669, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:49:20', 'ok', '86.254.27.65');
INSERT INTO log VALUES (670, 'admindemo', 'col-containerGetFromType', '2017-09-24 16:49:22', 'ok', '86.254.27.65');
INSERT INTO log VALUES (671, 'admindemo', 'col-storagecontainerWrite', '2017-09-24 16:49:28', 'ok', '86.254.27.65');
INSERT INTO log VALUES (672, 'admindemo', 'col-Storage-write', '2017-09-24 16:49:28', '6', '86.254.27.65');
INSERT INTO log VALUES (673, 'admindemo', 'col-containerDisplay', '2017-09-24 16:49:28', 'ok', '86.254.27.65');
INSERT INTO log VALUES (674, 'admindemo', 'col-containerList', '2017-09-24 16:49:33', 'ok', '86.254.27.65');
INSERT INTO log VALUES (675, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:49:34', 'ok', '86.254.27.65');
INSERT INTO log VALUES (676, 'admindemo', 'col-containerDisplay', '2017-09-24 16:49:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (677, 'admindemo', 'col-storagecontainerInput', '2017-09-24 16:49:41', 'ok', '86.254.27.65');
INSERT INTO log VALUES (678, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:49:44', 'ok', '86.254.27.65');
INSERT INTO log VALUES (679, 'admindemo', 'col-containerGetFromType', '2017-09-24 16:49:52', 'ok', '86.254.27.65');
INSERT INTO log VALUES (680, 'admindemo', 'col-containerGetFromType', '2017-09-24 16:49:56', 'ok', '86.254.27.65');
INSERT INTO log VALUES (681, 'admindemo', 'col-storagecontainerWrite', '2017-09-24 16:49:59', 'ok', '86.254.27.65');
INSERT INTO log VALUES (682, 'admindemo', 'col-Storage-write', '2017-09-24 16:49:59', '7', '86.254.27.65');
INSERT INTO log VALUES (683, 'admindemo', 'col-containerDisplay', '2017-09-24 16:49:59', 'ok', '86.254.27.65');
INSERT INTO log VALUES (684, 'admindemo', 'col-containerList', '2017-09-24 16:50:06', 'ok', '86.254.27.65');
INSERT INTO log VALUES (685, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:50:06', 'ok', '86.254.27.65');
INSERT INTO log VALUES (686, 'admindemo', 'col-containerDisplay', '2017-09-24 16:50:10', 'ok', '86.254.27.65');
INSERT INTO log VALUES (687, 'admindemo', 'col-containerList', '2017-09-24 16:50:34', 'ok', '86.254.27.65');
INSERT INTO log VALUES (688, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:50:35', 'ok', '86.254.27.65');
INSERT INTO log VALUES (689, 'admindemo', 'col-containerDisplay', '2017-09-24 16:50:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (690, 'admindemo', 'col-containerPrintLabel', '2017-09-24 16:50:50', 'ok', '86.254.27.65');
INSERT INTO log VALUES (691, 'admindemo', 'col-containerList', '2017-09-24 16:50:50', 'ok', '86.254.27.65');
INSERT INTO log VALUES (692, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:50:51', 'ok', '86.254.27.65');
INSERT INTO log VALUES (693, 'admindemo', 'col-containerDisplay', '2017-09-24 16:52:09', 'ok', '86.254.27.65');
INSERT INTO log VALUES (694, 'admindemo', 'col-containerPrintLabel', '2017-09-24 16:52:24', 'ok', '86.254.27.65');
INSERT INTO log VALUES (695, 'admindemo', 'col-containerList', '2017-09-24 16:52:24', 'ok', '86.254.27.65');
INSERT INTO log VALUES (696, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:52:25', 'ok', '86.254.27.65');
INSERT INTO log VALUES (697, 'admindemo', 'col-containerPrintLabel', '2017-09-24 16:52:50', 'ok', '86.254.27.65');
INSERT INTO log VALUES (698, 'admindemo', 'col-containerPrintLabel', '2017-09-24 16:53:24', 'ok', '86.254.27.65');
INSERT INTO log VALUES (699, 'admindemo', 'col-containerPrintLabel', '2017-09-24 16:53:40', 'ok', '86.254.27.65');
INSERT INTO log VALUES (700, 'admindemo', 'col-containerList', '2017-09-24 16:53:40', 'ok', '86.254.27.65');
INSERT INTO log VALUES (701, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:53:41', 'ok', '86.254.27.65');
INSERT INTO log VALUES (702, 'admindemo', 'col-importChange', '2017-09-24 16:53:52', 'ok', '86.254.27.65');
INSERT INTO log VALUES (703, 'admindemo', 'col-importControl', '2017-09-24 16:54:04', 'ok', '86.254.27.65');
INSERT INTO log VALUES (704, 'admindemo', 'col-importChange', '2017-09-24 16:54:04', 'ok', '86.254.27.65');
INSERT INTO log VALUES (705, 'admindemo', 'col-importImport', '2017-09-24 16:54:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (706, 'admindemo', 'col-importChange', '2017-09-24 16:54:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (707, 'admindemo', 'col-containerList', '2017-09-24 16:55:26', 'ok', '86.254.27.65');
INSERT INTO log VALUES (708, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 16:55:27', 'ok', '86.254.27.65');
INSERT INTO log VALUES (709, 'admindemo', 'col-sampleList', '2017-09-24 16:55:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (710, 'admindemo', 'col-samplingPlaceList', '2017-09-24 16:57:00', 'ok', '86.254.27.65');
INSERT INTO log VALUES (711, 'admindemo', 'col-samplingPlaceChange', '2017-09-24 16:57:34', 'ok', '86.254.27.65');
INSERT INTO log VALUES (712, 'admindemo', 'col-samplingPlaceWrite', '2017-09-24 16:57:48', 'ok', '86.254.27.65');
INSERT INTO log VALUES (713, 'admindemo', 'col-SamplingPlace-write', '2017-09-24 16:57:48', '11', '86.254.27.65');
INSERT INTO log VALUES (714, 'admindemo', 'col-samplingPlaceList', '2017-09-24 16:57:48', 'ok', '86.254.27.65');
INSERT INTO log VALUES (715, 'admindemo', 'col-samplingPlaceChange', '2017-09-24 16:57:54', 'ok', '86.254.27.65');
INSERT INTO log VALUES (716, 'admindemo', 'col-samplingPlaceWrite', '2017-09-24 16:58:03', 'ok', '86.254.27.65');
INSERT INTO log VALUES (717, 'admindemo', 'col-SamplingPlace-write', '2017-09-24 16:58:03', '12', '86.254.27.65');
INSERT INTO log VALUES (718, 'admindemo', 'col-samplingPlaceList', '2017-09-24 16:58:03', 'ok', '86.254.27.65');
INSERT INTO log VALUES (719, 'admindemo', 'col-sampleList', '2017-09-24 16:58:10', 'ok', '86.254.27.65');
INSERT INTO log VALUES (720, 'admindemo', 'col-sampleChange', '2017-09-24 16:58:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (721, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 16:59:22', 'ok', '86.254.27.65');
INSERT INTO log VALUES (722, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:00:05', 'ok', '86.254.27.65');
INSERT INTO log VALUES (723, 'admindemo', 'col-sampleTypeList', '2017-09-24 17:00:12', 'ok', '86.254.27.65');
INSERT INTO log VALUES (724, 'admindemo', 'col-sampleTypeChange', '2017-09-24 17:00:18', 'ok', '86.254.27.65');
INSERT INTO log VALUES (725, 'admindemo', 'col-sampleTypeWrite', '2017-09-24 17:00:34', 'ok', '86.254.27.65');
INSERT INTO log VALUES (726, 'admindemo', 'col-SampleType-write', '2017-09-24 17:00:34', '1', '86.254.27.65');
INSERT INTO log VALUES (727, 'admindemo', 'col-sampleTypeList', '2017-09-24 17:00:34', 'ok', '86.254.27.65');
INSERT INTO log VALUES (728, 'admindemo', 'col-sampleTypeChange', '2017-09-24 17:00:44', 'ok', '86.254.27.65');
INSERT INTO log VALUES (729, 'admindemo', 'col-sampleTypeWrite', '2017-09-24 17:00:49', 'ok', '86.254.27.65');
INSERT INTO log VALUES (730, 'admindemo', 'col-SampleType-write', '2017-09-24 17:00:49', '2', '86.254.27.65');
INSERT INTO log VALUES (731, 'admindemo', 'col-sampleTypeList', '2017-09-24 17:00:49', 'ok', '86.254.27.65');
INSERT INTO log VALUES (732, 'admindemo', 'col-sampleList', '2017-09-24 17:01:06', 'ok', '86.254.27.65');
INSERT INTO log VALUES (733, 'admindemo', 'col-sampleChange', '2017-09-24 17:01:09', 'ok', '86.254.27.65');
INSERT INTO log VALUES (734, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:01:49', 'ok', '86.254.27.65');
INSERT INTO log VALUES (735, 'admindemo', 'col-sampleWrite', '2017-09-24 17:07:55', 'ok', '86.254.27.65');
INSERT INTO log VALUES (736, 'admindemo', 'col-Sample-write', '2017-09-24 17:07:55', '94', '86.254.27.65');
INSERT INTO log VALUES (737, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:07:55', 'ok', '86.254.27.65');
INSERT INTO log VALUES (738, 'admindemo', 'col-sampleChange', '2017-09-24 17:09:45', 'ok', '86.254.27.65');
INSERT INTO log VALUES (739, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:09:45', 'ok', '86.254.27.65');
INSERT INTO log VALUES (740, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:10:02', 'ok', '86.254.27.65');
INSERT INTO log VALUES (741, 'admindemo', 'col-sampleWrite', '2017-09-24 17:10:56', 'ok', '86.254.27.65');
INSERT INTO log VALUES (742, 'admindemo', 'col-Sample-write', '2017-09-24 17:10:57', '95', '86.254.27.65');
INSERT INTO log VALUES (743, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:10:57', 'ok', '86.254.27.65');
INSERT INTO log VALUES (744, 'admindemo', 'col-sampleChange', '2017-09-24 17:11:02', 'ok', '86.254.27.65');
INSERT INTO log VALUES (745, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:11:02', 'ok', '86.254.27.65');
INSERT INTO log VALUES (746, 'admindemo', 'col-sampleWrite', '2017-09-24 17:11:41', 'ok', '86.254.27.65');
INSERT INTO log VALUES (747, 'admindemo', 'col-Sample-write', '2017-09-24 17:11:41', '96', '86.254.27.65');
INSERT INTO log VALUES (748, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:11:41', 'ok', '86.254.27.65');
INSERT INTO log VALUES (749, 'admindemo', 'col-sampleList', '2017-09-24 17:12:14', 'ok', '86.254.27.65');
INSERT INTO log VALUES (750, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:12:24', 'ok', '86.254.27.65');
INSERT INTO log VALUES (751, 'admindemo', 'col-sampleList', '2017-09-24 17:12:55', 'ok', '86.254.27.65');
INSERT INTO log VALUES (752, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:13:04', 'ok', '86.254.27.65');
INSERT INTO log VALUES (753, 'admindemo', 'col-sampleChange', '2017-09-24 17:13:16', 'ok', '86.254.27.65');
INSERT INTO log VALUES (754, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:13:29', 'ok', '86.254.27.65');
INSERT INTO log VALUES (755, 'admindemo', 'col-sampleWrite', '2017-09-24 17:13:44', 'ok', '86.254.27.65');
INSERT INTO log VALUES (756, 'admindemo', 'col-Sample-write', '2017-09-24 17:13:44', '97', '86.254.27.65');
INSERT INTO log VALUES (757, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:13:44', 'ok', '86.254.27.65');
INSERT INTO log VALUES (758, 'admindemo', 'col-sampleList', '2017-09-24 17:13:49', 'ok', '86.254.27.65');
INSERT INTO log VALUES (759, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:14:52', 'ok', '86.254.27.65');
INSERT INTO log VALUES (760, 'admindemo', 'col-sampleChange', '2017-09-24 17:15:06', 'ok', '86.254.27.65');
INSERT INTO log VALUES (761, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:15:06', 'ok', '86.254.27.65');
INSERT INTO log VALUES (762, 'admindemo', 'col-sampleDelete', '2017-09-24 17:15:12', 'ok', '86.254.27.65');
INSERT INTO log VALUES (763, 'admindemo', 'col-Sample-delete', '2017-09-24 17:15:12', '95', '86.254.27.65');
INSERT INTO log VALUES (764, 'admindemo', 'col-sampleList', '2017-09-24 17:15:12', 'ok', '86.254.27.65');
INSERT INTO log VALUES (765, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:15:26', 'ok', '86.254.27.65');
INSERT INTO log VALUES (766, 'admindemo', 'col-sampleChange', '2017-09-24 17:15:33', 'ok', '86.254.27.65');
INSERT INTO log VALUES (767, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:15:33', 'ok', '86.254.27.65');
INSERT INTO log VALUES (768, 'admindemo', 'col-sampleDelete', '2017-09-24 17:15:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (769, 'admindemo', 'col-Sample-delete', '2017-09-24 17:15:38', '96', '86.254.27.65');
INSERT INTO log VALUES (770, 'admindemo', 'col-sampleList', '2017-09-24 17:15:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (771, 'admindemo', 'col-sampleChange', '2017-09-24 17:15:52', 'ok', '86.254.27.65');
INSERT INTO log VALUES (772, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:15:52', 'ok', '86.254.27.65');
INSERT INTO log VALUES (773, 'admindemo', 'col-sampleWrite', '2017-09-24 17:16:25', 'ok', '86.254.27.65');
INSERT INTO log VALUES (774, 'admindemo', 'col-Sample-write', '2017-09-24 17:16:25', '98', '86.254.27.65');
INSERT INTO log VALUES (775, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:16:25', 'ok', '86.254.27.65');
INSERT INTO log VALUES (776, 'admindemo', 'col-sampleChange', '2017-09-24 17:16:42', 'ok', '86.254.27.65');
INSERT INTO log VALUES (777, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:16:43', 'ok', '86.254.27.65');
INSERT INTO log VALUES (778, 'admindemo', 'col-metadataList', '2017-09-24 17:16:58', 'ok', '86.254.27.65');
INSERT INTO log VALUES (779, 'admindemo', 'col-metadataChange', '2017-09-24 17:17:02', 'ok', '86.254.27.65');
INSERT INTO log VALUES (780, 'admindemo', 'col-metadataWrite', '2017-09-24 17:17:45', 'ok', '86.254.27.65');
INSERT INTO log VALUES (781, 'admindemo', 'col-Metadata-write', '2017-09-24 17:17:45', '3', '86.254.27.65');
INSERT INTO log VALUES (782, 'admindemo', 'col-metadataList', '2017-09-24 17:17:45', 'ok', '86.254.27.65');
INSERT INTO log VALUES (783, 'admindemo', 'col-metadataChange', '2017-09-24 17:17:47', 'ok', '86.254.27.65');
INSERT INTO log VALUES (784, 'admindemo', 'col-metadataWrite', '2017-09-24 17:18:32', 'ok', '86.254.27.65');
INSERT INTO log VALUES (785, 'admindemo', 'col-Metadata-write', '2017-09-24 17:18:32', '4', '86.254.27.65');
INSERT INTO log VALUES (786, 'admindemo', 'col-metadataList', '2017-09-24 17:18:32', 'ok', '86.254.27.65');
INSERT INTO log VALUES (787, 'admindemo', 'col-sampleList', '2017-09-24 17:18:36', 'ok', '86.254.27.65');
INSERT INTO log VALUES (788, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:18:40', 'ok', '86.254.27.65');
INSERT INTO log VALUES (789, 'admindemo', 'col-sampleChange', '2017-09-24 17:18:48', 'ok', '86.254.27.65');
INSERT INTO log VALUES (790, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:18:49', 'ok', '86.254.27.65');
INSERT INTO log VALUES (791, 'admindemo', 'col-sampleWrite', '2017-09-24 17:18:59', 'ok', '86.254.27.65');
INSERT INTO log VALUES (792, 'admindemo', 'col-Sample-write', '2017-09-24 17:18:59', '94', '86.254.27.65');
INSERT INTO log VALUES (793, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:18:59', 'ok', '86.254.27.65');
INSERT INTO log VALUES (794, 'admindemo', 'col-sampleList', '2017-09-24 17:19:12', 'ok', '86.254.27.65');
INSERT INTO log VALUES (795, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:19:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (796, 'admindemo', 'col-sampleChange', '2017-09-24 17:19:27', 'ok', '86.254.27.65');
INSERT INTO log VALUES (797, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:19:28', 'ok', '86.254.27.65');
INSERT INTO log VALUES (798, 'admindemo', 'col-sampleWrite', '2017-09-24 17:19:44', 'ok', '86.254.27.65');
INSERT INTO log VALUES (799, 'admindemo', 'col-Sample-write', '2017-09-24 17:19:44', '97', '86.254.27.65');
INSERT INTO log VALUES (800, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:19:44', 'ok', '86.254.27.65');
INSERT INTO log VALUES (801, 'admindemo', 'col-sampleList', '2017-09-24 17:19:53', 'ok', '86.254.27.65');
INSERT INTO log VALUES (802, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:20:04', 'ok', '86.254.27.65');
INSERT INTO log VALUES (803, 'admindemo', 'col-sampleChange', '2017-09-24 17:20:10', 'ok', '86.254.27.65');
INSERT INTO log VALUES (804, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:20:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (805, 'admindemo', 'col-sampleDelete', '2017-09-24 17:20:27', 'ok', '86.254.27.65');
INSERT INTO log VALUES (806, 'admindemo', 'col-Sample-delete', '2017-09-24 17:20:27', '98', '86.254.27.65');
INSERT INTO log VALUES (807, 'admindemo', 'col-sampleList', '2017-09-24 17:20:27', 'ok', '86.254.27.65');
INSERT INTO log VALUES (808, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:20:37', 'ok', '86.254.27.65');
INSERT INTO log VALUES (809, 'admindemo', 'col-sampleChange', '2017-09-24 17:20:46', 'ok', '86.254.27.65');
INSERT INTO log VALUES (810, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:21:00', 'ok', '86.254.27.65');
INSERT INTO log VALUES (811, 'admindemo', 'col-sampleWrite', '2017-09-24 17:21:17', 'ok', '86.254.27.65');
INSERT INTO log VALUES (812, 'admindemo', 'col-Sample-write', '2017-09-24 17:21:17', '99', '86.254.27.65');
INSERT INTO log VALUES (813, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:21:17', 'ok', '86.254.27.65');
INSERT INTO log VALUES (814, 'admindemo', 'col-sampleList', '2017-09-24 17:21:25', 'ok', '86.254.27.65');
INSERT INTO log VALUES (815, 'admindemo', 'col-identifierTypeList', '2017-09-24 17:22:16', 'ok', '86.254.27.65');
INSERT INTO log VALUES (816, 'admindemo', 'col-sampleList', '2017-09-24 17:22:27', 'ok', '86.254.27.65');
INSERT INTO log VALUES (817, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:22:40', 'ok', '86.254.27.65');
INSERT INTO log VALUES (818, 'admindemo', 'col-sampleChange', '2017-09-24 17:22:52', 'ok', '86.254.27.65');
INSERT INTO log VALUES (819, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:22:54', 'ok', '86.254.27.65');
INSERT INTO log VALUES (820, 'admindemo', 'col-sampleList', '2017-09-24 17:23:14', 'ok', '86.254.27.65');
INSERT INTO log VALUES (821, 'admindemo', 'col-sampleTypeList', '2017-09-24 17:23:32', 'ok', '86.254.27.65');
INSERT INTO log VALUES (822, 'admindemo', 'col-sampleTypeChange', '2017-09-24 17:23:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (823, 'admindemo', 'col-sampleTypeList', '2017-09-24 17:23:55', 'ok', '86.254.27.65');
INSERT INTO log VALUES (824, 'admindemo', 'col-sampleList', '2017-09-24 17:24:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (825, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:24:22', 'ok', '86.254.27.65');
INSERT INTO log VALUES (826, 'admindemo', 'col-sampleobjectIdentifierChange', '2017-09-24 17:24:28', 'ok', '86.254.27.65');
INSERT INTO log VALUES (827, 'admindemo', 'col-sampleobjectIdentifierWrite', '2017-09-24 17:24:32', 'ok', '86.254.27.65');
INSERT INTO log VALUES (828, 'admindemo', 'col-ObjectIdentifier-write', '2017-09-24 17:24:32', '1', '86.254.27.65');
INSERT INTO log VALUES (829, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:24:32', 'ok', '86.254.27.65');
INSERT INTO log VALUES (830, 'admindemo', 'col-sampleList', '2017-09-24 17:24:35', 'ok', '86.254.27.65');
INSERT INTO log VALUES (831, 'admindemo', 'col-sampleChange', '2017-09-24 17:25:28', 'ok', '86.254.27.65');
INSERT INTO log VALUES (832, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:25:29', 'ok', '86.254.27.65');
INSERT INTO log VALUES (833, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:25:57', 'ok', '86.254.27.65');
INSERT INTO log VALUES (834, 'admindemo', 'col-metadataList', '2017-09-24 17:26:53', 'ok', '86.254.27.65');
INSERT INTO log VALUES (835, 'admindemo', 'col-metadataChange', '2017-09-24 17:26:55', 'ok', '86.254.27.65');
INSERT INTO log VALUES (836, 'admindemo', 'col-metadataWrite', '2017-09-24 17:27:36', 'ok', '86.254.27.65');
INSERT INTO log VALUES (837, 'admindemo', 'col-Metadata-write', '2017-09-24 17:27:36', '4', '86.254.27.65');
INSERT INTO log VALUES (838, 'admindemo', 'col-metadataList', '2017-09-24 17:27:36', 'ok', '86.254.27.65');
INSERT INTO log VALUES (839, 'admindemo', 'col-sampleList', '2017-09-24 17:27:40', 'ok', '86.254.27.65');
INSERT INTO log VALUES (840, 'admindemo', 'col-sampleChange', '2017-09-24 17:27:44', 'ok', '86.254.27.65');
INSERT INTO log VALUES (841, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:27:45', 'ok', '86.254.27.65');
INSERT INTO log VALUES (842, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:27:52', 'ok', '86.254.27.65');
INSERT INTO log VALUES (843, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:30:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (844, 'admindemo', 'col-sampleWrite', '2017-09-24 17:34:08', 'ok', '86.254.27.65');
INSERT INTO log VALUES (845, 'admindemo', 'col-Sample-write', '2017-09-24 17:34:08', '100', '86.254.27.65');
INSERT INTO log VALUES (846, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:34:08', 'ok', '86.254.27.65');
INSERT INTO log VALUES (847, 'admindemo', 'col-metadataList', '2017-09-24 17:34:22', 'ok', '86.254.27.65');
INSERT INTO log VALUES (848, 'admindemo', 'col-metadataChange', '2017-09-24 17:34:25', 'ok', '86.254.27.65');
INSERT INTO log VALUES (849, 'admindemo', 'col-metadataList', '2017-09-24 17:34:44', 'ok', '86.254.27.65');
INSERT INTO log VALUES (850, 'admindemo', 'col-metadataChange', '2017-09-24 17:34:46', 'ok', '86.254.27.65');
INSERT INTO log VALUES (851, 'admindemo', 'col-metadataWrite', '2017-09-24 17:35:18', 'ok', '86.254.27.65');
INSERT INTO log VALUES (852, 'admindemo', 'col-Metadata-write', '2017-09-24 17:35:18', '3', '86.254.27.65');
INSERT INTO log VALUES (853, 'admindemo', 'col-metadataList', '2017-09-24 17:35:18', 'ok', '86.254.27.65');
INSERT INTO log VALUES (854, 'admindemo', 'col-sampleList', '2017-09-24 17:35:23', 'ok', '86.254.27.65');
INSERT INTO log VALUES (855, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:35:34', 'ok', '86.254.27.65');
INSERT INTO log VALUES (856, 'admindemo', 'col-sampleChange', '2017-09-24 17:36:08', 'ok', '86.254.27.65');
INSERT INTO log VALUES (857, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:36:09', 'ok', '86.254.27.65');
INSERT INTO log VALUES (858, 'admindemo', 'col-sampleWrite', '2017-09-24 17:36:23', 'ok', '86.254.27.65');
INSERT INTO log VALUES (859, 'admindemo', 'col-Sample-write', '2017-09-24 17:36:23', '94', '86.254.27.65');
INSERT INTO log VALUES (860, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:36:23', 'ok', '86.254.27.65');
INSERT INTO log VALUES (861, 'admindemo', 'col-sampleList', '2017-09-24 17:36:36', 'ok', '86.254.27.65');
INSERT INTO log VALUES (862, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:36:43', 'ok', '86.254.27.65');
INSERT INTO log VALUES (863, 'admindemo', 'col-sampleChange', '2017-09-24 17:36:46', 'ok', '86.254.27.65');
INSERT INTO log VALUES (864, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:36:47', 'ok', '86.254.27.65');
INSERT INTO log VALUES (865, 'admindemo', 'col-sampleWrite', '2017-09-24 17:37:05', 'ok', '86.254.27.65');
INSERT INTO log VALUES (866, 'admindemo', 'col-Sample-write', '2017-09-24 17:37:05', '100', '86.254.27.65');
INSERT INTO log VALUES (867, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:37:05', 'ok', '86.254.27.65');
INSERT INTO log VALUES (868, 'admindemo', 'col-sampleList', '2017-09-24 17:37:13', 'ok', '86.254.27.65');
INSERT INTO log VALUES (869, 'admindemo', 'col-sampleChange', '2017-09-24 17:37:40', 'ok', '86.254.27.65');
INSERT INTO log VALUES (870, 'admindemo', 'col-sampleTypeMetadata', '2017-09-24 17:37:41', 'ok', '86.254.27.65');
INSERT INTO log VALUES (871, 'admindemo', 'col-sampleWrite', '2017-09-24 17:41:34', 'ok', '86.254.27.65');
INSERT INTO log VALUES (872, 'admindemo', 'col-Sample-write', '2017-09-24 17:41:34', '101', '86.254.27.65');
INSERT INTO log VALUES (873, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:41:34', 'ok', '86.254.27.65');
INSERT INTO log VALUES (874, 'admindemo', 'col-sampleobjectIdentifierChange', '2017-09-24 17:41:42', 'ok', '86.254.27.65');
INSERT INTO log VALUES (875, 'admindemo', 'col-sampleobjectIdentifierWrite', '2017-09-24 17:41:46', 'ok', '86.254.27.65');
INSERT INTO log VALUES (876, 'admindemo', 'col-ObjectIdentifier-write', '2017-09-24 17:41:46', '2', '86.254.27.65');
INSERT INTO log VALUES (877, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:41:46', 'ok', '86.254.27.65');
INSERT INTO log VALUES (878, 'admindemo', 'col-sampleList', '2017-09-24 17:41:49', 'ok', '86.254.27.65');
INSERT INTO log VALUES (879, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:42:10', 'ok', '86.254.27.65');
INSERT INTO log VALUES (880, 'admindemo', 'col-sampleobjectIdentifierChange', '2017-09-24 17:42:13', 'ok', '86.254.27.65');
INSERT INTO log VALUES (881, 'admindemo', 'col-sampleobjectIdentifierWrite', '2017-09-24 17:42:17', 'ok', '86.254.27.65');
INSERT INTO log VALUES (882, 'admindemo', 'col-ObjectIdentifier-write', '2017-09-24 17:42:17', '3', '86.254.27.65');
INSERT INTO log VALUES (883, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:42:17', 'ok', '86.254.27.65');
INSERT INTO log VALUES (884, 'admindemo', 'col-sampleList', '2017-09-24 17:42:28', 'ok', '86.254.27.65');
INSERT INTO log VALUES (885, 'admindemo', 'col-projectList', '2017-09-24 17:42:52', 'ok', '86.254.27.65');
INSERT INTO log VALUES (886, 'admindemo', 'col-projectChange', '2017-09-24 17:43:04', 'ok', '86.254.27.65');
INSERT INTO log VALUES (887, 'admindemo', 'col-projectWrite', '2017-09-24 17:43:10', 'ok', '86.254.27.65');
INSERT INTO log VALUES (888, 'admindemo', 'col-Project-write', '2017-09-24 17:43:10', '1', '86.254.27.65');
INSERT INTO log VALUES (889, 'admindemo', 'col-projectList', '2017-09-24 17:43:10', 'ok', '86.254.27.65');
INSERT INTO log VALUES (890, 'admindemo', 'col-sampleList', '2017-09-24 17:43:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (891, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:43:22', 'ok', '86.254.27.65');
INSERT INTO log VALUES (892, 'admindemo', 'col-sampleList', '2017-09-24 17:44:16', 'ok', '86.254.27.65');
INSERT INTO log VALUES (893, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:44:23', 'ok', '86.254.27.65');
INSERT INTO log VALUES (894, 'admindemo', 'col-sampleList', '2017-09-24 17:44:35', 'ok', '86.254.27.65');
INSERT INTO log VALUES (895, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:44:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (896, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:44:53', 'ok', '86.254.27.65');
INSERT INTO log VALUES (897, 'admindemo', 'col-projectList', '2017-09-24 17:45:05', 'ok', '86.254.27.65');
INSERT INTO log VALUES (898, 'admindemo', 'col-projectChange', '2017-09-24 17:45:17', 'ok', '86.254.27.65');
INSERT INTO log VALUES (899, 'admindemo', 'col-projectDelete', '2017-09-24 17:45:21', 'ok', '86.254.27.65');
INSERT INTO log VALUES (900, 'admindemo', 'col-Project-delete', '2017-09-24 17:45:21', '2', '86.254.27.65');
INSERT INTO log VALUES (901, 'admindemo', 'col-projectList', '2017-09-24 17:45:21', 'ok', '86.254.27.65');
INSERT INTO log VALUES (902, 'admindemo', 'col-projectChange', '2017-09-24 17:45:32', 'ok', '86.254.27.65');
INSERT INTO log VALUES (903, 'admindemo', 'col-projectWrite', '2017-09-24 17:45:35', 'ok', '86.254.27.65');
INSERT INTO log VALUES (904, 'admindemo', 'col-Project-write', '2017-09-24 17:45:35', '1', '86.254.27.65');
INSERT INTO log VALUES (905, 'admindemo', 'col-projectList', '2017-09-24 17:45:35', 'ok', '86.254.27.65');
INSERT INTO log VALUES (906, 'admindemo', 'col-sampleList', '2017-09-24 17:45:39', 'ok', '86.254.27.65');
INSERT INTO log VALUES (907, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:45:43', 'ok', '86.254.27.65');
INSERT INTO log VALUES (908, 'admindemo', 'col-loginList', '2017-09-24 17:46:02', 'ok', '86.254.27.65');
INSERT INTO log VALUES (909, 'admin', 'col-connexion', '2017-09-24 17:46:17', 'db-ok', '86.254.27.65');
INSERT INTO log VALUES (910, 'admindemo', 'col-loginList', '2017-09-24 17:46:17', 'ok', '86.254.27.65');
INSERT INTO log VALUES (911, 'admindemo', 'col-aclloginList', '2017-09-24 17:46:31', 'ok', '86.254.27.65');
INSERT INTO log VALUES (912, 'admindemo', 'col-groupList', '2017-09-24 17:46:42', 'ok', '86.254.27.65');
INSERT INTO log VALUES (913, 'admindemo', 'col-aclloginList', '2017-09-24 17:47:06', 'ok', '86.254.27.65');
INSERT INTO log VALUES (914, 'admindemo', 'col-aclloginChange', '2017-09-24 17:47:09', 'ok', '86.254.27.65');
INSERT INTO log VALUES (915, 'admindemo', 'col-loginList', '2017-09-24 17:47:16', 'ok', '86.254.27.65');
INSERT INTO log VALUES (916, 'admindemo', 'col-loginChange', '2017-09-24 17:47:17', 'ok', '86.254.27.65');
INSERT INTO log VALUES (917, 'admindemo', 'col-loginWrite', '2017-09-24 17:48:00', 'ok', '86.254.27.65');
INSERT INTO log VALUES (918, 'admindemo', 'col-LoginGestion-write', '2017-09-24 17:48:00', '2', '86.254.27.65');
INSERT INTO log VALUES (919, 'admindemo', 'col-loginList', '2017-09-24 17:48:00', 'ok', '86.254.27.65');
INSERT INTO log VALUES (920, 'admindemo', 'col-loginChange', '2017-09-24 17:48:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (921, 'admindemo', 'col-loginWrite', '2017-09-24 17:49:25', 'ok', '86.254.27.65');
INSERT INTO log VALUES (922, 'admindemo', 'col-LoginGestion-write', '2017-09-24 17:49:25', '3', '86.254.27.65');
INSERT INTO log VALUES (923, 'admindemo', 'col-loginList', '2017-09-24 17:49:25', 'ok', '86.254.27.65');
INSERT INTO log VALUES (924, 'admindemo', 'col-groupList', '2017-09-24 17:49:32', 'ok', '86.254.27.65');
INSERT INTO log VALUES (925, 'admindemo', 'col-groupChange', '2017-09-24 17:49:44', 'ok', '86.254.27.65');
INSERT INTO log VALUES (926, 'admindemo', 'col-groupWrite', '2017-09-24 17:49:50', 'ok', '86.254.27.65');
INSERT INTO log VALUES (927, 'admindemo', 'col-Aclgroup-write', '2017-09-24 17:49:50', '5', '86.254.27.65');
INSERT INTO log VALUES (928, 'admindemo', 'col-groupList', '2017-09-24 17:49:50', 'ok', '86.254.27.65');
INSERT INTO log VALUES (929, 'admindemo', 'col-projectList', '2017-09-24 17:49:57', 'ok', '86.254.27.65');
INSERT INTO log VALUES (930, 'admindemo', 'col-projectChange', '2017-09-24 17:50:04', 'ok', '86.254.27.65');
INSERT INTO log VALUES (931, 'admindemo', 'col-projectWrite', '2017-09-24 17:50:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (932, 'admindemo', 'col-Project-write', '2017-09-24 17:50:19', '1', '86.254.27.65');
INSERT INTO log VALUES (933, 'admindemo', 'col-projectList', '2017-09-24 17:50:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (934, 'admindemo', 'col-projectChange', '2017-09-24 17:50:22', 'ok', '86.254.27.65');
INSERT INTO log VALUES (935, 'admindemo', 'col-projectWrite', '2017-09-24 17:50:26', 'ok', '86.254.27.65');
INSERT INTO log VALUES (936, 'admindemo', 'col-Project-write', '2017-09-24 17:50:26', '3', '86.254.27.65');
INSERT INTO log VALUES (937, 'admindemo', 'col-projectList', '2017-09-24 17:50:26', 'ok', '86.254.27.65');
INSERT INTO log VALUES (938, 'admindemo', 'col-sampleList', '2017-09-24 17:50:32', 'ok', '86.254.27.65');
INSERT INTO log VALUES (939, 'admindemo', 'col-sampleDisplay', '2017-09-24 17:50:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (940, 'admindemo', 'col-projectList', '2017-09-24 17:51:09', 'ok', '86.254.27.65');
INSERT INTO log VALUES (941, 'admindemo', 'col-sampleList', '2017-09-24 17:51:55', 'ok', '86.254.27.65');
INSERT INTO log VALUES (942, 'admindemo', 'col-labelList', '2017-09-24 17:52:32', 'ok', '86.254.27.65');
INSERT INTO log VALUES (943, 'admindemo', 'col-labelChange', '2017-09-24 17:52:43', 'ok', '86.254.27.65');
INSERT INTO log VALUES (944, 'admindemo', 'col-identifierTypeList', '2017-09-24 17:53:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (945, 'admindemo', 'col-identifierTypeChange', '2017-09-24 17:53:40', 'ok', '86.254.27.65');
INSERT INTO log VALUES (946, 'admindemo', 'col-identifierTypeList', '2017-09-24 17:53:42', 'ok', '86.254.27.65');
INSERT INTO log VALUES (947, 'admindemo', 'col-containerList', '2017-09-24 17:54:05', 'ok', '86.254.27.65');
INSERT INTO log VALUES (948, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 17:54:06', 'ok', '86.254.27.65');
INSERT INTO log VALUES (949, 'admindemo', 'col-containerDisplay', '2017-09-24 17:55:02', 'ok', '86.254.27.65');
INSERT INTO log VALUES (950, 'admindemo', 'col-containerobjectIdentifierChange', '2017-09-24 17:55:06', 'ok', '86.254.27.65');
INSERT INTO log VALUES (951, 'admindemo', 'col-containerobjectIdentifierWrite', '2017-09-24 17:55:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (952, 'admindemo', 'col-ObjectIdentifier-write', '2017-09-24 17:55:19', '4', '86.254.27.65');
INSERT INTO log VALUES (953, 'admindemo', 'col-containerDisplay', '2017-09-24 17:55:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (954, 'admindemo', 'col-containerobjectIdentifierChange', '2017-09-24 17:55:28', 'ok', '86.254.27.65');
INSERT INTO log VALUES (955, 'admindemo', 'col-containerobjectIdentifierWrite', '2017-09-24 17:55:32', 'ok', '86.254.27.65');
INSERT INTO log VALUES (956, 'admindemo', 'col-ObjectIdentifier-write', '2017-09-24 17:55:32', '4', '86.254.27.65');
INSERT INTO log VALUES (957, 'admindemo', 'col-containerDisplay', '2017-09-24 17:55:32', 'ok', '86.254.27.65');
INSERT INTO log VALUES (958, 'admindemo', 'col-containerobjectIdentifierChange', '2017-09-24 17:55:46', 'ok', '86.254.27.65');
INSERT INTO log VALUES (959, 'admindemo', 'col-containerobjectIdentifierWrite', '2017-09-24 17:55:55', 'ok', '86.254.27.65');
INSERT INTO log VALUES (960, 'admindemo', 'col-ObjectIdentifier-write', '2017-09-24 17:55:55', '4', '86.254.27.65');
INSERT INTO log VALUES (961, 'admindemo', 'col-containerDisplay', '2017-09-24 17:55:55', 'ok', '86.254.27.65');
INSERT INTO log VALUES (962, 'admindemo', 'col-containerList', '2017-09-24 17:55:58', 'ok', '86.254.27.65');
INSERT INTO log VALUES (963, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 17:55:59', 'ok', '86.254.27.65');
INSERT INTO log VALUES (964, 'admindemo', 'col-containerPrintLabel', '2017-09-24 17:57:12', 'ok', '86.254.27.65');
INSERT INTO log VALUES (965, 'admindemo', 'col-containerList', '2017-09-24 17:57:12', 'ok', '86.254.27.65');
INSERT INTO log VALUES (966, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 17:57:13', 'ok', '86.254.27.65');
INSERT INTO log VALUES (967, 'admindemo', 'col-containerPrintLabel', '2017-09-24 17:57:37', 'ok', '86.254.27.65');
INSERT INTO log VALUES (968, 'admindemo', 'col-containerPrintLabel', '2017-09-24 17:57:51', 'ok', '86.254.27.65');
INSERT INTO log VALUES (969, 'admindemo', 'col-containerPrintLabel', '2017-09-24 17:58:09', 'ok', '86.254.27.65');
INSERT INTO log VALUES (970, 'admindemo', 'col-containerList', '2017-09-24 17:58:09', 'ok', '86.254.27.65');
INSERT INTO log VALUES (971, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 17:58:09', 'ok', '86.254.27.65');
INSERT INTO log VALUES (972, 'admindemo', 'col-containerPrintLabel', '2017-09-24 17:58:45', 'ok', '86.254.27.65');
INSERT INTO log VALUES (973, 'admindemo', 'col-containerPrintLabel', '2017-09-24 17:59:03', 'ok', '86.254.27.65');
INSERT INTO log VALUES (974, 'admindemo', 'col-containerList', '2017-09-24 17:59:03', 'ok', '86.254.27.65');
INSERT INTO log VALUES (975, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 17:59:04', 'ok', '86.254.27.65');
INSERT INTO log VALUES (976, 'admindemo', 'col-containerDisplay', '2017-09-24 17:59:46', 'ok', '86.254.27.65');
INSERT INTO log VALUES (977, 'admindemo', 'col-containerPrintLabel', '2017-09-24 17:59:50', 'ok', '86.254.27.65');
INSERT INTO log VALUES (978, 'admindemo', 'col-containerList', '2017-09-24 17:59:50', 'ok', '86.254.27.65');
INSERT INTO log VALUES (979, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 17:59:51', 'ok', '86.254.27.65');
INSERT INTO log VALUES (980, 'admindemo', 'col-containerPrintLabel', '2017-09-24 18:00:03', 'ok', '86.254.27.65');
INSERT INTO log VALUES (981, 'admindemo', 'col-containerPrintLabel', '2017-09-24 18:00:07', 'ok', '86.254.27.65');
INSERT INTO log VALUES (982, 'admindemo', 'col-containerPrintLabel', '2017-09-24 18:00:24', 'ok', '86.254.27.65');
INSERT INTO log VALUES (983, 'admindemo', 'col-containerList', '2017-09-24 18:00:24', 'ok', '86.254.27.65');
INSERT INTO log VALUES (984, 'admindemo', 'col-containerTypeGetFromFamily', '2017-09-24 18:00:25', 'ok', '86.254.27.65');
INSERT INTO log VALUES (985, 'admindemo', 'col-sampleList', '2017-09-24 18:00:30', 'ok', '86.254.27.65');
INSERT INTO log VALUES (986, 'admindemo', 'col-samplePrintLabel', '2017-09-24 18:03:40', 'ok', '86.254.27.65');
INSERT INTO log VALUES (987, 'admindemo', 'col-sampleList', '2017-09-24 18:03:52', 'ok', '86.254.27.65');
INSERT INTO log VALUES (988, 'admindemo', 'col-samplePrintLabel', '2017-09-24 18:04:18', 'ok', '86.254.27.65');
INSERT INTO log VALUES (989, 'admindemo', 'col-sampleList', '2017-09-24 18:04:30', 'ok', '86.254.27.65');
INSERT INTO log VALUES (990, 'admindemo', 'col-samplePrintLabel', '2017-09-24 18:04:36', 'ok', '86.254.27.65');
INSERT INTO log VALUES (991, 'admindemo', 'col-samplePrintLabel', '2017-09-24 18:04:53', 'ok', '86.254.27.65');
INSERT INTO log VALUES (992, 'admindemo', 'col-sampleList', '2017-09-24 18:05:23', 'ok', '86.254.27.65');
INSERT INTO log VALUES (993, 'admindemo', 'col-samplePrintLabel', '2017-09-24 18:05:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (994, 'admindemo', 'col-samplePrintLabel', '2017-09-24 18:05:42', 'ok', '86.254.27.65');
INSERT INTO log VALUES (995, 'admindemo', 'col-sampleList', '2017-09-24 18:05:50', 'ok', '86.254.27.65');
INSERT INTO log VALUES (996, 'admindemo', 'col-samplePrintLabel', '2017-09-24 18:06:13', 'ok', '86.254.27.65');
INSERT INTO log VALUES (997, 'admindemo', 'col-samplePrintLabel', '2017-09-24 18:06:26', 'ok', '86.254.27.65');
INSERT INTO log VALUES (998, 'admindemo', 'col-sampleList', '2017-09-24 18:06:52', 'ok', '86.254.27.65');
INSERT INTO log VALUES (999, 'admindemo', 'col-labelList', '2017-09-24 18:07:04', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1000, 'admindemo', 'col-labelChange', '2017-09-24 18:07:13', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1001, 'admindemo', 'col-metadataGetschema', '2017-09-24 18:07:28', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1002, 'admindemo', 'col-labelWrite', '2017-09-24 18:07:30', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1003, 'admindemo', 'col-Label-write', '2017-09-24 18:07:30', '4', '86.254.27.65');
INSERT INTO log VALUES (1004, 'admindemo', 'col-labelList', '2017-09-24 18:07:30', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1005, 'admindemo', 'col-labelChange', '2017-09-24 18:07:35', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1006, 'admindemo', 'col-metadataGetschema', '2017-09-24 18:07:43', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1007, 'admindemo', 'col-metadataGetschema', '2017-09-24 18:08:06', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1008, 'admindemo', 'col-labelWrite', '2017-09-24 18:08:15', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1009, 'admindemo', 'col-Label-write', '2017-09-24 18:08:15', '5', '86.254.27.65');
INSERT INTO log VALUES (1010, 'admindemo', 'col-labelList', '2017-09-24 18:08:15', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1011, 'admindemo', 'col-labelChange', '2017-09-24 18:08:26', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1012, 'admindemo', 'col-metadataGetschema', '2017-09-24 18:08:26', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1013, 'admindemo', 'col-labelWrite', '2017-09-24 18:08:41', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1014, 'admindemo', 'col-Label-write', '2017-09-24 18:08:41', '4', '86.254.27.65');
INSERT INTO log VALUES (1015, 'admindemo', 'col-labelList', '2017-09-24 18:08:41', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1016, 'admindemo', 'col-labelChange', '2017-09-24 18:08:45', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1017, 'admindemo', 'col-metadataGetschema', '2017-09-24 18:08:45', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1018, 'admindemo', 'col-labelWrite', '2017-09-24 18:10:37', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1019, 'admindemo', 'col-Label-write', '2017-09-24 18:10:38', '4', '86.254.27.65');
INSERT INTO log VALUES (1020, 'admindemo', 'col-labelList', '2017-09-24 18:10:38', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1021, 'admindemo', 'col-labelChange', '2017-09-24 18:10:46', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1022, 'admindemo', 'col-metadataGetschema', '2017-09-24 18:10:47', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1023, 'admindemo', 'col-labelWrite', '2017-09-24 18:13:15', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1024, 'admindemo', 'col-Label-write', '2017-09-24 18:13:15', '5', '86.254.27.65');
INSERT INTO log VALUES (1025, 'admindemo', 'col-labelList', '2017-09-24 18:13:15', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1026, 'admindemo', 'col-labelChange', '2017-09-24 18:13:24', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1027, 'admindemo', 'col-metadataGetschema', '2017-09-24 18:13:25', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1028, 'admindemo', 'col-labelWrite', '2017-09-24 18:15:13', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1029, 'admindemo', 'col-Label-write', '2017-09-24 18:15:13', '5', '86.254.27.65');
INSERT INTO log VALUES (1030, 'admindemo', 'col-labelList', '2017-09-24 18:15:13', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1031, 'admindemo', 'col-sampleList', '2017-09-24 18:16:10', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1032, 'admindemo', 'col-samplePrintLabel', '2017-09-24 18:37:31', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1033, 'admindemo', 'col-samplePrintLabel', '2017-09-24 18:37:47', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1034, 'admindemo', 'col-sampleList', '2017-09-24 18:38:37', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1035, 'admindemo', 'col-samplePrintLabel', '2017-09-24 18:38:56', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1036, 'admindemo', 'col-sampleList', '2017-09-24 18:39:34', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1037, 'admindemo', 'col-labelList', '2017-09-24 18:39:49', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1038, 'admindemo', 'col-labelChange', '2017-09-24 18:40:10', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1039, 'admindemo', 'col-metadataGetschema', '2017-09-24 18:40:10', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1040, 'admindemo', 'col-labelList', '2017-09-24 18:41:28', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1041, 'admindemo', 'col-labelChange', '2017-09-24 18:42:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1042, 'admindemo', 'col-metadataGetschema', '2017-09-24 18:42:11', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1043, 'admindemo', 'col-labelWrite', '2017-09-24 18:43:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1044, 'admindemo', 'col-Label-write', '2017-09-24 18:43:19', '5', '86.254.27.65');
INSERT INTO log VALUES (1045, 'admindemo', 'col-labelList', '2017-09-24 18:43:19', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1046, 'admindemo', 'col-sampleList', '2017-09-24 18:43:47', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1047, 'admindemo', 'col-samplePrintLabel', '2017-09-24 18:44:14', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1048, 'admindemo', 'col-samplePrintLabel', '2017-09-24 18:44:29', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1049, 'admindemo', 'col-sampleList', '2017-09-24 18:44:49', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1050, 'admindemo', 'col-metadataList', '2017-09-24 18:44:55', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1051, 'admindemo', 'col-metadataChange', '2017-09-24 18:45:12', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1052, 'admindemo', 'col-metadataList', '2017-09-24 18:47:18', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1053, 'admindemo', 'col-metadataChange', '2017-09-24 18:47:30', 'ok', '86.254.27.65');
INSERT INTO log VALUES (1054, 'unknown', 'col-default', '2017-09-25 10:10:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1055, 'unknown', 'col-connexion', '2017-09-25 10:10:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1056, 'admin', 'col-connexion', '2017-09-25 10:10:35', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1057, 'admin', 'col-default', '2017-09-25 10:10:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1058, 'admin', 'col-sampleList', '2017-09-25 10:10:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1059, 'admin', 'col-sampleList', '2017-09-25 10:10:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1060, 'admin', 'col-samplingPlaceList', '2017-09-25 10:11:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1061, 'unknown', 'col-default', '2017-09-25 10:13:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1062, 'unknown', 'col-default', '2017-09-25 10:56:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1063, 'unknown', 'col-connexion', '2017-09-25 10:56:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1064, 'admin', 'col-connexion', '2017-09-25 10:56:42', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1065, 'admin', 'col-default', '2017-09-25 10:56:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1066, 'admin', 'col-labelList', '2017-09-25 10:56:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1067, 'admin', 'col-labelChange', '2017-09-25 10:56:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1068, 'admin', 'col-metadataGetschema', '2017-09-25 10:56:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1069, 'admin', 'col-labelWrite', '2017-09-25 10:57:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1070, 'admin', 'col-Label-write', '2017-09-25 10:57:46', '9', '10.4.2.103');
INSERT INTO log VALUES (1071, 'admin', 'col-labelList', '2017-09-25 10:57:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1072, 'admin', 'col-sampleList', '2017-09-25 10:57:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1073, 'admin', 'col-sampleList', '2017-09-25 10:58:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1074, 'admin', 'col-samplePrintLabel', '2017-09-25 10:58:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1075, 'admin', 'col-labelChange', '2017-09-25 10:59:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1076, 'admin', 'col-metadataGetschema', '2017-09-25 10:59:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1077, 'admin', 'col-labelWrite', '2017-09-25 11:04:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1078, 'admin', 'col-Label-write', '2017-09-25 11:04:30', '9', '10.4.2.103');
INSERT INTO log VALUES (1079, 'admin', 'col-labelList', '2017-09-25 11:04:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1080, 'admin', 'col-samplePrintLabel', '2017-09-25 11:04:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1081, 'admin', 'col-labelChange', '2017-09-25 11:05:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1082, 'admin', 'col-metadataGetschema', '2017-09-25 11:05:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1083, 'admin', 'col-labelWrite', '2017-09-25 11:06:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1084, 'admin', 'col-Label-write', '2017-09-25 11:06:01', '9', '10.4.2.103');
INSERT INTO log VALUES (1085, 'admin', 'col-labelList', '2017-09-25 11:06:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1086, 'admin', 'col-samplePrintLabel', '2017-09-25 11:06:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1087, 'admin', 'col-labelChange', '2017-09-25 11:06:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1088, 'admin', 'col-metadataGetschema', '2017-09-25 11:06:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1089, 'admin', 'col-labelWrite', '2017-09-25 11:08:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1090, 'admin', 'col-Label-write', '2017-09-25 11:08:40', '9', '10.4.2.103');
INSERT INTO log VALUES (1091, 'admin', 'col-labelList', '2017-09-25 11:08:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1092, 'admin', 'col-samplePrintLabel', '2017-09-25 11:08:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1093, 'admin', 'col-labelChange', '2017-09-25 11:09:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1094, 'admin', 'col-metadataGetschema', '2017-09-25 11:09:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1095, 'admin', 'col-labelWrite', '2017-09-25 11:10:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1096, 'admin', 'col-Label-write', '2017-09-25 11:10:07', '9', '10.4.2.103');
INSERT INTO log VALUES (1097, 'admin', 'col-labelList', '2017-09-25 11:10:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1098, 'admin', 'col-samplePrintLabel', '2017-09-25 11:10:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1099, 'admin', 'col-labelChange', '2017-09-25 11:11:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1100, 'admin', 'col-metadataGetschema', '2017-09-25 11:11:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1101, 'admin', 'col-labelWrite', '2017-09-25 11:11:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1102, 'admin', 'col-Label-write', '2017-09-25 11:11:40', '9', '10.4.2.103');
INSERT INTO log VALUES (1103, 'admin', 'col-labelList', '2017-09-25 11:11:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1104, 'admin', 'col-samplePrintLabel', '2017-09-25 11:11:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1105, 'admin', 'col-samplePrintLabel', '2017-09-25 11:11:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1106, 'admin', 'col-labelChange', '2017-09-25 11:12:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1107, 'admin', 'col-metadataGetschema', '2017-09-25 11:12:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1108, 'admin', 'col-labelWrite', '2017-09-25 11:13:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1109, 'admin', 'col-Label-write', '2017-09-25 11:13:02', '9', '10.4.2.103');
INSERT INTO log VALUES (1110, 'admin', 'col-labelList', '2017-09-25 11:13:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1111, 'admin', 'col-samplePrintLabel', '2017-09-25 11:13:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1112, 'admin', 'col-labelChange', '2017-09-25 11:13:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1113, 'admin', 'col-metadataGetschema', '2017-09-25 11:13:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1114, 'admin', 'col-sampleDisplay', '2017-09-25 11:19:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1115, 'admin', 'col-sampleChange', '2017-09-25 11:20:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1116, 'admin', 'col-sampleTypeMetadata', '2017-09-25 11:20:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1117, 'admin', 'col-sampleWrite', '2017-09-25 11:21:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1118, 'admin', 'col-Sample-write', '2017-09-25 11:21:30', '7', '10.4.2.103');
INSERT INTO log VALUES (1119, 'admin', 'col-sampleDisplay', '2017-09-25 11:21:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1120, 'admin', 'col-sampleList', '2017-09-25 11:21:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1121, 'admin', 'col-samplePrintLabel', '2017-09-25 11:21:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1122, 'unknown', 'col-sampleList', '2017-09-25 13:08:09', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (1123, 'admin', 'col-connexion', '2017-09-25 13:08:12', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1124, 'admin', 'col-sampleList', '2017-09-25 13:08:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1125, 'admin', 'col-sampleList', '2017-09-25 13:08:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1126, 'admin', 'col-sampleDisplay', '2017-09-25 13:08:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1127, 'admin', 'col-sampleDisplay', '2017-09-25 13:09:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1128, 'admin', 'col-sampleDisplay', '2017-09-25 13:09:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1129, 'admin', 'col-connexion', '2017-09-25 13:51:13', 'token-ok', '10.4.2.103');
INSERT INTO log VALUES (1130, 'admin', 'col-labelList', '2017-09-25 13:51:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1131, 'admin', 'col-labelChange', '2017-09-25 13:51:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1132, 'admin', 'col-metadataGetschema', '2017-09-25 13:51:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1133, 'admin', 'col-sampleList', '2017-09-25 13:58:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1134, 'admin', 'col-sampleList', '2017-09-25 13:58:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1135, 'admin', 'col-samplePrintLabel', '2017-09-25 13:59:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1136, 'admin', 'col-labelList', '2017-09-25 14:05:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1137, 'admin', 'col-labelChange', '2017-09-25 14:05:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1138, 'admin', 'col-metadataGetschema', '2017-09-25 14:05:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1139, 'admin', 'col-labelWrite', '2017-09-25 14:08:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1140, 'admin', 'col-Label-write', '2017-09-25 14:08:12', '5', '10.4.2.103');
INSERT INTO log VALUES (1141, 'admin', 'col-labelList', '2017-09-25 14:08:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1142, 'admin', 'col-samplePrintLabel', '2017-09-25 14:08:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1143, 'admin', 'col-labelChange', '2017-09-25 14:08:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1144, 'admin', 'col-metadataGetschema', '2017-09-25 14:08:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1145, 'admin', 'col-default', '2017-09-25 14:09:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1146, 'admin', 'col-labelList', '2017-09-25 14:09:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1147, 'admin', 'col-labelChange', '2017-09-25 14:09:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1148, 'admin', 'col-metadataGetschema', '2017-09-25 14:09:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1149, 'admin', 'col-labelWrite', '2017-09-25 14:09:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1150, 'admin', 'col-Label-write', '2017-09-25 14:09:45', '5', '10.4.2.103');
INSERT INTO log VALUES (1151, 'admin', 'col-labelList', '2017-09-25 14:09:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1152, 'admin', 'col-samplePrintLabel', '2017-09-25 14:09:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1153, 'admin', 'col-labelChange', '2017-09-25 14:11:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1154, 'admin', 'col-metadataGetschema', '2017-09-25 14:11:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1155, 'admin', 'col-labelWrite', '2017-09-25 14:12:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1156, 'admin', 'col-Label-write', '2017-09-25 14:12:01', '5', '10.4.2.103');
INSERT INTO log VALUES (1157, 'admin', 'col-labelList', '2017-09-25 14:12:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1158, 'admin', 'col-samplePrintLabel', '2017-09-25 14:12:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1159, 'admin', 'col-labelChange', '2017-09-25 14:12:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1160, 'admin', 'col-metadataGetschema', '2017-09-25 14:12:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1161, 'admin', 'col-labelWrite', '2017-09-25 14:16:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1162, 'admin', 'col-Label-write', '2017-09-25 14:16:44', '5', '10.4.2.103');
INSERT INTO log VALUES (1163, 'admin', 'col-labelList', '2017-09-25 14:16:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1164, 'admin', 'col-samplePrintLabel', '2017-09-25 14:16:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1165, 'admin', 'col-labelChange', '2017-09-25 14:17:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1166, 'admin', 'col-metadataGetschema', '2017-09-25 14:17:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1167, 'admin', 'col-labelWrite', '2017-09-25 14:18:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1168, 'admin', 'col-Label-write', '2017-09-25 14:18:10', '5', '10.4.2.103');
INSERT INTO log VALUES (1169, 'admin', 'col-labelList', '2017-09-25 14:18:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1170, 'admin', 'col-samplePrintLabel', '2017-09-25 14:18:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1171, 'admin', 'col-labelChange', '2017-09-25 14:19:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1172, 'admin', 'col-metadataGetschema', '2017-09-25 14:19:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1173, 'admin', 'col-labelWrite', '2017-09-25 14:20:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1174, 'admin', 'col-Label-write', '2017-09-25 14:20:28', '5', '10.4.2.103');
INSERT INTO log VALUES (1175, 'admin', 'col-labelList', '2017-09-25 14:20:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1176, 'admin', 'col-samplePrintLabel', '2017-09-25 14:20:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1177, 'admin', 'col-labelChange', '2017-09-25 14:20:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1178, 'admin', 'col-metadataGetschema', '2017-09-25 14:20:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1179, 'admin', 'col-labelWrite', '2017-09-25 14:21:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1180, 'admin', 'col-Label-write', '2017-09-25 14:21:56', '5', '10.4.2.103');
INSERT INTO log VALUES (1181, 'admin', 'col-labelList', '2017-09-25 14:21:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1182, 'admin', 'col-samplePrintLabel', '2017-09-25 14:22:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1183, 'admin', 'col-labelChange', '2017-09-25 14:22:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1184, 'admin', 'col-metadataGetschema', '2017-09-25 14:22:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1185, 'admin', 'col-labelWrite', '2017-09-25 14:23:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1186, 'admin', 'col-Label-write', '2017-09-25 14:23:27', '5', '10.4.2.103');
INSERT INTO log VALUES (1187, 'admin', 'col-labelList', '2017-09-25 14:23:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1188, 'admin', 'col-samplePrintLabel', '2017-09-25 14:23:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1189, 'admin', 'col-labelChange', '2017-09-25 14:23:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1190, 'admin', 'col-metadataGetschema', '2017-09-25 14:23:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1191, 'admin', 'col-labelWrite', '2017-09-25 14:24:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1192, 'admin', 'col-Label-write', '2017-09-25 14:24:15', '5', '10.4.2.103');
INSERT INTO log VALUES (1193, 'admin', 'col-labelList', '2017-09-25 14:24:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1194, 'admin', 'col-samplePrintLabel', '2017-09-25 14:24:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1195, 'admin', 'col-labelChange', '2017-09-25 14:25:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1196, 'admin', 'col-metadataGetschema', '2017-09-25 14:25:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1197, 'admin', 'col-labelWrite', '2017-09-25 14:25:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1198, 'admin', 'col-Label-write', '2017-09-25 14:25:53', '5', '10.4.2.103');
INSERT INTO log VALUES (1199, 'admin', 'col-labelList', '2017-09-25 14:25:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1200, 'admin', 'col-samplePrintLabel', '2017-09-25 14:25:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1201, 'unknown', 'col-default', '2017-09-25 14:28:08', 'ok', '195.83.247.50');
INSERT INTO log VALUES (1202, 'unknown', 'col-disconnect-ipaddress-changed', '2017-09-25 14:28:13', 'old:195.83.247.50-new:195.83.247.53', '195.83.247.53');
INSERT INTO log VALUES (1203, 'unknown', 'col-connexion', '2017-09-25 14:28:13', 'ok', '195.83.247.53');
INSERT INTO log VALUES (1204, 'admindemo', 'col-connexion', '2017-09-25 14:34:36', 'db-ko', '195.83.247.51');
INSERT INTO log VALUES (1205, 'unknown', 'col-default', '2017-09-25 14:34:36', 'ok', '195.83.247.51');
INSERT INTO log VALUES (1206, 'unknown', 'col-disconnect-ipaddress-changed', '2017-09-25 14:34:41', 'old:195.83.247.51-new:195.83.247.162', '195.83.247.162');
INSERT INTO log VALUES (1207, 'unknown', 'col-connexion', '2017-09-25 14:34:41', 'ok', '195.83.247.162');
INSERT INTO log VALUES (1208, 'unknown', 'col-default', '2017-09-25 14:35:56', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1209, 'unknown', 'col-connexion', '2017-09-25 14:35:58', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1210, 'admindemo', 'col-connexion', '2017-09-25 14:36:59', 'db-ko', '193.54.246.132');
INSERT INTO log VALUES (1211, 'unknown', 'col-default', '2017-09-25 14:36:59', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1212, 'unknown', 'col-objets', '2017-09-25 14:37:02', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1213, 'unknown', 'col-connexion', '2017-09-25 14:37:05', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1214, 'unknown', 'col-default', '2017-09-25 15:35:30', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1215, 'unknown', 'col-connexion', '2017-09-25 15:35:37', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1216, 'cpignol', 'col-connexion', '2017-09-25 15:35:56', 'db-ok', '193.48.126.37');
INSERT INTO log VALUES (1217, 'cpignol', 'col-default', '2017-09-25 15:35:56', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1218, 'unknown', 'col-disconnect', '2017-09-25 15:40:25', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1219, 'unknown', 'col-connexion', '2017-09-25 15:40:28', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1220, 'cpignol', 'col-connexion', '2017-09-25 15:40:32', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1221, 'cpignol', 'col-default', '2017-09-25 15:40:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1222, 'cpignol', 'col-sampleList', '2017-09-25 15:40:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1223, 'cpignol', 'col-sampleList', '2017-09-25 15:40:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1224, 'cpignol', 'col-projectList', '2017-09-25 15:40:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1225, 'cpignol', 'col-disconnect', '2017-09-25 15:41:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1226, 'unknown', 'col-connexion', '2017-09-25 15:44:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1227, 'admin', 'col-connexion', '2017-09-25 15:44:45', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1228, 'admin', 'col-default', '2017-09-25 15:44:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1229, 'admin', 'col-groupList', '2017-09-25 15:44:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1230, 'admin', 'col-connexion', '2017-09-25 15:45:03', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1231, 'admin', 'col-groupList', '2017-09-25 15:45:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1232, 'admin', 'col-groupChange', '2017-09-25 15:45:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1233, 'admin', 'col-groupWrite', '2017-09-25 15:45:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1234, 'admin', 'col-Aclgroup-write', '2017-09-25 15:45:42', '6', '10.4.2.103');
INSERT INTO log VALUES (1235, 'admin', 'col-groupList', '2017-09-25 15:45:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1236, 'admin', 'col-groupChange', '2017-09-25 15:45:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1237, 'admin', 'col-groupWrite', '2017-09-25 15:45:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1238, 'admin', 'col-Aclgroup-write', '2017-09-25 15:45:58', '7', '10.4.2.103');
INSERT INTO log VALUES (1239, 'admin', 'col-groupList', '2017-09-25 15:45:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1240, 'admin', 'col-projectList', '2017-09-25 15:46:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1241, 'admin', 'col-projectChange', '2017-09-25 15:46:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1242, 'admin', 'col-projectWrite', '2017-09-25 15:46:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1243, 'admin', 'col-Project-write', '2017-09-25 15:46:33', '1', '10.4.2.103');
INSERT INTO log VALUES (1244, 'admin', 'col-projectList', '2017-09-25 15:46:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1245, 'admin', 'col-projectChange', '2017-09-25 15:46:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1246, 'admin', 'col-projectWrite', '2017-09-25 15:46:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1247, 'admin', 'col-Project-write', '2017-09-25 15:46:44', '3', '10.4.2.103');
INSERT INTO log VALUES (1248, 'admin', 'col-projectList', '2017-09-25 15:46:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1249, 'admin', 'col-sampleList', '2017-09-25 15:46:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1250, 'admin', 'col-sampleList', '2017-09-25 15:46:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1251, 'admin', 'col-sampleDisplay', '2017-09-25 15:47:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1252, 'admin', 'col-sampleList', '2017-09-25 15:47:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1253, 'admin', 'col-sampleDisplay', '2017-09-25 15:47:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1254, 'admin', 'col-sampleList', '2017-09-25 15:47:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1255, 'admin', 'col-sampleDisplay', '2017-09-25 15:48:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1256, 'admin', 'col-sampleList', '2017-09-25 15:48:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1257, 'admin', 'col-sampleList', '2017-09-25 15:50:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1258, 'admin', 'col-sampleDisplay', '2017-09-25 15:50:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1259, 'admin', 'col-sampleDisplay', '2017-09-25 15:50:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1260, 'admin', 'col-sampleChange', '2017-09-25 15:50:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1261, 'admin', 'col-sampleTypeMetadata', '2017-09-25 15:50:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1262, 'admin', 'col-sampleWrite', '2017-09-25 15:51:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1263, 'admin', 'col-Sample-write', '2017-09-25 15:51:11', '4', '10.4.2.103');
INSERT INTO log VALUES (1264, 'admin', 'col-sampleDisplay', '2017-09-25 15:51:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1265, 'admin', 'col-sampleList', '2017-09-25 15:51:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1266, 'admin', 'col-sampleDisplay', '2017-09-25 15:51:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1267, 'admin', 'col-sampleList', '2017-09-25 15:51:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1268, 'admin', 'col-sampleDisplay', '2017-09-25 15:53:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1269, 'admin', 'col-sampleChange', '2017-09-25 15:53:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1270, 'admin', 'col-sampleTypeMetadata', '2017-09-25 15:53:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1271, 'admin', 'col-sampleWrite', '2017-09-25 15:53:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1272, 'admin', 'col-Sample-write', '2017-09-25 15:53:54', '5', '10.4.2.103');
INSERT INTO log VALUES (1273, 'admin', 'col-sampleDisplay', '2017-09-25 15:53:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1274, 'admin', 'col-sampleChange', '2017-09-25 15:53:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1275, 'admin', 'col-sampleTypeMetadata', '2017-09-25 15:53:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1276, 'admin', 'col-sampleWrite', '2017-09-25 15:54:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1277, 'admin', 'col-Sample-write', '2017-09-25 15:54:11', '5', '10.4.2.103');
INSERT INTO log VALUES (1278, 'admin', 'col-sampleDisplay', '2017-09-25 15:54:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1279, 'admin', 'col-sampleList', '2017-09-25 15:54:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1280, 'admin', 'col-sampleDisplay', '2017-09-25 15:54:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1281, 'admin', 'col-sampleChange', '2017-09-25 15:54:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1282, 'admin', 'col-sampleTypeMetadata', '2017-09-25 15:54:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1283, 'admin', 'col-sampleWrite', '2017-09-25 15:54:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1284, 'admin', 'col-Sample-write', '2017-09-25 15:54:46', '6', '10.4.2.103');
INSERT INTO log VALUES (1285, 'admin', 'col-sampleDisplay', '2017-09-25 15:54:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1286, 'admin', 'col-sampleList', '2017-09-25 15:55:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1287, 'admin', 'col-disconnect', '2017-09-25 15:55:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1288, 'unknown', 'col-connexion', '2017-09-25 15:55:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1289, 'cpignol', 'col-connexion', '2017-09-25 15:55:42', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1290, 'cpignol', 'col-default', '2017-09-25 15:55:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1291, 'cpignol', 'col-sampleList', '2017-09-25 15:55:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1292, 'cpignol', 'col-sampleList', '2017-09-25 15:55:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1293, 'cpignol', 'col-sampleDisplay', '2017-09-25 15:55:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1294, 'cpignol', 'col-sampleList', '2017-09-25 15:56:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1295, 'cpignol', 'col-containerList', '2017-09-25 15:56:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1296, 'cpignol', 'col-containerTypeGetFromFamily', '2017-09-25 15:56:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1297, 'cpignol', 'col-disconnect', '2017-09-25 16:15:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1298, 'unknown', 'col-connexion', '2017-09-25 16:15:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1299, 'vbretagnolle', 'col-connexion', '2017-09-25 16:16:31', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1300, 'vbretagnolle', 'col-default', '2017-09-25 16:16:31', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1301, 'vbretagnolle', 'col-objets', '2017-09-25 16:16:34', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1302, 'vbretagnolle', 'col-sampleList', '2017-09-25 16:16:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1303, 'vbretagnolle', 'col-sampleList', '2017-09-25 16:16:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1304, 'vbretagnolle', 'col-sampleDisplay', '2017-09-25 16:16:46', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1305, 'vbretagnolle', 'col-sampleList', '2017-09-25 16:16:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1306, 'vbretagnolle', 'col-sampleList', '2017-09-25 16:16:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1307, 'vbretagnolle', 'col-objets', '2017-09-25 16:16:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1308, 'vbretagnolle', 'col-containerList', '2017-09-25 16:17:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1309, 'vbretagnolle', 'col-containerTypeGetFromFamily', '2017-09-25 16:17:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1310, 'vbretagnolle', 'col-importChange', '2017-09-25 16:17:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1311, 'vbretagnolle', 'col-fastInputChange', '2017-09-25 16:17:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1312, 'vbretagnolle', 'col-objectGetDetail', '2017-09-25 16:17:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1313, 'vbretagnolle', 'col-parametre', '2017-09-25 16:17:14', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1314, 'vbretagnolle', 'col-sampleTypeList', '2017-09-25 16:17:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1315, 'vbretagnolle', 'col-containerTypeList', '2017-09-25 16:17:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1316, 'vbretagnolle', 'col-disconnect', '2017-09-25 16:17:40', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1317, 'unknown', 'col-containerList', '2017-09-25 16:17:44', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (1318, 'admin', 'col-connexion', '2017-09-25 16:17:49', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1319, 'admin', 'col-containerList', '2017-09-25 16:17:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1320, 'admin', 'col-containerTypeGetFromFamily', '2017-09-25 16:17:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1321, 'admin', 'col-objets', '2017-09-25 16:18:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1322, 'admin', 'col-containerList', '2017-09-25 16:18:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1323, 'admin', 'col-containerTypeGetFromFamily', '2017-09-25 16:18:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1324, 'admin', 'col-containerTypeGetFromFamily', '2017-09-25 16:18:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1325, 'admin', 'col-containerList', '2017-09-25 16:18:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1326, 'admin', 'col-containerTypeGetFromFamily', '2017-09-25 16:18:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1327, 'admin', 'col-containerTypeGetFromFamily', '2017-09-25 16:19:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1328, 'admin', 'col-containerList', '2017-09-25 16:19:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1329, 'admin', 'col-containerTypeGetFromFamily', '2017-09-25 16:19:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1330, 'admin', 'col-containerTypeGetFromFamily', '2017-09-25 16:19:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1331, 'admin', 'col-disconnect', '2017-09-25 16:19:32', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1332, 'unknown', 'col-containerList', '2017-09-25 16:19:35', 'nologin', '10.4.2.103');
INSERT INTO log VALUES (1333, 'cpignol', 'col-connexion', '2017-09-25 16:19:42', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1334, 'cpignol', 'col-containerList', '2017-09-25 16:19:42', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1335, 'cpignol', 'col-containerTypeGetFromFamily', '2017-09-25 16:19:43', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1336, 'cpignol', 'col-containerTypeGetFromFamily', '2017-09-25 16:19:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1337, 'cpignol', 'col-containerList', '2017-09-25 16:19:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1338, 'cpignol', 'col-containerTypeGetFromFamily', '2017-09-25 16:19:52', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1339, 'cpignol', 'col-containerDisplay', '2017-09-25 16:21:04', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1340, 'cpignol', 'col-containerDisplay', '2017-09-25 16:22:33', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1341, 'unknown', 'col-default', '2017-09-25 16:24:25', 'ok', '195.83.247.162');
INSERT INTO log VALUES (1342, 'unknown', 'col-disconnect-ipaddress-changed', '2017-09-25 16:24:28', 'old:195.83.247.162-new:195.83.247.51', '195.83.247.51');
INSERT INTO log VALUES (1343, 'unknown', 'col-connexion', '2017-09-25 16:24:28', 'ok', '195.83.247.51');
INSERT INTO log VALUES (1344, 'cpignol', 'col-containerDisplay', '2017-09-25 16:24:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1345, 'cpignol', 'col-connexion', '2017-09-25 16:24:53', 'db-ok', '195.83.247.53');
INSERT INTO log VALUES (1346, 'cpignol', 'col-default', '2017-09-25 16:24:53', 'ok', '195.83.247.53');
INSERT INTO log VALUES (1347, 'cpignol', 'col-disconnect-ipaddress-changed', '2017-09-25 16:24:56', 'old:195.83.247.53-new:195.83.247.50', '195.83.247.50');
INSERT INTO log VALUES (1348, 'cpignol', 'col-connexion', '2017-09-25 16:24:56', 'token-ok', '195.83.247.50');
INSERT INTO log VALUES (1349, 'cpignol', 'col-sampleList', '2017-09-25 16:24:56', 'ok', '195.83.247.50');
INSERT INTO log VALUES (1350, 'unknown', 'col-sampleList', '2017-09-25 16:25:03', 'nologin', '195.83.247.53');
INSERT INTO log VALUES (1351, 'unknown', 'col-disconnect-ipaddress-changed', '2017-09-25 16:25:20', 'old:195.83.247.53-new:195.83.247.162', '195.83.247.162');
INSERT INTO log VALUES (1352, 'unknown', 'col-connexion', '2017-09-25 16:25:20', 'HEADER-ko', '195.83.247.162');
INSERT INTO log VALUES (1353, 'unknown', 'col-sampleList', '2017-09-25 16:25:20', 'nologin', '195.83.247.162');
INSERT INTO log VALUES (1354, 'unknown', 'col-connexion', '2017-09-25 16:25:25', 'ok', '195.83.247.162');
INSERT INTO log VALUES (1355, 'unknown', 'col-disconnect-ipaddress-changed', '2017-09-25 16:25:38', 'old:195.83.247.162-new:195.83.247.51', '195.83.247.51');
INSERT INTO log VALUES (1356, 'unknown', 'col-connexion', '2017-09-25 16:25:38', 'HEADER-ko', '195.83.247.51');
INSERT INTO log VALUES (1357, 'unknown', 'col-default', '2017-09-25 16:25:38', 'ok', '195.83.247.51');
INSERT INTO log VALUES (1358, 'unknown', 'col-sampleList', '2017-09-25 16:25:42', 'nologin', '195.83.247.162');
INSERT INTO log VALUES (1359, 'unknown', 'col-default', '2017-09-25 16:25:46', 'ok', '195.83.247.162');
INSERT INTO log VALUES (1360, 'unknown', 'col-disconnect-ipaddress-changed', '2017-09-25 16:25:51', 'old:195.83.247.162-new:195.83.247.50', '195.83.247.50');
INSERT INTO log VALUES (1361, 'unknown', 'col-connexion', '2017-09-25 16:25:51', 'ok', '195.83.247.50');
INSERT INTO log VALUES (1362, 'cpignol', 'col-sampleTypeList', '2017-09-25 16:25:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1363, 'cpignol', 'col-containerTypeList', '2017-09-25 16:26:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1364, 'cpignol', 'col-connexion', '2017-09-25 16:26:13', 'db-ok', '195.83.247.50');
INSERT INTO log VALUES (1365, 'cpignol', 'col-default', '2017-09-25 16:26:13', 'ok', '195.83.247.50');
INSERT INTO log VALUES (1366, 'cpignol', 'col-containerTypeChange', '2017-09-25 16:26:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1367, 'cpignol', 'col-disconnect-ipaddress-changed', '2017-09-25 16:26:29', 'old:195.83.247.50-new:195.83.247.162', '195.83.247.162');
INSERT INTO log VALUES (1368, 'unknown', 'col-sampleList', '2017-09-25 16:26:29', 'nologin', '195.83.247.162');
INSERT INTO log VALUES (1369, 'cpignol', 'col-containerTypeWrite', '2017-09-25 16:26:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1370, 'cpignol', 'col-ContainerType-write', '2017-09-25 16:26:30', '6', '10.4.2.103');
INSERT INTO log VALUES (1371, 'cpignol', 'col-containerTypeList', '2017-09-25 16:26:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1372, 'unknown', 'col-default', '2017-09-25 16:26:35', 'ok', '195.83.247.162');
INSERT INTO log VALUES (1373, 'unknown', 'col-connexion', '2017-09-25 16:26:37', 'ok', '195.83.247.162');
INSERT INTO log VALUES (1374, 'cpignol', 'col-connexion', '2017-09-25 16:26:44', 'db-ok', '195.83.247.162');
INSERT INTO log VALUES (1375, 'cpignol', 'col-default', '2017-09-25 16:26:44', 'ok', '195.83.247.162');
INSERT INTO log VALUES (1376, 'cpignol', 'col-disconnect-ipaddress-changed', '2017-09-25 16:26:51', 'old:195.83.247.162-new:195.83.247.51', '195.83.247.51');
INSERT INTO log VALUES (1377, 'cpignol', 'col-connexion', '2017-09-25 16:26:51', 'token-ok', '195.83.247.51');
INSERT INTO log VALUES (1378, 'cpignol', 'col-containerList', '2017-09-25 16:26:51', 'ok', '195.83.247.51');
INSERT INTO log VALUES (1379, 'unknown', 'col-containerTypeGetFromFamily', '2017-09-25 16:26:52', 'nologin', '195.83.247.162');
INSERT INTO log VALUES (1380, 'unknown', 'col-disconnect-ipaddress-changed', '2017-09-25 16:27:05', 'old:195.83.247.162-new:195.83.247.50', '195.83.247.50');
INSERT INTO log VALUES (1381, 'unknown', 'col-fastOutputChange', '2017-09-25 16:27:05', 'nologin', '195.83.247.50');
INSERT INTO log VALUES (1382, 'cpignol', 'col-connexion', '2017-09-25 16:27:12', 'db-ok', '195.83.247.53');
INSERT INTO log VALUES (1383, 'cpignol', 'col-fastOutputChange', '2017-09-25 16:27:12', 'ok', '195.83.247.53');
INSERT INTO log VALUES (1384, 'cpignol', 'col-objectGetDetail', '2017-09-25 16:27:38', 'ok', '195.83.247.53');
INSERT INTO log VALUES (1385, 'cpignol', 'col-objets', '2017-09-25 16:30:26', 'ok', '195.83.247.53');
INSERT INTO log VALUES (1386, 'cpignol', 'col-sampleList', '2017-09-25 16:30:29', 'ok', '195.83.247.53');
INSERT INTO log VALUES (1387, 'cpignol', 'col-disconnect-ipaddress-changed', '2017-09-25 16:30:32', 'old:195.83.247.53-new:195.83.247.51', '195.83.247.51');
INSERT INTO log VALUES (1388, 'cpignol', 'col-connexion', '2017-09-25 16:30:32', 'token-ok', '195.83.247.51');
INSERT INTO log VALUES (1389, 'cpignol', 'col-sampleList', '2017-09-25 16:30:32', 'ok', '195.83.247.51');
INSERT INTO log VALUES (1390, 'unknown', 'col-sampleDisplay', '2017-09-25 16:30:43', 'nologin', '195.83.247.51');
INSERT INTO log VALUES (1391, 'unknown', 'col-disconnect-ipaddress-changed', '2017-09-25 16:30:51', 'old:195.83.247.51-new:195.83.247.162', '195.83.247.162');
INSERT INTO log VALUES (1392, 'unknown', 'col-connexion', '2017-09-25 16:30:51', 'HEADER-ko', '195.83.247.162');
INSERT INTO log VALUES (1393, 'unknown', 'col-sampleDisplay', '2017-09-25 16:30:51', 'nologin', '195.83.247.162');
INSERT INTO log VALUES (1394, 'unknown', 'col-sampleList', '2017-09-25 16:30:53', 'nologin', '195.83.247.50');
INSERT INTO log VALUES (1395, 'cpignol', 'col-connexion', '2017-09-25 16:30:59', 'db-ok', '195.83.247.50');
INSERT INTO log VALUES (1396, 'cpignol', 'col-sampleList', '2017-09-25 16:30:59', 'ok', '195.83.247.50');
INSERT INTO log VALUES (1397, 'cpignol', 'col-disconnect-ipaddress-changed', '2017-09-25 16:31:01', 'old:195.83.247.50-new:195.83.247.51', '195.83.247.51');
INSERT INTO log VALUES (1398, 'cpignol', 'col-connexion', '2017-09-25 16:31:01', 'token-ok', '195.83.247.51');
INSERT INTO log VALUES (1399, 'cpignol', 'col-sampleList', '2017-09-25 16:31:01', 'ok', '195.83.247.51');
INSERT INTO log VALUES (1400, 'unknown', 'col-sampleDisplay', '2017-09-25 16:31:06', 'nologin', '195.83.247.50');
INSERT INTO log VALUES (1401, 'unknown', 'col-disconnect-ipaddress-changed', '2017-09-25 16:31:17', 'old:195.83.247.50-new:195.83.247.53', '195.83.247.53');
INSERT INTO log VALUES (1402, 'unknown', 'col-connexion', '2017-09-25 16:31:17', 'HEADER-ko', '195.83.247.53');
INSERT INTO log VALUES (1403, 'unknown', 'col-sampleDisplay', '2017-09-25 16:31:17', 'nologin', '195.83.247.53');
INSERT INTO log VALUES (1404, 'unknown', 'col-connexion', '2017-09-25 16:31:21', 'ok', '195.83.247.53');
INSERT INTO log VALUES (1405, 'unknown', 'col-disconnect-ipaddress-changed', '2017-09-25 16:31:25', 'old:195.83.247.53-new:195.83.247.50', '195.83.247.50');
INSERT INTO log VALUES (1406, 'unknown', 'col-connexion', '2017-09-25 16:31:25', 'HEADER-ko', '195.83.247.50');
INSERT INTO log VALUES (1407, 'unknown', 'col-default', '2017-09-25 16:31:25', 'ok', '195.83.247.50');
INSERT INTO log VALUES (1408, 'cpignol', 'col-connexion', '2017-09-25 16:31:30', 'db-ok', '195.83.247.50');
INSERT INTO log VALUES (1409, 'cpignol', 'col-default', '2017-09-25 16:31:30', 'ok', '195.83.247.50');
INSERT INTO log VALUES (1410, 'cpignol', 'col-sampleList', '2017-09-25 16:31:32', 'ok', '195.83.247.50');
INSERT INTO log VALUES (1411, 'cpignol', 'col-disconnect-ipaddress-changed', '2017-09-25 16:31:34', 'old:195.83.247.50-new:195.83.247.162', '195.83.247.162');
INSERT INTO log VALUES (1412, 'cpignol', 'col-connexion', '2017-09-25 16:31:34', 'token-ok', '195.83.247.162');
INSERT INTO log VALUES (1413, 'cpignol', 'col-sampleList', '2017-09-25 16:31:34', 'ok', '195.83.247.162');
INSERT INTO log VALUES (1414, 'unknown', 'col-sampleDisplay', '2017-09-25 16:31:40', 'nologin', '195.83.247.162');
INSERT INTO log VALUES (1415, 'unknown', 'col-disconnect-ipaddress-changed', '2017-09-25 16:31:44', 'old:195.83.247.162-new:195.83.247.50', '195.83.247.50');
INSERT INTO log VALUES (1416, 'unknown', 'col-objets', '2017-09-25 16:31:44', 'ok', '195.83.247.50');
INSERT INTO log VALUES (1417, 'unknown', 'col-objets', '2017-09-25 16:31:46', 'ok', '195.83.247.53');
INSERT INTO log VALUES (1418, 'unknown', 'col-disconnect-ipaddress-changed', '2017-09-25 16:31:47', 'old:195.83.247.53-new:195.83.247.162', '195.83.247.162');
INSERT INTO log VALUES (1419, 'unknown', 'col-objets', '2017-09-25 16:31:47', 'ok', '195.83.247.162');
INSERT INTO log VALUES (1420, 'unknown', 'col-loginChangePassword', '2017-09-25 16:31:50', 'ok', '195.83.247.50');
INSERT INTO log VALUES (1421, 'unknown', 'col-disconnect-ipaddress-changed', '2017-09-25 16:31:55', 'old:195.83.247.50-new:195.83.247.162', '195.83.247.162');
INSERT INTO log VALUES (1422, 'unknown', 'col-connexion', '2017-09-25 16:31:55', 'HEADER-ko', '195.83.247.162');
INSERT INTO log VALUES (1423, 'unknown', 'col-default', '2017-09-25 16:31:55', 'ok', '195.83.247.162');
INSERT INTO log VALUES (1424, 'unknown', 'col-sampleList', '2017-09-25 16:31:57', 'nologin', '195.83.247.162');
INSERT INTO log VALUES (1425, 'cpignol', 'col-containerList', '2017-09-25 16:32:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1426, 'unknown', 'col-sampleList', '2017-09-25 16:32:01', 'nologin', '195.83.247.162');
INSERT INTO log VALUES (1427, 'cpignol', 'col-containerTypeGetFromFamily', '2017-09-25 16:32:01', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1428, 'unknown', 'col-disconnect-ipaddress-changed', '2017-09-25 16:32:02', 'old:195.83.247.162-new:195.83.247.51', '195.83.247.51');
INSERT INTO log VALUES (1429, 'unknown', 'col-connexion', '2017-09-25 16:32:02', 'ok', '195.83.247.51');
INSERT INTO log VALUES (1430, 'cpignol', 'col-containerDisplay', '2017-09-25 16:32:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1431, 'unknown', 'col-connexion', '2017-09-25 16:32:03', 'ok', '195.83.247.51');
INSERT INTO log VALUES (1432, 'unknown', 'col-disconnect-ipaddress-changed', '2017-09-25 16:32:04', 'old:195.83.247.51-new:195.83.247.162', '195.83.247.162');
INSERT INTO log VALUES (1433, 'unknown', 'col-connexion', '2017-09-25 16:32:04', 'ok', '195.83.247.162');
INSERT INTO log VALUES (1434, 'unknown', 'col-connexion', '2017-09-25 16:32:04', 'ok', '195.83.247.162');
INSERT INTO log VALUES (1435, 'unknown', 'col-disconnect-ipaddress-changed', '2017-09-25 16:32:05', 'old:195.83.247.162-new:195.83.247.50', '195.83.247.50');
INSERT INTO log VALUES (1436, 'unknown', 'col-connexion', '2017-09-25 16:32:05', 'ok', '195.83.247.50');
INSERT INTO log VALUES (1437, 'unknown', 'col-connexion', '2017-09-25 16:32:05', 'ok', '195.83.247.53');
INSERT INTO log VALUES (1438, 'cpignol', 'col-containerDisplay', '2017-09-25 16:32:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1439, 'unknown', 'col-disconnect-ipaddress-changed', '2017-09-25 16:32:11', 'old:195.83.247.53-new:195.83.247.50', '195.83.247.50');
INSERT INTO log VALUES (1440, 'unknown', 'col-connexion', '2017-09-25 16:32:11', 'HEADER-ko', '195.83.247.50');
INSERT INTO log VALUES (1441, 'unknown', 'col-default', '2017-09-25 16:32:11', 'ok', '195.83.247.50');
INSERT INTO log VALUES (1442, 'cpignol', 'col-containerDisplay', '2017-09-25 16:32:15', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1443, 'unknown', 'col-default', '2017-09-25 16:32:20', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1444, 'unknown', 'col-connexion', '2017-09-25 16:32:22', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1445, 'cpignol', 'col-connexion', '2017-09-25 16:32:32', 'db-ok', '193.54.246.132');
INSERT INTO log VALUES (1446, 'cpignol', 'col-default', '2017-09-25 16:32:32', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1447, 'cpignol', 'col-sampleList', '2017-09-25 16:32:36', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1448, 'cpignol', 'col-sampleList', '2017-09-25 16:32:38', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1449, 'cpignol', 'col-sampleDisplay', '2017-09-25 16:32:43', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1450, 'cpignol', 'col-samplePrintDirect', '2017-09-25 16:33:04', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1451, 'cpignol', 'col-sampleList', '2017-09-25 16:33:05', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1452, 'cpignol', 'col-sampleList', '2017-09-25 16:33:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1453, 'cpignol', 'col-sampleList', '2017-09-25 16:33:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1454, 'cpignol', 'col-connexion', '2017-09-25 16:33:23', 'db-ok', '195.83.247.162');
INSERT INTO log VALUES (1455, 'cpignol', 'col-default', '2017-09-25 16:33:23', 'ok', '195.83.247.162');
INSERT INTO log VALUES (1548, 'cpignol', 'col-samplePrintLabel', '2017-09-25 16:54:52', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1456, 'cpignol', 'col-disconnect-ipaddress-changed', '2017-09-25 16:33:26', 'old:195.83.247.162-new:195.83.247.51', '195.83.247.51');
INSERT INTO log VALUES (1457, 'cpignol', 'col-connexion', '2017-09-25 16:33:26', 'token-ok', '195.83.247.51');
INSERT INTO log VALUES (1458, 'cpignol', 'col-sampleList', '2017-09-25 16:33:26', 'ok', '195.83.247.51');
INSERT INTO log VALUES (1459, 'unknown', 'col-sampleList', '2017-09-25 16:33:28', 'nologin', '195.83.247.50');
INSERT INTO log VALUES (1460, 'cpignol', 'col-sampleDisplay', '2017-09-25 16:33:44', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1461, 'cpignol', 'col-storagesampleInput', '2017-09-25 16:33:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1462, 'cpignol', 'col-containerTypeGetFromFamily', '2017-09-25 16:34:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1463, 'cpignol', 'col-containerGetFromType', '2017-09-25 16:34:10', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1464, 'cpignol', 'col-containerGetFromType', '2017-09-25 16:34:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1465, 'unknown', 'col-disconnect-ipaddress-changed', '2017-09-25 16:34:25', 'old:195.83.247.50-new:195.83.247.53', '195.83.247.53');
INSERT INTO log VALUES (1466, 'unknown', 'col-default', '2017-09-25 16:34:25', 'ok', '195.83.247.53');
INSERT INTO log VALUES (1467, 'unknown', 'col-default', '2017-09-25 16:34:35', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1468, 'unknown', 'col-connexion', '2017-09-25 16:34:44', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1469, 'cpignol', 'col-connexion', '2017-09-25 16:34:53', 'db-ok', '193.54.246.132');
INSERT INTO log VALUES (1470, 'cpignol', 'col-default', '2017-09-25 16:34:53', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1471, 'cpignol', 'col-sampleList', '2017-09-25 16:34:57', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1472, 'cpignol', 'col-sampleList', '2017-09-25 16:34:59', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1473, 'cpignol', 'col-sampleDisplay', '2017-09-25 16:35:03', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1474, 'cpignol', 'col-storagesampleWrite', '2017-09-25 16:35:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1475, 'cpignol', 'col-Storage-write', '2017-09-25 16:35:06', '87', '10.4.2.103');
INSERT INTO log VALUES (1476, 'cpignol', 'col-sampleDisplay', '2017-09-25 16:35:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1477, 'cpignol', 'col-samplePrintDirect', '2017-09-25 16:35:12', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1478, 'cpignol', 'col-sampleList', '2017-09-25 16:35:13', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1479, 'cpignol', 'col-containerDisplay', '2017-09-25 16:35:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1480, 'cpignol', 'col-samplePrintDirect', '2017-09-25 16:36:36', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1481, 'cpignol', 'col-sampleList', '2017-09-25 16:36:37', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1482, 'cpignol', 'col-sampleTypeList', '2017-09-25 16:39:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1483, 'cpignol', 'col-default', '2017-09-25 16:43:57', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1484, 'cpignol', 'col-sampleList', '2017-09-25 16:44:01', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1485, 'cpignol', 'col-sampleDisplay', '2017-09-25 16:44:05', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1486, 'cpignol', 'col-samplePrintDirect', '2017-09-25 16:44:10', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1487, 'cpignol', 'col-sampleList', '2017-09-25 16:44:11', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1488, 'cpignol', 'col-samplePrintLabel', '2017-09-25 16:44:16', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1489, 'cpignol', 'col-samplingPlaceList', '2017-09-25 16:45:38', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1490, 'cpignol', 'col-metadataList', '2017-09-25 16:45:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1491, 'cpignol', 'col-metadataChange', '2017-09-25 16:45:45', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1492, 'cpignol', 'col-metadataList', '2017-09-25 16:45:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1493, 'cpignol', 'col-metadataChange', '2017-09-25 16:46:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1494, 'cpignol', 'col-disconnect', '2017-09-25 16:46:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1495, 'unknown', 'col-connexion', '2017-09-25 16:46:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1496, 'admin', 'col-connexion', '2017-09-25 16:46:09', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1497, 'admin', 'col-default', '2017-09-25 16:46:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1498, 'admin', 'col-metadataList', '2017-09-25 16:46:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1499, 'admin', 'col-metadataChange', '2017-09-25 16:46:20', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1500, 'admin', 'col-metadataList', '2017-09-25 16:46:29', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1501, 'admin', 'col-metadataChange', '2017-09-25 16:46:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1502, 'admin', 'col-operationList', '2017-09-25 16:46:53', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1503, 'admin', 'col-operationChange', '2017-09-25 16:47:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1504, 'admin', 'col-metadataList', '2017-09-25 16:47:18', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1505, 'admin', 'col-metadataChange', '2017-09-25 16:47:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1506, 'admin', 'col-metadataList', '2017-09-25 16:47:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1507, 'admin', 'col-metadataChange', '2017-09-25 16:47:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1508, 'admin', 'col-disconnect', '2017-09-25 16:47:56', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1509, 'unknown', 'col-connexion', '2017-09-25 16:47:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1510, 'admin', 'col-connexion', '2017-09-25 16:48:02', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1511, 'admin', 'col-default', '2017-09-25 16:48:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1512, 'admin', 'col-metadataList', '2017-09-25 16:48:09', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1513, 'admin', 'col-metadataChange', '2017-09-25 16:48:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1514, 'admin', 'col-projectList', '2017-09-25 16:48:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1515, 'admin', 'col-groupList', '2017-09-25 16:48:36', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1516, 'admin', 'col-connexion', '2017-09-25 16:48:39', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1517, 'admin', 'col-groupList', '2017-09-25 16:48:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1518, 'admin', 'col-groupChange', '2017-09-25 16:49:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1519, 'admin', 'col-groupList', '2017-09-25 16:49:12', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1520, 'admin', 'col-groupChange', '2017-09-25 16:52:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1521, 'admin', 'col-groupWrite', '2017-09-25 16:52:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1522, 'admin', 'col-Aclgroup-write', '2017-09-25 16:52:51', '4', '10.4.2.103');
INSERT INTO log VALUES (1523, 'admin', 'col-groupList', '2017-09-25 16:52:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1524, 'admin', 'col-groupChange', '2017-09-25 16:52:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1525, 'admin', 'col-groupWrite', '2017-09-25 16:52:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1526, 'admin', 'col-Aclgroup-write', '2017-09-25 16:52:58', '4', '10.4.2.103');
INSERT INTO log VALUES (1527, 'admin', 'col-groupList', '2017-09-25 16:52:58', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1528, 'admin', 'col-groupChange', '2017-09-25 16:53:00', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1529, 'admin', 'col-groupWrite', '2017-09-25 16:53:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1530, 'admin', 'col-Aclgroup-write', '2017-09-25 16:53:02', '5', '10.4.2.103');
INSERT INTO log VALUES (1531, 'admin', 'col-groupList', '2017-09-25 16:53:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1532, 'admin', 'col-metadataList', '2017-09-25 16:53:07', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1533, 'admin', 'col-metadataChange', '2017-09-25 16:53:11', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1534, 'admin', 'col-metadataList', '2017-09-25 16:53:19', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1535, 'admin', 'col-metadataChange', '2017-09-25 16:53:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1536, 'admin', 'col-metadataList', '2017-09-25 16:53:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1537, 'admin', 'col-metadataChange', '2017-09-25 16:53:26', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1538, 'admin', 'col-metadataList', '2017-09-25 16:53:37', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1539, 'cpignol', 'col-default', '2017-09-25 16:53:57', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1540, 'cpignol', 'col-sampleList', '2017-09-25 16:53:59', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1541, 'cpignol', 'col-sampleDisplay', '2017-09-25 16:54:03', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1542, 'cpignol', 'col-samplePrintLabel', '2017-09-25 16:54:08', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1543, 'cpignol', 'col-sampleList', '2017-09-25 16:54:08', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1544, 'cpignol', 'col-samplePrintLabel', '2017-09-25 16:54:33', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1545, 'cpignol', 'col-samplePrintLabel', '2017-09-25 16:54:40', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1546, 'cpignol', 'col-sampleList', '2017-09-25 16:54:40', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1547, 'cpignol', 'col-samplePrintLabel', '2017-09-25 16:54:46', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1549, 'cpignol', 'col-sampleList', '2017-09-25 16:54:52', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1550, 'cpignol', 'col-samplePrintLabel', '2017-09-25 16:55:02', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1551, 'cpignol', 'col-samplePrintLabel', '2017-09-25 16:56:23', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1552, 'cpignol', 'col-sampleList', '2017-09-25 16:56:23', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1553, 'cpignol', 'col-fastInputChange', '2017-09-25 16:56:30', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1554, 'cpignol', 'col-objectGetDetail', '2017-09-25 16:56:35', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1555, 'cpignol', 'col-objectGetDetail', '2017-09-25 16:56:45', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1556, 'cpignol', 'col-objectGetDetail', '2017-09-25 16:56:50', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1557, 'cpignol', 'col-objectGetDetail', '2017-09-25 16:56:53', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1558, 'cpignol', 'col-objectGetDetail', '2017-09-25 16:56:55', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1559, 'cpignol', 'col-objectGetDetail', '2017-09-25 16:56:59', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1560, 'cpignol', 'col-connexion', '2017-09-25 16:57:02', 'token-ok', '193.48.126.37');
INSERT INTO log VALUES (1561, 'cpignol', 'col-sampleList', '2017-09-25 16:57:02', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1562, 'cpignol', 'col-objectGetDetail', '2017-09-25 16:57:05', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1563, 'cpignol', 'col-sampleList', '2017-09-25 16:57:06', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1564, 'cpignol', 'col-objectGetDetail', '2017-09-25 16:57:13', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1565, 'cpignol', 'col-objectGetDetail', '2017-09-25 16:57:15', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1566, 'cpignol', 'col-objectGetDetail', '2017-09-25 16:57:17', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1567, 'cpignol', 'col-sampleDisplay', '2017-09-25 16:57:21', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1568, 'cpignol', 'col-sampleList', '2017-09-25 16:57:24', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1569, 'cpignol', 'col-sampleDisplay', '2017-09-25 16:57:26', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1570, 'cpignol', 'col-storagesampleOutput', '2017-09-25 16:57:31', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1571, 'cpignol', 'col-fastOutputChange', '2017-09-25 16:57:32', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1572, 'cpignol', 'col-objectGetDetail', '2017-09-25 16:57:36', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1573, 'cpignol', 'col-objectGetDetail', '2017-09-25 16:57:38', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1574, 'cpignol', 'col-objectGetDetail', '2017-09-25 16:57:40', 'ok', '193.54.246.132');
INSERT INTO log VALUES (1575, 'cpignol', 'col-storageReasonList', '2017-09-25 16:57:48', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1576, 'cpignol', 'col-storageReasonChange', '2017-09-25 16:57:52', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1577, 'cpignol', 'col-storageReasonWrite', '2017-09-25 16:58:08', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1578, 'cpignol', 'col-StorageReason-write', '2017-09-25 16:58:08', '1', '193.48.126.37');
INSERT INTO log VALUES (1579, 'cpignol', 'col-storageReasonList', '2017-09-25 16:58:08', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1580, 'cpignol', 'col-storageReasonChange', '2017-09-25 16:58:11', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1581, 'cpignol', 'col-storageReasonWrite', '2017-09-25 16:58:42', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1582, 'cpignol', 'col-StorageReason-write', '2017-09-25 16:58:42', '2', '193.48.126.37');
INSERT INTO log VALUES (1583, 'cpignol', 'col-storageReasonList', '2017-09-25 16:58:42', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1584, 'cpignol', 'col-storageReasonChange', '2017-09-25 16:58:46', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1585, 'cpignol', 'col-storageReasonWrite', '2017-09-25 16:59:06', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1586, 'cpignol', 'col-StorageReason-write', '2017-09-25 16:59:06', '3', '193.48.126.37');
INSERT INTO log VALUES (1587, 'cpignol', 'col-storageReasonList', '2017-09-25 16:59:06', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1588, 'cpignol', 'col-storageReasonChange', '2017-09-25 16:59:08', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1589, 'cpignol', 'col-storageReasonWrite', '2017-09-25 16:59:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1590, 'cpignol', 'col-StorageReason-write', '2017-09-25 16:59:17', '4', '193.48.126.37');
INSERT INTO log VALUES (1591, 'cpignol', 'col-storageReasonList', '2017-09-25 16:59:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1592, 'cpignol', 'col-storageReasonChange', '2017-09-25 16:59:18', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1593, 'cpignol', 'col-storageReasonWrite', '2017-09-25 16:59:32', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1594, 'cpignol', 'col-StorageReason-write', '2017-09-25 16:59:32', '5', '193.48.126.37');
INSERT INTO log VALUES (1595, 'cpignol', 'col-storageReasonList', '2017-09-25 16:59:32', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1596, 'cpignol', 'col-storageReasonChange', '2017-09-25 16:59:34', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1597, 'cpignol', 'col-storageReasonWrite', '2017-09-25 16:59:49', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1598, 'cpignol', 'col-StorageReason-write', '2017-09-25 16:59:49', '6', '193.48.126.37');
INSERT INTO log VALUES (1599, 'cpignol', 'col-storageReasonList', '2017-09-25 16:59:49', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1600, 'cpignol', 'col-storageReasonChange', '2017-09-25 16:59:59', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1601, 'cpignol', 'col-storageReasonWrite', '2017-09-25 17:00:03', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1602, 'cpignol', 'col-StorageReason-write', '2017-09-25 17:00:03', '2', '193.48.126.37');
INSERT INTO log VALUES (1603, 'cpignol', 'col-storageReasonList', '2017-09-25 17:00:03', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1604, 'cpignol', 'col-objets', '2017-09-25 17:00:11', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1605, 'cpignol', 'col-sampleList', '2017-09-25 17:00:13', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1606, 'cpignol', 'col-sampleTypeMetadata', '2017-09-25 17:00:21', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1607, 'cpignol', 'col-sampleList', '2017-09-25 17:00:22', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1608, 'cpignol', 'col-sampleTypeMetadata', '2017-09-25 17:00:22', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1609, 'cpignol', 'col-sampleDisplay', '2017-09-25 17:01:19', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1610, 'cpignol', 'col-sampleList', '2017-09-25 17:01:21', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1611, 'cpignol', 'col-sampleTypeMetadata', '2017-09-25 17:01:21', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1612, 'cpignol', 'col-sampleDisplay', '2017-09-25 17:01:25', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1613, 'admin', 'col-labelList', '2017-09-25 17:01:30', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1614, 'cpignol', 'col-storagesampleOutput', '2017-09-25 17:01:31', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1615, 'cpignol', 'col-storagesampleWrite', '2017-09-25 17:01:50', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1616, 'cpignol', 'col-Storage-write', '2017-09-25 17:01:50', '88', '193.48.126.37');
INSERT INTO log VALUES (1617, 'cpignol', 'col-sampleDisplay', '2017-09-25 17:01:50', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1618, 'cpignol', 'col-parametre', '2017-09-25 17:02:07', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1619, 'cpignol', 'col-parametre', '2017-09-25 17:02:11', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1620, 'cpignol', 'col-parametre', '2017-09-25 17:02:12', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1621, 'cpignol', 'col-parametre', '2017-09-25 17:02:13', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1622, 'cpignol', 'col-storageReasonList', '2017-09-25 17:02:19', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1623, 'cpignol', 'col-storageReasonChange', '2017-09-25 17:02:28', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1624, 'cpignol', 'col-storageReasonList', '2017-09-25 17:02:52', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1625, 'cpignol', 'col-containerFamilyList', '2017-09-25 17:02:59', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1626, 'cpignol', 'col-containerFamilyChange', '2017-09-25 17:03:02', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1627, 'cpignol', 'col-containerFamilyList', '2017-09-25 17:03:04', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1628, 'cpignol', 'col-parametre', '2017-09-25 17:03:05', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1629, 'cpignol', 'col-parametre', '2017-09-25 17:03:06', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1630, 'cpignol', 'col-samplingPlaceList', '2017-09-25 17:03:15', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1631, 'cpignol', 'col-multipleTypeList', '2017-09-25 17:03:30', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1632, 'cpignol', 'col-multipleTypeChange', '2017-09-25 17:03:38', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1633, 'cpignol', 'col-multipleTypeWrite', '2017-09-25 17:03:41', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1634, 'cpignol', 'col-MultipleType-write', '2017-09-25 17:03:41', '5', '193.48.126.37');
INSERT INTO log VALUES (1635, 'cpignol', 'col-multipleTypeList', '2017-09-25 17:03:41', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1636, 'cpignol', 'col-multipleTypeChange', '2017-09-25 17:03:47', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1637, 'cpignol', 'col-multipleTypeWrite', '2017-09-25 17:04:11', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1638, 'cpignol', 'col-MultipleType-write', '2017-09-25 17:04:11', '5', '193.48.126.37');
INSERT INTO log VALUES (1639, 'cpignol', 'col-multipleTypeList', '2017-09-25 17:04:11', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1640, 'cpignol', 'col-protocolList', '2017-09-25 17:04:26', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1641, 'cpignol', 'col-operationList', '2017-09-25 17:04:52', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1642, 'cpignol', 'col-operationChange', '2017-09-25 17:06:44', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1643, 'cpignol', 'col-operationWrite', '2017-09-25 17:07:29', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1644, 'cpignol', 'col-Operation-write', '2017-09-25 17:07:29', '10', '193.48.126.37');
INSERT INTO log VALUES (1645, 'cpignol', 'col-operationList', '2017-09-25 17:07:29', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1646, 'cpignol', 'col-operationChange', '2017-09-25 17:07:46', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1647, 'cpignol', 'col-operationWrite', '2017-09-25 17:07:58', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1648, 'cpignol', 'col-Operation-write', '2017-09-25 17:07:58', '6', '193.48.126.37');
INSERT INTO log VALUES (1649, 'cpignol', 'col-operationList', '2017-09-25 17:07:58', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1650, 'cpignol', 'col-operationChange', '2017-09-25 17:08:07', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1651, 'cpignol', 'col-operationWrite', '2017-09-25 17:08:11', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1652, 'cpignol', 'col-Operation-write', '2017-09-25 17:08:11', '7', '193.48.126.37');
INSERT INTO log VALUES (1653, 'cpignol', 'col-operationList', '2017-09-25 17:08:11', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1654, 'cpignol', 'col-operationChange', '2017-09-25 17:08:22', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1655, 'cpignol', 'col-operationChange', '2017-09-25 17:08:32', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1656, 'cpignol', 'col-operationList', '2017-09-25 17:08:36', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1657, 'cpignol', 'col-operationChange', '2017-09-25 17:08:52', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1658, 'cpignol', 'col-operationWrite', '2017-09-25 17:09:01', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1659, 'cpignol', 'col-Operation-write', '2017-09-25 17:09:01', '4', '193.48.126.37');
INSERT INTO log VALUES (1660, 'cpignol', 'col-operationList', '2017-09-25 17:09:01', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1661, 'cpignol', 'col-operationChange', '2017-09-25 17:09:12', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1662, 'cpignol', 'col-operationWrite', '2017-09-25 17:09:15', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1663, 'cpignol', 'col-Operation-write', '2017-09-25 17:09:15', '4', '193.48.126.37');
INSERT INTO log VALUES (1664, 'cpignol', 'col-operationList', '2017-09-25 17:09:15', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1665, 'cpignol', 'col-operationChange', '2017-09-25 17:09:27', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1666, 'cpignol', 'col-operationWrite', '2017-09-25 17:09:30', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1667, 'cpignol', 'col-Operation-write', '2017-09-25 17:09:30', '1', '193.48.126.37');
INSERT INTO log VALUES (1668, 'cpignol', 'col-operationList', '2017-09-25 17:09:30', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1669, 'cpignol', 'col-operationChange', '2017-09-25 17:09:49', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1670, 'cpignol', 'col-operationWrite', '2017-09-25 17:09:53', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1671, 'cpignol', 'col-Operation-write', '2017-09-25 17:09:53', '2', '193.48.126.37');
INSERT INTO log VALUES (1672, 'cpignol', 'col-operationList', '2017-09-25 17:09:53', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1673, 'cpignol', 'col-operationList', '2017-09-25 17:10:21', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1674, 'cpignol', 'col-parametre', '2017-09-25 17:10:27', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1675, 'cpignol', 'col-protocolList', '2017-09-25 17:10:28', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1676, 'cpignol', 'col-parametre', '2017-09-25 17:10:33', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1677, 'cpignol', 'col-eventTypeList', '2017-09-25 17:10:36', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1678, 'cpignol', 'col-containerFamilyList', '2017-09-25 17:11:48', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1679, 'cpignol', 'col-containerFamilyChange', '2017-09-25 17:11:51', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1680, 'cpignol', 'col-storageConditionList', '2017-09-25 17:11:57', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1681, 'cpignol', 'col-storageConditionChange', '2017-09-25 17:12:06', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1682, 'cpignol', 'col-storageConditionWrite', '2017-09-25 17:12:13', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1683, 'cpignol', 'col-StorageCondition-write', '2017-09-25 17:12:13', '3', '193.48.126.37');
INSERT INTO log VALUES (1684, 'cpignol', 'col-storageConditionList', '2017-09-25 17:12:13', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1685, 'cpignol', 'col-storageConditionChange', '2017-09-25 17:12:15', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1686, 'cpignol', 'col-storageConditionWrite', '2017-09-25 17:12:22', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1687, 'cpignol', 'col-StorageCondition-write', '2017-09-25 17:12:22', '3', '193.48.126.37');
INSERT INTO log VALUES (1688, 'cpignol', 'col-storageConditionList', '2017-09-25 17:12:22', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1689, 'cpignol', 'col-storageConditionChange', '2017-09-25 17:12:24', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1690, 'cpignol', 'col-storageConditionWrite', '2017-09-25 17:12:35', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1691, 'cpignol', 'col-StorageCondition-write', '2017-09-25 17:12:35', '4', '193.48.126.37');
INSERT INTO log VALUES (1692, 'cpignol', 'col-storageConditionList', '2017-09-25 17:12:35', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1693, 'cpignol', 'col-storageConditionChange', '2017-09-25 17:12:45', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1694, 'cpignol', 'col-storageConditionWrite', '2017-09-25 17:12:54', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1695, 'cpignol', 'col-StorageCondition-write', '2017-09-25 17:12:54', '5', '193.48.126.37');
INSERT INTO log VALUES (1696, 'cpignol', 'col-storageConditionList', '2017-09-25 17:12:54', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1697, 'cpignol', 'col-storageConditionChange', '2017-09-25 17:12:56', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1698, 'cpignol', 'col-storageConditionWrite', '2017-09-25 17:13:06', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1699, 'cpignol', 'col-StorageCondition-write', '2017-09-25 17:13:06', '5', '193.48.126.37');
INSERT INTO log VALUES (1700, 'cpignol', 'col-storageConditionList', '2017-09-25 17:13:06', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1701, 'cpignol', 'col-storageConditionChange', '2017-09-25 17:13:14', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1702, 'cpignol', 'col-storageConditionWrite', '2017-09-25 17:13:18', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1703, 'cpignol', 'col-StorageCondition-write', '2017-09-25 17:13:18', '5', '193.48.126.37');
INSERT INTO log VALUES (1704, 'cpignol', 'col-storageConditionList', '2017-09-25 17:13:18', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1705, 'cpignol', 'col-storageReasonList', '2017-09-25 17:13:28', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1706, 'cpignol', 'col-eventTypeList', '2017-09-25 17:13:57', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1707, 'cpignol', 'col-storageReasonList', '2017-09-25 17:19:32', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1708, 'cpignol', 'col-storageReasonChange', '2017-09-25 17:20:03', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1709, 'cpignol', 'col-storageReasonWrite', '2017-09-25 17:20:12', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1710, 'cpignol', 'col-StorageReason-write', '2017-09-25 17:20:12', '1', '193.48.126.37');
INSERT INTO log VALUES (1711, 'cpignol', 'col-storageReasonList', '2017-09-25 17:20:12', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1712, 'cpignol', 'col-storageReasonChange', '2017-09-25 17:20:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1713, 'cpignol', 'col-storageReasonWrite', '2017-09-25 17:21:00', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1714, 'cpignol', 'col-StorageReason-write', '2017-09-25 17:21:00', '7', '193.48.126.37');
INSERT INTO log VALUES (1715, 'cpignol', 'col-storageReasonList', '2017-09-25 17:21:00', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1716, 'cpignol', 'col-storageReasonChange', '2017-09-25 17:21:14', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1717, 'cpignol', 'col-storageReasonDelete', '2017-09-25 17:21:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1718, 'cpignol', 'col-StorageReason-delete', '2017-09-25 17:21:17', '3', '193.48.126.37');
INSERT INTO log VALUES (1719, 'cpignol', 'col-storageReasonList', '2017-09-25 17:21:17', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1720, 'cpignol', 'col-storageReasonChange', '2017-09-25 17:21:48', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1721, 'cpignol', 'col-storageReasonWrite', '2017-09-25 17:22:04', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1722, 'cpignol', 'col-StorageReason-write', '2017-09-25 17:22:04', '4', '193.48.126.37');
INSERT INTO log VALUES (1723, 'cpignol', 'col-storageReasonList', '2017-09-25 17:22:04', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1724, 'cpignol', 'col-storageReasonChange', '2017-09-25 17:22:11', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1725, 'cpignol', 'col-storageReasonWrite', '2017-09-25 17:22:38', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1726, 'cpignol', 'col-StorageReason-write', '2017-09-25 17:22:38', '8', '193.48.126.37');
INSERT INTO log VALUES (1727, 'cpignol', 'col-storageReasonList', '2017-09-25 17:22:38', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1728, 'cpignol', 'col-storageReasonChange', '2017-09-25 17:22:53', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1729, 'cpignol', 'col-storageReasonWrite', '2017-09-25 17:23:27', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1730, 'cpignol', 'col-StorageReason-write', '2017-09-25 17:23:27', '5', '193.48.126.37');
INSERT INTO log VALUES (1731, 'cpignol', 'col-storageReasonList', '2017-09-25 17:23:27', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1732, 'cpignol', 'col-storageReasonChange', '2017-09-25 17:25:05', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1733, 'cpignol', 'col-storageReasonWrite', '2017-09-25 17:25:25', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1734, 'cpignol', 'col-StorageReason-write', '2017-09-25 17:25:25', '6', '193.48.126.37');
INSERT INTO log VALUES (1735, 'cpignol', 'col-storageReasonList', '2017-09-25 17:25:25', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1736, 'cpignol', 'col-parametre', '2017-09-25 17:25:41', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1737, 'cpignol', 'col-containerTypeList', '2017-09-25 17:25:48', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1738, 'cpignol', 'col-objectStatusList', '2017-09-25 17:26:51', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1739, 'cpignol', 'col-sampleTypeList', '2017-09-25 17:27:14', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1740, 'cpignol', 'col-sampleTypeChange', '2017-09-25 17:28:10', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1741, 'cpignol', 'col-multipleTypeList', '2017-09-25 17:29:00', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1742, 'cpignol', 'col-samplingPlaceList', '2017-09-25 17:29:12', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1743, 'cpignol', 'col-metadataList', '2017-09-25 17:29:38', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1744, 'cpignol', 'col-labelList', '2017-09-25 17:29:45', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1745, 'cpignol', 'col-identifierTypeList', '2017-09-25 17:30:09', 'ok', '193.48.126.37');
INSERT INTO log VALUES (1746, 'admin', 'col-metadataList', '2017-09-25 17:32:47', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1747, 'admin', 'col-metadataChange', '2017-09-25 17:33:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1748, 'admin', 'col-metadataList', '2017-09-25 17:39:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1749, 'admin', 'col-metadataChange', '2017-09-25 17:40:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1750, 'admin', 'col-metadataChange', '2017-09-25 17:40:41', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1751, 'unknown', 'col-default', '2017-09-25 17:46:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1752, 'unknown', 'col-connexion', '2017-09-25 17:46:51', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1753, 'admin', 'col-connexion', '2017-09-25 17:46:59', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1754, 'admin', 'col-default', '2017-09-25 17:46:59', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1755, 'admin', 'col-metadataList', '2017-09-25 17:47:03', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1756, 'admin', 'col-metadataChange', '2017-09-25 17:47:06', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1757, 'admin', 'col-sampleList', '2017-09-25 17:56:49', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1758, 'admin', 'col-sampleList', '2017-09-25 17:56:55', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1759, 'admin', 'col-sampleDisplay', '2017-09-25 17:57:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1760, 'unknown', 'col-default', '2017-09-25 18:16:39', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1761, 'unknown', 'col-collec12List', '2017-10-23 11:39:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1762, 'unknown', 'col-connexion', '2017-10-23 11:39:57', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1763, 'admin', 'col-connexion', '2017-10-23 11:40:02', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1764, 'admin', 'col-default', '2017-10-23 11:40:02', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1765, 'admin', 'col-containerList', '2017-10-23 11:40:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1766, 'admin', 'col-containerTypeGetFromFamily', '2017-10-23 11:40:08', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1767, 'admin', 'col-containerTypeGetFromFamily', '2017-10-23 11:40:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1768, 'admin', 'col-collec12index.php?moduleBase=container&action=List&isSearch=1&name=&object_status_id=1&uid_min=0&uid_max=0&container_family_id=2&container_type_id=List', '2017-10-23 11:40:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1769, 'admin', 'col-dbparamList', '2017-10-23 11:40:50', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1770, 'admin', 'col-connexion', '2017-10-23 11:40:54', 'db-ok', '10.4.2.103');
INSERT INTO log VALUES (1771, 'admin', 'col-dbparamList', '2017-10-23 11:40:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1772, 'admin', 'col-collec12index.phpList', '2017-10-23 11:41:05', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1773, 'admin', 'col-sampleList', '2017-10-23 11:41:13', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1774, 'admin', 'col-sampleTypeMetadata', '2017-10-23 11:41:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1775, 'admin', 'col-collec12index.php?moduleBase=sample&action=List&isSearch=1&name=&project_id=&uid_min=0&uid_max=0&sample_type_id=4&sampling_place_id=&object_status_id=1&metadata_field=&metadata_value=List', '2017-10-23 11:41:24', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1776, 'admin', 'col-containerList', '2017-10-23 11:45:16', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1777, 'admin', 'col-containerTypeGetFromFamily', '2017-10-23 11:45:17', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1778, 'admin', 'col-containerTypeGetFromFamily', '2017-10-23 11:45:21', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1779, 'admin', 'col-containerList', '2017-10-23 11:45:22', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1780, 'admin', 'col-containerTypeGetFromFamily', '2017-10-23 11:45:23', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1781, 'admin', 'col-sampleList', '2017-10-23 11:46:27', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1782, 'admin', 'col-sampleList', '2017-10-23 11:46:35', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1783, 'admin', 'col-dbparamList', '2017-10-23 11:46:48', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1784, 'admin', 'col-dbparamWriteGlobal', '2017-10-23 11:46:54', 'ok', '10.4.2.103');
INSERT INTO log VALUES (1785, 'admin', 'col-DbParam-writeGlobal', '2017-10-23 11:46:54', NULL, '10.4.2.103');
INSERT INTO log VALUES (1786, 'admin', 'col-dbparamList', '2017-10-23 11:46:54', 'ok', '10.4.2.103');


--
-- TOC entry 2820 (class 0 OID 0)
-- Dependencies: 255
-- Name: log_log_id_seq; Type: SEQUENCE SET; Schema: gacl; Owner: collec
--

SELECT pg_catalog.setval('log_log_id_seq', 1786, true);


--
-- TOC entry 2629 (class 0 OID 40201)
-- Dependencies: 257
-- Data for Name: login_oldpassword; Type: TABLE DATA; Schema: gacl; Owner: collec
--



--
-- TOC entry 2821 (class 0 OID 0)
-- Dependencies: 258
-- Name: login_oldpassword_login_oldpassword_id_seq; Type: SEQUENCE SET; Schema: gacl; Owner: collec
--

SELECT pg_catalog.setval('login_oldpassword_login_oldpassword_id_seq', 1, false);


--
-- TOC entry 2631 (class 0 OID 40207)
-- Dependencies: 259
-- Data for Name: logingestion; Type: TABLE DATA; Schema: gacl; Owner: collec
--

INSERT INTO logingestion VALUES (1, 'admin', 'cd916028a2d8a1b901e831246dd5b9b4d3832786ddc63bbf5af4b50d9fc98f50', 'Administrator', NULL, NULL, NULL, 1);
INSERT INTO logingestion VALUES (2, 'cpignol', '9fbd2e4d19289f163a6abb1fb44bc6906aeff84682b19a42d55d0811120b121a', 'Pignol', 'Cécile', 'cecile.pignol@univ-savoie.fr', '2017-09-24', 1);
INSERT INTO logingestion VALUES (3, 'vbretagnolle', '119839fe050e31d0ce7861d8558538f05539e991142d16bf4e73866f68f8adf5', 'Bretagnolle', 'Vincent', 'vincent.bretagnolle@cebc.cnrs.fr', '2017-09-24', 1);


--
-- TOC entry 2632 (class 0 OID 40215)
-- Dependencies: 260
-- Data for Name: passwordlost; Type: TABLE DATA; Schema: gacl; Owner: collec
--



--
-- TOC entry 2822 (class 0 OID 0)
-- Dependencies: 261
-- Name: passwordlost_passwordlost_id_seq; Type: SEQUENCE SET; Schema: gacl; Owner: collec
--

SELECT pg_catalog.setval('passwordlost_passwordlost_id_seq', 1, false);


--
-- TOC entry 2823 (class 0 OID 0)
-- Dependencies: 256
-- Name: seq_logingestion_id; Type: SEQUENCE SET; Schema: gacl; Owner: collec
--

SELECT pg_catalog.setval('seq_logingestion_id', 3, true);


SET search_path = col, pg_catalog;

--
-- TOC entry 2319 (class 2606 OID 40259)
-- Name: booking_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY booking
    ADD CONSTRAINT booking_pk PRIMARY KEY (booking_id);


--
-- TOC entry 2323 (class 2606 OID 40261)
-- Name: container_family_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container_family
    ADD CONSTRAINT container_family_pk PRIMARY KEY (container_family_id);


--
-- TOC entry 2321 (class 2606 OID 40263)
-- Name: container_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container
    ADD CONSTRAINT container_pk PRIMARY KEY (container_id);


--
-- TOC entry 2325 (class 2606 OID 40265)
-- Name: container_type_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container_type
    ADD CONSTRAINT container_type_pk PRIMARY KEY (container_type_id);


--
-- TOC entry 2399 (class 2606 OID 40553)
-- Name: dbparam_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY dbparam
    ADD CONSTRAINT dbparam_pk PRIMARY KEY (dbparam_id);


--
-- TOC entry 2327 (class 2606 OID 40267)
-- Name: dbversion_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY dbversion
    ADD CONSTRAINT dbversion_pk PRIMARY KEY (dbversion_id);


--
-- TOC entry 2329 (class 2606 OID 40269)
-- Name: document_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY document
    ADD CONSTRAINT document_pk PRIMARY KEY (document_id);


--
-- TOC entry 2331 (class 2606 OID 40271)
-- Name: event_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY event
    ADD CONSTRAINT event_pk PRIMARY KEY (event_id);


--
-- TOC entry 2333 (class 2606 OID 40273)
-- Name: event_type_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY event_type
    ADD CONSTRAINT event_type_pk PRIMARY KEY (event_type_id);


--
-- TOC entry 2335 (class 2606 OID 40275)
-- Name: identifier_type_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY identifier_type
    ADD CONSTRAINT identifier_type_pk PRIMARY KEY (identifier_type_id);


--
-- TOC entry 2337 (class 2606 OID 40277)
-- Name: label_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY label
    ADD CONSTRAINT label_pk PRIMARY KEY (label_id);


--
-- TOC entry 2341 (class 2606 OID 40279)
-- Name: metadata_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY metadata
    ADD CONSTRAINT metadata_pk PRIMARY KEY (metadata_id);


--
-- TOC entry 2343 (class 2606 OID 40281)
-- Name: mime_type_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY mime_type
    ADD CONSTRAINT mime_type_pk PRIMARY KEY (mime_type_id);


--
-- TOC entry 2345 (class 2606 OID 40283)
-- Name: movement_type_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY movement_type
    ADD CONSTRAINT movement_type_pk PRIMARY KEY (movement_type_id);


--
-- TOC entry 2347 (class 2606 OID 40285)
-- Name: multiple_type_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY multiple_type
    ADD CONSTRAINT multiple_type_pk PRIMARY KEY (multiple_type_id);


--
-- TOC entry 2351 (class 2606 OID 40287)
-- Name: object_identifier_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY object_identifier
    ADD CONSTRAINT object_identifier_pk PRIMARY KEY (object_identifier_id);


--
-- TOC entry 2349 (class 2606 OID 40289)
-- Name: object_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY object
    ADD CONSTRAINT object_pk PRIMARY KEY (uid);


--
-- TOC entry 2353 (class 2606 OID 40291)
-- Name: object_status_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY object_status
    ADD CONSTRAINT object_status_pk PRIMARY KEY (object_status_id);


--
-- TOC entry 2355 (class 2606 OID 40293)
-- Name: operation_name_version_unique; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY operation
    ADD CONSTRAINT operation_name_version_unique UNIQUE (operation_name, operation_version);


--
-- TOC entry 2357 (class 2606 OID 40295)
-- Name: operation_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY operation
    ADD CONSTRAINT operation_pk PRIMARY KEY (operation_id);


--
-- TOC entry 2359 (class 2606 OID 40297)
-- Name: printer_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY printer
    ADD CONSTRAINT printer_pk PRIMARY KEY (printer_id);


--
-- TOC entry 2363 (class 2606 OID 40299)
-- Name: project_group_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY project_group
    ADD CONSTRAINT project_group_pk PRIMARY KEY (project_id, aclgroup_id);


--
-- TOC entry 2361 (class 2606 OID 40301)
-- Name: project_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_pk PRIMARY KEY (project_id);


--
-- TOC entry 2365 (class 2606 OID 40303)
-- Name: protocol_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY protocol
    ADD CONSTRAINT protocol_pk PRIMARY KEY (protocol_id);


--
-- TOC entry 2367 (class 2606 OID 40305)
-- Name: sample_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_pk PRIMARY KEY (sample_id);


--
-- TOC entry 2369 (class 2606 OID 40307)
-- Name: sample_type_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample_type
    ADD CONSTRAINT sample_type_pk PRIMARY KEY (sample_type_id);


--
-- TOC entry 2371 (class 2606 OID 40309)
-- Name: sampling_place_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sampling_place
    ADD CONSTRAINT sampling_place_pk PRIMARY KEY (sampling_place_id);


--
-- TOC entry 2373 (class 2606 OID 40311)
-- Name: storage_condition_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage_condition
    ADD CONSTRAINT storage_condition_pk PRIMARY KEY (storage_condition_id);


--
-- TOC entry 2339 (class 2606 OID 40313)
-- Name: storage_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT storage_pk PRIMARY KEY (storage_id);


--
-- TOC entry 2375 (class 2606 OID 40315)
-- Name: storage_reason_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage_reason
    ADD CONSTRAINT storage_reason_pk PRIMARY KEY (storage_reason_id);


--
-- TOC entry 2377 (class 2606 OID 40317)
-- Name: subsample_pk; Type: CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY subsample
    ADD CONSTRAINT subsample_pk PRIMARY KEY (subsample_id);


SET search_path = gacl, pg_catalog;

--
-- TOC entry 2379 (class 2606 OID 40319)
-- Name: aclacl_pk; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclacl
    ADD CONSTRAINT aclacl_pk PRIMARY KEY (aclaco_id, aclgroup_id);


--
-- TOC entry 2381 (class 2606 OID 40321)
-- Name: aclaco_pk; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclaco
    ADD CONSTRAINT aclaco_pk PRIMARY KEY (aclaco_id);


--
-- TOC entry 2383 (class 2606 OID 40323)
-- Name: aclappli_pk; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclappli
    ADD CONSTRAINT aclappli_pk PRIMARY KEY (aclappli_id);


--
-- TOC entry 2317 (class 2606 OID 40325)
-- Name: aclgroup_pk; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclgroup
    ADD CONSTRAINT aclgroup_pk PRIMARY KEY (aclgroup_id);


--
-- TOC entry 2385 (class 2606 OID 40327)
-- Name: acllogin_pk; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY acllogin
    ADD CONSTRAINT acllogin_pk PRIMARY KEY (acllogin_id);


--
-- TOC entry 2387 (class 2606 OID 40329)
-- Name: acllogingroup_pk; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY acllogingroup
    ADD CONSTRAINT acllogingroup_pk PRIMARY KEY (acllogin_id, aclgroup_id);


--
-- TOC entry 2391 (class 2606 OID 40331)
-- Name: log_pk; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY log
    ADD CONSTRAINT log_pk PRIMARY KEY (log_id);


--
-- TOC entry 2393 (class 2606 OID 40333)
-- Name: login_oldpassword_pk; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY login_oldpassword
    ADD CONSTRAINT login_oldpassword_pk PRIMARY KEY (login_oldpassword_id);


--
-- TOC entry 2397 (class 2606 OID 40335)
-- Name: passwordlost_pk; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY passwordlost
    ADD CONSTRAINT passwordlost_pk PRIMARY KEY (passwordlost_id);


--
-- TOC entry 2395 (class 2606 OID 40337)
-- Name: pk_logingestion; Type: CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY logingestion
    ADD CONSTRAINT pk_logingestion PRIMARY KEY (id);


--
-- TOC entry 2388 (class 1259 OID 40338)
-- Name: log_date_idx; Type: INDEX; Schema: gacl; Owner: collec
--

CREATE INDEX log_date_idx ON log USING btree (log_date);


--
-- TOC entry 2389 (class 1259 OID 40339)
-- Name: log_login_idx; Type: INDEX; Schema: gacl; Owner: collec
--

CREATE INDEX log_login_idx ON log USING btree (login);


SET search_path = col, pg_catalog;

--
-- TOC entry 2420 (class 2606 OID 40340)
-- Name: aclgroup_projet_group_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY project_group
    ADD CONSTRAINT aclgroup_projet_group_fk FOREIGN KEY (aclgroup_id) REFERENCES gacl.aclgroup(aclgroup_id);


--
-- TOC entry 2404 (class 2606 OID 40345)
-- Name: container_family_container_type_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container_type
    ADD CONSTRAINT container_family_container_type_fk FOREIGN KEY (container_family_id) REFERENCES container_family(container_family_id);


--
-- TOC entry 2412 (class 2606 OID 40350)
-- Name: container_storage_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT container_storage_fk FOREIGN KEY (container_id) REFERENCES container(container_id);


--
-- TOC entry 2402 (class 2606 OID 40355)
-- Name: container_type_container_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container
    ADD CONSTRAINT container_type_container_fk FOREIGN KEY (container_type_id) REFERENCES container_type(container_type_id);


--
-- TOC entry 2428 (class 2606 OID 40360)
-- Name: container_type_sample_type_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample_type
    ADD CONSTRAINT container_type_sample_type_fk FOREIGN KEY (container_type_id) REFERENCES container_type(container_type_id);


--
-- TOC entry 2409 (class 2606 OID 40365)
-- Name: event_type_event_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY event
    ADD CONSTRAINT event_type_event_fk FOREIGN KEY (event_type_id) REFERENCES event_type(event_type_id);


--
-- TOC entry 2417 (class 2606 OID 40370)
-- Name: identifier_type_object_identifier_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY object_identifier
    ADD CONSTRAINT identifier_type_object_identifier_fk FOREIGN KEY (identifier_type_id) REFERENCES identifier_type(identifier_type_id);


--
-- TOC entry 2405 (class 2606 OID 40375)
-- Name: label_container_type_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container_type
    ADD CONSTRAINT label_container_type_fk FOREIGN KEY (label_id) REFERENCES label(label_id);


--
-- TOC entry 2411 (class 2606 OID 40380)
-- Name: metadata_label_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY label
    ADD CONSTRAINT metadata_label_fk FOREIGN KEY (metadata_id) REFERENCES metadata(metadata_id);


--
-- TOC entry 2429 (class 2606 OID 40385)
-- Name: metadata_sample_type_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample_type
    ADD CONSTRAINT metadata_sample_type_fk FOREIGN KEY (metadata_id) REFERENCES metadata(metadata_id);


--
-- TOC entry 2407 (class 2606 OID 40390)
-- Name: mime_type_document_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY document
    ADD CONSTRAINT mime_type_document_fk FOREIGN KEY (mime_type_id) REFERENCES mime_type(mime_type_id);


--
-- TOC entry 2413 (class 2606 OID 40395)
-- Name: movement_type_storage_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT movement_type_storage_fk FOREIGN KEY (movement_type_id) REFERENCES movement_type(movement_type_id);


--
-- TOC entry 2432 (class 2606 OID 40400)
-- Name: movement_type_subsample_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY subsample
    ADD CONSTRAINT movement_type_subsample_fk FOREIGN KEY (movement_type_id) REFERENCES movement_type(movement_type_id);


--
-- TOC entry 2430 (class 2606 OID 40405)
-- Name: multiple_type_sample_type_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample_type
    ADD CONSTRAINT multiple_type_sample_type_fk FOREIGN KEY (multiple_type_id) REFERENCES multiple_type(multiple_type_id);


--
-- TOC entry 2401 (class 2606 OID 40410)
-- Name: object_booking_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY booking
    ADD CONSTRAINT object_booking_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 2403 (class 2606 OID 40415)
-- Name: object_container_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container
    ADD CONSTRAINT object_container_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 2408 (class 2606 OID 40420)
-- Name: object_document_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY document
    ADD CONSTRAINT object_document_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 2410 (class 2606 OID 40425)
-- Name: object_event_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY event
    ADD CONSTRAINT object_event_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 2418 (class 2606 OID 40430)
-- Name: object_object_identifier_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY object_identifier
    ADD CONSTRAINT object_object_identifier_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 2423 (class 2606 OID 40435)
-- Name: object_sample_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT object_sample_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 2416 (class 2606 OID 40440)
-- Name: object_status_object_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY object
    ADD CONSTRAINT object_status_object_fk FOREIGN KEY (object_status_id) REFERENCES object_status(object_status_id);


--
-- TOC entry 2414 (class 2606 OID 40445)
-- Name: object_storage_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT object_storage_fk FOREIGN KEY (uid) REFERENCES object(uid);


--
-- TOC entry 2431 (class 2606 OID 40450)
-- Name: operation_sample_type_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample_type
    ADD CONSTRAINT operation_sample_type_fk FOREIGN KEY (operation_id) REFERENCES operation(operation_id);


--
-- TOC entry 2421 (class 2606 OID 40455)
-- Name: project_projet_group_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY project_group
    ADD CONSTRAINT project_projet_group_fk FOREIGN KEY (project_id) REFERENCES project(project_id);


--
-- TOC entry 2422 (class 2606 OID 40460)
-- Name: project_protocol_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY protocol
    ADD CONSTRAINT project_protocol_fk FOREIGN KEY (project_id) REFERENCES project(project_id);


--
-- TOC entry 2424 (class 2606 OID 40465)
-- Name: project_sample_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT project_sample_fk FOREIGN KEY (project_id) REFERENCES project(project_id);


--
-- TOC entry 2419 (class 2606 OID 40470)
-- Name: protocol_operation_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY operation
    ADD CONSTRAINT protocol_operation_fk FOREIGN KEY (protocol_id) REFERENCES protocol(protocol_id);


--
-- TOC entry 2425 (class 2606 OID 40475)
-- Name: sample_sample_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_sample_fk FOREIGN KEY (parent_sample_id) REFERENCES sample(sample_id);


--
-- TOC entry 2433 (class 2606 OID 40480)
-- Name: sample_subsample_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY subsample
    ADD CONSTRAINT sample_subsample_fk FOREIGN KEY (sample_id) REFERENCES sample(sample_id);


--
-- TOC entry 2426 (class 2606 OID 40485)
-- Name: sample_type_sample_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_type_sample_fk FOREIGN KEY (sample_type_id) REFERENCES sample_type(sample_type_id);


--
-- TOC entry 2427 (class 2606 OID 40490)
-- Name: sampling_place_sample_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sampling_place_sample_fk FOREIGN KEY (sampling_place_id) REFERENCES sampling_place(sampling_place_id);


--
-- TOC entry 2406 (class 2606 OID 40495)
-- Name: storage_condition_container_type_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY container_type
    ADD CONSTRAINT storage_condition_container_type_fk FOREIGN KEY (storage_condition_id) REFERENCES storage_condition(storage_condition_id);


--
-- TOC entry 2415 (class 2606 OID 40500)
-- Name: storage_reason_storage_fk; Type: FK CONSTRAINT; Schema: col; Owner: collec
--

ALTER TABLE ONLY storage
    ADD CONSTRAINT storage_reason_storage_fk FOREIGN KEY (storage_reason_id) REFERENCES storage_reason(storage_reason_id);


SET search_path = gacl, pg_catalog;

--
-- TOC entry 2434 (class 2606 OID 40505)
-- Name: aclaco_aclacl_fk; Type: FK CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclacl
    ADD CONSTRAINT aclaco_aclacl_fk FOREIGN KEY (aclaco_id) REFERENCES aclaco(aclaco_id);


--
-- TOC entry 2436 (class 2606 OID 40510)
-- Name: aclappli_aclaco_fk; Type: FK CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclaco
    ADD CONSTRAINT aclappli_aclaco_fk FOREIGN KEY (aclappli_id) REFERENCES aclappli(aclappli_id);


--
-- TOC entry 2435 (class 2606 OID 40515)
-- Name: aclgroup_aclacl_fk; Type: FK CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclacl
    ADD CONSTRAINT aclgroup_aclacl_fk FOREIGN KEY (aclgroup_id) REFERENCES aclgroup(aclgroup_id);


--
-- TOC entry 2400 (class 2606 OID 40520)
-- Name: aclgroup_aclgroup_fk; Type: FK CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY aclgroup
    ADD CONSTRAINT aclgroup_aclgroup_fk FOREIGN KEY (aclgroup_id_parent) REFERENCES aclgroup(aclgroup_id);


--
-- TOC entry 2437 (class 2606 OID 40525)
-- Name: aclgroup_acllogingroup_fk; Type: FK CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY acllogingroup
    ADD CONSTRAINT aclgroup_acllogingroup_fk FOREIGN KEY (aclgroup_id) REFERENCES aclgroup(aclgroup_id);


--
-- TOC entry 2438 (class 2606 OID 40530)
-- Name: acllogin_acllogingroup_fk; Type: FK CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY acllogingroup
    ADD CONSTRAINT acllogin_acllogingroup_fk FOREIGN KEY (acllogin_id) REFERENCES acllogin(acllogin_id);


--
-- TOC entry 2439 (class 2606 OID 40535)
-- Name: logingestion_login_oldpassword_fk; Type: FK CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY login_oldpassword
    ADD CONSTRAINT logingestion_login_oldpassword_fk FOREIGN KEY (id) REFERENCES logingestion(id);


--
-- TOC entry 2440 (class 2606 OID 40540)
-- Name: logingestion_passwordlost_fk; Type: FK CONSTRAINT; Schema: gacl; Owner: collec
--

ALTER TABLE ONLY passwordlost
    ADD CONSTRAINT logingestion_passwordlost_fk FOREIGN KEY (id) REFERENCES logingestion(id);


--
-- TOC entry 2640 (class 0 OID 0)
-- Dependencies: 9
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2017-10-23 13:11:55 CEST

--
-- PostgreSQL database dump complete
--

