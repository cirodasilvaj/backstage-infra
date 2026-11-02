--
-- PostgreSQL database dump
--

\restrict kk1VekvTEMBwWC3LncKxgP8DBBWWbKQDwcCxFpjXcpSQZjCnV0E0q6lgdeBtiqq

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

INSERT INTO public.final_entities VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', '3ed1d60aa4d478e03761fe9cfc510074c9d52621', '2cd953a3-2367-4c46-8a3e-f2a3ed2d1a64', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"dotnet-csharp-demo-app","grafana/tag-selector":"service:dotnet-csharp-demo-app","grafana/overview-dashboard":"http://grafana.799416476486.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe","argocd/app-name":"dotnet-csharp-app"},"name":"dotnet-csharp-demo-app","title":".NET 8 C# Minimal API Microservice","description":"App Web em C# (.NET 8 Minimal API) com Prometheus metrics, logs JSON para Grafana Loki, SonarQube Quality Gate, GitOps via ArgoCD e HTTPS via AWS ACM.","tags":["dotnet","csharp","sonarqube","prometheus","fluentd","loki","grafana","k8s","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app","title":"GitHub Source Code","icon":"github"},{"url":"http://dotnet.799416476486.realhandsonlabs.net","title":".NET 8 C# Live App (HTTP)","icon":"web"},{"url":"https://dotnet.799416476486.realhandsonlabs.net","title":".NET 8 C# Live App (HTTPS ACM)","icon":"lock"},{"url":"http://dotnet.799416476486.realhandsonlabs.net/metrics","title":"Prometheus Metrics (/metrics)","icon":"gauge"},{"url":"http://grafana.799416476486.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe","title":"Grafana Dashboard (Golden Signals & Loki Logs)","icon":"dashboard"},{"url":"http://sonarqube.799416476486.realhandsonlabs.net/dashboard?id=apps-demo-2026","title":"SonarQube Quality Gate","icon":"check"},{"url":"https://argocd.799416476486.realhandsonlabs.net/applications/dotnet-csharp-app","title":"ArgoCD GitOps","icon":"sync"}],"uid":"6fed0b98-a145-41ce-a88f-be349334888d","generation":1,"etag":"3ed1d60aa4d478e03761fe9cfc510074c9d52621"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","providesApis":["dotnet-csharp-app-api"],"dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"apps-demo-2026"}},{"type":"providesApi","target":{"kind":"api","namespace":"default","name":"dotnet-csharp-app-api"}}]}');
INSERT INTO public.final_entities VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', '9d604bc9120eb4d073f9bd99d442f5f5da37538e', '27609670-ef21-48f7-a160-fc9f1367b58d', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/"},"name":"nodejs-sonarqube-cicd-template","title":"Node.js 20 Web App + CI/CD with SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Node.js 20 microservice repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki JSON logs, and Backstage manifest.","tags":["node","nodejs","javascript","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"f4433dbe-aa69-4603-840e-2c2f82ce17c0","generation":1,"etag":"9d604bc9120eb4d073f9bd99d442f5f5da37538e"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"nodejs-app-demo"},"description":{"title":"Description","type":"string","description":"What does this Node.js microservice do?","default":"Node.js 20 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"nodejs-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}},"relations":[{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"squad-plataforma"}}]}');
INSERT INTO public.final_entities VALUES ('d21a25a7-d0b8-488a-9667-b473754b703d', '9ad296e21d28d1d2ae153cdaf8af9d68cee4d46b', '7f0e1306-6e72-4a5b-84db-7275e999204e', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-73a2399a7c2024519f325ee2a4e98268e82758b7","uid":"d21a25a7-d0b8-488a-9667-b473754b703d","generation":1,"etag":"9ad296e21d28d1d2ae153cdaf8af9d68cee4d46b"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/floci-localstack-aws/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/floci-localstack-aws/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/floci-localstack-aws/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/floci-localstack-aws/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/floci-localstack-aws/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('165fd037-6ebf-4195-9352-6ad5a94884ce', '5875948eb351dabe78979a67d965ecb3acecdf74', '030e9cb1-13f3-4a3f-b0c3-5d4a2a8f5cb2', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-e67fab63afdcd722173e912706fe624b9df62c34","uid":"165fd037-6ebf-4195-9352-6ad5a94884ce","generation":1,"etag":"5875948eb351dabe78979a67d965ecb3acecdf74"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/devmarcelo/openclaw-setup/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/devmarcelo/openclaw-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/devmarcelo/openclaw-setup/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/devmarcelo/openclaw-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/devmarcelo/openclaw-setup/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('15d0d89c-e09d-4679-a192-0892d1cd29bc', 'ed2a96b0673394689e415ea729916118ab5d5cc8', '17e2bca4-3e8c-42af-877f-6917c7a5abb6', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-bd14bea673b37261e7a74bd04975480bb069f8bc","uid":"15d0d89c-e09d-4679-a192-0892d1cd29bc","generation":1,"etag":"ed2a96b0673394689e415ea729916118ab5d5cc8"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/a360-dev-multiagentes/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/a360-business/a360-dev-multiagentes/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/a360-dev-multiagentes/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/a360-dev-multiagentes/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/a360-dev-multiagentes/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('adeb7f13-198c-4a2e-aa65-06684ee4ee4e', '724a5022fc61d540476d7c55a4f85c112f820989', '5bd0c5c9-2629-41df-86ed-74988c8d66b1', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-edb107c0bf74b8a4c4c763787b54180b9801f99b","uid":"adeb7f13-198c-4a2e-aa65-06684ee4ee4e","generation":1,"etag":"724a5022fc61d540476d7c55a4f85c112f820989"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/hermes-setup/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/a360-business/hermes-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/hermes-setup/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/hermes-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/hermes-setup/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', '44384825848573f2cb0a1d4256309abf997ca697', 'eff768d6-4f7d-4407-a232-29177239c631', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"python-demo-app","grafana/tag-selector":"service:python-demo-app","grafana/overview-dashboard":"http://grafana.799416476486.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12","argocd/app-name":"python-app"},"name":"python-demo-app","title":"Python 3.12 Flask Microservice","description":"App Web em Python 3.12 (Flask) com Prometheus metrics, logs JSON para Grafana Loki, SonarQube Quality Gate, GitOps via ArgoCD e HTTPS via AWS ACM.","tags":["python","flask","sonarqube","prometheus","fluentd","loki","grafana","k8s","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app","title":"GitHub Source Code","icon":"github"},{"url":"http://python.799416476486.realhandsonlabs.net","title":"Python 3.12 Live App (HTTP)","icon":"web"},{"url":"https://python.799416476486.realhandsonlabs.net","title":"Python 3.12 Live App (HTTPS ACM)","icon":"lock"},{"url":"http://python.799416476486.realhandsonlabs.net/metrics","title":"Prometheus Metrics (/metrics)","icon":"gauge"},{"url":"http://grafana.799416476486.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12","title":"Grafana Dashboard (Golden Signals & Loki Logs)","icon":"dashboard"},{"url":"http://sonarqube.799416476486.realhandsonlabs.net/dashboard?id=apps-demo-2026","title":"SonarQube Quality Gate","icon":"check"},{"url":"https://argocd.799416476486.realhandsonlabs.net/applications/python-app","title":"ArgoCD GitOps","icon":"sync"}],"uid":"7d02e7b7-48b7-43fd-abe6-5650785ed3de","generation":1,"etag":"44384825848573f2cb0a1d4256309abf997ca697"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","providesApis":["python-app-api"],"dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"apps-demo-2026"}},{"type":"providesApi","target":{"kind":"api","namespace":"default","name":"python-app-api"}}]}');
INSERT INTO public.final_entities VALUES ('f3e4a0a1-be3a-4f1c-97be-0dda1b365099', '3999188364d5d2fd3529ea88ace049da7c7cdd0a', 'ef6983c5-5132-4ede-9f10-17a9928f2efc', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-9a24efc486a6e189695017ff7d1ff5886f9498aa","uid":"f3e4a0a1-be3a-4f1c-97be-0dda1b365099","generation":1,"etag":"3999188364d5d2fd3529ea88ace049da7c7cdd0a"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/hermes-backup-1-vid-agentes-repos/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/hermes-backup-1-vid-agentes-repos/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/hermes-backup-1-vid-agentes-repos/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/hermes-backup-1-vid-agentes-repos/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/hermes-backup-1-vid-agentes-repos/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'b63654eb57f875669bf4c165eb4e0a7ca9b1cc57', '1e35194d-2464-43b5-bc75-82fb25eca98f', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"ldap-ad-api","description":"Endpoint LDAP/LDAPS Round-Robin do Samba 4 AD (ldap://ad.empresa.local:389)","uid":"a47d058b-3461-44b2-9feb-97fec94b206f","generation":1,"etag":"b63654eb57f875669bf4c165eb4e0a7ca9b1cc57"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"grpc","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"syntax = \"proto3\";\nservice ActiveDirectoryLDAP {\n  // ldap://ad.empresa.local:389 (Round-Robin DC1 & DC2)\n  // Base DN: DC=empresa,DC=local\n}\n"},"relations":[{"type":"apiProvidedBy","target":{"kind":"component","namespace":"default","name":"samba-ad-dc"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}}]}');
INSERT INTO public.final_entities VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'b80c988c2df279253a6b129cd906fad2d392eeab', '81fa25db-9570-41c9-9d4d-5b3bb5a0df77', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/"},"name":"dotnet-csharp-app-api","title":".NET 8 C# Minimal API REST API","description":"Interface REST para consulta de status, saúde e telemetria da aplicação C# .NET 8","uid":"63db9a4c-47aa-4c58-a818-dc552e7dd313","generation":1,"etag":"b80c988c2df279253a6b129cd906fad2d392eeab"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","definition":"openapi: \"3.0.0\"\ninfo:\n  title: .NET 8 C# Minimal API\n  version: \"1.0.0\"\npaths:\n  /:\n    get:\n      summary: Overview & HTML Dashboard\n      responses:\n        ''200'':\n          description: OK\n  /api/info:\n    get:\n      summary: System & client runtime information\n      responses:\n        ''200'':\n          description: OK\n  /healthz:\n    get:\n      summary: Liveness probe\n      responses:\n        ''200'':\n          description: OK\n  /ready:\n    get:\n      summary: Readiness probe\n      responses:\n        ''200'':\n          description: OK\n  /metrics:\n    get:\n      summary: Prometheus metrics\n      responses:\n        ''200'':\n          description: OK\n"},"relations":[{"type":"apiProvidedBy","target":{"kind":"component","namespace":"default","name":"dotnet-csharp-demo-app"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"apps-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('7056b87f-a004-4d97-8343-edf21f81730c', '74040247144757e7ef6f92eef8c4cf75e6d37d0e', 'c2b3ed44-94e5-44c8-af76-3f2407ecb32a', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-fe0f1bf72ec2879f9e6e9673b75d2a1f020b3878","uid":"7056b87f-a004-4d97-8343-edf21f81730c","generation":1,"etag":"74040247144757e7ef6f92eef8c4cf75e6d37d0e"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/galeed-community/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/a360-business/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('970d32b3-c8c8-457a-be7b-1082928a08fb', 'a1ad521d971ae7f3aef8fbcfa298fd17d5b55f9a', '51a5aa01-3e10-4068-a2c8-aedf24d73347', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-78a0f16f4da15640f067c17fea7b0935483fd142","uid":"970d32b3-c8c8-457a-be7b-1082928a08fb","generation":1,"etag":"a1ad521d971ae7f3aef8fbcfa298fd17d5b55f9a"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/agent-foreman/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/a360-business/agent-foreman/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/agent-foreman/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/agent-foreman/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/agent-foreman/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', '85eba869f58fcbf5f44da429369e9e1d4159acc5', '2cace450-d6ed-43ab-a5f8-cfad59866c11', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/"},"name":"python-sonarqube-cicd-template","title":"Python 3.12 Web App + CI/CD with QA, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Python (Flask + Gunicorn) repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki logging, and Backstage manifest.","tags":["python","flask","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"e7ce2e2c-1a65-412c-92af-958b480db2a9","generation":1,"etag":"85eba869f58fcbf5f44da429369e9e1d4159acc5"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"python-app-demo"},"description":{"title":"Description","type":"string","description":"What does this microservice do?","default":"Python microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"python-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}},"relations":[{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"squad-plataforma"}}]}');
INSERT INTO public.final_entities VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'bd8ef00a9f1a78189ef9689ad74c95f9c0615cde', '7f4ed5ac-c121-412a-875b-2552d4f4cf5f', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/"},"name":"generated-e1e842392fd0da6efe989d25722f835228d60e05","uid":"0292df28-4efd-43fd-a9ee-52ece26b6185","generation":1,"etag":"bd8ef00a9f1a78189ef9689ad74c95f9c0615cde"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('147335f7-820d-4e12-939a-13d0250820a6', '845d2db603549d238a8b81febad0b65b948f4270', '95643128-da4b-4163-b0c7-4a89357e5d5d', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-d6eb614c9d4a9daaeb84a95d3fece1a6a0dd9916","uid":"147335f7-820d-4e12-939a-13d0250820a6","generation":1,"etag":"845d2db603549d238a8b81febad0b65b948f4270"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirobessa/kube-demo-2026/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirobessa/kube-demo-2026/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirobessa/kube-demo-2026/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirobessa/kube-demo-2026/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirobessa/kube-demo-2026/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('83c4b685-a74b-4228-a442-a3903e0778b0', 'd55c8679eabc0201e6c49b976508892aebb02e91', '9c720071-79a8-4c6a-8e25-a14bcded9fbd', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/"},"name":"generated-689c18882dc297803e1a420c73b8783d094c8e17","uid":"83c4b685-a74b-4228-a442-a3903e0778b0","generation":1,"etag":"d55c8679eabc0201e6c49b976508892aebb02e91"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'd41ef0364c1db5ce21625ee34a0b786ca237c8be', '4f5eb3d3-a3ee-4b43-b090-3e5268aa50c6', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"prometheus","backstage.io/kubernetes-namespace":"monitoring","backstage.io/kubernetes-label-selector":"app.kubernetes.io/name=prometheus"},"name":"prometheus","description":"Prometheus Metrics Server & Node Exporter on EKS","uid":"5d7e145e-f768-46d6-9fe9-64263ace073e","generation":1,"etag":"d41ef0364c1db5ce21625ee34a0b786ca237c8be"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'ecb1f3b059032f35019f4810b1dbaacb4fa3a2be', '988f596d-7d4c-491c-bac3-194898a7e6e1', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/"},"name":"jvm-springboot-sonarqube-cicd-template","title":"JVM Spring Boot (Java 21) + CI/CD with SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Java 21 / Spring Boot 3.3 microservice repository with Maven + JaCoCo tests, SonarQube Quality Gate (SpotBugs/FindSecBugs & OWASP), Prometheus /metrics, Fluentd -> Loki JSON logs, and Backstage manifest.","tags":["java","jvm","springboot","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"70145be8-a40e-4a5a-b0ce-25af2aeadd94","generation":1,"etag":"ecb1f3b059032f35019f4810b1dbaacb4fa3a2be"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"springboot-app-demo"},"description":{"title":"Description","type":"string","description":"What does this Spring Boot microservice do?","default":"JVM Spring Boot 3.3 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"springboot-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}},"relations":[{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"squad-plataforma"}}]}');
INSERT INTO public.final_entities VALUES ('4cb23490-426e-4e19-9652-da094d279f3e', '6fe851eb4c268701062bb19f6bd32e4e79ab3833', '4d3b2a9c-a6e2-4245-a1c4-bafd41bff722', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-8f44ff1b0eee905e4f10b347f2f4cde12c6ecb91","uid":"4cb23490-426e-4e19-9652-da094d279f3e","generation":1,"etag":"6fe851eb4c268701062bb19f6bd32e4e79ab3833"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/MoreiraThi87/galeed-community/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/MoreiraThi87/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/MoreiraThi87/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/MoreiraThi87/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/MoreiraThi87/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', '7e4f528cd139f936bbbd83b1bd9f9f6177bd82a3', '213ac5bb-42b3-4391-a43d-c13d43013e0c', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"sonarqube","backstage.io/kubernetes-namespace":"sonarqube"},"name":"sonarqube","description":"SonarQube QA & Security Scanner on EKS (OWASP Dependency-Check, FindSecBugs & YAML/K8s Security plugins)","uid":"6cf1741d-cc32-41d6-83f5-2e02fe66c637","generation":1,"etag":"7e4f528cd139f936bbbd83b1bd9f9f6177bd82a3"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', '1372f99c0a94ccd979b5dc3b14b1c5abab75fa96', '170d8f2c-aa35-4762-8b6d-fc380124aabb', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/"},"name":"dotnet-sonarqube-cicd-template","title":".NET 8 C# Web App + CI/CD with QA, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete .NET 8 C# Minimal API repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki logging, and Backstage manifest.","tags":["dotnet","csharp","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"bd2f3497-ed87-4202-a8a4-4613a3b58f78","generation":1,"etag":"1372f99c0a94ccd979b5dc3b14b1c5abab75fa96"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"dotnet-csharp-app-demo"},"description":{"title":"Description","type":"string","description":"What does this microservice do?","default":".NET 8 C# microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"dotnet-csharp-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}},"relations":[{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"squad-plataforma"}}]}');
INSERT INTO public.final_entities VALUES ('c53ac0bc-ed1c-4e57-9161-2aa918a66513', '445e79bbc3e674f59b9bd4702ce1d3dd23869468', 'b2962cda-9c2d-4de5-bc40-d4177256bd60', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-83f2543400bad694b3b4169b8f0dda74347f09ca","uid":"c53ac0bc-ed1c-4e57-9161-2aa918a66513","generation":1,"etag":"445e79bbc3e674f59b9bd4702ce1d3dd23869468"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/talerelayapp/superfria/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/talerelayapp/superfria/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/talerelayapp/superfria/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/talerelayapp/superfria/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/talerelayapp/superfria/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('26a2b9a2-91df-4404-93e7-f9c5e2c4b62f', '466a71fd85c415bd9f2b7f174d985a12e1e447be', 'a09f34f1-aa36-46ad-b925-1edfb4e30ffe', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-d6c74b7d4667a209e2cd1841e6d838c0d7d20c98","uid":"26a2b9a2-91df-4404-93e7-f9c5e2c4b62f","generation":1,"etag":"466a71fd85c415bd9f2b7f174d985a12e1e447be"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/counter-service-exercise/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/counter-service-exercise/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/counter-service-exercise/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/counter-service-exercise/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/counter-service-exercise/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('b9d0245c-c6f9-4214-aa46-9d84d2235fce', '085f2ec41808f9ad2c32d646aa01733955fb9e11', '32b20551-4111-4522-a061-0ec24cac9289', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/microservice-template/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/"},"name":"generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98","uid":"b9d0245c-c6f9-4214-aa46-9d84d2235fce","generation":1,"etag":"085f2ec41808f9ad2c32d646aa01733955fb9e11"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'dfd3bb8eea67b6b0a06aa464e504a6b689d8219b', '80f8adee-30b8-438c-99a9-8523113e9f91', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/"},"name":"generated-64bf0f42f04286e509e88978a740e76f33a6cc2a","uid":"b997bba0-79d4-45ab-9ba3-3b007e722a86","generation":1,"etag":"dfd3bb8eea67b6b0a06aa464e504a6b689d8219b"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', '5fbd01012e624d08f9a810e16a94ff70c4954bc1', '25c8ca19-6c6f-4b44-8866-80ecae00b898', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"oidc-idp-api","description":"Endpoint OpenID Connect (OIDC) Discovery do Keycloak (sso.empresa.local)","uid":"f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2","generation":1,"etag":"5fbd01012e624d08f9a810e16a94ff70c4954bc1"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Keycloak OIDC Discovery API\n  version: \"1.0.0\"\npaths:\n  /realms/empresa/.well-known/openid-configuration:\n    get:\n      summary: Retorna a configuracao OIDC do Realm empresa\n      responses:\n        \"200\":\n          description: OIDC Discovery JSON\n"},"relations":[{"type":"apiProvidedBy","target":{"kind":"component","namespace":"default","name":"keycloak-sso"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}}]}');
INSERT INTO public.final_entities VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', '0ed790ee9dd9c7c6d26225eabb3faacb45a26e4e', 'f2bab11f-1027-4218-878d-86c9652e0d31', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/"},"name":"python-app-api","title":"Python Flask App REST API","description":"Interface REST para consulta de status, saúde e telemetria da aplicação Python","uid":"091b50f1-ebf5-4713-8048-9ad7b9d59968","generation":1,"etag":"0ed790ee9dd9c7c6d26225eabb3faacb45a26e4e"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Python App API\n  version: \"1.0.0\"\npaths:\n  /:\n    get:\n      summary: Overview & HTML Dashboard\n      responses:\n        ''200'':\n          description: OK\n  /api/info:\n    get:\n      summary: System & client runtime information\n      responses:\n        ''200'':\n          description: OK\n  /healthz:\n    get:\n      summary: Liveness probe\n      responses:\n        ''200'':\n          description: OK\n  /ready:\n    get:\n      summary: Readiness probe\n      responses:\n        ''200'':\n          description: OK\n  /metrics:\n    get:\n      summary: Prometheus metrics\n      responses:\n        ''200'':\n          description: OK\n"},"relations":[{"type":"apiProvidedBy","target":{"kind":"component","namespace":"default","name":"python-demo-app"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"apps-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', '35552bf9cf70a7f02f6f83ffc2aaa5dec8bcf3bc', 'd4373aac-5d4b-4928-9c2b-7a81754bf60d', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec","uid":"f4a11b84-32b1-4802-a206-b75b16465f11","generation":1,"etag":"35552bf9cf70a7f02f6f83ffc2aaa5dec8bcf3bc"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"file","target":"/etc/backstage/catalog-entities.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', '4f08d9a040cccbf2fd6332ddb622b13c68a90f50', '4bab6158-c04b-46c9-9982-7136889b4a76', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system"},"name":"kube-demo-eks","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","uid":"bd7f67a9-56d3-4906-8ae7-e5a360c38903","generation":1,"etag":"4f08d9a040cccbf2fd6332ddb622b13c68a90f50"},"apiVersion":"backstage.io/v1alpha1","kind":"Resource","spec":{"type":"kubernetes-cluster","owner":"platform-team","system":"kube-demo-2026"},"relations":[{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"argocd"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"backstage-portal"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"dotnet-csharp-demo-app"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"grafana"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"prometheus"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"python-demo-app"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"sonarqube"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('2f0b622d-7a82-4e30-a16e-d344a1d3fc10', 'ec3ea390aeae26a166b9fd10a84d7f5ca7c7c7d6', '549bae80-ab23-4eb7-90c3-5bf309c12cec', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/"},"name":"generated-b4f29ca1863623b0dea4276cfa3970b897899c36","uid":"2f0b622d-7a82-4e30-a16e-d344a1d3fc10","generation":1,"etag":"ec3ea390aeae26a166b9fd10a84d7f5ca7c7c7d6"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'd17743147f1476787aa41c2fd4032cefbeed4fd5', '84705c6c-268b-4dc8-a070-87a267aaeec0', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/","github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/kubernetes-id":"keycloak-sso","backstage.io/kubernetes-namespace":"default"},"name":"keycloak-sso","description":"Servidor Keycloak IAM (Broker SAML 2.0, OAuth2 e OIDC) federado via LDAP ao Samba 4 AD para autenticar Backstage, ArgoCD, Grafana e Apps Demo","tags":["keycloak","saml2","oidc","sso","mfa"],"uid":"59bcae1b-0310-4bf1-9216-1cc4fc975884","generation":1,"etag":"d17743147f1476787aa41c2fd4032cefbeed4fd5"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","dependsOn":["component:default/samba-ad-dc","component:default/freeradius-mfa"],"providesApis":["saml-idp-api","oidc-idp-api"]},"relations":[{"type":"dependsOn","target":{"kind":"component","namespace":"default","name":"freeradius-mfa"}},{"type":"dependsOn","target":{"kind":"component","namespace":"default","name":"samba-ad-dc"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}},{"type":"providesApi","target":{"kind":"api","namespace":"default","name":"oidc-idp-api"}},{"type":"providesApi","target":{"kind":"api","namespace":"default","name":"saml-idp-api"}}]}');
INSERT INTO public.final_entities VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'dc8300e3173ac09b771b2ddb8c2f67cb308cdca0', 'd4101246-7a8e-4233-9aea-7bd5085e7def', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/"},"name":"generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a","uid":"50cc71b8-67dc-4dac-91e0-57841741c1a5","generation":1,"etag":"dc8300e3173ac09b771b2ddb8c2f67cb308cdca0"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('2cbc721b-e1d4-4340-80df-340fd5872798', '8c7c2c819c3aac30767f9eb54a91f60a73532028', '74824929-82f8-4c46-a9e2-63ef49a3b311', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-e40d9e847bb90a7610522a0d467185a8e079bb3e","uid":"2cbc721b-e1d4-4340-80df-340fd5872798","generation":1,"etag":"8c7c2c819c3aac30767f9eb54a91f60a73532028"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/openclaw-setup/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/a360-business/openclaw-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/openclaw-setup/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/openclaw-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/openclaw-setup/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('45752d5d-178b-4c41-accd-053a59debedd', 'e5a3d8a658ba658322a0016af468afccede01a6c', 'bae49726-8097-4297-bf7e-8d920828923c', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-31a0877ed2bec2edf4feee46dd4161a60585d1ce","uid":"45752d5d-178b-4c41-accd-053a59debedd","generation":1,"etag":"e5a3d8a658ba658322a0016af468afccede01a6c"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', '3ad962943566d9a3950d29dd5d6fb4ca63f02d6f', '988aabf6-e4b4-491b-95d1-dcc84911566a', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage"},"name":"backstage-portal","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","uid":"5d61d659-a82b-47c2-b6a1-949fd04b6f27","generation":1,"etag":"3ad962943566d9a3950d29dd5d6fb4ca63f02d6f"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"website","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('8d116692-0278-464c-979e-ab81d3e5aefd', '9b2fcbc1da676d9a4f267368523a35ed0cede644', 'd5115bf6-c197-4a08-98f8-a3c51bb15b90', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-e461ccc7db88e98c2a26c40a0672f2e1edbfe4f0","uid":"8d116692-0278-464c-979e-ab81d3e5aefd","generation":1,"etag":"9b2fcbc1da676d9a4f267368523a35ed0cede644"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/leonardoserio/accelera-skills/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/leonardoserio/accelera-skills/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/leonardoserio/accelera-skills/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/leonardoserio/accelera-skills/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/leonardoserio/accelera-skills/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('b5678983-efe6-44d7-9c0d-3046066c1687', '59bc55b67fe9110a7a076fe781e30a019f92af7c', 'c86490dd-fad4-4ee0-b81e-2e47cca6a215', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-3a49cafceb0ae80411060ab243ac7adf4cb8101e","uid":"b5678983-efe6-44d7-9c0d-3046066c1687","generation":1,"etag":"59bc55b67fe9110a7a076fe781e30a019f92af7c"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/backstage-infra/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/backstage-infra/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/backstage-infra/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/backstage-infra/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', '98961b9855eb4bb3555bf160c58d0448b81efdd7', '82476f4b-bb53-441b-9097-3e6e70524d2f', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"kube-demo-2026","description":"AWS EKS 1.35 Platform, GitOps, Observability & Developer Portal","uid":"c061cd8b-71b0-4ad0-8a8c-064863bb4cf0","generation":1,"etag":"98961b9855eb4bb3555bf160c58d0448b81efdd7"},"apiVersion":"backstage.io/v1alpha1","kind":"System","spec":{"owner":"platform-team"},"relations":[{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"argocd"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"backstage-portal"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"grafana"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"prometheus"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"sonarqube"}},{"type":"hasPart","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}}]}');
INSERT INTO public.final_entities VALUES ('3a5d3700-d0c8-4bb4-bc90-1abb32008733', 'f356b157dbc6416712b60a3af3c31b55b4629a61', '3148ab25-434d-4301-bcfa-c7da66733865', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"generated-230c2622c092081637053d0a834587aef4c2bae2","uid":"3a5d3700-d0c8-4bb4-bc90-1abb32008733","generation":1,"etag":"f356b157dbc6416712b60a3af3c31b55b4629a61"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('ef7b0d9e-99e7-4c48-8994-f7df1b118282', 'ff9b139d07ba55fa7adb3f723bb2660c38e840a9', '70717854-c50e-4096-8203-7c43d489855d', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-1f8726637b31d8323de2ea178b5ccd8c303f90fa","uid":"ef7b0d9e-99e7-4c48-8994-f7df1b118282","generation":1,"etag":"ff9b139d07ba55fa7adb3f723bb2660c38e840a9"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/mesa-agents/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/mesa-agents/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/mesa-agents/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/mesa-agents/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/mesa-agents/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'fc8288ef4828c13323cadf43ebcefa7288a91ef4', 'f04c4d97-14b9-42fb-9b80-b27d43b0d4d8', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"saml-idp-api","description":"Endpoint SAML 2.0 Identity Provider do Keycloak (sso.empresa.local)","uid":"40be89b0-5809-47dc-a88c-5053d2b38724","generation":1,"etag":"fc8288ef4828c13323cadf43ebcefa7288a91ef4"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Keycloak SAML 2.0 IdP Descriptor\n  version: \"1.0.0\"\npaths:\n  /realms/empresa/protocol/saml/descriptor:\n    get:\n      summary: Retorna o XML de metadados SAML 2.0 do Realm empresa\n      responses:\n        \"200\":\n          description: SAML 2.0 Metadata XML\n"},"relations":[{"type":"apiProvidedBy","target":{"kind":"component","namespace":"default","name":"keycloak-sso"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}}]}');
INSERT INTO public.final_entities VALUES ('08a67f6a-55b9-4f17-9a6d-008303c617be', '2985c25fc9e861f92e4df243f7f1cdbc254dab1e', '11db1215-ff7b-406d-abaa-f818aab14a46', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-d2a36c4260a85053ce94fbe9c674187459d272db","uid":"08a67f6a-55b9-4f17-9a6d-008303c617be","generation":1,"etag":"2985c25fc9e861f92e4df243f7f1cdbc254dab1e"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/arthurecio/openclaw-setup/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/arthurecio/openclaw-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/arthurecio/openclaw-setup/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/arthurecio/openclaw-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/arthurecio/openclaw-setup/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'fe83ce5c544fa28fe0dc59719768342e5ef9deaa', '3a9d9242-8d1e-42e7-bc45-3939c67803f1', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/"},"name":"apps-demo-2026","title":"Apps Demo 2026 Ecosystem","description":"Microservices Demo Collection (Python 3.12 Flask, .NET 8 C# Minimal API) with CI/CD, SonarQube, Prometheus Metrics, Fluentd/Loki Logs, GitOps via ArgoCD and HTTPS via AWS ACM.","uid":"34c740af-8954-42f2-8520-94448a3ea8cd","generation":1,"etag":"fe83ce5c544fa28fe0dc59719768342e5ef9deaa"},"apiVersion":"backstage.io/v1alpha1","kind":"System","spec":{"owner":"platform-team"},"relations":[{"type":"hasPart","target":{"kind":"api","namespace":"default","name":"dotnet-csharp-app-api"}},{"type":"hasPart","target":{"kind":"api","namespace":"default","name":"python-app-api"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"dotnet-csharp-demo-app"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"python-demo-app"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}}]}');
INSERT INTO public.final_entities VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', '004ec17646acc85b1818b995323a854d0d4daa4a', 'b70df1f2-2928-40df-8e16-ac53a787e1b2', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"guest","uid":"c594da02-5da3-463f-b953-c6b40ea03639","generation":1,"etag":"004ec17646acc85b1818b995323a854d0d4daa4a"},"apiVersion":"backstage.io/v1alpha1","kind":"User","spec":{"profile":{"displayName":"Guest User","email":"guest@empresa.local"},"memberOf":["platform-team"]},"relations":[{"type":"memberOf","target":{"kind":"group","namespace":"default","name":"platform-team"}}]}');
INSERT INTO public.final_entities VALUES ('e0ad8fc3-b7ae-4b03-a636-748f7994afe7', 'd470bd8eb83d600ae78831c4d096bb3fa4ad259b', 'f55cb95a-4f88-4734-9ad3-7a2ff3df2c26', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/"},"name":"generated-7692b664b197d2303b0a28bb177c1b133773311c","uid":"e0ad8fc3-b7ae-4b03-a636-748f7994afe7","generation":1,"etag":"d470bd8eb83d600ae78831c4d096bb3fa4ad259b"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('9575b37e-e899-4803-9b03-61add445781f', '1b4356fb34afdd02999617c7eead5c3392d99f6a', 'a3322c53-d889-4cb0-9bf0-46d82c07c960', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/"},"name":"generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce","uid":"9575b37e-e899-4803-9b03-61add445781f","generation":1,"etag":"1b4356fb34afdd02999617c7eead5c3392d99f6a"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', '85222f82be7f25cea9dadfb1d45bab8016860f6d', '83174d9a-574d-4878-99ff-29deb04f9083', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/microservice-template/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/"},"name":"standard-microservice-template","title":"Standard Microservice with CI/CD, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a ready-to-use repository with a test pipeline, SonarQube Quality Gate validation, Prometheus metrics, Fluentd/Loki logging, and Backstage manifest.","tags":["node","python","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"270eff48-d8a7-4539-8bcc-c5aadd2103fb","generation":1,"etag":"85222f82be7f25cea9dadfb1d45bab8016860f6d"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$"},"description":{"title":"Description","type":"string","description":"What does this microservice do?"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"microservice-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}},"relations":[{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"squad-plataforma"}}]}');
INSERT INTO public.final_entities VALUES ('ef9ade31-8eb3-4c84-8de0-28f715ca82c0', '479a4348a3ace5972b6b5b3370434cbdba606a4a', 'e706ded0-b601-442e-8223-b2fc4f3b1286', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-b44b1f6c085e8ca890654a6f6755902d78d4c46b","uid":"ef9ade31-8eb3-4c84-8de0-28f715ca82c0","generation":1,"etag":"479a4348a3ace5972b6b5b3370434cbdba606a4a"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/vini-brito/growth-os-skills-full/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/vini-brito/growth-os-skills-full/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/vini-brito/growth-os-skills-full/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/vini-brito/growth-os-skills-full/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/vini-brito/growth-os-skills-full/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('d832b2bf-1c66-41f1-9cda-0d3d3d5943c4', '8df5cd52a845d6fe89945f84c55a970dd992bac1', 'bf73224a-a555-4ff2-97b9-4cdacafada75', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/orphan":"true"},"name":"generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551","uid":"d832b2bf-1c66-41f1-9cda-0d3d3d5943c4","generation":1,"etag":"8df5cd52a845d6fe89945f84c55a970dd992bac1"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"github-discovery","target":"https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('0e6caa74-5293-4053-a36c-4bcfd4ee5ca0', 'e17e510a504fb02ab922641029ff50f8df801e4a', '1c8e0bc3-7ad2-4957-ae21-1fb8ba98087a', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-6e615a027feacec08857bccd2c90fef1db2a2372","uid":"0e6caa74-5293-4053-a36c-4bcfd4ee5ca0","generation":1,"etag":"e17e510a504fb02ab922641029ff50f8df801e4a"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/accelera-skills/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/a360-business/accelera-skills/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/accelera-skills/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/accelera-skills/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/accelera-skills/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('ba7da6b3-9a3d-45be-ad81-a803860e93ca', '89f1bc6f306c9e5857c373843581b97932cd3188', '946d4f13-bd0b-4e1e-846d-37675aa9a29a', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-c7cbc24b24c9bd1238a6138087c948db5f143a8a","uid":"ba7da6b3-9a3d-45be-ad81-a803860e93ca","generation":1,"etag":"89f1bc6f306c9e5857c373843581b97932cd3188"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvajardim-crypto/mesa-site-institucional/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvajardim-crypto/mesa-site-institucional/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvajardim-crypto/mesa-site-institucional/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvajardim-crypto/mesa-site-institucional/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvajardim-crypto/mesa-site-institucional/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('a719699d-987b-4b60-90cd-1379aa96a91f', '933651d897258e8e46f96ae8e1b97de08de4f73f', '8f4ebabb-aba8-4087-a5f8-aa71a8d0cbc4', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-bcfe70fc389b7b6f55a5728ad12e48fbb12a7627","uid":"a719699d-987b-4b60-90cd-1379aa96a91f","generation":1,"etag":"933651d897258e8e46f96ae8e1b97de08de4f73f"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/zoeiroka-automacoes/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/zoeiroka-automacoes/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/zoeiroka-automacoes/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/zoeiroka-automacoes/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/zoeiroka-automacoes/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('b3095b41-0888-4c27-84f0-00bdceb205fe', '06543fa6fb15a606ee64c5a4e5a448482ca302de', '7a3f9d7a-0c32-48ab-a058-9f0ceb9a4a17', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-aea2074c195831a31fb8d1acdfcfd9ae7d08cd1b","uid":"b3095b41-0888-4c27-84f0-00bdceb205fe","generation":1,"etag":"06543fa6fb15a606ee64c5a4e5a448482ca302de"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/bot-dermatologia-mattos/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/bot-dermatologia-mattos/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/bot-dermatologia-mattos/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/bot-dermatologia-mattos/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/bot-dermatologia-mattos/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('b081a66a-a8cb-4e6d-a5c0-430c16450a42', 'e78bda2ac3d257185106aeb25b9948e86682c77c', '314c950a-7e4b-4b43-860b-e6ad8f3ac342', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-1fa5db3a5d97294de3a94bed049e4c7133c78dca","uid":"b081a66a-a8cb-4e6d-a5c0-430c16450a42","generation":1,"etag":"e78bda2ac3d257185106aeb25b9948e86682c77c"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/fabricaberger-droid/a360-dev-multiagentes/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/fabricaberger-droid/a360-dev-multiagentes/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/fabricaberger-droid/a360-dev-multiagentes/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/fabricaberger-droid/a360-dev-multiagentes/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/fabricaberger-droid/a360-dev-multiagentes/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('16c3cb70-e2e9-4910-80e9-b173ef4de30b', 'ac71d15e253d0c4d098902762af31cc7b333b377', '70a61d0e-a9fa-4ff1-a429-69f5259fb04c', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-023ff0c2d516eb7ee170b46c23edf162e464605b","uid":"16c3cb70-e2e9-4910-80e9-b173ef4de30b","generation":1,"etag":"ac71d15e253d0c4d098902762af31cc7b333b377"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/joaoguibune/galeed-community/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/joaoguibune/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/joaoguibune/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/joaoguibune/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/joaoguibune/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('257e492a-1177-431b-b323-5689c6369907', '03fd60917851db30e17b3025b46ad91bb8e27108', '3a702607-a3e6-402b-b44e-1fae30c31d52', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"radius-mfa-api","description":"Endpoint FreeRADIUS Auth (UDP 1812) e Acct (UDP 1813) com suporte a MFA (radius.empresa.local)","uid":"257e492a-1177-431b-b323-5689c6369907","generation":1,"etag":"03fd60917851db30e17b3025b46ad91bb8e27108"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"grpc","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"syntax = \"proto3\";\nservice FreeRadiusMFA {\n  // UDP radius.empresa.local:1812 (Auth + MFA)\n  // UDP radius.empresa.local:1813 (Accounting)\n}\n"},"relations":[{"type":"apiProvidedBy","target":{"kind":"component","namespace":"default","name":"freeradius-mfa"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}}]}');
INSERT INTO public.final_entities VALUES ('6679cc68-fcb4-4c93-87c0-4ac41bd02e23', '5262d823f593291dcb219e0adc30543e175fab9c', '3a502b71-3c18-41f7-81f7-5c89fba478a0', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-fa205f62d462a6f82aa4a1b49761425165444beb","uid":"6679cc68-fcb4-4c93-87c0-4ac41bd02e23","generation":1,"etag":"5262d823f593291dcb219e0adc30543e175fab9c"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/master-developer-nandomatik/growth-os-skills-full/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/master-developer-nandomatik/growth-os-skills-full/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/master-developer-nandomatik/growth-os-skills-full/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/master-developer-nandomatik/growth-os-skills-full/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/master-developer-nandomatik/growth-os-skills-full/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('49c5d45a-10ac-4e69-86a6-abe8514e289e', '837dbae446408a2ffc2336114b5d1d680ff30f3b', '55453f74-a194-44a7-a490-90d3b7bf2abf', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-6bcefc9bd5af69ed0137a6ce0836fe36e0fef7f2","uid":"49c5d45a-10ac-4e69-86a6-abe8514e289e","generation":1,"etag":"837dbae446408a2ffc2336114b5d1d680ff30f3b"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/bs-tutelas-patentes-site/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/bs-tutelas-patentes-site/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/bs-tutelas-patentes-site/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/bs-tutelas-patentes-site/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/bs-tutelas-patentes-site/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('1495d3c6-d8f8-42b5-8674-975878d1bbb3', 'f90563bdfbceb83fc718489f400bc317c4fe6e84', 'dfcd745f-758b-489a-978f-653679aab370', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-03b13b5fb17fe9a670e36e235ad81fd06fcfd666","uid":"1495d3c6-d8f8-42b5-8674-975878d1bbb3","generation":1,"etag":"f90563bdfbceb83fc718489f400bc317c4fe6e84"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/setup-ambiente/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/a360-business/setup-ambiente/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/setup-ambiente/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/setup-ambiente/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/setup-ambiente/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('03fa39dd-9139-4384-ac01-2f4bfaf3d4dd', '376642a9fc70a5687ab868a665ef370f024afa96', '0ea0ac97-7fa0-40b8-be64-446e478f2fea', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-39540a08be0bcb5645ee1d683b08d860953c5b44","uid":"03fa39dd-9139-4384-ac01-2f4bfaf3d4dd","generation":1,"etag":"376642a9fc70a5687ab868a665ef370f024afa96"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/scripts1/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/scripts1/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/scripts1/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/scripts1/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/scripts1/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('3fe9e6d5-e48d-4859-825a-24b08ccd4ceb', '22d9c70bcd5ec33a23468ab6bfa8af48fe6bcbda', '54f7ef46-d731-4ac0-8e20-98abf63ff02d', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-796712c88a485ec71e012b5c5f4566412a5f5672","uid":"3fe9e6d5-e48d-4859-825a-24b08ccd4ceb","generation":1,"etag":"22d9c70bcd5ec33a23468ab6bfa8af48fe6bcbda"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/growth-os-skills-full/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/a360-business/growth-os-skills-full/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/growth-os-skills-full/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/growth-os-skills-full/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/growth-os-skills-full/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'a9f823cfd2a53c0d9ddded8bbc175f4f0b225f62', '756fcf8a-e6d3-4c9b-9daa-b766a744f8ee', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"grafana","backstage.io/kubernetes-namespace":"grafana"},"name":"grafana","description":"Grafana Observability UI receiving metrics from Prometheus on EKS","uid":"e7874ba5-8387-43bb-82a2-588659c8f617","generation":1,"etag":"a9f823cfd2a53c0d9ddded8bbc175f4f0b225f62"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["component:default/prometheus-monitoring","resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"component","namespace":"default","name":"prometheus-monitoring"}},{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'c08c9fb63bf1edcecdc40170370311609324e0f8', 'dfb036ce-428c-4ca0-8333-e65e66893f0d', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/","github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/kubernetes-id":"samba-ad-dc","backstage.io/kubernetes-namespace":"default"},"name":"samba-ad-dc","description":"Samba 4 Active Directory Multi-DC (DC1 Principal + DC2 Réplica em Multi-AZ com --dns-backend=NONE e Route 53 Private Hosted Zone)","tags":["samba4","active-directory","ldap","kerberos","route53"],"uid":"d8aa8894-4fe0-436a-99c1-3ee2c3439e11","generation":1,"etag":"c08c9fb63bf1edcecdc40170370311609324e0f8"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","providesApis":["ldap-ad-api"]},"relations":[{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"freeradius-mfa"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"keycloak-sso"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}},{"type":"providesApi","target":{"kind":"api","namespace":"default","name":"ldap-ad-api"}}]}');
INSERT INTO public.final_entities VALUES ('d8b23781-db44-446e-a796-22e57d97b0c9', '107147be2817a4923b13ae138065b8c1e0328aaa', 'c45f5b0c-73b1-413f-8892-3cfde5f36068', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-c377ebbfb933b0a54dfd0e158734712e21979bde","uid":"d8b23781-db44-446e-a796-22e57d97b0c9","generation":1,"etag":"107147be2817a4923b13ae138065b8c1e0328aaa"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/FernandoNesi/galeed-community/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/FernandoNesi/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/FernandoNesi/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/FernandoNesi/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/FernandoNesi/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', '8202a630f5aaf0a0dc85d1aa6c7a8f9c3359aec0', 'ad79aa77-175e-46a9-a9a3-fe4de3df2e14', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"argocd","backstage.io/kubernetes-namespace":"argocd","backstage.io/kubernetes-label-selector":"app.kubernetes.io/part-of=argocd"},"name":"argocd","description":"ArgoCD GitOps Continuous Delivery Controller on EKS","uid":"a2837fe8-7139-43d3-9d5e-67166f32ade2","generation":1,"etag":"8202a630f5aaf0a0dc85d1aa6c7a8f9c3359aec0"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'e2d62894839313cfa8a74c2f05f80042d1d6d949', 'd0d043d2-75af-4f98-bea7-af1c48407365', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"platform-team","description":"Platform Engineering & DevEx Team","uid":"c6bce8e1-4852-4234-aee5-38f6e029b95f","generation":1,"etag":"e2d62894839313cfa8a74c2f05f80042d1d6d949"},"apiVersion":"backstage.io/v1alpha1","kind":"Group","spec":{"type":"team","children":[],"members":["guest"]},"relations":[{"type":"hasMember","target":{"kind":"user","namespace":"default","name":"guest"}},{"type":"ownerOf","target":{"kind":"api","namespace":"default","name":"dotnet-csharp-app-api"}},{"type":"ownerOf","target":{"kind":"api","namespace":"default","name":"ldap-ad-api"}},{"type":"ownerOf","target":{"kind":"api","namespace":"default","name":"oidc-idp-api"}},{"type":"ownerOf","target":{"kind":"api","namespace":"default","name":"python-app-api"}},{"type":"ownerOf","target":{"kind":"api","namespace":"default","name":"radius-mfa-api"}},{"type":"ownerOf","target":{"kind":"api","namespace":"default","name":"saml-idp-api"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"argocd"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"backstage-portal"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"dotnet-csharp-demo-app"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"freeradius-mfa"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"grafana"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"keycloak-sso"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"prometheus"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"python-demo-app"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"samba-ad-dc"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"sonarqube"}},{"type":"ownerOf","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownerOf","target":{"kind":"system","namespace":"default","name":"apps-demo-2026"}},{"type":"ownerOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}},{"type":"ownerOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}}]}');
INSERT INTO public.final_entities VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'ce6b84fb730b28fa46b29ecd5affdbb917219c4b', 'cacf9ed6-2657-4f05-a598-daf3022e91df', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/","github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/kubernetes-id":"freeradius-mfa","backstage.io/kubernetes-namespace":"default"},"name":"freeradius-mfa","description":"Servidor FreeRADIUS + PAM Google Authenticator (TOTP MFA) integrado ao Samba 4 AD para autenticação geral e MFA na VPC do EKS","tags":["radius","freeradius","mfa","totp"],"uid":"78aca34d-c7ad-4316-9d74-afd733e893a3","generation":1,"etag":"ce6b84fb730b28fa46b29ecd5affdbb917219c4b"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","dependsOn":["component:default/samba-ad-dc"],"providesApis":["radius-mfa-api"]},"relations":[{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"keycloak-sso"}},{"type":"dependsOn","target":{"kind":"component","namespace":"default","name":"samba-ad-dc"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}},{"type":"providesApi","target":{"kind":"api","namespace":"default","name":"radius-mfa-api"}}]}');
INSERT INTO public.final_entities VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'f5fa00d194e45a49cffcc0f5d72f6b1a4e6b97cd', '17696ed5-9a31-4810-8eac-5c595dfe967e', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"samba-ad-keycloak-iam","description":"Arquitetura Corporativa IAM na VPC do EKS (Samba 4 AD Multi-DC sem DNS interno + Route 53 Private Zone + FreeRADIUS MFA + Keycloak SAML 2.0 / OIDC)","uid":"2a9beea9-e004-4fd5-8dda-11f2c52f5f07","generation":1,"etag":"f5fa00d194e45a49cffcc0f5d72f6b1a4e6b97cd"},"apiVersion":"backstage.io/v1alpha1","kind":"System","spec":{"owner":"platform-team"},"relations":[{"type":"hasPart","target":{"kind":"api","namespace":"default","name":"ldap-ad-api"}},{"type":"hasPart","target":{"kind":"api","namespace":"default","name":"oidc-idp-api"}},{"type":"hasPart","target":{"kind":"api","namespace":"default","name":"radius-mfa-api"}},{"type":"hasPart","target":{"kind":"api","namespace":"default","name":"saml-idp-api"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"freeradius-mfa"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"keycloak-sso"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"samba-ad-dc"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}}]}');


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

