--
-- PostgreSQL database dump
--

\restrict 3zeJl3lj0zCocktXvs7qpcKqRRpWWnnpMIaiOZiJ0LZWgv9jthh4bUfQCpMGALo

-- Dumped from database version 16.13
-- Dumped by pg_dump version 16.15

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

ALTER TABLE IF EXISTS ONLY public.search DROP CONSTRAINT IF EXISTS search_entity_id_foreign;
ALTER TABLE IF EXISTS ONLY public.relations DROP CONSTRAINT IF EXISTS relations_originating_entity_id_foreign;
ALTER TABLE IF EXISTS ONLY public.refresh_state_references DROP CONSTRAINT IF EXISTS refresh_state_references_target_entity_ref_foreign;
ALTER TABLE IF EXISTS ONLY public.refresh_state_references DROP CONSTRAINT IF EXISTS refresh_state_references_source_entity_ref_foreign;
ALTER TABLE IF EXISTS ONLY public.location_update_log DROP CONSTRAINT IF EXISTS location_update_log_location_id_foreign;
ALTER TABLE IF EXISTS ONLY public.final_entities DROP CONSTRAINT IF EXISTS final_entities_entity_id_foreign;
ALTER TABLE IF EXISTS ONLY public.entities_search DROP CONSTRAINT IF EXISTS entities_search_entity_id_foreign;
ALTER TABLE IF EXISTS ONLY public.entities_relations DROP CONSTRAINT IF EXISTS entities_relations_originating_entity_id_foreign;
ALTER TABLE IF EXISTS ONLY public.entities DROP CONSTRAINT IF EXISTS entities_location_id_foreign;
CREATE OR REPLACE VIEW public.location_update_log_latest AS
SELECT
    NULL::bigint AS id,
    NULL::text AS status,
    NULL::timestamp with time zone AS created_at,
    NULL::text AS message,
    NULL::uuid AS location_id,
    NULL::text AS entity_name;
DROP INDEX IF EXISTS public.update_log_location_id_idx;
DROP INDEX IF EXISTS public.source_full_name_idx;
DROP INDEX IF EXISTS public.search_value_idx;
DROP INDEX IF EXISTS public.search_key_idx;
DROP INDEX IF EXISTS public.search_entity_id_idx;
DROP INDEX IF EXISTS public.relations_source_entity_ref_idx;
DROP INDEX IF EXISTS public.relations_source_entity_id_idx;
DROP INDEX IF EXISTS public.refresh_state_references_target_entity_ref_idx;
DROP INDEX IF EXISTS public.refresh_state_references_source_key_idx;
DROP INDEX IF EXISTS public.refresh_state_references_source_entity_ref_idx;
DROP INDEX IF EXISTS public.refresh_state_next_update_at_idx;
DROP INDEX IF EXISTS public.refresh_state_entity_ref_idx;
DROP INDEX IF EXISTS public.refresh_state_entity_id_idx;
DROP INDEX IF EXISTS public.originating_entity_id_idx;
DROP INDEX IF EXISTS public.final_entities_entity_id_idx;
DROP INDEX IF EXISTS public.entity_location_id_idx;
DROP INDEX IF EXISTS public.entity_id_idx;
DROP INDEX IF EXISTS public.entities_search_value;
DROP INDEX IF EXISTS public.entities_search_key;
ALTER TABLE IF EXISTS ONLY public.refresh_state_references DROP CONSTRAINT IF EXISTS refresh_state_references_pkey;
ALTER TABLE IF EXISTS ONLY public.refresh_state DROP CONSTRAINT IF EXISTS refresh_state_pkey;
ALTER TABLE IF EXISTS ONLY public.refresh_state DROP CONSTRAINT IF EXISTS refresh_state_entity_ref_uniq;
ALTER TABLE IF EXISTS ONLY public.locations DROP CONSTRAINT IF EXISTS locations_pkey;
ALTER TABLE IF EXISTS ONLY public.location_update_log DROP CONSTRAINT IF EXISTS location_update_log_pkey;
ALTER TABLE IF EXISTS ONLY public.knex_migrations DROP CONSTRAINT IF EXISTS knex_migrations_pkey;
ALTER TABLE IF EXISTS ONLY public.knex_migrations_lock DROP CONSTRAINT IF EXISTS knex_migrations_lock_pkey;
ALTER TABLE IF EXISTS ONLY public.final_entities DROP CONSTRAINT IF EXISTS final_entities_pkey;
ALTER TABLE IF EXISTS ONLY public.entities DROP CONSTRAINT IF EXISTS entities_unique_full_name;
ALTER TABLE IF EXISTS ONLY public.entities DROP CONSTRAINT IF EXISTS entities_pkey;
ALTER TABLE IF EXISTS public.refresh_state_references ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.location_update_log ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.knex_migrations_lock ALTER COLUMN index DROP DEFAULT;
ALTER TABLE IF EXISTS public.knex_migrations ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS public.search;
DROP TABLE IF EXISTS public.relations;
DROP SEQUENCE IF EXISTS public.refresh_state_references_id_seq;
DROP TABLE IF EXISTS public.refresh_state_references;
DROP TABLE IF EXISTS public.refresh_state;
DROP TABLE IF EXISTS public.locations;
DROP VIEW IF EXISTS public.location_update_log_latest;
DROP SEQUENCE IF EXISTS public.location_update_log_id_seq;
DROP TABLE IF EXISTS public.location_update_log;
DROP SEQUENCE IF EXISTS public.knex_migrations_lock_index_seq;
DROP TABLE IF EXISTS public.knex_migrations_lock;
DROP SEQUENCE IF EXISTS public.knex_migrations_id_seq;
DROP TABLE IF EXISTS public.knex_migrations;
DROP TABLE IF EXISTS public.final_entities;
DROP TABLE IF EXISTS public.entities_search;
DROP TABLE IF EXISTS public.entities_relations;
DROP TABLE IF EXISTS public.entities;
-- *not* dropping schema, since initdb creates it
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: entities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entities (
    id uuid NOT NULL,
    location_id uuid,
    etag character varying(255) NOT NULL,
    generation character varying(255) NOT NULL,
    full_name text NOT NULL,
    data text NOT NULL
);


--
-- Name: TABLE entities; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.entities IS 'All entities currently stored in the catalog';


--
-- Name: COLUMN entities.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entities.id IS 'Auto-generated ID of the entity';


--
-- Name: COLUMN entities.location_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entities.location_id IS 'The location that originated the entity';


--
-- Name: COLUMN entities.etag; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entities.etag IS 'An opaque string that changes for each update operation to any part of the entity, including metadata.';


--
-- Name: COLUMN entities.generation; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entities.generation IS 'A positive nonzero number that indicates the current generation of data for this entity; the value is incremented each time the spec changes.';


--
-- Name: COLUMN entities.data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entities.data IS 'The entire JSON data blob of the entity';


--
-- Name: entities_relations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entities_relations (
    originating_entity_id uuid NOT NULL,
    source_full_name character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    target_full_name character varying(255) NOT NULL
);


--
-- Name: TABLE entities_relations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.entities_relations IS 'All relations between entities in the catalog';


--
-- Name: COLUMN entities_relations.originating_entity_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entities_relations.originating_entity_id IS 'The entity that provided the relation';


--
-- Name: COLUMN entities_relations.source_full_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entities_relations.source_full_name IS 'The full name of the source entity of the relation';


--
-- Name: COLUMN entities_relations.type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entities_relations.type IS 'The type of the relation between the entities';


--
-- Name: COLUMN entities_relations.target_full_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entities_relations.target_full_name IS 'The full name of the target entity of the relation';


--
-- Name: entities_search; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entities_search (
    entity_id uuid,
    key character varying(255) NOT NULL,
    value text
);


--
-- Name: TABLE entities_search; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.entities_search IS 'Flattened key-values from the entities, used for quick filtering';


--
-- Name: COLUMN entities_search.entity_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entities_search.entity_id IS 'The entity that matches this key/value';


--
-- Name: COLUMN entities_search.key; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entities_search.key IS 'A key that occurs in the entity';


--
-- Name: COLUMN entities_search.value; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.entities_search.value IS 'The corresponding value to match on';


--
-- Name: final_entities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.final_entities (
    entity_id text NOT NULL,
    hash text NOT NULL,
    stitch_ticket text NOT NULL,
    final_entity text
);


--
-- Name: TABLE final_entities; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.final_entities IS 'This table contains the final entity result after processing and stitching';


--
-- Name: COLUMN final_entities.entity_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.final_entities.entity_id IS 'Entity ID which corresponds to the ID in the refresh_state table';


--
-- Name: COLUMN final_entities.hash; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.final_entities.hash IS 'Stable hash of the entity data, to be used for caching and avoiding redundant work';


--
-- Name: COLUMN final_entities.stitch_ticket; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.final_entities.stitch_ticket IS 'A random value representing a unique stitch attempt ticket, that gets updated each time that a stitching attempt is made on the entity';


--
-- Name: COLUMN final_entities.final_entity; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.final_entities.final_entity IS 'The JSON encoded final entity';


--
-- Name: knex_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.knex_migrations (
    id integer NOT NULL,
    name character varying(255),
    batch integer,
    migration_time timestamp with time zone
);


--
-- Name: knex_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.knex_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: knex_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.knex_migrations_id_seq OWNED BY public.knex_migrations.id;


--
-- Name: knex_migrations_lock; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.knex_migrations_lock (
    index integer NOT NULL,
    is_locked integer
);


--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.knex_migrations_lock_index_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.knex_migrations_lock_index_seq OWNED BY public.knex_migrations_lock.index;


--
-- Name: location_update_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location_update_log (
    id bigint NOT NULL,
    status text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    message text,
    location_id uuid,
    entity_name text,
    CONSTRAINT location_update_log_status_check CHECK ((status = ANY (ARRAY['success'::text, 'fail'::text])))
);


--
-- Name: location_update_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.location_update_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: location_update_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.location_update_log_id_seq OWNED BY public.location_update_log.id;


--
-- Name: location_update_log_latest; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.location_update_log_latest AS
SELECT
    NULL::bigint AS id,
    NULL::text AS status,
    NULL::timestamp with time zone AS created_at,
    NULL::text AS message,
    NULL::uuid AS location_id,
    NULL::text AS entity_name;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id uuid NOT NULL,
    type character varying(255) NOT NULL,
    target character varying(255) NOT NULL
);


--
-- Name: TABLE locations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.locations IS 'Registered locations that shall be contiuously scanned for catalog item updates';


--
-- Name: COLUMN locations.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.locations.id IS 'Auto-generated ID of the location';


--
-- Name: COLUMN locations.type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.locations.type IS 'The type of location';


--
-- Name: COLUMN locations.target; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.locations.target IS 'The actual target of the location';


--
-- Name: refresh_state; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refresh_state (
    entity_id text NOT NULL,
    entity_ref text NOT NULL,
    unprocessed_entity text NOT NULL,
    processed_entity text,
    cache text,
    errors text NOT NULL,
    next_update_at timestamp with time zone NOT NULL,
    last_discovery_at timestamp with time zone NOT NULL,
    location_key text
);


--
-- Name: TABLE refresh_state; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.refresh_state IS 'Location refresh states. Every individual location (that was ever directly or indirectly discovered) and entity has an entry in this table. It therefore represents the entire live set of things that the refresh loop considers.';


--
-- Name: COLUMN refresh_state.entity_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.refresh_state.entity_id IS 'Primary ID, which will also be used as the uid of the resulting entity';


--
-- Name: COLUMN refresh_state.entity_ref; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.refresh_state.entity_ref IS 'A reference to the entity that the refresh state is tied to';


--
-- Name: COLUMN refresh_state.unprocessed_entity; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.refresh_state.unprocessed_entity IS 'The unprocessed entity (in its source form, before being run through all of the processors) as JSON';


--
-- Name: COLUMN refresh_state.processed_entity; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.refresh_state.processed_entity IS 'The processed entity (after running through all processors, but before being stitched together with state and relations) as JSON';


--
-- Name: COLUMN refresh_state.cache; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.refresh_state.cache IS 'Cache information tied to the refreshing of this entity, such as etag information or actual response caching';


--
-- Name: COLUMN refresh_state.errors; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.refresh_state.errors IS 'JSON array containing all errors related to entity';


--
-- Name: COLUMN refresh_state.next_update_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.refresh_state.next_update_at IS 'Timestamp of when entity should be updated';


--
-- Name: COLUMN refresh_state.last_discovery_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.refresh_state.last_discovery_at IS 'The last timestamp of which this entity was discovered';


--
-- Name: COLUMN refresh_state.location_key; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.refresh_state.location_key IS 'An opaque key that uniquely identifies the location of an entity in order to support conflict resolution';


--
-- Name: refresh_state_references; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refresh_state_references (
    id integer NOT NULL,
    source_key text,
    source_entity_ref text,
    target_entity_ref text NOT NULL
);


--
-- Name: TABLE refresh_state_references; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.refresh_state_references IS 'Holds edges between refresh state rows. Every time when an entity is processed and emits another entity, an edge will be stored to represent that fact. This is used to detect orphans and ultimately deletions.';


--
-- Name: COLUMN refresh_state_references.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.refresh_state_references.id IS 'Primary key to distinguish unique lines from each other';


--
-- Name: COLUMN refresh_state_references.source_key; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.refresh_state_references.source_key IS 'When the reference source is not an entity, this is an opaque identifier for that source.';


--
-- Name: COLUMN refresh_state_references.source_entity_ref; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.refresh_state_references.source_entity_ref IS 'When the reference source is an entity, this is the EntityRef of the source entity.';


--
-- Name: COLUMN refresh_state_references.target_entity_ref; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.refresh_state_references.target_entity_ref IS 'The EntityRef of the target entity.';


--
-- Name: refresh_state_references_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.refresh_state_references_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refresh_state_references_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.refresh_state_references_id_seq OWNED BY public.refresh_state_references.id;


--
-- Name: relations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.relations (
    originating_entity_id text NOT NULL,
    source_entity_ref text NOT NULL,
    type text NOT NULL,
    target_entity_ref text NOT NULL
);


--
-- Name: TABLE relations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.relations IS 'All relations between entities in the catalog';


--
-- Name: COLUMN relations.originating_entity_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.relations.originating_entity_id IS 'The entity that provided the relation';


--
-- Name: COLUMN relations.source_entity_ref; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.relations.source_entity_ref IS 'The entity reference of the source entity of the relation';


--
-- Name: COLUMN relations.type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.relations.type IS 'The type of the relation between the entities';


--
-- Name: COLUMN relations.target_entity_ref; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.relations.target_entity_ref IS 'The entity reference of the target entity of the relation';


--
-- Name: search; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.search (
    entity_id text,
    key character varying(255) NOT NULL,
    value character varying(255)
);


--
-- Name: TABLE search; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.search IS 'Flattened key-values from the entities, used for quick filtering';


--
-- Name: COLUMN search.entity_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.search.entity_id IS 'The entity that matches this key/value';


--
-- Name: COLUMN search.key; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.search.key IS 'A key that occurs in the entity';


--
-- Name: COLUMN search.value; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.search.value IS 'The corresponding value to match on';


--
-- Name: knex_migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knex_migrations ALTER COLUMN id SET DEFAULT nextval('public.knex_migrations_id_seq'::regclass);


--
-- Name: knex_migrations_lock index; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knex_migrations_lock ALTER COLUMN index SET DEFAULT nextval('public.knex_migrations_lock_index_seq'::regclass);


--
-- Name: location_update_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_update_log ALTER COLUMN id SET DEFAULT nextval('public.location_update_log_id_seq'::regclass);


--
-- Name: refresh_state_references id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_state_references ALTER COLUMN id SET DEFAULT nextval('public.refresh_state_references_id_seq'::regclass);


