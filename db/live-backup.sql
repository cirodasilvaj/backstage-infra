--
-- PostgreSQL database dump
--

\restrict Y9vGwNy4a8aj4Fl83vJwpinylC8hf1uzaNlyVEOFbl4fAl1seSPPIXGTpZHpdEA

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

INSERT INTO public.final_entities VALUES ('91a4a62f-0e20-4d57-a546-55f9f325a6c6', '42cacfd135205b00de92b81e5f1590be95f56b5c', '9b595f0d-345e-4caf-9ed6-900e3776307d', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec","uid":"91a4a62f-0e20-4d57-a546-55f9f325a6c6","generation":1,"etag":"42cacfd135205b00de92b81e5f1590be95f56b5c"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"file","target":"/etc/backstage/catalog-entities.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('bc4ebcf5-c998-4f61-ab16-3ac80fd4490f', '6e2a7a2b9a094bc1f88b0123a33af464ba7623b0', '29145b94-bf40-4e2d-a649-fa680ad6a999', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-fa205f62d462a6f82aa4a1b49761425165444beb","uid":"bc4ebcf5-c998-4f61-ab16-3ac80fd4490f","generation":1,"etag":"6e2a7a2b9a094bc1f88b0123a33af464ba7623b0"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/master-developer-nandomatik/growth-os-skills-full/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/master-developer-nandomatik/growth-os-skills-full/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/master-developer-nandomatik/growth-os-skills-full/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/master-developer-nandomatik/growth-os-skills-full/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/master-developer-nandomatik/growth-os-skills-full/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('2964dfe6-0ed8-47c1-8b66-62b9a5a5f2f1', 'e2aac03ffc9e52da133cbbb0df0680100401d25b', '798952b3-8e54-4ec1-b758-2641cd4eddcb', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551","uid":"2964dfe6-0ed8-47c1-8b66-62b9a5a5f2f1","generation":1,"etag":"e2aac03ffc9e52da133cbbb0df0680100401d25b"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"github-discovery","target":"https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', '17b124cef6facf909e92d036909a08edfb552471', '63400c7e-c81b-47c8-a6b1-258704fe8271', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","github.com/project-slug":"cirobessa/kube-demo-2026","backstage.io/kubernetes-id":"argocd","backstage.io/kubernetes-namespace":"argocd","backstage.io/kubernetes-label-selector":"app.kubernetes.io/part-of=argocd"},"name":"argocd","title":"ArgoCD GitOps","description":"ArgoCD GitOps Continuous Delivery Controller on EKS","links":[{"url":"https://argocd.992382723408.realhandsonlabs.net","title":"ArgoCD Web Console (HTTPS ACM)","icon":"sync"},{"url":"https://github.com/cirobessa/kube-demo-2026","title":"GitOps Cluster Repository","icon":"github"}],"uid":"c0075925-12d7-4dfa-b9fc-8324d2f99dcb","generation":1,"etag":"17b124cef6facf909e92d036909a08edfb552471"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('67f8a0e4-f1e1-46a8-8541-0d06400fadc6', '2cbf7dce531ff831aa3dc47b1c5a09d5f612b7b2', 'a203c916-0bf3-4acf-b614-225707c2c7fd', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-e461ccc7db88e98c2a26c40a0672f2e1edbfe4f0","uid":"67f8a0e4-f1e1-46a8-8541-0d06400fadc6","generation":1,"etag":"2cbf7dce531ff831aa3dc47b1c5a09d5f612b7b2"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/leonardoserio/accelera-skills/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/leonardoserio/accelera-skills/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/leonardoserio/accelera-skills/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/leonardoserio/accelera-skills/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/leonardoserio/accelera-skills/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('dd4b07f1-662a-49b8-8764-5d5845540a4e', 'd9b04cd0865e6dbc14a2abdb9e3d68c8853a2b17', '7b90d812-b7d3-4d84-931b-bbf70a182e65', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-6e615a027feacec08857bccd2c90fef1db2a2372","uid":"dd4b07f1-662a-49b8-8764-5d5845540a4e","generation":1,"etag":"d9b04cd0865e6dbc14a2abdb9e3d68c8853a2b17"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/accelera-skills/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/a360-business/accelera-skills/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/accelera-skills/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/accelera-skills/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/accelera-skills/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('39f21457-07ab-4140-9a0a-9ab2a68f7e28', '0401f4aa5728b41ed91393540ed4ade3de19f48e', '9a3d95e4-88a8-4440-a982-f7541b55c645', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-6bcefc9bd5af69ed0137a6ce0836fe36e0fef7f2","uid":"39f21457-07ab-4140-9a0a-9ab2a68f7e28","generation":1,"etag":"0401f4aa5728b41ed91393540ed4ade3de19f48e"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/bs-tutelas-patentes-site/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/bs-tutelas-patentes-site/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/bs-tutelas-patentes-site/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/bs-tutelas-patentes-site/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/bs-tutelas-patentes-site/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', '130b7a34f3bb61aeb2d15533d81743faf53eb028', '11157dfe-160c-4e58-aa58-cc17edebcac7', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/"},"name":"python-sonarqube-cicd-template","title":"Python 3.12 Web App + CI/CD with QA, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Python (Flask + Gunicorn) repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki logging, and Backstage manifest.","tags":["python","flask","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"a9a1752a-cf74-47af-9a22-dede131c4c5d","generation":1,"etag":"130b7a34f3bb61aeb2d15533d81743faf53eb028"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"python-app-demo"},"description":{"title":"Description","type":"string","description":"What does this microservice do?","default":"Python microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"python-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"{{ parameters.component_id }}","description":"{{ parameters.description }}","owner":"{{ parameters.owner }}","system":"{{ parameters.system }}","destinationOwner":"{{ parameters.destinationOwner }}"}}},{"id":"publish","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"{{ parameters.description }}","repoUrl":"github.com?owner={{ parameters.destinationOwner }}&repo={{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"{{ steps.publish.output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"{{ steps.publish.output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"{{ steps.register.output.entityRef }}"}]}},"relations":[{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"squad-plataforma"}}]}');
INSERT INTO public.final_entities VALUES ('b70e7452-e2ca-4d1a-baef-8929bed899ae', 'ef3659ca0db2caf03750f51c925f7908de0b9abd', '8c341948-dbd1-4e39-9074-24ec816e2f38', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-d2a36c4260a85053ce94fbe9c674187459d272db","uid":"b70e7452-e2ca-4d1a-baef-8929bed899ae","generation":1,"etag":"ef3659ca0db2caf03750f51c925f7908de0b9abd"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/arthurecio/openclaw-setup/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/arthurecio/openclaw-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/arthurecio/openclaw-setup/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/arthurecio/openclaw-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/arthurecio/openclaw-setup/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', '93b787ce87113fa66513de14662fa9c96f768ad6', '6b9e9f3b-bfd5-435f-b5d8-3124ab0033b2', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/","github.com/project-slug":"cirodasilvaj/apps-demo-2026","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"dotnet-csharp-demo-app","grafana/tag-selector":"service:dotnet-csharp-demo-app","grafana/overview-dashboard":"http://grafana.992382723408.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe","argocd/app-name":"dotnet-csharp-app"},"name":"dotnet-csharp-demo-app","title":".NET 8 C# Minimal API Microservice","description":"App Web em C# (.NET 8 Minimal API) com Prometheus metrics, logs JSON para Grafana Loki, SonarQube Quality Gate, GitOps via ArgoCD e HTTPS via AWS ACM.","tags":["dotnet","csharp","sonarqube","prometheus","fluentd","loki","grafana","k8s","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app","title":"GitHub Source Code","icon":"github"},{"url":"http://dotnet.992382723408.realhandsonlabs.net","title":".NET 8 C# Live App (HTTP)","icon":"web"},{"url":"https://dotnet.992382723408.realhandsonlabs.net","title":".NET 8 C# Live App (HTTPS ACM)","icon":"lock"},{"url":"http://dotnet.992382723408.realhandsonlabs.net/metrics","title":"Prometheus Metrics (/metrics)","icon":"gauge"},{"url":"http://grafana.992382723408.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe","title":"Grafana Dashboard (Golden Signals & Loki Logs)","icon":"dashboard"},{"url":"http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=apps-demo-2026","title":"SonarQube Quality Gate","icon":"check"},{"url":"https://argocd.992382723408.realhandsonlabs.net/applications/dotnet-csharp-app","title":"ArgoCD GitOps","icon":"sync"}],"uid":"526e7749-f3f6-4d20-83a4-549c09c21024","generation":1,"etag":"93b787ce87113fa66513de14662fa9c96f768ad6"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","providesApis":["dotnet-csharp-app-api"],"dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"apps-demo-2026"}},{"type":"providesApi","target":{"kind":"api","namespace":"default","name":"dotnet-csharp-app-api"}}]}');
INSERT INTO public.final_entities VALUES ('4def6055-c424-4fc1-bd59-5ee4349e209a', '5accc7f767081fcdf550e975ea481727eb74ebba', '4dfb6b41-5fcd-4248-9430-0c8cb031bb9d', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-023ff0c2d516eb7ee170b46c23edf162e464605b","uid":"4def6055-c424-4fc1-bd59-5ee4349e209a","generation":1,"etag":"5accc7f767081fcdf550e975ea481727eb74ebba"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/joaoguibune/galeed-community/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/joaoguibune/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/joaoguibune/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/joaoguibune/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/joaoguibune/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', '6abf65f65cd88432a549776fa17759a0f031cbc1', '5523a56f-9a07-459a-95c5-f52524ef3a3c', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/"},"name":"dotnet-csharp-app-api","title":".NET 8 C# Minimal API REST API","description":"Interface REST para consulta de status, saúde e telemetria da aplicação C# .NET 8","uid":"d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e","generation":1,"etag":"6abf65f65cd88432a549776fa17759a0f031cbc1"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","definition":"openapi: \"3.0.0\"\ninfo:\n  title: .NET 8 C# Minimal API\n  version: \"1.0.0\"\npaths:\n  /:\n    get:\n      summary: Overview & HTML Dashboard\n      responses:\n        ''200'':\n          description: OK\n  /api/info:\n    get:\n      summary: System & client runtime information\n      responses:\n        ''200'':\n          description: OK\n  /healthz:\n    get:\n      summary: Liveness probe\n      responses:\n        ''200'':\n          description: OK\n  /ready:\n    get:\n      summary: Readiness probe\n      responses:\n        ''200'':\n          description: OK\n  /metrics:\n    get:\n      summary: Prometheus metrics\n      responses:\n        ''200'':\n          description: OK\n"},"relations":[{"type":"apiProvidedBy","target":{"kind":"component","namespace":"default","name":"dotnet-csharp-demo-app"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"apps-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('c9965817-610e-41cd-90a5-62723cfcf426', 'e6a9a187436efef41b8ac76c683f594a1da95dc7', '6c5f6ec4-d071-4334-aa5d-1bdc62a81199', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-db60c7b251928fac7d8502c0c92b1fa486c7621b","uid":"c9965817-610e-41cd-90a5-62723cfcf426","generation":1,"etag":"e6a9a187436efef41b8ac76c683f594a1da95dc7"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/test-repo-via-pat/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/test-repo-via-pat/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/test-repo-via-pat/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/test-repo-via-pat/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/test-repo-via-pat/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('ba03d047-b0e3-49dc-bc31-be7e943f6da4', 'a9bdf8c422903c58e0458f9649e41806714f6e8f', '7ae8456a-59fb-415a-b3f0-73964eb56534', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-e67fab63afdcd722173e912706fe624b9df62c34","uid":"ba03d047-b0e3-49dc-bc31-be7e943f6da4","generation":1,"etag":"a9bdf8c422903c58e0458f9649e41806714f6e8f"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/devmarcelo/openclaw-setup/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/devmarcelo/openclaw-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/devmarcelo/openclaw-setup/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/devmarcelo/openclaw-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/devmarcelo/openclaw-setup/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('b9fc798e-c450-4cff-b55b-5176288fd3ea', 'f9665f9dee271da4e61be8fcbe70899d8edd1a99', '84a7a24b-8e2b-457e-b7e3-9ef9e8759de8', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-d6c74b7d4667a209e2cd1841e6d838c0d7d20c98","uid":"b9fc798e-c450-4cff-b55b-5176288fd3ea","generation":1,"etag":"f9665f9dee271da4e61be8fcbe70899d8edd1a99"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/counter-service-exercise/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/counter-service-exercise/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/counter-service-exercise/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/counter-service-exercise/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/counter-service-exercise/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'f998e1fc82abf9df9e584842f6652de6c21fd8a1', '8a223f48-a9be-4f3d-a0be-4e1d0ccd688f', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"radius-mfa-api","description":"Endpoint FreeRADIUS Auth (UDP 1812) e Acct (UDP 1813) com suporte a MFA (radius.empresa.local)","uid":"aaba2d47-d59f-46f6-9305-53637bf8ece9","generation":1,"etag":"f998e1fc82abf9df9e584842f6652de6c21fd8a1"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"grpc","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"syntax = \"proto3\";\nservice FreeRadiusMFA {\n  // UDP radius.empresa.local:1812 (Auth + MFA)\n  // UDP radius.empresa.local:1813 (Accounting)\n}\n"},"relations":[{"type":"apiProvidedBy","target":{"kind":"component","namespace":"default","name":"freeradius-mfa"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}}]}');
INSERT INTO public.final_entities VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', '1b6cebd7e68bbaf380d4b5f15c09b3a11f6dfa02', '20a686a4-9f38-48a3-8d4a-8ba75b19ea1f', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system"},"name":"kube-demo-eks","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","uid":"a1398182-7d8a-41e3-bab3-6f6125b19bd2","generation":1,"etag":"1b6cebd7e68bbaf380d4b5f15c09b3a11f6dfa02"},"apiVersion":"backstage.io/v1alpha1","kind":"Resource","spec":{"type":"kubernetes-cluster","owner":"platform-team","system":"kube-demo-2026"},"relations":[{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"argocd"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"backstage-portal"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"dotnet-csharp-demo-app"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"grafana"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"prometheus"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"python-demo-app"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"sonarqube"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'e72c94a885238127c90444022dc525fbbc721034', '52d7a2a7-554c-486d-bef1-2062037b2b5a', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/","github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"samba-ad-keycloak","backstage.io/kubernetes-id":"freeradius-mfa","backstage.io/kubernetes-namespace":"default","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"samba-ad-keycloak"},"name":"freeradius-mfa","description":"Servidor FreeRADIUS + PAM Google Authenticator (TOTP MFA) integrado ao Samba 4 AD para autenticação geral e MFA na VPC do EKS","tags":["radius","freeradius","mfa","totp"],"links":[{"url":"https://github.com/cirodasilvaj/samba-ad-keycloak","title":"GitHub Source Code","icon":"github"}],"uid":"c7e06623-192c-43eb-87f8-2951a24f999f","generation":1,"etag":"e72c94a885238127c90444022dc525fbbc721034"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","dependsOn":["component:default/samba-ad-dc"],"providesApis":["radius-mfa-api"]},"relations":[{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"keycloak-sso"}},{"type":"dependsOn","target":{"kind":"component","namespace":"default","name":"samba-ad-dc"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}},{"type":"providesApi","target":{"kind":"api","namespace":"default","name":"radius-mfa-api"}}]}');
INSERT INTO public.final_entities VALUES ('6206c4ce-84cd-4dd6-8547-d58912b69324', 'afcbca0a9db59f8f69105531f349f51ef4de1511', '7ba576c0-c4e8-4eaf-bac1-bb48ac7b1fd3', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-c7cbc24b24c9bd1238a6138087c948db5f143a8a","uid":"6206c4ce-84cd-4dd6-8547-d58912b69324","generation":1,"etag":"afcbca0a9db59f8f69105531f349f51ef4de1511"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvajardim-crypto/mesa-site-institucional/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvajardim-crypto/mesa-site-institucional/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvajardim-crypto/mesa-site-institucional/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvajardim-crypto/mesa-site-institucional/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvajardim-crypto/mesa-site-institucional/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('ee863f3c-6e3d-4737-bf1c-fa378c782ff2', '8c3b00b94aa480bf87f251f4be5fb6cb32890453', 'f22d3c05-6c89-4315-ac55-3536ad5fdd48', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-1fa5db3a5d97294de3a94bed049e4c7133c78dca","uid":"ee863f3c-6e3d-4737-bf1c-fa378c782ff2","generation":1,"etag":"8c3b00b94aa480bf87f251f4be5fb6cb32890453"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/fabricaberger-droid/a360-dev-multiagentes/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/fabricaberger-droid/a360-dev-multiagentes/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/fabricaberger-droid/a360-dev-multiagentes/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/fabricaberger-droid/a360-dev-multiagentes/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/fabricaberger-droid/a360-dev-multiagentes/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', '3b6baef776b1887e6352c4db00c716f80e0c4d82', '62639233-1b0b-4ff6-9584-45fd58e8949d', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","github.com/project-slug":"cirobessa/kube-demo-2026","backstage.io/kubernetes-id":"grafana","backstage.io/kubernetes-namespace":"grafana","backstage.io/kubernetes-label-selector":"app.kubernetes.io/name=grafana"},"name":"grafana","title":"Grafana Observability","description":"Grafana Observability Dashboards connected to Prometheus and Loki","links":[{"url":"http://grafana.992382723408.realhandsonlabs.net","title":"Grafana Dashboards UI","icon":"dashboard"},{"url":"https://github.com/cirobessa/kube-demo-2026","title":"Monitoring Config Repo","icon":"github"}],"uid":"b0a652b4-6566-4194-a5f2-2a8c3c31db69","generation":1,"etag":"3b6baef776b1887e6352c4db00c716f80e0c4d82"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"website","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('849ec066-af2d-4eb7-8084-8674deff2066', '9c5c4e927e01c9a8aa26ece956d5e428c5a24970', '225638e2-eea4-4e15-be43-e6e5ca037b24', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-bd14bea673b37261e7a74bd04975480bb069f8bc","uid":"849ec066-af2d-4eb7-8084-8674deff2066","generation":1,"etag":"9c5c4e927e01c9a8aa26ece956d5e428c5a24970"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/a360-dev-multiagentes/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/a360-business/a360-dev-multiagentes/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/a360-dev-multiagentes/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/a360-dev-multiagentes/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/a360-dev-multiagentes/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', '5d90175c1089dadd863a4c36f850aae933bc3b90', 'ba56c68b-6bf7-4e0f-96ff-9bce674de1ba', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/","github.com/project-slug":"cirodasilvaj/bakstg-nodejs-demo2","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"bakstg-nodejs-demo2","backstage.io/kubernetes-id":"bakstg-nodejs-demo2","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"bakstg-nodejs-demo2","grafana/tag-selector":"service:bakstg-nodejs-demo2","grafana/overview-dashboard":"http://grafana.992382723408.realhandsonlabs.net/d/bakstg-nodejs-demo2-dashboard","argocd/app-name":"bakstg-nodejs-demo2","backstage.io/orphan":"true"},"name":"bakstg-nodejs-demo2","description":"Node.js 20 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs","tags":["microservice","k8s","sonarqube","prometheus","fluentd","loki","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/bakstg-nodejs-demo2","title":"GitHub Source Code","icon":"github"},{"url":"http://grafana.992382723408.realhandsonlabs.net/d/bakstg-nodejs-demo2-dashboard","title":"Grafana Dashboard","icon":"dashboard"},{"url":"http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=bakstg-nodejs-demo2","title":"SonarQube Quality Gate","icon":"check"}],"uid":"1e69ed9f-d832-487e-87d5-d2895168e30c","generation":1,"etag":"5d90175c1089dadd863a4c36f850aae933bc3b90"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026"},"relations":[{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('a2a75b30-567d-43eb-947a-760437c05894', '881065ff09de4e2996a6b4291aee1b15a1d2a75c', '69499a8a-e29e-4602-b57b-7a1d17fcda68', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"guest","uid":"a2a75b30-567d-43eb-947a-760437c05894","generation":1,"etag":"881065ff09de4e2996a6b4291aee1b15a1d2a75c"},"apiVersion":"backstage.io/v1alpha1","kind":"User","spec":{"profile":{"displayName":"Guest User","email":"guest@empresa.local"},"memberOf":["platform-team"]},"relations":[{"type":"memberOf","target":{"kind":"group","namespace":"default","name":"platform-team"}}]}');
INSERT INTO public.final_entities VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'c2ecb333fb918e58c01b16c409923f51a348145a', '8b010a2a-715f-43aa-bdfe-d29e212cedaa', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/blob/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/","github.com/project-slug":"cirodasilvaj/bkstg-made-nodejs-demo22","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"bkstg-made-nodejs-demo22","backstage.io/kubernetes-id":"bkstg-made-nodejs-demo22","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"bkstg-made-nodejs-demo22","grafana/tag-selector":"service:bkstg-made-nodejs-demo22","grafana/overview-dashboard":"http://grafana.992382723408.realhandsonlabs.net/d/bkstg-made-nodejs-demo22-dashboard","argocd/app-name":"bkstg-made-nodejs-demo22"},"name":"bkstg-made-nodejs-demo22","description":"Node.js 20 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs","tags":["microservice","k8s","sonarqube","prometheus","fluentd","loki","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22","title":"GitHub Source Code","icon":"github"},{"url":"http://grafana.992382723408.realhandsonlabs.net/d/bkstg-made-nodejs-demo22-dashboard","title":"Grafana Dashboard","icon":"dashboard"},{"url":"http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=bkstg-made-nodejs-demo22","title":"SonarQube Quality Gate","icon":"check"}],"uid":"32a660f9-efac-45f3-97c8-41f32ed8d97f","generation":1,"etag":"c2ecb333fb918e58c01b16c409923f51a348145a"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026"},"relations":[{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('fc8e7ab4-869c-4e8b-813a-1f4cf99340b4', '2a4e3220a07be8b4161557a1300c44b6c6a402bb', '3a3e7081-3da5-4eba-b8ad-1594c04e40c4', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-73a2399a7c2024519f325ee2a4e98268e82758b7","uid":"fc8e7ab4-869c-4e8b-813a-1f4cf99340b4","generation":1,"etag":"2a4e3220a07be8b4161557a1300c44b6c6a402bb"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/floci-localstack-aws/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/floci-localstack-aws/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/floci-localstack-aws/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/floci-localstack-aws/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/floci-localstack-aws/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('8ddbcbb3-b67c-4c1d-9853-a9bb8b31d346', 'd47ef316efa42609321af63ffdc5f691c9fbdb62', '5daa48a5-e533-433f-95c2-e375532b7a7a', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/"},"name":"generated-64bf0f42f04286e509e88978a740e76f33a6cc2a","uid":"8ddbcbb3-b67c-4c1d-9853-a9bb8b31d346","generation":1,"etag":"d47ef316efa42609321af63ffdc5f691c9fbdb62"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('507739a8-3ff8-4533-b9b3-abf0205f6d0c', 'a295028a27473bce154e02765da2c4f674e1911b', '845cca06-cffe-4bd8-accb-a9e625e18da7', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-03b13b5fb17fe9a670e36e235ad81fd06fcfd666","uid":"507739a8-3ff8-4533-b9b3-abf0205f6d0c","generation":1,"etag":"a295028a27473bce154e02765da2c4f674e1911b"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/setup-ambiente/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/a360-business/setup-ambiente/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/setup-ambiente/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/setup-ambiente/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/setup-ambiente/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'a1a75ca3319b058133f4877b0881ec223ebb6d8e', '47dcc2b4-f1bf-4174-8c98-a7a1c3acffaa', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"kube-demo-2026","description":"AWS EKS 1.35 Platform, GitOps, Observability & Developer Portal","uid":"605f8bb8-29f1-4f08-8571-2a92ee8520c4","generation":1,"etag":"a1a75ca3319b058133f4877b0881ec223ebb6d8e"},"apiVersion":"backstage.io/v1alpha1","kind":"System","spec":{"owner":"platform-team"},"relations":[{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"argocd"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"backstage-portal"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"bakstg-nodejs-demo2"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"bkstg-made-nodejs-demo22"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"grafana"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"prometheus"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"scaffolder-starter-microservice"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"sonarqube"}},{"type":"hasPart","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}}]}');
INSERT INTO public.final_entities VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', '7902a6b0f3b6559ab703a93bc5c817aa003afbed', '902e0a75-1de3-4e22-8a44-006605f1aa47', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/","github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"samba-ad-keycloak","backstage.io/kubernetes-id":"keycloak-sso","backstage.io/kubernetes-namespace":"default","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"samba-ad-keycloak"},"name":"keycloak-sso","description":"Servidor Keycloak IAM (Broker SAML 2.0, OAuth2 e OIDC) federado via LDAP ao Samba 4 AD para autenticar Backstage, ArgoCD, Grafana e Apps Demo","tags":["keycloak","saml2","oidc","sso","mfa"],"links":[{"url":"https://github.com/cirodasilvaj/samba-ad-keycloak","title":"GitHub Source Code","icon":"github"},{"url":"http://sso.992382723408.realhandsonlabs.net","title":"Keycloak SSO Realm","icon":"web"},{"url":"http://sso.992382723408.realhandsonlabs.net/admin","title":"Keycloak Admin Console","icon":"admin"},{"url":"http://sso.992382723408.realhandsonlabs.net/realms/empresa/.well-known/openid-configuration","title":"OIDC Discovery Configuration","icon":"lock"},{"url":"http://sso.992382723408.realhandsonlabs.net/realms/empresa/protocol/saml/descriptor","title":"SAML 2.0 Metadata Descriptor","icon":"lock"}],"uid":"c8b70617-2a07-4099-aa00-3e429fc52c3f","generation":1,"etag":"7902a6b0f3b6559ab703a93bc5c817aa003afbed"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","dependsOn":["component:default/samba-ad-dc","component:default/freeradius-mfa"],"providesApis":["saml-idp-api","oidc-idp-api"]},"relations":[{"type":"dependsOn","target":{"kind":"component","namespace":"default","name":"freeradius-mfa"}},{"type":"dependsOn","target":{"kind":"component","namespace":"default","name":"samba-ad-dc"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}},{"type":"providesApi","target":{"kind":"api","namespace":"default","name":"oidc-idp-api"}},{"type":"providesApi","target":{"kind":"api","namespace":"default","name":"saml-idp-api"}}]}');
INSERT INTO public.final_entities VALUES ('8ffa28bf-4525-474c-a0ea-275e2329fcdf', '118c10265b9d5c74543eeb251a85fcba75e79360', '2259cc59-31ca-4671-96fd-75e1414fae87', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-39540a08be0bcb5645ee1d683b08d860953c5b44","uid":"8ffa28bf-4525-474c-a0ea-275e2329fcdf","generation":1,"etag":"118c10265b9d5c74543eeb251a85fcba75e79360"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/scripts1/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/scripts1/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/scripts1/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/scripts1/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/scripts1/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', '9fdfa0ecb0d95755fb7243daa9ec2f2c708d585e', '4e25e0cd-e488-4d72-89d1-d69ada49af19', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/"},"name":"dotnet-sonarqube-cicd-template","title":".NET 8 C# Web App + CI/CD with QA, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete .NET 8 C# Minimal API repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki logging, and Backstage manifest.","tags":["dotnet","csharp","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"e08f1151-4161-404e-a9ef-f86e9166e3b4","generation":1,"etag":"9fdfa0ecb0d95755fb7243daa9ec2f2c708d585e"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"dotnet-csharp-app-demo"},"description":{"title":"Description","type":"string","description":"What does this microservice do?","default":".NET 8 C# microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"dotnet-csharp-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"{{ parameters.component_id }}","description":"{{ parameters.description }}","owner":"{{ parameters.owner }}","system":"{{ parameters.system }}","destinationOwner":"{{ parameters.destinationOwner }}"}}},{"id":"publish","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"{{ parameters.description }}","repoUrl":"github.com?owner={{ parameters.destinationOwner }}&repo={{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"{{ steps.publish.output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"{{ steps.publish.output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"{{ steps.register.output.entityRef }}"}]}},"relations":[{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"squad-plataforma"}}]}');
INSERT INTO public.final_entities VALUES ('2abb648f-f7cb-48dc-996f-4feb9f4778fe', 'd0268eb5ac77382eb31482eeb1ed0adc96ffb7db', '8fd53e98-4536-4158-93e6-08be0a493ae9', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-8f44ff1b0eee905e4f10b347f2f4cde12c6ecb91","uid":"2abb648f-f7cb-48dc-996f-4feb9f4778fe","generation":1,"etag":"d0268eb5ac77382eb31482eeb1ed0adc96ffb7db"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/MoreiraThi87/galeed-community/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/MoreiraThi87/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/MoreiraThi87/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/MoreiraThi87/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/MoreiraThi87/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('85ae82e4-e930-46a4-b3e7-26a9ad047a6f', 'a6ece88a3a2d1b03dd58cd0a556f84bda2ab61f8', '6ebc6d93-b6e0-4bc2-908a-2303456bda9f', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-623b5bbb8262e0696340d3ea541298687d0b3e21","uid":"85ae82e4-e930-46a4-b3e7-26a9ad047a6f","generation":1,"etag":"a6ece88a3a2d1b03dd58cd0a556f84bda2ab61f8"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/demo-microservice-backstage-2026/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/demo-microservice-backstage-2026/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/demo-microservice-backstage-2026/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/demo-microservice-backstage-2026/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/demo-microservice-backstage-2026/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('f455ce50-afa5-469e-ba70-803fcd20ff43', '5d8edb51b7d0a6f40ef7fa94869e69ab84f17776', '2888d02e-10fe-4be0-bfce-59edbb9f6f80', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/"},"name":"generated-6a784c45d310bbbb8ae6d987a8a58e15ee836489","uid":"f455ce50-afa5-469e-ba70-803fcd20ff43","generation":1,"etag":"5d8edb51b7d0a6f40ef7fa94869e69ab84f17776"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('f4d59911-2200-4c72-b99e-819df59d7610', '68e183db23c10b87c11d324057371235db6d2314', '81788d8f-74fd-4eb0-931c-1a6a8ac044ea', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-aea2074c195831a31fb8d1acdfcfd9ae7d08cd1b","uid":"f4d59911-2200-4c72-b99e-819df59d7610","generation":1,"etag":"68e183db23c10b87c11d324057371235db6d2314"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/bot-dermatologia-mattos/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/bot-dermatologia-mattos/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/bot-dermatologia-mattos/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/bot-dermatologia-mattos/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/bot-dermatologia-mattos/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('6983d607-a250-48aa-ade6-997553435d79', '740fb3a971b8423a331105c403917f8b31f54295', '275cc9bc-2257-4730-bac2-a93cfb3abf61', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/microservice-template/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/"},"name":"generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98","uid":"6983d607-a250-48aa-ade6-997553435d79","generation":1,"etag":"740fb3a971b8423a331105c403917f8b31f54295"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('7c3a0812-4f6f-43f5-b7ba-15254e07e374', '1ee0bfcf904a7e9669c26a83034abb5722e5b40d', 'cbd87192-b542-4a61-b69e-cd0e414ad418', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/"},"name":"generated-7692b664b197d2303b0a28bb177c1b133773311c","uid":"7c3a0812-4f6f-43f5-b7ba-15254e07e374","generation":1,"etag":"1ee0bfcf904a7e9669c26a83034abb5722e5b40d"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', '9ae0cf29fab03155d8a829cf0868a156b6e70b5f', '52fe7085-a69c-4b45-98a3-b162e51b9cb9', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/"},"name":"nodejs-sonarqube-cicd-template","title":"Node.js 20 Web App + CI/CD with SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Node.js 20 microservice repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki JSON logs, and Backstage manifest.","tags":["node","nodejs","javascript","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"cbf1609f-cb2c-4a1f-8241-d19ef4075bf7","generation":1,"etag":"9ae0cf29fab03155d8a829cf0868a156b6e70b5f"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"nodejs-app-demo"},"description":{"title":"Description","type":"string","description":"What does this Node.js microservice do?","default":"Node.js 20 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"nodejs-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"{{ parameters.component_id }}","description":"{{ parameters.description }}","owner":"{{ parameters.owner }}","system":"{{ parameters.system }}","destinationOwner":"{{ parameters.destinationOwner }}"}}},{"id":"publish","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"{{ parameters.description }}","repoUrl":"github.com?owner={{ parameters.destinationOwner }}&repo={{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"{{ steps.publish.output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"{{ steps.publish.output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"{{ steps.register.output.entityRef }}"}]}},"relations":[{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"squad-plataforma"}}]}');
INSERT INTO public.final_entities VALUES ('a9695418-4b02-4a0b-bcb4-c58faab06eb8', '8fcfc225fbb92e9d492c23b925875cb4f6d5311a', '99bcc582-5063-4e06-b02f-2a32f3f8b6e4', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/scaffolder-starter-microservice/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/","backstage.io/orphan":"true"},"name":"generated-d39e9e69bdff92426a0ef516ba3b7a18205f9ddc","uid":"a9695418-4b02-4a0b-bcb4-c58faab06eb8","generation":1,"etag":"8fcfc225fbb92e9d492c23b925875cb4f6d5311a"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'cd2de5175089933744346268b9cee4f78274ac97', '660009ee-1d67-4f99-8d6d-93e312684ecc', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/scaffolder-starter-microservice/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/","github.com/project-slug":"cirodasilvaj/scaffolder-starter-microservice","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"scaffolder-starter-microservice","backstage.io/kubernetes-id":"scaffolder-starter-microservice","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"scaffolder-starter-microservice","grafana/tag-selector":"service:scaffolder-starter-microservice","grafana/overview-dashboard":"http://grafana.992382723408.realhandsonlabs.net/d/scaffolder-starter-microservice-dashboard","argocd/app-name":"scaffolder-starter-microservice"},"name":"scaffolder-starter-microservice","description":"Scaffolder starter microservice created from Backstage IDP","tags":["microservice","k8s","sonarqube","prometheus","fluentd","loki","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/scaffolder-starter-microservice","title":"GitHub Source Code","icon":"github"},{"url":"http://grafana.992382723408.realhandsonlabs.net/d/scaffolder-starter-microservice-dashboard","title":"Grafana Dashboard","icon":"dashboard"},{"url":"http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=scaffolder-starter-microservice","title":"SonarQube Quality Gate","icon":"check"}],"uid":"dd98330a-009c-413f-9dc6-69b7b3b045f2","generation":1,"etag":"cd2de5175089933744346268b9cee4f78274ac97"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026"},"relations":[{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('2ddb3e60-40cf-4844-8e24-b7413752f9f3', 'f35f97f47b6ca8904232277a23d1513dfeb61b62', '77006039-34be-4ed4-a221-fa05da336d0f', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-47a88091bb52dcb96cc116a938257ca203c6cf66","uid":"2ddb3e60-40cf-4844-8e24-b7413752f9f3","generation":1,"etag":"f35f97f47b6ca8904232277a23d1513dfeb61b62"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/blob/main/catalog-info.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', '573a616ca9bbc01955b2772ccaf83f541b7cab98', '7031b5e0-b6e3-433a-afcc-a6a9dac5375e', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/"},"name":"apps-demo-2026","title":"Apps Demo 2026 Ecosystem","description":"Microservices Demo Collection (Python 3.12 Flask, .NET 8 C# Minimal API) with CI/CD, SonarQube, Prometheus Metrics, Fluentd/Loki Logs, GitOps via ArgoCD and HTTPS via AWS ACM.","uid":"da0ddf52-10a0-4392-b061-72d5576c80db","generation":1,"etag":"573a616ca9bbc01955b2772ccaf83f541b7cab98"},"apiVersion":"backstage.io/v1alpha1","kind":"System","spec":{"owner":"platform-team"},"relations":[{"type":"hasPart","target":{"kind":"api","namespace":"default","name":"dotnet-csharp-app-api"}},{"type":"hasPart","target":{"kind":"api","namespace":"default","name":"python-app-api"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"dotnet-csharp-demo-app"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"python-demo-app"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}}]}');
INSERT INTO public.final_entities VALUES ('96a807de-0f76-4a71-b1d2-fbb244ee6678', '1ad602f57f07171409cc141bb160f009865b9952', '392c2fd5-4b9d-447f-ac2a-b80055d2895e', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-83f2543400bad694b3b4169b8f0dda74347f09ca","uid":"96a807de-0f76-4a71-b1d2-fbb244ee6678","generation":1,"etag":"1ad602f57f07171409cc141bb160f009865b9952"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/talerelayapp/superfria/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/talerelayapp/superfria/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/talerelayapp/superfria/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/talerelayapp/superfria/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/talerelayapp/superfria/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', '0d25c92c1e4fb7842172f8efd29945fdc97ebc7b', 'bf1cfcc6-f06c-4a0f-baa6-5eed564a48d5', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/"},"name":"python-app-api","title":"Python Flask App REST API","description":"Interface REST para consulta de status, saúde e telemetria da aplicação Python","uid":"8b395fb2-b486-4e7c-ac0c-9b9ef49b608e","generation":1,"etag":"0d25c92c1e4fb7842172f8efd29945fdc97ebc7b"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Python App API\n  version: \"1.0.0\"\npaths:\n  /:\n    get:\n      summary: Overview & HTML Dashboard\n      responses:\n        ''200'':\n          description: OK\n  /api/info:\n    get:\n      summary: System & client runtime information\n      responses:\n        ''200'':\n          description: OK\n  /healthz:\n    get:\n      summary: Liveness probe\n      responses:\n        ''200'':\n          description: OK\n  /ready:\n    get:\n      summary: Readiness probe\n      responses:\n        ''200'':\n          description: OK\n  /metrics:\n    get:\n      summary: Prometheus metrics\n      responses:\n        ''200'':\n          description: OK\n"},"relations":[{"type":"apiProvidedBy","target":{"kind":"component","namespace":"default","name":"python-demo-app"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"apps-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('e5835291-d759-408a-b161-43106ca035df', 'eb22c651c01f726dc43e88e593e008c09ed677c9', '0ab5a730-de76-4eec-b37e-436a9ba2f8a5', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/"},"name":"generated-e1e842392fd0da6efe989d25722f835228d60e05","uid":"e5835291-d759-408a-b161-43106ca035df","generation":1,"etag":"eb22c651c01f726dc43e88e593e008c09ed677c9"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('9877515a-425a-46df-9c60-2286fb06abda', 'a0da15a8fc4ab7a813f243103df5136339732042', '5ac5a827-fef0-4d55-b293-0d9835e639f0', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/"},"name":"generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a","uid":"9877515a-425a-46df-9c60-2286fb06abda","generation":1,"etag":"a0da15a8fc4ab7a813f243103df5136339732042"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'd5e561ff5a68d06fe819ac735269541418c7cedc', '719efbaf-1ea1-4b04-8094-27590dd37456', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/microservice-template/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/"},"name":"standard-microservice-template","title":"Standard Microservice with CI/CD, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a ready-to-use repository with a test pipeline, SonarQube Quality Gate validation, Prometheus metrics, Fluentd/Loki logging, and Backstage manifest.","tags":["node","python","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"b336ba83-2423-4731-895e-6cdfacb64bce","generation":1,"etag":"d5e561ff5a68d06fe819ac735269541418c7cedc"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$"},"description":{"title":"Description","type":"string","description":"What does this microservice do?"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"microservice-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"{{ parameters.component_id }}","description":"{{ parameters.description }}","owner":"{{ parameters.owner }}","system":"{{ parameters.system }}","destinationOwner":"{{ parameters.destinationOwner }}"}}},{"id":"publish","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"{{ parameters.description }}","repoUrl":"github.com?owner={{ parameters.destinationOwner }}&repo={{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"{{ steps.publish.output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"{{ steps.publish.output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"{{ steps.register.output.entityRef }}"}]}},"relations":[{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"squad-plataforma"}}]}');
INSERT INTO public.final_entities VALUES ('c21e2a4f-66b6-42fa-8d52-8c654775fb77', 'a92864f60df8d62eaa291a8aa17b246b5a23fcb5', 'ac851fba-178e-42b6-8c16-a662e36df58b', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/"},"name":"generated-689c18882dc297803e1a420c73b8783d094c8e17","uid":"c21e2a4f-66b6-42fa-8d52-8c654775fb77","generation":1,"etag":"a92864f60df8d62eaa291a8aa17b246b5a23fcb5"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'f8be2483c15d1c70d1f75d8d17bd4b7bd80fabee', 'dbad0d7c-62fd-4c00-8845-74d5916fdecc', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/","github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"samba-ad-keycloak","backstage.io/kubernetes-id":"samba-ad-dc","backstage.io/kubernetes-namespace":"default","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"samba-ad-keycloak"},"name":"samba-ad-dc","description":"Samba 4 Active Directory Multi-DC (DC1 Principal + DC2 Réplica em Multi-AZ com --dns-backend=NONE e Route 53 Private Hosted Zone)","tags":["samba4","active-directory","ldap","kerberos","route53"],"links":[{"url":"https://github.com/cirodasilvaj/samba-ad-keycloak","title":"GitHub Source Code","icon":"github"}],"uid":"7df42e7c-cdc7-4f6f-853b-4ecd0335e728","generation":1,"etag":"f8be2483c15d1c70d1f75d8d17bd4b7bd80fabee"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","providesApis":["ldap-ad-api"]},"relations":[{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"freeradius-mfa"}},{"type":"dependencyOf","target":{"kind":"component","namespace":"default","name":"keycloak-sso"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}},{"type":"providesApi","target":{"kind":"api","namespace":"default","name":"ldap-ad-api"}}]}');
INSERT INTO public.final_entities VALUES ('66576428-ff82-4dc3-914e-6988c6259d76', '40a1352ab6b5b372ca67cbc0ea5ce77716279612', 'c0432287-2329-44fe-8577-d625f68f15e9', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-5c9e4afea8ffa75fba62cb03ab309d31fd5b98b3","uid":"66576428-ff82-4dc3-914e-6988c6259d76","generation":1,"etag":"40a1352ab6b5b372ca67cbc0ea5ce77716279612"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-permission-test-1793652634586/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/backstage-permission-test-1793652634586/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/backstage-permission-test-1793652634586/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/backstage-permission-test-1793652634586/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/backstage-permission-test-1793652634586/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('5a3770b1-36ac-439b-aae7-ad1e1c6f7a93', '00ea1f13ce002d87d138e0c3daa87184333f97a0', '8fe5a840-72ff-4468-81a2-f6810a55b2c0', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/"},"name":"generated-b4f29ca1863623b0dea4276cfa3970b897899c36","uid":"5a3770b1-36ac-439b-aae7-ad1e1c6f7a93","generation":1,"etag":"00ea1f13ce002d87d138e0c3daa87184333f97a0"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('57242473-b776-432c-bb75-f28c61301137', 'f568e373a615b1a6ce3370884e366bb52b3809de', '5d489e1c-5dfc-425e-bb85-7d30793efce3', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-3a49cafceb0ae80411060ab243ac7adf4cb8101e","uid":"57242473-b776-432c-bb75-f28c61301137","generation":1,"etag":"f568e373a615b1a6ce3370884e366bb52b3809de"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/backstage-infra/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/backstage-infra/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/backstage-infra/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/backstage-infra/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('569b86ee-0b91-4986-b3fb-639450e8e556', 'bcac755ca11dc5cd493fc256489aa6e01dabd4d5', 'c475d30d-a460-4def-88f2-5a2c1998d10d', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-0bc5455adc5c6e2724b4409f7f4382f145a48c31","uid":"569b86ee-0b91-4986-b3fb-639450e8e556","generation":1,"etag":"bcac755ca11dc5cd493fc256489aa6e01dabd4d5"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/scaffolder-starter-microservice/blob/main/catalog-info.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('5c335bb9-eb33-4dcb-8cdf-e02df2c7830a', '83dcf7a31af308557959864008eaffd923c34ebc', '0bb281c6-ff76-4472-b2b6-f013e308f6a2', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-702a36957042d54fefb74573b3f2079c194a1849","uid":"5c335bb9-eb33-4dcb-8cdf-e02df2c7830a","generation":1,"etag":"83dcf7a31af308557959864008eaffd923c34ebc"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/test-repo-check-permission/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/test-repo-check-permission/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/test-repo-check-permission/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/test-repo-check-permission/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/test-repo-check-permission/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('8ba49820-4112-4d3f-ac91-d708ed64c6f6', 'e4a723b0f625af9fb40e991f06f193a3793b02f8', 'd14c2380-ede8-4cb3-a65e-4119b3aaf839', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-d6eb614c9d4a9daaeb84a95d3fece1a6a0dd9916","uid":"8ba49820-4112-4d3f-ac91-d708ed64c6f6","generation":1,"etag":"e4a723b0f625af9fb40e991f06f193a3793b02f8"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirobessa/kube-demo-2026/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirobessa/kube-demo-2026/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirobessa/kube-demo-2026/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirobessa/kube-demo-2026/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirobessa/kube-demo-2026/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('d70d519d-0082-403b-83f7-d3028813f332', '0c63fa37d95497ec49fa9a90b18f6cdb03d2ca31', '42f0b56f-0fcd-4454-8d1d-20ae9a027ea2', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"generated-230c2622c092081637053d0a834587aef4c2bae2","uid":"d70d519d-0082-403b-83f7-d3028813f332","generation":1,"etag":"0c63fa37d95497ec49fa9a90b18f6cdb03d2ca31"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('d156834d-2957-4c7b-a60b-473c61a84906', 'bde977db5dc9a6e86e7d0f9391d0283687dd1f1f', 'dd35cc09-80b1-4c36-9a68-343d1a52d87d', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-e40d9e847bb90a7610522a0d467185a8e079bb3e","uid":"d156834d-2957-4c7b-a60b-473c61a84906","generation":1,"etag":"bde977db5dc9a6e86e7d0f9391d0283687dd1f1f"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/openclaw-setup/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/a360-business/openclaw-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/openclaw-setup/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/openclaw-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/openclaw-setup/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('cbacfd61-8a1a-4914-ba7e-2a8563bbad45', 'aca571c3ffb15968b20dba7cd9a4e685f967ca16', '283f460f-1218-4191-8e76-e5f21463d75e', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-1f8726637b31d8323de2ea178b5ccd8c303f90fa","uid":"cbacfd61-8a1a-4914-ba7e-2a8563bbad45","generation":1,"etag":"aca571c3ffb15968b20dba7cd9a4e685f967ca16"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/mesa-agents/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/mesa-agents/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/mesa-agents/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/mesa-agents/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/mesa-agents/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('28d415d5-684c-4e90-822c-39112ab6a4a2', 'd48b8218f9cafdf70d42d7b5b0b43f7da7948a32', 'e68d921e-e5b3-4a9c-b9db-37e442a05d85', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-796712c88a485ec71e012b5c5f4566412a5f5672","uid":"28d415d5-684c-4e90-822c-39112ab6a4a2","generation":1,"etag":"d48b8218f9cafdf70d42d7b5b0b43f7da7948a32"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/growth-os-skills-full/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/a360-business/growth-os-skills-full/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/growth-os-skills-full/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/growth-os-skills-full/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/growth-os-skills-full/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', '0b5a58e2c302b73ba233b2a2ccbade76a540037e', 'c2516e8a-c3b8-4f9c-864f-1f6409e21511', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"platform-team","description":"Platform Engineering & DevEx Team","uid":"568dc919-f18e-45a0-950c-e431c5a533a5","generation":1,"etag":"0b5a58e2c302b73ba233b2a2ccbade76a540037e"},"apiVersion":"backstage.io/v1alpha1","kind":"Group","spec":{"type":"team","children":[],"members":["guest"]},"relations":[{"type":"hasMember","target":{"kind":"user","namespace":"default","name":"guest"}},{"type":"ownerOf","target":{"kind":"api","namespace":"default","name":"dotnet-csharp-app-api"}},{"type":"ownerOf","target":{"kind":"api","namespace":"default","name":"ldap-ad-api"}},{"type":"ownerOf","target":{"kind":"api","namespace":"default","name":"oidc-idp-api"}},{"type":"ownerOf","target":{"kind":"api","namespace":"default","name":"python-app-api"}},{"type":"ownerOf","target":{"kind":"api","namespace":"default","name":"radius-mfa-api"}},{"type":"ownerOf","target":{"kind":"api","namespace":"default","name":"saml-idp-api"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"argocd"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"backstage-portal"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"bakstg-nodejs-demo2"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"bkstg-made-nodejs-demo22"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"dotnet-csharp-demo-app"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"freeradius-mfa"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"grafana"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"keycloak-sso"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"prometheus"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"python-demo-app"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"samba-ad-dc"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"scaffolder-starter-microservice"}},{"type":"ownerOf","target":{"kind":"component","namespace":"default","name":"sonarqube"}},{"type":"ownerOf","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownerOf","target":{"kind":"system","namespace":"default","name":"apps-demo-2026"}},{"type":"ownerOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}},{"type":"ownerOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}}]}');
INSERT INTO public.final_entities VALUES ('328bd867-6b9c-4be1-a096-00f817eecbc1', 'e48e1edf06895444a35d5edc0f213c7c2bfbf01e', 'fbdbefb3-6a8d-4723-83a4-d300cae78667', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-bcfe70fc389b7b6f55a5728ad12e48fbb12a7627","uid":"328bd867-6b9c-4be1-a096-00f817eecbc1","generation":1,"etag":"e48e1edf06895444a35d5edc0f213c7c2bfbf01e"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/zoeiroka-automacoes/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/zoeiroka-automacoes/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/zoeiroka-automacoes/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/zoeiroka-automacoes/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/zoeiroka-automacoes/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('af5d5b44-ad56-4ccb-945a-d9f92fc651e6', '4134b71404fb6cacedbeef6a85c764eddcbc3e0a', 'c05cefd5-d512-44bf-b598-b65844265ada', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-fe0f1bf72ec2879f9e6e9673b75d2a1f020b3878","uid":"af5d5b44-ad56-4ccb-945a-d9f92fc651e6","generation":1,"etag":"4134b71404fb6cacedbeef6a85c764eddcbc3e0a"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/galeed-community/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/a360-business/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', '8490d22ced01d4317b26c268f0030cbb3b5ac303', '537314f4-8391-485f-b635-fd0670545611', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"oidc-idp-api","description":"Endpoint OpenID Connect (OIDC) Discovery do Keycloak (sso.empresa.local)","uid":"c0d72379-16b6-4e8a-8d49-1f327ef118b2","generation":1,"etag":"8490d22ced01d4317b26c268f0030cbb3b5ac303"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Keycloak OIDC Discovery API\n  version: \"1.0.0\"\npaths:\n  /realms/empresa/.well-known/openid-configuration:\n    get:\n      summary: Retorna a configuracao OIDC do Realm empresa\n      responses:\n        \"200\":\n          description: OIDC Discovery JSON\n"},"relations":[{"type":"apiProvidedBy","target":{"kind":"component","namespace":"default","name":"keycloak-sso"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}}]}');
INSERT INTO public.final_entities VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', '98c4ba7e77dcd5b70a2683edd25079aa4b08c8b2', '09ce9edf-983a-486d-8f61-e7abd052a937', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","github.com/project-slug":"cirobessa/kube-demo-2026","backstage.io/kubernetes-id":"sonarqube","backstage.io/kubernetes-namespace":"sonarqube"},"name":"sonarqube","title":"SonarQube Code Quality","description":"SonarQube QA & Security Scanner on EKS (OWASP Dependency-Check, FindSecBugs & YAML/K8s Security plugins)","links":[{"url":"http://sonarqube.992382723408.realhandsonlabs.net","title":"SonarQube Dashboard UI","icon":"check"},{"url":"https://github.com/cirobessa/kube-demo-2026","title":"SonarQube QA Config","icon":"github"}],"uid":"01edbf6e-da27-4e26-a028-e62fa0cbc5b6","generation":1,"etag":"98c4ba7e77dcd5b70a2683edd25079aa4b08c8b2"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('cd28be50-4ca3-4f8b-9f46-7373e1e92545', 'aee474ff2825a02cc592a2ef24271e71d9b88bf1', '43c927a6-3b7b-4dab-bcc2-3ea572d766cf', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-b44b1f6c085e8ca890654a6f6755902d78d4c46b","uid":"cd28be50-4ca3-4f8b-9f46-7373e1e92545","generation":1,"etag":"aee474ff2825a02cc592a2ef24271e71d9b88bf1"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/vini-brito/growth-os-skills-full/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/vini-brito/growth-os-skills-full/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/vini-brito/growth-os-skills-full/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/vini-brito/growth-os-skills-full/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/vini-brito/growth-os-skills-full/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'ed6eb079832eb5f88abb37b9cfca4338ba92d755', '8d583cb1-ad97-429f-90d4-cbc2817f6410', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"ldap-ad-api","description":"Endpoint LDAP/LDAPS Round-Robin do Samba 4 AD (ldap://ad.empresa.local:389)","uid":"ff3f673b-6c22-41eb-a709-e5ea84b5191c","generation":1,"etag":"ed6eb079832eb5f88abb37b9cfca4338ba92d755"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"grpc","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"syntax = \"proto3\";\nservice ActiveDirectoryLDAP {\n  // ldap://ad.empresa.local:389 (Round-Robin DC1 & DC2)\n  // Base DN: DC=empresa,DC=local\n}\n"},"relations":[{"type":"apiProvidedBy","target":{"kind":"component","namespace":"default","name":"samba-ad-dc"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}}]}');
INSERT INTO public.final_entities VALUES ('00d94013-0f3e-4bf6-b6fc-c3a793e7472f', 'a457cc0a3b154de879e72de31980eb013f9dbc55', '93febade-3247-48cd-9dcd-b8365629249e', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-31a0877ed2bec2edf4feee46dd4161a60585d1ce","uid":"00d94013-0f3e-4bf6-b6fc-c3a793e7472f","generation":1,"etag":"a457cc0a3b154de879e72de31980eb013f9dbc55"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', '62c71aac115494b3b7cc49d7633b29c27627c448', '86713940-549a-4816-a622-84daf2ca1943', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"saml-idp-api","description":"Endpoint SAML 2.0 Identity Provider do Keycloak (sso.empresa.local)","uid":"ac68373a-af16-4be0-b0c3-5ffdf40e00fb","generation":1,"etag":"62c71aac115494b3b7cc49d7633b29c27627c448"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Keycloak SAML 2.0 IdP Descriptor\n  version: \"1.0.0\"\npaths:\n  /realms/empresa/protocol/saml/descriptor:\n    get:\n      summary: Retorna o XML de metadados SAML 2.0 do Realm empresa\n      responses:\n        \"200\":\n          description: SAML 2.0 Metadata XML\n"},"relations":[{"type":"apiProvidedBy","target":{"kind":"component","namespace":"default","name":"keycloak-sso"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"samba-ad-keycloak-iam"}}]}');
INSERT INTO public.final_entities VALUES ('1503a318-6894-4f0d-b372-0a31b1d954a9', 'f128c87581e0f4b028aac4bb13d8d5687a0a6f25', '003e2566-7ff1-426b-849b-1957fd41950d', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-c377ebbfb933b0a54dfd0e158734712e21979bde","uid":"1503a318-6894-4f0d-b372-0a31b1d954a9","generation":1,"etag":"f128c87581e0f4b028aac4bb13d8d5687a0a6f25"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/FernandoNesi/galeed-community/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/FernandoNesi/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/FernandoNesi/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/FernandoNesi/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/FernandoNesi/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('8f54f8c6-eb39-4b4b-a6e2-e1ada1f5c15d', '1be6e3a6d170101daa9fc8144e6acd36ede7320e', '9286cbeb-ba10-438b-802f-5506df89ca97', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/"},"name":"generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce","uid":"8f54f8c6-eb39-4b4b-a6e2-e1ada1f5c15d","generation":1,"etag":"1be6e3a6d170101daa9fc8144e6acd36ede7320e"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml"},"relations":[]}');
INSERT INTO public.final_entities VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'a6e083947fdff84d2e90ae43bb5d56b38d1a17dc', 'd6ae0606-9479-422d-aa3b-e825839c9819', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","github.com/project-slug":"cirobessa/kube-demo-2026","backstage.io/kubernetes-id":"prometheus","backstage.io/kubernetes-namespace":"monitoring","backstage.io/kubernetes-label-selector":"app.kubernetes.io/name=prometheus"},"name":"prometheus","title":"Prometheus Monitoring","description":"Prometheus Metrics Server & Node Exporter on EKS","links":[{"url":"http://prometheus.992382723408.realhandsonlabs.net","title":"Prometheus Web UI","icon":"gauge"},{"url":"https://github.com/cirobessa/kube-demo-2026","title":"Prometheus Manifests","icon":"github"}],"uid":"6ba147d5-0d04-487e-b400-98ebc3a32caf","generation":1,"etag":"a6e083947fdff84d2e90ae43bb5d56b38d1a17dc"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'a296908c8ee2821d258b2816cd23639db97b35b9', '831cfdf2-b3ca-4e0d-b1d9-5a7fe1590053', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","github.com/project-slug":"cirodasilvaj/backstage-infra","backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage"},"name":"backstage-portal","title":"Backstage Developer Portal","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","links":[{"url":"http://backstage.992382723408.realhandsonlabs.net","title":"Backstage Portal UI","icon":"dashboard"},{"url":"https://github.com/cirodasilvaj/backstage-infra","title":"GitHub Infrastructure Repo","icon":"github"}],"uid":"d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe","generation":1,"etag":"a296908c8ee2821d258b2816cd23639db97b35b9"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"website","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"kube-demo-2026"}}]}');
INSERT INTO public.final_entities VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', '8ac5a989d3799ffc69031605bd681d3db4bf0234', '38e91540-0cf3-4b31-9c65-3e5a0def371a', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"samba-ad-keycloak-iam","description":"Arquitetura Corporativa IAM na VPC do EKS (Samba 4 AD Multi-DC sem DNS interno + Route 53 Private Zone + FreeRADIUS MFA + Keycloak SAML 2.0 / OIDC)","uid":"39387fbf-9d96-40f7-baed-4dd4470abe8d","generation":1,"etag":"8ac5a989d3799ffc69031605bd681d3db4bf0234"},"apiVersion":"backstage.io/v1alpha1","kind":"System","spec":{"owner":"platform-team"},"relations":[{"type":"hasPart","target":{"kind":"api","namespace":"default","name":"ldap-ad-api"}},{"type":"hasPart","target":{"kind":"api","namespace":"default","name":"oidc-idp-api"}},{"type":"hasPart","target":{"kind":"api","namespace":"default","name":"radius-mfa-api"}},{"type":"hasPart","target":{"kind":"api","namespace":"default","name":"saml-idp-api"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"freeradius-mfa"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"keycloak-sso"}},{"type":"hasPart","target":{"kind":"component","namespace":"default","name":"samba-ad-dc"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}}]}');
INSERT INTO public.final_entities VALUES ('115a964d-41be-496c-ab7f-47b42064763f', 'd1436caea339c6e65e7cc570440eb4fd8f790288', 'a559eb31-6713-400b-bb37-afc123adc9c7', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-78a0f16f4da15640f067c17fea7b0935483fd142","uid":"115a964d-41be-496c-ab7f-47b42064763f","generation":1,"etag":"d1436caea339c6e65e7cc570440eb4fd8f790288"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/agent-foreman/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/a360-business/agent-foreman/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/agent-foreman/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/agent-foreman/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/agent-foreman/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'e1d300f93ddfeb9c4bde0d0c25291dc861272b20', '40bbc3b4-6adc-4b5f-a89c-1c9bc28159bf', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/"},"name":"jvm-springboot-sonarqube-cicd-template","title":"JVM Spring Boot (Java 21) + CI/CD with SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Java 21 / Spring Boot 3.3 microservice repository with Maven + JaCoCo tests, SonarQube Quality Gate (SpotBugs/FindSecBugs & OWASP), Prometheus /metrics, Fluentd -> Loki JSON logs, and Backstage manifest.","tags":["java","jvm","springboot","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"44041f68-9d66-4b71-86ac-5cd98a6bb212","generation":1,"etag":"e1d300f93ddfeb9c4bde0d0c25291dc861272b20"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"springboot-app-demo"},"description":{"title":"Description","type":"string","description":"What does this Spring Boot microservice do?","default":"JVM Spring Boot 3.3 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"springboot-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"{{ parameters.component_id }}","description":"{{ parameters.description }}","owner":"{{ parameters.owner }}","system":"{{ parameters.system }}","destinationOwner":"{{ parameters.destinationOwner }}"}}},{"id":"publish","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"{{ parameters.description }}","repoUrl":"github.com?owner={{ parameters.destinationOwner }}&repo={{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"{{ steps.publish.output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"{{ steps.publish.output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"{{ steps.register.output.entityRef }}"}]}},"relations":[{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"squad-plataforma"}}]}');
INSERT INTO public.final_entities VALUES ('6e55b9e8-2c65-4773-b863-2e77ce1ced96', 'afc6f48dc28eb6f63244ff7d50d622529f524ef4', '0a9f7142-43c1-4535-be62-51d487375afa', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-9a24efc486a6e189695017ff7d1ff5886f9498aa","uid":"6e55b9e8-2c65-4773-b863-2e77ce1ced96","generation":1,"etag":"afc6f48dc28eb6f63244ff7d50d622529f524ef4"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/hermes-backup-1-vid-agentes-repos/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/hermes-backup-1-vid-agentes-repos/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/hermes-backup-1-vid-agentes-repos/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/hermes-backup-1-vid-agentes-repos/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/hermes-backup-1-vid-agentes-repos/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', '972d574b3e02d9e3fbd65a100f44fb0a4569a62b', 'ba467175-5ee8-47ce-8414-74fd5086a305', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/","github.com/project-slug":"cirodasilvaj/apps-demo-2026","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"python-demo-app","grafana/tag-selector":"service:python-demo-app","grafana/overview-dashboard":"http://grafana.992382723408.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12","argocd/app-name":"python-app"},"name":"python-demo-app","title":"Python 3.12 Flask Microservice","description":"App Web em Python 3.12 (Flask) com Prometheus metrics, logs JSON para Grafana Loki, SonarQube Quality Gate, GitOps via ArgoCD e HTTPS via AWS ACM.","tags":["python","flask","sonarqube","prometheus","fluentd","loki","grafana","k8s","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app","title":"GitHub Source Code","icon":"github"},{"url":"http://python.992382723408.realhandsonlabs.net","title":"Python 3.12 Live App (HTTP)","icon":"web"},{"url":"https://python.992382723408.realhandsonlabs.net","title":"Python 3.12 Live App (HTTPS ACM)","icon":"lock"},{"url":"http://python.992382723408.realhandsonlabs.net/metrics","title":"Prometheus Metrics (/metrics)","icon":"gauge"},{"url":"http://grafana.992382723408.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12","title":"Grafana Dashboard (Golden Signals & Loki Logs)","icon":"dashboard"},{"url":"http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=apps-demo-2026","title":"SonarQube Quality Gate","icon":"check"},{"url":"https://argocd.992382723408.realhandsonlabs.net/applications/python-app","title":"ArgoCD GitOps","icon":"sync"}],"uid":"5d70a2d8-41a8-4321-b3e8-558a2769b323","generation":1,"etag":"972d574b3e02d9e3fbd65a100f44fb0a4569a62b"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","providesApis":["python-app-api"],"dependsOn":["resource:default/kube-demo-eks"]},"relations":[{"type":"dependsOn","target":{"kind":"resource","namespace":"default","name":"kube-demo-eks"}},{"type":"ownedBy","target":{"kind":"group","namespace":"default","name":"platform-team"}},{"type":"partOf","target":{"kind":"system","namespace":"default","name":"apps-demo-2026"}},{"type":"providesApi","target":{"kind":"api","namespace":"default","name":"python-app-api"}}]}');
INSERT INTO public.final_entities VALUES ('6dbef53c-6b33-461c-a885-773759651e58', 'b5a4670b13cfba41af49a32f6bb4acb4bceffd62', 'fa059801-6e70-45d9-8774-a2e211479288', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-edb107c0bf74b8a4c4c763787b54180b9801f99b","uid":"6dbef53c-6b33-461c-a885-773759651e58","generation":1,"etag":"b5a4670b13cfba41af49a32f6bb4acb4bceffd62"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/hermes-setup/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/a360-business/hermes-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/hermes-setup/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/hermes-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/hermes-setup/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');
INSERT INTO public.final_entities VALUES ('a0551093-7eae-45a6-bece-165c2dfdc2ea', 'd19c0e14e6783b23fca35a0f54d5db0110294291', 'e0e026c1-b179-48c0-9118-098ecb010901', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-024455ef88eaf59fbb3261fdaa8dd9c1095d1ac7","uid":"a0551093-7eae-45a6-bece-165c2dfdc2ea","generation":1,"etag":"d19c0e14e6783b23fca35a0f54d5db0110294291"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/test-direct-pod-call/blob/main/catalog-info.yaml"},"relations":[],"status":{"items":[{"type":"backstage.io/catalog-processing","level":"error","message":"NotFoundError: Unable to read url, NotFoundError: https://github.com/cirodasilvaj/test-direct-pod-call/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/test-direct-pod-call/contents/catalog-info.yaml?ref=main, 404 Not Found","error":{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/test-direct-pod-call/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/test-direct-pod-call/contents/catalog-info.yaml?ref=main, 404 Not Found"}}]}}');


--
-- Data for Name: knex_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.knex_migrations VALUES (1, '20200511113813_init.js', 1, '2026-11-02 19:53:46.972+00');
INSERT INTO public.knex_migrations VALUES (2, '20200520140700_location_update_log_table.js', 1, '2026-11-02 19:53:46.982+00');
INSERT INTO public.knex_migrations VALUES (3, '20200527114117_location_update_log_latest_view.js', 1, '2026-11-02 19:53:46.986+00');
INSERT INTO public.knex_migrations VALUES (4, '20200702153613_entities.js', 1, '2026-11-02 19:53:47.018+00');
INSERT INTO public.knex_migrations VALUES (5, '20200721115244_location_update_log_latest_deduplicate.js', 1, '2026-11-02 19:53:47.022+00');
INSERT INTO public.knex_migrations VALUES (6, '20200805163904_location_update_log_duplication_fix.js', 1, '2026-11-02 19:53:47.032+00');
INSERT INTO public.knex_migrations VALUES (7, '20200807120600_entitySearch.js', 1, '2026-11-02 19:53:47.036+00');
INSERT INTO public.knex_migrations VALUES (8, '20200809202832_add_bootstrap_location.js', 1, '2026-11-02 19:53:47.04+00');
INSERT INTO public.knex_migrations VALUES (9, '20200923104503_case_insensitivity.js', 1, '2026-11-02 19:53:47.044+00');
INSERT INTO public.knex_migrations VALUES (10, '20201005122705_add_entity_full_name.js', 1, '2026-11-02 19:53:47.053+00');
INSERT INTO public.knex_migrations VALUES (11, '20201006130744_entity_data_column.js', 1, '2026-11-02 19:53:47.062+00');
INSERT INTO public.knex_migrations VALUES (12, '20201006203131_entity_remove_redundant_columns.js', 1, '2026-11-02 19:53:47.067+00');
INSERT INTO public.knex_migrations VALUES (13, '20201007201501_index_entity_search.js', 1, '2026-11-02 19:53:47.071+00');
INSERT INTO public.knex_migrations VALUES (14, '20201019130742_add_relations_table.js', 1, '2026-11-02 19:53:47.08+00');
INSERT INTO public.knex_migrations VALUES (15, '20201123205611_relations_table_uniq.js', 1, '2026-11-02 19:53:47.083+00');
INSERT INTO public.knex_migrations VALUES (16, '20201210185851_fk_index.js', 1, '2026-11-02 19:53:47.087+00');
INSERT INTO public.knex_migrations VALUES (17, '20201230103504_update_log_varchar.js', 1, '2026-11-02 19:53:47.096+00');
INSERT INTO public.knex_migrations VALUES (18, '20210209121210_locations_fk_index.js', 1, '2026-11-02 19:53:47.1+00');
INSERT INTO public.knex_migrations VALUES (19, '20210302150147_refresh_state.js', 1, '2026-11-02 19:53:47.165+00');
INSERT INTO public.knex_migrations VALUES (20, '20210622104022_refresh_state_location_key.js', 1, '2026-11-02 19:53:47.168+00');


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

INSERT INTO public.locations VALUES ('7a24232d-ba8f-4cbe-93c0-24e6e9b2f0be', 'bootstrap', 'bootstrap');
INSERT INTO public.locations VALUES ('0cdf8066-991b-445e-aff9-0963c1591785', 'url', 'https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml');
INSERT INTO public.locations VALUES ('32b0032a-d0a8-4e39-9061-64a0592e7427', 'url', 'https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml');


--
-- Data for Name: refresh_state; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.refresh_state VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'component:default/bakstg-nodejs-demo2', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"bakstg-nodejs-demo2","description":"Node.js 20 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs","annotations":{"github.com/project-slug":"cirodasilvaj/bakstg-nodejs-demo2","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"bakstg-nodejs-demo2","backstage.io/kubernetes-id":"bakstg-nodejs-demo2","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"bakstg-nodejs-demo2","grafana/tag-selector":"service:bakstg-nodejs-demo2","grafana/overview-dashboard":"http://grafana.992382723408.realhandsonlabs.net/d/bakstg-nodejs-demo2-dashboard","argocd/app-name":"bakstg-nodejs-demo2","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml"},"tags":["microservice","k8s","sonarqube","prometheus","fluentd","loki","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/bakstg-nodejs-demo2","title":"GitHub Source Code","icon":"github"},{"url":"http://grafana.992382723408.realhandsonlabs.net/d/bakstg-nodejs-demo2-dashboard","title":"Grafana Dashboard","icon":"dashboard"},{"url":"http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=bakstg-nodejs-demo2","title":"SonarQube Quality Gate","icon":"check"}]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/","github.com/project-slug":"cirodasilvaj/bakstg-nodejs-demo2","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"bakstg-nodejs-demo2","backstage.io/kubernetes-id":"bakstg-nodejs-demo2","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"bakstg-nodejs-demo2","grafana/tag-selector":"service:bakstg-nodejs-demo2","grafana/overview-dashboard":"http://grafana.992382723408.realhandsonlabs.net/d/bakstg-nodejs-demo2-dashboard","argocd/app-name":"bakstg-nodejs-demo2"},"name":"bakstg-nodejs-demo2","description":"Node.js 20 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs","tags":["microservice","k8s","sonarqube","prometheus","fluentd","loki","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/bakstg-nodejs-demo2","title":"GitHub Source Code","icon":"github"},{"url":"http://grafana.992382723408.realhandsonlabs.net/d/bakstg-nodejs-demo2-dashboard","title":"Grafana Dashboard","icon":"dashboard"},{"url":"http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=bakstg-nodejs-demo2","title":"SonarQube Quality Gate","icon":"check"}],"uid":"1e69ed9f-d832-487e-87d5-d2895168e30c"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026"}}', '{}', '[]', '2026-11-03 00:20:47.399745+00', '2026-11-03 00:05:46.284828+00', 'url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'component:default/scaffolder-starter-microservice', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"scaffolder-starter-microservice","description":"Scaffolder starter microservice created from Backstage IDP","annotations":{"github.com/project-slug":"cirodasilvaj/scaffolder-starter-microservice","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"scaffolder-starter-microservice","backstage.io/kubernetes-id":"scaffolder-starter-microservice","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"scaffolder-starter-microservice","grafana/tag-selector":"service:scaffolder-starter-microservice","grafana/overview-dashboard":"http://grafana.992382723408.realhandsonlabs.net/d/scaffolder-starter-microservice-dashboard","argocd/app-name":"scaffolder-starter-microservice","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml"},"tags":["microservice","k8s","sonarqube","prometheus","fluentd","loki","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/scaffolder-starter-microservice","title":"GitHub Source Code","icon":"github"},{"url":"http://grafana.992382723408.realhandsonlabs.net/d/scaffolder-starter-microservice-dashboard","title":"Grafana Dashboard","icon":"dashboard"},{"url":"http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=scaffolder-starter-microservice","title":"SonarQube Quality Gate","icon":"check"}]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/scaffolder-starter-microservice/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/","github.com/project-slug":"cirodasilvaj/scaffolder-starter-microservice","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"scaffolder-starter-microservice","backstage.io/kubernetes-id":"scaffolder-starter-microservice","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"scaffolder-starter-microservice","grafana/tag-selector":"service:scaffolder-starter-microservice","grafana/overview-dashboard":"http://grafana.992382723408.realhandsonlabs.net/d/scaffolder-starter-microservice-dashboard","argocd/app-name":"scaffolder-starter-microservice"},"name":"scaffolder-starter-microservice","description":"Scaffolder starter microservice created from Backstage IDP","tags":["microservice","k8s","sonarqube","prometheus","fluentd","loki","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/scaffolder-starter-microservice","title":"GitHub Source Code","icon":"github"},{"url":"http://grafana.992382723408.realhandsonlabs.net/d/scaffolder-starter-microservice-dashboard","title":"Grafana Dashboard","icon":"dashboard"},{"url":"http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=scaffolder-starter-microservice","title":"SonarQube Quality Gate","icon":"check"}],"uid":"dd98330a-009c-413f-9dc6-69b7b3b045f2"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026"}}', '{}', '[]', '2026-11-03 00:19:47.350333+00', '2026-11-03 00:18:06.497322+00', 'url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('a9695418-4b02-4a0b-bcb4-c58faab06eb8', 'location:default/generated-d39e9e69bdff92426a0ef516ba3b7a18205f9ddc', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-d39e9e69bdff92426a0ef516ba3b7a18205f9ddc","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/scaffolder-starter-microservice/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/"},"name":"generated-d39e9e69bdff92426a0ef516ba3b7a18205f9ddc","uid":"a9695418-4b02-4a0b-bcb4-c58faab06eb8"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml"}}', '{}', '[]', '2026-11-03 00:19:46.349954+00', '2026-11-02 23:38:04.164736+00', 'url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('2964dfe6-0ed8-47c1-8b66-62b9a5a5f2f1', 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"github-discovery","target":"https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551","uid":"2964dfe6-0ed8-47c1-8b66-62b9a5a5f2f1"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"github-discovery","target":"https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}}', '{}', '[]', '2026-11-03 00:21:07.427161+00', '2026-11-02 19:53:47.183081+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'component:default/prometheus', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"prometheus","title":"Prometheus Monitoring","description":"Prometheus Metrics Server & Node Exporter on EKS","annotations":{"github.com/project-slug":"cirobessa/kube-demo-2026","backstage.io/kubernetes-id":"prometheus","backstage.io/kubernetes-namespace":"monitoring","backstage.io/kubernetes-label-selector":"app.kubernetes.io/name=prometheus","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"},"links":[{"url":"http://prometheus.992382723408.realhandsonlabs.net","title":"Prometheus Web UI","icon":"gauge"},{"url":"https://github.com/cirobessa/kube-demo-2026","title":"Prometheus Manifests","icon":"github"}]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","github.com/project-slug":"cirobessa/kube-demo-2026","backstage.io/kubernetes-id":"prometheus","backstage.io/kubernetes-namespace":"monitoring","backstage.io/kubernetes-label-selector":"app.kubernetes.io/name=prometheus"},"name":"prometheus","title":"Prometheus Monitoring","description":"Prometheus Metrics Server & Node Exporter on EKS","links":[{"url":"http://prometheus.992382723408.realhandsonlabs.net","title":"Prometheus Web UI","icon":"gauge"},{"url":"https://github.com/cirobessa/kube-demo-2026","title":"Prometheus Manifests","icon":"github"}],"uid":"6ba147d5-0d04-487e-b400-98ebc3a32caf"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-03 00:21:08.427858+00', '2026-11-03 00:19:27.460811+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('5a3770b1-36ac-439b-aae7-ad1e1c6f7a93', 'location:default/generated-b4f29ca1863623b0dea4276cfa3970b897899c36', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-b4f29ca1863623b0dea4276cfa3970b897899c36","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/"},"name":"generated-b4f29ca1863623b0dea4276cfa3970b897899c36","uid":"5a3770b1-36ac-439b-aae7-ad1e1c6f7a93"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml"}}', '{}', '[]', '2026-11-03 00:21:07.427161+00', '2026-11-02 19:53:47.183081+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('f455ce50-afa5-469e-ba70-803fcd20ff43', 'location:default/generated-6a784c45d310bbbb8ae6d987a8a58e15ee836489', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-6a784c45d310bbbb8ae6d987a8a58e15ee836489","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/"},"name":"generated-6a784c45d310bbbb8ae6d987a8a58e15ee836489","uid":"f455ce50-afa5-469e-ba70-803fcd20ff43"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml"}}', '{}', '[]', '2026-11-03 00:20:46.398612+00', '2026-11-02 23:57:25.329923+00', 'url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('f4d59911-2200-4c72-b99e-819df59d7610', 'location:default/generated-aea2074c195831a31fb8d1acdfcfd9ae7d08cd1b', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-aea2074c195831a31fb8d1acdfcfd9ae7d08cd1b","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/bot-dermatologia-mattos/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-aea2074c195831a31fb8d1acdfcfd9ae7d08cd1b","uid":"f4d59911-2200-4c72-b99e-819df59d7610"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/bot-dermatologia-mattos/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/bot-dermatologia-mattos/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/bot-dermatologia-mattos/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:09.502637+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('d156834d-2957-4c7b-a60b-473c61a84906', 'location:default/generated-e40d9e847bb90a7610522a0d467185a8e079bb3e', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-e40d9e847bb90a7610522a0d467185a8e079bb3e","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/a360-business/openclaw-setup/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-e40d9e847bb90a7610522a0d467185a8e079bb3e","uid":"d156834d-2957-4c7b-a60b-473c61a84906"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/openclaw-setup/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/openclaw-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/openclaw-setup/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:10.428747+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'template:default/standard-microservice-template', '{"apiVersion":"backstage.io/v1beta2","kind":"Template","metadata":{"name":"standard-microservice-template","title":"Standard Microservice with CI/CD, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a ready-to-use repository with a test pipeline, SonarQube Quality Gate validation, Prometheus metrics, Fluentd/Loki logging, and Backstage manifest.","tags":["node","python","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml"}},"spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$"},"description":{"title":"Description","type":"string","description":"What does this microservice do?"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"microservice-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"{{ parameters.component_id }}","description":"{{ parameters.description }}","owner":"{{ parameters.owner }}","system":"{{ parameters.system }}","destinationOwner":"{{ parameters.destinationOwner }}"}}},{"id":"publish","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"{{ parameters.description }}","repoUrl":"github.com?owner={{ parameters.destinationOwner }}&repo={{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"{{ steps.publish.output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"{{ steps.publish.output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"{{ steps.register.output.entityRef }}"}]}}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/microservice-template/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/"},"name":"standard-microservice-template","title":"Standard Microservice with CI/CD, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a ready-to-use repository with a test pipeline, SonarQube Quality Gate validation, Prometheus metrics, Fluentd/Loki logging, and Backstage manifest.","tags":["node","python","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"b336ba83-2423-4731-895e-6cdfacb64bce"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$"},"description":{"title":"Description","type":"string","description":"What does this microservice do?"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"microservice-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"{{ parameters.component_id }}","description":"{{ parameters.description }}","owner":"{{ parameters.owner }}","system":"{{ parameters.system }}","destinationOwner":"{{ parameters.destinationOwner }}"}}},{"id":"publish","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"{{ parameters.description }}","repoUrl":"github.com?owner={{ parameters.destinationOwner }}&repo={{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"{{ steps.publish.output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"{{ steps.publish.output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"{{ steps.register.output.entityRef }}"}]}}}', '{}', '[]', '2026-11-03 00:21:08.515595+00', '2026-11-03 00:19:27.679958+00', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml');
INSERT INTO public.refresh_state VALUES ('28d415d5-684c-4e90-822c-39112ab6a4a2', 'location:default/generated-796712c88a485ec71e012b5c5f4566412a5f5672', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-796712c88a485ec71e012b5c5f4566412a5f5672","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/a360-business/growth-os-skills-full/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-796712c88a485ec71e012b5c5f4566412a5f5672","uid":"28d415d5-684c-4e90-822c-39112ab6a4a2"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/growth-os-skills-full/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/growth-os-skills-full/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/growth-os-skills-full/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:10.428747+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'group:default/platform-team', '{"apiVersion":"backstage.io/v1alpha1","kind":"Group","metadata":{"name":"platform-team","description":"Platform Engineering & DevEx Team","annotations":{"backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"team","children":[],"members":["guest"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"platform-team","description":"Platform Engineering & DevEx Team","uid":"568dc919-f18e-45a0-950c-e431c5a533a5"},"apiVersion":"backstage.io/v1alpha1","kind":"Group","spec":{"type":"team","children":[],"members":["guest"]}}', '{}', '[]', '2026-11-03 00:21:08.427858+00', '2026-11-03 00:19:27.460811+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('91a4a62f-0e20-4d57-a546-55f9f325a6c6', 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"file","target":"/etc/backstage/catalog-entities.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec","uid":"91a4a62f-0e20-4d57-a546-55f9f325a6c6"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"file","target":"/etc/backstage/catalog-entities.yaml"}}', '{}', '[]', '2026-11-03 00:21:07.427161+00', '2026-11-02 19:53:47.183081+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'template:default/jvm-springboot-sonarqube-cicd-template', '{"apiVersion":"backstage.io/v1beta2","kind":"Template","metadata":{"name":"jvm-springboot-sonarqube-cicd-template","title":"JVM Spring Boot (Java 21) + CI/CD with SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Java 21 / Spring Boot 3.3 microservice repository with Maven + JaCoCo tests, SonarQube Quality Gate (SpotBugs/FindSecBugs & OWASP), Prometheus /metrics, Fluentd -> Loki JSON logs, and Backstage manifest.","tags":["java","jvm","springboot","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml"}},"spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"springboot-app-demo"},"description":{"title":"Description","type":"string","description":"What does this Spring Boot microservice do?","default":"JVM Spring Boot 3.3 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"springboot-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"{{ parameters.component_id }}","description":"{{ parameters.description }}","owner":"{{ parameters.owner }}","system":"{{ parameters.system }}","destinationOwner":"{{ parameters.destinationOwner }}"}}},{"id":"publish","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"{{ parameters.description }}","repoUrl":"github.com?owner={{ parameters.destinationOwner }}&repo={{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"{{ steps.publish.output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"{{ steps.publish.output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"{{ steps.register.output.entityRef }}"}]}}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/"},"name":"jvm-springboot-sonarqube-cicd-template","title":"JVM Spring Boot (Java 21) + CI/CD with SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Java 21 / Spring Boot 3.3 microservice repository with Maven + JaCoCo tests, SonarQube Quality Gate (SpotBugs/FindSecBugs & OWASP), Prometheus /metrics, Fluentd -> Loki JSON logs, and Backstage manifest.","tags":["java","jvm","springboot","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"44041f68-9d66-4b71-86ac-5cd98a6bb212"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"springboot-app-demo"},"description":{"title":"Description","type":"string","description":"What does this Spring Boot microservice do?","default":"JVM Spring Boot 3.3 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"springboot-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"{{ parameters.component_id }}","description":"{{ parameters.description }}","owner":"{{ parameters.owner }}","system":"{{ parameters.system }}","destinationOwner":"{{ parameters.destinationOwner }}"}}},{"id":"publish","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"{{ parameters.description }}","repoUrl":"github.com?owner={{ parameters.destinationOwner }}&repo={{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"{{ steps.publish.output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"{{ steps.publish.output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"{{ steps.register.output.entityRef }}"}]}}}', '{}', '[]', '2026-11-03 00:21:08.563907+00', '2026-11-03 00:19:27.762926+00', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('7c3a0812-4f6f-43f5-b7ba-15254e07e374', 'location:default/generated-7692b664b197d2303b0a28bb177c1b133773311c', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-7692b664b197d2303b0a28bb177c1b133773311c","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/"},"name":"generated-7692b664b197d2303b0a28bb177c1b133773311c","uid":"7c3a0812-4f6f-43f5-b7ba-15254e07e374"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml"}}', '{}', '[]', '2026-11-03 00:21:07.427161+00', '2026-11-02 19:53:47.183081+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('85ae82e4-e930-46a4-b3e7-26a9ad047a6f', 'location:default/generated-623b5bbb8262e0696340d3ea541298687d0b3e21', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-623b5bbb8262e0696340d3ea541298687d0b3e21","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/demo-microservice-backstage-2026/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-623b5bbb8262e0696340d3ea541298687d0b3e21","uid":"85ae82e4-e930-46a4-b3e7-26a9ad047a6f"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/demo-microservice-backstage-2026/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/demo-microservice-backstage-2026/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/demo-microservice-backstage-2026/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:15.431297+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('e5835291-d759-408a-b161-43106ca035df', 'location:default/generated-e1e842392fd0da6efe989d25722f835228d60e05', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-e1e842392fd0da6efe989d25722f835228d60e05","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/"},"name":"generated-e1e842392fd0da6efe989d25722f835228d60e05","uid":"e5835291-d759-408a-b161-43106ca035df"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml"}}', '{}', '[]', '2026-11-03 00:21:07.427161+00', '2026-11-02 19:53:47.183081+00', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('a2a75b30-567d-43eb-947a-760437c05894', 'user:default/guest', '{"apiVersion":"backstage.io/v1alpha1","kind":"User","metadata":{"name":"guest","annotations":{"backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"profile":{"displayName":"Guest User","email":"guest@empresa.local"},"memberOf":["platform-team"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"guest","uid":"a2a75b30-567d-43eb-947a-760437c05894"},"apiVersion":"backstage.io/v1alpha1","kind":"User","spec":{"profile":{"displayName":"Guest User","email":"guest@empresa.local"},"memberOf":["platform-team"]}}', '{}', '[]', '2026-11-03 00:21:08.427858+00', '2026-11-03 00:19:27.460811+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('507739a8-3ff8-4533-b9b3-abf0205f6d0c', 'location:default/generated-03b13b5fb17fe9a670e36e235ad81fd06fcfd666', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-03b13b5fb17fe9a670e36e235ad81fd06fcfd666","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/a360-business/setup-ambiente/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-03b13b5fb17fe9a670e36e235ad81fd06fcfd666","uid":"507739a8-3ff8-4533-b9b3-abf0205f6d0c"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/setup-ambiente/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/setup-ambiente/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/setup-ambiente/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:09.690262+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'system:default/samba-ad-keycloak-iam', '{"apiVersion":"backstage.io/v1alpha1","kind":"System","metadata":{"name":"samba-ad-keycloak-iam","description":"Arquitetura Corporativa IAM na VPC do EKS (Samba 4 AD Multi-DC sem DNS interno + Route 53 Private Zone + FreeRADIUS MFA + Keycloak SAML 2.0 / OIDC)","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"}},"spec":{"owner":"platform-team"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"samba-ad-keycloak-iam","description":"Arquitetura Corporativa IAM na VPC do EKS (Samba 4 AD Multi-DC sem DNS interno + Route 53 Private Zone + FreeRADIUS MFA + Keycloak SAML 2.0 / OIDC)","uid":"39387fbf-9d96-40f7-baed-4dd4470abe8d"},"apiVersion":"backstage.io/v1alpha1","kind":"System","spec":{"owner":"platform-team"}}', '{}', '[]', '2026-11-03 00:21:08.427858+00', '2026-11-03 00:19:27.598601+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('5c335bb9-eb33-4dcb-8cdf-e02df2c7830a', 'location:default/generated-702a36957042d54fefb74573b3f2079c194a1849', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-702a36957042d54fefb74573b3f2079c194a1849","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/test-repo-check-permission/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-702a36957042d54fefb74573b3f2079c194a1849","uid":"5c335bb9-eb33-4dcb-8cdf-e02df2c7830a"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/test-repo-check-permission/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/test-repo-check-permission/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/test-repo-check-permission/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:08.427858+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('2ddb3e60-40cf-4844-8e24-b7413752f9f3', 'location:default/generated-47a88091bb52dcb96cc116a938257ca203c6cf66', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-47a88091bb52dcb96cc116a938257ca203c6cf66","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-47a88091bb52dcb96cc116a938257ca203c6cf66","uid":"2ddb3e60-40cf-4844-8e24-b7413752f9f3"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/blob/main/catalog-info.yaml"}}', '{}', '[]', '2026-11-03 00:21:08.427858+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('d70d519d-0082-403b-83f7-d3028813f332', 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-230c2622c092081637053d0a834587aef4c2bae2","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"generated-230c2622c092081637053d0a834587aef4c2bae2","uid":"d70d519d-0082-403b-83f7-d3028813f332"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml"}}', '{}', '[]', '2026-11-03 00:21:07.427161+00', '2026-11-02 19:53:47.183081+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('8ffa28bf-4525-474c-a0ea-275e2329fcdf', 'location:default/generated-39540a08be0bcb5645ee1d683b08d860953c5b44', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-39540a08be0bcb5645ee1d683b08d860953c5b44","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/scripts1/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-39540a08be0bcb5645ee1d683b08d860953c5b44","uid":"8ffa28bf-4525-474c-a0ea-275e2329fcdf"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/scripts1/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/scripts1/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/scripts1/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:09.502637+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('328bd867-6b9c-4be1-a096-00f817eecbc1', 'location:default/generated-bcfe70fc389b7b6f55a5728ad12e48fbb12a7627', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-bcfe70fc389b7b6f55a5728ad12e48fbb12a7627","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/zoeiroka-automacoes/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-bcfe70fc389b7b6f55a5728ad12e48fbb12a7627","uid":"328bd867-6b9c-4be1-a096-00f817eecbc1"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/zoeiroka-automacoes/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/zoeiroka-automacoes/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/zoeiroka-automacoes/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:09.690262+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('6983d607-a250-48aa-ade6-997553435d79', 'location:default/generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/microservice-template/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/"},"name":"generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98","uid":"6983d607-a250-48aa-ade6-997553435d79"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml"}}', '{}', '[]', '2026-11-03 00:21:07.427161+00', '2026-11-02 19:53:47.183081+00', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml');
INSERT INTO public.refresh_state VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'api:default/dotnet-csharp-app-api', '{"apiVersion":"backstage.io/v1alpha1","kind":"API","metadata":{"name":"dotnet-csharp-app-api","title":".NET 8 C# Minimal API REST API","description":"Interface REST para consulta de status, saúde e telemetria da aplicação C# .NET 8","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml"}},"spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","definition":"openapi: \"3.0.0\"\ninfo:\n  title: .NET 8 C# Minimal API\n  version: \"1.0.0\"\npaths:\n  /:\n    get:\n      summary: Overview & HTML Dashboard\n      responses:\n        ''200'':\n          description: OK\n  /api/info:\n    get:\n      summary: System & client runtime information\n      responses:\n        ''200'':\n          description: OK\n  /healthz:\n    get:\n      summary: Liveness probe\n      responses:\n        ''200'':\n          description: OK\n  /ready:\n    get:\n      summary: Readiness probe\n      responses:\n        ''200'':\n          description: OK\n  /metrics:\n    get:\n      summary: Prometheus metrics\n      responses:\n        ''200'':\n          description: OK\n"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/"},"name":"dotnet-csharp-app-api","title":".NET 8 C# Minimal API REST API","description":"Interface REST para consulta de status, saúde e telemetria da aplicação C# .NET 8","uid":"d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","definition":"openapi: \"3.0.0\"\ninfo:\n  title: .NET 8 C# Minimal API\n  version: \"1.0.0\"\npaths:\n  /:\n    get:\n      summary: Overview & HTML Dashboard\n      responses:\n        ''200'':\n          description: OK\n  /api/info:\n    get:\n      summary: System & client runtime information\n      responses:\n        ''200'':\n          description: OK\n  /healthz:\n    get:\n      summary: Liveness probe\n      responses:\n        ''200'':\n          description: OK\n  /ready:\n    get:\n      summary: Readiness probe\n      responses:\n        ''200'':\n          description: OK\n  /metrics:\n    get:\n      summary: Prometheus metrics\n      responses:\n        ''200'':\n          description: OK\n"}}', '{}', '[]', '2026-11-03 00:21:08.515595+00', '2026-11-03 00:19:27.733065+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'component:default/grafana', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"grafana","title":"Grafana Observability","description":"Grafana Observability Dashboards connected to Prometheus and Loki","annotations":{"github.com/project-slug":"cirobessa/kube-demo-2026","backstage.io/kubernetes-id":"grafana","backstage.io/kubernetes-namespace":"grafana","backstage.io/kubernetes-label-selector":"app.kubernetes.io/name=grafana","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"},"links":[{"url":"http://grafana.992382723408.realhandsonlabs.net","title":"Grafana Dashboards UI","icon":"dashboard"},{"url":"https://github.com/cirobessa/kube-demo-2026","title":"Monitoring Config Repo","icon":"github"}]},"spec":{"type":"website","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","github.com/project-slug":"cirobessa/kube-demo-2026","backstage.io/kubernetes-id":"grafana","backstage.io/kubernetes-namespace":"grafana","backstage.io/kubernetes-label-selector":"app.kubernetes.io/name=grafana"},"name":"grafana","title":"Grafana Observability","description":"Grafana Observability Dashboards connected to Prometheus and Loki","links":[{"url":"http://grafana.992382723408.realhandsonlabs.net","title":"Grafana Dashboards UI","icon":"dashboard"},{"url":"https://github.com/cirobessa/kube-demo-2026","title":"Monitoring Config Repo","icon":"github"}],"uid":"b0a652b4-6566-4194-a5f2-2a8c3c31db69"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"website","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-03 00:21:08.427858+00', '2026-11-03 00:19:27.460811+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('6e55b9e8-2c65-4773-b863-2e77ce1ced96', 'location:default/generated-9a24efc486a6e189695017ff7d1ff5886f9498aa', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-9a24efc486a6e189695017ff7d1ff5886f9498aa","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/hermes-backup-1-vid-agentes-repos/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-9a24efc486a6e189695017ff7d1ff5886f9498aa","uid":"6e55b9e8-2c65-4773-b863-2e77ce1ced96"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/hermes-backup-1-vid-agentes-repos/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/hermes-backup-1-vid-agentes-repos/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/hermes-backup-1-vid-agentes-repos/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:10.609567+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('8ddbcbb3-b67c-4c1d-9853-a9bb8b31d346', 'location:default/generated-64bf0f42f04286e509e88978a740e76f33a6cc2a', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-64bf0f42f04286e509e88978a740e76f33a6cc2a","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/"},"name":"generated-64bf0f42f04286e509e88978a740e76f33a6cc2a","uid":"8ddbcbb3-b67c-4c1d-9853-a9bb8b31d346"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml"}}', '{}', '[]', '2026-11-03 00:21:07.427161+00', '2026-11-02 19:53:47.183081+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('cbacfd61-8a1a-4914-ba7e-2a8563bbad45', 'location:default/generated-1f8726637b31d8323de2ea178b5ccd8c303f90fa', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-1f8726637b31d8323de2ea178b5ccd8c303f90fa","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/mesa-agents/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-1f8726637b31d8323de2ea178b5ccd8c303f90fa","uid":"cbacfd61-8a1a-4914-ba7e-2a8563bbad45"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/mesa-agents/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/mesa-agents/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/mesa-agents/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:09.502637+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('67f8a0e4-f1e1-46a8-8541-0d06400fadc6', 'location:default/generated-e461ccc7db88e98c2a26c40a0672f2e1edbfe4f0', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-e461ccc7db88e98c2a26c40a0672f2e1edbfe4f0","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/leonardoserio/accelera-skills/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-e461ccc7db88e98c2a26c40a0672f2e1edbfe4f0","uid":"67f8a0e4-f1e1-46a8-8541-0d06400fadc6"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/leonardoserio/accelera-skills/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/leonardoserio/accelera-skills/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/leonardoserio/accelera-skills/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:11.429433+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'component:default/sonarqube', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"sonarqube","title":"SonarQube Code Quality","description":"SonarQube QA & Security Scanner on EKS (OWASP Dependency-Check, FindSecBugs & YAML/K8s Security plugins)","annotations":{"github.com/project-slug":"cirobessa/kube-demo-2026","backstage.io/kubernetes-id":"sonarqube","backstage.io/kubernetes-namespace":"sonarqube","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"},"links":[{"url":"http://sonarqube.992382723408.realhandsonlabs.net","title":"SonarQube Dashboard UI","icon":"check"},{"url":"https://github.com/cirobessa/kube-demo-2026","title":"SonarQube QA Config","icon":"github"}]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","github.com/project-slug":"cirobessa/kube-demo-2026","backstage.io/kubernetes-id":"sonarqube","backstage.io/kubernetes-namespace":"sonarqube"},"name":"sonarqube","title":"SonarQube Code Quality","description":"SonarQube QA & Security Scanner on EKS (OWASP Dependency-Check, FindSecBugs & YAML/K8s Security plugins)","links":[{"url":"http://sonarqube.992382723408.realhandsonlabs.net","title":"SonarQube Dashboard UI","icon":"check"},{"url":"https://github.com/cirobessa/kube-demo-2026","title":"SonarQube QA Config","icon":"github"}],"uid":"01edbf6e-da27-4e26-a028-e62fa0cbc5b6"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-03 00:21:08.515595+00', '2026-11-03 00:19:27.460811+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('c21e2a4f-66b6-42fa-8d52-8c654775fb77', 'location:default/generated-689c18882dc297803e1a420c73b8783d094c8e17', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-689c18882dc297803e1a420c73b8783d094c8e17","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/"},"name":"generated-689c18882dc297803e1a420c73b8783d094c8e17","uid":"c21e2a4f-66b6-42fa-8d52-8c654775fb77"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml"}}', '{}', '[]', '2026-11-03 00:21:07.427161+00', '2026-11-02 19:53:47.183081+00', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('c9965817-610e-41cd-90a5-62723cfcf426', 'location:default/generated-db60c7b251928fac7d8502c0c92b1fa486c7621b', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-db60c7b251928fac7d8502c0c92b1fa486c7621b","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/test-repo-via-pat/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-db60c7b251928fac7d8502c0c92b1fa486c7621b","uid":"c9965817-610e-41cd-90a5-62723cfcf426"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/test-repo-via-pat/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/test-repo-via-pat/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/test-repo-via-pat/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:08.563907+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'component:default/backstage-portal', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"backstage-portal","title":"Backstage Developer Portal","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","annotations":{"github.com/project-slug":"cirodasilvaj/backstage-infra","backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"},"links":[{"url":"http://backstage.992382723408.realhandsonlabs.net","title":"Backstage Portal UI","icon":"dashboard"},{"url":"https://github.com/cirodasilvaj/backstage-infra","title":"GitHub Infrastructure Repo","icon":"github"}]},"spec":{"type":"website","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","github.com/project-slug":"cirodasilvaj/backstage-infra","backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage"},"name":"backstage-portal","title":"Backstage Developer Portal","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","links":[{"url":"http://backstage.992382723408.realhandsonlabs.net","title":"Backstage Portal UI","icon":"dashboard"},{"url":"https://github.com/cirodasilvaj/backstage-infra","title":"GitHub Infrastructure Repo","icon":"github"}],"uid":"d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"website","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-03 00:21:08.515595+00', '2026-11-03 00:19:27.460811+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('569b86ee-0b91-4986-b3fb-639450e8e556', 'location:default/generated-0bc5455adc5c6e2724b4409f7f4382f145a48c31', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-0bc5455adc5c6e2724b4409f7f4382f145a48c31","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/scaffolder-starter-microservice/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-0bc5455adc5c6e2724b4409f7f4382f145a48c31","uid":"569b86ee-0b91-4986-b3fb-639450e8e556"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/scaffolder-starter-microservice/blob/main/catalog-info.yaml"}}', '{}', '[]', '2026-11-03 00:21:09.428118+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'component:default/freeradius-mfa', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"freeradius-mfa","description":"Servidor FreeRADIUS + PAM Google Authenticator (TOTP MFA) integrado ao Samba 4 AD para autenticação geral e MFA na VPC do EKS","annotations":{"github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"samba-ad-keycloak","backstage.io/kubernetes-id":"freeradius-mfa","backstage.io/kubernetes-namespace":"default","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"samba-ad-keycloak","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"},"tags":["radius","freeradius","mfa","totp"],"links":[{"url":"https://github.com/cirodasilvaj/samba-ad-keycloak","title":"GitHub Source Code","icon":"github"}]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","dependsOn":["component:default/samba-ad-dc"],"providesApis":["radius-mfa-api"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/","github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"samba-ad-keycloak","backstage.io/kubernetes-id":"freeradius-mfa","backstage.io/kubernetes-namespace":"default","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"samba-ad-keycloak"},"name":"freeradius-mfa","description":"Servidor FreeRADIUS + PAM Google Authenticator (TOTP MFA) integrado ao Samba 4 AD para autenticação geral e MFA na VPC do EKS","tags":["radius","freeradius","mfa","totp"],"links":[{"url":"https://github.com/cirodasilvaj/samba-ad-keycloak","title":"GitHub Source Code","icon":"github"}],"uid":"c7e06623-192c-43eb-87f8-2951a24f999f"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","dependsOn":["component:default/samba-ad-dc"],"providesApis":["radius-mfa-api"]}}', '{}', '[]', '2026-11-03 00:21:08.563907+00', '2026-11-03 00:19:27.598601+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('57242473-b776-432c-bb75-f28c61301137', 'location:default/generated-3a49cafceb0ae80411060ab243ac7adf4cb8101e', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-3a49cafceb0ae80411060ab243ac7adf4cb8101e","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-3a49cafceb0ae80411060ab243ac7adf4cb8101e","uid":"57242473-b776-432c-bb75-f28c61301137"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/backstage-infra/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/backstage-infra/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:09.502637+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'component:default/argocd', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"argocd","title":"ArgoCD GitOps","description":"ArgoCD GitOps Continuous Delivery Controller on EKS","annotations":{"github.com/project-slug":"cirobessa/kube-demo-2026","backstage.io/kubernetes-id":"argocd","backstage.io/kubernetes-namespace":"argocd","backstage.io/kubernetes-label-selector":"app.kubernetes.io/part-of=argocd","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"},"links":[{"url":"https://argocd.992382723408.realhandsonlabs.net","title":"ArgoCD Web Console (HTTPS ACM)","icon":"sync"},{"url":"https://github.com/cirobessa/kube-demo-2026","title":"GitOps Cluster Repository","icon":"github"}]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","github.com/project-slug":"cirobessa/kube-demo-2026","backstage.io/kubernetes-id":"argocd","backstage.io/kubernetes-namespace":"argocd","backstage.io/kubernetes-label-selector":"app.kubernetes.io/part-of=argocd"},"name":"argocd","title":"ArgoCD GitOps","description":"ArgoCD GitOps Continuous Delivery Controller on EKS","links":[{"url":"https://argocd.992382723408.realhandsonlabs.net","title":"ArgoCD Web Console (HTTPS ACM)","icon":"sync"},{"url":"https://github.com/cirobessa/kube-demo-2026","title":"GitOps Cluster Repository","icon":"github"}],"uid":"c0075925-12d7-4dfa-b9fc-8324d2f99dcb"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026","dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-03 00:21:08.515595+00', '2026-11-03 00:19:27.460811+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('9877515a-425a-46df-9c60-2286fb06abda', 'location:default/generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/jvm-springboot-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/"},"name":"generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a","uid":"9877515a-425a-46df-9c60-2286fb06abda"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml"}}', '{}', '[]', '2026-11-03 00:21:07.427161+00', '2026-11-02 19:53:47.183081+00', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'api:default/saml-idp-api', '{"apiVersion":"backstage.io/v1alpha1","kind":"API","metadata":{"name":"saml-idp-api","description":"Endpoint SAML 2.0 Identity Provider do Keycloak (sso.empresa.local)","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"}},"spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Keycloak SAML 2.0 IdP Descriptor\n  version: \"1.0.0\"\npaths:\n  /realms/empresa/protocol/saml/descriptor:\n    get:\n      summary: Retorna o XML de metadados SAML 2.0 do Realm empresa\n      responses:\n        \"200\":\n          description: SAML 2.0 Metadata XML\n"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"saml-idp-api","description":"Endpoint SAML 2.0 Identity Provider do Keycloak (sso.empresa.local)","uid":"ac68373a-af16-4be0-b0c3-5ffdf40e00fb"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Keycloak SAML 2.0 IdP Descriptor\n  version: \"1.0.0\"\npaths:\n  /realms/empresa/protocol/saml/descriptor:\n    get:\n      summary: Retorna o XML de metadados SAML 2.0 do Realm empresa\n      responses:\n        \"200\":\n          description: SAML 2.0 Metadata XML\n"}}', '{}', '[]', '2026-11-03 00:21:09.770323+00', '2026-11-03 00:19:27.598601+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('fc8e7ab4-869c-4e8b-813a-1f4cf99340b4', 'location:default/generated-73a2399a7c2024519f325ee2a4e98268e82758b7', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-73a2399a7c2024519f325ee2a4e98268e82758b7","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/floci-localstack-aws/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-73a2399a7c2024519f325ee2a4e98268e82758b7","uid":"fc8e7ab4-869c-4e8b-813a-1f4cf99340b4"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/floci-localstack-aws/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/floci-localstack-aws/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/floci-localstack-aws/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:09.502637+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('8ba49820-4112-4d3f-ac91-d708ed64c6f6', 'location:default/generated-d6eb614c9d4a9daaeb84a95d3fece1a6a0dd9916', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-d6eb614c9d4a9daaeb84a95d3fece1a6a0dd9916","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirobessa/kube-demo-2026/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-d6eb614c9d4a9daaeb84a95d3fece1a6a0dd9916","uid":"8ba49820-4112-4d3f-ac91-d708ed64c6f6"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirobessa/kube-demo-2026/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirobessa/kube-demo-2026/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirobessa/kube-demo-2026/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:10.428747+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('6dbef53c-6b33-461c-a885-773759651e58', 'location:default/generated-edb107c0bf74b8a4c4c763787b54180b9801f99b', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-edb107c0bf74b8a4c4c763787b54180b9801f99b","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/a360-business/hermes-setup/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-edb107c0bf74b8a4c4c763787b54180b9801f99b","uid":"6dbef53c-6b33-461c-a885-773759651e58"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/hermes-setup/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/hermes-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/hermes-setup/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:10.428747+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'component:default/bkstg-made-nodejs-demo22', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"bkstg-made-nodejs-demo22","description":"Node.js 20 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs","annotations":{"github.com/project-slug":"cirodasilvaj/bkstg-made-nodejs-demo22","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"bkstg-made-nodejs-demo22","backstage.io/kubernetes-id":"bkstg-made-nodejs-demo22","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"bkstg-made-nodejs-demo22","grafana/tag-selector":"service:bkstg-made-nodejs-demo22","grafana/overview-dashboard":"http://grafana.992382723408.realhandsonlabs.net/d/bkstg-made-nodejs-demo22-dashboard","argocd/app-name":"bkstg-made-nodejs-demo22","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/blob/main/catalog-info.yaml"},"tags":["microservice","k8s","sonarqube","prometheus","fluentd","loki","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22","title":"GitHub Source Code","icon":"github"},{"url":"http://grafana.992382723408.realhandsonlabs.net/d/bkstg-made-nodejs-demo22-dashboard","title":"Grafana Dashboard","icon":"dashboard"},{"url":"http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=bkstg-made-nodejs-demo22","title":"SonarQube Quality Gate","icon":"check"}]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/blob/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/","github.com/project-slug":"cirodasilvaj/bkstg-made-nodejs-demo22","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"bkstg-made-nodejs-demo22","backstage.io/kubernetes-id":"bkstg-made-nodejs-demo22","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"bkstg-made-nodejs-demo22","grafana/tag-selector":"service:bkstg-made-nodejs-demo22","grafana/overview-dashboard":"http://grafana.992382723408.realhandsonlabs.net/d/bkstg-made-nodejs-demo22-dashboard","argocd/app-name":"bkstg-made-nodejs-demo22"},"name":"bkstg-made-nodejs-demo22","description":"Node.js 20 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs","tags":["microservice","k8s","sonarqube","prometheus","fluentd","loki","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22","title":"GitHub Source Code","icon":"github"},{"url":"http://grafana.992382723408.realhandsonlabs.net/d/bkstg-made-nodejs-demo22-dashboard","title":"Grafana Dashboard","icon":"dashboard"},{"url":"http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=bkstg-made-nodejs-demo22","title":"SonarQube Quality Gate","icon":"check"}],"uid":"32a660f9-efac-45f3-97c8-41f32ed8d97f"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"kube-demo-2026"}}', '{}', '[]', '2026-11-03 00:21:08.563907+00', '2026-11-03 00:19:28.592385+00', 'url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'api:default/python-app-api', '{"apiVersion":"backstage.io/v1alpha1","kind":"API","metadata":{"name":"python-app-api","title":"Python Flask App REST API","description":"Interface REST para consulta de status, saúde e telemetria da aplicação Python","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml"}},"spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Python App API\n  version: \"1.0.0\"\npaths:\n  /:\n    get:\n      summary: Overview & HTML Dashboard\n      responses:\n        ''200'':\n          description: OK\n  /api/info:\n    get:\n      summary: System & client runtime information\n      responses:\n        ''200'':\n          description: OK\n  /healthz:\n    get:\n      summary: Liveness probe\n      responses:\n        ''200'':\n          description: OK\n  /ready:\n    get:\n      summary: Readiness probe\n      responses:\n        ''200'':\n          description: OK\n  /metrics:\n    get:\n      summary: Prometheus metrics\n      responses:\n        ''200'':\n          description: OK\n"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/"},"name":"python-app-api","title":"Python Flask App REST API","description":"Interface REST para consulta de status, saúde e telemetria da aplicação Python","uid":"8b395fb2-b486-4e7c-ac0c-9b9ef49b608e"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Python App API\n  version: \"1.0.0\"\npaths:\n  /:\n    get:\n      summary: Overview & HTML Dashboard\n      responses:\n        ''200'':\n          description: OK\n  /api/info:\n    get:\n      summary: System & client runtime information\n      responses:\n        ''200'':\n          description: OK\n  /healthz:\n    get:\n      summary: Liveness probe\n      responses:\n        ''200'':\n          description: OK\n  /ready:\n    get:\n      summary: Readiness probe\n      responses:\n        ''200'':\n          description: OK\n  /metrics:\n    get:\n      summary: Prometheus metrics\n      responses:\n        ''200'':\n          description: OK\n"}}', '{}', '[]', '2026-11-03 00:21:09.428118+00', '2026-11-03 00:19:27.640023+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('b70e7452-e2ca-4d1a-baef-8929bed899ae', 'location:default/generated-d2a36c4260a85053ce94fbe9c674187459d272db', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-d2a36c4260a85053ce94fbe9c674187459d272db","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/arthurecio/openclaw-setup/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-d2a36c4260a85053ce94fbe9c674187459d272db","uid":"b70e7452-e2ca-4d1a-baef-8929bed899ae"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/arthurecio/openclaw-setup/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/arthurecio/openclaw-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/arthurecio/openclaw-setup/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:10.609567+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('ba03d047-b0e3-49dc-bc31-be7e943f6da4', 'location:default/generated-e67fab63afdcd722173e912706fe624b9df62c34', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-e67fab63afdcd722173e912706fe624b9df62c34","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/devmarcelo/openclaw-setup/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-e67fab63afdcd722173e912706fe624b9df62c34","uid":"ba03d047-b0e3-49dc-bc31-be7e943f6da4"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/devmarcelo/openclaw-setup/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/devmarcelo/openclaw-setup/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/devmarcelo/openclaw-setup/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:10.428747+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'resource:default/kube-demo-eks', '{"apiVersion":"backstage.io/v1alpha1","kind":"Resource","metadata":{"name":"kube-demo-eks","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","annotations":{"backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"type":"kubernetes-cluster","owner":"platform-team","system":"kube-demo-2026"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system"},"name":"kube-demo-eks","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","uid":"a1398182-7d8a-41e3-bab3-6f6125b19bd2"},"apiVersion":"backstage.io/v1alpha1","kind":"Resource","spec":{"type":"kubernetes-cluster","owner":"platform-team","system":"kube-demo-2026"}}', '{}', '[]', '2026-11-03 00:21:08.427858+00', '2026-11-03 00:19:27.460811+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'api:default/oidc-idp-api', '{"apiVersion":"backstage.io/v1alpha1","kind":"API","metadata":{"name":"oidc-idp-api","description":"Endpoint OpenID Connect (OIDC) Discovery do Keycloak (sso.empresa.local)","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"}},"spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Keycloak OIDC Discovery API\n  version: \"1.0.0\"\npaths:\n  /realms/empresa/.well-known/openid-configuration:\n    get:\n      summary: Retorna a configuracao OIDC do Realm empresa\n      responses:\n        \"200\":\n          description: OIDC Discovery JSON\n"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"oidc-idp-api","description":"Endpoint OpenID Connect (OIDC) Discovery do Keycloak (sso.empresa.local)","uid":"c0d72379-16b6-4e8a-8d49-1f327ef118b2"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"openapi","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"openapi: \"3.0.0\"\ninfo:\n  title: Keycloak OIDC Discovery API\n  version: \"1.0.0\"\npaths:\n  /realms/empresa/.well-known/openid-configuration:\n    get:\n      summary: Retorna a configuracao OIDC do Realm empresa\n      responses:\n        \"200\":\n          description: OIDC Discovery JSON\n"}}', '{}', '[]', '2026-11-03 00:21:09.428118+00', '2026-11-03 00:19:27.598601+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('4def6055-c424-4fc1-bd59-5ee4349e209a', 'location:default/generated-023ff0c2d516eb7ee170b46c23edf162e464605b', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-023ff0c2d516eb7ee170b46c23edf162e464605b","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/joaoguibune/galeed-community/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-023ff0c2d516eb7ee170b46c23edf162e464605b","uid":"4def6055-c424-4fc1-bd59-5ee4349e209a"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/joaoguibune/galeed-community/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/joaoguibune/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/joaoguibune/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:11.429433+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('a0551093-7eae-45a6-bece-165c2dfdc2ea', 'location:default/generated-024455ef88eaf59fbb3261fdaa8dd9c1095d1ac7', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-024455ef88eaf59fbb3261fdaa8dd9c1095d1ac7","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/test-direct-pod-call/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-024455ef88eaf59fbb3261fdaa8dd9c1095d1ac7","uid":"a0551093-7eae-45a6-bece-165c2dfdc2ea"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/test-direct-pod-call/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/test-direct-pod-call/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/test-direct-pod-call/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:09.428118+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('115a964d-41be-496c-ab7f-47b42064763f', 'location:default/generated-78a0f16f4da15640f067c17fea7b0935483fd142', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-78a0f16f4da15640f067c17fea7b0935483fd142","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/a360-business/agent-foreman/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-78a0f16f4da15640f067c17fea7b0935483fd142","uid":"115a964d-41be-496c-ab7f-47b42064763f"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/agent-foreman/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/agent-foreman/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/agent-foreman/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:11.429433+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('66576428-ff82-4dc3-914e-6988c6259d76', 'location:default/generated-5c9e4afea8ffa75fba62cb03ab309d31fd5b98b3', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-5c9e4afea8ffa75fba62cb03ab309d31fd5b98b3","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-permission-test-1793652634586/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-5c9e4afea8ffa75fba62cb03ab309d31fd5b98b3","uid":"66576428-ff82-4dc3-914e-6988c6259d76"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-permission-test-1793652634586/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/backstage-permission-test-1793652634586/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/backstage-permission-test-1793652634586/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:08.563907+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('00d94013-0f3e-4bf6-b6fc-c3a793e7472f', 'location:default/generated-31a0877ed2bec2edf4feee46dd4161a60585d1ce', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-31a0877ed2bec2edf4feee46dd4161a60585d1ce","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-31a0877ed2bec2edf4feee46dd4161a60585d1ce","uid":"00d94013-0f3e-4bf6-b6fc-c3a793e7472f"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:09.643801+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'system:default/kube-demo-2026', '{"apiVersion":"backstage.io/v1alpha1","kind":"System","metadata":{"name":"kube-demo-2026","description":"AWS EKS 1.35 Platform, GitOps, Observability & Developer Portal","annotations":{"backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml"}},"spec":{"owner":"platform-team"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"file:/etc/backstage/catalog-entities.yaml","backstage.io/managed-by-origin-location":"file:/etc/backstage/catalog-entities.yaml"},"name":"kube-demo-2026","description":"AWS EKS 1.35 Platform, GitOps, Observability & Developer Portal","uid":"605f8bb8-29f1-4f08-8571-2a92ee8520c4"},"apiVersion":"backstage.io/v1alpha1","kind":"System","spec":{"owner":"platform-team"}}', '{}', '[]', '2026-11-03 00:21:08.427858+00', '2026-11-03 00:19:27.460811+00', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.refresh_state VALUES ('2abb648f-f7cb-48dc-996f-4feb9f4778fe', 'location:default/generated-8f44ff1b0eee905e4f10b347f2f4cde12c6ecb91', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-8f44ff1b0eee905e4f10b347f2f4cde12c6ecb91","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/MoreiraThi87/galeed-community/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-8f44ff1b0eee905e4f10b347f2f4cde12c6ecb91","uid":"2abb648f-f7cb-48dc-996f-4feb9f4778fe"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/MoreiraThi87/galeed-community/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/MoreiraThi87/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/MoreiraThi87/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:09.643801+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('ee863f3c-6e3d-4737-bf1c-fa378c782ff2', 'location:default/generated-1fa5db3a5d97294de3a94bed049e4c7133c78dca', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-1fa5db3a5d97294de3a94bed049e4c7133c78dca","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/fabricaberger-droid/a360-dev-multiagentes/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-1fa5db3a5d97294de3a94bed049e4c7133c78dca","uid":"ee863f3c-6e3d-4737-bf1c-fa378c782ff2"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/fabricaberger-droid/a360-dev-multiagentes/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/fabricaberger-droid/a360-dev-multiagentes/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/fabricaberger-droid/a360-dev-multiagentes/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:10.609567+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'template:default/dotnet-sonarqube-cicd-template', '{"apiVersion":"backstage.io/v1beta2","kind":"Template","metadata":{"name":"dotnet-sonarqube-cicd-template","title":".NET 8 C# Web App + CI/CD with QA, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete .NET 8 C# Minimal API repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki logging, and Backstage manifest.","tags":["dotnet","csharp","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml"}},"spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"dotnet-csharp-app-demo"},"description":{"title":"Description","type":"string","description":"What does this microservice do?","default":".NET 8 C# microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"dotnet-csharp-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"{{ parameters.component_id }}","description":"{{ parameters.description }}","owner":"{{ parameters.owner }}","system":"{{ parameters.system }}","destinationOwner":"{{ parameters.destinationOwner }}"}}},{"id":"publish","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"{{ parameters.description }}","repoUrl":"github.com?owner={{ parameters.destinationOwner }}&repo={{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"{{ steps.publish.output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"{{ steps.publish.output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"{{ steps.register.output.entityRef }}"}]}}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/dotnet-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/"},"name":"dotnet-sonarqube-cicd-template","title":".NET 8 C# Web App + CI/CD with QA, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete .NET 8 C# Minimal API repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki logging, and Backstage manifest.","tags":["dotnet","csharp","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"e08f1151-4161-404e-a9ef-f86e9166e3b4"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"dotnet-csharp-app-demo"},"description":{"title":"Description","type":"string","description":"What does this microservice do?","default":".NET 8 C# microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"dotnet-csharp-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"{{ parameters.component_id }}","description":"{{ parameters.description }}","owner":"{{ parameters.owner }}","system":"{{ parameters.system }}","destinationOwner":"{{ parameters.destinationOwner }}"}}},{"id":"publish","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"{{ parameters.description }}","repoUrl":"github.com?owner={{ parameters.destinationOwner }}&repo={{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"{{ steps.publish.output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"{{ steps.publish.output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"{{ steps.register.output.entityRef }}"}]}}}', '{}', '[]', '2026-11-03 00:21:09.428118+00', '2026-11-03 00:19:27.603977+00', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('8f54f8c6-eb39-4b4b-a6e2-e1ada1f5c15d', 'location:default/generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/"},"name":"generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce","uid":"8f54f8c6-eb39-4b4b-a6e2-e1ada1f5c15d"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml"}}', '{}', '[]', '2026-11-03 00:21:09.428118+00', '2026-11-02 19:53:47.183081+00', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'template:default/nodejs-sonarqube-cicd-template', '{"apiVersion":"backstage.io/v1beta2","kind":"Template","metadata":{"name":"nodejs-sonarqube-cicd-template","title":"Node.js 20 Web App + CI/CD with SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Node.js 20 microservice repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki JSON logs, and Backstage manifest.","tags":["node","nodejs","javascript","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml"}},"spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"nodejs-app-demo"},"description":{"title":"Description","type":"string","description":"What does this Node.js microservice do?","default":"Node.js 20 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"nodejs-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"{{ parameters.component_id }}","description":"{{ parameters.description }}","owner":"{{ parameters.owner }}","system":"{{ parameters.system }}","destinationOwner":"{{ parameters.destinationOwner }}"}}},{"id":"publish","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"{{ parameters.description }}","repoUrl":"github.com?owner={{ parameters.destinationOwner }}&repo={{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"{{ steps.publish.output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"{{ steps.publish.output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"{{ steps.register.output.entityRef }}"}]}}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/nodejs-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/"},"name":"nodejs-sonarqube-cicd-template","title":"Node.js 20 Web App + CI/CD with SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Node.js 20 microservice repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki JSON logs, and Backstage manifest.","tags":["node","nodejs","javascript","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"cbf1609f-cb2c-4a1f-8241-d19ef4075bf7"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"nodejs-app-demo"},"description":{"title":"Description","type":"string","description":"What does this Node.js microservice do?","default":"Node.js 20 microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"nodejs-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"{{ parameters.component_id }}","description":"{{ parameters.description }}","owner":"{{ parameters.owner }}","system":"{{ parameters.system }}","destinationOwner":"{{ parameters.destinationOwner }}"}}},{"id":"publish","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"{{ parameters.description }}","repoUrl":"github.com?owner={{ parameters.destinationOwner }}&repo={{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"{{ steps.publish.output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"{{ steps.publish.output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"{{ steps.register.output.entityRef }}"}]}}}', '{}', '[]', '2026-11-03 00:21:11.429433+00', '2026-11-03 00:19:29.636306+00', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'component:default/keycloak-sso', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"keycloak-sso","description":"Servidor Keycloak IAM (Broker SAML 2.0, OAuth2 e OIDC) federado via LDAP ao Samba 4 AD para autenticar Backstage, ArgoCD, Grafana e Apps Demo","annotations":{"github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"samba-ad-keycloak","backstage.io/kubernetes-id":"keycloak-sso","backstage.io/kubernetes-namespace":"default","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"samba-ad-keycloak","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"},"tags":["keycloak","saml2","oidc","sso","mfa"],"links":[{"url":"https://github.com/cirodasilvaj/samba-ad-keycloak","title":"GitHub Source Code","icon":"github"},{"url":"http://sso.992382723408.realhandsonlabs.net","title":"Keycloak SSO Realm","icon":"web"},{"url":"http://sso.992382723408.realhandsonlabs.net/admin","title":"Keycloak Admin Console","icon":"admin"},{"url":"http://sso.992382723408.realhandsonlabs.net/realms/empresa/.well-known/openid-configuration","title":"OIDC Discovery Configuration","icon":"lock"},{"url":"http://sso.992382723408.realhandsonlabs.net/realms/empresa/protocol/saml/descriptor","title":"SAML 2.0 Metadata Descriptor","icon":"lock"}]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","dependsOn":["component:default/samba-ad-dc","component:default/freeradius-mfa"],"providesApis":["saml-idp-api","oidc-idp-api"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/","github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"samba-ad-keycloak","backstage.io/kubernetes-id":"keycloak-sso","backstage.io/kubernetes-namespace":"default","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"samba-ad-keycloak"},"name":"keycloak-sso","description":"Servidor Keycloak IAM (Broker SAML 2.0, OAuth2 e OIDC) federado via LDAP ao Samba 4 AD para autenticar Backstage, ArgoCD, Grafana e Apps Demo","tags":["keycloak","saml2","oidc","sso","mfa"],"links":[{"url":"https://github.com/cirodasilvaj/samba-ad-keycloak","title":"GitHub Source Code","icon":"github"},{"url":"http://sso.992382723408.realhandsonlabs.net","title":"Keycloak SSO Realm","icon":"web"},{"url":"http://sso.992382723408.realhandsonlabs.net/admin","title":"Keycloak Admin Console","icon":"admin"},{"url":"http://sso.992382723408.realhandsonlabs.net/realms/empresa/.well-known/openid-configuration","title":"OIDC Discovery Configuration","icon":"lock"},{"url":"http://sso.992382723408.realhandsonlabs.net/realms/empresa/protocol/saml/descriptor","title":"SAML 2.0 Metadata Descriptor","icon":"lock"}],"uid":"c8b70617-2a07-4099-aa00-3e429fc52c3f"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","dependsOn":["component:default/samba-ad-dc","component:default/freeradius-mfa"],"providesApis":["saml-idp-api","oidc-idp-api"]}}', '{}', '[]', '2026-11-03 00:21:09.428118+00', '2026-11-03 00:19:27.598601+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('dd4b07f1-662a-49b8-8764-5d5845540a4e', 'location:default/generated-6e615a027feacec08857bccd2c90fef1db2a2372', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-6e615a027feacec08857bccd2c90fef1db2a2372","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/a360-business/accelera-skills/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-6e615a027feacec08857bccd2c90fef1db2a2372","uid":"dd4b07f1-662a-49b8-8764-5d5845540a4e"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/accelera-skills/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/accelera-skills/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/accelera-skills/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:09.690262+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('39f21457-07ab-4140-9a0a-9ab2a68f7e28', 'location:default/generated-6bcefc9bd5af69ed0137a6ce0836fe36e0fef7f2', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-6bcefc9bd5af69ed0137a6ce0836fe36e0fef7f2","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/bs-tutelas-patentes-site/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-6bcefc9bd5af69ed0137a6ce0836fe36e0fef7f2","uid":"39f21457-07ab-4140-9a0a-9ab2a68f7e28"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/bs-tutelas-patentes-site/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/bs-tutelas-patentes-site/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/bs-tutelas-patentes-site/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:10.428747+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('af5d5b44-ad56-4ccb-945a-d9f92fc651e6', 'location:default/generated-fe0f1bf72ec2879f9e6e9673b75d2a1f020b3878', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-fe0f1bf72ec2879f9e6e9673b75d2a1f020b3878","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/a360-business/galeed-community/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-fe0f1bf72ec2879f9e6e9673b75d2a1f020b3878","uid":"af5d5b44-ad56-4ccb-945a-d9f92fc651e6"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/galeed-community/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:09.770323+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'component:default/dotnet-csharp-demo-app', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"dotnet-csharp-demo-app","title":".NET 8 C# Minimal API Microservice","description":"App Web em C# (.NET 8 Minimal API) com Prometheus metrics, logs JSON para Grafana Loki, SonarQube Quality Gate, GitOps via ArgoCD e HTTPS via AWS ACM.","annotations":{"github.com/project-slug":"cirodasilvaj/apps-demo-2026","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"dotnet-csharp-demo-app","grafana/tag-selector":"service:dotnet-csharp-demo-app","grafana/overview-dashboard":"http://grafana.992382723408.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe","argocd/app-name":"dotnet-csharp-app","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml"},"tags":["dotnet","csharp","sonarqube","prometheus","fluentd","loki","grafana","k8s","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app","title":"GitHub Source Code","icon":"github"},{"url":"http://dotnet.992382723408.realhandsonlabs.net","title":".NET 8 C# Live App (HTTP)","icon":"web"},{"url":"https://dotnet.992382723408.realhandsonlabs.net","title":".NET 8 C# Live App (HTTPS ACM)","icon":"lock"},{"url":"http://dotnet.992382723408.realhandsonlabs.net/metrics","title":"Prometheus Metrics (/metrics)","icon":"gauge"},{"url":"http://grafana.992382723408.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe","title":"Grafana Dashboard (Golden Signals & Loki Logs)","icon":"dashboard"},{"url":"http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=apps-demo-2026","title":"SonarQube Quality Gate","icon":"check"},{"url":"https://argocd.992382723408.realhandsonlabs.net/applications/dotnet-csharp-app","title":"ArgoCD GitOps","icon":"sync"}]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","providesApis":["dotnet-csharp-app-api"],"dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/","github.com/project-slug":"cirodasilvaj/apps-demo-2026","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"dotnet-csharp-demo-app","grafana/tag-selector":"service:dotnet-csharp-demo-app","grafana/overview-dashboard":"http://grafana.992382723408.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe","argocd/app-name":"dotnet-csharp-app"},"name":"dotnet-csharp-demo-app","title":".NET 8 C# Minimal API Microservice","description":"App Web em C# (.NET 8 Minimal API) com Prometheus metrics, logs JSON para Grafana Loki, SonarQube Quality Gate, GitOps via ArgoCD e HTTPS via AWS ACM.","tags":["dotnet","csharp","sonarqube","prometheus","fluentd","loki","grafana","k8s","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app","title":"GitHub Source Code","icon":"github"},{"url":"http://dotnet.992382723408.realhandsonlabs.net","title":".NET 8 C# Live App (HTTP)","icon":"web"},{"url":"https://dotnet.992382723408.realhandsonlabs.net","title":".NET 8 C# Live App (HTTPS ACM)","icon":"lock"},{"url":"http://dotnet.992382723408.realhandsonlabs.net/metrics","title":"Prometheus Metrics (/metrics)","icon":"gauge"},{"url":"http://grafana.992382723408.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe","title":"Grafana Dashboard (Golden Signals & Loki Logs)","icon":"dashboard"},{"url":"http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=apps-demo-2026","title":"SonarQube Quality Gate","icon":"check"},{"url":"https://argocd.992382723408.realhandsonlabs.net/applications/dotnet-csharp-app","title":"ArgoCD GitOps","icon":"sync"}],"uid":"526e7749-f3f6-4d20-83a4-549c09c21024"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","providesApis":["dotnet-csharp-app-api"],"dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-03 00:21:08.427858+00', '2026-11-03 00:19:27.733065+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('1503a318-6894-4f0d-b372-0a31b1d954a9', 'location:default/generated-c377ebbfb933b0a54dfd0e158734712e21979bde', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-c377ebbfb933b0a54dfd0e158734712e21979bde","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/FernandoNesi/galeed-community/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-c377ebbfb933b0a54dfd0e158734712e21979bde","uid":"1503a318-6894-4f0d-b372-0a31b1d954a9"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/FernandoNesi/galeed-community/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/FernandoNesi/galeed-community/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/FernandoNesi/galeed-community/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:09.690262+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('cd28be50-4ca3-4f8b-9f46-7373e1e92545', 'location:default/generated-b44b1f6c085e8ca890654a6f6755902d78d4c46b', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-b44b1f6c085e8ca890654a6f6755902d78d4c46b","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/vini-brito/growth-os-skills-full/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-b44b1f6c085e8ca890654a6f6755902d78d4c46b","uid":"cd28be50-4ca3-4f8b-9f46-7373e1e92545"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/vini-brito/growth-os-skills-full/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/vini-brito/growth-os-skills-full/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/vini-brito/growth-os-skills-full/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:10.428747+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('96a807de-0f76-4a71-b1d2-fbb244ee6678', 'location:default/generated-83f2543400bad694b3b4169b8f0dda74347f09ca', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-83f2543400bad694b3b4169b8f0dda74347f09ca","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/talerelayapp/superfria/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-83f2543400bad694b3b4169b8f0dda74347f09ca","uid":"96a807de-0f76-4a71-b1d2-fbb244ee6678"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/talerelayapp/superfria/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/talerelayapp/superfria/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/talerelayapp/superfria/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:10.428747+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'api:default/ldap-ad-api', '{"apiVersion":"backstage.io/v1alpha1","kind":"API","metadata":{"name":"ldap-ad-api","description":"Endpoint LDAP/LDAPS Round-Robin do Samba 4 AD (ldap://ad.empresa.local:389)","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"}},"spec":{"type":"grpc","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"syntax = \"proto3\";\nservice ActiveDirectoryLDAP {\n  // ldap://ad.empresa.local:389 (Round-Robin DC1 & DC2)\n  // Base DN: DC=empresa,DC=local\n}\n"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"ldap-ad-api","description":"Endpoint LDAP/LDAPS Round-Robin do Samba 4 AD (ldap://ad.empresa.local:389)","uid":"ff3f673b-6c22-41eb-a709-e5ea84b5191c"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"grpc","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"syntax = \"proto3\";\nservice ActiveDirectoryLDAP {\n  // ldap://ad.empresa.local:389 (Round-Robin DC1 & DC2)\n  // Base DN: DC=empresa,DC=local\n}\n"}}', '{}', '[]', '2026-11-03 00:21:09.690262+00', '2026-11-03 00:19:27.598601+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('6206c4ce-84cd-4dd6-8547-d58912b69324', 'location:default/generated-c7cbc24b24c9bd1238a6138087c948db5f143a8a', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-c7cbc24b24c9bd1238a6138087c948db5f143a8a","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvajardim-crypto/mesa-site-institucional/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-c7cbc24b24c9bd1238a6138087c948db5f143a8a","uid":"6206c4ce-84cd-4dd6-8547-d58912b69324"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvajardim-crypto/mesa-site-institucional/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvajardim-crypto/mesa-site-institucional/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvajardim-crypto/mesa-site-institucional/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:10.428747+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'component:default/python-demo-app', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"python-demo-app","title":"Python 3.12 Flask Microservice","description":"App Web em Python 3.12 (Flask) com Prometheus metrics, logs JSON para Grafana Loki, SonarQube Quality Gate, GitOps via ArgoCD e HTTPS via AWS ACM.","annotations":{"github.com/project-slug":"cirodasilvaj/apps-demo-2026","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"python-demo-app","grafana/tag-selector":"service:python-demo-app","grafana/overview-dashboard":"http://grafana.992382723408.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12","argocd/app-name":"python-app","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml"},"tags":["python","flask","sonarqube","prometheus","fluentd","loki","grafana","k8s","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app","title":"GitHub Source Code","icon":"github"},{"url":"http://python.992382723408.realhandsonlabs.net","title":"Python 3.12 Live App (HTTP)","icon":"web"},{"url":"https://python.992382723408.realhandsonlabs.net","title":"Python 3.12 Live App (HTTPS ACM)","icon":"lock"},{"url":"http://python.992382723408.realhandsonlabs.net/metrics","title":"Prometheus Metrics (/metrics)","icon":"gauge"},{"url":"http://grafana.992382723408.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12","title":"Grafana Dashboard (Golden Signals & Loki Logs)","icon":"dashboard"},{"url":"http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=apps-demo-2026","title":"SonarQube Quality Gate","icon":"check"},{"url":"https://argocd.992382723408.realhandsonlabs.net/applications/python-app","title":"ArgoCD GitOps","icon":"sync"}]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","providesApis":["python-app-api"],"dependsOn":["resource:default/kube-demo-eks"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/","github.com/project-slug":"cirodasilvaj/apps-demo-2026","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"python-demo-app","grafana/tag-selector":"service:python-demo-app","grafana/overview-dashboard":"http://grafana.992382723408.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12","argocd/app-name":"python-app"},"name":"python-demo-app","title":"Python 3.12 Flask Microservice","description":"App Web em Python 3.12 (Flask) com Prometheus metrics, logs JSON para Grafana Loki, SonarQube Quality Gate, GitOps via ArgoCD e HTTPS via AWS ACM.","tags":["python","flask","sonarqube","prometheus","fluentd","loki","grafana","k8s","argocd"],"links":[{"url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app","title":"GitHub Source Code","icon":"github"},{"url":"http://python.992382723408.realhandsonlabs.net","title":"Python 3.12 Live App (HTTP)","icon":"web"},{"url":"https://python.992382723408.realhandsonlabs.net","title":"Python 3.12 Live App (HTTPS ACM)","icon":"lock"},{"url":"http://python.992382723408.realhandsonlabs.net/metrics","title":"Prometheus Metrics (/metrics)","icon":"gauge"},{"url":"http://grafana.992382723408.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12","title":"Grafana Dashboard (Golden Signals & Loki Logs)","icon":"dashboard"},{"url":"http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=apps-demo-2026","title":"SonarQube Quality Gate","icon":"check"},{"url":"https://argocd.992382723408.realhandsonlabs.net/applications/python-app","title":"ArgoCD GitOps","icon":"sync"}],"uid":"5d70a2d8-41a8-4321-b3e8-558a2769b323"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"apps-demo-2026","providesApis":["python-app-api"],"dependsOn":["resource:default/kube-demo-eks"]}}', '{}', '[]', '2026-11-03 00:21:09.428118+00', '2026-11-03 00:19:27.640023+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('bc4ebcf5-c998-4f61-ab16-3ac80fd4490f', 'location:default/generated-fa205f62d462a6f82aa4a1b49761425165444beb', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-fa205f62d462a6f82aa4a1b49761425165444beb","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/master-developer-nandomatik/growth-os-skills-full/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-fa205f62d462a6f82aa4a1b49761425165444beb","uid":"bc4ebcf5-c998-4f61-ab16-3ac80fd4490f"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/master-developer-nandomatik/growth-os-skills-full/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/master-developer-nandomatik/growth-os-skills-full/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/master-developer-nandomatik/growth-os-skills-full/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:10.428747+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('849ec066-af2d-4eb7-8084-8674deff2066', 'location:default/generated-bd14bea673b37261e7a74bd04975480bb069f8bc', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-bd14bea673b37261e7a74bd04975480bb069f8bc","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/a360-business/a360-dev-multiagentes/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-bd14bea673b37261e7a74bd04975480bb069f8bc","uid":"849ec066-af2d-4eb7-8084-8674deff2066"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/a360-business/a360-dev-multiagentes/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/a360-business/a360-dev-multiagentes/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/a360-business/a360-dev-multiagentes/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:10.609567+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'api:default/radius-mfa-api', '{"apiVersion":"backstage.io/v1alpha1","kind":"API","metadata":{"name":"radius-mfa-api","description":"Endpoint FreeRADIUS Auth (UDP 1812) e Acct (UDP 1813) com suporte a MFA (radius.empresa.local)","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"}},"spec":{"type":"grpc","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"syntax = \"proto3\";\nservice FreeRadiusMFA {\n  // UDP radius.empresa.local:1812 (Auth + MFA)\n  // UDP radius.empresa.local:1813 (Accounting)\n}\n"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/"},"name":"radius-mfa-api","description":"Endpoint FreeRADIUS Auth (UDP 1812) e Acct (UDP 1813) com suporte a MFA (radius.empresa.local)","uid":"aaba2d47-d59f-46f6-9305-53637bf8ece9"},"apiVersion":"backstage.io/v1alpha1","kind":"API","spec":{"type":"grpc","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","definition":"syntax = \"proto3\";\nservice FreeRadiusMFA {\n  // UDP radius.empresa.local:1812 (Auth + MFA)\n  // UDP radius.empresa.local:1813 (Accounting)\n}\n"}}', '{}', '[]', '2026-11-03 00:21:09.428118+00', '2026-11-03 00:19:27.598601+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('b9fc798e-c450-4cff-b55b-5176288fd3ea', 'location:default/generated-d6c74b7d4667a209e2cd1841e6d838c0d7d20c98', '{"apiVersion":"backstage.io/v1alpha1","kind":"Location","metadata":{"name":"generated-d6c74b7d4667a209e2cd1841e6d838c0d7d20c98","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"}},"spec":{"type":"url","target":"https://github.com/cirodasilvaj/counter-service-exercise/blob/main/catalog-info.yaml"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml"},"name":"generated-d6c74b7d4667a209e2cd1841e6d838c0d7d20c98","uid":"b9fc798e-c450-4cff-b55b-5176288fd3ea"},"apiVersion":"backstage.io/v1alpha1","kind":"Location","spec":{"type":"url","target":"https://github.com/cirodasilvaj/counter-service-exercise/blob/main/catalog-info.yaml"}}', '{}', '[{"name":"NotFoundError","message":"Unable to read url, NotFoundError: https://github.com/cirodasilvaj/counter-service-exercise/blob/main/catalog-info.yaml could not be read as https://api.github.com/repos/cirodasilvaj/counter-service-exercise/contents/catalog-info.yaml?ref=main, 404 Not Found"}]', '2026-11-03 00:21:10.609567+00', '2026-11-03 00:19:28.252076+00', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'template:default/python-sonarqube-cicd-template', '{"apiVersion":"backstage.io/v1beta2","kind":"Template","metadata":{"name":"python-sonarqube-cicd-template","title":"Python 3.12 Web App + CI/CD with QA, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Python (Flask + Gunicorn) repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki logging, and Backstage manifest.","tags":["python","flask","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml"}},"spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"python-app-demo"},"description":{"title":"Description","type":"string","description":"What does this microservice do?","default":"Python microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"python-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"{{ parameters.component_id }}","description":"{{ parameters.description }}","owner":"{{ parameters.owner }}","system":"{{ parameters.system }}","destinationOwner":"{{ parameters.destinationOwner }}"}}},{"id":"publish","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"{{ parameters.description }}","repoUrl":"github.com?owner={{ parameters.destinationOwner }}&repo={{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"{{ steps.publish.output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"{{ steps.publish.output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"{{ steps.register.output.entityRef }}"}]}}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/python-sonarqube-cicd/template.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/"},"name":"python-sonarqube-cicd-template","title":"Python 3.12 Web App + CI/CD with QA, SonarQube, Prometheus & Fluentd/Loki","description":"Creates a complete Python (Flask + Gunicorn) repository with automated QA tests, SonarQube Quality Gate validation, Prometheus /metrics, Fluentd -> Loki logging, and Backstage manifest.","tags":["python","flask","k8s","sonarqube","prometheus","fluentd","loki","cicd"],"uid":"a9a1752a-cf74-47af-9a22-dede131c4c5d"},"apiVersion":"backstage.io/v1beta2","kind":"Template","spec":{"owner":"squad-plataforma","type":"service","parameters":[{"title":"Component Information","required":["component_id","owner","description"],"properties":{"component_id":{"title":"Service Name","type":"string","description":"Unique identifier (lowercase letters and hyphens)","pattern":"^[a-z0-9-]+$","default":"python-app-demo"},"description":{"title":"Description","type":"string","description":"What does this microservice do?","default":"Python microservice with SonarQube Quality Gate, Prometheus metrics and Fluentd/Loki logs"},"owner":{"title":"Responsible Team","type":"string","description":"Squad that owns the application (e.g., squad-checkout)","default":"platform-team"},"system":{"title":"System / Domain","type":"string","default":"kube-demo-2026"}}},{"title":"Git Destination","required":["destinationOwner","repository"],"properties":{"destinationOwner":{"title":"GitHub Owner / Organization","type":"string","description":"GitHub user or organization where the repository will be created","default":"cirodasilvaj"},"repository":{"title":"GitHub Repository Name","type":"string","description":"Target repository name to create on GitHub","default":"python-app-demo"}}}],"steps":[{"id":"fetch-base","name":"Rendering Template","action":"fetch:template","input":{"url":"./skeleton","values":{"component_id":"{{ parameters.component_id }}","description":"{{ parameters.description }}","owner":"{{ parameters.owner }}","system":"{{ parameters.system }}","destinationOwner":"{{ parameters.destinationOwner }}"}}},{"id":"publish","name":"Publishing Repository to GitHub","action":"publish:github","input":{"allowedHosts":["github.com"],"description":"{{ parameters.description }}","repoUrl":"github.com?owner={{ parameters.destinationOwner }}&repo={{ parameters.repository }}","defaultBranch":"main","repoVisibility":"public"}},{"id":"register","name":"Registering in Backstage","action":"catalog:register","input":{"repoContentsUrl":"{{ steps.publish.output.repoContentsUrl }}","catalogInfoPath":"/catalog-info.yaml"}}],"output":{"links":[{"title":"Open Git Repository","url":"{{ steps.publish.output.remoteUrl }}"},{"title":"View in Backstage Catalog","icon":"catalog","entityRef":"{{ steps.register.output.entityRef }}"}]}}}', '{}', '[]', '2026-11-03 00:21:08.601171+00', '2026-11-03 00:19:27.79089+00', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.refresh_state VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'system:default/apps-demo-2026', '{"apiVersion":"backstage.io/v1alpha1","kind":"System","metadata":{"name":"apps-demo-2026","title":"Apps Demo 2026 Ecosystem","description":"Microservices Demo Collection (Python 3.12 Flask, .NET 8 C# Minimal API) with CI/CD, SonarQube, Prometheus Metrics, Fluentd/Loki Logs, GitOps via ArgoCD and HTTPS via AWS ACM.","annotations":{"backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml"}},"spec":{"owner":"platform-team"}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/apps-demo-2026/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/"},"name":"apps-demo-2026","title":"Apps Demo 2026 Ecosystem","description":"Microservices Demo Collection (Python 3.12 Flask, .NET 8 C# Minimal API) with CI/CD, SonarQube, Prometheus Metrics, Fluentd/Loki Logs, GitOps via ArgoCD and HTTPS via AWS ACM.","uid":"da0ddf52-10a0-4392-b061-72d5576c80db"},"apiVersion":"backstage.io/v1alpha1","kind":"System","spec":{"owner":"platform-team"}}', '{}', '[]', '2026-11-03 00:21:09.428118+00', '2026-11-03 00:19:27.733874+00', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml');
INSERT INTO public.refresh_state VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'component:default/samba-ad-dc', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"samba-ad-dc","description":"Samba 4 Active Directory Multi-DC (DC1 Principal + DC2 Réplica em Multi-AZ com --dns-backend=NONE e Route 53 Private Hosted Zone)","annotations":{"github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"samba-ad-keycloak","backstage.io/kubernetes-id":"samba-ad-dc","backstage.io/kubernetes-namespace":"default","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"samba-ad-keycloak","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml"},"tags":["samba4","active-directory","ldap","kerberos","route53"],"links":[{"url":"https://github.com/cirodasilvaj/samba-ad-keycloak","title":"GitHub Source Code","icon":"github"}]},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","providesApis":["ldap-ad-api"]}}', '{"metadata":{"namespace":"default","annotations":{"backstage.io/managed-by-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/managed-by-origin-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml","backstage.io/view-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml","backstage.io/edit-url":"https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml","backstage.io/source-location":"url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/","github.com/project-slug":"cirodasilvaj/samba-ad-keycloak","backstage.io/techdocs-ref":"dir:.","sonarqube.org/project-key":"samba-ad-keycloak","backstage.io/kubernetes-id":"samba-ad-dc","backstage.io/kubernetes-namespace":"default","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/dashboard-selector":"samba-ad-keycloak"},"name":"samba-ad-dc","description":"Samba 4 Active Directory Multi-DC (DC1 Principal + DC2 Réplica em Multi-AZ com --dns-backend=NONE e Route 53 Private Hosted Zone)","tags":["samba4","active-directory","ldap","kerberos","route53"],"links":[{"url":"https://github.com/cirodasilvaj/samba-ad-keycloak","title":"GitHub Source Code","icon":"github"}],"uid":"7df42e7c-cdc7-4f6f-853b-4ecd0335e728"},"apiVersion":"backstage.io/v1alpha1","kind":"Component","spec":{"type":"service","lifecycle":"production","owner":"platform-team","system":"samba-ad-keycloak-iam","providesApis":["ldap-ad-api"]}}', '{}', '[]', '2026-11-03 00:21:09.643801+00', '2026-11-03 00:19:27.598601+00', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');


--
-- Data for Name: refresh_state_references; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.refresh_state_references VALUES (1, 'ConfigLocationProvider', NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec');
INSERT INTO public.refresh_state_references VALUES (2, 'ConfigLocationProvider', NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551');
INSERT INTO public.refresh_state_references VALUES (3, 'ConfigLocationProvider', NULL, 'location:default/generated-64bf0f42f04286e509e88978a740e76f33a6cc2a');
INSERT INTO public.refresh_state_references VALUES (4, 'ConfigLocationProvider', NULL, 'location:default/generated-b4f29ca1863623b0dea4276cfa3970b897899c36');
INSERT INTO public.refresh_state_references VALUES (5, 'ConfigLocationProvider', NULL, 'location:default/generated-7692b664b197d2303b0a28bb177c1b133773311c');
INSERT INTO public.refresh_state_references VALUES (6, 'ConfigLocationProvider', NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2');
INSERT INTO public.refresh_state_references VALUES (7, 'ConfigLocationProvider', NULL, 'location:default/generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98');
INSERT INTO public.refresh_state_references VALUES (8, 'ConfigLocationProvider', NULL, 'location:default/generated-689c18882dc297803e1a420c73b8783d094c8e17');
INSERT INTO public.refresh_state_references VALUES (9, 'ConfigLocationProvider', NULL, 'location:default/generated-e1e842392fd0da6efe989d25722f835228d60e05');
INSERT INTO public.refresh_state_references VALUES (10, 'ConfigLocationProvider', NULL, 'location:default/generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a');
INSERT INTO public.refresh_state_references VALUES (11, 'ConfigLocationProvider', NULL, 'location:default/generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce');
INSERT INTO public.refresh_state_references VALUES (8841, NULL, 'location:default/generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98', 'template:default/standard-microservice-template');
INSERT INTO public.refresh_state_references VALUES (8845, NULL, 'location:default/generated-689c18882dc297803e1a420c73b8783d094c8e17', 'template:default/python-sonarqube-cicd-template');
INSERT INTO public.refresh_state_references VALUES (7961, 'DefaultLocationStore', NULL, 'location:default/generated-6a784c45d310bbbb8ae6d987a8a58e15ee836489');
INSERT INTO public.refresh_state_references VALUES (8820, NULL, 'location:default/generated-d39e9e69bdff92426a0ef516ba3b7a18205f9ddc', 'component:default/scaffolder-starter-microservice');
INSERT INTO public.refresh_state_references VALUES (8821, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'user:default/guest');
INSERT INTO public.refresh_state_references VALUES (8822, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'group:default/platform-team');
INSERT INTO public.refresh_state_references VALUES (8823, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'system:default/kube-demo-2026');
INSERT INTO public.refresh_state_references VALUES (8824, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'resource:default/kube-demo-eks');
INSERT INTO public.refresh_state_references VALUES (8825, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'component:default/backstage-portal');
INSERT INTO public.refresh_state_references VALUES (8826, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'component:default/argocd');
INSERT INTO public.refresh_state_references VALUES (8827, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'component:default/grafana');
INSERT INTO public.refresh_state_references VALUES (8828, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'component:default/prometheus');
INSERT INTO public.refresh_state_references VALUES (8829, NULL, 'location:default/generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec', 'component:default/sonarqube');
INSERT INTO public.refresh_state_references VALUES (8831, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.refresh_state_references VALUES (8832, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'component:default/samba-ad-dc');
INSERT INTO public.refresh_state_references VALUES (8833, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'component:default/freeradius-mfa');
INSERT INTO public.refresh_state_references VALUES (8834, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'component:default/keycloak-sso');
INSERT INTO public.refresh_state_references VALUES (8835, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'api:default/saml-idp-api');
INSERT INTO public.refresh_state_references VALUES (8836, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'api:default/oidc-idp-api');
INSERT INTO public.refresh_state_references VALUES (8837, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'api:default/ldap-ad-api');
INSERT INTO public.refresh_state_references VALUES (8838, NULL, 'location:default/generated-230c2622c092081637053d0a834587aef4c2bae2', 'api:default/radius-mfa-api');
INSERT INTO public.refresh_state_references VALUES (8842, NULL, 'location:default/generated-7692b664b197d2303b0a28bb177c1b133773311c', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.refresh_state_references VALUES (8843, NULL, 'location:default/generated-7692b664b197d2303b0a28bb177c1b133773311c', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.refresh_state_references VALUES (8846, NULL, 'location:default/generated-64bf0f42f04286e509e88978a740e76f33a6cc2a', 'system:default/apps-demo-2026');
INSERT INTO public.refresh_state_references VALUES (8847, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-78a0f16f4da15640f067c17fea7b0935483fd142');
INSERT INTO public.refresh_state_references VALUES (8848, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-edb107c0bf74b8a4c4c763787b54180b9801f99b');
INSERT INTO public.refresh_state_references VALUES (8849, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-bd14bea673b37261e7a74bd04975480bb069f8bc');
INSERT INTO public.refresh_state_references VALUES (8850, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-796712c88a485ec71e012b5c5f4566412a5f5672');
INSERT INTO public.refresh_state_references VALUES (8851, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-fe0f1bf72ec2879f9e6e9673b75d2a1f020b3878');
INSERT INTO public.refresh_state_references VALUES (8830, NULL, 'location:default/generated-e1e842392fd0da6efe989d25722f835228d60e05', 'template:default/dotnet-sonarqube-cicd-template');
INSERT INTO public.refresh_state_references VALUES (8839, NULL, 'location:default/generated-b4f29ca1863623b0dea4276cfa3970b897899c36', 'component:default/python-demo-app');
INSERT INTO public.refresh_state_references VALUES (8840, NULL, 'location:default/generated-b4f29ca1863623b0dea4276cfa3970b897899c36', 'api:default/python-app-api');
INSERT INTO public.refresh_state_references VALUES (8844, NULL, 'location:default/generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a', 'template:default/jvm-springboot-sonarqube-cicd-template');
INSERT INTO public.refresh_state_references VALUES (8852, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-6e615a027feacec08857bccd2c90fef1db2a2372');
INSERT INTO public.refresh_state_references VALUES (8853, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-03b13b5fb17fe9a670e36e235ad81fd06fcfd666');
INSERT INTO public.refresh_state_references VALUES (8854, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-e40d9e847bb90a7610522a0d467185a8e079bb3e');
INSERT INTO public.refresh_state_references VALUES (8855, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-c7cbc24b24c9bd1238a6138087c948db5f143a8a');
INSERT INTO public.refresh_state_references VALUES (8856, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-39540a08be0bcb5645ee1d683b08d860953c5b44');
INSERT INTO public.refresh_state_references VALUES (8857, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-e461ccc7db88e98c2a26c40a0672f2e1edbfe4f0');
INSERT INTO public.refresh_state_references VALUES (8858, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-31a0877ed2bec2edf4feee46dd4161a60585d1ce');
INSERT INTO public.refresh_state_references VALUES (8859, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-023ff0c2d516eb7ee170b46c23edf162e464605b');
INSERT INTO public.refresh_state_references VALUES (8860, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-1f8726637b31d8323de2ea178b5ccd8c303f90fa');
INSERT INTO public.refresh_state_references VALUES (8861, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-bcfe70fc389b7b6f55a5728ad12e48fbb12a7627');
INSERT INTO public.refresh_state_references VALUES (8862, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-c377ebbfb933b0a54dfd0e158734712e21979bde');
INSERT INTO public.refresh_state_references VALUES (8863, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-6bcefc9bd5af69ed0137a6ce0836fe36e0fef7f2');
INSERT INTO public.refresh_state_references VALUES (8864, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-83f2543400bad694b3b4169b8f0dda74347f09ca');
INSERT INTO public.refresh_state_references VALUES (8865, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-d6eb614c9d4a9daaeb84a95d3fece1a6a0dd9916');
INSERT INTO public.refresh_state_references VALUES (8866, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-73a2399a7c2024519f325ee2a4e98268e82758b7');
INSERT INTO public.refresh_state_references VALUES (8867, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-d6c74b7d4667a209e2cd1841e6d838c0d7d20c98');
INSERT INTO public.refresh_state_references VALUES (8868, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-aea2074c195831a31fb8d1acdfcfd9ae7d08cd1b');
INSERT INTO public.refresh_state_references VALUES (8869, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-8f44ff1b0eee905e4f10b347f2f4cde12c6ecb91');
INSERT INTO public.refresh_state_references VALUES (8870, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-9a24efc486a6e189695017ff7d1ff5886f9498aa');
INSERT INTO public.refresh_state_references VALUES (8871, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-fa205f62d462a6f82aa4a1b49761425165444beb');
INSERT INTO public.refresh_state_references VALUES (8872, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-b44b1f6c085e8ca890654a6f6755902d78d4c46b');
INSERT INTO public.refresh_state_references VALUES (8873, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-1fa5db3a5d97294de3a94bed049e4c7133c78dca');
INSERT INTO public.refresh_state_references VALUES (8874, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-e67fab63afdcd722173e912706fe624b9df62c34');
INSERT INTO public.refresh_state_references VALUES (8875, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-d2a36c4260a85053ce94fbe9c674187459d272db');
INSERT INTO public.refresh_state_references VALUES (8876, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-3a49cafceb0ae80411060ab243ac7adf4cb8101e');
INSERT INTO public.refresh_state_references VALUES (8877, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-702a36957042d54fefb74573b3f2079c194a1849');
INSERT INTO public.refresh_state_references VALUES (8878, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-5c9e4afea8ffa75fba62cb03ab309d31fd5b98b3');
INSERT INTO public.refresh_state_references VALUES (8879, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-db60c7b251928fac7d8502c0c92b1fa486c7621b');
INSERT INTO public.refresh_state_references VALUES (8880, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-024455ef88eaf59fbb3261fdaa8dd9c1095d1ac7');
INSERT INTO public.refresh_state_references VALUES (8881, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-623b5bbb8262e0696340d3ea541298687d0b3e21');
INSERT INTO public.refresh_state_references VALUES (8882, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-0bc5455adc5c6e2724b4409f7f4382f145a48c31');
INSERT INTO public.refresh_state_references VALUES (8883, NULL, 'location:default/generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551', 'location:default/generated-47a88091bb52dcb96cc116a938257ca203c6cf66');
INSERT INTO public.refresh_state_references VALUES (8884, NULL, 'location:default/generated-47a88091bb52dcb96cc116a938257ca203c6cf66', 'component:default/bkstg-made-nodejs-demo22');
INSERT INTO public.refresh_state_references VALUES (8885, NULL, 'location:default/generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce', 'template:default/nodejs-sonarqube-cicd-template');


--
-- Data for Name: relations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.relations VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'component:default/scaffolder-starter-microservice', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'group:default/platform-team', 'ownerOf', 'component:default/scaffolder-starter-microservice');
INSERT INTO public.relations VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'component:default/scaffolder-starter-microservice', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'system:default/kube-demo-2026', 'hasPart', 'component:default/scaffolder-starter-microservice');
INSERT INTO public.relations VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'component:default/bakstg-nodejs-demo2', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'group:default/platform-team', 'ownerOf', 'component:default/bakstg-nodejs-demo2');
INSERT INTO public.relations VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'component:default/bakstg-nodejs-demo2', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'system:default/kube-demo-2026', 'hasPart', 'component:default/bakstg-nodejs-demo2');
INSERT INTO public.relations VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'resource:default/kube-demo-eks', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'group:default/platform-team', 'ownerOf', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'resource:default/kube-demo-eks', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'system:default/kube-demo-2026', 'hasPart', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'system:default/samba-ad-keycloak-iam', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'group:default/platform-team', 'ownerOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'api:default/dotnet-csharp-app-api', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'group:default/platform-team', 'ownerOf', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.relations VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'api:default/dotnet-csharp-app-api', 'partOf', 'system:default/apps-demo-2026');
INSERT INTO public.relations VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'system:default/apps-demo-2026', 'hasPart', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.relations VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'component:default/backstage-portal', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'group:default/platform-team', 'ownerOf', 'component:default/backstage-portal');
INSERT INTO public.relations VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'component:default/backstage-portal', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/backstage-portal');
INSERT INTO public.relations VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'component:default/backstage-portal', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'system:default/kube-demo-2026', 'hasPart', 'component:default/backstage-portal');
INSERT INTO public.relations VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'template:default/jvm-springboot-sonarqube-cicd-template', 'ownedBy', 'group:default/squad-plataforma');
INSERT INTO public.relations VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'group:default/squad-plataforma', 'ownerOf', 'template:default/jvm-springboot-sonarqube-cicd-template');
INSERT INTO public.relations VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'template:default/python-sonarqube-cicd-template', 'ownedBy', 'group:default/squad-plataforma');
INSERT INTO public.relations VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'group:default/squad-plataforma', 'ownerOf', 'template:default/python-sonarqube-cicd-template');
INSERT INTO public.relations VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'api:default/python-app-api', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'group:default/platform-team', 'ownerOf', 'api:default/python-app-api');
INSERT INTO public.relations VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'api:default/python-app-api', 'partOf', 'system:default/apps-demo-2026');
INSERT INTO public.relations VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'component:default/python-demo-app', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'system:default/apps-demo-2026', 'hasPart', 'api:default/python-app-api');
INSERT INTO public.relations VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'group:default/platform-team', 'ownerOf', 'component:default/python-demo-app');
INSERT INTO public.relations VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'component:default/python-demo-app', 'providesApi', 'api:default/python-app-api');
INSERT INTO public.relations VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'api:default/python-app-api', 'apiProvidedBy', 'component:default/python-demo-app');
INSERT INTO public.relations VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'component:default/python-demo-app', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/python-demo-app');
INSERT INTO public.relations VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'component:default/python-demo-app', 'partOf', 'system:default/apps-demo-2026');
INSERT INTO public.relations VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'system:default/apps-demo-2026', 'hasPart', 'component:default/python-demo-app');
INSERT INTO public.relations VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'component:default/samba-ad-dc', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'group:default/platform-team', 'ownerOf', 'component:default/samba-ad-dc');
INSERT INTO public.relations VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'component:default/samba-ad-dc', 'providesApi', 'api:default/ldap-ad-api');
INSERT INTO public.relations VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'api:default/ldap-ad-api', 'apiProvidedBy', 'component:default/samba-ad-dc');
INSERT INTO public.relations VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'component:default/samba-ad-dc', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'component:default/samba-ad-dc');
INSERT INTO public.relations VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'api:default/ldap-ad-api', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'group:default/platform-team', 'ownerOf', 'api:default/ldap-ad-api');
INSERT INTO public.relations VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'api:default/ldap-ad-api', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'api:default/ldap-ad-api');
INSERT INTO public.relations VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'api:default/saml-idp-api', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'group:default/platform-team', 'ownerOf', 'api:default/saml-idp-api');
INSERT INTO public.relations VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'api:default/saml-idp-api', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'api:default/saml-idp-api');
INSERT INTO public.relations VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'group:default/platform-team', 'hasMember', 'user:default/guest');
INSERT INTO public.relations VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'user:default/guest', 'memberOf', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'component:default/grafana', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'group:default/platform-team', 'ownerOf', 'component:default/grafana');
INSERT INTO public.relations VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'component:default/grafana', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/grafana');
INSERT INTO public.relations VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'component:default/grafana', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'system:default/kube-demo-2026', 'hasPart', 'component:default/grafana');
INSERT INTO public.relations VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'template:default/dotnet-sonarqube-cicd-template', 'ownedBy', 'group:default/squad-plataforma');
INSERT INTO public.relations VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'group:default/squad-plataforma', 'ownerOf', 'template:default/dotnet-sonarqube-cicd-template');
INSERT INTO public.relations VALUES ('a2a75b30-567d-43eb-947a-760437c05894', 'user:default/guest', 'memberOf', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('a2a75b30-567d-43eb-947a-760437c05894', 'group:default/platform-team', 'hasMember', 'user:default/guest');
INSERT INTO public.relations VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'template:default/standard-microservice-template', 'ownedBy', 'group:default/squad-plataforma');
INSERT INTO public.relations VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'group:default/squad-plataforma', 'ownerOf', 'template:default/standard-microservice-template');
INSERT INTO public.relations VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'api:default/radius-mfa-api', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'group:default/platform-team', 'ownerOf', 'api:default/radius-mfa-api');
INSERT INTO public.relations VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'api:default/radius-mfa-api', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'api:default/radius-mfa-api');
INSERT INTO public.relations VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'component:default/keycloak-sso');
INSERT INTO public.relations VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'template:default/nodejs-sonarqube-cicd-template', 'ownedBy', 'group:default/squad-plataforma');
INSERT INTO public.relations VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'group:default/squad-plataforma', 'ownerOf', 'template:default/nodejs-sonarqube-cicd-template');
INSERT INTO public.relations VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'component:default/prometheus', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'group:default/platform-team', 'ownerOf', 'component:default/prometheus');
INSERT INTO public.relations VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'component:default/prometheus', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/prometheus');
INSERT INTO public.relations VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'component:default/prometheus', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'system:default/kube-demo-2026', 'hasPart', 'component:default/prometheus');
INSERT INTO public.relations VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'component:default/argocd', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'group:default/platform-team', 'ownerOf', 'component:default/argocd');
INSERT INTO public.relations VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'component:default/argocd', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/argocd');
INSERT INTO public.relations VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'component:default/argocd', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'system:default/kube-demo-2026', 'hasPart', 'component:default/argocd');
INSERT INTO public.relations VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'component:default/bkstg-made-nodejs-demo22', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'group:default/platform-team', 'ownerOf', 'component:default/bkstg-made-nodejs-demo22');
INSERT INTO public.relations VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'component:default/bkstg-made-nodejs-demo22', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'system:default/kube-demo-2026', 'hasPart', 'component:default/bkstg-made-nodejs-demo22');
INSERT INTO public.relations VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'component:default/keycloak-sso', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'group:default/platform-team', 'ownerOf', 'component:default/keycloak-sso');
INSERT INTO public.relations VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'component:default/keycloak-sso', 'providesApi', 'api:default/saml-idp-api');
INSERT INTO public.relations VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'api:default/saml-idp-api', 'apiProvidedBy', 'component:default/keycloak-sso');
INSERT INTO public.relations VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'component:default/keycloak-sso', 'providesApi', 'api:default/oidc-idp-api');
INSERT INTO public.relations VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'api:default/oidc-idp-api', 'apiProvidedBy', 'component:default/keycloak-sso');
INSERT INTO public.relations VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'component:default/keycloak-sso', 'dependsOn', 'component:default/samba-ad-dc');
INSERT INTO public.relations VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'component:default/samba-ad-dc', 'dependencyOf', 'component:default/keycloak-sso');
INSERT INTO public.relations VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'component:default/keycloak-sso', 'dependsOn', 'component:default/freeradius-mfa');
INSERT INTO public.relations VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'component:default/freeradius-mfa', 'dependencyOf', 'component:default/keycloak-sso');
INSERT INTO public.relations VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'component:default/keycloak-sso', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'component:default/dotnet-csharp-demo-app', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'group:default/platform-team', 'ownerOf', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.relations VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'component:default/dotnet-csharp-demo-app', 'providesApi', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.relations VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'api:default/dotnet-csharp-app-api', 'apiProvidedBy', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.relations VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'component:default/dotnet-csharp-demo-app', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.relations VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'component:default/dotnet-csharp-demo-app', 'partOf', 'system:default/apps-demo-2026');
INSERT INTO public.relations VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'system:default/apps-demo-2026', 'hasPart', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.relations VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'system:default/apps-demo-2026', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'group:default/platform-team', 'ownerOf', 'system:default/apps-demo-2026');
INSERT INTO public.relations VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'system:default/kube-demo-2026', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'group:default/platform-team', 'ownerOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'component:default/sonarqube', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'group:default/platform-team', 'ownerOf', 'component:default/sonarqube');
INSERT INTO public.relations VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'component:default/sonarqube', 'dependsOn', 'resource:default/kube-demo-eks');
INSERT INTO public.relations VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'resource:default/kube-demo-eks', 'dependencyOf', 'component:default/sonarqube');
INSERT INTO public.relations VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'component:default/sonarqube', 'partOf', 'system:default/kube-demo-2026');
INSERT INTO public.relations VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'system:default/kube-demo-2026', 'hasPart', 'component:default/sonarqube');
INSERT INTO public.relations VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'component:default/freeradius-mfa', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'group:default/platform-team', 'ownerOf', 'component:default/freeradius-mfa');
INSERT INTO public.relations VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'component:default/freeradius-mfa', 'providesApi', 'api:default/radius-mfa-api');
INSERT INTO public.relations VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'api:default/radius-mfa-api', 'apiProvidedBy', 'component:default/freeradius-mfa');
INSERT INTO public.relations VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'component:default/freeradius-mfa', 'dependsOn', 'component:default/samba-ad-dc');
INSERT INTO public.relations VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'component:default/samba-ad-dc', 'dependencyOf', 'component:default/freeradius-mfa');
INSERT INTO public.relations VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'component:default/freeradius-mfa', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'component:default/freeradius-mfa');
INSERT INTO public.relations VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'api:default/oidc-idp-api', 'ownedBy', 'group:default/platform-team');
INSERT INTO public.relations VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'group:default/platform-team', 'ownerOf', 'api:default/oidc-idp-api');
INSERT INTO public.relations VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'api:default/oidc-idp-api', 'partOf', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.relations VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'system:default/samba-ad-keycloak-iam', 'hasPart', 'api:default/oidc-idp-api');