INSERT INTO public.refresh_state VALUES ('e0ad8fc3-b7ae-4b03-a636-748f7994afe7', 'location:default/generated-7692b664b197d2303b0a28bb177c1b133773311c', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-7692b664b197d2303b0a28bb177c1b133773311c","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/"},"name":"generated-7692b664b197d2303b0a28bb177c1b133773311c","uid":"e0ad8fc3-b7ae-4b03-a636-748f7994afe7"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml"}}', '{}', '[]', '2026-11-02 01:50:43.189296+00', '2026-11-02 01:29:41.428819+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('16c3cb70-e2e9-4910-80e9-b173ef4de30b', 'location:default/generated-023ff0c2d516eb7ee170b46c23edf162e464605b', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-023ff0c2d516eb7ee170b46c23edf162e464605b","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/joaoguibune/galeed-community/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-023ff0c2d516eb7ee170b46c23edf162e464605b","uid":"16c3cb70-e2e9-4910-80e9-b173ef4de30b"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/joaoguibune/galeed-community/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/joaoguibune/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/joaoguibune/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.412431+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('2f0b622d-7a82-4e30-a16e-d344a1d3fc10', 'location:default/generated-b4f29ca1863623b0dea4276cfa3970b897899c36', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-b4f29ca1863623b0dea4276cfa3970b897899c36","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/"},"name":"generated-b4f29ca1863623b0dea4276cfa3970b897899c36","uid":"2f0b622d-7a82-4e30-a16e-d344a1d3fc10"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml"}}', '{}', '[]', '2026-11-02 01:50:43.189296+00', '2026-11-02 01:29:41.428819+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'resource:default/kube-demo-eks', '{"apiVersion":"backstage.io/v1alpha1","kind":"Resource","metadata":{"name":"kube-demo-eks","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","annotations":{"backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"kubernetes-cluster","owner":"platform-team","system":"kube-demo-2026"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system"},"name":"kube-demo-eks","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","uid":"bd7f67a9-56d3-4906-8ae7-e5a360c38903"},"apiVersion":"backstage.io/v1alpha1","kind":"Resource","spec":{"type":"kubernetes-cluster","owner":"platform-team","system":"kube-demo-2026"}}', '{}', '[]', '2026-11-02 01:50:47.192782+00', '2026-11-02 01:49:03.24855+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'location:default/generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/"},"name":"generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a","uid":"50cc71b8-67dc-4dac-91e0-57841741c1a5"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml"}}', '{}', '[]', '2026-11-02 01:50:43.189296+00', '2026-11-02 01:29:41.428819+00', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('3a5d3700-d0c8-4bb4-bc90-1abb32008733', 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-230c2622c092081637053d0a834587aef4c2bae2","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"generated-230c2622c092081637053d0a834587aef4c2bae2","uid":"3a5d3700-d0c8-4bb4-bc90-1abb32008733"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml"}}', '{}', '[]', '2026-11-02 01:50:43.189296+00', '2026-11-02 01:29:41.428819+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('9575b37e-e899-4803-9b03-61add445781f', 'location:default/generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/"},"name":"generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce","uid":"9575b37e-e899-4803-9b03-61add445781f"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml"}}', '{}', '[]', '2026-11-02 01:50:43.189296+00', '2026-11-02 01:29:41.428819+00', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'api:default/saml-idp-api', '{"apiVersion":"backstage.io/v1alpha1","kind":"API","metadata":{"name":"saml-idp-api","description":"Endpoint SAML 2.0 Identity Provider do Keycloak (sso.empresa.local)","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"}},"spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Keycloak SAML 2.0 IdP Descriptor\n  version: \"1.0.0\"\npaths:\n  /realms/empresa/protocol/saml/descriptor:\n    get:\n      summary: Retorna o XML de metadados SAML 2.0 do Realm empresa\n      responses:\n        \"200\":\n          description: SAML 2.0 Metadata XML\n"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"saml-idp-api","description":"Endpoint SAML 2.0 Identity Provider do Keycloak (sso.empresa.local)","uid":"40be89b0-5809-47dc-a88c-5053d2b38724"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Keycloak SAML 2.0 IdP Descriptor\n  version: \"1.0.0\"\npaths:\n  /realms/empresa/protocol/saml/descriptor:\n    get:\n      summary: Retorna o XML de metadados SAML 2.0 do Realm empresa\n      responses:\n        \"200\":\n          description: SAML 2.0 Metadata XML\n"}}', '{}', '[]', '2026-11-02 01:50:47.384886+00', '2026-11-02 01:49:03.443007+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"file","target":"/etc/backstage/catalog-entities.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec","uid":"f4a11b84-32b1-4802-a206-b75b16465f11"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"file","target":"/etc/backstage/catalog-entities.yaml"}}', '{}', '[]', '2026-11-02 01:50:43.189296+00', '2026-11-02 01:29:41.428819+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('6679cc68-fcb4-4c93-87c0-4ac41bd02e23', 'location:default/generated-fa205f62d462a6f82aa4a1b49761425165444beb', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-fa205f62d462a6f82aa4a1b49761425165444beb","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/master-developer-nandomatik/growth-os-skills-full/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-fa205f62d462a6f82aa4a1b49761425165444beb","uid":"6679cc68-fcb4-4c93-87c0-4ac41bd02e23"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/master-developer-nandomatik/growth-os-skills-full/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/master-developer-nandomatik/growth-os-skills-full/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/master-developer-nandomatik/growth-os-skills-full/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.191899+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'location:default/generated-e1e842392fd0da6efe989d25722f835228d60e05', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-e1e842392fd0da6efe989d25722f835228d60e05","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/"},"name":"generated-e1e842392fd0da6efe989d25722f835228d60e05","uid":"0292df28-4efd-43fd-a9ee-52ece26b6185"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml"}}', '{}', '[]', '2026-11-02 01:50:43.189296+00', '2026-11-02 01:29:41.428819+00', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('d832b2bf-1c66-41f1-9cda-0d3d3d5943c4', 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"github-discovery","target":"https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551","uid":"d832b2bf-1c66-41f1-9cda-0d3d3d5943c4"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"github-discovery","target":"https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}}', '{}', '[]', '2026-11-02 01:50:43.189296+00', '2026-11-02 01:29:01.731216+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('c53ac0bc-ed1c-4e57-9161-2aa918a66513', 'location:default/generated-83f2543400bad694b3b4169b8f0dda74347f09ca', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-83f2543400bad694b3b4169b8f0dda74347f09ca","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/talerelayapp/superfria/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-83f2543400bad694b3b4169b8f0dda74347f09ca","uid":"c53ac0bc-ed1c-4e57-9161-2aa918a66513"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/talerelayapp/superfria/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/talerelayapp/superfria/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/talerelayapp/superfria/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.191899+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'template:default/jvm-springboot-sonarqube-cicd-template', '{"apiVersion":"backstage.io/v1beta2","kind":"Template","metadata":{"name":"jvm-springboot-sonarqube-cicd-template","title":"JVM Spring Boot (Java 21) + CI/CD with SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Java 21 / Spring Boot 3.3 microservice repository with Maven + JaCoCo tests, SonarQube Quality Gate (SpotBugs/FindSecBugs & OWASP), Prometheus /metrics, Fluentd -> Loki JSON logs, and Backstage manifest.","tags":["java","jvm","springboot","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml"}},"spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"springboot-app-demo"},"description":{"title":"Description","type":"string","description":"What does this Spring Boot microservice do?","default":"JVM Spring Boot 3.3 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"springboot-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/"},"name":"jvm-springboot-sonarqube-cicd-template","title":"JVM Spring Boot (Java 21) + CI/CD with SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Java 21 / Spring Boot 3.3 microservice repository with Maven + JaCoCo tests, SonarQube Quality Gate (SpotBugs/FindSecBugs & OWASP), Prometheus /metrics, Fluentd -> Loki JSON logs, and Backstage manifest.","tags":["java","jvm","springboot","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"70145be8-a40e-4a5a-b0ce-25af2aeadd94"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"springboot-app-demo"},"description":{"title":"Description","type":"string","description":"What does this Spring Boot microservice do?","default":"JVM Spring Boot 3.3 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"springboot-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{}', '[]', '2026-11-02 01:50:47.327728+00', '2026-11-02 01:49:03.419934+00', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('257e492a-1177-431b-b323-5689c6369907', 'api:default/radius-mfa-api', '{"apiVersion":"backstage.io/v1alpha1","kind":"API","metadata":{"name":"radius-mfa-api","description":"Endpoint FreeRADIUS Auth (UDP 1812) e Acct (UDP 1813) com suporte a MFA (radius.empresa.local)","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"}},"spec":{"type":"grpc","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"syntax = \"proto3\";\nservice FreeRadiusMFA {\n  // UDP radius.empresa.local:1812 (Auth + MFA)\n  // UDP radius.empresa.local:1813 (Accounting)\n}\n"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"radius-mfa-api","description":"Endpoint FreeRADIUS Auth (UDP 1812) e Acct (UDP 1813) com suporte a MFA (radius.empresa.local)","uid":"257e492a-1177-431b-b323-5689c6369907"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"grpc","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"syntax = \"proto3\";\nservice FreeRadiusMFA {\n  // UDP radius.empresa.local:1812 (Auth + MFA)\n  // UDP radius.empresa.local:1813 (Accounting)\n}\n"}}', '{}', '[]', '2026-11-02 01:50:47.4234+00', '2026-11-02 01:49:03.443007+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('b9d0245c-c6f9-4214-aa46-9d84d2235fce', 'location:default/generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/microservice-template/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/"},"name":"generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98","uid":"b9d0245c-c6f9-4214-aa46-9d84d2235fce"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml"}}', '{}', '[]', '2026-11-02 01:50:43.189296+00', '2026-11-02 01:29:41.428819+00', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml');
INSERT INTO public.refresh_state VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'api:default/ldap-ad-api', '{"apiVersion":"backstage.io/v1alpha1","kind":"API","metadata":{"name":"ldap-ad-api","description":"Endpoint LDAP/LDAPS Round-Robin do Samba 4 AD (ldap://ad.empresa.local:389)","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"}},"spec":{"type":"grpc","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"syntax = \"proto3\";\nservice ActiveDirectoryLDAP {\n  // ldap://ad.empresa.local:389 (Round-Robin DC1 & DC2)\n  // Base DN: DC=empresa,DC=local\n}\n"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"ldap-ad-api","description":"Endpoint LDAP/LDAPS Round-Robin do Samba 4 AD (ldap://ad.empresa.local:389)","uid":"a47d058b-3461-44b2-9feb-97fec94b206f"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"grpc","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"syntax = \"proto3\";\nservice ActiveDirectoryLDAP {\n  // ldap://ad.empresa.local:389 (Round-Robin DC1 & DC2)\n  // Base DN: DC=empresa,DC=local\n}\n"}}', '{}', '[]', '2026-11-02 01:50:47.384886+00', '2026-11-02 01:49:03.443007+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('26a2b9a2-91df-4404-93e7-f9c5e2c4b62f', 'location:default/generated-d6c74b7d4667a209e2cd1841e6d838c0d7d20c98', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-d6c74b7d4667a209e2cd1841e6d838c0d7d20c98","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/counter-service-exercise/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-d6c74b7d4667a209e2cd1841e6d838c0d7d20c98","uid":"26a2b9a2-91df-4404-93e7-f9c5e2c4b62f"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/counter-service-exercise/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/counter-service-exercise/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/counter-service-exercise/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.191899+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('d8b23781-db44-446e-a796-22e57d97b0c9', 'location:default/generated-c377ebbfb933b0a54dfd0e158734712e21979bde', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-c377ebbfb933b0a54dfd0e158734712e21979bde","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/FernandoNesi/galeed-community/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-c377ebbfb933b0a54dfd0e158734712e21979bde","uid":"d8b23781-db44-446e-a796-22e57d97b0c9"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/FernandoNesi/galeed-community/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/FernandoNesi/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/FernandoNesi/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.191899+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'component:default/grafana', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"grafana","description":"Grafana Observability UI receiving metrics from Prometheus on EKS","annotations":{"backstage.io/kubernetes-id":"grafana","backstage.io/kubernetes-namespace":"grafana","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["component:default/prometheus-monitoring","resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"grafana","backstage.io/kubernetes-namespace":"grafana"},"name":"grafana","description":"Grafana Observability UI receiving metrics from Prometheus on EKS","uid":"e7874ba5-8387-43bb-82a2-588659c8f617"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["component:default/prometheus-monitoring","resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-02 01:50:47.192782+00', '2026-11-02 01:49:03.24855+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'location:default/generated-64bf0f42f04286e509e88978a740e76f33a6cc2a', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-64bf0f42f04286e509e88978a740e76f33a6cc2a","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/"},"name":"generated-64bf0f42f04286e509e88978a740e76f33a6cc2a","uid":"b997bba0-79d4-45ab-9ba3-3b007e722a86"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml"}}', '{}', '[]', '2026-11-02 01:50:44.189839+00', '2026-11-02 01:29:41.428819+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'component:default/prometheus', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"prometheus","description":"Prometheus Metrics Server & Node Exporter on EKS","annotations":{"backstage.io/kubernetes-id":"prometheus","backstage.io/kubernetes-namespace":"monitoring","backstage.io/kubernetes-label-selector":"app.kubernetes.io/name=prometheus","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"prometheus","backstage.io/kubernetes-namespace":"monitoring","backstage.io/kubernetes-label-selector":"app.kubernetes.io/name=prometheus"},"name":"prometheus","description":"Prometheus Metrics Server & Node Exporter on EKS","uid":"5d7e145e-f768-46d6-9fe9-64263ace073e"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-02 01:50:47.192782+00', '2026-11-02 01:49:03.24855+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('147335f7-820d-4e12-939a-13d0250820a6', 'location:default/generated-d6eb614c9d4a9daaeb84a95d3fece1a6a0dd9916', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-d6eb614c9d4a9daaeb84a95d3fece1a6a0dd9916","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirobessa/kube-demo-2026/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-d6eb614c9d4a9daaeb84a95d3fece1a6a0dd9916","uid":"147335f7-820d-4e12-939a-13d0250820a6"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirobessa/kube-demo-2026/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirobessa/kube-demo-2026/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirobessa/kube-demo-2026/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.191899+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('970d32b3-c8c8-457a-be7b-1082928a08fb', 'location:default/generated-78a0f16f4da15640f067c17fea7b0935483fd142', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-78a0f16f4da15640f067c17fea7b0935483fd142","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/a360-business/agent-foreman/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-78a0f16f4da15640f067c17fea7b0935483fd142","uid":"970d32b3-c8c8-457a-be7b-1082928a08fb"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/agent-foreman/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/agent-foreman/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/agent-foreman/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:45.191348+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('83c4b685-a74b-4228-a442-a3903e0778b0', 'location:default/generated-689c18882dc297803e1a420c73b8783d094c8e17', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-689c18882dc297803e1a420c73b8783d094c8e17","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/"},"name":"generated-689c18882dc297803e1a420c73b8783d094c8e17","uid":"83c4b685-a74b-4228-a442-a3903e0778b0"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml"}}', '{}', '[]', '2026-11-02 01:50:43.189296+00', '2026-11-02 01:29:41.428819+00', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('4cb23490-426e-4e19-9652-da094d279f3e', 'location:default/generated-8f44ff1b0eee905e4f10b347f2f4cde12c6ecb91', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-8f44ff1b0eee905e4f10b347f2f4cde12c6ecb91","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/MoreiraThi87/galeed-community/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-8f44ff1b0eee905e4f10b347f2f4cde12c6ecb91","uid":"4cb23490-426e-4e19-9652-da094d279f3e"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/MoreiraThi87/galeed-community/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/MoreiraThi87/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/MoreiraThi87/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.191899+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'component:default/argocd', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"argocd","description":"ArgoCD GitOps Continuous Delivery Controller on EKS","annotations":{"backstage.io/kubernetes-id":"argocd","backstage.io/kubernetes-namespace":"argocd","backstage.io/kubernetes-label-selector":"app.kubernetes.io/part-of=argocd","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"argocd","backstage.io/kubernetes-namespace":"argocd","backstage.io/kubernetes-label-selector":"app.kubernetes.io/part-of=argocd"},"name":"argocd","description":"ArgoCD GitOps Continuous Delivery Controller on EKS","uid":"a2837fe8-7139-43d3-9d5e-67166f32ade2"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-02 01:50:47.192782+00', '2026-11-02 01:49:03.24855+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('1495d3c6-d8f8-42b5-8674-975878d1bbb3', 'location:default/generated-03b13b5fb17fe9a670e36e235ad81fd06fcfd666', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-03b13b5fb17fe9a670e36e235ad81fd06fcfd666","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/a360-business/setup-ambiente/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-03b13b5fb17fe9a670e36e235ad81fd06fcfd666","uid":"1495d3c6-d8f8-42b5-8674-975878d1bbb3"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/setup-ambiente/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/setup-ambiente/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/setup-ambiente/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:45.191348+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('0e6caa74-5293-4053-a36c-4bcfd4ee5ca0', 'location:default/generated-6e615a027feacec08857bccd2c90fef1db2a2372', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-6e615a027feacec08857bccd2c90fef1db2a2372","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/a360-business/accelera-skills/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-6e615a027feacec08857bccd2c90fef1db2a2372","uid":"0e6caa74-5293-4053-a36c-4bcfd4ee5ca0"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/accelera-skills/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/accelera-skills/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/accelera-skills/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:45.191348+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('15d0d89c-e09d-4679-a192-0892d1cd29bc', 'location:default/generated-bd14bea673b37261e7a74bd04975480bb069f8bc', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-bd14bea673b37261e7a74bd04975480bb069f8bc","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/a360-business/a360-dev-multiagentes/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-bd14bea673b37261e7a74bd04975480bb069f8bc","uid":"15d0d89c-e09d-4679-a192-0892d1cd29bc"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/a360-dev-multiagentes/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/a360-dev-multiagentes/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/a360-dev-multiagentes/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:45.191348+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('adeb7f13-198c-4a2e-aa65-06684ee4ee4e', 'location:default/generated-edb107c0bf74b8a4c4c763787b54180b9801f99b', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-edb107c0bf74b8a4c4c763787b54180b9801f99b","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/a360-business/hermes-setup/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-edb107c0bf74b8a4c4c763787b54180b9801f99b","uid":"adeb7f13-198c-4a2e-aa65-06684ee4ee4e"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/hermes-setup/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/hermes-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/hermes-setup/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:45.191348+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('b081a66a-a8cb-4e6d-a5c0-430c16450a42', 'location:default/generated-1fa5db3a5d97294de3a94bed049e4c7133c78dca', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-1fa5db3a5d97294de3a94bed049e4c7133c78dca","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/fabricaberger-droid/a360-dev-multiagentes/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-1fa5db3a5d97294de3a94bed049e4c7133c78dca","uid":"b081a66a-a8cb-4e6d-a5c0-430c16450a42"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/fabricaberger-droid/a360-dev-multiagentes/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/fabricaberger-droid/a360-dev-multiagentes/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/fabricaberger-droid/a360-dev-multiagentes/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.441871+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('f3e4a0a1-be3a-4f1c-97be-0dda1b365099', 'location:default/generated-9a24efc486a6e189695017ff7d1ff5886f9498aa', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-9a24efc486a6e189695017ff7d1ff5886f9498aa","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/hermes-backup-1-vid-agentes-repos/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-9a24efc486a6e189695017ff7d1ff5886f9498aa","uid":"f3e4a0a1-be3a-4f1c-97be-0dda1b365099"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/hermes-backup-1-vid-agentes-repos/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/hermes-backup-1-vid-agentes-repos/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/hermes-backup-1-vid-agentes-repos/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.191899+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('45752d5d-178b-4c41-accd-053a59debedd', 'location:default/generated-31a0877ed2bec2edf4feee46dd4161a60585d1ce', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-31a0877ed2bec2edf4feee46dd4161a60585d1ce","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-31a0877ed2bec2edf4feee46dd4161a60585d1ce","uid":"45752d5d-178b-4c41-accd-053a59debedd"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.412431+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', 'user:default/guest', '{"apiVersion":"backstage.io/v1alpha1","kind":"User","metadata":{"name":"guest","annotations":{"backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"profile":{"displayName":"Guest User","email":"guest@empresa.local"},"memberOf":["platform-team"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"guest","uid":"c594da02-5da3-463f-b953-c6b40ea03639"},"apiVersion":"backstage.io/v1alpha1","kind":"User","spec":{"profile":{"displayName":"Guest User","email":"guest@empresa.local"},"memberOf":["platform-team"]}}', '{}', '[]', '2026-11-02 01:50:47.192782+00', '2026-11-02 01:49:03.24855+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('2cbc721b-e1d4-4340-80df-340fd5872798', 'location:default/generated-e40d9e847bb90a7610522a0d467185a8e079bb3e', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-e40d9e847bb90a7610522a0d467185a8e079bb3e","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/a360-business/openclaw-setup/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-e40d9e847bb90a7610522a0d467185a8e079bb3e","uid":"2cbc721b-e1d4-4340-80df-340fd5872798"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/openclaw-setup/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/openclaw-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/openclaw-setup/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:45.191348+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('8d116692-0278-464c-979e-ab81d3e5aefd', 'location:default/generated-e461ccc7db88e98c2a26c40a0672f2e1edbfe4f0', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-e461ccc7db88e98c2a26c40a0672f2e1edbfe4f0","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/leonardoserio/accelera-skills/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-e461ccc7db88e98c2a26c40a0672f2e1edbfe4f0","uid":"8d116692-0278-464c-979e-ab81d3e5aefd"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/leonardoserio/accelera-skills/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/leonardoserio/accelera-skills/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/leonardoserio/accelera-skills/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.412431+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('165fd037-6ebf-4195-9352-6ad5a94884ce', 'location:default/generated-e67fab63afdcd722173e912706fe624b9df62c34', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-e67fab63afdcd722173e912706fe624b9df62c34","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/devmarcelo/openclaw-setup/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-e67fab63afdcd722173e912706fe624b9df62c34","uid":"165fd037-6ebf-4195-9352-6ad5a94884ce"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/devmarcelo/openclaw-setup/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/devmarcelo/openclaw-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/devmarcelo/openclaw-setup/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.441871+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('7d02e7b7-48b7-43fd-abe6-5650785ed3de', 'component:default/python-demo-app', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"python-demo-app","title":"Python 3.12 Flask Microservice","description":"App Web em Python 3.12 (Flask) com Prometheus metrics, logs JSON para Grafana Loki, SonarQube Quality Gate, GitOps via ArgoCD e HTTPS via AWS ACM.","annotations":{"backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"python-demo-app","grafana/tag-selector":"service:python-demo-app","grafana/overview-dashboard":"http://grafana.799416476486.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12","argocd/app-name":"python-app","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml"},"tags":["python","flask","sonarqube","prometheus","fluentd","loki","grafana","k8s","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app","title":"GitHub Source Code","icon":"github"},{"url":"http://python.799416476486.realhandsonlabs.net","title":"Python 3.12 Live App (HTTP)","icon":"web"},{"url":"https://python.799416476486.realhandsonlabs.net","title":"Python 3.12 Live App (HTTPS ACM)","icon":"lock"},{"url":"http://python.799416476486.realhandsonlabs.net/metrics","title":"Prometheus Metrics (/metrics)","icon":"gauge"},{"url":"http://grafana.799416476486.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12","title":"Grafana Dashboard (Golden Signals & Loki Logs)","icon":"dashboard"},{"url":"http://sonarqube.799416476486.realhandsonlabs.net/dashboard?id=apps-demo-2026","title":"SonarQube Quality Gate","icon":"check"},{"url":"https://argocd.799416476486.realhandsonlabs.net/applications/python-app","title":"ArgoCD GitOps","icon":"sync"}]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","providesApis":["python-app-api"],"dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"python-demo-app","grafana/tag-selector":"service:python-demo-app","grafana/overview-dashboard":"http://grafana.799416476486.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12","argocd/app-name":"python-app"},"name":"python-demo-app","title":"Python 3.12 Flask Microservice","description":"App Web em Python 3.12 (Flask) com Prometheus metrics, logs JSON para Grafana Loki, SonarQube Quality Gate, GitOps via ArgoCD e HTTPS via AWS ACM.","tags":["python","flask","sonarqube","prometheus","fluentd","loki","grafana","k8s","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app","title":"GitHub Source Code","icon":"github"},{"url":"http://python.799416476486.realhandsonlabs.net","title":"Python 3.12 Live App (HTTP)","icon":"web"},{"url":"https://python.799416476486.realhandsonlabs.net","title":"Python 3.12 Live App (HTTPS ACM)","icon":"lock"},{"url":"http://python.799416476486.realhandsonlabs.net/metrics","title":"Prometheus Metrics (/metrics)","icon":"gauge"},{"url":"http://grafana.799416476486.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12","title":"Grafana Dashboard (Golden Signals & Loki Logs)","icon":"dashboard"},{"url":"http://sonarqube.799416476486.realhandsonlabs.net/dashboard?id=apps-demo-2026","title":"SonarQube Quality Gate","icon":"check"},{"url":"https://argocd.799416476486.realhandsonlabs.net/applications/python-app","title":"ArgoCD GitOps","icon":"sync"}],"uid":"7d02e7b7-48b7-43fd-abe6-5650785ed3de"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","providesApis":["python-app-api"],"dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-02 01:50:47.192782+00', '2026-11-02 01:49:03.406073+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('7056b87f-a004-4d97-8343-edf21f81730c', 'location:default/generated-fe0f1bf72ec2879f9e6e9673b75d2a1f020b3878', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-fe0f1bf72ec2879f9e6e9673b75d2a1f020b3878","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/a360-business/galeed-community/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-fe0f1bf72ec2879f9e6e9673b75d2a1f020b3878","uid":"7056b87f-a004-4d97-8343-edf21f81730c"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/galeed-community/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:45.191348+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('49c5d45a-10ac-4e69-86a6-abe8514e289e', 'location:default/generated-6bcefc9bd5af69ed0137a6ce0836fe36e0fef7f2', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-6bcefc9bd5af69ed0137a6ce0836fe36e0fef7f2","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/bs-tutelas-patentes-site/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-6bcefc9bd5af69ed0137a6ce0836fe36e0fef7f2","uid":"49c5d45a-10ac-4e69-86a6-abe8514e289e"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/bs-tutelas-patentes-site/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/bs-tutelas-patentes-site/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/bs-tutelas-patentes-site/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.191899+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'system:default/kube-demo-2026', '{"apiVersion":"backstage.io/v1alpha1","kind":"System","metadata":{"name":"kube-demo-2026","description":"AWS EKS 1.35 Platform, GitOps, Observability & Developer Portal","annotations":{"backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"owner":"platform-team"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"kube-demo-2026","description":"AWS EKS 1.35 Platform, GitOps, Observability & Developer Portal","uid":"c061cd8b-71b0-4ad0-8a8c-064863bb4cf0"},"apiVersion":"backstage.io/v1alpha1","kind":"System","spec":{"owner":"platform-team"}}', '{}', '[]', '2026-11-02 01:50:47.192782+00', '2026-11-02 01:49:03.24855+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('ba7da6b3-9a3d-45be-ad81-a803860e93ca', 'location:default/generated-c7cbc24b24c9bd1238a6138087c948db5f143a8a', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-c7cbc24b24c9bd1238a6138087c948db5f143a8a","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvajardim-crypto/mesa-site-institucional/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-c7cbc24b24c9bd1238a6138087c948db5f143a8a","uid":"ba7da6b3-9a3d-45be-ad81-a803860e93ca"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvajardim-crypto/mesa-site-institucional/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvajardim-crypto/mesa-site-institucional/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvajardim-crypto/mesa-site-institucional/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:45.191348+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'component:default/dotnet-csharp-demo-app', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"dotnet-csharp-demo-app","title":".NET 8 C# Minimal API Microservice","description":"App Web em C# (.NET 8 Minimal API) com Prometheus metrics, logs JSON para Grafana Loki, SonarQube Quality Gate, GitOps via ArgoCD e HTTPS via AWS ACM.","annotations":{"backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"dotnet-csharp-demo-app","grafana/tag-selector":"service:dotnet-csharp-demo-app","grafana/overview-dashboard":"http://grafana.799416476486.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe","argocd/app-name":"dotnet-csharp-app","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml"},"tags":["dotnet","csharp","sonarqube","prometheus","fluentd","loki","grafana","k8s","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app","title":"GitHub Source Code","icon":"github"},{"url":"http://dotnet.799416476486.realhandsonlabs.net","title":".NET 8 C# Live App (HTTP)","icon":"web"},{"url":"https://dotnet.799416476486.realhandsonlabs.net","title":".NET 8 C# Live App (HTTPS ACM)","icon":"lock"},{"url":"http://dotnet.799416476486.realhandsonlabs.net/metrics","title":"Prometheus Metrics (/metrics)","icon":"gauge"},{"url":"http://grafana.799416476486.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe","title":"Grafana Dashboard (Golden Signals & Loki Logs)","icon":"dashboard"},{"url":"http://sonarqube.799416476486.realhandsonlabs.net/dashboard?id=apps-demo-2026","title":"SonarQube Quality Gate","icon":"check"},{"url":"https://argocd.799416476486.realhandsonlabs.net/applications/dotnet-csharp-app","title":"ArgoCD GitOps","icon":"sync"}]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","providesApis":["dotnet-csharp-app-api"],"dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"dotnet-csharp-demo-app","grafana/tag-selector":"service:dotnet-csharp-demo-app","grafana/overview-dashboard":"http://grafana.799416476486.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe","argocd/app-name":"dotnet-csharp-app"},"name":"dotnet-csharp-demo-app","title":".NET 8 C# Minimal API Microservice","description":"App Web em C# (.NET 8 Minimal API) com Prometheus metrics, logs JSON para Grafana Loki, SonarQube Quality Gate, GitOps via ArgoCD e HTTPS via AWS ACM.","tags":["dotnet","csharp","sonarqube","prometheus","fluentd","loki","grafana","k8s","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app","title":"GitHub Source Code","icon":"github"},{"url":"http://dotnet.799416476486.realhandsonlabs.net","title":".NET 8 C# Live App (HTTP)","icon":"web"},{"url":"https://dotnet.799416476486.realhandsonlabs.net","title":".NET 8 C# Live App (HTTPS ACM)","icon":"lock"},{"url":"http://dotnet.799416476486.realhandsonlabs.net/metrics","title":"Prometheus Metrics (/metrics)","icon":"gauge"},{"url":"http://grafana.799416476486.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe","title":"Grafana Dashboard (Golden Signals & Loki Logs)","icon":"dashboard"},{"url":"http://sonarqube.799416476486.realhandsonlabs.net/dashboard?id=apps-demo-2026","title":"SonarQube Quality Gate","icon":"check"},{"url":"https://argocd.799416476486.realhandsonlabs.net/applications/dotnet-csharp-app","title":"ArgoCD GitOps","icon":"sync"}],"uid":"6fed0b98-a145-41ce-a88f-be349334888d"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","providesApis":["dotnet-csharp-app-api"],"dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-02 01:50:47.327728+00', '2026-11-02 01:49:03.378282+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('3fe9e6d5-e48d-4859-825a-24b08ccd4ceb', 'location:default/generated-796712c88a485ec71e012b5c5f4566412a5f5672', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-796712c88a485ec71e012b5c5f4566412a5f5672","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/a360-business/growth-os-skills-full/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-796712c88a485ec71e012b5c5f4566412a5f5672","uid":"3fe9e6d5-e48d-4859-825a-24b08ccd4ceb"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/growth-os-skills-full/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/growth-os-skills-full/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/growth-os-skills-full/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:45.191348+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('03fa39dd-9139-4384-ac01-2f4bfaf3d4dd', 'location:default/generated-39540a08be0bcb5645ee1d683b08d860953c5b44', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-39540a08be0bcb5645ee1d683b08d860953c5b44","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/scripts1/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-39540a08be0bcb5645ee1d683b08d860953c5b44","uid":"03fa39dd-9139-4384-ac01-2f4bfaf3d4dd"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/scripts1/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/scripts1/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/scripts1/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:45.191348+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('b3095b41-0888-4c27-84f0-00bdceb205fe', 'location:default/generated-aea2074c195831a31fb8d1acdfcfd9ae7d08cd1b', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-aea2074c195831a31fb8d1acdfcfd9ae7d08cd1b","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/bot-dermatologia-mattos/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-aea2074c195831a31fb8d1acdfcfd9ae7d08cd1b","uid":"b3095b41-0888-4c27-84f0-00bdceb205fe"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/bot-dermatologia-mattos/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/bot-dermatologia-mattos/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/bot-dermatologia-mattos/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.191899+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('d21a25a7-d0b8-488a-9667-b473754b703d', 'location:default/generated-73a2399a7c2024519f325ee2a4e98268e82758b7', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-73a2399a7c2024519f325ee2a4e98268e82758b7","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/floci-localstack-aws/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-73a2399a7c2024519f325ee2a4e98268e82758b7","uid":"d21a25a7-d0b8-488a-9667-b473754b703d"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/floci-localstack-aws/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/floci-localstack-aws/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/floci-localstack-aws/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.191899+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('08a67f6a-55b9-4f17-9a6d-008303c617be', 'location:default/generated-d2a36c4260a85053ce94fbe9c674187459d272db', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-d2a36c4260a85053ce94fbe9c674187459d272db","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/arthurecio/openclaw-setup/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-d2a36c4260a85053ce94fbe9c674187459d272db","uid":"08a67f6a-55b9-4f17-9a6d-008303c617be"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/arthurecio/openclaw-setup/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/arthurecio/openclaw-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/arthurecio/openclaw-setup/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.441871+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('a719699d-987b-4b60-90cd-1379aa96a91f', 'location:default/generated-bcfe70fc389b7b6f55a5728ad12e48fbb12a7627', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-bcfe70fc389b7b6f55a5728ad12e48fbb12a7627","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/zoeiroka-automacoes/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-bcfe70fc389b7b6f55a5728ad12e48fbb12a7627","uid":"a719699d-987b-4b60-90cd-1379aa96a91f"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/zoeiroka-automacoes/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/zoeiroka-automacoes/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/zoeiroka-automacoes/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.412431+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('b5678983-efe6-44d7-9c0d-3046066c1687', 'location:default/generated-3a49cafceb0ae80411060ab243ac7adf4cb8101e', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-3a49cafceb0ae80411060ab243ac7adf4cb8101e","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-3a49cafceb0ae80411060ab243ac7adf4cb8101e","uid":"b5678983-efe6-44d7-9c0d-3046066c1687"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/backstage-infra/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/backstage-infra/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.441871+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'component:default/sonarqube', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"sonarqube","description":"SonarQube QA & Security Scanner on EKS (OWASP Dependency-Check, FindSecBugs & YAML/K8s Security plugins)","annotations":{"backstage.io/kubernetes-id":"sonarqube","backstage.io/kubernetes-namespace":"sonarqube","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"sonarqube","backstage.io/kubernetes-namespace":"sonarqube"},"name":"sonarqube","description":"SonarQube QA & Security Scanner on EKS (OWASP Dependency-Check, FindSecBugs & YAML/K8s Security plugins)","uid":"6cf1741d-cc32-41d6-83f5-2e02fe66c637"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-02 01:50:47.192782+00', '2026-11-02 01:49:03.24855+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'component:default/samba-ad-dc', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"samba-ad-dc","description":"Samba 4 Active Directory Multi-DC (DC1 Principal + DC2 Réplica em Multi-AZ com --dns-backend=NONE e Route 53 Private Hosted Zone)","annotations":{"github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/kubernetes-id":"samba-ad-dc","backstage.io/kubernetes-namespace":"default","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"},"tags":["samba4","active-directory","ldap","kerberos","route53"]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","providesApis":["ldap-ad-api"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/","github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/kubernetes-id":"samba-ad-dc","backstage.io/kubernetes-namespace":"default"},"name":"samba-ad-dc","description":"Samba 4 Active Directory Multi-DC (DC1 Principal + DC2 Réplica em Multi-AZ com --dns-backend=NONE e Route 53 Private Hosted Zone)","tags":["samba4","active-directory","ldap","kerberos","route53"],"uid":"d8aa8894-4fe0-436a-99c1-3ee2c3439e11"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","providesApis":["ldap-ad-api"]}}', '{}', '[]', '2026-11-02 01:50:47.305595+00', '2026-11-02 01:49:03.443007+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('ef7b0d9e-99e7-4c48-8994-f7df1b118282', 'location:default/generated-1f8726637b31d8323de2ea178b5ccd8c303f90fa', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-1f8726637b31d8323de2ea178b5ccd8c303f90fa","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/mesa-agents/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-1f8726637b31d8323de2ea178b5ccd8c303f90fa","uid":"ef7b0d9e-99e7-4c48-8994-f7df1b118282"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/mesa-agents/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/mesa-agents/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/mesa-agents/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.412431+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('ef9ade31-8eb3-4c84-8de0-28f715ca82c0', 'location:default/generated-b44b1f6c085e8ca890654a6f6755902d78d4c46b', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-b44b1f6c085e8ca890654a6f6755902d78d4c46b","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/vini-brito/growth-os-skills-full/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-b44b1f6c085e8ca890654a6f6755902d78d4c46b","uid":"ef9ade31-8eb3-4c84-8de0-28f715ca82c0"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/vini-brito/growth-os-skills-full/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/vini-brito/growth-os-skills-full/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/vini-brito/growth-os-skills-full/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-02 01:50:46.441871+00', '2026-11-02 01:49:03.914366+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'component:default/backstage-portal', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"backstage-portal","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","annotations":{"backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"website","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage"},"name":"backstage-portal","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","uid":"5d61d659-a82b-47c2-b6a1-949fd04b6f27"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"website","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-02 01:50:47.305595+00', '2026-11-02 01:49:03.24855+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'api:default/dotnet-csharp-app-api', '{"apiVersion":"backstage.io/v1alpha1","kind":"API","metadata":{"name":"dotnet-csharp-app-api","title":".NET 8 C# Minimal API REST API","description":"Interface REST para consulta de status, saúde e telemetria da aplicação C# .NET 8","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml"}},"spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","definition":"openapi: \"3.0.0\"\ninfo:\n  title: .NET 8 C# Minimal API\n  version: \"1.0.0\"\npaths:\n  /:\n    get:\n      summary: Overview & HTML Dashboard\n      responses:\n        ''200'':\n          description: OK\n  /api/info:\n    get:\n      summary: System & client runtime information\n      responses:\n        ''200'':\n          description: OK\n  /healthz:\n    get:\n      summary: Liveness probe\n      responses:\n        ''200'':\n          description: OK\n  /ready:\n    get:\n      summary: Readiness probe\n      responses:\n        ''200'':\n          description: OK\n  /metrics:\n    get:\n      summary: Prometheus metrics\n      responses:\n        ''200'':\n          description: OK\n"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/"},"name":"dotnet-csharp-app-api","title":".NET 8 C# Minimal API REST API","description":"Interface REST para consulta de status, saúde e telemetria da aplicação C# .NET 8","uid":"63db9a4c-47aa-4c58-a818-dc552e7dd313"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","definition":"openapi: \"3.0.0\"\ninfo:\n  title: .NET 8 C# Minimal API\n  version: \"1.0.0\"\npaths:\n  /:\n    get:\n      summary: Overview & HTML Dashboard\n      responses:\n        ''200'':\n          description: OK\n  /api/info:\n    get:\n      summary: System & client runtime information\n      responses:\n        ''200'':\n          description: OK\n  /healthz:\n    get:\n      summary: Liveness probe\n      responses:\n        ''200'':\n          description: OK\n  /ready:\n    get:\n      summary: Readiness probe\n      responses:\n        ''200'':\n          description: OK\n  /metrics:\n    get:\n      summary: Prometheus metrics\n      responses:\n        ''200'':\n          description: OK\n"}}', '{}', '[]', '2026-11-02 01:50:47.192782+00', '2026-11-02 01:49:03.378282+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'template:default/nodejs-sonarqube-cicd-template', '{"apiVersion":"backstage.io/v1beta2","kind":"Template","metadata":{"name":"nodejs-sonarqube-cicd-template","title":"Node.js 20 Web App + CI/CD with SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Node.js 20 microservice repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki JSON logs, and Backstage manifest.","tags":["node","nodejs","javascript","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml"}},"spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"nodejs-app-demo"},"description":{"title":"Description","type":"string","description":"What does this Node.js microservice do?","default":"Node.js 20 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"nodejs-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/"},"name":"nodejs-sonarqube-cicd-template","title":"Node.js 20 Web App + CI/CD with SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Node.js 20 microservice repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki JSON logs, and Backstage manifest.","tags":["node","nodejs","javascript","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"f4433dbe-aa69-4603-840e-2c2f82ce17c0"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"nodejs-app-demo"},"description":{"title":"Description","type":"string","description":"What does this Node.js microservice do?","default":"Node.js 20 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"nodejs-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{}', '[]', '2026-11-02 01:50:47.384886+00', '2026-11-02 01:49:03.62485+00', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'group:default/platform-team', '{"apiVersion":"backstage.io/v1alpha1","kind":"Group","metadata":{"name":"platform-team","description":"Platform Engineering & DevEx Team","annotations":{"backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"team","children":[],"members":["guest"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"platform-team","description":"Platform Engineering & DevEx Team","uid":"c6bce8e1-4852-4234-aee5-38f6e029b95f"},"apiVersion":"backstage.io/v1alpha1","kind":"Group","spec":{"type":"team","children":[],"members":["guest"]}}', '{}', '[]', '2026-11-02 01:50:47.327728+00', '2026-11-02 01:49:03.24855+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'api:default/oidc-idp-api', '{"apiVersion":"backstage.io/v1alpha1","kind":"API","metadata":{"name":"oidc-idp-api","description":"Endpoint OpenID Connect (OIDC) Discovery do Keycloak (sso.empresa.local)","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"}},"spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Keycloak OIDC Discovery API\n  version: \"1.0.0\"\npaths:\n  /realms/empresa/.well-known/openid-configuration:\n    get:\n      summary: Retorna a configuracao OIDC do Realm empresa\n      responses:\n        \"200\":\n          description: OIDC Discovery JSON\n"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"oidc-idp-api","description":"Endpoint OpenID Connect (OIDC) Discovery do Keycloak (sso.empresa.local)","uid":"f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Keycloak OIDC Discovery API\n  version: \"1.0.0\"\npaths:\n  /realms/empresa/.well-known/openid-configuration:\n    get:\n      summary: Retorna a configuracao OIDC do Realm empresa\n      responses:\n        \"200\":\n          description: OIDC Discovery JSON\n"}}', '{}', '[]', '2026-11-02 01:50:47.327728+00', '2026-11-02 01:49:03.443007+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'api:default/python-app-api', '{"apiVersion":"backstage.io/v1alpha1","kind":"API","metadata":{"name":"python-app-api","title":"Python Flask App REST API","description":"Interface REST para consulta de status, saúde e telemetria da aplicação Python","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml"}},"spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Python App API\n  version: \"1.0.0\"\npaths:\n  /:\n    get:\n      summary: Overview & HTML Dashboard\n      responses:\n        ''200'':\n          description: OK\n  /api/info:\n    get:\n      summary: System & client runtime information\n      responses:\n        ''200'':\n          description: OK\n  /healthz:\n    get:\n      summary: Liveness probe\n      responses:\n        ''200'':\n          description: OK\n  /ready:\n    get:\n      summary: Readiness probe\n      responses:\n        ''200'':\n          description: OK\n  /metrics:\n    get:\n      summary: Prometheus metrics\n      responses:\n        ''200'':\n          description: OK\n"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/"},"name":"python-app-api","title":"Python Flask App REST API","description":"Interface REST para consulta de status, saúde e telemetria da aplicação Python","uid":"091b50f1-ebf5-4713-8048-9ad7b9d59968"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Python App API\n  version: \"1.0.0\"\npaths:\n  /:\n    get:\n      summary: Overview & HTML Dashboard\n      responses:\n        ''200'':\n          description: OK\n  /api/info:\n    get:\n      summary: System & client runtime information\n      responses:\n        ''200'':\n          description: OK\n  /healthz:\n    get:\n      summary: Liveness probe\n      responses:\n        ''200'':\n          description: OK\n  /ready:\n    get:\n      summary: Readiness probe\n      responses:\n        ''200'':\n          description: OK\n  /metrics:\n    get:\n      summary: Prometheus metrics\n      responses:\n        ''200'':\n          description: OK\n"}}', '{}', '[]', '2026-11-02 01:50:47.192782+00', '2026-11-02 01:49:03.406073+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'system:default/samba-ad-keycloak-iam', '{"apiVersion":"backstage.io/v1alpha1","kind":"System","metadata":{"name":"samba-ad-keycloak-iam","description":"Arquitetura Corporativa IAM na VPC do EKS (Samba 4 AD Multi-DC sem DNS interno + Route 53 Private Zone + FreeRADIUS MFA + Keycloak SAML 2.0 / OIDC)","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"}},"spec":{"owner":"platform-team"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"samba-ad-keycloak-iam","description":"Arquitetura Corporativa IAM na VPC do EKS (Samba 4 AD Multi-DC sem DNS interno + Route 53 Private Zone + FreeRADIUS MFA + Keycloak SAML 2.0 / OIDC)","uid":"2a9beea9-e004-4fd5-8dda-11f2c52f5f07"},"apiVersion":"backstage.io/v1alpha1","kind":"System","spec":{"owner":"platform-team"}}', '{}', '[]', '2026-11-02 01:50:47.327728+00', '2026-11-02 01:49:03.443007+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'template:default/dotnet-sonarqube-cicd-template', '{"apiVersion":"backstage.io/v1beta2","kind":"Template","metadata":{"name":"dotnet-sonarqube-cicd-template","title":".NET 8 C# Web App + CI/CD with QA, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete .NET 8 C# Minimal API repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki logging, and Backstage manifest.","tags":["dotnet","csharp","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml"}},"spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"dotnet-csharp-app-demo"},"description":{"title":"Description","type":"string","description":"What does this microservice do?","default":".NET 8 C# microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"dotnet-csharp-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/"},"name":"dotnet-sonarqube-cicd-template","title":".NET 8 C# Web App + CI/CD with QA, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete .NET 8 C# Minimal API repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki logging, and Backstage manifest.","tags":["dotnet","csharp","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"bd2f3497-ed87-4202-a8a4-4613a3b58f78"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"dotnet-csharp-app-demo"},"description":{"title":"Description","type":"string","description":"What does this microservice do?","default":".NET 8 C# microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"dotnet-csharp-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{}', '[]', '2026-11-02 01:50:47.384886+00', '2026-11-02 01:49:03.625349+00', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'system:default/apps-demo-2026', '{"apiVersion":"backstage.io/v1alpha1","kind":"System","metadata":{"name":"apps-demo-2026","title":"Apps Demo 2026 Ecosystem","description":"Microservices Demo Collection (Python 3.12 Flask, .NET 8 C# Minimal API) with CI/CD, SonarQube, Prometheus Metrics, Fluentd/Loki Logs, GitOps via ArgoCD and HTTPS via AWS ACM.","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml"}},"spec":{"owner":"platform-team"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/"},"name":"apps-demo-2026","title":"Apps Demo 2026 Ecosystem","description":"Microservices Demo Collection (Python 3.12 Flask, .NET 8 C# Minimal API) with CI/CD, SonarQube, Prometheus Metrics, Fluentd/Loki Logs, GitOps via ArgoCD and HTTPS via AWS ACM.","uid":"34c740af-8954-42f2-8520-94448a3ea8cd"},"apiVersion":"backstage.io/v1alpha1","kind":"System","spec":{"owner":"platform-team"}}', '{}', '[]', '2026-11-02 01:50:47.4234+00', '2026-11-02 01:49:04.349533+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'template:default/python-sonarqube-cicd-template', '{"apiVersion":"backstage.io/v1beta2","kind":"Template","metadata":{"name":"python-sonarqube-cicd-template","title":"Python 3.12 Web App + CI/CD with QA, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Python (Flask + Gunicorn) repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki logging, and Backstage manifest.","tags":["python","flask","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml"}},"spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"python-app-demo"},"description":{"title":"Description","type":"string","description":"What does this microservice do?","default":"Python microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"python-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/"},"name":"python-sonarqube-cicd-template","title":"Python 3.12 Web App + CI/CD with QA, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Python (Flask + Gunicorn) repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki logging, and Backstage manifest.","tags":["python","flask","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"e7ce2e2c-1a65-412c-92af-958b480db2a9"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"python-app-demo"},"description":{"title":"Description","type":"string","description":"What does this microservice do?","default":"Python microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"python-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{}', '[]', '2026-11-02 01:50:47.305595+00', '2026-11-02 01:49:03.65718+00', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('59bcae1b-0310-4bf1-9216-1cc4fc975884', 'component:default/keycloak-sso', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"keycloak-sso","description":"Servidor Keycloak IAM (Broker SAML 2.0, OAuth2 e OIDC) federado via LDAP ao Samba 4 AD para autenticar Backstage, ArgoCD, Grafana e Apps Demo","annotations":{"github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/kubernetes-id":"keycloak-sso","backstage.io/kubernetes-namespace":"default","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"},"tags":["keycloak","saml2","oidc","sso","mfa"]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","dependsOn":["component:default/samba-ad-dc","component:default/freeradius-mfa"],"providesApis":["saml-idp-api","oidc-idp-api"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/","github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/kubernetes-id":"keycloak-sso","backstage.io/kubernetes-namespace":"default"},"name":"keycloak-sso","description":"Servidor Keycloak IAM (Broker SAML 2.0, OAuth2 e OIDC) federado via LDAP ao Samba 4 AD para autenticar Backstage, ArgoCD, Grafana e Apps Demo","tags":["keycloak","saml2","oidc","sso","mfa"],"uid":"59bcae1b-0310-4bf1-9216-1cc4fc975884"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","dependsOn":["component:default/samba-ad-dc","component:default/freeradius-mfa"],"providesApis":["saml-idp-api","oidc-idp-api"]}}', '{}', '[]', '2026-11-02 01:50:47.305595+00', '2026-11-02 01:49:03.443007+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'template:default/standard-microservice-template', '{"apiVersion":"backstage.io/v1beta2","kind":"Template","metadata":{"name":"standard-microservice-template","title":"Standard Microservice with CI/CD, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a ready-to-use repository with a test pipeline, SonarQube Quality Gate validation, Prometheus metrics, Fluentd/Loki logging, and Backstage manifest.","tags":["node","python","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml"}},"spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$"},"description":{"title":"Description","type":"string","description":"What does this microservice do?"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"microservice-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/microservice-template/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/"},"name":"standard-microservice-template","title":"Standard Microservice with CI/CD, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a ready-to-use repository with a test pipeline, SonarQube Quality Gate validation, Prometheus metrics, Fluentd/Loki logging, and Backstage manifest.","tags":["node","python","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"270eff48-d8a7-4539-8bcc-c5aadd2103fb"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$"},"description":{"title":"Description","type":"string","description":"What does this microservice do?"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"microservice-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"${{ parameters.component_id }}","description":"${{ parameters.description }}","owner":"${{ parameters.owner }}","system":"${{ parameters.system }}","destinationOwner":"${{ parameters.destinationOwner }}"}}},{"id":"publish-git","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"${{ parameters.description }}","repoUrl":"github.com?owner=${{ parameters.destinationOwner }}&repo=${{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register-catalog","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"${{ steps[''publish-git''].output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"${{ steps[''publish-git''].output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"${{ steps[''register-catalog''].output.entityRef }}"}]}}}', '{}', '[]', '2026-11-02 01:50:47.305595+00', '2026-11-02 01:49:03.556875+00', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml');
INSERT INTO public.refresh_state VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'component:default/freeradius-mfa', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"freeradius-mfa","description":"Servidor FreeRADIUS + PAM Google Authenticator (TOTP MFA) integrado ao Samba 4 AD para autenticação geral e MFA na VPC do EKS","annotations":{"github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/kubernetes-id":"freeradius-mfa","backstage.io/kubernetes-namespace":"default","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"},"tags":["radius","freeradius","mfa","totp"]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","dependsOn":["component:default/samba-ad-dc"],"providesApis":["radius-mfa-api"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/","github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/kubernetes-id":"freeradius-mfa","backstage.io/kubernetes-namespace":"default"},"name":"freeradius-mfa","description":"Servidor FreeRADIUS + PAM Google Authenticator (TOTP MFA) integrado ao Samba 4 AD para autenticação geral e MFA na VPC do EKS","tags":["radius","freeradius","mfa","totp"],"uid":"78aca34d-c7ad-4316-9d74-afd733e893a3"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","dependsOn":["component:default/samba-ad-dc"],"providesApis":["radius-mfa-api"]}}', '{}', '[]', '2026-11-02 01:50:47.384886+00', '2026-11-02 01:49:03.443007+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');


--
-- Data for Name: refresh_state_references; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.refresh_state_references VALUES (752, 'ConfigLocationProvider', NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec');
INSERT INTO public.refresh_state_references VALUES (753, 'ConfigLocationProvider', NULL, 'location:default/generated-64bf0f42f04286e509e88978a740e76f33a6cc2a');
INSERT INTO public.refresh_state_references VALUES (754, 'ConfigLocationProvider', NULL, 'location:default/generated-b4f29ca1863623b0dea4276cfa3970b897899c36');
INSERT INTO public.refresh_state_references VALUES (755, 'ConfigLocationProvider', NULL, 'location:default/generated-7692b664b197d2303b0a28bb177c1b133773311c');
INSERT INTO public.refresh_state_references VALUES (756, 'ConfigLocationProvider', NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2');
INSERT INTO public.refresh_state_references VALUES (757, 'ConfigLocationProvider', NULL, 'location:default/generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98');
INSERT INTO public.refresh_state_references VALUES (758, 'ConfigLocationProvider', NULL, 'location:default/generated-689c18882dc297803e1a420c73b8783d094c8e17');
INSERT INTO public.refresh_state_references VALUES (759, 'ConfigLocationProvider', NULL, 'location:default/generated-e1e842392fd0da6efe989d25722f835228d60e05');
INSERT INTO public.refresh_state_references VALUES (1400, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'user:default/guest');
INSERT INTO public.refresh_state_references VALUES (1401, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'group:default/platform-team');
INSERT INTO public.refresh_state_references VALUES (1402, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'system:default/kube-demo-2026');
INSERT INTO public.refresh_state_references VALUES (1403, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'resource:default/kube-demo-eks');
INSERT INTO public.refresh_state_references VALUES (1404, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'component:default/backstage-portal');
INSERT INTO public.refresh_state_references VALUES (1405, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'component:default/argocd');
INSERT INTO public.refresh_state_references VALUES (1406, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'component:default/grafana');
INSERT INTO public.refresh_state_references VALUES (1407, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'component:default/prometheus');
INSERT INTO public.refresh_state_references VALUES (1408, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'component:default/sonarqube');
INSERT INTO public.refresh_state_references VALUES (760, 'ConfigLocationProvider', NULL, 'location:default/generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a');
INSERT INTO public.refresh_state_references VALUES (761, 'ConfigLocationProvider', NULL, 'location:default/generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce');
INSERT INTO public.refresh_state_references VALUES (1409, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'component:default/grafana');
INSERT INTO public.refresh_state_references VALUES (1410, NULL, 'location:default/generated-7692b664b197d2303b0a28bb177c1b133773311c', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.refresh_state_references VALUES (1411, NULL, 'location:default/generated-7692b664b197d2303b0a28bb177c1b133773311c', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.refresh_state_references VALUES (1412, NULL, 'location:default/generated-b4f29ca1863623b0dea4276cfa3970b897899c36', 'component:default/python-demo-app');
INSERT INTO public.refresh_state_references VALUES (1413, NULL, 'location:default/generated-b4f29ca1863623b0dea4276cfa3970b897899c36', 'api:default/python-app-api');
INSERT INTO public.refresh_state_references VALUES (1415, NULL, 'location:default/generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98', 'template:default/standard-microservice-template');
INSERT INTO public.refresh_state_references VALUES (1418, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.refresh_state_references VALUES (1420, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'component:default/samba-ad-dc');
INSERT INTO public.refresh_state_references VALUES (1421, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'component:default/freeradius-mfa');
INSERT INTO public.refresh_state_references VALUES (1422, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'component:default/keycloak-sso');
INSERT INTO public.refresh_state_references VALUES (1419, NULL, 'location:default/generated-689c18882dc297803e1a420c73b8783d094c8e17', 'template:default/python-sonarqube-cicd-template');
INSERT INTO public.refresh_state_references VALUES (1423, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'api:default/saml-idp-api');
INSERT INTO public.refresh_state_references VALUES (1424, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'api:default/oidc-idp-api');
INSERT INTO public.refresh_state_references VALUES (1425, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'api:default/ldap-ad-api');
INSERT INTO public.refresh_state_references VALUES (1426, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'api:default/radius-mfa-api');
INSERT INTO public.refresh_state_references VALUES (1455, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-d2a36c4260a85053ce94fbe9c674187459d272db');
INSERT INTO public.refresh_state_references VALUES (1456, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-3a49cafceb0ae80411060ab243ac7adf4cb8101e');
INSERT INTO public.refresh_state_references VALUES (1457, NULL, 'location:default/generated-64bf0f42f04286e509e88978a740e76f33a6cc2a', 'system:default/apps-demo-2026');
INSERT INTO public.refresh_state_references VALUES (1414, NULL, 'location:default/generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a', 'template:default/jvm-springboot-sonarqube-cicd-template');
INSERT INTO public.refresh_state_references VALUES (1416, NULL, 'location:default/generated-e1e842392fd0da6efe989d25722f835228d60e05', 'template:default/dotnet-sonarqube-cicd-template');
INSERT INTO public.refresh_state_references VALUES (1417, NULL, 'location:default/generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce', 'template:default/nodejs-sonarqube-cicd-template');
INSERT INTO public.refresh_state_references VALUES (1427, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-78a0f16f4da15640f067c17fea7b0935483fd142');
INSERT INTO public.refresh_state_references VALUES (1428, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-edb107c0bf74b8a4c4c763787b54180b9801f99b');
INSERT INTO public.refresh_state_references VALUES (1429, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-bd14bea673b37261e7a74bd04975480bb069f8bc');
INSERT INTO public.refresh_state_references VALUES (1430, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-796712c88a485ec71e012b5c5f4566412a5f5672');
INSERT INTO public.refresh_state_references VALUES (1431, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-fe0f1bf72ec2879f9e6e9673b75d2a1f020b3878');
INSERT INTO public.refresh_state_references VALUES (1432, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-6e615a027feacec08857bccd2c90fef1db2a2372');
INSERT INTO public.refresh_state_references VALUES (1433, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-03b13b5fb17fe9a670e36e235ad81fd06fcfd666');
INSERT INTO public.refresh_state_references VALUES (1434, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-e40d9e847bb90a7610522a0d467185a8e079bb3e');
INSERT INTO public.refresh_state_references VALUES (1435, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-c7cbc24b24c9bd1238a6138087c948db5f143a8a');
INSERT INTO public.refresh_state_references VALUES (1436, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-39540a08be0bcb5645ee1d683b08d860953c5b44');
INSERT INTO public.refresh_state_references VALUES (1437, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-e461ccc7db88e98c2a26c40a0672f2e1edbfe4f0');
INSERT INTO public.refresh_state_references VALUES (1438, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-31a0877ed2bec2edf4feee46dd4161a60585d1ce');
INSERT INTO public.refresh_state_references VALUES (1439, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-023ff0c2d516eb7ee170b46c23edf162e464605b');
INSERT INTO public.refresh_state_references VALUES (1440, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-1f8726637b31d8323de2ea178b5ccd8c303f90fa');
INSERT INTO public.refresh_state_references VALUES (1441, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-bcfe70fc389b7b6f55a5728ad12e48fbb12a7627');
INSERT INTO public.refresh_state_references VALUES (1442, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-c377ebbfb933b0a54dfd0e158734712e21979bde');
INSERT INTO public.refresh_state_references VALUES (1443, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-6bcefc9bd5af69ed0137a6ce0836fe36e0fef7f2');
INSERT INTO public.refresh_state_references VALUES (1444, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-83f2543400bad694b3b4169b8f0dda74347f09ca');
INSERT INTO public.refresh_state_references VALUES (1445, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-d6eb614c9d4a9daaeb84a95d3fece1a6a0dd9916');
INSERT INTO public.refresh_state_references VALUES (1446, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-73a2399a7c2024519f325ee2a4e98268e82758b7');
INSERT INTO public.refresh_state_references VALUES (1447, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-d6c74b7d4667a209e2cd1841e6d838c0d7d20c98');
INSERT INTO public.refresh_state_references VALUES (1448, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-aea2074c195831a31fb8d1acdfcfd9ae7d08cd1b');
INSERT INTO public.refresh_state_references VALUES (1449, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-8f44ff1b0eee905e4f10b347f2f4cde12c6ecb91');
INSERT INTO public.refresh_state_references VALUES (1450, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-9a24efc486a6e189695017ff7d1ff5886f9498aa');
INSERT INTO public.refresh_state_references VALUES (1451, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-fa205f62d462a6f82aa4a1b49761425165444beb');
INSERT INTO public.refresh_state_references VALUES (1452, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-b44b1f6c085e8ca890654a6f6755902d78d4c46b');
INSERT INTO public.refresh_state_references VALUES (1453, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-1fa5db3a5d97294de3a94bed049e4c7133c78dca');
INSERT INTO public.refresh_state_references VALUES (1454, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-e67fab63afdcd722173e912706fe624b9df62c34');


--
-- Data for Name: relations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.relations VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'api:default/python-app-api', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'group:default/platform-team', 'ownerOf', 'api:default/python-app-api');
INSERT INTO public.relations VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'api:default/python-app-api', 'partOf', 'system:default/apps-demo-2026');
INSERT INTO public.relations VALUES ('091b50f1-ebf5-4713-8048-9ad7b9d59968', 'system:default/apps-demo-2026', 'hasPart', 'api:default/python-app-api');
INSERT INTO public.relations VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'component:default/sonarqube', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'group:default/platform-team', 'ownerOf', 'component:default/sonarqube');
INSERT INTO public.relations VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'component:default/sonarqube', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/sonarqube');
INSERT INTO public.relations VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'component:default/sonarqube', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('6cf1741d-cc32-41d6-83f5-2e02fe66c637', 'system:default/kube-demo-2026', 'hasPart', 'component:default/sonarqube');
INSERT INTO public.relations VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'component:default/backstage-portal', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'group:default/platform-team', 'ownerOf', 'component:default/backstage-portal');
INSERT INTO public.relations VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'component:default/backstage-portal', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/backstage-portal');
INSERT INTO public.relations VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'component:default/backstage-portal', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('5d61d659-a82b-47c2-b6a1-949fd04b6f27', 'system:default/kube-demo-2026', 'hasPart', 'component:default/backstage-portal');
INSERT INTO public.relations VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'group:default/platform-team', 'hasMember', 'user:default/guest');
INSERT INTO public.relations VALUES ('c6bce8e1-4852-4234-aee5-38f6e029b95f', 'user:default/guest', 'memberOf', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'api:default/saml-idp-api', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'group:default/platform-team', 'ownerOf', 'api:default/saml-idp-api');
INSERT INTO public.relations VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'api:default/saml-idp-api', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('40be89b0-5809-47dc-a88c-5053d2b38724', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'api:default/saml-idp-api');
INSERT INTO public.relations VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'api:default/ldap-ad-api', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'group:default/platform-team', 'ownerOf', 'api:default/ldap-ad-api');
INSERT INTO public.relations VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'api:default/ldap-ad-api', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('a47d058b-3461-44b2-9feb-97fec94b206f', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'api:default/ldap-ad-api');
INSERT INTO public.relations VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'component:default/grafana', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'group:default/platform-team', 'ownerOf', 'component:default/grafana');
INSERT INTO public.relations VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'component:default/grafana', 'dependsOn', 'component:default/prometheus-monitoring');
INSERT INTO public.relations VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'component:default/prometheus-monitoring', 'dependencyOf', 'component:default/grafana');
INSERT INTO public.relations VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'component:default/grafana', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/grafana');
INSERT INTO public.relations VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'component:default/grafana', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('e7874ba5-8387-43bb-82a2-588659c8f617', 'system:default/kube-demo-2026', 'hasPart', 'component:default/grafana');
INSERT INTO public.relations VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'component:default/dotnet-csharp-demo-app', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'group:default/platform-team', 'ownerOf', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.relations VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'component:default/dotnet-csharp-demo-app', 'providesApi', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.relations VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'api:default/dotnet-csharp-app-api', 'apiProvidedBy', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.relations VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'component:default/dotnet-csharp-demo-app', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.relations VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'component:default/dotnet-csharp-demo-app', 'partOf', 'system:default/apps-demo-2026');
INSERT INTO public.relations VALUES ('6fed0b98-a145-41ce-a88f-be349334888d', 'system:default/apps-demo-2026', 'hasPart', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.relations VALUES ('257e492a-1177-431b-b323-5689c6369907', 'api:default/radius-mfa-api', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('257e492a-1177-431b-b323-5689c6369907', 'group:default/platform-team', 'ownerOf', 'api:default/radius-mfa-api');
INSERT INTO public.relations VALUES ('257e492a-1177-431b-b323-5689c6369907', 'api:default/radius-mfa-api', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('257e492a-1177-431b-b323-5689c6369907', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'api:default/radius-mfa-api');
INSERT INTO public.relations VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'api:default/dotnet-csharp-app-api', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'group:default/platform-team', 'ownerOf', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.relations VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'api:default/dotnet-csharp-app-api', 'partOf', 'system:default/apps-demo-2026');
INSERT INTO public.relations VALUES ('63db9a4c-47aa-4c58-a818-dc552e7dd313', 'system:default/apps-demo-2026', 'hasPart', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.relations VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'template:default/standard-microservice-template', 'ownedBy', 'group:default/squad-plataforma');
INSERT INTO public.relations VALUES ('270eff48-d8a7-4539-8bcc-c5aadd2103fb', 'group:default/squad-plataforma', 'ownerOf', 'template:default/standard-microservice-template');
INSERT INTO public.relations VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'component:default/argocd', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'group:default/platform-team', 'ownerOf', 'component:default/argocd');
INSERT INTO public.relations VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'component:default/argocd', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/argocd');
INSERT INTO public.relations VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'component:default/argocd', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('a2837fe8-7139-43d3-9d5e-67166f32ade2', 'system:default/kube-demo-2026', 'hasPart', 'component:default/argocd');
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
INSERT INTO public.relations VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'system:default/apps-demo-2026', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('34c740af-8954-42f2-8520-94448a3ea8cd', 'group:default/platform-team', 'ownerOf', 'system:default/apps-demo-2026');
INSERT INTO public.relations VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'component:default/prometheus', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'group:default/platform-team', 'ownerOf', 'component:default/prometheus');
INSERT INTO public.relations VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'component:default/prometheus', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/prometheus');
INSERT INTO public.relations VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'component:default/prometheus', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('5d7e145e-f768-46d6-9fe9-64263ace073e', 'system:default/kube-demo-2026', 'hasPart', 'component:default/prometheus');
INSERT INTO public.relations VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'template:default/python-sonarqube-cicd-template', 'ownedBy', 'group:default/squad-plataforma');
INSERT INTO public.relations VALUES ('e7ce2e2c-1a65-412c-92af-958b480db2a9', 'group:default/squad-plataforma', 'ownerOf', 'template:default/python-sonarqube-cicd-template');
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
INSERT INTO public.relations VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'system:default/kube-demo-2026', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('c061cd8b-71b0-4ad0-8a8c-064863bb4cf0', 'group:default/platform-team', 'ownerOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'system:default/samba-ad-keycloak-iam', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('2a9beea9-e004-4fd5-8dda-11f2c52f5f07', 'group:default/platform-team', 'ownerOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'component:default/freeradius-mfa', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'group:default/platform-team', 'ownerOf', 'component:default/freeradius-mfa');
INSERT INTO public.relations VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'component:default/freeradius-mfa', 'providesApi', 'api:default/radius-mfa-api');
INSERT INTO public.relations VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'api:default/radius-mfa-api', 'apiProvidedBy', 'component:default/freeradius-mfa');
INSERT INTO public.relations VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'component:default/freeradius-mfa', 'dependsOn', 'component:default/samba-ad-dc');
INSERT INTO public.relations VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'component:default/samba-ad-dc', 'dependencyOf', 'component:default/freeradius-mfa');
INSERT INTO public.relations VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'component:default/freeradius-mfa', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('78aca34d-c7ad-4316-9d74-afd733e893a3', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'component:default/freeradius-mfa');
INSERT INTO public.relations VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', 'user:default/guest', 'memberOf', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('c594da02-5da3-463f-b953-c6b40ea03639', 'group:default/platform-team', 'hasMember', 'user:default/guest');
INSERT INTO public.relations VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'template:default/jvm-springboot-sonarqube-cicd-template', 'ownedBy', 'group:default/squad-plataforma');
INSERT INTO public.relations VALUES ('70145be8-a40e-4a5a-b0ce-25af2aeadd94', 'group:default/squad-plataforma', 'ownerOf', 'template:default/jvm-springboot-sonarqube-cicd-template');
INSERT INTO public.relations VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'template:default/dotnet-sonarqube-cicd-template', 'ownedBy', 'group:default/squad-plataforma');
INSERT INTO public.relations VALUES ('bd2f3497-ed87-4202-a8a4-4613a3b58f78', 'group:default/squad-plataforma', 'ownerOf', 'template:default/dotnet-sonarqube-cicd-template');
INSERT INTO public.relations VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'resource:default/kube-demo-eks', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'group:default/platform-team', 'ownerOf', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'resource:default/kube-demo-eks', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('bd7f67a9-56d3-4906-8ae7-e5a360c38903', 'system:default/kube-demo-2026', 'hasPart', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'component:default/samba-ad-dc', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'group:default/platform-team', 'ownerOf', 'component:default/samba-ad-dc');
INSERT INTO public.relations VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'component:default/samba-ad-dc', 'providesApi', 'api:default/ldap-ad-api');
INSERT INTO public.relations VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'api:default/ldap-ad-api', 'apiProvidedBy', 'component:default/samba-ad-dc');
INSERT INTO public.relations VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'component:default/samba-ad-dc', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('d8aa8894-4fe0-436a-99c1-3ee2c3439e11', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'component:default/samba-ad-dc');
INSERT INTO public.relations VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'template:default/nodejs-sonarqube-cicd-template', 'ownedBy', 'group:default/squad-plataforma');
INSERT INTO public.relations VALUES ('f4433dbe-aa69-4603-840e-2c2f82ce17c0', 'group:default/squad-plataforma', 'ownerOf', 'template:default/nodejs-sonarqube-cicd-template');


--
-- Data for Name: search; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'spec.type', 'url');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'spec.target', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'metadata.name', 'generated-e1e842392fd0da6efe989d25722f835228d60e05');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'metadata.uid', '0292df28-4efd-43fd-a9ee-52ece26b6185');
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
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'kind', 'location');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'spec.type', 'url');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'spec.target', 'https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'metadata.name', 'generated-64bf0f42f04286e509e88978a740e76f33a6cc2a');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'metadata.uid', 'b997bba0-79d4-45ab-9ba3-3b007e722a86');
INSERT INTO public.search VALUES ('d832b2bf-1c66-41f1-9cda-0d3d3d5943c4', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d832b2bf-1c66-41f1-9cda-0d3d3d5943c4', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d832b2bf-1c66-41f1-9cda-0d3d3d5943c4', 'metadata.annotations.backstage.io/orphan', 'true');
INSERT INTO public.search VALUES ('d832b2bf-1c66-41f1-9cda-0d3d3d5943c4', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('d832b2bf-1c66-41f1-9cda-0d3d3d5943c4', 'kind', 'location');
INSERT INTO public.search VALUES ('d832b2bf-1c66-41f1-9cda-0d3d3d5943c4', 'spec.type', 'github-discovery');
INSERT INTO public.search VALUES ('d832b2bf-1c66-41f1-9cda-0d3d3d5943c4', 'spec.target', 'https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d832b2bf-1c66-41f1-9cda-0d3d3d5943c4', 'metadata.name', 'generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551');
INSERT INTO public.search VALUES ('d832b2bf-1c66-41f1-9cda-0d3d3d5943c4', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('d832b2bf-1c66-41f1-9cda-0d3d3d5943c4', 'metadata.uid', 'd832b2bf-1c66-41f1-9cda-0d3d3d5943c4');
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
INSERT INTO public.search VALUES ('ba7da6b3-9a3d-45be-ad81-a803860e93ca', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ba7da6b3-9a3d-45be-ad81-a803860e93ca', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ba7da6b3-9a3d-45be-ad81-a803860e93ca', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('ba7da6b3-9a3d-45be-ad81-a803860e93ca', 'kind', 'location');
INSERT INTO public.search VALUES ('ba7da6b3-9a3d-45be-ad81-a803860e93ca', 'spec.type', 'url');
INSERT INTO public.search VALUES ('ba7da6b3-9a3d-45be-ad81-a803860e93ca', 'spec.target', 'https://github.com/cirodasilvajardim-crypto/mesa-site-institucional/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ba7da6b3-9a3d-45be-ad81-a803860e93ca', 'metadata.name', 'generated-c7cbc24b24c9bd1238a6138087c948db5f143a8a');
INSERT INTO public.search VALUES ('ba7da6b3-9a3d-45be-ad81-a803860e93ca', 'metadata.namespace', 'default');
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
INSERT INTO public.search VALUES ('ba7da6b3-9a3d-45be-ad81-a803860e93ca', 'metadata.uid', 'ba7da6b3-9a3d-45be-ad81-a803860e93ca');
INSERT INTO public.search VALUES ('08a67f6a-55b9-4f17-9a6d-008303c617be', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('08a67f6a-55b9-4f17-9a6d-008303c617be', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('08a67f6a-55b9-4f17-9a6d-008303c617be', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('08a67f6a-55b9-4f17-9a6d-008303c617be', 'kind', 'location');
INSERT INTO public.search VALUES ('08a67f6a-55b9-4f17-9a6d-008303c617be', 'spec.type', 'url');
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
INSERT INTO public.search VALUES ('08a67f6a-55b9-4f17-9a6d-008303c617be', 'spec.target', 'https://github.com/arthurecio/openclaw-setup/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('08a67f6a-55b9-4f17-9a6d-008303c617be', 'metadata.name', 'generated-d2a36c4260a85053ce94fbe9c674187459d272db');
INSERT INTO public.search VALUES ('08a67f6a-55b9-4f17-9a6d-008303c617be', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('08a67f6a-55b9-4f17-9a6d-008303c617be', 'metadata.uid', '08a67f6a-55b9-4f17-9a6d-008303c617be');
INSERT INTO public.search VALUES ('b081a66a-a8cb-4e6d-a5c0-430c16450a42', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b081a66a-a8cb-4e6d-a5c0-430c16450a42', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b081a66a-a8cb-4e6d-a5c0-430c16450a42', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('b081a66a-a8cb-4e6d-a5c0-430c16450a42', 'kind', 'location');
INSERT INTO public.search VALUES ('b081a66a-a8cb-4e6d-a5c0-430c16450a42', 'spec.type', 'url');
INSERT INTO public.search VALUES ('b081a66a-a8cb-4e6d-a5c0-430c16450a42', 'spec.target', 'https://github.com/fabricaberger-droid/a360-dev-multiagentes/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b081a66a-a8cb-4e6d-a5c0-430c16450a42', 'metadata.name', 'generated-1fa5db3a5d97294de3a94bed049e4c7133c78dca');
INSERT INTO public.search VALUES ('b081a66a-a8cb-4e6d-a5c0-430c16450a42', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('b081a66a-a8cb-4e6d-a5c0-430c16450a42', 'metadata.uid', 'b081a66a-a8cb-4e6d-a5c0-430c16450a42');
INSERT INTO public.search VALUES ('f3e4a0a1-be3a-4f1c-97be-0dda1b365099', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
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
INSERT INTO public.search VALUES ('7056b87f-a004-4d97-8343-edf21f81730c', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('7056b87f-a004-4d97-8343-edf21f81730c', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('7056b87f-a004-4d97-8343-edf21f81730c', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('7056b87f-a004-4d97-8343-edf21f81730c', 'kind', 'location');
INSERT INTO public.search VALUES ('7056b87f-a004-4d97-8343-edf21f81730c', 'spec.type', 'url');
INSERT INTO public.search VALUES ('7056b87f-a004-4d97-8343-edf21f81730c', 'spec.target', 'https://github.com/a360-business/galeed-community/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('7056b87f-a004-4d97-8343-edf21f81730c', 'metadata.name', 'generated-fe0f1bf72ec2879f9e6e9673b75d2a1f020b3878');
INSERT INTO public.search VALUES ('7056b87f-a004-4d97-8343-edf21f81730c', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('7056b87f-a004-4d97-8343-edf21f81730c', 'metadata.uid', '7056b87f-a004-4d97-8343-edf21f81730c');
INSERT INTO public.search VALUES ('970d32b3-c8c8-457a-be7b-1082928a08fb', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('970d32b3-c8c8-457a-be7b-1082928a08fb', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('970d32b3-c8c8-457a-be7b-1082928a08fb', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('970d32b3-c8c8-457a-be7b-1082928a08fb', 'kind', 'location');
INSERT INTO public.search VALUES ('970d32b3-c8c8-457a-be7b-1082928a08fb', 'spec.type', 'url');
INSERT INTO public.search VALUES ('970d32b3-c8c8-457a-be7b-1082928a08fb', 'spec.target', 'https://github.com/a360-business/agent-foreman/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('970d32b3-c8c8-457a-be7b-1082928a08fb', 'metadata.name', 'generated-78a0f16f4da15640f067c17fea7b0935483fd142');
INSERT INTO public.search VALUES ('970d32b3-c8c8-457a-be7b-1082928a08fb', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('970d32b3-c8c8-457a-be7b-1082928a08fb', 'metadata.uid', '970d32b3-c8c8-457a-be7b-1082928a08fb');
INSERT INTO public.search VALUES ('f3e4a0a1-be3a-4f1c-97be-0dda1b365099', 'apiversion', 'backstage.io/v1alpha1');
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
INSERT INTO public.search VALUES ('2cbc721b-e1d4-4340-80df-340fd5872798', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('2cbc721b-e1d4-4340-80df-340fd5872798', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('2cbc721b-e1d4-4340-80df-340fd5872798', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('2cbc721b-e1d4-4340-80df-340fd5872798', 'kind', 'location');
INSERT INTO public.search VALUES ('2cbc721b-e1d4-4340-80df-340fd5872798', 'spec.type', 'url');
INSERT INTO public.search VALUES ('2cbc721b-e1d4-4340-80df-340fd5872798', 'spec.target', 'https://github.com/a360-business/openclaw-setup/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('2cbc721b-e1d4-4340-80df-340fd5872798', 'metadata.name', 'generated-e40d9e847bb90a7610522a0d467185a8e079bb3e');
INSERT INTO public.search VALUES ('2cbc721b-e1d4-4340-80df-340fd5872798', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('2cbc721b-e1d4-4340-80df-340fd5872798', 'metadata.uid', '2cbc721b-e1d4-4340-80df-340fd5872798');
INSERT INTO public.search VALUES ('165fd037-6ebf-4195-9352-6ad5a94884ce', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('165fd037-6ebf-4195-9352-6ad5a94884ce', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('165fd037-6ebf-4195-9352-6ad5a94884ce', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('165fd037-6ebf-4195-9352-6ad5a94884ce', 'kind', 'location');
INSERT INTO public.search VALUES ('165fd037-6ebf-4195-9352-6ad5a94884ce', 'spec.type', 'url');
INSERT INTO public.search VALUES ('165fd037-6ebf-4195-9352-6ad5a94884ce', 'spec.target', 'https://github.com/devmarcelo/openclaw-setup/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('165fd037-6ebf-4195-9352-6ad5a94884ce', 'metadata.name', 'generated-e67fab63afdcd722173e912706fe624b9df62c34');
INSERT INTO public.search VALUES ('165fd037-6ebf-4195-9352-6ad5a94884ce', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('165fd037-6ebf-4195-9352-6ad5a94884ce', 'metadata.uid', '165fd037-6ebf-4195-9352-6ad5a94884ce');
INSERT INTO public.search VALUES ('d21a25a7-d0b8-488a-9667-b473754b703d', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d21a25a7-d0b8-488a-9667-b473754b703d', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d21a25a7-d0b8-488a-9667-b473754b703d', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('d21a25a7-d0b8-488a-9667-b473754b703d', 'kind', 'location');
INSERT INTO public.search VALUES ('d21a25a7-d0b8-488a-9667-b473754b703d', 'spec.type', 'url');
INSERT INTO public.search VALUES ('d21a25a7-d0b8-488a-9667-b473754b703d', 'spec.target', 'https://github.com/cirodasilvaj/floci-localstack-aws/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d21a25a7-d0b8-488a-9667-b473754b703d', 'metadata.name', 'generated-73a2399a7c2024519f325ee2a4e98268e82758b7');
INSERT INTO public.search VALUES ('d21a25a7-d0b8-488a-9667-b473754b703d', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('d21a25a7-d0b8-488a-9667-b473754b703d', 'metadata.uid', 'd21a25a7-d0b8-488a-9667-b473754b703d');
INSERT INTO public.search VALUES ('f3e4a0a1-be3a-4f1c-97be-0dda1b365099', 'kind', 'location');
INSERT INTO public.search VALUES ('f3e4a0a1-be3a-4f1c-97be-0dda1b365099', 'spec.type', 'url');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'apiversion', 'backstage.io/v1alpha1');
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
INSERT INTO public.search VALUES ('adeb7f13-198c-4a2e-aa65-06684ee4ee4e', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('adeb7f13-198c-4a2e-aa65-06684ee4ee4e', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('adeb7f13-198c-4a2e-aa65-06684ee4ee4e', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('adeb7f13-198c-4a2e-aa65-06684ee4ee4e', 'kind', 'location');
INSERT INTO public.search VALUES ('adeb7f13-198c-4a2e-aa65-06684ee4ee4e', 'spec.type', 'url');
INSERT INTO public.search VALUES ('adeb7f13-198c-4a2e-aa65-06684ee4ee4e', 'spec.target', 'https://github.com/a360-business/hermes-setup/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('adeb7f13-198c-4a2e-aa65-06684ee4ee4e', 'metadata.name', 'generated-edb107c0bf74b8a4c4c763787b54180b9801f99b');
INSERT INTO public.search VALUES ('adeb7f13-198c-4a2e-aa65-06684ee4ee4e', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('adeb7f13-198c-4a2e-aa65-06684ee4ee4e', 'metadata.uid', 'adeb7f13-198c-4a2e-aa65-06684ee4ee4e');
INSERT INTO public.search VALUES ('ef9ade31-8eb3-4c84-8de0-28f715ca82c0', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ef9ade31-8eb3-4c84-8de0-28f715ca82c0', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ef9ade31-8eb3-4c84-8de0-28f715ca82c0', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('ef9ade31-8eb3-4c84-8de0-28f715ca82c0', 'kind', 'location');
INSERT INTO public.search VALUES ('ef9ade31-8eb3-4c84-8de0-28f715ca82c0', 'spec.type', 'url');
INSERT INTO public.search VALUES ('ef9ade31-8eb3-4c84-8de0-28f715ca82c0', 'spec.target', 'https://github.com/vini-brito/growth-os-skills-full/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ef9ade31-8eb3-4c84-8de0-28f715ca82c0', 'metadata.name', 'generated-b44b1f6c085e8ca890654a6f6755902d78d4c46b');
INSERT INTO public.search VALUES ('ef9ade31-8eb3-4c84-8de0-28f715ca82c0', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('ef9ade31-8eb3-4c84-8de0-28f715ca82c0', 'metadata.uid', 'ef9ade31-8eb3-4c84-8de0-28f715ca82c0');
INSERT INTO public.search VALUES ('d8b23781-db44-446e-a796-22e57d97b0c9', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
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
INSERT INTO public.search VALUES ('f3e4a0a1-be3a-4f1c-97be-0dda1b365099', 'spec.target', 'https://github.com/cirodasilvaj/hermes-backup-1-vid-agentes-repos/blob/main/catalog-info.yaml');
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
INSERT INTO public.search VALUES ('3fe9e6d5-e48d-4859-825a-24b08ccd4ceb', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('3fe9e6d5-e48d-4859-825a-24b08ccd4ceb', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('3fe9e6d5-e48d-4859-825a-24b08ccd4ceb', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('3fe9e6d5-e48d-4859-825a-24b08ccd4ceb', 'kind', 'location');
INSERT INTO public.search VALUES ('3fe9e6d5-e48d-4859-825a-24b08ccd4ceb', 'spec.type', 'url');
INSERT INTO public.search VALUES ('3fe9e6d5-e48d-4859-825a-24b08ccd4ceb', 'spec.target', 'https://github.com/a360-business/growth-os-skills-full/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('3fe9e6d5-e48d-4859-825a-24b08ccd4ceb', 'metadata.name', 'generated-796712c88a485ec71e012b5c5f4566412a5f5672');
INSERT INTO public.search VALUES ('3fe9e6d5-e48d-4859-825a-24b08ccd4ceb', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('3fe9e6d5-e48d-4859-825a-24b08ccd4ceb', 'metadata.uid', '3fe9e6d5-e48d-4859-825a-24b08ccd4ceb');
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
INSERT INTO public.search VALUES ('03fa39dd-9139-4384-ac01-2f4bfaf3d4dd', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('03fa39dd-9139-4384-ac01-2f4bfaf3d4dd', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('03fa39dd-9139-4384-ac01-2f4bfaf3d4dd', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('03fa39dd-9139-4384-ac01-2f4bfaf3d4dd', 'kind', 'location');
INSERT INTO public.search VALUES ('03fa39dd-9139-4384-ac01-2f4bfaf3d4dd', 'spec.type', 'url');
INSERT INTO public.search VALUES ('03fa39dd-9139-4384-ac01-2f4bfaf3d4dd', 'spec.target', 'https://github.com/cirodasilvaj/scripts1/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('03fa39dd-9139-4384-ac01-2f4bfaf3d4dd', 'metadata.name', 'generated-39540a08be0bcb5645ee1d683b08d860953c5b44');
INSERT INTO public.search VALUES ('03fa39dd-9139-4384-ac01-2f4bfaf3d4dd', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('03fa39dd-9139-4384-ac01-2f4bfaf3d4dd', 'metadata.uid', '03fa39dd-9139-4384-ac01-2f4bfaf3d4dd');
INSERT INTO public.search VALUES ('ef7b0d9e-99e7-4c48-8994-f7df1b118282', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ef7b0d9e-99e7-4c48-8994-f7df1b118282', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ef7b0d9e-99e7-4c48-8994-f7df1b118282', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('ef7b0d9e-99e7-4c48-8994-f7df1b118282', 'kind', 'location');
INSERT INTO public.search VALUES ('ef7b0d9e-99e7-4c48-8994-f7df1b118282', 'spec.type', 'url');
INSERT INTO public.search VALUES ('ef7b0d9e-99e7-4c48-8994-f7df1b118282', 'spec.target', 'https://github.com/cirodasilvaj/mesa-agents/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ef7b0d9e-99e7-4c48-8994-f7df1b118282', 'metadata.name', 'generated-1f8726637b31d8323de2ea178b5ccd8c303f90fa');
INSERT INTO public.search VALUES ('ef7b0d9e-99e7-4c48-8994-f7df1b118282', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('ef7b0d9e-99e7-4c48-8994-f7df1b118282', 'metadata.uid', 'ef7b0d9e-99e7-4c48-8994-f7df1b118282');
INSERT INTO public.search VALUES ('f3e4a0a1-be3a-4f1c-97be-0dda1b365099', 'metadata.name', 'generated-9a24efc486a6e189695017ff7d1ff5886f9498aa');
INSERT INTO public.search VALUES ('15d0d89c-e09d-4679-a192-0892d1cd29bc', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('15d0d89c-e09d-4679-a192-0892d1cd29bc', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('15d0d89c-e09d-4679-a192-0892d1cd29bc', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('15d0d89c-e09d-4679-a192-0892d1cd29bc', 'kind', 'location');
INSERT INTO public.search VALUES ('15d0d89c-e09d-4679-a192-0892d1cd29bc', 'spec.type', 'url');
INSERT INTO public.search VALUES ('15d0d89c-e09d-4679-a192-0892d1cd29bc', 'spec.target', 'https://github.com/a360-business/a360-dev-multiagentes/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('15d0d89c-e09d-4679-a192-0892d1cd29bc', 'metadata.name', 'generated-bd14bea673b37261e7a74bd04975480bb069f8bc');
INSERT INTO public.search VALUES ('15d0d89c-e09d-4679-a192-0892d1cd29bc', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('15d0d89c-e09d-4679-a192-0892d1cd29bc', 'metadata.uid', '15d0d89c-e09d-4679-a192-0892d1cd29bc');
INSERT INTO public.search VALUES ('d8b23781-db44-446e-a796-22e57d97b0c9', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d8b23781-db44-446e-a796-22e57d97b0c9', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('d8b23781-db44-446e-a796-22e57d97b0c9', 'kind', 'location');
INSERT INTO public.search VALUES ('d8b23781-db44-446e-a796-22e57d97b0c9', 'spec.type', 'url');
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
INSERT INTO public.search VALUES ('1495d3c6-d8f8-42b5-8674-975878d1bbb3', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('1495d3c6-d8f8-42b5-8674-975878d1bbb3', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('1495d3c6-d8f8-42b5-8674-975878d1bbb3', 'apiversion', 'backstage.io/v1alpha1');
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
INSERT INTO public.search VALUES ('0e6caa74-5293-4053-a36c-4bcfd4ee5ca0', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('0e6caa74-5293-4053-a36c-4bcfd4ee5ca0', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('0e6caa74-5293-4053-a36c-4bcfd4ee5ca0', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('0e6caa74-5293-4053-a36c-4bcfd4ee5ca0', 'kind', 'location');
INSERT INTO public.search VALUES ('0e6caa74-5293-4053-a36c-4bcfd4ee5ca0', 'spec.type', 'url');
INSERT INTO public.search VALUES ('0e6caa74-5293-4053-a36c-4bcfd4ee5ca0', 'spec.target', 'https://github.com/a360-business/accelera-skills/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('0e6caa74-5293-4053-a36c-4bcfd4ee5ca0', 'metadata.name', 'generated-6e615a027feacec08857bccd2c90fef1db2a2372');
INSERT INTO public.search VALUES ('0e6caa74-5293-4053-a36c-4bcfd4ee5ca0', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('0e6caa74-5293-4053-a36c-4bcfd4ee5ca0', 'metadata.uid', '0e6caa74-5293-4053-a36c-4bcfd4ee5ca0');
INSERT INTO public.search VALUES ('a719699d-987b-4b60-90cd-1379aa96a91f', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a719699d-987b-4b60-90cd-1379aa96a91f', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a719699d-987b-4b60-90cd-1379aa96a91f', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('a719699d-987b-4b60-90cd-1379aa96a91f', 'kind', 'location');
INSERT INTO public.search VALUES ('a719699d-987b-4b60-90cd-1379aa96a91f', 'spec.type', 'url');
INSERT INTO public.search VALUES ('a719699d-987b-4b60-90cd-1379aa96a91f', 'spec.target', 'https://github.com/cirodasilvaj/zoeiroka-automacoes/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a719699d-987b-4b60-90cd-1379aa96a91f', 'metadata.name', 'generated-bcfe70fc389b7b6f55a5728ad12e48fbb12a7627');
INSERT INTO public.search VALUES ('a719699d-987b-4b60-90cd-1379aa96a91f', 'metadata.namespace', 'default');
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
INSERT INTO public.search VALUES ('a719699d-987b-4b60-90cd-1379aa96a91f', 'metadata.uid', 'a719699d-987b-4b60-90cd-1379aa96a91f');
INSERT INTO public.search VALUES ('16c3cb70-e2e9-4910-80e9-b173ef4de30b', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('16c3cb70-e2e9-4910-80e9-b173ef4de30b', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('16c3cb70-e2e9-4910-80e9-b173ef4de30b', 'apiversion', 'backstage.io/v1alpha1');
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
INSERT INTO public.search VALUES ('d8b23781-db44-446e-a796-22e57d97b0c9', 'spec.target', 'https://github.com/fernandonesi/galeed-community/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d8b23781-db44-446e-a796-22e57d97b0c9', 'metadata.name', 'generated-c377ebbfb933b0a54dfd0e158734712e21979bde');
INSERT INTO public.search VALUES ('d8b23781-db44-446e-a796-22e57d97b0c9', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('d8b23781-db44-446e-a796-22e57d97b0c9', 'metadata.uid', 'd8b23781-db44-446e-a796-22e57d97b0c9');
INSERT INTO public.search VALUES ('147335f7-820d-4e12-939a-13d0250820a6', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('147335f7-820d-4e12-939a-13d0250820a6', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('147335f7-820d-4e12-939a-13d0250820a6', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('147335f7-820d-4e12-939a-13d0250820a6', 'kind', 'location');
INSERT INTO public.search VALUES ('147335f7-820d-4e12-939a-13d0250820a6', 'spec.type', 'url');
INSERT INTO public.search VALUES ('147335f7-820d-4e12-939a-13d0250820a6', 'spec.target', 'https://github.com/cirobessa/kube-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('147335f7-820d-4e12-939a-13d0250820a6', 'metadata.name', 'generated-d6eb614c9d4a9daaeb84a95d3fece1a6a0dd9916');
INSERT INTO public.search VALUES ('147335f7-820d-4e12-939a-13d0250820a6', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('147335f7-820d-4e12-939a-13d0250820a6', 'metadata.uid', '147335f7-820d-4e12-939a-13d0250820a6');
INSERT INTO public.search VALUES ('f3e4a0a1-be3a-4f1c-97be-0dda1b365099', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('f3e4a0a1-be3a-4f1c-97be-0dda1b365099', 'metadata.namespace', 'default');
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
INSERT INTO public.search VALUES ('1495d3c6-d8f8-42b5-8674-975878d1bbb3', 'kind', 'location');
INSERT INTO public.search VALUES ('1495d3c6-d8f8-42b5-8674-975878d1bbb3', 'spec.type', 'url');
INSERT INTO public.search VALUES ('1495d3c6-d8f8-42b5-8674-975878d1bbb3', 'spec.target', 'https://github.com/a360-business/setup-ambiente/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('1495d3c6-d8f8-42b5-8674-975878d1bbb3', 'metadata.name', 'generated-03b13b5fb17fe9a670e36e235ad81fd06fcfd666');
INSERT INTO public.search VALUES ('1495d3c6-d8f8-42b5-8674-975878d1bbb3', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('1495d3c6-d8f8-42b5-8674-975878d1bbb3', 'metadata.uid', '1495d3c6-d8f8-42b5-8674-975878d1bbb3');
INSERT INTO public.search VALUES ('b5678983-efe6-44d7-9c0d-3046066c1687', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b5678983-efe6-44d7-9c0d-3046066c1687', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b5678983-efe6-44d7-9c0d-3046066c1687', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('b5678983-efe6-44d7-9c0d-3046066c1687', 'kind', 'location');
INSERT INTO public.search VALUES ('b5678983-efe6-44d7-9c0d-3046066c1687', 'spec.type', 'url');
INSERT INTO public.search VALUES ('b5678983-efe6-44d7-9c0d-3046066c1687', 'spec.target', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b5678983-efe6-44d7-9c0d-3046066c1687', 'metadata.name', 'generated-3a49cafceb0ae80411060ab243ac7adf4cb8101e');
INSERT INTO public.search VALUES ('b5678983-efe6-44d7-9c0d-3046066c1687', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('b5678983-efe6-44d7-9c0d-3046066c1687', 'metadata.uid', 'b5678983-efe6-44d7-9c0d-3046066c1687');
INSERT INTO public.search VALUES ('26a2b9a2-91df-4404-93e7-f9c5e2c4b62f', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('26a2b9a2-91df-4404-93e7-f9c5e2c4b62f', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('26a2b9a2-91df-4404-93e7-f9c5e2c4b62f', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('26a2b9a2-91df-4404-93e7-f9c5e2c4b62f', 'kind', 'location');
INSERT INTO public.search VALUES ('26a2b9a2-91df-4404-93e7-f9c5e2c4b62f', 'spec.type', 'url');
INSERT INTO public.search VALUES ('26a2b9a2-91df-4404-93e7-f9c5e2c4b62f', 'spec.target', 'https://github.com/cirodasilvaj/counter-service-exercise/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('26a2b9a2-91df-4404-93e7-f9c5e2c4b62f', 'metadata.name', 'generated-d6c74b7d4667a209e2cd1841e6d838c0d7d20c98');
INSERT INTO public.search VALUES ('26a2b9a2-91df-4404-93e7-f9c5e2c4b62f', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('26a2b9a2-91df-4404-93e7-f9c5e2c4b62f', 'metadata.uid', '26a2b9a2-91df-4404-93e7-f9c5e2c4b62f');
INSERT INTO public.search VALUES ('f3e4a0a1-be3a-4f1c-97be-0dda1b365099', 'metadata.uid', 'f3e4a0a1-be3a-4f1c-97be-0dda1b365099');
INSERT INTO public.search VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'kind', 'location');
INSERT INTO public.search VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'spec.type', 'file');
INSERT INTO public.search VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'spec.target', '/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'metadata.name', 'generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec');
INSERT INTO public.search VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('f4a11b84-32b1-4802-a206-b75b16465f11', 'metadata.uid', 'f4a11b84-32b1-4802-a206-b75b16465f11');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'kind', 'location');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'spec.type', 'url');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'spec.target', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'metadata.name', 'generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'metadata.uid', '50cc71b8-67dc-4dac-91e0-57841741c1a5');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('83c4b685-a74b-4228-a442-a3903e0778b0', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('f1aa9fc8-a1d7-4a05-be6e-986ca893cbf2', 'relations.partof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('45752d5d-178b-4c41-accd-053a59debedd', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('45752d5d-178b-4c41-accd-053a59debedd', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('45752d5d-178b-4c41-accd-053a59debedd', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('45752d5d-178b-4c41-accd-053a59debedd', 'kind', 'location');
INSERT INTO public.search VALUES ('45752d5d-178b-4c41-accd-053a59debedd', 'spec.type', 'url');
INSERT INTO public.search VALUES ('45752d5d-178b-4c41-accd-053a59debedd', 'spec.target', 'https://github.com/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('45752d5d-178b-4c41-accd-053a59debedd', 'metadata.name', 'generated-31a0877ed2bec2edf4feee46dd4161a60585d1ce');
INSERT INTO public.search VALUES ('45752d5d-178b-4c41-accd-053a59debedd', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('45752d5d-178b-4c41-accd-053a59debedd', 'metadata.uid', '45752d5d-178b-4c41-accd-053a59debedd');
INSERT INTO public.search VALUES ('8d116692-0278-464c-979e-ab81d3e5aefd', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('8d116692-0278-464c-979e-ab81d3e5aefd', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('8d116692-0278-464c-979e-ab81d3e5aefd', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('8d116692-0278-464c-979e-ab81d3e5aefd', 'kind', 'location');
INSERT INTO public.search VALUES ('8d116692-0278-464c-979e-ab81d3e5aefd', 'spec.type', 'url');
INSERT INTO public.search VALUES ('8d116692-0278-464c-979e-ab81d3e5aefd', 'spec.target', 'https://github.com/leonardoserio/accelera-skills/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('8d116692-0278-464c-979e-ab81d3e5aefd', 'metadata.name', 'generated-e461ccc7db88e98c2a26c40a0672f2e1edbfe4f0');
INSERT INTO public.search VALUES ('8d116692-0278-464c-979e-ab81d3e5aefd', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('8d116692-0278-464c-979e-ab81d3e5aefd', 'metadata.uid', '8d116692-0278-464c-979e-ab81d3e5aefd');
INSERT INTO public.search VALUES ('49c5d45a-10ac-4e69-86a6-abe8514e289e', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('49c5d45a-10ac-4e69-86a6-abe8514e289e', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('49c5d45a-10ac-4e69-86a6-abe8514e289e', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('49c5d45a-10ac-4e69-86a6-abe8514e289e', 'kind', 'location');
INSERT INTO public.search VALUES ('49c5d45a-10ac-4e69-86a6-abe8514e289e', 'spec.type', 'url');
INSERT INTO public.search VALUES ('49c5d45a-10ac-4e69-86a6-abe8514e289e', 'spec.target', 'https://github.com/cirodasilvaj/bs-tutelas-patentes-site/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('49c5d45a-10ac-4e69-86a6-abe8514e289e', 'metadata.name', 'generated-6bcefc9bd5af69ed0137a6ce0836fe36e0fef7f2');
INSERT INTO public.search VALUES ('49c5d45a-10ac-4e69-86a6-abe8514e289e', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('49c5d45a-10ac-4e69-86a6-abe8514e289e', 'metadata.uid', '49c5d45a-10ac-4e69-86a6-abe8514e289e');
INSERT INTO public.search VALUES ('c53ac0bc-ed1c-4e57-9161-2aa918a66513', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c53ac0bc-ed1c-4e57-9161-2aa918a66513', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c53ac0bc-ed1c-4e57-9161-2aa918a66513', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('c53ac0bc-ed1c-4e57-9161-2aa918a66513', 'kind', 'location');
INSERT INTO public.search VALUES ('c53ac0bc-ed1c-4e57-9161-2aa918a66513', 'spec.type', 'url');
INSERT INTO public.search VALUES ('c53ac0bc-ed1c-4e57-9161-2aa918a66513', 'spec.target', 'https://github.com/talerelayapp/superfria/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c53ac0bc-ed1c-4e57-9161-2aa918a66513', 'metadata.name', 'generated-83f2543400bad694b3b4169b8f0dda74347f09ca');
INSERT INTO public.search VALUES ('c53ac0bc-ed1c-4e57-9161-2aa918a66513', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('c53ac0bc-ed1c-4e57-9161-2aa918a66513', 'metadata.uid', 'c53ac0bc-ed1c-4e57-9161-2aa918a66513');
INSERT INTO public.search VALUES ('b3095b41-0888-4c27-84f0-00bdceb205fe', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b3095b41-0888-4c27-84f0-00bdceb205fe', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b3095b41-0888-4c27-84f0-00bdceb205fe', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('b3095b41-0888-4c27-84f0-00bdceb205fe', 'kind', 'location');
INSERT INTO public.search VALUES ('b3095b41-0888-4c27-84f0-00bdceb205fe', 'spec.type', 'url');
INSERT INTO public.search VALUES ('b3095b41-0888-4c27-84f0-00bdceb205fe', 'spec.target', 'https://github.com/cirodasilvaj/bot-dermatologia-mattos/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b3095b41-0888-4c27-84f0-00bdceb205fe', 'metadata.name', 'generated-aea2074c195831a31fb8d1acdfcfd9ae7d08cd1b');
INSERT INTO public.search VALUES ('b3095b41-0888-4c27-84f0-00bdceb205fe', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('b3095b41-0888-4c27-84f0-00bdceb205fe', 'metadata.uid', 'b3095b41-0888-4c27-84f0-00bdceb205fe');
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
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('0292df28-4efd-43fd-a9ee-52ece26b6185', 'kind', 'location');
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
INSERT INTO public.search VALUES ('16c3cb70-e2e9-4910-80e9-b173ef4de30b', 'kind', 'location');
INSERT INTO public.search VALUES ('16c3cb70-e2e9-4910-80e9-b173ef4de30b', 'spec.type', 'url');
INSERT INTO public.search VALUES ('16c3cb70-e2e9-4910-80e9-b173ef4de30b', 'spec.target', 'https://github.com/joaoguibune/galeed-community/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('16c3cb70-e2e9-4910-80e9-b173ef4de30b', 'metadata.name', 'generated-023ff0c2d516eb7ee170b46c23edf162e464605b');
INSERT INTO public.search VALUES ('16c3cb70-e2e9-4910-80e9-b173ef4de30b', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('16c3cb70-e2e9-4910-80e9-b173ef4de30b', 'metadata.uid', '16c3cb70-e2e9-4910-80e9-b173ef4de30b');
INSERT INTO public.search VALUES ('4cb23490-426e-4e19-9652-da094d279f3e', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('4cb23490-426e-4e19-9652-da094d279f3e', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('4cb23490-426e-4e19-9652-da094d279f3e', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('4cb23490-426e-4e19-9652-da094d279f3e', 'kind', 'location');
INSERT INTO public.search VALUES ('4cb23490-426e-4e19-9652-da094d279f3e', 'spec.type', 'url');
INSERT INTO public.search VALUES ('4cb23490-426e-4e19-9652-da094d279f3e', 'spec.target', 'https://github.com/moreirathi87/galeed-community/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('4cb23490-426e-4e19-9652-da094d279f3e', 'metadata.name', 'generated-8f44ff1b0eee905e4f10b347f2f4cde12c6ecb91');
INSERT INTO public.search VALUES ('4cb23490-426e-4e19-9652-da094d279f3e', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('4cb23490-426e-4e19-9652-da094d279f3e', 'metadata.uid', '4cb23490-426e-4e19-9652-da094d279f3e');
INSERT INTO public.search VALUES ('6679cc68-fcb4-4c93-87c0-4ac41bd02e23', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('6679cc68-fcb4-4c93-87c0-4ac41bd02e23', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('6679cc68-fcb4-4c93-87c0-4ac41bd02e23', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('6679cc68-fcb4-4c93-87c0-4ac41bd02e23', 'kind', 'location');
INSERT INTO public.search VALUES ('6679cc68-fcb4-4c93-87c0-4ac41bd02e23', 'spec.type', 'url');
INSERT INTO public.search VALUES ('6679cc68-fcb4-4c93-87c0-4ac41bd02e23', 'spec.target', 'https://github.com/master-developer-nandomatik/growth-os-skills-full/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('6679cc68-fcb4-4c93-87c0-4ac41bd02e23', 'metadata.name', 'generated-fa205f62d462a6f82aa4a1b49761425165444beb');
INSERT INTO public.search VALUES ('6679cc68-fcb4-4c93-87c0-4ac41bd02e23', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('6679cc68-fcb4-4c93-87c0-4ac41bd02e23', 'metadata.uid', '6679cc68-fcb4-4c93-87c0-4ac41bd02e23');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('50cc71b8-67dc-4dac-91e0-57841741c1a5', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
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
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/apps-demo-2026/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b997bba0-79d4-45ab-9ba3-3b007e722a86', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/');


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

SELECT pg_catalog.setval('public.refresh_state_references_id_seq', 1457, true);


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

\unrestrict kk1VekvTEMBwWC3LncKxgP8DBBWWbKQDwcCxFpjXcpSQZjCnV0E0q6lgdeBtiqq