--
-- Data for Name: entities; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: entities_relations; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: entities_search; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: final_entities; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.final_entities VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', '9d604bc9120eb4d073f9bd99d442f5f5da37538e', '4a8b1679-9e2b-47a7-a532-d7be2547d393', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/"},"name":"nodejs-sonarqube-cicd-template","title":"Node.js 20 Web App + CI/CD with SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Node.js 20 microservice repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki JSON logs, and Backstage manifest.","tags":["node","nodejs","javascript","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"f4433dbe-aa69-4603-840e-2c2f82ce17c0","generation":1,"etag":"9d604bc9120eb4d073f9bd99d442f5f5da37538e"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"nodejs-app-demo"},"description":{"title":"Description","type":"string","description":"What does this Node.js microservice do?","default":"Node.js 20 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"nodejs-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}},"relations":[{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"squad-plataforma"}}]}');
INSERT INTO public.final_entities VALUES ('9575b37e-e899-4803-9b03-61add445781f', '1b4356fb34afdd02999617c7eead5c3392d99f6a', '1fdd1934-cff9-4e79-baa3-d6e85832c009', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/"},"name":"generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce","uid":"9575b37e-e899-4803-9b03-61add445781f","generation":1,"etag":"1b4356fb34afdd02999617c7eead5c3392d99f6a"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('b9d0245c-c6f9-4214-aa46-9d84d2235fce', '085f2ec41808f9ad2c32d646aa01733955fb9e11', '08448d6d-cd4d-4787-a10c-4d736238d6c0', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/microservice-template/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/"},"name":"generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98","uid":"b9d0245c-c6f9-4214-aa46-9d84d2235fce","generation":1,"etag":"085f2ec41808f9ad2c32d646aa01733955fb9e11"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'bd8ef00a9f1a78189ef9689ad74c95f9c0615cde', 'd3bd4ec6-9647-437d-932c-6fa6eec12ccd', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/"},"name":"generated-e1e842392fd0da6efe989d25722f835228d60e05","uid":"0292df28-4efd-43fd-a9ee-52ece26b6185","generation":1,"etag":"bd8ef00a9f1a78189ef9689ad74c95f9c0615cde"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', '44384825848573f2cb0a1d4256309abf997ca697', '85ce75f1-0de5-4a36-887d-e2156ca5ab4c', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"python-demo-app","grafana/tag-selector":"service:python-demo-app","grafana/overview-dashboard":"http://grafana.799416476486.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12","argocd/app-name":"python-app"},"name":"python-demo-app","title":"Python 3.12 Flask Microservice","description":"App Web em Python 3.12 (Flask) com Prometheus metrics, logs JSON para Grafana Loki, SonarQube Quality Gate, GitOps via ArgoCD e HTTPS via AWS ACM.","tags":["python","flask","sonarqube","prometheus","fluentd","loki","grafana","k8s","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app","title":"GitHub Source Code","icon":"github"},{"url":"http://python.799416476486.realhandsonlabs.net","title":"Python 3.12 Live App (HTTP)","icon":"web"},{"url":"https://python.799416476486.realhandsonlabs.net","title":"Python 3.12 Live App (HTTPS ACM)","icon":"lock"},{"url":"http://python.799416476486.realhandsonlabs.net/metrics","title":"Prometheus Metrics (/metrics)","icon":"gauge"},{"url":"http://grafana.799416476486.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12","title":"Grafana Dashboard (Golden Signals & Loki Logs)","icon":"dashboard"},{"url":"http://sonarqube.799416476486.realhandsonlabs.net/dashboard?id=apps-demo-2026","title":"SonarQube Quality Gate","icon":"check"},{"url":"https://argocd.799416476486.realhandsonlabs.net/applications/python-app","title":"ArgoCD GitOps","icon":"sync"}],"uid":"7d02e7b7-48b7-43fd-abe6-5650785ed3de","generation":1,"etag":"44384825848573f2cb0a1d4256309abf997ca697"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","providesApis":["python-app-api"],"dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"apps-demo-2026"}},{"type":"providesApi","target":{"kind":"api","namespace":"default","name":"python-app-api"}}]}');
INSERT INTO public.final_entities VALUES ('83c4b685-a74b-4228-a442-a3903e0778b0', 'd55c8679eabc0201e6c49b976508892aebb02e91', '43439a65-3b43-4a15-9fb8-9151edac49b3', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/"},"name":"generated-689c18882dc297803e1a420c73b8783d094c8e17","uid":"83c4b685-a74b-4228-a442-a3903e0778b0","generation":1,"etag":"d55c8679eabc0201e6c49b976508892aebb02e91"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'b80c988c2df279253a6b129cd906fad2d392eeab', '0db10beb-38bd-418b-ad6c-3b4bb111f625', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/"},"name":"dotnet-csharp-app-api","title":".NET 8 C# Minimal API REST API","description":"Interface REST para consulta de status, saúde e telemetria da aplicação C# .NET 8","uid":"63db9a4c-47aa-4c58-a818-dc552e7dd313","generation":1,"etag":"b80c988c2df279253a6b129cd906fad2d392eeab"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","definition":"openapi: \"3.0.0\"\ninfo:\n  title: .NET 8 C# Minimal API\n  version: \"1.0.0\"\npaths:\n  /:\n    get:\n      summary: Overview & HTML Dashboard\n      responses:\n        ''200'':\n          description: OK\n  /api/info:\n    get:\n      summary: System & client runtime information\n      responses:\n        ''200'':\n          description: OK\n  /healthz:\n    get:\n      summary: Liveness probe\n      responses:\n        ''200'':\n          description: OK\n  /ready:\n    get:\n      summary: Readiness probe\n      responses:\n        ''200'':\n          description: OK\n  /metrics:\n    get:\n      summary: Prometheus metrics\n      responses:\n        ''200'':\n          description: OK\n"},"relations":[{"type":"apiProvidedBy","target":{"kind":"component","namespace":"default","name":"dotnet-csharp-demo-app"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"apps-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'fe83ce5c544fa28fe0dc59719768342e5ef9deaa', 'a9875962-9c6b-4aa7-afb0-fcd857bff2b1', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/"},"name":"apps-demo-2026","title":"Apps Demo 2026 Ecosystem","description":"Microservices Demo Collection (Python 3.12 Flask, .NET 8 C# Minimal API) with CI/CD, SonarQube, Prometheus Metrics, Fluentd/Loki Logs, GitOps via ArgoCD and HTTPS via AWS ACM.","uid":"34c740af-8954-42f2-8520-94448a3ea8cd","generation":1,"etag":"fe83ce5c544fa28fe0dc59719768342e5ef9deaa"},"apiVersion":"backstage.io/v1alpha1","kind":"System","spec":{"owner":"platform-team"},"relations":[{"type":"hasPart","target":{"kind":"api","namespace":"default","name":"dotnet-csharp-app-api"}},{"type":"hasPart","target":{"kind":"api","namespace":"default","name":"python-app-api"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"dotnet-csharp-demo-app"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"python-demo-app"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}}]}');
INSERT INTO public.final_entities VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', '85eba869f58fcbf5f44da429369e9e1d4159acc5', 'bf5eba3e-2ae1-4c4e-aaac-78c64e315df9', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/"},"name":"python-sonarqube-cicd-template","title":"Python 3.12 Web App + CI/CD with QA, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Python (Flask + Gunicorn) repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki logging, and Backstage manifest.","tags":["python","flask","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"e7ce2e2c-1a65-412c-92af-958b480db2a9","generation":1,"etag":"85eba869f58fcbf5f44da429369e9e1d4159acc5"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"python-app-demo"},"description":{"title":"Description","type":"string","description":"What does this microservice do?","default":"Python microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"python-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}},"relations":[{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"squad-plataforma"}}]}');
INSERT INTO public.final_entities VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', '0ed790ee9dd9c7c6d26225eabb3faacb45a26e4e', 'df715d42-21f2-4caa-a4a8-e7ab0eca0496', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/"},"name":"python-app-api","title":"Python Flask App REST API","description":"Interface REST para consulta de status, saúde e telemetria da aplicação Python","uid":"091b50f1-ebf5-4713-8048-9ad7b9d59968","generation":1,"etag":"0ed790ee9dd9c7c6d26225eabb3faacb45a26e4e"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Python App API\n  version: \"1.0.0\"\npaths:\n  /:\n    get:\n      summary: Overview & HTML Dashboard\n      responses:\n        ''200'':\n          description: OK\n  /api/info:\n    get:\n      summary: System & client runtime information\n      responses:\n        ''200'':\n          description: OK\n  /healthz:\n    get:\n      summary: Liveness probe\n      responses:\n        ''200'':\n          description: OK\n  /ready:\n    get:\n      summary: Readiness probe\n      responses:\n        ''200'':\n          description: OK\n  /metrics:\n    get:\n      summary: Prometheus metrics\n      responses:\n        ''200'':\n          description: OK\n"},"relations":[{"type":"apiProvidedBy","target":{"kind":"component","namespace":"default","name":"python-demo-app"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"apps-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', '3ad962943566d9a3950d29dd5d6fb4ca63f02d6f', '82d7e6b8-a461-40e4-94e3-c7cdfea01fef', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage"},"name":"backstage-portal","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","uid":"5d61d659-a82b-47c2-b6a1-949fd04b6f27","generation":1,"etag":"3ad962943566d9a3950d29dd5d6fb4ca63f02d6f"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"website","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'ecb1f3b059032f35019f4810b1dbaacb4fa3a2be', 'edd8dc6a-22d0-4fb2-b2b1-291b7a41a314', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/"},"name":"jvm-springboot-sonarqube-cicd-template","title":"JVM Spring Boot (Java 21) + CI/CD with SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Java 21 / Spring Boot 3.3 microservice repository with Maven + JaCoCo tests, SonarQube Quality Gate (SpotBugs/FindSecBugs & OWASP), Prometheus /metrics, Fluentd -> Loki JSON logs, and Backstage manifest.","tags":["java","jvm","springboot","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"70145be8-a40e-4a5a-b0ce-25af2aeadd94","generation":1,"etag":"ecb1f3b059032f35019f4810b1dbaacb4fa3a2be"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"springboot-app-demo"},"description":{"title":"Description","type":"string","description":"What does this Spring Boot microservice do?","default":"JVM Spring Boot 3.3 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"springboot-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}},"relations":[{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"squad-plataforma"}}]}');
INSERT INTO public.final_entities VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', '3ed1d60aa4d478e03761fe9cfc510074c9d52621', 'beae3b6e-f058-4047-bc4e-8b36eb83fc1a', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"dotnet-csharp-demo-app","grafana/tag-selector":"service:dotnet-csharp-demo-app","grafana/overview-dashboard":"http://grafana.799416476486.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe","argocd/app-name":"dotnet-csharp-app"},"name":"dotnet-csharp-demo-app","title":".NET 8 C# Minimal API Microservice","description":"App Web em C# (.NET 8 Minimal API) com Prometheus metrics, logs JSON para Grafana Loki, SonarQube Quality Gate, GitOps via ArgoCD e HTTPS via AWS ACM.","tags":["dotnet","csharp","sonarqube","prometheus","fluentd","loki","grafana","k8s","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app","title":"GitHub Source Code","icon":"github"},{"url":"http://dotnet.799416476486.realhandsonlabs.net","title":".NET 8 C# Live App (HTTP)","icon":"web"},{"url":"https://dotnet.799416476486.realhandsonlabs.net","title":".NET 8 C# Live App (HTTPS ACM)","icon":"lock"},{"url":"http://dotnet.799416476486.realhandsonlabs.net/metrics","title":"Prometheus Metrics (/metrics)","icon":"gauge"},{"url":"http://grafana.799416476486.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe","title":"Grafana Dashboard (Golden Signals & Loki Logs)","icon":"dashboard"},{"url":"http://sonarqube.799416476486.realhandsonlabs.net/dashboard?id=apps-demo-2026","title":"SonarQube Quality Gate","icon":"check"},{"url":"https://argocd.799416476486.realhandsonlabs.net/applications/dotnet-csharp-app","title":"ArgoCD GitOps","icon":"sync"}],"uid":"6fed0b98-a145-41ce-a88f-be349334888d","generation":1,"etag":"3ed1d60aa4d478e03761fe9cfc510074c9d52621"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","providesApis":["dotnet-csharp-app-api"],"dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"apps-demo-2026"}},{"type":"providesApi","target":{"kind":"api","namespace":"default","name":"dotnet-csharp-app-api"}}]}');
INSERT INTO public.final_entities VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', '8202a630f5aaf0a0dc85d1aa6c7a8f9c3359aec0', 'bf2f3dde-e29d-46cf-adc3-c4dacb6670f9', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"argocd","backstage.io/kubernetes-namespace":"argocd","backstage.io/kubernetes-label-selector":"app.kubernetes.io/part-of=argocd"},"name":"argocd","description":"ArgoCD GitOps Continuous Delivery Controller on EKS","uid":"a2837fe8-7139-43d3-9d5e-67166f32ade2","generation":1,"etag":"8202a630f5aaf0a0dc85d1aa6c7a8f9c3359aec0"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', '7e4f528cd139f936bbbd83b1bd9f9f6177bd82a3', '7bb09872-853e-48de-96cf-3ae2ec24f8a2', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"sonarqube","backstage.io/kubernetes-namespace":"sonarqube"},"name":"sonarqube","description":"SonarQube QA & Security Scanner on EKS (OWASP Dependency-Check, FindSecBugs & YAML/K8s Security plugins)","uid":"6cf1741d-cc32-41d6-83f5-2e02fe66c637","generation":1,"etag":"7e4f528cd139f936bbbd83b1bd9f9f6177bd82a3"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', '1372f99c0a94ccd979b5dc3b14b1c5abab75fa96', 'f3d5121d-e29c-4183-9ebb-bb599ad818c2', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/"},"name":"dotnet-sonarqube-cicd-template","title":".NET 8 C# Web App + CI/CD with QA, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete .NET 8 C# Minimal API repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki logging, and Backstage manifest.","tags":["dotnet","csharp","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"bd2f3497-ed87-4202-a8a4-4613a3b58f78","generation":1,"etag":"1372f99c0a94ccd979b5dc3b14b1c5abab75fa96"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"dotnet-csharp-app-demo"},"description":{"title":"Description","type":"string","description":"What does this microservice do?","default":".NET 8 C# microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"dotnet-csharp-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}},"relations":[{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"squad-plataforma"}}]}');
INSERT INTO public.final_entities VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'dfd3bb8eea67b6b0a06aa464e504a6b689d8219b', 'a375f030-f945-4ffb-a39c-716deeca8142', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/"},"name":"generated-64bf0f42f04286e509e88978a740e76f33a6cc2a","uid":"b997bba0-79d4-45ab-9ba3-3b007e722a86","generation":1,"etag":"dfd3bb8eea67b6b0a06aa464e504a6b689d8219b"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'a9f823cfd2a53c0d9ddded8bbc175f4f0b225f62', 'a012a908-3929-4134-a222-445c5d494193', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"grafana","backstage.io/kubernetes-namespace":"grafana"},"name":"grafana","description":"Grafana Observability UI receiving metrics from Prometheus on EKS","uid":"e7874ba5-8387-43bb-82a2-588659c8f617","generation":1,"etag":"a9f823cfd2a53c0d9ddded8bbc175f4f0b225f62"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["component:default/prometheus-monitoring","resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"component","namespace":"default","name":"prometheus-monitoring"}},{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', '35552bf9cf70a7f02f6f83ffc2aaa5dec8bcf3bc', '326c0eee-4eb2-4f26-add7-cc6fc7b20429', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec","uid":"f4a11b84-32b1-4802-a206-b75b16465f11","generation":1,"etag":"35552bf9cf70a7f02f6f83ffc2aaa5dec8bcf3bc"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"file","target":"/etc/backstage/catalog-entities.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'c08c9fb63bf1edcecdc40170370311609324e0f8', '58e0f0fa-9cbd-42b8-bd87-b066d2b872bb', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/","github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/kubernetes-id":"samba-ad-dc","backstage.io/kubernetes-namespace":"default"},"name":"samba-ad-dc","description":"Samba 4 Active Directory Multi-DC (DC1 Principal + DC2 Réplica em Multi-AZ com --dns-backend=NONE e Route 53 Private Hosted Zone)","tags":["samba4","active-directory","ldap","kerberos","route53"],"uid":"d8aa8894-4fe0-436a-99c1-3ee2c3439e11","generation":1,"etag":"c08c9fb63bf1edcecdc40170370311609324e0f8"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","providesApis":["ldap-ad-api"]},"relations":[{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"freeradius-mfa"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"keycloak-sso"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}},{"type":"providesApi","target":{"kind":"api","namespace":"default","name":"ldap-ad-api"}}]}');
INSERT INTO public.final_entities VALUES ('2f0b622d-7a82-4e30-a16e-d344a1d3fc10', 'ec3ea390aeae26a166b9fd10a84d7f5ca7c7c7d6', 'a2cfafe0-3685-4483-a67f-b88a98fe0a67', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/"},"name":"generated-b4f29ca1863623b0dea4276cfa3970b897899c36","uid":"2f0b622d-7a82-4e30-a16e-d344a1d3fc10","generation":1,"etag":"ec3ea390aeae26a166b9fd10a84d7f5ca7c7c7d6"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'dc8300e3173ac09b771b2ddb8c2f67cb308cdca0', 'dd8987ad-3e96-4a63-b2f4-b4f35777b512', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/"},"name":"generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a","uid":"50cc71b8-67dc-4dac-91e0-57841741c1a5","generation":1,"etag":"dc8300e3173ac09b771b2ddb8c2f67cb308cdca0"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'fc8288ef4828c13323cadf43ebcefa7288a91ef4', 'a2ec21c4-7035-4257-819a-d82397253c59', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"saml-idp-api","description":"Endpoint SAML 2.0 Identity Provider do Keycloak (sso.empresa.local)","uid":"40be89b0-5809-47dc-a88c-5053d2b38724","generation":1,"etag":"fc8288ef4828c13323cadf43ebcefa7288a91ef4"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Keycloak SAML 2.0 IdP Descriptor\n  version: \"1.0.0\"\npaths:\n  /realms/empresa/protocol/saml/descriptor:\n    get:\n      summary: Retorna o XML de metadados SAML 2.0 do Realm empresa\n      responses:\n        \"200\":\n          description: SAML 2.0 Metadata XML\n"},"relations":[{"type":"apiProvidedBy","target":{"kind":"component","namespace":"default","name":"keycloak-sso"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}}]}');
INSERT INTO public.final_entities VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', '4f08d9a040cccbf2fd6332ddb622b13c68a90f50', '3d7e9736-971b-4c2d-a234-c2031071e79c', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system"},"name":"kube-demo-eks","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","uid":"bd7f67a9-56d3-4906-8ae7-e5a360c38903","generation":1,"etag":"4f08d9a040cccbf2fd6332ddb622b13c68a90f50"},"apiVersion":"backstage.io/v1alpha1","kind":"Resource","spec":{"type":"kubernetes-cluster","owner":"platform-team","system":"kube-demo-2026"},"relations":[{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"argocd"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"backstage-portal"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"dotnet-csharp-demo-app"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"grafana"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"prometheus"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"python-demo-app"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"sonarqube"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'd41ef0364c1db5ce21625ee34a0b786ca237c8be', '88d20c73-3cc9-450a-98ca-b75b39cd263e', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"prometheus","backstage.io/kubernetes-namespace":"monitoring","backstage.io/kubernetes-label-selector":"app.kubernetes.io/name=prometheus"},"name":"prometheus","description":"Prometheus Metrics Server & Node Exporter on EKS","uid":"5d7e145e-f768-46d6-9fe9-64263ace073e","generation":1,"etag":"d41ef0364c1db5ce21625ee34a0b786ca237c8be"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', '85222f82be7f25cea9dadfb1d45bab8016860f6d', 'c10b4310-2724-4c52-9182-5f2a23fc2c5d', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/microservice-template/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/"},"name":"standard-microservice-template","title":"Standard Microservice with CI/CD, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a ready-to-use repository with a test pipeline, SonarQube Quality Gate validation, Prometheus metrics, Fluentd/Loki logging, and Backstage manifest.","tags":["node","python","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"270eff48-d8a7-4539-8bcc-c5aadd2103fb","generation":1,"etag":"85222f82be7f25cea9dadfb1d45bab8016860f6d"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$"},"description":{"title":"Description","type":"string","description":"What does this microservice do?"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"microservice-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}},"relations":[{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"squad-plataforma"}}]}');
INSERT INTO public.final_entities VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'e2d62894839313cfa8a74c2f05f80042d1d6d949', 'd30e6140-3e70-4512-b5fd-c298ae0768eb', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"platform-team","description":"Platform Engineering & DevEx Team","uid":"c6bce8e1-4852-4234-aee5-38f6e029b95f","generation":1,"etag":"e2d62894839313cfa8a74c2f05f80042d1d6d949"},"apiVersion":"backstage.io/v1alpha1","kind":"Group","spec":{"type":"team","children":[],"members":["guest"]},"relations":[{"type":"hasMember","target":{"kind":"user","namespace":"default","name":"guest"}},{"type":"ownerOf","target":{"kind":"api","namespace":"default","name":"dotnet-csharp-app-api"}},{"type":"ownerOf","target":{"kind":"api","namespace":"default","name":"ldap-ad-api"}},{"type":"ownerOf","target":{"kind":"api","namespace":"default","name":"oidc-idp-api"}},{"type":"ownerOf","target":{"kind":"api","namespace":"default","name":"python-app-api"}},{"type":"ownerOf","target":{"kind":"api","namespace":"default","name":"radius-mfa-api"}},{"type":"ownerOf","target":{"kind":"api","namespace":"default","name":"saml-idp-api"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"argocd"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"backstage-portal"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"dotnet-csharp-demo-app"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"freeradius-mfa"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"grafana"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"keycloak-sso"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"prometheus"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"python-demo-app"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"samba-ad-dc"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"sonarqube"}},{"type":"ownerOf","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownerOf","target":{"kind":"system","namespace":"default","name":"apps-demo-2026"}},{"type":"ownerOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}},{"type":"ownerOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}}]}');
INSERT INTO public.final_entities VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'd17743147f1476787aa41c2fd4032cefbeed4fd5', 'b7f6b11b-b10e-43fe-be1b-f5ee982a7a14', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/","github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/kubernetes-id":"keycloak-sso","backstage.io/kubernetes-namespace":"default"},"name":"keycloak-sso","description":"Servidor Keycloak IAM (Broker SAML 2.0, OAuth2 e OIDC) federado via LDAP ao Samba 4 AD para autenticar Backstage, ArgoCD, Grafana e Apps Demo","tags":["keycloak","saml2","oidc","sso","mfa"],"uid":"59bcae1b-0310-4bf1-9216-1cc4fc975884","generation":1,"etag":"d17743147f1476787aa41c2fd4032cefbeed4fd5"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","dependsOn":["component:default/samba-ad-dc","component:default/freeradius-mfa"],"providesApis":["saml-idp-api","oidc-idp-api"]},"relations":[{"type":"dependsOn","target":{"kind":"component","namespace":"default","name":"freeradius-mfa"}},{"type":"dependsOn","target":{"kind":"component","namespace":"default","name":"samba-ad-dc"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}},{"type":"providesApi","target":{"kind":"api","namespace":"default","name":"oidc-idp-api"}},{"type":"providesApi","target":{"kind":"api","namespace":"default","name":"saml-idp-api"}}]}');
INSERT INTO public.final_entities VALUES ('3a5d3700-d0c8-4bb4-bc90-1abb32008733', 'f356b157dbc6416712b60a3af3c31b55b4629a61', 'd6ba509d-6424-4eba-ba34-d33a5bd32635', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"generated-230c2622c092081637053d0a834587aef4c2bae2","uid":"3a5d3700-d0c8-4bb4-bc90-1abb32008733","generation":1,"etag":"f356b157dbc6416712b60a3af3c31b55b4629a61"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'ce6b84fb730b28fa46b29ecd5affdbb917219c4b', 'a3b28a25-26ee-4c87-804a-9209f0008f17', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/","github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/kubernetes-id":"freeradius-mfa","backstage.io/kubernetes-namespace":"default"},"name":"freeradius-mfa","description":"Servidor FreeRADIUS + PAM Google Authenticator (TOTP MFA) integrado ao Samba 4 AD para autenticação geral e MFA na VPC do EKS","tags":["radius","freeradius","mfa","totp"],"uid":"78aca34d-c7ad-4316-9d74-afd733e893a3","generation":1,"etag":"ce6b84fb730b28fa46b29ecd5affdbb917219c4b"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","dependsOn":["component:default/samba-ad-dc"],"providesApis":["radius-mfa-api"]},"relations":[{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"keycloak-sso"}},{"type":"dependsOn","target":{"kind":"component","namespace":"default","name":"samba-ad-dc"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}},{"type":"providesApi","target":{"kind":"api","namespace":"default","name":"radius-mfa-api"}}]}');
INSERT INTO public.final_entities VALUES ('e0ad8fc3-b7ae-4b03-a636-748f7994afe7', 'd470bd8eb83d600ae78831c4d096bb3fa4ad259b', 'acfb4a5b-13b9-4999-bdec-d9569c748e5b', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/"},"name":"generated-7692b664b197d2303b0a28bb177c1b133773311c","uid":"e0ad8fc3-b7ae-4b03-a636-748f7994afe7","generation":1,"etag":"d470bd8eb83d600ae78831c4d096bb3fa4ad259b"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', '98961b9855eb4bb3555bf160c58d0448b81efdd7', '3db0bcf8-02b5-45b1-960c-8472c1a9265b', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"kube-demo-2026","description":"AWS EKS 1.35 Platform, GitOps, Observability & Developer Portal","uid":"c061cd8b-71b0-4ad0-8a8c-064863bb4cf0","generation":1,"etag":"98961b9855eb4bb3555bf160c58d0448b81efdd7"},"apiVersion":"backstage.io/v1alpha1","kind":"System","spec":{"owner":"platform-team"},"relations":[{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"argocd"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"backstage-portal"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"grafana"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"prometheus"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"sonarqube"}},{"type":"hasPart","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}}]}');
INSERT INTO public.final_entities VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', '004ec17646acc85b1818b995323a854d0d4daa4a', '34e7cdf8-b9b2-4f7e-bb19-83da6cec7272', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"guest","uid":"c594da02-5da3-463f-b953-c6b40ea03639","generation":1,"etag":"004ec17646acc85b1818b995323a854d0d4daa4a"},"apiVersion":"backstage.io/v1alpha1","kind":"User","spec":{"profile":{"displayName":"Guest User","email":"guest@empresa.local"},"memberOf":["platform-team"]},"relations":[{"type":"memberOf","target":{"kind":"group","namespace":"default","name":"platform-team"}}]}');
INSERT INTO public.final_entities VALUES ('257e492a-1177-431b-b323-5689c6369907', '03fd60917851db30e17b3025b46ad91bb8e27108', '6c3a9c6d-0d36-47df-a6ab-67974c1e67d3', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"radius-mfa-api","description":"Endpoint FreeRADIUS Auth (UDP 1812) e Acct (UDP 1813) com suporte a MFA (radius.empresa.local)","uid":"257e492a-1177-431b-b323-5689c6369907","generation":1,"etag":"03fd60917851db30e17b3025b46ad91bb8e27108"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"grpc","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"syntax = \"proto3\";\nservice FreeRadiusMFA {\n  // UDP radius.empresa.local:1812 (Auth + MFA)\n  // UDP radius.empresa.local:1813 (Accounting)\n}\n"},"relations":[{"type":"apiProvidedBy","target":{"kind":"component","namespace":"default","name":"freeradius-mfa"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}}]}');
INSERT INTO public.final_entities VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', '5fbd01012e624d08f9a810e16a94ff70c4954bc1', '75354c96-1eaa-4364-b16b-521e5a2cc658', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"oidc-idp-api","description":"Endpoint OpenID Connect (OIDC) Discovery do Keycloak (sso.empresa.local)","uid":"f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2","generation":1,"etag":"5fbd01012e624d08f9a810e16a94ff70c4954bc1"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Keycloak OIDC Discovery API\n  version: \"1.0.0\"\npaths:\n  /realms/empresa/.well-known/openid-configuration:\n    get:\n      summary: Retorna a configuracao OIDC do Realm empresa\n      responses:\n        \"200\":\n          description: OIDC Discovery JSON\n"},"relations":[{"type":"apiProvidedBy","target":{"kind":"component","namespace":"default","name":"keycloak-sso"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}}]}');
INSERT INTO public.final_entities VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'b63654eb57f875669bf4c165eb4e0a7ca9b1cc57', '1f5ce317-bb80-473b-8192-8894e512e777', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"ldap-ad-api","description":"Endpoint LDAP/LDAPS Round-Robin do Samba 4 AD (ldap://ad.empresa.local:389)","uid":"a47d058b-3461-44b2-9feb-97fec94b206f","generation":1,"etag":"b63654eb57f875669bf4c165eb4e0a7ca9b1cc57"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"grpc","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"syntax = \"proto3\";\nservice ActiveDirectoryLDAP {\n  // ldap://ad.empresa.local:389 (Round-Robin DC1 & DC2)\n  // Base DN: DC=empresa,DC=local\n}\n"},"relations":[{"type":"apiProvidedBy","target":{"kind":"component","namespace":"default","name":"samba-ad-dc"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}}]}');
INSERT INTO public.final_entities VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'f5fa00d194e45a49cffcc0f5d72f6b1a4e6b97cd', 'e1f16060-1b4f-4c9c-90fc-7f76e63a4434', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"samba-ad-keycloak-iam","description":"Arquitetura Corporativa IAM na VPC do EKS (Samba 4 AD Multi-DC sem DNS interno + Route 53 Private Zone + FreeRADIUS MFA + Keycloak SAML 2.0 / OIDC)","uid":"2a9beea9-e004-4fd5-8dda-11f2c52f5f07","generation":1,"etag":"f5fa00d194e45a49cffcc0f5d72f6b1a4e6b97cd"},"apiVersion":"backstage.io/v1alpha1","kind":"System","spec":{"owner":"platform-team"},"relations":[{"type":"hasPart","target":{"kind":"api","namespace":"default","name":"ldap-ad-api"}},{"type":"hasPart","target":{"kind":"api","namespace":"default","name":"oidc-idp-api"}},{"type":"hasPart","target":{"kind":"api","namespace":"default","name":"radius-mfa-api"}},{"type":"hasPart","target":{"kind":"api","namespace":"default","name":"saml-idp-api"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"freeradius-mfa"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"keycloak-sso"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"samba-ad-dc"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}}]}');


