--
-- PostgreSQL database dump
--

\restrict QbbEZsSfDNDCZGIGeJBcrW6JiFPlZumDesyKTO51nqfcaIe3JsBmTX09zLt7HkA

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

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: final_entities; Type: TABLE; Schema: public; Owner: backstage
--

CREATE TABLE public.final_entities (
    entity_id uuid NOT NULL,
    hash character varying(255) NOT NULL,
    stitch_ticket uuid NOT NULL,
    final_entity text,
    entity_ref character varying(255) NOT NULL,
    last_updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.final_entities OWNER TO backstage;

--
-- Name: knex_migrations; Type: TABLE; Schema: public; Owner: backstage
--

CREATE TABLE public.knex_migrations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    batch integer NOT NULL,
    migration_time timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.knex_migrations OWNER TO backstage;

--
-- Name: knex_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: backstage
--

CREATE SEQUENCE public.knex_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.knex_migrations_id_seq OWNER TO backstage;

--
-- Name: knex_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: backstage
--

ALTER SEQUENCE public.knex_migrations_id_seq OWNED BY public.knex_migrations.id;


--
-- Name: knex_migrations_lock; Type: TABLE; Schema: public; Owner: backstage
--

CREATE TABLE public.knex_migrations_lock (
    index integer NOT NULL,
    is_locked integer DEFAULT 0
);


ALTER TABLE public.knex_migrations_lock OWNER TO backstage;

--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE; Schema: public; Owner: backstage
--

CREATE SEQUENCE public.knex_migrations_lock_index_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.knex_migrations_lock_index_seq OWNER TO backstage;

--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: backstage
--

ALTER SEQUENCE public.knex_migrations_lock_index_seq OWNED BY public.knex_migrations_lock.index;


--
-- Name: kubernetes_clusters; Type: TABLE; Schema: public; Owner: backstage
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


ALTER TABLE public.kubernetes_clusters OWNER TO backstage;

--
-- Name: locations; Type: TABLE; Schema: public; Owner: backstage
--

CREATE TABLE public.locations (
    id uuid NOT NULL,
    type character varying(255) NOT NULL,
    target text NOT NULL
);


ALTER TABLE public.locations OWNER TO backstage;

--
-- Name: refresh_state; Type: TABLE; Schema: public; Owner: backstage
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


ALTER TABLE public.refresh_state OWNER TO backstage;

--
-- Name: relations; Type: TABLE; Schema: public; Owner: backstage
--

CREATE TABLE public.relations (
    originating_entity_id uuid NOT NULL,
    source_entity_ref character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    target_entity_ref character varying(255) NOT NULL
);


ALTER TABLE public.relations OWNER TO backstage;

--
-- Name: search; Type: TABLE; Schema: public; Owner: backstage
--

CREATE TABLE public.search (
    original_entity_id uuid NOT NULL,
    key character varying(255) NOT NULL,
    value character varying(255),
    original_value character varying(255)
);


ALTER TABLE public.search OWNER TO backstage;

--
-- Name: signing_keys; Type: TABLE; Schema: public; Owner: backstage
--

CREATE TABLE public.signing_keys (
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    key text NOT NULL
);


ALTER TABLE public.signing_keys OWNER TO backstage;

--
-- Name: knex_migrations id; Type: DEFAULT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.knex_migrations ALTER COLUMN id SET DEFAULT nextval('public.knex_migrations_id_seq'::regclass);


--
-- Name: knex_migrations_lock index; Type: DEFAULT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.knex_migrations_lock ALTER COLUMN index SET DEFAULT nextval('public.knex_migrations_lock_index_seq'::regclass);


--
-- Data for Name: final_entities; Type: TABLE DATA; Schema: public; Owner: backstage
--

COPY public.final_entities (entity_id, hash, stitch_ticket, final_entity, entity_ref, last_updated_at) FROM stdin;
aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa	hash-kube-demo-eks-v2	aaaaaaaa-1111-1111-1111-aaaaaaaaaaaa	{"apiVersion":"backstage.io/v1alpha1","kind":"Resource","metadata":{"name":"kube-demo-eks","namespace":"default","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","annotations":{"backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system"}},"spec":{"type":"kubernetes-cluster","owner":"platform-team"}}	resource:default/kube-demo-eks	2026-11-01 21:30:51.352074+00
bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb	hash-backstage-portal-v2	bbbbbbbb-2222-2222-2222-bbbbbbbbbbbb	{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"backstage-portal","namespace":"default","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","annotations":{"backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage"}},"spec":{"type":"website","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}	component:default/backstage-portal	2026-11-01 21:30:51.352074+00
cccccccc-cccc-cccc-cccc-cccccccccccc	hash-python-demo-app-v2	cccccccc-3333-3333-3333-cccccccccccc	{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"python-demo-app","namespace":"default","description":"Python 3.12 Flask Demo App on EKS","annotations":{"sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/overview-dashboard":"d/apps-prometheus-loki/8c87aef"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}	component:default/python-demo-app	2026-11-01 21:30:51.352074+00
dddddddd-dddd-dddd-dddd-dddddddddddd	hash-dotnet-csharp-demo-app-v2	dddddddd-4444-4444-4444-dddddddddddd	{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"dotnet-csharp-demo-app","namespace":"default","description":"C# .NET 8 Minimal API Demo App on EKS","annotations":{"sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/overview-dashboard":"d/apps-prometheus-loki/8c87aef"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}	component:default/dotnet-csharp-demo-app	2026-11-01 21:30:51.352074+00
\.


--
-- Data for Name: knex_migrations; Type: TABLE DATA; Schema: public; Owner: backstage
--

COPY public.knex_migrations (id, name, batch, migration_time) FROM stdin;
\.


--
-- Data for Name: knex_migrations_lock; Type: TABLE DATA; Schema: public; Owner: backstage
--

COPY public.knex_migrations_lock (index, is_locked) FROM stdin;
\.


--
-- Data for Name: kubernetes_clusters; Type: TABLE DATA; Schema: public; Owner: backstage
--

COPY public.kubernetes_clusters (cluster_name, api_server_url, auth_provider, service_account_name, service_account_namespace, skip_tls_verify, skip_metrics_lookup, updated_at) FROM stdin;
kube-demo-eks	https://kubernetes.default.svc	serviceAccount	backstage	backstage	t	f	2026-11-01 21:30:51.352074+00
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: backstage
--

COPY public.locations (id, type, target) FROM stdin;
11111111-1111-1111-1111-111111111111	file	/etc/backstage/catalog-entities.yaml
22222222-2222-2222-2222-222222222222	url	https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml
\.


--
-- Data for Name: refresh_state; Type: TABLE DATA; Schema: public; Owner: backstage
--

COPY public.refresh_state (entity_id, entity_ref, unprocessed_entity, processed_entity, cache, errors, next_update_at, last_discovery_at, result_hash, unprocessed_hash) FROM stdin;
aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa	resource:default/kube-demo-eks	{"apiVersion":"backstage.io/v1alpha1","kind":"Resource","metadata":{"name":"kube-demo-eks","namespace":"default","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","annotations":{"backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system"}},"spec":{"type":"kubernetes-cluster","owner":"platform-team"}}	{"apiVersion":"backstage.io/v1alpha1","kind":"Resource","metadata":{"name":"kube-demo-eks","namespace":"default","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","annotations":{"backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system"}},"spec":{"type":"kubernetes-cluster","owner":"platform-team"}}	\N	[]	2026-11-01 21:14:03.304696+00	2026-11-01 21:30:51.352074+00	hash-kube-demo-eks-v2	hash-kube-demo-eks-v2
cccccccc-cccc-cccc-cccc-cccccccccccc	component:default/python-demo-app	{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"python-demo-app","namespace":"default","description":"Python 3.12 Flask Demo App on EKS","annotations":{"sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/overview-dashboard":"d/apps-prometheus-loki/8c87aef"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}	{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"python-demo-app","namespace":"default","description":"Python 3.12 Flask Demo App on EKS","annotations":{"sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/overview-dashboard":"d/apps-prometheus-loki/8c87aef"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}	\N	[]	2026-11-01 21:14:03.304696+00	2026-11-01 21:30:51.352074+00	hash-python-demo-app-v2	hash-python-demo-app-v2
bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb	component:default/backstage-portal	{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"backstage-portal","namespace":"default","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","annotations":{"backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage"}},"spec":{"type":"website","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}	{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"backstage-portal","namespace":"default","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","annotations":{"backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage"}},"spec":{"type":"website","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}	\N	[]	2026-11-01 21:14:03.304696+00	2026-11-01 21:30:51.352074+00	hash-backstage-portal-v2	hash-backstage-portal-v2
dddddddd-dddd-dddd-dddd-dddddddddddd	component:default/dotnet-csharp-demo-app	{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"dotnet-csharp-demo-app","namespace":"default","description":"C# .NET 8 Minimal API Demo App on EKS","annotations":{"sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/overview-dashboard":"d/apps-prometheus-loki/8c87aef"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}	{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"dotnet-csharp-demo-app","namespace":"default","description":"C# .NET 8 Minimal API Demo App on EKS","annotations":{"sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/overview-dashboard":"d/apps-prometheus-loki/8c87aef"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}	\N	[]	2026-11-01 21:14:03.304696+00	2026-11-01 21:30:51.352074+00	hash-dotnet-csharp-demo-app-v2	hash-dotnet-csharp-demo-app-v2
\.


--
-- Data for Name: relations; Type: TABLE DATA; Schema: public; Owner: backstage
--

COPY public.relations (originating_entity_id, source_entity_ref, type, target_entity_ref) FROM stdin;
\.


--
-- Data for Name: search; Type: TABLE DATA; Schema: public; Owner: backstage
--

COPY public.search (original_entity_id, key, value, original_value) FROM stdin;
\.


--
-- Data for Name: signing_keys; Type: TABLE DATA; Schema: public; Owner: backstage
--

COPY public.signing_keys (id, created_at, key) FROM stdin;
\.


--
-- Name: knex_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: backstage
--

SELECT pg_catalog.setval('public.knex_migrations_id_seq', 1, false);


--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE SET; Schema: public; Owner: backstage
--

SELECT pg_catalog.setval('public.knex_migrations_lock_index_seq', 1, false);


--
-- Name: final_entities final_entities_entity_ref_key; Type: CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.final_entities
    ADD CONSTRAINT final_entities_entity_ref_key UNIQUE (entity_ref);


--
-- Name: final_entities final_entities_pkey; Type: CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.final_entities
    ADD CONSTRAINT final_entities_pkey PRIMARY KEY (entity_id);


--
-- Name: knex_migrations_lock knex_migrations_lock_pkey; Type: CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.knex_migrations_lock
    ADD CONSTRAINT knex_migrations_lock_pkey PRIMARY KEY (index);


--
-- Name: knex_migrations knex_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.knex_migrations
    ADD CONSTRAINT knex_migrations_pkey PRIMARY KEY (id);


--
-- Name: kubernetes_clusters kubernetes_clusters_pkey; Type: CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.kubernetes_clusters
    ADD CONSTRAINT kubernetes_clusters_pkey PRIMARY KEY (cluster_name);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: refresh_state refresh_state_entity_ref_key; Type: CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.refresh_state
    ADD CONSTRAINT refresh_state_entity_ref_key UNIQUE (entity_ref);


--
-- Name: refresh_state refresh_state_pkey; Type: CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.refresh_state
    ADD CONSTRAINT refresh_state_pkey PRIMARY KEY (entity_id);


--
-- Name: signing_keys signing_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.signing_keys
    ADD CONSTRAINT signing_keys_pkey PRIMARY KEY (id);


--
-- Name: final_entities_entity_ref_idx; Type: INDEX; Schema: public; Owner: backstage
--

CREATE INDEX final_entities_entity_ref_idx ON public.final_entities USING btree (entity_ref);


--
-- Name: refresh_state_entity_ref_idx; Type: INDEX; Schema: public; Owner: backstage
--

CREATE INDEX refresh_state_entity_ref_idx ON public.refresh_state USING btree (entity_ref);


--
-- Name: refresh_state_next_update_at_idx; Type: INDEX; Schema: public; Owner: backstage
--

CREATE INDEX refresh_state_next_update_at_idx ON public.refresh_state USING btree (next_update_at);


--
-- Name: relations_source_entity_ref_idx; Type: INDEX; Schema: public; Owner: backstage
--

CREATE INDEX relations_source_entity_ref_idx ON public.relations USING btree (source_entity_ref);


--
-- Name: relations_target_entity_ref_idx; Type: INDEX; Schema: public; Owner: backstage
--

CREATE INDEX relations_target_entity_ref_idx ON public.relations USING btree (target_entity_ref);


--
-- Name: search_key_value_idx; Type: INDEX; Schema: public; Owner: backstage
--

CREATE INDEX search_key_value_idx ON public.search USING btree (key, value);


--
-- Name: final_entities final_entities_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.final_entities
    ADD CONSTRAINT final_entities_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.refresh_state(entity_id) ON DELETE CASCADE;


--
-- Name: relations relations_originating_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT relations_originating_entity_id_fkey FOREIGN KEY (originating_entity_id) REFERENCES public.refresh_state(entity_id) ON DELETE CASCADE;


--
-- Name: search search_original_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.search
    ADD CONSTRAINT search_original_entity_id_fkey FOREIGN KEY (original_entity_id) REFERENCES public.refresh_state(entity_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict QbbEZsSfDNDCZGIGeJBcrW6JiFPlZumDesyKTO51nqfcaIe3JsBmTX09zLt7HkA

--
-- PostgreSQL database dump
--

\restrict QbbEZsSfDNDCZGIGeJBcrW6JiFPlZumDesyKTO51nqfcaIe3JsBmTX09zLt7HkA

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

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: final_entities; Type: TABLE; Schema: public; Owner: backstage
--

CREATE TABLE public.final_entities (
    entity_id uuid NOT NULL,
    hash character varying(255) NOT NULL,
    stitch_ticket uuid NOT NULL,
    final_entity text,
    entity_ref character varying(255) NOT NULL,
    last_updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.final_entities OWNER TO backstage;

--
-- Name: knex_migrations; Type: TABLE; Schema: public; Owner: backstage
--

CREATE TABLE public.knex_migrations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    batch integer NOT NULL,
    migration_time timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.knex_migrations OWNER TO backstage;

--
-- Name: knex_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: backstage
--

CREATE SEQUENCE public.knex_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.knex_migrations_id_seq OWNER TO backstage;

--
-- Name: knex_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: backstage
--

ALTER SEQUENCE public.knex_migrations_id_seq OWNED BY public.knex_migrations.id;


--
-- Name: knex_migrations_lock; Type: TABLE; Schema: public; Owner: backstage
--

CREATE TABLE public.knex_migrations_lock (
    index integer NOT NULL,
    is_locked integer DEFAULT 0
);


ALTER TABLE public.knex_migrations_lock OWNER TO backstage;

--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE; Schema: public; Owner: backstage
--

CREATE SEQUENCE public.knex_migrations_lock_index_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.knex_migrations_lock_index_seq OWNER TO backstage;

--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: backstage
--

ALTER SEQUENCE public.knex_migrations_lock_index_seq OWNED BY public.knex_migrations_lock.index;


--
-- Name: kubernetes_clusters; Type: TABLE; Schema: public; Owner: backstage
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


ALTER TABLE public.kubernetes_clusters OWNER TO backstage;

--
-- Name: locations; Type: TABLE; Schema: public; Owner: backstage
--

CREATE TABLE public.locations (
    id uuid NOT NULL,
    type character varying(255) NOT NULL,
    target text NOT NULL
);


ALTER TABLE public.locations OWNER TO backstage;

--
-- Name: refresh_state; Type: TABLE; Schema: public; Owner: backstage
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


ALTER TABLE public.refresh_state OWNER TO backstage;

--
-- Name: relations; Type: TABLE; Schema: public; Owner: backstage
--

CREATE TABLE public.relations (
    originating_entity_id uuid NOT NULL,
    source_entity_ref character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    target_entity_ref character varying(255) NOT NULL
);


ALTER TABLE public.relations OWNER TO backstage;

--
-- Name: search; Type: TABLE; Schema: public; Owner: backstage
--

CREATE TABLE public.search (
    original_entity_id uuid NOT NULL,
    key character varying(255) NOT NULL,
    value character varying(255),
    original_value character varying(255)
);


ALTER TABLE public.search OWNER TO backstage;

--
-- Name: signing_keys; Type: TABLE; Schema: public; Owner: backstage
--

CREATE TABLE public.signing_keys (
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    key text NOT NULL
);


ALTER TABLE public.signing_keys OWNER TO backstage;

--
-- Name: knex_migrations id; Type: DEFAULT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.knex_migrations ALTER COLUMN id SET DEFAULT nextval('public.knex_migrations_id_seq'::regclass);


--
-- Name: knex_migrations_lock index; Type: DEFAULT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.knex_migrations_lock ALTER COLUMN index SET DEFAULT nextval('public.knex_migrations_lock_index_seq'::regclass);


--
-- Data for Name: final_entities; Type: TABLE DATA; Schema: public; Owner: backstage
--

COPY public.final_entities (entity_id, hash, stitch_ticket, final_entity, entity_ref, last_updated_at) FROM stdin;
aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa	hash-kube-demo-eks-v2	aaaaaaaa-1111-1111-1111-aaaaaaaaaaaa	{"apiVersion":"backstage.io/v1alpha1","kind":"Resource","metadata":{"name":"kube-demo-eks","namespace":"default","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","annotations":{"backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system"}},"spec":{"type":"kubernetes-cluster","owner":"platform-team"}}	resource:default/kube-demo-eks	2026-11-01 21:30:51.352074+00
bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb	hash-backstage-portal-v2	bbbbbbbb-2222-2222-2222-bbbbbbbbbbbb	{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"backstage-portal","namespace":"default","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","annotations":{"backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage"}},"spec":{"type":"website","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}	component:default/backstage-portal	2026-11-01 21:30:51.352074+00
cccccccc-cccc-cccc-cccc-cccccccccccc	hash-python-demo-app-v2	cccccccc-3333-3333-3333-cccccccccccc	{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"python-demo-app","namespace":"default","description":"Python 3.12 Flask Demo App on EKS","annotations":{"sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/overview-dashboard":"d/apps-prometheus-loki/8c87aef"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}	component:default/python-demo-app	2026-11-01 21:30:51.352074+00
dddddddd-dddd-dddd-dddd-dddddddddddd	hash-dotnet-csharp-demo-app-v2	dddddddd-4444-4444-4444-dddddddddddd	{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"dotnet-csharp-demo-app","namespace":"default","description":"C# .NET 8 Minimal API Demo App on EKS","annotations":{"sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/overview-dashboard":"d/apps-prometheus-loki/8c87aef"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}	component:default/dotnet-csharp-demo-app	2026-11-01 21:30:51.352074+00
\.


--
-- Data for Name: knex_migrations; Type: TABLE DATA; Schema: public; Owner: backstage
--

COPY public.knex_migrations (id, name, batch, migration_time) FROM stdin;
\.


--
-- Data for Name: knex_migrations_lock; Type: TABLE DATA; Schema: public; Owner: backstage
--

COPY public.knex_migrations_lock (index, is_locked) FROM stdin;
\.


--
-- Data for Name: kubernetes_clusters; Type: TABLE DATA; Schema: public; Owner: backstage
--

COPY public.kubernetes_clusters (cluster_name, api_server_url, auth_provider, service_account_name, service_account_namespace, skip_tls_verify, skip_metrics_lookup, updated_at) FROM stdin;
kube-demo-eks	https://kubernetes.default.svc	serviceAccount	backstage	backstage	t	f	2026-11-01 21:30:51.352074+00
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: backstage
--

COPY public.locations (id, type, target) FROM stdin;
11111111-1111-1111-1111-111111111111	file	/etc/backstage/catalog-entities.yaml
22222222-2222-2222-2222-222222222222	url	https://github.com/cirodasilvaj/apps-demo-2026/blob/main/catalog-info.yaml
\.


--
-- Data for Name: refresh_state; Type: TABLE DATA; Schema: public; Owner: backstage
--

COPY public.refresh_state (entity_id, entity_ref, unprocessed_entity, processed_entity, cache, errors, next_update_at, last_discovery_at, result_hash, unprocessed_hash) FROM stdin;
aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa	resource:default/kube-demo-eks	{"apiVersion":"backstage.io/v1alpha1","kind":"Resource","metadata":{"name":"kube-demo-eks","namespace":"default","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","annotations":{"backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system"}},"spec":{"type":"kubernetes-cluster","owner":"platform-team"}}	{"apiVersion":"backstage.io/v1alpha1","kind":"Resource","metadata":{"name":"kube-demo-eks","namespace":"default","description":"AWS EKS 1.35 Kubernetes Cluster connected via In-Cluster ServiceAccount RBAC","annotations":{"backstage.io/kubernetes-id":"kube-demo-eks","backstage.io/kubernetes-namespace":"kube-system"}},"spec":{"type":"kubernetes-cluster","owner":"platform-team"}}	\N	[]	2026-11-01 21:14:03.304696+00	2026-11-01 21:30:51.352074+00	hash-kube-demo-eks-v2	hash-kube-demo-eks-v2
cccccccc-cccc-cccc-cccc-cccccccccccc	component:default/python-demo-app	{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"python-demo-app","namespace":"default","description":"Python 3.12 Flask Demo App on EKS","annotations":{"sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/overview-dashboard":"d/apps-prometheus-loki/8c87aef"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}	{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"python-demo-app","namespace":"default","description":"Python 3.12 Flask Demo App on EKS","annotations":{"sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"python-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/overview-dashboard":"d/apps-prometheus-loki/8c87aef"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}	\N	[]	2026-11-01 21:14:03.304696+00	2026-11-01 21:30:51.352074+00	hash-python-demo-app-v2	hash-python-demo-app-v2
bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb	component:default/backstage-portal	{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"backstage-portal","namespace":"default","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","annotations":{"backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage"}},"spec":{"type":"website","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}	{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"backstage-portal","namespace":"default","description":"Backstage Internal Developer Portal backed by AWS RDS PostgreSQL and linked to EKS","annotations":{"backstage.io/kubernetes-id":"backstage","backstage.io/kubernetes-namespace":"backstage","backstage.io/kubernetes-label-selector":"app=backstage"}},"spec":{"type":"website","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}	\N	[]	2026-11-01 21:14:03.304696+00	2026-11-01 21:30:51.352074+00	hash-backstage-portal-v2	hash-backstage-portal-v2
dddddddd-dddd-dddd-dddd-dddddddddddd	component:default/dotnet-csharp-demo-app	{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"dotnet-csharp-demo-app","namespace":"default","description":"C# .NET 8 Minimal API Demo App on EKS","annotations":{"sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/overview-dashboard":"d/apps-prometheus-loki/8c87aef"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}	{"apiVersion":"backstage.io/v1alpha1","kind":"Component","metadata":{"name":"dotnet-csharp-demo-app","namespace":"default","description":"C# .NET 8 Minimal API Demo App on EKS","annotations":{"sonarqube.org/project-key":"apps-demo-2026","backstage.io/kubernetes-id":"dotnet-csharp-app","backstage.io/kubernetes-namespace":"apps-demo","prometheus.io/scrape":"true","prometheus.io/path":"/metrics","fluentd.io/destination":"loki","grafana/overview-dashboard":"d/apps-prometheus-loki/8c87aef"}},"spec":{"type":"service","lifecycle":"production","owner":"platform-team","dependsOn":["resource:default/kube-demo-eks"]}}	\N	[]	2026-11-01 21:14:03.304696+00	2026-11-01 21:30:51.352074+00	hash-dotnet-csharp-demo-app-v2	hash-dotnet-csharp-demo-app-v2
\.


--
-- Data for Name: relations; Type: TABLE DATA; Schema: public; Owner: backstage
--

COPY public.relations (originating_entity_id, source_entity_ref, type, target_entity_ref) FROM stdin;
\.


--
-- Data for Name: search; Type: TABLE DATA; Schema: public; Owner: backstage
--

COPY public.search (original_entity_id, key, value, original_value) FROM stdin;
\.


--
-- Data for Name: signing_keys; Type: TABLE DATA; Schema: public; Owner: backstage
--

COPY public.signing_keys (id, created_at, key) FROM stdin;
\.


--
-- Name: knex_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: backstage
--

SELECT pg_catalog.setval('public.knex_migrations_id_seq', 1, false);


--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE SET; Schema: public; Owner: backstage
--

SELECT pg_catalog.setval('public.knex_migrations_lock_index_seq', 1, false);


--
-- Name: final_entities final_entities_entity_ref_key; Type: CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.final_entities
    ADD CONSTRAINT final_entities_entity_ref_key UNIQUE (entity_ref);


--
-- Name: final_entities final_entities_pkey; Type: CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.final_entities
    ADD CONSTRAINT final_entities_pkey PRIMARY KEY (entity_id);


--
-- Name: knex_migrations_lock knex_migrations_lock_pkey; Type: CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.knex_migrations_lock
    ADD CONSTRAINT knex_migrations_lock_pkey PRIMARY KEY (index);


--
-- Name: knex_migrations knex_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.knex_migrations
    ADD CONSTRAINT knex_migrations_pkey PRIMARY KEY (id);


--
-- Name: kubernetes_clusters kubernetes_clusters_pkey; Type: CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.kubernetes_clusters
    ADD CONSTRAINT kubernetes_clusters_pkey PRIMARY KEY (cluster_name);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: refresh_state refresh_state_entity_ref_key; Type: CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.refresh_state
    ADD CONSTRAINT refresh_state_entity_ref_key UNIQUE (entity_ref);


--
-- Name: refresh_state refresh_state_pkey; Type: CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.refresh_state
    ADD CONSTRAINT refresh_state_pkey PRIMARY KEY (entity_id);


--
-- Name: signing_keys signing_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.signing_keys
    ADD CONSTRAINT signing_keys_pkey PRIMARY KEY (id);


--
-- Name: final_entities_entity_ref_idx; Type: INDEX; Schema: public; Owner: backstage
--

CREATE INDEX final_entities_entity_ref_idx ON public.final_entities USING btree (entity_ref);


--
-- Name: refresh_state_entity_ref_idx; Type: INDEX; Schema: public; Owner: backstage
--

CREATE INDEX refresh_state_entity_ref_idx ON public.refresh_state USING btree (entity_ref);


--
-- Name: refresh_state_next_update_at_idx; Type: INDEX; Schema: public; Owner: backstage
--

CREATE INDEX refresh_state_next_update_at_idx ON public.refresh_state USING btree (next_update_at);


--
-- Name: relations_source_entity_ref_idx; Type: INDEX; Schema: public; Owner: backstage
--

CREATE INDEX relations_source_entity_ref_idx ON public.relations USING btree (source_entity_ref);


--
-- Name: relations_target_entity_ref_idx; Type: INDEX; Schema: public; Owner: backstage
--

CREATE INDEX relations_target_entity_ref_idx ON public.relations USING btree (target_entity_ref);


--
-- Name: search_key_value_idx; Type: INDEX; Schema: public; Owner: backstage
--

CREATE INDEX search_key_value_idx ON public.search USING btree (key, value);


--
-- Name: final_entities final_entities_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.final_entities
    ADD CONSTRAINT final_entities_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.refresh_state(entity_id) ON DELETE CASCADE;


--
-- Name: relations relations_originating_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT relations_originating_entity_id_fkey FOREIGN KEY (originating_entity_id) REFERENCES public.refresh_state(entity_id) ON DELETE CASCADE;


--
-- Name: search search_original_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: backstage
--

ALTER TABLE ONLY public.search
    ADD CONSTRAINT search_original_entity_id_fkey FOREIGN KEY (original_entity_id) REFERENCES public.refresh_state(entity_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict QbbEZsSfDNDCZGIGeJBcrW6JiFPlZumDesyKTO51nqfcaIe3JsBmTX09zLt7HkA

pod "pgdump-export" deleted from default namespace