--
-- Data for Name: search; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.search VALUES ('91a4a62f-0e20-4d57-a546-55f9f325a6c6', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('91a4a62f-0e20-4d57-a546-55f9f325a6c6', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('91a4a62f-0e20-4d57-a546-55f9f325a6c6', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('91a4a62f-0e20-4d57-a546-55f9f325a6c6', 'kind', 'location');
INSERT INTO public.search VALUES ('91a4a62f-0e20-4d57-a546-55f9f325a6c6', 'spec.type', 'file');
INSERT INTO public.search VALUES ('91a4a62f-0e20-4d57-a546-55f9f325a6c6', 'spec.target', '/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('91a4a62f-0e20-4d57-a546-55f9f325a6c6', 'metadata.name', 'generated-551ae55c8f3f194e0109aef4e3d56dbab68e09ec');
INSERT INTO public.search VALUES ('91a4a62f-0e20-4d57-a546-55f9f325a6c6', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('91a4a62f-0e20-4d57-a546-55f9f325a6c6', 'metadata.uid', '91a4a62f-0e20-4d57-a546-55f9f325a6c6');
INSERT INTO public.search VALUES ('7c3a0812-4f6f-43f5-b7ba-15254e07e374', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('7c3a0812-4f6f-43f5-b7ba-15254e07e374', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('7c3a0812-4f6f-43f5-b7ba-15254e07e374', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('7c3a0812-4f6f-43f5-b7ba-15254e07e374', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('7c3a0812-4f6f-43f5-b7ba-15254e07e374', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/');
INSERT INTO public.search VALUES ('7c3a0812-4f6f-43f5-b7ba-15254e07e374', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('7c3a0812-4f6f-43f5-b7ba-15254e07e374', 'kind', 'location');
INSERT INTO public.search VALUES ('7c3a0812-4f6f-43f5-b7ba-15254e07e374', 'spec.type', 'url');
INSERT INTO public.search VALUES ('7c3a0812-4f6f-43f5-b7ba-15254e07e374', 'spec.target', 'https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('7c3a0812-4f6f-43f5-b7ba-15254e07e374', 'metadata.name', 'generated-7692b664b197d2303b0a28bb177c1b133773311c');
INSERT INTO public.search VALUES ('7c3a0812-4f6f-43f5-b7ba-15254e07e374', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('7c3a0812-4f6f-43f5-b7ba-15254e07e374', 'metadata.uid', '7c3a0812-4f6f-43f5-b7ba-15254e07e374');
INSERT INTO public.search VALUES ('c21e2a4f-66b6-42fa-8d52-8c654775fb77', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('c21e2a4f-66b6-42fa-8d52-8c654775fb77', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('c21e2a4f-66b6-42fa-8d52-8c654775fb77', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('c21e2a4f-66b6-42fa-8d52-8c654775fb77', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('c21e2a4f-66b6-42fa-8d52-8c654775fb77', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/');
INSERT INTO public.search VALUES ('c21e2a4f-66b6-42fa-8d52-8c654775fb77', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('c21e2a4f-66b6-42fa-8d52-8c654775fb77', 'kind', 'location');
INSERT INTO public.search VALUES ('c21e2a4f-66b6-42fa-8d52-8c654775fb77', 'spec.type', 'url');
INSERT INTO public.search VALUES ('c21e2a4f-66b6-42fa-8d52-8c654775fb77', 'spec.target', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('c21e2a4f-66b6-42fa-8d52-8c654775fb77', 'metadata.name', 'generated-689c18882dc297803e1a420c73b8783d094c8e17');
INSERT INTO public.search VALUES ('c21e2a4f-66b6-42fa-8d52-8c654775fb77', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('c21e2a4f-66b6-42fa-8d52-8c654775fb77', 'metadata.uid', 'c21e2a4f-66b6-42fa-8d52-8c654775fb77');
INSERT INTO public.search VALUES ('e5835291-d759-408a-b161-43106ca035df', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('e5835291-d759-408a-b161-43106ca035df', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('e5835291-d759-408a-b161-43106ca035df', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('e5835291-d759-408a-b161-43106ca035df', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('e5835291-d759-408a-b161-43106ca035df', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/');
INSERT INTO public.search VALUES ('e5835291-d759-408a-b161-43106ca035df', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('e5835291-d759-408a-b161-43106ca035df', 'kind', 'location');
INSERT INTO public.search VALUES ('e5835291-d759-408a-b161-43106ca035df', 'spec.type', 'url');
INSERT INTO public.search VALUES ('e5835291-d759-408a-b161-43106ca035df', 'spec.target', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('e5835291-d759-408a-b161-43106ca035df', 'metadata.name', 'generated-e1e842392fd0da6efe989d25722f835228d60e05');
INSERT INTO public.search VALUES ('e5835291-d759-408a-b161-43106ca035df', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('e5835291-d759-408a-b161-43106ca035df', 'metadata.uid', 'e5835291-d759-408a-b161-43106ca035df');
INSERT INTO public.search VALUES ('6983d607-a250-48aa-ade6-997553435d79', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml');
INSERT INTO public.search VALUES ('6983d607-a250-48aa-ade6-997553435d79', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml');
INSERT INTO public.search VALUES ('6983d607-a250-48aa-ade6-997553435d79', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml');
INSERT INTO public.search VALUES ('6983d607-a250-48aa-ade6-997553435d79', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/microservice-template/template.yaml');
INSERT INTO public.search VALUES ('6983d607-a250-48aa-ade6-997553435d79', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/');
INSERT INTO public.search VALUES ('6983d607-a250-48aa-ade6-997553435d79', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('6983d607-a250-48aa-ade6-997553435d79', 'kind', 'location');
INSERT INTO public.search VALUES ('6983d607-a250-48aa-ade6-997553435d79', 'spec.type', 'url');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'spec.type', 'grpc');
INSERT INTO public.search VALUES ('6983d607-a250-48aa-ade6-997553435d79', 'spec.target', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml');
INSERT INTO public.search VALUES ('6983d607-a250-48aa-ade6-997553435d79', 'metadata.name', 'generated-05e23b2d867eb6d7503e28e398f9e6aa8db76d98');
INSERT INTO public.search VALUES ('6983d607-a250-48aa-ade6-997553435d79', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('6983d607-a250-48aa-ade6-997553435d79', 'metadata.uid', '6983d607-a250-48aa-ade6-997553435d79');
INSERT INTO public.search VALUES ('5c335bb9-eb33-4dcb-8cdf-e02df2c7830a', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('5c335bb9-eb33-4dcb-8cdf-e02df2c7830a', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('5c335bb9-eb33-4dcb-8cdf-e02df2c7830a', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('5c335bb9-eb33-4dcb-8cdf-e02df2c7830a', 'kind', 'location');
INSERT INTO public.search VALUES ('5c335bb9-eb33-4dcb-8cdf-e02df2c7830a', 'spec.type', 'url');
INSERT INTO public.search VALUES ('5c335bb9-eb33-4dcb-8cdf-e02df2c7830a', 'spec.target', 'https://github.com/cirodasilvaj/test-repo-check-permission/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('5c335bb9-eb33-4dcb-8cdf-e02df2c7830a', 'metadata.name', 'generated-702a36957042d54fefb74573b3f2079c194a1849');
INSERT INTO public.search VALUES ('5c335bb9-eb33-4dcb-8cdf-e02df2c7830a', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('5c335bb9-eb33-4dcb-8cdf-e02df2c7830a', 'metadata.uid', '5c335bb9-eb33-4dcb-8cdf-e02df2c7830a');
INSERT INTO public.search VALUES ('a0551093-7eae-45a6-bece-165c2dfdc2ea', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a0551093-7eae-45a6-bece-165c2dfdc2ea', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a0551093-7eae-45a6-bece-165c2dfdc2ea', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('a0551093-7eae-45a6-bece-165c2dfdc2ea', 'kind', 'location');
INSERT INTO public.search VALUES ('a0551093-7eae-45a6-bece-165c2dfdc2ea', 'spec.type', 'url');
INSERT INTO public.search VALUES ('a0551093-7eae-45a6-bece-165c2dfdc2ea', 'spec.target', 'https://github.com/cirodasilvaj/test-direct-pod-call/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'metadata.annotations.github.com/project-slug', 'cirobessa/kube-demo-2026');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'metadata.annotations.backstage.io/kubernetes-id', 'argocd');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'metadata.annotations.backstage.io/kubernetes-namespace', 'argocd');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'metadata.annotations.backstage.io/kubernetes-label-selector', 'app.kubernetes.io/part-of=argocd');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'metadata.title', 'argocd gitops');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'metadata.description', 'argocd gitops continuous delivery controller on eks');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'metadata.links.url', 'https://argocd.992382723408.realhandsonlabs.net');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'metadata.links.title', 'argocd web console (https acm)');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'metadata.links.icon', 'sync');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'metadata.links.url', 'https://github.com/cirobessa/kube-demo-2026');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'metadata.links.title', 'gitops cluster repository');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'metadata.links.icon', 'github');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'kind', 'component');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'spec.type', 'service');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'spec.system', 'kube-demo-2026');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'spec.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'spec.dependson.resource:default/kube-demo-eks', 'true');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'metadata.name', 'argocd');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'metadata.uid', 'c0075925-12d7-4dfa-b9fc-8324d2f99dcb');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'relations.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('c0075925-12d7-4dfa-b9fc-8324d2f99dcb', 'relations.partof', 'system:default/kube-demo-2026');
INSERT INTO public.search VALUES ('a0551093-7eae-45a6-bece-165c2dfdc2ea', 'metadata.name', 'generated-024455ef88eaf59fbb3261fdaa8dd9c1095d1ac7');
INSERT INTO public.search VALUES ('a0551093-7eae-45a6-bece-165c2dfdc2ea', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('a0551093-7eae-45a6-bece-165c2dfdc2ea', 'metadata.uid', 'a0551093-7eae-45a6-bece-165c2dfdc2ea');
INSERT INTO public.search VALUES ('2ddb3e60-40cf-4844-8e24-b7413752f9f3', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('2ddb3e60-40cf-4844-8e24-b7413752f9f3', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('2ddb3e60-40cf-4844-8e24-b7413752f9f3', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('2ddb3e60-40cf-4844-8e24-b7413752f9f3', 'kind', 'location');
INSERT INTO public.search VALUES ('2ddb3e60-40cf-4844-8e24-b7413752f9f3', 'spec.type', 'url');
INSERT INTO public.search VALUES ('2ddb3e60-40cf-4844-8e24-b7413752f9f3', 'spec.target', 'https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('2ddb3e60-40cf-4844-8e24-b7413752f9f3', 'metadata.name', 'generated-47a88091bb52dcb96cc116a938257ca203c6cf66');
INSERT INTO public.search VALUES ('2ddb3e60-40cf-4844-8e24-b7413752f9f3', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('2ddb3e60-40cf-4844-8e24-b7413752f9f3', 'metadata.uid', '2ddb3e60-40cf-4844-8e24-b7413752f9f3');
INSERT INTO public.search VALUES ('5a3770b1-36ac-439b-aae7-ad1e1c6f7a93', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('5a3770b1-36ac-439b-aae7-ad1e1c6f7a93', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('5a3770b1-36ac-439b-aae7-ad1e1c6f7a93', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('5a3770b1-36ac-439b-aae7-ad1e1c6f7a93', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('5a3770b1-36ac-439b-aae7-ad1e1c6f7a93', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/');
INSERT INTO public.search VALUES ('9877515a-425a-46df-9c60-2286fb06abda', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('5a3770b1-36ac-439b-aae7-ad1e1c6f7a93', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('5a3770b1-36ac-439b-aae7-ad1e1c6f7a93', 'kind', 'location');
INSERT INTO public.search VALUES ('5a3770b1-36ac-439b-aae7-ad1e1c6f7a93', 'spec.type', 'url');
INSERT INTO public.search VALUES ('9877515a-425a-46df-9c60-2286fb06abda', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('9877515a-425a-46df-9c60-2286fb06abda', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('9877515a-425a-46df-9c60-2286fb06abda', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('9877515a-425a-46df-9c60-2286fb06abda', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/');
INSERT INTO public.search VALUES ('9877515a-425a-46df-9c60-2286fb06abda', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('9877515a-425a-46df-9c60-2286fb06abda', 'kind', 'location');
INSERT INTO public.search VALUES ('9877515a-425a-46df-9c60-2286fb06abda', 'spec.type', 'url');
INSERT INTO public.search VALUES ('9877515a-425a-46df-9c60-2286fb06abda', 'spec.target', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('9877515a-425a-46df-9c60-2286fb06abda', 'metadata.name', 'generated-7b9925b4f8f1f623b54635616c6c676b027cdd4a');
INSERT INTO public.search VALUES ('9877515a-425a-46df-9c60-2286fb06abda', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('9877515a-425a-46df-9c60-2286fb06abda', 'metadata.uid', '9877515a-425a-46df-9c60-2286fb06abda');
INSERT INTO public.search VALUES ('5a3770b1-36ac-439b-aae7-ad1e1c6f7a93', 'spec.target', 'https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('5a3770b1-36ac-439b-aae7-ad1e1c6f7a93', 'metadata.name', 'generated-b4f29ca1863623b0dea4276cfa3970b897899c36');
INSERT INTO public.search VALUES ('5a3770b1-36ac-439b-aae7-ad1e1c6f7a93', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('5a3770b1-36ac-439b-aae7-ad1e1c6f7a93', 'metadata.uid', '5a3770b1-36ac-439b-aae7-ad1e1c6f7a93');
INSERT INTO public.search VALUES ('d70d519d-0082-403b-83f7-d3028813f332', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d70d519d-0082-403b-83f7-d3028813f332', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d70d519d-0082-403b-83f7-d3028813f332', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d70d519d-0082-403b-83f7-d3028813f332', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d70d519d-0082-403b-83f7-d3028813f332', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('d70d519d-0082-403b-83f7-d3028813f332', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('d70d519d-0082-403b-83f7-d3028813f332', 'kind', 'location');
INSERT INTO public.search VALUES ('d70d519d-0082-403b-83f7-d3028813f332', 'spec.type', 'url');
INSERT INTO public.search VALUES ('d70d519d-0082-403b-83f7-d3028813f332', 'spec.target', 'https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d70d519d-0082-403b-83f7-d3028813f332', 'metadata.name', 'generated-230c2622c092081637053d0a834587aef4c2bae2');
INSERT INTO public.search VALUES ('d70d519d-0082-403b-83f7-d3028813f332', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('d70d519d-0082-403b-83f7-d3028813f332', 'metadata.uid', 'd70d519d-0082-403b-83f7-d3028813f332');
INSERT INTO public.search VALUES ('8ddbcbb3-b67c-4c1d-9853-a9bb8b31d346', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('8ddbcbb3-b67c-4c1d-9853-a9bb8b31d346', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('8ddbcbb3-b67c-4c1d-9853-a9bb8b31d346', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('8ddbcbb3-b67c-4c1d-9853-a9bb8b31d346', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/apps-demo-2026/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('8ddbcbb3-b67c-4c1d-9853-a9bb8b31d346', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/');
INSERT INTO public.search VALUES ('8ddbcbb3-b67c-4c1d-9853-a9bb8b31d346', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('8ddbcbb3-b67c-4c1d-9853-a9bb8b31d346', 'kind', 'location');
INSERT INTO public.search VALUES ('8ddbcbb3-b67c-4c1d-9853-a9bb8b31d346', 'spec.type', 'url');
INSERT INTO public.search VALUES ('8ddbcbb3-b67c-4c1d-9853-a9bb8b31d346', 'spec.target', 'https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('8ddbcbb3-b67c-4c1d-9853-a9bb8b31d346', 'metadata.name', 'generated-64bf0f42f04286e509e88978a740e76f33a6cc2a');
INSERT INTO public.search VALUES ('8ddbcbb3-b67c-4c1d-9853-a9bb8b31d346', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('8ddbcbb3-b67c-4c1d-9853-a9bb8b31d346', 'metadata.uid', '8ddbcbb3-b67c-4c1d-9853-a9bb8b31d346');
INSERT INTO public.search VALUES ('66576428-ff82-4dc3-914e-6988c6259d76', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('66576428-ff82-4dc3-914e-6988c6259d76', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('66576428-ff82-4dc3-914e-6988c6259d76', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('66576428-ff82-4dc3-914e-6988c6259d76', 'kind', 'location');
INSERT INTO public.search VALUES ('66576428-ff82-4dc3-914e-6988c6259d76', 'spec.type', 'url');
INSERT INTO public.search VALUES ('66576428-ff82-4dc3-914e-6988c6259d76', 'spec.target', 'https://github.com/cirodasilvaj/backstage-permission-test-1793652634586/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('66576428-ff82-4dc3-914e-6988c6259d76', 'metadata.name', 'generated-5c9e4afea8ffa75fba62cb03ab309d31fd5b98b3');
INSERT INTO public.search VALUES ('66576428-ff82-4dc3-914e-6988c6259d76', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('66576428-ff82-4dc3-914e-6988c6259d76', 'metadata.uid', '66576428-ff82-4dc3-914e-6988c6259d76');
INSERT INTO public.search VALUES ('85ae82e4-e930-46a4-b3e7-26a9ad047a6f', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('85ae82e4-e930-46a4-b3e7-26a9ad047a6f', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'metadata.annotations.github.com/project-slug', 'cirobessa/kube-demo-2026');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'metadata.annotations.backstage.io/kubernetes-id', 'prometheus');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'metadata.annotations.backstage.io/kubernetes-namespace', 'monitoring');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'metadata.annotations.backstage.io/kubernetes-label-selector', 'app.kubernetes.io/name=prometheus');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'metadata.title', 'prometheus monitoring');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'metadata.description', 'prometheus metrics server & node exporter on eks');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'metadata.links.url', 'http://prometheus.992382723408.realhandsonlabs.net');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'metadata.links.title', 'prometheus web ui');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'metadata.links.icon', 'gauge');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'metadata.links.url', 'https://github.com/cirobessa/kube-demo-2026');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'metadata.links.title', 'prometheus manifests');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'metadata.links.icon', 'github');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'kind', 'component');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'spec.type', 'service');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'spec.system', 'kube-demo-2026');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'spec.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'spec.dependson.resource:default/kube-demo-eks', 'true');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'metadata.name', 'prometheus');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'metadata.uid', '6ba147d5-0d04-487e-b400-98ebc3a32caf');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'relations.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('6ba147d5-0d04-487e-b400-98ebc3a32caf', 'relations.partof', 'system:default/kube-demo-2026');
INSERT INTO public.search VALUES ('85ae82e4-e930-46a4-b3e7-26a9ad047a6f', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('85ae82e4-e930-46a4-b3e7-26a9ad047a6f', 'kind', 'location');
INSERT INTO public.search VALUES ('85ae82e4-e930-46a4-b3e7-26a9ad047a6f', 'spec.type', 'url');
INSERT INTO public.search VALUES ('85ae82e4-e930-46a4-b3e7-26a9ad047a6f', 'spec.target', 'https://github.com/cirodasilvaj/demo-microservice-backstage-2026/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('85ae82e4-e930-46a4-b3e7-26a9ad047a6f', 'metadata.name', 'generated-623b5bbb8262e0696340d3ea541298687d0b3e21');
INSERT INTO public.search VALUES ('85ae82e4-e930-46a4-b3e7-26a9ad047a6f', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('85ae82e4-e930-46a4-b3e7-26a9ad047a6f', 'metadata.uid', '85ae82e4-e930-46a4-b3e7-26a9ad047a6f');
INSERT INTO public.search VALUES ('a9695418-4b02-4a0b-bcb4-c58faab06eb8', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a9695418-4b02-4a0b-bcb4-c58faab06eb8', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a9695418-4b02-4a0b-bcb4-c58faab06eb8', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a9695418-4b02-4a0b-bcb4-c58faab06eb8', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/scaffolder-starter-microservice/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a9695418-4b02-4a0b-bcb4-c58faab06eb8', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/');
INSERT INTO public.search VALUES ('a9695418-4b02-4a0b-bcb4-c58faab06eb8', 'metadata.annotations.backstage.io/orphan', 'true');
INSERT INTO public.search VALUES ('a9695418-4b02-4a0b-bcb4-c58faab06eb8', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('a9695418-4b02-4a0b-bcb4-c58faab06eb8', 'kind', 'location');
INSERT INTO public.search VALUES ('a9695418-4b02-4a0b-bcb4-c58faab06eb8', 'spec.type', 'url');
INSERT INTO public.search VALUES ('a9695418-4b02-4a0b-bcb4-c58faab06eb8', 'spec.target', 'https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('a9695418-4b02-4a0b-bcb4-c58faab06eb8', 'metadata.name', 'generated-d39e9e69bdff92426a0ef516ba3b7a18205f9ddc');
INSERT INTO public.search VALUES ('c9965817-610e-41cd-90a5-62723cfcf426', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c9965817-610e-41cd-90a5-62723cfcf426', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c9965817-610e-41cd-90a5-62723cfcf426', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('c9965817-610e-41cd-90a5-62723cfcf426', 'kind', 'location');
INSERT INTO public.search VALUES ('c9965817-610e-41cd-90a5-62723cfcf426', 'spec.type', 'url');
INSERT INTO public.search VALUES ('c9965817-610e-41cd-90a5-62723cfcf426', 'spec.target', 'https://github.com/cirodasilvaj/test-repo-via-pat/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c9965817-610e-41cd-90a5-62723cfcf426', 'metadata.name', 'generated-db60c7b251928fac7d8502c0c92b1fa486c7621b');
INSERT INTO public.search VALUES ('c9965817-610e-41cd-90a5-62723cfcf426', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('c9965817-610e-41cd-90a5-62723cfcf426', 'metadata.uid', 'c9965817-610e-41cd-90a5-62723cfcf426');
INSERT INTO public.search VALUES ('a9695418-4b02-4a0b-bcb4-c58faab06eb8', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('a9695418-4b02-4a0b-bcb4-c58faab06eb8', 'metadata.uid', 'a9695418-4b02-4a0b-bcb4-c58faab06eb8');
INSERT INTO public.search VALUES ('a2a75b30-567d-43eb-947a-760437c05894', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('a2a75b30-567d-43eb-947a-760437c05894', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('a2a75b30-567d-43eb-947a-760437c05894', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('a2a75b30-567d-43eb-947a-760437c05894', 'kind', 'user');
INSERT INTO public.search VALUES ('a2a75b30-567d-43eb-947a-760437c05894', 'spec.profile.displayname', 'guest user');
INSERT INTO public.search VALUES ('a2a75b30-567d-43eb-947a-760437c05894', 'spec.profile.email', 'guest@empresa.local');
INSERT INTO public.search VALUES ('a2a75b30-567d-43eb-947a-760437c05894', 'spec.memberof', 'platform-team');
INSERT INTO public.search VALUES ('a2a75b30-567d-43eb-947a-760437c05894', 'spec.memberof.platform-team', 'true');
INSERT INTO public.search VALUES ('a2a75b30-567d-43eb-947a-760437c05894', 'metadata.name', 'guest');
INSERT INTO public.search VALUES ('a2a75b30-567d-43eb-947a-760437c05894', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('a2a75b30-567d-43eb-947a-760437c05894', 'metadata.uid', 'a2a75b30-567d-43eb-947a-760437c05894');
INSERT INTO public.search VALUES ('a2a75b30-567d-43eb-947a-760437c05894', 'relations.memberof', 'group:default/platform-team');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'metadata.annotations.github.com/project-slug', 'cirodasilvaj/backstage-infra');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'metadata.annotations.backstage.io/kubernetes-id', 'backstage');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'metadata.annotations.backstage.io/kubernetes-namespace', 'backstage');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'metadata.annotations.backstage.io/kubernetes-label-selector', 'app=backstage');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'metadata.title', 'backstage developer portal');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'metadata.description', 'backstage internal developer portal backed by aws rds postgresql and linked to eks');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'metadata.links.url', 'http://backstage.992382723408.realhandsonlabs.net');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'metadata.links.title', 'backstage portal ui');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'metadata.links.icon', 'dashboard');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'metadata.links.url', 'https://github.com/cirodasilvaj/backstage-infra');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'metadata.links.title', 'github infrastructure repo');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'metadata.links.icon', 'github');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'kind', 'component');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'spec.type', 'website');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'spec.system', 'kube-demo-2026');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'spec.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'spec.dependson.resource:default/kube-demo-eks', 'true');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'metadata.name', 'backstage-portal');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'metadata.uid', 'd52cdf63-7b9a-4ec4-872a-b2f1c6a47efe');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'relations.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('d52cdf63-7b9a-4ec4-872a-b2f1c6a47efe', 'relations.partof', 'system:default/kube-demo-2026');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/python-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/python-sonarqube-cicd/');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.title', 'python 3.12 web app + ci/cd with qa, sonarqube, prometheus & fluentd/loki');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.description', 'creates a complete python (flask + gunicorn) repository with automated qa tests, sonarqube quality gate validation, prometheus /metrics, fluentd -> loki logging, and backstage manifest.');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.tags', 'python');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.tags.python', 'true');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.tags', 'flask');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.tags.flask', 'true');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.tags', 'k8s');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.tags.k8s', 'true');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.tags', 'sonarqube');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.tags.sonarqube', 'true');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.tags', 'prometheus');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.tags.prometheus', 'true');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.tags', 'fluentd');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.tags.fluentd', 'true');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.tags', 'loki');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.tags.loki', 'true');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.tags', 'cicd');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.tags.cicd', 'true');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'apiversion', 'backstage.io/v1beta2');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'kind', 'template');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.owner', 'squad-plataforma');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.type', 'service');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.title', 'component information');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.required', 'component_id');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.required.component_id', 'true');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.required', 'owner');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.required.owner', 'true');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.required', 'description');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.required.description', 'true');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.component_id.title', 'service name');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.component_id.type', 'string');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.component_id.description', 'unique identifier (lowercase letters and hyphens)');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.component_id.pattern', '^[a-z0-9-]+$');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.component_id.default', 'python-app-demo');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'metadata.annotations.github.com/project-slug', 'cirobessa/kube-demo-2026');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'metadata.annotations.backstage.io/kubernetes-id', 'sonarqube');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'metadata.annotations.backstage.io/kubernetes-namespace', 'sonarqube');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'metadata.title', 'sonarqube code quality');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'metadata.description', 'sonarqube qa & security scanner on eks (owasp dependency-check, findsecbugs & yaml/k8s security plugins)');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'metadata.links.url', 'http://sonarqube.992382723408.realhandsonlabs.net');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'metadata.links.title', 'sonarqube dashboard ui');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'metadata.links.icon', 'check');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'metadata.links.url', 'https://github.com/cirobessa/kube-demo-2026');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'metadata.links.title', 'sonarqube qa config');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'metadata.links.icon', 'github');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'kind', 'component');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'spec.type', 'service');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'spec.system', 'kube-demo-2026');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'spec.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'spec.dependson.resource:default/kube-demo-eks', 'true');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'metadata.name', 'sonarqube');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'metadata.uid', '01edbf6e-da27-4e26-a028-e62fa0cbc5b6');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'relations.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('01edbf6e-da27-4e26-a028-e62fa0cbc5b6', 'relations.partof', 'system:default/kube-demo-2026');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.description.title', 'description');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.description.type', 'string');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.description.description', 'what does this microservice do?');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.description.default', 'python microservice with sonarqube quality gate, prometheus metrics and fluentd/loki logs');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.owner.title', 'responsible team');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.owner.type', 'string');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.owner.description', 'squad that owns the application (e.g., squad-checkout)');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.owner.default', 'platform-team');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.system.title', 'system / domain');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.system.type', 'string');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.system.default', 'kube-demo-2026');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.title', 'git destination');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.required', 'destinationowner');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.required.destinationowner', 'true');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.required', 'repository');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.required.repository', 'true');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.destinationowner.title', 'github owner / organization');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.destinationowner.type', 'string');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.destinationowner.description', 'github user or organization where the repository will be created');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.destinationowner.default', 'cirodasilvaj');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.repository.title', 'github repository name');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.repository.type', 'string');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.repository.description', 'target repository name to create on github');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.parameters.properties.repository.default', 'python-app-demo');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.id', 'fetch-base');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.name', 'rendering template');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.action', 'fetch:template');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.input.url', './skeleton');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.input.values.component_id', '{{ parameters.component_id }}');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'metadata.annotations.github.com/project-slug', 'cirobessa/kube-demo-2026');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'metadata.annotations.backstage.io/kubernetes-id', 'grafana');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'metadata.annotations.backstage.io/kubernetes-namespace', 'grafana');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'metadata.annotations.backstage.io/kubernetes-label-selector', 'app.kubernetes.io/name=grafana');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'metadata.title', 'grafana observability');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'metadata.description', 'grafana observability dashboards connected to prometheus and loki');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'metadata.links.url', 'http://grafana.992382723408.realhandsonlabs.net');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'metadata.links.title', 'grafana dashboards ui');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'metadata.links.icon', 'dashboard');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'metadata.links.url', 'https://github.com/cirobessa/kube-demo-2026');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'metadata.links.title', 'monitoring config repo');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'metadata.links.icon', 'github');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'kind', 'component');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'spec.type', 'website');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'spec.system', 'kube-demo-2026');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'spec.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'spec.dependson.resource:default/kube-demo-eks', 'true');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'metadata.name', 'grafana');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'metadata.uid', 'b0a652b4-6566-4194-a5f2-2a8c3c31db69');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'relations.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('b0a652b4-6566-4194-a5f2-2a8c3c31db69', 'relations.partof', 'system:default/kube-demo-2026');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.input.values.description', '{{ parameters.description }}');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.input.values.owner', '{{ parameters.owner }}');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.input.values.system', '{{ parameters.system }}');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.input.values.destinationowner', '{{ parameters.destinationowner }}');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.id', 'publish');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.name', 'publishing repository to github');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.action', 'publish:github');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.input.allowedhosts', 'github.com');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.input.allowedhosts.github.com', 'true');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.input.description', '{{ parameters.description }}');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.input.repourl', 'github.com?owner={{ parameters.destinationowner }}&repo={{ parameters.repository }}');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.input.defaultbranch', 'main');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.input.repovisibility', 'public');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.id', 'register');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.name', 'registering in backstage');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.action', 'catalog:register');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.input.repocontentsurl', '{{ steps.publish.output.repocontentsurl }}');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.steps.input.cataloginfopath', '/catalog-info.yaml');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.output.links.title', 'open git repository');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.output.links.url', '{{ steps.publish.output.remoteurl }}');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.output.links.title', 'view in backstage catalog');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.output.links.icon', 'catalog');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'spec.output.links.entityref', '{{ steps.register.output.entityref }}');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.name', 'python-sonarqube-cicd-template');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'metadata.uid', 'a9a1752a-cf74-47af-9a22-dede131c4c5d');
INSERT INTO public.search VALUES ('a9a1752a-cf74-47af-9a22-dede131c4c5d', 'relations.ownedby', 'group:default/squad-plataforma');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.annotations.github.com/project-slug', 'cirodasilvaj/bkstg-made-nodejs-demo22');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.annotations.backstage.io/techdocs-ref', 'dir:.');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.annotations.sonarqube.org/project-key', 'bkstg-made-nodejs-demo22');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.annotations.backstage.io/kubernetes-id', 'bkstg-made-nodejs-demo22');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.annotations.backstage.io/kubernetes-namespace', 'apps-demo');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/jvm-springboot-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/jvm-springboot-sonarqube-cicd/');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.title', 'jvm spring boot (java 21) + ci/cd with sonarqube, prometheus & fluentd/loki');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.tags', 'java');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.tags.java', 'true');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.tags', 'jvm');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.tags.jvm', 'true');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.tags', 'springboot');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.tags.springboot', 'true');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.tags', 'k8s');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.annotations.prometheus.io/scrape', 'true');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.annotations.prometheus.io/path', '/metrics');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.annotations.fluentd.io/destination', 'loki');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.annotations.grafana/dashboard-selector', 'bkstg-made-nodejs-demo22');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.annotations.grafana/tag-selector', 'service:bkstg-made-nodejs-demo22');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.annotations.grafana/overview-dashboard', 'http://grafana.992382723408.realhandsonlabs.net/d/bkstg-made-nodejs-demo22-dashboard');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.annotations.argocd/app-name', 'bkstg-made-nodejs-demo22');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.description', 'node.js 20 microservice with sonarqube quality gate, prometheus metrics and fluentd/loki logs');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.tags', 'microservice');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.tags.microservice', 'true');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.tags', 'k8s');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.tags.k8s', 'true');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.tags', 'sonarqube');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.tags.sonarqube', 'true');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.tags', 'prometheus');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.tags.prometheus', 'true');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.annotations.github.com/project-slug', 'cirodasilvaj/apps-demo-2026');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.annotations.backstage.io/techdocs-ref', 'dir:.');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.annotations.sonarqube.org/project-key', 'apps-demo-2026');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.annotations.backstage.io/kubernetes-id', 'dotnet-csharp-app');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.annotations.backstage.io/kubernetes-namespace', 'apps-demo');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.annotations.prometheus.io/scrape', 'true');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.annotations.prometheus.io/path', '/metrics');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.annotations.fluentd.io/destination', 'loki');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.annotations.grafana/dashboard-selector', 'dotnet-csharp-demo-app');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.annotations.grafana/tag-selector', 'service:dotnet-csharp-demo-app');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.annotations.grafana/overview-dashboard', 'http://grafana.992382723408.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.annotations.argocd/app-name', 'dotnet-csharp-app');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.title', '.net 8 c# minimal api microservice');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.description', 'app web em c# (.net 8 minimal api) com prometheus metrics, logs json para grafana loki, sonarqube quality gate, gitops via argocd e https via aws acm.');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.tags', 'dotnet');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.tags.dotnet', 'true');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.tags', 'csharp');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.tags.csharp', 'true');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.tags', 'sonarqube');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.tags.sonarqube', 'true');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.tags', 'prometheus');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.tags.prometheus', 'true');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.tags', 'fluentd');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.tags.fluentd', 'true');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.tags', 'loki');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.tags.loki', 'true');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.tags', 'grafana');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.tags.grafana', 'true');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.tags.k8s', 'true');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.tags', 'sonarqube');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.tags.sonarqube', 'true');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.tags', 'prometheus');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.tags.prometheus', 'true');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.tags', 'fluentd');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.tags.fluentd', 'true');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.tags', 'fluentd');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.tags.fluentd', 'true');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.tags', 'loki');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.tags.loki', 'true');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.tags', 'argocd');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.tags.argocd', 'true');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.links.url', 'https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.links.title', 'github source code');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.links.icon', 'github');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.links.url', 'http://grafana.992382723408.realhandsonlabs.net/d/bkstg-made-nodejs-demo22-dashboard');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.links.title', 'grafana dashboard');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.links.icon', 'dashboard');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.links.url', 'http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=bkstg-made-nodejs-demo22');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.links.title', 'sonarqube quality gate');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.links.icon', 'check');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/scaffolder-starter-microservice/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/scaffolder-starter-microservice/tree/main/');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.annotations.github.com/project-slug', 'cirodasilvaj/scaffolder-starter-microservice');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.annotations.backstage.io/techdocs-ref', 'dir:.');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.annotations.sonarqube.org/project-key', 'scaffolder-starter-microservice');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.annotations.backstage.io/kubernetes-id', 'scaffolder-starter-microservice');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.annotations.backstage.io/kubernetes-namespace', 'apps-demo');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.annotations.prometheus.io/scrape', 'true');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.annotations.prometheus.io/path', '/metrics');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.annotations.fluentd.io/destination', 'loki');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.annotations.grafana/dashboard-selector', 'scaffolder-starter-microservice');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.annotations.grafana/tag-selector', 'service:scaffolder-starter-microservice');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.annotations.grafana/overview-dashboard', 'http://grafana.992382723408.realhandsonlabs.net/d/scaffolder-starter-microservice-dashboard');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.annotations.argocd/app-name', 'scaffolder-starter-microservice');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.description', 'scaffolder starter microservice created from backstage idp');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.tags', 'microservice');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.tags.microservice', 'true');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.tags', 'k8s');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.tags.k8s', 'true');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.tags', 'sonarqube');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.tags.sonarqube', 'true');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.tags', 'prometheus');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.tags.prometheus', 'true');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.tags', 'fluentd');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.tags.fluentd', 'true');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.tags', 'loki');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.tags.loki', 'true');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.tags', 'argocd');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.tags.argocd', 'true');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.links.url', 'https://github.com/cirodasilvaj/scaffolder-starter-microservice');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.links.title', 'github source code');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.links.icon', 'github');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.links.url', 'http://grafana.992382723408.realhandsonlabs.net/d/scaffolder-starter-microservice-dashboard');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.links.title', 'grafana dashboard');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'kind', 'component');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'spec.type', 'service');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.tags', 'loki');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.tags.loki', 'true');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.tags', 'cicd');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'spec.system', 'kube-demo-2026');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.name', 'bkstg-made-nodejs-demo22');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'metadata.uid', '32a660f9-efac-45f3-97c8-41f32ed8d97f');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('32a660f9-efac-45f3-97c8-41f32ed8d97f', 'relations.partof', 'system:default/kube-demo-2026');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'metadata.description', 'platform engineering & devex team');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'kind', 'group');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'spec.type', 'team');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'spec.members', 'guest');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'spec.members.guest', 'true');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.tags.cicd', 'true');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'apiversion', 'backstage.io/v1beta2');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'kind', 'template');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.owner', 'squad-plataforma');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.type', 'service');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.title', 'component information');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.required', 'component_id');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.required.component_id', 'true');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.required', 'owner');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.required.owner', 'true');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.required', 'description');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.required.description', 'true');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.component_id.title', 'service name');
INSERT INTO public.search VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'metadata.description', 'endpoint openid connect (oidc) discovery do keycloak (sso.empresa.local)');
INSERT INTO public.search VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'kind', 'api');
INSERT INTO public.search VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'spec.type', 'openapi');
INSERT INTO public.search VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'spec.system', 'samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'metadata.name', 'oidc-idp-api');
INSERT INTO public.search VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'metadata.uid', 'c0d72379-16b6-4e8a-8d49-1f327ef118b2');
INSERT INTO public.search VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'relations.apiprovidedby', 'component:default/keycloak-sso');
INSERT INTO public.search VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('c0d72379-16b6-4e8a-8d49-1f327ef118b2', 'relations.partof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.component_id.type', 'string');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.component_id.description', 'unique identifier (lowercase letters and hyphens)');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.component_id.pattern', '^[a-z0-9-]+$');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.component_id.default', 'springboot-app-demo');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.description.title', 'description');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.description.type', 'string');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.description.description', 'what does this spring boot microservice do?');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.description.default', 'jvm spring boot 3.3 microservice with sonarqube quality gate, prometheus metrics and fluentd/loki logs');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.owner.title', 'responsible team');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.owner.type', 'string');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.owner.description', 'squad that owns the application (e.g., squad-checkout)');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.owner.default', 'platform-team');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.system.title', 'system / domain');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.system.type', 'string');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.system.default', 'kube-demo-2026');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.title', 'git destination');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.required', 'destinationowner');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.required.destinationowner', 'true');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'metadata.name', 'platform-team');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.required', 'repository');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.required.repository', 'true');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.destinationowner.title', 'github owner / organization');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.destinationowner.type', 'string');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.destinationowner.description', 'github user or organization where the repository will be created');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.destinationowner.default', 'cirodasilvaj');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.repository.title', 'github repository name');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.repository.type', 'string');
INSERT INTO public.search VALUES ('8f54f8c6-eb39-4b4b-a6e2-e1ada1f5c15d', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('8f54f8c6-eb39-4b4b-a6e2-e1ada1f5c15d', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('8f54f8c6-eb39-4b4b-a6e2-e1ada1f5c15d', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('8f54f8c6-eb39-4b4b-a6e2-e1ada1f5c15d', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('8f54f8c6-eb39-4b4b-a6e2-e1ada1f5c15d', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/');
INSERT INTO public.search VALUES ('8f54f8c6-eb39-4b4b-a6e2-e1ada1f5c15d', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('8f54f8c6-eb39-4b4b-a6e2-e1ada1f5c15d', 'kind', 'location');
INSERT INTO public.search VALUES ('8f54f8c6-eb39-4b4b-a6e2-e1ada1f5c15d', 'spec.type', 'url');
INSERT INTO public.search VALUES ('8f54f8c6-eb39-4b4b-a6e2-e1ada1f5c15d', 'spec.target', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('8f54f8c6-eb39-4b4b-a6e2-e1ada1f5c15d', 'metadata.name', 'generated-4c3e4003c1496fb80ea5a08e761d8ac9d6f421ce');
INSERT INTO public.search VALUES ('8f54f8c6-eb39-4b4b-a6e2-e1ada1f5c15d', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('8f54f8c6-eb39-4b4b-a6e2-e1ada1f5c15d', 'metadata.uid', '8f54f8c6-eb39-4b4b-a6e2-e1ada1f5c15d');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'metadata.uid', '568dc919-f18e-45a0-950c-e431c5a533a5');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.hasmember', 'user:default/guest');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'api:default/ldap-ad-api');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'api:default/oidc-idp-api');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'api:default/python-app-api');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'api:default/radius-mfa-api');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'api:default/saml-idp-api');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'component:default/argocd');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'component:default/backstage-portal');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'component:default/bakstg-nodejs-demo2');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'component:default/bkstg-made-nodejs-demo22');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'component:default/freeradius-mfa');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'component:default/grafana');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'component:default/keycloak-sso');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.repository.description', 'target repository name to create on github');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.parameters.properties.repository.default', 'springboot-app-demo');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.id', 'fetch-base');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.name', 'rendering template');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.action', 'fetch:template');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.input.url', './skeleton');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.input.values.component_id', '{{ parameters.component_id }}');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.input.values.description', '{{ parameters.description }}');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.input.values.owner', '{{ parameters.owner }}');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.input.values.system', '{{ parameters.system }}');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.input.values.destinationowner', '{{ parameters.destinationowner }}');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.id', 'publish');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.name', 'publishing repository to github');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.action', 'publish:github');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.input.allowedhosts', 'github.com');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.input.allowedhosts.github.com', 'true');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.input.description', '{{ parameters.description }}');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.input.repourl', 'github.com?owner={{ parameters.destinationowner }}&repo={{ parameters.repository }}');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'component:default/prometheus');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'component:default/python-demo-app');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'component:default/samba-ad-dc');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'component:default/scaffolder-starter-microservice');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'component:default/sonarqube');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'system:default/apps-demo-2026');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'system:default/kube-demo-2026');
INSERT INTO public.search VALUES ('568dc919-f18e-45a0-950c-e431c5a533a5', 'relations.ownerof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/apps-demo-2026/edit/main/dotnet-csharp-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app/');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'metadata.title', '.net 8 c# minimal api rest api');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'metadata.description', 'interface rest para consulta de status, saúde e telemetria da aplicação c# .net 8');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'kind', 'api');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'spec.type', 'openapi');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'spec.system', 'apps-demo-2026');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'metadata.name', 'dotnet-csharp-app-api');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'metadata.uid', 'd3edfd85-876b-4ec0-ae7d-3da46bcc2f9e');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'relations.apiprovidedby', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('d3edfd85-876b-4ec0-ae7d-3da46bcc2f9e', 'relations.partof', 'system:default/apps-demo-2026');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.annotations.github.com/project-slug', 'cirodasilvaj/samba-ad-keycloak');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.annotations.backstage.io/techdocs-ref', 'dir:.');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.annotations.sonarqube.org/project-key', 'samba-ad-keycloak');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.annotations.backstage.io/kubernetes-id', 'keycloak-sso');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.annotations.backstage.io/kubernetes-namespace', 'default');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.annotations.prometheus.io/scrape', 'true');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.annotations.prometheus.io/path', '/metrics');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.annotations.fluentd.io/destination', 'loki');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.annotations.grafana/dashboard-selector', 'samba-ad-keycloak');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.description', 'servidor keycloak iam (broker saml 2.0, oauth2 e oidc) federado via ldap ao samba 4 ad para autenticar backstage, argocd, grafana e apps demo');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.tags', 'keycloak');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.tags.keycloak', 'true');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.tags', 'saml2');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.tags.saml2', 'true');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.tags', 'oidc');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.tags.oidc', 'true');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.tags', 'sso');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.tags.sso', 'true');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.tags', 'mfa');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.tags.mfa', 'true');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.links.url', 'https://github.com/cirodasilvaj/samba-ad-keycloak');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.links.title', 'github source code');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.links.icon', 'github');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.links.url', 'http://sso.992382723408.realhandsonlabs.net');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.links.title', 'keycloak sso realm');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.links.icon', 'web');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.links.icon', 'dashboard');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.links.url', 'http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=scaffolder-starter-microservice');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.links.title', 'sonarqube quality gate');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.links.icon', 'check');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'kind', 'component');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'spec.type', 'service');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'spec.system', 'kube-demo-2026');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.name', 'scaffolder-starter-microservice');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'metadata.uid', 'dd98330a-009c-413f-9dc6-69b7b3b045f2');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('dd98330a-009c-413f-9dc6-69b7b3b045f2', 'relations.partof', 'system:default/kube-demo-2026');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'metadata.description', 'aws eks 1.35 platform, gitops, observability & developer portal');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'kind', 'system');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'metadata.name', 'kube-demo-2026');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'metadata.uid', '605f8bb8-29f1-4f08-8571-2a92ee8520c4');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'relations.haspart', 'component:default/argocd');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'relations.haspart', 'component:default/backstage-portal');
INSERT INTO public.search VALUES ('af5d5b44-ad56-4ccb-945a-d9f92fc651e6', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('af5d5b44-ad56-4ccb-945a-d9f92fc651e6', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('af5d5b44-ad56-4ccb-945a-d9f92fc651e6', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('af5d5b44-ad56-4ccb-945a-d9f92fc651e6', 'kind', 'location');
INSERT INTO public.search VALUES ('af5d5b44-ad56-4ccb-945a-d9f92fc651e6', 'spec.type', 'url');
INSERT INTO public.search VALUES ('af5d5b44-ad56-4ccb-945a-d9f92fc651e6', 'spec.target', 'https://github.com/a360-business/galeed-community/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('af5d5b44-ad56-4ccb-945a-d9f92fc651e6', 'metadata.name', 'generated-fe0f1bf72ec2879f9e6e9673b75d2a1f020b3878');
INSERT INTO public.search VALUES ('af5d5b44-ad56-4ccb-945a-d9f92fc651e6', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('af5d5b44-ad56-4ccb-945a-d9f92fc651e6', 'metadata.uid', 'af5d5b44-ad56-4ccb-945a-d9f92fc651e6');
INSERT INTO public.search VALUES ('bc4ebcf5-c998-4f61-ab16-3ac80fd4490f', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('bc4ebcf5-c998-4f61-ab16-3ac80fd4490f', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('bc4ebcf5-c998-4f61-ab16-3ac80fd4490f', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('bc4ebcf5-c998-4f61-ab16-3ac80fd4490f', 'kind', 'location');
INSERT INTO public.search VALUES ('bc4ebcf5-c998-4f61-ab16-3ac80fd4490f', 'spec.type', 'url');
INSERT INTO public.search VALUES ('bc4ebcf5-c998-4f61-ab16-3ac80fd4490f', 'spec.target', 'https://github.com/master-developer-nandomatik/growth-os-skills-full/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('bc4ebcf5-c998-4f61-ab16-3ac80fd4490f', 'metadata.name', 'generated-fa205f62d462a6f82aa4a1b49761425165444beb');
INSERT INTO public.search VALUES ('bc4ebcf5-c998-4f61-ab16-3ac80fd4490f', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('bc4ebcf5-c998-4f61-ab16-3ac80fd4490f', 'metadata.uid', 'bc4ebcf5-c998-4f61-ab16-3ac80fd4490f');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.annotations.github.com/project-slug', 'cirodasilvaj/samba-ad-keycloak');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.annotations.backstage.io/techdocs-ref', 'dir:.');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.annotations.sonarqube.org/project-key', 'samba-ad-keycloak');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.annotations.backstage.io/kubernetes-id', 'freeradius-mfa');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.annotations.backstage.io/kubernetes-namespace', 'default');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.annotations.prometheus.io/scrape', 'true');
INSERT INTO public.search VALUES ('cd28be50-4ca3-4f8b-9f46-7373e1e92545', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('cd28be50-4ca3-4f8b-9f46-7373e1e92545', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('cd28be50-4ca3-4f8b-9f46-7373e1e92545', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('cd28be50-4ca3-4f8b-9f46-7373e1e92545', 'kind', 'location');
INSERT INTO public.search VALUES ('cd28be50-4ca3-4f8b-9f46-7373e1e92545', 'spec.type', 'url');
INSERT INTO public.search VALUES ('cd28be50-4ca3-4f8b-9f46-7373e1e92545', 'spec.target', 'https://github.com/vini-brito/growth-os-skills-full/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('cd28be50-4ca3-4f8b-9f46-7373e1e92545', 'metadata.name', 'generated-b44b1f6c085e8ca890654a6f6755902d78d4c46b');
INSERT INTO public.search VALUES ('cd28be50-4ca3-4f8b-9f46-7373e1e92545', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('cd28be50-4ca3-4f8b-9f46-7373e1e92545', 'metadata.uid', 'cd28be50-4ca3-4f8b-9f46-7373e1e92545');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.tags', 'k8s');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.tags.k8s', 'true');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.tags', 'argocd');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.tags.argocd', 'true');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.url', 'https://github.com/cirodasilvaj/apps-demo-2026/tree/main/dotnet-csharp-app');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.title', 'github source code');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.icon', 'github');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.url', 'http://dotnet.992382723408.realhandsonlabs.net');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.title', '.net 8 c# live app (http)');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.icon', 'web');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.url', 'https://dotnet.992382723408.realhandsonlabs.net');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.title', '.net 8 c# live app (https acm)');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.icon', 'lock');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.url', 'http://dotnet.992382723408.realhandsonlabs.net/metrics');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.title', 'prometheus metrics (/metrics)');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.icon', 'gauge');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.url', 'http://grafana.992382723408.realhandsonlabs.net/d/dotnet-csharp-demo-app-dashboard/dd0f8fe');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.title', 'grafana dashboard (golden signals & loki logs)');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.icon', 'dashboard');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.url', 'http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=apps-demo-2026');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.title', 'sonarqube quality gate');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.icon', 'check');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.url', 'https://argocd.992382723408.realhandsonlabs.net/applications/dotnet-csharp-app');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.title', 'argocd gitops');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.links.icon', 'sync');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'kind', 'component');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'spec.type', 'service');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'spec.system', 'apps-demo-2026');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'spec.providesapis', 'dotnet-csharp-app-api');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'spec.providesapis.dotnet-csharp-app-api', 'true');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'spec.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'spec.dependson.resource:default/kube-demo-eks', 'true');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.name', 'dotnet-csharp-demo-app');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'metadata.uid', '526e7749-f3f6-4d20-83a4-549c09c21024');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'relations.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'relations.partof', 'system:default/apps-demo-2026');
INSERT INTO public.search VALUES ('526e7749-f3f6-4d20-83a4-549c09c21024', 'relations.providesapi', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.input.defaultbranch', 'main');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.input.repovisibility', 'public');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.id', 'register');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.name', 'registering in backstage');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.action', 'catalog:register');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.input.repocontentsurl', '{{ steps.publish.output.repocontentsurl }}');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.steps.input.cataloginfopath', '/catalog-info.yaml');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.output.links.title', 'open git repository');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.output.links.url', '{{ steps.publish.output.remoteurl }}');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.output.links.title', 'view in backstage catalog');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.output.links.icon', 'catalog');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'spec.output.links.entityref', '{{ steps.register.output.entityref }}');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.name', 'jvm-springboot-sonarqube-cicd-template');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'metadata.uid', '44041f68-9d66-4b71-86ac-5cd98a6bb212');
INSERT INTO public.search VALUES ('44041f68-9d66-4b71-86ac-5cd98a6bb212', 'relations.ownedby', 'group:default/squad-plataforma');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'relations.haspart', 'component:default/bakstg-nodejs-demo2');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'relations.haspart', 'component:default/bkstg-made-nodejs-demo22');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'relations.haspart', 'component:default/grafana');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'relations.haspart', 'component:default/prometheus');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'relations.haspart', 'component:default/scaffolder-starter-microservice');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'relations.haspart', 'component:default/sonarqube');
INSERT INTO public.search VALUES ('2964dfe6-0ed8-47c1-8b66-62b9a5a5f2f1', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('2964dfe6-0ed8-47c1-8b66-62b9a5a5f2f1', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('2964dfe6-0ed8-47c1-8b66-62b9a5a5f2f1', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('2964dfe6-0ed8-47c1-8b66-62b9a5a5f2f1', 'kind', 'location');
INSERT INTO public.search VALUES ('2964dfe6-0ed8-47c1-8b66-62b9a5a5f2f1', 'spec.type', 'github-discovery');
INSERT INTO public.search VALUES ('2964dfe6-0ed8-47c1-8b66-62b9a5a5f2f1', 'spec.target', 'https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/microservice-template/template.yaml');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/template.yaml');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/microservice-template/template.yaml');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/microservice-template/');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.title', 'standard microservice with ci/cd, sonarqube, prometheus & fluentd/loki');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.description', 'creates a ready-to-use repository with a test pipeline, sonarqube quality gate validation, prometheus metrics, fluentd/loki logging, and backstage manifest.');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.annotations.github.com/project-slug', 'cirodasilvaj/apps-demo-2026');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.annotations.backstage.io/techdocs-ref', 'dir:.');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.annotations.sonarqube.org/project-key', 'apps-demo-2026');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.annotations.backstage.io/kubernetes-id', 'python-app');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.annotations.backstage.io/kubernetes-namespace', 'apps-demo');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.annotations.prometheus.io/scrape', 'true');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.annotations.prometheus.io/path', '/metrics');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.annotations.fluentd.io/destination', 'loki');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.annotations.grafana/dashboard-selector', 'python-demo-app');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.annotations.grafana/tag-selector', 'service:python-demo-app');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.annotations.grafana/overview-dashboard', 'http://grafana.992382723408.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.annotations.argocd/app-name', 'python-app');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.title', 'python 3.12 flask microservice');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.description', 'app web em python 3.12 (flask) com prometheus metrics, logs json para grafana loki, sonarqube quality gate, gitops via argocd e https via aws acm.');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.tags', 'python');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.tags.python', 'true');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.tags', 'flask');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.tags.flask', 'true');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.tags', 'sonarqube');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.tags.sonarqube', 'true');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.tags', 'prometheus');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.tags.prometheus', 'true');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.tags', 'fluentd');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.tags.fluentd', 'true');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.tags', 'loki');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.tags.loki', 'true');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.tags', 'grafana');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.tags.grafana', 'true');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.tags', 'k8s');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.tags.k8s', 'true');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.tags', 'argocd');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.tags.argocd', 'true');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.url', 'https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.title', 'github source code');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.icon', 'github');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.url', 'http://python.992382723408.realhandsonlabs.net');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.title', 'python 3.12 live app (http)');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.icon', 'web');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.url', 'https://python.992382723408.realhandsonlabs.net');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.title', 'python 3.12 live app (https acm)');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.icon', 'lock');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.url', 'http://python.992382723408.realhandsonlabs.net/metrics');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.title', 'prometheus metrics (/metrics)');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.icon', 'gauge');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.url', 'http://grafana.992382723408.realhandsonlabs.net/d/python-demo-app-dashboard/cd51c12');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.title', 'grafana dashboard (golden signals & loki logs)');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.icon', 'dashboard');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.url', 'http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=apps-demo-2026');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.tags', 'node');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.tags.node', 'true');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.tags', 'python');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.tags.python', 'true');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.tags', 'k8s');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.tags.k8s', 'true');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.tags', 'sonarqube');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.tags.sonarqube', 'true');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.tags', 'prometheus');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.tags.prometheus', 'true');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.tags', 'fluentd');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.tags.fluentd', 'true');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.tags', 'loki');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.tags.loki', 'true');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.tags', 'cicd');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.tags.cicd', 'true');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'apiversion', 'backstage.io/v1beta2');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'kind', 'template');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.owner', 'squad-plataforma');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.type', 'service');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.title', 'component information');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.required', 'component_id');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.required.component_id', 'true');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.required', 'owner');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.required.owner', 'true');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.required', 'description');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.required.description', 'true');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.component_id.title', 'service name');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.component_id.type', 'string');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.component_id.description', 'unique identifier (lowercase letters and hyphens)');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.component_id.pattern', '^[a-z0-9-]+$');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.description.title', 'description');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.description.type', 'string');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.description.description', 'what does this microservice do?');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.owner.title', 'responsible team');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.owner.type', 'string');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.owner.description', 'squad that owns the application (e.g., squad-checkout)');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.owner.default', 'platform-team');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.system.title', 'system / domain');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.system.type', 'string');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.system.default', 'kube-demo-2026');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.title', 'git destination');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.required', 'destinationowner');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.required.destinationowner', 'true');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.required', 'repository');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.required.repository', 'true');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.destinationowner.title', 'github owner / organization');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.destinationowner.type', 'string');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.destinationowner.description', 'github user or organization where the repository will be created');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.destinationowner.default', 'cirodasilvaj');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.repository.title', 'github repository name');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.repository.type', 'string');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.repository.description', 'target repository name to create on github');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.parameters.properties.repository.default', 'microservice-demo');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.id', 'fetch-base');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.name', 'rendering template');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.action', 'fetch:template');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.input.url', './skeleton');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.input.values.component_id', '{{ parameters.component_id }}');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'metadata.description', 'endpoint ldap/ldaps round-robin do samba 4 ad (ldap://ad.empresa.local:389)');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'kind', 'api');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.input.values.description', '{{ parameters.description }}');
INSERT INTO public.search VALUES ('2964dfe6-0ed8-47c1-8b66-62b9a5a5f2f1', 'metadata.name', 'generated-ce343b91b6f00c5ed2aaeb0ba620fa9dc85ab551');
INSERT INTO public.search VALUES ('2964dfe6-0ed8-47c1-8b66-62b9a5a5f2f1', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('2964dfe6-0ed8-47c1-8b66-62b9a5a5f2f1', 'metadata.uid', '2964dfe6-0ed8-47c1-8b66-62b9a5a5f2f1');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/dotnet-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/dotnet-sonarqube-cicd/');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.title', '.net 8 c# web app + ci/cd with qa, sonarqube, prometheus & fluentd/loki');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.description', 'creates a complete .net 8 c# minimal api repository with automated qa tests, sonarqube quality gate validation, prometheus /metrics, fluentd -> loki logging, and backstage manifest.');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.tags', 'dotnet');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.tags.dotnet', 'true');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.tags', 'csharp');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.tags.csharp', 'true');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.tags', 'k8s');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.tags.k8s', 'true');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.tags', 'sonarqube');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.tags.sonarqube', 'true');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.tags', 'prometheus');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.tags.prometheus', 'true');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.tags', 'fluentd');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.tags.fluentd', 'true');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.tags', 'loki');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.tags.loki', 'true');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.tags', 'cicd');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.tags.cicd', 'true');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'apiversion', 'backstage.io/v1beta2');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'kind', 'template');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.owner', 'squad-plataforma');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.type', 'service');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.title', 'component information');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.required', 'component_id');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.required.component_id', 'true');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.required', 'owner');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.required.owner', 'true');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.required', 'description');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.required.description', 'true');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.component_id.title', 'service name');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.component_id.type', 'string');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.component_id.description', 'unique identifier (lowercase letters and hyphens)');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.component_id.pattern', '^[a-z0-9-]+$');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.component_id.default', 'dotnet-csharp-app-demo');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.description.title', 'description');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.description.type', 'string');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.description.description', 'what does this microservice do?');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.description.default', '.net 8 c# microservice with sonarqube quality gate, prometheus metrics and fluentd/loki logs');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.owner.title', 'responsible team');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.owner.type', 'string');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.owner.description', 'squad that owns the application (e.g., squad-checkout)');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.owner.default', 'platform-team');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.system.title', 'system / domain');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.system.type', 'string');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.system.default', 'kube-demo-2026');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.title', 'git destination');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.required', 'destinationowner');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.required.destinationowner', 'true');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.required', 'repository');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.required.repository', 'true');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.destinationowner.title', 'github owner / organization');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.destinationowner.type', 'string');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.destinationowner.description', 'github user or organization where the repository will be created');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.destinationowner.default', 'cirodasilvaj');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.repository.title', 'github repository name');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.repository.type', 'string');
INSERT INTO public.search VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'metadata.description', 'endpoint saml 2.0 identity provider do keycloak (sso.empresa.local)');
INSERT INTO public.search VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'kind', 'api');
INSERT INTO public.search VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'spec.type', 'openapi');
INSERT INTO public.search VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'spec.system', 'samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'metadata.name', 'saml-idp-api');
INSERT INTO public.search VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'metadata.uid', 'ac68373a-af16-4be0-b0c3-5ffdf40e00fb');
INSERT INTO public.search VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'relations.apiprovidedby', 'component:default/keycloak-sso');
INSERT INTO public.search VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('ac68373a-af16-4be0-b0c3-5ffdf40e00fb', 'relations.partof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.input.values.owner', '{{ parameters.owner }}');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.input.values.system', '{{ parameters.system }}');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.input.values.destinationowner', '{{ parameters.destinationowner }}');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.id', 'publish');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.name', 'publishing repository to github');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.action', 'publish:github');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.input.allowedhosts', 'github.com');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.input.allowedhosts.github.com', 'true');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.input.description', '{{ parameters.description }}');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.input.repourl', 'github.com?owner={{ parameters.destinationowner }}&repo={{ parameters.repository }}');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.input.defaultbranch', 'main');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.input.repovisibility', 'public');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.id', 'register');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.name', 'registering in backstage');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.action', 'catalog:register');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.input.repocontentsurl', '{{ steps.publish.output.repocontentsurl }}');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.steps.input.cataloginfopath', '/catalog-info.yaml');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.output.links.title', 'open git repository');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.output.links.url', '{{ steps.publish.output.remoteurl }}');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.output.links.title', 'view in backstage catalog');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.output.links.icon', 'catalog');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'spec.output.links.entityref', '{{ steps.register.output.entityref }}');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.name', 'standard-microservice-template');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'metadata.uid', 'b336ba83-2423-4731-895e-6cdfacb64bce');
INSERT INTO public.search VALUES ('b336ba83-2423-4731-895e-6cdfacb64bce', 'relations.ownedby', 'group:default/squad-plataforma');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/backstage-infra/blob/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/backstage-infra/edit/main/templates/nodejs-sonarqube-cicd/template.yaml');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/backstage-infra/tree/main/templates/nodejs-sonarqube-cicd/');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.title', 'node.js 20 web app + ci/cd with sonarqube, prometheus & fluentd/loki');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.description', 'creates a complete node.js 20 microservice repository with automated qa tests, sonarqube quality gate validation, prometheus /metrics, fluentd -> loki json logs, and backstage manifest.');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.tags', 'node');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.tags.node', 'true');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.tags', 'nodejs');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.tags.nodejs', 'true');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.tags', 'javascript');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.tags.javascript', 'true');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.tags', 'k8s');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.tags.k8s', 'true');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.tags', 'sonarqube');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.tags.sonarqube', 'true');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.tags', 'prometheus');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.tags.prometheus', 'true');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.tags', 'fluentd');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.annotations.prometheus.io/path', '/metrics');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.annotations.fluentd.io/destination', 'loki');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.annotations.grafana/dashboard-selector', 'samba-ad-keycloak');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.description', 'servidor freeradius + pam google authenticator (totp mfa) integrado ao samba 4 ad para autenticação geral e mfa na vpc do eks');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.tags', 'radius');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.tags.radius', 'true');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.tags', 'freeradius');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.tags.freeradius', 'true');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.tags', 'mfa');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.tags.mfa', 'true');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.tags', 'totp');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.tags.totp', 'true');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.links.url', 'https://github.com/cirodasilvaj/samba-ad-keycloak');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.links.title', 'github source code');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.links.icon', 'github');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'kind', 'component');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'spec.type', 'service');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'spec.system', 'samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'spec.dependson', 'component:default/samba-ad-dc');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'spec.dependson.component:default/samba-ad-dc', 'true');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'spec.providesapis', 'radius-mfa-api');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'spec.providesapis.radius-mfa-api', 'true');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.name', 'freeradius-mfa');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'metadata.uid', 'c7e06623-192c-43eb-87f8-2951a24f999f');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'relations.dependencyof', 'component:default/keycloak-sso');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'relations.dependson', 'component:default/samba-ad-dc');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'relations.partof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('c7e06623-192c-43eb-87f8-2951a24f999f', 'relations.providesapi', 'api:default/radius-mfa-api');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.repository.description', 'target repository name to create on github');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.parameters.properties.repository.default', 'dotnet-csharp-app-demo');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.id', 'fetch-base');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.name', 'rendering template');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.action', 'fetch:template');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.input.url', './skeleton');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.input.values.component_id', '{{ parameters.component_id }}');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.input.values.description', '{{ parameters.description }}');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.input.values.owner', '{{ parameters.owner }}');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.input.values.system', '{{ parameters.system }}');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.input.values.destinationowner', '{{ parameters.destinationowner }}');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.id', 'publish');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.name', 'publishing repository to github');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.action', 'publish:github');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.input.allowedhosts', 'github.com');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.input.allowedhosts.github.com', 'true');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.input.description', '{{ parameters.description }}');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.input.repourl', 'github.com?owner={{ parameters.destinationowner }}&repo={{ parameters.repository }}');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.input.defaultbranch', 'main');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.input.repovisibility', 'public');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.id', 'register');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.name', 'registering in backstage');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.action', 'catalog:register');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.input.repocontentsurl', '{{ steps.publish.output.repocontentsurl }}');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.steps.input.cataloginfopath', '/catalog-info.yaml');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.output.links.title', 'open git repository');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.output.links.url', '{{ steps.publish.output.remoteurl }}');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.output.links.title', 'view in backstage catalog');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.output.links.icon', 'catalog');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'spec.output.links.entityref', '{{ steps.register.output.entityref }}');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.name', 'dotnet-sonarqube-cicd-template');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'metadata.uid', 'e08f1151-4161-404e-a9ef-f86e9166e3b4');
INSERT INTO public.search VALUES ('e08f1151-4161-404e-a9ef-f86e9166e3b4', 'relations.ownedby', 'group:default/squad-plataforma');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'relations.haspart', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('605f8bb8-29f1-4f08-8571-2a92ee8520c4', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.links.url', 'http://sso.992382723408.realhandsonlabs.net/admin');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.links.title', 'keycloak admin console');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.links.icon', 'admin');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.links.url', 'http://sso.992382723408.realhandsonlabs.net/realms/empresa/.well-known/openid-configuration');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.links.title', 'oidc discovery configuration');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.links.icon', 'lock');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.links.url', 'http://sso.992382723408.realhandsonlabs.net/realms/empresa/protocol/saml/descriptor');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.links.title', 'saml 2.0 metadata descriptor');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.links.icon', 'lock');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'kind', 'component');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'spec.type', 'service');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'spec.system', 'samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'spec.dependson', 'component:default/samba-ad-dc');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'spec.dependson.component:default/samba-ad-dc', 'true');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'spec.dependson', 'component:default/freeradius-mfa');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'spec.dependson.component:default/freeradius-mfa', 'true');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'spec.providesapis', 'saml-idp-api');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'spec.providesapis.saml-idp-api', 'true');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'spec.providesapis', 'oidc-idp-api');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'spec.providesapis.oidc-idp-api', 'true');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.name', 'keycloak-sso');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'metadata.uid', 'c8b70617-2a07-4099-aa00-3e429fc52c3f');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'relations.dependson', 'component:default/freeradius-mfa');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'relations.dependson', 'component:default/samba-ad-dc');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'relations.partof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'relations.providesapi', 'api:default/oidc-idp-api');
INSERT INTO public.search VALUES ('c8b70617-2a07-4099-aa00-3e429fc52c3f', 'relations.providesapi', 'api:default/saml-idp-api');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.tags.fluentd', 'true');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.tags', 'loki');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.tags.loki', 'true');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.tags', 'cicd');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.tags.cicd', 'true');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'apiversion', 'backstage.io/v1beta2');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'kind', 'template');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.owner', 'squad-plataforma');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.type', 'service');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.title', 'component information');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.required', 'component_id');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.required.component_id', 'true');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.required', 'owner');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.required.owner', 'true');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.required', 'description');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.required.description', 'true');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.component_id.title', 'service name');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.component_id.type', 'string');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.component_id.description', 'unique identifier (lowercase letters and hyphens)');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.component_id.pattern', '^[a-z0-9-]+$');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.component_id.default', 'nodejs-app-demo');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.description.title', 'description');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.description.type', 'string');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.description.description', 'what does this node.js microservice do?');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.description.default', 'node.js 20 microservice with sonarqube quality gate, prometheus metrics and fluentd/loki logs');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.owner.title', 'responsible team');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.owner.type', 'string');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'metadata.description', 'arquitetura corporativa iam na vpc do eks (samba 4 ad multi-dc sem dns interno + route 53 private zone + freeradius mfa + keycloak saml 2.0 / oidc)');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'kind', 'system');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.annotations.github.com/project-slug', 'cirodasilvaj/samba-ad-keycloak');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.annotations.backstage.io/techdocs-ref', 'dir:.');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.annotations.sonarqube.org/project-key', 'samba-ad-keycloak');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.annotations.backstage.io/kubernetes-id', 'samba-ad-dc');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.annotations.backstage.io/kubernetes-namespace', 'default');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.annotations.prometheus.io/scrape', 'true');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.annotations.prometheus.io/path', '/metrics');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.annotations.fluentd.io/destination', 'loki');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.annotations.grafana/dashboard-selector', 'samba-ad-keycloak');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.description', 'samba 4 active directory multi-dc (dc1 principal + dc2 réplica em multi-az com --dns-backend=none e route 53 private hosted zone)');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.tags', 'samba4');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.tags.samba4', 'true');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.tags', 'active-directory');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.tags.active-directory', 'true');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.tags', 'ldap');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.tags.ldap', 'true');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.tags', 'kerberos');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.tags.kerberos', 'true');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.tags', 'route53');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.tags.route53', 'true');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.links.url', 'https://github.com/cirodasilvaj/samba-ad-keycloak');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.links.title', 'github source code');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.links.icon', 'github');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'kind', 'component');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'spec.type', 'service');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'spec.system', 'samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'spec.providesapis', 'ldap-ad-api');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'spec.providesapis.ldap-ad-api', 'true');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.name', 'samba-ad-dc');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'metadata.uid', '7df42e7c-cdc7-4f6f-853b-4ecd0335e728');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'relations.dependencyof', 'component:default/freeradius-mfa');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'relations.dependencyof', 'component:default/keycloak-sso');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'relations.partof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('7df42e7c-cdc7-4f6f-853b-4ecd0335e728', 'relations.providesapi', 'api:default/ldap-ad-api');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.owner.description', 'squad that owns the application (e.g., squad-checkout)');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.owner.default', 'platform-team');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.system.title', 'system / domain');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.system.type', 'string');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.system.default', 'kube-demo-2026');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.title', 'git destination');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.required', 'destinationowner');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.required.destinationowner', 'true');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.required', 'repository');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.required.repository', 'true');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.destinationowner.title', 'github owner / organization');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.destinationowner.type', 'string');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.destinationowner.description', 'github user or organization where the repository will be created');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.destinationowner.default', 'cirodasilvaj');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.repository.title', 'github repository name');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.repository.type', 'string');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.repository.description', 'target repository name to create on github');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.parameters.properties.repository.default', 'nodejs-app-demo');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.id', 'fetch-base');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.name', 'rendering template');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.action', 'fetch:template');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.input.url', './skeleton');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.input.values.component_id', '{{ parameters.component_id }}');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.input.values.description', '{{ parameters.description }}');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.input.values.owner', '{{ parameters.owner }}');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.input.values.system', '{{ parameters.system }}');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.input.values.destinationowner', '{{ parameters.destinationowner }}');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.id', 'publish');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.name', 'publishing repository to github');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.action', 'publish:github');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.input.allowedhosts', 'github.com');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.input.allowedhosts.github.com', 'true');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.input.description', '{{ parameters.description }}');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.input.repourl', 'github.com?owner={{ parameters.destinationowner }}&repo={{ parameters.repository }}');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.input.defaultbranch', 'main');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.input.repovisibility', 'public');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.id', 'register');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.name', 'registering in backstage');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.action', 'catalog:register');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.input.repocontentsurl', '{{ steps.publish.output.repocontentsurl }}');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.steps.input.cataloginfopath', '/catalog-info.yaml');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.output.links.title', 'open git repository');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.output.links.url', '{{ steps.publish.output.remoteurl }}');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.output.links.title', 'view in backstage catalog');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.output.links.icon', 'catalog');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'spec.output.links.entityref', '{{ steps.register.output.entityref }}');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.name', 'nodejs-sonarqube-cicd-template');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'metadata.uid', 'cbf1609f-cb2c-4a1f-8241-d19ef4075bf7');
INSERT INTO public.search VALUES ('cbf1609f-cb2c-4a1f-8241-d19ef4075bf7', 'relations.ownedby', 'group:default/squad-plataforma');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.annotations.github.com/project-slug', 'cirodasilvaj/bakstg-nodejs-demo2');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.annotations.backstage.io/techdocs-ref', 'dir:.');
INSERT INTO public.search VALUES ('dd4b07f1-662a-49b8-8764-5d5845540a4e', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('dd4b07f1-662a-49b8-8764-5d5845540a4e', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('dd4b07f1-662a-49b8-8764-5d5845540a4e', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('dd4b07f1-662a-49b8-8764-5d5845540a4e', 'kind', 'location');
INSERT INTO public.search VALUES ('dd4b07f1-662a-49b8-8764-5d5845540a4e', 'spec.type', 'url');
INSERT INTO public.search VALUES ('dd4b07f1-662a-49b8-8764-5d5845540a4e', 'spec.target', 'https://github.com/a360-business/accelera-skills/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('dd4b07f1-662a-49b8-8764-5d5845540a4e', 'metadata.name', 'generated-6e615a027feacec08857bccd2c90fef1db2a2372');
INSERT INTO public.search VALUES ('dd4b07f1-662a-49b8-8764-5d5845540a4e', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('dd4b07f1-662a-49b8-8764-5d5845540a4e', 'metadata.uid', 'dd4b07f1-662a-49b8-8764-5d5845540a4e');
INSERT INTO public.search VALUES ('28d415d5-684c-4e90-822c-39112ab6a4a2', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('28d415d5-684c-4e90-822c-39112ab6a4a2', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('28d415d5-684c-4e90-822c-39112ab6a4a2', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('28d415d5-684c-4e90-822c-39112ab6a4a2', 'kind', 'location');
INSERT INTO public.search VALUES ('28d415d5-684c-4e90-822c-39112ab6a4a2', 'spec.type', 'url');
INSERT INTO public.search VALUES ('28d415d5-684c-4e90-822c-39112ab6a4a2', 'spec.target', 'https://github.com/a360-business/growth-os-skills-full/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('28d415d5-684c-4e90-822c-39112ab6a4a2', 'metadata.name', 'generated-796712c88a485ec71e012b5c5f4566412a5f5672');
INSERT INTO public.search VALUES ('28d415d5-684c-4e90-822c-39112ab6a4a2', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('28d415d5-684c-4e90-822c-39112ab6a4a2', 'metadata.uid', '28d415d5-684c-4e90-822c-39112ab6a4a2');
INSERT INTO public.search VALUES ('6dbef53c-6b33-461c-a885-773759651e58', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('6dbef53c-6b33-461c-a885-773759651e58', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('6dbef53c-6b33-461c-a885-773759651e58', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('6dbef53c-6b33-461c-a885-773759651e58', 'kind', 'location');
INSERT INTO public.search VALUES ('6dbef53c-6b33-461c-a885-773759651e58', 'spec.type', 'url');
INSERT INTO public.search VALUES ('6dbef53c-6b33-461c-a885-773759651e58', 'spec.target', 'https://github.com/a360-business/hermes-setup/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('6dbef53c-6b33-461c-a885-773759651e58', 'metadata.name', 'generated-edb107c0bf74b8a4c4c763787b54180b9801f99b');
INSERT INTO public.search VALUES ('6dbef53c-6b33-461c-a885-773759651e58', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('6dbef53c-6b33-461c-a885-773759651e58', 'metadata.uid', '6dbef53c-6b33-461c-a885-773759651e58');
INSERT INTO public.search VALUES ('ba03d047-b0e3-49dc-bc31-be7e943f6da4', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ba03d047-b0e3-49dc-bc31-be7e943f6da4', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ba03d047-b0e3-49dc-bc31-be7e943f6da4', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('ba03d047-b0e3-49dc-bc31-be7e943f6da4', 'kind', 'location');
INSERT INTO public.search VALUES ('ba03d047-b0e3-49dc-bc31-be7e943f6da4', 'spec.type', 'url');
INSERT INTO public.search VALUES ('ba03d047-b0e3-49dc-bc31-be7e943f6da4', 'spec.target', 'https://github.com/devmarcelo/openclaw-setup/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ba03d047-b0e3-49dc-bc31-be7e943f6da4', 'metadata.name', 'generated-e67fab63afdcd722173e912706fe624b9df62c34');
INSERT INTO public.search VALUES ('ba03d047-b0e3-49dc-bc31-be7e943f6da4', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.annotations.sonarqube.org/project-key', 'bakstg-nodejs-demo2');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.annotations.backstage.io/kubernetes-id', 'bakstg-nodejs-demo2');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.annotations.backstage.io/kubernetes-namespace', 'apps-demo');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.annotations.prometheus.io/scrape', 'true');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.annotations.prometheus.io/path', '/metrics');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.annotations.fluentd.io/destination', 'loki');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.annotations.grafana/dashboard-selector', 'bakstg-nodejs-demo2');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.annotations.grafana/tag-selector', 'service:bakstg-nodejs-demo2');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.annotations.grafana/overview-dashboard', 'http://grafana.992382723408.realhandsonlabs.net/d/bakstg-nodejs-demo2-dashboard');
INSERT INTO public.search VALUES ('507739a8-3ff8-4533-b9b3-abf0205f6d0c', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/samba-ad-keycloak/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/samba-ad-keycloak/tree/main/');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'metadata.description', 'endpoint freeradius auth (udp 1812) e acct (udp 1813) com suporte a mfa (radius.empresa.local)');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'kind', 'api');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'spec.type', 'grpc');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'spec.system', 'samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'spec.definition', 'syntax = "proto3";
service freeradiusmfa {
  // udp radius.empresa.local:1812 (auth + mfa)
  // udp radius.empresa.local:1813 (accounting)
}
');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'metadata.name', 'radius-mfa-api');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'metadata.uid', 'aaba2d47-d59f-46f6-9305-53637bf8ece9');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'relations.apiprovidedby', 'component:default/freeradius-mfa');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('aaba2d47-d59f-46f6-9305-53637bf8ece9', 'relations.partof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.annotations.argocd/app-name', 'bakstg-nodejs-demo2');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.annotations.backstage.io/orphan', 'true');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.description', 'node.js 20 microservice with sonarqube quality gate, prometheus metrics and fluentd/loki logs');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.tags', 'microservice');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.tags.microservice', 'true');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.tags', 'k8s');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.tags.k8s', 'true');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.tags', 'sonarqube');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.tags.sonarqube', 'true');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.tags', 'prometheus');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.tags.prometheus', 'true');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.tags', 'fluentd');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.tags.fluentd', 'true');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.tags', 'loki');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.tags.loki', 'true');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.tags', 'argocd');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.tags.argocd', 'true');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.links.url', 'https://github.com/cirodasilvaj/bakstg-nodejs-demo2');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.links.title', 'github source code');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.links.icon', 'github');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.links.url', 'http://grafana.992382723408.realhandsonlabs.net/d/bakstg-nodejs-demo2-dashboard');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.links.title', 'grafana dashboard');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.links.icon', 'dashboard');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.links.url', 'http://sonarqube.992382723408.realhandsonlabs.net/dashboard?id=bakstg-nodejs-demo2');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.links.title', 'sonarqube quality gate');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.links.icon', 'check');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'kind', 'component');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'spec.type', 'service');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'spec.system', 'kube-demo-2026');
INSERT INTO public.search VALUES ('507739a8-3ff8-4533-b9b3-abf0205f6d0c', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('507739a8-3ff8-4533-b9b3-abf0205f6d0c', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('507739a8-3ff8-4533-b9b3-abf0205f6d0c', 'kind', 'location');
INSERT INTO public.search VALUES ('507739a8-3ff8-4533-b9b3-abf0205f6d0c', 'spec.type', 'url');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.name', 'bakstg-nodejs-demo2');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'spec.system', 'samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'spec.definition', 'syntax = "proto3";
service activedirectoryldap {
  // ldap://ad.empresa.local:389 (round-robin dc1 & dc2)
  // base dn: dc=empresa,dc=local
}
');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'metadata.name', 'ldap-ad-api');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'metadata.uid', 'ff3f673b-6c22-41eb-a709-e5ea84b5191c');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'relations.apiprovidedby', 'component:default/samba-ad-dc');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('ff3f673b-6c22-41eb-a709-e5ea84b5191c', 'relations.partof', 'system:default/samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/apps-demo-2026/edit/main/python-app/catalog-info.yaml');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/python-app/');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'metadata.title', 'python flask app rest api');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'metadata.description', 'interface rest para consulta de status, saúde e telemetria da aplicação python');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'metadata.uid', '1e69ed9f-d832-487e-87d5-d2895168e30c');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('1e69ed9f-d832-487e-87d5-d2895168e30c', 'relations.partof', 'system:default/kube-demo-2026');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'kind', 'api');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'spec.type', 'openapi');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'spec.system', 'apps-demo-2026');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'metadata.name', 'python-app-api');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('507739a8-3ff8-4533-b9b3-abf0205f6d0c', 'spec.target', 'https://github.com/a360-business/setup-ambiente/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('507739a8-3ff8-4533-b9b3-abf0205f6d0c', 'metadata.name', 'generated-03b13b5fb17fe9a670e36e235ad81fd06fcfd666');
INSERT INTO public.search VALUES ('507739a8-3ff8-4533-b9b3-abf0205f6d0c', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('507739a8-3ff8-4533-b9b3-abf0205f6d0c', 'metadata.uid', '507739a8-3ff8-4533-b9b3-abf0205f6d0c');
INSERT INTO public.search VALUES ('d156834d-2957-4c7b-a60b-473c61a84906', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d156834d-2957-4c7b-a60b-473c61a84906', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d156834d-2957-4c7b-a60b-473c61a84906', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('d156834d-2957-4c7b-a60b-473c61a84906', 'kind', 'location');
INSERT INTO public.search VALUES ('d156834d-2957-4c7b-a60b-473c61a84906', 'spec.type', 'url');
INSERT INTO public.search VALUES ('d156834d-2957-4c7b-a60b-473c61a84906', 'spec.target', 'https://github.com/a360-business/openclaw-setup/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('d156834d-2957-4c7b-a60b-473c61a84906', 'metadata.name', 'generated-e40d9e847bb90a7610522a0d467185a8e079bb3e');
INSERT INTO public.search VALUES ('d156834d-2957-4c7b-a60b-473c61a84906', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('d156834d-2957-4c7b-a60b-473c61a84906', 'metadata.uid', 'd156834d-2957-4c7b-a60b-473c61a84906');
INSERT INTO public.search VALUES ('569b86ee-0b91-4986-b3fb-639450e8e556', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('569b86ee-0b91-4986-b3fb-639450e8e556', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('569b86ee-0b91-4986-b3fb-639450e8e556', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('569b86ee-0b91-4986-b3fb-639450e8e556', 'kind', 'location');
INSERT INTO public.search VALUES ('569b86ee-0b91-4986-b3fb-639450e8e556', 'spec.type', 'url');
INSERT INTO public.search VALUES ('569b86ee-0b91-4986-b3fb-639450e8e556', 'spec.target', 'https://github.com/cirodasilvaj/scaffolder-starter-microservice/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('569b86ee-0b91-4986-b3fb-639450e8e556', 'metadata.name', 'generated-0bc5455adc5c6e2724b4409f7f4382f145a48c31');
INSERT INTO public.search VALUES ('569b86ee-0b91-4986-b3fb-639450e8e556', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('569b86ee-0b91-4986-b3fb-639450e8e556', 'metadata.uid', '569b86ee-0b91-4986-b3fb-639450e8e556');
INSERT INTO public.search VALUES ('6206c4ce-84cd-4dd6-8547-d58912b69324', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('6206c4ce-84cd-4dd6-8547-d58912b69324', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('6206c4ce-84cd-4dd6-8547-d58912b69324', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('6206c4ce-84cd-4dd6-8547-d58912b69324', 'kind', 'location');
INSERT INTO public.search VALUES ('6206c4ce-84cd-4dd6-8547-d58912b69324', 'spec.type', 'url');
INSERT INTO public.search VALUES ('6206c4ce-84cd-4dd6-8547-d58912b69324', 'spec.target', 'https://github.com/cirodasilvajardim-crypto/mesa-site-institucional/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('6206c4ce-84cd-4dd6-8547-d58912b69324', 'metadata.name', 'generated-c7cbc24b24c9bd1238a6138087c948db5f143a8a');
INSERT INTO public.search VALUES ('6206c4ce-84cd-4dd6-8547-d58912b69324', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('6206c4ce-84cd-4dd6-8547-d58912b69324', 'metadata.uid', '6206c4ce-84cd-4dd6-8547-d58912b69324');
INSERT INTO public.search VALUES ('1503a318-6894-4f0d-b372-0a31b1d954a9', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('1503a318-6894-4f0d-b372-0a31b1d954a9', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('1503a318-6894-4f0d-b372-0a31b1d954a9', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('1503a318-6894-4f0d-b372-0a31b1d954a9', 'kind', 'location');
INSERT INTO public.search VALUES ('1503a318-6894-4f0d-b372-0a31b1d954a9', 'spec.type', 'url');
INSERT INTO public.search VALUES ('1503a318-6894-4f0d-b372-0a31b1d954a9', 'spec.target', 'https://github.com/fernandonesi/galeed-community/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('1503a318-6894-4f0d-b372-0a31b1d954a9', 'metadata.name', 'generated-c377ebbfb933b0a54dfd0e158734712e21979bde');
INSERT INTO public.search VALUES ('1503a318-6894-4f0d-b372-0a31b1d954a9', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('1503a318-6894-4f0d-b372-0a31b1d954a9', 'metadata.uid', '1503a318-6894-4f0d-b372-0a31b1d954a9');
INSERT INTO public.search VALUES ('115a964d-41be-496c-ab7f-47b42064763f', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('115a964d-41be-496c-ab7f-47b42064763f', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('115a964d-41be-496c-ab7f-47b42064763f', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('115a964d-41be-496c-ab7f-47b42064763f', 'kind', 'location');
INSERT INTO public.search VALUES ('115a964d-41be-496c-ab7f-47b42064763f', 'spec.type', 'url');
INSERT INTO public.search VALUES ('115a964d-41be-496c-ab7f-47b42064763f', 'spec.target', 'https://github.com/a360-business/agent-foreman/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('115a964d-41be-496c-ab7f-47b42064763f', 'metadata.name', 'generated-78a0f16f4da15640f067c17fea7b0935483fd142');
INSERT INTO public.search VALUES ('115a964d-41be-496c-ab7f-47b42064763f', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('115a964d-41be-496c-ab7f-47b42064763f', 'metadata.uid', '115a964d-41be-496c-ab7f-47b42064763f');
INSERT INTO public.search VALUES ('b70e7452-e2ca-4d1a-baef-8929bed899ae', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b70e7452-e2ca-4d1a-baef-8929bed899ae', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b70e7452-e2ca-4d1a-baef-8929bed899ae', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'metadata.annotations.backstage.io/managed-by-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'metadata.annotations.backstage.io/managed-by-origin-location', 'file:/etc/backstage/catalog-entities.yaml');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'metadata.annotations.backstage.io/kubernetes-id', 'kube-demo-eks');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'metadata.annotations.backstage.io/kubernetes-namespace', 'kube-system');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'metadata.description', 'aws eks 1.35 kubernetes cluster connected via in-cluster serviceaccount rbac');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'kind', 'resource');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'spec.type', 'kubernetes-cluster');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'spec.system', 'kube-demo-2026');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'metadata.name', 'kube-demo-eks');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'metadata.uid', '8b395fb2-b486-4e7c-ac0c-9b9ef49b608e');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'relations.apiprovidedby', 'component:default/python-demo-app');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('8b395fb2-b486-4e7c-ac0c-9b9ef49b608e', 'relations.partof', 'system:default/apps-demo-2026');
INSERT INTO public.search VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/apps-demo-2026/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/apps-demo-2026/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/apps-demo-2026/tree/main/');
INSERT INTO public.search VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'metadata.title', 'apps demo 2026 ecosystem');
INSERT INTO public.search VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'metadata.description', 'microservices demo collection (python 3.12 flask, .net 8 c# minimal api) with ci/cd, sonarqube, prometheus metrics, fluentd/loki logs, gitops via argocd and https via aws acm.');
INSERT INTO public.search VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'kind', 'system');
INSERT INTO public.search VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'metadata.name', 'apps-demo-2026');
INSERT INTO public.search VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'metadata.uid', 'da0ddf52-10a0-4392-b061-72d5576c80db');
INSERT INTO public.search VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'relations.haspart', 'api:default/dotnet-csharp-app-api');
INSERT INTO public.search VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'relations.haspart', 'api:default/python-app-api');
INSERT INTO public.search VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'relations.haspart', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.search VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'relations.haspart', 'component:default/python-demo-app');
INSERT INTO public.search VALUES ('da0ddf52-10a0-4392-b061-72d5576c80db', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('2abb648f-f7cb-48dc-996f-4feb9f4778fe', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('2abb648f-f7cb-48dc-996f-4feb9f4778fe', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('2abb648f-f7cb-48dc-996f-4feb9f4778fe', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('2abb648f-f7cb-48dc-996f-4feb9f4778fe', 'kind', 'location');
INSERT INTO public.search VALUES ('2abb648f-f7cb-48dc-996f-4feb9f4778fe', 'spec.type', 'url');
INSERT INTO public.search VALUES ('2abb648f-f7cb-48dc-996f-4feb9f4778fe', 'spec.target', 'https://github.com/moreirathi87/galeed-community/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('2abb648f-f7cb-48dc-996f-4feb9f4778fe', 'metadata.name', 'generated-8f44ff1b0eee905e4f10b347f2f4cde12c6ecb91');
INSERT INTO public.search VALUES ('2abb648f-f7cb-48dc-996f-4feb9f4778fe', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('2abb648f-f7cb-48dc-996f-4feb9f4778fe', 'metadata.uid', '2abb648f-f7cb-48dc-996f-4feb9f4778fe');
INSERT INTO public.search VALUES ('8ffa28bf-4525-474c-a0ea-275e2329fcdf', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.title', 'sonarqube quality gate');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.icon', 'check');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.url', 'https://argocd.992382723408.realhandsonlabs.net/applications/python-app');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.title', 'argocd gitops');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.links.icon', 'sync');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'kind', 'component');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'spec.type', 'service');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'spec.lifecycle', 'production');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'spec.system', 'apps-demo-2026');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'spec.providesapis', 'python-app-api');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'spec.providesapis.python-app-api', 'true');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'spec.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'spec.dependson.resource:default/kube-demo-eks', 'true');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.name', 'python-demo-app');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'metadata.uid', '5d70a2d8-41a8-4321-b3e8-558a2769b323');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'relations.dependson', 'resource:default/kube-demo-eks');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'relations.partof', 'system:default/apps-demo-2026');
INSERT INTO public.search VALUES ('5d70a2d8-41a8-4321-b3e8-558a2769b323', 'relations.providesapi', 'api:default/python-app-api');
INSERT INTO public.search VALUES ('ba03d047-b0e3-49dc-bc31-be7e943f6da4', 'metadata.uid', 'ba03d047-b0e3-49dc-bc31-be7e943f6da4');
INSERT INTO public.search VALUES ('849ec066-af2d-4eb7-8084-8674deff2066', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('849ec066-af2d-4eb7-8084-8674deff2066', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('849ec066-af2d-4eb7-8084-8674deff2066', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('849ec066-af2d-4eb7-8084-8674deff2066', 'kind', 'location');
INSERT INTO public.search VALUES ('849ec066-af2d-4eb7-8084-8674deff2066', 'spec.type', 'url');
INSERT INTO public.search VALUES ('849ec066-af2d-4eb7-8084-8674deff2066', 'spec.target', 'https://github.com/a360-business/a360-dev-multiagentes/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('849ec066-af2d-4eb7-8084-8674deff2066', 'metadata.name', 'generated-bd14bea673b37261e7a74bd04975480bb069f8bc');
INSERT INTO public.search VALUES ('849ec066-af2d-4eb7-8084-8674deff2066', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('849ec066-af2d-4eb7-8084-8674deff2066', 'metadata.uid', '849ec066-af2d-4eb7-8084-8674deff2066');
INSERT INTO public.search VALUES ('ee863f3c-6e3d-4737-bf1c-fa378c782ff2', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ee863f3c-6e3d-4737-bf1c-fa378c782ff2', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('ee863f3c-6e3d-4737-bf1c-fa378c782ff2', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('ee863f3c-6e3d-4737-bf1c-fa378c782ff2', 'kind', 'location');
INSERT INTO public.search VALUES ('ee863f3c-6e3d-4737-bf1c-fa378c782ff2', 'spec.type', 'url');
INSERT INTO public.search VALUES ('ee863f3c-6e3d-4737-bf1c-fa378c782ff2', 'spec.target', 'https://github.com/fabricaberger-droid/a360-dev-multiagentes/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'spec.owner', 'platform-team');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'metadata.name', 'samba-ad-keycloak-iam');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'metadata.uid', '39387fbf-9d96-40f7-baed-4dd4470abe8d');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'relations.haspart', 'api:default/ldap-ad-api');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'relations.haspart', 'api:default/oidc-idp-api');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'relations.haspart', 'api:default/radius-mfa-api');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'relations.haspart', 'api:default/saml-idp-api');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'relations.haspart', 'component:default/freeradius-mfa');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'relations.haspart', 'component:default/keycloak-sso');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'relations.haspart', 'component:default/samba-ad-dc');
INSERT INTO public.search VALUES ('39387fbf-9d96-40f7-baed-4dd4470abe8d', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('96a807de-0f76-4a71-b1d2-fbb244ee6678', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('96a807de-0f76-4a71-b1d2-fbb244ee6678', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('96a807de-0f76-4a71-b1d2-fbb244ee6678', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('96a807de-0f76-4a71-b1d2-fbb244ee6678', 'kind', 'location');
INSERT INTO public.search VALUES ('96a807de-0f76-4a71-b1d2-fbb244ee6678', 'spec.type', 'url');
INSERT INTO public.search VALUES ('96a807de-0f76-4a71-b1d2-fbb244ee6678', 'spec.target', 'https://github.com/talerelayapp/superfria/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('96a807de-0f76-4a71-b1d2-fbb244ee6678', 'metadata.name', 'generated-83f2543400bad694b3b4169b8f0dda74347f09ca');
INSERT INTO public.search VALUES ('96a807de-0f76-4a71-b1d2-fbb244ee6678', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('96a807de-0f76-4a71-b1d2-fbb244ee6678', 'metadata.uid', '96a807de-0f76-4a71-b1d2-fbb244ee6678');
INSERT INTO public.search VALUES ('67f8a0e4-f1e1-46a8-8541-0d06400fadc6', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('67f8a0e4-f1e1-46a8-8541-0d06400fadc6', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('67f8a0e4-f1e1-46a8-8541-0d06400fadc6', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('67f8a0e4-f1e1-46a8-8541-0d06400fadc6', 'kind', 'location');
INSERT INTO public.search VALUES ('67f8a0e4-f1e1-46a8-8541-0d06400fadc6', 'spec.type', 'url');
INSERT INTO public.search VALUES ('67f8a0e4-f1e1-46a8-8541-0d06400fadc6', 'spec.target', 'https://github.com/leonardoserio/accelera-skills/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('67f8a0e4-f1e1-46a8-8541-0d06400fadc6', 'metadata.name', 'generated-e461ccc7db88e98c2a26c40a0672f2e1edbfe4f0');
INSERT INTO public.search VALUES ('67f8a0e4-f1e1-46a8-8541-0d06400fadc6', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('67f8a0e4-f1e1-46a8-8541-0d06400fadc6', 'metadata.uid', '67f8a0e4-f1e1-46a8-8541-0d06400fadc6');
INSERT INTO public.search VALUES ('4def6055-c424-4fc1-bd59-5ee4349e209a', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('4def6055-c424-4fc1-bd59-5ee4349e209a', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('4def6055-c424-4fc1-bd59-5ee4349e209a', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('4def6055-c424-4fc1-bd59-5ee4349e209a', 'kind', 'location');
INSERT INTO public.search VALUES ('4def6055-c424-4fc1-bd59-5ee4349e209a', 'spec.type', 'url');
INSERT INTO public.search VALUES ('4def6055-c424-4fc1-bd59-5ee4349e209a', 'spec.target', 'https://github.com/joaoguibune/galeed-community/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('4def6055-c424-4fc1-bd59-5ee4349e209a', 'metadata.name', 'generated-023ff0c2d516eb7ee170b46c23edf162e464605b');
INSERT INTO public.search VALUES ('4def6055-c424-4fc1-bd59-5ee4349e209a', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('4def6055-c424-4fc1-bd59-5ee4349e209a', 'metadata.uid', '4def6055-c424-4fc1-bd59-5ee4349e209a');
INSERT INTO public.search VALUES ('f455ce50-afa5-469e-ba70-803fcd20ff43', 'metadata.annotations.backstage.io/managed-by-location', 'url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('f455ce50-afa5-469e-ba70-803fcd20ff43', 'metadata.annotations.backstage.io/managed-by-origin-location', 'url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('f455ce50-afa5-469e-ba70-803fcd20ff43', 'metadata.annotations.backstage.io/view-url', 'https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('f455ce50-afa5-469e-ba70-803fcd20ff43', 'metadata.annotations.backstage.io/edit-url', 'https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/edit/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('f455ce50-afa5-469e-ba70-803fcd20ff43', 'metadata.annotations.backstage.io/source-location', 'url:https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/');
INSERT INTO public.search VALUES ('f455ce50-afa5-469e-ba70-803fcd20ff43', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('f455ce50-afa5-469e-ba70-803fcd20ff43', 'kind', 'location');
INSERT INTO public.search VALUES ('f455ce50-afa5-469e-ba70-803fcd20ff43', 'spec.type', 'url');
INSERT INTO public.search VALUES ('f455ce50-afa5-469e-ba70-803fcd20ff43', 'spec.target', 'https://github.com/cirodasilvaj/bkstg-made-nodejs-demo22/tree/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('f455ce50-afa5-469e-ba70-803fcd20ff43', 'metadata.name', 'generated-6a784c45d310bbbb8ae6d987a8a58e15ee836489');
INSERT INTO public.search VALUES ('f455ce50-afa5-469e-ba70-803fcd20ff43', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('f455ce50-afa5-469e-ba70-803fcd20ff43', 'metadata.uid', 'f455ce50-afa5-469e-ba70-803fcd20ff43');
INSERT INTO public.search VALUES ('b70e7452-e2ca-4d1a-baef-8929bed899ae', 'kind', 'location');
INSERT INTO public.search VALUES ('b70e7452-e2ca-4d1a-baef-8929bed899ae', 'spec.type', 'url');
INSERT INTO public.search VALUES ('b70e7452-e2ca-4d1a-baef-8929bed899ae', 'spec.target', 'https://github.com/arthurecio/openclaw-setup/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b70e7452-e2ca-4d1a-baef-8929bed899ae', 'metadata.name', 'generated-d2a36c4260a85053ce94fbe9c674187459d272db');
INSERT INTO public.search VALUES ('b70e7452-e2ca-4d1a-baef-8929bed899ae', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('b70e7452-e2ca-4d1a-baef-8929bed899ae', 'metadata.uid', 'b70e7452-e2ca-4d1a-baef-8929bed899ae');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'metadata.uid', 'a1398182-7d8a-41e3-bab3-6f6125b19bd2');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'relations.dependencyof', 'component:default/argocd');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'relations.dependencyof', 'component:default/backstage-portal');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'relations.dependencyof', 'component:default/dotnet-csharp-demo-app');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'relations.dependencyof', 'component:default/grafana');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'relations.dependencyof', 'component:default/prometheus');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'relations.dependencyof', 'component:default/python-demo-app');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'relations.dependencyof', 'component:default/sonarqube');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'relations.ownedby', 'group:default/platform-team');
INSERT INTO public.search VALUES ('a1398182-7d8a-41e3-bab3-6f6125b19bd2', 'relations.partof', 'system:default/kube-demo-2026');
INSERT INTO public.search VALUES ('ee863f3c-6e3d-4737-bf1c-fa378c782ff2', 'metadata.name', 'generated-1fa5db3a5d97294de3a94bed049e4c7133c78dca');
INSERT INTO public.search VALUES ('ee863f3c-6e3d-4737-bf1c-fa378c782ff2', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('ee863f3c-6e3d-4737-bf1c-fa378c782ff2', 'metadata.uid', 'ee863f3c-6e3d-4737-bf1c-fa378c782ff2');
INSERT INTO public.search VALUES ('39f21457-07ab-4140-9a0a-9ab2a68f7e28', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('39f21457-07ab-4140-9a0a-9ab2a68f7e28', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('39f21457-07ab-4140-9a0a-9ab2a68f7e28', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('39f21457-07ab-4140-9a0a-9ab2a68f7e28', 'kind', 'location');
INSERT INTO public.search VALUES ('39f21457-07ab-4140-9a0a-9ab2a68f7e28', 'spec.type', 'url');
INSERT INTO public.search VALUES ('39f21457-07ab-4140-9a0a-9ab2a68f7e28', 'spec.target', 'https://github.com/cirodasilvaj/bs-tutelas-patentes-site/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('39f21457-07ab-4140-9a0a-9ab2a68f7e28', 'metadata.name', 'generated-6bcefc9bd5af69ed0137a6ce0836fe36e0fef7f2');
INSERT INTO public.search VALUES ('39f21457-07ab-4140-9a0a-9ab2a68f7e28', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('39f21457-07ab-4140-9a0a-9ab2a68f7e28', 'metadata.uid', '39f21457-07ab-4140-9a0a-9ab2a68f7e28');
INSERT INTO public.search VALUES ('328bd867-6b9c-4be1-a096-00f817eecbc1', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('328bd867-6b9c-4be1-a096-00f817eecbc1', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('328bd867-6b9c-4be1-a096-00f817eecbc1', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('328bd867-6b9c-4be1-a096-00f817eecbc1', 'kind', 'location');
INSERT INTO public.search VALUES ('328bd867-6b9c-4be1-a096-00f817eecbc1', 'spec.type', 'url');
INSERT INTO public.search VALUES ('328bd867-6b9c-4be1-a096-00f817eecbc1', 'spec.target', 'https://github.com/cirodasilvaj/zoeiroka-automacoes/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('328bd867-6b9c-4be1-a096-00f817eecbc1', 'metadata.name', 'generated-bcfe70fc389b7b6f55a5728ad12e48fbb12a7627');
INSERT INTO public.search VALUES ('328bd867-6b9c-4be1-a096-00f817eecbc1', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('328bd867-6b9c-4be1-a096-00f817eecbc1', 'metadata.uid', '328bd867-6b9c-4be1-a096-00f817eecbc1');
INSERT INTO public.search VALUES ('b9fc798e-c450-4cff-b55b-5176288fd3ea', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b9fc798e-c450-4cff-b55b-5176288fd3ea', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b9fc798e-c450-4cff-b55b-5176288fd3ea', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('b9fc798e-c450-4cff-b55b-5176288fd3ea', 'kind', 'location');
INSERT INTO public.search VALUES ('b9fc798e-c450-4cff-b55b-5176288fd3ea', 'spec.type', 'url');
INSERT INTO public.search VALUES ('b9fc798e-c450-4cff-b55b-5176288fd3ea', 'spec.target', 'https://github.com/cirodasilvaj/counter-service-exercise/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('b9fc798e-c450-4cff-b55b-5176288fd3ea', 'metadata.name', 'generated-d6c74b7d4667a209e2cd1841e6d838c0d7d20c98');
INSERT INTO public.search VALUES ('b9fc798e-c450-4cff-b55b-5176288fd3ea', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('b9fc798e-c450-4cff-b55b-5176288fd3ea', 'metadata.uid', 'b9fc798e-c450-4cff-b55b-5176288fd3ea');
INSERT INTO public.search VALUES ('57242473-b776-432c-bb75-f28c61301137', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('57242473-b776-432c-bb75-f28c61301137', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('57242473-b776-432c-bb75-f28c61301137', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('57242473-b776-432c-bb75-f28c61301137', 'kind', 'location');
INSERT INTO public.search VALUES ('57242473-b776-432c-bb75-f28c61301137', 'spec.type', 'url');
INSERT INTO public.search VALUES ('57242473-b776-432c-bb75-f28c61301137', 'spec.target', 'https://github.com/cirodasilvaj/backstage-infra/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('57242473-b776-432c-bb75-f28c61301137', 'metadata.name', 'generated-3a49cafceb0ae80411060ab243ac7adf4cb8101e');
INSERT INTO public.search VALUES ('57242473-b776-432c-bb75-f28c61301137', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('57242473-b776-432c-bb75-f28c61301137', 'metadata.uid', '57242473-b776-432c-bb75-f28c61301137');
INSERT INTO public.search VALUES ('fc8e7ab4-869c-4e8b-813a-1f4cf99340b4', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('fc8e7ab4-869c-4e8b-813a-1f4cf99340b4', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('fc8e7ab4-869c-4e8b-813a-1f4cf99340b4', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('fc8e7ab4-869c-4e8b-813a-1f4cf99340b4', 'kind', 'location');
INSERT INTO public.search VALUES ('fc8e7ab4-869c-4e8b-813a-1f4cf99340b4', 'spec.type', 'url');
INSERT INTO public.search VALUES ('fc8e7ab4-869c-4e8b-813a-1f4cf99340b4', 'spec.target', 'https://github.com/cirodasilvaj/floci-localstack-aws/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('fc8e7ab4-869c-4e8b-813a-1f4cf99340b4', 'metadata.name', 'generated-73a2399a7c2024519f325ee2a4e98268e82758b7');
INSERT INTO public.search VALUES ('fc8e7ab4-869c-4e8b-813a-1f4cf99340b4', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('fc8e7ab4-869c-4e8b-813a-1f4cf99340b4', 'metadata.uid', 'fc8e7ab4-869c-4e8b-813a-1f4cf99340b4');
INSERT INTO public.search VALUES ('6e55b9e8-2c65-4773-b863-2e77ce1ced96', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('6e55b9e8-2c65-4773-b863-2e77ce1ced96', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('6e55b9e8-2c65-4773-b863-2e77ce1ced96', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('6e55b9e8-2c65-4773-b863-2e77ce1ced96', 'kind', 'location');
INSERT INTO public.search VALUES ('6e55b9e8-2c65-4773-b863-2e77ce1ced96', 'spec.type', 'url');
INSERT INTO public.search VALUES ('6e55b9e8-2c65-4773-b863-2e77ce1ced96', 'spec.target', 'https://github.com/cirodasilvaj/hermes-backup-1-vid-agentes-repos/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('6e55b9e8-2c65-4773-b863-2e77ce1ced96', 'metadata.name', 'generated-9a24efc486a6e189695017ff7d1ff5886f9498aa');
INSERT INTO public.search VALUES ('6e55b9e8-2c65-4773-b863-2e77ce1ced96', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('6e55b9e8-2c65-4773-b863-2e77ce1ced96', 'metadata.uid', '6e55b9e8-2c65-4773-b863-2e77ce1ced96');
INSERT INTO public.search VALUES ('00d94013-0f3e-4bf6-b6fc-c3a793e7472f', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('00d94013-0f3e-4bf6-b6fc-c3a793e7472f', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('00d94013-0f3e-4bf6-b6fc-c3a793e7472f', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('00d94013-0f3e-4bf6-b6fc-c3a793e7472f', 'kind', 'location');
INSERT INTO public.search VALUES ('00d94013-0f3e-4bf6-b6fc-c3a793e7472f', 'spec.type', 'url');
INSERT INTO public.search VALUES ('00d94013-0f3e-4bf6-b6fc-c3a793e7472f', 'spec.target', 'https://github.com/cirodasilvaj/aws-certified-solutions-architect-associate-brasil/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('00d94013-0f3e-4bf6-b6fc-c3a793e7472f', 'metadata.name', 'generated-31a0877ed2bec2edf4feee46dd4161a60585d1ce');
INSERT INTO public.search VALUES ('00d94013-0f3e-4bf6-b6fc-c3a793e7472f', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('00d94013-0f3e-4bf6-b6fc-c3a793e7472f', 'metadata.uid', '00d94013-0f3e-4bf6-b6fc-c3a793e7472f');
INSERT INTO public.search VALUES ('cbacfd61-8a1a-4914-ba7e-2a8563bbad45', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('cbacfd61-8a1a-4914-ba7e-2a8563bbad45', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('cbacfd61-8a1a-4914-ba7e-2a8563bbad45', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('cbacfd61-8a1a-4914-ba7e-2a8563bbad45', 'kind', 'location');
INSERT INTO public.search VALUES ('cbacfd61-8a1a-4914-ba7e-2a8563bbad45', 'spec.type', 'url');
INSERT INTO public.search VALUES ('cbacfd61-8a1a-4914-ba7e-2a8563bbad45', 'spec.target', 'https://github.com/cirodasilvaj/mesa-agents/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('cbacfd61-8a1a-4914-ba7e-2a8563bbad45', 'metadata.name', 'generated-1f8726637b31d8323de2ea178b5ccd8c303f90fa');
INSERT INTO public.search VALUES ('cbacfd61-8a1a-4914-ba7e-2a8563bbad45', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('cbacfd61-8a1a-4914-ba7e-2a8563bbad45', 'metadata.uid', 'cbacfd61-8a1a-4914-ba7e-2a8563bbad45');
INSERT INTO public.search VALUES ('8ba49820-4112-4d3f-ac91-d708ed64c6f6', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('8ba49820-4112-4d3f-ac91-d708ed64c6f6', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('8ba49820-4112-4d3f-ac91-d708ed64c6f6', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('8ba49820-4112-4d3f-ac91-d708ed64c6f6', 'kind', 'location');
INSERT INTO public.search VALUES ('8ba49820-4112-4d3f-ac91-d708ed64c6f6', 'spec.type', 'url');
INSERT INTO public.search VALUES ('8ba49820-4112-4d3f-ac91-d708ed64c6f6', 'spec.target', 'https://github.com/cirobessa/kube-demo-2026/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('8ba49820-4112-4d3f-ac91-d708ed64c6f6', 'metadata.name', 'generated-d6eb614c9d4a9daaeb84a95d3fece1a6a0dd9916');
INSERT INTO public.search VALUES ('8ba49820-4112-4d3f-ac91-d708ed64c6f6', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('8ba49820-4112-4d3f-ac91-d708ed64c6f6', 'metadata.uid', '8ba49820-4112-4d3f-ac91-d708ed64c6f6');
INSERT INTO public.search VALUES ('8ffa28bf-4525-474c-a0ea-275e2329fcdf', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('8ffa28bf-4525-474c-a0ea-275e2329fcdf', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('8ffa28bf-4525-474c-a0ea-275e2329fcdf', 'kind', 'location');
INSERT INTO public.search VALUES ('8ffa28bf-4525-474c-a0ea-275e2329fcdf', 'spec.type', 'url');
INSERT INTO public.search VALUES ('8ffa28bf-4525-474c-a0ea-275e2329fcdf', 'spec.target', 'https://github.com/cirodasilvaj/scripts1/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('8ffa28bf-4525-474c-a0ea-275e2329fcdf', 'metadata.name', 'generated-39540a08be0bcb5645ee1d683b08d860953c5b44');
INSERT INTO public.search VALUES ('8ffa28bf-4525-474c-a0ea-275e2329fcdf', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('8ffa28bf-4525-474c-a0ea-275e2329fcdf', 'metadata.uid', '8ffa28bf-4525-474c-a0ea-275e2329fcdf');
INSERT INTO public.search VALUES ('f4d59911-2200-4c72-b99e-819df59d7610', 'metadata.annotations.backstage.io/managed-by-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('f4d59911-2200-4c72-b99e-819df59d7610', 'metadata.annotations.backstage.io/managed-by-origin-location', 'github-discovery:https://github.com/cirodasilvaj/*/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('f4d59911-2200-4c72-b99e-819df59d7610', 'apiversion', 'backstage.io/v1alpha1');
INSERT INTO public.search VALUES ('f4d59911-2200-4c72-b99e-819df59d7610', 'kind', 'location');
INSERT INTO public.search VALUES ('f4d59911-2200-4c72-b99e-819df59d7610', 'spec.type', 'url');
INSERT INTO public.search VALUES ('f4d59911-2200-4c72-b99e-819df59d7610', 'spec.target', 'https://github.com/cirodasilvaj/bot-dermatologia-mattos/blob/main/catalog-info.yaml');
INSERT INTO public.search VALUES ('f4d59911-2200-4c72-b99e-819df59d7610', 'metadata.name', 'generated-aea2074c195831a31fb8d1acdfcfd9ae7d08cd1b');
INSERT INTO public.search VALUES ('f4d59911-2200-4c72-b99e-819df59d7610', 'metadata.namespace', 'default');
INSERT INTO public.search VALUES ('f4d59911-2200-4c72-b99e-819df59d7610', 'metadata.uid', 'f4d59911-2200-4c72-b99e-819df59d7610');


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

SELECT pg_catalog.setval('public.refresh_state_references_id_seq', 8885, true);


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

\unrestrict Y9vGwNy4a8aj4Fl83vJwpinylC8hf1uzaNlyVEOFbl4fAl1seSPPIXGTpZHpdEA