--
-- Data for Name: knex_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.knex_migrations VALUES (1, '20200511113813_init.js', 1, '2026-11-02 00:47:17.642+00');
INSERT INTO public.knex_migrations VALUES (2, '20200520140700_location_update_log_table.js', 1, '2026-11-02 00:47:17.652+00');
INSERT INTO public.knex_migrations VALUES (3, '20200527114117_location_update_log_latest_view.js', 1, '2026-11-02 00:47:17.656+00');
INSERT INTO public.knex_migrations VALUES (4, '20200702153613_entities.js', 1, '2026-11-02 00:47:17.694+00');
INSERT INTO public.knex_migrations VALUES (5, '20200721115244_location_update_log_latest_deduplicate.js', 1, '2026-11-02 00:47:17.699+00');
INSERT INTO public.knex_migrations VALUES (6, '20200805163904_location_update_log_duplication_fix.js', 1, '2026-11-02 00:47:17.71+00');
INSERT INTO public.knex_migrations VALUES (7, '20200807120600_entitySearch.js', 1, '2026-11-02 00:47:17.715+00');
INSERT INTO public.knex_migrations VALUES (8, '20200809202832_add_bootstrap_location.js', 1, '2026-11-02 00:47:17.719+00');
INSERT INTO public.knex_migrations VALUES (9, '20200923104503_case_insensitivity.js', 1, '2026-11-02 00:47:17.723+00');
INSERT INTO public.knex_migrations VALUES (10, '20201005122705_add_entity_full_name.js', 1, '2026-11-02 00:47:17.735+00');
INSERT INTO public.knex_migrations VALUES (11, '20201006130744_entity_data_column.js', 1, '2026-11-02 00:47:17.747+00');
INSERT INTO public.knex_migrations VALUES (12, '20201006203131_entity_remove_redundant_columns.js', 1, '2026-11-02 00:47:17.753+00');
INSERT INTO public.knex_migrations VALUES (13, '20201007201501_index_entity_search.js', 1, '2026-11-02 00:47:17.758+00');
INSERT INTO public.knex_migrations VALUES (14, '20201019130742_add_relations_table.js', 1, '2026-11-02 00:47:17.771+00');
INSERT INTO public.knex_migrations VALUES (15, '20201123205611_relations_table_uniq.js', 1, '2026-11-02 00:47:17.776+00');
INSERT INTO public.knex_migrations VALUES (16, '20201210185851_fk_index.js', 1, '2026-11-02 00:47:17.785+00');
INSERT INTO public.knex_migrations VALUES (17, '20201230103504_update_log_varchar.js', 1, '2026-11-02 00:47:17.799+00');
INSERT INTO public.knex_migrations VALUES (18, '20210209121210_locations_fk_index.js', 1, '2026-11-02 00:47:17.804+00');
INSERT INTO public.knex_migrations VALUES (19, '20210302150147_refresh_state.js', 1, '2026-11-02 00:47:17.879+00');
INSERT INTO public.knex_migrations VALUES (20, '20210622104022_refresh_state_location_key.js', 1, '2026-11-02 00:47:17.883+00');


--
-- Data for Name: knex_migrations_lock; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.knex_migrations_lock VALUES (1, 0);


--
-- Data for Name: location_update_log; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.locations VALUES ('641c80b5-88fc-4a4e-8268-7e27978d0ae7', 'bootstrap', 'bootstrap');


