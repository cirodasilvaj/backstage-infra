--
-- PostgreSQL database dump
--

\restrict UwDgzIPwfm0LMpg2LqojekCSRokwJKxY79uD8AyGAC1lAlvCUuRRHusBP8O2ZBZ

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

ALTER TABLE IF EXISTS ONLY public.search DROP CONSTRAINT IF EXISTS search_original_entity_id_fkey;
ALTER TABLE IF EXISTS ONLY public.relations DROP CONSTRAINT IF EXISTS relations_originating_entity_id_fkey;
ALTER TABLE IF EXISTS ONLY public.final_entities DROP CONSTRAINT IF EXISTS final_entities_entity_id_fkey;
DROP INDEX IF EXISTS public.search_key_value_idx;
DROP INDEX IF EXISTS public.relations_target_entity_ref_idx;
DROP INDEX IF EXISTS public.relations_source_entity_ref_idx;
DROP INDEX IF EXISTS public.refresh_state_next_update_at_idx;
DROP INDEX IF EXISTS public.refresh_state_entity_ref_idx;
DROP INDEX IF EXISTS public.final_entities_entity_ref_idx;
ALTER TABLE IF EXISTS ONLY public.signing_keys DROP CONSTRAINT IF EXISTS signing_keys_pkey;
ALTER TABLE IF EXISTS ONLY public.refresh_state DROP CONSTRAINT IF EXISTS refresh_state_pkey;
ALTER TABLE IF EXISTS ONLY public.refresh_state DROP CONSTRAINT IF EXISTS refresh_state_entity_ref_key;
ALTER TABLE IF EXISTS ONLY public.locations DROP CONSTRAINT IF EXISTS locations_pkey;
ALTER TABLE IF EXISTS ONLY public.kubernetes_clusters DROP CONSTRAINT IF EXISTS kubernetes_clusters_pkey;
ALTER TABLE IF EXISTS ONLY public.knex_migrations DROP CONSTRAINT IF EXISTS knex_migrations_pkey;
ALTER TABLE IF EXISTS ONLY public.knex_migrations_lock DROP CONSTRAINT IF EXISTS knex_migrations_lock_pkey;
ALTER TABLE IF EXISTS ONLY public.final_entities DROP CONSTRAINT IF EXISTS final_entities_pkey;
ALTER TABLE IF EXISTS ONLY public.final_entities DROP CONSTRAINT IF EXISTS final_entities_entity_ref_key;
ALTER TABLE IF EXISTS public.knex_migrations_lock ALTER COLUMN index DROP DEFAULT;
ALTER TABLE IF EXISTS public.knex_migrations ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS public.signing_keys;
DROP TABLE IF EXISTS public.search;
DROP TABLE IF EXISTS public.relations;
DROP TABLE IF EXISTS public.refresh_state;
DROP TABLE IF EXISTS public.locations;
DROP TABLE IF EXISTS public.kubernetes_clusters;
DROP SEQUENCE IF EXISTS public.knex_migrations_lock_index_seq;
DROP TABLE IF EXISTS public.knex_migrations_lock;
DROP SEQUENCE IF EXISTS public.knex_migrations_id_seq;
DROP TABLE IF EXISTS public.knex_migrations;
DROP TABLE IF EXISTS public.final_entities;
DROP EXTENSION IF EXISTS "uuid-ossp";
--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: final_entities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.final_entities (
    entity_id uuid NOT NULL,
    hash character varying(255) NOT NULL,
    stitch_ticket uuid NOT NULL,
    final_entity text,
    entity_ref character varying(255) NOT NULL,
    last_updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: knex_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.knex_migrations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    batch integer NOT NULL,
    migration_time timestamp with time zone DEFAULT now() NOT NULL
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
    is_locked integer DEFAULT 0
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
-- Name: kubernetes_clusters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kubernetes_clusters (
    cluster_name character varying(255) NOT NULL,
    api_server_url text NOT NULL,
    auth_provider character varying(100) DEFAULT 'serviceAccount'::character varying NOT NULL,
    service_account_name character varying(255) DEFAULT 'backstage'::character varying NOT NULL,
    service_account_namespace character varying(255) DEFAULT 'backstage'::character varying NOT NULL,
    skip_tls_verify boolean DEFAULT true NOT NULL,
    skip_metrics_lookup boolean DEFAULT false NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id uuid NOT NULL,
    type character varying(255) NOT NULL,
    target text NOT NULL
);


--
-- Name: refresh_state; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refresh_state (
    entity_id uuid NOT NULL,
    entity_ref character varying(255) NOT NULL,
    unprocessed_entity text NOT NULL,
    processed_entity text,
    cache text,
    errors text DEFAULT '[]'::text NOT NULL,
    next_update_at timestamp with time zone DEFAULT now() NOT NULL,
    last_discovery_at timestamp with time zone DEFAULT now() NOT NULL,
    result_hash character varying(255),
    unprocessed_hash character varying(255)
);


--
-- Name: relations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.relations (
    originating_entity_id uuid NOT NULL,
    source_entity_ref character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    target_entity_ref character varying(255) NOT NULL
);


--
-- Name: search; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.search (
    original_entity_id uuid NOT NULL,
    key character varying(255) NOT NULL,
    value character varying(255),
    original_value character varying(255)
);


--
-- Name: signing_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.signing_keys (
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    key text NOT NULL
);


--
-- Name: knex_migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knex_migrations ALTER COLUMN id SET DEFAULT nextval('public.knex_migrations_id_seq'::regclass);


--
-- Name: knex_migrations_lock index; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knex_migrations_lock ALTER COLUMN index SET DEFAULT nextval('public.knex_migrations_lock_index_seq'::regclass);


--
-- Data for Name: final_entities; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.final_entities VALUES ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'hash-kube-demo-eks-v2', 'aaaaaaaa-1111-1111-1111-aaaaaaaaaaaa', '{"apiVersion":"backstage.io/v1alpha1","kind":"Resource","metadata":{"name":"kube-demo-eks","namespace":"default","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","annotations":{"backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system"}},"spec":{"type":"kubernetes-cluster","owner":"platform-team"}}', 'resource:default/kube-demo-eks', '2026-11-01 12:33:18.606633+00');
INSERT INTO public.final_entities VALUES ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'hash-backstage-portal-v2', 'bbbbbbbb-2222-2222-2222-bbbbbbbbbbbb', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"backstage-portal","namespace":"default","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","annotations":{"backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage"}},"spec":{"type":"website","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}', 'component:default/backstage-portal', '2026-11-01 12:33:18.606633+00');
INSERT INTO public.final_entities VALUES ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'hash-python-demo-app-v2', 'cccccccc-3333-3333-3333-cccccccccccc', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"python-demo-app","namespace":"default","description":"Python 3.12 Flask Demo App on EKS","annotations":{"github.com/project-slug":"cirodasilvaj/apps-demo-2026","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/overview-dashboard":"d/apps-prometheus-loki/8c87aef"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}', 'component:default/python-demo-app', '2026-11-01 12:33:18.606633+00');
INSERT INTO public.final_entities VALUES ('dddddddd-dddd-dddd-dddd-dddddddddddd', 'hash-dotnet-csharp-demo-app-v2', 'dddddddd-4444-4444-4444-dddddddddddd', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"dotnet-csharp-demo-app","namespace":"default","description":"C# .NET 8 Minimal API Demo App on EKS","annotations":{"github.com/project-slug":"cirodasilvaj/apps-demo-2026","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/overview-dashboard":"d/apps-prometheus-loki/8c87aef"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}', 'component:default/dotnet-csharp-demo-app', '2026-11-01 12:33:18.606633+00');


--
-- Data for Name: knex_migrations; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: knex_migrations_lock; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: kubernetes_clusters; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.kubernetes_clusters VALUES ('kube-demo-eks', 'https://kubernetes.default.svc', 'serviceAccount', 'backstage', 'backstage', true, false, '2026-11-01 12:33:18.606633+00');


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.locations VALUES ('11111111-1111-1111-1111-111111111111', 'file', '/etc/backstage/catalog-entities.yaml');
INSERT INTO public.locations VALUES ('22222222-2222-2222-2222-222222222222', 'url', 'https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml');


--
-- Data for Name: refresh_state; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.refresh_state VALUES ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'resource:default/kube-demo-eks', '{"apiVersion":"backstage.io/v1alpha1","kind":"Resource","metadata":{"name":"kube-demo-eks","namespace":"default","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","annotations":{"backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system"}},"spec":{"type":"kubernetes-cluster","owner":"platform-team"}}', '{"apiVersion":"backstage.io/v1alpha1","kind":"Resource","metadata":{"name":"kube-demo-eks","namespace":"default","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","annotations":{"backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system"}},"spec":{"type":"kubernetes-cluster","owner":"platform-team"}}', NULL, '[]', '2026-11-01 12:02:42.992983+00', '2026-11-01 12:33:18.606633+00', 'hash-kube-demo-eks-v2', 'hash-kube-demo-eks-v2');
INSERT INTO public.refresh_state VALUES ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'component:default/backstage-portal', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"backstage-portal","namespace":"default","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","annotations":{"backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage"}},"spec":{"type":"website","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"backstage-portal","namespace":"default","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","annotations":{"backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage"}},"spec":{"type":"website","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}', NULL, '[]', '2026-11-01 12:02:42.992983+00', '2026-11-01 12:33:18.606633+00', 'hash-backstage-portal-v2', 'hash-backstage-portal-v2');
INSERT INTO public.refresh_state VALUES ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'component:default/python-demo-app', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"python-demo-app","namespace":"default","description":"Python 3.12 Flask Demo App on EKS","annotations":{"github.com/project-slug":"cirodasilvaj/apps-demo-2026","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/overview-dashboard":"d/apps-prometheus-loki/8c87aef"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"python-demo-app","namespace":"default","description":"Python 3.12 Flask Demo App on EKS","annotations":{"github.com/project-slug":"cirodasilvaj/apps-demo-2026","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/overview-dashboard":"d/apps-prometheus-loki/8c87aef"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}', NULL, '[]', '2026-11-01 12:02:42.992983+00', '2026-11-01 12:33:18.606633+00', 'hash-python-demo-app-v2', 'hash-python-demo-app-v2');
INSERT INTO public.refresh_state VALUES ('dddddddd-dddd-dddd-dddd-dddddddddddd', 'component:default/dotnet-csharp-demo-app', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"dotnet-csharp-demo-app","namespace":"default","description":"C# .NET 8 Minimal API Demo App on EKS","annotations":{"github.com/project-slug":"cirodasilvaj/apps-demo-2026","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/overview-dashboard":"d/apps-prometheus-loki/8c87aef"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}', '{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"dotnet-csharp-demo-app","namespace":"default","description":"C# .NET 8 Minimal API Demo App on EKS","annotations":{"github.com/project-slug":"cirodasilvaj/apps-demo-2026","sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/overview-dashboard":"d/apps-prometheus-loki/8c87aef"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}', NULL, '[]', '2026-11-01 12:02:42.992983+00', '2026-11-01 12:33:18.606633+00', 'hash-dotnet-csharp-demo-app-v2', 'hash-dotnet-csharp-demo-app-v2');


--
-- Data for Name: relations; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: search; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: signing_keys; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: knex_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.knex_migrations_id_seq', 1, false);


--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.knex_migrations_lock_index_seq', 1, false);


--
-- Name: final_entities final_entities_entity_ref_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.final_entities
    ADD CONSTRAINT final_entities_entity_ref_key UNIQUE (entity_ref);


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
-- Name: kubernetes_clusters kubernetes_clusters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kubernetes_clusters
    ADD CONSTRAINT kubernetes_clusters_pkey PRIMARY KEY (cluster_name);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: refresh_state refresh_state_entity_ref_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_state
    ADD CONSTRAINT refresh_state_entity_ref_key UNIQUE (entity_ref);


--
-- Name: refresh_state refresh_state_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_state
    ADD CONSTRAINT refresh_state_pkey PRIMARY KEY (entity_id);


--
-- Name: signing_keys signing_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signing_keys
    ADD CONSTRAINT signing_keys_pkey PRIMARY KEY (id);


--
-- Name: final_entities_entity_ref_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX final_entities_entity_ref_idx ON public.final_entities USING btree (entity_ref);


--
-- Name: refresh_state_entity_ref_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX refresh_state_entity_ref_idx ON public.refresh_state USING btree (entity_ref);


--
-- Name: refresh_state_next_update_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX refresh_state_next_update_at_idx ON public.refresh_state USING btree (next_update_at);


--
-- Name: relations_source_entity_ref_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX relations_source_entity_ref_idx ON public.relations USING btree (source_entity_ref);


--
-- Name: relations_target_entity_ref_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX relations_target_entity_ref_idx ON public.relations USING btree (target_entity_ref);


--
-- Name: search_key_value_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX search_key_value_idx ON public.search USING btree (key, value);


--
-- Name: final_entities final_entities_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.final_entities
    ADD CONSTRAINT final_entities_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.refresh_state(entity_id) ON DELETE CASCADE;


--
-- Name: relations relations_originating_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT relations_originating_entity_id_fkey FOREIGN KEY (originating_entity_id) REFERENCES public.refresh_state(entity_id) ON DELETE CASCADE;


--
-- Name: search search_original_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.search
    ADD CONSTRAINT search_original_entity_id_fkey FOREIGN KEY (original_entity_id) REFERENCES public.refresh_state(entity_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict UwDgzIPwfm0LMpg2LqojekCSRokwJKxY79uD8AyGAC1lAlvCUuRRHusBP8O2ZBZ