--
-- Data for Name: refresh_state; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.refresh_state VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'api:default/ldap-ad-api', '{"apiVersion":"backstage.io/v1alpha1","kind":"API","metadata":{"name":"ldap-ad-api","description":"Endpoint LDAP/LDAPS Round-Robin do Samba 4 AD (ldap://ad.empresa.local:389)","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"}},"spec":{"type":"grpc","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"syntax = \"proto3\";\nservice ActiveDirectoryLDAP {\n  // ldap://ad.empresa.local:389 (Round-Robin DC1 & DC2)\n  // Base DN: DC=empresa,DC=local\n}\n"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"ldap-ad-api","description":"Endpoint LDAP/LDAPS Round-Robin do Samba 4 AD (ldap://ad.empresa.local:389)","uid":"a47d058b-3461-44b2-9feb-97fec94b206f"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"grpc","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"syntax = \"proto3\";\nservice ActiveDirectoryLDAP {\n  // ldap://ad.empresa.local:389 (Round-Robin DC1 & DC2)\n  // Base DN: DC=empresa,DC=local\n}\n"}}', '{}', '[]', '2026-11-02 01:29:04.18876+00', '2026-11-02 01:27:22.480364+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('2f0b622d-7a82-4e30-a16e-d344a1d3fc10', 'location:default/generated-b4f29ca1863623b0dea4276cfa3970b897899c36', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-b4f29ca1863623b0dea4276cfa3970b897899c36","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/"},"name":"generated-b4f29ca1863623b0dea4276cfa3970b897899c36","uid":"2f0b622d-7a82-4e30-a16e-d344a1d3fc10"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml"}}', '{}', '[]', '2026-11-02 01:29:01.944593+00', '2026-11-02 00:47:17.901529+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'resource:default/kube-demo-eks', '{"apiVersion":"backstage.io/v1alpha1","kind":"Resource","metadata":{"name":"kube-demo-eks","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","annotations":{"backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"kubernetes-cluster","owner":"platform-team","system":"kube-demo-2026"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system"},"name":"kube-demo-eks","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","uid":"bd7f67a9-56d3-4906-8ae7-e5a360c38903"},"apiVersion":"backstage.io/v1alpha1","kind":"Resource","spec":{"type":"kubernetes-cluster","owner":"platform-team","system":"kube-demo-2026"}}', '{}', '[]', '2026-11-02 01:29:03.944221+00', '2026-11-02 01:27:22.066331+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'component:default/argocd', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"argocd","description":"ArgoCD GitOps Continuous Delivery Controller on EKS","annotations":{"backstage.io/kubernetes-id":"argocd","backstage.io/kubernetes-namespace":"argocd","backstage.io/kubernetes-label-selector":"app.kubernetes.io/part-of=argocd","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"argocd","backstage.io/kubernetes-namespace":"argocd","backstage.io/kubernetes-label-selector":"app.kubernetes.io/part-of=argocd"},"name":"argocd","description":"ArgoCD GitOps Continuous Delivery Controller on EKS","uid":"a2837fe8-7139-43d3-9d5e-67166f32ade2"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-02 01:29:03.944221+00', '2026-11-02 01:27:22.066331+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('3a5d3700-d0c8-4bb4-bc90-1abb32008733', 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-230c2622c092081637053d0a834587aef4c2bae2","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"generated-230c2622c092081637053d0a834587aef4c2bae2","uid":"3a5d3700-d0c8-4bb4-bc90-1abb32008733"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml"}}', '{}', '[]', '2026-11-02 01:29:01.944593+00', '2026-11-02 00:47:17.901529+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'location:default/generated-e1e842392fd0da6efe989d25722f835228d60e05', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-e1e842392fd0da6efe989d25722f835228d60e05","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/"},"name":"generated-e1e842392fd0da6efe989d25722f835228d60e05","uid":"0292df28-4efd-43fd-a9ee-52ece26b6185"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml"}}', '{}', '[]', '2026-11-02 01:29:01.944593+00', '2026-11-02 00:47:17.901529+00', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'template:default/dotnet-sonarqube-cicd-template', '{"apiVersion":"backstage.io/v1beta2","kind":"Template","metadata":{"name":"dotnet-sonarqube-cicd-template","title":".NET 8 C# Web App + CI/CD with QA, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete .NET 8 C# Minimal API repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki logging, and Backstage manifest.","tags":["dotnet","csharp","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml"}},"spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"dotnet-csharp-app-demo"},"description":{"title":"Description","type":"string","description":"What does this microservice do?","default":".NET 8 C# microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"dotnet-csharp-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/"},"name":"dotnet-sonarqube-cicd-template","title":".NET 8 C# Web App + CI/CD with QA, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete .NET 8 C# Minimal API repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki logging, and Backstage manifest.","tags":["dotnet","csharp","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"bd2f3497-ed87-4202-a8a4-4613a3b58f78"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"dotnet-csharp-app-demo"},"description":{"title":"Description","type":"string","description":"What does this microservice do?","default":".NET 8 C# microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"dotnet-csharp-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{}', '[]', '2026-11-02 01:29:04.18876+00', '2026-11-02 01:27:22.218588+00', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'location:default/generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/"},"name":"generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a","uid":"50cc71b8-67dc-4dac-91e0-57841741c1a5"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml"}}', '{}', '[]', '2026-11-02 01:29:01.944593+00', '2026-11-02 00:47:17.901529+00', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('9575b37e-e899-4803-9b03-61add445781f', 'location:default/generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/"},"name":"generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce","uid":"9575b37e-e899-4803-9b03-61add445781f"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml"}}', '{}', '[]', '2026-11-02 01:29:01.944593+00', '2026-11-02 00:47:17.901529+00', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"file","target":"/etc/backstage/catalog-entities.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec","uid":"f4a11b84-32b1-4802-a206-b75b16465f11"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"file","target":"/etc/backstage/catalog-entities.yaml"}}', '{}', '[]', '2026-11-02 01:29:01.944593+00', '2026-11-02 00:47:17.901529+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('83c4b685-a74b-4228-a442-a3903e0778b0', 'location:default/generated-689c18882dc297803e1a420c73b8783d094c8e17', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-689c18882dc297803e1a420c73b8783d094c8e17","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/"},"name":"generated-689c18882dc297803e1a420c73b8783d094c8e17","uid":"83c4b685-a74b-4228-a442-a3903e0778b0"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml"}}', '{}', '[]', '2026-11-02 01:29:01.944593+00', '2026-11-02 00:47:17.901529+00', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'api:default/saml-idp-api', '{"apiVersion":"backstage.io/v1alpha1","kind":"API","metadata":{"name":"saml-idp-api","description":"Endpoint SAML 2.0 Identity Provider do Keycloak (sso.empresa.local)","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"}},"spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Keycloak SAML 2.0 IdP Descriptor\n  version: \"1.0.0\"\npaths:\n  /realms/empresa/protocol/saml/descriptor:\n    get:\n      summary: Retorna o XML de metadados SAML 2.0 do Realm empresa\n      responses:\n        \"200\":\n          description: SAML 2.0 Metadata XML\n"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"saml-idp-api","description":"Endpoint SAML 2.0 Identity Provider do Keycloak (sso.empresa.local)","uid":"40be89b0-5809-47dc-a88c-5053d2b38724"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Keycloak SAML 2.0 IdP Descriptor\n  version: \"1.0.0\"\npaths:\n  /realms/empresa/protocol/saml/descriptor:\n    get:\n      summary: Retorna o XML de metadados SAML 2.0 do Realm empresa\n      responses:\n        \"200\":\n          description: SAML 2.0 Metadata XML\n"}}', '{}', '[]', '2026-11-02 01:29:04.18876+00', '2026-11-02 01:27:22.480364+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('e0ad8fc3-b7ae-4b03-a636-748f7994afe7', 'location:default/generated-7692b664b197d2303b0a28bb177c1b133773311c', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-7692b664b197d2303b0a28bb177c1b133773311c","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/"},"name":"generated-7692b664b197d2303b0a28bb177c1b133773311c","uid":"e0ad8fc3-b7ae-4b03-a636-748f7994afe7"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml"}}', '{}', '[]', '2026-11-02 01:29:01.944593+00', '2026-11-02 00:47:17.901529+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'component:default/python-demo-app', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"python-demo-app","title":"Python 3.12 Flask Microservice","description":"App Web em Python 3.12 (Flask) com Prometheus metrics, logs JSON para Grafana Loki, SonarQube Quality Gate, GitOps via ArgoCD e HTTPS via AWS ACM.","annotations":{"backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"python-demo-app","grafana/tag-selector":"service:python-demo-app","grafana/overview-dashboard":"http://grafana.799416476486.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12","argocd/app-name":"python-app","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml"},"tags":["python","flask","sonarqube","prometheus","fluentd","loki","grafana","k8s","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app","title":"GitHub Source Code","icon":"github"},{"url":"http://python.799416476486.realhandsonlabs.net","title":"Python 3.12 Live App (HTTP)","icon":"web"},{"url":"https://python.799416476486.realhandsonlabs.net","title":"Python 3.12 Live App (HTTPS ACM)","icon":"lock"},{"url":"http://python.799416476486.realhandsonlabs.net/metrics","title":"Prometheus Metrics (/metrics)","icon":"gauge"},{"url":"http://grafana.799416476486.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12","title":"Grafana Dashboard (Golden Signals & Loki Logs)","icon":"dashboard"},{"url":"http://sonarqube.799416476486.realhandsonlabs.net/dashboard?id=apps-demo-2026","title":"SonarQube Quality Gate","icon":"check"},{"url":"https://argocd.799416476486.realhandsonlabs.net/applications/python-app","title":"ArgoCD GitOps","icon":"sync"}]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","providesApis":["python-app-api"],"dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"python-demo-app","grafana/tag-selector":"service:python-demo-app","grafana/overview-dashboard":"http://grafana.799416476486.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12","argocd/app-name":"python-app"},"name":"python-demo-app","title":"Python 3.12 Flask Microservice","description":"App Web em Python 3.12 (Flask) com Prometheus metrics, logs JSON para Grafana Loki, SonarQube Quality Gate, GitOps via ArgoCD e HTTPS via AWS ACM.","tags":["python","flask","sonarqube","prometheus","fluentd","loki","grafana","k8s","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app","title":"GitHub Source Code","icon":"github"},{"url":"http://python.799416476486.realhandsonlabs.net","title":"Python 3.12 Live App (HTTP)","icon":"web"},{"url":"https://python.799416476486.realhandsonlabs.net","title":"Python 3.12 Live App (HTTPS ACM)","icon":"lock"},{"url":"http://python.799416476486.realhandsonlabs.net/metrics","title":"Prometheus Metrics (/metrics)","icon":"gauge"},{"url":"http://grafana.799416476486.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12","title":"Grafana Dashboard (Golden Signals & Loki Logs)","icon":"dashboard"},{"url":"http://sonarqube.799416476486.realhandsonlabs.net/dashboard?id=apps-demo-2026","title":"SonarQube Quality Gate","icon":"check"},{"url":"https://argocd.799416476486.realhandsonlabs.net/applications/python-app","title":"ArgoCD GitOps","icon":"sync"}],"uid":"7d02e7b7-48b7-43fd-abe6-5650785ed3de"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","providesApis":["python-app-api"],"dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-02 01:29:03.944221+00', '2026-11-02 01:27:22.208349+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'template:default/jvm-springboot-sonarqube-cicd-template', '{"apiVersion":"backstage.io/v1beta2","kind":"Template","metadata":{"name":"jvm-springboot-sonarqube-cicd-template","title":"JVM Spring Boot (Java 21) + CI/CD with SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Java 21 / Spring Boot 3.3 microservice repository with Maven + JaCoCo tests, SonarQube Quality Gate (SpotBugs/FindSecBugs & OWASP), Prometheus /metrics, Fluentd -> Loki JSON logs, and Backstage manifest.","tags":["java","jvm","springboot","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml"}},"spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"springboot-app-demo"},"description":{"title":"Description","type":"string","description":"What does this Spring Boot microservice do?","default":"JVM Spring Boot 3.3 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"springboot-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/"},"name":"jvm-springboot-sonarqube-cicd-template","title":"JVM Spring Boot (Java 21) + CI/CD with SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Java 21 / Spring Boot 3.3 microservice repository with Maven + JaCoCo tests, SonarQube Quality Gate (SpotBugs/FindSecBugs & OWASP), Prometheus /metrics, Fluentd -> Loki JSON logs, and Backstage manifest.","tags":["java","jvm","springboot","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"70145be8-a40e-4a5a-b0ce-25af2aeadd94"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"springboot-app-demo"},"description":{"title":"Description","type":"string","description":"What does this Spring Boot microservice do?","default":"JVM Spring Boot 3.3 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"springboot-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{}', '[]', '2026-11-02 01:29:04.18876+00', '2026-11-02 01:27:22.555786+00', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('b9d0245c-c6f9-4214-aa46-9d84d2235fce', 'location:default/generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/microservice-template/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/"},"name":"generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98","uid":"b9d0245c-c6f9-4214-aa46-9d84d2235fce"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml"}}', '{}', '[]', '2026-11-02 01:29:01.944593+00', '2026-11-02 00:47:17.901529+00', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml');
INSERT INTO public.refresh_state VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'component:default/backstage-portal', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"backstage-portal","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","annotations":{"backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"website","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage"},"name":"backstage-portal","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","uid":"5d61d659-a82b-47c2-b6a1-949fd04b6f27"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"website","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-02 01:29:04.157827+00', '2026-11-02 01:27:22.066331+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'component:default/sonarqube', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"sonarqube","description":"SonarQube QA & Security Scanner on EKS (OWASP Dependency-Check, FindSecBugs & YAML/K8s Security plugins)","annotations":{"backstage.io/kubernetes-id":"sonarqube","backstage.io/kubernetes-namespace":"sonarqube","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"sonarqube","backstage.io/kubernetes-namespace":"sonarqube"},"name":"sonarqube","description":"SonarQube QA & Security Scanner on EKS (OWASP Dependency-Check, FindSecBugs & YAML/K8s Security plugins)","uid":"6cf1741d-cc32-41d6-83f5-2e02fe66c637"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-02 01:29:03.944221+00', '2026-11-02 01:27:22.066331+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'location:default/generated-64bf0f42f04286e509e88978a740e76f33a6cc2a', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-64bf0f42f04286e509e88978a740e76f33a6cc2a","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/"},"name":"generated-64bf0f42f04286e509e88978a740e76f33a6cc2a","uid":"b997bba0-79d4-45ab-9ba3-3b007e722a86"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml"}}', '{}', '[]', '2026-11-02 01:29:01.944593+00', '2026-11-02 00:47:17.901529+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'component:default/prometheus', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"prometheus","description":"Prometheus Metrics Server & Node Exporter on EKS","annotations":{"backstage.io/kubernetes-id":"prometheus","backstage.io/kubernetes-namespace":"monitoring","backstage.io/kubernetes-label-selector":"app.kubernetes.io/name=prometheus","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"prometheus","backstage.io/kubernetes-namespace":"monitoring","backstage.io/kubernetes-label-selector":"app.kubernetes.io/name=prometheus"},"name":"prometheus","description":"Prometheus Metrics Server & Node Exporter on EKS","uid":"5d7e145e-f768-46d6-9fe9-64263ace073e"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-02 01:29:03.944221+00', '2026-11-02 01:27:22.066331+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'system:default/kube-demo-2026', '{"apiVersion":"backstage.io/v1alpha1","kind":"System","metadata":{"name":"kube-demo-2026","description":"AWS EKS 1.35 Platform, GitOps, Observability & Developer Portal","annotations":{"backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"owner":"platform-team"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"kube-demo-2026","description":"AWS EKS 1.35 Platform, GitOps, Observability & Developer Portal","uid":"c061cd8b-71b0-4ad0-8a8c-064863bb4cf0"},"apiVersion":"backstage.io/v1alpha1","kind":"System","spec":{"owner":"platform-team"}}', '{}', '[]', '2026-11-02 01:29:03.944221+00', '2026-11-02 01:27:22.066331+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'api:default/oidc-idp-api', '{"apiVersion":"backstage.io/v1alpha1","kind":"API","metadata":{"name":"oidc-idp-api","description":"Endpoint OpenID Connect (OIDC) Discovery do Keycloak (sso.empresa.local)","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"}},"spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Keycloak OIDC Discovery API\n  version: \"1.0.0\"\npaths:\n  /realms/empresa/.well-known/openid-configuration:\n    get:\n      summary: Retorna a configuracao OIDC do Realm empresa\n      responses:\n        \"200\":\n          description: OIDC Discovery JSON\n"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"oidc-idp-api","description":"Endpoint OpenID Connect (OIDC) Discovery do Keycloak (sso.empresa.local)","uid":"f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Keycloak OIDC Discovery API\n  version: \"1.0.0\"\npaths:\n  /realms/empresa/.well-known/openid-configuration:\n    get:\n      summary: Retorna a configuracao OIDC do Realm empresa\n      responses:\n        \"200\":\n          description: OIDC Discovery JSON\n"}}', '{}', '[]', '2026-11-02 01:29:04.18876+00', '2026-11-02 01:27:22.480364+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'component:default/grafana', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"grafana","description":"Grafana Observability UI receiving metrics from Prometheus on EKS","annotations":{"backstage.io/kubernetes-id":"grafana","backstage.io/kubernetes-namespace":"grafana","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["component:default/prometheus-monitoring","resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"grafana","backstage.io/kubernetes-namespace":"grafana"},"name":"grafana","description":"Grafana Observability UI receiving metrics from Prometheus on EKS","uid":"e7874ba5-8387-43bb-82a2-588659c8f617"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["component:default/prometheus-monitoring","resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-02 01:29:03.944221+00', '2026-11-02 01:27:22.066331+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'component:default/keycloak-sso', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"keycloak-sso","description":"Servidor Keycloak IAM (Broker SAML 2.0, OAuth2 e OIDC) federado via LDAP ao Samba 4 AD para autenticar Backstage, ArgoCD, Grafana e Apps Demo","annotations":{"github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/kubernetes-id":"keycloak-sso","backstage.io/kubernetes-namespace":"default","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"},"tags":["keycloak","saml2","oidc","sso","mfa"]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","dependsOn":["component:default/samba-ad-dc","component:default/freeradius-mfa"],"providesApis":["saml-idp-api","oidc-idp-api"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/","github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/kubernetes-id":"keycloak-sso","backstage.io/kubernetes-namespace":"default"},"name":"keycloak-sso","description":"Servidor Keycloak IAM (Broker SAML 2.0, OAuth2 e OIDC) federado via LDAP ao Samba 4 AD para autenticar Backstage, ArgoCD, Grafana e Apps Demo","tags":["keycloak","saml2","oidc","sso","mfa"],"uid":"59bcae1b-0310-4bf1-9216-1cc4fc975884"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","dependsOn":["component:default/samba-ad-dc","component:default/freeradius-mfa"],"providesApis":["saml-idp-api","oidc-idp-api"]}}', '{}', '[]', '2026-11-02 01:29:04.157827+00', '2026-11-02 01:27:22.480364+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', 'user:default/guest', '{"apiVersion":"backstage.io/v1alpha1","kind":"User","metadata":{"name":"guest","annotations":{"backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"profile":{"displayName":"Guest User","email":"guest@empresa.local"},"memberOf":["platform-team"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"guest","uid":"c594da02-5da3-463f-b953-c6b40ea03639"},"apiVersion":"backstage.io/v1alpha1","kind":"User","spec":{"profile":{"displayName":"Guest User","email":"guest@empresa.local"},"memberOf":["platform-team"]}}', '{}', '[]', '2026-11-02 01:29:03.944221+00', '2026-11-02 01:27:22.066331+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'template:default/standard-microservice-template', '{"apiVersion":"backstage.io/v1beta2","kind":"Template","metadata":{"name":"standard-microservice-template","title":"Standard Microservice with CI/CD, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a ready-to-use repository with a test pipeline, SonarQube Quality Gate validation, Prometheus metrics, Fluentd/Loki logging, and Backstage manifest.","tags":["node","python","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml"}},"spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$"},"description":{"title":"Description","type":"string","description":"What does this microservice do?"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"microservice-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/microservice-template/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/"},"name":"standard-microservice-template","title":"Standard Microservice with CI/CD, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a ready-to-use repository with a test pipeline, SonarQube Quality Gate validation, Prometheus metrics, Fluentd/Loki logging, and Backstage manifest.","tags":["node","python","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"270eff48-d8a7-4539-8bcc-c5aadd2103fb"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$"},"description":{"title":"Description","type":"string","description":"What does this microservice do?"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"microservice-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{}', '[]', '2026-11-02 01:29:04.157827+00', '2026-11-02 01:27:22.555961+00', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml');
INSERT INTO public.refresh_state VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'api:default/dotnet-csharp-app-api', '{"apiVersion":"backstage.io/v1alpha1","kind":"API","metadata":{"name":"dotnet-csharp-app-api","title":".NET 8 C# Minimal API REST API","description":"Interface REST para consulta de status, saúde e telemetria da aplicação C# .NET 8","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml"}},"spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","definition":"openapi: \"3.0.0\"\ninfo:\n  title: .NET 8 C# Minimal API\n  version: \"1.0.0\"\npaths:\n  /:\n    get:\n      summary: Overview & HTML Dashboard\n      responses:\n        ''200'':\n          description: OK\n  /api/info:\n    get:\n      summary: System & client runtime information\n      responses:\n        ''200'':\n          description: OK\n  /healthz:\n    get:\n      summary: Liveness probe\n      responses:\n        ''200'':\n          description: OK\n  /ready:\n    get:\n      summary: Readiness probe\n      responses:\n        ''200'':\n          description: OK\n  /metrics:\n    get:\n      summary: Prometheus metrics\n      responses:\n        ''200'':\n          description: OK\n"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/"},"name":"dotnet-csharp-app-api","title":".NET 8 C# Minimal API REST API","description":"Interface REST para consulta de status, saúde e telemetria da aplicação C# .NET 8","uid":"63db9a4c-47aa-4c58-a818-dc552e7dd313"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","definition":"openapi: \"3.0.0\"\ninfo:\n  title: .NET 8 C# Minimal API\n  version: \"1.0.0\"\npaths:\n  /:\n    get:\n      summary: Overview & HTML Dashboard\n      responses:\n        ''200'':\n          description: OK\n  /api/info:\n    get:\n      summary: System & client runtime information\n      responses:\n        ''200'':\n          description: OK\n  /healthz:\n    get:\n      summary: Liveness probe\n      responses:\n        ''200'':\n          description: OK\n  /ready:\n    get:\n      summary: Readiness probe\n      responses:\n        ''200'':\n          description: OK\n  /metrics:\n    get:\n      summary: Prometheus metrics\n      responses:\n        ''200'':\n          description: OK\n"}}', '{}', '[]', '2026-11-02 01:29:03.944221+00', '2026-11-02 01:27:22.528372+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'api:default/python-app-api', '{"apiVersion":"backstage.io/v1alpha1","kind":"API","metadata":{"name":"python-app-api","title":"Python Flask App REST API","description":"Interface REST para consulta de status, saúde e telemetria da aplicação Python","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml"}},"spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Python App API\n  version: \"1.0.0\"\npaths:\n  /:\n    get:\n      summary: Overview & HTML Dashboard\n      responses:\n        ''200'':\n          description: OK\n  /api/info:\n    get:\n      summary: System & client runtime information\n      responses:\n        ''200'':\n          description: OK\n  /healthz:\n    get:\n      summary: Liveness probe\n      responses:\n        ''200'':\n          description: OK\n  /ready:\n    get:\n      summary: Readiness probe\n      responses:\n        ''200'':\n          description: OK\n  /metrics:\n    get:\n      summary: Prometheus metrics\n      responses:\n        ''200'':\n          description: OK\n"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/"},"name":"python-app-api","title":"Python Flask App REST API","description":"Interface REST para consulta de status, saúde e telemetria da aplicação Python","uid":"091b50f1-ebf5-4713-8048-9ad7b9d59968"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Python App API\n  version: \"1.0.0\"\npaths:\n  /:\n    get:\n      summary: Overview & HTML Dashboard\n      responses:\n        ''200'':\n          description: OK\n  /api/info:\n    get:\n      summary: System & client runtime information\n      responses:\n        ''200'':\n          description: OK\n  /healthz:\n    get:\n      summary: Liveness probe\n      responses:\n        ''200'':\n          description: OK\n  /ready:\n    get:\n      summary: Readiness probe\n      responses:\n        ''200'':\n          description: OK\n  /metrics:\n    get:\n      summary: Prometheus metrics\n      responses:\n        ''200'':\n          description: OK\n"}}', '{}', '[]', '2026-11-02 01:29:03.944221+00', '2026-11-02 01:27:22.208349+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'component:default/samba-ad-dc', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"samba-ad-dc","description":"Samba 4 Active Directory Multi-DC (DC1 Principal + DC2 Réplica em Multi-AZ com --dns-backend=NONE e Route 53 Private Hosted Zone)","annotations":{"github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/kubernetes-id":"samba-ad-dc","backstage.io/kubernetes-namespace":"default","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"},"tags":["samba4","active-directory","ldap","kerberos","route53"]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","providesApis":["ldap-ad-api"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/","github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/kubernetes-id":"samba-ad-dc","backstage.io/kubernetes-namespace":"default"},"name":"samba-ad-dc","description":"Samba 4 Active Directory Multi-DC (DC1 Principal + DC2 Réplica em Multi-AZ com --dns-backend=NONE e Route 53 Private Hosted Zone)","tags":["samba4","active-directory","ldap","kerberos","route53"],"uid":"d8aa8894-4fe0-436a-99c1-3ee2c3439e11"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","providesApis":["ldap-ad-api"]}}', '{}', '[]', '2026-11-02 01:29:04.157827+00', '2026-11-02 01:27:22.480364+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'group:default/platform-team', '{"apiVersion":"backstage.io/v1alpha1","kind":"Group","metadata":{"name":"platform-team","description":"Platform Engineering & DevEx Team","annotations":{"backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"team","children":[],"members":["guest"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"platform-team","description":"Platform Engineering & DevEx Team","uid":"c6bce8e1-4852-4234-aee5-38f6e029b95f"},"apiVersion":"backstage.io/v1alpha1","kind":"Group","spec":{"type":"team","children":[],"members":["guest"]}}', '{}', '[]', '2026-11-02 01:29:04.3254+00', '2026-11-02 01:27:22.066331+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'template:default/python-sonarqube-cicd-template', '{"apiVersion":"backstage.io/v1beta2","kind":"Template","metadata":{"name":"python-sonarqube-cicd-template","title":"Python 3.12 Web App + CI/CD with QA, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Python (Flask + Gunicorn) repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki logging, and Backstage manifest.","tags":["python","flask","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml"}},"spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"python-app-demo"},"description":{"title":"Description","type":"string","description":"What does this microservice do?","default":"Python microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"python-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/"},"name":"python-sonarqube-cicd-template","title":"Python 3.12 Web App + CI/CD with QA, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Python (Flask + Gunicorn) repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki logging, and Backstage manifest.","tags":["python","flask","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"e7ce2e2c-1a65-412c-92af-958b480db2a9"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"python-app-demo"},"description":{"title":"Description","type":"string","description":"What does this microservice do?","default":"Python microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"python-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{}', '[]', '2026-11-02 01:29:04.157827+00', '2026-11-02 01:27:22.445138+00', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'component:default/dotnet-csharp-demo-app', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"dotnet-csharp-demo-app","title":".NET 8 C# Minimal API Microservice","description":"App Web em C# (.NET 8 Minimal API) com Prometheus metrics, logs JSON para Grafana Loki, SonarQube Quality Gate, GitOps via ArgoCD e HTTPS via AWS ACM.","annotations":{"backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"dotnet-csharp-demo-app","grafana/tag-selector":"service:dotnet-csharp-demo-app","grafana/overview-dashboard":"http://grafana.799416476486.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe","argocd/app-name":"dotnet-csharp-app","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml"},"tags":["dotnet","csharp","sonarqube","prometheus","fluentd","loki","grafana","k8s","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app","title":"GitHub Source Code","icon":"github"},{"url":"http://dotnet.799416476486.realhandsonlabs.net","title":".NET 8 C# Live App (HTTP)","icon":"web"},{"url":"https://dotnet.799416476486.realhandsonlabs.net","title":".NET 8 C# Live App (HTTPS ACM)","icon":"lock"},{"url":"http://dotnet.799416476486.realhandsonlabs.net/metrics","title":"Prometheus Metrics (/metrics)","icon":"gauge"},{"url":"http://grafana.799416476486.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe","title":"Grafana Dashboard (Golden Signals & Loki Logs)","icon":"dashboard"},{"url":"http://sonarqube.799416476486.realhandsonlabs.net/dashboard?id=apps-demo-2026","title":"SonarQube Quality Gate","icon":"check"},{"url":"https://argocd.799416476486.realhandsonlabs.net/applications/dotnet-csharp-app","title":"ArgoCD GitOps","icon":"sync"}]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","providesApis":["dotnet-csharp-app-api"],"dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"dotnet-csharp-demo-app","grafana/tag-selector":"service:dotnet-csharp-demo-app","grafana/overview-dashboard":"http://grafana.799416476486.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe","argocd/app-name":"dotnet-csharp-app"},"name":"dotnet-csharp-demo-app","title":".NET 8 C# Minimal API Microservice","description":"App Web em C# (.NET 8 Minimal API) com Prometheus metrics, logs JSON para Grafana Loki, SonarQube Quality Gate, GitOps via ArgoCD e HTTPS via AWS ACM.","tags":["dotnet","csharp","sonarqube","prometheus","fluentd","loki","grafana","k8s","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app","title":"GitHub Source Code","icon":"github"},{"url":"http://dotnet.799416476486.realhandsonlabs.net","title":".NET 8 C# Live App (HTTP)","icon":"web"},{"url":"https://dotnet.799416476486.realhandsonlabs.net","title":".NET 8 C# Live App (HTTPS ACM)","icon":"lock"},{"url":"http://dotnet.799416476486.realhandsonlabs.net/metrics","title":"Prometheus Metrics (/metrics)","icon":"gauge"},{"url":"http://grafana.799416476486.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe","title":"Grafana Dashboard (Golden Signals & Loki Logs)","icon":"dashboard"},{"url":"http://sonarqube.799416476486.realhandsonlabs.net/dashboard?id=apps-demo-2026","title":"SonarQube Quality Gate","icon":"check"},{"url":"https://argocd.799416476486.realhandsonlabs.net/applications/dotnet-csharp-app","title":"ArgoCD GitOps","icon":"sync"}],"uid":"6fed0b98-a145-41ce-a88f-be349334888d"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","providesApis":["dotnet-csharp-app-api"],"dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-02 01:29:04.3254+00', '2026-11-02 01:27:22.528372+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'component:default/freeradius-mfa', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"freeradius-mfa","description":"Servidor FreeRADIUS + PAM Google Authenticator (TOTP MFA) integrado ao Samba 4 AD para autenticação geral e MFA na VPC do EKS","annotations":{"github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/kubernetes-id":"freeradius-mfa","backstage.io/kubernetes-namespace":"default","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"},"tags":["radius","freeradius","mfa","totp"]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","dependsOn":["component:default/samba-ad-dc"],"providesApis":["radius-mfa-api"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/","github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/kubernetes-id":"freeradius-mfa","backstage.io/kubernetes-namespace":"default"},"name":"freeradius-mfa","description":"Servidor FreeRADIUS + PAM Google Authenticator (TOTP MFA) integrado ao Samba 4 AD para autenticação geral e MFA na VPC do EKS","tags":["radius","freeradius","mfa","totp"],"uid":"78aca34d-c7ad-4316-9d74-afd733e893a3"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","dependsOn":["component:default/samba-ad-dc"],"providesApis":["radius-mfa-api"]}}', '{}', '[]', '2026-11-02 01:29:04.3254+00', '2026-11-02 01:27:22.480364+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'template:default/nodejs-sonarqube-cicd-template', '{"apiVersion":"backstage.io/v1beta2","kind":"Template","metadata":{"name":"nodejs-sonarqube-cicd-template","title":"Node.js 20 Web App + CI/CD with SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Node.js 20 microservice repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki JSON logs, and Backstage manifest.","tags":["node","nodejs","javascript","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml"}},"spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"nodejs-app-demo"},"description":{"title":"Description","type":"string","description":"What does this Node.js microservice do?","default":"Node.js 20 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"nodejs-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/"},"name":"nodejs-sonarqube-cicd-template","title":"Node.js 20 Web App + CI/CD with SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Node.js 20 microservice repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki JSON logs, and Backstage manifest.","tags":["node","nodejs","javascript","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"f4433dbe-aa69-4603-840e-2c2f82ce17c0"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"nodejs-app-demo"},"description":{"title":"Description","type":"string","description":"What does this Node.js microservice do?","default":"Node.js 20 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"nodejs-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{}', '[]', '2026-11-02 01:29:04.3254+00', '2026-11-02 01:27:22.55954+00', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'system:default/apps-demo-2026', '{"apiVersion":"backstage.io/v1alpha1","kind":"System","metadata":{"name":"apps-demo-2026","title":"Apps Demo 2026 Ecosystem","description":"Microservices Demo Collection (Python 3.12 Flask, .NET 8 C# Minimal API) with CI/CD, SonarQube, Prometheus Metrics, Fluentd/Loki Logs, GitOps via ArgoCD and HTTPS via AWS ACM.","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml"}},"spec":{"owner":"platform-team"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/"},"name":"apps-demo-2026","title":"Apps Demo 2026 Ecosystem","description":"Microservices Demo Collection (Python 3.12 Flask, .NET 8 C# Minimal API) with CI/CD, SonarQube, Prometheus Metrics, Fluentd/Loki Logs, GitOps via ArgoCD and HTTPS via AWS ACM.","uid":"34c740af-8954-42f2-8520-94448a3ea8cd"},"apiVersion":"backstage.io/v1alpha1","kind":"System","spec":{"owner":"platform-team"}}', '{}', '[]', '2026-11-02 01:29:04.360956+00', '2026-11-02 01:27:22.557307+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'system:default/samba-ad-keycloak-iam', '{"apiVersion":"backstage.io/v1alpha1","kind":"System","metadata":{"name":"samba-ad-keycloak-iam","description":"Arquitetura Corporativa IAM na VPC do EKS (Samba 4 AD Multi-DC sem DNS interno + Route 53 Private Zone + FreeRADIUS MFA + Keycloak SAML 2.0 / OIDC)","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"}},"spec":{"owner":"platform-team"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"samba-ad-keycloak-iam","description":"Arquitetura Corporativa IAM na VPC do EKS (Samba 4 AD Multi-DC sem DNS interno + Route 53 Private Zone + FreeRADIUS MFA + Keycloak SAML 2.0 / OIDC)","uid":"2a9beea9-e004-4fd5-8dda-11f2c52f5f07"},"apiVersion":"backstage.io/v1alpha1","kind":"System","spec":{"owner":"platform-team"}}', '{}', '[]', '2026-11-02 01:29:04.3254+00', '2026-11-02 01:27:22.480364+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('257e492a-1177-431b-b323-5689c6369907', 'api:default/radius-mfa-api', '{"apiVersion":"backstage.io/v1alpha1","kind":"API","metadata":{"name":"radius-mfa-api","description":"Endpoint FreeRADIUS Auth (UDP 1812) e Acct (UDP 1813) com suporte a MFA (radius.empresa.local)","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"}},"spec":{"type":"grpc","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"syntax = \"proto3\";\nservice FreeRadiusMFA {\n  // UDP radius.empresa.local:1812 (Auth + MFA)\n  // UDP radius.empresa.local:1813 (Accounting)\n}\n"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"radius-mfa-api","description":"Endpoint FreeRADIUS Auth (UDP 1812) e Acct (UDP 1813) com suporte a MFA (radius.empresa.local)","uid":"257e492a-1177-431b-b323-5689c6369907"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"grpc","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"syntax = \"proto3\";\nservice FreeRadiusMFA {\n  // UDP radius.empresa.local:1812 (Auth + MFA)\n  // UDP radius.empresa.local:1813 (Accounting)\n}\n"}}', '{}', '[]', '2026-11-02 01:29:04.360956+00', '2026-11-02 01:27:22.480364+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');


--
-- Data for Name: refresh_state_references; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.refresh_state_references VALUES (1, 'ConfigLocationProvider', NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec');
INSERT INTO public.refresh_state_references VALUES (2, 'ConfigLocationProvider', NULL, 'location:default/generated-64bf0f42f04286e509e88978a740e76f33a6cc2a');
INSERT INTO public.refresh_state_references VALUES (3, 'ConfigLocationProvider', NULL, 'location:default/generated-b4f29ca1863623b0dea4276cfa3970b897899c36');
INSERT INTO public.refresh_state_references VALUES (4, 'ConfigLocationProvider', NULL, 'location:default/generated-7692b664b197d2303b0a28bb177c1b133773311c');
INSERT INTO public.refresh_state_references VALUES (5, 'ConfigLocationProvider', NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2');
INSERT INTO public.refresh_state_references VALUES (6, 'ConfigLocationProvider', NULL, 'location:default/generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98');
INSERT INTO public.refresh_state_references VALUES (7, 'ConfigLocationProvider', NULL, 'location:default/generated-689c18882dc297803e1a420c73b8783d094c8e17');
INSERT INTO public.refresh_state_references VALUES (8, 'ConfigLocationProvider', NULL, 'location:default/generated-e1e842392fd0da6efe989d25722f835228d60e05');
INSERT INTO public.refresh_state_references VALUES (9, 'ConfigLocationProvider', NULL, 'location:default/generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a');
INSERT INTO public.refresh_state_references VALUES (10, 'ConfigLocationProvider', NULL, 'location:default/generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce');
INSERT INTO public.refresh_state_references VALUES (665, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'user:default/guest');
INSERT INTO public.refresh_state_references VALUES (666, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'group:default/platform-team');
INSERT INTO public.refresh_state_references VALUES (667, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'system:default/kube-demo-2026');
INSERT INTO public.refresh_state_references VALUES (668, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'resource:default/kube-demo-eks');
INSERT INTO public.refresh_state_references VALUES (669, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'component:default/backstage-portal');
INSERT INTO public.refresh_state_references VALUES (670, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'component:default/argocd');
INSERT INTO public.refresh_state_references VALUES (671, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'component:default/grafana');
INSERT INTO public.refresh_state_references VALUES (672, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'component:default/prometheus');
INSERT INTO public.refresh_state_references VALUES (673, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'component:default/sonarqube');
INSERT INTO public.refresh_state_references VALUES (674, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'component:default/grafana');
INSERT INTO public.refresh_state_references VALUES (675, NULL, 'location:default/generated-b4f29ca1863623b0dea4276cfa3970b897899c36', 'component:default/python-demo-app');
INSERT INTO public.refresh_state_references VALUES (676, NULL, 'location:default/generated-b4f29ca1863623b0dea4276cfa3970b897899c36', 'api:default/python-app-api');
INSERT INTO public.refresh_state_references VALUES (678, NULL, 'location:default/generated-689c18882dc297803e1a420c73b8783d094c8e17', 'template:default/python-sonarqube-cicd-template');
INSERT INTO public.refresh_state_references VALUES (680, NULL, 'location:default/generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a', 'template:default/jvm-springboot-sonarqube-cicd-template');
INSERT INTO public.refresh_state_references VALUES (683, NULL, 'location:default/generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce', 'template:default/nodejs-sonarqube-cicd-template');
INSERT INTO public.refresh_state_references VALUES (692, NULL, 'location:default/generated-64bf0f42f04286e509e88978a740e76f33a6cc2a', 'system:default/apps-demo-2026');
INSERT INTO public.refresh_state_references VALUES (677, NULL, 'location:default/generated-e1e842392fd0da6efe989d25722f835228d60e05', 'template:default/dotnet-sonarqube-cicd-template');
INSERT INTO public.refresh_state_references VALUES (679, NULL, 'location:default/generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98', 'template:default/standard-microservice-template');
INSERT INTO public.refresh_state_references VALUES (681, NULL, 'location:default/generated-7692b664b197d2303b0a28bb177c1b133773311c', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.refresh_state_references VALUES (682, NULL, 'location:default/generated-7692b664b197d2303b0a28bb177c1b133773311c', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.refresh_state_references VALUES (684, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.refresh_state_references VALUES (685, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'component:default/samba-ad-dc');
INSERT INTO public.refresh_state_references VALUES (686, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'component:default/freeradius-mfa');
INSERT INTO public.refresh_state_references VALUES (687, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'component:default/keycloak-sso');
INSERT INTO public.refresh_state_references VALUES (688, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'api:default/saml-idp-api');
INSERT INTO public.refresh_state_references VALUES (689, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'api:default/oidc-idp-api');
INSERT INTO public.refresh_state_references VALUES (690, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'api:default/ldap-ad-api');
INSERT INTO public.refresh_state_references VALUES (691, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'api:default/radius-mfa-api');


--
-- Data for Name: relations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.relations VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'component:default/argocd', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'group:default/platform-team', 'ownerOf', 'component:default/argocd');
INSERT INTO public.relations VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'component:default/argocd', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/argocd');
INSERT INTO public.relations VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'component:default/argocd', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'system:default/kube-demo-2026', 'hasPart', 'component:default/argocd');
INSERT INTO public.relations VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'system:default/kube-demo-2026', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'group:default/platform-team', 'ownerOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'template:default/python-sonarqube-cicd-template', 'ownedBy', 'group:default/squad-plataforma');
INSERT INTO public.relations VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'group:default/squad-plataforma', 'ownerOf', 'template:default/python-sonarqube-cicd-template');
INSERT INTO public.relations VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'component:default/samba-ad-dc', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'group:default/platform-team', 'ownerOf', 'component:default/samba-ad-dc');
INSERT INTO public.relations VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'component:default/samba-ad-dc', 'providesApi', 'api:default/ldap-ad-api');
INSERT INTO public.relations VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'api:default/ldap-ad-api', 'apiProvidedBy', 'component:default/samba-ad-dc');
INSERT INTO public.relations VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'component:default/samba-ad-dc', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'component:default/samba-ad-dc');
INSERT INTO public.relations VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'template:default/nodejs-sonarqube-cicd-template', 'ownedBy', 'group:default/squad-plataforma');
INSERT INTO public.relations VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'group:default/squad-plataforma', 'ownerOf', 'template:default/nodejs-sonarqube-cicd-template');
INSERT INTO public.relations VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'api:default/python-app-api', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'group:default/platform-team', 'ownerOf', 'api:default/python-app-api');
INSERT INTO public.relations VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'api:default/python-app-api', 'partOf', 'system:default/apps-demo-2026');
INSERT INTO public.relations VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'system:default/apps-demo-2026', 'hasPart', 'api:default/python-app-api');
INSERT INTO public.relations VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'api:default/ldap-ad-api', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'group:default/platform-team', 'ownerOf', 'api:default/ldap-ad-api');
INSERT INTO public.relations VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'api:default/ldap-ad-api', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'api:default/ldap-ad-api');
INSERT INTO public.relations VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'system:default/samba-ad-keycloak-iam', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'group:default/platform-team', 'ownerOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'api:default/dotnet-csharp-app-api', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'group:default/platform-team', 'ownerOf', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.relations VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'api:default/dotnet-csharp-app-api', 'partOf', 'system:default/apps-demo-2026');
INSERT INTO public.relations VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'system:default/apps-demo-2026', 'hasPart', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.relations VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'template:default/dotnet-sonarqube-cicd-template', 'ownedBy', 'group:default/squad-plataforma');
INSERT INTO public.relations VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'group:default/squad-plataforma', 'ownerOf', 'template:default/dotnet-sonarqube-cicd-template');
INSERT INTO public.relations VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'system:default/apps-demo-2026', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'group:default/platform-team', 'ownerOf', 'system:default/apps-demo-2026');
INSERT INTO public.relations VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', 'user:default/guest', 'memberOf', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', 'group:default/platform-team', 'hasMember', 'user:default/guest');
INSERT INTO public.relations VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'template:default/jvm-springboot-sonarqube-cicd-template', 'ownedBy', 'group:default/squad-plataforma');
INSERT INTO public.relations VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'group:default/squad-plataforma', 'ownerOf', 'template:default/jvm-springboot-sonarqube-cicd-template');
INSERT INTO public.relations VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'resource:default/kube-demo-eks', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'group:default/platform-team', 'ownerOf', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'resource:default/kube-demo-eks', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'system:default/kube-demo-2026', 'hasPart', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'api:default/saml-idp-api', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'group:default/platform-team', 'ownerOf', 'api:default/saml-idp-api');
INSERT INTO public.relations VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'api:default/saml-idp-api', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'api:default/saml-idp-api');
INSERT INTO public.relations VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'component:default/dotnet-csharp-demo-app', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'group:default/platform-team', 'ownerOf', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.relations VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'component:default/dotnet-csharp-demo-app', 'providesApi', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.relations VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'api:default/dotnet-csharp-app-api', 'apiProvidedBy', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.relations VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'component:default/dotnet-csharp-demo-app', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.relations VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'component:default/dotnet-csharp-demo-app', 'partOf', 'system:default/apps-demo-2026');
INSERT INTO public.relations VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'system:default/apps-demo-2026', 'hasPart', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.relations VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'component:default/prometheus', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'group:default/platform-team', 'ownerOf', 'component:default/prometheus');
INSERT INTO public.relations VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'component:default/prometheus', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/prometheus');
INSERT INTO public.relations VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'component:default/prometheus', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'system:default/kube-demo-2026', 'hasPart', 'component:default/prometheus');
INSERT INTO public.relations VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'component:default/keycloak-sso', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'group:default/platform-team', 'ownerOf', 'component:default/keycloak-sso');
INSERT INTO public.relations VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'component:default/keycloak-sso', 'providesApi', 'api:default/saml-idp-api');
INSERT INTO public.relations VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'api:default/saml-idp-api', 'apiProvidedBy', 'component:default/keycloak-sso');
INSERT INTO public.relations VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'component:default/keycloak-sso', 'providesApi', 'api:default/oidc-idp-api');
INSERT INTO public.relations VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'api:default/oidc-idp-api', 'apiProvidedBy', 'component:default/keycloak-sso');
INSERT INTO public.relations VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'component:default/keycloak-sso', 'dependsOn', 'component:default/samba-ad-dc');
INSERT INTO public.relations VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'component:default/samba-ad-dc', 'dependencyOf', 'component:default/keycloak-sso');
INSERT INTO public.relations VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'component:default/keycloak-sso', 'dependsOn', 'component:default/freeradius-mfa');
INSERT INTO public.relations VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'component:default/freeradius-mfa', 'dependencyOf', 'component:default/keycloak-sso');
INSERT INTO public.relations VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'component:default/keycloak-sso', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'component:default/keycloak-sso');
INSERT INTO public.relations VALUES ('257e492a-1177-431b-b323-5689c6369907', 'api:default/radius-mfa-api', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('257e492a-1177-431b-b323-5689c6369907', 'group:default/platform-team', 'ownerOf', 'api:default/radius-mfa-api');
INSERT INTO public.relations VALUES ('257e492a-1177-431b-b323-5689c6369907', 'api:default/radius-mfa-api', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('257e492a-1177-431b-b323-5689c6369907', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'api:default/radius-mfa-api');
INSERT INTO public.relations VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'component:default/sonarqube', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'group:default/platform-team', 'ownerOf', 'component:default/sonarqube');
INSERT INTO public.relations VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'component:default/sonarqube', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/sonarqube');
INSERT INTO public.relations VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'component:default/sonarqube', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'system:default/kube-demo-2026', 'hasPart', 'component:default/sonarqube');
INSERT INTO public.relations VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'template:default/standard-microservice-template', 'ownedBy', 'group:default/squad-plataforma');
INSERT INTO public.relations VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'group:default/squad-plataforma', 'ownerOf', 'template:default/standard-microservice-template');
INSERT INTO public.relations VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'component:default/grafana', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'group:default/platform-team', 'ownerOf', 'component:default/grafana');
INSERT INTO public.relations VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'component:default/grafana', 'dependsOn', 'component:default/prometheus-monitoring');
INSERT INTO public.relations VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'component:default/prometheus-monitoring', 'dependencyOf', 'component:default/grafana');
INSERT INTO public.relations VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'component:default/grafana', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/grafana');
INSERT INTO public.relations VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'component:default/grafana', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'system:default/kube-demo-2026', 'hasPart', 'component:default/grafana');
INSERT INTO public.relations VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'component:default/backstage-portal', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'group:default/platform-team', 'ownerOf', 'component:default/backstage-portal');
INSERT INTO public.relations VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'component:default/backstage-portal', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/backstage-portal');
INSERT INTO public.relations VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'component:default/backstage-portal', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'system:default/kube-demo-2026', 'hasPart', 'component:default/backstage-portal');
INSERT INTO public.relations VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'component:default/freeradius-mfa', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'group:default/platform-team', 'ownerOf', 'component:default/freeradius-mfa');
INSERT INTO public.relations VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'component:default/freeradius-mfa', 'providesApi', 'api:default/radius-mfa-api');
INSERT INTO public.relations VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'api:default/radius-mfa-api', 'apiProvidedBy', 'component:default/freeradius-mfa');
INSERT INTO public.relations VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'component:default/freeradius-mfa', 'dependsOn', 'component:default/samba-ad-dc');
INSERT INTO public.relations VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'component:default/samba-ad-dc', 'dependencyOf', 'component:default/freeradius-mfa');
INSERT INTO public.relations VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'component:default/freeradius-mfa', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'component:default/freeradius-mfa');
INSERT INTO public.relations VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'component:default/python-demo-app', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'group:default/platform-team', 'ownerOf', 'component:default/python-demo-app');
INSERT INTO public.relations VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'component:default/python-demo-app', 'providesApi', 'api:default/python-app-api');
INSERT INTO public.relations VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'api:default/python-app-api', 'apiProvidedBy', 'component:default/python-demo-app');
INSERT INTO public.relations VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'component:default/python-demo-app', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/python-demo-app');
INSERT INTO public.relations VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'component:default/python-demo-app', 'partOf', 'system:default/apps-demo-2026');
INSERT INTO public.relations VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'system:default/apps-demo-2026', 'hasPart', 'component:default/python-demo-app');
INSERT INTO public.relations VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'api:default/oidc-idp-api', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'group:default/platform-team', 'ownerOf', 'api:default/oidc-idp-api');
INSERT INTO public.relations VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'api:default/oidc-idp-api', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'api:default/oidc-idp-api');
INSERT INTO public.relations VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'group:default/platform-team', 'hasMember', 'user:default/guest');
INSERT INTO public.relations VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'user:default/guest', 'memberOf', 'group:default/platform-team');


--
-- Data for Name: search; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.search VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'kind', 'location');
INSERT INTO public.search VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'spec.type', 'file');
INSERT INTO public.search VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'spec.target', '/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'metadata.name', 'generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec');
INSERT INTO public.search VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'metadata.uid', 'f4a11b84-32b1-4802-a206-b75b16465f11');
INSERT INTO public.search VALUES ('2f0b622d-7a82-4e30-a16e-d344a1d3fc10', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('2f0b622d-7a82-4e30-a16e-d344a1d3fc10', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('2f0b622d-7a82-4e30-a16e-d344a1d3fc10', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('2f0b622d-7a82-4e30-a16e-d344a1d3fc10', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('2f0b622d-7a82-4e30-a16e-d344a1d3fc10', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/');
INSERT INTO public.search VALUES ('2f0b622d-7a82-4e30-a16e-d344a1d3fc10', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('2f0b622d-7a82-4e30-a16e-d344a1d3fc10', 'kind', 'location');
INSERT INTO public.search VALUES ('2f0b622d-7a82-4e30-a16e-d344a1d3fc10', 'spec.type', 'url');
INSERT INTO public.search VALUES ('2f0b622d-7a82-4e30-a16e-d344a1d3fc10', 'spec.target', 'https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('2f0b622d-7a82-4e30-a16e-d344a1d3fc10', 'metadata.name', 'generated-b4f29ca1863623b0dea4276cfa3970b897899c36');
INSERT INTO public.search VALUES ('2f0b622d-7a82-4e30-a16e-d344a1d3fc10', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('2f0b622d-7a82-4e30-a16e-d344a1d3fc10', 'metadata.uid', '2f0b622d-7a82-4e30-a16e-d344a1d3fc10');
INSERT INTO public.search VALUES ('e0ad8fc3-b7ae-4b03-a636-748f7994afe7', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('e0ad8fc3-b7ae-4b03-a636-748f7994afe7', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('e0ad8fc3-b7ae-4b03-a636-748f7994afe7', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('e0ad8fc3-b7ae-4b03-a636-748f7994afe7', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('e0ad8fc3-b7ae-4b03-a636-748f7994afe7', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/');
INSERT INTO public.search VALUES ('e0ad8fc3-b7ae-4b03-a636-748f7994afe7', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('e0ad8fc3-b7ae-4b03-a636-748f7994afe7', 'kind', 'location');
INSERT INTO public.search VALUES ('e0ad8fc3-b7ae-4b03-a636-748f7994afe7', 'spec.type', 'url');
INSERT INTO public.search VALUES ('e0ad8fc3-b7ae-4b03-a636-748f7994afe7', 'spec.target', 'https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('e0ad8fc3-b7ae-4b03-a636-748f7994afe7', 'metadata.name', 'generated-7692b664b197d2303b0a28bb177c1b133773311c');
INSERT INTO public.search VALUES ('e0ad8fc3-b7ae-4b03-a636-748f7994afe7', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('e0ad8fc3-b7ae-4b03-a636-748f7994afe7', 'metadata.uid', 'e0ad8fc3-b7ae-4b03-a636-748f7994afe7');
INSERT INTO public.search VALUES ('9575b37e-e899-4803-9b03-61add445781f', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('9575b37e-e899-4803-9b03-61add445781f', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('9575b37e-e899-4803-9b03-61add445781f', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('9575b37e-e899-4803-9b03-61add445781f', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('9575b37e-e899-4803-9b03-61add445781f', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/');
INSERT INTO public.search VALUES ('9575b37e-e899-4803-9b03-61add445781f', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('9575b37e-e899-4803-9b03-61add445781f', 'kind', 'location');
INSERT INTO public.search VALUES ('9575b37e-e899-4803-9b03-61add445781f', 'spec.type', 'url');
INSERT INTO public.search VALUES ('9575b37e-e899-4803-9b03-61add445781f', 'spec.target', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('9575b37e-e899-4803-9b03-61add445781f', 'metadata.name', 'generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce');
INSERT INTO public.search VALUES ('9575b37e-e899-4803-9b03-61add445781f', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('9575b37e-e899-4803-9b03-61add445781f', 'metadata.uid', '9575b37e-e899-4803-9b03-61add445781f');
INSERT INTO public.search VALUES ('b9d0245c-c6f9-4214-aa46-9d84d2235fce', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml');
INSERT INTO public.search VALUES ('b9d0245c-c6f9-4214-aa46-9d84d2235fce', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml');
INSERT INTO public.search VALUES ('b9d0245c-c6f9-4214-aa46-9d84d2235fce', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml');
INSERT INTO public.search VALUES ('b9d0245c-c6f9-4214-aa46-9d84d2235fce', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/microservice-template/template.yaml');
INSERT INTO public.search VALUES ('b9d0245c-c6f9-4214-aa46-9d84d2235fce', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/');
INSERT INTO public.search VALUES ('b9d0245c-c6f9-4214-aa46-9d84d2235fce', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('b9d0245c-c6f9-4214-aa46-9d84d2235fce', 'kind', 'location');
INSERT INTO public.search VALUES ('b9d0245c-c6f9-4214-aa46-9d84d2235fce', 'spec.type', 'url');
INSERT INTO public.search VALUES ('b9d0245c-c6f9-4214-aa46-9d84d2235fce', 'spec.target', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml');
INSERT INTO public.search VALUES ('b9d0245c-c6f9-4214-aa46-9d84d2235fce', 'metadata.name', 'generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98');
INSERT INTO public.search VALUES ('b9d0245c-c6f9-4214-aa46-9d84d2235fce', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('b9d0245c-c6f9-4214-aa46-9d84d2235fce', 'metadata.uid', 'b9d0245c-c6f9-4214-aa46-9d84d2235fce');
INSERT INTO public.search VALUES ('83c4b685-a74b-4228-a442-a3903e0778b0', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('83c4b685-a74b-4228-a442-a3903e0778b0', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('83c4b685-a74b-4228-a442-a3903e0778b0', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('83c4b685-a74b-4228-a442-a3903e0778b0', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('83c4b685-a74b-4228-a442-a3903e0778b0', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/');
INSERT INTO public.search VALUES ('83c4b685-a74b-4228-a442-a3903e0778b0', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('83c4b685-a74b-4228-a442-a3903e0778b0', 'kind', 'location');
INSERT INTO public.search VALUES ('83c4b685-a74b-4228-a442-a3903e0778b0', 'spec.type', 'url');
INSERT INTO public.search VALUES ('83c4b685-a74b-4228-a442-a3903e0778b0', 'spec.target', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('83c4b685-a74b-4228-a442-a3903e0778b0', 'metadata.name', 'generated-689c18882dc297803e1a420c73b8783d094c8e17');
INSERT INTO public.search VALUES ('83c4b685-a74b-4228-a442-a3903e0778b0', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('83c4b685-a74b-4228-a442-a3903e0778b0', 'metadata.uid', '83c4b685-a74b-4228-a442-a3903e0778b0');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'kind', 'location');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'spec.type', 'url');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'spec.target', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'metadata.name', 'generated-e1e842392fd0da6efe989d25722f835228d60e05');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'metadata.uid', '0292df28-4efd-43fd-a9ee-52ece26b6185');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'kind', 'location');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'spec.type', 'url');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'spec.target', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'metadata.name', 'generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'metadata.uid', '50cc71b8-67dc-4dac-91e0-57841741c1a5');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/apps-demo-2026/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'kind', 'location');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'spec.type', 'url');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'spec.target', 'https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'metadata.name', 'generated-64bf0f42f04286e509e88978a740e76f33a6cc2a');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'metadata.uid', 'b997bba0-79d4-45ab-9ba3-3b007e722a86');
INSERT INTO public.search VALUES ('3a5d3700-d0c8-4bb4-bc90-1abb32008733', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('3a5d3700-d0c8-4bb4-bc90-1abb32008733', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('3a5d3700-d0c8-4bb4-bc90-1abb32008733', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('3a5d3700-d0c8-4bb4-bc90-1abb32008733', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('3a5d3700-d0c8-4bb4-bc90-1abb32008733', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('3a5d3700-d0c8-4bb4-bc90-1abb32008733', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('3a5d3700-d0c8-4bb4-bc90-1abb32008733', 'kind', 'location');
INSERT INTO public.search VALUES ('3a5d3700-d0c8-4bb4-bc90-1abb32008733', 'spec.type', 'url');
INSERT INTO public.search VALUES ('3a5d3700-d0c8-4bb4-bc90-1abb32008733', 'spec.target', 'https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('3a5d3700-d0c8-4bb4-bc90-1abb32008733', 'metadata.name', 'generated-230c2622c092081637053d0a834587aef4c2bae2');
INSERT INTO public.search VALUES ('3a5d3700-d0c8-4bb4-bc90-1abb32008733', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('3a5d3700-d0c8-4bb4-bc90-1abb32008733', 'metadata.uid', '3a5d3700-d0c8-4bb4-bc90-1abb32008733');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'metadata.annotations.backstage.io/kubernetes-id', 'prometheus');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'metadata.annotations.backstage.io/kubernetes-namespace', 'monitoring');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'metadata.annotations.backstage.io/kubernetes-label-selector', 'app.kubernetes.io/name=prometheus');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'metadata.description', 'prometheus metrics server & node exporter on eks');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'kind', 'component');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'spec.type', 'service');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'spec.system', 'kube-demo-2026');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'spec.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'spec.dependson.resource:default/kube-demo-eks', 'true');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'metadata.name', 'prometheus');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'metadata.uid', '5d7e145e-f768-46d6-9fe9-64263ace073e');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'relations.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'relations.partof', 'system:default/kube-demo-2026');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'metadata.description', 'platform engineering & devex team');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'kind', 'group');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'spec.type', 'team');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'spec.members', 'guest');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'spec.members.guest', 'true');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'metadata.name', 'platform-team');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'metadata.uid', 'c6bce8e1-4852-4234-aee5-38f6e029b95f');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.hasmember', 'user:default/guest');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'api:default/ldap-ad-api');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'api:default/oidc-idp-api');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'api:default/python-app-api');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'api:default/radius-mfa-api');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'metadata.description', 'platform engineering & devex team');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'kind', 'group');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'spec.type', 'team');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'spec.members', 'guest');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'spec.members.guest', 'true');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'metadata.name', 'platform-team');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'metadata.uid', 'c6bce8e1-4852-4234-aee5-38f6e029b95f');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.hasmember', 'user:default/guest');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'api:default/ldap-ad-api');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'api:default/oidc-idp-api');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'api:default/python-app-api');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'api:default/radius-mfa-api');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'api:default/saml-idp-api');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/argocd');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/backstage-portal');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/freeradius-mfa');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/grafana');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/keycloak-sso');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/prometheus');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/python-demo-app');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/samba-ad-dc');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/sonarqube');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'system:default/apps-demo-2026');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'system:default/kube-demo-2026');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'api:default/saml-idp-api');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/argocd');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/backstage-portal');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/freeradius-mfa');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/grafana');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/keycloak-sso');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/prometheus');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/python-demo-app');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/samba-ad-dc');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'component:default/sonarqube');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'system:default/apps-demo-2026');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'system:default/kube-demo-2026');
INSERT INTO public.search VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'relations.ownerof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'metadata.description', 'aws eks 1.35 platform, gitops, observability & developer portal');
INSERT INTO public.search VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'kind', 'system');
INSERT INTO public.search VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'metadata.name', 'kube-demo-2026');
INSERT INTO public.search VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'metadata.uid', 'c061cd8b-71b0-4ad0-8a8c-064863bb4cf0');
INSERT INTO public.search VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'relations.haspart', 'component:default/argocd');
INSERT INTO public.search VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'relations.haspart', 'component:default/backstage-portal');
INSERT INTO public.search VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'relations.haspart', 'component:default/grafana');
INSERT INTO public.search VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'relations.haspart', 'component:default/prometheus');
INSERT INTO public.search VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'relations.haspart', 'component:default/sonarqube');
INSERT INTO public.search VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'relations.haspart', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'metadata.annotations.backstage.io/kubernetes-id', 'backstage');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'metadata.annotations.backstage.io/kubernetes-namespace', 'backstage');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'metadata.annotations.backstage.io/kubernetes-label-selector', 'app=backstage');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'metadata.description', 'backstage internal developer portal backed by aws rds postgresql and linked to eks');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'kind', 'component');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'spec.type', 'website');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'spec.system', 'kube-demo-2026');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'spec.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'spec.dependson.resource:default/kube-demo-eks', 'true');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'metadata.name', 'backstage-portal');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'metadata.uid', '5d61d659-a82b-47c2-b6a1-949fd04b6f27');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'relations.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'relations.partof', 'system:default/kube-demo-2026');
INSERT INTO public.search VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', 'kind', 'user');
INSERT INTO public.search VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', 'spec.profile.displayname', 'guest user');
INSERT INTO public.search VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', 'spec.profile.email', 'guest@empresa.local');
INSERT INTO public.search VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', 'spec.memberof', 'platform-team');
INSERT INTO public.search VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', 'spec.memberof.platform-team', 'true');
INSERT INTO public.search VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', 'metadata.name', 'guest');
INSERT INTO public.search VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', 'metadata.uid', 'c594da02-5da3-463f-b953-c6b40ea03639');
INSERT INTO public.search VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', 'relations.memberof', 'group:default/platform-team');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'metadata.description', 'endpoint openid connect (oidc) discovery do keycloak (sso.empresa.local)');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'kind', 'api');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'spec.type', 'openapi');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'spec.system', 'samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'metadata.name', 'oidc-idp-api');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'metadata.uid', 'f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'relations.apiprovidedby', 'component:default/keycloak-sso');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/microservice-template/template.yaml');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.title', 'standard microservice with ci/cd, sonarqube, prometheus & fluentd/loki');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.description', 'creates a ready-to-use repository with a test pipeline, sonarqube quality gate validation, prometheus metrics, fluentd/loki logging, and backstage manifest.');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.tags', 'node');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.tags.node', 'true');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.tags', 'python');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.tags.python', 'true');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.tags', 'k8s');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.tags.k8s', 'true');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.tags', 'sonarqube');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.tags.sonarqube', 'true');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.tags', 'prometheus');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.tags.prometheus', 'true');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.tags', 'fluentd');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.tags.fluentd', 'true');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.tags', 'loki');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.tags.loki', 'true');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.tags', 'cicd');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.tags.cicd', 'true');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'apiversion', 'backstage.io/v1beta2');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'kind', 'template');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.owner', 'squad-plataforma');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.type', 'service');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.title', 'component information');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.required', 'component_id');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.required.component_id', 'true');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.required', 'owner');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.required.owner', 'true');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.required', 'description');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.required.description', 'true');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.component_id.title', 'service name');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.component_id.type', 'string');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.component_id.description', 'unique identifier (lowercase letters and hyphens)');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.component_id.pattern', '^[a-z0-9-]+$');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.description.title', 'description');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.description.type', 'string');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.description.description', 'what does this microservice do?');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.owner.title', 'responsible team');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.owner.type', 'string');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.owner.description', 'squad that owns the application (e.g., squad-checkout)');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.owner.default', 'platform-team');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.system.title', 'system / domain');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.system.type', 'string');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.system.default', 'kube-demo-2026');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.title', 'git destination');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.required', 'destinationowner');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.required.destinationowner', 'true');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.required', 'repository');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.required.repository', 'true');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.destinationowner.title', 'github owner / organization');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'kind', 'component');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'metadata.annotations.backstage.io/kubernetes-id', 'sonarqube');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'metadata.annotations.backstage.io/kubernetes-namespace', 'sonarqube');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'metadata.description', 'sonarqube qa & security scanner on eks (owasp dependency-check, findsecbugs & yaml/k8s security plugins)');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'kind', 'component');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'spec.type', 'service');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'spec.system', 'kube-demo-2026');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'spec.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'spec.dependson.resource:default/kube-demo-eks', 'true');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'metadata.name', 'sonarqube');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'metadata.uid', '6cf1741d-cc32-41d6-83f5-2e02fe66c637');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'relations.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'relations.partof', 'system:default/kube-demo-2026');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.title', 'python 3.12 web app + ci/cd with qa, sonarqube, prometheus & fluentd/loki');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.description', 'creates a complete python (flask + gunicorn) repository with automated qa tests, sonarqube quality gate validation, prometheus /metrics, fluentd -> loki logging, and backstage manifest.');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.tags', 'python');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.tags.python', 'true');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.tags', 'flask');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.tags.flask', 'true');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.tags', 'k8s');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.tags.k8s', 'true');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.tags', 'sonarqube');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.tags.sonarqube', 'true');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.tags', 'prometheus');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.tags.prometheus', 'true');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.tags', 'fluentd');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.tags.fluentd', 'true');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.tags', 'loki');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.tags.loki', 'true');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.tags', 'cicd');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.tags.cicd', 'true');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'apiversion', 'backstage.io/v1beta2');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'kind', 'template');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.owner', 'squad-plataforma');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.type', 'service');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.title', 'component information');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.required', 'component_id');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.required.component_id', 'true');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.required', 'owner');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.required.owner', 'true');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.required', 'description');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.required.description', 'true');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.component_id.title', 'service name');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.component_id.type', 'string');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.component_id.description', 'unique identifier (lowercase letters and hyphens)');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.component_id.pattern', '^[a-z0-9-]+$');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.component_id.default', 'python-app-demo');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.description.title', 'description');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.description.type', 'string');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.description.description', 'what does this microservice do?');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.description.default', 'python microservice with sonarqube quality gate, prometheus metrics and fluentd/loki logs');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.owner.title', 'responsible team');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.owner.type', 'string');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.owner.description', 'squad that owns the application (e.g., squad-checkout)');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.owner.default', 'platform-team');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'metadata.annotations.backstage.io/kubernetes-id', 'grafana');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'metadata.annotations.backstage.io/kubernetes-namespace', 'grafana');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'metadata.description', 'grafana observability ui receiving metrics from prometheus on eks');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'kind', 'component');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'spec.type', 'service');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'spec.system', 'kube-demo-2026');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'spec.dependson', 'component:default/prometheus-monitoring');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'spec.dependson.component:default/prometheus-monitoring', 'true');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'spec.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'spec.dependson.resource:default/kube-demo-eks', 'true');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'metadata.name', 'grafana');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'metadata.uid', 'e7874ba5-8387-43bb-82a2-588659c8f617');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'relations.dependson', 'component:default/prometheus-monitoring');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'relations.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'relations.partof', 'system:default/kube-demo-2026');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.annotations.backstage.io/techdocs-ref', 'dir:.');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.annotations.sonarqube.org/project-key', 'apps-demo-2026');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.annotations.backstage.io/kubernetes-id', 'dotnet-csharp-app');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.annotations.backstage.io/kubernetes-namespace', 'apps-demo');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.annotations.prometheus.io/scrape', 'true');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.annotations.prometheus.io/path', '/metrics');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.annotations.fluentd.io/destination', 'loki');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.annotations.grafana/dashboard-selector', 'dotnet-csharp-demo-app');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.annotations.grafana/tag-selector', 'service:dotnet-csharp-demo-app');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.annotations.grafana/overview-dashboard', 'http://grafana.799416476486.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.annotations.argocd/app-name', 'dotnet-csharp-app');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.title', '.net 8 c# minimal api microservice');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.description', 'app web em c# (.net 8 minimal api) com prometheus metrics, logs json para grafana loki, sonarqube quality gate, gitops via argocd e https via aws acm.');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.tags', 'dotnet');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.tags.dotnet', 'true');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.tags', 'csharp');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.tags.csharp', 'true');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.tags', 'sonarqube');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.tags.sonarqube', 'true');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.tags', 'prometheus');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.tags.prometheus', 'true');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.tags', 'fluentd');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.tags.fluentd', 'true');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.tags', 'loki');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.annotations.backstage.io/techdocs-ref', 'dir:.');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.annotations.sonarqube.org/project-key', 'apps-demo-2026');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.annotations.backstage.io/kubernetes-id', 'python-app');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.annotations.backstage.io/kubernetes-namespace', 'apps-demo');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.annotations.prometheus.io/scrape', 'true');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.annotations.prometheus.io/path', '/metrics');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.annotations.fluentd.io/destination', 'loki');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.annotations.grafana/dashboard-selector', 'python-demo-app');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.annotations.grafana/tag-selector', 'service:python-demo-app');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.annotations.grafana/overview-dashboard', 'http://grafana.799416476486.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.annotations.argocd/app-name', 'python-app');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.title', 'python 3.12 flask microservice');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.description', 'app web em python 3.12 (flask) com prometheus metrics, logs json para grafana loki, sonarqube quality gate, gitops via argocd e https via aws acm.');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.tags', 'python');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.tags.python', 'true');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.tags', 'flask');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.tags.flask', 'true');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.tags', 'sonarqube');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.tags.sonarqube', 'true');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.tags', 'prometheus');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.tags.prometheus', 'true');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.tags', 'fluentd');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.tags.fluentd', 'true');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.tags', 'loki');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.tags.loki', 'true');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.tags', 'grafana');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.tags.grafana', 'true');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.tags', 'k8s');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.tags.k8s', 'true');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.tags', 'argocd');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.tags.argocd', 'true');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.url', 'https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.title', 'github source code');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'metadata.annotations.backstage.io/kubernetes-id', 'argocd');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'metadata.annotations.backstage.io/kubernetes-namespace', 'argocd');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'metadata.annotations.backstage.io/kubernetes-label-selector', 'app.kubernetes.io/part-of=argocd');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'metadata.description', 'argocd gitops continuous delivery controller on eks');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'kind', 'component');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'spec.type', 'service');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'spec.system', 'kube-demo-2026');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'spec.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'spec.dependson.resource:default/kube-demo-eks', 'true');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'metadata.name', 'argocd');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'metadata.uid', 'a2837fe8-7139-43d3-9d5e-67166f32ade2');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'relations.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'relations.partof', 'system:default/kube-demo-2026');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.icon', 'github');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.url', 'http://python.799416476486.realhandsonlabs.net');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.title', 'python 3.12 live app (http)');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.icon', 'web');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.url', 'https://python.799416476486.realhandsonlabs.net');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.title', 'python 3.12 live app (https acm)');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.icon', 'lock');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.url', 'http://python.799416476486.realhandsonlabs.net/metrics');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.title', 'prometheus metrics (/metrics)');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.icon', 'gauge');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.url', 'http://grafana.799416476486.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.title', 'grafana dashboard (golden signals & loki logs)');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.icon', 'dashboard');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.url', 'http://sonarqube.799416476486.realhandsonlabs.net/dashboard?id=apps-demo-2026');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.title', 'sonarqube quality gate');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.icon', 'check');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.url', 'https://argocd.799416476486.realhandsonlabs.net/applications/python-app');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.title', 'argocd gitops');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.links.icon', 'sync');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'kind', 'component');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'spec.type', 'service');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'spec.system', 'apps-demo-2026');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'spec.providesapis', 'python-app-api');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'spec.providesapis.python-app-api', 'true');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'spec.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'spec.dependson.resource:default/kube-demo-eks', 'true');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.name', 'python-demo-app');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'metadata.uid', '7d02e7b7-48b7-43fd-abe6-5650785ed3de');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'relations.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'relations.partof', 'system:default/apps-demo-2026');
INSERT INTO public.search VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'relations.providesapi', 'api:default/python-app-api');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'metadata.title', 'python flask app rest api');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'metadata.description', 'interface rest para consulta de status, saúde e telemetria da aplicação python');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'kind', 'api');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'spec.type', 'openapi');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.component_id.type', 'string');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'spec.system', 'apps-demo-2026');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'metadata.name', 'python-app-api');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.annotations.github.com/project-slug', 'cirodasilvaj/samba-ad-keycloak');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.annotations.backstage.io/kubernetes-id', 'samba-ad-dc');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.annotations.backstage.io/kubernetes-namespace', 'default');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.description', 'samba 4 active directory multi-dc (dc1 principal + dc2 réplica em multi-az com --dns-backend=none e route 53 private hosted zone)');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.tags', 'samba4');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.tags.samba4', 'true');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.tags', 'active-directory');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.tags.active-directory', 'true');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.tags', 'ldap');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.tags.ldap', 'true');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.tags', 'kerberos');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.tags.kerberos', 'true');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.tags', 'route53');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.tags.route53', 'true');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'kind', 'component');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'spec.type', 'service');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'spec.system', 'samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'spec.providesapis', 'ldap-ad-api');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'spec.providesapis.ldap-ad-api', 'true');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.name', 'samba-ad-dc');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'metadata.uid', 'd8aa8894-4fe0-436a-99c1-3ee2c3439e11');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'relations.dependencyof', 'component:default/freeradius-mfa');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'relations.dependencyof', 'component:default/keycloak-sso');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'relations.partof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'relations.providesapi', 'api:default/ldap-ad-api');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'metadata.uid', '091b50f1-ebf5-4713-8048-9ad7b9d59968');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'relations.apiprovidedby', 'component:default/python-demo-app');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'relations.partof', 'system:default/apps-demo-2026');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.tags.loki', 'true');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.tags', 'grafana');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.tags.grafana', 'true');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.tags', 'k8s');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.tags.k8s', 'true');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.tags', 'argocd');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.tags.argocd', 'true');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.url', 'https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.title', 'github source code');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.icon', 'github');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.url', 'http://dotnet.799416476486.realhandsonlabs.net');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.title', '.net 8 c# live app (http)');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.icon', 'web');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.url', 'https://dotnet.799416476486.realhandsonlabs.net');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.title', '.net 8 c# live app (https acm)');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.icon', 'lock');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.url', 'http://dotnet.799416476486.realhandsonlabs.net/metrics');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.title', 'prometheus metrics (/metrics)');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.icon', 'gauge');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.url', 'http://grafana.799416476486.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.title', 'grafana dashboard (golden signals & loki logs)');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.icon', 'dashboard');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'metadata.annotations.backstage.io/kubernetes-id', 'kube-demo-eks');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'metadata.annotations.backstage.io/kubernetes-namespace', 'kube-system');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'metadata.description', 'aws eks 1.35 kubernetes cluster connected via in-cluster serviceaccount rbac');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'kind', 'resource');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'spec.type', 'kubernetes-cluster');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'spec.system', 'kube-demo-2026');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'metadata.name', 'kube-demo-eks');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'metadata.uid', 'bd7f67a9-56d3-4906-8ae7-e5a360c38903');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'relations.dependencyof', 'component:default/argocd');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'relations.dependencyof', 'component:default/backstage-portal');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'relations.dependencyof', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'relations.dependencyof', 'component:default/grafana');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.title', 'node.js 20 web app + ci/cd with sonarqube, prometheus & fluentd/loki');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.description', 'creates a complete node.js 20 microservice repository with automated qa tests, sonarqube quality gate validation, prometheus /metrics, fluentd -> loki json logs, and backstage manifest.');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.tags', 'node');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.tags.node', 'true');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.tags', 'nodejs');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.tags.nodejs', 'true');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.tags', 'javascript');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.tags.javascript', 'true');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.tags', 'k8s');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.tags.k8s', 'true');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.tags', 'sonarqube');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.tags.sonarqube', 'true');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.tags', 'prometheus');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.tags.prometheus', 'true');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.tags', 'fluentd');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.tags.fluentd', 'true');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.tags', 'loki');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.tags.loki', 'true');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.tags', 'cicd');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.tags.cicd', 'true');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'apiversion', 'backstage.io/v1beta2');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'kind', 'template');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.owner', 'squad-plataforma');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.type', 'service');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.title', 'component information');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.required', 'component_id');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.required.component_id', 'true');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.required', 'owner');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.required.owner', 'true');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.required', 'description');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.required.description', 'true');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.component_id.title', 'service name');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.component_id.type', 'string');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.component_id.description', 'unique identifier (lowercase letters and hyphens)');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.component_id.pattern', '^[a-z0-9-]+$');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.component_id.default', 'nodejs-app-demo');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.description.title', 'description');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.description.type', 'string');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.description.description', 'what does this node.js microservice do?');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.description.default', 'node.js 20 microservice with sonarqube quality gate, prometheus metrics and fluentd/loki logs');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.owner.title', 'responsible team');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.owner.type', 'string');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.owner.description', 'squad that owns the application (e.g., squad-checkout)');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.owner.default', 'platform-team');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.system.title', 'system / domain');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.system.type', 'string');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.system.default', 'kube-demo-2026');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.title', 'git destination');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.required', 'destinationowner');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.required.destinationowner', 'true');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.required', 'repository');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.required.repository', 'true');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.destinationowner.title', 'github owner / organization');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.destinationowner.type', 'string');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.destinationowner.description', 'github user or organization where the repository will be created');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.destinationowner.default', 'cirodasilvaj');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.repository.title', 'github repository name');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.repository.type', 'string');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.repository.description', 'target repository name to create on github');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.system.title', 'system / domain');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.system.type', 'string');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.system.default', 'kube-demo-2026');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.title', 'git destination');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.required', 'destinationowner');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.required.destinationowner', 'true');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.required', 'repository');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.required.repository', 'true');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.destinationowner.title', 'github owner / organization');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.destinationowner.type', 'string');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.destinationowner.description', 'github user or organization where the repository will be created');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.destinationowner.default', 'cirodasilvaj');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.repository.title', 'github repository name');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.repository.type', 'string');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.repository.description', 'target repository name to create on github');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.parameters.properties.repository.default', 'python-app-demo');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.id', 'fetch-base');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.name', 'rendering template');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.action', 'fetch:template');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.input.url', './skeleton');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.input.values.component_id', '${{ parameters.component_id }}');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.input.values.description', '${{ parameters.description }}');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.input.values.owner', '${{ parameters.owner }}');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.input.values.system', '${{ parameters.system }}');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.input.values.destinationowner', '${{ parameters.destinationowner }}');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.id', 'publish-git');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.name', 'publishing repository to github');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.action', 'publish:github');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.input.allowedhosts', 'github.com');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.input.allowedhosts.github.com', 'true');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.input.description', '${{ parameters.description }}');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.input.repourl', 'github.com?owner=${{ parameters.destinationowner }}&repo=${{ parameters.repository }}');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.input.defaultbranch', 'main');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.input.repovisibility', 'public');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.id', 'register-catalog');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.name', 'registering in backstage');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.action', 'catalog:register');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.input.repocontentsurl', '${{ steps[''publish-git''].output.repocontentsurl }}');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.steps.input.cataloginfopath', '/catalog-info.yaml');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.output.links.title', 'open git repository');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.output.links.url', '${{ steps[''publish-git''].output.remoteurl }}');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.output.links.title', 'view in backstage catalog');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.output.links.icon', 'catalog');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'spec.output.links.entityref', '${{ steps[''register-catalog''].output.entityref }}');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.name', 'python-sonarqube-cicd-template');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'metadata.uid', 'e7ce2e2c-1a65-412c-92af-958b480db2a9');
INSERT INTO public.search VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'relations.ownedby', 'group:default/squad-plataforma');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.annotations.github.com/project-slug', 'cirodasilvaj/samba-ad-keycloak');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.annotations.backstage.io/kubernetes-id', 'freeradius-mfa');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.annotations.backstage.io/kubernetes-namespace', 'default');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.description', 'servidor freeradius + pam google authenticator (totp mfa) integrado ao samba 4 ad para autenticação geral e mfa na vpc do eks');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.tags', 'radius');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.tags.radius', 'true');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.tags', 'freeradius');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.tags.freeradius', 'true');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.tags', 'mfa');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.tags.mfa', 'true');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.tags', 'totp');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.tags.totp', 'true');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.parameters.properties.repository.default', 'nodejs-app-demo');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.id', 'fetch-base');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.name', 'rendering template');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.action', 'fetch:template');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.input.url', './skeleton');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.input.values.component_id', '${{ parameters.component_id }}');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.input.values.description', '${{ parameters.description }}');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.input.values.owner', '${{ parameters.owner }}');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.input.values.system', '${{ parameters.system }}');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.input.values.destinationowner', '${{ parameters.destinationowner }}');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.id', 'publish-git');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.name', 'publishing repository to github');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.action', 'publish:github');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.input.allowedhosts', 'github.com');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.input.allowedhosts.github.com', 'true');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.input.description', '${{ parameters.description }}');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.input.repourl', 'github.com?owner=${{ parameters.destinationowner }}&repo=${{ parameters.repository }}');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.input.defaultbranch', 'main');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.input.repovisibility', 'public');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.id', 'register-catalog');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.name', 'registering in backstage');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.action', 'catalog:register');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.input.repocontentsurl', '${{ steps[''publish-git''].output.repocontentsurl }}');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.steps.input.cataloginfopath', '/catalog-info.yaml');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.output.links.title', 'open git repository');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.output.links.url', '${{ steps[''publish-git''].output.remoteurl }}');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.output.links.title', 'view in backstage catalog');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.output.links.icon', 'catalog');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'spec.output.links.entityref', '${{ steps[''register-catalog''].output.entityref }}');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.name', 'nodejs-sonarqube-cicd-template');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'metadata.uid', 'f4433dbe-aa69-4603-840e-2c2f82ce17c0');
INSERT INTO public.search VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'relations.ownedby', 'group:default/squad-plataforma');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.title', '.net 8 c# web app + ci/cd with qa, sonarqube, prometheus & fluentd/loki');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.description', 'creates a complete .net 8 c# minimal api repository with automated qa tests, sonarqube quality gate validation, prometheus /metrics, fluentd -> loki logging, and backstage manifest.');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.tags', 'dotnet');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.tags.dotnet', 'true');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.tags', 'csharp');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.tags.csharp', 'true');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.tags', 'k8s');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.tags.k8s', 'true');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.tags', 'sonarqube');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.tags.sonarqube', 'true');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.tags', 'prometheus');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.tags.prometheus', 'true');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.tags', 'fluentd');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.tags.fluentd', 'true');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.tags', 'loki');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.tags.loki', 'true');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.tags', 'cicd');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.tags.cicd', 'true');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'apiversion', 'backstage.io/v1beta2');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'kind', 'template');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.owner', 'squad-plataforma');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.type', 'service');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.title', 'component information');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.required', 'component_id');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.required.component_id', 'true');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.required', 'owner');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.required.owner', 'true');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.required', 'description');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.required.description', 'true');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.component_id.title', 'service name');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.destinationowner.type', 'string');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.destinationowner.description', 'github user or organization where the repository will be created');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.destinationowner.default', 'cirodasilvaj');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.repository.title', 'github repository name');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.repository.type', 'string');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.repository.description', 'target repository name to create on github');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.parameters.properties.repository.default', 'microservice-demo');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.id', 'fetch-base');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.name', 'rendering template');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.action', 'fetch:template');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.input.url', './skeleton');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.input.values.component_id', '${{ parameters.component_id }}');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.input.values.description', '${{ parameters.description }}');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.input.values.owner', '${{ parameters.owner }}');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.input.values.system', '${{ parameters.system }}');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.input.values.destinationowner', '${{ parameters.destinationowner }}');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.id', 'publish-git');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.name', 'publishing repository to github');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.action', 'publish:github');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.input.allowedhosts', 'github.com');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.input.allowedhosts.github.com', 'true');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.input.description', '${{ parameters.description }}');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.input.repourl', 'github.com?owner=${{ parameters.destinationowner }}&repo=${{ parameters.repository }}');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.input.defaultbranch', 'main');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.input.repovisibility', 'public');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.id', 'register-catalog');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.name', 'registering in backstage');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.action', 'catalog:register');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.input.repocontentsurl', '${{ steps[''publish-git''].output.repocontentsurl }}');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.steps.input.cataloginfopath', '/catalog-info.yaml');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.output.links.title', 'open git repository');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.output.links.url', '${{ steps[''publish-git''].output.remoteurl }}');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.output.links.title', 'view in backstage catalog');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.output.links.icon', 'catalog');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'spec.output.links.entityref', '${{ steps[''register-catalog''].output.entityref }}');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.name', 'standard-microservice-template');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'metadata.uid', '270eff48-d8a7-4539-8bcc-c5aadd2103fb');
INSERT INTO public.search VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'relations.ownedby', 'group:default/squad-plataforma');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'metadata.description', 'endpoint ldap/ldaps round-robin do samba 4 ad (ldap://ad.empresa.local:389)');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'kind', 'api');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'spec.type', 'grpc');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'spec.system', 'samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'spec.definition', 'syntax = "proto3";
service activedirectoryldap {
  // ldap://ad.empresa.local:389 (round-robin dc1 & dc2)
  // base dn: dc=empresa,dc=local
}
');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'metadata.name', 'ldap-ad-api');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'metadata.uid', 'a47d058b-3461-44b2-9feb-97fec94b206f');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'relations.apiprovidedby', 'component:default/samba-ad-dc');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'relations.partof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.url', 'http://sonarqube.799416476486.realhandsonlabs.net/dashboard?id=apps-demo-2026');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.title', 'sonarqube quality gate');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.icon', 'check');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.url', 'https://argocd.799416476486.realhandsonlabs.net/applications/dotnet-csharp-app');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.title', 'argocd gitops');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.links.icon', 'sync');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'relations.dependencyof', 'component:default/prometheus');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'relations.dependencyof', 'component:default/python-demo-app');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'relations.dependencyof', 'component:default/sonarqube');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'relations.partof', 'system:default/kube-demo-2026');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.title', 'jvm spring boot (java 21) + ci/cd with sonarqube, prometheus & fluentd/loki');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.tags', 'java');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.tags.java', 'true');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.tags', 'jvm');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.tags.jvm', 'true');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.tags', 'springboot');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.tags.springboot', 'true');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.tags', 'k8s');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.tags.k8s', 'true');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.tags', 'sonarqube');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.tags.sonarqube', 'true');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.tags', 'prometheus');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.tags.prometheus', 'true');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.tags', 'fluentd');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.tags.fluentd', 'true');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.tags', 'loki');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.tags.loki', 'true');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.tags', 'cicd');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.tags.cicd', 'true');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'apiversion', 'backstage.io/v1beta2');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'kind', 'template');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.owner', 'squad-plataforma');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.type', 'service');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.title', 'component information');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.required', 'component_id');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.required.component_id', 'true');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.required', 'owner');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.required.owner', 'true');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.required', 'description');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.required.description', 'true');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.component_id.title', 'service name');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.component_id.type', 'string');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.component_id.description', 'unique identifier (lowercase letters and hyphens)');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.component_id.pattern', '^[a-z0-9-]+$');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.component_id.default', 'springboot-app-demo');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.description.title', 'description');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.description.type', 'string');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.description.description', 'what does this spring boot microservice do?');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.description.default', 'jvm spring boot 3.3 microservice with sonarqube quality gate, prometheus metrics and fluentd/loki logs');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.owner.title', 'responsible team');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.owner.type', 'string');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.owner.description', 'squad that owns the application (e.g., squad-checkout)');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.owner.default', 'platform-team');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.system.title', 'system / domain');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.system.type', 'string');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.system.default', 'kube-demo-2026');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.title', 'git destination');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.required', 'destinationowner');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.required.destinationowner', 'true');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.required', 'repository');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.required.repository', 'true');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.destinationowner.title', 'github owner / organization');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.destinationowner.type', 'string');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.destinationowner.description', 'github user or organization where the repository will be created');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.destinationowner.default', 'cirodasilvaj');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.repository.title', 'github repository name');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'kind', 'component');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'spec.type', 'service');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'spec.system', 'apps-demo-2026');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'spec.providesapis', 'dotnet-csharp-app-api');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'spec.providesapis.dotnet-csharp-app-api', 'true');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'spec.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'spec.dependson.resource:default/kube-demo-eks', 'true');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.name', 'dotnet-csharp-demo-app');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'metadata.uid', '6fed0b98-a145-41ce-a88f-be349334888d');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'relations.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'relations.partof', 'system:default/apps-demo-2026');
INSERT INTO public.search VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'relations.providesapi', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'metadata.title', '.net 8 c# minimal api rest api');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'metadata.description', 'interface rest para consulta de status, saúde e telemetria da aplicação c# .net 8');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'kind', 'api');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'spec.type', 'openapi');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'spec.system', 'apps-demo-2026');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'metadata.name', 'dotnet-csharp-app-api');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'metadata.uid', '63db9a4c-47aa-4c58-a818-dc552e7dd313');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'relations.apiprovidedby', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'relations.partof', 'system:default/apps-demo-2026');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'metadata.description', 'endpoint freeradius auth (udp 1812) e acct (udp 1813) com suporte a mfa (radius.empresa.local)');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'kind', 'api');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'spec.type', 'grpc');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'spec.system', 'samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'spec.definition', 'syntax = "proto3";
service freeradiusmfa {
  // udp radius.empresa.local:1812 (auth + mfa)
  // udp radius.empresa.local:1813 (accounting)
}
');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'metadata.name', 'radius-mfa-api');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'metadata.uid', '257e492a-1177-431b-b323-5689c6369907');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'relations.apiprovidedby', 'component:default/freeradius-mfa');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('257e492a-1177-431b-b323-5689c6369907', 'relations.partof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.annotations.github.com/project-slug', 'cirodasilvaj/samba-ad-keycloak');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.annotations.backstage.io/kubernetes-id', 'keycloak-sso');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.annotations.backstage.io/kubernetes-namespace', 'default');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.description', 'servidor keycloak iam (broker saml 2.0, oauth2 e oidc) federado via ldap ao samba 4 ad para autenticar backstage, argocd, grafana e apps demo');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.tags', 'keycloak');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.tags.keycloak', 'true');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.tags', 'saml2');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.tags.saml2', 'true');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.tags', 'oidc');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.tags.oidc', 'true');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.tags', 'sso');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.tags.sso', 'true');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.tags', 'mfa');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.tags.mfa', 'true');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'kind', 'component');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'spec.type', 'service');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'spec.system', 'samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'spec.dependson', 'component:default/samba-ad-dc');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'spec.dependson.component:default/samba-ad-dc', 'true');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'spec.dependson', 'component:default/freeradius-mfa');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'spec.dependson.component:default/freeradius-mfa', 'true');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'spec.providesapis', 'saml-idp-api');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'spec.providesapis.saml-idp-api', 'true');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'spec.providesapis', 'oidc-idp-api');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'spec.providesapis.oidc-idp-api', 'true');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.name', 'keycloak-sso');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'metadata.uid', '59bcae1b-0310-4bf1-9216-1cc4fc975884');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'relations.dependson', 'component:default/freeradius-mfa');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'relations.dependson', 'component:default/samba-ad-dc');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'relations.partof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'relations.providesapi', 'api:default/oidc-idp-api');
INSERT INTO public.search VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'relations.providesapi', 'api:default/saml-idp-api');
INSERT INTO public.search VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/apps-demo-2026/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/');
INSERT INTO public.search VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'metadata.title', 'apps demo 2026 ecosystem');
INSERT INTO public.search VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'metadata.description', 'microservices demo collection (python 3.12 flask, .net 8 c# minimal api) with ci/cd, sonarqube, prometheus metrics, fluentd/loki logs, gitops via argocd and https via aws acm.');
INSERT INTO public.search VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'kind', 'system');
INSERT INTO public.search VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'metadata.name', 'apps-demo-2026');
INSERT INTO public.search VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'metadata.uid', '34c740af-8954-42f2-8520-94448a3ea8cd');
INSERT INTO public.search VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'relations.haspart', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.search VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'relations.haspart', 'api:default/python-app-api');
INSERT INTO public.search VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'relations.haspart', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.search VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'relations.haspart', 'component:default/python-demo-app');
INSERT INTO public.search VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.component_id.description', 'unique identifier (lowercase letters and hyphens)');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.component_id.pattern', '^[a-z0-9-]+$');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.component_id.default', 'dotnet-csharp-app-demo');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.description.title', 'description');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.description.type', 'string');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.description.description', 'what does this microservice do?');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.description.default', '.net 8 c# microservice with sonarqube quality gate, prometheus metrics and fluentd/loki logs');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.owner.title', 'responsible team');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.owner.type', 'string');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.owner.description', 'squad that owns the application (e.g., squad-checkout)');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.owner.default', 'platform-team');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.system.title', 'system / domain');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.system.type', 'string');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.system.default', 'kube-demo-2026');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.title', 'git destination');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.required', 'destinationowner');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.required.destinationowner', 'true');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.required', 'repository');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.required.repository', 'true');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.destinationowner.title', 'github owner / organization');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.destinationowner.type', 'string');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.destinationowner.description', 'github user or organization where the repository will be created');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.destinationowner.default', 'cirodasilvaj');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.repository.title', 'github repository name');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.repository.type', 'string');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.repository.description', 'target repository name to create on github');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.parameters.properties.repository.default', 'dotnet-csharp-app-demo');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.id', 'fetch-base');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.name', 'rendering template');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.action', 'fetch:template');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.input.url', './skeleton');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.input.values.component_id', '${{ parameters.component_id }}');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.input.values.description', '${{ parameters.description }}');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.input.values.owner', '${{ parameters.owner }}');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.input.values.system', '${{ parameters.system }}');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.input.values.destinationowner', '${{ parameters.destinationowner }}');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.id', 'publish-git');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.name', 'publishing repository to github');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.action', 'publish:github');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.input.allowedhosts', 'github.com');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.input.allowedhosts.github.com', 'true');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.input.description', '${{ parameters.description }}');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.input.repourl', 'github.com?owner=${{ parameters.destinationowner }}&repo=${{ parameters.repository }}');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.input.defaultbranch', 'main');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.input.repovisibility', 'public');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.id', 'register-catalog');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.name', 'registering in backstage');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.action', 'catalog:register');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.input.repocontentsurl', '${{ steps[''publish-git''].output.repocontentsurl }}');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.steps.input.cataloginfopath', '/catalog-info.yaml');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.output.links.title', 'open git repository');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.output.links.url', '${{ steps[''publish-git''].output.remoteurl }}');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.output.links.title', 'view in backstage catalog');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.output.links.icon', 'catalog');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'spec.output.links.entityref', '${{ steps[''register-catalog''].output.entityref }}');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.name', 'dotnet-sonarqube-cicd-template');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'metadata.uid', 'bd2f3497-ed87-4202-a8a4-4613a3b58f78');
INSERT INTO public.search VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'relations.ownedby', 'group:default/squad-plataforma');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'spec.type', 'service');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'spec.system', 'samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'spec.dependson', 'component:default/samba-ad-dc');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'spec.dependson.component:default/samba-ad-dc', 'true');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'spec.providesapis', 'radius-mfa-api');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'spec.providesapis.radius-mfa-api', 'true');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.name', 'freeradius-mfa');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'metadata.uid', '78aca34d-c7ad-4316-9d74-afd733e893a3');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'relations.dependencyof', 'component:default/keycloak-sso');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'relations.dependson', 'component:default/samba-ad-dc');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'relations.partof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'relations.providesapi', 'api:default/radius-mfa-api');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'metadata.description', 'endpoint saml 2.0 identity provider do keycloak (sso.empresa.local)');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'kind', 'api');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'spec.type', 'openapi');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'spec.system', 'samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'metadata.name', 'saml-idp-api');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'metadata.uid', '40be89b0-5809-47dc-a88c-5053d2b38724');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'relations.apiprovidedby', 'component:default/keycloak-sso');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'relations.partof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'metadata.description', 'endpoint ldap/ldaps round-robin do samba 4 ad (ldap://ad.empresa.local:389)');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'kind', 'api');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'spec.type', 'grpc');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'spec.system', 'samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'spec.definition', 'syntax = "proto3";
service activedirectoryldap {
  // ldap://ad.empresa.local:389 (round-robin dc1 & dc2)
  // base dn: dc=empresa,dc=local
}
');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'metadata.name', 'ldap-ad-api');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'metadata.uid', 'a47d058b-3461-44b2-9feb-97fec94b206f');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'relations.apiprovidedby', 'component:default/samba-ad-dc');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'relations.partof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'metadata.description', 'arquitetura corporativa iam na vpc do eks (samba 4 ad multi-dc sem dns interno + route 53 private zone + freeradius mfa + keycloak saml 2.0 / oidc)');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'kind', 'system');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'metadata.name', 'samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'metadata.uid', '2a9beea9-e004-4fd5-8dda-11f2c52f5f07');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'relations.haspart', 'api:default/ldap-ad-api');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'relations.haspart', 'api:default/oidc-idp-api');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'relations.haspart', 'api:default/radius-mfa-api');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'relations.haspart', 'api:default/saml-idp-api');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'relations.haspart', 'component:default/freeradius-mfa');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'relations.haspart', 'component:default/keycloak-sso');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'relations.haspart', 'component:default/samba-ad-dc');
INSERT INTO public.search VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'metadata.description', 'endpoint saml 2.0 identity provider do keycloak (sso.empresa.local)');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'kind', 'api');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'spec.type', 'openapi');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'spec.system', 'samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'metadata.name', 'saml-idp-api');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'metadata.uid', '40be89b0-5809-47dc-a88c-5053d2b38724');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'relations.apiprovidedby', 'component:default/keycloak-sso');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'relations.partof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'relations.partof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.repository.type', 'string');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.repository.description', 'target repository name to create on github');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.parameters.properties.repository.default', 'springboot-app-demo');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.id', 'fetch-base');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.name', 'rendering template');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.action', 'fetch:template');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.input.url', './skeleton');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.input.values.component_id', '${{ parameters.component_id }}');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.input.values.description', '${{ parameters.description }}');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.input.values.owner', '${{ parameters.owner }}');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.input.values.system', '${{ parameters.system }}');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.input.values.destinationowner', '${{ parameters.destinationowner }}');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.id', 'publish-git');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.name', 'publishing repository to github');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.action', 'publish:github');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.input.allowedhosts', 'github.com');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.input.allowedhosts.github.com', 'true');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.input.description', '${{ parameters.description }}');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.input.repourl', 'github.com?owner=${{ parameters.destinationowner }}&repo=${{ parameters.repository }}');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.input.defaultbranch', 'main');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.input.repovisibility', 'public');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.id', 'register-catalog');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.name', 'registering in backstage');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.action', 'catalog:register');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.input.repocontentsurl', '${{ steps[''publish-git''].output.repocontentsurl }}');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.steps.input.cataloginfopath', '/catalog-info.yaml');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.output.links.title', 'open git repository');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.output.links.url', '${{ steps[''publish-git''].output.remoteurl }}');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.output.links.title', 'view in backstage catalog');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.output.links.icon', 'catalog');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'spec.output.links.entityref', '${{ steps[''register-catalog''].output.entityref }}');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.name', 'jvm-springboot-sonarqube-cicd-template');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'metadata.uid', '70145be8-a40e-4a5a-b0ce-25af2aeadd94');
INSERT INTO public.search VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'relations.ownedby', 'group:default/squad-plataforma');


--
-- Name: knex_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.knex_migrations_id_seq', 20, true);


--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.knex_migrations_lock_index_seq', 1, true);


--
-- Name: location_update_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.location_update_log_id_seq', 1, false);


--
-- Name: refresh_state_references_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.refresh_state_references_id_seq', 692, true);


--
-- Name: entities entities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT entities_pkey PRIMARY KEY (id);


--
-- Name: entities entities_unique_full_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT entities_unique_full_name UNIQUE (full_name);


--
-- Name: final_entities final_entities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.final_entities
    ADD CONSTRAINT final_entities_pkey PRIMARY KEY (entity_id);


--
-- Name: knex_migrations_lock knex_migrations_lock_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knex_migrations_lock
    ADD CONSTRAINT knex_migrations_lock_pkey PRIMARY KEY (index);


--
-- Name: knex_migrations knex_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knex_migrations
    ADD CONSTRAINT knex_migrations_pkey PRIMARY KEY (id);


--
-- Name: location_update_log location_update_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_update_log
    ADD CONSTRAINT location_update_log_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: refresh_state refresh_state_entity_ref_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_state
    ADD CONSTRAINT refresh_state_entity_ref_uniq UNIQUE (entity_ref);


--
-- Name: refresh_state refresh_state_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_state
    ADD CONSTRAINT refresh_state_pkey PRIMARY KEY (entity_id);


--
-- Name: refresh_state_references refresh_state_references_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_state_references
    ADD CONSTRAINT refresh_state_references_pkey PRIMARY KEY (id);


--
-- Name: entities_search_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entities_search_key ON public.entities_search USING btree (key);


--
-- Name: entities_search_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entities_search_value ON public.entities_search USING btree (value);


--
-- Name: entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entity_id_idx ON public.entities_search USING btree (entity_id);


--
-- Name: entity_location_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX entity_location_id_idx ON public.entities USING btree (location_id);


--
-- Name: final_entities_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX final_entities_entity_id_idx ON public.final_entities USING btree (entity_id);


--
-- Name: originating_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX originating_entity_id_idx ON public.entities_relations USING btree (originating_entity_id);


--
-- Name: refresh_state_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX refresh_state_entity_id_idx ON public.refresh_state USING btree (entity_id);


--
-- Name: refresh_state_entity_ref_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX refresh_state_entity_ref_idx ON public.refresh_state USING btree (entity_ref);


--
-- Name: refresh_state_next_update_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX refresh_state_next_update_at_idx ON public.refresh_state USING btree (next_update_at);


--
-- Name: refresh_state_references_source_entity_ref_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX refresh_state_references_source_entity_ref_idx ON public.refresh_state_references USING btree (source_entity_ref);


--
-- Name: refresh_state_references_source_key_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX refresh_state_references_source_key_idx ON public.refresh_state_references USING btree (source_key);


--
-- Name: refresh_state_references_target_entity_ref_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX refresh_state_references_target_entity_ref_idx ON public.refresh_state_references USING btree (target_entity_ref);


--
-- Name: relations_source_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX relations_source_entity_id_idx ON public.relations USING btree (originating_entity_id);


--
-- Name: relations_source_entity_ref_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX relations_source_entity_ref_idx ON public.relations USING btree (source_entity_ref);


--
-- Name: search_entity_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX search_entity_id_idx ON public.search USING btree (entity_id);


--
-- Name: search_key_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX search_key_idx ON public.search USING btree (key);


--
-- Name: search_value_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX search_value_idx ON public.search USING btree (value);


--
-- Name: source_full_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX source_full_name_idx ON public.entities_relations USING btree (source_full_name);


--
-- Name: update_log_location_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX update_log_location_id_idx ON public.location_update_log USING btree (location_id);


--
-- Name: location_update_log_latest _RETURN; Type: RULE; Schema: public; Owner: -
--

CREATE OR REPLACE VIEW public.location_update_log_latest AS
 SELECT t1.id,
    t1.status,
    t1.created_at,
    t1.message,
    t1.location_id,
    t1.entity_name
   FROM (public.location_update_log t1
     JOIN ( SELECT location_update_log.location_id,
            max(location_update_log.id) AS maxid
           FROM public.location_update_log
          GROUP BY location_update_log.location_id) t2 ON (((t1.location_id = t2.location_id) AND (t1.id = t2.maxid))))
  GROUP BY t1.location_id, t1.id
  ORDER BY t1.created_at DESC;


--
-- Name: entities entities_location_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT entities_location_id_foreign FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: entities_relations entities_relations_originating_entity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entities_relations
    ADD CONSTRAINT entities_relations_originating_entity_id_foreign FOREIGN KEY (originating_entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: entities_search entities_search_entity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entities_search
    ADD CONSTRAINT entities_search_entity_id_foreign FOREIGN KEY (entity_id) REFERENCES public.entities(id) ON DELETE CASCADE;


--
-- Name: final_entities final_entities_entity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.final_entities
    ADD CONSTRAINT final_entities_entity_id_foreign FOREIGN KEY (entity_id) REFERENCES public.refresh_state(entity_id) ON DELETE CASCADE;


--
-- Name: location_update_log location_update_log_location_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_update_log
    ADD CONSTRAINT location_update_log_location_id_foreign FOREIGN KEY (location_id) REFERENCES public.locations(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: refresh_state_references refresh_state_references_source_entity_ref_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_state_references
    ADD CONSTRAINT refresh_state_references_source_entity_ref_foreign FOREIGN KEY (source_entity_ref) REFERENCES public.refresh_state(entity_ref) ON DELETE CASCADE;


--
-- Name: refresh_state_references refresh_state_references_target_entity_ref_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_state_references
    ADD CONSTRAINT refresh_state_references_target_entity_ref_foreign FOREIGN KEY (target_entity_ref) REFERENCES public.refresh_state(entity_ref) ON DELETE CASCADE;


--
-- Name: relations relations_originating_entity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT relations_originating_entity_id_foreign FOREIGN KEY (originating_entity_id) REFERENCES public.refresh_state(entity_id) ON DELETE CASCADE;


--
-- Name: search search_entity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.search
    ADD CONSTRAINT search_entity_id_foreign FOREIGN KEY (entity_id) REFERENCES public.refresh_state(entity_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 3zeJl3lj0zCocktXvs7qpcKqRRpWWnnpMIaiOZiJ0LZWgv9jthh4bUfQCpMGALo

